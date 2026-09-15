// =====================================================================
// MK Optics — ai-insight Edge Function
// =====================================================================
// Runs the pre-written, sales-focused prompt against a customer's own
// visit history and returns a short, actionable insight in plain
// language — so staff never have to write a prompt themselves.
//
// Provider strategy (all free-tier, in order):
//   1. Google Gemini (gemini-2.5-flash) — primary, generous free quota.
//   2. Groq (llama-3.3-70b-versatile) — automatic fallback, only tried
//      if Gemini reports its free daily quota is exhausted (HTTP 429).
//   3. If BOTH are exhausted or neither is configured: return a plain
//      message suggesting a paid ChatGPT Plus/Pro account as a manual
//      option. This is a suggestion only, never an automatic call —
//      ChatGPT's consumer subscription isn't a programmatic API key,
//      so there's nothing here to call automatically even if a shop
//      has one.
//
// Why this lives server-side rather than calling providers from the
// browser: API keys must never be visible in a browser tab (anyone
// could open dev tools and steal them). This function reads keys with
// the service-role connection (bypassing RLS, same as any other
// trusted server process) and makes the calls itself; the browser
// only ever sees the final text answer, never a key.
//
// Deploy with the Supabase CLI from the repo root:
//   supabase functions deploy ai-insight --project-ref <your-project-ref>
//
// Requires no Edge Function secrets — keys come from the ai_settings
// table (see ai-settings.html), so each shop's own keys live in their
// own database, not in deployed code.
// =====================================================================

import { createClient } from 'https://esm.sh/@supabase/supabase-js@2';

const GEMINI_MODEL = 'gemini-2.5-flash';
const GROQ_MODEL = 'llama-3.3-70b-versatile';

// The pre-engineered prompt. Non-technical shop owners never see or
// write this — it's baked into the app so "Ask AI" just works.
const SYSTEM_PROMPT = `You are a retail analytics consultant for a small, independent optical
retail store in India (eyeglasses, sunglasses, contact lenses, eye tests).
You will be given one customer's full visit history as JSON — dates,
prescriptions, frames, lenses, amounts spent, and free-text staff notes.

Your job: look at this customer's history and tell staff specifically
WHAT to offer them next and in WHAT BUDGET RANGE, to help the shop sell
more — never a purely clinical or descriptive observation with no rupee
angle, and never framed as a warning, risk, or concern about the
customer. A customer spending more or buying often is a GOOD sign to
build on, not a problem to flag. Do not use words like "excessive,"
"risk," "concerning," "return," or anything implying the customer is
overspending or behaving unusually in a bad way — that is never the
message, even if true. The message is always: here is the specific
opportunity, here is the product/category and price range that fits
this customer, and here is what to do about it.
Prioritize things a busy shop owner would NOT notice just by skimming the
list — patterns across multiple visits, what they keep coming back for,
gaps in what they've never purchased, timing patterns, or a trend that
points to a specific upsell or cross-sell opportunity.

You MUST respond with exactly three lines, and each line MUST start with
one of these three literal labels, spelled exactly this way, followed by
a colon and a space — do not paraphrase, translate, omit, or reformat
the labels themselves:

HEADLINE: one sentence stating the insight with a specific rupee number
or estimate — never a number-free generality.
WHY IT MATTERS: 2-3 full sentences explaining, in plain language a
non-technical shop owner would immediately understand, why this
connects to revenue or cost, and what would happen if ignored.
ACTION: one sentence naming the SPECIFIC product/category and a rupee
BUDGET RANGE to offer this customer next, and when to offer it.

A response missing any of the three literal labels "HEADLINE:", "WHY IT
MATTERS:", or "ACTION:" is a FAILED response. A one-sentence answer is
also a FAILED response. Do not do either under any circumstances.

Example of the required shape and tone (do not reuse this content, it is
only to show the format, detail level, and positive framing expected):
"HEADLINE: Spend per visit has grown 180% over three visits while the
prescription barely changed.
WHY IT MATTERS: This shows the customer chooses premium features and
brand over price. That's a strong opening for the shop's top-tier line
rather than mid-range stock, and asking early avoids losing that
upgrade sale to a competitor with better options on display.
ACTION: On their next visit, lead with the ₹8,000-12,000 premium frame
and photochromic lens range before showing anything mid-range."

Target 70-100 words total across all three parts combined — never fewer
than 50. If the data genuinely doesn't support a strong insight, still
follow the exact three-part structure and say so plainly within it,
rather than collapsing into a single sentence.`;

