DROP TABLE IF EXISTS "prayer_analytics" CASCADE;

CREATE TABLE IF NOT EXISTS "prayer_analytics" (
    prayer_analytics_id SERIAL PRIMARY KEY, 
    prayer_id INT NOT NULL,
    total_prayers INT DEFAULT 0,
    datetime_last_prayed TIMESTAMP, 
    last_prayed_by INT, 
    num_unique_users INT DEFAULT 0,
    num_shares INT DEFAULT 0,    
    FOREIGN KEY (prayer_id) REFERENCES "prayer" (prayer_id)
);

/*** comments ***/
COMMENT ON TABLE "prayer_analytics" IS 'This table stores analytics data related to prayer requests.';
COMMENT ON COLUMN "prayer_analytics".prayer_analytics_id IS 'Unique identifier for each prayer analytics record.';
COMMENT ON COLUMN "prayer_analytics".prayer_id IS 'Foreign key referencing the associated prayer request.';
COMMENT ON COLUMN "prayer_analytics".total_prayers IS 'Total number of prayers for this request.';
COMMENT ON COLUMN "prayer_analytics".datetime_last_prayed IS 'Timestamp of the last time this prayer was prayed.';
COMMENT ON COLUMN "prayer_analytics".last_prayed_by IS 'User ID of the last user who prayed for this request.';
COMMENT ON COLUMN "prayer_analytics".num_unique_users IS 'Number of unique users who have prayed for this request.';
COMMENT ON COLUMN "prayer_analytics".num_shares IS 'Number of times this prayer request has been shared.';

/*** indexes ***/
CREATE INDEX IF NOT EXISTS idx_prayer_analytics_prayer_id ON "prayer_analytics" (prayer_id);

/*** functions ***/

/*** triggers ***/