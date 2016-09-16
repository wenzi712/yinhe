package com.yinhe.controller;

import com.google.gson.Gson;
import com.yinhe.service.CalculateService;
import org.apache.shiro.authz.annotation.RequiresAuthentication;
import org.apache.shiro.authz.annotation.RequiresRoles;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

@Controller
@RequestMapping(value = "/api/calculate")
public class CalculateControl {
    @Autowired
    private CalculateService calculateService;

    @RequiresRoles(value = {"root"})
    @RequestMapping(value = "display", produces = "text/json; charset=UTF-8")
    @ResponseBody
    public String display() throws Exception {
        Map<String, Object> result = new LinkedHashMap<>();
        result.put("finish", false);

        if (!CalculateService.IsRunning) {
            result.put("finish", true);
        }

        List<String> calculateResult;
        if (CalculateService.ResultList.size() > CalculateService.HasReadNumber) {
            result.put("finish", false);
            calculateResult = CalculateService.ResultList.subList(CalculateService.HasReadNumber, CalculateService.ResultList.size());
            CalculateService.HasReadNumber = CalculateService.ResultList.size();
            result.put("message", calculateResult);
        }
        return (new Gson()).toJson(result);
    }

    @RequiresRoles(value = {"root"})
    @RequestMapping(value = "excuse/{action}", produces = "text/json; charset=UTF-8")
    @ResponseBody
    public String excuse(@PathVariable String action) throws Exception {
        CalculateService.ResultList.clear();
        CalculateService.IsRunning = true;
        CalculateService.HasReadNumber = 0;

        Map<String, Object> messageMap = new HashMap<>();
        messageMap.put("success", CalculateService.calculate(action));
        CalculateService.IsRunning = false;
        return (new Gson()).toJson(messageMap);
    }

    @RequiresRoles(value = {"root"})
    @RequestMapping(value = "excuse/{action}/{year}/{month}/{day}", produces = "text/json; charset=UTF-8")
    @ResponseBody
    public String excuse(@PathVariable String action, @PathVariable int year, @PathVariable int month, @PathVariable int day) throws Exception {
        CalculateService.ResultList.clear();
        CalculateService.IsRunning = true;
        CalculateService.HasReadNumber = 0;

        Map<String, Object> messageMap = new HashMap<>();
        messageMap.put("success", CalculateService.calculate(action, year, month, day));
        CalculateService.IsRunning = false;
        return (new Gson()).toJson(messageMap);
    }

    @RequiresRoles(value = {"root"})
    @RequestMapping(value = "excuse/{action}/{year}/{month}", produces = "text/json; charset=UTF-8")
    @ResponseBody
    public String excuse(@PathVariable String action, @PathVariable int year, @PathVariable int month) throws Exception {
        CalculateService.ResultList.clear();
        CalculateService.IsRunning = true;
        CalculateService.HasReadNumber = 0;

        Map<String, Object> messageMap = new HashMap<>();
        messageMap.put("success", CalculateService.calculate(action, year, month));
        CalculateService.IsRunning = false;
        return (new Gson()).toJson(messageMap);
    }

    @RequiresRoles(value = {"root"})
    @RequestMapping(value = "initial", produces = "text/json; charset=UTF-8")
    @ResponseBody
    public String initial() throws Exception {
        Map<String, Object> messageMap = new HashMap<>();
        messageMap.put("success", CalculateService.initial());
        CalculateService.IsRunning = false;
        return (new Gson()).toJson(messageMap);
    }

    @RequiresAuthentication
    @RequiresRoles(value = {"root"})
    @RequestMapping(value = "save/{year}/{month}", produces = "text/json; charset=UTF-8")
    @ResponseBody
    public String save(@PathVariable int year, @PathVariable int month) {
        Map<String, Object> messageMap = new LinkedHashMap<>();
        if (month < 1 || month > 12) {
            messageMap.put("success", false);
            messageMap.put("message", "数据错误!");
        }
        try {
            calculateService.drop(year, month);
        } catch (Exception e) {
            e.printStackTrace();
        }
        calculateService.save(year, month);
        messageMap.put("success", true);
        return (new Gson()).toJson(messageMap);
    }
}

