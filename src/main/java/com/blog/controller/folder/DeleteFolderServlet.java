package com.blog.controller.folder;

import com.blog.dao.FolderDAO;
import com.blog.entity.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.io.PrintWriter;

/**
 * 删除收藏夹Servlet
 */
@WebServlet("/folder/delete")
public class DeleteFolderServlet extends HttpServlet {
    private FolderDAO folderDAO = new FolderDAO();
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        request.setCharacterEncoding("UTF-8");
        response.setContentType("application/json;charset=UTF-8");
        response.setCharacterEncoding("UTF-8");
        
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        
        PrintWriter out = response.getWriter();
        
        // 检查用户是否登录
        if (user == null) {
            out.println("{\"success\": false, \"message\": \"请先登录\"}");
            out.flush();
            return;
        }
        
        try {
            String folderIdStr = request.getParameter("folderId");
            if (folderIdStr == null || folderIdStr.trim().isEmpty()) {
                out.println("{\"success\": false, \"message\": \"收藏夹ID不能为空\"}");
                out.flush();
                return;
            }
            
            int folderId = Integer.parseInt(folderIdStr);
            
            // 删除收藏夹（会级联删除收藏项）
            int result = folderDAO.deleteFolder(folderId, user.getId());
            
            if (result > 0) {
                out.println("{\"success\": true, \"message\": \"收藏夹删除成功\"}");
            } else {
                out.println("{\"success\": false, \"message\": \"删除失败，收藏夹不存在或无权限\"}");
            }
            
        } catch (NumberFormatException e) {
            out.println("{\"success\": false, \"message\": \"收藏夹ID格式错误\"}");
        } catch (Exception e) {
            e.printStackTrace();
            out.println("{\"success\": false, \"message\": \"删除失败：" + e.getMessage() + "\"}");
        } finally {
            out.flush();
        }
    }
}

