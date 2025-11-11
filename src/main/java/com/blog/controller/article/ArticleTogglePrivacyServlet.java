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

@WebServlet("/article/toggle-privacy")
public class ArticleTogglePrivacyServlet extends HttpServlet {
    private ArticleDAO articleDAO = new ArticleDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        response.setContentType("application/json;charset=UTF-8");
        
        PrintWriter out = response.getWriter();
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        
        if (user == null) {
            out.println("{\"success\": false, \"message\": \"请先登录\"}");
            return;
        }

        try {
            String articleIdStr = request.getParameter("articleId");
            if (articleIdStr == null || articleIdStr.trim().isEmpty()) {
                out.println("{\"success\": false, \"message\": \"文章ID不能为空\"}");
                return;
            }

            int articleId = Integer.parseInt(articleIdStr);
            
            // 验证文章是否属于当前用户（查询任意状态的文章）
            com.blog.entity.Article article = articleDAO.getArticleByIdForUser(articleId, user.getId());
            if (article == null) {
                out.println("{\"success\": false, \"message\": \"文章不存在或您没有权限修改此文章\"}");
                return;
            }

            // 切换状态：1（公开）<-> 3（私密）
            int currentStatus = article.getStatus();
            int newStatus;
            String message;
            
            if (currentStatus == ArticleDAO.STATUS_PUBLISHED) {
                // 当前是公开，改为私密
                newStatus = ArticleDAO.STATUS_PRIVATE;
                message = "文章已设为私密";
            } else if (currentStatus == ArticleDAO.STATUS_PRIVATE) {
                // 当前是私密，改为公开
                newStatus = ArticleDAO.STATUS_PUBLISHED;
                message = "文章已设为公开";
            } else {
                out.println("{\"success\": false, \"message\": \"文章状态不支持此操作\"}");
                return;
            }

            // 更新文章状态
            int result = articleDAO.updateArticleStatus(articleId, newStatus);
            
            if (result > 0) {
                out.println("{\"success\": true, \"message\": \"" + message + "\", \"newStatus\": " + newStatus + "}");
            } else {
                out.println("{\"success\": false, \"message\": \"操作失败，请重试\"}");
            }

        } catch (NumberFormatException e) {
            out.println("{\"success\": false, \"message\": \"文章ID格式错误\"}");
        } catch (Exception e) {
            e.printStackTrace();
            out.println("{\"success\": false, \"message\": \"系统错误: " + e.getMessage() + "\"}");
        } finally {
            out.close();
        }
    }
}

