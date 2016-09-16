package com.yinhe.model;

import com.google.gson.GsonBuilder;
import com.google.gson.annotations.Expose;
import org.hibernate.validator.constraints.NotBlank;

import javax.validation.constraints.NotNull;
import java.io.Serializable;

public class Account implements Serializable {
    @Expose
    protected String Department;                     //营业部
    @Expose
    protected String Organization;                   //部门
    @Expose
    protected String Name;                            //姓名
    @Expose
    protected boolean Export;                          //存档权限
    @NotNull
    @NotBlank
    @Expose
    protected String LoginID;                        //登陆名
    @Expose
    protected String Role;                            //角色
    @NotNull
    @NotBlank
    protected String Password;                       //密码

    public String toString() {
        return (new GsonBuilder().excludeFieldsWithoutExposeAnnotation().create()).toJson(this).toString();
    }

    public String getDepartment() {
        return Department;
    }

    public void setDepartment(String department) {
        Department = department;
    }

    public String getOrganization() {
        return Organization;
    }

    public void setOrganization(String organization) {
        Organization = organization;
    }

    public String getName() {
        return Name;
    }

    public void setName(String name) {
        Name = name;
    }

    public boolean getExport() {
        return Export;
    }

    public void setExport(Boolean export) {
        Export = export;
    }

    public String getLoginID() {
        return LoginID;
    }

    public void setLoginID(String loginID) {
        LoginID = loginID;
    }

    public String getRole() {
        return Role;
    }

    public void setRole(String role) {
        Role = role;
    }

    public String getPassword() {
        return Password;
    }

    public void setPassword(String password) {
        Password = password;
    }
}
