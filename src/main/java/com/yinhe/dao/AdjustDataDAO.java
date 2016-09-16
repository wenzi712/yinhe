package com.yinhe.dao;

import com.yinhe.model.AdjustData;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Map;

@Repository
public interface AdjustDataDAO {
    List<AdjustData> listAll(Map<String, Object> parameters);

    int update(AdjustData updateData);
}
