package com.skillforge.controllers;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;

/**
 * Serves the About / FAQ page.
 * Demonstrates an extra informational page beyond CRUD operations.
 */
@WebServlet("/about")
public class AboutServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        req.setAttribute("pageTitle", "About SkillForge");
        req.setAttribute("activePage", "about");
        req.getRequestDispatcher("/WEB-INF/pages/about.jsp").forward(req, resp);
    }
}