Deno.serve(async (req) => {
  const cors = {
    'Access-Control-Allow-Origin': '*',
    'Access-Control-Allow-Headers': 'authorization, x-client-info, apikey, content-type',
    'Access-Control-Allow-Methods': 'POST, OPTIONS',
  };
  if (req.method === 'OPTIONS') return new Response('ok', { headers: cors });

  try {
    const { customerId, test } = await req.json();

    const supabaseAdmin = createClient(
      Deno.env.get('SUPABASE_URL') ?? '',
      Deno.env.get('SUPABASE_SERVICE_ROLE_KEY') ?? ''
    );

    const { data: appSettings } = await supabaseAdmin
      .from('app_settings')
      .select('ai_enabled')
      .eq('id', true)
      .maybeSingle();

    if (appSettings && appSettings.ai_enabled === false) {
      return json({ error: 'The AI Insights feature has been turned off by your store admin.' }, cors);
    }

    const { data: settings, error: settingsError } = await supabaseAdmin
      .from('ai_settings')
      .select('gemini_api_key, groq_api_key')
      .eq('id', true)
      .maybeSingle();

    if (settingsError) return json({ error: settingsError.message }, cors);
    const geminiKey = settings?.gemini_api_key || null;
    const groqKey = settings?.groq_api_key || null;

    if (!geminiKey && !groqKey) {
      return json({ error: 'No AI key configured yet — add one on the AI Setup page.' }, cors);
    }

    if (test) {
      const result = await callWithFallback(geminiKey, groqKey, 'Reply with the single word: OK', 10);
      if (!result.ok) return json({ error: result.error }, cors);
      return json({ ok: true, provider: result.provider }, cors);
    }

    if (!customerId) return json({ error: 'Missing customerId.' }, cors);

    const [{ data: customer }, { data: visits }] = await Promise.all([
      supabaseAdmin.from('customers').select('*').eq('id', customerId).single(),
      supabaseAdmin.from('visits').select('*').eq('customer_id', customerId).order('created_at', { ascending: true }),
    ]);

    if (!customer) return json({ error: 'Customer not found.' }, cors);
    if (!visits || visits.length < 2) {
      return json({ error: 'Not enough visit history yet — needs at least 2 visits.' }, cors);
    }

    const payload = {
      customer_name: customer.name,
      high_value_flag: !!customer.high_value,
      visits: visits.map((v) => ({
        date: v.visit_date,
        prescription: {
          od: [v.od_sphere, v.od_cylinder, v.od_axis].filter(Boolean).join(' '),
          os: [v.os_sphere, v.os_cylinder, v.os_axis].filter(Boolean).join(' '),
          add_od: v.add_od_sphere,
          add_os: v.add_os_sphere,
        },
        product_type: v.product_type,
        frame: v.frame,
        lens: v.lens,
        amount: v.amount,
        staff_notes: [v.preferences_budget, v.pitch_next_time, v.remarks].filter(Boolean).join(' | '),
      })),
    };

    const result = await callWithFallback(
      geminiKey,
      groqKey,
      `Here is the visit history JSON:\n\n${JSON.stringify(payload, null, 2)}`,
      900, // covers the 250-token thinking budget plus a full ~100-word, 3-part answer
      SYSTEM_PROMPT
    );

    if (!result.ok) return json({ error: result.error }, cors);
    return json({ insight: result.text, provider: result.provider }, cors);
  } catch (err) {
    return json({ error: String(err) }, { 'Access-Control-Allow-Origin': '*' });
  }
});

// Tries Gemini first (if configured), falls back to Groq only when
// Gemini reports its free quota is exhausted (or Gemini isn't
// configured at all). If both are unavailable, suggests a paid
// ChatGPT Plus/Pro account as a manual next step rather than failing
// silently — that's a human decision, not something this function can
// act on automatically.
async function callWithFallback(
  geminiKey: string | null,
  groqKey: string | null,
  userMessage: string,
  maxTokens: number,
  systemPrompt?: string
) {
  let geminiExhausted = false;
  let groqExhausted = false;

  if (geminiKey) {
    const result = await callGemini(geminiKey, userMessage, maxTokens, systemPrompt);
    if (result.ok) return { ...result, provider: 'gemini' };
    if (!result.quotaExhausted) return result; // a real error, not a quota issue — surface it as-is
    geminiExhausted = true;
  }

  if (groqKey) {
    const result = await callGroq(groqKey, userMessage, maxTokens, systemPrompt);
    if (result.ok) return { ...result, provider: 'groq' };
    if (!result.quotaExhausted) return result;
    groqExhausted = true;
  }

  // Everything configured was tried and every one hit its free daily
  // limit (or nothing is configured at all) — say exactly what
  // happened rather than a generic "both" message that may not be true.
  if (geminiExhausted && groqExhausted) {
    return { ok: false, error: quotaMessage("Both Gemini and Groq's free tiers have") };
  }
  if (geminiExhausted) {
    return { ok: false, error: quotaMessage("Gemini's free tier has") + ' Add a Groq key too for an automatic backup next time.' };
  }
  if (groqExhausted) {
    return { ok: false, error: quotaMessage("Groq's free tier has") };
  }
  return { ok: false, error: 'Add a Gemini or Groq API key on the AI Setup page to use this feature.' };
}

