package com.skillforge.filters;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

/**
 * Security filter — guards every request.
 * Public paths pass through; everything else requires a session.
 * Admin paths require role=admin; student paths require role=student.
 */
@WebFilter("/*")
public class AccessFilter implements Filter {

    @Override
    public void init(FilterConfig filterConfig) throws ServletException { }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest  req = (HttpServletRequest) request;
        HttpServletResponse res = (HttpServletResponse) response;

        String path = req.getServletPath();

        // Public paths — no auth needed
        if (path.equals("/login") || path.equals("/register") ||
            path.equals("/forgot-password") || path.equals("/about") ||
            path.equals("/auth/google") ||
            path.startsWith("/css") || path.startsWith("/images") ||
            path.startsWith("/photo") || path.startsWith("/uploads") ||
            path.equals("/")) {
            chain.doFilter(request, response);
            return;
        }

        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("role") == null) {
            res.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        String role = (String) session.getAttribute("role");

        // Admin-only area
        if (path.startsWith("/admin")) {
            if (!"admin".equals(role)) {
                res.sendRedirect(req.getContextPath() + "/student");
                return;
            }
        }

        // Student-only area
        if (path.startsWith("/student")) {
            if (!"student".equals(role)) {
                res.sendRedirect(req.getContextPath() + "/admin");
                return;
            }
        }

        chain.doFilter(request, response);
    }

    @Override
    public void destroy() { }
}
