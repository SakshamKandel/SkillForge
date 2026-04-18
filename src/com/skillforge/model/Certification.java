package com.skillforge.model;

/**
 * POJO representing an automated certification issued to a student.
 */
public class Certification {
    private int id;
    private int studentId;
    private int courseId;
    private int attemptId;
    private String certCode;
    private String issuedAt;

    // Joined fields for display
    private String studentName;
    private String courseTitle;

    public Certification() {}

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public int getStudentId() { return studentId; }
    public void setStudentId(int studentId) { this.studentId = studentId; }

    public int getCourseId() { return courseId; }
    public void setCourseId(int courseId) { this.courseId = courseId; }

    public int getAttemptId() { return attemptId; }
    public void setAttemptId(int attemptId) { this.attemptId = attemptId; }

    public String getCertCode() { return certCode; }
    public void setCertCode(String certCode) { this.certCode = certCode; }

    public String getIssuedAt() { return issuedAt; }
    public void setIssuedAt(String issuedAt) { this.issuedAt = issuedAt; }

    public String getStudentName() { return studentName; }
    public void setStudentName(String studentName) { this.studentName = studentName; }

    public String getCourseTitle() { return courseTitle; }
    public void setCourseTitle(String courseTitle) { this.courseTitle = courseTitle; }
}
