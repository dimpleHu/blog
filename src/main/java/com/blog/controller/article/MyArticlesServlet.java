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

@WebServlet("/article/my-articles")
public class MyArticlesServlet extends HttpServlet {
    private ArticleDAO articleDAO = new ArticleDAO();

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/user/login");
            return;
        }

        try {
            List<Article> articles = articleDAO.getArticlesByUserId(user.getId());
            request.setAttribute("articles", articles);
            request.setAttribute("pageTitle", "我的文章");
            
            request.getRequestDispatcher("/jsp/user/myarticles.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "加载文章列表失败");
            request.getRequestDispatcher("/jsp/user/myarticles.jsp").forward(request, response);
        }
    }
}