INSERT INTO "prayer_subject_membership" (
    member_prayer_subject_id,
    group_prayer_subject_id,
    membership_role,
    created_by
)
VALUES
    -- Members of The Johnson Family (prayer_subject_id = 4)
    (2, 4, 'parent', 1),      -- Mom is parent in Johnson Family

    -- Members of Youth Group (prayer_subject_id = 5)
    (3, 5, 'leader', 1),      -- John Smith is youth group leader

    -- Members of The Smith Family (prayer_subject_id = 9)
    (8, 9, 'member', 2),      -- Sarah Jones is in Smith Family

    -- Members of Small Group Leaders (prayer_subject_id = 12)
    (3, 12, 'leader', 3),     -- John Smith is a small group leader
    (11, 12, 'member', 3);    -- Brother Mike is in small group leaders
