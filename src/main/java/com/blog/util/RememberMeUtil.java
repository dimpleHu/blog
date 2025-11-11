package com.blog.util;

import java.util.Base64;
import java.util.Calendar;

/**
 * 记住我功能工具类
 */
public class RememberMeUtil {
    
    private static final int REMEMBER_ME_DAYS = 10; // 记住我天数
    private static final String SEPARATOR = ":";
    
    /**
     * 生成记住我token
     * 格式：Base64(用户ID:过期时间戳)
     */
    public static String generateToken(int userId) {
        // 计算过期时间（10天后）
        Calendar calendar = Calendar.getInstance();
        calendar.add(Calendar.DAY_OF_MONTH, REMEMBER_ME_DAYS);
        long expireTime = calendar.getTimeInMillis();
        
        // 组合：用户ID:过期时间戳
        String tokenData = userId + SEPARATOR + expireTime;
        
        // Base64编码
        return Base64.getEncoder().encodeToString(tokenData.getBytes());
    }
    
    /**
     * 验证并解析token
     * @return 用户ID，如果token无效则返回null
     */
    public static Integer validateAndParseToken(String token) {
        if (token == null || token.trim().isEmpty()) {
            return null;
        }
        
        try {
            // Base64解码
            byte[] decodedBytes = Base64.getDecoder().decode(token);
            String tokenData = new String(decodedBytes);
            
            // 分割用户ID和过期时间
            String[] parts = tokenData.split(SEPARATOR);
            if (parts.length != 2) {
                return null;
            }
            
            int userId = Integer.parseInt(parts[0]);
            long expireTime = Long.parseLong(parts[1]);
            
            // 检查是否过期
            long currentTime = System.currentTimeMillis();
            if (currentTime > expireTime) {
                return null; // token已过期
            }
            
            return userId;
        } catch (Exception e) {
            // token格式错误或解析失败
            return null;
        }
    }
    
    /**
     * 获取Cookie名称
     */
    public static String getCookieName() {
        return "rememberMe";
    }
    
    /**
     * 获取Cookie过期时间（秒）
     */
    public static int getCookieMaxAge() {
        return REMEMBER_ME_DAYS * 24 * 60 * 60; // 10天的秒数
    }
}

