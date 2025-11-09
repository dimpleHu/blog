package com.blog.controller.user;

import com.blog.dao.UserDAO;
import com.blog.entity.User;
import com.blog.util.PasswordUtil;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.time.LocalDateTime;

@WebServlet("/user/login")
public class LoginServlet extends HttpServlet {
    private UserDAO userDAO = new UserDAO();

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // 如果已经登录，跳转到首页
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        if (user != null && user.getId() != null) {
            response.sendRedirect(request.getContextPath() + "/user/home");
            return;
        }
        
        // 转发到登录页面
        request.getRequestDispatcher("/jsp/user/login.jsp").forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        
        // 验证输入
        if (username == null || username.trim().isEmpty() || 
            password == null || password.trim().isEmpty()) {
            request.setAttribute("error", "用户名和密码不能为空");
            request.getRequestDispatcher("/jsp/user/login.jsp").forward(request, response);
            return;
        }
        
        try {
            // 查询用户
            User user = userDAO.getUserByUsername(username.trim());
            if (user == null) {
                request.setAttribute("error", "用户名或密码错误");
                request.setAttribute("username", username);
                request.getRequestDispatcher("/jsp/user/login.jsp").forward(request, response);
                return;
            }
            
            // 验证密码
            if (!PasswordUtil.verifyPassword(password, user.getPassword())) {
                request.setAttribute("error", "用户名或密码错误");
                request.setAttribute("username", username);
                request.getRequestDispatcher("/jsp/user/login.jsp").forward(request, response);
                return;
            }
            
            // 检查用户状态
            if (user.getStatus() != null && user.getStatus() == 0) {
                request.setAttribute("error", "账户已被禁用，请联系管理员");
                request.setAttribute("username", username);
                request.getRequestDispatcher("/jsp/user/login.jsp").forward(request, response);
                return;
            }
            
            // 登录成功，设置session
            HttpSession session = request.getSession();
            session.setAttribute("user", user);
            session.setMaxInactiveInterval(30 * 60); // 30分钟超时
            
            // 更新最后登录时间
            user.setLastLoginTime(LocalDateTime.now());
            userDAO.updateLastLoginTime(user.getId());
            
            // 重定向到首页
            response.sendRedirect(request.getContextPath() + "/user/home");
            
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "系统错误，请稍后重试");
            request.getRequestDispatcher("/jsp/user/login.jsp").forward(request, response);
        }
    }
}