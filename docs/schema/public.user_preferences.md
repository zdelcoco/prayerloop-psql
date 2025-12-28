# public.user_preferences

## Description

User-specific preference values

## Columns

| Name                | Type                        | Default                                                       | Nullable | Children | Parents                                       | Comment                                                                                              |
| ------------------- | --------------------------- | ------------------------------------------------------------- | -------- | -------- | --------------------------------------------- | ---------------------------------------------------------------------------------------------------- |
| datetime_create     | timestamp without time zone | CURRENT_TIMESTAMP                                             | true     |          |                                               | Timestamp when the preference was created.                                                           |
| datetime_update     | timestamp without time zone | CURRENT_TIMESTAMP                                             | true     |          |                                               | Timestamp when the preference was last updated.                                                      |
| is_active           | boolean                     | true                                                          | true     |          |                                               | Indicates if the preference is active. This can be used to disable a preference without deleting it. |
| preference_key      | varchar(50)                 |                                                               | false    |          |                                               | The key for the preference setting (e.g., theme, notifications).                                     |
| preference_value    | text                        |                                                               | true     |          |                                               | The value for the preference setting (e.g., dark mode, true/false).                                  |
| user_preferences_id | integer                     | nextval('user_preferences_user_preferences_id_seq'::regclass) | false    |          |                                               | Unique identifier for the user preference entry.                                                     |
| user_profile_id     | integer                     |                                                               | false    |          | [public.user_profile](public.user_profile.md) | Unique identifier for the user.                                                                      |

## Constraints

| Name                                  | Type        | Definition                                                                               |
| ------------------------------------- | ----------- | ---------------------------------------------------------------------------------------- |
| user_preferences_pkey                 | PRIMARY KEY | PRIMARY KEY (user_preferences_id)                                                        |
| user_preferences_user_profile_id_fkey | FOREIGN KEY | FOREIGN KEY (user_profile_id) REFERENCES user_profile(user_profile_id) ON DELETE CASCADE |

## Indexes

| Name                                     | Definition                                                                                                                     |
| ---------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------ |
| idx_user_preferences_preference_key      | CREATE INDEX idx_user_preferences_preference_key ON public.user_preferences USING btree (preference_key)                       |
| idx_user_preferences_user_preference_key | CREATE INDEX idx_user_preferences_user_preference_key ON public.user_preferences USING btree (user_profile_id, preference_key) |
| idx_user_preferences_user_profile_id     | CREATE INDEX idx_user_preferences_user_profile_id ON public.user_preferences USING btree (user_profile_id)                     |
| user_preferences_pkey                    | CREATE UNIQUE INDEX user_preferences_pkey ON public.user_preferences USING btree (user_preferences_id)                         |

## Triggers

| Name                        | Definition                                                                                                                                 |
| --------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------ |
| set_datetime_create_trigger | CREATE TRIGGER set_datetime_create_trigger BEFORE INSERT ON public.user_preferences FOR EACH ROW EXECUTE FUNCTION set_datetime_create()    |
| set_datetime_update_trigger | CREATE TRIGGER set_datetime_update_trigger BEFORE UPDATE ON public.user_preferences FOR EACH ROW EXECUTE FUNCTION update_datetime_update() |

## Relations

```mermaid
erDiagram

"public.user_preferences" }o--|| "public.user_profile" : "FOREIGN KEY (user_profile_id) REFERENCES user_profile(user_profile_id) ON DELETE CASCADE"

"public.user_preferences" {
  timestamp_without_time_zone datetime_create "Timestamp when the preference was created."
  timestamp_without_time_zone datetime_update "Timestamp when the preference was last updated."
  boolean is_active "Indicates if the preference is active. This can be used to disable a preference without deleting it."
  varchar_50_ preference_key "The key for the preference setting (e.g., theme, notifications)."
  text preference_value "The value for the preference setting (e.g., dark mode, true/false)."
  integer user_preferences_id "Unique identifier for the user preference entry."
  integer user_profile_id FK "Unique identifier for the user."
}
"public.user_profile" {
  boolean admin "Indicates if the user has admin privileges."
  integer created_by "User ID of the creator of this record."
  timestamp_without_time_zone datetime_create "Timestamp when the user record was created."
  timestamp_without_time_zone datetime_update "Timestamp when the user record was last updated."
  boolean deleted "Indicates if the user account has been marked as deleted."
  varchar_255_ email "The user's email address (optional)."
  boolean email_verified "Indicates if the user's email has been verified."
  varchar_255_ first_name "The user's first name."
  varchar_255_ last_name "The user's last name."
  varchar_255_ password "The user's password (hashed)."
  varchar_20_ phone_number "The user's phone number (optional)."
  boolean phone_verified "Indicates if the user's phone number has been verified."
  integer updated_by "User ID of who last updated this record."
  integer user_profile_id "Unique identifier for the user."
  varchar_255_ username "The user's chosen username (must be unique)."
  varchar_255_ verification_token "Token used for email/phone verification."
}
```

---

> Generated by [tbls](https://github.com/k1LoW/tbls)
