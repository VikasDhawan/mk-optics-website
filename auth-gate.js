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

    window.MKAuth = { supabase: supabase };

    const loginScreen = document.getElementById('login-screen');
    const appRoot = document.getElementById('app-root');
    const loginError = document.getElementById('login-error');
    const staffEmailEl = document.getElementById('staff-email');

    function showApp(session) {
        loginScreen.hidden = true;
        appRoot.hidden = false;
        if (staffEmailEl) {
            staffEmailEl.textContent = session && session.user ? (session.user.email || '') : '';
        }
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
        const email = document.getElementById('login-email').value.trim();
        const password = document.getElementById('login-password').value;
        loginError.textContent = '';
        if (!email || !password) {
            loginError.textContent = 'Enter both email and password.';
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
