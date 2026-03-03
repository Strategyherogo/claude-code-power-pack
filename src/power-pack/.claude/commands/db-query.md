# Skill: db-query
Database query assistance and optimization.

## Auto-Trigger
**When:** "query", "sql", "database", "select", "join"

## Query Patterns

### Basic SELECT
```sql
-- All columns
SELECT * FROM table_name LIMIT 10;

-- Specific columns
SELECT col1, col2, col3
FROM table_name
WHERE condition
ORDER BY col1 DESC
LIMIT 100;
```

### JOINs
```sql
-- INNER JOIN (matching rows only)
SELECT a.*, b.related_field
FROM table_a a
INNER JOIN table_b b ON a.id = b.a_id;

-- LEFT JOIN (all from left, matched from right)
SELECT a.*, b.related_field
FROM table_a a
LEFT JOIN table_b b ON a.id = b.a_id;

-- Multiple JOINs
SELECT a.*, b.field, c.field
FROM table_a a
JOIN table_b b ON a.id = b.a_id
JOIN table_c c ON b.id = c.b_id
WHERE a.status = 'active';
```

### Aggregations
```sql
-- Count
SELECT status, COUNT(*) as count
FROM orders
GROUP BY status;

-- Sum/Avg
SELECT category,
       SUM(amount) as total,
       AVG(amount) as average,
       COUNT(*) as count
FROM transactions
GROUP BY category
HAVING SUM(amount) > 1000;

-- Date grouping
SELECT DATE(created_at) as date,
       COUNT(*) as daily_count
FROM events
WHERE created_at >= DATE_SUB(NOW(), INTERVAL 30 DAY)
GROUP BY DATE(created_at)
ORDER BY date;
```

### Subqueries
```sql
-- In WHERE
SELECT * FROM orders
WHERE customer_id IN (
    SELECT id FROM customers WHERE country = 'US'
);

-- In FROM
SELECT avg_amount, category
FROM (
    SELECT category, AVG(amount) as avg_amount
    FROM transactions
    GROUP BY category
) subquery
WHERE avg_amount > 100;

-- Correlated subquery
SELECT * FROM orders o
WHERE amount > (
    SELECT AVG(amount)
    FROM orders
    WHERE customer_id = o.customer_id
);
```

### CTEs (Common Table Expressions)
```sql
WITH monthly_totals AS (
    SELECT DATE_TRUNC('month', date) as month,
           SUM(amount) as total
    FROM transactions
    GROUP BY DATE_TRUNC('month', date)
),
growth AS (
    SELECT month,
           total,
           LAG(total) OVER (ORDER BY month) as prev_total
    FROM monthly_totals
)
SELECT month,
       total,
       ROUND((total - prev_total) / prev_total * 100, 2) as growth_pct
FROM growth;
```

## Query Optimization

### Index Usage
```sql
-- Check if query uses index
EXPLAIN ANALYZE SELECT * FROM table WHERE indexed_col = 'value';

-- Create index
CREATE INDEX idx_table_col ON table(column);

-- Composite index
CREATE INDEX idx_table_multi ON table(col1, col2);
```

### Performance Tips
```
✅ Do:
- Use specific columns, not SELECT *
- Add indexes on WHERE/JOIN columns
- Use LIMIT for exploration
- Use EXPLAIN ANALYZE

❌ Don't:
- SELECT * in production
- Use functions on indexed columns in WHERE
- Join large tables without conditions
- Nest subqueries when CTEs work
```

## SQLite Specifics (for your health database)
```sql
-- Your database location
-- Data_Analytics/00_ACTIVE_PROJECTS/Personal_Health_Analysis/unified_personal_data_2025.db

-- Sample query
SELECT date, hrv_rmssd, stress_day, energy_day
FROM daily_metrics
WHERE hrv_rmssd IS NOT NULL
ORDER BY date DESC
LIMIT 30;

-- Aggregate by day of week
SELECT day_of_week,
       AVG(stress_day) as avg_stress,
       AVG(energy_day) as avg_energy
FROM daily_metrics
GROUP BY day_of_week;
```

---
Last updated: 2026-01-27
