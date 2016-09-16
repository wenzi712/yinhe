package com.yinhe.helper;

import com.linuxense.javadbf.DBFReader;
import com.yinhe.config.ConnectionManager;

import java.io.InputStream;
import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.Statement;

public class DbfHelper {
    public static int DbfImportToDatabase(InputStream inputStream, String tableName, boolean isCreateTable) throws Exception {
        Connection connection = ConnectionManager.getConnection();
        Statement statement = connection.createStatement();
        String sql;
        if (isCreateTable) {
            sql = "IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'" + tableName + "') AND type in (N'U')) DROP TABLE " + tableName;
            statement.execute(sql);
        }

        DBFReader dbfReader = new DBFReader(inputStream);
        dbfReader.setCharactersetName("gb2312");
        int fieldCount = dbfReader.getFieldCount();
        int processColumns = 1024 / (fieldCount / 10 + 1);
        for (int j = 0; j < dbfReader.getFieldCount(); j++) {
            dbfReader.getField(j).setFieldLength(dbfReader.getField(j).getFieldLength());
        }
        int count = 0;

        if (isCreateTable) {
            sql = "CREATE TABLE " + tableName + " (";
            for (int j = 0; j < fieldCount; j++) {
                sql += (dbfReader.getField(j).getName() + " nvarchar(255),");
            }
            sql = sql.substring(0, sql.length() - 1) + ")";
            statement.execute(sql);
        }
        Object[] recordObjects;
        while ((recordObjects = dbfReader.nextRecord()) != null) {
            String[] recordValues = new String[recordObjects.length];
            sql = "INSERT INTO " + tableName + " VALUES (";
            for (int j = 0; j < fieldCount; j++) {
                Object recordValue = recordObjects[j];
                String record = new String(recordValue.toString().trim());
                if (recordValue instanceof Float || recordValue instanceof Double) {
                    record = BigDecimal.valueOf((Double) recordValue).toPlainString();
                }
                if (record.isEmpty()) {
                    recordValues[j] = "";
                }
                sql += ("'" + record + "',");
            }
            sql = sql.substring(0, sql.length() - 1) + ")";
            statement.addBatch(sql);
            count++;
            if (count % processColumns == 0) {
                statement.executeBatch();
            }
        }
        statement.executeBatch();
        statement.close();
        connection.close();
        inputStream.close();
        return count;
    }
}
