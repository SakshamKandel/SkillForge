package com.skillforge.model;

/**
 * POJO representing a student's attempt at a quiz.
 */
public class QuizAttempt {
    private int id;
    private int studentId;
    private int quizId;
    private int score;
    private boolean passed;
    private String attemptedAt;

    public QuizAttempt() {}

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public int getStudentId() { return studentId; }
    public void setStudentId(int studentId) { this.studentId = studentId; }

    public int getQuizId() { return quizId; }
    public void setQuizId(int quizId) { this.quizId = quizId; }

    public int getScore() { return score; }
    public void setScore(int score) { this.score = score; }

    public boolean isPassed() { return passed; }
    public void setPassed(boolean passed) { this.passed = passed; }

    public String getAttemptedAt() { return attemptedAt; }
    public void setAttemptedAt(String attemptedAt) { this.attemptedAt = attemptedAt; }
}
