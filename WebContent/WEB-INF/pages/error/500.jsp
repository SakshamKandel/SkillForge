<%@ page contentType="text/html;charset=UTF-8" language="java" isErrorPage="true" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>500 — Server Error</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/style.css" />
</head>
<body>
<div class="error-page">
    <div class="error-box">
        <div class="code">500</div>
        <h2>Something Went Wrong</h2>
        <p>An internal server error occurred. Please try again later.</p>
        <a href="<%= request.getContextPath() %>/login" class="btn btn-teal">Back to Login</a>
    </div>
</div>
</body>
</html>
