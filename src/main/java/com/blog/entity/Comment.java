package com.blog.entity;

import java.time.LocalDateTime;
import java.util.List;

public class Comment {
    private Integer id;
    private String content;
    private Integer userId;
    private Integer articleId;
    private Integer parentId;
    private Integer likes;
    private Integer status;
    private LocalDateTime createTime;
    
    // 关联属性
    private User user;
    private Article article;
    private List<Comment> replies; // 回复列表
    private Boolean liked; // 当前用户是否已点赞（用于前端显示）
    
    public Comment() {}
    
    // Getter和Setter方法
    public Integer getId() { return id; }
    public void setId(Integer id) { this.id = id; }
    
    public String getContent() { return content; }
    public void setContent(String content) { this.content = content; }
    
    public Integer getUserId() { return userId; }
    public void setUserId(Integer userId) { this.userId = userId; }
    
    public Integer getArticleId() { return articleId; }
    public void setArticleId(Integer articleId) { this.articleId = articleId; }
    
    public Integer getParentId() { return parentId; }
    public void setParentId(Integer parentId) { this.parentId = parentId; }
    
    public Integer getLikes() { return likes; }
    public void setLikes(Integer likes) { this.likes = likes; }
    
    public Integer getStatus() { return status; }
    public void setStatus(Integer status) { this.status = status; }
    
    public LocalDateTime getCreateTime() { return createTime; }
    public void setCreateTime(LocalDateTime createTime) { this.createTime = createTime; }
    
    public User getUser() { return user; }
    public void setUser(User user) { this.user = user; }
    
    public Article getArticle() { return article; }
    public void setArticle(Article article) { this.article = article; }
    
    public List<Comment> getReplies() { return replies; }
    public void setReplies(List<Comment> replies) { this.replies = replies; }
    
    public Boolean getLiked() { return liked; }
    public void setLiked(Boolean liked) { this.liked = liked; }
}