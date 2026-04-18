package com.skillforge.model;

/**
 * JavaBean representing a row in the {@code courses} table.
 * Uses FK references to categories and instructors (3NF).
 */
public class Course {

    private int     id;
    private String  title;
    private int     categoryId;
    private int     instructorId;
    private int     durationWeeks;
    private String  description;
    private boolean active;

    /* Joined display fields (populated via JOIN queries) */
    private String  categoryName;
    private String  instructorName;

    /* ---------- No-arg constructor ---------- */
    public Course() { }

    /* ---------- Getters & Setters ---------- */

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public String getTitle() { return title; }
    public void setTitle(String title) { this.title = title; }

    public int getCategoryId() { return categoryId; }
    public void setCategoryId(int categoryId) { this.categoryId = categoryId; }

    public int getInstructorId() { return instructorId; }
    public void setInstructorId(int instructorId) { this.instructorId = instructorId; }

    public int getDurationWeeks() { return durationWeeks; }
    public void setDurationWeeks(int durationWeeks) { this.durationWeeks = durationWeeks; }

    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }

    public boolean isActive() { return active; }
    public void setActive(boolean active) { this.active = active; }

    /* Joined fields */
    public String getCategoryName() { return categoryName; }
    public void setCategoryName(String categoryName) { this.categoryName = categoryName; }

    public String getInstructorName() { return instructorName; }
    public void setInstructorName(String instructorName) { this.instructorName = instructorName; }
}
