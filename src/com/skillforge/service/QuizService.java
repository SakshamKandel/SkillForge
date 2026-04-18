package com.skillforge.service;

import com.skillforge.config.DBConfig;
import com.skillforge.model.Quiz;
import com.skillforge.model.Question;
import com.skillforge.model.QuizAttempt;
import com.skillforge.model.Certification;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.UUID;

public class QuizService {

    public List<Quiz> getAllQuizzes() throws SQLException {
        List<Quiz> quizzes = new ArrayList<>();
        String sql = "SELECT * FROM quizzes";
        try (Connection conn = DBConfig.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                quizzes.add(mapQuiz(rs));
            }
        }
        return quizzes;
    }

    public Quiz getQuizByCourseId(int courseId) throws SQLException {
        String sql = "SELECT * FROM quizzes WHERE course_id = ?";
        try (Connection conn = DBConfig.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, courseId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return mapQuiz(rs);
            }
        }
        return null;
    }

    public List<Question> getQuestionsByQuizId(int quizId) throws SQLException {
        List<Question> questions = new ArrayList<>();
        String sql = "SELECT * FROM quiz_questions WHERE quiz_id = ?";
        try (Connection conn = DBConfig.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, quizId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    questions.add(mapQuestion(rs));
                }
            }
        }
        return questions;
    }

    public void saveQuiz(Quiz quiz) throws SQLException {
        String sql = "INSERT INTO quizzes (course_id, title, description, passing_score) VALUES (?, ?, ?, ?)";
        try (Connection conn = DBConfig.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, quiz.getCourseId());
            ps.setString(2, quiz.getTitle());
            ps.setString(3, quiz.getDescription());
            ps.setInt(4, quiz.getPassingScore());
            ps.executeUpdate();
        }
    }

    public void deleteQuiz(int id) throws SQLException {
        try (Connection conn = DBConfig.getConnection()) {
            // Step 1: Perform the delete
            String sql = "DELETE FROM quizzes WHERE id = ?";
            conn.setAutoCommit(true);
            try (PreparedStatement ps = conn.prepareStatement(sql)) {
                ps.setInt(1, id);
                int rows = ps.executeUpdate();
                
                if (rows == 0) {
                    throw new SQLException("Termination Failed: Quiz ID " + id + " was not found in the live database.");
                }
            }
        }
    }

    public void saveQuestion(Question q) throws SQLException {
        String sql = "INSERT INTO quiz_questions (quiz_id, question_text, option_a, option_b, option_c, option_d, correct_option) VALUES (?, ?, ?, ?, ?, ?, ?)";
        try (Connection conn = DBConfig.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, q.getQuizId());
            ps.setString(2, q.getQuestionText());
            ps.setString(3, q.getOptionA());
            ps.setString(4, q.getOptionB());
            ps.setString(5, q.getOptionC());
            ps.setString(6, q.getOptionD());
            ps.setString(7, String.valueOf(q.getCorrectOption()));
            ps.executeUpdate();
        }
    }

    public int saveAttempt(QuizAttempt attempt) throws SQLException {
        String sql = "INSERT INTO quiz_attempts (student_id, quiz_id, score, passed) VALUES (?, ?, ?, ?)";
        try (Connection conn = DBConfig.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setInt(1, attempt.getStudentId());
            ps.setInt(2, attempt.getQuizId());
            ps.setInt(3, attempt.getScore());
            ps.setBoolean(4, attempt.isPassed());
            ps.executeUpdate();
            
            try (ResultSet rs = ps.getGeneratedKeys()) {
                if (rs.next()) return rs.getInt(1);
            }
        }
        return -1;
    }

    public void issueCertification(int studentId, int courseId, int attemptId) throws SQLException {
        String code = "CERT-" + UUID.randomUUID().toString().substring(0, 8).toUpperCase();
        String sql = "INSERT INTO certifications (student_id, course_id, attempt_id, cert_code) VALUES (?, ?, ?, ?)";
        try (Connection conn = DBConfig.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, studentId);
            ps.setInt(2, courseId);
            ps.setInt(3, attemptId);
            ps.setString(4, code);
            ps.executeUpdate();
        }
    }

    public Certification getCertificationByAttempt(int attemptId) throws SQLException {
        String sql = "SELECT c.*, u.full_name as studentName, co.title as courseTitle " +
                     "FROM certifications c " +
                     "JOIN users u ON c.student_id = u.id " +
                     "JOIN courses co ON c.course_id = co.id " +
                     "WHERE c.attempt_id = ?";
        try (Connection conn = DBConfig.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, attemptId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Certification cert = new Certification();
                    cert.setId(rs.getInt("id"));
                    cert.setCertCode(rs.getString("cert_code"));
                    cert.setIssuedAt(rs.getString("issued_at"));
                    cert.setStudentName(rs.getString("studentName"));
                    cert.setCourseTitle(rs.getString("courseTitle"));
                    return cert;
                }
            }
        }
        return null;
    }

    public QuizAttempt getLastAttempt(int studentId, int quizId) throws SQLException {
        String sql = "SELECT * FROM quiz_attempts WHERE student_id = ? AND quiz_id = ? ORDER BY attempted_at DESC LIMIT 1";
        try (Connection conn = DBConfig.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, studentId);
            ps.setInt(2, quizId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return mapQuizAttempt(rs);
            }
        }
        return null;
    }

    private Quiz mapQuiz(ResultSet rs) throws SQLException {
        Quiz q = new Quiz();
        q.setId(rs.getInt("id"));
        q.setCourseId(rs.getInt("course_id"));
        q.setTitle(rs.getString("title"));
        q.setDescription(rs.getString("description"));
        q.setPassingScore(rs.getInt("passing_score"));
        return q;
    }

    private Question mapQuestion(ResultSet rs) throws SQLException {
        Question q = new Question();
        q.setId(rs.getInt("id"));
        q.setQuizId(rs.getInt("quiz_id"));
        q.setQuestionText(rs.getString("question_text"));
        q.setOptionA(rs.getString("option_a"));
        q.setOptionB(rs.getString("option_b"));
        q.setOptionC(rs.getString("option_c"));
        q.setOptionD(rs.getString("option_d"));
        q.setCorrectOption(rs.getString("correct_option").charAt(0));
        return q;
    }

    private QuizAttempt mapQuizAttempt(ResultSet rs) throws SQLException {
        QuizAttempt qa = new QuizAttempt();
        qa.setId(rs.getInt("id"));
        qa.setStudentId(rs.getInt("student_id"));
        qa.setQuizId(rs.getInt("quiz_id"));
        qa.setScore(rs.getInt("score"));
        qa.setPassed(rs.getBoolean("passed"));
        qa.setAttemptedAt(rs.getString("attempted_at"));
        return qa;
    }
}
