package com.yinhe.shiro;

import com.yinhe.config.Parameter;
import com.yinhe.model.Account;
import com.yinhe.service.AccountService;
import com.yinhe.service.AuthorityService;
import org.apache.shiro.authc.*;
import org.apache.shiro.authz.AuthorizationInfo;
import org.apache.shiro.authz.SimpleAuthorizationInfo;
import org.apache.shiro.realm.AuthorizingRealm;
import org.apache.shiro.subject.PrincipalCollection;
import org.apache.shiro.util.ByteSource;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
@Transactional
public class AccountRealm extends AuthorizingRealm {
    @Autowired
    private AccountService accountService;
    @Autowired
    private AuthorityService authorityService;

    @Override
    protected AuthorizationInfo doGetAuthorizationInfo(PrincipalCollection principalCollection) {
        Account account = (Account)principalCollection.getPrimaryPrincipal();
        if (account == null) {
            return null;
        }
        SimpleAuthorizationInfo simpleAuthorizationInfo = new SimpleAuthorizationInfo();
        simpleAuthorizationInfo.addRole(authorityService.get(account.getRole()));
        return simpleAuthorizationInfo;
    }

    @Override
    protected AuthenticationInfo doGetAuthenticationInfo(AuthenticationToken authenticationToken) throws AuthenticationException {
        UsernamePasswordToken token = (UsernamePasswordToken) authenticationToken;
        String LoginID = token.getUsername();
        if (LoginID == null || LoginID.isEmpty() || !accountService.exist(LoginID)) {
            throw new UnknownAccountException();
        }
        Account account = new Account();
        account.setLoginID(token.getUsername());
        account.setPassword(String.valueOf(token.getPassword()));
        account = accountService.get(account.getLoginID());
        SimpleAuthenticationInfo authenticationInfo = new SimpleAuthenticationInfo(
                account,
                account.getPassword(),
                ByteSource.Util.bytes(account.getName() + Parameter.SALT),
                account.getName()
        );
        return authenticationInfo;
    }
}
