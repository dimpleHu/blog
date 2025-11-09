package com.blog.util;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Random;

public class UploadUtils {
    // 允许的图片格式（防止恶意文件）
    private static final String[] ALLOWED_SUFFIX = {"jpg", "jpeg", "png", "gif", "webp"};

    /**
     * 生成唯一文件名：时间戳_随机数.后缀
     */
    public static String generateUniqueFileName(String originalFileName) {
        // 1. 校验文件格式
        String suffix = originalFileName.substring(originalFileName.lastIndexOf(".") + 1).toLowerCase();
        if (!isAllowedSuffix(suffix)) {
            throw new RuntimeException("不支持的图片格式！仅允许：jpg、jpeg、png、gif、webp");
        }
        // 2. 生成唯一名称
        String timestamp = new SimpleDateFormat("yyyyMMddHHmmss").format(new Date());
        String randomNum = String.valueOf(new Random().nextInt(10000));
        return timestamp + "_" + randomNum + "." + suffix;
    }

    // 校验格式是否允许
    private static boolean isAllowedSuffix(String suffix) {
        for (String s : ALLOWED_SUFFIX) {
            if (s.equals(suffix)) return true;
        }
        return false;
    }
}