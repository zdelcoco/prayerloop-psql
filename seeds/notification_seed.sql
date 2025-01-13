INSERT INTO "notification" (
  user_profile_id, 
  notification_type, 
  notification_message, 
  notification_status, 
  datetime_create, 
  datetime_update, 
  updated_by, 
  created_by
) VALUES 
(1, 'GROUP_INVITE', 'You''ve been invited to join group x', 'UNREAD', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 1, 1),
(2, 'GROUP_INVITE', 'You''ve been invited to join group y', 'UNREAD', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 2, 2),
(3, 'GROUP_INVITE', 'You''ve been invited to join group z', 'READ', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 3, 3);