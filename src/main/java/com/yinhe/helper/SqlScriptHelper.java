package com.yinhe.helper;

import com.yinhe.service.CalculateService;

import java.io.*;
import java.text.MessageFormat;
import java.util.ArrayList;
import java.util.Properties;

public class SqlScriptHelper {
    public static int year = 0;
    public static int month = 0;
    public static int day = 0;

    synchronized public static boolean excuse(File sqlScript) {
        final String fileName = sqlScript.getName().substring(0, 2) + ".sql";
        final String rootDirectory = System.getProperty("web.root");
        final String directory = FileHelper.path(rootDirectory, "/tmp/sql/");

        ArrayList<String> sourceString = new ArrayList<>();
        ArrayList<String> replaceString = new ArrayList<>();

        if (year >= 2000) {
            sourceString.add("__REPLACE_YEAR__");
            replaceString.add(String.valueOf(year));
        }

        if (month >= 1 && month <= 12) {
            sourceString.add("__REPLACE_MONTH__");
            replaceString.add(String.format("%02d", month));
        }

        if (day >= 1 && day <= 31) {
            sourceString.add("__REPLACE_DAY__");
            replaceString.add(String.format("%02d", day));
        }

        boolean result;
        try {
            InputStreamReader inputStreamReader = new InputStreamReader(new FileInputStream(sqlScript), "GBK");
            BufferedReader bufferedReader = new BufferedReader(inputStreamReader);
            CharArrayWriter tempStream = new CharArrayWriter();
            String line;
            while ((line = bufferedReader.readLine()) != null) {
                if (!sourceString.isEmpty() && !replaceString.isEmpty()) {
                    for (int i = 0; i < sourceString.size(); i++) {
                        line = line.replaceAll(sourceString.get(i), replaceString.get(i));
                    }
                }
                tempStream.write(line);
                tempStream.append(System.getProperty("line.separator"));
            }
            bufferedReader.close();
            String path = directory + fileName;
            File file = FileHelper.create(path);
            if (file == null) {
                return false;
            }
            Writer writer = new OutputStreamWriter(new FileOutputStream(file), "GBK");
            tempStream.writeTo(writer);
            tempStream.close();
            writer.close();

            String batPath = directory + fileName + ".bat";
            path = batPath;
            file = FileHelper.create(path);
            if (file == null) {
                return false;
            }
            writer = new OutputStreamWriter(new FileOutputStream(file), "GBK");
            Properties properties = new Properties();
            String DatabasePropertiesFile = "config/database.properties";
            ClassLoader classLoader = Thread.currentThread().getContextClassLoader();
            properties.load(classLoader.getResourceAsStream(DatabasePropertiesFile));

            String scriptPath = directory + fileName;
            String content = MessageFormat.format("sqlcmd -S {0},{1} -d {2} -U {3} -P {4} -i \"{5}\"", properties.getProperty("host"), properties.getProperty("port"), properties.getProperty("database"), properties.getProperty("username"), properties.getProperty("password"), scriptPath);
            writer.write(content);
            writer.close();

            ProcessBuilder processBuilder = new ProcessBuilder(batPath);
            processBuilder.redirectErrorStream(true);
            Process process = processBuilder.start();
            bufferedReader = new BufferedReader(new InputStreamReader(process.getInputStream()));
            tempStream = new CharArrayWriter();
            while ((line = bufferedReader.readLine()) != null) {
                if (line.isEmpty() || line.indexOf(content) >= 0) {
                    continue;
                }
                CalculateService.ResultList.add(line);
                tempStream.write(line);
                tempStream.append(System.getProperty("line.separator"));
            }
            String logPath = directory + fileName + ".log";
            writer = new OutputStreamWriter(new FileOutputStream(logPath), "GBK");
            tempStream.writeTo(writer);
            tempStream.close();
            writer.close();
            process.waitFor();
            result = (process.exitValue() == 0);
        } catch (Exception e) {
            result = false;
        }
        return result;
    }
}
