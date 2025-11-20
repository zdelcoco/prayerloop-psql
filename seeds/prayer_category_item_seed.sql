INSERT INTO "prayer_category_item" (prayer_category_id, prayer_access_id, created_by)
VALUES
    -- User 1's personal prayer in "Family" category (prayer_category_id 1)
    (1, 1, 1),  -- Prayer 1 (personal to User 1) -> Family

    -- Group 1 prayer in "Mission Trip" category (prayer_category_id 7)
    (7, 2, 1),  -- Prayer 2 (Group 1) -> Mission Trip

    -- User 3's personal prayer in "Urgent" category (prayer_category_id 6)
    (6, 9, 3),  -- Prayer 9 (personal to User 3) -> Urgent

    -- Group 2 prayer in "Members" category (prayer_category_id 9)
    (9, 3, 2);  -- Prayer 3 (Group 2) -> Members
