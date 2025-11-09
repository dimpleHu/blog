package com.blog.controller.user;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/user/logout")
public class LogoutServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // 获取session，如果不存在则不创建新的
        HttpSession session = request.getSession(false);
        if (session != null) {
            // 移除用户信息
            session.removeAttribute("user");
            // 使session失效
            session.invalidate();
        }
        // 重定向到登录页面
        response.sendRedirect(request.getContextPath() + "/user/login");
    }
}