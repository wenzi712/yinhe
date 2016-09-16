package com.yinhe.service;

import com.yinhe.dao.ImportDataDAO;
import com.yinhe.model.ImportData;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class ImportDataService {
    @Autowired
    private ImportDataDAO importDataDAO;

    public List<ImportData> listAll() throws Exception {
        return importDataDAO.listAll();
    }

    public boolean update(ImportData updateData) {
        return (importDataDAO.update(updateData) > 0);
    }
}
