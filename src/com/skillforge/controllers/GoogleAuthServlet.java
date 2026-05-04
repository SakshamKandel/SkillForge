package com.skillforge.controllers;

import com.skillforge.model.User;
import com.skillforge.service.UserService;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

/**
 * Sign In With Google — verifies the ID token returned by Google Identity
 * Services, then either logs in an existing student or auto-registers a new one.
 *
 * Verification flow:
 *   1. Receive the JWT ID token (POST parameter "credential") from the browser.
 *   2. Forward it to Google's tokeninfo endpoint, which validates the signature,
 *      issuer, and expiry server-side and returns the decoded payload as JSON.
 *   3. Confirm aud == our client_id and email_verified == true.
 *   4. Look up by email; create a student account if none exists.
 *   5. Set the same session attributes a normal login would.
 */
@WebServlet("/auth/google")
public class GoogleAuthServlet extends HttpServlet {

    /** OAuth 2.0 Client ID from Google Cloud Console. */
    private static final String CLIENT_ID =
        "740455423110-bi3kos6v3msmmcs1u09lrudu2g0r0dnt.apps.googleusercontent.com";

    private static final String TOKENINFO_URL =
        "https://oauth2.googleapis.com/tokeninfo?id_token=";

    private final UserService userService = new UserService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        // Direct GETs make no sense here — bounce to login
        resp.sendRedirect(req.getContextPath() + "/login");
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String idToken = req.getParameter("credential");
        if (idToken == null || idToken.trim().isEmpty()) {
            redirectError(req, resp, "Missing Google credential.");
            return;
        }

        try {
            String json = fetchTokenInfo(idToken.trim());
            if (json == null) {
                redirectError(req, resp, "Google did not accept the sign-in token.");
                return;
            }

            String aud           = jsonString(json, "aud");
            String email         = jsonString(json, "email");
            String emailVerified = jsonString(json, "email_verified");
            String name          = jsonString(json, "name");
            String sub           = jsonString(json, "sub");

            if (!CLIENT_ID.equals(aud)) {
                redirectError(req, resp, "Invalid Google audience.");
                return;
            }
            if (!"true".equalsIgnoreCase(emailVerified)) {
                redirectError(req, resp, "Google email not verified.");
                return;
            }
            if (email == null || email.isEmpty()) {
                redirectError(req, resp, "No email returned from Google.");
                return;
            }

            User user = userService.findByEmail(email);
            if (user == null) {
                // First-time Google user — auto-register as a student
                String displayName = (name != null && !name.isEmpty()) ? name : email;
                user = userService.registerGoogleUser(email, displayName, sub);
            } else if (!"student".equals(user.getRole())) {
                redirectError(req, resp, "Admin accounts must sign in with a password.");
                return;
            } else if (user.isLocked()) {
                redirectError(req, resp, "Account is locked. Please contact admin.");
                return;
            }

            // Same session bootstrap as LoginServlet so the rest of the app works
            HttpSession session = req.getSession(true);
            session.setAttribute("userId",    user.getId());
            session.setAttribute("userName",  user.getFullName());
            session.setAttribute("userEmail", user.getEmail());
            session.setAttribute("hasPhoto",
                user.getProfilePhoto() != null && user.getProfilePhoto().length > 0);
            session.setAttribute("role",      user.getRole());
            session.setMaxInactiveInterval(30 * 60);

            resp.sendRedirect(req.getContextPath() + "/student");

        } catch (Exception e) {
            redirectError(req, resp, "Google sign-in failed: " + e.getMessage());
        }
    }

    /** Calls Google's tokeninfo endpoint; returns the JSON body on HTTP 200, else null. */
    private String fetchTokenInfo(String idToken) throws IOException {
        URL url = new URL(TOKENINFO_URL + URLEncoder.encode(idToken, StandardCharsets.UTF_8.name()));
        HttpURLConnection conn = (HttpURLConnection) url.openConnection();
        conn.setRequestMethod("GET");
        conn.setConnectTimeout(5000);
        conn.setReadTimeout(5000);
        try {
            int code = conn.getResponseCode();
            if (code != 200) return null;
            try (BufferedReader br = new BufferedReader(
                    new InputStreamReader(conn.getInputStream(), StandardCharsets.UTF_8))) {
                StringBuilder sb = new StringBuilder();
                String line;
                while ((line = br.readLine()) != null) sb.append(line);
                return sb.toString();
            }
        } finally {
            conn.disconnect();
        }
    }

    /**
     * Pulls a string-valued field out of a flat JSON object.
     * Sufficient for the tokeninfo response — values are quoted strings, no nesting.
     */
    private static String jsonString(String json, String field) {
        if (json == null) return null;
        Pattern p = Pattern.compile(
            "\"" + Pattern.quote(field) + "\"\\s*:\\s*\"((?:\\\\.|[^\"\\\\])*)\"");
        Matcher m = p.matcher(json);
        return m.find() ? m.group(1) : null;
    }

    private void redirectError(HttpServletRequest req, HttpServletResponse resp, String msg)
            throws IOException {
        resp.sendRedirect(req.getContextPath() + "/login?error="
                + URLEncoder.encode(msg, StandardCharsets.UTF_8.name()));
    }
}
