package com.yinhe.controller;

import com.google.gson.Gson;
import com.yinhe.helper.DbfHelper;
import com.yinhe.helper.ExcelHelper;
import com.yinhe.service.CalculateService;
import com.yinhe.service.UploadService;
import org.apache.shiro.authz.annotation.RequiresRoles;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.io.InputStream;
import java.util.*;

@Controller
@RequestMapping(value = "/api/upload")
public class UploadController {
    @RequiresRoles(value = {"root"})
    @RequestMapping(value = "import", method = {RequestMethod.POST}, produces = "text/json; charset=UTF-8")
    @ResponseBody
    public String upload(@RequestParam("uploadFile") MultipartFile[] uploadFile) throws Exception {
        LinkedHashMap<String, Object> result = new LinkedHashMap<>();

        CalculateService.ResultList.clear();
        CalculateService.IsRunning = true;
        CalculateService.HasReadNumber = 0;

        if (uploadFile == null || uploadFile.length <= 0) {
            result.put("error", "请选择导入文件!");
            return (new Gson()).toJson(result);
        }
        for (MultipartFile file : uploadFile) {
            String fileName = file.getOriginalFilename().toLowerCase();
            if (!fileName.endsWith(".xls") && !fileName.endsWith(".dbf")) {
                result.put("error", "非法格式!");
                return (new Gson()).toJson(result);
            }
        }

        Set<String> hasCreateTable = new HashSet<>();
        for (int i = 0; i < uploadFile.length; i++) {
            String fileName = uploadFile[i].getOriginalFilename();
            String tableName = fileName.substring(0, fileName.lastIndexOf("."));
            String suffix = fileName.substring(fileName.lastIndexOf(".") + 1, fileName.length()).toLowerCase();
            if (tableName.indexOf('_') >= 0) {
                tableName = tableName.substring(0, tableName.indexOf('_'));
            }
            boolean isCreateTable = !hasCreateTable.contains(tableName);
            InputStream inputStream = uploadFile[i].getInputStream();
            try {
                switch (suffix) {
                    case "xls":
                        (new ExcelHelper()).ExcelImportToDatabase(inputStream, tableName, isCreateTable);
                        break;
                    case "dbf":
                        DbfHelper.DbfImportToDatabase(inputStream, tableName, isCreateTable);
                        break;
                }
            } catch (Exception e) {
                result.put("error", e.getMessage());
                CalculateService.IsRunning = false;
                return (new Gson()).toJson(result);
            }
            if (!hasCreateTable.contains(tableName)) {
                hasCreateTable.add(tableName);
            }
            CalculateService.ResultList.add(fileName + "--->导入完成");
            inputStream.close();
        }
        CalculateService.IsRunning = false;
        result.put("success", true);
        return (new Gson()).toJson(result);
    }

    @RequiresRoles(value = {"root"})
    @RequestMapping(value = "merge/{year}/{month}/{day}",  produces = "text/json; charset=UTF-8")
    @ResponseBody
    public String merge(@PathVariable int year, @PathVariable int month, @PathVariable int day) throws Exception {
        Map<String, Object> result = new HashMap<>();
        result.put("success", UploadService.merge(year, month, day));
        Gson gson = new Gson();
        String message = gson.toJson(result);
        return message;
    }
}

