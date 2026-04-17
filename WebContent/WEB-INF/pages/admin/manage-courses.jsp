<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.skillforge.model.Course, java.util.List" %>
<%
    request.setAttribute("pageTitle", "Manage Courses");
    request.setAttribute("activePage", "courses");
%>
<%@ include file="/WEB-INF/pages/common/header.jsp" %>
<%
    List<Course> courses = (List<Course>) request.getAttribute("courses");
    String searchVal = (String) request.getAttribute("search");
%>

<!-- ===== Content ===== -->
<div class="p-10">
    <div class="flex flex-col xl:flex-row xl:items-end justify-between gap-8 mb-10">
        <div class="flex items-center gap-6">
            <img src="<%= ctx %>/images/Students with teacher.png" alt="Mascot" class="w-24 h-24 object-contain" />
            <div>
                <h2 class="text-3xl font-black text-slate-800 tracking-tight">Curriculum Control</h2>
                <p class="text-[0.7rem] font-black text-slate-400 uppercase tracking-widest mt-2">Design and oversee academic offerings</p>
            </div>
        </div>
        
        <div class="flex flex-col sm:flex-row items-center gap-4">
            <form method="get" action="<%= ctx %>/admin/courses" class="relative group">
                <input type="text" name="search" placeholder="Search curriculum..." value="<%= searchVal != null ? searchVal : "" %>"
                       class="w-full sm:w-80 pl-12 pr-6 py-4 bg-white rounded-2xl text-sm font-black text-slate-700 ring-1 ring-slate-100 shadow-sm focus:ring-8 focus:ring-brand/5 focus:border-brand border-2 border-transparent transition-all outline-none" />
                <svg class="absolute left-4 top-1/2 -translate-y-1/2 w-5 h-5 text-slate-300 group-hover:text-brand transition-colors" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="3"><circle cx="11" cy="11" r="8"/><path d="m21 21-4.3-4.3"/></svg>
            </form>
            
            <a href="<%= ctx %>/admin/courses?action=add" class="w-full sm:w-auto flex items-center justify-center gap-3 px-8 py-4 bg-brand text-white rounded-2xl font-black text-xs uppercase tracking-widest shadow-[0_6px_0_0_rgb(66,153,2)] hover:translate-y-[-2px] active:translate-y-[2px] active:shadow-none transition-all">
                <svg class="w-4 h-4" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="4"><path d="M12 5v14M5 12h14"/></svg>
                Deploy Course
            </a>
        </div>
    </div>

    <div class="bg-white rounded-[2.5rem] overflow-hidden shadow-[0_8px_30px_rgb(0,0,0,0.04)] ring-1 ring-slate-100">
        <div class="overflow-x-auto">
            <table class="w-full text-left border-collapse">
                <thead>
                    <tr class="bg-slate-50/50">
                        <th class="px-8 py-6 text-[0.7rem] font-black text-slate-400 uppercase tracking-widest">Syllabus Title</th>
                        <th class="px-8 py-6 text-[0.7rem] font-black text-slate-400 uppercase tracking-widest">Faculty</th>
                        <th class="px-8 py-6 text-[0.7rem] font-black text-slate-400 uppercase tracking-widest text-center">Duration</th>
                        <th class="px-8 py-6 text-[0.7rem] font-black text-slate-400 uppercase tracking-widest text-center">Visibility</th>
                        <th class="px-8 py-6 text-[0.7rem] font-black text-slate-400 uppercase tracking-widest text-right">Settings</th>
                    </tr>
                </thead>
                <tbody class="divide-y divide-slate-50">
                <% if (courses != null && !courses.isEmpty()) {
                    for (Course co : courses) { %>
                    <tr class="group hover:bg-slate-50/30 transition-colors">
                        <td class="px-8 py-8">
                            <div class="font-black text-slate-800 leading-tight"><%= co.getTitle() %></div>
                            <div class="text-[0.65rem] font-black text-slate-400 uppercase tracking-widest mt-1"><%= co.getCategory() %></div>
                        </td>
                        <td class="px-8 py-8">
                            <div class="flex items-center gap-3">
                                <div class="w-8 h-8 rounded-lg bg-slate-100 flex items-center justify-center text-[0.6rem] font-black text-slate-400 uppercase">
                                    <%= co.getInstructor().substring(0, 1) %>
                                </div>
                                <span class="text-sm font-bold text-slate-600"><%= co.getInstructor() %></span>
                            </div>
                        </td>
                        <td class="px-8 py-8 text-center text-xs font-black text-slate-400 tabular-nums">
                            <%= co.getDurationWeeks() %> <span class="text-[0.6rem] uppercase tracking-tighter">Weeks</span>
                        </td>
                        <td class="px-8 py-8 text-center">
                            <span class="inline-flex px-4 py-1.5 rounded-full text-[0.6rem] font-black uppercase tracking-widest
                                <%= co.isActive() ? "bg-brand/10 text-brand" : "bg-slate-50 text-slate-400" %>">
                                <%= co.isActive() ? "Public" : "Draft" %>
                            </span>
                        </td>
                        <td class="px-8 py-8 text-right">
                            <div class="flex items-center justify-end gap-3">
                                <a href="<%= ctx %>/admin/courses?action=edit&id=<%= co.getId() %>" 
                                   class="p-3 text-slate-400 hover:text-brand hover:bg-brand/5 rounded-xl transition-all">
                                    <svg class="w-5 h-5" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="3"><path d="M17 3a2.828 2.828 0 1 1 4 4L7.5 20.5 2 22l1.5-5.5L17.3 3z"/></svg>
                                </a>
                                <a href="<%= ctx %>/admin/courses?action=delete&id=<%= co.getId() %>" 
                                   class="p-3 text-slate-400 hover:text-red-500 hover:bg-red-50 rounded-xl transition-all"
                                   onclick="return confirm('Wipe curriculum record?')">
                                    <svg class="w-5 h-5" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="3"><path d="M3 6h18M19 6v14c0 1-1 2-2 2H7c-1 0-2-1-2-2V6M8 6V4c0-1 1-2 2-2h4c1 0 2 1 2 2v2"/></svg>
                                </a>
                            </div>
                        </td>
                    </tr>
                <% } } else { %>
                    <tr><td colspan="5" class="px-8 py-32 text-center">
                        <div class="w-24 h-24 bg-slate-50 rounded-[2.5rem] flex items-center justify-center mx-auto mb-8 text-slate-100">
                            <svg class="w-12 h-12" fill="none" stroke="currentColor" stroke-width="3" viewBox="0 0 24 24"><path d="M4 19.5v-15A2.5 2.5 0 0 1 6.5 2H20v20H6.5a2.5 2.5 0 0 1 0-5H20"/><path d="M8 7h6"/><path d="M8 11h4"/></svg>
                        </div>
                        <p class="text-base font-black text-slate-400 uppercase tracking-widest">No Curriculum Matched</p>
                    </td></tr>
                <% } %>
                </tbody>
            </table>
        </div>
    </div>
</div>

<%@ include file="/WEB-INF/pages/common/footer.jsp" %>
