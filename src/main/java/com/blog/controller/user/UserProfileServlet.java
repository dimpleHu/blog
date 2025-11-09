package com.blog.controller.user;

import com.blog.dao.ArticleDAO;
import com.blog.dao.CommentDAO;
import com.blog.dao.FavoriteItemDAO;
import com.blog.entity.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/user/profile")
public class UserProfileServlet extends HttpServlet {
    private ArticleDAO articleDAO = new ArticleDAO();
    private CommentDAO commentDAO = new CommentDAO();
    private FavoriteItemDAO favoriteItemDAO = new FavoriteItemDAO();

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/user/login");
            return;
        }

        try {
            // 获取用户统计数据
            int articleCount = articleDAO.getUserArticleCount(user.getId());
            int commentCount = commentDAO.getUserCommentCount(user.getId());
            int collectCount = favoriteItemDAO.getUserFavoriteCount(user.getId());

            request.setAttribute("articleCount", articleCount);
            request.setAttribute("commentCount", commentCount);
            request.setAttribute("collectCount", collectCount);
            request.setAttribute("pageTitle", "个人信息");
            
            // 转发到JSP页面
            request.getRequestDispatcher("/jsp/user/profile.jsp").forward(request, response);
            
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "加载用户信息失败");
            request.getRequestDispatcher("/jsp/user/profile.jsp").forward(request, response);
        }
    }
}