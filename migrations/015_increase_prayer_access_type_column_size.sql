-- Migration: Increase access_type column size in prayer_access
-- Date: 2025-01-07
-- Description: Increase access_type from VARCHAR(5) to VARCHAR(10) to accommodate 'subject' type

-- Alter the column size (this is a safe operation - increasing size doesn't affect existing data)
ALTER TABLE prayer_access
ALTER COLUMN access_type TYPE VARCHAR(10);

-- Update the comment to reflect all access types
COMMENT ON COLUMN prayer_access.access_type IS 'Type of access (e.g., ''user'', ''group'', ''subject'').';
