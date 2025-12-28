-- Migration: Add prayer_subject_id to prayer table
-- Part of Person-Centric Prayer Model (v2026.1.1)

-- Add column IF NOT EXISTS for idempotency (fresh installs already have this column)
DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM information_schema.columns
        WHERE table_name = 'prayer' AND column_name = 'prayer_subject_id'
    ) THEN
        ALTER TABLE prayer
        ADD COLUMN prayer_subject_id INT REFERENCES prayer_subject(prayer_subject_id) ON DELETE CASCADE;
    END IF;
END $$;

COMMENT ON COLUMN prayer.prayer_subject_id IS 'The person/family/group this prayer is for. Required after data migration.';

CREATE INDEX IF NOT EXISTS idx_prayer_prayer_subject ON prayer(prayer_subject_id);
