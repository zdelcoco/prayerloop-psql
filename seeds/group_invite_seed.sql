INSERT INTO
  "group_invite" (
    group_profile_id,
    invite_code,
    created_by,
    updated_by,
    datetime_expires,
    is_active
  )
VALUES
  (
    1,
    'admin-group-1',
    1,
    1,
    CURRENT_TIMESTAMP + INTERVAL '1 day',
    TRUE
  ),
  (
    2,
    'user-group-1',
    1,
    1,
    CURRENT_TIMESTAMP + INTERVAL '30 days',
    FALSE
  ),
  (
    3,
    'prayer-group-1',
    1,
    1,
    CURRENT_TIMESTAMP,
    TRUE
  ),
  (
    4,
    'study-group-1',
    1,
    1,
    NULL,
    TRUE
  ),
  (
    5,
    'event-organizers-1',
    1,
    1,
    CURRENT_TIMESTAMP + INTERVAL '30 days',
    TRUE
  ),
  (
    6,
    'feedback-group-1',
    1,
    1,
    CURRENT_TIMESTAMP + INTERVAL '30 days',
    TRUE
  ),
  (
    7,
    'volunteer-team-1',
    1,
    1,
    CURRENT_TIMESTAMP + INTERVAL '30 days',
    TRUE
  ),
  (
    8,
    'sports-club-1',
    1,
    1,
    CURRENT_TIMESTAMP + INTERVAL '30 days',
    TRUE
  );
