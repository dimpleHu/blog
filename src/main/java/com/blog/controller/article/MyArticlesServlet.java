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
    private static final int PAGE_SIZE = 10; // 每页显示10条

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/user/login");
            return;
        }

        try {
            // 获取页码参数，默认为1
            int page = 1;
            String pageStr = request.getParameter("page");
            if (pageStr != null && !pageStr.trim().isEmpty()) {
                try {
                    page = Integer.parseInt(pageStr);
                    if (page < 1) page = 1;
                } catch (NumberFormatException e) {
                    page = 1;
                }
            }

            // 获取总文章数
            int totalCount = articleDAO.getUserArticleCount(user.getId());
            int totalPages = (int) Math.ceil((double) totalCount / PAGE_SIZE);
            if (page > totalPages && totalPages > 0) {
                page = totalPages;
            }

            // 分页查询文章
            List<Article> articles = articleDAO.getArticlesByUserId(user.getId(), page, PAGE_SIZE);
            
            request.setAttribute("articles", articles);
            request.setAttribute("pageTitle", "我的文章");
            request.setAttribute("currentPage", page);
            request.setAttribute("totalPages", totalPages);
            request.setAttribute("totalCount", totalCount);
            request.setAttribute("pageSize", PAGE_SIZE);
            
            request.getRequestDispatcher("/jsp/user/myarticles.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "加载文章列表失败");
            request.getRequestDispatcher("/jsp/user/myarticles.jsp").forward(request, response);
        }
    }
}