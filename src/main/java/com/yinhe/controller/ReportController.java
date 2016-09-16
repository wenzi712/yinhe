package com.yinhe.controller;

import com.google.gson.Gson;
import com.yinhe.model.Account;
import com.yinhe.service.ReportService;
import org.apache.shiro.SecurityUtils;
import org.apache.shiro.authz.annotation.RequiresRoles;
import org.apache.shiro.authz.annotation.RequiresUser;
import org.apache.shiro.subject.Subject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import java.util.HashMap;
import java.util.Map;

@Controller
@RequestMapping(value = "/api/report")
public class ReportController {
    @Autowired
    private ReportService reportService;

    @RequiresUser
    @RequestMapping(value = "get/{report}/{year}/{month}", produces = "text/json; charset=UTF-8")
    @ResponseBody
    public String get(@PathVariable String report, @PathVariable int year, @PathVariable int month) throws Exception {
        Subject subject = SecurityUtils.getSubject();
        Account account = (Account) subject.getPrincipal();
        Map<String, Object> parameters = new HashMap<>();

        if (subject.hasRole("super")) {
            parameters.put("Department", account.getDepartment());
        } else if (subject.hasRole("admin")) {
            parameters.put("Department", account.getDepartment());
            parameters.put("Organization", account.getOrganization());
        } else if (subject.hasRole("user")) {
            parameters.put("Department", account.getDepartment());
            parameters.put("Organization", account.getOrganization());
            parameters.put("Name", account.getName());
        }
        return (new Gson()).toJson(reportService.listAll(report, String.valueOf(year) + String.format("%02d", month), parameters));
    }

    @RequiresRoles(value = {"root"})
    @RequestMapping(value = "get/{report}", produces = "text/json; charset=UTF-8")
    @ResponseBody
    public String get(@PathVariable String report) throws Exception {
        return (new Gson()).toJson(reportService.listAll(report, null, null));
    }
}
