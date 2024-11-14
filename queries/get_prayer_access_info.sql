SELECT
  p.prayer_id,
  p.title,
  p.prayer_description,
  pa.access_type,
  pa.access_type_id
FROM
  prayer p
  LEFT JOIN prayer_access pa ON p.prayer_id = pa.prayer_id;