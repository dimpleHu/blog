package com.blog.dao;

import com.blog.entity.Comment;
import com.blog.entity.User;
import java.util.List;

public class CommentDAO extends BaseDAO {
    
    /**
     * 添加评论
     */
    public int addComment(Comment comment) {
        String sql = "INSERT INTO comment (content, user_id, article_id, parent_id, create_time) VALUES (?, ?, ?, ?, NOW())";
        return executeUpdate(sql, comment.getContent(), comment.getUserId(), comment.getArticleId(), 
                comment.getParentId() != null ? comment.getParentId() : 0);
    }
    
    /**
     * 根据文章ID获取评论列表（包含回复）
     */
    public List<Comment> getCommentsByArticleId(int articleId) {
        // 关联完整的用户信息（至少包含id和username）
        String sql = "SELECT c.*, u.id as user_id, u.username, u.avatar " +
                "FROM comment c " +
                "LEFT JOIN user u ON c.user_id = u.id " +
                "WHERE c.article_id = ? AND c.status = 1 " +
                "ORDER BY c.create_time DESC";

        List<Comment> comments = executeQuery(sql, Comment.class, articleId);

        // 为每个评论的回复也加载用户信息
        if (comments != null) {
            for (Comment comment : comments) {
                comment.setReplies(getRepliesByCommentId(comment.getId()));
            }
        }

        return comments;
    }
    
    /**
     * 获取评论的回复列表
     */
    public List<Comment> getRepliesByCommentId(int commentId) {
        // 关联回复的用户信息
        String sql = "SELECT c.*, u.id as user_id, u.username, u.avatar " +
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
     * 根据ID获取评论
     */
    public Comment getCommentById(int commentId) {
        String sql = "SELECT c.*, u.username, u.avatar FROM comment c " +
                "LEFT JOIN user u ON c.user_id = u.id WHERE c.id = ?";
        return executeQueryForObject(sql, Comment.class, commentId);
    }
}