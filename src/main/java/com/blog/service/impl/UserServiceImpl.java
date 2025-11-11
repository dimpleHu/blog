package com.blog.service.impl;

import com.blog.dao.UserDAO;
import com.blog.entity.User;
import com.blog.service.UserService;

import java.util.List;

/**
 * 用户服务实现类
 */
public class UserServiceImpl implements UserService {
    
    private UserDAO userDAO = new UserDAO();
    
    @Override
    public int register(User user) {
        return userDAO.addUser(user);
    }
    
    @Override
    public User getUserById(int id) {
        return userDAO.getUserById(id);
    }
    
    @Override
    public User getUserByUsername(String username) {
        return userDAO.getUserByUsername(username);
    }
    
    @Override
    public User getUserByPhone(String phonenumber) {
        return userDAO.getUserByPhone(phonenumber);
    }
    
    @Override
    public int updateUser(User user) {
        return userDAO.updateUser(user);
    }
    
    @Override
    public int updatePassword(int userId, String newPassword) {
        return userDAO.updatePassword(userId, newPassword);
    }
    
    @Override
    public int disableUser(int userId) {
        return userDAO.disableUser(userId);
    }
    
    @Override
    public List<User> getAllUsers() {
        return userDAO.getAllUsers();
    }
    
    @Override
    public User validateLogin(String username, String password) {
        return userDAO.validateLogin(username, password);
    }
    
    @Override
    public int updateLastLoginTime(Integer id) {
        return userDAO.updateLastLoginTime(id);
    }
    
    @Override
    public boolean isUsernameExists(String username) {
        return userDAO.isUsernameExists(username);
    }
    
    @Override
    public boolean isPhoneExists(String phonenumber) {
        return userDAO.isPhoneExists(phonenumber);
    }
    
    @Override
    public List<User> getUsersByPage(int page, int pageSize) {
        return userDAO.getUsersByPage(page, pageSize);
    }
    
    @Override
    public int getUserCount() {
        return userDAO.getUserCount();
    }
    
    @Override
    public int updateAvatar(int userId, String avatarPath) {
        return userDAO.updateAvatar(userId, avatarPath);
    }
    
    @Override
    public int updateSignature(int userId, String signature) {
        return userDAO.updateSignature(userId, signature);
    }
    
    @Override
    public List<User> searchUsersByUsername(String keyword) {
        return userDAO.searchUsersByUsername(keyword);
    }
}

