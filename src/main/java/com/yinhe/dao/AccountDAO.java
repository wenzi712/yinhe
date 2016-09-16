package com.yinhe.dao;

import com.yinhe.model.Account;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface AccountDAO {
    List<Account> listAll();

    int exist(String LoginID);

    Account get(String LoginID);

    int update(Account updateData);

    int add(Account addData);

    int delete(String LoginID);
}