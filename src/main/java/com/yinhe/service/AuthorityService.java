package com.yinhe.service;

import com.yinhe.dao.AuthorityDAO;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class AuthorityService {
    @Autowired
    private AuthorityDAO authorityDAO;

    public String get(String Role) {
        return authorityDAO.get(Role);
    }

    public List<String> list() {
        return authorityDAO.list();
    }
}
