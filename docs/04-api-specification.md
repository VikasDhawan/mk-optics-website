# API Specification (Outline)

**Project:** MK Optics Growth Platform
**Companion documents:** `02-technical-architecture.md`, `03-data-model.md`

This is a developer-ready endpoint outline, not a full OpenAPI contract — intended to scope backend work and let frontend/admin-console development start in parallel. The development team should formalize this into an OpenAPI/Swagger spec during Phase 1 sprint planning.

All endpoints are prefixed `/api/v1` and require staff authentication (`Authorization: Bearer <token>`) except where marked **public**.

---

## 1. Auth

| Method | Path | Purpose |
|---|---|---|
| POST | `/auth/login` | Staff/owner login (phone + OTP or email + password) |
| POST | `/auth/logout` | Invalidate session |
| GET | `/auth/me` | Current user + role |

## 2. Customers

| Method | Path | Purpose |
|---|---|---|
| POST | `/public/signup` **(public)** | QR-linked signup form submit: name, mobile, consent → creates/updates `CUSTOMER` |
| GET | `/customers` | List/search customers (query: name, mobile, tag, next-visit-due range) |
| GET | `/customers/{id}` | Full customer profile: contact, purchases, prescriptions, notes, loyalty |
| POST | `/customers` | Staff-created customer record (counter intake) |
| PATCH | `/customers/{id}` | Update contact info, preferences, notes, opt-in status |
| GET | `/customers/{id}/timeline` | Chronological activity: purchases, messages, enquiries |
| POST | `/customers/{id}/opt-out` | Record consent withdrawal (must halt all future marketing messages immediately) |

## 3. Prescriptions

| Method | Path | Purpose |
|---|---|---|
| POST | `/customers/{id}/prescriptions` | Add a prescription record |
| GET | `/customers/{id}/prescriptions` | List a customer's prescription history |

## 4. Purchases & Products

| Method | Path | Purpose |
|---|---|---|
| POST | `/customers/{id}/purchases` | Record a purchase (items, amount, channel); triggers next-visit-due calculation |
| GET | `/customers/{id}/purchases` | Purchase history for a customer |
| GET | `/products` | List products (filter: category, slow_moving) |
| POST | `/products` | Add a product |
| PATCH | `/products/{id}` | Update stock, price, or `slow_moving_flag` |

## 5. Enquiries (Lost-Sale Recovery)

| Method | Path | Purpose |
|---|---|---|
| POST | `/enquiries` | Log a non-converted enquiry/walk-in |
| GET | `/enquiries` | List open enquiries (filter: status, age) |
| POST | `/enquiries/{id}/follow-up` | Trigger a "Follow Up" WhatsApp message |
| POST | `/enquiries/{id}/send-offer` | Trigger a "Send Offer" WhatsApp message |
| POST | `/enquiries/{id}/send-update` | Trigger a "Send Update" WhatsApp message |
| PATCH | `/enquiries/{id}` | Update status (converted/closed) |

## 6. Campaigns & Templates

| Method | Path | Purpose |
|---|---|---|
| GET | `/templates` | List message templates + WhatsApp approval status |
| POST | `/templates` | Create a new template (submits for WhatsApp approval) |
| GET | `/campaigns` | List campaigns (filter: type, status) |
| POST | `/campaigns` | Create a campaign (winback / slow_stock / seasonal / referral / review / custom) |
| POST | `/campaigns/{id}/target-customers` | Attach/preview the matched customer segment (manual list, or AI-matched list in Phase 3) |
| POST | `/campaigns/{id}/schedule` | Schedule or send a campaign |
| GET | `/campaigns/{id}/results` | Delivery/read/click stats for a campaign |

## 7. Loyalty & Referrals

| Method | Path | Purpose |
|---|---|---|
| GET | `/customers/{id}/loyalty` | Points balance / tier |
| POST | `/customers/{id}/loyalty/redeem` | Redeem points/benefit |
| POST | `/customers/{id}/referrals` | Log a referral sent by this customer |
| GET | `/referrals` | List referrals (filter: status) |

## 8. Reviews

| Method | Path | Purpose |
|---|---|---|
| POST | `/customers/{id}/review-requests` | Trigger a review-request message |
| GET | `/review-requests` | List sent review requests + click status |

## 9. Messaging (WhatsApp integration)

| Method | Path | Purpose |
|---|---|---|
| POST | `/webhooks/whatsapp` **(public, signature-verified)** | Inbound delivery/read receipts and customer replies from Meta/BSP |
| GET | `/messages` | Message log (filter: customer, campaign, status, date range) |

## 10. Dashboard / Reports

| Method | Path | Purpose |
|---|---|---|
| GET | `/reports/summary` | Headline metrics: customers captured, repeat-visit rate, messages sent, review count, revenue-influenced |
| GET | `/reports/campaigns` | Per-campaign performance |
| GET | `/reports/enquiries` | Follow-up/conversion rate |

## 11. Phase 3 — AI / Recommendations (future)

| Method | Path | Purpose |
|---|---|---|
| GET | `/customers/{id}/recommendations` | Next-best-offer suggestion(s) for a customer |
| GET | `/customers/{id}/replenishment-forecast` | Predicted contact-lens reorder date |
| POST | `/ai/recompute` | Trigger a recomputation batch job (operator-only) |

---

## Conventions

- All list endpoints support pagination (`?page=`, `?limit=`) and return `{ data, total, page, limit }`.
- All mutating endpoints validate `marketing_opt_in` before allowing any marketing-category message to be queued (utility/transactional messages, e.g. purchase confirmation, are exempt — see NFR consent rules).
- Standard error shape: `{ error: { code, message } }` with appropriate HTTP status codes (400/401/403/404/409/422/500).
- All timestamps are ISO 8601 UTC.
