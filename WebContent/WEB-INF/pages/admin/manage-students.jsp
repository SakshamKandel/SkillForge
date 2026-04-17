<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.skillforge.model.User, java.util.List" %>
<%
    request.setAttribute("pageTitle", "Manage Students");
    request.setAttribute("activePage", "students");
%>
<%@ include file="/WEB-INF/pages/common/header.jsp" %>
<%
    List<User> students = (List<User>) request.getAttribute("students");
%>

<!-- ===== Content ===== -->
<div class="p-10">
    <div class="flex items-center justify-between mb-10">
        <div class="flex items-center gap-6">
            <img src="<%= ctx %>/images/Adminn with student.png" alt="Mascot" class="w-24 h-24 object-contain" />
            <div>
                <h2 class="text-3xl font-black text-slate-800 tracking-tight">Student Directory</h2>
                <p class="text-[0.7rem] font-black text-slate-400 uppercase tracking-widest mt-2">Manage all registered platform users</p>
            </div>
        </div>
        <div class="flex gap-4">
            <div class="px-6 py-4 rounded-2xl bg-white shadow-sm ring-1 ring-slate-100 flex items-center gap-3">
                <span class="text-[0.7rem] font-black text-slate-400 uppercase tracking-widest border-r border-slate-100 pr-3">Total</span>
                <span class="text-sm font-black text-slate-800"><%= students != null ? students.size() : 0 %> Students</span>
            </div>
        </div>
    </div>

    <div class="bg-white rounded-[2.5rem] overflow-hidden shadow-[0_8px_30px_rgb(0,0,0,0.04)] ring-1 ring-slate-100">
        <div class="overflow-x-auto">
            <table class="w-full text-left border-collapse">
                <thead>
                    <tr class="bg-slate-50/50">
                        <th class="px-8 py-6 text-[0.7rem] font-black text-slate-400 uppercase tracking-widest">Identify</th>
                        <th class="px-8 py-6 text-[0.7rem] font-black text-slate-400 uppercase tracking-widest">Connect</th>
                        <th class="px-8 py-6 text-[0.7rem] font-black text-slate-400 uppercase tracking-widest text-center">Security Status</th>
                        <th class="px-8 py-6 text-[0.7rem] font-black text-slate-400 uppercase tracking-widest text-right">Operations</th>
                    </tr>
                </thead>
                <tbody class="divide-y divide-slate-50">
                <% if (students != null && !students.isEmpty()) {
                    for (User st : students) { %>
                    <tr class="group hover:bg-slate-50/30 transition-colors">
                        <td class="px-8 py-8">
                            <div class="flex items-center gap-5">
                                <div class="relative">
                                    <% if (st.getProfilePhoto() != null && st.getProfilePhoto().length > 0) { %>
                                        <img src="<%= ctx %>/photo?userId=<%= st.getId() %>" alt="Photo" class="w-16 h-16 rounded-[1.2rem] object-cover bg-white ring-4 ring-slate-50 border border-slate-100 shadow-sm" />
                                    <% } else { %>
                                        <div class="w-16 h-16 rounded-[1.2rem] bg-brand/10 flex items-center justify-center text-xl font-black text-brand ring-4 ring-brand/5 border border-brand/10 shadow-sm">
                                            <%= st.getFullName().substring(0, 1).toUpperCase() %>
                                        </div>
                                    <% } %>
                                    <% if (st.isLocked()) { %>
                                        <div class="absolute -top-1 -right-1 w-5 h-5 bg-red-500 rounded-full border-4 border-white flex items-center justify-center">
                                            <svg class="w-2 h-2 text-white" fill="none" stroke="currentColor" stroke-width="4" viewBox="0 0 24 24"><path d="M12 1v22M17 5H9.5a3.5 3.5 0 0 0 0 7h5a3.5 3.5 0 0 1 0 7H6"/></svg>
                                        </div>
                                    <% } %>
                                </div>
                                <div>
                                    <div class="text-base font-black text-slate-800 leading-tight"><%= st.getFullName() %></div>
                                    <div class="text-[0.65rem] font-black text-slate-400 uppercase tracking-widest mt-1">ID: #SF-<%= st.getId() %></div>
                                </div>
                            </div>
                        </td>
                        <td class="px-8 py-8">
                            <div class="flex flex-col gap-1.5">
                                <div class="flex items-center gap-2 text-sm font-bold text-slate-600">
                                    <svg class="w-3.5 h-3.5 text-slate-300" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="3"><rect width="20" height="16" x="2" y="4" rx="2"/><path d="m22 7-8.97 5.7a1.94 1.94 0 0 1-2.06 0L2 7"/></svg>
                                    <%= st.getEmail() %>
                                </div>
                                <div class="flex items-center gap-2 text-[0.7rem] font-bold text-slate-400">
                                    <svg class="w-3.5 h-3.5 text-slate-200" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="3"><path d="M22 16.92v3a2 2 0 0 1-2.18 2 19.79 19.79 0 0 1-8.63-3.07 19.5 19.5 0 0 1-6-6 19.79 19.79 0 0 1-3.07-8.67A2 2 0 0 1 4.11 2h3a2 2 0 0 1 2 1.72 12.84 12.84 0 0 0 .7 2.81 2 2 0 0 1-.45 2.11L8.09 9.91a16 16 0 0 0 6 6l1.27-1.27a2 2 0 0 1 2.11-.45 12.84 12.84 0 0 0 2.81.7A2 2 0 0 1 22 16.92z"/></svg>
                                    <%= st.getPhone() %>
                                </div>
                            </div>
                        </td>
                        <td class="px-8 py-8 text-center">
                            <div class="flex flex-col items-center gap-2">
                                <span class="inline-flex px-4 py-1.5 rounded-full text-[0.6rem] font-black uppercase tracking-widest
                                    <%= st.isLocked() ? "bg-red-50 text-red-600" : "bg-brand/10 text-brand" %>">
                                    <%= st.isLocked() ? "Account Locked" : "Authenticated" %>
                                </span>
                                <% if (st.getFailedAttempts() > 0) { %>
                                    <span class="text-[0.6rem] font-bold text-amber-500 uppercase tracking-widest"><%= st.getFailedAttempts() %> Failed Attempts</span>
                                <% } %>
                            </div>
                        </td>
                        <td class="px-8 py-8 text-right">
                            <div class="flex items-center justify-end gap-3">
                                <% if (st.isLocked()) { %>
                                    <a href="<%= ctx %>/admin?action=unlock&id=<%= st.getId() %>" 
                                       class="px-5 py-3 text-[0.65rem] font-black uppercase tracking-widest text-amber-600 bg-amber-50 rounded-xl hover:bg-amber-100 transition-all border border-amber-100">
                                        Release Lock
                                    </a>
                                <% } %>
                                <a href="<%= ctx %>/admin?action=remove&id=<%= st.getId() %>" 
                                   class="p-3 text-red-400 hover:text-red-600 hover:bg-red-50 rounded-xl transition-all"
                                   onclick="return confirm('Wipe student record? This action is irreversible.')">
                                    <svg class="w-5 h-5" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="3"><path d="M3 6h18M19 6v14c0 1-1 2-2 2H7c-1 0-2-1-2-2V6M8 6V4c0-1 1-2 2-2h4c1 0 2 1 2 2v2"/></svg>
                                </a>
                            </div>
                        </td>
                    </tr>
                <% } } else { %>
                    <tr><td colspan="4" class="px-8 py-32 text-center">
                        <div class="w-24 h-24 bg-slate-50 rounded-[2.5rem] flex items-center justify-center mx-auto mb-8 text-slate-100">
                            <svg class="w-12 h-12" fill="none" stroke="currentColor" stroke-width="3" viewBox="0 0 24 24"><path d="M17 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2"/><circle cx="9" cy="7" r="4"/><path d="M23 21v-2a4 4 0 0 0-3-3.87"/><path d="m16 3.13a4 4 0 0 1 0 7.75"/></svg>
                        </div>
                        <p class="text-base font-black text-slate-400 uppercase tracking-widest">No Student Records Found</p>
                    </td></tr>
                <% } %>
                </tbody>
            </table>
        </div>
    </div>
</div>

<%@ include file="/WEB-INF/pages/common/footer.jsp" %>
