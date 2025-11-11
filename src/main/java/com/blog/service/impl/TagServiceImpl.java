package com.blog.service.impl;

import com.blog.dao.TagDAO;
import com.blog.entity.Tag;
import com.blog.service.TagService;

import java.util.List;

/**
 * 标签服务实现类
 */
public class TagServiceImpl implements TagService {
    
    private TagDAO tagDAO = new TagDAO();
    
    @Override
    public List<Tag> getAllActiveTags() {
        return tagDAO.getAllActiveTags();
    }
    
    @Override
    public Tag getTagById(int id) {
        return tagDAO.getTagById(id);
    }
    
    @Override
    public Tag getTagByName(String name) {
        return tagDAO.getTagByName(name);
    }
    
    @Override
    public int createTag(Tag tag) {
        return tagDAO.createTag(tag);
    }
    
    @Override
    public int updateTagUseCount(int tagId) {
        return tagDAO.updateTagUseCount(tagId);
    }
    
    @Override
    public List<Tag> getTagsByArticleId(int articleId) {
        return tagDAO.getTagsByArticleId(articleId);
    }
    
    @Override
    public int addTagToArticle(int articleId, int tagId) {
        return tagDAO.addTagToArticle(articleId, tagId);
    }
    
    @Override
    public int removeTagFromArticle(int articleId, int tagId) {
        return tagDAO.removeTagFromArticle(articleId, tagId);
    }
    
    @Override
    public int clearArticleTags(int articleId) {
        return tagDAO.clearArticleTags(articleId);
    }
    
    @Override
    public List<Tag> getHotTags(int limit) {
        return tagDAO.getHotTags(limit);
    }
    
    @Override
    public List<Tag> searchTags(String keyword) {
        return tagDAO.searchTags(keyword);
    }
    
    @Override
    public List<com.blog.entity.Article> getArticlesByTagName(String tagName) {
        return tagDAO.getArticlesByTagName(tagName);
    }
}

