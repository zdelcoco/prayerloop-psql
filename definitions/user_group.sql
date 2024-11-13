DROP TABLE IF EXISTS "user_group" CASCADE;

CREATE TABLE IF NOT EXISTS "user_group" (
    user_group_id SERIAL PRIMARY KEY, 
    user_profile_id INT NOT NULL, 
    group_profile_id INT NOT NULL, 
    is_active BOOLEAN DEFAULT TRUE, 
    datetime_create TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    datetime_update TIMESTAMP DEFAULT CURRENT_TIMESTAMP,  
    updated_by INT NOT NULL, 
    created_by INT NOT NULL,
    FOREIGN KEY (user_profile_id) REFERENCES "user_profile" (user_profile_id),  
    FOREIGN KEY (group_profile_id) REFERENCES "group_profile" (group_profile_id) 
);

/*** comments ***/
COMMENT ON TABLE "user_group" IS 'This table stores relationships between users and groups.';
COMMENT ON COLUMN "user_group".user_group_id IS 'Unique identifier for the user-group relationship.';
COMMENT ON COLUMN "user_group".user_profile_id IS 'ID of the user participating in the group.';
COMMENT ON COLUMN "user_group".group_profile_id IS 'ID of the group to which the user belongs.';
COMMENT ON COLUMN "user_group".is_active IS 'Indicates if the user-group relationship is active.';
COMMENT ON COLUMN "user_group".datetime_create IS 'Timestamp when the record was created.';
COMMENT ON COLUMN "user_group".datetime_update IS 'Timestamp when the record was last updated.';
COMMENT ON COLUMN "user_group".updated_by IS 'User ID of the last updater of this record.';
COMMENT ON COLUMN "user_group".created_by IS 'User ID of the creator of this record.';

/*** indexes ***/
CREATE UNIQUE INDEX IF NOT EXISTS idx_user_group_userid_groupid ON "user_group" (user_profile_id, group_profile_id);

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
BEFORE INSERT ON "user_group"
FOR EACH ROW 
EXECUTE PROCEDURE set_datetime_create();

CREATE TRIGGER set_datetime_update
BEFORE UPDATE ON "user_group"
FOR EACH ROW 
EXECUTE PROCEDURE update_datetime_update();