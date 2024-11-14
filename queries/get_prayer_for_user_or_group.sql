-- less efficient, but lower cost
SELECT DISTINCT
  ON (user_profile_id) CASE
    WHEN pa.access_type = 'user' THEN pa.access_type_id
    WHEN pa.access_type = 'group' THEN ug.user_profile_id
    ELSE NULL
  END AS user_profile_id,
  p.prayer_id,
  p.prayer_type,
  p.is_private,
  p.title,
  p.prayer_description,
  p.is_answered,
  p.prayer_priority,
  p.datetime_answered,
  p.created_by,
  p.datetime_create,
  p.updated_by,
  p.datetime_update,
  p.deleted,
  pa.access_type,
  pa.access_type_id
FROM
  prayer p
  LEFT JOIN prayer_access pa ON p.prayer_id = pa.prayer_id
  LEFT JOIN user_profile up ON pa.access_type = 'user'
  AND pa.access_type_id = up.user_profile_id
  LEFT JOIN user_group ug ON pa.access_type = 'group'
  AND pa.access_type_id = ug.group_profile_id
WHERE
  p.prayer_id = 2
ORDER BY
  user_profile_id,
  pa.access_type;

--  Unique  (cost=48.59..48.62 rows=5 width=1165) (actual time=0.773..0.778 rows=4 loops=1)
--    ->  Sort  (cost=48.59..48.60 rows=5 width=1165) (actual time=0.772..0.774 rows=6 loops=1)
--          Sort Key: (CASE WHEN ((pa.access_type)::text = 'user'::text) THEN pa.access_type_id WHEN ((pa.access_type)::text = 'group'::text) THEN ug.user_profile_id ELSE NULL::integer END), pa.access_type
--          Sort Method: quicksort  Memory: 25kB
--          ->  Nested Loop Left Join  (cost=12.87..48.53 rows=5 width=1165) (actual time=0.727..0.741 rows=6 loops=1)
--                ->  Index Scan using prayer_pkey on prayer p  (cost=0.14..8.16 rows=1 width=1133) (actual time=0.486..0.487 rows=1 loops=1)
--                      Index Cond: (prayer_id = 2)
--                ->  Hash Right Join  (cost=12.72..40.30 rows=5 width=36) (actual time=0.236..0.247 rows=6 loops=1)
--                      Hash Cond: (ug.group_profile_id = pa.access_type_id)
--                      Join Filter: ((pa.access_type)::text = 'group'::text)
--                      Rows Removed by Join Filter: 7
--                      ->  Seq Scan on user_group ug  (cost=0.00..22.50 rows=1250 width=8) (actual time=0.035..0.036 rows=11 loops=1)
--                      ->  Hash  (cost=12.66..12.66 rows=5 width=32) (actual time=0.181..0.182 rows=4 loops=1)
--                            Buckets: 1024  Batches: 1  Memory Usage: 9kB
--                            ->  Bitmap Heap Scan on prayer_access pa  (cost=4.19..12.66 rows=5 width=32) (actual time=0.061..0.062 rows=4 loops=1)
--                                  Recheck Cond: (prayer_id = 2)
--                                  Heap Blocks: exact=1
--                                  ->  Bitmap Index Scan on idx_prayer_access_prayer_id  (cost=0.00..4.19 rows=5 width=0) (actual time=0.038..0.038 rows=4 loops=1)
--                                        Index Cond: (prayer_id = 2)
--  Planning Time: 0.647 ms
--  Execution Time: 0.958 ms
-- (21 rows)



-- more efficient, but higher cost (used in GetPrayerRequest method)
SELECT DISTINCT
  ON (user_profile_id) CASE
    WHEN pa.access_type = 'user' THEN pa.access_type_id
    WHEN pa.access_type = 'group' THEN ug.user_profile_id
    ELSE NULL
  END AS user_profile_id,
  p.prayer_id,
  p.prayer_type,
  p.is_private,
  p.title,
  p.prayer_description,
  p.is_answered,
  p.prayer_priority,
  p.datetime_answered,
  p.created_by,
  p.datetime_create,
  p.updated_by,
  p.datetime_update,
  p.deleted,
  pa.access_type,
  pa.access_type_id
FROM
  prayer p
  LEFT JOIN prayer_access pa ON p.prayer_id = pa.prayer_id
  LEFT JOIN user_group ug ON (
    pa.access_type = 'group'
    AND pa.access_type_id = ug.group_profile_id
  )
  OR (
    pa.access_type = 'user'
    AND pa.access_type_id = ug.user_profile_id
  )
WHERE
  p.prayer_id = 2
ORDER BY
  user_profile_id,
  pa.access_type;

-- Unique  (cost=113.42..113.44 rows=5 width=1165) (actual time=0.120..0.125 rows=4 loops=1)
-- ->  Sort  (cost=113.42..113.43 rows=5 width=1165) (actual time=0.119..0.121 rows=9 loops=1)
--       Sort Key: (CASE WHEN ((pa.access_type)::text = 'user'::text) THEN pa.access_type_id WHEN ((pa.access_type)::text = 'group'::text) THEN ug.user_profile_id ELSE NULL::integer END), pa.access_type
--       Sort Method: quicksort  Memory: 26kB
--       ->  Nested Loop Left Join  (cost=17.26..113.36 rows=5 width=1165) (actual time=0.075..0.096 rows=9 loops=1)
--             ->  Nested Loop Left Join  (cost=4.33..20.87 rows=5 width=1161) (actual time=0.054..0.056 rows=4 loops=1)
--                   ->  Index Scan using prayer_pkey on prayer p  (cost=0.14..8.16 rows=1 width=1133) (actual time=0.036..0.037 rows=1 loops=1)
--                         Index Cond: (prayer_id = 2)
--                   ->  Bitmap Heap Scan on prayer_access pa  (cost=4.19..12.66 rows=5 width=32) (actual time=0.011..0.012 rows=4 loops=1)
--                         Recheck Cond: (prayer_id = 2)
--                         Heap Blocks: exact=1
--                         ->  Bitmap Index Scan on idx_prayer_access_prayer_id  (cost=0.00..4.19 rows=5 width=0) (actual time=0.006..0.007 rows=4 loops=1)
--                               Index Cond: (prayer_id = 2)
--             ->  Bitmap Heap Scan on user_group ug  (cost=12.93..18.48 rows=1 width=8) (actual time=0.007..0.008 rows=2 loops=4)
--                   Recheck Cond: ((pa.access_type_id = group_profile_id) OR (pa.access_type_id = user_profile_id))
--                   Filter: ((((pa.access_type)::text = 'group'::text) AND (pa.access_type_id = group_profile_id)) OR (((pa.access_type)::text = 'user'::text) AND (pa.access_type_id = user_profile_id)))
--                   Rows Removed by Filter: 2
--                   Heap Blocks: exact=4
--                   ->  BitmapOr  (cost=12.93..12.93 rows=12 width=0) (actual time=0.005..0.005 rows=0 loops=4)
--                         ->  Bitmap Index Scan on idx_user_group_userid_groupid  (cost=0.00..11.13 rows=6 width=0) (actual time=0.003..0.003 rows=2 loops=4)
--                               Index Cond: (group_profile_id = pa.access_type_id)
--                         ->  Bitmap Index Scan on idx_user_group_userid_groupid  (cost=0.00..1.80 rows=6 width=0) (actual time=0.001..0.001 rows=2 loops=4)
--                               Index Cond: (user_profile_id = pa.access_type_id)
-- Planning Time: 0.269 ms
-- Execution Time: 0.210 ms
-- (25 rows)