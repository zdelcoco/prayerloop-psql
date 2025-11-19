-- Migration: Add display_sequence columns for user-specific ordering
-- Date: 2025-11-18
-- Description: Add display_sequence to prayer_access and group_display_sequence to user_group
--              to allow users to customize the order of their prayers and groups

-- Add display_sequence to prayer_access table
-- This allows each user to order their prayers independently
ALTER TABLE prayer_access
ADD COLUMN display_sequence INTEGER DEFAULT 0 NOT NULL;

-- Add comment for the new column
COMMENT ON COLUMN prayer_access.display_sequence IS 'User-defined display order for prayers. Lower values appear first. Sequential integers (0, 1, 2...).';

-- Create index for efficient ordering queries
CREATE INDEX IF NOT EXISTS idx_prayer_access_display_sequence
ON prayer_access (access_type, access_type_id, display_sequence);

-- Add group_display_sequence to user_group table
-- This allows each user to order their groups independently
ALTER TABLE user_group
ADD COLUMN group_display_sequence INTEGER DEFAULT 0 NOT NULL;

-- Add comment for the new column
COMMENT ON COLUMN user_group.group_display_sequence IS 'User-defined display order for groups. Lower values appear first. Sequential integers (0, 1, 2...).';

-- Create index for efficient ordering queries
CREATE INDEX IF NOT EXISTS idx_user_group_display_sequence
ON user_group (user_profile_id, group_display_sequence);

-- Update existing records to have sequential display_sequence values
-- This ensures existing data has a logical default order (by creation date)

-- For prayer_access: order by datetime_create for each user
WITH ranked_prayers AS (
  SELECT
    prayer_access_id,
    ROW_NUMBER() OVER (
      PARTITION BY access_type, access_type_id
      ORDER BY datetime_create
    ) - 1 AS seq
  FROM prayer_access
  WHERE access_type = 'user'
)
UPDATE prayer_access pa
SET display_sequence = rp.seq
FROM ranked_prayers rp
WHERE pa.prayer_access_id = rp.prayer_access_id;

-- For prayer_access: order by datetime_create for each group
WITH ranked_group_prayers AS (
  SELECT
    prayer_access_id,
    ROW_NUMBER() OVER (
      PARTITION BY access_type, access_type_id
      ORDER BY datetime_create
    ) - 1 AS seq
  FROM prayer_access
  WHERE access_type = 'group'
)
UPDATE prayer_access pa
SET display_sequence = rgp.seq
FROM ranked_group_prayers rgp
WHERE pa.prayer_access_id = rgp.prayer_access_id;

-- For user_group: order by datetime_create for each user
WITH ranked_groups AS (
  SELECT
    user_group_id,
    ROW_NUMBER() OVER (
      PARTITION BY user_profile_id
      ORDER BY datetime_create
    ) - 1 AS seq
  FROM user_group
)
UPDATE user_group ug
SET group_display_sequence = rg.seq
FROM ranked_groups rg
WHERE ug.user_group_id = rg.user_group_id;
