package com.yinhe.dao;

import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Map;

@Repository
public interface ReportDataDAO {
    List<Map<String, Object>> listZengShouXiShuJiSuanBiao(Map<String,Object> parameters); //增收系数计算表

    List<Map<String, Object>> listTiChengJiShuJiSuanBiao(Map<String,Object> parameters); //提成基数计算表

    List<Map<String, Object>> listFuWuJiangJinFaFangBiao(Map<String,Object> parameters); //服务奖金发放表

    List<Map<String, Object>> listFuWuJiangJinJiSuanBiao(Map<String,Object> parameters); //服务奖金计算表

    List<Map<String, Object>> listJiFenBiao(Map<String,Object> parameters); //积分表

    List<Map<String, Object>> listZiChanGongXianDuDaBiaoLvBiao(Map<String,Object> parameters); //资产贡献度达标率表
}
