.PHONY: test test-schema test-migrations init-db clean help

# Colors for output
GREEN := \033[0;32m
YELLOW := \033[1;33m
NC := \033[0m

help: ## Show this help message
	@echo "Available commands:"
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "  ${GREEN}%-15s${NC} %s\n", $$1, $$2}'

test: ## Run all tests (schema + migrations)
	@echo "${YELLOW}Running all database tests...${NC}"
	@./tests/test_schema.sh
	@./tests/test_migrations.sh
	@echo "${GREEN}All tests passed!${NC}"

test-schema: ## Run schema validation tests
	@echo "${YELLOW}Running schema tests...${NC}"
	@./tests/test_schema.sh

test-migrations: ## Run migration tests
	@echo "${YELLOW}Running migration tests...${NC}"
	@./tests/test_migrations.sh

init-db: ## Initialize database with schema and seed data
	@echo "${YELLOW}Initializing database...${NC}"
	@read -p "Enter database name: " dbname; \
	psql -d postgres -c "CREATE DATABASE $$dbname;" && \
	psql -d $$dbname -f database_init.sql && \
	echo "${GREEN}Database $$dbname initialized successfully!${NC}"

clean: ## Clean up test databases
	@echo "${YELLOW}Cleaning up test databases...${NC}"
	@psql -d postgres -tAc "SELECT datname FROM pg_database WHERE datname LIKE 'prayerloop_%test%';" | \
	while read db; do \
		echo "Dropping $$db..."; \
		psql -d postgres -c "DROP DATABASE IF EXISTS $$db;" > /dev/null 2>&1; \
	done
	@echo "${GREEN}Cleanup complete!${NC}"

run-migration: ## Run a specific migration (usage: make run-migration MIGRATION=006 DB=mydb)
	@if [ -z "$(MIGRATION)" ] || [ -z "$(DB)" ]; then \
		echo "Usage: make run-migration MIGRATION=006 DB=mydb"; \
		exit 1; \
	fi
	@echo "${YELLOW}Running migration $(MIGRATION) on database $(DB)...${NC}"
	@psql -d $(DB) -f migrations/$(MIGRATION)_*.sql
	@echo "${GREEN}Migration complete!${NC}"
