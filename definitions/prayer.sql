DROP TABLE IF EXISTS "prayer" CASCADE;

CREATE TABLE IF NOT EXISTS "prayer" (
    prayer_id SERIAL PRIMARY KEY,
    prayer_type varchar(20) NOT NULL,
    title VARCHAR(250) NOT NULL,
    prayer_description VARCHAR(3000),
    is_private BOOLEAN DEFAULT FALSE,
    is_answered BOOLEAN DEFAULT FALSE,
    prayer_priority INT DEFAULT 0,
    datetime_answered TIMESTAMP,
    datetime_create TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    datetime_update TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    created_by INT NOT NULL,
    updated_by INT NOT NULL,
    deleted BOOLEAN DEFAULT FALSE
);

/*** comments ***/
COMMENT ON TABLE "prayer" IS 'This table stores information about prayer.';
COMMENT ON COLUMN "prayer".prayer_id IS 'Unique identifier for each prayer request.';
COMMENT ON COLUMN "prayer".prayer_type IS 'Type of prayer (e.g., request, praise).';
COMMENT ON COLUMN "prayer".title IS 'Title of the prayer request.';
COMMENT ON COLUMN "prayer".prayer_description IS 'Detailed description of the prayer request.';
COMMENT ON COLUMN "prayer".is_private IS 'Indicates if the prayer request is private.';
COMMENT ON COLUMN "prayer".is_answered IS 'Indicates if the prayer has been answered.';
COMMENT ON COLUMN "prayer".prayer_priority IS 'Priority level of the prayer request.';
COMMENT ON COLUMN "prayer".datetime_answered IS 'Timestamp when the prayer was answered.';
COMMENT ON COLUMN "prayer".datetime_create IS 'Timestamp when the record was created.';
COMMENT ON COLUMN "prayer".datetime_update IS 'Timestamp when the record was last updated.';
COMMENT ON COLUMN "prayer".created_by IS 'User ID of the creator of this record.';
COMMENT ON COLUMN "prayer".updated_by IS 'User ID of who last updated this record.';
COMMENT ON COLUMN "prayer".deleted IS 'Indicates if the prayer request has been marked as deleted.';

/*** indexes ***/
CREATE INDEX IF NOT EXISTS idx_prayer_created_by ON "prayer" (created_by);

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
BEFORE INSERT ON "prayer"
FOR EACH ROW 
EXECUTE PROCEDURE set_datetime_create();

CREATE TRIGGER set_datetime_update
BEFORE UPDATE ON "prayer"
FOR EACH ROW 
EXECUTE PROCEDURE update_datetime_update();    