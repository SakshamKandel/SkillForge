package com.skillforge.controllers;

import com.skillforge.model.User;
import com.skillforge.service.UserService;
import com.skillforge.util.InputValidator;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.File;
import java.io.IOException;
import java.util.UUID;

@WebServlet(urlPatterns = {"/student/profile", "/admin/profile"})
@MultipartConfig(
        fileSizeThreshold = 1024 * 1024 * 2,    // 2 MB
        maxFileSize       = 1024 * 1024 * 50,   // 50 MB
        maxRequestSize    = 1024 * 1024 * 60    // 60 MB
)
public class ProfileServlet extends HttpServlet {

    private final UserService userService = new UserService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        try {
            int userId = (int) req.getSession().getAttribute("userId");
            String role = (String) req.getSession().getAttribute("role");
            User user = userService.findById(userId);
            req.setAttribute("userBean", user);

            String jsp = "admin".equals(role)
                    ? "/WEB-INF/pages/admin/profile.jsp"
                    : "/WEB-INF/pages/student/profile.jsp";
            req.getRequestDispatcher(jsp).forward(req, resp);
        } catch (Exception e) {
            throw new ServletException(e);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession();
        int userId = (int) session.getAttribute("userId");
        String role = (String) session.getAttribute("role");
        String action = null;

        try {
            action = req.getParameter("action");
            if ("updateProfile".equals(action)) {
                String fullName = req.getParameter("fullName");
                String phone    = req.getParameter("phone");

                if (!InputValidator.isValidName(fullName))
                    throw new Exception("Name must be 2-100 letters/spaces.");
                if (!InputValidator.isValidPhone(phone))
                    throw new Exception("Phone must be exactly 10 digits.");

                userService.editProfile(userId, fullName, phone);
                session.setAttribute("userName", fullName);
                req.setAttribute("success", "Profile updated successfully.");

            } else if ("changePassword".equals(action)) {
                String currentPwd = req.getParameter("currentPassword");
                String newPwd     = req.getParameter("newPassword");
                String confirm    = req.getParameter("confirm");

                String email = (String) session.getAttribute("userEmail");
                if (email == null) {
                    User u = userService.findById(userId);
                    email = u.getEmail();
                }
                userService.authenticate(email, currentPwd);

                if (!InputValidator.isValidPassword(newPwd))
                    throw new Exception("New password must be at least 6 characters.");
                if (!newPwd.equals(confirm))
                    throw new Exception("Passwords do not match.");

                userService.changePassword(userId, newPwd);
                req.setAttribute("success", "Password changed successfully.");

            } else if ("uploadPhoto".equals(action)) {
                Part filePart = req.getPart("photo");
                if (filePart != null && filePart.getSize() > 0) {
                    String origName = getFileName(filePart);
                    if (origName == null || origName.isEmpty()) {
                        throw new Exception("No file selected.");
                    }

                    // Validate extension
                    String ext = origName.substring(origName.lastIndexOf(".")).toLowerCase();
                    if (!ext.matches("\\.(jpg|jpeg|png|gif|webp)")) {
                        throw new Exception("Only JPG, PNG, GIF, WEBP images are allowed.");
                    }

                    // Update database with binary stream
                    userService.updateProfilePhoto(userId, filePart.getInputStream());
                    
                    session.setAttribute("hasPhoto", true);
                    req.setAttribute("success", "Profile photo updated successfully.");
                } else {
                    throw new Exception("No file selected.");
                }
            } else if ("deletePhoto".equals(action)) {
                userService.updateProfilePhoto(userId, null);
                session.setAttribute("hasPhoto", false);
                req.setAttribute("success", "Profile photo removed.");
            }
        } catch (Exception e) {
            req.setAttribute("error", e.getMessage());
        }

        // Reload user and forward back
        try {
            User user = userService.findById(userId);
            req.setAttribute("userBean", user);
        } catch (Exception ignored) { }

        try {
            String jsp = "admin".equals(role)
                    ? "/WEB-INF/pages/admin/profile.jsp"
                    : "/WEB-INF/pages/student/profile.jsp";
            req.getRequestDispatcher(jsp).forward(req, resp);
        } catch (Exception e) {
            throw new ServletException(e);
        }
    }

    private String getFileName(Part part) {
        String header = part.getHeader("content-disposition");
        for (String token : header.split(";")) {
            if (token.trim().startsWith("filename")) {
                return token.substring(token.indexOf('=') + 1).trim().replace("\"", "");
            }
        }
        return null;
    }
}
