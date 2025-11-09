package com.blog.dao;

import com.blog.util.JDBCUtils;
import org.apache.commons.dbutils.QueryRunner;
import org.apache.commons.dbutils.handlers.ColumnListHandler;

import java.lang.reflect.Field;
import java.sql.*;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

/**
 * 基础DAO类，封装通用的CRUD操作
 */
public class BaseDAO {
    private QueryRunner queryRunner = new QueryRunner();

    /**
     * 执行更新操作（INSERT, UPDATE, DELETE）
     */
    protected int executeUpdate(String sql, Object... params) {
        Connection conn = null;
        PreparedStatement pstmt = null;

        try {
            conn = JDBCUtils.getConnection();
            pstmt = conn.prepareStatement(sql);

            // 设置参数
            if (params != null) {
                for (int i = 0; i < params.length; i++) {
                    pstmt.setObject(i + 1, params[i]);
                }
            }

            return pstmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
            throw new RuntimeException("数据库操作失败", e);
        } finally {
            JDBCUtils.close(conn, pstmt);
        }
    }

    /**
     * 执行查询操作，返回单个对象
     */
    protected <T> T executeQueryForObject(String sql, Class<T> clazz, Object... params) {
        List<T> list = executeQuery(sql, clazz, params);
        return list.isEmpty() ? null : list.get(0);
    }

    /**
     * 执行查询操作，返回对象列表
     */
    protected <T> List<T> executeQuery(String sql, Class<T> clazz, Object... params) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        List<T> list = new ArrayList<>();

        try {
            conn = JDBCUtils.getConnection();
            pstmt = conn.prepareStatement(sql);

            // 设置参数
            if (params != null) {
                for (int i = 0; i < params.length; i++) {
                    pstmt.setObject(i + 1, params[i]);
                }
            }

            rs = pstmt.executeQuery();
            ResultSetMetaData metaData = rs.getMetaData();
            int columnCount = metaData.getColumnCount();

            while (rs.next()) {
                T obj = clazz.getDeclaredConstructor().newInstance();

                for (int i = 1; i <= columnCount; i++) {
                    String columnName = metaData.getColumnLabel(i);
                    Object value = rs.getObject(columnName);

                    // 将下划线命名转换为驼峰命名
                    String fieldName = toCamelCase(columnName);

                    try {
                        Field field = clazz.getDeclaredField(fieldName);
                        field.setAccessible(true);

                        // 新增：处理时间类型转换
                        value = convertValueForField(field, value);

                        field.set(obj, value);
                    } catch (NoSuchFieldException e) {
                        // 忽略不存在的字段
                    }
                }

                list.add(obj);
            }
        } catch (Exception e) {
            e.printStackTrace();
            throw new RuntimeException("数据库查询失败", e);
        } finally {
            JDBCUtils.close(conn, pstmt, rs);
        }

