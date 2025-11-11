package com.blog.service;

import com.blog.entity.Tag;
import java.util.List;

/**
 * 标签服务接口
 */
public interface TagService {
    List<Tag> getAllActiveTags();
    Tag getTagById(int id);
    Tag getTagByName(String name);
    int createTag(Tag tag);
    int updateTagUseCount(int tagId);
    List<Tag> getTagsByArticleId(int articleId);
    int addTagToArticle(int articleId, int tagId);
    int removeTagFromArticle(int articleId, int tagId);
    int clearArticleTags(int articleId);
    List<Tag> getHotTags(int limit);
    List<Tag> searchTags(String keyword);
    List<com.blog.entity.Article> getArticlesByTagName(String tagName);
}

