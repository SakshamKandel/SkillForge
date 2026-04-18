<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.skillforge.model.Certification" %>
<%
    Certification cert = (Certification) request.getAttribute("cert");
    int attemptId = (int) request.getAttribute("attemptId");
    boolean passed = (cert != null);
%>
<%@ include file="/WEB-INF/pages/common/header.jsp" %>

<div class="px-10 py-20 flex flex-col items-center text-center">
    <div class="max-w-2xl w-full bg-white rounded-[3rem] p-16 shadow-[0_20px_50px_rgba(0,0,0,0.1)] border border-slate-100">
        
        <% if (passed) { %>
            <div class="mb-10 animate-bounce">
                <div class="w-32 h-32 bg-duo-green rounded-full flex items-center justify-center mx-auto shadow-[0_6px_0_var(--duo-green-dark)]">
                    <svg class="w-16 h-16 text-white" fill="none" stroke="currentColor" stroke-width="4" viewBox="0 0 24 24"><polyline points="20 6 9 17 4 12"/></svg>
                </div>
            </div>
            
            <h2 class="text-4xl font-black text-slate-800 mb-4 tracking-tight">Challenge Mastered!</h2>
            <p class="text-slate-400 font-bold text-lg mb-10">You've successfully completed the quiz for <strong><%= cert.getCourseTitle() %></strong>.</p>
            
            <div class="flex flex-col sm:flex-row gap-4 justify-center">
                <a href="<%= ctx %>/student/certification?attemptId=<%= attemptId %>" class="btn-duo btn-duo-green px-10">
                    <svg class="w-6 h-6 mr-2" fill="none" stroke="currentColor" stroke-width="3" viewBox="0 0 24 24"><path d="M12 2l3.09 6.26L22 9.27l-5 4.87 1.18 6.88L12 17.77l-6.18 3.25L7 14.14 2 9.27l6.91-1.01L12 2z"/></svg>
                    Claim Certificate
                </a>
                <a href="<%= ctx %>/student/courses" class="btn-duo btn-duo-white px-10">Back to Path</a>
            </div>

        <% } else { %>
            <div class="mb-10">
                <div class="w-32 h-32 bg-red-100 rounded-full flex items-center justify-center mx-auto text-red-500">
                    <svg class="w-16 h-16" fill="none" stroke="currentColor" stroke-width="4" viewBox="0 0 24 24"><line x1="18" y1="6" x2="6" y2="18"></line><line x1="6" y1="6" x2="18" y2="18"></line></svg>
                </div>
            </div>
            
            <h2 class="text-4xl font-black text-slate-800 mb-4 tracking-tight">Almost There!</h2>
            <p class="text-slate-400 font-bold text-lg mb-10">Don't worry, every mistake is a lesson. Review your course materials and try again when you're ready.</p>
            
            <div class="flex gap-4 justify-center">
                <button onclick="window.history.back()" class="btn-duo btn-duo-blue px-10">Try Again</button>
                <a href="<%= ctx %>/student/courses" class="btn-duo btn-duo-white px-10">Study More</a>
            </div>
        <% } %>
    </div>
    
    <!-- Animation Text Overlay (Optional extra Duo vibe) -->
    <div class="mt-16 text-xs font-black text-slate-300 uppercase tracking-[0.3em] duo-animate-text">
        SkillForge &bull; Verified Learning &bull; Expert Path
    </div>
</div>

<style>
    .duo-animate-text {
        animation: duoBounce 2s infinite ease-in-out;
    }
</style>

<%@ include file="/WEB-INF/pages/common/footer.jsp" %>
