#!/bin/bash
# Schema validation tests for prayerloop database

set -e  # Exit on any error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Test database name
TEST_DB="prayerloop_test_$(date +%s)"

# Test counters
TESTS_RUN=0
TESTS_PASSED=0
TESTS_FAILED=0

# Helper functions
print_test() {
    echo -e "${YELLOW}TEST:${NC} $1"
    TESTS_RUN=$((TESTS_RUN + 1))
}

print_pass() {
    echo -e "${GREEN}✓ PASS${NC}"
    TESTS_PASSED=$((TESTS_PASSED + 1))
}

print_fail() {
    echo -e "${RED}✗ FAIL${NC} $1"
    TESTS_FAILED=$((TESTS_FAILED + 1))
}

print_summary() {
    echo ""
    echo "================================"
    echo "Test Summary"
    echo "================================"
    echo "Total:  $TESTS_RUN"
    echo -e "${GREEN}Passed: $TESTS_PASSED${NC}"
    if [ $TESTS_FAILED -gt 0 ]; then
        echo -e "${RED}Failed: $TESTS_FAILED${NC}"
    else
        echo "Failed: $TESTS_FAILED"
    fi
    echo "================================"
}

cleanup() {
    echo ""
    echo "Cleaning up test database..."
    psql -d postgres -c "DROP DATABASE IF EXISTS $TEST_DB;" > /dev/null 2>&1
}

# Trap to ensure cleanup on exit
trap cleanup EXIT

echo "================================"
echo "Prayerloop Database Schema Tests"
echo "================================"
echo ""

# Create test database
print_test "Creating test database"
if psql -d postgres -c "CREATE DATABASE $TEST_DB;" > /dev/null 2>&1; then
    print_pass
else
    print_fail "Failed to create test database"
    exit 1
fi

# Run database_init.sql
print_test "Running database_init.sql"
if psql -d $TEST_DB -f database_init.sql > /dev/null 2>&1; then
    print_pass
else
    print_fail "database_init.sql failed"
    exit 1
fi

# Test: Verify expected tables exist
print_test "Verifying all expected tables exist"
EXPECTED_TABLES=(
    "user_profile"
    "group_profile"
    "user_group"
    "prayer"
    "prayer_access"
    "prayer_analytics"
    "prayer_session"
    "prayer_session_detail"
    "user_stats"
    "notification"
    "group_invite"
    "preference"
    "user_preferences"
    "user_push_tokens"
    "password_reset_tokens"
    "prayer_category"
    "prayer_category_item"
    "prayer_subject"
    "prayer_subject_membership"
    "prayer_connection_request"
    "prayer_session_config"
    "prayer_session_config_detail"
)

MISSING_TABLES=()
for table in "${EXPECTED_TABLES[@]}"; do
    if ! psql -d $TEST_DB -tAc "SELECT to_regclass('public.$table');" | grep -q "$table"; then
        MISSING_TABLES+=("$table")
    fi
done

