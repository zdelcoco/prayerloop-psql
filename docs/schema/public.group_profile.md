# public.group_profile

## Description

Prayer groups

## Columns

| Name              | Type                        | Default                                                 | Nullable | Children                                                                                | Parents | Comment                                            |
| ----------------- | --------------------------- | ------------------------------------------------------- | -------- | --------------------------------------------------------------------------------------- | ------- | -------------------------------------------------- |
| created_by        | integer                     |                                                         | false    |                                                                                         |         | User ID of the creator of the group.               |
| datetime_create   | timestamp without time zone | CURRENT_TIMESTAMP                                       | true     |                                                                                         |         | Timestamp when the group was created.              |
| datetime_update   | timestamp without time zone | CURRENT_TIMESTAMP                                       | true     |                                                                                         |         | Timestamp when the group was last updated.         |
| deleted           | boolean                     | false                                                   | true     |                                                                                         |         | Indicates if the group has been marked as deleted. |
| group_description | varchar(500)                |                                                         | true     |                                                                                         |         | Description of the group.                          |
| group_name        | varchar(255)                |                                                         | false    |                                                                                         |         | This field holds the name of the group.            |
| group_profile_id  | integer                     | nextval('group_profile_group_profile_id_seq'::regclass) | false    | [public.group_invite](public.group_invite.md) [public.user_group](public.user_group.md) |         | Unique identifier for the group.                   |
| is_active         | boolean                     | true                                                    | true     |                                                                                         |         | Indicates if the group is active.                  |
| updated_by        | integer                     |                                                         | false    |                                                                                         |         | User ID of the last updater of the group.          |

## Constraints

| Name               | Type        | Definition                     |
| ------------------ | ----------- | ------------------------------ |
| group_profile_pkey | PRIMARY KEY | PRIMARY KEY (group_profile_id) |

## Indexes

| Name                 | Definition                                                                                                   |
| -------------------- | ------------------------------------------------------------------------------------------------------------ |
| group_profile_pkey   | CREATE UNIQUE INDEX group_profile_pkey ON public.group_profile USING btree (group_profile_id)                |
| idx_group_group_name | CREATE UNIQUE INDEX idx_group_group_name ON public.group_profile USING btree (group_name, group_description) |

## Triggers

| Name                        | Definition                                                                                                                           |
| --------------------------- | ------------------------------------------------------------------------------------------------------------------------------------ |
| set_datetime_create_trigger | CREATE TRIGGER set_datetime_create_trigger BEFORE INSERT ON public.group_profile FOR EACH ROW EXECUTE FUNCTION set_datetime_create() |
| set_datetime_update         | CREATE TRIGGER set_datetime_update BEFORE UPDATE ON public.group_profile FOR EACH ROW EXECUTE FUNCTION update_datetime_update()      |

## Relations

```mermaid
erDiagram

"public.group_invite" }o--|| "public.group_profile" : "FOREIGN KEY (group_profile_id) REFERENCES group_profile(group_profile_id) ON DELETE CASCADE"
"public.user_group" }o--|| "public.group_profile" : "FOREIGN KEY (group_profile_id) REFERENCES group_profile(group_profile_id)"

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
"public.group_invite" {
  integer created_by "User ID of the creator of the invite."
  timestamp_without_time_zone datetime_create "Timestamp when the invite was created."
  timestamp_without_time_zone datetime_expires "Timestamp when the invite expires."
  timestamp_without_time_zone datetime_update "Timestamp when the invite was last updated."
  integer group_invite_id "Unique identifier for the group invite."
  integer group_profile_id FK "Unique identifier for the group."
  varchar_50_ invite_code "Unique code for the invite."
  boolean is_active "Indicates if the invite is active.  Used for revoking invites."
  integer updated_by "User ID of the last updater of the invite."
}
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
```

---

> Generated by [tbls](https://github.com/k1LoW/tbls)
