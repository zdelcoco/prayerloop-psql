-- Migration: Migrate existing prayers to self prayer_subject
-- Part of Person-Centric Prayer Model (v2026.1.1)
-- This migration is idempotent - safe to run on fresh installs or existing databases

-- Step 1: Create self prayer_subjects for users who don't have one yet
-- (Skip users who already have a self subject from seeds/fresh install)
INSERT INTO prayer_subject (
    prayer_subject_type,
    prayer_subject_display_name,
    user_profile_id,
    link_status,
    display_sequence,
    created_by,
    updated_by
)
SELECT
    'individual',
    COALESCE(NULLIF(TRIM(first_name || ' ' || last_name), ''), username, 'Me'),
    user_profile_id,
    'linked',
    0,
    user_profile_id,
    user_profile_id
FROM user_profile u
WHERE deleted = FALSE
  AND NOT EXISTS (
      SELECT 1 FROM prayer_subject ps
      WHERE ps.created_by = u.user_profile_id
        AND ps.user_profile_id = u.user_profile_id
  );

-- Step 2: Update prayers that have NULL prayer_subject_id to point to user's self subject
-- (Only affects existing databases where column was added as nullable)
UPDATE prayer p
SET prayer_subject_id = ps.prayer_subject_id
FROM prayer_subject ps
WHERE ps.created_by = p.created_by
  AND ps.user_profile_id = ps.created_by
  AND p.prayer_subject_id IS NULL;

-- Step 3: Verify no NULL values remain before making NOT NULL
DO $$
DECLARE
    null_count INT;
    col_is_nullable VARCHAR(3);
BEGIN
    -- Check if there are any NULL values
    SELECT COUNT(*) INTO null_count FROM prayer WHERE prayer_subject_id IS NULL AND deleted = FALSE;

    IF null_count > 0 THEN
        RAISE EXCEPTION 'Cannot make prayer_subject_id NOT NULL: % prayers still have NULL prayer_subject_id', null_count;
    END IF;

    -- Check if column is already NOT NULL
    SELECT c.is_nullable INTO col_is_nullable
    FROM information_schema.columns c
    WHERE c.table_name = 'prayer' AND c.column_name = 'prayer_subject_id';

    -- Only alter if column is currently nullable
    IF col_is_nullable = 'YES' THEN
        ALTER TABLE prayer ALTER COLUMN prayer_subject_id SET NOT NULL;
    END IF;
END $$;

COMMENT ON COLUMN prayer.prayer_subject_id IS 'The person/family/group this prayer is for. Required - all prayers must be associated with a subject.';
