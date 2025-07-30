-- Migration: Fix typo in user_preferences table column name
-- Date: 2025-07-30
-- Description: Rename user_prefences_id to user_preferences_id (add missing 'r')
-- This was only needed locally, but saving in case it is needed in the future.

-- Rename the column to fix the typo
ALTER TABLE "user_preferences" 
RENAME COLUMN user_prefences_id TO user_preferences_id;
