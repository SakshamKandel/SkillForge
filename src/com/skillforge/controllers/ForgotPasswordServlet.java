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

        HttpSession session = req.getSession();
        String fAction = req.getParameter("f_action");
        String email   = req.getParameter("email");
        
        // Try to get email from session if parameter is missing (Step 2 validation)
        if (email == null || email.trim().isEmpty()) {
            email = (String) session.getAttribute("resetEmail");
        }

        System.err.println("[ForgotPassword] Action: " + fAction + ", Email: " + email);

        if (email != null && !email.trim().isEmpty()) {
            req.setAttribute("email", email.trim());
            session.setAttribute("resetEmail", email.trim()); // backup
        }

        try {
            if ("request".equals(fAction)) {
                if (email == null || email.trim().isEmpty()) {
                    throw new Exception("Please enter your email.");
                }
                
                if (!InputValidator.isValidEmail(email)) {
                    throw new Exception("Invalid email format.");
                }

                String token = userService.issueResetToken(email.trim());
                if (token == null) {
                    throw new Exception("No account found with that email.");
                }

                req.setAttribute("token", token);
                req.setAttribute("step", "reset");
                System.err.println("[ForgotPassword] Step 1 Success. Email: " + email);

            } else if ("reset".equals(fAction)) {
                req.setAttribute("step", "reset");

                String token   = req.getParameter("token");
                String newPwd  = req.getParameter("newPassword");
                String confirm = req.getParameter("confirm");

                System.err.println("[ForgotPassword] Step 2 Attempt. Email: " + email + ", Token: " + token);

                if (email == null || email.trim().isEmpty())
                    throw new Exception("Email identification lost. Please restart.");
                if (token == null || token.trim().isEmpty())
                    throw new Exception("Token is required.");
                if (!InputValidator.isValidPassword(newPwd))
                    throw new Exception("Password must be at least 6 characters.");
                if (confirm == null || !newPwd.equals(confirm))
                    throw new Exception("Passwords do not match.");

                userService.applyReset(email.trim(), token.trim(), newPwd);
                
                session.removeAttribute("resetEmail");
                System.err.println("[ForgotPassword] Step 2 Success for: " + email);

                resp.sendRedirect(req.getContextPath() + "/login?success=Password+reset+successful.+Please+login.");
                return;
            }
        } catch (Exception e) {
            System.err.println("[ForgotPassword] Error: " + e.getMessage());
            req.setAttribute("error", e.getMessage());
        }

        req.getRequestDispatcher("/WEB-INF/pages/forgot-password.jsp").forward(req, resp);
    }
}
