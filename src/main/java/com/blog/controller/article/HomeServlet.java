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

@WebServlet({"/home", "/index", "/"})
public class HomeServlet extends HttpServlet {
    private ArticleDAO articleDAO = new ArticleDAO();

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            // 检查是否有搜索参数
            String keyword = request.getParameter("keyword");

            if (keyword != null && !keyword.trim().isEmpty()) {
                // 如果有搜索关键词，执行搜索
                List<Article> searchResults = articleDAO.searchArticles(keyword.trim());
                request.setAttribute("searchResults", searchResults);
                request.setAttribute("keyword", keyword.trim());
                request.setAttribute("resultCount", searchResults.size());

                // 转发到搜索结果页面
                request.getRequestDispatcher("/jsp/article/search.jsp").forward(request, response);
                return;
            }

            // 正常首页逻辑 - 关键修复：确保正确设置属性
            List<Article> hotArticles = articleDAO.getHotArticles(4);

            // 关键：必须设置到request属性中
            request.setAttribute("hotArticles", hotArticles);

            // 可选：添加其他数据
            List<Article> latestArticles = articleDAO.getLatestArticles(6);
            request.setAttribute("latestArticles", latestArticles);

            int totalArticles = articleDAO.getArticleCount();
            request.setAttribute("totalArticles", totalArticles);

            // 转发到首页
            request.getRequestDispatcher("/jsp/user/home.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "加载首页数据失败: " + e.getMessage());
            request.getRequestDispatcher("/jsp/user/home.jsp").forward(request, response);
        }
    }
}