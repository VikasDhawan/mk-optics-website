# Risks, Assumptions & Glossary

**Project:** MK Optics Growth Platform

---

## 1. Risk Register

| # | Risk | Likelihood | Impact | Mitigation |
|---|---|---|---|---|
| R1 | WhatsApp Business Account / template approval delays (Meta review can take days) | Medium | Medium | Start WABA verification and submit initial templates in Phase 0, before development finishes; build against a queue of approved templates |
| R2 | Manual data entry (no POS integration) leads to incomplete/inaccurate purchase or prescription records | High | Medium | Keep intake UI fast and minimal; make key fields required; train staff; monitor capture-rate metric (PRD §3) |
| R3 | Low customer opt-in rate at signup limits reach of automation | Medium | Medium | Make consent value clear at the QR touchpoint (e.g. "exclusive offers"); track opt-in rate from week 1 |
| R4 | WhatsApp number quality rating drops due to over-messaging or low engagement, risking throttling/suspension | Low–Medium | High | Enforce frequency caps (NFR §2); monitor delivery/read/opt-out metrics; keep messages relevant and personalized |
| R5 | Insufficient data volume delays Phase 3 AI features beyond the illustrative 6–12 month window | Medium | Low (scope already treats this as future work) | Track data-sufficiency explicitly as a roadmap gate, not a fixed date |
| R6 | Staff adoption resistance (extra step at checkout) | Medium | Medium | Keep intake flow under the performance target (NFR §4); involve staff in training and early feedback |
| R7 | Store's Google Business Profile is unclaimed/disputed, blocking review-request links | Low | Low | Verify Google Business access during Phase 0 |
| R8 | Third-party WhatsApp/BSP costs scale with customer base and are outside the platform's own fee | Medium | Medium | Call out explicitly in SOW §5; monitor conversation volume monthly |
| R9 | Prescription/health-adjacent data mishandled, creating a compliance exposure under the DPDP Act | Low | High | Enforce role-based access and the data-handling rules in `05-non-functional-requirements.md` from day one |

## 2. Assumptions

1. Single MK Optics store location for v1.
2. Staff will manually enter purchase, prescription, and stock data (no existing POS/inventory system to integrate).
3. MK Optics will provide branding assets, store content, and access to its Google Business Profile.
4. MK Optics will set up (or authorize setup of) a WhatsApp Business Account eligible for the Cloud API.
5. Customers carry a smartphone capable of scanning a QR code and using WhatsApp.
6. The existing marketing website (this repository) is extended rather than rebuilt from scratch.
7. Phase 3 AI features are explicitly deferred and excluded from the current commercial scope (see SOW §4).
8. Currency and pricing are in INR, consistent with an India-market single-store deployment.

## 3. Glossary

| Term | Definition |
|---|---|
| **QR signup** | A printed QR code linking to a mobile web form customers use to join "MK Optics Rewards" and consent to marketing contact |
| **WABA** | WhatsApp Business Account — the Meta-verified account required to send business messages via the WhatsApp Business Platform |
| **WhatsApp Cloud API** | Meta's hosted API for sending/receiving WhatsApp Business messages programmatically |
| **BSP** | Business Solution Provider — a third-party (e.g. Gupshup, Twilio, Interakt) that simplifies WhatsApp API access, template management, and billing |
| **Message template** | A pre-approved message format required by WhatsApp policy for any proactive (non-session) business message |
| **Win-back message** | An automated message sent to a lapsed or due-for-reminder customer to bring them back to the store |
| **Lost-sale recovery** | The workflow for following up with customers who enquired or visited but did not purchase |
| **Next-best-offer (NBO)** | An AI-generated product suggestion for a specific customer based on their purchase history and similar customers' behavior (Phase 3) |
| **Slow-moving stock** | Inventory that has not sold recently and is targeted by a matching campaign to move it |
| **High-value customer** | A customer flagged (by rule or AI) as a priority for retention/engagement based on spend or visit frequency |
| **Opt-in / opt-out** | A customer's explicit consent to receive marketing messages, and their ability to withdraw it at any time |
| **DPDP Act** | India's Digital Personal Data Protection Act, 2023 — governs collection, use, and protection of personal data |
| **Capture & Connect / Engage & Nurture / Reward & Grow** | The three customer-lifecycle phases from the original proposal deck, mapped to Roadmap Phases 1, 2, and 3 respectively |
