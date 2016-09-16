package com.yinhe.dao;

import com.yinhe.model.ImportData;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface ImportDataDAO {
    List<ImportData> listAll();

    int update(ImportData updateData);
}