        return list;
    }

    /**
     * 新增：处理字段值类型转换（特别是时间类型）
     */
    private Object convertValueForField(Field field, Object value) {
        if (value == null) {
            return null;
        }

        Class<?> fieldType = field.getType();

        // 如果类型匹配，直接返回
        if (fieldType.isInstance(value)) {
            return value;
        }

        // 处理时间类型转换
        if (value instanceof Timestamp) {
            Timestamp timestamp = (Timestamp) value;

            if (fieldType == LocalDateTime.class) {
                // Timestamp 转 LocalDateTime
                return timestamp.toLocalDateTime();
            } else if (fieldType == java.util.Date.class) {
                // Timestamp 转 java.util.Date
                return new java.util.Date(timestamp.getTime());
            } else if (fieldType == java.sql.Date.class) {
                // Timestamp 转 java.sql.Date
                return new java.sql.Date(timestamp.getTime());
            }
        } else if (value instanceof java.sql.Date) {
            java.sql.Date sqlDate = (java.sql.Date) value;

            if (fieldType == LocalDateTime.class) {
                // java.sql.Date 转 LocalDateTime（设置为当天的开始时间）
                return sqlDate.toLocalDate().atStartOfDay();
            } else if (fieldType == java.util.Date.class) {
                // java.sql.Date 转 java.util.Date
                return new java.util.Date(sqlDate.getTime());
            } else if (fieldType == Timestamp.class) {
                // java.sql.Date 转 Timestamp
                return new Timestamp(sqlDate.getTime());
            }
        } else if (value instanceof java.sql.Time) {
            java.sql.Time sqlTime = (java.sql.Time) value;

            if (fieldType == java.util.Date.class) {
                return new java.util.Date(sqlTime.getTime());
            } else if (fieldType == Timestamp.class) {
                return new Timestamp(sqlTime.getTime());
            }
        }

        // 处理数字类型转换
        if (value instanceof Number) {
            Number number = (Number) value;

            if (fieldType == Integer.class || fieldType == int.class) {
                return number.intValue();
            } else if (fieldType == Long.class || fieldType == long.class) {
                return number.longValue();
            } else if (fieldType == Double.class || fieldType == double.class) {
                return number.doubleValue();
            } else if (fieldType == Float.class || fieldType == float.class) {
                return number.floatValue();
            } else if (fieldType == Short.class || fieldType == short.class) {
                return number.shortValue();
            } else if (fieldType == Byte.class || fieldType == byte.class) {
                return number.byteValue();
            }
        }

        // 处理布尔类型转换
        if (fieldType == Boolean.class || fieldType == boolean.class) {
            if (value instanceof Number) {
                return ((Number) value).intValue() != 0;
            } else if (value instanceof String) {
                String strValue = ((String) value).toLowerCase();
                return "true".equals(strValue) || "1".equals(strValue) || "yes".equals(strValue) || "y".equals(strValue);
            }
        }

        // 处理字符串转换
        if (fieldType == String.class) {
            return value.toString();
        }

        // 如果无法转换，返回原值（让系统抛出异常）
        return value;
    }

    /**
     * 执行查询，返回单个值（如COUNT(*)）
     */
    protected <T> T executeQueryForSingleValue(String sql, Class<T> clazz, Object... params) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        try {
            conn = JDBCUtils.getConnection();
            pstmt = conn.prepareStatement(sql);

            if (params != null) {
                for (int i = 0; i < params.length; i++) {
                    pstmt.setObject(i + 1, params[i]);
                }
            }

            rs = pstmt.executeQuery();
            if (rs.next()) {
                return rs.getObject(1, clazz);
            }
            return null;
        } catch (SQLException e) {
            e.printStackTrace();
            throw new RuntimeException("数据库查询失败", e);
        } finally {
            JDBCUtils.close(conn, pstmt, rs);
        }
    }

    /**
     * 将数据库字段名转换为Java属性名（下划线转驼峰）
     */
    private String toCamelCase(String columnName) {
        StringBuilder result = new StringBuilder();
        String[] parts = columnName.split("_");

        for (int i = 0; i < parts.length; i++) {
            if (i == 0) {
                result.append(parts[i]);
            } else {
                result.append(Character.toUpperCase(parts[i].charAt(0)))
                        .append(parts[i].substring(1));
            }
        }
        return result.toString();
    }

    /**
     * 新增：查询单个字段的列表数据（如标签ID列表、用户名列表等）
     * @param sql SQL语句
     * @param clazz 字段类型（如 Integer.class、String.class）
     * @param params SQL参数
     * @param <T> 泛型，对应字段类型
     * @return 单个字段的列表（如 List<Integer> 标签ID列表）
     */
    public <T> List<T> executeQueryForList(String sql, Class<T> clazz, Object... params) {
        Connection conn = null;
        try {
            // 获取数据库连接（复用你项目中已有的连接获取逻辑，如 JDBCUtils.getConnection()）
            conn = JDBCUtils.getConnection();
            // 使用 ColumnListHandler 处理结果：只取查询结果的第一列数据，封装为 List<T>
            return queryRunner.query(conn, sql, new ColumnListHandler<>(clazz.getModifiers()), params);
        } catch (SQLException e) {
            e.printStackTrace();
            throw new RuntimeException("查询单个字段列表失败：" + e.getMessage());
        } finally {
            // 关闭连接（复用你项目中已有的关闭逻辑）
            JDBCUtils.close(conn);
        }
    }

    /**
     * 新增：安全的查询方法，带异常处理
     */
    protected <T> List<T> executeQuerySafely(String sql, Class<T> clazz, Object... params) {
        try {
            return executeQuery(sql, clazz, params);
        } catch (Exception e) {
            e.printStackTrace();
            // 返回空列表而不是抛出异常
            return new ArrayList<>();
        }
    }

    /**
     * 新增：安全的查询单个对象方法
     */
    protected <T> T executeQueryForObjectSafely(String sql, Class<T> clazz, Object... params) {
        List<T> list = executeQuerySafely(sql, clazz, params);
        return list.isEmpty() ? null : list.get(0);
    }
}