if [ ${#MISSING_TABLES[@]} -eq 0 ]; then
    print_pass
else
    print_fail "Missing tables: ${MISSING_TABLES[*]}"
fi

# Test: Verify table count
print_test "Verifying table count"
TABLE_COUNT=$(psql -d $TEST_DB -tAc "SELECT COUNT(*) FROM information_schema.tables WHERE table_schema = 'public';")
EXPECTED_COUNT=22
if [ "$TABLE_COUNT" -eq "$EXPECTED_COUNT" ]; then
    print_pass
else
    print_fail "Expected $EXPECTED_COUNT tables, found $TABLE_COUNT"
fi

# Test: Verify prayer_category structure
print_test "Verifying prayer_category table structure"
PRAYER_CATEGORY_COLUMNS=$(psql -d $TEST_DB -tAc "SELECT column_name FROM information_schema.columns WHERE table_name = 'prayer_category' ORDER BY ordinal_position;")
EXPECTED_COLUMNS="prayer_category_id
category_type
category_type_id
category_name
category_color
display_sequence
datetime_create
datetime_update
created_by
updated_by"

if [ "$PRAYER_CATEGORY_COLUMNS" = "$EXPECTED_COLUMNS" ]; then
    print_pass
else
    print_fail "prayer_category column structure mismatch"
fi

# Test: Verify foreign key constraints
print_test "Verifying foreign key constraints on prayer_category_item"
FK_COUNT=$(psql -d $TEST_DB -tAc "SELECT COUNT(*) FROM information_schema.table_constraints WHERE table_name = 'prayer_category_item' AND constraint_type = 'FOREIGN KEY';")
EXPECTED_FK_COUNT=2
if [ "$FK_COUNT" -eq "$EXPECTED_FK_COUNT" ]; then
    print_pass
else
    print_fail "Expected $EXPECTED_FK_COUNT foreign keys, found $FK_COUNT"
fi

# Test: Verify unique constraint on prayer_category_item
print_test "Verifying unique constraint on prayer_access_id"
UNIQUE_CONSTRAINT=$(psql -d $TEST_DB -tAc "SELECT constraint_name FROM information_schema.table_constraints WHERE table_name = 'prayer_category_item' AND constraint_type = 'UNIQUE';")
if [ -n "$UNIQUE_CONSTRAINT" ]; then
    print_pass
else
    print_fail "Missing unique constraint on prayer_access_id"
fi

# Test: Verify check constraint on category_type
print_test "Verifying check constraint on category_type"
CHECK_CONSTRAINT=$(psql -d $TEST_DB -tAc "SELECT COUNT(*) FROM information_schema.check_constraints WHERE constraint_name = 'chk_category_type';")
if [ "$CHECK_CONSTRAINT" -eq "1" ]; then
    print_pass
else
    print_fail "Missing check constraint on category_type"
fi

# Test: Verify indexes on prayer_category
print_test "Verifying indexes on prayer_category"
INDEX_COUNT=$(psql -d $TEST_DB -tAc "SELECT COUNT(*) FROM pg_indexes WHERE tablename = 'prayer_category';")
EXPECTED_INDEX_COUNT=4  # Primary key + 3 created indexes
if [ "$INDEX_COUNT" -eq "$EXPECTED_INDEX_COUNT" ]; then
    print_pass
else
    print_fail "Expected $EXPECTED_INDEX_COUNT indexes, found $INDEX_COUNT"
fi

# Test: Verify seed data loaded
print_test "Verifying prayer_category seed data"
CATEGORY_COUNT=$(psql -d $TEST_DB -tAc "SELECT COUNT(*) FROM prayer_category;")
EXPECTED_CATEGORY_COUNT=10
if [ "$CATEGORY_COUNT" -eq "$EXPECTED_CATEGORY_COUNT" ]; then
    print_pass
else
    print_fail "Expected $EXPECTED_CATEGORY_COUNT categories, found $CATEGORY_COUNT"
fi

# Test: Verify prayer_category_item seed data
print_test "Verifying prayer_category_item seed data"
ITEM_COUNT=$(psql -d $TEST_DB -tAc "SELECT COUNT(*) FROM prayer_category_item;")
EXPECTED_ITEM_COUNT=4
if [ "$ITEM_COUNT" -eq "$EXPECTED_ITEM_COUNT" ]; then
    print_pass
else
    print_fail "Expected $EXPECTED_ITEM_COUNT items, found $ITEM_COUNT"
fi

# Test: Verify triggers exist
print_test "Verifying datetime triggers on prayer_category"
TRIGGER_COUNT=$(psql -d $TEST_DB -tAc "SELECT COUNT(*) FROM information_schema.triggers WHERE event_object_table = 'prayer_category';")
EXPECTED_TRIGGER_COUNT=2
if [ "$TRIGGER_COUNT" -eq "$EXPECTED_TRIGGER_COUNT" ]; then
    print_pass
else
    print_fail "Expected $EXPECTED_TRIGGER_COUNT triggers, found $TRIGGER_COUNT"
fi

# Test: Verify category_type constraint works
print_test "Testing category_type check constraint (should reject invalid value)"
if psql -d $TEST_DB -c "INSERT INTO prayer_category (category_type, category_type_id, category_name, created_by, updated_by) VALUES ('invalid', 1, 'Test', 1, 1);" > /dev/null 2>&1; then
    print_fail "Check constraint allowed invalid category_type"
else
    print_pass
fi

# Test: Verify unique prayer_access_id constraint works
print_test "Testing unique constraint (should reject duplicate prayer_access_id)"
if psql -d $TEST_DB -c "INSERT INTO prayer_category_item (prayer_category_id, prayer_access_id, created_by) VALUES (1, 1, 1);" > /dev/null 2>&1; then
    print_fail "Unique constraint allowed duplicate prayer_access_id"
else
    print_pass
fi

# Test: Verify ON DELETE CASCADE works
print_test "Testing ON DELETE CASCADE on category deletion"
psql -d $TEST_DB -c "DELETE FROM prayer_category WHERE prayer_category_id = 1;" > /dev/null 2>&1
REMAINING_ITEMS=$(psql -d $TEST_DB -tAc "SELECT COUNT(*) FROM prayer_category_item WHERE prayer_category_id = 1;")
if [ "$REMAINING_ITEMS" -eq "0" ]; then
    print_pass
else
    print_fail "CASCADE delete did not remove related items"
fi

# ================================
# Prayer Subject Tests
# ================================

# Test: Verify prayer_subject table structure
print_test "Verifying prayer_subject table structure"
PRAYER_SUBJECT_COLUMNS=$(psql -d $TEST_DB -tAc "SELECT column_name FROM information_schema.columns WHERE table_name = 'prayer_subject' ORDER BY ordinal_position;")
EXPECTED_PS_COLUMNS="prayer_subject_id
prayer_subject_type
prayer_subject_display_name
notes
display_sequence
photo_s3_key
user_profile_id
use_linked_user_photo
link_status
datetime_create
datetime_update
created_by
updated_by"

if [ "$PRAYER_SUBJECT_COLUMNS" = "$EXPECTED_PS_COLUMNS" ]; then
    print_pass
else
    print_fail "prayer_subject column structure mismatch"
fi

# Test: Verify prayer_subject_type check constraint
print_test "Verifying prayer_subject_type check constraint (should reject invalid value)"
if psql -d $TEST_DB -c "INSERT INTO prayer_subject (prayer_subject_type, prayer_subject_display_name, created_by) VALUES ('invalid', 'Test', 1);" > /dev/null 2>&1; then
    print_fail "Check constraint allowed invalid prayer_subject_type"
else
    print_pass
fi

# Test: Verify link_status check constraint
print_test "Verifying link_status check constraint (should reject invalid value)"
if psql -d $TEST_DB -c "INSERT INTO prayer_subject (prayer_subject_type, prayer_subject_display_name, link_status, created_by) VALUES ('individual', 'Test', 'invalid', 1);" > /dev/null 2>&1; then
    print_fail "Check constraint allowed invalid link_status"
else
    print_pass
fi

# Test: Verify valid prayer_subject insert works
print_test "Verifying valid prayer_subject insert"
if psql -d $TEST_DB -c "INSERT INTO prayer_subject (prayer_subject_type, prayer_subject_display_name, created_by) VALUES ('individual', 'Test Person', 1);" > /dev/null 2>&1; then
    print_pass
else
    print_fail "Valid prayer_subject insert failed"
fi

# Test: Verify prayer_subject indexes
print_test "Verifying indexes on prayer_subject"
INDEX_COUNT=$(psql -d $TEST_DB -tAc "SELECT COUNT(*) FROM pg_indexes WHERE tablename = 'prayer_subject';")
EXPECTED_INDEX_COUNT=5  # Primary key + 4 created indexes
if [ "$INDEX_COUNT" -eq "$EXPECTED_INDEX_COUNT" ]; then
    print_pass
else
    print_fail "Expected $EXPECTED_INDEX_COUNT indexes, found $INDEX_COUNT"
fi

# Test: Verify prayer_subject triggers
print_test "Verifying datetime triggers on prayer_subject"
TRIGGER_COUNT=$(psql -d $TEST_DB -tAc "SELECT COUNT(*) FROM information_schema.triggers WHERE event_object_table = 'prayer_subject';")
EXPECTED_TRIGGER_COUNT=2
if [ "$TRIGGER_COUNT" -eq "$EXPECTED_TRIGGER_COUNT" ]; then
    print_pass
else
    print_fail "Expected $EXPECTED_TRIGGER_COUNT triggers, found $TRIGGER_COUNT"
fi

# ================================
# Prayer Subject Membership Tests
# ================================

# Test: Verify prayer_subject_membership unique constraint
print_test "Verifying unique membership constraint"
psql -d $TEST_DB -c "INSERT INTO prayer_subject (prayer_subject_id, prayer_subject_type, prayer_subject_display_name, created_by) VALUES (100, 'family', 'Test Family', 1);" > /dev/null 2>&1
psql -d $TEST_DB -c "INSERT INTO prayer_subject (prayer_subject_id, prayer_subject_type, prayer_subject_display_name, created_by) VALUES (101, 'individual', 'Test Individual', 1);" > /dev/null 2>&1
psql -d $TEST_DB -c "INSERT INTO prayer_subject_membership (member_prayer_subject_id, group_prayer_subject_id, created_by) VALUES (101, 100, 1);" > /dev/null 2>&1
if psql -d $TEST_DB -c "INSERT INTO prayer_subject_membership (member_prayer_subject_id, group_prayer_subject_id, created_by) VALUES (101, 100, 1);" > /dev/null 2>&1; then
    print_fail "Unique constraint allowed duplicate membership"
else
    print_pass
fi

# ================================
# Prayer Connection Request Tests
# ================================

# Test: Verify prayer_connection_request status check constraint
print_test "Verifying connection request status check constraint"
if psql -d $TEST_DB -c "INSERT INTO prayer_connection_request (requester_id, target_user_id, prayer_subject_id, status) VALUES (1, 2, 1, 'invalid');" > /dev/null 2>&1; then
    print_fail "Check constraint allowed invalid status"
else
    print_pass
fi

# ================================
# Prayer Session Config Tests
# ================================

# Test: Verify prayer_session_config table structure
print_test "Verifying prayer_session_config table exists and has correct structure"
SESSION_CONFIG_COLUMNS=$(psql -d $TEST_DB -tAc "SELECT column_name FROM information_schema.columns WHERE table_name = 'prayer_session_config' ORDER BY ordinal_position;")
EXPECTED_SC_COLUMNS="session_config_id
user_profile_id
name
description
is_default
datetime_create
datetime_update"

if [ "$SESSION_CONFIG_COLUMNS" = "$EXPECTED_SC_COLUMNS" ]; then
    print_pass
else
    print_fail "prayer_session_config column structure mismatch"
fi

# ================================
# Prayer Session Item Tests
# ================================

# Test: Verify prayer_session_config_detail check constraint (must have exactly one of subject or prayer)
print_test "Verifying session item constraint (reject both NULL)"
psql -d $TEST_DB -c "INSERT INTO prayer_session_config (session_config_id, user_profile_id, name) VALUES (999, 1, 'Test Session');" > /dev/null 2>&1
if psql -d $TEST_DB -c "INSERT INTO prayer_session_config_detail (session_config_id, prayer_subject_id, prayer_id) VALUES (999, NULL, NULL);" > /dev/null 2>&1; then
    print_fail "Check constraint allowed both NULL"
else
    print_pass
fi

# Test: Verify prayer_session_config_detail check constraint (reject both set)
print_test "Verifying session item constraint (reject both set)"
if psql -d $TEST_DB -c "INSERT INTO prayer_session_config_detail (session_config_id, prayer_subject_id, prayer_id) VALUES (999, 1, 1);" > /dev/null 2>&1; then
    print_fail "Check constraint allowed both set"
else
    print_pass
fi

# Test: Verify valid session item insert (subject only)
print_test "Verifying valid session item insert (subject only)"
if psql -d $TEST_DB -c "INSERT INTO prayer_session_config_detail (session_config_id, prayer_subject_id, prayer_id) VALUES (999, 1, NULL);" > /dev/null 2>&1; then
    print_pass
else
    print_fail "Valid session item insert failed"
fi

# Print summary
print_summary

# Exit with appropriate code
if [ $TESTS_FAILED -gt 0 ]; then
    exit 1
else
    exit 0
fi
