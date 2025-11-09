package com.blog.dao;

import com.blog.entity.FavoriteItem;
import com.blog.entity.Article;
import com.blog.entity.Folder;
import com.blog.entity.User;
import java.util.List;

public class FavoriteItemDAO extends BaseDAO {

    /**
     * 添加文章到收藏夹
     */
    public int addToFolder(int folderId, int articleId, int userId) {
        // 步骤1：校验收藏夹是否属于当前用户
        FolderDAO folderDAO = new FolderDAO();
        Folder folder = folderDAO.getFolderById(folderId);
        if (folder == null || folder.getUserId() != userId) {
            return -1; // 收藏夹不存在或不属于当前用户
        }

        // 步骤2：校验文章是否已在收藏夹中
        if (isArticleInFolder(articleId, userId, folderId)) {
            return 0; // 已收藏
        }

        // 步骤3：执行插入操作
        String sql = "INSERT INTO favorite_item (folder_id, article_id, user_id, create_time) VALUES (?, ?, ?, NOW())";
        int result = executeUpdate(sql, folderId, articleId, userId);

        if (result > 0) {
            folderDAO.updateFolderItemCount(folderId); // 更新收藏夹项目数
        }

        return result;
    }


    /**
     * 从收藏夹移除文章
     */
    public int removeFromFolder(int folderId, int articleId, int userId) {
        String sql = "DELETE FROM favorite_item WHERE folder_id = ? AND article_id = ? AND user_id = ?";
        int result = executeUpdate(sql, folderId, articleId, userId);
        
        if (result > 0) {
            // 更新收藏夹项目数量
            FolderDAO folderDAO = new FolderDAO();
            folderDAO.updateFolderItemCount(folderId);
        }
        
        return result;
    }

    /**
     * 检查文章是否在收藏夹中
     */
    public boolean isArticleInFolder(int articleId, int userId, Integer folderId) {
        String sql = "SELECT COUNT(*) FROM favorite_item WHERE article_id = ? AND user_id = ?";
        if (folderId != null) {
            sql += " AND folder_id = ?";
            Integer count = executeQueryForSingleValue(sql, Integer.class, articleId, userId, folderId);
            return count != null && count > 0;
        } else {
            Integer count = executeQueryForSingleValue(sql, Integer.class, articleId, userId);
            return count != null && count > 0;
        }
    }

    /**
     * 检查用户是否收藏过文章（任何收藏夹）
     */
    public boolean hasUserFavoritedArticle(int articleId, int userId) {
        return isArticleInFolder(articleId, userId, null);
    }

    /**
     * 获取用户收藏的文章列表
     */
    public List<FavoriteItem> getFavoriteArticlesByUserId(int userId) {
        String sql = "SELECT fi.*, a.title, a.summary, a.post_time, a.hits, a.likes, " +
                "u.username as author_username, u.avatar as author_avatar, " +
                "f.name as folder_name " +
                "FROM favorite_item fi " +
                "LEFT JOIN article a ON fi.article_id = a.id " +
                "LEFT JOIN user u ON a.user_id = u.id " +
                "LEFT JOIN folder f ON fi.folder_id = f.id " +
                "WHERE fi.user_id = ? AND a.status = ? " +
                "ORDER BY fi.create_time DESC";
        return executeQuery(sql, FavoriteItem.class, userId, ArticleDAO.STATUS_PUBLISHED);
    }

    /**
     * 获取收藏夹中的文章列表
     */
    public List<FavoriteItem> getArticlesInFolder(int folderId) {
        String sql = "SELECT fi.*, a.title, a.summary, a.post_time, a.hits, a.likes, " +
                "u.username as author_username, u.avatar as author_avatar " +
                "FROM favorite_item fi " +
                "LEFT JOIN article a ON fi.article_id = a.id " +
                "LEFT JOIN user u ON a.user_id = u.id " +
                "WHERE fi.folder_id = ? AND a.status = ? " +
                "ORDER BY fi.create_time DESC";
        return executeQuery(sql, FavoriteItem.class, folderId, ArticleDAO.STATUS_PUBLISHED);
    }

    /**
     * 获取文章所在的收藏夹
     */
    public List<Folder> getFoldersContainingArticle(int articleId, int userId) {
        String sql = "SELECT f.* FROM folder f " +
                "INNER JOIN favorite_item fi ON f.id = fi.folder_id " +
                "WHERE fi.article_id = ? AND fi.user_id = ?";
        return executeQuery(sql, Folder.class, articleId, userId);
    }

    /**
     * 根据用户ID和收藏夹ID获取收藏项列表
     */
//    public List<FavoriteItem> getFavoriteArticlesByUserIdAndFolderId(int userId, int folderId) {
//        String sql = "SELECT fi.*, a.title, a.post_time as article_create_time, " +
//                "u.username as author_username " +
//                "FROM favorite_item fi " +
//                "LEFT JOIN article a ON fi.article_id = a.id " +
//                "LEFT JOIN user u ON a.user_id = u.id " +
//                "WHERE fi.user_id = ? AND fi.folder_id = ? AND a.status = ? " +
//                "ORDER BY fi.create_time DESC";
//        return executeQuery(sql, FavoriteItem.class, userId, folderId, ArticleDAO.STATUS_PUBLISHED);
//    }

    /**
     * 根据用户ID和收藏夹ID获取收藏项列表
     */
    public List<FavoriteItem> getFavoriteItemsByUserIdAndFolderId(int userId, int folderId) {
        String sql = "SELECT fi.* FROM favorite_item fi " +
                "WHERE fi.user_id = ? AND fi.folder_id = ? " +
                "ORDER BY fi.create_time DESC";
        return executeQuery(sql, FavoriteItem.class, userId, folderId);
    }

    /**
     * 获取用户的收藏总数（所有收藏夹中的文章总数）
     */
    public int getUserFavoriteCount(int userId) {
        String sql = "SELECT COUNT(DISTINCT article_id) FROM favorite_item WHERE user_id = ?";
        Integer count = executeQueryForSingleValue(sql, Integer.class, userId);
        return count != null ? count : 0;
    }
}