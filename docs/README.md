# MK Optics Growth Platform — Documentation

This is the full documentation package for the **MK Optics Growth Platform** (internally "Retailer Growth System"): a customer-retention and WhatsApp-marketing-automation system for MK Optics, based on the client-approved proposal deck (*Retailer Growth System*, 16 slides).

This documentation is what MK Optics is asked to review and approve, and what the development team builds from.

## Documents

| # | Document | Purpose |
|---|---|---|
| 1 | [Product Requirements Document](01-product-requirements.md) | Problem, vision, personas, features by phase, functional requirements |
| 2 | [Technical Architecture](02-technical-architecture.md) | System diagram, components, suggested tech stack |
| 3 | [Data Model](03-data-model.md) | Entity-relationship diagram and field-level notes |
| 4 | [API Specification](04-api-specification.md) | REST endpoint outline by module |
| 5 | [Non-Functional Requirements](05-non-functional-requirements.md) | Privacy/DPDP compliance, WhatsApp policy, security, performance |
| 6 | [Project Roadmap](06-project-roadmap.md) | Phased delivery plan and indicative timeline |
| 7 | [Statement of Work](07-statement-of-work.md) | Deliverables, pricing, acceptance criteria, sign-off |
| 8 | [Risks, Assumptions & Glossary](08-risks-assumptions-glossary.md) | Risk register, assumptions, terminology |

## Client-Facing Approval Proposal

A polished, standalone summary of this documentation — for MK Optics stakeholders to review and approve before development starts — is published as a Claude Artifact. See the link shared alongside this repository, or ask for it to be re-shared.

## UI Design

Key screens (customer QR signup, staff customer database/intake, campaign manager, owner dashboard) are designed as a Claude Design canvas — see the link shared alongside this repository.

## How These Documents Relate

```
Proposal deck (client input)
        │
        ▼
01 PRD  ──────────────► 06 Roadmap ──────────────► 07 SOW (pricing, deliverables, sign-off)
   │                                                     ▲
   ▼                                                     │
02 Architecture ──► 03 Data Model ──► 04 API Spec        │
   │                                                     │
   ▼                                                     │
05 Non-Functional Requirements ──────────────────────────┘
   │
   ▼
08 Risks, Assumptions & Glossary (cross-cutting)
```

## Status

Draft v1.0 — pending MK Optics approval of scope, design, and pricing (see `07-statement-of-work.md` §8 Sign-off).
