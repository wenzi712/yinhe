package com.yinhe.controller;

import com.alibaba.fastjson.JSONObject;
import com.google.gson.Gson;
import com.yinhe.config.Parameter;
import com.yinhe.helper.PasswordHelper;
import com.yinhe.helper.RSAHelper;
import com.yinhe.model.Account;
import com.yinhe.service.AccountService;
import com.yinhe.service.AuthorityService;
import org.apache.shiro.SecurityUtils;
import org.apache.shiro.authc.AuthenticationException;
import org.apache.shiro.authc.ExcessiveAttemptsException;
import org.apache.shiro.authc.UnknownAccountException;
import org.apache.shiro.authc.UsernamePasswordToken;
import org.apache.shiro.authz.annotation.RequiresAuthentication;
import org.apache.shiro.authz.annotation.RequiresRoles;
import org.apache.shiro.web.util.WebUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.*;

import javax.crypto.BadPaddingException;
import javax.crypto.IllegalBlockSizeException;
import javax.crypto.NoSuchPaddingException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.validation.Valid;
import java.io.IOException;
import java.security.InvalidKeyException;
import java.security.NoSuchAlgorithmException;
import java.util.HashMap;
import java.util.Map;

@Controller
@RequestMapping(value = "/api/account")
public class AccountControl {
    @Autowired
    private AccountService accountService;
    @Autowired
    private AuthorityService authorityService;

    @RequestMapping(value = "login", produces = "text/json; charset=UTF-8")
    @ResponseBody
    public String login(@Valid @RequestBody Account account, @RequestParam("RememberMe") boolean RememberMe, BindingResult bindingResult, HttpServletRequest request) {
        Map<String, Object> messageMap = new HashMap<>();
        if (bindingResult.hasErrors()) {
            messageMap.put("success", false);
            messageMap.put("message", "非法操作。");
            return (new Gson()).toJson(messageMap);
        }
        if (account.getLoginID() == "admin") {
            RememberMe = false;
        }
        try {
            String password = RSAHelper.DecryptString(Parameter.PRIVATE_KEY, account.getPassword());
            if (!password.contains("#")) {
                messageMap.put("success", false);
                messageMap.put("message", "非法操作。");
                return (new Gson()).toJson(messageMap);
            }
            password = password.substring(0, password.lastIndexOf('#'));
            account.setPassword(password);
        } catch (Exception e) {
            messageMap.put("success", false);
            messageMap.put("message", "非法操作。");
            return (new Gson()).toJson(messageMap);
        }

        UsernamePasswordToken token = new UsernamePasswordToken(account.getLoginID(), account.getPassword());
        token.setRememberMe(RememberMe);
        try {
            SecurityUtils.getSubject().login(token);
            messageMap.put("success", true);
            messageMap.put("url", WebUtils.getSavedRequest(request).getRequestUrl());
        } catch (UnknownAccountException e) {
            messageMap.put("success", false);
            messageMap.put("message", "该帐户不存在。请输入其他帐户。");
        } catch (ExcessiveAttemptsException e) {
            messageMap.put("success", false);
            messageMap.put("message", "用户被锁定");
            token.clear();
        } catch (AuthenticationException e) {
            messageMap.put("success", false);
            messageMap.put("message", "请确保使用与帐户对应的密码。");
            token.clear();
        }
        return (new Gson()).toJson(messageMap);
    }

