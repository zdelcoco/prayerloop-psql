INSERT INTO "prayer_subject" (
    prayer_subject_type,
    prayer_subject_display_name,
    notes,
    display_sequence,
    user_profile_id,
    link_status,
    created_by,
    updated_by
)
VALUES
    -- User 1's self subject (linked to their own account)
    ('individual', 'Admin User', NULL, 0, 1, 'linked', 1, 1),
    -- User 1's prayer subjects
    ('individual', 'Mom', 'Remember to call weekly', 1, NULL, 'unlinked', 1, 1),
    ('individual', 'John Smith', 'Small group leader', 2, 2, 'linked', 1, 1),
    ('family', 'The Johnson Family', 'Neighbors', 3, NULL, 'unlinked', 1, 1),
    ('group', 'Youth Group', 'Church youth ministry', 4, NULL, 'unlinked', 1, 1),

    -- User 2's self subject
    ('individual', 'FirstName1 LastName1', NULL, 0, 2, 'linked', 2, 2),
    -- User 2's prayer subjects
    ('individual', 'Dad', NULL, 1, NULL, 'unlinked', 2, 2),
    ('individual', 'Sarah Jones', 'College friend', 2, 3, 'pending', 2, 2),
    ('family', 'The Smith Family', NULL, 3, NULL, 'unlinked', 2, 2),

    -- User 3's self subject
    ('individual', 'FirstName2 LastName2', NULL, 0, 3, 'linked', 3, 3),
    -- User 3's prayer subjects
    ('individual', 'Brother Mike', 'Needs prayer for job search', 1, NULL, 'unlinked', 3, 3),
    ('group', 'Small Group Leaders', 'Church leadership team', 2, NULL, 'unlinked', 3, 3);
