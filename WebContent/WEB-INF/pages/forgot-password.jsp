<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<% String ctx = request.getContextPath(); %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Forgot Password — SkillForge</title>
    <link rel="stylesheet" href="<%= ctx %>/css/auth.css">
</head>
<body>

<div class="auth-container">
    <div class="auth-card">
        <h1>Forgot Key</h1>
        <p class="subtitle subtitle-gap">Let's Find It!</p>

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

        <% if (request.getAttribute("step") == null) { %>
            <!-- STEP 1: Email -->
            <form action="<%= ctx %>/forgot-password" method="post">
                <input type="hidden" name="f_action" value="request">
                <div class="field">
                    <label for="email">Account Email</label>
                    <input type="email" id="email" name="email" value="<%= request.getAttribute("email") != null ? request.getAttribute("email") : (session.getAttribute("resetEmail") != null ? session.getAttribute("resetEmail") : "") %>" placeholder="Enter your email" required autofocus>
                </div>
                <button type="submit" class="btn-duo btn-duo-blue">
                    Continue
                </button>
            </form>
        <% } else if ("reset".equals(request.getAttribute("step"))) { %>
            <!-- STEP 2: Token + Pwd -->
            <form action="<%= ctx %>/forgot-password" method="post" class="form-left-align">
                <input type="hidden" name="f_action" value="reset">
                <input type="hidden" name="email" value="<%= request.getAttribute("email") != null ? request.getAttribute("email") : (session.getAttribute("resetEmail") != null ? session.getAttribute("resetEmail") : "") %>">
                
                <div class="field">
                    <p class="subtitle reset-info-text">
                        Resetting password for: <strong><%= request.getAttribute("email") != null ? request.getAttribute("email") : (session.getAttribute("resetEmail") != null ? session.getAttribute("resetEmail") : "Required Email Lost") %></strong>
                    </p>
                    <label for="token">Reset Token</label>
                    <input type="text" id="token" name="token" value="<%= request.getAttribute("token") != null ? request.getAttribute("token") : "" %>" placeholder="8-Character Token" required autofocus>
                    <p class="subtitle token-hint">Check console or use: <%= request.getAttribute("token") %></p>
                </div>
                
                <div class="field">
                    <label for="newPassword">New Password</label>
                    <input type="password" id="newPassword" name="newPassword" placeholder="Minimum 6 characters" required>
                </div>

                <div class="field">
                    <label for="confirm">Confirm Password</label>
                    <input type="password" id="confirm" name="confirm" placeholder="Repeat password" required>
                </div>
                
                <button type="submit" class="btn-duo btn-duo-blue btn-submit-gap">
                    Update Password
                </button>
            </form>
        <% } %>

        <div class="auth-divider">
            <span>Remembered it?</span>
        </div>

        <a href="<%= ctx %>/login" class="btn-duo btn-duo-ghost">
            Login
        </a>
    </div>
</div>

</body>
</html>
