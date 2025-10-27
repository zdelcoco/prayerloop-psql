-- Purpose: This file is used to initialize the database schema and
--          seed the database with initial test data.

-- create the tables
\i './definitions/user_profile.sql'
\i './definitions/group_profile.sql'
\i './definitions/user_group.sql'
\i './definitions/prayer.sql'
\i './definitions/prayer_access.sql'
\i './definitions/prayer_analytics.sql'
\i './definitions/prayer_session.sql'
\i './definitions/prayer_session_detail.sql'
\i './definitions/user_stats.sql'
\i './definitions/notification.sql'
\i './definitions/group_invite.sql'
\i './definitions/preference.sql'
\i './definitions/user_preferences.sql'
\i './definitions/user_push_tokens.sql'
\i './definitions/password_reset_tokens.sql'

-- seed the tables
\i './seeds/user_profile_seed.sql'
\i './seeds/group_profile_seed.sql'
\i './seeds/user_group_seed.sql'
\i './seeds/prayer_seed.sql'
\i './seeds/prayer_access_seed.sql'
\i './seeds/prayer_analytics_seed.sql'
\i './seeds/prayer_session_seed.sql'
\i './seeds/prayer_session_detail_seed.sql'
\i './seeds/user_stats_seed.sql'
\i './seeds/notification_seed.sql'
\i './seeds/group_invite_seed.sql'
\i './seeds/preference_seed.sql'
\i './seeds/user_preferences_seed.sql'
