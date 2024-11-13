INSERT INTO
  "prayer_session" (user_profile_id, start_time, end_time)
VALUES
  (
    1,
    NOW () - INTERVAL '1 hour',
    NOW () - INTERVAL '30 minutes'
  ),
  (
    1,
    NOW () - INTERVAL '2 hours',
    NOW () - INTERVAL '1 hour'
  ),
  (
    2,
    NOW () - INTERVAL '3 hours',
    NOW () - INTERVAL '2 hours'
  ),
  (3, NOW () - INTERVAL '4 hours', NULL),
  (
    4,
    NOW () - INTERVAL '5 hours',
    NOW () - INTERVAL '4 hours'
  ),
  (5, NOW () - INTERVAL '6 hours', NULL),
  (
    6,
    NOW () - INTERVAL '7 hours',
    NOW () - INTERVAL '6 hours'
  ),
  (
    7,
    NOW () - INTERVAL '8 hours',
    NOW () - INTERVAL '7 hours'
  ),
  (8, NOW () - INTERVAL '9 hours', NULL),
  (
    9,
    NOW () - INTERVAL '10 hours',
    NOW () - INTERVAL '9 hours'
  );