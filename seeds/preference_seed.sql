-- Insert default preference values
INSERT INTO "preference" (preference_key, default_value, description, value_type) VALUES
('notifications', 'true', 'Enable push notifications for prayers and updates', 'boolean'),
('theme', 'light', 'Application theme (light or dark)', 'string');