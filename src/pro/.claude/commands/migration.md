# Skill: migration
Database migration helper.

## Auto-Trigger
**When:** "migration", "database migration", "schema change", "migrate", "db migrate"

## Migration Frameworks

### Node.js (Prisma)
```bash
# Create migration
npx prisma migrate dev --name [migration_name]

# Apply to production
npx prisma migrate deploy

# Reset database
npx prisma migrate reset

# View status
npx prisma migrate status
```

### Node.js (Knex)
```bash
# Create migration
npx knex migrate:make [migration_name]

# Run migrations
npx knex migrate:latest

# Rollback
npx knex migrate:rollback

# Status
npx knex migrate:status
```

### Python (Alembic)
```bash
# Create migration
alembic revision --autogenerate -m "migration_name"

# Run migrations
alembic upgrade head

# Rollback one
alembic downgrade -1

# View history
alembic history
```

### Rails
```bash
# Create migration
rails generate migration AddColumnToTable column:type

# Run migrations
rails db:migrate

# Rollback
rails db:rollback

# Status
rails db:migrate:status
```

## Migration Template

### SQL Migration
```sql
-- Migration: [name]
-- Created: [date]
-- Description: [what this migration does]

-- UP
BEGIN;

ALTER TABLE users ADD COLUMN email_verified BOOLEAN DEFAULT FALSE;
CREATE INDEX idx_users_email ON users(email);

COMMIT;

-- DOWN
BEGIN;

DROP INDEX idx_users_email;
ALTER TABLE users DROP COLUMN email_verified;

COMMIT;
```

### Knex Migration
```javascript
// migrations/20260129_add_email_verified.js

exports.up = function(knex) {
  return knex.schema.alterTable('users', (table) => {
    table.boolean('email_verified').defaultTo(false);
    table.index('email');
  });
};

exports.down = function(knex) {
  return knex.schema.alterTable('users', (table) => {
    table.dropIndex('email');
    table.dropColumn('email_verified');
  });
};
```

### Prisma Migration
```prisma
// prisma/schema.prisma

model User {
  id            Int      @id @default(autoincrement())
  email         String   @unique
  emailVerified Boolean  @default(false) // New field

  @@index([email])
}
```

## Common Operations

### Add Column
```sql
ALTER TABLE users ADD COLUMN phone VARCHAR(20);
```

### Remove Column
```sql
ALTER TABLE users DROP COLUMN phone;
```

### Rename Column
```sql
ALTER TABLE users RENAME COLUMN phone TO phone_number;
```

### Add Index
```sql
CREATE INDEX idx_users_email ON users(email);
CREATE UNIQUE INDEX idx_users_email_unique ON users(email);
```

### Add Foreign Key
```sql
ALTER TABLE orders
ADD CONSTRAINT fk_orders_user
FOREIGN KEY (user_id) REFERENCES users(id);
```

### Create Table
```sql
CREATE TABLE orders (
  id SERIAL PRIMARY KEY,
  user_id INTEGER NOT NULL REFERENCES users(id),
  total DECIMAL(10,2) NOT NULL,
  status VARCHAR(50) DEFAULT 'pending',
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
```

## Migration Checklist

### Before Running
- [ ] Backup database
- [ ] Test migration on staging
- [ ] Review SQL generated
- [ ] Check for data loss risks
- [ ] Estimate downtime (if any)
- [ ] Prepare rollback plan

### Data Migrations
- [ ] Handle NULL values
- [ ] Set appropriate defaults
- [ ] Migrate existing data if needed
- [ ] Verify data integrity after

### After Running
- [ ] Verify schema changes
- [ ] Check application works
- [ ] Monitor for errors
- [ ] Update documentation

## Zero-Downtime Migrations

### Adding Column
```sql
-- Safe: add nullable column
ALTER TABLE users ADD COLUMN new_col VARCHAR(100);

-- Then: backfill data
UPDATE users SET new_col = 'default' WHERE new_col IS NULL;

-- Then: add constraint (if needed)
ALTER TABLE users ALTER COLUMN new_col SET NOT NULL;
```

### Removing Column
```sql
-- Step 1: Stop writing to column (in app code)
-- Step 2: Deploy code change
-- Step 3: Drop column
ALTER TABLE users DROP COLUMN old_col;
```

### Renaming Column
```sql
-- Step 1: Add new column
ALTER TABLE users ADD COLUMN new_name VARCHAR(100);

-- Step 2: Copy data
UPDATE users SET new_name = old_name;

-- Step 3: Update app to use new column
-- Step 4: Drop old column
ALTER TABLE users DROP COLUMN old_name;
```

## Quick Commands
```
/migration create [name]     # Generate migration file
/migration status            # Show migration status
/migration run               # Run pending migrations
/migration rollback          # Rollback last migration
/migration checklist         # Pre-migration checklist
```

---
Last updated: 2026-01-29
