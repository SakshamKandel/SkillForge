# SkillForge - Online Course Enrollment & Tracking

SkillForge is a full-stack Java Dynamic Web Project designed for managing online course catalogs and student progress. It is built using the Jakarta EE platform with pure Servlets, JSP, and JDBC, following a strict Model-View-Controller (MVC) architecture without external frameworks.

## Features
- **Admin Panel**: Dashboard for metrics, Course CRUD with search, and student account management.
- **Student Portal**: Course browsing, enrollment, and self-reported progress tracking.
- **Authentication**: Role-based access control with secure AES password encryption.
- **Security**: Account lockout protection, input validation, and secure session management.

## Project Structure
- `src/`: Core Java controllers, services, models, and utility classes.
- `WebContent/`: Frontend JSP views, CSS, and web configuration (web.xml).
- `tooling/`: Contains the necessary JDK and Tomcat binaries for local execution.
- `skillforge_db.sql`: Database schema and initial seed data.

## Local Setup
1. **Database**: Import `skillforge_db.sql` into local MySQL (e.g., via XAMPP).
2. **Library**: Add `mysql-connector-j-9.6.0.jar` to `WEB-INF/lib`.
3. **IDE**: Import as a Dynamic Web Project in Eclipse or IntelliJ.
4. **Run**: Deploy to Tomcat 10.1 or higher.

### Quick Start (PowerShell)
For a portable runtime experience, you can use the included script:
```powershell
.\run.ps1
```
The application will be available at `http://localhost:8082/SkillForge/`.

## Default Access
- **Administrator**: admin@skillforge.com / Admin@2024
- **Student**: aarav@skillforge.com / Student@123
