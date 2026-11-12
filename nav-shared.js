// Shared staff sidebar nav, rendered fresh on every page from one config
// below, instead of the same markup being copy-pasted into 12 HTML files.
// A future nav change (new category, renamed page, different grouping)
// is now a one-file edit here, not a find-and-replace across every page.
//
// Each page sets window.MK_ACTIVE_PAGE to one of the ids below, then
// includes this script — BEFORE auth-gate.js, since auth-gate.js looks
// up #actions-badge, #messages-badge, #referrals-badge, #nav-admin-settings
// and #nav-ai-settings by id and expects them to already exist in the DOM.
//
// Categories with children render as an accordion: clicking one expands
// it in place and collapses whichever other category was open. The
// category containing the current page starts expanded. This is the
// exact same markup and behavior at every screen width — mobile gets it
// for free, since .sidebar-nav as a whole is just shown/hidden by the
// existing hamburger toggle in auth-gate.js, not rebuilt separately.
//
// "Actions" is the aggregated worklist (actions.html): follow-ups due/
// overdue, new appointment requests, open enquiries, pending orders, and
// pending rewards sign-ups, all in one place — its badge is the total
// count across all five. Messages and Referrals carry their own badges
// too (open messages, invited referrals) since those still have their
// own dedicated pages under Customers.
(function () {
    // Outline icons, drawn on a 24px grid with a single stroke weight,
    // to match the thin line style used across the app.
    var ICON_PATHS = {
        bell: '<path d="M18 8a6 6 0 0 0-12 0c0 7-3 9-3 9h18s-3-2-3-9"/><path d="M13.7 21a2 2 0 0 1-3.4 0"/>',
        user: '<circle cx="12" cy="8" r="4"/><path d="M4 21c0-4 3.6-7 8-7s8 3 8 7"/>',
        bag: '<path d="M5 8h14l-1 12H6L5 8z"/><path d="M9 8V6a3 3 0 0 1 6 0v2"/>',
        chat: '<path d="M21 12a8 8 0 0 1-11.6 7.1L4 20l1-4.6A8 8 0 1 1 21 12z"/>',
        envelope: '<rect x="3" y="5" width="18" height="14" rx="2"/><path d="M3 7l9 6 9-6"/>',
        share: '<circle cx="18" cy="5" r="3"/><circle cx="6" cy="12" r="3"/><circle cx="18" cy="19" r="3"/><path d="M8.6 13.5l6.8 4M15.4 6.5l-6.8 4"/>',
        sliders: '<path d="M4 6h10M18 6h2M4 12h4M12 12h8M4 18h10M18 18h2"/><circle cx="16" cy="6" r="2"/><circle cx="10" cy="12" r="2"/><circle cx="16" cy="18" r="2"/>',
        gear: '<circle cx="12" cy="12" r="3"/><circle cx="12" cy="12" r="8" stroke-dasharray="2.5 2.2"/>',
        headphones: '<path d="M4 15v-3a8 8 0 0 1 16 0v3"/><rect x="3" y="15" width="4" height="6" rx="1"/><rect x="17" y="15" width="4" height="6" rx="1"/>',
        pie: '<path d="M12 3a9 9 0 1 0 9 9h-9z"/><path d="M14 3.5A9 9 0 0 1 20.5 10H14z"/>',
        cart: '<circle cx="9" cy="20" r="1.5"/><circle cx="18" cy="20" r="1.5"/><path d="M2 3h3l2.6 11.4a2 2 0 0 0 2 1.6h7.7a2 2 0 0 0 2-1.5L21 7H6"/>',
        calendar: '<rect x="3" y="4" width="18" height="18" rx="2"/><path d="M16 2v4M8 2v4M3 10h18"/>'
    };

    function iconSvg(name) {
        var paths = ICON_PATHS[name];
        if (!paths) return null;
        var svg = document.createElementNS('http://www.w3.org/2000/svg', 'svg');
        svg.setAttribute('class', 'nav-icon');
        svg.setAttribute('viewBox', '0 0 24 24');
        svg.setAttribute('aria-hidden', 'true');
        svg.setAttribute('fill', 'none');
        svg.setAttribute('stroke', 'currentColor');
        svg.setAttribute('stroke-width', '1.6');
        svg.setAttribute('stroke-linecap', 'round');
        svg.setAttribute('stroke-linejoin', 'round');
        svg.innerHTML = paths;
        return svg;
    }

    // Sidebar groups. Each group has a small heading. A group can be hidden
    // from some roles: groupId is the id of the wrapper, which auth-gate.js
    // shows or hides by role.
    var NAV_GROUPS = [
        {
            label: 'Work',
            items: [
                { id: 'actions', label: 'Actions', href: 'actions.html', badgeId: 'actions-badge', icon: 'bell' },
                {
                    id: 'customers',
                    label: 'Customers',
                    icon: 'user',
                    children: [
                        { id: 'counter-intake', label: 'Counter Intake', href: 'counter-intake.html' },
                        { id: 'customers', label: 'Customers', href: 'customers.html' },
                        { id: 'enquiries', label: 'Enquiries', href: 'enquiries.html' },
                        { id: 'referrals', label: 'Referrals', href: 'referrals.html', badgeId: 'referrals-badge' },
                        { id: 'messages', label: 'Messages', href: 'customer-messages.html', badgeId: 'messages-badge' }
                    ]
                },
                { id: 'calendar', label: 'Calendar', href: 'calendar.html', icon: 'calendar' },
                { id: 'orders', label: 'Orders', href: 'consumable-orders.html', icon: 'cart' }
            ]
        },
        {
            label: 'Overview',
            items: [
                { id: 'dashboard', label: 'Dashboard', href: 'dashboard.html', icon: 'pie' }
            ]
        },
        {
            label: 'Admin',
            groupId: 'nav-group-admin',
            items: [
                { id: 'admin-settings', label: 'Admin Settings', href: 'admin-settings.html', wrapperId: 'nav-admin-settings', icon: 'sliders' },
                { id: 'ai-settings', label: 'AI Setup', href: 'ai-settings.html', wrapperId: 'nav-ai-settings', icon: 'gear' }
            ]
        },
        {
            label: 'Support',
            items: [
                { id: 'help', label: 'Help', href: 'help.html', icon: 'headphones' }
            ]
        }
    ];

    function findActiveCategoryId(activeId) {
        for (var g = 0; g < NAV_GROUPS.length; g++) {
            var items = NAV_GROUPS[g].items;
            for (var i = 0; i < items.length; i++) {
                var item = items[i];
                if (!item.children) continue;
                for (var j = 0; j < item.children.length; j++) {
                    if (item.children[j].id === activeId) return item.id;
                }
            }
        }
        return null;
    }

    function renderLink(item, activeId) {
        var a = document.createElement('a');
        a.href = item.href;
        if (item.id === activeId) a.className = 'active';
        var icon = iconSvg(item.icon);
        if (icon) a.appendChild(icon);
        var label = document.createElement('span');
        label.className = 'nav-label';
        label.textContent = item.label;
        a.appendChild(label);
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
        var toggleIcon = iconSvg(item.icon);
        if (toggleIcon) toggle.appendChild(toggleIcon);
        var toggleLabel = document.createElement('span');
        toggleLabel.className = 'nav-label';
        toggleLabel.textContent = item.label;
        toggle.appendChild(toggleLabel);
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

    function renderItem(item, activeId, openCategoryId) {
        var node = item.children
            ? renderCategory(item, activeId, openCategoryId)
            : renderLink(item, activeId);
        if (item.wrapperId) {
            var wrapper = document.createElement('span');
            wrapper.id = item.wrapperId;
            wrapper.hidden = true;
            wrapper.appendChild(node);
            return wrapper;
        }
        return node;
    }

    function render(navEl, activeId) {
        var openCategoryId = findActiveCategoryId(activeId);

        NAV_GROUPS.forEach(function (group) {
            var container = document.createElement('div');
            container.className = 'nav-group';
            if (group.groupId) {
                container.id = group.groupId;
                container.hidden = true;
            }

            var heading = document.createElement('div');
            heading.className = 'nav-group-label';
            heading.textContent = group.label;
            container.appendChild(heading);

            group.items.forEach(function (item) {
                container.appendChild(renderItem(item, activeId, openCategoryId));
            });
            navEl.appendChild(container);
        });
    }

    var navEl = document.querySelector('.sidebar-nav');
    if (navEl) render(navEl, window.MK_ACTIVE_PAGE || '');
})();
