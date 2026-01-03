DROP TABLE IF EXISTS "prayer_session_config_detail" CASCADE;

CREATE TABLE IF NOT EXISTS "prayer_session_config_detail" (
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

/*** comments ***/
COMMENT ON TABLE "prayer_session_config_detail" IS 'Items included in a saved prayer session. Can be either a prayer subject (person) or a specific prayer.';
COMMENT ON COLUMN "prayer_session_config_detail".session_item_id IS 'Unique identifier for the session item.';
COMMENT ON COLUMN "prayer_session_config_detail".session_config_id IS 'Parent session configuration this item belongs to.';
COMMENT ON COLUMN "prayer_session_config_detail".prayer_subject_id IS 'If set, includes all prayers for this person/family/group in the session.';
COMMENT ON COLUMN "prayer_session_config_detail".prayer_id IS 'If set, includes this specific prayer in the session.';
COMMENT ON COLUMN "prayer_session_config_detail".display_sequence IS 'Order in which items appear within the session.';

/*** indexes ***/
CREATE INDEX IF NOT EXISTS idx_session_item_config ON "prayer_session_config_detail" (session_config_id);
CREATE INDEX IF NOT EXISTS idx_session_item_subject ON "prayer_session_config_detail" (prayer_subject_id);
CREATE INDEX IF NOT EXISTS idx_session_item_prayer ON "prayer_session_config_detail" (prayer_id);
CREATE INDEX IF NOT EXISTS idx_session_item_sequence ON "prayer_session_config_detail" (session_config_id, display_sequence);
