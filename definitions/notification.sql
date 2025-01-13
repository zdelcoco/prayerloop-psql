DROP TABLE IF EXISTS "notification" CASCADE;

CREATE TABLE IF NOT EXISTS "notification" (
    notification_id SERIAL PRIMARY KEY,
    user_profile_id INT NOT NULL,
    notification_type VARCHAR(50) NOT NULL,
    notification_message TEXT,
    notification_status VARCHAR(20) DEFAULT 'UNREAD',
    datetime_create TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    datetime_update TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_by INT NOT NULL,
    created_by INT NOT NULL,
    FOREIGN KEY (user_profile_id) REFERENCES "user_profile" (user_profile_id)
  );

/*** comments ***/
COMMENT ON TABLE "notification" IS 'This table stores notifications for users.';
COMMENT ON COLUMN "notification".notification_id IS 'Unique identifier for each notification.';
COMMENT ON COLUMN "notification".user_profile_id IS 'ID of the user receiving the notification.';
COMMENT ON COLUMN "notification".notification_type IS 'Type of notification (e.g., invitation, prayer request).';
COMMENT ON COLUMN "notification".notification_message IS 'Content of the notification.';
COMMENT ON COLUMN "notification".notification_status IS 'Status of the notification (e.g., read, unread).';
COMMENT ON COLUMN "notification".datetime_create IS 'Timestamp when the notification was created.';
COMMENT ON COLUMN "notification".datetime_update IS 'Timestamp when the notification was last updated.';
COMMENT ON COLUMN "notification".updated_by IS 'User ID of the last updater of this record.';
COMMENT ON COLUMN "notification".created_by IS 'User ID of the creator of this record.';

/*** indexes ***/
CREATE INDEX IF NOT EXISTS idx_notification_notification_id ON "notification" (notification_id);
CREATE INDEX IF NOT EXISTS idx_notification_user_type ON "notification" (user_profile_id, notification_type);
CREATE INDEX IF NOT EXISTS idx_notification_user_status ON "notification" (user_profile_id, notification_status);

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
BEFORE INSERT ON "notification"
FOR EACH ROW
EXECUTE PROCEDURE set_datetime_create();

CREATE TRIGGER set_datetime_update
BEFORE UPDATE ON "notification"
FOR EACH ROW
EXECUTE PROCEDURE update_datetime_update();
