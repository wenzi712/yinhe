package com.yinhe.service;

import com.yinhe.dao.ParameterDataDAO;
import com.yinhe.model.ParameterData;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class ParameterDataService {
    @Autowired
    private ParameterDataDAO parameterDataDAO;

    public List<ParameterData> listAll() {
        return parameterDataDAO.listAll();
    }

    public boolean exist(String Name) {
        return (parameterDataDAO.exist(Name) > 0);
    }

    public boolean update(ParameterData updateData) {
        return (parameterDataDAO.update(updateData) > 0);
    }

    public boolean add(ParameterData addData) {
        return (parameterDataDAO.add(addData) > 0);
    }

    public boolean delete(String Name) {
        return (parameterDataDAO.delete(Name) > 0);
    }
}
