package com.blog.service;

import com.blog.entity.Folder;
import java.util.List;

/**
 * 收藏夹服务接口
 */
public interface FolderService {
    int createFolder(Folder folder);
    Folder getFolderById(int folderId);
    List<Folder> getFoldersByUserId(int userId);
    List<Folder> getFoldersByUserId(int userId, int page, int pageSize);
    int getUserFolderCount(int userId);
    List<Folder> getRecentFoldersByUserId(int userId, int limit);
    int updateFolder(Folder folder);
    int deleteFolder(int folderId, int userId);
    boolean isFolderNameExists(int userId, String folderName);
    int getFolderItemCount(int folderId);
    int updateFolderItemCount(int folderId);
}

