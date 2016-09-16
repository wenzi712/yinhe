package com.yinhe.helper;

import com.yinhe.config.Parameter;
import com.yinhe.model.Account;
import org.apache.shiro.crypto.hash.SimpleHash;
import org.apache.shiro.util.ByteSource;
import org.springframework.stereotype.Component;

@Component
public class PasswordHelper {
    private static String AlgorithmName = "SHA-256";
    private static int HashIterations = 1;

    public static void setAlgorithmName(String algorithmName) {
        AlgorithmName = algorithmName;
    }

    public static void setHashIterations(int hashIterations) {
        HashIterations = hashIterations;
    }

    public static void EncryptPassword(Account account) {
        String Password = new SimpleHash(
                AlgorithmName,
                account.getPassword(),
                ByteSource.Util.bytes(account.getName() + Parameter.SALT),
                HashIterations).toHex();
        account.setPassword(Password);
    }

    public static String EncryptPassword(String password, String name) {
        String Password = new SimpleHash(
                AlgorithmName,
                password,
                ByteSource.Util.bytes(name + Parameter.SALT),
                HashIterations).toHex();
        return Password;
    }
}
