INSERT INTO
  "prayer" (
    prayer_type,
    title,
    prayer_description,
    is_private,
    is_answered,
    prayer_priority,
    created_by,
    updated_by
  )
VALUES
  (
    'request',
    'Prayer for Healing',
    'Requesting healing for a friend who is ill.',
    FALSE,
    FALSE,
    1,
    1,
    1
  ),
  (
    'request',
    'Prayer for Peace',
    'Praying for peace in the community.',
    FALSE,
    FALSE,
    2,
    1,
    1
  ),
  (
    'request',
    'Personal Strength',
    'Seeking strength during difficult times.',
    TRUE,
    FALSE,
    3,
    1,
    1
  ),
  (
    'praise',
    'Thanksgiving Prayer',
    'Giving thanks for blessings received.',
    FALSE,
    TRUE,
    0,
    1,
    1
  ),
  (
    'request',
    'Guidance Prayer',
    'Praying for guidance in decision making.',
    FALSE,
    FALSE,
    2,
    1,
    1
  ),
  (
    'request',
    'Family Protection',
    'Praying for the safety and protection of family.',
    TRUE,
    FALSE,
    1,
    1,
    1
  ),
  (
    'request',
    'Prayer for Unity',
    'Asking for unity among people.',
    FALSE,
    FALSE,
    2,
    1,
    1
  ),
  (
    'request',
    'Job Opportunity Prayer',
    'Praying for new job opportunities.',
    FALSE,
    FALSE,
    3,
    1,
    1
  ),
  (
    'request',
    'Confidential Prayer Request',
    'A personal request that is confidential.',
    TRUE,
    FALSE,
    0,
    1,
    1
  ),
  (
    'praise',
    'Prayer for the World',
    'Praying for global peace and understanding.',
    FALSE,
    FALSE,
    2,
    1,
    1
  );