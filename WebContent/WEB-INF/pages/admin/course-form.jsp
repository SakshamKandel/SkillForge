<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.skillforge.model.Course, java.util.Map" %>
<%
    request.setAttribute("pageTitle", "Course Form");
    request.setAttribute("activePage", "courses");
%>
<%@ include file="/WEB-INF/pages/common/header.jsp" %>
<%
    Course course = (Course) request.getAttribute("course");
    boolean isEdit = (course != null);
    String error = (String) request.getAttribute("error");

    @SuppressWarnings("unchecked")
    Map<Integer, String> categories  = (Map<Integer, String>) request.getAttribute("categories");
    @SuppressWarnings("unchecked")
    Map<Integer, String> instructors = (Map<Integer, String>) request.getAttribute("instructors");
%>

<div class="panel form-panel">
    <div class="panel-head">
        <h2><%= isEdit ? "Edit Course" : "Add New Course" %></h2>
    </div>
    <div class="panel-body">

        <% if (error != null) { %>
            <div class="msg msg-error"><%= error %></div>
        <% } %>

        <form method="post" action="<%= ctx %>/admin/courses">
            <% if (isEdit) { %>
                <input type="hidden" name="id" value="<%= course.getId() %>" />
            <% } %>

            <div class="field">
                <label for="title">Course Title</label>
                <input type="text" id="title" name="title" value="<%= isEdit ? course.getTitle() : "" %>" required />
            </div>

            <div class="field-row">
                <div class="field">
                    <label for="categoryId">Category</label>
                    <select id="categoryId" name="categoryId" required>
                        <option value="">— Select Category —</option>
                        <% if (categories != null) {
                            for (Map.Entry<Integer, String> cat : categories.entrySet()) { %>
                                <option value="<%= cat.getKey() %>"
                                    <%= (isEdit && course.getCategoryId() == cat.getKey()) ? "selected" : "" %>>
                                    <%= cat.getValue() %>
                                </option>
                        <%  } } %>
                    </select>
                </div>
                <div class="field">
                    <label for="instructorId">Instructor</label>
                    <select id="instructorId" name="instructorId" required>
                        <option value="">— Select Instructor —</option>
                        <% if (instructors != null) {
                            for (Map.Entry<Integer, String> ins : instructors.entrySet()) { %>
                                <option value="<%= ins.getKey() %>"
                                    <%= (isEdit && course.getInstructorId() == ins.getKey()) ? "selected" : "" %>>
                                    <%= ins.getValue() %>
                                </option>
                        <%  } } %>
                    </select>
                </div>
            </div>

            <div class="field">
                <label for="durationWeeks">Duration (weeks)</label>
                <input type="number" id="durationWeeks" name="durationWeeks" min="1" value="<%= isEdit ? course.getDurationWeeks() : 4 %>" required />
            </div>

            <div class="field">
                <label for="description">Description</label>
                <textarea id="description" name="description"><%= isEdit ? course.getDescription() : "" %></textarea>
            </div>

            <% if (isEdit) { %>
                <div class="checkbox-field">
                    <input type="checkbox" id="active" name="active" <%= course.isActive() ? "checked" : "" %> />
                    <label for="active">Active</label>
                </div>
            <% } %>

            <div class="form-btns">
                <button type="submit" class="btn btn-teal"><%= isEdit ? "Update Course" : "Add Course" %></button>
                <a href="<%= ctx %>/admin/courses" class="btn btn-slate">Cancel</a>
            </div>
        </form>
    </div>
</div>

<%@ include file="/WEB-INF/pages/common/footer.jsp" %>
