DROP TABLE IF EXISTS "prayer_session_config" CASCADE;

CREATE TABLE IF NOT EXISTS "prayer_session_config" (
    session_config_id SERIAL PRIMARY KEY,
    user_profile_id INT NOT NULL REFERENCES user_profile(user_profile_id) ON DELETE CASCADE,
    name VARCHAR(100) NOT NULL,
    description TEXT,
    is_default BOOLEAN DEFAULT FALSE,
    datetime_create TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    datetime_update TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

/*** comments ***/
COMMENT ON TABLE "prayer_session_config" IS 'Saved prayer session configurations. Users can create reusable sessions like "Morning Prayer" or "Small Group".';
COMMENT ON COLUMN "prayer_session_config".session_config_id IS 'Unique identifier for the session configuration.';
COMMENT ON COLUMN "prayer_session_config".user_profile_id IS 'Owner of this session configuration.';
COMMENT ON COLUMN "prayer_session_config".name IS 'Name of the saved session (e.g., "Morning Prayer", "Small Group").';
COMMENT ON COLUMN "prayer_session_config".description IS 'Optional description of the session.';
COMMENT ON COLUMN "prayer_session_config".is_default IS 'If true, this session is the user default when starting a quick session.';
COMMENT ON COLUMN "prayer_session_config".datetime_create IS 'Timestamp when the record was created.';
COMMENT ON COLUMN "prayer_session_config".datetime_update IS 'Timestamp when the record was last updated.';

/*** indexes ***/
CREATE INDEX IF NOT EXISTS idx_session_config_user ON "prayer_session_config" (user_profile_id);

/*** triggers ***/
CREATE TRIGGER session_config_set_datetime_create
BEFORE INSERT ON "prayer_session_config"
FOR EACH ROW
EXECUTE PROCEDURE set_datetime_create();

CREATE TRIGGER session_config_set_datetime_update
BEFORE UPDATE ON "prayer_session_config"
FOR EACH ROW
EXECUTE PROCEDURE update_datetime_update();
