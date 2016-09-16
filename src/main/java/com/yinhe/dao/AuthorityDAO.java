package com.yinhe.dao;

import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface AuthorityDAO {
    String get(String Role);

    List<String> list();
}