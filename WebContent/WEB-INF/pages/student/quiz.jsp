<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.skillforge.model.Quiz, com.skillforge.model.Question, java.util.List" %>
<%
    Quiz quiz = (Quiz) request.getAttribute("quiz");
    List<Question> questions = (List<Question>) request.getAttribute("questions");
%>
<%@ include file="/WEB-INF/pages/common/header.jsp" %>

<% if (quiz == null || questions == null || questions.isEmpty()) { %>
<div class="p-10">
    <div class="bg-white rounded-[3rem] p-20 text-center border-2 border-dashed border-slate-100">
        <div class="w-24 h-24 bg-slate-50 rounded-[2rem] flex items-center justify-center mx-auto mb-8 text-slate-300">
            <svg class="w-12 h-12" fill="none" stroke="currentColor" stroke-width="3" viewBox="0 0 24 24"><path d="M12 9v3.75m-9.303 3.376c-.866 1.5.217 3.374 1.948 3.374h14.71c1.73 0 2.813-1.874 1.948-3.374L13.949 3.378c-.866-1.5-3.032-1.5-3.898 0L2.697 16.126z"/><path d="M12 15.75h.007v.008H12v-.008z"/></svg>
        </div>
        <h3 class="text-2xl font-black text-slate-800 mb-3">No Quiz Available</h3>
        <p class="text-slate-400 font-bold mb-8">This course doesn't have a quiz yet, or no questions have been added.</p>
        <a href="<%= ctx %>/student/courses" class="inline-flex items-center gap-3 bg-brand text-white px-8 py-4 rounded-2xl font-black text-sm uppercase tracking-widest shadow-[0_6px_0_0_rgb(66,153,2)] hover:translate-y-[-2px] active:translate-y-[2px] active:shadow-none transition-all">
            Back to Courses
        </a>
    </div>
</div>
<% } else { %>
<div class="quiz-container">
    <!-- Quiz Mascot Coach -->
    <div class="mascot-bubble-container mt-8">
        <div class="mascot-image-wrap">
            <img src="<%= ctx %>/images/Untitled.gif" alt="Mascot" />
        </div>
        <div class="speech-bubble">
            <p>You've got this! Focus and pick the best answer for each question.</p>
        </div>
    </div>

    <!-- Duo Style Header -->
    <div class="quiz-header">
            <a href="<%= ctx %>/student/courses" class="text-slate-400 hover:text-slate-600 transition-colors">
                <svg class="w-8 h-8" fill="none" stroke="currentColor" stroke-width="3" viewBox="0 0 24 24"><path d="M15 19l-7-7 7-7"/></svg>
            </a>
            <div class="quiz-progress-outer">
                <div id="quizProgress" class="quiz-progress-inner" style="width: 0%"></div>
            </div>
            <div id="questionCounter" class="text-lg font-black text-slate-400 tabular-nums">0 / <%= questions.size() %></div>
        </div>

        <form id="quizForm" action="<%= ctx %>/student/quiz" method="post" class="space-y-12">
            <input type="hidden" name="quizId" value="<%= quiz.getId() %>" />
            <input type="hidden" name="courseId" value="<%= quiz.getCourseId() %>" />

            <% 
            int idx = 0;
            for (Question q : questions) { 
                idx++;
            %>
            <div class="question-step <%= idx == 1 ? "quiz-step-active" : "quiz-step-hidden" %>" id="step-<%= idx %>" data-step="<%= idx %>">
                <div class="question-card">
                    <h2 class="question-text"><%= q.getQuestionText() %></h2>
                    
                    <div class="options-grid">
                        <label class="option-label group cursor-pointer block relative">
                            <input type="radio" name="q<%= q.getId() %>" value="A" class="sr-only peer" required>
                            <div class="option-item flex items-center gap-4 p-4 rounded-2xl border-2 border-slate-200 transition-all pointer-events-none group-hover:bg-slate-50 peer-checked:bg-blue-50 peer-checked:border-blue-400 peer-checked:text-blue-600">
                                <span class="option-letter w-10 h-10 rounded-xl border-2 border-slate-200 flex items-center justify-center font-bold peer-checked:border-blue-400">A</span>
                                <span class="font-bold"><%= q.getOptionA() %></span>
                            </div>
                        </label>
                        <label class="option-label group cursor-pointer block relative">
                            <input type="radio" name="q<%= q.getId() %>" value="B" class="sr-only peer">
                            <div class="option-item flex items-center gap-4 p-4 rounded-2xl border-2 border-slate-200 transition-all pointer-events-none group-hover:bg-slate-50 peer-checked:bg-blue-50 peer-checked:border-blue-400 peer-checked:text-blue-600">
                                <span class="option-letter w-10 h-10 rounded-xl border-2 border-slate-200 flex items-center justify-center font-bold peer-checked:border-blue-400">B</span>
                                <span class="font-bold"><%= q.getOptionB() %></span>
                            </div>
                        </label>
                        <label class="option-label group cursor-pointer block relative">
                            <input type="radio" name="q<%= q.getId() %>" value="C" class="sr-only peer">
                            <div class="option-item flex items-center gap-4 p-4 rounded-2xl border-2 border-slate-200 transition-all pointer-events-none group-hover:bg-slate-50 peer-checked:bg-blue-50 peer-checked:border-blue-400 peer-checked:text-blue-600">
                                <span class="option-letter w-10 h-10 rounded-xl border-2 border-slate-200 flex items-center justify-center font-bold peer-checked:border-blue-400">C</span>
                                <span class="font-bold"><%= q.getOptionC() %></span>
                            </div>
                        </label>
                        <label class="option-label group cursor-pointer block relative">
                            <input type="radio" name="q<%= q.getId() %>" value="D" class="sr-only peer">
                            <div class="option-item flex items-center gap-4 p-4 rounded-2xl border-2 border-slate-200 transition-all pointer-events-none group-hover:bg-slate-50 peer-checked:bg-blue-50 peer-checked:border-blue-400 peer-checked:text-blue-600">
                                <span class="option-letter w-10 h-10 rounded-xl border-2 border-slate-200 flex items-center justify-center font-bold peer-checked:border-blue-400">D</span>
                                <span class="font-bold"><%= q.getOptionD() %></span>
                            </div>
                        </label>
                    </div>
                </div>
            </div>
            <% } %>

            <!-- Duo Style Footer Buttons -->
            <div class="quiz-footer">
                <button type="button" onclick="nextQuestion()" class="btn-duo btn-duo-green px-12 py-5 text-lg">
                    <span>Next Question</span>
                    <svg class="w-6 h-6" fill="none" stroke="currentColor" stroke-width="3" viewBox="0 0 24 24"><path d="M9 5l7 7-7 7"/></svg>
                </button>
                <button type="submit" id="submitBtn" class="btn-duo btn-duo-green px-12 py-5 text-lg hidden">
                    <span>Submit Score</span>
                </button>
            </div>
        </form>
</div>

<script>
    // Global state
    window.totalSteps = <%= questions.size() %>;
    window.currentStep = 1;

    function updateUI() {

        var percent = (window.currentStep / window.totalSteps) * 100;
        var progressInner = document.getElementById('quizProgress');
        var questionCounter = document.getElementById('questionCounter');
        var submitBtn = document.getElementById('submitBtn');
        var nextBtn = document.querySelector('button[onclick="nextQuestion()"]');

        if (progressInner) progressInner.style.width = percent + '%';
        if (questionCounter) questionCounter.innerText = window.currentStep + ' / ' + window.totalSteps;

        if (window.currentStep === window.totalSteps) {
            if (nextBtn) nextBtn.classList.add('quiz-step-hidden');
            if (submitBtn) submitBtn.classList.remove('hidden');
        } else {
            if (nextBtn) nextBtn.classList.remove('quiz-step-hidden');
            if (submitBtn) submitBtn.classList.add('hidden');
        }
    }

    window.nextQuestion = function() {

        var currentStepEl = document.getElementById("step-" + window.currentStep);
        
        if (!currentStepEl) {

            // Fallback: try attribute selector
            var fallback = document.querySelector('.question-step[data-step="' + window.currentStep + '"]');
            if (fallback) {

                processStep(fallback);
                return;
            }
            return;
        }
        processStep(currentStepEl);
    }

    function processStep(currentStepEl) {
        // Find selected radio in the current step
        var radios = currentStepEl.querySelectorAll('input[type="radio"]');
        var hasSelection = false;
        radios.forEach(function(r) { if(r.checked) hasSelection = true; });



        if (!hasSelection) {
            alert('Please select an option to move to the next question!');
            return;
        }

        // Hide current
        currentStepEl.classList.remove('quiz-step-active');
        currentStepEl.classList.add('quiz-step-hidden');

        // Increment
        window.currentStep++;
        
        // Show next
        var nextStepEl = document.getElementById("step-" + window.currentStep);
        if (nextStepEl) {
            nextStepEl.classList.remove('quiz-step-hidden');
            nextStepEl.classList.add('quiz-step-active');
            updateUI();
        } else {

            updateUI();
        }
    }

    // Initialize UI on load
    window.addEventListener('load', updateUI);
</script>
<% } %>

<%@ include file="/WEB-INF/pages/common/footer.jsp" %>

