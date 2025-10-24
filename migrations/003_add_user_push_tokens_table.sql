-- Migration: Add user_push_tokens table
-- Date: 2025-10-24
-- Description: Creates user_push_tokens table to store FCM/APNs push notification tokens for users

-- Create user_push_tokens table
CREATE TABLE IF NOT EXISTS user_push_tokens (
    user_push_tokens_id SERIAL PRIMARY KEY,
    user_profile_id INTEGER NOT NULL REFERENCES user_profile(user_profile_id) ON DELETE CASCADE,
    push_token VARCHAR(500) NOT NULL,
    platform VARCHAR(10) NOT NULL CHECK (platform IN ('ios', 'android')),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Add comments for table and columns
COMMENT ON TABLE user_push_tokens IS 'This table stores push notification tokens for users.';
COMMENT ON COLUMN user_push_tokens.user_push_tokens_id IS 'Unique identifier for the push token record.';
COMMENT ON COLUMN user_push_tokens.user_profile_id IS 'ID of the user associated with the push token.';
COMMENT ON COLUMN user_push_tokens.push_token IS 'The push notification token for the user.';
COMMENT ON COLUMN user_push_tokens.platform IS 'The platform for which the push token is valid (ios or android).';
COMMENT ON COLUMN user_push_tokens.created_at IS 'Timestamp when the record was created.';
COMMENT ON COLUMN user_push_tokens.updated_at IS 'Timestamp when the record was last updated.';

-- Create indexes
CREATE UNIQUE INDEX IF NOT EXISTS idx_user_push_tokens_userid_token ON user_push_tokens(user_profile_id, push_token);
CREATE INDEX IF NOT EXISTS idx_user_push_tokens_user_id ON user_push_tokens(user_profile_id);
CREATE INDEX IF NOT EXISTS idx_user_push_tokens_platform ON user_push_tokens(platform);

-- Create function for setting created_at timestamp
CREATE OR REPLACE FUNCTION set_user_push_tokens_created_at()
RETURNS TRIGGER AS $$
BEGIN
    NEW.created_at = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$ language 'plpgsql';

-- Create function for updating updated_at timestamp
CREATE OR REPLACE FUNCTION update_user_push_tokens_updated_at()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$ language 'plpgsql';

-- Create trigger for setting created_at
DROP TRIGGER IF EXISTS set_user_push_tokens_created_at ON user_push_tokens;
CREATE TRIGGER set_user_push_tokens_created_at
    BEFORE INSERT ON user_push_tokens
    FOR EACH ROW
    EXECUTE FUNCTION set_user_push_tokens_created_at();

-- Create trigger for updating updated_at
DROP TRIGGER IF EXISTS set_user_push_tokens_updated_at ON user_push_tokens;
CREATE TRIGGER set_user_push_tokens_updated_at
    BEFORE UPDATE ON user_push_tokens
    FOR EACH ROW
    EXECUTE FUNCTION update_user_push_tokens_updated_at();
