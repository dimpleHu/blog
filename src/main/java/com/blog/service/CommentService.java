package com.blog.service;

import com.blog.entity.Comment;
import java.util.List;

/**
 * 评论服务接口
 */
public interface CommentService {
    int addComment(Comment comment);
    List<Comment> getCommentsByArticleId(int articleId);
    List<Comment> getRepliesByCommentId(int commentId);
    int getCommentCountByArticleId(int articleId);
    int getUserCommentCount(int userId);
    Comment getCommentById(int commentId);
}

