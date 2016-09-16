package com.yinhe.service;

import com.yinhe.helper.FileHelper;
import com.yinhe.helper.SqlScriptHelper;
import org.springframework.stereotype.Service;

import java.io.File;
import java.util.List;

@Service
public class UploadService {
    public static boolean merge(int year, int month, int day) {
        boolean result = true;
        String rootDirectory = System.getProperty("web.root");
        String directory = FileHelper.path(rootDirectory, "/template/sql");

        List<File> fileList = FileHelper.getFiles(directory, "sql");

        SqlScriptHelper.year = year;
        SqlScriptHelper.month = month;
        SqlScriptHelper.day = day;

        for (File file : fileList) {
            if (file.getName().contains("数据准备")) {
                try {
                    SqlScriptHelper.excuse(file);
                } catch (Exception e) {
                    return false;
                }
            }
        }
        SqlScriptHelper.year = 0;
        SqlScriptHelper.month = 0;
        SqlScriptHelper.day = 0;

        return result;
    }
}
