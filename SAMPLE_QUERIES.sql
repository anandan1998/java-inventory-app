-- Sample SQL Queries for Inventory Management System

-- ==================================
-- USEFUL QUERIES FOR TESTING
-- ==================================

-- 1. View all products with category information
SELECT 
    p.id,
    p.sku,
    p.name AS product_name,
    p.price,
    p.quantity,
    p.reorder_level,
    p.status,
    c.name AS category_name,
    p.created_at
FROM products p
JOIN categories c ON p.category_id = c.id
ORDER BY p.created_at DESC;

-- 2. Find products that need reordering (low stock)
SELECT 
    p.sku,
    p.name,
    p.quantity AS current_stock,
    p.reorder_level,
    (p.reorder_level - p.quantity) AS shortage,
    c.name AS category
FROM products p
JOIN categories c ON p.category_id = c.id
WHERE p.quantity <= p.reorder_level
ORDER BY shortage DESC;

-- 3. Get inventory value by category
SELECT 
    c.name AS category,
    COUNT(p.id) AS product_count,
    SUM(p.quantity) AS total_quantity,
    SUM(p.price * p.quantity) AS total_value
FROM categories c
LEFT JOIN products p ON c.id = p.category_id
GROUP BY c.id, c.name
ORDER BY total_value DESC;

-- 4. View all users with their roles
SELECT 
    u.id,
    u.username,
    u.email,
    u.full_name,
    u.enabled,
    STRING_AGG(r.name::text, ', ') AS roles
FROM users u
LEFT JOIN user_roles ur ON u.id = ur.user_id
LEFT JOIN roles r ON ur.role_id = r.id
GROUP BY u.id, u.username, u.email, u.full_name, u.enabled
ORDER BY u.created_at DESC;

-- 5. Products by status
SELECT 
    status,
    COUNT(*) AS count,
    SUM(quantity) AS total_quantity,
    SUM(price * quantity) AS total_value
FROM products
GROUP BY status
ORDER BY count DESC;

-- 6. Categories with product counts
SELECT 
    c.id,
    c.name,
    c.description,
    COUNT(p.id) AS product_count,
    COALESCE(SUM(p.quantity), 0) AS total_stock
FROM categories c
LEFT JOIN products p ON c.id = p.category_id
GROUP BY c.id, c.name, c.description
ORDER BY product_count DESC;

-- 7. Most expensive products
SELECT 
    p.sku,
    p.name,
    p.price,
    p.quantity,
    (p.price * p.quantity) AS total_value,
    c.name AS category
FROM products p
JOIN categories c ON p.category_id = c.id
ORDER BY p.price DESC
LIMIT 10;

-- 8. Recently added products
SELECT 
    p.sku,
    p.name,
    p.price,
    p.quantity,
    c.name AS category,
    p.created_at
FROM products p
JOIN categories c ON p.category_id = c.id
ORDER BY p.created_at DESC
LIMIT 10;

-- 9. Out of stock products
SELECT 
    p.sku,
    p.name,
    c.name AS category,
    p.reorder_level,
    p.updated_at AS last_updated
FROM products p
JOIN categories c ON p.category_id = c.id
WHERE p.quantity = 0
ORDER BY p.updated_at DESC;

-- 10. Search products by name or description
SELECT 
    p.sku,
    p.name,
    p.description,
    p.price,
    c.name AS category
FROM products p
JOIN categories c ON p.category_id = c.id
WHERE 
    LOWER(p.name) LIKE LOWER('%laptop%') 
    OR LOWER(p.description) LIKE LOWER('%laptop%')
ORDER BY p.name;

-- ==================================
-- DATA MAINTENANCE QUERIES
-- ==================================

-- Update product status based on quantity
UPDATE products 
SET status = CASE 
    WHEN quantity = 0 THEN 'OUT_OF_STOCK'
    WHEN quantity <= reorder_level THEN 'LOW_STOCK'
    ELSE 'ACTIVE'
END;

-- Update stock quantity for a product
UPDATE products 
SET 
    quantity = quantity - 5,  -- Reduce by 5 units
    updated_at = NOW()
WHERE sku = 'LAPTOP-001';

-- Mark discontinued products
UPDATE products 
SET 
    status = 'DISCONTINUED',
    updated_at = NOW()
WHERE id IN (1, 2, 3);

-- ==================================
-- ADMIN QUERIES
-- ==================================

-- Create admin user (password should be BCrypt encrypted)
-- Note: Use the API endpoint for proper password encryption
-- This is just for reference

-- Check database size
SELECT 
    pg_size_pretty(pg_database_size('inventory_db')) AS database_size;

-- Check table sizes
SELECT 
    schemaname,
    tablename,
    pg_size_pretty(pg_total_relation_size(schemaname||'.'||tablename)) AS size
FROM pg_tables
WHERE schemaname = 'public'
ORDER BY pg_total_relation_size(schemaname||'.'||tablename) DESC;

-- Recent activity (products modified in last 24 hours)
SELECT 
    p.sku,
    p.name,
    p.updated_at,
    c.name AS category
FROM products p
JOIN categories c ON p.category_id = c.id
WHERE p.updated_at >= NOW() - INTERVAL '24 hours'
ORDER BY p.updated_at DESC;

-- ==================================
-- REPORTS
-- ==================================

-- Monthly inventory summary
SELECT 
    DATE_TRUNC('month', created_at) AS month,
    COUNT(*) AS products_added,
    SUM(quantity) AS total_quantity_added
FROM products
GROUP BY DATE_TRUNC('month', created_at)
ORDER BY month DESC;

-- Inventory turnover (products with frequent updates)
SELECT 
    p.sku,
    p.name,
    p.quantity,
    p.updated_at,
    c.name AS category,
    DATE_PART('day', NOW() - p.updated_at) AS days_since_update
FROM products p
JOIN categories c ON p.category_id = c.id
WHERE p.updated_at >= NOW() - INTERVAL '30 days'
ORDER BY p.updated_at DESC;

-- ==================================
-- BACKUP QUERIES
-- ==================================

-- Create backup of products table
CREATE TABLE products_backup AS 
SELECT * FROM products;

-- Restore from backup (careful!)
-- TRUNCATE products;
-- INSERT INTO products SELECT * FROM products_backup;

-- ==================================
-- PERFORMANCE QUERIES
-- ==================================

-- Check indexes
SELECT 
    tablename,
    indexname,
    indexdef
FROM pg_indexes
WHERE schemaname = 'public'
ORDER BY tablename, indexname;

-- Analyze query performance
EXPLAIN ANALYZE
SELECT p.*, c.name AS category_name
FROM products p
JOIN categories c ON p.category_id = c.id
WHERE p.quantity <= p.reorder_level;

-- ==================================
-- CLEANUP QUERIES
-- ==================================

-- Delete discontinued products (be careful!)
-- DELETE FROM products WHERE status = 'DISCONTINUED';

-- Remove old audit logs (if you add audit logging)
-- DELETE FROM audit_logs WHERE created_at < NOW() - INTERVAL '90 days';

-- Reset sequences if needed
-- SELECT setval('products_id_seq', (SELECT MAX(id) FROM products));
-- SELECT setval('categories_id_seq', (SELECT MAX(id) FROM categories));
