SELECT
  p.prayer_id,
  p.datetime_create AS created_date,
  up.username AS created_by,
  pa.total_prayers AS total_times_prayed,
  pa.datetime_last_prayed AS last_prayed,
  (
    SELECT
      up2.username
    FROM
      prayer_access pa2
      JOIN user_profile up2 ON pa2.access_type_id = up2.user_profile_id
    WHERE
      pa2.prayer_id = p.prayer_id
      AND pa2.access_type = 'user'
    LIMIT
      1
  ) AS last_prayed_by,
  pa.num_unique_users AS number_of_users_prayed,
  pa.num_shares AS number_of_shares
FROM
  prayer p
  LEFT JOIN user_profile up ON p.created_by = up.user_profile_id
  LEFT JOIN prayer_analytics pa ON p.prayer_id = pa.prayer_id
WHERE
  p.prayer_id = 1;