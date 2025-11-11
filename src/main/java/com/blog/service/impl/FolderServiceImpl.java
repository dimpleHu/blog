package com.blog.service.impl;

import com.blog.dao.FolderDAO;
import com.blog.entity.Folder;
import com.blog.service.FolderService;

import java.util.List;

/**
 * 收藏夹服务实现类
 */
public class FolderServiceImpl implements FolderService {
    
    private FolderDAO folderDAO = new FolderDAO();
    
    @Override
    public int createFolder(Folder folder) {
        return folderDAO.createFolder(folder);
    }
    
    @Override
    public Folder getFolderById(int folderId) {
        return folderDAO.getFolderById(folderId);
    }
    
    @Override
    public List<Folder> getFoldersByUserId(int userId) {
        return folderDAO.getFoldersByUserId(userId);
    }
    
    @Override
    public List<Folder> getFoldersByUserId(int userId, int page, int pageSize) {
        return folderDAO.getFoldersByUserId(userId, page, pageSize);
    }
    
    @Override
    public int getUserFolderCount(int userId) {
        return folderDAO.getUserFolderCount(userId);
    }
    
    @Override
    public List<Folder> getRecentFoldersByUserId(int userId, int limit) {
        return folderDAO.getRecentFoldersByUserId(userId, limit);
    }
    
    @Override
    public int updateFolder(Folder folder) {
        return folderDAO.updateFolder(folder);
    }
    
    @Override
    public int deleteFolder(int folderId, int userId) {
        return folderDAO.deleteFolder(folderId, userId);
    }
    
    @Override
    public boolean isFolderNameExists(int userId, String folderName) {
        return folderDAO.isFolderNameExists(userId, folderName);
    }
    
    @Override
    public int getFolderItemCount(int folderId) {
        return folderDAO.getFolderItemCount(folderId);
    }
    
    @Override
    public int updateFolderItemCount(int folderId) {
        return folderDAO.updateFolderItemCount(folderId);
    }
}

