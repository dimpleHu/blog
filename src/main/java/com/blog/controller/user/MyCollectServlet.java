package com.blog.controller.user;

import com.blog.dao.FavoriteItemDAO;
import com.blog.dao.FolderDAO;
import com.blog.dao.ArticleDAO;
import com.blog.entity.Folder;
import com.blog.entity.FavoriteItem;
import com.blog.entity.User;
import com.blog.entity.Article;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

@WebServlet("/article/my-collect")
public class MyCollectServlet extends HttpServlet {
    private FolderDAO folderDAO = new FolderDAO();
    private FavoriteItemDAO favoriteItemDAO = new FavoriteItemDAO();
    private ArticleDAO articleDAO = new ArticleDAO(); // 用于查询文章详情
    // 时间格式化器（直接在Servlet内定义，不新增工具类）
    private static final DateTimeFormatter DATE_FORMATTER = DateTimeFormatter.ofPattern("yyyy.MM.dd");

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/jsp/user/login.jsp");
            return;
        }

        // 1. 查询用户所有收藏夹
        List<Folder> folders = folderDAO.getFoldersByUserId(user.getId());
        // 2. 用Map包装每个收藏夹的相关数据（不改动Folder实体类）
        List<Map<String, Object>> folderMapList = new ArrayList<>();

        for (Folder folder : folders) {
            Map<String, Object> folderMap = new HashMap<>();
            // 存储收藏夹本身
            folderMap.put("folder", folder);

            // 3. 查询收藏夹下的所有收藏项（FolderItem）
            List<FavoriteItem> favoriteItems = favoriteItemDAO.getFavoriteItemsByUserIdAndFolderId(folder.getUserId(),folder.getId());
            // 4. 根据收藏项的articleId查询文章详情
            List<Article> articles = favoriteItems.stream()
                    .map(item -> articleDAO.getArticleById(item.getArticleId()))
                    .filter(article -> article != null) // 过滤无效文章
                    .collect(Collectors.toList());

            // 5. 计算最近更新时间（取收藏项的最近创建时间，无收藏项则取收藏夹创建时间）
            String recentUpdateTime;
            if (!favoriteItems.isEmpty()) {
                LocalDateTime latestCreateTime = favoriteItems.stream()
                        .map(FavoriteItem::getCreateTime)
                        .max(LocalDateTime::compareTo)
                        .orElse(folder.getCreateTime());
                recentUpdateTime = latestCreateTime.format(DATE_FORMATTER);
            } else {
                recentUpdateTime = folder.getCreateTime().format(DATE_FORMATTER);
            }

            // 6. 存储文章列表和最近更新时间到Map
            folderMap.put("articles", articles);
            folderMap.put("recentUpdateTime", recentUpdateTime);

            folderMapList.add(folderMap);
        }

        // 7. 传递数据到JSP
        request.setAttribute("folderMapList", folderMapList);
        request.setAttribute("pageTitle", "我的收藏夹");
        request.getRequestDispatcher("/jsp/user/mycollect.jsp").forward(request, response);
    }
}