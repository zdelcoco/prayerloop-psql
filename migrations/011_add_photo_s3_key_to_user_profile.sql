-- Migration: Add photo_s3_key to user_profile table
-- Part of Person-Centric Prayer Model (v2026.1.1)
-- Enables user profile photos stored in S3

-- Add column IF NOT EXISTS for idempotency (fresh installs already have this column)
ALTER TABLE user_profile
ADD COLUMN IF NOT EXISTS photo_s3_key VARCHAR(500);

COMMENT ON COLUMN user_profile.photo_s3_key IS 'S3 object key for user profile photo (not full URL). Used when prayer_subject.use_linked_user_photo is true.';
