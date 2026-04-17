package com.skillforge.util;

/**
 * Server-side input validation helpers.
 */
public class InputValidator {

    /** Letters and spaces, 2–100 characters. */
    public static boolean isValidName(String name) {
        return name != null && name.matches("^[a-zA-Z ]{2,100}$");
    }

    /** Basic e-mail regex. */
    public static boolean isValidEmail(String email) {
        return email != null && email.matches("^[\\w.+-]+@[\\w.-]+\\.[a-zA-Z]{2,}$");
    }

    /** Exactly 10 digits. */
    public static boolean isValidPhone(String phone) {
        return phone != null && phone.matches("^\\d{10}$");
    }

    /** Minimum 6 characters. */
    public static boolean isValidPassword(String pwd) {
        return pwd != null && pwd.length() >= 6;
    }

    /** Null or blank check. */
    public static boolean isBlank(String s) {
        return s == null || s.trim().isEmpty();
    }

    /** Parses as positive integer (&gt; 0). */
    public static boolean isPositiveInt(String s) {
        if (isBlank(s)) return false;
        try {
            return Integer.parseInt(s.trim()) > 0;
        } catch (NumberFormatException e) {
            return false;
        }
    }
}
