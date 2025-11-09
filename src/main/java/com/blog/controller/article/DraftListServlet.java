package com.blog.controller.article;

import com.blog.dao.ArticleDAO;
import com.blog.entity.Article;
import com.blog.entity.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

@WebServlet("/article/drafts")
public class DraftListServlet extends HttpServlet {
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
            System.out.println("=== 草稿箱调试信息 ===");
            System.out.println("当前用户ID: " + user.getId());
            System.out.println("当前用户名: " + user.getUsername());

            // 获取草稿列表
            List<Article> drafts = articleDAO.getDraftsByUserId(user.getId());
            request.setAttribute("drafts", drafts);

            if (drafts != null && !drafts.isEmpty()) {
                for (Article draft : drafts) {
                    System.out.println("草稿ID: " + draft.getId() + ", 标题: " + draft.getTitle() + ", 状态: " + draft.getStatus());
                }
            } else {
                System.out.println("没有查询到草稿数据");
            }

            // 获取草稿数量
            int draftCount = articleDAO.getUserDraftCount(user.getId());
            request.setAttribute("draftCount", draftCount);

            System.out.println("设置到request的drafts: " + (drafts != null ? drafts.size() : 0));
            System.out.println("设置到request的draftCount: " + draftCount);

            // 转发到草稿箱页面
            request.getRequestDispatcher("/jsp/article/drafts.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "获取草稿列表失败");
            request.getRequestDispatcher("/jsp/article/drafts.jsp").forward(request, response);
        }
    }
}