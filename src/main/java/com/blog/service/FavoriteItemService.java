package com.blog.service;

import com.blog.entity.FavoriteItem;
import com.blog.entity.Folder;
import java.util.List;

/**
 * 收藏项服务接口
 */
public interface FavoriteItemService {
    int addToFolder(int folderId, int articleId, int userId);
    int removeFromFolder(int folderId, int articleId, int userId);
    boolean isArticleInFolder(int articleId, int userId, Integer folderId);
    boolean hasUserFavoritedArticle(int articleId, int userId);
    List<FavoriteItem> getFavoriteArticlesByUserId(int userId);
    List<FavoriteItem> getArticlesInFolder(int folderId);
    List<Folder> getFoldersContainingArticle(int articleId, int userId);
    List<FavoriteItem> getFavoriteItemsByUserIdAndFolderId(int userId, int folderId);
    int getUserFavoriteCount(int userId);
}

