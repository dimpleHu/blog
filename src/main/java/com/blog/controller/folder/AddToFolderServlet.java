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
import java.util.Enumeration;

@WebServlet("/folder/add")
public class AddToFolderServlet extends HttpServlet {
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

        // 调试：打印所有请求参数
        System.out.println("=== 请求参数调试开始 ===");
        Enumeration<String> paramNames = request.getParameterNames();
        while (paramNames.hasMoreElements()) {
            String paramName = paramNames.nextElement();
            String paramValue = request.getParameter(paramName);
            System.out.println("参数名: " + paramName + ", 参数值: " + paramValue);
        }
        System.out.println("=== 请求参数调试结束 ===");

        String articleIdStr = request.getParameter("articleId");
        String folderIdStr = request.getParameter("folderId");

        System.out.println("添加收藏 - 用户ID: " + user.getId() +
                ", 文章ID: " + articleIdStr +
                ", 收藏夹ID: " + folderIdStr);

        // 更严格的参数验证
        if (articleIdStr == null || folderIdStr == null ||
                articleIdStr.trim().isEmpty() || folderIdStr.trim().isEmpty()) {
            System.err.println("参数为空: articleId=" + articleIdStr + ", folderId=" + folderIdStr);
            out.println("{\"success\": false, \"message\": \"参数不能为空\", \"code\": 400}");
            return;
        }

        try {
            // 去除空格后转换
            int articleId = Integer.parseInt(articleIdStr.trim());
            int folderId = Integer.parseInt(folderIdStr.trim());
            int userId = user.getId();

            // 验证ID有效性
            if (articleId <= 0 || folderId <= 0) {
                System.err.println("参数无效: articleId=" + articleId + ", folderId=" + folderId);
                out.println("{\"success\": false, \"message\": \"参数无效\", \"code\": 400}");
                return;
            }

            System.out.println("参数验证通过，开始添加收藏...");

            int result = favoriteItemDAO.addToFolder(folderId, articleId, userId);

            if (result > 0) {
                System.out.println("收藏成功");
                out.println("{\"success\": true, \"message\": \"收藏成功\", \"code\": 200}");
            } else if (result == 0) {
                System.out.println("文章已在收藏夹中");
                out.println("{\"success\": false, \"message\": \"文章已在收藏夹中\", \"code\": 409}");
            } else {
                System.out.println("收藏失败");
                out.println("{\"success\": false, \"message\": \"收藏失败\", \"code\": 500}");
            }

        } catch (NumberFormatException e) {
            System.err.println("参数格式错误: " + e.getMessage());
            System.err.println("原始参数 - articleId: '" + articleIdStr + "', folderId: '" + folderIdStr + "'");
            out.println("{\"success\": false, \"message\": \"参数格式错误: \" + e.getMessage(), \"code\": 400}");
        } catch (Exception e) {
            e.printStackTrace();
            System.err.println("系统错误: " + e.getMessage());
            out.println("{\"success\": false, \"message\": \"系统错误: \" + e.getMessage(), \"code\": 500}");
        }
    }
}