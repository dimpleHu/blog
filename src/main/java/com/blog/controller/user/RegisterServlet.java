package com.blog.controller.user;

import com.blog.dao.UserDAO;
import com.blog.entity.User;
import com.blog.util.PasswordUtil;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.time.LocalDateTime;
import java.util.Date;

@WebServlet("/user/register")
public class RegisterServlet extends HttpServlet {
    private UserDAO userDAO = new UserDAO();

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.getRequestDispatcher("/jsp/user/register.jsp").forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirmPassword");
        String phonenumber = request.getParameter("phonenumber");
        
        // 保留表单数据用于回显
        request.setAttribute("username", username);
        request.setAttribute("phonenumber", phonenumber);
        
        // 验证输入
        if (username == null || username.trim().isEmpty()) {
            request.setAttribute("error", "用户名不能为空");
            request.getRequestDispatcher("/jsp/user/register.jsp").forward(request, response);
            return;
        }
        
        if (username.trim().length() < 3 || username.trim().length() > 20) {
            request.setAttribute("error", "用户名长度必须在3-20个字符之间");
            request.getRequestDispatcher("/jsp/user/register.jsp").forward(request, response);
            return;
        }
        
        if (password == null || password.trim().isEmpty()) {
            request.setAttribute("error", "密码不能为空");
            request.getRequestDispatcher("/jsp/user/register.jsp").forward(request, response);
            return;
        }
        
        if (password.length() < 6) {
            request.setAttribute("error", "密码长度不能少于6位");
            request.getRequestDispatcher("/jsp/user/register.jsp").forward(request, response);
            return;
        }
        
        if (!password.equals(confirmPassword)) {
            request.setAttribute("error", "两次输入的密码不一致");
            request.getRequestDispatcher("/jsp/user/register.jsp").forward(request, response);
            return;
        }
        
        if (phonenumber == null || phonenumber.trim().isEmpty()) {
            request.setAttribute("error", "手机号不能为空");
            request.getRequestDispatcher("/jsp/user/register.jsp").forward(request, response);
            return;
        }
        
        if (!phonenumber.matches("1[3-9]\\d{9}")) {
            request.setAttribute("error", "手机号格式不正确");
            request.getRequestDispatcher("/jsp/user/register.jsp").forward(request, response);
            return;
        }
        
        // 检查用户名是否已存在
        if (userDAO.getUserByUsername(username.trim()) != null) {
            request.setAttribute("error", "用户名已存在");
            request.getRequestDispatcher("/jsp/user/register.jsp").forward(request, response);
            return;
        }
        
        // 检查手机号是否已注册
        if (userDAO.getUserByPhone(phonenumber.trim()) != null) {
            request.setAttribute("error", "手机号已被注册");
            request.getRequestDispatcher("/jsp/user/register.jsp").forward(request, response);
            return;
        }
        
        try {
            // 创建用户对象
            User user = new User();
            user.setUsername(username.trim());
            user.setPassword(PasswordUtil.encryptPassword(password));
            user.setPhonenumber(phonenumber.trim());
            user.setAvatar("images/default-avatar.jpg");
            user.setGender(0);
            user.setCreateTime(LocalDateTime.now());
            user.setStatus(1);
            
            // 保存用户
            int result = userDAO.addUser(user);
            if (result > 0) {
                // 注册成功，跳转到登录页面
                response.sendRedirect(request.getContextPath() + "/user/login?success=1");
            } else {
                request.setAttribute("error", "注册失败，请稍后重试");
                request.getRequestDispatcher("/jsp/user/register.jsp").forward(request, response);
            }
            
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "系统错误，请稍后重试");
            request.getRequestDispatcher("/jsp/user/register.jsp").forward(request, response);
        }
    }
}