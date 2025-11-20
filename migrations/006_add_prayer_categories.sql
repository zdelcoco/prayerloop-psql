-- Migration: Add prayer_category and prayer_category_item tables
-- Date: 2025-11-20
-- Description: Add support for user-defined and group-defined categories to organize prayers.
--              Categories are either personal (user-scoped) or shared (group-scoped).
--              Each prayer can belong to at most one category.

-- Create prayer_category table
CREATE TABLE IF NOT EXISTS "prayer_category" (
    prayer_category_id SERIAL PRIMARY KEY,
    category_type VARCHAR(5) NOT NULL,
    category_type_id INT NOT NULL,
    category_name VARCHAR(100) NOT NULL,
    category_color VARCHAR(20),
    display_sequence INTEGER DEFAULT 0 NOT NULL,
    datetime_create TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    datetime_update TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    created_by INT NOT NULL,
    updated_by INT NOT NULL,
    CONSTRAINT chk_category_type CHECK (category_type IN ('user', 'group'))
);

-- Add comments for prayer_category table
COMMENT ON TABLE "prayer_category" IS 'This table stores user-defined and group-defined categories for organizing prayers.';
COMMENT ON COLUMN "prayer_category".prayer_category_id IS 'Unique identifier for each category.';
COMMENT ON COLUMN "prayer_category".category_type IS 'Type of category (''user'' for personal categories, ''group'' for shared group categories).';
COMMENT ON COLUMN "prayer_category".category_type_id IS 'ID value of the associated type (e.g., if category_type is user, then user_profile_id; if group, then group_profile_id).';
COMMENT ON COLUMN "prayer_category".category_name IS 'Name of the category (e.g., ''Family'', ''Work'', ''Health'').';
COMMENT ON COLUMN "prayer_category".category_color IS 'Hex color code for visual distinction (e.g., ''#90c590'').';
COMMENT ON COLUMN "prayer_category".display_sequence IS 'User-defined display order for categories. Lower values appear first. Sequential integers (0, 1, 2...).';
COMMENT ON COLUMN "prayer_category".datetime_create IS 'Timestamp when the category was created.';
COMMENT ON COLUMN "prayer_category".datetime_update IS 'Timestamp when the category was last updated.';
COMMENT ON COLUMN "prayer_category".created_by IS 'User ID of the creator of this category.';
COMMENT ON COLUMN "prayer_category".updated_by IS 'User ID of who last updated this category.';

-- Create indexes for prayer_category table
CREATE INDEX IF NOT EXISTS idx_prayer_category_type_id ON "prayer_category" (category_type, category_type_id);
CREATE INDEX IF NOT EXISTS idx_prayer_category_display_sequence ON "prayer_category" (category_type, category_type_id, display_sequence);
CREATE UNIQUE INDEX IF NOT EXISTS idx_unique_prayer_category_name ON "prayer_category" (category_type, category_type_id, LOWER(category_name));

-- Create triggers for prayer_category table
CREATE TRIGGER set_datetime_create_trigger
BEFORE INSERT ON "prayer_category"
FOR EACH ROW
EXECUTE PROCEDURE set_datetime_create();

CREATE TRIGGER set_datetime_update
BEFORE UPDATE ON "prayer_category"
FOR EACH ROW
EXECUTE PROCEDURE update_datetime_update();

-- Create prayer_category_item junction table
CREATE TABLE IF NOT EXISTS "prayer_category_item" (
    prayer_category_item_id SERIAL PRIMARY KEY,
    prayer_category_id INT NOT NULL,
    prayer_access_id INT NOT NULL,
    datetime_create TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    created_by INT NOT NULL,
    FOREIGN KEY (prayer_category_id) REFERENCES "prayer_category" (prayer_category_id) ON DELETE CASCADE,
    FOREIGN KEY (prayer_access_id) REFERENCES "prayer_access" (prayer_access_id) ON DELETE CASCADE,
    CONSTRAINT unique_prayer_category UNIQUE (prayer_access_id)
);

-- Add comments for prayer_category_item table
COMMENT ON TABLE "prayer_category_item" IS 'Junction table linking prayers to categories. Each prayer can belong to at most one category.';
COMMENT ON COLUMN "prayer_category_item".prayer_category_item_id IS 'Unique identifier for each category-prayer relationship.';
COMMENT ON COLUMN "prayer_category_item".prayer_category_id IS 'Foreign key referencing the prayer category.';
COMMENT ON COLUMN "prayer_category_item".prayer_access_id IS 'Foreign key referencing the prayer access record.';
COMMENT ON COLUMN "prayer_category_item".datetime_create IS 'Timestamp when the prayer was added to the category.';
COMMENT ON COLUMN "prayer_category_item".created_by IS 'User ID who assigned the prayer to this category.';

-- Create indexes for prayer_category_item table
CREATE INDEX IF NOT EXISTS idx_prayer_category_item_category_id ON "prayer_category_item" (prayer_category_id);
CREATE INDEX IF NOT EXISTS idx_prayer_category_item_access_id ON "prayer_category_item" (prayer_access_id);

-- Create trigger for prayer_category_item table
CREATE TRIGGER set_datetime_create_trigger
BEFORE INSERT ON "prayer_category_item"
FOR EACH ROW
EXECUTE PROCEDURE set_datetime_create();
