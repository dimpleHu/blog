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

@WebServlet("/folder/remove")
public class RemoveFromFolderServlet extends HttpServlet {
    private FavoriteItemDAO favoriteItemDAO = new FavoriteItemDAO();

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("application/json;charset=UTF-8");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();

        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        
        if (user == null) {
            out.println("{\"success\": false, \"message\": \"请先登录\", \"code\": 401}");
            return;
        }

        String articleIdStr = request.getParameter("articleId");
        String folderIdStr = request.getParameter("folderId");

        System.out.println("取消收藏 - 用户ID: " + user.getId() + 
                ", 文章ID: " + articleIdStr + 
                ", 收藏夹ID: " + folderIdStr);

        if (articleIdStr == null || folderIdStr == null) {
            out.println("{\"success\": false, \"message\": \"参数不能为空\", \"code\": 400}");
            return;
        }

        try {
            int articleId = Integer.parseInt(articleIdStr);
            int folderId = Integer.parseInt(folderIdStr);
            int userId = user.getId();

            // 检查是否已经收藏
            if (!favoriteItemDAO.isArticleInFolder(articleId, userId, folderId)) {
                out.println("{\"success\": false, \"message\": \"文章未在收藏夹中\", \"code\": 404}");
                return;
            }

            int result = favoriteItemDAO.removeFromFolder(folderId, articleId, userId);

            if (result > 0) {
                System.out.println("取消收藏成功");
                out.println("{\"success\": true, \"message\": \"取消收藏成功\", \"code\": 200}");
            } else {
                System.out.println("取消收藏失败");
                out.println("{\"success\": false, \"message\": \"取消收藏失败\", \"code\": 500}");
            }

        } catch (NumberFormatException e) {
            System.err.println("参数格式错误: " + e.getMessage());
            out.println("{\"success\": false, \"message\": \"参数格式错误\", \"code\": 400}");
        } catch (Exception e) {
            e.printStackTrace();
            System.err.println("系统错误: " + e.getMessage());
            out.println("{\"success\": false, \"message\": \"系统错误: \" + e.getMessage(), \"code\": 500}");
        }
    }
}