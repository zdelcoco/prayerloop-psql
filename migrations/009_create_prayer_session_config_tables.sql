-- Migration: Create prayer session config tables
-- Part of Person-Centric Prayer Model (v2026.1.1)

CREATE TABLE prayer_session_config (
    session_config_id SERIAL PRIMARY KEY,
    user_profile_id INT NOT NULL REFERENCES user_profile(user_profile_id) ON DELETE CASCADE,
    name VARCHAR(100) NOT NULL,
    description TEXT,
    is_default BOOLEAN DEFAULT FALSE,
    datetime_create TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    datetime_update TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

COMMENT ON TABLE prayer_session_config IS 'Saved prayer session configurations. Users can create reusable sessions like "Morning Prayer" or "Small Group".';
COMMENT ON COLUMN prayer_session_config.session_config_id IS 'Unique identifier for the session configuration.';
COMMENT ON COLUMN prayer_session_config.user_profile_id IS 'Owner of this session configuration.';
COMMENT ON COLUMN prayer_session_config.name IS 'Name of the saved session (e.g., "Morning Prayer", "Small Group").';
COMMENT ON COLUMN prayer_session_config.description IS 'Optional description of the session.';
COMMENT ON COLUMN prayer_session_config.is_default IS 'If true, this session is the user default when starting a quick session.';
COMMENT ON COLUMN prayer_session_config.datetime_create IS 'Timestamp when the record was created.';
COMMENT ON COLUMN prayer_session_config.datetime_update IS 'Timestamp when the record was last updated.';

CREATE INDEX idx_session_config_user ON prayer_session_config(user_profile_id);

CREATE TRIGGER session_config_set_datetime_create
BEFORE INSERT ON prayer_session_config
FOR EACH ROW
EXECUTE PROCEDURE set_datetime_create();

CREATE TRIGGER session_config_set_datetime_update
BEFORE UPDATE ON prayer_session_config
FOR EACH ROW
EXECUTE PROCEDURE update_datetime_update();

CREATE TABLE prayer_session_config_detail (
    session_item_id SERIAL PRIMARY KEY,
    session_config_id INT NOT NULL REFERENCES prayer_session_config(session_config_id) ON DELETE CASCADE,
    prayer_subject_id INT REFERENCES prayer_subject(prayer_subject_id) ON DELETE CASCADE,
    prayer_id INT REFERENCES prayer(prayer_id) ON DELETE CASCADE,
    display_sequence INT DEFAULT 0,
    CONSTRAINT chk_session_item_type CHECK (
        (prayer_subject_id IS NOT NULL AND prayer_id IS NULL) OR
        (prayer_subject_id IS NULL AND prayer_id IS NOT NULL)
    )
);

COMMENT ON TABLE prayer_session_config_detail IS 'Items included in a saved prayer session. Can be either a prayer subject (person) or a specific prayer.';
COMMENT ON COLUMN prayer_session_config_detail.session_item_id IS 'Unique identifier for the session item.';
COMMENT ON COLUMN prayer_session_config_detail.session_config_id IS 'Parent session configuration this item belongs to.';
COMMENT ON COLUMN prayer_session_config_detail.prayer_subject_id IS 'If set, includes all prayers for this person/family/group in the session.';
COMMENT ON COLUMN prayer_session_config_detail.prayer_id IS 'If set, includes this specific prayer in the session.';
COMMENT ON COLUMN prayer_session_config_detail.display_sequence IS 'Order in which items appear within the session.';

CREATE INDEX idx_session_item_config ON prayer_session_config_detail(session_config_id);
CREATE INDEX idx_session_item_subject ON prayer_session_config_detail(prayer_subject_id);
CREATE INDEX idx_session_item_prayer ON prayer_session_config_detail(prayer_id);
CREATE INDEX idx_session_item_sequence ON prayer_session_config_detail(session_config_id, display_sequence);
