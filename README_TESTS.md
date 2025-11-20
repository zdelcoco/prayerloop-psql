# Database Testing

This repository includes automated tests for the Prayerloop database schema and migrations.

## Test Suite

### Schema Tests (`tests/test_schema.sh`)

Validates the database schema structure:

- All expected tables exist
- Correct column structure
- Foreign key constraints
- Unique constraints
- Check constraints
- Indexes
- Triggers
- Seed data loads correctly
- Constraint enforcement (reject invalid data)
- CASCADE delete behavior

### Migration Tests (`tests/test_migrations.sh`)

Validates database migrations:

- Migrations run without errors
- Tables created by migrations exist
- Migrations are idempotent (can run twice)
- Constraints work after migrations
- All migrations run in sequence

## Running Tests

### Prerequisites

- PostgreSQL 16+ installed and running
- `psql` command available in PATH

### Quick Start

```bash
# Run all tests
make test

# Run only schema tests
make test-schema

# Run only migration tests
make test-migrations
```

### Manual Test Execution

```bash
# Make scripts executable
chmod +x tests/test_schema.sh
chmod +x tests/test_migrations.sh

# Run schema tests
./tests/test_schema.sh

# Run migration tests
./tests/test_migrations.sh
```

## Test Output

Tests use color-coded output:

- 🟡 **YELLOW** - Test running
- 🟢 **GREEN** - Test passed
- 🔴 **RED** - Test failed

Example output:

```
================================
Prayerloop Database Schema Tests
================================

TEST: Creating test database
✓ PASS
TEST: Running database_init.sql
✓ PASS
...

================================
Test Summary
================================
Total:  15
Passed: 15
Failed: 0
================================
```

## CI/CD Integration

Tests run automatically on GitHub Actions for:

- Push to `main`, `develop` branches
- Pull requests to these branches

See `.github/workflows/test.yml` for configuration.

## Makefile Commands

```bash
make help              # Show all available commands
make test              # Run all tests
make test-schema       # Run schema tests only
make test-migrations   # Run migration tests only
make init-db           # Initialize a new database
make clean             # Remove test databases
make run-migration     # Run specific migration
```

## Writing New Tests

### Adding Schema Tests

Edit `tests/test_schema.sh` and add new test cases:

```bash
print_test "Testing my new feature"
if psql -d $TEST_DB -c "SELECT ..."; then
    print_pass
else
    print_fail "Description of failure"
fi
```

### Adding Migration Tests

Edit `tests/test_migrations.sh` to validate new migrations:

```bash
print_test "Running migration 007_my_new_migration.sql"
if psql -d $TEST_DB -f migrations/007_my_new_migration.sql > /dev/null 2>&1; then
    print_pass
else
    print_fail "Migration 007 failed"
fi
```

## Test Database Cleanup

Test databases are automatically cleaned up after each test run. To manually clean up lingering test databases:

```bash
make clean
```

## Troubleshooting

### PostgreSQL not running

```bash
# macOS (Homebrew)
brew services start postgresql@16

# Linux (systemd)
sudo systemctl start postgresql
```

### Permission denied errors

```bash
chmod +x tests/*.sh
```

### Tests fail locally but pass in CI

- Check PostgreSQL version (should be 16+)
- Ensure no conflicting test databases exist
- Run `make clean` to remove old test databases

## Test Coverage

Current coverage:

- 17 tables validated
- 15 schema tests
- 7 migration tests
- All foreign keys tested
- All constraints tested
- Idempotency validated
