DROP TABLE IF EXISTS "group_invite" CASCADE;

CREATE TABLE group_invite (
    group_invite_id SERIAL PRIMARY KEY,
    group_profile_id INT NOT NULL,
    invite_code VARCHAR(50) UNIQUE NOT NULL,
    datetime_create TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    datetime_update TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    created_by INT NOT NULL,
    updated_by INT NOT NULL,
    datetime_expires TIMESTAMP, 
    is_active BOOLEAN DEFAULT TRUE,
    FOREIGN KEY (group_profile_id) REFERENCES group_profile(group_profile_id) ON DELETE CASCADE
);

/*** comments ***/
COMMENT ON TABLE group_invite IS 'This table stores information about group invites.';
COMMENT ON COLUMN group_invite.group_invite_id IS 'Unique identifier for the group invite.';
COMMENT ON COLUMN group_invite.group_profile_id IS 'Unique identifier for the group.';
COMMENT ON COLUMN group_invite.invite_code IS 'Unique code for the invite.';
COMMENT ON COLUMN group_invite.datetime_create IS 'Timestamp when the invite was created.';
COMMENT ON COLUMN group_invite.datetime_update IS 'Timestamp when the invite was last updated.';
COMMENT ON COLUMN group_invite.created_by IS 'User ID of the creator of the invite.';
COMMENT ON COLUMN group_invite.updated_by IS 'User ID of the last updater of the invite.';
COMMENT ON COLUMN group_invite.datetime_expires IS 'Timestamp when the invite expires.';
COMMENT ON COLUMN group_invite.is_active IS 'Indicates if the invite is active.  Used for revoking invites.';

/*** indexes ***/
CREATE UNIQUE INDEX IF NOT EXISTS idx_group_invite_code ON group_invite(invite_code);
CREATE INDEX idx_group_invite_group_profile_id ON group_invite(group_profile_id);


/*** functions ***/
CREATE OR REPLACE FUNCTION set_default_datetime_expires()
RETURNS TRIGGER AS $$
BEGIN
  IF NEW.datetime_expires IS NULL THEN
    NEW.datetime_expires := NEW.datetime_create + INTERVAL '30 days';
  END IF;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

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
CREATE TRIGGER set_datetime_expires_before_insert
BEFORE INSERT ON "group_invite"
FOR EACH ROW
EXECUTE FUNCTION set_default_datetime_expires();

CREATE TRIGGER set_datetime_create_trigger
BEFORE INSERT ON "group_invite"
FOR EACH ROW 
EXECUTE PROCEDURE set_datetime_create();

CREATE TRIGGER set_datetime_update
BEFORE UPDATE ON "group_invite"
FOR EACH ROW 
EXECUTE PROCEDURE update_datetime_update();