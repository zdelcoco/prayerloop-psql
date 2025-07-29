DROP TABLE IF EXISTS "preference" CASCADE;

CREATE TABLE IF NOT EXISTS "preference" (
    preference_id SERIAL PRIMARY KEY,
    preference_key VARCHAR(100) NOT NULL UNIQUE,
    default_value VARCHAR(500) NOT NULL,
    description TEXT,
    value_type VARCHAR(50) NOT NULL DEFAULT 'string', -- 'string', 'boolean', 'number'
    datetime_create TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    datetime_update TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    created_by INT NOT NULL DEFAULT 1,
    updated_by INT NOT NULL DEFAULT 1,
    is_active BOOLEAN DEFAULT TRUE
);

/*** comments ***/
COMMENT ON TABLE "preference" IS 'This table stores default preference values for the application.';
COMMENT ON COLUMN "preference".preference_key IS 'Unique key identifying the preference (e.g., notifications, theme).';
COMMENT ON COLUMN "preference".default_value IS 'Default value for this preference.';
COMMENT ON COLUMN "preference".description IS 'Human-readable description of what this preference controls.';
COMMENT ON COLUMN "preference".value_type IS 'Data type of the preference value (string, boolean, number).';
COMMENT ON COLUMN "preference".is_active IS 'Whether this preference is currently active/available.';

/*** indexes ***/
CREATE UNIQUE INDEX IF NOT EXISTS idx_preference_key ON "preference" (preference_key);
CREATE INDEX IF NOT EXISTS idx_preference_active ON "preference" (is_active);

/*** triggers ***/
CREATE TRIGGER set_datetime_create_preference_trigger
BEFORE INSERT ON "preference"
FOR EACH ROW 
EXECUTE PROCEDURE set_datetime_create();

CREATE TRIGGER set_datetime_update_preference_trigger
BEFORE UPDATE ON "preference"
FOR EACH ROW 
EXECUTE PROCEDURE update_datetime_update();