DROP TABLE IF EXISTS "group_profile" CASCADE;

CREATE TABLE IF NOT EXISTS "group_profile" (
    group_profile_id SERIAL PRIMARY KEY,
    group_name VARCHAR(255) NOT NULL,
    group_description VARCHAR(500),
    is_active BOOLEAN DEFAULT TRUE,
    datetime_create TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    datetime_update TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    created_by INT NOT NULL,
    updated_by INT NOT NULL,
    deleted BOOLEAN DEFAULT FALSE 
);

/*** comments ***/
COMMENT ON TABLE "group_profile" IS 'This table stores information about groups.';
COMMENT ON COLUMN "group_profile".group_profile_id IS 'Unique identifier for the group.';
COMMENT ON COLUMN "group_profile".group_name IS 'This field holds the name of the group.';
COMMENT ON COLUMN "group_profile".group_description IS 'Description of the group.';
COMMENT ON COLUMN "group_profile".is_active IS 'Indicates if the group is active.';
COMMENT ON COLUMN "group_profile".datetime_create IS 'Timestamp when the group was created.';
COMMENT ON COLUMN "group_profile".datetime_update IS 'Timestamp when the group was last updated.';
COMMENT ON COLUMN "group_profile".created_by IS 'User ID of the creator of the group.';
COMMENT ON COLUMN "group_profile".updated_by IS 'User ID of the last updater of the group.';
COMMENT ON COLUMN "group_profile".deleted IS 'Indicates if the group has been marked as deleted.';

/*** indexes ***/
CREATE UNIQUE INDEX IF NOT EXISTS idx_group_group_name ON "group_profile" (group_name, group_description);

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
BEFORE INSERT ON "group_profile"
FOR EACH ROW 
EXECUTE PROCEDURE set_datetime_create();

CREATE TRIGGER set_datetime_update
BEFORE UPDATE ON "group_profile"
FOR EACH ROW 
EXECUTE PROCEDURE update_datetime_update();