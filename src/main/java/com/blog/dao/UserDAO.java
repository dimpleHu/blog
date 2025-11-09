package com.blog.dao;

import com.blog.entity.User;
import java.util.List;

public class UserDAO extends BaseDAO {
    
    /**
     * 添加用户
     */
    public int addUser(User user) {
        String sql = "INSERT INTO user (username, password, phonenumber, avatar, gender, birthday, signature) " +
                    "VALUES (?, ?, ?, ?, ?, ?, ?)";
        return executeUpdate(sql, 
            user.getUsername(), user.getPassword(), user.getPhonenumber(),
            user.getAvatar(), user.getGender(), user.getBirthday(), user.getSignature());
    }
    
    /**
     * 根据ID查询用户
     */
    public User getUserById(int id) {
        String sql = "SELECT * FROM user WHERE id = ? AND status = 1";
        return executeQueryForObject(sql, User.class, id);
    }
    
    /**
     * 根据用户名查询用户
     */
    public User getUserByUsername(String username) {
        String sql = "SELECT * FROM user WHERE username = ? AND status = 1";
        return executeQueryForObject(sql, User.class, username);
    }
    
    /**
     * 根据手机号查询用户
     */
    public User getUserByPhone(String phonenumber) {
        String sql = "SELECT * FROM user WHERE phonenumber = ? AND status = 1";
        return executeQueryForObject(sql, User.class, phonenumber);
    }
    
    /**
     * 更新用户信息
     */
    public int updateUser(User user) {
        String sql = "UPDATE user SET username=?, phonenumber=?, avatar=?, gender=?, " +
                    "birthday=?, signature=?, last_login_time=? WHERE id=?";
        return executeUpdate(sql, 
            user.getUsername(), user.getPhonenumber(), user.getAvatar(),
            user.getGender(), user.getBirthday(), user.getSignature(),
            user.getLastLoginTime(), user.getId());
    }
    
    /**
     * 更新密码
     */
    public int updatePassword(int userId, String newPassword) {
        String sql = "UPDATE user SET password = ? WHERE id = ?";
        return executeUpdate(sql, newPassword, userId);
    }
    
    /**
     * 禁用用户
     */
    public int disableUser(int userId) {
        String sql = "UPDATE user SET status = 0 WHERE id = ?";
        return executeUpdate(sql, userId);
    }
    
    /**
     * 查询所有用户
     */
    public List<User> getAllUsers() {
        String sql = "SELECT * FROM user WHERE status = 1 ORDER BY create_time DESC";
        return executeQuery(sql, User.class);
    }
    
    /**
     * 验证用户登录
     */
    public User validateLogin(String username, String password) {
        String sql = "SELECT * FROM user WHERE username = ? AND password = ? AND status = 1";
        return executeQueryForObject(sql, User.class, username, password);
    }

    /**
     * 更新最后登录时间
     */
    public int updateLastLoginTime(Integer id) {
        if (id == null || id <= 0) {
            return 0;
        }
        String sql = "UPDATE user SET last_login_time = NOW() WHERE id = ?";
        return executeUpdate(sql, id);
    }
    /**
     * 检查用户名是否存在
     */
    public boolean isUsernameExists(String username) {
        if (username == null || username.trim().isEmpty()) {
            return false;
        }
        String sql = "SELECT COUNT(*) FROM user WHERE username = ?";
        Integer count = executeQueryForSingleValue(sql, Integer.class, username.trim());
        return count != null && count > 0;
    }

    /**
     * 检查手机号是否存在
     */
    public boolean isPhoneExists(String phonenumber) {
        if (phonenumber == null || phonenumber.trim().isEmpty()) {
            return false;
        }
        String sql = "SELECT COUNT(*) FROM user WHERE phonenumber = ?";
        Integer count = executeQueryForSingleValue(sql, Integer.class, phonenumber.trim());
        return count != null && count > 0;
    }

    /**
     * 分页查询用户
     */
    public List<User> getUsersByPage(int page, int pageSize) {
        int start = (page - 1) * pageSize;
        String sql = "SELECT * FROM user WHERE status = 1 ORDER BY create_time DESC LIMIT ?, ?";
        return executeQuery(sql, User.class, start, pageSize);
    }

    /**
     * 获取用户总数
     */
    public int getUserCount() {
        String sql = "SELECT COUNT(*) FROM user WHERE status = 1";
        Integer count = executeQueryForSingleValue(sql, Integer.class);
        return count != null ? count : 0;
    }

    /**
     * 更新用户头像
     */
    public int updateAvatar(int userId, String avatarPath) {
        String sql = "UPDATE user SET avatar = ? WHERE id = ?";
        return executeUpdate(sql, avatarPath, userId);
    }

    /**
     * 更新用户个性签名
     */
    public int updateSignature(int userId, String signature) {
        String sql = "UPDATE user SET signature = ? WHERE id = ?";
        return executeUpdate(sql, signature, userId);
    }

//    /**
//     * 根据用户名模糊搜索用户
//     */
//    public List<User> searchUsersByUsername(String keyword) {
//        if (keyword == null || keyword.trim().isEmpty()) {
//            return getAllUsers();
//        }
//        String sql = "SELECT * FROM user WHERE username LIKE ? AND status = 1 ORDER BY create_time DESC";
//        return executeQuery(sql, User.class, "%" + keyword.trim() + "%");
//    }

    /**
     * 增强搜索用户（支持模糊搜索和相关性排序）
     */
    public List<User> searchUsersByUsername(String keyword) {
        if (keyword == null || keyword.trim().isEmpty()) {
            return getAllUsers();
        }

        String sql = "SELECT * FROM user WHERE status = 1 AND " +
                "(username LIKE ? OR signature LIKE ?) " +
                "ORDER BY " +
                "CASE WHEN username = ? THEN 1 " +
                "     WHEN username LIKE ? THEN 2 " +
                "     WHEN username LIKE ? THEN 3 " +
                "     ELSE 4 END, " +
                "create_time DESC";

        return executeQuery(sql, User.class,
                "%" + keyword + "%", "%" + keyword + "%",
                keyword, keyword + "%", "%" + keyword + "%");
    }
}