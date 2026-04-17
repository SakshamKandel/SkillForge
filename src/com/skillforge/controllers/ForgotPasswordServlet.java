package com.skillforge.controllers;

import com.skillforge.service.UserService;
import com.skillforge.util.InputValidator;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;

@WebServlet("/forgot-password")
public class ForgotPasswordServlet extends HttpServlet {

    private final UserService userService = new UserService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        req.getRequestDispatcher("/WEB-INF/pages/forgot-password.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String step = req.getParameter("step");

        try {
            if ("1".equals(step)) {
                // Issue token
                String email = req.getParameter("email");
                if (!InputValidator.isValidEmail(email))
                    throw new Exception("Invalid email format.");

                String token = userService.issueResetToken(email);
                if (token == null)
                    throw new Exception("No account found with that email.");

                req.setAttribute("token", token);
                req.setAttribute("email", email);
                req.setAttribute("step", "2");

            } else if ("2".equals(step)) {
                // Apply reset
                String email   = req.getParameter("email");
                String token   = req.getParameter("token");
                String newPwd  = req.getParameter("newPassword");
                String confirm = req.getParameter("confirm");

                if (!InputValidator.isValidPassword(newPwd))
                    throw new Exception("Password must be at least 6 characters.");
                if (!newPwd.equals(confirm))
                    throw new Exception("Passwords do not match.");

                userService.applyReset(email, token, newPwd);

                resp.sendRedirect(req.getContextPath() + "/login?success=Password+reset+successful.+Please+login.");
                return;
            }
        } catch (Exception e) {
            req.setAttribute("error", e.getMessage());
        }

        req.getRequestDispatcher("/WEB-INF/pages/forgot-password.jsp").forward(req, resp);
    }
}
