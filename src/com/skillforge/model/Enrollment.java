package com.skillforge.model;

/**
 * JavaBean representing a row in the {@code enrollments} table,
 * enriched with joined columns from users and courses.
 */
public class Enrollment {

    private int    id;
    private int    studentId;
    private int    courseId;

    /* Joined fields */
    private String studentName;
    private String courseTitle;
    private String category;
    private String instructor;
    private int    durationWeeks;

    private String enrolledAt;
    private int    progress;
    private String status;

    /* ---------- No-arg constructor ---------- */
    public Enrollment() { }

    /* ---------- Getters & Setters ---------- */

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public int getStudentId() { return studentId; }
    public void setStudentId(int studentId) { this.studentId = studentId; }

    public int getCourseId() { return courseId; }
    public void setCourseId(int courseId) { this.courseId = courseId; }

    public String getStudentName() { return studentName; }
    public void setStudentName(String studentName) { this.studentName = studentName; }

    public String getCourseTitle() { return courseTitle; }
    public void setCourseTitle(String courseTitle) { this.courseTitle = courseTitle; }

    public String getCategory() { return category; }
    public void setCategory(String category) { this.category = category; }

    public String getInstructor() { return instructor; }
    public void setInstructor(String instructor) { this.instructor = instructor; }

    public int getDurationWeeks() { return durationWeeks; }
    public void setDurationWeeks(int durationWeeks) { this.durationWeeks = durationWeeks; }

    public String getEnrolledAt() { return enrolledAt; }
    public void setEnrolledAt(String enrolledAt) { this.enrolledAt = enrolledAt; }

    public int getProgress() { return progress; }
    public void setProgress(int progress) { this.progress = progress; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }
}
