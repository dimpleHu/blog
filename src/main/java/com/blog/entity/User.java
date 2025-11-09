package com.blog.entity;

import java.time.LocalDateTime;

public class User {
    private Integer id;
    private String username;
    private String password;
    private String phonenumber;
    private String avatar;
    private Integer gender;
    private LocalDateTime birthday;        // 改为LocalDateTime
    private String signature;
    private LocalDateTime createTime;       // 改为LocalDateTime
    private Integer status;
    private LocalDateTime lastLoginTime;   // 改为LocalDateTime

    // Getter和Setter方法
    public Integer getId() { return id; }
    public void setId(Integer id) { this.id = id; }

    public String getUsername() { return username; }
    public void setUsername(String username) { this.username = username; }

    public String getPassword() { return password; }
    public void setPassword(String password) { this.password = password; }

    public String getPhonenumber() { return phonenumber; }
    public void setPhonenumber(String phonenumber) { this.phonenumber = phonenumber; }

    public String getAvatar() { return avatar; }
    public void setAvatar(String avatar) { this.avatar = avatar; }

    public Integer getGender() { return gender; }
    public void setGender(Integer gender) { this.gender = gender; }

    public LocalDateTime getBirthday() { return birthday; }
    public void setBirthday(LocalDateTime birthday) { this.birthday = birthday; }

    public String getSignature() { return signature; }
    public void setSignature(String signature) { this.signature = signature; }

    public LocalDateTime getCreateTime() { return createTime; }
    public void setCreateTime(LocalDateTime createTime) { this.createTime = createTime; }

    public Integer getStatus() { return status; }
    public void setStatus(Integer status) { this.status = status; }

    public LocalDateTime getLastLoginTime() { return lastLoginTime; }
    public void setLastLoginTime(LocalDateTime lastLoginTime) { this.lastLoginTime = lastLoginTime; }
}