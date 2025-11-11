package com.blog.service.impl;

import com.blog.dao.FavoriteItemDAO;
import com.blog.entity.FavoriteItem;
import com.blog.entity.Folder;
import com.blog.service.FavoriteItemService;

import java.util.List;

/**
 * 收藏项服务实现类
 */
public class FavoriteItemServiceImpl implements FavoriteItemService {
    
    private FavoriteItemDAO favoriteItemDAO = new FavoriteItemDAO();
    
    @Override
    public int addToFolder(int folderId, int articleId, int userId) {
        return favoriteItemDAO.addToFolder(folderId, articleId, userId);
    }
    
    @Override
    public int removeFromFolder(int folderId, int articleId, int userId) {
        return favoriteItemDAO.removeFromFolder(folderId, articleId, userId);
    }
    
    @Override
    public boolean isArticleInFolder(int articleId, int userId, Integer folderId) {
        return favoriteItemDAO.isArticleInFolder(articleId, userId, folderId);
    }
    
    @Override
    public boolean hasUserFavoritedArticle(int articleId, int userId) {
        return favoriteItemDAO.hasUserFavoritedArticle(articleId, userId);
    }
    
    @Override
    public List<FavoriteItem> getFavoriteArticlesByUserId(int userId) {
        return favoriteItemDAO.getFavoriteArticlesByUserId(userId);
    }
    
    @Override
    public List<FavoriteItem> getArticlesInFolder(int folderId) {
        return favoriteItemDAO.getArticlesInFolder(folderId);
    }
    
    @Override
    public List<Folder> getFoldersContainingArticle(int articleId, int userId) {
        return favoriteItemDAO.getFoldersContainingArticle(articleId, userId);
    }
    
    @Override
    public List<FavoriteItem> getFavoriteItemsByUserIdAndFolderId(int userId, int folderId) {
        return favoriteItemDAO.getFavoriteItemsByUserIdAndFolderId(userId, folderId);
    }
    
    @Override
    public int getUserFavoriteCount(int userId) {
        return favoriteItemDAO.getUserFavoriteCount(userId);
    }
}

