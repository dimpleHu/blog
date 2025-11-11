package com.blog.service.impl;

import com.blog.dao.ArticleDAO;
import com.blog.entity.Article;
import com.blog.service.ArticleService;

import java.util.List;

/**
 * 文章服务实现类
 */
public class ArticleServiceImpl implements ArticleService {
    
    private ArticleDAO articleDAO = new ArticleDAO();
    
    @Override
    public int addArticle(Article article) {
        return articleDAO.addArticle(article);
    }
    
    @Override
    public int saveDraft(Article article) {
        return articleDAO.saveDraft(article);
    }
    
    @Override
    public List<Article> getDraftsByUserId(int userId) {
        return articleDAO.getDraftsByUserId(userId);
    }
    
    @Override
    public Article getDraftById(int draftId, int userId) {
        return articleDAO.getDraftById(draftId, userId);
    }
    
    @Override
    public int updateDraft(Article article) {
        return articleDAO.updateDraft(article);
    }
    
    @Override
    public int getUserDraftCount(int userId) {
        return articleDAO.getUserDraftCount(userId);
    }
    
    @Override
    public int deleteDraft(int draftId, int userId) {
        return articleDAO.deleteDraft(draftId, userId);
    }
    
    @Override
    public Article getArticleById(int articleId) {
        return articleDAO.getArticleById(articleId);
    }
    
    @Override
    public Article getArticleByIdForUser(int articleId, int userId) {
        return articleDAO.getArticleByIdForUser(articleId, userId);
    }
    
    @Override
    public List<Article> getArticlesByUserId(int userId) {
        return articleDAO.getArticlesByUserId(userId);
    }
    
    @Override
    public List<Article> getArticlesByUserId(int userId, int page, int pageSize) {
        return articleDAO.getArticlesByUserId(userId, page, pageSize);
    }
    
    @Override
    public int getUserArticleCount(int userId) {
        return articleDAO.getUserArticleCount(userId);
    }
    
    @Override
    public List<Article> getAllPublicArticles() {
        return articleDAO.getAllPublicArticles();
    }
    
    @Override
    public List<Article> getArticlesByPage(int page, int pageSize) {
        return articleDAO.getArticlesByPage(page, pageSize);
    }
    
    @Override
    public int updateArticle(Article article) {
        return articleDAO.updateArticle(article);
    }
    
    @Override
    public int deleteArticle(int articleId) {
        return articleDAO.deleteArticle(articleId);
    }
    
    @Override
    public int updateArticleStatus(int articleId, int status) {
        return articleDAO.updateArticleStatus(articleId, status);
    }
    
    @Override
    public int increaseHits(int articleId) {
        return articleDAO.increaseHits(articleId);
    }
    
    @Override
    public int increaseLikes(int articleId) {
        return articleDAO.increaseLikes(articleId);
    }
    
    @Override
    public int getArticleCount() {
        return articleDAO.getArticleCount();
    }
    
    @Override
    public List<Article> getHotArticles(int limit) {
        return articleDAO.getHotArticles(limit);
    }
    
    @Override
    public List<Article> getRelatedArticles(int excludeArticleId, int limit) {
        return articleDAO.getRelatedArticles(excludeArticleId, limit);
    }
    
    @Override
    public List<Article> getLatestArticles(int limit) {
        return articleDAO.getLatestArticles(limit);
    }
    
    @Override
    public int addArticleReturnId(Article article) {
        return articleDAO.addArticleReturnId(article);
    }
    
    @Override
    public int getLatestArticleId(int userId) {
        return articleDAO.getLatestArticleId(userId);
    }
    
    @Override
    public int publishDraft(Article draft) {
        return articleDAO.publishDraft(draft);
    }
    
    @Override
    public boolean hasUserLikedArticle(int articleId, int userId) {
        return articleDAO.hasUserLikedArticle(articleId, userId);
    }
    
    @Override
    public int addLikeRecord(int articleId, int userId) {
        return articleDAO.addLikeRecord(articleId, userId);
    }
    
    @Override
    public int removeLikeRecord(int articleId, int userId) {
        return articleDAO.removeLikeRecord(articleId, userId);
    }
    
    @Override
    public int increaseLikesWithCheck(int articleId, int userId) {
        return articleDAO.increaseLikesWithCheck(articleId, userId);
    }
    
    @Override
    public int getArticleLikes(int articleId) {
        return articleDAO.getArticleLikes(articleId);
    }
    
    @Override
    public List<Article> getLikedArticlesByUserId(int userId) {
        return articleDAO.getLikedArticlesByUserId(userId);
    }
    
    @Override
    public int setArticleTags(int articleId, List<Integer> tagIds) {
        return articleDAO.setArticleTags(articleId, tagIds);
    }
    
    @Override
    public List<Integer> getArticleTagIds(int articleId) {
        return articleDAO.getArticleTagIds(articleId);
    }
    
    @Override
    public List<Article> getPublishedArticles() {
        return articleDAO.getPublishedArticles();
    }
    
    @Override
    public List<Article> getPublishedArticlesByTag(String tagName) {
        return articleDAO.getPublishedArticlesByTag(tagName);
    }
    
    @Override
    public List<Article> getArticlesByTagId(int tagId) {
        return articleDAO.getArticlesByTagId(tagId);
    }
    
    @Override
    public List<Article> searchArticles(String keyword) {
        return articleDAO.searchArticles(keyword);
    }
    
    @Override
    public List<Article> getArticlesByTagName(String tagName) {
        return articleDAO.getArticlesByTagName(tagName);
    }
    
    @Override
    public List<String> getArticleTagNames(int articleId) {
        return articleDAO.getArticleTagNames(articleId);
    }
    
    @Override
    public int decreaseLikesWithCheck(int articleId, int userId) {
        return articleDAO.decreaseLikesWithCheck(articleId, userId);
    }
}

