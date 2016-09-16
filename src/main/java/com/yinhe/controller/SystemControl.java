package com.yinhe.controller;

import com.yinhe.helper.FileHelper;
import org.apache.shiro.authz.annotation.RequiresRoles;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import java.io.FileOutputStream;
import java.io.IOException;
import java.io.OutputStreamWriter;
import java.io.Writer;

@Controller
@RequestMapping(value = "/system")
public class SystemControl {
    @RequiresRoles(value = {"root"})
    @RequestMapping(value = "restart", produces = "text/json; charset=UTF-8")
    @ResponseBody
    public void restart() throws IOException, InterruptedException {
        final String rootDirectory = System.getProperty("web.root");
        final String directory = FileHelper.path(rootDirectory, "/tmp/sql/");
        String batPath = directory + "00_restart.bat";
        String content = "sc stop Tomcat8 && sc start Tomcat8";
        Writer writer = new OutputStreamWriter(new FileOutputStream(batPath), "GBK");
        writer.write(content);
        writer.close();

        ProcessBuilder processBuilder = new ProcessBuilder(batPath);
        Process process = processBuilder.start();
        process.waitFor();
    }
}
