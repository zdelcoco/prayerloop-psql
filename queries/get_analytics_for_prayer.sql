SELECT
  pa.prayer_id,
  pa.total_prayers,
  pa.num_unique_users,
  pa.num_shares
FROM
  prayer_analytics pa
WHERE
  pa.prayer_id = 1;  -- change prayer_id