DROP TABLE IF EXISTS "prayer_session_detail" CASCADE;

CREATE TABLE IF NOT EXISTS "prayer_session_detail" (
    prayer_session_detail_id SERIAL PRIMARY KEY, 
    prayer_session_id INT NOT NULL, 
    prayer_id INT NOT NULL, 
    start_time TIMESTAMP NOT NULL,
    end_time TIMESTAMP,     
    FOREIGN KEY (prayer_session_id) REFERENCES "prayer_session" (prayer_session_id),  
    FOREIGN KEY (prayer_id) REFERENCES "prayer" (prayer_id) 
);

/*** comments ***/
COMMENT ON TABLE "prayer_session_detail" IS 'This table stores details of individual prayers within a prayer session.';
COMMENT ON COLUMN "prayer_session_detail".prayer_session_detail_id IS 'Unique identifier for each prayer session detail record.';
COMMENT ON COLUMN "prayer_session_detail".prayer_session_id IS 'Foreign key referencing the associated prayer session.';
COMMENT ON COLUMN "prayer_session_detail".prayer_id IS 'Foreign key referencing the associated prayer request.';
COMMENT ON COLUMN "prayer_session_detail".start_time IS 'Timestamp when the prayer session detail starts.';
COMMENT ON COLUMN "prayer_session_detail".end_time IS 'Timestamp when the prayer session detail ends (optional).';

/*** indexes ***/
CREATE INDEX IF NOT EXISTS idx_prayer_session_detail_prayer_session_id ON "prayer_session_detail" (prayer_session_id);
CREATE INDEX IF NOT EXISTS idx_prayer_session_detail_prayer_id ON "prayer_session_detail" (prayer_id);

/*** functions ***/

/*** triggers ***/