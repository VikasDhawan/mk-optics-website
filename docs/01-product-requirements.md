# Product Requirements Document (PRD)

**Project:** MK Optics Growth Platform ("Retailer Growth System")
**Client:** MK Optics
**Prepared for:** Software development kickoff & client approval
**Source input:** *Retailer Growth System* proposal deck (16 slides)
**Status:** Draft v1.0 — pending client approval

---

## 1. Background & Problem Statement

MK Optics, like most independent optical retailers, loses revenue at four predictable points in the customer lifecycle:

| Stage | What happens | Impact |
|---|---|---|
| **Buy** | A customer visits and makes a purchase | ~60% of optical store customers are one-time buyers |
| **Forget** | Their details are never captured, or captured incompletely | ~70% of retailers have no complete, usable customer database |
| **Lose** | Good customers are never nudged for their next eye test, replacement, or upgrade | Repeat customers generate 2–3x more purchases than new customers, but this upside is left on the table |
| **Miss** | Marketing is one-way and occasional (e.g. social posts) | ~80% of optical purchases are not influenced by digital/social marketing at all |

**The opportunity is not acquiring more new customers — it is systematically retaining and re-engaging the customers MK Optics already has.**

A 5% improvement in customer retention can increase profitability by 25–95% (Bain & Co. / Harvard Business Review). Illustratively, 40 returning customers a month at an average spend of ₹2,500 represents ₹100,000 of additional monthly revenue.

## 2. Vision

Give MK Optics a simple, AI-assisted system that:

1. Captures every customer's details and history at the point of purchase.
2. Automatically keeps in touch with them over WhatsApp — reminders, win-backs, offers, review/referral requests.
3. Turns store data (slow-moving stock, lapsed customers, unconverted enquiries) into targeted, automated action.
4. Requires no technical expertise from store staff to operate day to day.

Product tagline (from the approved messaging): **"Know. Nudge. Keep."**

## 3. Goals & Success Metrics

| Goal | Metric | Target (illustrative — to be set with baseline data) |
|---|---|---|
| Build a usable customer database | % of transactions with a captured customer record | ≥ 90% within 60 days of launch |
| Increase repeat visits | Monthly returning-customer count | +5% quarter over quarter |
| Recover lost enquiries | % of non-converted enquiries followed up within 7 days | ≥ 95% (automated) |
| Grow reviews & referrals | New Google reviews / month | Baseline + 3x within 90 days |
| Reduce dead stock | Slow-moving SKUs cleared via targeted campaigns | Tracked per campaign |
| Staff adoption | Staff actively logging customers at checkout | 100% of billing staff trained and using the system |

## 4. Personas

### 4.1 Store Owner / Manager (primary buyer)
Wants visibility into the business — footfall, repeat customers, sales trends — without hiring a marketing team. Cares about ROI and simplicity.

### 4.2 Front-of-store Staff / Optician (primary daily user)
Captures customer details and prescriptions at checkout. Needs a fast, low-friction interface — this must not slow down billing.

### 4.3 Customer / Patient (end recipient)
Scans a QR code to join MK Optics Rewards, receives WhatsApp updates (offers, reminders, order status), redeems loyalty benefits. Expects convenience, not spam — must be able to opt out.

### 4.4 Platform Operator / Support (LITRIT / vendor team)
Configures campaign templates, monitors delivery and system health, and provides onboarding/support to the store during the setup and monthly-plan phases.

## 5. Scope Overview — Three Delivery Phases

The proposal deck frames the customer journey in three phases. This PRD maps each to a software delivery phase (see `06-project-roadmap.md` for timeline/sequencing).

### Phase 1 — Capture & Connect (First Visit)
Build the foundation: the customer record and the intake flow.

- **F1.1 — QR Code Customer Capture.** Printed/counter QR code linking to a mobile-friendly signup page ("MK Optics Rewards"): name, mobile number, marketing consent checkbox.
- **F1.2 — Staff Intake Console.** Staff-facing screen to record/confirm a customer's basic details, prescription, and purchase (frame, lenses, amount) at time of sale.
- **F1.3 — Digital Customer Record.** On save, the customer instantly receives a WhatsApp confirmation with a link to view their digital record (purchase + prescription summary).
- **F1.4 — Customer Database.** Central, always-up-to-date record per customer: contact details, purchase history, prescription records, next-visit due date, preferences/notes, and a computed "high value customer" flag.
- **F1.5 — Store Profile & Public Presence.** Store profile setup, Google Business Profile setup/claim, and enhancement of the existing MK Optics website with an online appointment-booking entry point.
- **F1.6 — Loyalty Program Setup.** Definition of the MK Optics Rewards program (points/benefits structure), tied to the customer record.

### Phase 2 — Engage & Nurture (Ongoing)
Automate the relationship between visits.

