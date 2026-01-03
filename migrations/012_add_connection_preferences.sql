-- Migration: Add connection-related user preferences
-- Part of Person-Centric Prayer Model (v2026.1.1)
-- Enables users to control discoverability and notification settings

INSERT INTO preference (preference_key, default_value, description, value_type) VALUES
    ('discoverable_by_email', 'true', 'Allow others to find you by email for prayer connections', 'boolean'),
    ('notify_when_prayed_for', 'true', 'Receive notifications when someone prays for you (requires linked connection)', 'boolean'),
    ('notify_connection_requests', 'true', 'Receive notifications for new prayer connection requests', 'boolean');
