<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<% String ctx = request.getContextPath(); %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Register — SkillForge</title>
    <link rel="stylesheet" href="<%= ctx %>/css/auth.css">
</head>
<body>

<div class="auth-container">
    <div class="auth-card">
        <h1>Join Now</h1>
        <p class="subtitle">Start Your Journey Today!</p>

        <% if (request.getAttribute("error") != null) { %>
            <div class="msg msg-error">
                <%= request.getAttribute("error") %>
            </div>
        <% } %>

        <form action="<%= ctx %>/register" method="post">
            <div class="field">
                <label for="fullName">Full Name</label>
                <input type="text" id="fullName" name="fullName" placeholder="Enter your full name" required autofocus>
            </div>

            <div class="field">
                <label for="email">Email Address</label>
                <input type="email" id="email" name="email" placeholder="Enter your email" required>
            </div>

            <div class="field">
                <label for="password">Choose Password</label>
                <input type="password" id="password" name="password" placeholder="Create a strong password" required>
            </div>

            <div class="field">
                <label for="phone">Phone Number</label>
                <input type="text" id="phone" name="phone" placeholder="Your phone number" required>
            </div>

            <button type="submit" class="btn-duo btn-duo-green" style="margin-top: 16px;">
                Create Account
            </button>
        </form>

        <div class="auth-divider">
            <span>Already have an account?</span>
        </div>

        <a href="<%= ctx %>/login" class="btn-duo btn-duo-ghost">
            Login
        </a>
    </div>
</div>

</body>
</html>
