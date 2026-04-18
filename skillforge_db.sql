-- =====================================================
-- SkillForge Database — Online Course Enrollment System
-- MySQL 8.x  ·  Run via XAMPP phpMyAdmin or CLI
-- Normalised to 3NF (categories & instructors extracted)
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
    profile_photo  LONGBLOB      DEFAULT NULL,
    joined_at      TIMESTAMP     DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB;

-- -------------------------------------------------
-- 2. categories  (3NF — eliminates transitive dependency)
-- -------------------------------------------------
CREATE TABLE categories (
    id             INT AUTO_INCREMENT PRIMARY KEY,
    name           VARCHAR(80)   NOT NULL UNIQUE
) ENGINE=InnoDB;

-- -------------------------------------------------
-- 3. instructors  (3NF — eliminates transitive dependency)
-- -------------------------------------------------
CREATE TABLE instructors (
    id             INT AUTO_INCREMENT PRIMARY KEY,
    full_name      VARCHAR(100)  NOT NULL,
    specialty      VARCHAR(100)  DEFAULT NULL
) ENGINE=InnoDB;

-- -------------------------------------------------
-- 4. courses  (now uses FK to categories & instructors)
-- -------------------------------------------------
CREATE TABLE courses (
    id              INT AUTO_INCREMENT PRIMARY KEY,
    title           VARCHAR(150)  NOT NULL,
    category_id     INT           NOT NULL,
    instructor_id   INT           NOT NULL,
    duration_weeks  INT           NOT NULL DEFAULT 4,
    description     TEXT,
    active          TINYINT       NOT NULL DEFAULT 1,
    created_at      TIMESTAMP     DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (category_id)   REFERENCES categories(id)   ON DELETE CASCADE,
    FOREIGN KEY (instructor_id) REFERENCES instructors(id)   ON DELETE CASCADE
) ENGINE=InnoDB;

-- -------------------------------------------------
-- 5. enrollments
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

-- -------------------------------------------------
-- 6. quizzes
-- -------------------------------------------------
CREATE TABLE quizzes (
    id             INT AUTO_INCREMENT PRIMARY KEY,
    course_id      INT           NOT NULL,
    title          VARCHAR(255)  NOT NULL,
    description    TEXT,
    passing_score  INT           DEFAULT 70,
    FOREIGN KEY (course_id) REFERENCES courses(id) ON DELETE CASCADE
) ENGINE=InnoDB;

-- -------------------------------------------------
-- 7. quiz_questions
-- -------------------------------------------------
CREATE TABLE quiz_questions (
    id             INT AUTO_INCREMENT PRIMARY KEY,
    quiz_id        INT           NOT NULL,
    question_text  TEXT          NOT NULL,
    option_a       VARCHAR(255)  NOT NULL,
    option_b       VARCHAR(255)  NOT NULL,
    option_c       VARCHAR(255)  NOT NULL,
    option_d       VARCHAR(255)  NOT NULL,
    correct_option CHAR(1)       NOT NULL, -- 'A', 'B', 'C', or 'D'
    FOREIGN KEY (quiz_id) REFERENCES quizzes(id) ON DELETE CASCADE
) ENGINE=InnoDB;

