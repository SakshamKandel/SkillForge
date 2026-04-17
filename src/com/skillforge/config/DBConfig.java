package com.skillforge.config;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

/// Database settings
public class DBConfig {

    private static final String URL  = "jdbc:mysql://localhost:3306/skillforge_db?useSSL=false&serverTimezone=UTC";
    private static final String USER = "root";
    private static final String PASS = "";

    public static Connection getConnection() throws SQLException {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
        } catch (ClassNotFoundException e) {
            throw new SQLException("MySQL JDBC driver not found. Place mysql-connector-j-9.6.0.jar in WEB-INF/lib.", e);
        }
        return DriverManager.getConnection(URL, USER, PASS);
    }
}
