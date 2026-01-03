INSERT INTO "prayer_session_config" (
    user_profile_id,
    name,
    description,
    is_default
)
VALUES
    -- User 1's saved sessions
    (1, 'Morning Prayer', 'Daily morning devotional prayer time', TRUE),
    (1, 'Small Group', 'Weekly small group prayer list', FALSE),
    (1, 'Family Focus', 'Prayers focused on family members', FALSE),

    -- User 2's saved sessions
    (2, 'Daily Prayers', 'My daily prayer routine', TRUE),
    (2, 'Friends & Family', 'Loved ones I pray for regularly', FALSE),

    -- User 3's saved sessions
    (3, 'Leadership Prayers', 'Prayers for church leadership', TRUE);
