package com.yinhe.model;

import org.hibernate.validator.constraints.NotBlank;

import javax.validation.constraints.NotNull;
import java.io.Serializable;

public class ParameterData implements Serializable {
    @NotNull
    @NotBlank
    protected String Name;            //参数名称
    protected double SectionSign1;  //分段标识1
    protected double SectionSign2;  //分段标识2
    protected double Parameter1;    //参数1
    protected double Parameter2;    //参数2
    protected double Parameter3;    //参数3

    public String getName() {
        return Name;
    }

    public void setName(String name) {
        Name = name;
    }

    public double getSectionSign1() {
        return SectionSign1;
    }

    public void setSectionSign1(double sectionSign1) {
        SectionSign1 = sectionSign1;
    }

    public double getSectionSign2() {
        return SectionSign2;
    }

    public void setSectionSign2(double sectionSign2) {
        SectionSign2 = sectionSign2;
    }

    public double getParameter1() {
        return Parameter1;
    }

    public void setParameter1(double parameter1) {
        Parameter1 = parameter1;
    }

    public double getParameter2() {
        return Parameter2;
    }

    public void setParameter2(double parameter2) {
        Parameter2 = parameter2;
    }

    public double getParameter3() {
        return Parameter3;
    }

    public void setParameter3(double parameter3) {
        Parameter3 = parameter3;
    }
}
