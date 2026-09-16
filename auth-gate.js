// Shared staff-login gate used by every app page. Reads window.SUPABASE_CONFIG
// (from supabase-config.js), creates the Supabase client, and shows either the
// login screen or the app depending on whether someone is signed in.
//
// Every page using this expects these elements to exist in its HTML:
//   #config-banner, #login-screen, #login-email, #login-password,
//   #login-btn, #login-error, #app-root, #staff-email, #sign-out-btn
//
// After this script runs, window.MKAuth.supabase is either the Supabase
// client (ready to use for data calls) or null (Supabase isn't configured).
// window.MKAuth.ready is a promise that resolves once the initial
// logged-in/logged-out check has finished.

(function () {
    const cfg = window.SUPABASE_CONFIG;
    const configBanner = document.getElementById('config-banner');
    let supabase = null;

    if (!cfg || !cfg.url || cfg.url.indexOf('YOUR-PROJECT-REF') !== -1) {
        if (configBanner) configBanner.hidden = false;
    } else {
        supabase = window.supabase.createClient(cfg.url, cfg.anonKey);
    }

    // Staff log in with either a mobile number or an email — Supabase
    // Auth itself only understands email+password (its native phone
    // sign-in needs a paid SMS provider, even just to verify the
    // number), so a plain 10-digit number is converted to a fake
    // internal address like "9876543210@staff.mkoptics.local" that's
    // never actually emailed, just used as a unique login ID. A real
    // email is passed through unchanged. Shared here so the login form
    // and Admin Settings' "Add New Staff" form use the exact same rule.
    function toLoginEmail(raw) {
        const value = (raw || '').trim();
        if (!value) return null;
        if (value.indexOf('@') !== -1) return value.toLowerCase();
        const digits = value.replace(/\D/g, '');
        if (digits.length < 10 || digits.length > 15) return null;
        return digits + '@staff.mkoptics.local';
    }

    // The reverse of toLoginEmail — for display only, so staff see the
    // number they actually typed rather than the internal fake address.
    function friendlyLogin(email) {
        const match = /^(\d{10,15})@staff\.mkoptics\.local$/.exec(email || '');
        return match ? match[1] : (email || '');
    }

    let resolveRoleReady;
    window.MKAuth = {
        supabase: supabase,
        role: null,
        profile: null,
        toLoginEmail: toLoginEmail,
        friendlyLogin: friendlyLogin,
        // Resolves with the current user's role ('employee' by default)
        // once their staff_profiles row has been fetched (or created).
        // Pages that need to hide/show something by role should wait on
        // this rather than reading window.MKAuth.role immediately.
        roleReady: new Promise((resolve) => { resolveRoleReady = resolve; }),
    };

    const loginScreen = document.getElementById('login-screen');
    const appRoot = document.getElementById('app-root');
    const loginError = document.getElementById('login-error');
    const staffEmailEl = document.getElementById('staff-email');

    function showApp(session) {
        loginScreen.hidden = true;
        appRoot.hidden = false;
        if (staffEmailEl) {
            staffEmailEl.textContent = session && session.user ? friendlyLogin(session.user.email || '') : '';
        }
        if (session && session.user) loadProfile(session.user.id);
    }

    // Every staff login has exactly one staff_profiles row (role, name,
    // photo). New logins (e.g. an account created straight from the
    // Supabase dashboard before this ever existed) don't have one yet —
    // self-create as the lowest-privilege role ('employee'); promotions
    // only ever happen via the staff-admin Edge Function, never here.
    //
    // A customer, logged in via customer-portal.html (mobile number +
    // PIN — a different account type, not a staff login), can also
    // reach this same code path if they open a staff page in the same
    // browser (shared Supabase session storage). Migration 012 makes
    // the self-insert below fail for any session already linked to a
    // customers row (RLS), so `created` comes back empty — that must
    // NOT be treated as "ok, employee anyway," or a customer would see
    // the staff app shell.
    async function loadProfile(userId) {
        let { data: profile } = await supabase.from('staff_profiles').select('*').eq('id', userId).maybeSingle();
        if (!profile) {
            const { data: created } = await supabase
                .from('staff_profiles')
                .insert({ id: userId, role: 'employee' })
                .select()
                .maybeSingle();
            if (!created) {
                // Not a staff account — sign out of the staff app rather
                // than rendering it with a fabricated role and no real
                // data access.
                showLogin();
                loginError.textContent = 'This login is not a staff account.';
                await supabase.auth.signOut();
                return;
            }
            profile = created;
        }

        window.MKAuth.role = profile.role;
        window.MKAuth.profile = profile;

        const avatarImg = document.getElementById('staff-avatar');
        if (avatarImg) {
            if (profile.photo_url) {
                avatarImg.src = profile.photo_url;
                avatarImg.hidden = false;
            } else {
                avatarImg.hidden = true;
            }
        }

        const isAdminOrAbove = profile.role === 'admin' || profile.role === 'super_admin';
        const isSuperAdmin = profile.role === 'super_admin';
        const adminNav = document.getElementById('nav-admin-settings');
        if (adminNav) adminNav.hidden = !isAdminOrAbove;
        const aiNav = document.getElementById('nav-ai-settings');
        if (aiNav) aiNav.hidden = !isSuperAdmin;

        resolveRoleReady(profile.role);
    }

    function showLogin() {
        loginScreen.hidden = false;
        appRoot.hidden = true;
    }

    // Mobile hamburger menu: closed = a single row (brand + ☰). Tapping
    // it adds .menu-open to the sidebar, which CSS uses to expand the
    // page links and account actions as normal in-flow rows underneath
    // (pushing content down), rather than a horizontally-scrolling strip
    // or an overlaid dropdown. Wired regardless of Supabase config since
    // it's pure UI; harmless no-op on desktop widths.
    const menuBtn = document.getElementById('mobile-menu-btn');
    const sidebar = menuBtn ? menuBtn.closest('.sidebar') : null;
    if (menuBtn && sidebar) {
        menuBtn.addEventListener('click', (e) => {
            e.stopPropagation();
            sidebar.classList.toggle('menu-open');
        });
        document.addEventListener('click', (e) => {
            if (sidebar.classList.contains('menu-open') && !sidebar.contains(e.target)) {
                sidebar.classList.remove('menu-open');
            }
        });
    }

    if (!supabase) {
        window.MKAuth.ready = Promise.resolve();
        resolveRoleReady('employee');
        showApp(null);
        return;
    }

    window.MKAuth.ready = supabase.auth.getSession().then(({ data }) => {
        if (data.session) { showApp(data.session); } else { showLogin(); }
    });

    supabase.auth.onAuthStateChange((_event, session) => {
        if (session) { showApp(session); } else { showLogin(); }
    });

    document.getElementById('login-btn').addEventListener('click', async () => {
        const raw = document.getElementById('login-email').value.trim();
        const password = document.getElementById('login-password').value;
        loginError.textContent = '';
        if (!raw || !password) {
            loginError.textContent = 'Enter both a mobile number (or email) and password.';
            return;
        }
        const email = window.MKAuth.toLoginEmail(raw);
        if (!email) {
            loginError.textContent = 'Enter a 10-digit mobile number or a valid email.';
            return;
        }
        const { error } = await supabase.auth.signInWithPassword({ email, password });
        if (error) {
            loginError.textContent = error.message;
        }
    });

    document.getElementById('login-password').addEventListener('keydown', (e) => {
        if (e.key === 'Enter') document.getElementById('login-btn').click();
    });

    document.getElementById('sign-out-btn').addEventListener('click', () => {
        supabase.auth.signOut();
    });

    // Sidebar badge on "Follow-Ups": a small red count of new, not-yet-
    // reviewed appointment requests from the public booking page. Shown
    // on every staff page (not just Follow-Ups itself) so staff notice
    // it app-wide. #followups-badge is present in every page's sidebar
    // markup; this just fills it in once we know the count.
    const followupsBadge = document.getElementById('followups-badge');
    if (followupsBadge) {
        window.MKAuth.ready.then(async () => {
            const { count } = await supabase
                .from('appointment_requests')
                .select('id', { count: 'exact', head: true })
                .eq('status', 'new');
            if (count) {
                followupsBadge.textContent = count > 99 ? '99+' : String(count);
                followupsBadge.hidden = false;
            }
        });
    }
})();
