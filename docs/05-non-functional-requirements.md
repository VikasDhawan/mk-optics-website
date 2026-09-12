# Non-Functional Requirements

**Project:** MK Optics Growth Platform

---

## 1. Data Privacy & Consent

- The platform stores personal data (name, mobile number) and health-adjacent data (eyewear prescriptions). It must be designed and operated in line with India's **Digital Personal Data Protection Act, 2023 (DPDP Act)**:
  - Collect only what is needed (name, mobile, prescription, purchase details, stated preferences).
  - Obtain **explicit, recorded consent** at signup for marketing communication (the QR signup form's checkbox is the consent record — see `CUSTOMER.marketing_opt_in` / `opt_in_date`).
  - Provide an easy way for a customer to withdraw consent (reply "STOP" on WhatsApp, or a staff-assisted opt-out), honored immediately and permanently until re-consent.
  - Support a data access/deletion request from a customer within a reasonable timeframe (manual process acceptable for v1: staff export/delete via the admin console).
  - Store only MK Optics' own customers' data; no data is sold or shared with third parties outside the WhatsApp/Google integrations needed to operate the service.
- **Prescription data** should be visible only to authenticated staff roles, never exposed in any public-facing page or unauthenticated link.

## 2. WhatsApp Business Platform Compliance

- All **proactive/marketing** messages (reminders, offers, campaigns, referral/review requests) must use **Meta-approved message templates**. Free-form text may only be used within an active 24-hour customer-initiated conversation window.
- Every marketing template must include a clear opt-out instruction, and the system must process opt-out replies automatically.
- Message frequency must respect a sensible cap (e.g. no more than one marketing message per customer per week outside of an active conversation) to avoid WhatsApp quality-rating penalties that could suspend the business number.
- Template approval turnaround (typically 1–3 business days via Meta/BSP) must be planned into campaign scheduling — see the risk register.

## 3. Security

- All traffic over HTTPS/TLS.
- Staff authentication with role-based access control (Owner vs. Staff — e.g. only Owner role can view revenue reports or edit templates/campaigns; Staff role can capture customers and log enquiries).
- Passwords/OTP handled via a reputable auth library; no plaintext credential storage.
- The WhatsApp webhook endpoint must validate the provider's signature on every inbound request.
- Regular dependency/security patching; no secrets committed to the repository (API keys/tokens via environment variables or a secrets manager).

## 4. Performance

- The staff intake screen (customer lookup/create + purchase entry) must complete common actions in **under 3 seconds** on a typical in-store connection — this is a checkout-adjacent workflow and must not create a queue.
- The customer signup page (QR-linked) must load in under 2 seconds on mobile networks.
- Dashboard reports may load asynchronously (a few seconds is acceptable) given they are not time-critical.

## 5. Availability & Reliability

- Target **99% uptime** for the admin console and API during store operating hours — appropriate for a single-store SME deployment (not a 99.99% SLA).
- Message sending must be retried on transient failure (e.g. WhatsApp API timeout) with backoff, and failures must be visible in the admin console rather than silently dropped.
- Daily automated database backups with a defined restore procedure.

## 6. Scalability

- v1 is sized for a single store with a customer base in the low thousands and message volumes of a few hundred/day — no need for high-throughput infrastructure.
- The data model (`03-data-model.md`) is store-scoped so the same system can extend to additional MK Optics branches later without a schema redesign.

## 7. Usability & Accessibility

- Staff-facing screens must be usable by non-technical retail staff with minimal training (aligned with the deck's "No Tech Complexity" promise).
- The customer-facing signup page must work on low-end Android devices and common mobile browsers, with large touch targets and minimal required fields.
- Follow basic WCAG 2.1 AA practices (contrast, readable font sizes, form labels) on all customer-facing pages.

## 8. Auditability

- Every outbound message and every consent change (opt-in/opt-out) is logged with a timestamp and is queryable by staff for at least one customer dispute/audit scenario (see `MESSAGE_LOG` in the data model).

## 9. Maintainability & Support

- Codebase organized per `02-technical-architecture.md` component boundaries so the messaging engine, admin console, and public site can be worked on independently.
- Monthly-plan support (per the SOW) includes monitoring message delivery health and template approval status — this should be operationally visible (e.g. a simple ops dashboard or alert), not something the vendor discovers from a client complaint.
