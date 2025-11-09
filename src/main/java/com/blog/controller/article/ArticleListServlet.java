package com.blog.controller.article;

import com.blog.dao.ArticleDAO;
import com.blog.entity.Article;
import com.blog.entity.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

@WebServlet("/article/list")
public class ArticleListServlet extends HttpServlet {
    private ArticleDAO articleDAO = new ArticleDAO();

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // 检查用户是否登录
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/user/login");
            return;
        }
        
        try {
            // 获取文章列表
            List<Article> articles = articleDAO.getArticlesByUserId(user.getId());
            request.setAttribute("articles", articles);
            
            // 获取用户文章数量
            int articleCount = articleDAO.getUserArticleCount(user.getId());
            request.setAttribute("articleCount", articleCount);
            
            // 转发到文章列表页面
            request.getRequestDispatcher("/jsp/article/list.jsp").forward(request, response);
            
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "获取文章列表失败");
            request.getRequestDispatcher("/jsp/article/list.jsp").forward(request, response);
        }
    }
}


