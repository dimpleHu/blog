package com.blog.controller.folder;

import com.blog.dao.FolderDAO;
import com.blog.entity.Folder;
import com.blog.entity.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.io.PrintWriter;

@WebServlet("/folder/create")
public class CreateFolderServlet extends HttpServlet {
    private FolderDAO folderDAO = new FolderDAO();

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("application/json;charset=UTF-8");
        PrintWriter out = response.getWriter();

        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        
        if (user == null) {
            out.println("{\"success\": false, \"message\": \"请先登录\", \"code\": 401}");
            return;
        }

        String name = request.getParameter("name");
        String description = request.getParameter("description");
        String isPublicStr = request.getParameter("isPublic");
        String isDefaultStr = request.getParameter("isDefault");

        if (name == null || name.trim().isEmpty()) {
            out.println("{\"success\": false, \"message\": \"收藏夹名称不能为空\", \"code\": 400}");
            return;
        }

        name = name.trim();
        if (name.length() > 15) {
            out.println("{\"success\": false, \"message\": \"收藏夹名称不能超过15个字符\", \"code\": 400}");
            return;
        }

        try {
            // 检查收藏夹名称是否已存在
            if (folderDAO.isFolderNameExists(user.getId(), name)) {
                out.println("{\"success\": false, \"message\": \"收藏夹名称已存在\", \"code\": 409}");
                return;
            }

            Folder folder = new Folder();
            folder.setUserId(user.getId());
            folder.setName(name);
            folder.setIsPublic("1".equals(isPublicStr) ? 1 : 0);
            folder.setItemCount(0);

            int result = folderDAO.createFolder(folder);

            if (result > 0) {
                out.println("{\"success\": true, \"message\": \"收藏夹创建成功\", \"folderId\": " + result + ", \"code\": 200}");
            } else {
                out.println("{\"success\": false, \"message\": \"收藏夹创建失败\", \"code\": 500}");
            }

        } catch (Exception e) {
            e.printStackTrace();
            out.println("{\"success\": false, \"message\": \"系统错误: \" + e.getMessage(), \"code\": 500}");
        }
    }
}