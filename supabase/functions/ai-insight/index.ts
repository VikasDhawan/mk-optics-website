// =====================================================================
// MK Optics — ai-insight Edge Function
// =====================================================================
// Runs the pre-written, sales-focused prompt against a customer's own
// visit history and returns a short, actionable insight in plain
// language — so staff never have to write a prompt themselves.
//
// Why this lives server-side rather than calling Anthropic from the
// browser: the shop's API key must never be visible in a browser tab
// (anyone could open dev tools and steal it). This function reads the
// key with the service-role connection (bypassing RLS, same as any
// other trusted server process) and makes the call itself; the
// browser only ever sees the final text answer, never the key.
//
// Deploy with the Supabase CLI from the repo root:
//   supabase functions deploy ai-insight --project-ref <your-project-ref>
//
// Requires no extra secrets to be set — the key comes from the
// ai_settings table (see ai-settings.html), not from Edge Function
// environment variables, so each shop's own key lives in their own
// database, not in deployed code.
// =====================================================================

import { createClient } from 'https://esm.sh/@supabase/supabase-js@2';

const CLAUDE_MODEL = 'claude-3-5-haiku-latest'; // fast + inexpensive — plenty for this use case
const CLAUDE_API_VERSION = '2023-06-01';

// The pre-engineered prompt. Non-technical shop owners never see or
// write this — it's baked into the app so "Ask AI" just works.
const SYSTEM_PROMPT = `You are a retail analytics consultant for a small, independent optical
retail store in India (eyeglasses, sunglasses, contact lenses, eye tests).
You will be given one customer's full visit history as JSON — dates,
prescriptions, frames, lenses, amounts spent, and free-text staff notes.

Your job: find the ONE most useful, non-obvious insight in this data that
connects directly to increasing revenue or reducing cost for the shop.
Prioritize things a busy shop owner would NOT notice just by skimming the
list — patterns across multiple visits, contradictions between what a
customer says and what they buy, trends in spend or prescription, gaps in
what they've never purchased, timing patterns, or signals of a customer
about to leave.

Respond in this exact structure, plain text, no markdown, no headers:
1. One short headline sentence with a rupee estimate if at all possible.
2. One paragraph (2-3 sentences max) explaining the insight in plain
   language a non-technical shop owner would immediately understand.
3. One concrete, specific action starting with "Action:" that staff could
   take on this customer's very next visit or contact.

Keep the whole response under 100 words. Be direct and confident, not
hedgy. If the data genuinely doesn't support a strong insight, say so
plainly rather than inventing one.`;

Deno.serve(async (req) => {
  const cors = {
    'Access-Control-Allow-Origin': '*',
    'Access-Control-Allow-Headers': 'authorization, x-client-info, apikey, content-type',
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
      .select('api_key')
      .eq('id', true)
      .maybeSingle();

    if (settingsError || !settings?.api_key) {
      return json({ error: 'No AI key configured yet — add one on the AI Setup page.' }, cors);
    }
    const apiKey = settings.api_key;

    // A cheap, tiny call just to confirm the key actually works, used by
    // the "Test Connection" button on ai-settings.html.
    if (test) {
      const testRes = await callClaude(apiKey, 'Reply with the single word: OK', 10);
      if (!testRes.ok) return json({ error: testRes.error }, cors);
      return json({ ok: true }, cors);
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

    const result = await callClaude(
      apiKey,
      `Here is the visit history JSON:\n\n${JSON.stringify(payload, null, 2)}`,
      300,
      SYSTEM_PROMPT
    );

    if (!result.ok) return json({ error: result.error }, cors);
    return json({ insight: result.text }, cors);
  } catch (err) {
    return json({ error: String(err) }, { 'Access-Control-Allow-Origin': '*' });
  }
});

async function callClaude(apiKey: string, userMessage: string, maxTokens: number, systemPrompt?: string) {
  try {
    const res = await fetch('https://api.anthropic.com/v1/messages', {
      method: 'POST',
      headers: {
        'content-type': 'application/json',
        'x-api-key': apiKey,
        'anthropic-version': CLAUDE_API_VERSION,
      },
      body: JSON.stringify({
        model: CLAUDE_MODEL,
        max_tokens: maxTokens,
        ...(systemPrompt ? { system: systemPrompt } : {}),
        messages: [{ role: 'user', content: userMessage }],
      }),
    });
    const data = await res.json();
    if (!res.ok) {
      return { ok: false, error: data?.error?.message || `Anthropic API error (${res.status})` };
    }
    const text = data?.content?.[0]?.text?.trim();
    return { ok: true, text };
  } catch (err) {
    return { ok: false, error: String(err) };
  }
}

function json(body: unknown, extraHeaders: Record<string, string>) {
  return new Response(JSON.stringify(body), {
    headers: { 'content-type': 'application/json', ...extraHeaders },
  });
}
