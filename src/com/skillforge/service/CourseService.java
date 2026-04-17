package com.skillforge.service;

import com.skillforge.config.DBConfig;
import com.skillforge.model.Course;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * Business logic for course CRUD.
 */
public class CourseService {

    public List<Course> getAll() throws SQLException {
        return query("SELECT * FROM courses ORDER BY title");
    }

    public List<Course> getActive() throws SQLException {
        return query("SELECT * FROM courses WHERE active = 1 ORDER BY title");
    }

    /**
     * Active courses the student has NOT already enrolled in.
     */
    public List<Course> getAvailableForStudent(int studentId) throws SQLException {
        String sql = "SELECT * FROM courses WHERE active = 1 AND id NOT IN " +
                     "(SELECT course_id FROM enrollments WHERE student_id = ?) ORDER BY title";
        List<Course> list = new ArrayList<>();
        try (Connection c = DBConfig.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, studentId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) list.add(map(rs));
            }
        }
        return list;
    }

    public List<Course> search(String keyword) throws SQLException {
        String sql = "SELECT * FROM courses WHERE title LIKE ? OR category LIKE ? OR instructor LIKE ? ORDER BY title";
        List<Course> list = new ArrayList<>();
        String kw = "%" + keyword + "%";
        try (Connection c = DBConfig.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setString(1, kw);
            ps.setString(2, kw);
            ps.setString(3, kw);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) list.add(map(rs));
            }
        }
        return list;
    }

    public Course findById(int id) throws SQLException {
        String sql = "SELECT * FROM courses WHERE id = ?";
        try (Connection c = DBConfig.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next() ? map(rs) : null;
            }
        }
    }

    public void add(Course course) throws SQLException {
        String sql = "INSERT INTO courses (title, category, instructor, duration_weeks, description, active) VALUES (?,?,?,?,?,?)";
        try (Connection c = DBConfig.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setString(1, course.getTitle());
            ps.setString(2, course.getCategory());
            ps.setString(3, course.getInstructor());
            ps.setInt(4, course.getDurationWeeks());
            ps.setString(5, course.getDescription());
            ps.setInt(6, course.isActive() ? 1 : 0);
            ps.executeUpdate();
        }
    }

    /**
     * Search available (not already enrolled) courses for a student by keyword.
     */
    public List<Course> searchAvailableForStudent(int studentId, String keyword) throws SQLException {
        String sql = "SELECT * FROM courses WHERE active = 1 AND id NOT IN " +
                     "(SELECT course_id FROM enrollments WHERE student_id = ?) " +
                     "AND (title LIKE ? OR category LIKE ? OR instructor LIKE ?) ORDER BY title";
        List<Course> list = new ArrayList<>();
        String kw = "%" + keyword + "%";
        try (Connection c = DBConfig.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, studentId);
            ps.setString(2, kw);
            ps.setString(3, kw);
            ps.setString(4, kw);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) list.add(map(rs));
            }
        }
        return list;
    }

    public void update(Course course) throws SQLException {
        String sql = "UPDATE courses SET title=?, category=?, instructor=?, duration_weeks=?, description=?, active=? WHERE id=?";
        try (Connection c = DBConfig.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setString(1, course.getTitle());
            ps.setString(2, course.getCategory());
            ps.setString(3, course.getInstructor());
            ps.setInt(4, course.getDurationWeeks());
            ps.setString(5, course.getDescription());
            ps.setInt(6, course.isActive() ? 1 : 0);
            ps.setInt(7, course.getId());
            ps.executeUpdate();
        }
    }

    public void delete(int id) throws SQLException {
        try (Connection c = DBConfig.getConnection()) {
            c.setAutoCommit(false);
            try {
                // Remove enrollments first
                String delEnroll = "DELETE FROM enrollments WHERE student_id IS NOT NULL AND course_id = ?";
                try (PreparedStatement ps1 = c.prepareStatement(delEnroll)) {
                    ps1.setInt(1, id);
                    ps1.executeUpdate();
                }
                
                // Remove course
                String delCourse = "DELETE FROM courses WHERE id = ?";
                try (PreparedStatement ps2 = c.prepareStatement(delCourse)) {
                    ps2.setInt(1, id);
                    ps2.executeUpdate();
                }
                
                c.commit();
            } catch (SQLException e) {
                c.rollback();
                throw e;
            } finally {
                c.setAutoCommit(true);
            }
        }
    }

    public int countAll() throws SQLException {
        try (Connection c = DBConfig.getConnection();
             Statement st = c.createStatement();
             ResultSet rs = st.executeQuery("SELECT COUNT(*) FROM courses")) {
            rs.next();
            return rs.getInt(1);
        }
    }

    /* ========== helpers ========== */

    private List<Course> query(String sql) throws SQLException {
        List<Course> list = new ArrayList<>();
        try (Connection c = DBConfig.getConnection();
             Statement st = c.createStatement();
             ResultSet rs = st.executeQuery(sql)) {
            while (rs.next()) list.add(map(rs));
        }
        return list;
    }

    private Course map(ResultSet rs) throws SQLException {
        Course co = new Course();
        co.setId(rs.getInt("id"));
        co.setTitle(rs.getString("title"));
        co.setCategory(rs.getString("category"));
        co.setInstructor(rs.getString("instructor"));
        co.setDurationWeeks(rs.getInt("duration_weeks"));
        co.setDescription(rs.getString("description"));
        co.setActive(rs.getInt("active") == 1);
        return co;
    }
}
