# Changelog

All notable changes to the Prayerloop database schema will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project uses a date-based versioning scheme: `[year].[month].[sequence]`
(e.g., 2025.11.3 is the third release in November 2025).

## [Unreleased]

### Planned

- Urgent prayer columns and tracking

## [2025.11.4] - 2025-11-20

- **Migration 006: Display Sequence Columns**

- Category tables for prayer organization

## [2025.11.3] - 2025-11-19

### Added

- **Migration 002: Display Sequence Columns**
  - Added `display_sequence` column to `prayer_access` table
    - Type: INTEGER
    - Default: 0
    - Allows user-defined ordering of prayers
  - Added `group_display_sequence` column to `user_group` table
    - Type: INTEGER
    - Default: 0
    - Allows per-user ordering of groups
  - Migration file: `migrations/005_add_display_sequence_to_prayer_access.sql`

### Changed

- **Versioning Convention** - Switched from semantic versioning to date-based versioning
  - Format: `[year].[month].[sequence]`
  - Aligns with backend and mobile app versioning

## [0.0.1] - 2025-11-17

### Added

- **Migration 003: Push Notification Tokens**
  - New table: `user_push_tokens`
    - `id` (SERIAL PRIMARY KEY)
    - `user_profile_id` (INTEGER, FK to user_profile)
    - `push_token` (VARCHAR(500), unique)
    - `platform` (VARCHAR(20), iOS/Android)
    - `created_at` (TIMESTAMP)
    - `updated_at` (TIMESTAMP)
  - Migration file: `migrations/003_add_user_push_tokens_table.sql`

- **Initial Database Schema**

#### Core Tables

- `user_profile` - User accounts and authentication
  - Columns: user_profile_id, username, email, password_hash, first_name, last_name, phone_number, email_verified, phone_verified, admin, created_by, updated_by, datetime_create, datetime_update, deleted
  - Indexes: username (unique), email (unique)

- `prayer` - Prayer entries
  - Columns: prayer_id, title, prayer_description, prayer_type, prayer_priority, is_private, is_answered, datetime_answered, user_profile_id, created_by, updated_by, datetime_create, datetime_update, deleted
  - Indexes: user_profile_id, is_private, is_answered

- `prayer_access` - Prayer permissions and sharing
  - Columns: prayer_access_id, prayer_id, user_profile_id, access_type, group_profile_id, created_by, updated_by, datetime_create, datetime_update, deleted
  - Indexes: prayer_id, user_profile_id, group_profile_id
  - Composite unique constraint: (prayer_id, user_profile_id, group_profile_id)

- `group_profile` - Prayer groups
  - Columns: group_id, group_name, group_description, is_active, created_by, updated_by, datetime_create, datetime_update, deleted
  - Indexes: created_by

- `user_group` - Group membership
  - Columns: user_group_id, user_profile_id, group_id, role, created_by, updated_by, datetime_create, datetime_update, deleted
  - Indexes: user_profile_id, group_id
  - Composite unique constraint: (user_profile_id, group_id)

- `group_invitation` - Group invitations
  - Columns: invitation_id, group_id, inviter_user_id, invitee_email, invitation_code, status, expires_at, created_at, updated_at
  - Indexes: invitation_code (unique), group_id, invitee_email, status
  - TTL: 7 days

#### Supporting Tables

- `user_preferences` - User settings and preferences
  - Columns: preference_id, user_profile_id, prayer_reminder_enabled, prayer_reminder_time, push_notifications_enabled, email_notifications_enabled, created_at, updated_at
  - Indexes: user_profile_id (unique)

- `prayer_session` - Prayer session tracking
  - Columns: session_id, user_profile_id, session_start, session_end, prayers_count, created_at
  - Indexes: user_profile_id, session_start

- `password_reset` - Password reset tokens
  - Columns: reset_id, user_profile_id, reset_code, expires_at, used, created_at
  - Indexes: user_profile_id, reset_code, expires_at
  - TTL: 15 minutes

- `prayer_analytics` - Prayer interaction analytics
  - Columns: analytics_id, prayer_id, user_profile_id, action_type, created_at
  - Indexes: prayer_id, user_profile_id, action_type, created_at

#### Constraints and Relationships

- Foreign keys with ON DELETE CASCADE for data integrity
- Check constraints for data validation
- Unique constraints to prevent duplicates
- NOT NULL constraints for required fields

#### Default Data

- System user (user_profile_id = 0) for system-generated content
- Default preferences for new users

### Security

- Row-level security policies (planned for future implementation)
- Encrypted sensitive data (password_hash via bcrypt)
- Audit columns (created_by, updated_by, datetime_create, datetime_update)
- Soft deletes (deleted column)

### Fixed

- Expanded `push_token` column from VARCHAR(255) to VARCHAR(500)
  - FCM tokens can be up to 500 characters

## Version History

- **2025.11.3** - Current release with display sequence columns
- **0.0.1** - Initial schema with core tables

---

## Migration Guide

### Applying Migrations

```bash
psql -h [host] \
     -U [user] -d [dbname] -f migrations/[migration_file].sql
```

### Migration Files

| Version | Migration File | Description |
|---------|---------------|-------------|
| 0.0.1 | `001_add_signup_fields_to_user_profile.sql` | User signup |
| 0.0.1 | `002_fix_user_preferences_column_name.sql` | User preferences |
| 0.0.1 | `003_add_user_push_tokens_table.sql` | Push tokens |
| 0.0.1 | `004_add_password_reset_tokens_table.sql` | Password reset |
| 2025.11.3 | `005_add_display_sequence_columns.sql` | Prayer/Group ordering |

### Rollback Procedures

Each migration should include a corresponding rollback script if needed:

- Backup database before applying migrations
- Test migrations on development environment first
- Document rollback steps in migration comments
