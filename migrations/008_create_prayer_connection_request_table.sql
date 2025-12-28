-- Migration: Create prayer_connection_request table
-- Part of Person-Centric Prayer Model (v2026.1.1)

CREATE TABLE prayer_connection_request (
    request_id SERIAL PRIMARY KEY,
    requester_id INT NOT NULL REFERENCES user_profile(user_profile_id) ON DELETE CASCADE,
    target_user_id INT NOT NULL REFERENCES user_profile(user_profile_id) ON DELETE CASCADE,
    prayer_subject_id INT NOT NULL REFERENCES prayer_subject(prayer_subject_id) ON DELETE CASCADE,
    status VARCHAR(20) DEFAULT 'pending' CHECK (status IN ('pending', 'accepted', 'declined')),
    datetime_create TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    datetime_responded TIMESTAMP,
    CONSTRAINT unique_connection_request UNIQUE (requester_id, target_user_id, prayer_subject_id)
);

COMMENT ON TABLE prayer_connection_request IS 'Tracks requests to link prayer subjects to real PrayerLoop user accounts.';
COMMENT ON COLUMN prayer_connection_request.request_id IS 'Unique identifier for the connection request.';
COMMENT ON COLUMN prayer_connection_request.requester_id IS 'The user sending the connection request.';
COMMENT ON COLUMN prayer_connection_request.target_user_id IS 'The PrayerLoop user being requested to link.';
COMMENT ON COLUMN prayer_connection_request.prayer_subject_id IS 'The prayer subject being linked to the target user.';
COMMENT ON COLUMN prayer_connection_request.status IS 'Request status: pending (awaiting response), accepted (linked), declined (rejected).';
COMMENT ON COLUMN prayer_connection_request.datetime_create IS 'Timestamp when the request was created.';
COMMENT ON COLUMN prayer_connection_request.datetime_responded IS 'Timestamp when the target user accepted or declined the request.';

CREATE INDEX idx_connection_request_target ON prayer_connection_request(target_user_id, status);
CREATE INDEX idx_connection_request_requester ON prayer_connection_request(requester_id);
CREATE INDEX idx_connection_request_subject ON prayer_connection_request(prayer_subject_id);