- **F2.1 — Automated Win-Back / Reminder Messages.** Rule-based WhatsApp messages triggered by elapsed time since last eye test / expected replacement date (e.g. "It's been 18 months since your last eye test").
- **F2.2 — Lost-Sale Recovery.** Staff can log an enquiry or walk-in that did not convert (with a reason, e.g. price concern). The system tracks these and surfaces one-click actions: **Follow Up** (WhatsApp), **Send Offer**, **Send Update**.
- **F2.3 — Review & Referral Automation.** After a purchase (or a positive interaction), the system automatically requests a Google review at the right time, and separately asks satisfied customers to refer friends/family with an incentive (e.g. "5% off their first purchase").
- **F2.4 — Slow-Moving Stock Campaigns.** Staff/operator flags slow-moving frames/products; the system matches them against customers likely to be interested (based on past purchase profile) and sends a personalised WhatsApp campaign message.
- **F2.5 — Campaign Templates & Seasonal Campaigns.** A library of reusable message templates (win-back, offer, review, referral, seasonal/festival) that can be scheduled or triggered manually.
- **F2.6 — WhatsApp Catalog Sharing.** Ability to share a WhatsApp product catalog / new-arrivals message with customers or segments.
- **F2.7 — Reporting Dashboard.** Store owner-facing dashboard: customers captured, messages sent/delivered, follow-up conversions, review counts, repeat-visit trend, campaign performance.

### Phase 3 — Reward & Grow (Next Visit and Beyond) — *Data-dependent, future features*
These require 6–12 months of accumulated customer/purchase data before they can function reliably, per the proposal deck's explicit "Future Feature" callouts. They are included here for architectural planning, not for initial delivery.

- **F3.1 — AI Next-Best-Offer Recommendations.** After sufficient purchase history exists, the system identifies patterns (e.g. "customers who buy progressive spectacles are 3x more likely to buy prescription sunglasses next") and triggers a personalised WhatsApp recommendation.
- **F3.2 — Contact Lens Replenishment Prediction.** For contact-lens customers, the system predicts the expected replenishment date from supply duration and proactively messages a reorder reminder with a relevant offer (e.g. free solution) before the customer runs out.
- **F3.3 — Loyalty Rewards Redemption.** In-store or digital redemption of accumulated loyalty points/benefits (e.g. ₹500 off next purchase), member-only offers.
- **F3.4 — Advanced Customer Insights.** Segmentation and "best customer" analytics to guide manual marketing decisions beyond the automated rules above.

## 6. Out of Scope (v1)

- Point-of-sale (POS) / billing / inventory management system — the platform is a customer-engagement layer, not a POS. Purchase and stock data are entered manually by staff or imported, not synced live from a POS (see `08-risks-assumptions-glossary.md` for the integration assumption and future option).
- Payment processing / e-commerce checkout.
- Native mobile app for customers (the customer experience is web-based via a QR-linked page and WhatsApp — no app install required).
- Multi-store / franchise management (single-store deployment for MK Optics; multi-location support is a possible future extension).
- Phase 3 AI features, until sufficient data volume exists (tracked as future work, not part of the initial build or its acceptance criteria).

## 7. Functional Requirements Summary

| ID | Requirement | Phase |
|---|---|---|
| FR-01 | System shall generate a unique, printable QR code linking to a mobile signup form | 1 |
| FR-02 | System shall capture name, mobile number, and explicit marketing-consent opt-in on signup | 1 |
| FR-03 | System shall allow staff to record purchase (frame/lens/amount) and prescription details against a customer record | 1 |
| FR-04 | System shall send a WhatsApp confirmation message containing a link to the customer's digital record after signup/purchase | 1 |
| FR-05 | System shall compute and store a "next visit due" date based on record type (e.g. eye test cycle, contact lens supply duration) | 1 |
| FR-06 | System shall allow staff to search/view a customer's full profile: contact info, history, prescriptions, notes, preferences | 1 |
| FR-07 | System shall trigger an automated WhatsApp reminder when a customer's next-visit-due date is reached, with an opt-out honored on every message | 2 |
| FR-08 | System shall allow staff to log a non-converted enquiry/walk-in with a reason code | 2 |
| FR-09 | System shall provide one-click Follow Up / Send Offer / Send Update actions against a logged enquiry | 2 |
| FR-10 | System shall automatically request a Google review from a customer after a qualifying interaction, no more than once per defined cooldown period | 2 |
| FR-11 | System shall send an automated referral request with an incentive to customers flagged as satisfied/high-value | 2 |
| FR-12 | System shall allow an operator to flag one or more products as slow-moving and select/target a matched customer segment | 2 |
| FR-13 | System shall provide a template library for common message types, editable per campaign | 2 |
| FR-14 | System shall log every outbound message (type, recipient, status: sent/delivered/read/failed) for audit and reporting | 2 |
| FR-15 | System shall present a dashboard of key metrics (customers captured, messages sent, conversions, reviews, repeat-visit trend) to the store owner | 2 |
| FR-16 | System shall respect and enforce WhatsApp Business messaging policy (template/session message rules — see `05-non-functional-requirements.md`) | 2 |
| FR-17 | *(Future)* System shall generate a next-best-offer recommendation per customer once minimum data thresholds are met | 3 |
| FR-18 | *(Future)* System shall predict contact-lens replenishment dates and trigger a proactive reminder | 3 |

## 8. Assumptions

See `08-risks-assumptions-glossary.md` for the full list; key product-level assumptions:

- MK Optics has (or will obtain) a WhatsApp Business Account eligible for the Cloud API.
- Purchase, prescription, and stock data will be entered manually by store staff at checkout (no existing POS integration in v1).
- MK Optics can provide store branding assets, Google Business access, and content for the public website.
- Customers provide explicit consent to be contacted; the system must never message a customer who has opted out or not opted in.

## 9. Approval

This PRD, together with `06-project-roadmap.md` and `07-statement-of-work.md`, forms the basis of the scope MK Optics is asked to approve before development begins. See the Approval Proposal artifact for the client-facing summary and sign-off.
