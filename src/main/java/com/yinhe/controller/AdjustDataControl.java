package com.yinhe.controller;

import com.google.gson.Gson;
import com.yinhe.model.Account;
import com.yinhe.model.AdjustData;
import com.yinhe.service.AdjustDataService;
import com.yinhe.service.CalculateService;
import org.apache.shiro.SecurityUtils;
import org.apache.shiro.authz.annotation.Logical;
import org.apache.shiro.authz.annotation.RequiresRoles;
import org.apache.shiro.subject.Subject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import java.util.HashMap;
import java.util.Map;

@Controller
@RequestMapping(value = "/api/data/adjust")
public class AdjustDataControl {
    @Autowired
    private AdjustDataService adjustDataService;

    @RequiresRoles(value = {"root", "super", "admin"}, logical = Logical.OR)
    @RequestMapping(value = "get", produces = "text/json; charset=UTF-8")
    @ResponseBody
    public String get() throws Exception {
        Subject subject = SecurityUtils.getSubject();
        Account account = (Account) subject.getPrincipal();
        Map<String, Object> parameters = new HashMap<>();

        if (subject.hasRole("super")) {
            parameters.put("Department", account.getDepartment());
        } else if (subject.hasRole("admin")) {
            parameters.put("Department", account.getDepartment());
            parameters.put("Organization", account.getOrganization());
        }

        return (new Gson()).toJson(adjustDataService.listAll(parameters));
    }

    @RequiresRoles(value = {"root", "super", "admin"}, logical = Logical.OR)
    @RequestMapping(value = "update", method = {RequestMethod.POST}, produces = "text/json; charset=UTF-8")
    @ResponseBody
    public String update(@RequestBody AdjustData data) throws Exception {
        Map<String, Object> messageMap = new HashMap<>();
        if (data.getPayment() + data.getAdjust() < 0) {
            messageMap.put("success", true);
        } else {
            messageMap.put("success", adjustDataService.update(data));
            CalculateService.calculate("排序", 0, 0);
        }
        return (new Gson()).toJson(messageMap);
    }
}
