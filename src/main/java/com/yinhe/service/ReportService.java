package com.yinhe.service;

import com.yinhe.dao.ReportDataDAO;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Service
public class ReportService {
    @Autowired
    private ReportDataDAO reportDataDAO;

    public List<Map<String, Object>> listAll(String report, String date, Map<String, Object> parameters) {
        List<Map<String, Object>> result = null;
        if (parameters == null) {
            parameters = new HashMap<>();
        }
        if (date == null || date.isEmpty()) {
            parameters.put("TableName", "月度考核");
        } else {
            parameters.put("TableName", "月度考核" + date);
        }
        switch (report) {
            case "增收系数计算表":
                result = reportDataDAO.listZengShouXiShuJiSuanBiao(parameters);
                break;
            case "提成基数计算表":
                result = reportDataDAO.listTiChengJiShuJiSuanBiao(parameters);
                break;
            case "服务奖金发放表":
                result = reportDataDAO.listFuWuJiangJinFaFangBiao(parameters);
                break;
            case "服务奖金计算表":
                result = reportDataDAO.listFuWuJiangJinJiSuanBiao(parameters);
                break;
            case "积分表":
                result = reportDataDAO.listJiFenBiao(parameters);
                break;
            case "资产贡献度达标率表":
                result = reportDataDAO.listZiChanGongXianDuDaBiaoLvBiao(parameters);
                break;
        }
        return result;
    }
}
