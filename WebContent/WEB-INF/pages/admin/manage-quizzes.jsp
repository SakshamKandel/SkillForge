<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.skillforge.model.Quiz, com.skillforge.model.Question, com.skillforge.model.Course, java.util.List" %>
<%
    List<Quiz> quizzes = (List<Quiz>) request.getAttribute("quizzes");
    List<Course> courses = (List<Course>) request.getAttribute("courses");
    List<Question> selectedQuestions = (List<Question>) request.getAttribute("quizQuestions");
    Integer selectedQuizId = (Integer) request.getAttribute("selectedQuizId");

    // BULLETPROOF: Never allow NPE in the view
    if (quizzes == null) quizzes = new java.util.ArrayList<>();
    if (courses == null) courses = new java.util.ArrayList<>();
    if (selectedQuestions == null) selectedQuestions = new java.util.ArrayList<>();
%>
<%@ include file="/WEB-INF/pages/common/header.jsp" %>

<div class="px-10 py-8 space-y-10">
    <div class="mascot-bubble-container">
        <div class="mascot-image-wrap">
            <img src="<%= ctx %>/images/Untitled.gif" alt="Mascot" />
        </div>
        <div class="speech-bubble">
            <h2 class="text-xl font-black text-slate-800 tracking-tight">Quiz & Challenges</h2>
            <p class="text-[0.6rem] font-black text-slate-400 uppercase tracking-widest mt-1">Design intensive challenges and certification paths here.</p>
        </div>
    </div>

    <%-- Notification Center --%>
    <% if (session.getAttribute("success") != null) { %>
        <div class="bg-brand text-white p-5 rounded-3xl shadow-[0_6px_0_0_rgba(66,153,2,1)] font-bold text-sm mb-8 animate-pulse">
            ✅ <%= session.getAttribute("success") %>
        </div>
        <% session.removeAttribute("success"); %>
    <% } %>

    <% if (session.getAttribute("error") != null) { %>
        <div class="bg-red-500 text-white p-5 rounded-3xl shadow-[0_6px_0_0_rgba(185,28,28,1)] font-bold text-sm mb-8">
            ❌ Error: <%= session.getAttribute("error") %>
        </div>
        <% session.removeAttribute("error"); %>
    <% } %>

    <div class="grid grid-cols-1 lg:grid-cols-3 gap-10">
        <!-- Left Panel: Lists and Create -->
        <div class="lg:col-span-1 space-y-8">
            <!-- Create Quiz Box -->
            <div class="bg-white rounded-[2.5rem] p-8 shadow-[0_8px_30px_rgb(0,0,0,0.04)] ring-1 ring-slate-100">
                <h3 class="text-lg font-black text-slate-800 mb-6 flex items-center gap-3">
                    <span class="w-2 h-6 bg-brand rounded-full"></span>
                    New Quiz
                </h3>
                <form action="<%= ctx %>/admin/quizzes" method="post" class="space-y-4">
                    <input type="hidden" name="action" value="createQuiz" />
                    <div class="field">
                        <label>Target Course</label>
                        <select name="courseId" required class="rounded-2xl border-2 border-slate-100 p-4 focus:ring-4 focus:ring-brand/10 transition-all w-full">
                            <% for (Course c : courses) { %>
                                <option value="<%= c.getId() %>"><%= c.getTitle() %></option>
                            <% } %>
                        </select>
                    </div>
                    <div class="field">
                        <label>Quiz Title</label>
                        <input type="text" name="title" placeholder="e.g. Master Class Finale" required class="rounded-2xl border-2 border-slate-100 p-4 w-full" />
                    </div>
                    <div class="field">
                        <label>Passing Score (%)</label>
                        <input type="number" name="passingScore" value="70" min="1" max="100" required class="rounded-2xl border-2 border-slate-100 p-4 w-full" />
                    </div>
                    <button type="submit" class="w-full bg-brand text-white font-black py-4 rounded-2xl shadow-[0_4px_0_0_rgba(66,153,2,1)] hover:translate-y-[2px] hover:shadow-none transition-all mt-4">Record Quiz</button>
                </form>
            </div>

            <!-- Existing Quizzes -->
            <div class="bg-white rounded-[2.5rem] overflow-hidden shadow-[0_8px_30px_rgb(0,0,0,0.04)] ring-1 ring-slate-100">
                <div class="p-6 border-b border-slate-50 font-black text-slate-400 uppercase tracking-widest text-xs">Active Quizzes</div>
                <div class="divide-y divide-slate-50">
                    <% if (quizzes != null && !quizzes.isEmpty()) {
                        for (Quiz q : quizzes) { %>
                        <div class="group/item flex items-center p-6 hover:bg-slate-50 transition-all border-r-4 <%= (selectedQuizId != null && selectedQuizId == q.getId()) ? "bg-brand/5 border-brand" : "border-transparent" %>">
                            <a href="<%= ctx %>/admin/quizzes?quizId=<%= q.getId() %>" class="flex-1">
                                <div class="font-black text-slate-800"><%= q.getTitle() %></div>
                                <div class="text-[0.65rem] font-bold text-slate-400 uppercase mt-1">Passing: <%= q.getPassingScore() %>%</div>
                            </a>
                            <div class="flex items-center gap-2">
                                <button onclick="event.preventDefault(); event.stopPropagation(); confirmDeleteQuiz(<%= q.getId() %>, '<%= q.getTitle().replace("'", "\\'") %>')" 
                                        class="p-2 rounded-lg text-slate-300 hover:text-red-500 hover:bg-red-50 transition-all opacity-0 group-hover/item:opacity-100">
                                    <svg class="w-5 h-5" fill="none" stroke="currentColor" stroke-width="2.5" viewBox="0 0 24 24"><path d="M19 7l-.867 12.142A2 2 0 0116.138 21H7.862a2 2 0 01-1.995-1.858L5 7m5 4v6m4-6v6m1-10V4a1 1 0 00-1-1h-4a1 1 0 00-1 1v3M4 7h16"/></svg>
                                </button>
                                <svg class="w-5 h-5 text-slate-200" fill="none" stroke="currentColor" stroke-width="3" viewBox="0 0 24 24"><path d="M9 5l7 7-7 7"/></svg>
                            </div>
                        </div>
                    <% } } else { %>
                        <div class="p-10 text-center text-slate-300 font-bold italic">No quizzes created yet.</div>
                    <% } %>
                </div>
            </div>
        </div>

        <!-- Right Panel: Questions Management -->
        <div class="lg:col-span-2">
            <% if (selectedQuizId != null) { %>
                <div class="space-y-8">
                    <div class="bg-white rounded-[2.5rem] p-10 shadow-[0_12px_40px_rgba(0,0,0,0.06)] ring-1 ring-slate-100">
                        <h3 class="text-2xl font-black text-slate-800 mb-8">Add Interactive Question</h3>
                        <form action="<%= ctx %>/admin/quizzes" method="post" class="space-y-6">
                            <input type="hidden" name="action" value="addQuestion" />
                            <input type="hidden" name="quizId" value="<%= selectedQuizId %>" />
                            
                            <div class="field">
                                <label>Question Prompt</label>
                                <textarea name="questionText" required placeholder="What is the output of...?" class="rounded-2xl border-2 border-slate-100 p-4 w-full h-32"></textarea>
                            </div>

                            <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
                                <div class="field">
                                    <label class="flex items-center gap-2"><span class="w-6 h-6 rounded bg-slate-100 flex items-center justify-center text-[0.6rem] font-bold">A</span> Option A</label>
                                    <input type="text" name="optionA" required class="rounded-2xl border-2 border-slate-100 p-4 w-full" />
                                </div>
                                <div class="field">
                                    <label class="flex items-center gap-2"><span class="w-6 h-6 rounded bg-slate-100 flex items-center justify-center text-[0.6rem] font-bold">B</span> Option B</label>
                                    <input type="text" name="optionB" required class="rounded-2xl border-2 border-slate-100 p-4 w-full" />
                                </div>
                                <div class="field">
                                    <label class="flex items-center gap-2"><span class="w-6 h-6 rounded bg-slate-100 flex items-center justify-center text-[0.6rem] font-bold">C</span> Option C</label>
                                    <input type="text" name="optionC" required class="rounded-2xl border-2 border-slate-100 p-4 w-full" />
                                </div>
                                <div class="field">
                                    <label class="flex items-center gap-2"><span class="w-6 h-6 rounded bg-slate-100 flex items-center justify-center text-[0.6rem] font-bold">D</span> Option D</label>
                                    <input type="text" name="optionD" required class="rounded-2xl border-2 border-slate-100 p-4 w-full" />
                                </div>
                            </div>

                            <div class="field">
                                <label>Select Correct Answer</label>
                                <div class="grid grid-cols-4 gap-4">
                                    <% for(String opt : new String[]{"A", "B", "C", "D"}) { %>
                                        <label class="cursor-pointer">
                                            <input type="radio" name="correctOption" value="<%= opt %>" <%= "A".equals(opt) ? "checked" : "" %> class="peer hidden" />
                                            <div class="text-center p-4 rounded-xl border-2 border-slate-100 font-black text-slate-400 peer-checked:border-brand peer-checked:bg-brand/5 peer-checked:text-brand transition-all">
                                                <%= opt %>
                                            </div>
                                        </label>
                                    <% } %>
                                </div>
                            </div>

                            <button type="submit" class="w-full bg-slate-800 text-white font-black py-4 rounded-2xl shadow-[0_4px_0_0_rgb(30,41,59)] hover:translate-y-[2px] transition-all">Publish Question</button>
                        </form>
                    </div>

                    <% if (selectedQuestions != null && !selectedQuestions.isEmpty()) { %>
                        <div class="space-y-4">
                            <h4 class="text-xs font-black text-slate-400 uppercase tracking-widest px-4">Question Queue (<%= selectedQuestions.size() %>)</h4>
                            <% for (Question question : selectedQuestions) { %>
                                <div class="bg-white p-6 rounded-3xl shadow-sm ring-1 ring-slate-100 group">
                                    <p class="font-bold text-slate-800"><%= question.getQuestionText() %></p>
                                    <div class="grid grid-cols-2 gap-4 mt-4">
                                        <% 
                                            String[] optLabels = {"A", "B", "C", "D"};
                                            String[] optValues = {question.getOptionA(), question.getOptionB(), question.getOptionC(), question.getOptionD()};
                                            for (int oi = 0; oi < 4; oi++) {
                                                boolean isCorrect = optLabels[oi].charAt(0) == question.getCorrectOption();
                                        %>
                                            <div class="text-xs font-bold p-3 rounded-xl <%= isCorrect ? "bg-brand/10 text-brand ring-1 ring-brand/20" : "bg-slate-50 text-slate-500" %>">
                                                <span class="opacity-50"><%= optLabels[oi] %>:</span> <%= optValues[oi] %>
                                            </div>
                                        <% } %>
                                    </div>
                                </div>
                            <% } %>
                        </div>
                    <% } %>
                </div>
            <% } else { %>
                <div class="h-full min-h-[400px] border-4 border-dashed border-slate-100 rounded-[2.5rem] flex flex-col items-center justify-center text-center p-10">
                    <div class="w-32 h-32 bg-slate-50 rounded-full flex items-center justify-center mb-6">
                        <svg class="w-16 h-16 text-slate-200" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24"><path d="M12 6.253v13m0-13C10.832 5.477 9.246 5 7.5 5S4.168 5.477 3 6.253v13C4.168 18.477 5.754 18 7.5 18s3.332.477 4.5 1.253m0-13C13.168 5.477 14.754 5 16.5 5S19.832 5.477 21 6.253v13C19.832 18.477 18.246 18 16.5 18c-1.746 0-3.332.477-4.5 1.253"/></svg>
                    </div>
                    <h3 class="text-xl font-bold text-slate-400">Select a quiz to manage its challenges</h3>
                    <p class="text-sm text-slate-300 mt-2 max-w-xs">New questions will be added to the live instance immediately.</p>
                </div>
            <% } %>
        </div>
    </div>
