SELECT
  p.prayer_id,
  p.title,
  p.description,
  pa.access_type,
  pa.access_type_id
FROM
  prayer p
  JOIN prayer_access pa ON p.prayer_id = pa.prayer_id
WHERE
  pa.access_type = 'group'
  AND pa.access_type_id = 1;