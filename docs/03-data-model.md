# Data Model

**Project:** MK Optics Growth Platform
**Companion documents:** `02-technical-architecture.md`, `04-api-specification.md`

---

## 1. Entity-Relationship Diagram

```mermaid
erDiagram
    STORE ||--o{ STAFF_USER : employs
    STORE ||--o{ CUSTOMER : serves
    STORE ||--o{ PRODUCT : stocks
    CUSTOMER ||--o{ PURCHASE : makes
    CUSTOMER ||--o{ PRESCRIPTION : has
    CUSTOMER ||--o{ ENQUIRY : raises
    CUSTOMER ||--o{ MESSAGE_LOG : receives
    CUSTOMER ||--o| LOYALTY_ACCOUNT : holds
    CUSTOMER ||--o{ REFERRAL : sends
    CUSTOMER ||--o{ REVIEW_REQUEST : receives
    PURCHASE ||--o{ PURCHASE_ITEM : contains
    PRODUCT ||--o{ PURCHASE_ITEM : sold_as
    CAMPAIGN ||--o{ MESSAGE_LOG : generates
    CAMPAIGN }o--o{ PRODUCT : targets
    MESSAGE_TEMPLATE ||--o{ MESSAGE_LOG : instantiates
    MESSAGE_TEMPLATE ||--o{ CAMPAIGN : used_by
    ENQUIRY ||--o{ MESSAGE_LOG : triggers

    STORE {
        uuid id PK
        string name
        string address
        string whatsapp_number
        string google_business_url
        datetime created_at
    }

    STAFF_USER {
        uuid id PK
        uuid store_id FK
        string name
        string role "owner | staff"
        string phone
        datetime last_login
    }

    CUSTOMER {
        uuid id PK
        uuid store_id FK
        string name
        string mobile_number UK
        bool marketing_opt_in
        date opt_in_date
        date last_visit_date
        date next_visit_due_date
        string next_visit_reason "eye_test | replacement | contact_lens"
        string preferences
        string notes
        bool high_value_flag
        datetime created_at
        datetime updated_at
    }

    PRESCRIPTION {
        uuid id PK
        uuid customer_id FK
        date issued_date
        string right_eye_sph
        string right_eye_cyl
        string left_eye_sph
        string left_eye_cyl
        string lens_type
        string notes
    }

    PRODUCT {
        uuid id PK
        uuid store_id FK
        string name
        string category "frame | lens | contact_lens | accessory"
        string brand
        decimal price
        int stock_quantity
        bool slow_moving_flag
        datetime last_sold_at
    }

    PURCHASE {
        uuid id PK
        uuid customer_id FK
        uuid store_id FK
        date purchase_date
        decimal total_amount
        string channel "in_store | online"
        int supply_duration_days "for contact lenses"
    }

    PURCHASE_ITEM {
        uuid id PK
        uuid purchase_id FK
        uuid product_id FK
        int quantity
        decimal unit_price
    }

    ENQUIRY {
        uuid id PK
        uuid customer_id FK
        uuid store_id FK
        date enquiry_date
        string product_interest
        string reason_not_converted "price | availability | thinking | other"
        string status "open | followed_up | converted | closed"
        datetime updated_at
    }

    LOYALTY_ACCOUNT {
        uuid id PK
        uuid customer_id FK "UK"
        int points_balance
        string tier
        datetime last_earned_at
        datetime last_redeemed_at
    }

    REFERRAL {
        uuid id PK
        uuid referrer_customer_id FK
        string referred_name
        string referred_mobile
        string status "sent | joined | rewarded"
        datetime created_at
    }

    REVIEW_REQUEST {
        uuid id PK
        uuid customer_id FK
        datetime requested_at
        string status "sent | clicked | reviewed"
    }

    CAMPAIGN {
        uuid id PK
        uuid store_id FK
        uuid template_id FK
        string name
        string type "winback | slow_stock | seasonal | referral | review | custom"
        string status "draft | scheduled | running | completed"
        date scheduled_date
        datetime created_at
    }

    MESSAGE_TEMPLATE {
        uuid id PK
        uuid store_id FK
        string name
        string category "utility | marketing"
        string whatsapp_template_id "external approval ID"
        string body_text
        string approval_status "pending | approved | rejected"
    }

    MESSAGE_LOG {
        uuid id PK
        uuid customer_id FK
        uuid campaign_id FK "nullable"
        uuid template_id FK
        uuid enquiry_id FK "nullable"
        string channel "whatsapp"
        string direction "outbound | inbound"
        string status "queued | sent | delivered | read | failed | replied"
        datetime sent_at
        datetime status_updated_at
    }
```

## 2. Entity Notes

- **CUSTOMER.marketing_opt_in / opt_in_date** — mandatory for every record; no `MESSAGE_LOG` may be created for a customer with `marketing_opt_in = false`, except transactional/utility messages tied to a purchase they initiated (see NFR — consent).
- **CUSTOMER.next_visit_due_date / next_visit_reason** — computed on purchase save (e.g. `purchase_date + 12 months` for an eye test, `purchase_date + supply_duration_days` for contact lenses). Drives the Phase 2 win-back scheduler (FR-07) and the Phase 3 replenishment prediction (FR-18).
- **CUSTOMER.high_value_flag** — a simple rule-based flag in v1 (e.g. total spend or visit count above a threshold); replaced/enhanced by the Phase 3 AI insight engine.
- **PRODUCT.slow_moving_flag** — set manually by staff/operator in v1 (FR-12); could be computed automatically later from `last_sold_at` / `stock_quantity`.
- **ENQUIRY** — captures the "Recover Lost Sales" feature (F2.2); `reason_not_converted` powers the Send Offer vs. Send Update decision in the admin console.
- **MESSAGE_TEMPLATE.whatsapp_template_id / approval_status** — every proactive/marketing message must reference a WhatsApp-approved template; the admin console must block scheduling a campaign against a non-approved template.
- **MESSAGE_LOG** — the single audit trail for all customer communication; powers the reporting dashboard (FR-15) and lets support diagnose delivery issues.
- All customer-identifying tables (`CUSTOMER`, `PRESCRIPTION`) are scoped by `store_id` so the schema can extend to multi-store without a redesign, even though v1 is single-store.

## 3. Data Retention & Sensitivity

- `PRESCRIPTION` and `CUSTOMER` contain personal data (and prescription data is health-adjacent); both require the access controls and retention policy defined in `05-non-functional-requirements.md`.
- `MESSAGE_LOG` body content should reference the template + variables rather than storing full free-text where possible, to simplify data-minimization and export requests.
