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

@WebServlet("/article/delete-draft")
public class DeleteDraftServlet extends HttpServlet {
    private ArticleDAO articleDAO = new ArticleDAO();

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // 检查用户是否登录
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/user/login");
            return;
        }

        try {
            String idStr = request.getParameter("id");
            if (idStr == null || idStr.trim().isEmpty()) {
                session.setAttribute("error", "草稿ID不能为空");
                response.sendRedirect(request.getContextPath() + "/article/drafts");
                return;
            }

            int draftId = Integer.parseInt(idStr);
            
            // 删除草稿（确保是当前用户的草稿）
            int result = articleDAO.deleteDraft(draftId, user.getId());
            
            if (result > 0) {
                session.setAttribute("message", "草稿删除成功");
            } else {
                session.setAttribute("error", "删除失败，草稿不存在或无权删除");
            }
            
            // 重定向到草稿箱页面
            response.sendRedirect(request.getContextPath() + "/article/drafts");
            
        } catch (NumberFormatException e) {
            session.setAttribute("error", "草稿ID格式错误");
            response.sendRedirect(request.getContextPath() + "/article/drafts");
        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("error", "删除草稿时发生错误");
            response.sendRedirect(request.getContextPath() + "/article/drafts");
        }
    }
}

