package com.blog.controller.user;

import com.blog.dao.ArticleDAO;
import com.blog.dao.UserDAO;
import com.blog.entity.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.io.PrintWriter;

@WebServlet("/user/stats")
public class UserStatsServlet extends HttpServlet {
    private ArticleDAO articleDAO = new ArticleDAO();
    private UserDAO userDAO = new UserDAO();

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("application/json;charset=UTF-8");
        PrintWriter out = response.getWriter();

        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        if (user == null) {
            out.println("{\"success\": false, \"message\": \"用户未登录\"}");
            return;
        }

        try {
            int userId = user.getId();
            
            // 获取用户文章数量
            int articleCount = articleDAO.getUserArticleCount(userId);
            
            // 获取用户草稿数量
            int draftCount = articleDAO.getUserDraftCount(userId);
            
            // 获取收藏数量（需要实现收藏功能）
            int collectCount = getCollectCount(userId);

            out.println("{\"success\": true, " +
                       "\"articleCount\": " + articleCount + ", " +
                       "\"draftCount\": " + draftCount + ", " +
                       "\"collectCount\": " + collectCount + "}");

        } catch (Exception e) {
            e.printStackTrace();
            out.println("{\"success\": false, \"message\": \"获取统计信息失败\"}");
        }
    }

    private int getCollectCount(int userId) {
        // 这里需要实现收藏功能后完善
        // 暂时返回0
        return 0;
    }
}