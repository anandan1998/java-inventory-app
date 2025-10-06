-- Initialize Roles
INSERT INTO roles (name, description) VALUES 
('ROLE_USER', 'Standard user with read access to view products and categories'),
('ROLE_MANAGER', 'Manager with read/write access to manage inventory'),
('ROLE_ADMIN', 'Administrator with full access to all system features')
ON CONFLICT DO NOTHING;

-- Create initial categories
INSERT INTO categories (name, description, created_at, updated_at) VALUES 
('Electronics', 'Electronic devices and accessories', NOW(), NOW()),
('Furniture', 'Office and home furniture', NOW(), NOW()),
('Stationery', 'Office supplies and stationery items', NOW(), NOW()),
('Hardware', 'Computer hardware and components', NOW(), NOW()),
('Software', 'Software licenses and applications', NOW(), NOW())
ON CONFLICT DO NOTHING;

-- Note: To create an admin user, you'll need to:
-- 1. Register through the API first (POST /api/auth/register)
-- 2. Or manually insert a user with encoded password
-- 
-- Example (password is 'admin123' - BCrypt encoded):
-- INSERT INTO users (username, email, password, full_name, enabled, created_at, updated_at)
-- VALUES ('admin', 'admin@inventory.com', '$2a$10$xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx', 'System Admin', true, NOW(), NOW());
-- 
-- Then link to admin role:
-- INSERT INTO user_roles (user_id, role_id)
-- SELECT u.id, r.id FROM users u, roles r WHERE u.username = 'admin' AND r.name = 'ROLE_ADMIN';
