DROP TABLE IF EXISTS "prayer_access" CASCADE;

CREATE TABLE IF NOT EXISTS "prayer_access" (
    prayer_access_id SERIAL PRIMARY KEY, 
    prayer_id INT NOT NULL,
    access_type VARCHAR(5) NOT NULL, 
    access_type_id INT NOT NULL,
    datetime_create TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    datetime_update TIMESTAMP DEFAULT CURRENT_TIMESTAMP, 
    created_by INT NOT NULL,
    updated_by INT NOT NULL,
    FOREIGN KEY (prayer_id) REFERENCES "prayer" (prayer_id)
);

/*** comments ***/
COMMENT ON TABLE "prayer_access" IS 'This table stores access records for prayer requests.';
COMMENT ON COLUMN "prayer_access".prayer_access_id IS 'Unique identifier for each prayer access record.';
COMMENT ON COLUMN "prayer_access".prayer_id IS 'Foreign key referencing the prayer request.';
COMMENT ON COLUMN "prayer_access".access_type IS 'Type of access (e.g., ''user'', ''group'').';
COMMENT ON COLUMN "prayer_access".access_type_id IS 'ID value of the associated type (e.g., if access_type is user, then use user.user_profile_id value).';
COMMENT ON COLUMN "prayer_access".datetime_create IS 'Timestamp when the record was created.';
COMMENT ON COLUMN "prayer_access".datetime_update IS 'Timestamp when the record was last updated.';
COMMENT ON COLUMN "prayer_access".created_by IS 'User ID of the creator of this record.';
COMMENT ON COLUMN "prayer_access".updated_by IS 'User ID of who last updated this record.';

/*** indexes ***/
CREATE UNIQUE INDEX IF NOT EXISTS idx_prayer_access_type_id ON "prayer_access" (prayer_id, access_type, access_type_id);
CREATE INDEX IF NOT EXISTS idx_prayer_access_prayer_id ON "prayer_access" (prayer_id);

/*** functions ***/
CREATE OR REPLACE FUNCTION set_datetime_create()
RETURNS TRIGGER AS $$
BEGIN
    NEW.datetime_create = CURRENT_TIMESTAMP;
    RETURN NEW; 
END;
$$

LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION update_datetime_update()
RETURNS TRIGGER AS $$
BEGIN
    NEW.datetime_update = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$

LANGUAGE plpgsql;

/*** triggers ***/
CREATE TRIGGER set_datetime_create_trigger
BEFORE INSERT ON "prayer_access"
FOR EACH ROW 
EXECUTE PROCEDURE set_datetime_create();

CREATE TRIGGER set_datetime_update
BEFORE UPDATE ON "prayer_access"
FOR EACH ROW 
EXECUTE PROCEDURE update_datetime_update();