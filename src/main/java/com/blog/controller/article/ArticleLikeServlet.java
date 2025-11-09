package com.blog.controller.article;

import com.blog.dao.ArticleDAO;
import com.blog.entity.User;
import com.blog.util.JDBCUtils;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

@WebServlet("/article/like")
public class ArticleLikeServlet extends HttpServlet {
    private ArticleDAO articleDAO = new ArticleDAO();

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // 设置响应类型为JSON
        response.setContentType("application/json;charset=UTF-8");
        PrintWriter out = response.getWriter();

        // 检查用户是否登录
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        if (user == null) {
            out.println("{\"success\": false, \"message\": \"请先登录\", \"code\": 401}");
            return;
        }

        // 获取文章ID参数
        String articleIdStr = request.getParameter("id");
        String action = request.getParameter("action"); // 新增：区分点赞/取消点赞

        if (articleIdStr == null || articleIdStr.trim().isEmpty()) {
            out.println("{\"success\": false, \"message\": \"文章ID不能为空\", \"code\": 400}");
            return;
        }

        try {
            int articleId = Integer.parseInt(articleIdStr);
            int userId = user.getId();

            // 检查文章是否存在
            if (articleDAO.getArticleById(articleId) == null) {
                out.println("{\"success\": false, \"message\": \"文章不存在\", \"code\": 404}");
                return;
            }

            // 根据action参数决定是点赞还是取消点赞
            int result;
            String message;

            if ("unlike".equals(action)) {
                // 取消点赞
                result = articleDAO.decreaseLikesWithCheck(articleId, userId);
                message = "取消点赞成功";
            } else {
                // 点赞
                // 检查用户是否已经点赞过
                if (articleDAO.hasUserLikedArticle(articleId, userId)) {
                    out.println("{\"success\": false, \"message\": \"您已经点赞过这篇文章了\", \"code\": 409}");
                    return;
                }
                result = articleDAO.increaseLikesWithCheck(articleId, userId);
                message = "点赞成功";
            }

            if (result > 0) {
                out.println("{\"success\": true, \"message\": \"" + message + "\", \"likes\": " + result + ", \"action\": \"" + ("unlike".equals(action) ? "unlike" : "like") + "\", \"code\": 200}");
            } else if (result == 0) {
                out.println("{\"success\": false, \"message\": \"取消成功\", \"code\": 409}");
            } else {
                out.println("{\"success\": false, \"message\": \"操作失败，请稍后重试\", \"code\": 500}");
            }

        } catch (NumberFormatException e) {
            out.println("{\"success\": false, \"message\": \"文章ID格式错误\", \"code\": 400}");
        } catch (Exception e) {
            e.printStackTrace();
            out.println("{\"success\": false, \"message\": \"系统错误: " + e.getMessage() + "\", \"code\": 500}");
        }
    }
}