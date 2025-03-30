DROP TABLE IF EXISTS "user_preferences" CASCADE;

CREATE TABLE user_preferences (
    user_profile_id INT NOT NULL,
    preference_key VARCHAR(50) NOT NULL,
    preference_value TEXT,
    datetime_create TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    datetime_update TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (user_profile_id, preference_key),
    FOREIGN KEY (user_profile_id) REFERENCES user_profile(user_profile_id) ON DELETE CASCADE
);

/*** comments ***/
COMMENT ON TABLE user_preferences IS 'This table stores user-specific preferences for the application.';
COMMENT ON COLUMN user_preferences.user_profile_id IS 'Unique identifier for the user.';
COMMENT ON COLUMN user_preferences.preference_key IS 'The key for the preference setting (e.g., theme, notifications).';
COMMENT ON COLUMN user_preferences.preference_value IS 'The value for the preference setting (e.g., dark mode, true/false).';
COMMENT ON COLUMN user_preferences.datetime_create IS 'Timestamp when the preference was created.';
COMMENT ON COLUMN user_preferences.datetime_update IS 'Timestamp when the preference was last updated.';

/*** indexes ***/
CREATE INDEX IF NOT EXISTS idx_user_preferences_user_profile_id ON user_preferences(user_profile_id);
CREATE INDEX IF NOT EXISTS idx_user_preferences_preference_key ON user_preferences(preference_key);

/*** functions ***/
CREATE OR REPLACE FUNCTION set_datetime_create()
RETURNS TRIGGER AS $$
BEGIN
    NEW.datetime_create = CURRENT_TIMESTAMP;
    RETURN NEW; 
END;
$$ LANGUAGE plpgsql; 

CREATE OR REPLACE FUNCTION update_datetime_update()
RETURNS TRIGGER AS $$
BEGIN
    NEW.datetime_update = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

/*** triggers ***/
CREATE TRIGGER set_datetime_create_trigger
BEFORE INSERT ON user_preferences
FOR EACH ROW
EXECUTE FUNCTION set_datetime_create(); 

CREATE TRIGGER set_datetime_update_trigger
BEFORE UPDATE ON user_preferences
FOR EACH ROW
EXECUTE FUNCTION update_datetime_update();

