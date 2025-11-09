package com.blog.entity;

import java.time.LocalDateTime;
import java.util.Date;

public class FavoriteItem {
    private Integer id;
    private Integer folderId;
    private Integer articleId;
    private Integer userId;
    private LocalDateTime createTime;

    
    // 关联属性
    private Folder folder;
    private Article article;
    private User user;
    
    public FavoriteItem() {}
    
    // Getter和Setter方法
    public Integer getId() { return id; }
    public void setId(Integer id) { this.id = id; }
    
    public Integer getFolderId() { return folderId; }
    public void setFolderId(Integer folderId) { this.folderId = folderId; }
    
    public Integer getArticleId() { return articleId; }
    public void setArticleId(Integer articleId) { this.articleId = articleId; }
    
    public Integer getUserId() { return userId; }
    public void setUserId(Integer userId) { this.userId = userId; }
    
    public LocalDateTime getCreateTime() { return createTime; }
    public void setCreateTime(LocalDateTime createTime) { this.createTime = createTime; }
    
    public Folder getFolder() { return folder; }
    public void setFolder(Folder folder) { this.folder = folder; }
    
    public Article getArticle() { return article; }
    public void setArticle(Article article) { this.article = article; }
    
    public User getUser() { return user; }
    public void setUser(User user) { this.user = user; }
}