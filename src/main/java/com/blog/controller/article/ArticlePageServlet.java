package com.blog.controller.article;

import com.blog.entity.User;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/article/*") // 匹配所有 /article/ 开头的请求（如 /article/drafts、/article/list）
public class ArticlePageServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException {
        // 1. 权限校验：未登录跳登录页（和发布文章、文章列表的权限逻辑一致）
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/user/login");
            return;
        }

        // 2. 提取路径参数（如 /article/drafts → path = "drafts"，/article/list → path = "list"）
        String path = request.getPathInfo();
        if (path == null || path.equals("/")) {
            path = "list"; // 默认跳文章列表页
        } else {
            path = path.substring(1); // 去掉路径开头的斜杠（如 "/drafts" → "drafts"）
        }

        // 3. 映射到对应的 JSP 物理路径（约定：/article/drafts → /jsp/article/drafts.jsp）
        String jspPath = "/jsp/article/" + path + ".jsp";
        try {
            // 4. 转发到目标 JSP 页面（保留 request 作用域数据，用户 URL 仍为 /article/xxx）
            request.getRequestDispatcher(jspPath).forward(request, response);
        } catch (Exception e) {
            // 页面不存在时跳 404（可自行创建 404.jsp 页面）
            response.sendRedirect(request.getContextPath() + "/article/404");
        }
    }
}