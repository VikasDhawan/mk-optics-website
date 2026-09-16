// =====================================================================
// MK Optics — customer-portal-admin Edge Function
// =====================================================================
// Sets up (or resets) a customer's login for customer-portal.html.
// Customer portal login has no self-registration and no SMS/OTP cost —
// staff set a PIN for a customer in person (Customers page, "Portal
// Access"), the same trust model this app already uses for staff
// logins (an admin sets a staff member's password directly). This
// function is what actually creates/updates the Supabase Auth user and
// the service-role power that takes — it never happens from the
// browser with the plain anon key, same reasoning as staff-admin.
//
// A customer's login "email" is never a real email — it's their phone
// digits mapped to an internal address (e.g. "9876543210@customer.
// mkoptics.local"), exactly parallel to how staff can log in with a
// mobile number (see toLoginEmail in auth-gate.js), just a different
// suffix so the two account types can never collide with each other.
//
// Actions (all POST, body: { action, ...}):
//   - setPin   { customerId, pin }  → creates the login on first call,
//     resets the PIN on any later call. Any logged-in staff member may
//     do this (same trust level as recording a visit at the counter).
//
// Deploy with the Supabase CLI from the repo root:
//   supabase functions deploy customer-portal-admin --project-ref <your-project-ref>
// =====================================================================

import { createClient } from 'https://esm.sh/@supabase/supabase-js@2';

Deno.serve(async (req) => {
  const cors = {
    'Access-Control-Allow-Origin': '*',
    'Access-Control-Allow-Headers': 'authorization, x-client-info, apikey, content-type',
    'Access-Control-Allow-Methods': 'POST, OPTIONS',
  };
  if (req.method === 'OPTIONS') return new Response('ok', { headers: cors });

  try {
    const authHeader = req.headers.get('Authorization') || '';
    const jwt = authHeader.replace(/^Bearer\s+/i, '');
    if (!jwt) return json({ error: 'Not signed in.' }, cors);

    const supabaseAdmin = createClient(
      Deno.env.get('SUPABASE_URL') ?? '',
      Deno.env.get('SUPABASE_SERVICE_ROLE_KEY') ?? ''
    );

    const { data: callerUser, error: callerError } = await supabaseAdmin.auth.getUser(jwt);
    if (callerError || !callerUser?.user) return json({ error: 'Not signed in.' }, cors);

    const { data: callerProfile } = await supabaseAdmin
      .from('staff_profiles')
      .select('id')
      .eq('id', callerUser.user.id)
      .maybeSingle();
    if (!callerProfile) return json({ error: 'Only staff can manage customer portal access.' }, cors);

    const body = await req.json();
    const action = body.action;

    if (action === 'setPin') {
      const { customerId, pin } = body;
      if (!customerId || !pin) return json({ error: 'Missing customerId or pin.' }, cors);
      if (!/^\d{4,6}$/.test(pin)) return json({ error: 'PIN must be 4-6 digits.' }, cors);

      const { data: customer, error: customerError } = await supabaseAdmin
        .from('customers')
        .select('id, phone, auth_user_id')
        .eq('id', customerId)
        .maybeSingle();
      if (customerError) return json({ error: customerError.message }, cors);
      if (!customer) return json({ error: 'Customer not found.' }, cors);

      const digits = (customer.phone || '').replace(/\D/g, '');
      if (digits.length < 8) return json({ error: 'This customer has no usable mobile number on file.' }, cors);
      const loginEmail = `${digits}@customer.mkoptics.local`;

      if (customer.auth_user_id) {
        const { error: updateError } = await supabaseAdmin.auth.admin.updateUserById(customer.auth_user_id, { password: pin });
        if (updateError) return json({ error: updateError.message }, cors);
        return json({ ok: true, created: false });
      }

      const { data: created, error: createError } = await supabaseAdmin.auth.admin.createUser({
        email: loginEmail, password: pin, email_confirm: true,
      });
      if (createError) return json({ error: createError.message }, cors);

      const { error: linkError } = await supabaseAdmin
        .from('customers')
        .update({ auth_user_id: created.user.id })
        .eq('id', customerId);
      if (linkError) return json({ error: linkError.message }, cors);

      return json({ ok: true, created: true });
    }

    return json({ error: 'Unknown action.' }, cors);
  } catch (e) {
    return json({ error: e.message || String(e) }, { 'Access-Control-Allow-Origin': '*' });
  }
});

function json(body, extraHeaders) {
  return new Response(JSON.stringify(body), {
    headers: { 'Content-Type': 'application/json', ...extraHeaders },
  });
}
