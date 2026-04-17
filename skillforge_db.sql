-- =====================================================
-- SkillForge Database — Online Course Enrollment System
-- MySQL 8.x  ·  Run via XAMPP phpMyAdmin or CLI
-- =====================================================

DROP DATABASE IF EXISTS skillforge_db;
CREATE DATABASE skillforge_db CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;
USE skillforge_db;

-- -------------------------------------------------
-- 1. users
-- -------------------------------------------------
CREATE TABLE users (
    id             INT AUTO_INCREMENT PRIMARY KEY,
    full_name      VARCHAR(100)  NOT NULL,
    email          VARCHAR(150)  NOT NULL UNIQUE,
    password       VARCHAR(255)  NOT NULL,
    phone          VARCHAR(15)   NOT NULL UNIQUE,
    role           ENUM('admin','student') NOT NULL DEFAULT 'student',
    failed_attempts INT          NOT NULL DEFAULT 0,
    is_locked      TINYINT       NOT NULL DEFAULT 0,
    reset_token    VARCHAR(100)  DEFAULT NULL,
    joined_at      TIMESTAMP     DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB;

-- -------------------------------------------------
-- 2. courses
-- -------------------------------------------------
CREATE TABLE courses (
    id             INT AUTO_INCREMENT PRIMARY KEY,
    title          VARCHAR(150)  NOT NULL,
    category       VARCHAR(80)   NOT NULL,
    instructor     VARCHAR(100)  NOT NULL,
    duration_weeks INT           NOT NULL DEFAULT 4,
    description    TEXT,
    active         TINYINT       NOT NULL DEFAULT 1,
    created_at     TIMESTAMP     DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB;

-- -------------------------------------------------
-- 3. enrollments
-- -------------------------------------------------
CREATE TABLE enrollments (
    id             INT AUTO_INCREMENT PRIMARY KEY,
    student_id     INT           NOT NULL,
    course_id      INT           NOT NULL,
    enrolled_at    TIMESTAMP     DEFAULT CURRENT_TIMESTAMP,
    progress       INT           NOT NULL DEFAULT 0 CHECK (progress BETWEEN 0 AND 100),
    status         ENUM('active','completed','dropped') NOT NULL DEFAULT 'active',
    UNIQUE KEY uq_student_course (student_id, course_id),
    FOREIGN KEY (student_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (course_id)  REFERENCES courses(id) ON DELETE CASCADE
) ENGINE=InnoDB;

-- =====================================================
-- SEED DATA
-- =====================================================

-- Passwords encrypted with AES/ECB/PKCS5Padding, key = SkillForge@2024!
-- admin@skillforge.com  / Admin@2024   → ei0KBl/vjaQwtSKyyWetNg==
-- aarav@skillforge.com  / Student@123  → tJILQnKTUAuVe8YKTE8M2g==
-- sushma@skillforge.com / Student@123  → tJILQnKTUAuVe8YKTE8M2g==

INSERT INTO users (full_name, email, password, phone, role) VALUES
('Admin User',   'admin@skillforge.com',  'ei0KBl/vjaQwtSKyyWetNg==',  '9800000001', 'admin'),
('Aarav Sharma',  'aarav@skillforge.com',  'tJILQnKTUAuVe8YKTE8M2g==',  '9800000002', 'student'),
('Sushma Thapa',  'sushma@skillforge.com', 'tJILQnKTUAuVe8YKTE8M2g==',  '9800000003', 'student');

INSERT INTO courses (title, category, instructor, duration_weeks, description) VALUES
('Java Full-Stack Development',  'Programming',   'Prof. Ramesh Khatri',  12, 'Master Java SE, Jakarta EE, JDBC, Servlets, JSP and build production-ready web applications from scratch.'),
('Data Science with Python',     'Data Science',   'Dr. Anjali Mehta',      8, 'Learn NumPy, Pandas, Matplotlib, Scikit-learn and real-world data analysis techniques with hands-on projects.'),
('UI/UX Design Fundamentals',    'Design',         'Sneha Gurung',          6, 'Explore user research, wireframing, prototyping and usability testing using Figma and Adobe XD.'),
('Cloud Computing on AWS',       'Cloud',          'Bikash Adhikari',      10, 'Dive into EC2, S3, Lambda, RDS, VPC and prepare for the AWS Solutions Architect Associate exam.'),
('Cybersecurity Essentials',     'Security',       'Priya Singh',           8, 'Understand network security, ethical hacking, vulnerability assessment and incident response protocols.');

INSERT INTO enrollments (student_id, course_id, progress, status) VALUES
(2, 1, 45, 'active'),
(2, 3, 100, 'completed'),
(3, 2, 20, 'active');
