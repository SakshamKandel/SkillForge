package com.skillforge.controllers;

import com.skillforge.model.User;
import com.skillforge.service.UserService;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.io.OutputStream;

/**
 * Serves user profile photos directly from the database (BLOB).
 * URL pattern: /photo?userId=123
 */
@WebServlet("/photo")
public class PhotoServlet extends HttpServlet {

    private final UserService userService = new UserService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String userIdStr = req.getParameter("userId");
        if (userIdStr == null || userIdStr.isEmpty()) {
            resp.sendError(HttpServletResponse.SC_NOT_FOUND);
            return;
        }

        try {
            int userId = Integer.parseInt(userIdStr);
            User user = userService.findById(userId);

            if (user == null || user.getProfilePhoto() == null || user.getProfilePhoto().length == 0) {
                // Return a default placeholder if needed, or 404
                resp.sendError(HttpServletResponse.SC_NOT_FOUND);
                return;
            }

            byte[] imageData = user.getProfilePhoto();

            // Cache for 1 hour
            resp.setHeader("Cache-Control", "public, max-age=3600");
            
            // Try to detect common image types (magic numbers)
            String mimeType = "image/jpeg"; // default
            if (imageData.length > 4) {
                if (imageData[0] == (byte)0x89 && imageData[1] == (byte)0x50) mimeType = "image/png";
                else if (imageData[0] == (byte)0x47 && imageData[1] == (byte)0x49) mimeType = "image/gif";
                else if (imageData[0] == (byte)0x52 && imageData[1] == (byte)0x49) mimeType = "image/webp";
            }
            
            resp.setContentType(mimeType);
            resp.setContentLength(imageData.length);

            try (OutputStream out = resp.getOutputStream()) {
                out.write(imageData);
            }

        } catch (Exception e) {
            resp.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
        }
    }
}
