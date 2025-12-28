# public.prayer_session_detail

## Description

Individual prayers within a session

## Columns

| Name                     | Type                        | Default                                                                 | Nullable | Children | Parents                                           | Comment                                                   |
| ------------------------ | --------------------------- | ----------------------------------------------------------------------- | -------- | -------- | ------------------------------------------------- | --------------------------------------------------------- |
| end_time                 | timestamp without time zone |                                                                         | true     |          |                                                   | Timestamp when the prayer session detail ends (optional). |
| prayer_id                | integer                     |                                                                         | false    |          | [public.prayer](public.prayer.md)                 | Foreign key referencing the associated prayer request.    |
| prayer_session_detail_id | integer                     | nextval('prayer_session_detail_prayer_session_detail_id_seq'::regclass) | false    |          |                                                   | Unique identifier for each prayer session detail record.  |
| prayer_session_id        | integer                     |                                                                         | false    |          | [public.prayer_session](public.prayer_session.md) | Foreign key referencing the associated prayer session.    |
| start_time               | timestamp without time zone |                                                                         | false    |          |                                                   | Timestamp when the prayer session detail starts.          |

## Constraints

| Name                                         | Type        | Definition                                                                   |
| -------------------------------------------- | ----------- | ---------------------------------------------------------------------------- |
| prayer_session_detail_pkey                   | PRIMARY KEY | PRIMARY KEY (prayer_session_detail_id)                                       |
| prayer_session_detail_prayer_id_fkey         | FOREIGN KEY | FOREIGN KEY (prayer_id) REFERENCES prayer(prayer_id)                         |
| prayer_session_detail_prayer_session_id_fkey | FOREIGN KEY | FOREIGN KEY (prayer_session_id) REFERENCES prayer_session(prayer_session_id) |

## Indexes

| Name                                        | Definition                                                                                                               |
| ------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------ |
| idx_prayer_session_detail_prayer_id         | CREATE INDEX idx_prayer_session_detail_prayer_id ON public.prayer_session_detail USING btree (prayer_id)                 |
| idx_prayer_session_detail_prayer_session_id | CREATE INDEX idx_prayer_session_detail_prayer_session_id ON public.prayer_session_detail USING btree (prayer_session_id) |
| prayer_session_detail_pkey                  | CREATE UNIQUE INDEX prayer_session_detail_pkey ON public.prayer_session_detail USING btree (prayer_session_detail_id)    |

## Relations

```mermaid
erDiagram

"public.prayer_session_detail" }o--|| "public.prayer" : "FOREIGN KEY (prayer_id) REFERENCES prayer(prayer_id)"
"public.prayer_session_detail" }o--|| "public.prayer_session" : "FOREIGN KEY (prayer_session_id) REFERENCES prayer_session(prayer_session_id)"

"public.prayer_session_detail" {
  timestamp_without_time_zone end_time "Timestamp when the prayer session detail ends (optional)."
  integer prayer_id FK "Foreign key referencing the associated prayer request."
  integer prayer_session_detail_id "Unique identifier for each prayer session detail record."
  integer prayer_session_id FK "Foreign key referencing the associated prayer session."
  timestamp_without_time_zone start_time "Timestamp when the prayer session detail starts."
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
"public.prayer_session" {
  timestamp_without_time_zone end_time "Timestamp when the prayer session ends (optional)."
  integer prayer_session_id "Unique identifier for each prayer session."
  timestamp_without_time_zone start_time "Timestamp when the prayer session starts."
  integer user_profile_id FK "Foreign key referencing the user participating in the prayer session."
}
```

---

> Generated by [tbls](https://github.com/k1LoW/tbls)
