package com.blog.entity;

import java.time.LocalDateTime;
import java.util.Date;

public class Tag {
    private Integer id;
    private String name;
    private String color;
    private Integer status;//0-禁用 1-启用
    private LocalDateTime createTime;
    private Integer useCount;
    
    public Tag() {}
    
    public Tag(String name) {
        this.name = name;
    }
    
    // Getter和Setter方法
    public Integer getId() { return id; }
    public void setId(Integer id) { this.id = id; }
    
    public String getName() { return name; }
    public void setName(String name) { this.name = name; }
    
    public String getColor() { return color; }
    public void setColor(String color) { this.color = color; }
    
    public Integer getStatus() { return status; }
    public void setStatus(Integer status) { this.status = status; }
    
    public LocalDateTime getCreateTime() { return createTime; }
    public void setCreateTime(LocalDateTime createTime) { this.createTime = createTime; }
    
    public Integer getUseCount() { return useCount; }
    public void setUseCount(Integer useCount) { this.useCount = useCount; }
    
    @Override
    public String toString() {
        return "Tag{id=" + id + ", name='" + name + "'}";
    }
}