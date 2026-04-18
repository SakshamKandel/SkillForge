<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<% String ctx = request.getContextPath(); %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login — SkillForge</title>
    <link rel="stylesheet" href="<%= ctx %>/css/auth.css">
</head>
<body>

<div class="auth-container">
    <div class="auth-card">
        <h1>SkillForge</h1>
        <p class="subtitle">Welcome Back!</p>

        <% if (request.getAttribute("error") != null) { %>
            <div class="msg msg-error">
                <%= request.getAttribute("error") %>
            </div>
        <% } %>
        <% if (request.getAttribute("success") != null) { %>
            <div class="msg msg-success">
                <%= request.getAttribute("success") %>
            </div>
        <% } %>

        <form action="<%= ctx %>/login" method="post">
            <div class="field">
                <label for="email">Username or Email</label>
                <input type="email" id="email" name="email" placeholder="Email address" required autofocus>
            </div>

            <div class="field">
                <label for="password">Password</label>
                <input type="password" id="password" name="password" placeholder="Password" required>
                <div class="forgot-link-wrap">
                    <a href="<%= ctx %>/forgot-password" class="footer-link">Forgot Password?</a>
                </div>
            </div>

            <button type="submit" class="btn-duo btn-duo-blue">
                Log In
            </button>
        </form>

        <div class="auth-divider">
            <span>New to SkillForge?</span>
        </div>

        <a href="<%= ctx %>/register" class="btn-duo btn-duo-ghost">
            Create Account
        </a>
    </div>
</div>

</body>
</html>
