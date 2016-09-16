package com.yinhe.model;

public class AdjustData {
    protected int Id;
    protected String Department;                     //营业部
    protected String Organization;                   //部门
    protected String Name;                            //姓名
    protected double Payment;                        //服务奖金预发放值
    protected double Adjust;                         //部门调整值
    protected String Remark;                         //备注

    public int getId() {
        return Id;
    }

    public void setId(int id) {
        Id = id;
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

    public double getPayment() {
        return Payment;
    }

    public void setPayment(double payment) {
        Payment = payment;
    }

    public double getAdjust() {
        return Adjust;
    }

    public void setAdjust(double adjust) {
        Adjust = adjust;
    }

    public String getRemark() {
        return Remark;
    }

    public void setRemark(String remark) {
        Remark = remark;
    }
}
