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

@WebServlet("/article/delete")
public class ArticleDeleteServlet extends HttpServlet {
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
                out.println("{\"success\": false, \"message\": \"文章不存在或您没有权限删除此文章\"}");
                return;
            }

            // 软删除文章（status改为2）
            int result = articleDAO.deleteArticle(articleId);
            
            if (result > 0) {
                out.println("{\"success\": true, \"message\": \"文章已删除\"}");
            } else {
                out.println("{\"success\": false, \"message\": \"删除失败，请重试\"}");
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

