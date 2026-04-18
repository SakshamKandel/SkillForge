package com.skillforge.controllers;

import com.skillforge.model.Quiz;
import com.skillforge.model.Question;
import com.skillforge.model.Course;
import com.skillforge.service.CourseService;
import com.skillforge.service.QuizService;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

@WebServlet("/admin/quizzes")
public class AdminQuizServlet extends HttpServlet {

    private final QuizService quizService = new QuizService();
    private final CourseService courseService = new CourseService();

    private void setNoCache(HttpServletResponse resp) {
        resp.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
        resp.setHeader("Pragma", "no-cache");
        resp.setDateHeader("Expires", 0);
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        setNoCache(resp);
        String action = req.getParameter("action");
        String quizIdParam = req.getParameter("quizId");

        try {
            // 1. Handle Delete Action
            if ("deleteQuiz".equals(action)) {
                if (quizIdParam != null && !quizIdParam.isEmpty()) {
                    int idToDelete = Integer.parseInt(quizIdParam);
                    quizService.deleteQuiz(idToDelete);
                    req.getSession().setAttribute("success", "Quiz ID " + idToDelete + " erased successfully.");
                }
                resp.sendRedirect(req.getContextPath() + "/admin/quizzes");
                return;
            }

            // 2. Fetch Prerequisite Data
            List<Quiz> quizzes = quizService.getAllQuizzes();
            List<Course> courses = courseService.getAll();
            
            // Fallbacks for JSP stability
            if (quizzes == null) quizzes = new ArrayList<>();
            if (courses == null) courses = new ArrayList<>();

            req.setAttribute("quizzes", quizzes);
            req.setAttribute("courses", courses);

            // 3. Handle Question Loading
            if (quizIdParam != null && !quizIdParam.isEmpty()) {
                try {
                    int quizId = Integer.parseInt(quizIdParam);
                    List<Question> questions = quizService.getQuestionsByQuizId(quizId);
                    req.setAttribute("quizQuestions", questions != null ? questions : new ArrayList<>());
                    req.setAttribute("selectedQuizId", quizId);
                } catch (NumberFormatException nfe) {
                    // Ignore malformed IDs
                }
            }

            req.setAttribute("activePage", "quizzes");
            req.setAttribute("pageTitle", "Manage Quizzes");
            
            // 4. Final Forward
            req.getRequestDispatcher("/WEB-INF/pages/admin/manage-quizzes.jsp").forward(req, resp);

        } catch (Exception e) {
            throw new ServletException("Quiz management error: " + e.getMessage(), e);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        setNoCache(resp);
        String action = req.getParameter("action");

        try {
            if ("createQuiz".equals(action)) {
                int courseId = Integer.parseInt(req.getParameter("courseId"));
                String title = req.getParameter("title");
                int passingScore = Integer.parseInt(req.getParameter("passingScore"));
                
                Quiz quiz = new Quiz();
                quiz.setCourseId(courseId);
                quiz.setTitle(title);
                quiz.setPassingScore(passingScore);
                quizService.saveQuiz(quiz);
                req.getSession().setAttribute("success", "Quiz successfully registered.");
            } else if ("addQuestion".equals(action)) {
                int quizId = Integer.parseInt(req.getParameter("quizId"));
                String text = req.getParameter("questionText");
                String a = req.getParameter("optionA");
                String b = req.getParameter("optionB");
                String c = req.getParameter("optionC");
                String d = req.getParameter("optionD");
                String correct = req.getParameter("correctOption");
                
                Question q = new Question();
                q.setQuizId(quizId);
                q.setQuestionText(text);
                q.setOptionA(a);
                q.setOptionB(b);
                q.setOptionC(c);
                q.setOptionD(d);
                q.setCorrectOption(correct.charAt(0));
                quizService.saveQuestion(q);
                req.getSession().setAttribute("success", "Question added into the vault.");
            }
        } catch (Exception e) {
            e.printStackTrace();
            req.getSession().setAttribute("error", "Vault rejection: " + e.getMessage());
        }
        resp.sendRedirect(req.getContextPath() + "/admin/quizzes");
    }
}
