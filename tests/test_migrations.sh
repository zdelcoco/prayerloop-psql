#!/bin/bash
# Migration tests for prayerloop database

set -e  # Exit on any error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Test database name
TEST_DB="prayerloop_migration_test_$(date +%s)"

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
echo "Prayerloop Database Migration Tests"
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

# Create full schema using database_init.sql
print_test "Running database_init.sql (full schema with all migrations applied)"
if psql -d $TEST_DB -f database_init.sql > /dev/null 2>&1; then
    print_pass
else
    print_fail "database_init.sql failed"
    exit 1
fi

# Test: Verify prayer_category tables exist
print_test "Verifying prayer_category table exists"
if psql -d $TEST_DB -tAc "SELECT to_regclass('public.prayer_category');" | grep -q "prayer_category"; then
    print_pass
else
    print_fail "prayer_category table not found"
fi

# Test: Verify prayer_category_item table exists
print_test "Verifying prayer_category_item table exists"
if psql -d $TEST_DB -tAc "SELECT to_regclass('public.prayer_category_item');" | grep -q "prayer_category_item"; then
    print_pass
else
    print_fail "prayer_category_item table not found"
fi

# Test: Idempotency - Run migration 006 again (should not error with IF NOT EXISTS)
print_test "Testing migration 006 idempotency (running on existing schema)"
if psql -d $TEST_DB -f migrations/006_add_prayer_categories.sql > /dev/null 2>&1; then
    print_pass
else
    print_fail "Migration 006 is not idempotent"
fi

# Test: Verify constraints still work after re-running migration
print_test "Testing category_type constraint after re-running migration"
if psql -d $TEST_DB -c "INSERT INTO prayer_category (category_type, category_type_id, category_name, created_by, updated_by) VALUES ('invalid', 1, 'Test', 1, 1);" > /dev/null 2>&1; then
    print_fail "Check constraint broken after re-running migration"
else
    print_pass
fi

# Test: Verify all migrations can run in sequence on fresh database
print_test "Testing all migrations run in sequence on fresh database"
TEST_DB_MIGRATIONS="prayerloop_migration_seq_test_$(date +%s)"
if psql -d postgres -c "CREATE DATABASE $TEST_DB_MIGRATIONS;" > /dev/null 2>&1; then
    # Create base tables (definitions only, no seeds)
    for def_file in definitions/user_profile.sql \
                    definitions/group_profile.sql \
                    definitions/user_group.sql \
                    definitions/prayer.sql \
                    definitions/prayer_access.sql \
                    definitions/prayer_analytics.sql \
                    definitions/prayer_session.sql \
                    definitions/prayer_session_detail.sql \
                    definitions/user_stats.sql \
                    definitions/notification.sql \
                    definitions/group_invite.sql \
                    definitions/preference.sql \
                    definitions/user_preferences.sql; do
        psql -d $TEST_DB_MIGRATIONS -f "$def_file" > /dev/null 2>&1
    done

    # Run migrations in order
    ALL_PASS=true
    for migration in migrations/*.sql; do
        if ! psql -d $TEST_DB_MIGRATIONS -f "$migration" > /dev/null 2>&1; then
            ALL_PASS=false
            break
        fi
    done

    psql -d postgres -c "DROP DATABASE $TEST_DB_MIGRATIONS;" > /dev/null 2>&1

    if $ALL_PASS; then
        print_pass
    else
        print_fail "One or more migrations failed"
    fi
else
    print_fail "Failed to create test database for migration sequence"
fi

# Print summary
print_summary

# Exit with appropriate code
if [ $TESTS_FAILED -gt 0 ]; then
    exit 1
else
    exit 0
fi
