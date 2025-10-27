DROP TABLE IF EXISTS "password_reset_tokens" CASCADE;

CREATE TABLE password_reset_tokens (
    password_reset_tokens_id SERIAL PRIMARY KEY,
    user_profile_id INTEGER NOT NULL REFERENCES user_profile(user_profile_id) ON DELETE CASCADE,
    code VARCHAR(6) NOT NULL,
    expires_at TIMESTAMP NOT NULL,
    used BOOLEAN DEFAULT FALSE,
    attempts INTEGER DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

/*** comments ***/
COMMENT ON TABLE password_reset_tokens IS 'This table stores temporary codes for password reset requests.';
COMMENT ON COLUMN password_reset_tokens.token_id IS 'Unique identifier for the password reset token record.';
COMMENT ON COLUMN password_reset_tokens.user_profile_id IS 'ID of the user requesting password reset.';
COMMENT ON COLUMN password_reset_tokens.code IS '6-digit verification code sent to user email.';
COMMENT ON COLUMN password_reset_tokens.expires_at IS 'Timestamp when the code expires (typically 15 minutes from creation).';
COMMENT ON COLUMN password_reset_tokens.used IS 'Indicates whether the code has been used (prevents reuse).';
COMMENT ON COLUMN password_reset_tokens.attempts IS 'Number of verification attempts (max 3 allowed).';
COMMENT ON COLUMN password_reset_tokens.created_at IS 'Timestamp when the reset code was created.';

/*** indexes ***/
CREATE INDEX IF NOT EXISTS idx_password_reset_code ON password_reset_tokens(code);
CREATE INDEX IF NOT EXISTS idx_password_reset_user ON password_reset_tokens(user_profile_id);
CREATE INDEX IF NOT EXISTS idx_password_reset_expires ON password_reset_tokens(expires_at);

/*** functions ***/
CREATE OR REPLACE FUNCTION set_password_reset_tokens_created_at()
RETURNS TRIGGER AS $$
BEGIN
    NEW.created_at = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$ language 'plpgsql';

/*** triggers ***/
CREATE TRIGGER set_password_reset_tokens_created_at
    BEFORE INSERT ON password_reset_tokens
    FOR EACH ROW
    EXECUTE FUNCTION set_password_reset_tokens_created_at();
