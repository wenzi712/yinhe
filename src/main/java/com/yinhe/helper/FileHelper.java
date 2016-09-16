package com.yinhe.helper;

import java.io.*;
import java.util.ArrayList;
import java.util.List;

public class FileHelper {
    public static List<File> getFiles(String directory, String suffix) {
        List<File> result = new ArrayList<>();
        File dir = new File(directory);
        if (dir.exists() && dir.isDirectory()) {
            File[] files = dir.listFiles();
            for (File file : files) {
                if (!file.isDirectory() && file.getName().endsWith("." + suffix)) {
                    result.add(file);
                }
            }
        }

        return result;
    }

    public static void copy(File source, File destination) throws IOException {
        if (!source.exists()) {
            return;
        }
        if (!destination.getParentFile().exists()) {
            destination.mkdirs();
        }
        if (destination.exists()) {
            destination.delete();
        }

        BufferedReader bufferedReader;
        BufferedWriter bufferedWriter;
        String line;
        bufferedReader = new BufferedReader(new FileReader(source));
        bufferedWriter = new BufferedWriter(new FileWriter(destination));
        while ((line = bufferedReader.readLine()) != null) {
            bufferedWriter.write(line);
            bufferedWriter.newLine();
        }
        bufferedWriter.close();
        bufferedReader.close();
    }

    public static File create(String path) throws IOException {
        File file = new File(path);
        if (file.exists()) {
            file.delete();
        } else {
            if (!file.getParentFile().exists()) {
                file.getParentFile().mkdirs();
            }
            file.createNewFile();
        }
        return file;
    }

    public static String path(String rootDirectory, String relativePath) {
        if (rootDirectory.isEmpty()) {
            return null;
        }
        rootDirectory = rootDirectory.replace("\\", File.separator);
        rootDirectory = rootDirectory.replace("/", File.separator);
        if (!(rootDirectory.charAt(rootDirectory.length() - 1) == File.separatorChar)) {
            rootDirectory += File.separator;
        }

        if (relativePath.isEmpty()) {
            return rootDirectory;
        }
        relativePath = relativePath.replace("\\", File.separator);
        relativePath = relativePath.replace("/", File.separator);

        if (relativePath.charAt(0) == File.separatorChar) {
            relativePath = relativePath.substring(1, relativePath.length());
        }
        if (!(relativePath.charAt(relativePath.length() - 1) == File.separatorChar)) {
            relativePath += File.separator;
        }
        return rootDirectory + relativePath;
    }

    public static boolean save(InputStream inputStream, String path, String readEncode, String writeEncode) {
        boolean result = true;
        if (path.isEmpty() || readEncode.isEmpty() || writeEncode.isEmpty()) {
            return false;
        }

        try {
            InputStreamReader inputStreamReader = new InputStreamReader(inputStream, readEncode);
            BufferedReader bufferedReader = new BufferedReader(inputStreamReader);
            File file = FileHelper.create(path);
            Writer writer = new OutputStreamWriter(new FileOutputStream(file), writeEncode);
            String line;
            while ((line = bufferedReader.readLine()) != null) {
                writer.write(line);
                writer.write(System.getProperty("line.separator"));
            }
            bufferedReader.close();
            writer.close();
        } catch (IOException e) {
            e.printStackTrace();
            result = false;
        }
        return result;
    }
}
