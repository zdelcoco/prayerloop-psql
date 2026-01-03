-- Migration: Create prayer_subject and prayer_subject_membership tables
-- Part of Person-Centric Prayer Model (v2026.1.1)

CREATE TABLE prayer_subject (
    prayer_subject_id SERIAL PRIMARY KEY,
    prayer_subject_type VARCHAR(20) NOT NULL CHECK (prayer_subject_type IN ('individual', 'family', 'group')),
    prayer_subject_display_name VARCHAR(255) NOT NULL,
    notes TEXT,
    display_sequence INT DEFAULT 0,
    photo_s3_key VARCHAR(500),
    user_profile_id INT REFERENCES user_profile(user_profile_id) ON DELETE SET NULL,
    use_linked_user_photo BOOLEAN DEFAULT TRUE,
    link_status VARCHAR(20) DEFAULT 'unlinked' CHECK (link_status IN ('unlinked', 'pending', 'linked', 'declined')),
    datetime_create TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    datetime_update TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    created_by INT NOT NULL REFERENCES user_profile(user_profile_id) ON DELETE CASCADE,
    updated_by INT REFERENCES user_profile(user_profile_id) ON DELETE SET NULL
);

COMMENT ON TABLE prayer_subject IS 'People, families, and groups that users pray for. Core table for person-centric prayer model.';
COMMENT ON COLUMN prayer_subject.prayer_subject_id IS 'Unique identifier for the prayer subject.';
COMMENT ON COLUMN prayer_subject.prayer_subject_type IS 'Type of subject: individual or group.';
COMMENT ON COLUMN prayer_subject.prayer_subject_display_name IS 'Display name for the subject (e.g., "John Smith", "The Smith Family").';
COMMENT ON COLUMN prayer_subject.notes IS 'Optional notes about the person/family/group.';
COMMENT ON COLUMN prayer_subject.display_sequence IS 'Order in which subjects appear in the user list.';
COMMENT ON COLUMN prayer_subject.photo_s3_key IS 'S3 object key for uploaded photo (not full URL).';
COMMENT ON COLUMN prayer_subject.user_profile_id IS 'Link to PrayerLoop user account (for connected users).';
COMMENT ON COLUMN prayer_subject.use_linked_user_photo IS 'When linked to a user, prefer their profile photo over uploaded photo.';
COMMENT ON COLUMN prayer_subject.link_status IS 'Connection status when linked to a PrayerLoop user: unlinked, pending, linked, declined.';
COMMENT ON COLUMN prayer_subject.datetime_create IS 'Timestamp when the record was created.';
COMMENT ON COLUMN prayer_subject.datetime_update IS 'Timestamp when the record was last updated.';
COMMENT ON COLUMN prayer_subject.created_by IS 'User ID of the creator of this record.';
COMMENT ON COLUMN prayer_subject.updated_by IS 'User ID of who last updated this record.';

CREATE INDEX idx_prayer_subject_created_by ON prayer_subject(created_by);
CREATE INDEX idx_prayer_subject_type ON prayer_subject(prayer_subject_type);
CREATE INDEX idx_prayer_subject_user_profile ON prayer_subject(user_profile_id);
CREATE INDEX idx_prayer_subject_display_sequence ON prayer_subject(created_by, display_sequence);

CREATE TRIGGER prayer_subject_set_datetime_create
BEFORE INSERT ON prayer_subject
FOR EACH ROW
EXECUTE PROCEDURE set_datetime_create();

CREATE TRIGGER prayer_subject_set_datetime_update
BEFORE UPDATE ON prayer_subject
FOR EACH ROW
EXECUTE PROCEDURE update_datetime_update();

CREATE TABLE prayer_subject_membership (
    prayer_subject_membership_id SERIAL PRIMARY KEY,
    member_prayer_subject_id INT NOT NULL REFERENCES prayer_subject(prayer_subject_id) ON DELETE CASCADE,
    group_prayer_subject_id INT NOT NULL REFERENCES prayer_subject(prayer_subject_id) ON DELETE CASCADE,
    membership_role VARCHAR(50),
    datetime_create TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    created_by INT NOT NULL REFERENCES user_profile(user_profile_id) ON DELETE CASCADE,
    CONSTRAINT unique_membership UNIQUE (member_prayer_subject_id, group_prayer_subject_id)
);

COMMENT ON TABLE prayer_subject_membership IS 'Links individual prayer subjects to family/group prayer subjects. Enables hierarchy.';
COMMENT ON COLUMN prayer_subject_membership.prayer_subject_membership_id IS 'Unique identifier for the membership record.';
COMMENT ON COLUMN prayer_subject_membership.member_prayer_subject_id IS 'The individual being added to a family/group.';
COMMENT ON COLUMN prayer_subject_membership.group_prayer_subject_id IS 'The family/group they belong to.';
COMMENT ON COLUMN prayer_subject_membership.membership_role IS 'Role within the group, e.g., parent, child, leader, member.';
COMMENT ON COLUMN prayer_subject_membership.datetime_create IS 'Timestamp when the record was created.';
COMMENT ON COLUMN prayer_subject_membership.created_by IS 'User ID of the creator of this record.';

CREATE INDEX idx_membership_member ON prayer_subject_membership(member_prayer_subject_id);
CREATE INDEX idx_membership_group ON prayer_subject_membership(group_prayer_subject_id);
