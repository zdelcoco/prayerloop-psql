INSERT INTO
    "prayer_session_detail" (
        prayer_session_id,
        prayer_id,
        start_time,
        end_time
    )
VALUES
    -- Details for User 1's first session (30 minutes total)
    (
        1,
        1,
        NOW () - INTERVAL '1 hour',
        NOW () - INTERVAL '45 minutes'
    ), -- 15 minutes
    (
        1,
        2,
        NOW () - INTERVAL '45 minutes',
        NOW () - INTERVAL '30 minutes'
    ), -- 15 minutes
    -- Details for User 1's second session (60 minutes total)
    (
        2,
        3,
        NOW () - INTERVAL '2 hours',
        NOW () - INTERVAL '1 hour'
    ), -- 30 minutes
    (
        2,
        4,
        NOW () - INTERVAL '1 hour',
        NOW () - INTERVAL '30 minutes'
    ), -- 30 minutes
    -- Details for User 2's session (60 minutes total)
    (
        3,
        5,
        NOW () - INTERVAL '3 hours',
        NOW () - INTERVAL '2 hours'
    ), -- 30 minutes
    (
        3,
        6,
        NOW () - INTERVAL '2 hours',
        NOW () - INTERVAL '1 hour 30 minutes'
    ), -- 30 minutes
    -- Details for User 3's session (ongoing)
    (4, 7, NOW () - INTERVAL '4 hours', NULL), -- Ongoing session
    -- Details for User 4's session (60 minutes total)
    (
        5,
        8,
        NOW () - INTERVAL '5 hours',
        NOW () - INTERVAL '4 hours'
    ), -- 30 minutes
    (
        5,
        9,
        NOW () - INTERVAL '4 hours',
        NOW () - INTERVAL '3 hours'
    ), -- 30 minutes
    -- Details for User 6's session (60 minutes total)
    (
        6,
        10,
        NOW () - INTERVAL '6 hours',
        NOW () - INTERVAL '5 hours'
    ), -- 30 minutes
    (
        6,
        1,
        NOW () - INTERVAL '5 hours',
        NOW () - INTERVAL '4 hours'
    );

-- 30 minutes