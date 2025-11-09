package com.blog.dao;

import com.blog.entity.Comment;
import java.util.List;

public class CommentDAO extends BaseDAO {
    
    /**
     * 添加评论
     */
    public int addComment(Comment comment) {
        String sql = "INSERT INTO comment (content, user_id, article_id, parent_id, create_time, likes) VALUES (?, ?, ?, ?, NOW(), 0)";
        return executeUpdate(sql, comment.getContent(), comment.getUserId(), comment.getArticleId(), 
                comment.getParentId() != null ? comment.getParentId() : 0);
    }
    
    /**
     * 根据文章ID获取评论列表（只返回顶级评论，回复通过replies属性加载）
     */
    public List<Comment> getCommentsByArticleId(int articleId) {
        // 只查询顶级评论（parent_id = 0 或 parent_id IS NULL）
        // 修复：避免字段冲突，使用 u.username 和 u.avatar 而不是 u.id
        String sql = "SELECT c.*, u.username, u.avatar " +
                "FROM comment c " +
                "LEFT JOIN user u ON c.user_id = u.id " +
                "WHERE c.article_id = ? AND c.status = 1 " +
                "AND (c.parent_id = 0 OR c.parent_id IS NULL) " +
                "ORDER BY c.create_time DESC";

        List<Comment> comments = executeQuery(sql, Comment.class, articleId);

        // 为每个评论的回复也加载用户信息
        if (comments != null) {
            for (Comment comment : comments) {
                List<Comment> replies = getRepliesByCommentId(comment.getId());
                comment.setReplies(replies);
            }
        }

        return comments;
    }
    
    /**
     * 获取评论的回复列表
     */
    public List<Comment> getRepliesByCommentId(int commentId) {
        // 关联回复的用户信息
        // 修复：避免字段冲突，使用 u.username 和 u.avatar 而不是 u.id
        String sql = "SELECT c.*, u.username, u.avatar " +
                "FROM comment c " +
                "LEFT JOIN user u ON c.user_id = u.id " +
                "WHERE c.parent_id = ? AND c.status = 1 " +
                "ORDER BY c.create_time ASC";
        return executeQuery(sql, Comment.class, commentId);
    }
    
    /**
     * 获取评论数量
     */
    public int getCommentCountByArticleId(int articleId) {
        String sql = "SELECT COUNT(*) FROM comment WHERE article_id = ? AND status = 1";
        Integer count = executeQueryForSingleValue(sql, Integer.class, articleId);
        return count != null ? count : 0;
    }

    /**
     * 获取用户的评论总数（包括回复）
     */
    public int getUserCommentCount(int userId) {
        String sql = "SELECT COUNT(*) FROM comment WHERE user_id = ? AND status = 1";
        Integer count = executeQueryForSingleValue(sql, Integer.class, userId);
        return count != null ? count : 0;
    }
    
    /**
     * 根据ID获取评论
     */
    public Comment getCommentById(int commentId) {
        String sql = "SELECT c.*, u.username, u.avatar FROM comment c " +
                "LEFT JOIN user u ON c.user_id = u.id WHERE c.id = ?";
        return executeQueryForObject(sql, Comment.class, commentId);
    }
    
    /**
     * 删除评论（软删除，级联删除子回复）
     * @param commentId 评论ID
     * @param userId 用户ID（确保只能删除自己的评论）
     * @return 删除的行数
     */
    public int deleteComment(int commentId, int userId) {
        // 先检查评论是否存在且属于该用户
        Comment comment = getCommentById(commentId);
        if (comment == null || !comment.getUserId().equals(userId)) {
            return 0;
        }
        
        // 软删除：将status设置为0
        // 先删除父评论
        String sql = "UPDATE comment SET status = 0 WHERE id = ? AND user_id = ?";
        int result = executeUpdate(sql, commentId, userId);
        
        // 级联删除：删除所有子回复（不管子回复是谁写的）
        if (result > 0) {
            String cascadeSql = "UPDATE comment SET status = 0 WHERE parent_id = ?";
            executeUpdate(cascadeSql, commentId);
        }
        
        return result;
    }
    
    /**
     * 检查用户是否已点赞评论
     * @param commentId 评论ID
     * @param userId 用户ID
     * @return 是否已点赞
     */
    public boolean hasUserLikedComment(int commentId, int userId) {
        try {
            String sql = "SELECT COUNT(*) FROM comment_like WHERE comment_id = ? AND user_id = ?";
            Integer count = executeQueryForSingleValue(sql, Integer.class, commentId, userId);
            return count != null && count > 0;
        } catch (Exception e) {
            // 如果表不存在，尝试创建表
            try {
                String createTableSql = "CREATE TABLE IF NOT EXISTS comment_like (" +
                        "id INT AUTO_INCREMENT PRIMARY KEY, " +
                        "comment_id INT NOT NULL, " +
                        "user_id INT NOT NULL, " +
                        "create_time DATETIME DEFAULT CURRENT_TIMESTAMP, " +
                        "UNIQUE KEY uk_comment_user (comment_id, user_id)" +
                        ") ENGINE=InnoDB DEFAULT CHARSET=utf8mb4";
                executeUpdate(createTableSql);
                // 创建表后，返回false（未点赞）
                return false;
            } catch (Exception ex) {
                // 创建表失败，返回false
                ex.printStackTrace();
                return false;
            }
        }
    }
    
    /**
     * 点赞评论
     * @param commentId 评论ID
     * @param userId 用户ID
     * @return 是否成功
     */
    public boolean likeComment(int commentId, int userId) {
        try {
            // 检查是否已点赞
            if (hasUserLikedComment(commentId, userId)) {
                return false;
            }
            
            // 插入点赞记录
            String insertSql = "INSERT INTO comment_like (comment_id, user_id, create_time) VALUES (?, ?, NOW())";
            int insertResult = executeUpdate(insertSql, commentId, userId);
            
            if (insertResult > 0) {
                // 更新评论的点赞数
                String updateSql = "UPDATE comment SET likes = likes + 1 WHERE id = ?";
                executeUpdate(updateSql, commentId);
                return true;
            }
            return false;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
    
    /**
     * 取消点赞评论
     * @param commentId 评论ID
     * @param userId 用户ID
     * @return 是否成功
     */
    public boolean unlikeComment(int commentId, int userId) {
        try {
            // 检查是否已点赞
            if (!hasUserLikedComment(commentId, userId)) {
                return false;
            }
            
            // 删除点赞记录
            String deleteSql = "DELETE FROM comment_like WHERE comment_id = ? AND user_id = ?";
            int deleteResult = executeUpdate(deleteSql, commentId, userId);
            
            if (deleteResult > 0) {
                // 更新评论的点赞数
                String updateSql = "UPDATE comment SET likes = GREATEST(likes - 1, 0) WHERE id = ?";
                executeUpdate(updateSql, commentId);
                return true;
            }
            return false;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
    
    /**
     * 获取评论的点赞数
     */
    public int getCommentLikes(int commentId) {
        String sql = "SELECT likes FROM comment WHERE id = ?";
        Integer likes = executeQueryForSingleValue(sql, Integer.class, commentId);
        return likes != null ? likes : 0;
    }
}