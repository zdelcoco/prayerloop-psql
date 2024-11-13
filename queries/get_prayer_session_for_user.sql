SELECT
  ps.prayer_session_id,
  ps.start_time,
  ps.end_time
FROM
  prayer_session ps
WHERE
  ps.user_profile_id = 1;  -- change user_profile_id