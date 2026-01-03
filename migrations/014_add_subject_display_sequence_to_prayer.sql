-- Migration: Add subject_display_sequence column to prayer table
-- Date: 2025-12-31
-- Description: Add subject_display_sequence to prayer table to allow users to
--              customize the order of prayers within a specific contact/subject

-- Add subject_display_sequence to prayer table (IF NOT EXISTS for idempotency)
-- This allows users to order prayers within each prayer subject independently
ALTER TABLE prayer
ADD COLUMN IF NOT EXISTS subject_display_sequence INTEGER DEFAULT 0 NOT NULL;

-- Add comment for the new column
COMMENT ON COLUMN prayer.subject_display_sequence IS 'User-defined display order for prayers within a prayer subject. Lower values appear first. Sequential integers (0, 1, 2...).';

-- Create index for efficient ordering queries within a subject
CREATE INDEX IF NOT EXISTS idx_prayer_subject_display_sequence
ON prayer (prayer_subject_id, subject_display_sequence);

-- Update existing records to have sequential subject_display_sequence values
-- This ensures existing data has a logical default order (by creation date within each subject)
WITH ranked_prayers AS (
  SELECT
    prayer_id,
    ROW_NUMBER() OVER (
      PARTITION BY prayer_subject_id
      ORDER BY datetime_create
    ) - 1 AS seq
  FROM prayer
  WHERE deleted = FALSE
)
UPDATE prayer p
SET subject_display_sequence = rp.seq
FROM ranked_prayers rp
WHERE p.prayer_id = rp.prayer_id;
