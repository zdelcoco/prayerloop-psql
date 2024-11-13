DROP TABLE IF EXISTS "prayer_session" CASCADE;

CREATE TABLE IF NOT EXISTS "prayer_session" (
    prayer_session_id SERIAL PRIMARY KEY,
    user_profile_id INT NOT NULL, 
    start_time TIMESTAMP NOT NULL,
    end_time TIMESTAMP, 
    FOREIGN KEY (user_profile_id) REFERENCES "user_profile" (user_profile_id) 
);

/*** comments ***/
COMMENT ON TABLE "prayer_session" IS 'This table stores information about prayer sessions.';
COMMENT ON COLUMN "prayer_session".prayer_session_id IS 'Unique identifier for each prayer session.';
COMMENT ON COLUMN "prayer_session".user_profile_id IS 'Foreign key referencing the user participating in the prayer session.';
COMMENT ON COLUMN "prayer_session".start_time IS 'Timestamp when the prayer session starts.';
COMMENT ON COLUMN "prayer_session".end_time IS 'Timestamp when the prayer session ends (optional).';

/*** indexes ***/
CREATE INDEX IF NOT EXISTS idx_prayer_session_user_profile_id ON "prayer_session" (user_profile_id);

/*** functions ***/

/*** triggers ***/
