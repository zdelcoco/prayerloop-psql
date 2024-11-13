INSERT INTO
  "prayer_analytics" (
    prayer_id,
    total_prayers,
    datetime_last_prayed,
    last_prayed_by,
    num_unique_users,
    num_shares
  )
VALUES
  (1, 5, NOW () - INTERVAL '1 day', 1, 3, 2),
  (2, 12, NOW () - INTERVAL '2 days', 2, 5, 3),
  (3, 8, NOW () - INTERVAL '3 days', 3, 4, 1),
  (4, 15, NOW () - INTERVAL '4 days', 4, 6, 0),
  (5, 20, NOW () - INTERVAL '5 days', 5, 7, 4),
  (6, 10, NOW () - INTERVAL '0 days', 6, 2, 1),
  (7, 7, NOW () - INTERVAL '7 days', NULL, 3, 0),
  (8, 25, NOW () - INTERVAL '8 days', NULL, 8, 5),
  (
    9,
    18,
    NOW () - INTERVAL '9 days',
    NULL,
    NULL,
    NULL
  ),
  (10, 30, NOW (), NULL, NULL, NULL);