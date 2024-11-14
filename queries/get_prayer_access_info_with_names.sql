SELECT
  p.prayer_id,
  p.title,
  p.prayer_description,
  pa.access_type,
  CASE 
    WHEN pa.access_type = 'user' THEN up.username
    WHEN pa.access_type = 'group' THEN gp.group_name
    ELSE NULL
  END AS access_name
FROM
  prayer p
  LEFT JOIN prayer_access pa ON p.prayer_id = pa.prayer_id
  LEFT JOIN user_profile up ON pa.access_type = 'user' AND pa.access_type_id = up.user_profile_id
  LEFT JOIN group_profile gp ON pa.access_type = 'group' AND pa.access_type_id = gp.group_profile_id;