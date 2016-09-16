package com.yinhe.service;

import com.yinhe.dao.AccountDAO;
import com.yinhe.model.Account;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class AccountService {
    @Autowired
    private AccountDAO accountDAO;

    public List<Account> listAll() {
        return accountDAO.listAll();
    }

    public boolean exist(String LoginID) {
        return (accountDAO.exist(LoginID) > 0);
    }

    public Account get(String LoginID) {
        return accountDAO.get(LoginID);
    }

    public boolean update(Account account) {
        return (accountDAO.update(account) > 0);
    }

    public boolean add(Account account) {
        return (accountDAO.add(account) > 0);
    }

    public boolean delete(String LoginID) {
        return (accountDAO.delete(LoginID) > 0);
    }
}
