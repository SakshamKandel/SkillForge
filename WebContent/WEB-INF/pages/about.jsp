<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    request.setAttribute("pageTitle", "About SkillForge");
    request.setAttribute("activePage", "about");
%>
<%@ include file="/WEB-INF/pages/common/header.jsp" %>

<!-- ===== About Page Content ===== -->
<div class="p-10 space-y-12">
    <!-- Hero Section -->
    <div class="bg-white rounded-[3rem] overflow-hidden shadow-[0_8px_30px_rgb(0,0,0,0.04)] ring-1 ring-slate-100">
        <div class="h-48 bg-slate-900 relative overflow-hidden">
            <div class="absolute inset-0 bg-[radial-gradient(circle_at_30%_50%,#58cc0220_0%,transparent_50%),radial-gradient(circle_at_70%_50%,#1cb0f620_0%,transparent_50%)]"></div>
        </div>
        <div class="px-12 pb-12 -mt-16 relative">
            <div class="w-24 h-24 bg-brand rounded-[2rem] flex items-center justify-center shadow-xl mb-6 border-[6px] border-white">
                <img src="<%= ctx %>/images/Logo.png" alt="Logo" class="w-14 h-14 object-contain" />
            </div>
            <h2 class="text-4xl font-black text-slate-800 tracking-tight mb-4">About SkillForge</h2>
            <p class="text-lg font-bold text-slate-500 max-w-3xl leading-relaxed">
                SkillForge is an Online Course Enrollment and Progress Tracking System built as a 
                Java Dynamic Web Application. It demonstrates enterprise-grade software engineering 
                practices using the MVC architectural pattern, Jakarta EE, and MySQL.
            </p>
        </div>
    </div>

    <!-- Features Grid -->
    <div class="grid grid-cols-1 md:grid-cols-2 xl:grid-cols-3 gap-10">
        <!-- Feature 1 -->
        <div class="bg-white p-10 rounded-[2.5rem] shadow-[0_8px_30px_rgb(0,0,0,0.04)] ring-1 ring-slate-100">
            <div class="w-14 h-14 rounded-2xl bg-brand/10 flex items-center justify-center text-brand mb-6">
                <svg class="w-7 h-7" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="3"><path d="M4 19.5v-15A2.5 2.5 0 0 1 6.5 2H20v20H6.5a2.5 2.5 0 0 1 0-5H20"/><path d="M8 7h6"/><path d="M8 11h4"/></svg>
            </div>
            <h3 class="text-xl font-black text-slate-800 mb-3">Course Management</h3>
            <p class="text-sm font-bold text-slate-400 leading-relaxed">
                Admins can create, update, and delete courses with categories and instructor assignments. 
                Students can browse, enroll, track progress, and drop courses.
            </p>
        </div>

        <!-- Feature 2 -->
        <div class="bg-white p-10 rounded-[2.5rem] shadow-[0_8px_30px_rgb(0,0,0,0.04)] ring-1 ring-slate-100">
            <div class="w-14 h-14 rounded-2xl bg-blue-50 flex items-center justify-center text-blue-500 mb-6">
                <svg class="w-7 h-7" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="3"><path d="M12 2l3.09 6.26L22 9.27l-5 4.87 1.18 6.88L12 17.77l-6.18 3.25L7 14.14 2 9.27l6.91-1.01L12 2z"/></svg>
            </div>
            <h3 class="text-xl font-black text-slate-800 mb-3">Quizzes &amp; Certificates</h3>
            <p class="text-sm font-bold text-slate-400 leading-relaxed">
                Students earn certificates by passing course quizzes. Each quiz features multiple-choice 
                questions with instant grading and a unique certification code on pass.
            </p>
        </div>

        <!-- Feature 3 -->
        <div class="bg-white p-10 rounded-[2.5rem] shadow-[0_8px_30px_rgb(0,0,0,0.04)] ring-1 ring-slate-100">
            <div class="w-14 h-14 rounded-2xl bg-purple-50 flex items-center justify-center text-purple-500 mb-6">
                <svg class="w-7 h-7" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="3"><rect width="18" height="11" x="3" y="11" rx="2" ry="2"/><path d="M7 11V7a5 5 0 0 1 10 0v4"/></svg>
            </div>
            <h3 class="text-xl font-black text-slate-800 mb-3">Security &amp; Auth</h3>
            <p class="text-sm font-bold text-slate-400 leading-relaxed">
                AES-128 password encryption, role-based access control via Servlet Filter, 
                account lockout after 5 failed attempts, and forgot-password with token reset.
            </p>
        </div>
    </div>

    <!-- Tech Stack Section -->
    <div class="bg-white rounded-[2.5rem] p-12 shadow-[0_8px_30px_rgb(0,0,0,0.04)] ring-1 ring-slate-100">
        <h2 class="text-2xl font-black text-slate-800 tracking-tight mb-8">Technology Stack</h2>
        <div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-8">
            <div class="flex items-center gap-4 p-5 bg-slate-50 rounded-2xl">
                <div class="w-10 h-10 rounded-xl bg-orange-50 flex items-center justify-center text-orange-500 font-black text-sm">JE</div>
                <div>
                    <div class="font-black text-slate-700 text-sm">Jakarta EE 5.0</div>
                    <div class="text-[0.65rem] font-bold text-slate-400 uppercase tracking-widest">Servlets + JSP</div>
                </div>
            </div>
            <div class="flex items-center gap-4 p-5 bg-slate-50 rounded-2xl">
                <div class="w-10 h-10 rounded-xl bg-blue-50 flex items-center justify-center text-blue-500 font-black text-sm">DB</div>
                <div>
                    <div class="font-black text-slate-700 text-sm">MySQL 8.x</div>
                    <div class="text-[0.65rem] font-bold text-slate-400 uppercase tracking-widest">InnoDB + 3NF</div>
                </div>
            </div>
            <div class="flex items-center gap-4 p-5 bg-slate-50 rounded-2xl">
                <div class="w-10 h-10 rounded-xl bg-red-50 flex items-center justify-center text-red-500 font-black text-sm">TC</div>
                <div>
                    <div class="font-black text-slate-700 text-sm">Apache Tomcat 10.1</div>
                    <div class="text-[0.65rem] font-bold text-slate-400 uppercase tracking-widest">App Server</div>
                </div>
            </div>
            <div class="flex items-center gap-4 p-5 bg-slate-50 rounded-2xl">
                <div class="w-10 h-10 rounded-xl bg-brand/10 flex items-center justify-center text-brand font-black text-sm">TW</div>
                <div>
                    <div class="font-black text-slate-700 text-sm">Tailwind CSS</div>
                    <div class="text-[0.65rem] font-bold text-slate-400 uppercase tracking-widest">Utility-First CSS</div>
                </div>
            </div>
        </div>
    </div>

    <!-- FAQ Section -->
    <div class="bg-white rounded-[2.5rem] p-12 shadow-[0_8px_30px_rgb(0,0,0,0.04)] ring-1 ring-slate-100">
        <h2 class="text-2xl font-black text-slate-800 tracking-tight mb-8">Frequently Asked Questions</h2>
        <div class="space-y-6">
            <div class="p-6 bg-slate-50 rounded-2xl">
                <h4 class="font-black text-slate-700 mb-2">How do I enroll in a course?</h4>
                <p class="text-sm font-bold text-slate-400">Navigate to "My Courses" from the sidebar, scroll to the catalog section, and click the "Enroll" button on any available course.</p>
            </div>
            <div class="p-6 bg-slate-50 rounded-2xl">
                <h4 class="font-black text-slate-700 mb-2">How are passwords stored?</h4>
                <p class="text-sm font-bold text-slate-400">All passwords are encrypted using AES-128 (ECB mode with PKCS5 padding) before being stored in the database. Plain-text passwords are never saved.</p>
            </div>
            <div class="p-6 bg-slate-50 rounded-2xl">
                <h4 class="font-black text-slate-700 mb-2">What happens after 5 failed login attempts?</h4>
                <p class="text-sm font-bold text-slate-400">Your account will be automatically locked for security. An administrator must manually unlock it from the admin dashboard.</p>
            </div>
            <div class="p-6 bg-slate-50 rounded-2xl">
                <h4 class="font-black text-slate-700 mb-2">How do I earn a certificate?</h4>
                <p class="text-sm font-bold text-slate-400">Complete your course progress to 100%, then take the associated quiz. If you score above the passing threshold, a unique certificate is automatically generated.</p>
            </div>
        </div>
    </div>
</div>

<%@ include file="/WEB-INF/pages/common/footer.jsp" %>
