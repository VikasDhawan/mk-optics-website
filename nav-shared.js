// Shared staff sidebar nav, rendered fresh on every page from one config
// below, instead of the same markup being copy-pasted into 12 HTML files.
// A future nav change (new category, renamed page, different grouping)
// is now a one-file edit here, not a find-and-replace across every page.
//
// Each page sets window.MK_ACTIVE_PAGE to one of the ids below, then
// includes this script — BEFORE auth-gate.js, since auth-gate.js looks
// up #followups-badge, #nav-admin-settings and #nav-ai-settings by id
// and expects them to already exist in the DOM.
//
// Categories with children render as an accordion: clicking one expands
// it in place and collapses whichever other category was open. The
// category containing the current page starts expanded. This is the
// exact same markup and behavior at every screen width — mobile gets it
// for free, since .sidebar-nav as a whole is just shown/hidden by the
// existing hamburger toggle in auth-gate.js, not rebuilt separately.
//
// "Actions" temporarily points at follow-ups.html and reuses its badge —
// a placeholder until it becomes its own aggregated page in the next
// phase. Nothing about follow-ups.html itself changes here.
(function () {
    var NAV_ITEMS = [
        { id: 'actions', label: 'Actions', href: 'follow-ups.html', badgeId: 'followups-badge' },
        {
            id: 'customers',
            label: 'Customers',
            children: [
                { id: 'counter-intake', label: 'Counter Intake', href: 'counter-intake.html' },
                { id: 'customers', label: 'Customers', href: 'customers.html' },
                { id: 'enquiries', label: 'Enquiries', href: 'enquiries.html' },
                { id: 'referrals', label: 'Referrals', href: 'referrals.html' },
                { id: 'messages', label: 'Messages', href: 'customer-messages.html' }
            ]
        },
        { id: 'calendar', label: 'Calendar', href: 'calendar.html' },
        { id: 'orders', label: 'Orders', href: 'consumable-orders.html' },
        { id: 'dashboard', label: 'Dashboard', href: 'dashboard.html' }
    ];

    // Settings/account-level pages — unaffected by the categorization
    // above, rendered exactly as before (including the role-gated hidden
    // wrapper spans auth-gate.js toggles by id).
    var EXTRA_ITEMS = [
        { id: 'ai-settings', label: 'AI Setup', href: 'ai-settings.html', wrapperId: 'nav-ai-settings' },
        { id: 'my-profile', label: 'My Profile', href: 'my-profile.html' },
        { id: 'admin-settings', label: 'Admin Settings', href: 'admin-settings.html', wrapperId: 'nav-admin-settings' }
    ];

    function findActiveCategoryId(activeId) {
        for (var i = 0; i < NAV_ITEMS.length; i++) {
            var item = NAV_ITEMS[i];
            if (!item.children) continue;
            for (var j = 0; j < item.children.length; j++) {
                if (item.children[j].id === activeId) return item.id;
            }
        }
        return null;
    }

    function renderLink(item, activeId) {
        var a = document.createElement('a');
        a.href = item.href;
        if (item.id === activeId) a.className = 'active';
        a.appendChild(document.createTextNode(item.label));
        if (item.badgeId) {
            var badge = document.createElement('span');
            badge.className = 'nav-badge';
            badge.id = item.badgeId;
            badge.hidden = true;
            badge.textContent = '0';
            a.appendChild(badge);
        }
        return a;
    }

    function closeAllCategories() {
        document.querySelectorAll('.nav-subitems').forEach(function (s) { s.hidden = true; });
        document.querySelectorAll('.nav-category-toggle').forEach(function (t) { t.classList.remove('open'); });
    }

    function renderCategory(item, activeId, openCategoryId) {
        var wrap = document.createElement('div');
        wrap.className = 'nav-category';

        var isOpen = item.id === openCategoryId;
        var toggle = document.createElement('button');
        toggle.type = 'button';
        toggle.className = 'nav-category-toggle' + (isOpen ? ' open' : '');
        toggle.appendChild(document.createTextNode(item.label));
        var chevron = document.createElement('span');
        chevron.className = 'nav-chevron';
        chevron.textContent = '▾';
        toggle.appendChild(chevron);

        var sub = document.createElement('div');
        sub.className = 'nav-subitems';
        sub.hidden = !isOpen;
        item.children.forEach(function (child) {
            sub.appendChild(renderLink(child, activeId));
        });

        toggle.addEventListener('click', function () {
            var willOpen = sub.hidden;
            closeAllCategories();
            if (willOpen) {
                sub.hidden = false;
                toggle.classList.add('open');
            }
        });

        wrap.appendChild(toggle);
        wrap.appendChild(sub);
        return wrap;
    }

    function render(navEl, activeId) {
        var openCategoryId = findActiveCategoryId(activeId);

        NAV_ITEMS.forEach(function (item) {
            navEl.appendChild(item.children ? renderCategory(item, activeId, openCategoryId) : renderLink(item, activeId));
        });

        EXTRA_ITEMS.forEach(function (item) {
            var link = renderLink(item, activeId);
            if (item.wrapperId) {
                var wrapper = document.createElement('span');
                wrapper.id = item.wrapperId;
                wrapper.hidden = true;
                wrapper.appendChild(link);
                navEl.appendChild(wrapper);
            } else {
                navEl.appendChild(link);
            }
        });
    }

    var navEl = document.querySelector('.sidebar-nav');
    if (navEl) render(navEl, window.MK_ACTIVE_PAGE || '');
})();
