CREATE DATABASE IF NOT EXISTS UserDB;
USE UserDB;

CREATE TABLE IF NOT EXISTS users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Sample Users
INSERT INTO users (username, password, email) VALUES 
('admin', 'Admin123', 'admin@example.com'),
('mukesh', 'password123', 'mukesh@example.com')
ON DUPLICATE KEY UPDATE username=username;
