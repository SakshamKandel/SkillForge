package com.skillforge.controllers;

import com.skillforge.model.Course;
import com.skillforge.service.CourseService;
import com.skillforge.util.InputValidator;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.util.List;
import java.util.Map;

@WebServlet("/admin/courses")
public class CourseServlet extends HttpServlet {

    private final CourseService courseService = new CourseService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String action = req.getParameter("action");

        try {
            if ("add".equals(action)) {
                /* Pass lookup data for dropdowns */
                req.setAttribute("categories", courseService.getAllCategories());
                req.setAttribute("instructors", courseService.getAllInstructors());
                req.getRequestDispatcher("/WEB-INF/pages/admin/course-form.jsp").forward(req, resp);

            } else if ("edit".equals(action)) {
                int id = Integer.parseInt(req.getParameter("id"));
                Course course = courseService.findById(id);
                req.setAttribute("course", course);
                req.setAttribute("categories", courseService.getAllCategories());
                req.setAttribute("instructors", courseService.getAllInstructors());
                req.getRequestDispatcher("/WEB-INF/pages/admin/course-form.jsp").forward(req, resp);

            } else if ("delete".equals(action)) {
                int id = Integer.parseInt(req.getParameter("id"));
                courseService.delete(id);
                resp.sendRedirect(req.getContextPath() + "/admin/courses");

            } else {
                // List with optional search
                String keyword = req.getParameter("search");
                List<Course> courses;
                if (keyword != null && !keyword.trim().isEmpty()) {
                    courses = courseService.search(keyword.trim());
                    req.setAttribute("search", keyword.trim());
                } else {
                    courses = courseService.getAll();
                }
                req.setAttribute("courses", courses);
                req.getRequestDispatcher("/WEB-INF/pages/admin/manage-courses.jsp").forward(req, resp);
            }
        } catch (Exception e) {
            throw new ServletException(e);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String title        = req.getParameter("title");
        String categoryId   = req.getParameter("categoryId");
        String instructorId = req.getParameter("instructorId");
        String durationStr  = req.getParameter("durationWeeks");
        String description  = req.getParameter("description");
        String idStr        = req.getParameter("id");
        String activeParam  = req.getParameter("active");

        try {
            if (InputValidator.isBlank(title) || InputValidator.isBlank(categoryId) || InputValidator.isBlank(instructorId))
                throw new Exception("Title, category, and instructor are required.");
            if (!InputValidator.isPositiveInt(durationStr))
                throw new Exception("Duration must be a positive number.");

            Course course = new Course();
            course.setTitle(title.trim());
            course.setCategoryId(Integer.parseInt(categoryId.trim()));
            course.setInstructorId(Integer.parseInt(instructorId.trim()));
            course.setDurationWeeks(Integer.parseInt(durationStr.trim()));
            course.setDescription(description != null ? description.trim() : "");

            if (idStr != null && !idStr.isEmpty()) {
                // Update
                course.setId(Integer.parseInt(idStr));
                course.setActive(activeParam != null); // checkbox
                courseService.update(course);
            } else {
                // Add
                course.setActive(true);
                courseService.add(course);
            }

            resp.sendRedirect(req.getContextPath() + "/admin/courses");

        } catch (Exception e) {
            req.setAttribute("error", e.getMessage());
            try {
                req.setAttribute("categories", courseService.getAllCategories());
                req.setAttribute("instructors", courseService.getAllInstructors());
            } catch (Exception ignored) { }
            if (idStr != null && !idStr.isEmpty()) {
                try {
                    req.setAttribute("course", courseService.findById(Integer.parseInt(idStr)));
                } catch (Exception ignored) { }
            }
            req.getRequestDispatcher("/WEB-INF/pages/admin/course-form.jsp").forward(req, resp);
        }
    }
}
