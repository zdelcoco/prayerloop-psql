# public.prayer_session

## Description

Prayer session tracking

## Columns

| Name              | Type                        | Default                                                   | Nullable | Children                                                        | Parents                                       | Comment                                                               |
| ----------------- | --------------------------- | --------------------------------------------------------- | -------- | --------------------------------------------------------------- | --------------------------------------------- | --------------------------------------------------------------------- |
| end_time          | timestamp without time zone |                                                           | true     |                                                                 |                                               | Timestamp when the prayer session ends (optional).                    |
| prayer_session_id | integer                     | nextval('prayer_session_prayer_session_id_seq'::regclass) | false    | [public.prayer_session_detail](public.prayer_session_detail.md) |                                               | Unique identifier for each prayer session.                            |
| start_time        | timestamp without time zone |                                                           | false    |                                                                 |                                               | Timestamp when the prayer session starts.                             |
| user_profile_id   | integer                     |                                                           | false    |                                                                 | [public.user_profile](public.user_profile.md) | Foreign key referencing the user participating in the prayer session. |

## Constraints

| Name                                | Type        | Definition                                                             |
| ----------------------------------- | ----------- | ---------------------------------------------------------------------- |
| prayer_session_pkey                 | PRIMARY KEY | PRIMARY KEY (prayer_session_id)                                        |
| prayer_session_user_profile_id_fkey | FOREIGN KEY | FOREIGN KEY (user_profile_id) REFERENCES user_profile(user_profile_id) |

## Indexes

| Name                               | Definition                                                                                             |
| ---------------------------------- | ------------------------------------------------------------------------------------------------------ |
| idx_prayer_session_user_profile_id | CREATE INDEX idx_prayer_session_user_profile_id ON public.prayer_session USING btree (user_profile_id) |
| prayer_session_pkey                | CREATE UNIQUE INDEX prayer_session_pkey ON public.prayer_session USING btree (prayer_session_id)       |

## Relations

```mermaid
erDiagram

"public.prayer_session_detail" }o--|| "public.prayer_session" : "FOREIGN KEY (prayer_session_id) REFERENCES prayer_session(prayer_session_id)"
"public.prayer_session" }o--|| "public.user_profile" : "FOREIGN KEY (user_profile_id) REFERENCES user_profile(user_profile_id)"

"public.prayer_session" {
  timestamp_without_time_zone end_time "Timestamp when the prayer session ends (optional)."
  integer prayer_session_id "Unique identifier for each prayer session."
  timestamp_without_time_zone start_time "Timestamp when the prayer session starts."
  integer user_profile_id FK "Foreign key referencing the user participating in the prayer session."
}
"public.prayer_session_detail" {
  timestamp_without_time_zone end_time "Timestamp when the prayer session detail ends (optional)."
  integer prayer_id FK "Foreign key referencing the associated prayer request."
  integer prayer_session_detail_id "Unique identifier for each prayer session detail record."
  integer prayer_session_id FK "Foreign key referencing the associated prayer session."
  timestamp_without_time_zone start_time "Timestamp when the prayer session detail starts."
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
