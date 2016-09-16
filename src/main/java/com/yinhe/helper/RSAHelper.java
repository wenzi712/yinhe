package com.yinhe.helper;

import sun.misc.BASE64Decoder;
import sun.misc.BASE64Encoder;

import javax.crypto.BadPaddingException;
import javax.crypto.Cipher;
import javax.crypto.IllegalBlockSizeException;
import javax.crypto.NoSuchPaddingException;
import java.io.*;
import java.security.*;
import java.security.spec.InvalidKeySpecException;
import java.security.spec.PKCS8EncodedKeySpec;
import java.security.spec.X509EncodedKeySpec;

public class RSAHelper {
    public static String KeyFileToString(File keyFile) throws IOException {
        if (!keyFile.exists() || keyFile.isDirectory()) {
            return null;
        }
        InputStreamReader inputStreamReader = new InputStreamReader(new FileInputStream(keyFile));
        BufferedReader bufferedReader = new BufferedReader(inputStreamReader);
        String line;
        StringBuffer stringBuffer = new StringBuffer();
        while ((line = bufferedReader.readLine()) != null) {
            if (line.startsWith("-----BEGIN")) {
                continue;
            }
            if (line.startsWith("-----END")) {
                break;
            }
            stringBuffer.append(line);
            stringBuffer.append("\n");
        }
        stringBuffer.deleteCharAt(stringBuffer.length() - 1);
        return stringBuffer.toString();
    }

    public static PrivateKey StringToPrivateKey(String RSAPrivateKey) throws NoSuchAlgorithmException, IOException, InvalidKeySpecException {
        byte[] buffer = (new BASE64Decoder()).decodeBuffer(RSAPrivateKey);
        PKCS8EncodedKeySpec keySpec = new PKCS8EncodedKeySpec(buffer);
        KeyFactory keyFactory = KeyFactory.getInstance("RSA");
        PrivateKey privateKey = keyFactory.generatePrivate(keySpec);
        return privateKey;
    }

    public static PublicKey StringToPublicKey(String stored) throws IOException, NoSuchAlgorithmException, InvalidKeySpecException {
        byte[] buffer = (new BASE64Decoder()).decodeBuffer(stored);
        KeyFactory keyFactory = KeyFactory.getInstance("RSA");
        return keyFactory.generatePublic(new X509EncodedKeySpec(buffer));
    }

    public static String PrivateKeyToString(PrivateKey RSAPrivateKey) throws NoSuchAlgorithmException, InvalidKeySpecException {
        KeyFactory keyFactory = KeyFactory.getInstance("RSA");
        PKCS8EncodedKeySpec pkcs8EncodedKeySpec = keyFactory.getKeySpec(RSAPrivateKey, PKCS8EncodedKeySpec.class);
        byte[] buffer = pkcs8EncodedKeySpec.getEncoded();
        String privateKey = (new BASE64Encoder()).encodeBuffer(buffer);
        return privateKey;
    }

    public static String PublicKeyToString(PublicKey RSAPublicKey) throws NoSuchAlgorithmException, InvalidKeySpecException {
        KeyFactory keyFactory = KeyFactory.getInstance("RSA");
        X509EncodedKeySpec spec = keyFactory.getKeySpec(RSAPublicKey, X509EncodedKeySpec.class);
        return (new BASE64Encoder()).encodeBuffer(spec.getEncoded());
    }

    public static String DecryptString(PrivateKey privateKey, String cipherTextString) throws InvalidKeyException, NoSuchPaddingException, NoSuchAlgorithmException, BadPaddingException, IllegalBlockSizeException, IOException {
        byte[] cipherText = (new BASE64Decoder()).decodeBuffer(cipherTextString);
        Cipher cipher = Cipher.getInstance("RSA");
        cipher.init(Cipher.DECRYPT_MODE, privateKey);
        byte[] plainText = cipher.doFinal(cipherText);
        String plainTextString = new String(plainText);
        return plainTextString;
    }
}
