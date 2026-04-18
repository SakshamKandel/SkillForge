package com.skillforge.controllers;

import com.skillforge.model.QuizAttempt;
import com.skillforge.model.Certification;
import com.skillforge.service.QuizService;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.sql.SQLException;

@WebServlet("/student/quiz/result")
public class QuizResultServlet extends HttpServlet {

    private final QuizService quizService = new QuizService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String attemptIdStr = req.getParameter("attemptId");
        if (attemptIdStr == null || attemptIdStr.isEmpty()) {
            resp.sendRedirect(req.getContextPath() + "/student/courses");
            return;
        }

        try {
            int attemptId = Integer.parseInt(attemptIdStr);
            Certification cert = quizService.getCertificationByAttempt(attemptId);
            
            // We'll reuse the Certification model search to get attempt details + names
            req.setAttribute("cert", cert);
            req.setAttribute("attemptId", attemptId);
            req.setAttribute("pageTitle", "Quiz Results");
            req.getRequestDispatcher("/WEB-INF/pages/student/quiz-result.jsp").forward(req, resp);

        } catch (SQLException | NumberFormatException e) {
            throw new ServletException(e);
        }
    }
}
