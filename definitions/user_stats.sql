DROP TABLE IF EXISTS "user_stats" CASCADE;

CREATE TABLE IF NOT EXISTS "user_stats" (
    user_stats_id SERIAL PRIMARY KEY, 
    user_profile_id INT NOT NULL, 
    days_active INT DEFAULT 0, 
    active_streak INT DEFAULT 0,  
    prayers_prayed INT DEFAULT 0,  
    time_prayed INTERVAL DEFAULT '0 seconds',     
    FOREIGN KEY (user_profile_id) REFERENCES "user_profile" (user_profile_id) 
);

/*** comments ***/
COMMENT ON TABLE "user_stats" IS 'This table stores statistics related to user activity and prayer engagement.';
COMMENT ON COLUMN "user_stats".user_stats_id IS 'Unique identifier for each user stats record.';
COMMENT ON COLUMN "user_stats".user_profile_id IS 'Foreign key referencing the associated user.';
COMMENT ON COLUMN "user_stats".days_active IS 'Total number of days the user has been active.';
COMMENT ON COLUMN "user_stats".active_streak IS 'Current streak of consecutive active days.';
COMMENT ON COLUMN "user_stats".prayers_prayed IS 'Total number of prayers prayed by the user.';
COMMENT ON COLUMN "user_stats".time_prayed IS 'Total time spent praying by the user.';

/*** indexes ***/
CREATE UNIQUE INDEX IF NOT EXISTS idx_user_stats_user_id ON "user_stats" (user_profile_id);

/*** functions ***/

/*** triggers ***/