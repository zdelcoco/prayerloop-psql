DROP TABLE IF EXISTS "user_profile" CASCADE;

CREATE TABLE IF NOT EXISTS "user_profile" (
    user_profile_id SERIAL PRIMARY KEY, 
    username VARCHAR(255) NOT NULL UNIQUE, 
    password VARCHAR(255) NOT NULL, 
    email VARCHAR(255) UNIQUE, 
    first_name VARCHAR(255) NOT NULL,  
    last_name VARCHAR(255) NOT NULL, 
    datetime_create TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    datetime_update TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    created_by INT NOT NULL, 
    updated_by INT NOT NULL,  
    deleted BOOLEAN DEFAULT FALSE  
);

/*** comments ***/
COMMENT ON TABLE "user_profile" IS 'This table stores information about users in the application.';
COMMENT ON COLUMN "user_profile".user_profile_id IS 'Unique identifier for the user.';
COMMENT ON COLUMN "user_profile".username IS 'The user''s chosen username (must be unique).';
COMMENT ON COLUMN "user_profile".password IS 'The user''s password (hashed).';
COMMENT ON COLUMN "user_profile".email IS 'The user''s email address (optional).';
COMMENT ON COLUMN "user_profile".first_name IS 'The user''s first name.';
COMMENT ON COLUMN "user_profile".last_name IS 'The user''s last name.';
COMMENT ON COLUMN "user_profile".datetime_create IS 'Timestamp when the user record was created.';
COMMENT ON COLUMN "user_profile".datetime_update IS 'Timestamp when the user record was last updated.';
COMMENT ON COLUMN "user_profile".created_by IS 'User ID of the creator of this record.';
COMMENT ON COLUMN "user_profile".updated_by IS 'User ID of who last updated this record.';
COMMENT ON COLUMN "user_profile".deleted IS 'Indicates if the user account has been marked as deleted.';

/*** indexes ***/
CREATE UNIQUE INDEX IF NOT EXISTS idx_user_profile_username ON "user_profile" (username);
CREATE UNIQUE INDEX IF NOT EXISTS idx_user_profile_email ON "user_profile" (email);

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
BEFORE INSERT ON "user_profile"
FOR EACH ROW 
EXECUTE PROCEDURE set_datetime_create();

CREATE TRIGGER set_datetime_update
BEFORE UPDATE ON "user_profile"
FOR EACH ROW 
EXECUTE PROCEDURE update_datetime_update();