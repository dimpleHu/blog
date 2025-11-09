package com.blog.dao;

import com.blog.entity.Folder;
import com.blog.entity.FavoriteItem;
import com.blog.entity.User;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.List;

public class FolderDAO extends BaseDAO {

    /**
     * 创建收藏夹
     */
    public int createFolder(Folder folder) {
        String sql = "INSERT INTO folder (user_id, name, is_public, create_time) VALUES (?, ?, ?, NOW())";
        return executeUpdate(sql, folder.getUserId(), folder.getName(), folder.getIsPublic());
    }

    /**
     * 根据ID获取收藏夹
     */
    public Folder getFolderById(int folderId) {
        String sql = "SELECT f.*, u.username, u.avatar FROM folder f " +
                "LEFT JOIN user u ON f.user_id = u.id WHERE f.id = ?";
        return executeQueryForObject(sql, Folder.class, folderId);
    }

    /**
     * 获取用户的所有收藏夹
     */
    public List<Folder> getFoldersByUserId(int userId) {
        String sql = "SELECT f.*, u.username, u.avatar FROM folder f " +
                "LEFT JOIN user u ON f.user_id = u.id " +
                "WHERE f.user_id = ? ORDER BY f.create_time DESC";
        return executeQuery(sql, Folder.class, userId);
    }

    /**
     * 分页获取用户的所有收藏夹
     */
    public List<Folder> getFoldersByUserId(int userId, int page, int pageSize) {
        String sql = "SELECT f.*, u.username, u.avatar FROM folder f " +
                "LEFT JOIN user u ON f.user_id = u.id " +
                "WHERE f.user_id = ? ORDER BY f.create_time DESC LIMIT ?, ?";
        int start = (page - 1) * pageSize;
        return executeQuery(sql, Folder.class, userId, start, pageSize);
    }

    /**
     * 获取用户的收藏夹总数
     */
    public int getUserFolderCount(int userId) {
        String sql = "SELECT COUNT(*) FROM folder WHERE user_id = ?";
        Integer count = executeQueryForSingleValue(sql, Integer.class, userId);
        return count != null ? count : 0;
    }

    /**
     * 获取用户最近使用的收藏夹
     */
    public List<Folder> getRecentFoldersByUserId(int userId, int limit) {
        String sql = "SELECT f.*, u.username, u.avatar FROM folder f " +
                "LEFT JOIN user u ON f.user_id = u.id " +
                "WHERE f.user_id = ? ORDER BY f.create_time DESC LIMIT ?";
        return executeQuery(sql, Folder.class, userId, limit);
    }

    /**
     * 更新收藏夹
     */
    public int updateFolder(Folder folder) {
        String sql = "UPDATE folder SET name=?, is_public=? WHERE id=? AND user_id=?";
        return executeUpdate(sql, folder.getName(), folder.getIsPublic(), folder.getId(), folder.getUserId());
    }

    /**
     * 删除收藏夹
     */
    public int deleteFolder(int folderId, int userId) {
        // 先删除收藏夹中的项目
        String deleteItemsSql = "DELETE FROM favorite_item WHERE folder_id = ?";
        executeUpdate(deleteItemsSql, folderId);
        
        // 再删除收藏夹
        String sql = "DELETE FROM folder WHERE id = ? AND user_id = ?";
        return executeUpdate(sql, folderId, userId);
    }

    /**
     * 检查收藏夹名称是否已存在
     */
    public boolean isFolderNameExists(int userId, String folderName) {
        String sql = "SELECT COUNT(*) FROM folder WHERE user_id = ? AND name = ?";
        Integer count = executeQueryForSingleValue(sql, Integer.class, userId, folderName);
        return count != null && count > 0;
    }

    /**
     * 获取收藏夹中的项目数量
     */
    public int getFolderItemCount(int folderId) {
        String sql = "SELECT COUNT(*) FROM favorite_item WHERE folder_id = ?";
        Integer count = executeQueryForSingleValue(sql, Integer.class, folderId);
        return count != null ? count : 0;
    }

    /**
     * 更新收藏夹项目数量
     */
    public int updateFolderItemCount(int folderId) {
        String sql = "UPDATE folder SET item_count = (SELECT COUNT(*) FROM favorite_item WHERE folder_id = ?) WHERE id = ?";
        return executeUpdate(sql, folderId, folderId);
    }
}