</div>

<%-- Deletion Modal --%>
<div id="cocModal" class="hidden fixed inset-0 z-[100] flex items-center justify-center p-6 bg-slate-900/40 backdrop-blur-sm animate-in fade-in duration-300">
    <div class="bg-white rounded-[3rem] w-full max-w-md overflow-hidden shadow-2xl scale-in-center">
        <div class="p-10 text-center">
            <div class="w-24 h-24 bg-red-50 rounded-full flex items-center justify-center mx-auto mb-8 animate-pulse">
                <svg class="w-12 h-12 text-red-500" fill="none" stroke="currentColor" stroke-width="2.5" viewBox="0 0 24 24"><path d="M19 7l-.867 12.142A2 2 0 0116.138 21H7.862a2 2 0 01-1.995-1.858L5 7m5 4v6m4-6v6m1-10V4a1 1 0 00-1-1h-4a1 1 0 00-1 1v3M4 7h16"/></svg>
            </div>
            <h3 class="text-3xl font-black text-slate-800 mb-4 tracking-tight">Nuclear Wipe?</h3>
            <p class="text-slate-500 font-bold mb-10 leading-relaxed">This will permanently delete <span id="targetQuizTitle" class="text-red-500 underline decoration-red-200">the quiz</span> and all associated results. Action cannot be undone.</p>
            <div class="flex flex-col gap-3">
                <button onclick="triggerNuclearWipe()" id="confirmBtn" class="bg-red-500 text-white font-black py-5 rounded-3xl shadow-[0_6px_0_0_rgba(185,28,28,1)] active:shadow-none active:translate-y-1 transition-all">Yes, Erase Everything</button>
                <button onclick="hideCocModal()" class="text-slate-400 font-bold py-4 hover:text-slate-600 transition-colors">Wait, cancel that</button>
            </div>
        </div>
    </div>
</div>

<script>
    let pendingQuizId = null;

    function confirmDeleteQuiz(quizId, title) {
        pendingQuizId = quizId;
        document.getElementById('targetQuizTitle').innerText = title;
        document.getElementById('cocModal').classList.remove('hidden');
    }

    function hideCocModal() {
        document.getElementById('cocModal').classList.add('hidden');
        pendingQuizId = null;
    }

    function triggerNuclearWipe() {
        if (pendingQuizId) {
            window.location.href = '<%= ctx %>/admin/quizzes?action=deleteQuiz&quizId=' + pendingQuizId + '&t=' + Date.now();
        }
    }
</script>

<style>
    .scale-in-center { animation: scale-in-center 0.4s cubic-bezier(0.250, 0.460, 0.450, 0.940) both; }
    @keyframes scale-in-center { 0% { transform: scale(0); opacity: 1; } 100% { transform: scale(1); opacity: 1; } }
</style>

<%@ include file="/WEB-INF/pages/common/footer.jsp" %>
