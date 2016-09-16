package com.yinhe.service;

import com.yinhe.config.ConnectionManager;
import com.yinhe.dao.CalculateDAO;
import com.yinhe.helper.FileHelper;
import com.yinhe.helper.SqlScriptHelper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.io.File;
import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

@Service
public class CalculateService {
    private static final String[] SaveTables = {"月度考核", "crmcd", "积分参数表"};
    public static Boolean IsRunning = false;
    public static List<String> ResultList = new ArrayList<>();
    public static int HasReadNumber = 0;
    @Autowired
    private CalculateDAO calculateDAO;

    synchronized public static boolean calculate(String action) {
        return calculate(action, 0, 0, 0);
    }

    synchronized public static boolean calculate(String action, int year, int month) {
        return calculate(action, year, month, 0);
    }

    synchronized public static boolean calculate(String action, int year, int month, int day) {
        boolean result = true;
        IsRunning = true;
        HasReadNumber = 0;
        String rootDirectory = System.getProperty("web.root");
        String directory = FileHelper.path(rootDirectory, "/template/sql");

        List<File> fileList = FileHelper.getFiles(directory, "sql");

        SqlScriptHelper.year = year;
        SqlScriptHelper.month = month;
        SqlScriptHelper.day = day;

        for (File file : fileList) {
            if (file.getName().contains(action)) {
                try {
                    SqlScriptHelper.excuse(file);
                } catch (Exception e) {
                    IsRunning = false;
                    return false;
                }
            }
        }
        SqlScriptHelper.year = 0;
        SqlScriptHelper.month = 0;
        IsRunning = false;
        return result;
    }

    synchronized public static boolean initial() throws SQLException {
        boolean result = true;
        Connection connection = null;

        try {
            connection = ConnectionManager.getConnection();
            String sql = "{call 参数初始化}";
            CallableStatement callableStatement = connection.prepareCall(sql);
            result = callableStatement.executeUpdate() >= 0;
            callableStatement.close();
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        } finally {
            if (connection != null) {
                connection.close();
            }
        }
        return result;
    }

    public void save(int year, int month) {
        for (String s : SaveTables) {
            HashMap<String, String> parameters = new HashMap<>();
            parameters.put("SourceTableName", s);
            parameters.put("DestinationTableName", s + String.valueOf(year) + String.format("%02d", month));
            calculateDAO.save(parameters);
        }
    }

    public void drop(int year, int month) {
        for (String s : SaveTables) {
            calculateDAO.drop(s + String.valueOf(year) + String.format("%02d", month));
        }
    }
}
