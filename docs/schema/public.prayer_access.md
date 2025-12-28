# public.prayer_access

## Description

Controls prayer visibility and sharing

## Columns

| Name             | Type                        | Default                                                 | Nullable | Children                                                      | Parents                           | Comment                                                                                              |
| ---------------- | --------------------------- | ------------------------------------------------------- | -------- | ------------------------------------------------------------- | --------------------------------- | ---------------------------------------------------------------------------------------------------- |
| access_type      | varchar(5)                  |                                                         | false    |                                                               |                                   | Type of access (e.g., 'user', 'group').                                                              |
| access_type_id   | integer                     |                                                         | false    |                                                               |                                   | ID value of the associated type (e.g., if access_type is user, then use user.user_profile_id value). |
| created_by       | integer                     |                                                         | false    |                                                               |                                   | User ID of the creator of this record.                                                               |
| datetime_create  | timestamp without time zone | CURRENT_TIMESTAMP                                       | true     |                                                               |                                   | Timestamp when the record was created.                                                               |
| datetime_update  | timestamp without time zone | CURRENT_TIMESTAMP                                       | true     |                                                               |                                   | Timestamp when the record was last updated.                                                          |
| display_sequence | integer                     | 0                                                       | false    |                                                               |                                   | User-defined display order for prayers. Lower values appear first. Sequential integers (0, 1, 2...). |
| prayer_access_id | integer                     | nextval('prayer_access_prayer_access_id_seq'::regclass) | false    | [public.prayer_category_item](public.prayer_category_item.md) |                                   | Unique identifier for each prayer access record.                                                     |
| prayer_id        | integer                     |                                                         | false    |                                                               | [public.prayer](public.prayer.md) | Foreign key referencing the prayer request.                                                          |
| updated_by       | integer                     |                                                         | false    |                                                               |                                   | User ID of who last updated this record.                                                             |

## Constraints

| Name                         | Type        | Definition                                           |
| ---------------------------- | ----------- | ---------------------------------------------------- |
| prayer_access_pkey           | PRIMARY KEY | PRIMARY KEY (prayer_access_id)                       |
| prayer_access_prayer_id_fkey | FOREIGN KEY | FOREIGN KEY (prayer_id) REFERENCES prayer(prayer_id) |

## Indexes

| Name                               | Definition                                                                                                                          |
| ---------------------------------- | ----------------------------------------------------------------------------------------------------------------------------------- |
| idx_prayer_access_display_sequence | CREATE INDEX idx_prayer_access_display_sequence ON public.prayer_access USING btree (access_type, access_type_id, display_sequence) |
| idx_prayer_access_prayer_id        | CREATE INDEX idx_prayer_access_prayer_id ON public.prayer_access USING btree (prayer_id)                                            |
| idx_prayer_access_type_id          | CREATE UNIQUE INDEX idx_prayer_access_type_id ON public.prayer_access USING btree (prayer_id, access_type, access_type_id)          |
| prayer_access_pkey                 | CREATE UNIQUE INDEX prayer_access_pkey ON public.prayer_access USING btree (prayer_access_id)                                       |

## Triggers

| Name                        | Definition                                                                                                                           |
| --------------------------- | ------------------------------------------------------------------------------------------------------------------------------------ |
| set_datetime_create_trigger | CREATE TRIGGER set_datetime_create_trigger BEFORE INSERT ON public.prayer_access FOR EACH ROW EXECUTE FUNCTION set_datetime_create() |
| set_datetime_update         | CREATE TRIGGER set_datetime_update BEFORE UPDATE ON public.prayer_access FOR EACH ROW EXECUTE FUNCTION update_datetime_update()      |

## Relations

```mermaid
erDiagram

"public.prayer_category_item" |o--|| "public.prayer_access" : "FOREIGN KEY (prayer_access_id) REFERENCES prayer_access(prayer_access_id) ON DELETE CASCADE"
"public.prayer_access" }o--|| "public.prayer" : "FOREIGN KEY (prayer_id) REFERENCES prayer(prayer_id)"

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
"public.prayer_category_item" {
  integer created_by "User ID who assigned the prayer to this category."
  timestamp_without_time_zone datetime_create "Timestamp when the prayer was added to the category."
  integer prayer_access_id FK "Foreign key referencing the prayer access record."
  integer prayer_category_id FK "Foreign key referencing the prayer category."
  integer prayer_category_item_id "Unique identifier for each category-prayer relationship."
}
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
```

---

> Generated by [tbls](https://github.com/k1LoW/tbls)
