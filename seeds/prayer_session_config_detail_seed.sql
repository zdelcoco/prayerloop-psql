INSERT INTO "prayer_session_config_detail" (
    session_config_id,
    prayer_subject_id,
    prayer_id,
    display_sequence
)
VALUES
    -- Morning Prayer session (session_config_id = 1) - User 1
    (1, 1, NULL, 0),      -- Self
    (1, 2, NULL, 1),      -- Mom
    (1, NULL, 1, 2),      -- Prayer for Healing

    -- Small Group session (session_config_id = 2) - User 1
    (2, 3, NULL, 0),      -- John Smith
    (2, 5, NULL, 1),      -- Youth Group
    (2, NULL, 2, 2),      -- Prayer for Peace

    -- Family Focus session (session_config_id = 3) - User 1
    (3, 2, NULL, 0),      -- Mom
    (3, 4, NULL, 1),      -- The Johnson Family
    (3, NULL, 6, 2),      -- Family Protection

    -- Daily Prayers session (session_config_id = 4) - User 2
    (4, 6, NULL, 0),      -- Self (User 2)
    (4, 7, NULL, 1),      -- Dad
    (4, 8, NULL, 2),      -- Sarah Jones

    -- Friends & Family session (session_config_id = 5) - User 2
    (5, 9, NULL, 0),      -- The Smith Family
    (5, 7, NULL, 1),      -- Dad

    -- Leadership Prayers session (session_config_id = 6) - User 3
    (6, 12, NULL, 0),     -- Small Group Leaders
    (6, 11, NULL, 1);     -- Brother Mike
