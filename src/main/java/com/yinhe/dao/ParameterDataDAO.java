package com.yinhe.dao;

import com.yinhe.model.ParameterData;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface ParameterDataDAO {
    List<ParameterData> listAll();

    int exist(String Name);

    int update(ParameterData updateData);

    int add(ParameterData addData);

    int delete(String Name);
}
