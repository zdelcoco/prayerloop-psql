-- Seed file for user_push_tokens table
-- Inserts dummy push tokens for all test users
-- These tokens won't work for actual push delivery, but allow testing the notification flow

INSERT INTO user_push_tokens (user_profile_id, push_token, platform, created_at, updated_at)
VALUES
  (1, 'test_push_token_user_1_aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa', 'ios', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
  (4, 'test_push_token_user_4_dddddddddddddddddddddddddddddddddddddddd', 'ios', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
  (5, 'test_push_token_user_5_eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee', 'ios', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
  (6, 'test_push_token_user_6_ffffffffffffffffffffffffffffffffffffffff', 'ios', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
  (7, 'test_push_token_user_7_gggggggggggggggggggggggggggggggggggggggg', 'android', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
  (8, 'test_push_token_user_8_hhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhh', 'android', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
  (9, 'test_push_token_user_9_iiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiii', 'android', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
  (10, 'test_push_token_user_10_jjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjj', 'android', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
  (11, 'test_push_token_user_11_kkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkk', 'ios', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
ON CONFLICT (user_profile_id, push_token) DO NOTHING;
