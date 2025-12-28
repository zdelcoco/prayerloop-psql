-- Migration tracking table
-- This table tracks which migrations have been applied to prevent re-running
-- Run this ONCE manually before using automated migrations

CREATE TABLE IF NOT EXISTS "_migrations" (
    id SERIAL PRIMARY KEY,
    filename VARCHAR(255) NOT NULL UNIQUE,
    applied_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

COMMENT ON TABLE "_migrations" IS 'Tracks applied database migrations to prevent re-running.';
