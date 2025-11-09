package com.blog.entity;

import java.time.LocalDateTime;
import java.util.List;

public class Article {
    private Integer id;
    private String title;
    private String content;
    private String summary;
    private String coverImage;
    private Integer status; // 1-发布，2-草稿，3-私密，0-删除
    private Integer isComment; // 1-允许，0-不允许
    private LocalDateTime postTime;
    private LocalDateTime editTime;
    private Integer hits;
    private Integer likes;
    private Integer userId;

    
    // 关联属性
    private User author;
    private List<Tag> tags;

    // 新增：用于存储标签名称列表（搜索结果显示用）
    private List<String> tagNames;

    // 状态常量
    public static final int STATUS_PUBLISHED = 1; // 已发布
    public static final int STATUS_DRAFT = 2;      // 草稿
    public static final int STATUS_PRIVATE = 3;    // 私密
    public static final int STATUS_DELETED = 0;    // 已删除
    
    public Article() {}
    
    public Article(String title, String content, Integer userId) {
        this.title = title;
        this.content = content;
        this.userId = userId;
    }
    
    // Getter和Setter方法
    public Integer getId() { return id; }
    public void setId(Integer id) { this.id = id; }
    
    public String getTitle() { return title; }
    public void setTitle(String title) { this.title = title; }
    
    public String getContent() { return content; }
    public void setContent(String content) { this.content = content; }
    
    public String getSummary() { return summary; }
    public void setSummary(String summary) { this.summary = summary; }
    
    public String getCoverImage() { return coverImage; }
    public void setCoverImage(String coverImage) { this.coverImage = coverImage; }
    
    public Integer getStatus() { return status; }
    public void setStatus(Integer status) { this.status = status; }
    
    public Integer getIsComment() { return isComment; }
    public void setIsComment(Integer isComment) { this.isComment = isComment; }
    
    public LocalDateTime getPostTime() { return postTime; }
    public void setPostTime(LocalDateTime postTime) { this.postTime = postTime; }
    
    public LocalDateTime getEditTime() { return editTime; }
    public void setEditTime(LocalDateTime editTime) { this.editTime = editTime; }
    
    public Integer getHits() { return hits; }
    public void setHits(Integer hits) { this.hits = hits; }
    
    public Integer getLikes() { return likes; }
    public void setLikes(Integer likes) { this.likes = likes; }
    
    public Integer getUserId() { return userId; }
    public void setUserId(Integer userId) { this.userId = userId; }
    
    public User getAuthor() { return author; }
    public void setAuthor(User author) { this.author = author; }
    
    public List<Tag> getTags() { return tags; }
    public void setTags(List<Tag> tags) { this.tags = tags; }
    
    @Override
    public String toString() {
        return "Article{id=" + id + ", title='" + title + "', userId=" + userId + "}";
    }

    // Getter和Setter for tagNames
    public List<String> getTagNames() {
        return tagNames;
    }

    public void setTagNames(List<String> tagNames) {
        this.tagNames = tagNames;
    }

    /**
     * 获取标签名称字符串（用于显示）
     */
    public String getTagNamesString() {
        if (tagNames == null || tagNames.isEmpty()) {
            return "暂无标签";
        }
        return String.join(", ", tagNames);
    }
}