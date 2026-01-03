INSERT INTO "prayer_connection_request" (
    requester_id,
    target_user_id,
    prayer_subject_id,
    status,
    datetime_responded
)
VALUES
    -- User 2 sent a pending request to User 3 for "Sarah Jones" subject
    (2, 3, 8, 'pending', NULL),

    -- User 1 sent an accepted request to User 2 for "John Smith" subject
    (1, 2, 3, 'accepted', CURRENT_TIMESTAMP - INTERVAL '7 days'),

    -- User 3 sent a declined request to User 4 for "Brother Mike" subject
    (3, 4, 11, 'declined', CURRENT_TIMESTAMP - INTERVAL '3 days');
