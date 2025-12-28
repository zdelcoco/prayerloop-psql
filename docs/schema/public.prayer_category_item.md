# public.prayer_category_item

## Description

Prayers assigned to categories

## Columns

| Name                    | Type                        | Default                                                               | Nullable | Children | Parents                                             | Comment                                                  |
| ----------------------- | --------------------------- | --------------------------------------------------------------------- | -------- | -------- | --------------------------------------------------- | -------------------------------------------------------- |
| created_by              | integer                     |                                                                       | false    |          |                                                     | User ID who assigned the prayer to this category.        |
| datetime_create         | timestamp without time zone | CURRENT_TIMESTAMP                                                     | true     |          |                                                     | Timestamp when the prayer was added to the category.     |
| prayer_access_id        | integer                     |                                                                       | false    |          | [public.prayer_access](public.prayer_access.md)     | Foreign key referencing the prayer access record.        |
| prayer_category_id      | integer                     |                                                                       | false    |          | [public.prayer_category](public.prayer_category.md) | Foreign key referencing the prayer category.             |
| prayer_category_item_id | integer                     | nextval('prayer_category_item_prayer_category_item_id_seq'::regclass) | false    |          |                                                     | Unique identifier for each category-prayer relationship. |

## Constraints

| Name                                         | Type        | Definition                                                                                        |
| -------------------------------------------- | ----------- | ------------------------------------------------------------------------------------------------- |
| prayer_category_item_pkey                    | PRIMARY KEY | PRIMARY KEY (prayer_category_item_id)                                                             |
| prayer_category_item_prayer_access_id_fkey   | FOREIGN KEY | FOREIGN KEY (prayer_access_id) REFERENCES prayer_access(prayer_access_id) ON DELETE CASCADE       |
| prayer_category_item_prayer_category_id_fkey | FOREIGN KEY | FOREIGN KEY (prayer_category_id) REFERENCES prayer_category(prayer_category_id) ON DELETE CASCADE |
| unique_prayer_category                       | UNIQUE      | UNIQUE (prayer_access_id)                                                                         |

## Indexes

| Name                                 | Definition                                                                                                         |
| ------------------------------------ | ------------------------------------------------------------------------------------------------------------------ |
| idx_prayer_category_item_access_id   | CREATE INDEX idx_prayer_category_item_access_id ON public.prayer_category_item USING btree (prayer_access_id)      |
| idx_prayer_category_item_category_id | CREATE INDEX idx_prayer_category_item_category_id ON public.prayer_category_item USING btree (prayer_category_id)  |
| prayer_category_item_pkey            | CREATE UNIQUE INDEX prayer_category_item_pkey ON public.prayer_category_item USING btree (prayer_category_item_id) |
| unique_prayer_category               | CREATE UNIQUE INDEX unique_prayer_category ON public.prayer_category_item USING btree (prayer_access_id)           |

## Triggers

| Name                        | Definition                                                                                                                                  |
| --------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------- |
| set_datetime_create_trigger | CREATE TRIGGER set_datetime_create_trigger BEFORE INSERT ON public.prayer_category_item FOR EACH ROW EXECUTE FUNCTION set_datetime_create() |

## Relations

```mermaid
erDiagram

"public.prayer_category_item" |o--|| "public.prayer_access" : "FOREIGN KEY (prayer_access_id) REFERENCES prayer_access(prayer_access_id) ON DELETE CASCADE"
"public.prayer_category_item" }o--|| "public.prayer_category" : "FOREIGN KEY (prayer_category_id) REFERENCES prayer_category(prayer_category_id) ON DELETE CASCADE"

"public.prayer_category_item" {
  integer created_by "User ID who assigned the prayer to this category."
  timestamp_without_time_zone datetime_create "Timestamp when the prayer was added to the category."
  integer prayer_access_id FK "Foreign key referencing the prayer access record."
  integer prayer_category_id FK "Foreign key referencing the prayer category."
  integer prayer_category_item_id "Unique identifier for each category-prayer relationship."
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
"public.prayer_category" {
  varchar_20_ category_color "Hex color code for visual distinction (e.g., '#90c590')."
  varchar_100_ category_name "Name of the category (e.g., 'Family', 'Work', 'Health')."
  varchar_5_ category_type "Type of category ('user' for personal categories, 'group' for shared group categories)."
  integer category_type_id "ID value of the associated type (e.g., if category_type is user, then user_profile_id; if group, then group_profile_id)."
  integer created_by "User ID of the creator of this category."
  timestamp_without_time_zone datetime_create "Timestamp when the category was created."
  timestamp_without_time_zone datetime_update "Timestamp when the category was last updated."
  integer display_sequence "User-defined display order for categories. Lower values appear first. Sequential integers (0, 1, 2...)."
  integer prayer_category_id "Unique identifier for each category."
  integer updated_by "User ID of who last updated this category."
}
```

---

> Generated by [tbls](https://github.com/k1LoW/tbls)
