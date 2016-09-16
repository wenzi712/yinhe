package com.yinhe.helper;

import com.yinhe.config.ConnectionManager;
import jxl.Cell;
import jxl.Sheet;
import jxl.Workbook;

import java.io.InputStream;
import java.sql.Connection;
import java.sql.Statement;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

public class ExcelHelper {
    public static int ExcelImportToDatabase(InputStream inputStream, String tableName, boolean isCreateTable) throws Exception {
        Connection connection = ConnectionManager.getConnection();
        Statement statement = connection.createStatement();
        String sql;
        if (isCreateTable) {
            sql = "IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'" + tableName + "') AND type in (N'U')) DROP TABLE " + tableName;
            statement.execute(sql);
        }

        Workbook workbook = Workbook.getWorkbook(inputStream);
        Sheet sheet[] = workbook.getSheets();
        if (sheet == null) {
            return 0;
        }
        int count = 0;
        int columns = 0;
        int processColumns = 1024;
        String reg = "[`~!@#$%^&*()+=|{}':;',\\[\\].<>/?~！@#￥%……&*（）——+|{}【】‘；：”“’。，、？‰]";
        Pattern pattern = Pattern.compile(reg);
        for (int i = 0; i < sheet.length; i++) {
            if (i == 0) {
                columns = sheet[i].getColumns();
                processColumns = processColumns / (columns / 10 + 1);
            }
            int rows = sheet[i].getRows();
            String[] cellValues = new String[columns];
            for (int j = 0; j < rows; j++) {
                for (int k = 0; k < columns; k++) {
                    Cell cell = sheet[i].getCell(k, j);
                    cellValues[k] = cell.getContents();
                }
                if (isCreateTable && i == 0 && j == 0) {
                    sql = "CREATE TABLE " + tableName + " (";
                    String cellValue;
                    for (int k = 0; k < columns; k++) {
                        cellValue = cellValues[k];
                        if (cellValue == null || cellValue.isEmpty()) {
                            columns = k;
                            break;
                        }
                        Matcher matcher = pattern.matcher(cellValue);
                        cellValue = matcher.replaceAll("").trim();
                        sql += ("["+cellValue + "] nvarchar(255),");
                    }
                    sql = sql.substring(0, sql.length() - 1) + ")";
                    statement.execute(sql);
                } else {
                    if (j >= 1) {
                        sql = "INSERT INTO " + tableName + " VALUES (";
                        for (int k = 0; k < columns; k++) {
                            sql += ("'" + cellValues[k] + "',");
                        }
                        sql = sql.substring(0, sql.length() - 1) + ")";
                        statement.addBatch(sql);
                        count++;
                    }
                }
                if (count % processColumns == 0) {
                    statement.executeBatch();
                }
            }
            statement.executeBatch();
        }
        statement.close();
        connection.close();
        inputStream.close();
        return count;
    }
}
