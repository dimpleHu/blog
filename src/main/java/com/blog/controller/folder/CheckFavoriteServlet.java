package com.blog.controller.folder;

import com.blog.dao.FavoriteItemDAO;
import com.blog.entity.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.io.PrintWriter;

@WebServlet("/folder/check-favorite")
public class CheckFavoriteServlet extends HttpServlet {
    private FavoriteItemDAO favoriteItemDAO = new FavoriteItemDAO();

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("application/json;charset=UTF-8");
        PrintWriter out = response.getWriter();

        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        
        if (user == null) {
            out.println("{\"success\": false, \"message\": \"请先登录\", \"code\": 401}");
            return;
        }

        String articleIdStr = request.getParameter("articleId");
        if (articleIdStr == null || articleIdStr.trim().isEmpty()) {
            out.println("{\"success\": false, \"message\": \"文章ID不能为空\", \"code\": 400}");
            return;
        }

        try {
            int articleId = Integer.parseInt(articleIdStr);
            int userId = user.getId();

            boolean hasFavorited = favoriteItemDAO.hasUserFavoritedArticle(articleId, userId);

            out.println("{\"success\": true, \"hasFavorited\": " + hasFavorited + ", \"code\": 200}");

        } catch (NumberFormatException e) {
            out.println("{\"success\": false, \"message\": \"文章ID格式错误\", \"code\": 400}");
        } catch (Exception e) {
            e.printStackTrace();
            out.println("{\"success\": false, \"message\": \"系统错误\", \"code\": 500}");
        }
    }
}