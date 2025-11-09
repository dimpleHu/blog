package com.blog.controller.folder;

import com.blog.dao.FolderDAO;
import com.blog.dao.FavoriteItemDAO;
import com.blog.entity.Folder;
import com.blog.entity.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

@WebServlet("/folder/list")
public class FolderListServlet extends HttpServlet {
    private FolderDAO folderDAO = new FolderDAO();
    private FavoriteItemDAO favoriteItemDAO = new FavoriteItemDAO();

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/jsp/user/login.jsp");
            return;
        }

        try {
            String articleIdStr = request.getParameter("articleId");
            Integer articleId = null;
            if (articleIdStr != null && !articleIdStr.trim().isEmpty()) {
                articleId = Integer.parseInt(articleIdStr);
            }

            System.out.println("获取收藏夹列表 - 用户ID: " + user.getId() + ", 文章ID: " + articleId);

            // 获取用户的所有收藏夹
            List<Folder> allFolders = folderDAO.getFoldersByUserId(user.getId());
            System.out.println("获取到收藏夹数量: " + (allFolders != null ? allFolders.size() : 0));

            // 获取最近使用的收藏夹（最近4个）
            List<Folder> recentFolders = folderDAO.getRecentFoldersByUserId(user.getId(), 4);
            System.out.println("获取到最近收藏夹数量: " + (recentFolders != null ? recentFolders.size() : 0));

            // 合并收藏夹列表，标记最近使用的收藏夹
            if (allFolders != null) {
                // 标记最近使用的收藏夹
                if (recentFolders != null) {
                    for (Folder folder : allFolders) {
                        // 检查是否是最近使用的收藏夹
                        boolean isRecent = recentFolders.stream()
                                .anyMatch(recent -> recent.getId().equals(folder.getId()));

                        // 设置recent字段
                        folder.setRecent(isRecent);
                    }
                }

                // 如果传入了文章ID，检查文章是否已经在各个收藏夹中
                if (articleId != null) {
                    for (Folder folder : allFolders) {
                        boolean isInFolder = favoriteItemDAO.isArticleInFolder(articleId, user.getId(), folder.getId());
                        folder.setIsInFolder(isInFolder ? 1 : 0);
                        System.out.println("收藏夹 " + folder.getName() + " 是否包含文章: " + isInFolder);
                    }
                }
            }

            request.setAttribute("allFolders", allFolders);
            request.setAttribute("articleId", articleId);
            request.setAttribute("totalFolderCount", allFolders != null ? allFolders.size() : 0);

            // 调试信息
            if (allFolders != null) {
                for (Folder folder : allFolders) {
                    System.out.println("收藏夹: " + folder.getName() +
                            ", 项目数: " + folder.getItemCount() +
                            ", 是否包含文章: " + folder.getIsInFolder() +
                            ", 是否最近: " + folder.isRecentFolder());
                }
            }

            // 修正路径：使用正确的JSP路径
            String jspPath = "/jsp/collect/show.jsp";
            System.out.println("转发到JSP: " + jspPath);
            request.getRequestDispatcher(jspPath).forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            System.err.println("获取收藏夹列表失败: " + e.getMessage());
            request.setAttribute("error", "获取收藏夹列表失败: " + e.getMessage());
            request.getRequestDispatcher("/jsp/collect/show.jsp").forward(request, response);
        }
    }
}