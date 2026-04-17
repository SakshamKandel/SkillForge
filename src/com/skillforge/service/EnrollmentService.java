package com.skillforge.service;

import com.skillforge.config.DBConfig;
import com.skillforge.model.Enrollment;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/// Business logic for enrollments
public class EnrollmentService {

    private static final String JOIN_SQL =
        "SELECT e.*, u.full_name AS student_name, c.title AS course_title, " +
        "c.category, c.instructor, c.duration_weeks " +
        "FROM enrollments e " +
        "JOIN users u ON e.student_id = u.id " +
        "JOIN courses c ON e.course_id = c.id ";

    /** All enrollments (admin view). */
    public List<Enrollment> getAll() throws SQLException {
        return query(JOIN_SQL + "ORDER BY e.enrolled_at DESC");
    }

    /** Enrollments for a specific student. */
    public List<Enrollment> getByStudent(int studentId) throws SQLException {
        String sql = JOIN_SQL + "WHERE e.student_id = ? ORDER BY e.enrolled_at DESC";
        List<Enrollment> list = new ArrayList<>();
        try (Connection c = DBConfig.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, studentId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) list.add(map(rs));
            }
        }
        return list;
    }

    /** Check duplicate enrollment. */
    public boolean alreadyEnrolled(int studentId, int courseId) throws SQLException {
        String sql = "SELECT id FROM enrollments WHERE student_id = ? AND course_id = ?";
        try (Connection c = DBConfig.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, studentId);
            ps.setInt(2, courseId);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next();
            }
        }
    }

    /** Enroll a student in a course. */
    public void enroll(int studentId, int courseId) throws SQLException {
        String sql = "INSERT INTO enrollments (student_id, course_id) VALUES (?,?)";
        try (Connection c = DBConfig.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, studentId);
            ps.setInt(2, courseId);
            ps.executeUpdate();
        }
    }

    /**
     * Update progress. Clamps to 100. Auto-sets status='completed' when >= 100.
     * Only the owning student can update their own enrollment.
     */
    public void updateProgress(int enrollmentId, int studentId, int progress) throws SQLException {
        if (progress > 100) progress = 100;
        if (progress < 0) progress = 0;
        String status = progress >= 100 ? "completed" : "active";
        String sql = "UPDATE enrollments SET progress = ?, status = ? WHERE id = ? AND student_id = ?";
        try (Connection c = DBConfig.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, progress);
            ps.setString(2, status);
            ps.setInt(3, enrollmentId);
            ps.setInt(4, studentId);
            ps.executeUpdate();
        }
    }

    /** Drop an enrollment (Physically deletes the record). */
    public void drop(int enrollmentId, int studentId) throws SQLException {
        String sql = "DELETE FROM enrollments WHERE id = ? AND student_id = ?";
        try (Connection c = DBConfig.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, enrollmentId);
            ps.setInt(2, studentId);
            ps.executeUpdate();
        }
    }

    /* Counts */

    public int countAll() throws SQLException {
        return count("SELECT COUNT(*) FROM enrollments");
    }

    public int countByStudent(int studentId) throws SQLException {
        String sql = "SELECT COUNT(*) FROM enrollments WHERE student_id = ?";
        try (Connection c = DBConfig.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, studentId);
            try (ResultSet rs = ps.executeQuery()) {
                rs.next();
                return rs.getInt(1);
            }
        }
    }

    public int countCompleted(int studentId) throws SQLException {
        String sql = "SELECT COUNT(*) FROM enrollments WHERE student_id = ? AND status = 'completed'";
        try (Connection c = DBConfig.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, studentId);
            try (ResultSet rs = ps.executeQuery()) {
                rs.next();
                return rs.getInt(1);
            }
        }
    }

    /* Helpers */

    private List<Enrollment> query(String sql) throws SQLException {
        List<Enrollment> list = new ArrayList<>();
        try (Connection c = DBConfig.getConnection();
             Statement st = c.createStatement();
             ResultSet rs = st.executeQuery(sql)) {
            while (rs.next()) list.add(map(rs));
        }
        return list;
    }

    private int count(String sql) throws SQLException {
        try (Connection c = DBConfig.getConnection();
             Statement st = c.createStatement();
             ResultSet rs = st.executeQuery(sql)) {
            rs.next();
            return rs.getInt(1);
        }
    }

    private Enrollment map(ResultSet rs) throws SQLException {
        Enrollment e = new Enrollment();
        e.setId(rs.getInt("id"));
        e.setStudentId(rs.getInt("student_id"));
        e.setCourseId(rs.getInt("course_id"));
        e.setStudentName(rs.getString("student_name"));
        e.setCourseTitle(rs.getString("course_title"));
        e.setCategory(rs.getString("category"));
        e.setInstructor(rs.getString("instructor"));
        e.setDurationWeeks(rs.getInt("duration_weeks"));
        e.setEnrolledAt(rs.getString("enrolled_at"));
        e.setProgress(rs.getInt("progress"));
        e.setStatus(rs.getString("status"));
        return e;
    }
}
