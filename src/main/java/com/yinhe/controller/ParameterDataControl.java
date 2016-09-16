package com.yinhe.controller;

import com.google.gson.Gson;
import com.yinhe.model.ParameterData;
import com.yinhe.service.ParameterDataService;
import org.apache.shiro.authz.annotation.RequiresAuthentication;
import org.apache.shiro.authz.annotation.RequiresRoles;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpServletResponse;
import javax.validation.Valid;
import java.util.HashMap;
import java.util.Map;

@Controller
@RequestMapping(value = "/api/parameter")
public class ParameterDataControl {
    @Autowired
    private ParameterDataService parameterDataService;

    @RequiresRoles(value = {"root"})
    @RequestMapping(value = "get", produces = "text/json; charset=UTF-8")
    @ResponseBody
    public String get() throws Exception {
        return (new Gson()).toJson(parameterDataService.listAll());
    }

    @RequiresRoles(value = {"root"})
    @RequestMapping(value = "update", method = {RequestMethod.POST}, produces = "text/json; charset=UTF-8")
    @ResponseBody
    public String update(@RequestBody @Valid ParameterData updateData) {
        Map<String, Object> messageMap = new HashMap<>();
        messageMap.put("success", parameterDataService.update(updateData));
        return (new Gson()).toJson(messageMap);
    }

    @RequiresRoles(value = {"root"})
    @RequestMapping(value = "exist", produces = "text/json; charset=UTF-8")
    @ResponseBody
    public String exist(@RequestParam("Name") String Name, HttpServletResponse response) {
        if (Name == null || Name.isEmpty()) {
            response.setStatus(HttpServletResponse.SC_NOT_ACCEPTABLE);
            return null;
        }
        Map<String, Object> messageMap = new HashMap<>();
        boolean result = parameterDataService.exist(Name);
        messageMap.put("exist", result);
        if (result) {
            response.setStatus(HttpServletResponse.SC_NOT_ACCEPTABLE);
        }
        return (new Gson()).toJson(messageMap);
    }

    @RequiresAuthentication
    @RequiresRoles(value = {"root"})
    @RequestMapping(value = "add", produces = "text/json; charset=UTF-8")
    @ResponseBody
    public String add(@RequestBody @Valid ParameterData data, BindingResult bindingResult, HttpServletResponse response) {
        Map<String, Object> messageMap = new HashMap<>();
        if (bindingResult.hasErrors()) {
            messageMap.put("success", false);
            messageMap.put("message", "对象不存在");
            response.setStatus(HttpServletResponse.SC_NOT_ACCEPTABLE);
            return (new Gson()).toJson(messageMap);
        }

        if (parameterDataService.exist(data.getName())) {
            messageMap.put("success", false);
            messageMap.put("message", "参数已存在");
            return (new Gson()).toJson(messageMap).toString();
        } else {
            messageMap.put("success", parameterDataService.add(data));
        }
        return (new Gson()).toJson(messageMap).toString();
    }

    @RequiresRoles(value = {"root"})
    @RequestMapping(value = "delete/{name}", method = {RequestMethod.DELETE}, produces = "text/json; charset=UTF-8")
    @ResponseBody
    public String delete(@PathVariable String name) {
        Map<String, Object> messageMap = new HashMap<>();
        if (name == null || name.isEmpty() || !parameterDataService.exist(name)) {
            messageMap.put("success", false);
            messageMap.put("message", "参数不存在");
            return (new Gson()).toJson(messageMap);
        }
        messageMap.put("success", parameterDataService.delete(name));
        return (new Gson()).toJson(messageMap);
    }
}
