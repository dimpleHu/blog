package com.blog.service.impl;

import com.blog.dao.CommentDAO;
import com.blog.entity.Comment;
import com.blog.service.CommentService;

import java.util.List;

/**
 * 评论服务实现类
 */
public class CommentServiceImpl implements CommentService {
    
    private CommentDAO commentDAO = new CommentDAO();
    
    @Override
    public int addComment(Comment comment) {
        return commentDAO.addComment(comment);
    }
    
    @Override
    public List<Comment> getCommentsByArticleId(int articleId) {
        return commentDAO.getCommentsByArticleId(articleId);
    }
    
    @Override
    public List<Comment> getRepliesByCommentId(int commentId) {
        return commentDAO.getRepliesByCommentId(commentId);
    }
    
    @Override
    public int getCommentCountByArticleId(int articleId) {
        return commentDAO.getCommentCountByArticleId(articleId);
    }
    
    @Override
    public int getUserCommentCount(int userId) {
        return commentDAO.getUserCommentCount(userId);
    }
    
    @Override
    public Comment getCommentById(int commentId) {
        return commentDAO.getCommentById(commentId);
    }
}

