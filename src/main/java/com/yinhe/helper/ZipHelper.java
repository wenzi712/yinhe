package com.yinhe.helper;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.util.zip.ZipEntry;
import java.util.zip.ZipOutputStream;

public class ZipHelper {
    /**
     * 创建ZIP文件
     *
     * @param sourcePath 文件或文件夹路径
     * @param zipPath    生成的zip文件存在路径（包括文件名）
     */
    public static void createZip(String sourcePath, String zipPath) throws IOException {
        FileOutputStream fos;
        ZipOutputStream zipOutputStream;
        fos = new FileOutputStream(zipPath);
        zipOutputStream = new ZipOutputStream(fos);
        writeZip(new File(sourcePath), "", zipOutputStream);
        if (zipOutputStream != null) {
            zipOutputStream.close();
        }
    }

    private static void writeZip(File file, String parentPath, ZipOutputStream zipOutputStream) throws IOException {
        if (file.exists()) {
            if (file.isDirectory()) {//处理文件夹
                parentPath += file.getName() + File.separator;
                File[] files = file.listFiles();
                for (File f : files) {
                    writeZip(f, parentPath, zipOutputStream);
                }
            } else {
                FileInputStream fileInputStream;
                fileInputStream = new FileInputStream(file);
                ZipEntry zipEntry = new ZipEntry(parentPath + file.getName());
                zipOutputStream.putNextEntry(zipEntry);
                byte[] content = new byte[1024];
                int length;
                while ((length = fileInputStream.read(content)) != -1) {
                    zipOutputStream.write(content, 0, length);
                    zipOutputStream.flush();
                }
                if (fileInputStream != null) {
                    fileInputStream.close();
                }
            }
        }
    }
}
