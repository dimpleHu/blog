package com.blog.service;

import com.blog.entity.User;
import java.util.List;

/**
 * 用户服务接口
 */
public interface UserService {
    
    /**
     * 注册用户
     */
    int register(User user);
    
    /**
     * 根据ID查询用户
     */
    User getUserById(int id);
    
    /**
     * 根据用户名查询用户
     */
    User getUserByUsername(String username);
    
    /**
     * 根据手机号查询用户
     */
    User getUserByPhone(String phonenumber);
    
    /**
     * 更新用户信息
     */
    int updateUser(User user);
    
    /**
     * 更新密码
     */
    int updatePassword(int userId, String newPassword);
    
    /**
     * 禁用用户
     */
    int disableUser(int userId);
    
    /**
     * 查询所有用户
     */
    List<User> getAllUsers();
    
    /**
     * 验证用户登录
     */
    User validateLogin(String username, String password);
    
    /**
     * 更新最后登录时间
     */
    int updateLastLoginTime(Integer id);
    
    /**
     * 检查用户名是否存在
     */
    boolean isUsernameExists(String username);
    
    /**
     * 检查手机号是否存在
     */
    boolean isPhoneExists(String phonenumber);
    
    /**
     * 分页查询用户
     */
    List<User> getUsersByPage(int page, int pageSize);
    
    /**
     * 获取用户总数
     */
    int getUserCount();
    
    /**
     * 更新用户头像
     */
    int updateAvatar(int userId, String avatarPath);
    
    /**
     * 更新用户个性签名
     */
    int updateSignature(int userId, String signature);
    
    /**
     * 搜索用户
     */
    List<User> searchUsersByUsername(String keyword);
}

