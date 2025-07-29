-- Migration: Add signup fields to user_profile table
-- Date: 2025-07-29
-- Description: Adds phone_number, email_verified, phone_verified, verification_token, and admin fields to support user signup flow

-- Add new columns to user_profile table
ALTER TABLE "user_profile" 
ADD COLUMN phone_number VARCHAR(20),
ADD COLUMN email_verified BOOLEAN DEFAULT FALSE,
ADD COLUMN phone_verified BOOLEAN DEFAULT FALSE, 
ADD COLUMN verification_token VARCHAR(255),
ADD COLUMN admin BOOLEAN DEFAULT FALSE;

-- Add indexes for new fields
CREATE INDEX IF NOT EXISTS idx_user_profile_phone_number ON "user_profile" (phone_number);
CREATE INDEX IF NOT EXISTS idx_user_profile_verification_token ON "user_profile" (verification_token);
CREATE INDEX IF NOT EXISTS idx_user_profile_admin ON "user_profile" (admin);

-- Add comments for new columns
COMMENT ON COLUMN "user_profile".phone_number IS 'The user''s phone number (optional).';
COMMENT ON COLUMN "user_profile".email_verified IS 'Indicates if the user''s email has been verified.';
COMMENT ON COLUMN "user_profile".phone_verified IS 'Indicates if the user''s phone number has been verified.';
COMMENT ON COLUMN "user_profile".verification_token IS 'Token used for email/phone verification.';
COMMENT ON COLUMN "user_profile".admin IS 'Indicates if the user has admin privileges.';

-- Update existing admin users (those with username starting with 'admin')
UPDATE "user_profile" 
SET admin = TRUE 
WHERE username LIKE 'admin%';