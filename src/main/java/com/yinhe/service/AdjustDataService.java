package com.yinhe.service;

import com.yinhe.dao.AdjustDataDAO;
import com.yinhe.model.AdjustData;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Map;

@Service
public class AdjustDataService {
    @Autowired
    private AdjustDataDAO adjustDataDAO;

    public List<AdjustData> listAll(Map<String, Object> parameters) {
        return adjustDataDAO.listAll(parameters);
    }

    public boolean update(AdjustData updateData) {
        return (adjustDataDAO.update(updateData) > 0);
    }
}
