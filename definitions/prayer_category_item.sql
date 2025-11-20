DROP TABLE IF EXISTS "prayer_category_item" CASCADE;

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

/*** comments ***/
COMMENT ON TABLE "prayer_category_item" IS 'Junction table linking prayers to categories. Each prayer can belong to at most one category.';
COMMENT ON COLUMN "prayer_category_item".prayer_category_item_id IS 'Unique identifier for each category-prayer relationship.';
COMMENT ON COLUMN "prayer_category_item".prayer_category_id IS 'Foreign key referencing the prayer category.';
COMMENT ON COLUMN "prayer_category_item".prayer_access_id IS 'Foreign key referencing the prayer access record.';
COMMENT ON COLUMN "prayer_category_item".datetime_create IS 'Timestamp when the prayer was added to the category.';
COMMENT ON COLUMN "prayer_category_item".created_by IS 'User ID who assigned the prayer to this category.';

/*** indexes ***/
CREATE INDEX IF NOT EXISTS idx_prayer_category_item_category_id ON "prayer_category_item" (prayer_category_id);
CREATE INDEX IF NOT EXISTS idx_prayer_category_item_access_id ON "prayer_category_item" (prayer_access_id);

/*** functions ***/
CREATE OR REPLACE FUNCTION set_datetime_create()
RETURNS TRIGGER AS $$
BEGIN
    NEW.datetime_create = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$

LANGUAGE plpgsql;

/*** triggers ***/
CREATE TRIGGER set_datetime_create_trigger
BEFORE INSERT ON "prayer_category_item"
FOR EACH ROW
EXECUTE PROCEDURE set_datetime_create();
