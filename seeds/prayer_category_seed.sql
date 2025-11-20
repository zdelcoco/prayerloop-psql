INSERT INTO "prayer_category" (category_type, category_type_id, category_name, category_color, display_sequence, created_by, updated_by)
VALUES
    -- User 1's personal categories
    ('user', 1, 'Family', '#FF6B6B', 0, 1, 1),
    ('user', 1, 'Work', '#4ECDC4', 1, 1, 1),
    ('user', 1, 'Health', '#95E1D3', 2, 1, 1),

    -- User 2's personal categories
    ('user', 2, 'Friends', '#FFE66D', 0, 2, 2),
    ('user', 2, 'Ministry', '#90c590', 1, 2, 2),

    -- User 3's personal categories
    ('user', 3, 'Urgent', '#FF6B9D', 0, 3, 3),

    -- Group 1's shared categories
    ('group', 1, 'Mission Trip', '#6A4C93', 0, 1, 1),
    ('group', 1, 'Church Building', '#C08497', 1, 1, 1),

    -- Group 2's shared categories
    ('group', 2, 'Members', '#80A1D4', 0, 2, 2),
    ('group', 2, 'Outreach', '#F9A826', 1, 2, 2);
