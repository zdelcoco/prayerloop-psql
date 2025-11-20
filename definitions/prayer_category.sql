DROP TABLE IF EXISTS "prayer_category" CASCADE;

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

/*** comments ***/
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

/*** indexes ***/
CREATE INDEX IF NOT EXISTS idx_prayer_category_type_id ON "prayer_category" (category_type, category_type_id);
CREATE INDEX IF NOT EXISTS idx_prayer_category_display_sequence ON "prayer_category" (category_type, category_type_id, display_sequence);
CREATE UNIQUE INDEX IF NOT EXISTS idx_unique_prayer_category_name ON "prayer_category" (category_type, category_type_id, LOWER(category_name));

/*** functions ***/
CREATE OR REPLACE FUNCTION set_datetime_create()
RETURNS TRIGGER AS $$
BEGIN
    NEW.datetime_create = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$

LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION update_datetime_update()
RETURNS TRIGGER AS $$
BEGIN
    NEW.datetime_update = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$

LANGUAGE plpgsql;

/*** triggers ***/
CREATE TRIGGER set_datetime_create_trigger
BEFORE INSERT ON "prayer_category"
FOR EACH ROW
EXECUTE PROCEDURE set_datetime_create();

CREATE TRIGGER set_datetime_update
BEFORE UPDATE ON "prayer_category"
FOR EACH ROW
EXECUTE PROCEDURE update_datetime_update();
