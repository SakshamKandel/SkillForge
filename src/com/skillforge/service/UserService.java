package com.skillforge.service;

import com.skillforge.config.DBConfig;
import com.skillforge.model.User;
import com.skillforge.util.CipherUtil;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.UUID;

// Business logic for users
public class UserService {

    // Register a new student
    public void register(User user) throws Exception {
        String sql = "INSERT INTO users (full_name, email, password, phone, role) VALUES (?,?,?,?,?)";
        try (Connection c = DBConfig.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setString(1, user.getFullName());
            ps.setString(2, user.getEmail());
            ps.setString(3, CipherUtil.encrypt(user.getPassword()));
            ps.setString(4, user.getPhone());
            ps.setString(5, "student");
            ps.executeUpdate();
        }
    }

    /* ---- Authenticate ---- */
    public User authenticate(String email, String rawPassword) throws Exception {
        String sql = "SELECT * FROM users WHERE email = ?";
        try (Connection c = DBConfig.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setString(1, email);
            try (ResultSet rs = ps.executeQuery()) {
                if (!rs.next()) throw new Exception("Invalid email or password.");

                User u = map(rs);

                if (u.isLocked()) {
                    throw new Exception("Account is locked after 5 failed attempts. Contact admin.");
                }

                String decrypted = CipherUtil.decrypt(u.getPassword());
                if (!decrypted.equals(rawPassword)) {
                    incrementFailed(u.getId());
                    if (u.getFailedAttempts() + 1 >= 5) {
                        lockAccount(u.getId());
                        throw new Exception("Account locked after 5 failed attempts. Contact admin.");
                    }
                    throw new Exception("Invalid email or password.");
                }

                // success — reset counter
                resetFailed(u.getId());
                return u;
            }
        }
    }

    /* ---- Duplicate checks ---- */
    public boolean emailTaken(String email) throws SQLException {
        return exists("SELECT id FROM users WHERE email = ?", email);
    }

    public boolean phoneTaken(String phone) throws SQLException {
        return exists("SELECT id FROM users WHERE phone = ?", phone);
    }

