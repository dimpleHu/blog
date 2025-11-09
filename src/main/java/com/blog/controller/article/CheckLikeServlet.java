package com.blog.controller.article;

import com.blog.dao.ArticleDAO;
import com.blog.entity.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.io.PrintWriter;

@WebServlet("/article/check-like")
public class CheckLikeServlet extends HttpServlet {
    private ArticleDAO articleDAO = new ArticleDAO();

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("application/json;charset=UTF-8");
        PrintWriter out = response.getWriter();

        String articleIdStr = request.getParameter("id");
        if (articleIdStr == null || articleIdStr.trim().isEmpty()) {
            out.println("{\"success\": false, \"message\": \"文章ID不能为空\"}");
            return;
        }

        try {
            int articleId = Integer.parseInt(articleIdStr);
            
            HttpSession session = request.getSession();
            User user = (User) session.getAttribute("user");
            
            boolean hasLiked = false;
            if (user != null) {
                hasLiked = articleDAO.hasUserLikedArticle(articleId, user.getId());
            }

            out.println("{\"success\": true, \"hasLiked\": " + hasLiked + "}");

        } catch (NumberFormatException e) {
            out.println("{\"success\": false, \"message\": \"文章ID格式错误\"}");
        } catch (Exception e) {
            e.printStackTrace();
            out.println("{\"success\": false, \"message\": \"系统错误\"}");
        }
    }
}