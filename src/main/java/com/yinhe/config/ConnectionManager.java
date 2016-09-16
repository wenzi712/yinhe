package com.yinhe.config;

import org.springframework.stereotype.Component;

import javax.sql.DataSource;
import java.sql.Connection;
import java.sql.SQLException;

@Component
public class ConnectionManager {
    private static DataSource dataSource;

    public static Connection getConnection() throws SQLException {
        return dataSource.getConnection();
    }

    public void setDataSource(DataSource dataSource) {
        ConnectionManager.dataSource = dataSource;
    }
}