    /* ---- Find / list ---- */
    public User findById(int id) throws SQLException {
        String sql = "SELECT * FROM users WHERE id = ?";
        try (Connection c = DBConfig.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next() ? map(rs) : null;
            }
        }
    }

    public User findByEmail(String email) throws SQLException {
        String sql = "SELECT * FROM users WHERE email = ?";
        try (Connection c = DBConfig.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setString(1, email);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next() ? map(rs) : null;
            }
        }
    }

    /**
     * Auto-register a student that signed in via Google.
     * The phone column is NOT NULL UNIQUE in the existing schema, so we
     * synthesise a 10-digit pseudo-phone from the Google subject id.
     * The stored password is a random encrypted string the user never sees.
     */
    public User registerGoogleUser(String email, String fullName, String googleSub) throws Exception {
        String phone     = pseudoPhoneFromSub(googleSub);
        String randomPwd = UUID.randomUUID().toString();

        String sql = "INSERT INTO users (full_name, email, password, phone, role) VALUES (?,?,?,?,?)";
        try (Connection c = DBConfig.getConnection();
             PreparedStatement ps = c.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setString(1, fullName);
            ps.setString(2, email);
            ps.setString(3, CipherUtil.encrypt(randomPwd));
            ps.setString(4, phone);
            ps.setString(5, "student");
            ps.executeUpdate();
            try (ResultSet rs = ps.getGeneratedKeys()) {
                rs.next();
                return findById(rs.getInt(1));
            }
        }
    }

    /** Take the last 10 digits of the Google subject id, left-pad with zeros if shorter. */
    private static String pseudoPhoneFromSub(String sub) {
        String digits = (sub == null) ? "" : sub.replaceAll("[^0-9]", "");
        if (digits.length() >= 10) {
            return digits.substring(digits.length() - 10);
        }
        StringBuilder sb = new StringBuilder(digits);
        while (sb.length() < 10) sb.insert(0, '0');
        return sb.toString();
    }

    public List<User> getAllStudents() throws SQLException {
        List<User> list = new ArrayList<>();
        String sql = "SELECT * FROM users WHERE role = 'student' ORDER BY full_name";
        try (Connection c = DBConfig.getConnection();
             Statement st = c.createStatement();
             ResultSet rs = st.executeQuery(sql)) {
            while (rs.next()) list.add(map(rs));
        }
        return list;
    }

    /* ---- Profile ---- */
    public void editProfile(int id, String fullName, String phone) throws SQLException {
        String sql = "UPDATE users SET full_name = ?, phone = ? WHERE id = ?";
        try (Connection c = DBConfig.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setString(1, fullName);
            ps.setString(2, phone);
            ps.setInt(3, id);
            ps.executeUpdate();
        }
    }

    public void updateProfilePhoto(int id, java.io.InputStream photoData) throws SQLException {
        String sql = "UPDATE users SET profile_photo = ? WHERE id = ?";
        try (Connection c = DBConfig.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setBinaryStream(1, photoData);
            ps.setInt(2, id);
            ps.executeUpdate();
        }
    }

    public void changePassword(int id, String newPwd) throws Exception {
        String sql = "UPDATE users SET password = ? WHERE id = ?";
        try (Connection c = DBConfig.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setString(1, CipherUtil.encrypt(newPwd));
            ps.setInt(2, id);
            ps.executeUpdate();
        }
    }

    /* ---- Admin actions ---- */
    public void removeStudent(int id) throws SQLException {
        String sql = "DELETE FROM users WHERE id = ? AND role = 'student'";
        try (Connection c = DBConfig.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, id);
            ps.executeUpdate();
        }
    }

    public void unlockAccount(int id) throws SQLException {
        String sql = "UPDATE users SET is_locked = 0, failed_attempts = 0 WHERE id = ?";
        try (Connection c = DBConfig.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, id);
            ps.executeUpdate();
        }
    }

    /* ---- Password reset (demo) ---- */
    public String issueResetToken(String email) throws SQLException {
        String token = UUID.randomUUID().toString().replace("-", "").substring(0, 8).toUpperCase();
        String sql = "UPDATE users SET reset_token = ? WHERE email = ?";
        try (Connection c = DBConfig.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setString(1, token);
            ps.setString(2, email);
            int rows = ps.executeUpdate();
            return rows > 0 ? token : null;
        }
    }

    public void applyReset(String email, String token, String newPwd) throws Exception {
        String sql = "SELECT * FROM users WHERE email = ? AND reset_token = ?";
        try (Connection c = DBConfig.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setString(1, email);
            ps.setString(2, token);
            try (ResultSet rs = ps.executeQuery()) {
                if (!rs.next()) throw new Exception("Invalid token or email.");
            }
        }
        String upd = "UPDATE users SET password = ?, reset_token = NULL, failed_attempts = 0, is_locked = 0 WHERE email = ? AND reset_token = ?";
        try (Connection c = DBConfig.getConnection();
             PreparedStatement ps = c.prepareStatement(upd)) {
            ps.setString(1, CipherUtil.encrypt(newPwd));
            ps.setString(2, email);
            ps.setString(3, token);
            ps.executeUpdate();
        }
    }

    /* ========== private helpers ========== */

    private void incrementFailed(int id) throws SQLException {
        exec("UPDATE users SET failed_attempts = failed_attempts + 1 WHERE id = ?", id);
    }

    private void lockAccount(int id) throws SQLException {
        exec("UPDATE users SET is_locked = 1 WHERE id = ?", id);
    }

    private void resetFailed(int id) throws SQLException {
        exec("UPDATE users SET failed_attempts = 0 WHERE id = ?", id);
    }

    private void exec(String sql, int id) throws SQLException {
        try (Connection c = DBConfig.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, id);
            ps.executeUpdate();
        }
    }

    private boolean exists(String sql, String val) throws SQLException {
        try (Connection c = DBConfig.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setString(1, val);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next();
            }
        }
    }

    private User map(ResultSet rs) throws SQLException {
        User u = new User();
        u.setId(rs.getInt("id"));
        u.setFullName(rs.getString("full_name"));
        u.setEmail(rs.getString("email"));
        u.setPassword(rs.getString("password"));
        u.setPhone(rs.getString("phone"));
        u.setRole(rs.getString("role"));
        u.setFailedAttempts(rs.getInt("failed_attempts"));
        u.setLocked(rs.getInt("is_locked") == 1);
        u.setResetToken(rs.getString("reset_token"));
        u.setProfilePhoto(rs.getBytes("profile_photo"));
        return u;
    }
}
