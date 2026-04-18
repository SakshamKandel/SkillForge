# SkillForge - Enterprise Online Learning Platform

SkillForge is a robust, full-stack Java Dynamic Web Project tailored for managing online course catalogs, student enrollments, interactive quizzes, and profile tracking. Built utilizing the Jakarta EE ecosystem, the platform demonstrates strict adherence to the **Model-View-Controller (MVC) architectural pattern** without relying on excessive third-party frameworks.

The user interface leverages modern utility-first CSS implementations to provide a responsive, minimalist, flat-design experience inspired by industry-leading ed-tech platforms.

---

## 🚀 Key Features

### Administrator Capabilities
* **Secure Provisioning:** Automated AES-based password encryption and role-based access controls.
* **Course Catalog Management:** Full CRUD operations for published courses with integrated category associations.
* **Interactive Quiz Authoring:** Administrators can append questions to distinct courses, complete with multiple-choice validation.
* **Student Tracking:** Macro-level dashboard monitoring overall platform enrollments and user acquisitions.

### Student Experience
* **Course Enrollment Matrix:** Frictionless exploration and enrollment for platform offerings.
* **Interactive Assessments:** Gamified, responsive UI for taking course quizzes natively within the platform.
* **Progress Visualization:** Dashboard summaries showcasing completed courses, active assessments, and certification metrics.
* **Profile Management:** Self-service administrative controls for updating credentials and interface elements.

---

## 🏗️ Technical Architecture

SkillForge adheres to strict enterprise-standard separations of concern:

* **Presentation Layer (View):** Built entirely with JavaServer Pages (JSP). Styles are securely governed by centralized, decoupled CSS files to ensure presentation integrity.
* **Controller Layer:** Pure Java Servlets orchestrate data binding, session validation, and view resolution.
* **Service / Model Layer:** Distinct POJO models mapped directly to schema counterparts.
* **Data Access Layer:** Direct JDBC abstractions interacting with a 3rd Normal Form (3NF) relational database.

---

## 🛠️ Local Environment Setup

The repository is natively structured as an **Eclipse Dynamic Web Project** for zero-configuration imports. 

### Prerequisites
* Java JDK (Version 11+)
* Apache Tomcat Server (Version 9.0 or 10+)
* MySQL Server (via XAMPP or standalone)
* Eclipse IDE for Enterprise Java and Web Developers

### Installation Steps

1. **Database Schema:** 
   * Navigate to `http://localhost/phpmyadmin`
   * Provision a local database named `skillforge_db`
   * Import the bundled `skillforge_db.sql` schema file.

2. **Source Code Import:**
   * Open Eclipse IDE -> `File` -> `Import` -> `Existing Projects into Workspace`
   * Select the unzipped `SkillForge` directory. 

3. **Server Deployment:**
   * Validate that the `WEB-INF/lib` directory contains the `mysql-connector-j.jar` file.
   * Right-click the project folder -> `Run As` -> `Run on Server` -> Select Apache Tomcat.
   * The ecosystem will automatically compile the serverless `.class` artifacts and launch.

---

## 🔐 Standard Access Credentials

Upon executing the database dump, the following baseline credentials are provisioned:

| Privilege Level | Address Signature | Password Authentication |
| :--- | :--- | :--- |
| **System Administrator** | `admin@skillforge.com` | `Admin@2024` |
| **Standard Student** | `aarav@skillforge.com` | `Student@123` |
| **Standard Student** | `sushma@skillforge.com` | `Student@123` |

---
*Developed as a cornerstone demonstration of Jakarta EE implementations.*
