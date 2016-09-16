package com.yinhe.controller;

import com.google.gson.Gson;
import com.yinhe.model.ImportData;
import com.yinhe.service.ImportDataService;
import org.apache.shiro.authz.annotation.RequiresRoles;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import java.util.HashMap;
import java.util.Map;

@Controller
@RequestMapping(value = "/api/data")
public class ImportDataControl {
    @Autowired
    private ImportDataService importDataService;

    @RequiresRoles(value = {"root"})
    @RequestMapping(value = "get", produces = "text/json; charset=UTF-8")
    @ResponseBody
    public String get() throws Exception {
        return (new Gson()).toJson(importDataService.listAll());
    }

    @RequiresRoles(value = {"root"})
    @RequestMapping(value = "update", method = {RequestMethod.POST}, produces = "text/json; charset=UTF-8")
    @ResponseBody
    public String update(@RequestBody ImportData updateData) throws Exception {
        Map<String, Object> messageMap = new HashMap<>();
        messageMap.put("success", importDataService.update(updateData));
        return (new Gson()).toJson(messageMap);
    }
}
