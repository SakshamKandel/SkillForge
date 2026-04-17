package com.skillforge.model;

/**
 * JavaBean representing a row in the {@code courses} table.
 */
public class Course {

    private int     id;
    private String  title;
    private String  category;
    private String  instructor;
    private int     durationWeeks;
    private String  description;
    private boolean active;

    /* ---------- No-arg constructor ---------- */
    public Course() { }

    /* ---------- Getters & Setters ---------- */

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public String getTitle() { return title; }
    public void setTitle(String title) { this.title = title; }

    public String getCategory() { return category; }
    public void setCategory(String category) { this.category = category; }

    public String getInstructor() { return instructor; }
    public void setInstructor(String instructor) { this.instructor = instructor; }

    public int getDurationWeeks() { return durationWeeks; }
    public void setDurationWeeks(int durationWeeks) { this.durationWeeks = durationWeeks; }

    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }

    public boolean isActive() { return active; }
    public void setActive(boolean active) { this.active = active; }
}
