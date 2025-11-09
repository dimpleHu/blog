package com.blog.entity;

import java.time.LocalDateTime;

public class Folder {
    private Integer id;
    private Integer userId;
    private String name;
    private String description;
    private Integer isPublic;
    private Integer isDefault;
    private Integer itemCount;
    private LocalDateTime createTime;
    // 新增：标记是否为最近使用的收藏夹
    private Integer isRecent; // 数据库字段映射
    private Boolean recent;   // 前端显示用

    // 新增：用于前端判断是否已收藏
    private Integer isInFolder;

    // 关联属性
    private User user;

    public Folder() {}

    public Folder(Integer userId, String name) {
        this.userId = userId;
        this.name = name;
    }

    // Getter和Setter方法
    public Integer getId() { return id; }
    public void setId(Integer id) { this.id = id; }

    public Integer getUserId() { return userId; }
    public void setUserId(Integer userId) { this.userId = userId; }

    public String getName() { return name; }
    public void setName(String name) { this.name = name; }

    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }

    public Integer getIsPublic() { return isPublic; }
    public void setIsPublic(Integer isPublic) { this.isPublic = isPublic; }

    public Integer getIsDefault() { return isDefault; }
    public void setIsDefault(Integer isDefault) { this.isDefault = isDefault; }

    public Integer getItemCount() { return itemCount; }
    public void setItemCount(Integer itemCount) { this.itemCount = itemCount; }

    public LocalDateTime getCreateTime() { return createTime; }
    public void setCreateTime(LocalDateTime createTime) { this.createTime = createTime; }

    public Integer getIsRecent() { return isRecent; }
    public void setIsRecent(Integer isRecent) { this.isRecent = isRecent; }

    public Boolean getRecent() { return recent; }
    public void setRecent(Boolean recent) { this.recent = recent; }

    public Integer getIsInFolder() { return isInFolder; }
    public void setIsInFolder(Integer isInFolder) { this.isInFolder = isInFolder; }

    public User getUser() { return user; }
    public void setUser(User user) { this.user = user; }

    // 辅助方法
    public String getPrivacyText() {
        return isPublic == 1 ? "公开" : "私密";
    }

    public String getPrivacyClass() {
        return isPublic == 1 ? "folder-public" : "folder-private";
    }

    // 判断是否为最近使用的收藏夹
    public boolean isRecentFolder() {
        if (recent != null) return recent;
        if (isRecent != null) return isRecent == 1;
        return false;
    }
}
//
//package com.blog.entity;
//
//import java.time.LocalDateTime;
//import java.util.List;
//
//public class Folder {
//    private Integer id;
//    private Integer userId;
//    private String name;
//    private String description;
//    private Integer isPublic;
//    private Integer isDefault;
//    private Integer itemCount;
//    private LocalDateTime createTime;
//    private Integer isRecent;
//    private Integer isInFolder;
//    private Boolean recent;// 数据库字段映射
//
//
//    private LocalDateTime lastUpdateTime;
//    private List<FavoriteItem> favoriteItems;
//
//
//    // 关联属性
//    private User user;
//
//    public Folder() {}
//
//    public Folder(Integer userId, String name) {
//        this.userId = userId;
//        this.name = name;
//    }
//
//
//    // Getter和Setter方法
//    public Integer getId() { return id; }
//    public void setId(Integer id) { this.id = id; }
//
//    public Integer getUserId() { return userId; }
//    public void setUserId(Integer userId) { this.userId = userId; }
//
//    public String getName() { return name; }
//    public void setName(String name) { this.name = name; }
//
//    public String getDescription() { return description; }
//    public void setDescription(String description) { this.description = description; }
//
//    public Integer getIsPublic() { return isPublic; }
//    public void setIsPublic(Integer isPublic) { this.isPublic = isPublic; }
//
//    public Integer getIsDefault() { return isDefault; }
//    public void setIsDefault(Integer isDefault) { this.isDefault = isDefault; }
//
//    public Integer getItemCount() { return itemCount; }
//    public void setItemCount(Integer itemCount) { this.itemCount = itemCount; }
//
//    public LocalDateTime getCreateTime() { return createTime; }
//    public void setCreateTime(LocalDateTime createTime) { this.createTime = createTime; }
//
//    // 修改为 LocalDateTime 类型
//    public LocalDateTime getLastUpdateTime() { return lastUpdateTime; }
//    public void setLastUpdateTime(LocalDateTime lastUpdateTime) { this.lastUpdateTime = lastUpdateTime; }
//
//
//    public List<FavoriteItem> getFavoriteItems() { return favoriteItems;}
//
//    public void setFavoriteItems(List<FavoriteItem> favoriteItems) { this.favoriteItems = favoriteItems;}
//
//    public Integer getIsInFolder() { return isInFolder; }
//    public void setIsInFolder(Integer isInFolder) { this.isInFolder = isInFolder; }
//
//    public Boolean getRecent() { return recent; }
//    public void setRecent(Boolean recent) { this.recent = recent; }
//
//    public Integer getIsRecent() { return isRecent; }
//    public void setIsRecent(Integer isRecent) { this.isRecent = isRecent; }
//
//
//    // 辅助方法
//    public String getPrivacyText() {
//        return isPublic == 1 ? "公开" : "私密";
//    }
//
//    public String getPrivacyClass() {
//        return isPublic == 1 ? "folder-public" : "folder-private";
//    }
//
//    // 判断是否为最近使用的收藏夹
//    public boolean isRecentFolder() {
//        if (recent != null) return recent;
//        if (isRecent != null) return isRecent == 1;
//        return false;
//    }
//}