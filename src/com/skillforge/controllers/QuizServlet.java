package com.skillforge.controllers;

import com.skillforge.model.Quiz;
import com.skillforge.model.Question;
import com.skillforge.model.QuizAttempt;
import com.skillforge.service.QuizService;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

@WebServlet("/student/quiz")
public class QuizServlet extends HttpServlet {

    private final QuizService quizService = new QuizService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String courseIdStr = req.getParameter("courseId");
        if (courseIdStr == null || courseIdStr.isEmpty()) {
            resp.sendRedirect(req.getContextPath() + "/student/courses");
            return;
        }

        try {
            int courseId = Integer.parseInt(courseIdStr);
            Quiz quiz = quizService.getQuizByCourseId(courseId);
            
            if (quiz == null) {
                req.setAttribute("error", "No quiz found for this course.");
                req.getRequestDispatcher("/WEB-INF/pages/student/my-courses.jsp").forward(req, resp);
                return;
            }

            List<Question> questions = quizService.getQuestionsByQuizId(quiz.getId());
            req.setAttribute("quiz", quiz);
            req.setAttribute("questions", questions);
            req.setAttribute("pageTitle", "Take Quiz: " + quiz.getTitle());
            req.getRequestDispatcher("/WEB-INF/pages/student/quiz.jsp").forward(req, resp);

        } catch (SQLException | NumberFormatException e) {
            throw new ServletException(e);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession();
        int userId = (int) session.getAttribute("userId");
        int quizId = Integer.parseInt(req.getParameter("quizId"));
        int courseId = Integer.parseInt(req.getParameter("courseId"));

        try {
            Quiz quiz = quizService.getQuizByCourseId(courseId);
            List<Question> questions = quizService.getQuestionsByQuizId(quizId);
            
            int correctCount = 0;
            for (Question q : questions) {
                String submittedAnswer = req.getParameter("q" + q.getId());
                if (submittedAnswer != null && submittedAnswer.equals(String.valueOf(q.getCorrectOption()))) {
                    correctCount++;
                }
            }

            int totalQuestions = questions.size();
            int score = (int) (((double) correctCount / totalQuestions) * 100);
            boolean passed = score >= quiz.getPassingScore();

            QuizAttempt attempt = new QuizAttempt();
            attempt.setStudentId(userId);
            attempt.setQuizId(quizId);
            attempt.setScore(score);
            attempt.setPassed(passed);
            
            int attemptId = quizService.saveAttempt(attempt);

            if (passed) {
                quizService.issueCertification(userId, courseId, attemptId);
            }

            resp.sendRedirect(req.getContextPath() + "/student/quiz/result?attemptId=" + attemptId);

        } catch (SQLException e) {
            throw new ServletException(e);
        }
    }
}
