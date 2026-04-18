package com.skillforge.service;

import com.skillforge.config.DBConfig;
import com.skillforge.model.Course;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.LinkedHashMap;

/**
 * Business logic for course CRUD.
 * Queries JOIN with categories and instructors (3NF).
 */
public class CourseService {

    /* Base JOIN query used by most read operations */
    private static final String JOIN_SQL =
        "SELECT c.*, cat.name AS category_name, i.full_name AS instructor_name " +
        "FROM courses c " +
        "JOIN categories cat ON c.category_id = cat.id " +
        "JOIN instructors i ON c.instructor_id = i.id ";

    public List<Course> getAll() throws SQLException {
        return query(JOIN_SQL + "ORDER BY c.title");
    }

    public List<Course> getActive() throws SQLException {
        return query(JOIN_SQL + "WHERE c.active = 1 ORDER BY c.title");
    }

    /**
     * Active courses the student has NOT already enrolled in.
     */
    public List<Course> getAvailableForStudent(int studentId) throws SQLException {
        String sql = JOIN_SQL + "WHERE c.active = 1 AND c.id NOT IN " +
                     "(SELECT course_id FROM enrollments WHERE student_id = ?) ORDER BY c.title";
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
        String sql = JOIN_SQL + "WHERE c.title LIKE ? OR cat.name LIKE ? OR i.full_name LIKE ? ORDER BY c.title";
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
        String sql = JOIN_SQL + "WHERE c.id = ?";
        try (Connection c = DBConfig.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next() ? map(rs) : null;
            }
        }
    }

    /**
     * Search available (not already enrolled) courses for a student by keyword.
     */
    public List<Course> searchAvailableForStudent(int studentId, String keyword) throws SQLException {
        String sql = JOIN_SQL + "WHERE c.active = 1 AND c.id NOT IN " +
                     "(SELECT course_id FROM enrollments WHERE student_id = ?) " +
                     "AND (c.title LIKE ? OR cat.name LIKE ? OR i.full_name LIKE ?) ORDER BY c.title";
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

    public void add(Course course) throws SQLException {
        String sql = "INSERT INTO courses (title, category_id, instructor_id, duration_weeks, description, active) VALUES (?,?,?,?,?,?)";
        try (Connection c = DBConfig.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setString(1, course.getTitle());
            ps.setInt(2, course.getCategoryId());
            ps.setInt(3, course.getInstructorId());
            ps.setInt(4, course.getDurationWeeks());
            ps.setString(5, course.getDescription());
            ps.setInt(6, course.isActive() ? 1 : 0);
            ps.executeUpdate();
        }
    }

    public void update(Course course) throws SQLException {
        String sql = "UPDATE courses SET title=?, category_id=?, instructor_id=?, duration_weeks=?, description=?, active=? WHERE id=?";
        try (Connection c = DBConfig.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setString(1, course.getTitle());
            ps.setInt(2, course.getCategoryId());
            ps.setInt(3, course.getInstructorId());
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

    /* ========== Lookup helpers (for dropdowns) ========== */

    /** Returns all categories as a map of id → name. */
    public Map<Integer, String> getAllCategories() throws SQLException {
        Map<Integer, String> map = new LinkedHashMap<>();
        String sql = "SELECT id, name FROM categories ORDER BY name";
        try (Connection c = DBConfig.getConnection();
             Statement st = c.createStatement();
             ResultSet rs = st.executeQuery(sql)) {
            while (rs.next()) {
                map.put(rs.getInt("id"), rs.getString("name"));
            }
        }
        return map;
    }

    /** Returns all instructors as a map of id → full_name. */
    public Map<Integer, String> getAllInstructors() throws SQLException {
        Map<Integer, String> map = new LinkedHashMap<>();
        String sql = "SELECT id, full_name FROM instructors ORDER BY full_name";
        try (Connection c = DBConfig.getConnection();
             Statement st = c.createStatement();
             ResultSet rs = st.executeQuery(sql)) {
            while (rs.next()) {
                map.put(rs.getInt("id"), rs.getString("full_name"));
            }
        }
        return map;
    }

    /* ========== private helpers ========== */

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
        co.setCategoryId(rs.getInt("category_id"));
        co.setInstructorId(rs.getInt("instructor_id"));
        co.setDurationWeeks(rs.getInt("duration_weeks"));
        co.setDescription(rs.getString("description"));
        co.setActive(rs.getInt("active") == 1);
        co.setCategoryName(rs.getString("category_name"));
        co.setInstructorName(rs.getString("instructor_name"));
        return co;
    }
}
