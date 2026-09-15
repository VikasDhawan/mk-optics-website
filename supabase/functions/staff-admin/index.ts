// =====================================================================
// MK Optics — staff-admin Edge Function
// =====================================================================
// Handles the staff-management actions that need admin-level power
// against Supabase Auth — creating a login for a new employee, and
// resetting someone's password. Neither of these can be done safely
// from the browser: Supabase's client library has no "create another
// user's login" or "set someone else's password" call using the
// regular anon key, on purpose (that power is meant to stay
// server-side). This function reads the caller's own session token,
// looks up their role in staff_profiles, and only then uses the
// service-role connection to perform the request — the service-role
// key itself never reaches any browser.
//
// Actions (all POST, body: { action, ...}):
//   - listStaff              → every staff_profiles row + auth email
//   - createStaff             { email, password, name, role }
//   - resetPassword           { userId, newPassword }
//   - setRole                 { userId, role }   (Super Admin only)
//
// Permission rules enforced here (not just in the UI):
//   - employee: none of these actions.
//   - admin: can createStaff (role must be 'employee'), can
//     resetPassword for an 'employee' target, can listStaff. Cannot
//     touch admin/super_admin accounts, cannot change roles.
//   - super_admin: everything, including creating/demoting admins and
//     resetting anyone's password.
//
// Deploy with the Supabase CLI from the repo root:
//   supabase functions deploy staff-admin --project-ref <your-project-ref>
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
    const callerId = callerUser.user.id;

    const { data: callerProfile } = await supabaseAdmin
      .from('staff_profiles')
      .select('role')
      .eq('id', callerId)
      .maybeSingle();
    const callerRole = callerProfile?.role || 'employee';

    if (callerRole !== 'admin' && callerRole !== 'super_admin') {
      return json({ error: 'Only Admin or Super Admin can manage staff.' }, cors);
    }

    const body = await req.json();
    const action = body.action;

    if (action === 'listStaff') {
      const { data: profiles, error: profilesError } = await supabaseAdmin
        .from('staff_profiles')
        .select('*')
        .order('created_at', { ascending: true });
      if (profilesError) return json({ error: profilesError.message }, cors);

      const { data: usersPage, error: usersError } = await supabaseAdmin.auth.admin.listUsers({ perPage: 1000 });
      if (usersError) return json({ error: usersError.message }, cors);

      const emailById = {};
      (usersPage?.users || []).forEach((u) => { emailById[u.id] = u.email; });

      const staff = (profiles || []).map((p) => ({ ...p, email: emailById[p.id] || '(unknown)' }));
      return json({ staff }, cors);
    }

    if (action === 'createStaff') {
      const { email, password, name, role } = body;
      if (!email || !password || !name) return json({ error: 'Name, email, and password are all required.' }, cors);
      const requestedRole = role === 'admin' ? 'admin' : 'employee';

      if (requestedRole === 'admin' && callerRole !== 'super_admin') {
        return json({ error: 'Only Super Admin can create another Admin account.' }, cors);
      }
      if (password.length < 8) return json({ error: 'Password must be at least 8 characters.' }, cors);

      const { data: created, error: createError } = await supabaseAdmin.auth.admin.createUser({
        email, password, email_confirm: true,
      });
      if (createError) return json({ error: createError.message }, cors);

      const { error: profileError } = await supabaseAdmin
        .from('staff_profiles')
        .insert({ id: created.user.id, role: requestedRole, name });
      if (profileError) return json({ error: profileError.message }, cors);

      return json({ ok: true }, cors);
    }

    if (action === 'resetPassword') {
      const { userId, newPassword } = body;
      if (!userId || !newPassword) return json({ error: 'Missing userId or newPassword.' }, cors);
      if (newPassword.length < 8) return json({ error: 'Password must be at least 8 characters.' }, cors);

      const { data: targetProfile } = await supabaseAdmin
        .from('staff_profiles')
        .select('role')
        .eq('id', userId)
        .maybeSingle();
      const targetRole = targetProfile?.role || 'employee';

      if (callerRole === 'admin' && targetRole !== 'employee') {
        return json({ error: 'Admin can only reset passwords for regular employees.' }, cors);
      }

      const { error: updateError } = await supabaseAdmin.auth.admin.updateUserById(userId, { password: newPassword });
      if (updateError) return json({ error: updateError.message }, cors);

      return json({ ok: true }, cors);
    }

    if (action === 'setRole') {
      if (callerRole !== 'super_admin') return json({ error: 'Only Super Admin can change staff roles.' }, cors);
      const { userId, role } = body;
      if (!userId || !['admin', 'employee'].includes(role)) return json({ error: 'Invalid role.' }, cors);

      const { error: roleError } = await supabaseAdmin
        .from('staff_profiles')
        .update({ role })
        .eq('id', userId);
      if (roleError) return json({ error: roleError.message }, cors);

      return json({ ok: true }, cors);
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
