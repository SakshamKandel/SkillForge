<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.skillforge.model.Enrollment, com.skillforge.model.Course, com.skillforge.model.Quiz, com.skillforge.model.QuizAttempt, java.util.List, java.util.Map" %>
<%
    request.setAttribute("pageTitle", "My Courses");
    request.setAttribute("activePage", "mycourses");
%>
<%@ include file="/WEB-INF/pages/common/header.jsp" %>
<%
    List<Enrollment> myEnrollments   = (List<Enrollment>) request.getAttribute("myEnrollments");
    List<Course>     availableCourses = (List<Course>) request.getAttribute("availableCourses");
    Map<Integer, Quiz>        quizByCourse        = (Map<Integer, Quiz>) request.getAttribute("quizByCourse");
    Map<Integer, QuizAttempt> lastAttemptByCourse = (Map<Integer, QuizAttempt>) request.getAttribute("lastAttemptByCourse");
    String searchVal = (request.getAttribute("search") != null) ? (String) request.getAttribute("search") : "";
%>

<!-- ===== Content ===== -->
<div class="p-10 space-y-12">
    <!-- My Enrolled Courses Section -->
    <section>
        <div class="flex items-center gap-6 mb-8">
            <img src="<%= ctx %>/images/Book reading.png" alt="Mascot" class="w-24 h-24 object-contain" />
            <div>
                <h2 class="text-3xl font-black text-slate-800 tracking-tight">Your Learning Path</h2>
                <p class="text-[0.7rem] font-black text-slate-400 uppercase tracking-widest mt-2">Resume where you left off</p>
            </div>
            <div class="ml-auto">
                <span class="px-5 py-2 rounded-2xl bg-brand/10 text-brand text-xs font-black uppercase tracking-widest">
                    <%= (myEnrollments != null) ? myEnrollments.size() : 0 %> active courses
                </span>
            </div>
        </div>

        <% if (myEnrollments != null && !myEnrollments.isEmpty()) { %>
        <div class="bg-white rounded-[2.5rem] overflow-hidden shadow-[0_8px_30px_rgb(0,0,0,0.04)] ring-1 ring-slate-100">
            <table class="w-full text-left border-collapse">
                <thead>
                    <tr class="bg-slate-50/50">
                        <th class="px-10 py-6 text-[0.7rem] font-black text-slate-400 uppercase tracking-widest">Course Title</th>
                        <th class="px-10 py-6 text-[0.7rem] font-black text-slate-400 uppercase tracking-widest">Progress</th>
                        <th class="px-10 py-6 text-[0.7rem] font-black text-slate-400 uppercase tracking-widest text-right">State</th>
                    </tr>
                </thead>
                <tbody class="divide-y divide-slate-50">
                    <% for (Enrollment en : myEnrollments) { %>
                    <tr class="group hover:bg-slate-50/30 transition-colors">
                        <td class="px-10 py-8">
                            <div class="font-black text-slate-800 text-lg leading-tight">
                                <%= en.getCourseTitle() %>
                                <% if (!en.isCourseActive()) { %>
                                    <span class="ml-2 inline-flex items-center px-2 py-0.5 rounded text-[0.65rem] font-bold bg-red-100 text-red-800 uppercase tracking-wider align-middle">Retired</span>
                                <% } %>
                            </div>
                            <div class="text-slate-400 text-xs font-bold mt-1 uppercase tracking-wide">By <%= en.getInstructor() %></div>
                        </td>
                        <td class="px-10 py-8 w-[400px]">
                            <div class="flex items-center gap-5">
                                <div class="flex-1 h-3.5 bg-slate-100 rounded-full overflow-hidden p-[2px]">
                                    <div class="h-full rounded-full transition-all duration-1000 ease-out <%= en.getProgress() >= 100 ? "bg-amber-400" : "bg-brand" %> shadow-sm" 
                                         style="width:<%= en.getProgress() %>%"></div>
                                </div>
                                <span class="text-sm font-black text-slate-500 tabular-nums"><%= en.getProgress() %>%</span>
                            </div>
                        </td>
                        <td class="px-10 py-8 text-right">
                            <div class="flex items-center justify-end gap-4">
                                <%
                                   Quiz q = (quizByCourse != null) ? quizByCourse.get(en.getCourseId()) : null;
                                   QuizAttempt lastAttempt = (lastAttemptByCourse != null) ? lastAttemptByCourse.get(en.getCourseId()) : null;

                                   if (q != null) {
                                       if (lastAttempt != null && lastAttempt.isPassed()) {
                                %>
                                    <a href="<%= ctx %>/student/certification?attemptId=<%= lastAttempt.getId() %>" 
                                       class="btn-duo btn-duo-blue btn-sm shadow-[0_3px_0_#1899D6] hover:translate-y-[-1px] active:translate-y-[2px] active:shadow-none">
                                        View Certificate
                                    </a>
                                <%     } else if (en.getProgress() >= 100) { %>
                                    <a href="<%= ctx %>/student/quiz?courseId=<%= en.getCourseId() %>" 
                                       class="btn-duo btn-duo-green btn-sm shadow-[0_3px_0_var(--duo-green-dark)] hover:translate-y-[-1px] active:translate-y-[2px] active:shadow-none">
                                        Take Quiz
                                    </a>
                                <%     } else { %>
                                    <span class="text-[0.6rem] font-black text-slate-300 uppercase tracking-widest bg-slate-50 px-3 py-2 rounded-lg border border-slate-100">
                                        Complete course for Quiz
                                    </span>
                                <%     } 
                                   } %>

                                <form method="post" action="<%= ctx %>/student/courses" class="flex items-center gap-2">
                                    <input type="hidden" name="enrollmentId" value="<%= en.getId() %>" />
                                    <input type="number" name="progress" min="0" max="100" value="<%= en.getProgress() %>" 
                                           class="w-16 px-3 py-2 rounded-xl bg-slate-50 border border-slate-100 text-sm font-black focus:ring-4 focus:ring-brand/10 focus:border-brand transition-all outline-none" />
                                    <button type="submit" class="p-2.5 bg-slate-50 rounded-xl text-slate-400 hover:text-brand hover:bg-brand/10 transition-all shadow-sm">
                                        <svg class="w-5 h-5" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="3" stroke-linecap="round" stroke-linejoin="round"><polyline points="20 6 9 17 4 12"/></svg>
                                    </button>
                                </form>
                                <a href="<%= ctx %>/student/courses?action=drop&enrollmentId=<%= en.getId() %>" 
                                   onclick="return confirm('Drop this course?')"
                                   class="p-2.5 text-slate-200 hover:text-red-500 hover:bg-red-50 rounded-xl transition-all">
                                    <svg class="w-5 h-5" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="3" stroke-linecap="round" stroke-linejoin="round"><path d="M3 6h18M19 6v14a2 2 0 0 1-2 2H7a2 2 0 0 1-2-2V6m3 0V4a2 2 0 0 1 2-2h4a2 2 0 0 1 2 2v2"/></svg>
                                </a>
                            </div>
                        </td>
                    </tr>
                    <% } %>
                </tbody>
            </table>
        </div>
        <% } else { %>
        <div class="bg-white rounded-[3rem] p-20 text-center border-2 border-dashed border-slate-100">
            <div class="relative w-56 h-56 mx-auto mb-10">
                <img class="w-full h-full object-contain" src="<%= ctx %>/images/Learning.png" alt="Mascot" />
            </div>
            <h3 class="text-3xl font-black text-slate-800 mb-4">Your journey awaits!</h3>
            <p class="text-slate-400 font-bold mb-10 max-w-sm mx-auto text-base leading-relaxed">It looks like you haven't started any courses yet. Pick a topic and let's get growing!</p>
            <a href="#browse" class="inline-flex items-center gap-4 bg-brand text-white px-10 py-5 rounded-[2rem] font-black text-sm uppercase tracking-widest shadow-[0_6px_0_0_rgb(66,153,2)] hover:translate-y-[-2px] active:translate-y-[2px] active:shadow-none transition-all">
                Browse Courses
                <svg class="w-5 h-5" fill="none" stroke="currentColor" stroke-width="3" viewBox="0 0 24 24"><path d="M7 13l5 5 5-5M12 6v12"/></svg>
            </a>
        </div>
        <% } %>
    </section>

    <!-- Available Courses Section -->
    <section id="browse" class="pt-10 scroll-mt-24">
        <div class="flex items-center gap-6 mb-10">
            <img src="<%= ctx %>/images/Learning.png" alt="Mascot" class="w-24 h-24 object-contain" />
            <div>
                <h2 class="text-3xl font-black text-slate-800 tracking-tight">Expand Your Skills</h2>
                <p class="text-[0.7rem] font-black text-slate-400 uppercase tracking-widest mt-2">Personalized course recommendations</p>
            </div>
            <div class="ml-auto">
                <form action="<%= ctx %>/student/courses" method="get" class="relative group">
                    <input type="text" name="search" placeholder="Search keywords..." value="<%= searchVal %>"
                           class="w-80 bg-white border border-slate-100 rounded-3xl px-8 py-5 pl-14 text-[0.95rem] font-black text-slate-700 shadow-sm focus:ring-8 focus:ring-brand/5 focus:border-brand transition-all outline-none" />
                    <svg class="absolute left-5 top-1/2 -translate-y-1/2 w-6 h-6 text-slate-300 group-focus-within:text-brand transition-colors" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="3" stroke-linecap="round" stroke-linejoin="round">
                        <circle cx="11" cy="11" r="8"/><line x1="21" y1="21" x2="16.65" y2="16.65"/>
                    </svg>
                </form>
            </div>
        </div>

        <% if (!searchVal.isEmpty()) { %>
            <div class="mb-8 flex items-center gap-4">
                <span class="px-5 py-2.5 rounded-2xl bg-amber-50 text-amber-700 text-sm font-black">
                    Results for "<%= searchVal %>"
                </span>
                <a href="<%= ctx %>/student/courses" class="text-xs font-black text-slate-400 hover:text-red-500 uppercase tracking-widest underline underline-offset-8 decoration-2 decoration-slate-200">Reset View</a>
            </div>
        <% } %>

        <% if (availableCourses != null && !availableCourses.isEmpty()) { %>
        <div class="grid grid-cols-1 md:grid-cols-2 xl:grid-cols-3 gap-10">
            <% for (Course co : availableCourses) { %>
            <div class="group bg-white rounded-[3rem] border border-slate-100 p-4 shadow-sm hover:shadow-[0_30px_60px_rgb(0,0,0,0.12)] hover:translate-y-[-10px] transition-all duration-700">
                <div class="aspect-video rounded-[2.25rem] mb-8 overflow-hidden bg-slate-50 relative">
                    <div class="absolute inset-0 bg-gradient-to-t from-slate-900/10 to-transparent z-10 opacity-0 group-hover:opacity-100 transition-opacity duration-500"></div>
                    <img src="https://images.unsplash.com/photo-1522202176988-66273c2fd55f?q=80&w=800&auto=format&fit=crop" 
                         class="w-full h-full object-cover grayscale-[0.1] group-hover:grayscale-0 group-hover:scale-110 transition-all duration-1000 ease-out" alt="Course" />
                    <div class="absolute top-6 left-6 z-20">
                        <span class="px-5 py-2.5 rounded-2xl bg-white/95 backdrop-blur-md text-[0.7rem] font-black uppercase tracking-widest text-slate-800 shadow-sm border border-slate-100">
                            <%= co.getCategoryName() %>
                        </span>
                    </div>
                </div>
                
                <div class="px-6 pb-6">
                    <h3 class="text-2xl font-black text-slate-800 mb-3 leading-tight group-hover:text-brand transition-colors"><%= co.getTitle() %></h3>
                    <div class="flex items-center gap-2 mb-8">
                        <div class="w-6 h-6 rounded-full bg-slate-100 flex items-center justify-center">
                            <svg class="w-3.5 h-3.5 text-slate-400" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="3" stroke-linecap="round" stroke-linejoin="round"><circle cx="12" cy="8" r="5"/><path d="M20 21a8 8 0 0 0-16 0"/></svg>
                        </div>
                        <span class="text-sm font-bold text-slate-400">By <span class="text-slate-900 group-hover:text-brand transition-colors"><%= co.getInstructorName() %></span></span>
                    </div>
                    
                    <div class="flex items-center justify-between pt-6 border-t border-slate-50">
                        <div class="flex items-center gap-3">
                            <span class="text-[0.7rem] font-black text-slate-400 uppercase tracking-widest"><%= co.getDurationWeeks() %> Weeks</span>
                        </div>
                        
                        <a href="<%= ctx %>/student/courses?action=enroll&courseId=<%= co.getId() %>"
                           class="inline-flex items-center gap-3 bg-slate-900 text-white px-8 py-4 rounded-2xl font-black text-sm shadow-xl shadow-slate-900/10 hover:bg-brand hover:shadow-brand/20 transition-all">
                            Enroll
                            <svg class="w-4 h-4 group-hover:translate-x-1 transition-transform" fill="none" stroke="currentColor" stroke-width="3" viewBox="0 0 24 24"><path d="M5 12h14M12 5l7 7-7 7"/></svg>
                        </a>
                    </div>
                </div>
            </div>
            <% } %>
        </div>
        <% } else { %>
        <div class="bg-white rounded-[3rem] p-24 text-center border-2 border-dashed border-slate-100">
            <div class="w-24 h-24 bg-slate-50 rounded-[2rem] flex items-center justify-center mx-auto mb-8 text-slate-300">
                <svg class="w-12 h-12" fill="none" stroke="currentColor" stroke-width="3" viewBox="0 0 24 24"><circle cx="11" cy="11" r="8"/><path d="m21 21-4.3-4.3"/></svg>
            </div>
            <h3 class="text-2xl font-black text-slate-800 mb-3">No results found</h3>
            <p class="text-slate-400 font-bold mb-8">We couldn't find any courses matching your search keyword.</p>
            <a href="<%= ctx %>/student/courses" class="text-brand font-black text-sm uppercase tracking-widest underline underline-offset-[12px] decoration-4 decoration-current">View All Catalog</a>
        </div>
        <% } %>
    </section>
</div>

<%@ include file="/WEB-INF/pages/common/footer.jsp" %>
