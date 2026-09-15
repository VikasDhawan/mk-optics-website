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

Your job: find the ONE most useful, non-obvious insight in this data that
connects directly to increasing revenue or reducing cost for the shop —
never a purely clinical or descriptive observation with no rupee angle.
Prioritize things a busy shop owner would NOT notice just by skimming the
list — patterns across multiple visits, contradictions between what a
customer says and what they buy, trends in spend or prescription, gaps in
what they've never purchased, timing patterns, or signals of a customer
about to leave.

You MUST respond with all three of these parts, each on its own line, in
plain text, no markdown, no headers. A one-sentence answer is a FAILED
response — do not do that under any circumstances.

1. HEADLINE: one sentence stating the insight with a specific rupee
   number or estimate — never a number-free generality.
2. WHY IT MATTERS: 2-3 full sentences explaining, in plain language a
   non-technical shop owner would immediately understand, why this
   connects to revenue or cost, and what would happen if ignored.
3. ACTION: one sentence starting with the word "Action:" giving one
   concrete, specific thing staff should do on this customer's very next
   visit or contact.

Example of the required shape (do not reuse this content, it is only to
show the format and level of detail expected):
"Spend per visit has grown 180% over three visits while the prescription
barely changed. This customer is paying for premium features and brand,
not a stronger correction — treating them like a price-sensitive walk-in
risks losing that upgrade revenue to a competitor who pitches better.
Action: show the top-tier frame and lens options first on their next
visit, before anything mid-range."

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
          // gemini-2.5-flash spends part of maxOutputTokens on internal
          // "thinking" before writing the visible answer. A thinkingBudget
          // is only a guideline, not a hard cap — tried 250 and it still
          // used far more, crowding out (and this time cutting off mid-
          // headline) the actual answer. Thinking off (0) is the only way
          // to reliably guarantee the full token budget goes to visible
          // text; structure and depth are now enforced entirely by the
          // prompt itself (explicit 3-part requirement + worked example)
          // rather than relying on the model "reasoning" its way there.
          generationConfig: { maxOutputTokens: maxTokens, thinkingConfig: { thinkingBudget: 0 } },
        }),
      }
    );
    const data = await res.json();
    if (!res.ok) {
      const status = data?.error?.status;
      const quotaExhausted = res.status === 429 || status === 'RESOURCE_EXHAUSTED';
      return { ok: false, quotaExhausted, error: data?.error?.message || `Gemini API error (${res.status})` };
    }
    const text = data?.candidates?.[0]?.content?.parts?.[0]?.text?.trim();
    if (!text) return { ok: false, quotaExhausted: false, error: 'Gemini returned an empty response.' };
    return { ok: true, text };
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
