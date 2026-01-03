DROP TABLE IF EXISTS "prayer_subject_membership" CASCADE;

CREATE TABLE IF NOT EXISTS "prayer_subject_membership" (
    prayer_subject_membership_id SERIAL PRIMARY KEY,
    member_prayer_subject_id INT NOT NULL REFERENCES prayer_subject(prayer_subject_id) ON DELETE CASCADE,
    group_prayer_subject_id INT NOT NULL REFERENCES prayer_subject(prayer_subject_id) ON DELETE CASCADE,
    membership_role VARCHAR(50),
    datetime_create TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    created_by INT NOT NULL REFERENCES user_profile(user_profile_id) ON DELETE CASCADE,
    CONSTRAINT unique_membership UNIQUE (member_prayer_subject_id, group_prayer_subject_id)
);

/*** comments ***/
COMMENT ON TABLE "prayer_subject_membership" IS 'Links individual prayer subjects to family/group prayer subjects. Enables hierarchy.';
COMMENT ON COLUMN "prayer_subject_membership".prayer_subject_membership_id IS 'Unique identifier for the membership record.';
COMMENT ON COLUMN "prayer_subject_membership".member_prayer_subject_id IS 'The individual being added to a family/group.';
COMMENT ON COLUMN "prayer_subject_membership".group_prayer_subject_id IS 'The family/group they belong to.';
COMMENT ON COLUMN "prayer_subject_membership".membership_role IS 'Role within the group, e.g., parent, child, leader, member.';
COMMENT ON COLUMN "prayer_subject_membership".datetime_create IS 'Timestamp when the record was created.';
COMMENT ON COLUMN "prayer_subject_membership".created_by IS 'User ID of the creator of this record.';

/*** indexes ***/
CREATE INDEX IF NOT EXISTS idx_membership_member ON "prayer_subject_membership" (member_prayer_subject_id);
CREATE INDEX IF NOT EXISTS idx_membership_group ON "prayer_subject_membership" (group_prayer_subject_id);