function quotaMessage(who: string) {
  return `${who} hit today's usage limit. It resets daily, so try again tomorrow — or, for unlimited access right away, consider a paid ChatGPT Plus/Pro account and paste the customer's details in there manually.`;
}

async function callGemini(apiKey: string, userMessage: string, maxTokens: number, systemPrompt?: string) {
  try {
    const res = await fetch(
      `https://generativelanguage.googleapis.com/v1beta/models/${GEMINI_MODEL}:generateContent?key=${apiKey}`,
      {
        method: 'POST',
        headers: { 'content-type': 'application/json' },
        body: JSON.stringify({
          ...(systemPrompt ? { systemInstruction: { parts: [{ text: systemPrompt }] } } : {}),
          contents: [{ parts: [{ text: userMessage }] }],
          // Root cause of every earlier "truncation" was actually the old
          // response-parsing code only reading parts[0] — Gemini puts its
          // thinking summary in an earlier part and the real answer in a
          // later one, so enabling thinking was silently losing the real
          // answer, not the model running out of room. Now that every
          // non-thought part is read (see below), thinking can safely be
          // turned back on — and it needs to be: with thinking fully off,
          // the model paraphrases the input instead of reasoning through
          // the required 3-part structure at all.
          generationConfig: { maxOutputTokens: maxTokens, thinkingConfig: { thinkingBudget: 400 } },
        }),
      }
    );
    const data = await res.json();
    if (!res.ok) {
      const status = data?.error?.status;
      const quotaExhausted = res.status === 429 || status === 'RESOURCE_EXHAUSTED';
      return { ok: false, quotaExhausted, error: data?.error?.message || `Gemini API error (${res.status})` };
    }
    // THE ACTUAL BUG behind every "truncated" response so far: Gemini can
    // split its answer across multiple parts (and may include a separate
    // "thought" part even at a low thinking budget), but this only ever
    // read parts[0] — silently dropping the rest of the answer regardless
    // of maxOutputTokens or thinkingConfig. Neither of those settings was
    // ever the real problem. Concatenate every non-thought part instead.
    const parts = data?.candidates?.[0]?.content?.parts || [];
    const text = parts.filter((p: any) => !p.thought).map((p: any) => p.text || '').join('').trim();
    const finishReason = data?.candidates?.[0]?.finishReason;
    // Temporary diagnostics, surfaced all the way to the UI, so we can
    // see exactly what Gemini actually did instead of guessing again —
    // part count/lengths and token usage explain a short answer far
    // better than staring at the visible text alone.
    const debug = {
      finishReason,
      partCount: parts.length,
      partLengths: parts.map((p: any) => ({ thought: !!p.thought, len: (p.text || '').length })),
      usage: data?.usageMetadata,
    };
    if (!text) {
      return { ok: false, quotaExhausted: false, error: `Gemini returned an empty response (finishReason: ${finishReason || 'unknown'}).`, debug };
    }
    return { ok: true, text, debug };
  } catch (err) {
    return { ok: false, quotaExhausted: false, error: String(err) };
  }
}

async function callGroq(apiKey: string, userMessage: string, maxTokens: number, systemPrompt?: string) {
  try {
    const messages = [];
    if (systemPrompt) messages.push({ role: 'system', content: systemPrompt });
    messages.push({ role: 'user', content: userMessage });

    const res = await fetch('https://api.groq.com/openai/v1/chat/completions', {
      method: 'POST',
      headers: { 'content-type': 'application/json', authorization: `Bearer ${apiKey}` },
      body: JSON.stringify({ model: GROQ_MODEL, messages, max_tokens: maxTokens }),
    });
    const data = await res.json();
    if (!res.ok) {
      const quotaExhausted = res.status === 429;
      return { ok: false, quotaExhausted, error: data?.error?.message || `Groq API error (${res.status})` };
    }
    const text = data?.choices?.[0]?.message?.content?.trim();
    if (!text) return { ok: false, quotaExhausted: false, error: 'Groq returned an empty response.' };
    return { ok: true, text };
  } catch (err) {
    return { ok: false, quotaExhausted: false, error: String(err) };
  }
}

function json(body: unknown, extraHeaders: Record<string, string>) {
  return new Response(JSON.stringify(body), {
    headers: { 'content-type': 'application/json', ...extraHeaders },
  });
}
