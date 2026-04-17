<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    request.setAttribute("pageTitle", "My Profile");
    request.setAttribute("activePage", "profile");
%>
<%@ include file="/WEB-INF/pages/common/header.jsp" %>
<jsp:useBean id="userBean" type="com.skillforge.model.User" scope="request" />
<%
    String error   = (String) request.getAttribute("error");
    String success = (String) request.getAttribute("success");
    String initial = (userBean.getFullName() != null && !userBean.getFullName().isEmpty())
                      ? userBean.getFullName().substring(0, 1).toUpperCase() : "?";
%>

<!-- ===== Content ===== -->
<div class="p-10 space-y-10">
    
    <!-- Notifications -->
    <% if (error != null) { %>
        <div class="flex items-center gap-4 px-8 py-5 rounded-[2rem] bg-red-50 text-red-700 animate-[fadeUp_.4s_ease-out]">
            <div class="w-10 h-10 rounded-full bg-white flex items-center justify-center shadow-sm">
                <svg class="w-5 h-5 text-red-500" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="3"><path d="M18 6 6 18M6 6l12 12"/></svg>
            </div>
            <span class="text-sm font-black uppercase tracking-widest"><%= error %></span>
        </div>
    <% } %>
    <% if (success != null) { %>
        <div class="flex items-center gap-4 px-8 py-5 rounded-[2rem] bg-brand/10 text-brand animate-[fadeUp_.4s_ease-out]">
            <div class="w-10 h-10 rounded-full bg-white flex items-center justify-center shadow-sm">
                <svg class="w-5 h-5 text-brand" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="3"><polyline points="20 6 9 17 4 12"/></svg>
            </div>
            <span class="text-sm font-black uppercase tracking-widest text-brand"><%= success %></span>
        </div>
    <% } %>

    <!-- Header Card -->
    <div class="relative bg-white rounded-[3rem] overflow-hidden shadow-[0_8px_30px_rgb(0,0,0,0.04)] ring-1 ring-slate-100">
        <div class="h-48 bg-slate-50 relative overflow-hidden">
            <div class="absolute inset-0 bg-[radial-gradient(circle_at_20%_30%,#42990208_0%,transparent_50%),radial-gradient(circle_at_80%_70%,#42990205_0%,transparent_50%)]"></div>
            <div class="absolute inset-0 opacity-[0.03] bg-[url('https://www.transparenttextures.com/patterns/cubes.png')]"></div>
        </div>
        
        <div class="px-12 pb-12 -mt-20 relative flex flex-col md:flex-row items-center md:items-end gap-8">
            <div class="relative group">
                <% if (userBean.getProfilePhoto() != null && userBean.getProfilePhoto().length > 0) { %>
                    <img src="<%= ctx %>/photo?userId=<%= userBean.getId() %>" alt="Profile"
                         class="w-40 h-40 rounded-[2.5rem] object-cover border-[8px] border-white shadow-xl shadow-slate-200/50 bg-white" />
                <% } else { %>
                    <div class="w-40 h-40 rounded-[2.5rem] bg-brand flex items-center justify-center text-5xl font-black text-white border-[8px] border-white shadow-xl shadow-slate-200/50">
                        <%= initial %>
                    </div>
                <% } %>
            </div>
            
            <div class="md:pb-4 text-center md:text-left flex-1">
                <h1 class="text-4xl font-black text-slate-800 tracking-tight mb-2"><jsp:getProperty name="userBean" property="fullName" /></h1>
                <div class="flex flex-wrap items-center justify-center md:justify-start gap-4">
                    <span class="flex items-center gap-2 text-sm font-bold text-slate-400">
                        <svg class="w-4 h-4 text-brand" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="3"><rect width="20" height="16" x="2" y="4" rx="2"/><path d="m22 7-8.97 5.7a1.94 1.94 0 0 1-2.06 0L2 7"/></svg>
                        <jsp:getProperty name="userBean" property="email" />
                    </span>
                    <span class="w-1.5 h-1.5 rounded-full bg-slate-200"></span>
                    <span class="text-xs font-black text-slate-400 uppercase tracking-widest">Student Member</span>
                </div>
            </div>
            
            <div class="flex gap-4">
                <a href="#photo-section" class="bg-slate-50 text-slate-600 hover:bg-slate-100 px-6 py-4 rounded-2xl text-xs font-black uppercase tracking-widest transition-all">Update Avatar</a>
            </div>
        </div>
    </div>

    <!-- Forms Grid -->
    <div class="grid grid-cols-1 lg:grid-cols-12 gap-10">
        
        <!-- Main Settings -->
        <div class="lg:col-span-7 space-y-10">
            <!-- Details Form -->
            <div class="bg-white rounded-[2.5rem] p-12 shadow-[0_8px_30px_rgb(0,0,0,0.04)] ring-1 ring-slate-100 flex flex-col">
                <div class="flex items-center gap-4 mb-10">
                    <div class="w-12 h-12 rounded-2xl bg-brand/10 flex items-center justify-center text-brand">
                        <svg class="w-6 h-6" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="3"><circle cx="12" cy="8" r="5"/><path d="M20 21a8 8 0 0 0-16 0"/></svg>
                    </div>
                    <h2 class="text-xl font-black text-slate-800 tracking-tight">Personal Details</h2>
                </div>

                <form method="post" action="<%= ctx %>/student/profile" class="space-y-8">
                    <input type="hidden" name="action" value="updateProfile" />
                    <div class="grid grid-cols-1 md:grid-cols-2 gap-8">
                        <div class="group">
                            <label class="block text-[0.7rem] font-black text-slate-400 uppercase tracking-widest mb-3 ml-1">Email <span class="text-xs lowercase font-bold opacity-60">(Locked)</span></label>
                            <input type="email" value="<jsp:getProperty name="userBean" property="email" />" disabled
                                   class="w-full px-6 py-4.5 bg-slate-50/50 rounded-2xl text-slate-400 font-bold border-2 border-transparent cursor-not-allowed text-sm" />
                        </div>
                        <div class="group">
                            <label for="fullName" class="block text-[0.7rem] font-black text-slate-400 uppercase tracking-widest mb-3 ml-1">Full Name</label>
                            <input type="text" id="fullName" name="fullName" value="<jsp:getProperty name="userBean" property="fullName" />" required
                                   class="w-full px-6 py-4.5 bg-slate-50 rounded-2xl focus:bg-white focus:ring-8 focus:ring-brand/5 focus:border-brand border-2 border-transparent transition-all font-black text-slate-700 outline-none text-sm" />
                        </div>
                    </div>
                    <div class="group">
                        <label for="phone" class="block text-[0.7rem] font-black text-slate-400 uppercase tracking-widest mb-3 ml-1">Mobile Phone</label>
                        <input type="text" id="phone" name="phone" value="<jsp:getProperty name="userBean" property="phone" />" required
                               class="w-full px-6 py-4.5 bg-slate-50 rounded-2xl focus:bg-white focus:ring-8 focus:ring-brand/5 focus:border-brand border-2 border-transparent transition-all font-black text-slate-700 outline-none text-sm" />
                    </div>
                    <button type="submit" class="w-full bg-brand text-white py-5 rounded-2xl font-black text-sm uppercase tracking-widest shadow-[0_6px_0_0_rgb(66,153,2)] hover:translate-y-[-2px] active:translate-y-[2px] active:shadow-none transition-all mt-4">
                        Push Updates
                    </button>
                </form>
            </div>

            <!-- Password Form -->
            <div class="bg-white rounded-[2.5rem] p-12 shadow-[0_8px_30px_rgb(0,0,0,0.04)] ring-1 ring-slate-100">
                <div class="flex items-center gap-4 mb-10">
                    <div class="w-12 h-12 rounded-2xl bg-purple-50 flex items-center justify-center text-purple-600">
                        <svg class="w-6 h-6" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="3"><rect width="18" height="11" x="3" y="11" rx="2" ry="2"/><path d="M7 11V7a5 5 0 0 1 10 0v4"/></svg>
                    </div>
                    <h2 class="text-xl font-black text-slate-800 tracking-tight">Security Vault</h2>
                </div>

                <form method="post" action="<%= ctx %>/student/profile" class="space-y-8">
                    <input type="hidden" name="action" value="changePassword" />
                    <div>
                        <label for="currentPassword" class="block text-[0.7rem] font-black text-slate-400 uppercase tracking-widest mb-3 ml-1">Legacy Password</label>
                        <input type="password" id="currentPassword" name="currentPassword" required
                               class="w-full px-6 py-4.5 bg-slate-50 rounded-2xl focus:bg-white focus:ring-8 focus:ring-purple-500/5 focus:border-purple-500 border-2 border-transparent transition-all font-black text-slate-700 outline-none text-sm" />
                    </div>
                    <div class="grid grid-cols-1 md:grid-cols-2 gap-8">
                        <div>
                            <label for="newPassword" class="block text-[0.7rem] font-black text-slate-400 uppercase tracking-widest mb-3 ml-1">New Secret</label>
                            <input type="password" id="newPassword" name="newPassword" placeholder="••••••••" required
                                   class="w-full px-6 py-4.5 bg-slate-50 rounded-2xl focus:bg-white focus:ring-8 focus:ring-purple-500/5 focus:border-purple-500 border-2 border-transparent transition-all font-black text-slate-700 outline-none text-sm" />
                        </div>
                        <div>
                            <label for="confirm" class="block text-[0.7rem] font-black text-slate-400 uppercase tracking-widest mb-3 ml-1">Confirm Secret</label>
                            <input type="password" id="confirm" name="confirm" placeholder="••••••••" required
                                   class="w-full px-6 py-4.5 bg-slate-50 rounded-2xl focus:bg-white focus:ring-8 focus:ring-purple-500/5 focus:border-purple-500 border-2 border-transparent transition-all font-black text-slate-700 outline-none text-sm" />
                        </div>
                    </div>
                    <button type="submit" class="w-full bg-slate-900 text-white py-5 rounded-2xl font-black text-sm uppercase tracking-widest hover:bg-slate-800 shadow-xl shadow-slate-900/10 transition-all">
                        Update Password
                    </button>
                </form>
            </div>
        </div>

        <!-- Photo Selection -->
        <div id="photo-section" class="lg:col-span-5">
            <div class="bg-white rounded-[2.5rem] p-12 shadow-[0_8px_30px_rgb(0,0,0,0.04)] ring-1 ring-slate-100 sticky top-10">
                <div class="flex items-center gap-4 mb-10">
                    <div class="w-12 h-12 rounded-2xl bg-orange-50 flex items-center justify-center text-orange-500">
                        <svg class="w-6 h-6" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="3"><path d="M23 19a2 2 0 0 1-2 2H3a2 2 0 0 1-2-2V8a2 2 0 0 1 2-2h4l2-3h6l2 3h4a2 2 0 0 1 2 2z"/><circle cx="12" cy="13" r="4"/></svg>
                    </div>
                    <h2 class="text-xl font-black text-slate-800 tracking-tight">Profile View</h2>
                </div>

                <div class="flex flex-col items-center mb-12">
                    <div class="relative mb-8">
                        <% if (userBean.getProfilePhoto() != null && userBean.getProfilePhoto().length > 0) { %>
                            <img src="<%= ctx %>/photo?userId=<%= userBean.getId() %>" alt="Profile"
                                 class="w-48 h-48 rounded-[3rem] object-cover ring-[12px] ring-slate-50 border-4 border-white shadow-inner bg-white" />
                            <form method="post" action="<%= ctx %>/student/profile" class="absolute -bottom-3 -right-3">
                                <input type="hidden" name="action" value="deletePhoto" />
                                <button type="submit" onclick="return confirm('Erase your photo?')" 
                                        class="p-4 rounded-2xl bg-white shadow-xl text-red-500 hover:bg-red-50 transition-all border border-slate-100">
                                    <svg class="w-5 h-5" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="3"><path d="M3 6h18M19 6v14c0 1-1 2-2 2H7c-1 0-2-1-2-2V6M8 6V4c0-1 1-2 2-2h4c1 0 2 1 2 2v2"/></svg>
                                </button>
                            </form>
                        <% } else { %>
                            <div class="w-48 h-48 rounded-[3rem] bg-brand flex items-center justify-center text-6xl font-black text-white ring-[12px] ring-brand/5 border-4 border-white">
                                <%= initial %>
                            </div>
                        <% } %>
                    </div>
                    <p class="text-xs font-black text-slate-400 uppercase tracking-widest">Visibility: Public to Instructors</p>
                </div>

                <form method="post" action="<%= ctx %>/student/profile" enctype="multipart/form-data" class="space-y-6">
                    <input type="hidden" name="action" value="uploadPhoto" />
                    <label for="photo" class="block group cursor-pointer group">
                        <div class="flex flex-col items-center gap-3 px-8 py-12 border-4 border-dashed border-slate-100 rounded-[2.5rem] group-hover:border-brand/30 group-hover:bg-brand/5 transition-all text-center bg-slate-50/50">
                            <div class="w-14 h-14 rounded-full bg-white flex items-center justify-center shadow-sm text-slate-300 group-hover:text-brand transition-colors">
                                <svg class="w-7 h-7" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="3"><path d="M21 15v4a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2v-4"/><polyline points="17 8 12 3 7 8"/><line x1="12" y1="3" x2="12" y2="15"/></svg>
                            </div>
                            <div class="mt-2">
                                <p class="text-sm font-black text-slate-700">Select Image File</p>
                                <p class="text-[0.7rem] font-bold text-slate-400 uppercase tracking-widest mt-1">PNG, JPG or WebP</p>
                            </div>
                        </div>
                        <input type="file" id="photo" name="photo" accept=".png,.jpg,.jpeg,.gif,.webp" required class="hidden" />
                    </label>
                    
                    <div id="fileNameDisplay" class="hidden px-5 py-3 rounded-xl bg-slate-50 border border-slate-100 text-center">
                        <span class="text-xs font-black text-slate-500 uppercase tracking-widest truncate block" id="fileNameText">No file chosen</span>
                    </div>

                    <button type="submit" class="w-full flex items-center justify-center gap-3 py-5 rounded-2xl bg-white border-2 border-slate-200 text-slate-700 font-black text-xs uppercase tracking-widest hover:border-brand hover:text-brand hover:bg-brand/5 transition-all">
                        Commit Photo Change
                    </button>
                </form>
            </div>
        </div>
    </div>
</div>

<script>
document.getElementById('photo').addEventListener('change', function() {
    const display = document.getElementById('fileNameDisplay');
    const text = document.getElementById('fileNameText');
    if (this.files.length > 0) {
        text.textContent = this.files[0].name;
        display.classList.remove('hidden');
    } else {
        display.classList.add('hidden');
    }
});
</script>

<%@ include file="/WEB-INF/pages/common/footer.jsp" %>
