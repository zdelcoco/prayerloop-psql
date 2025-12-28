# public.user_group

## Description

User-to-group membership

## Columns

| Name                   | Type                        | Default                                           | Nullable | Children | Parents                                         | Comment                                                                                             |
| ---------------------- | --------------------------- | ------------------------------------------------- | -------- | -------- | ----------------------------------------------- | --------------------------------------------------------------------------------------------------- |
| created_by             | integer                     |                                                   | false    |          |                                                 | User ID of the creator of this record.                                                              |
| datetime_create        | timestamp without time zone | CURRENT_TIMESTAMP                                 | true     |          |                                                 | Timestamp when the record was created.                                                              |
| datetime_update        | timestamp without time zone | CURRENT_TIMESTAMP                                 | true     |          |                                                 | Timestamp when the record was last updated.                                                         |
| group_display_sequence | integer                     | 0                                                 | false    |          |                                                 | User-defined display order for groups. Lower values appear first. Sequential integers (0, 1, 2...). |
| group_profile_id       | integer                     |                                                   | false    |          | [public.group_profile](public.group_profile.md) | ID of the group to which the user belongs.                                                          |
| is_active              | boolean                     | true                                              | true     |          |                                                 | Indicates if the user-group relationship is active.                                                 |
| updated_by             | integer                     |                                                   | false    |          |                                                 | User ID of the last updater of this record.                                                         |
| user_group_id          | integer                     | nextval('user_group_user_group_id_seq'::regclass) | false    |          |                                                 | Unique identifier for the user-group relationship.                                                  |
| user_profile_id        | integer                     |                                                   | false    |          | [public.user_profile](public.user_profile.md)   | ID of the user participating in the group.                                                          |

## Constraints

| Name                             | Type        | Definition                                                                |
| -------------------------------- | ----------- | ------------------------------------------------------------------------- |
| user_group_group_profile_id_fkey | FOREIGN KEY | FOREIGN KEY (group_profile_id) REFERENCES group_profile(group_profile_id) |
| user_group_pkey                  | PRIMARY KEY | PRIMARY KEY (user_group_id)                                               |
| user_group_user_profile_id_fkey  | FOREIGN KEY | FOREIGN KEY (user_profile_id) REFERENCES user_profile(user_profile_id)    |

## Indexes

| Name                            | Definition                                                                                                              |
| ------------------------------- | ----------------------------------------------------------------------------------------------------------------------- |
| idx_user_group_display_sequence | CREATE INDEX idx_user_group_display_sequence ON public.user_group USING btree (user_profile_id, group_display_sequence) |
| idx_user_group_userid_groupid   | CREATE UNIQUE INDEX idx_user_group_userid_groupid ON public.user_group USING btree (user_profile_id, group_profile_id)  |
| user_group_pkey                 | CREATE UNIQUE INDEX user_group_pkey ON public.user_group USING btree (user_group_id)                                    |

## Triggers

| Name                        | Definition                                                                                                                        |
| --------------------------- | --------------------------------------------------------------------------------------------------------------------------------- |
| set_datetime_create_trigger | CREATE TRIGGER set_datetime_create_trigger BEFORE INSERT ON public.user_group FOR EACH ROW EXECUTE FUNCTION set_datetime_create() |
| set_datetime_update         | CREATE TRIGGER set_datetime_update BEFORE UPDATE ON public.user_group FOR EACH ROW EXECUTE FUNCTION update_datetime_update()      |

## Relations

```mermaid
erDiagram

"public.user_group" }o--|| "public.group_profile" : "FOREIGN KEY (group_profile_id) REFERENCES group_profile(group_profile_id)"
"public.user_group" }o--|| "public.user_profile" : "FOREIGN KEY (user_profile_id) REFERENCES user_profile(user_profile_id)"

"public.user_group" {
  integer created_by "User ID of the creator of this record."
  timestamp_without_time_zone datetime_create "Timestamp when the record was created."
  timestamp_without_time_zone datetime_update "Timestamp when the record was last updated."
  integer group_display_sequence "User-defined display order for groups. Lower values appear first. Sequential integers (0, 1, 2...)."
  integer group_profile_id FK "ID of the group to which the user belongs."
  boolean is_active "Indicates if the user-group relationship is active."
  integer updated_by "User ID of the last updater of this record."
  integer user_group_id "Unique identifier for the user-group relationship."
  integer user_profile_id FK "ID of the user participating in the group."
}
"public.group_profile" {
  integer created_by "User ID of the creator of the group."
  timestamp_without_time_zone datetime_create "Timestamp when the group was created."
  timestamp_without_time_zone datetime_update "Timestamp when the group was last updated."
  boolean deleted "Indicates if the group has been marked as deleted."
  varchar_500_ group_description "Description of the group."
  varchar_255_ group_name "This field holds the name of the group."
  integer group_profile_id "Unique identifier for the group."
  boolean is_active "Indicates if the group is active."
  integer updated_by "User ID of the last updater of the group."
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
