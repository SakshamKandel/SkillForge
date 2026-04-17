<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.skillforge.model.Enrollment, java.util.List" %>
<%
    request.setAttribute("pageTitle", "Student Dashboard");
    request.setAttribute("activePage", "dashboard");
%>
<%@ include file="/WEB-INF/pages/common/header.jsp" %>
<%
    List<Enrollment> enrollments = (List<Enrollment>) request.getAttribute("enrollments");
    int enrolledCount  = (int) request.getAttribute("enrolledCount");
    int completedCount = (int) request.getAttribute("completedCount");
%>

<!-- ===== Content ===== -->
<div class="p-10 space-y-12">
    <!-- Header with Mascot -->
    <div class="flex items-center gap-6 mb-4">
        <img src="<%= ctx %>/images/Learning.png" alt="Mascot" class="w-32 h-32 object-contain" />
        <div>
            <h2 class="text-4xl font-black text-slate-800 tracking-tight">Your Progress Depot</h2>
            <p class="text-xs font-black text-slate-400 uppercase tracking-[0.2em] mt-2 leading-none">A snapshot of your academic journey</p>
        </div>
    </div>

    <!-- Stat Cards -->
    <div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-10">
        <!-- Enrolled -->
        <div class="bg-white p-10 rounded-[3rem] shadow-[0_8px_30px_rgb(0,0,0,0.04)] ring-1 ring-slate-100 flex flex-col justify-between">
            <div class="flex items-center gap-4 mb-8">
                <div class="w-12 h-12 rounded-2xl bg-blue-50 text-blue-500 flex items-center justify-center">
                    <svg class="w-6 h-6" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="3"><path d="M4 19.5v-15A2.5 2.5 0 0 1 6.5 2H20v20H6.5a2.5 2.5 0 0 1 0-5H20"/><path d="M8 7h6"/><path d="M8 11h4"/></svg>
                </div>
                <h3 class="text-[0.7rem] font-black text-slate-400 uppercase tracking-widest">Enrolled</h3>
            </div>
            <div class="text-6xl font-black text-slate-800 tabular-nums"><%= enrolledCount %></div>
        </div>

        <!-- Completed -->
        <div class="bg-white p-10 rounded-[3rem] shadow-[0_8px_30px_rgb(0,0,0,0.04)] ring-1 ring-slate-100 flex flex-col justify-between">
            <div class="flex items-center gap-4 mb-8">
                <div class="w-12 h-12 rounded-2xl bg-amber-50 text-amber-500 flex items-center justify-center">
                    <svg class="w-6 h-6" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="3"><polyline points="20 6 9 17 4 12"/></svg>
                </div>
                <h3 class="text-[0.7rem] font-black text-slate-400 uppercase tracking-widest">Completed</h3>
            </div>
            <div class="text-6xl font-black text-slate-800 tabular-nums"><%= completedCount %></div>
        </div>

        <!-- Browse Action -->
        <div class="bg-slate-900 p-10 rounded-[3rem] shadow-xl shadow-slate-900/10 flex flex-col justify-between group overflow-hidden relative">
            <div class="absolute inset-0 bg-[radial-gradient(circle_at_30%_-20%,#58cc0220_0%,transparent_50%)]"></div>
            <div class="relative z-10">
                <h3 class="text-[0.75rem] font-black text-slate-400 uppercase tracking-widest mb-2">New Skills</h3>
                <p class="text-white font-bold text-lg leading-tight mb-8">Ready to expand your horizon?</p>
            </div>
            <a href="<%= ctx %>/student/courses" class="relative z-10 w-full bg-brand text-white py-5 rounded-2xl font-black text-sm uppercase tracking-widest flex items-center justify-center gap-3 shadow-[0_6px_0_0_rgb(66,153,2)] hover:translate-y-[-2px] active:translate-y-[2px] active:shadow-none transition-all">
                Browse Catalog
                <svg class="w-4 h-4 group-hover:translate-x-1 transition-transform" fill="none" stroke="currentColor" stroke-width="3" viewBox="0 0 24 24"><path d="M5 12h14M12 5l7 7-7 7"/></svg>
            </a>
        </div>
    </div>

    <!-- Learning Progress -->
    <section>
        <div class="flex items-center justify-between mb-8">
            <div>
                <h2 class="text-2xl font-black text-slate-800 tracking-tight">Recent Progress</h2>
                <p class="text-[0.7rem] font-black text-slate-400 uppercase tracking-widest mt-2">Your latest academic milestones</p>
            </div>
        </div>

        <div class="bg-white rounded-[2.5rem] overflow-hidden shadow-[0_8px_30px_rgb(0,0,0,0.04)] ring-1 ring-slate-100">
            <div class="overflow-x-auto">
                <table class="w-full text-left border-collapse">
                    <thead>
                        <tr class="bg-slate-50/50">
                            <th class="px-10 py-6 text-[0.7rem] font-black text-slate-400 uppercase tracking-widest">Syllabus</th>
                            <th class="px-10 py-6 text-[0.7rem] font-black text-slate-400 uppercase tracking-widest">Velocity</th>
                            <th class="px-10 py-6 text-[0.7rem] font-black text-slate-400 uppercase tracking-widest text-center">Milestone</th>
                            <th class="px-10 py-6 text-[0.7rem] font-black text-slate-400 uppercase tracking-widest text-right">Commit Date</th>
                        </tr>
                    </thead>
                    <tbody class="divide-y divide-slate-50">
                    <% if (enrollments != null && !enrollments.isEmpty()) {
                        for (Enrollment en : enrollments) { %>
                        <tr class="group hover:bg-slate-50/30 transition-colors text-sm">
                            <td class="px-10 py-8">
                                <div class="font-black text-slate-800 leading-tight"><%= en.getCourseTitle() %></div>
                                <div class="text-[0.65rem] font-black text-slate-400 uppercase tracking-widest mt-1">Instructor: <%= en.getInstructor() %></div>
                            </td>
                            <td class="px-10 py-8 w-64">
                                <div class="flex items-center gap-4">
                                    <div class="flex-1 h-3 bg-slate-100 rounded-full overflow-hidden p-[2px]">
                                        <div class="h-full rounded-full transition-all duration-1000 ease-out <%= en.getProgress() >= 100 ? "bg-amber-400" : "bg-brand" %> shadow-sm" style="width:<%= en.getProgress() %>%"></div>
                                    </div>
                                    <span class="text-xs font-black text-slate-500 tabular-nums"><%= en.getProgress() %>%</span>
                                </div>
                            </td>
                            <td class="px-10 py-8 text-center">
                                <span class="inline-flex px-4 py-2 rounded-xl text-[0.65rem] font-black uppercase tracking-widest
                                    <%= "active".equals(en.getStatus()) ? "bg-brand/10 text-brand" : "completed".equals(en.getStatus()) ? "bg-amber-50 text-amber-600" : "bg-slate-50 text-slate-400" %>">
                                    <%= en.getStatus() %>
                                </span>
                            </td>
                            <td class="px-10 py-8 text-right text-xs font-black text-slate-400 tabular-nums">
                                <%= en.getEnrolledAt() %>
                            </td>
                        </tr>
                    <% } } else { %>
                        <tr><td colspan="4" class="px-10 py-24 text-center">
                            <div class="w-20 h-20 bg-slate-50 rounded-[2rem] flex items-center justify-center mx-auto mb-6 text-slate-200">
                                <svg class="w-10 h-10" fill="none" stroke="currentColor" stroke-width="3" viewBox="0 0 24 24"><path d="M12 8v4l3 3m6-3a9 9 0 1 1-18 0 9 9 0 0 1 18 0z"/></svg>
                            </div>
                            <p class="text-sm font-black text-slate-400 uppercase tracking-[0.2em]">No Courses Started Yet</p>
                        </td></tr>
                    <% } %>
                    </tbody>
                </table>
            </div>
        </div>
    </section>
</div>

<%@ include file="/WEB-INF/pages/common/footer.jsp" %>
