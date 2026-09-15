-- =====================================================================
-- MK Optics — Migration 008: contact lens purchases
-- =====================================================================
-- Run this in the SQL Editor after migration 007.
--
-- Adds contact-lens-specific fields to `visits`: brand, color, base
-- curve, and diameter. Sphere/cylinder/axis (od_sphere, os_sphere,
-- etc.) are reused for contact lens power — the same row can never be
-- both an eyewear visit and a contact lens visit, so there's no
-- ambiguity, and it means every existing report/query that reads
-- those columns keeps working unchanged for contact lens rows too.
--
-- `product_type` already existed in the original schema but the
-- Counter Intake form never actually set it — every visit saved so
-- far has it as null unless the demo data set it directly. This
-- migration doesn't backfill that (there's no reliable way to guess
-- old rows' type), but every new visit saved after this feature ships
-- will have it set correctly.
--
-- Safe to re-run.
-- =====================================================================

alter table visits add column if not exists cl_brand text;
alter table visits add column if not exists cl_color text;
alter table visits add column if not exists cl_base_curve text;
alter table visits add column if not exists cl_diameter text;