-- -------------------------------------------------
-- 8. quiz_attempts
-- -------------------------------------------------
CREATE TABLE quiz_attempts (
    id             INT AUTO_INCREMENT PRIMARY KEY,
    student_id     INT           NOT NULL,
    quiz_id        INT           NOT NULL,
    score          INT           NOT NULL,
    passed         TINYINT(1)    DEFAULT 0,
    attempted_at   TIMESTAMP     DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (student_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (quiz_id)    REFERENCES quizzes(id) ON DELETE CASCADE
) ENGINE=InnoDB;

-- -------------------------------------------------
-- 9. certifications
-- -------------------------------------------------
CREATE TABLE certifications (
    id             INT AUTO_INCREMENT PRIMARY KEY,
    student_id     INT           NOT NULL,
    course_id      INT           NOT NULL,
    attempt_id     INT           NOT NULL,
    cert_code      VARCHAR(50)   UNIQUE NOT NULL,
    issued_at      TIMESTAMP     DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (student_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (course_id)  REFERENCES courses(id) ON DELETE CASCADE,
    FOREIGN KEY (attempt_id) REFERENCES quiz_attempts(id) ON DELETE CASCADE
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

-- Categories (normalised from courses.category)
INSERT INTO categories (name) VALUES
('Programming'),     -- id=1
('Data Science'),    -- id=2
('Design'),          -- id=3
('Cloud'),           -- id=4
('Security');        -- id=5

-- Instructors (normalised from courses.instructor)
INSERT INTO instructors (full_name, specialty) VALUES
('Prof. Ramesh Khatri', 'Java & Enterprise Apps'),      -- id=1
('Dr. Anjali Mehta',    'Data Analytics & ML'),          -- id=2
('Sneha Gurung',        'UI/UX & Prototyping'),          -- id=3
('Bikash Adhikari',     'AWS & Cloud Infrastructure'),   -- id=4
('Priya Singh',         'Network Security & Ethics');    -- id=5

-- Courses (now referencing categories & instructors by FK)
INSERT INTO courses (title, category_id, instructor_id, duration_weeks, description) VALUES
('Java Full-Stack Development',  1, 1, 12, 'Master Java SE, Jakarta EE, JDBC, Servlets, JSP and build production-ready web applications from scratch.'),
('Data Science with Python',     2, 2,  8, 'Learn NumPy, Pandas, Matplotlib, Scikit-learn and real-world data analysis techniques with hands-on projects.'),
('UI/UX Design Fundamentals',    3, 3,  6, 'Explore user research, wireframing, prototyping and usability testing using Figma and Adobe XD.'),
('Cloud Computing on AWS',       4, 4, 10, 'Dive into EC2, S3, Lambda, RDS, VPC and prepare for the AWS Solutions Architect Associate exam.'),
('Cybersecurity Essentials',     5, 5,  8, 'Understand network security, ethical hacking, vulnerability assessment and incident response protocols.');

INSERT INTO enrollments (student_id, course_id, progress, status) VALUES
(2, 1, 45, 'active'),
(2, 3, 100, 'completed'),
(3, 2, 20, 'active');

-- -------------------------------------------------
-- QUIZ SEED DATA
-- -------------------------------------------------

INSERT INTO quizzes (course_id, title, description, passing_score) VALUES
(1, 'Java Fundamentals Quiz', 'Test your knowledge on core Java concepts like loops, classes, and inheritance.', 80),
(2, 'Python Data structures', 'Quiz covering Lists, Dictionaries, and NumPy basics.', 70),
(3, 'Figma & Design Principles', 'Focus on color theory and prototyping steps.', 75),
(4, 'AWS Core Services', 'IAM, EC2, and S3 knowledge check.', 80),
(5, 'Network Security Mastery', 'Assess your understanding of firewalls and encryption.', 70);

INSERT INTO quiz_questions (quiz_id, question_text, option_a, option_b, option_c, option_d, correct_option) VALUES
-- Java Quiz Questions
(1, 'Which of these is NOT a primitive type in Java?', 'int', 'boolean', 'String', 'char', 'C'),
(1, 'What is the default value of an uninitialized int variable?', '0', 'null', '1', 'undefined', 'A'),
(1, 'Which keyword is used to inherit a class in Java?', 'implements', 'extends', 'inherits', 'import', 'B'),
-- Python Quiz Questions
(2, 'Which data structure is mutable?', 'Tuple', 'String', 'List', 'None of the above', 'C'),
-- Figma Quiz Questions
(3, 'What is the primary tool for creating components in Figma?', 'Ctrl+K', 'Ctrl+Alt+K', 'Alt+C', 'Ctrl+Shift+K', 'B'),
-- AWS Quiz Questions
(4, 'Which AWS service provides scalable object storage?', 'EC2', 'RDS', 'S3', 'Lambda', 'C'),
-- Cybersecurity Quiz Questions
(5, 'What does TLS stand for?', 'Total Level Security', 'Transport Layer Security', 'Time Limit System', 'Trust Layer Solution', 'B');
