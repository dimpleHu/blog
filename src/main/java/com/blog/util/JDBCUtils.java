package com.blog.util;

import com.alibaba.druid.pool.DruidDataSource;

import javax.sql.DataSource;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;

public class JDBCUtils {
    private static DataSource dataSource;

    static {
        try {
            // 创建Druid数据源并直接设置配置
            DruidDataSource druidDataSource = new DruidDataSource();

            // 硬编码数据库配置
            druidDataSource.setDriverClassName("com.mysql.cj.jdbc.Driver");
            druidDataSource.setUrl("jdbc:mysql://127.0.0.1:3306/blogdata?useSSL=false&serverTimezone=Asia/Shanghai&allowPublicKeyRetrieval=true&useUnicode=true&characterEncoding=utf-8");
            druidDataSource.setUsername("root");
            druidDataSource.setPassword("20050902"); // 您的密码

            // 连接池配置
            druidDataSource.setInitialSize(5);
            druidDataSource.setMaxActive(20);
            druidDataSource.setMaxWait(30000);
            druidDataSource.setMinIdle(5);
            druidDataSource.setTimeBetweenEvictionRunsMillis(60000);
            druidDataSource.setMinEvictableIdleTimeMillis(300000);
            druidDataSource.setTestWhileIdle(true);
            druidDataSource.setTestOnBorrow(false);
            druidDataSource.setTestOnReturn(false);
            druidDataSource.setConnectionProperties("useUnicode=true;characterEncoding=utf8");

            // 验证连接的有效性
            druidDataSource.setValidationQuery("SELECT 1");

            dataSource = druidDataSource;

            // 测试连接
            try (Connection conn = dataSource.getConnection()) {
                System.out.println("✅ 数据库连接测试成功！");
                System.out.println("数据库: " + conn.getMetaData().getDatabaseProductName());
                System.out.println("URL: " + conn.getMetaData().getURL());
            }

        } catch (Exception e) {
            System.err.println("❌ 数据库连接初始化失败: " + e.getMessage());
            e.printStackTrace();
            throw new RuntimeException("数据库连接失败: " + e.getMessage(), e);
        }
    }

    public static Connection getConnection() throws SQLException {
        return dataSource.getConnection();
    }

    public static DataSource getDataSource() {
        return dataSource;
    }

//    public static void close(Connection conn, Statement stmt, ResultSet rs) {
//        try {
//            if (rs != null) rs.close();
//        } catch (SQLException e) {
//            e.printStackTrace();
//        }
//
//        try {
//            if (stmt != null) stmt.close();
//        } catch (SQLException e) {
//            e.printStackTrace();
//        }
//
//        try {
//            if (conn != null) conn.close();
//        } catch (SQLException e) {
//            e.printStackTrace();
//        }
//    }
//
//    public static void close(Connection conn, Statement stmt) {
//        close(conn, stmt, null);
//    }

    // 新增：单独关闭 Connection 的方法
    public static void close(Connection conn) {
        // 复用已有的 close 方法（传入 null 即可忽略 Statement 和 ResultSet）
        close(conn, null, null);
    }

    // 原有 close 方法保持不变
    public static void close(Connection conn, Statement stmt, ResultSet rs) {
        try {
            if (rs != null) rs.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }
        try {
            if (stmt != null) stmt.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }
        try {
            if (conn != null) conn.close(); // 归还连接到 Druid 连接池
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public static void close(Connection conn, Statement stmt) {
        close(conn, stmt, null);
    }
}