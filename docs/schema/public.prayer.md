# public.prayer

## Description

Individual prayer requests

## Columns

| Name               | Type                        | Default                                   | Nullable | Children                                                                                                                                                              | Parents | Comment                                                     |
| ------------------ | --------------------------- | ----------------------------------------- | -------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------- | ----------------------------------------------------------- |
| created_by         | integer                     |                                           | false    |                                                                                                                                                                       |         | User ID of the creator of this record.                      |
| datetime_answered  | timestamp without time zone |                                           | true     |                                                                                                                                                                       |         | Timestamp when the prayer was answered.                     |
| datetime_create    | timestamp without time zone | CURRENT_TIMESTAMP                         | true     |                                                                                                                                                                       |         | Timestamp when the record was created.                      |
| datetime_update    | timestamp without time zone | CURRENT_TIMESTAMP                         | true     |                                                                                                                                                                       |         | Timestamp when the record was last updated.                 |
| deleted            | boolean                     | false                                     | true     |                                                                                                                                                                       |         | Indicates if the prayer request has been marked as deleted. |
| is_answered        | boolean                     | false                                     | true     |                                                                                                                                                                       |         | Indicates if the prayer has been answered.                  |
| is_private         | boolean                     | false                                     | true     |                                                                                                                                                                       |         | Indicates if the prayer request is private.                 |
| prayer_description | varchar(3000)               |                                           | true     |                                                                                                                                                                       |         |                                                             |
| prayer_id          | integer                     | nextval('prayer_prayer_id_seq'::regclass) | false    | [public.prayer_access](public.prayer_access.md) [public.prayer_analytics](public.prayer_analytics.md) [public.prayer_session_detail](public.prayer_session_detail.md) |         | Unique identifier for each prayer request.                  |
| prayer_priority    | integer                     | 0                                         | true     |                                                                                                                                                                       |         |                                                             |
| prayer_type        | varchar(20)                 |                                           | false    |                                                                                                                                                                       |         |                                                             |
| title              | varchar(250)                |                                           | false    |                                                                                                                                                                       |         | Title of the prayer request.                                |
| updated_by         | integer                     |                                           | false    |                                                                                                                                                                       |         | User ID of who last updated this record.                    |

## Constraints

| Name        | Type        | Definition              |
| ----------- | ----------- | ----------------------- |
| prayer_pkey | PRIMARY KEY | PRIMARY KEY (prayer_id) |

## Indexes

| Name                  | Definition                                                                   |
| --------------------- | ---------------------------------------------------------------------------- |
| idx_prayer_created_by | CREATE INDEX idx_prayer_created_by ON public.prayer USING btree (created_by) |
| prayer_pkey           | CREATE UNIQUE INDEX prayer_pkey ON public.prayer USING btree (prayer_id)     |

## Triggers

| Name                        | Definition                                                                                                                    |
| --------------------------- | ----------------------------------------------------------------------------------------------------------------------------- |
| set_datetime_create_trigger | CREATE TRIGGER set_datetime_create_trigger BEFORE INSERT ON public.prayer FOR EACH ROW EXECUTE FUNCTION set_datetime_create() |
| set_datetime_update         | CREATE TRIGGER set_datetime_update BEFORE UPDATE ON public.prayer FOR EACH ROW EXECUTE FUNCTION update_datetime_update()      |

## Relations

```mermaid
erDiagram

"public.prayer_access" }o--|| "public.prayer" : "FOREIGN KEY (prayer_id) REFERENCES prayer(prayer_id)"
"public.prayer_analytics" }o--|| "public.prayer" : "FOREIGN KEY (prayer_id) REFERENCES prayer(prayer_id)"
"public.prayer_session_detail" }o--|| "public.prayer" : "FOREIGN KEY (prayer_id) REFERENCES prayer(prayer_id)"

"public.prayer" {
  integer created_by "User ID of the creator of this record."
  timestamp_without_time_zone datetime_answered "Timestamp when the prayer was answered."
  timestamp_without_time_zone datetime_create "Timestamp when the record was created."
  timestamp_without_time_zone datetime_update "Timestamp when the record was last updated."
  boolean deleted "Indicates if the prayer request has been marked as deleted."
  boolean is_answered "Indicates if the prayer has been answered."
  boolean is_private "Indicates if the prayer request is private."
  varchar_3000_ prayer_description ""
  integer prayer_id "Unique identifier for each prayer request."
  integer prayer_priority ""
  varchar_20_ prayer_type ""
  varchar_250_ title "Title of the prayer request."
  integer updated_by "User ID of who last updated this record."
}
"public.prayer_access" {
  varchar_5_ access_type "Type of access (e.g., 'user', 'group')."
  integer access_type_id "ID value of the associated type (e.g., if access_type is user, then use user.user_profile_id value)."
  integer created_by "User ID of the creator of this record."
  timestamp_without_time_zone datetime_create "Timestamp when the record was created."
  timestamp_without_time_zone datetime_update "Timestamp when the record was last updated."
  integer display_sequence "User-defined display order for prayers. Lower values appear first. Sequential integers (0, 1, 2...)."
  integer prayer_access_id "Unique identifier for each prayer access record."
  integer prayer_id FK "Foreign key referencing the prayer request."
  integer updated_by "User ID of who last updated this record."
}
"public.prayer_analytics" {
  timestamp_without_time_zone datetime_last_prayed "Timestamp of the last time this prayer was prayed."
  integer last_prayed_by "User ID of the last user who prayed for this request."
  integer num_shares "Number of times this prayer request has been shared."
  integer num_unique_users "Number of unique users who have prayed for this request."
  integer prayer_analytics_id "Unique identifier for each prayer analytics record."
  integer prayer_id FK "Foreign key referencing the associated prayer request."
  integer total_prayers "Total number of prayers for this request."
}
"public.prayer_session_detail" {
  timestamp_without_time_zone end_time "Timestamp when the prayer session detail ends (optional)."
  integer prayer_id FK "Foreign key referencing the associated prayer request."
  integer prayer_session_detail_id "Unique identifier for each prayer session detail record."
  integer prayer_session_id FK "Foreign key referencing the associated prayer session."
  timestamp_without_time_zone start_time "Timestamp when the prayer session detail starts."
}
```

---

> Generated by [tbls](https://github.com/k1LoW/tbls)