    @RequiresAuthentication
    @RequestMapping(value = "password/change", produces = "text/json; charset=UTF-8")
    @ResponseBody
    public String changePassword(@RequestBody JSONObject jsonObject) throws NoSuchPaddingException, NoSuchAlgorithmException, IllegalBlockSizeException, BadPaddingException, InvalidKeyException, IOException {
        String OldPassword = jsonObject.getString("OldPassword");
        String NewPassword = jsonObject.getString("NewPassword");
        Map<String, Object> messageMap = new HashMap<>();
        Account account = (Account) SecurityUtils.getSubject().getPrincipal();
        OldPassword = RSAHelper.DecryptString(Parameter.PRIVATE_KEY, OldPassword);
        if (!OldPassword.contains("#")) {
            messageMap.put("success", false);
            messageMap.put("message", "非法操作。");
            return (new Gson()).toJson(messageMap);
        }
        OldPassword = OldPassword.substring(0, OldPassword.lastIndexOf('#'));
        OldPassword = PasswordHelper.EncryptPassword(OldPassword, account.getName());
        if (!OldPassword.equalsIgnoreCase(account.getPassword())) {
            messageMap.put("success", false);
            messageMap.put("message", "原密码错误。");
            return (new Gson()).toJson(messageMap);
        }
        NewPassword = RSAHelper.DecryptString(Parameter.PRIVATE_KEY, NewPassword);
        if (!NewPassword.contains("#")) {
            messageMap.put("success", false);
            messageMap.put("message", "非法操作。");
            return (new Gson()).toJson(messageMap);
        }
        NewPassword = NewPassword.substring(0, NewPassword.lastIndexOf('#'));
        account.setPassword(NewPassword);
        PasswordHelper.EncryptPassword(account);
        messageMap.put("success", false);
        if (accountService.update(account)) {
            messageMap.put("success", true);
        }
        return (new Gson()).toJson(messageMap);
    }

    @RequestMapping(value = "/manage/get", produces = "text/json; charset=UTF-8")
    @ResponseBody
    public String get() throws Exception {
        return (new Gson()).toJson(accountService.listAll());
    }

    @RequiresAuthentication
    @RequestMapping(value = "/manage/update", method = {RequestMethod.POST}, produces = "text/json; charset=UTF-8")
    @ResponseBody
    public String update(@RequestBody Account account) throws NoSuchPaddingException, NoSuchAlgorithmException, IllegalBlockSizeException, BadPaddingException, InvalidKeyException, IOException {
        Map<String, Object> messageMap = new HashMap<>();
        if (account.getPassword() != null && !account.getPassword().isEmpty()) {
            String password = RSAHelper.DecryptString(Parameter.PRIVATE_KEY, account.getPassword());
            if (!password.contains("#")) {
                messageMap.put("success", false);
                messageMap.put("message", "非法操作。");
                return (new Gson()).toJson(messageMap);
            }
            password = password.substring(0, password.lastIndexOf('#'));
            account.setPassword(password);
            PasswordHelper.EncryptPassword(account);
        }
        messageMap.put("success", accountService.update(account));
        return (new Gson()).toJson(messageMap);
    }

    @RequiresAuthentication
    @RequestMapping(value = "/manage/exist", produces = "text/json; charset=UTF-8")
    @ResponseBody
    public String exist(@RequestParam("LoginID") String LoginID, HttpServletResponse response) {
        Map<String, Object> messageMap = new HashMap<>();
        if (LoginID == null || LoginID.isEmpty()) {
            response.setStatus(HttpServletResponse.SC_NOT_ACCEPTABLE);
            return null;
        }
        boolean result = accountService.exist(LoginID);
        messageMap.put("exist", result);
        if (result) {
            response.setStatus(HttpServletResponse.SC_NOT_ACCEPTABLE);
        }
        return (new Gson()).toJson(messageMap);
    }

    @RequiresRoles(value = {"root"})
    @RequestMapping(value = "/manage/delete/{LoginID}", method = {RequestMethod.DELETE}, produces = "text/json; charset=UTF-8")
    @ResponseBody
    public String delete(@PathVariable String LoginID) {
        Map<String, Object> messageMap = new HashMap<>();
        if (LoginID == null || LoginID.isEmpty() || !accountService.exist(LoginID)) {
            messageMap.put("success", false);
            messageMap.put("message", "用户不存在");
            return (new Gson()).toJson(messageMap);
        }
        messageMap.put("success", accountService.delete(LoginID));
        return (new Gson()).toJson(messageMap);
    }

    @RequiresRoles(value = {"root"})
    @RequestMapping(value = "/list/role", produces = "text/json; charset=UTF-8")
    @ResponseBody
    public String listRole() {
        Map<String, Object> messageMap = new HashMap<>();
        messageMap.put("roles", authorityService.list());
        return (new Gson()).toJson(messageMap);
    }

}
