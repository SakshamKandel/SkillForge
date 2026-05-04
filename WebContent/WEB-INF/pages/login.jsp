<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<% String ctx = request.getContextPath(); %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login — SkillForge</title>
    <link rel="stylesheet" href="<%= ctx %>/css/auth.css">
    <script src="https://accounts.google.com/gsi/client" async defer></script>
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
            <span>or</span>
        </div>

        <!-- Sign In With Google -->
        <div id="g_id_onload"
             data-client_id="740455423110-bi3kos6v3msmmcs1u09lrudu2g0r0dnt.apps.googleusercontent.com"
             data-callback="handleGoogleCredential"
             data-auto_prompt="false"></div>
        <div class="g_id_signin"
             data-type="standard"
             data-size="large"
             data-theme="outline"
             data-text="signin_with"
             data-shape="rectangular"
             data-logo_alignment="left"
             data-width="320"
             style="display: flex; justify-content: center;"></div>

        <div class="auth-divider">
            <span>New to SkillForge?</span>
        </div>

        <a href="<%= ctx %>/register" class="btn-duo btn-duo-ghost">
            Create Account
        </a>
    </div>
</div>

<form id="googleAuthForm" action="<%= ctx %>/auth/google" method="post" style="display:none;">
    <input type="hidden" name="credential" id="googleCredential" />
</form>
<script>
function handleGoogleCredential(response) {
    document.getElementById('googleCredential').value = response.credential;
    document.getElementById('googleAuthForm').submit();
}
</script>

</body>
</html>
