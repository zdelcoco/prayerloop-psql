select distinct on (prayer.prayer_id)
  prayer.prayer_id,
  prayer.title
from
  prayer_access
  join user_group on (
    prayer_access.access_type = 'group'
    and prayer_access.access_type_id = user_group.group_profile_id
  )
  or (
    prayer_access.access_type = 'user'
    and prayer_access.access_type_id = user_group.user_profile_id
  )
  join prayer on prayer_access.prayer_id = prayer.prayer_id
where
  user_group.user_profile_id = 1;