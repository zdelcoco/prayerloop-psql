SELECT
  gp.group_name,
  COUNT(pa.prayer_id) AS total_prayers
FROM
  group_profile gp
  LEFT JOIN user_group ug ON gp.group_profile_id = ug.group_profile_id
  LEFT JOIN prayer_access pa ON ug.user_profile_id = pa.access_type_id
GROUP BY
  gp.group_name;