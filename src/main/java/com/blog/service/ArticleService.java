package com.blog.service;

import com.blog.entity.Article;
import java.util.List;

/**
 * 文章服务接口
 */
public interface ArticleService {
    
    // 状态常量
    int STATUS_PUBLISHED = 1; // 已发布
    int STATUS_DRAFT = 2;      // 草稿
    int STATUS_PRIVATE = 3;    // 私密
    int STATUS_DELETED = 0;    // 已删除
    
    int addArticle(Article article);
    int saveDraft(Article article);
    List<Article> getDraftsByUserId(int userId);
    Article getDraftById(int draftId, int userId);
    int updateDraft(Article article);
    int getUserDraftCount(int userId);
    int deleteDraft(int draftId, int userId);
    Article getArticleById(int articleId);
    Article getArticleByIdForUser(int articleId, int userId);
    List<Article> getArticlesByUserId(int userId);
    List<Article> getArticlesByUserId(int userId, int page, int pageSize);
    int getUserArticleCount(int userId);
    List<Article> getAllPublicArticles();
    List<Article> getArticlesByPage(int page, int pageSize);
    int updateArticle(Article article);
    int deleteArticle(int articleId);
    int updateArticleStatus(int articleId, int status);
    int increaseHits(int articleId);
    int increaseLikes(int articleId);
    int getArticleCount();
    List<Article> getHotArticles(int limit);
    List<Article> getRelatedArticles(int excludeArticleId, int limit);
    List<Article> getLatestArticles(int limit);
    int addArticleReturnId(Article article);
    int getLatestArticleId(int userId);
    int publishDraft(Article draft);
    boolean hasUserLikedArticle(int articleId, int userId);
    int addLikeRecord(int articleId, int userId);
    int removeLikeRecord(int articleId, int userId);
    int increaseLikesWithCheck(int articleId, int userId);
    int getArticleLikes(int articleId);
    List<Article> getLikedArticlesByUserId(int userId);
    int setArticleTags(int articleId, List<Integer> tagIds);
    List<Integer> getArticleTagIds(int articleId);
    List<Article> getPublishedArticles();
    List<Article> getPublishedArticlesByTag(String tagName);
    List<Article> getArticlesByTagId(int tagId);
    List<Article> searchArticles(String keyword);
    List<Article> getArticlesByTagName(String tagName);
    List<String> getArticleTagNames(int articleId);
    int decreaseLikesWithCheck(int articleId, int userId);
}

