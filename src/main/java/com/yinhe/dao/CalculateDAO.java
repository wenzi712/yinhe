package com.yinhe.dao;

import org.springframework.stereotype.Repository;

import java.util.HashMap;

@Repository
public interface CalculateDAO {
    int save(HashMap<String, String> Parameters);

    int drop(String TableName);
}