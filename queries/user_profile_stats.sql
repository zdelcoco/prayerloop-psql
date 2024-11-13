SELECT
  up.user_profile_id,
  up.username,
  us.days_active,
  us.active_streak,
  us.prayers_prayed
FROM
  user_profile up
  LEFT JOIN user_stats us ON up.user_profile_id = us.user_profile_id;