INSERT INTO "prayer_access" (prayer_id, access_type, access_type_id, created_by, updated_by)
VALUES 
    (1, 'user', 1, 1, 1),  -- Prayer 1 accessible only to User 1
    (2, 'group', 1, 1, 1),  -- Prayer 2 accessible to Group 1
    (2, 'user', 2, 1, 1),   -- Prayer 2 accessible to User 2
    (2, 'user', 3, 1, 1),   -- Prayer 2 accessible to User 3
    (2, 'user', 4, 1, 1),   -- Prayer 2 accessible to User 4
    (3, 'group', 2, 1, 1),  -- Prayer 3 accessible to Group 2
    (3, 'group', 3, 1, 1),  -- Prayer 3 accessible to Group 3
    (3, 'user', 5, 1, 1),   -- Prayer 3 accessible to User 5 (not in Groups 2 or 3)
    (4, 'user', 6, 1, 1),   -- Prayer 4 accessible to User 6
    (4, 'group', 4, 1, 1),   -- Prayer 4 accessible to Group 4
    (5, 'user', 7, 1, 1),   -- Prayer 5 accessible to User 7
    (5, 'user', 8, 1, 1),   -- Prayer 5 accessible to User 8
    (6, 'group', 5, 1, 1),   -- Prayer 6 accessible to Group 5
    (6, 'user', 9, 1, 1),   -- Prayer 6 accessible to User 9
    (7, 'user',10 ,1 ,1),     -- Prayer accessible to User10 
    (8 , 'group' ,6 ,1 ,1) ,   -- Prayer8 is accessible to Group6 
    (9 , 'user' ,3 ,1 ,1) ,     -- Prayer9 is accessible to user3 
    (10 ,'group' ,7 ,1 ,1);     -- Prayer10 is accessible to group7 