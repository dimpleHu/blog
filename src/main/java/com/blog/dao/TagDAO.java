//package com.blog.dao;
//
//import com.blog.entity.Article;
//import com.blog.entity.Tag;
//import java.util.List;
//
//public class TagDAO extends BaseDAO {
//
//    /**
//     * 获取所有启用的标签
//     */
//    public List<Tag> getAllActiveTags() {
//        String sql = "SELECT * FROM tag WHERE status = 1 ORDER BY use_count DESC, name ASC";
//        return executeQuery(sql, Tag.class);
//    }
//
//    /**
//     * 根据ID获取标签
//     */
//    public Tag getTagById(int id) {
//        String sql = "SELECT * FROM tag WHERE id = ?";
//        return executeQueryForObject(sql, Tag.class, id);
//    }
//
//    /**
//     * 根据名称获取标签
//     */
//    public Tag getTagByName(String name) {
//        String sql = "SELECT * FROM tag WHERE name = ?";
//        return executeQueryForObject(sql, Tag.class, name);
//    }
//
//    /**
//     * 创建新标签
//     */
//    public int createTag(Tag tag) {
//        String sql = "INSERT INTO tag (name, color, status, create_time, use_count) VALUES (?, ?, ?, ?, ?)";
//        return executeUpdate(sql, tag.getName(), tag.getColor(), tag.getStatus(), tag.getCreateTime(), tag.getUseCount());
//    }
//
//    /**
//     * 更新标签使用次数
//     */
//    public int updateTagUseCount(int tagId) {
//        String sql = "UPDATE tag SET use_count = use_count + 1 WHERE id = ?";
//        return executeUpdate(sql, tagId);
//    }
//
//    /**
//     * 获取文章的所有标签
//     */
//    public List<Tag> getTagsByArticleId(int articleId) {
//        String sql = "SELECT t.* FROM tag t " +
//                    "INNER JOIN article_tag at ON t.id = at.tag_id " +
//                    "WHERE at.article_id = ? AND t.status = 1 " +
//                    "ORDER BY t.use_count DESC";
//        return executeQuery(sql, Tag.class, articleId);
//    }
//
//    /**
//     * 为文章添加标签
//     */
//    public int addTagToArticle(int articleId, int tagId) {
//        // 先检查是否已存在关联
//        String checkSql = "SELECT COUNT(*) FROM article_tag WHERE article_id = ? AND tag_id = ?";
//        Integer count = executeQueryForSingleValue(checkSql, Integer.class, articleId, tagId);
//
//        if (count != null && count > 0) {
//            return 0; // 已存在关联
//        }
//
//        String sql = "INSERT INTO article_tag (article_id, tag_id) VALUES (?, ?)";
//        int result = executeUpdate(sql, articleId, tagId);
//
//        if (result > 0) {
//            // 增加标签使用次数
//            updateTagUseCount(tagId);
//        }
//
//        return result;
//    }
//
//    /**
//     * 移除文章的标签
//     */
//    public int removeTagFromArticle(int articleId, int tagId) {
//        String sql = "DELETE FROM article_tag WHERE article_id = ? AND tag_id = ?";
//        return executeUpdate(sql, articleId, tagId);
//    }
//
//    /**
//     * 清除文章的所有标签
//     */
//    public int clearArticleTags(int articleId) {
//        String sql = "DELETE FROM article_tag WHERE article_id = ?";
//        return executeUpdate(sql, articleId);
//    }
//
//    /**
//     * 获取热门标签（按使用次数排序）
//     */
//    public List<Tag> getHotTags(int limit) {
//        String sql = "SELECT * FROM tag WHERE status = 1 ORDER BY use_count DESC LIMIT ?";
//        return executeQuery(sql, Tag.class, limit);
//    }
//
//    /**
//     * 增强搜索标签（支持模糊搜索和相关性排序）
//     */
//    public List<Tag> searchTags(String keyword) {
//        if (keyword == null || keyword.trim().isEmpty()) {
//            return getAllActiveTags();
//        }
//
//        String sql = "SELECT * FROM tag WHERE status = 1 AND " +
//                "(name LIKE ? OR color LIKE ?) " +
//                "ORDER BY " +
//                "CASE WHEN name = ? THEN 1 " +
//                "     WHEN name LIKE ? THEN 2 " +
//                "     WHEN name LIKE ? THEN 3 " +
//                "     ELSE 4 END, " +
//                "use_count DESC, name ASC";
//
//        return executeQuery(sql, Tag.class,
//                "%" + keyword + "%",
//                "%" + keyword + "%",
//                keyword,
//                keyword + "%",
//                "%" + keyword + "%");
//    }
//
//    /**
//     * 根据标签搜索相关文章
//     */
//    public List<Article> getArticlesByTagName(String tagName) {
//        String sql = "SELECT a.* FROM article a " +
//                "INNER JOIN article_tag at ON a.id = at.article_id " +
//                "INNER JOIN tag t ON at.tag_id = t.id " +
//                "WHERE t.name LIKE ? AND a.status = 1 " +
//                "ORDER BY a.likes DESC, a.hits DESC";
//        return executeQuery(sql, Article.class, "%" + tagName + "%");
//    }
//}

package com.blog.dao;

import com.blog.entity.Tag;
import java.util.List;

public class TagDAO extends BaseDAO {

    /**
     * 获取所有启用的标签
     */
    public List<Tag> getAllActiveTags() {
        String sql = "SELECT * FROM tag WHERE status = 1 ORDER BY use_count DESC, name ASC";
        return executeQuery(sql, Tag.class);
    }

    /**
     * 根据ID获取标签
     */
    public Tag getTagById(int id) {
        String sql = "SELECT * FROM tag WHERE id = ?";
        return executeQueryForObject(sql, Tag.class, id);
    }

    /**
     * 根据名称获取标签
     */
    public Tag getTagByName(String name) {
        String sql = "SELECT * FROM tag WHERE name = ?";
        return executeQueryForObject(sql, Tag.class, name);
    }

    /**
     * 创建新标签
     */
    public int createTag(Tag tag) {
        String sql = "INSERT INTO tag (name, color, status, create_time, use_count) VALUES (?, ?, ?, ?, ?)";
        return executeUpdate(sql, tag.getName(), tag.getColor(), tag.getStatus(), tag.getCreateTime(), tag.getUseCount());
    }

    /**
     * 更新标签使用次数
     */
    public int updateTagUseCount(int tagId) {
        String sql = "UPDATE tag SET use_count = use_count + 1 WHERE id = ?";
        return executeUpdate(sql, tagId);
    }

    /**
     * 获取文章的所有标签
     */
    public List<Tag> getTagsByArticleId(int articleId) {
        String sql = "SELECT t.* FROM tag t " +
                "INNER JOIN article_tag at ON t.id = at.tag_id " +
                "WHERE at.article_id = ? AND t.status = 1 " +
                "ORDER BY t.use_count DESC";
        return executeQuery(sql, Tag.class, articleId);
    }

    /**
     * 为文章添加标签
     */
    public int addTagToArticle(int articleId, int tagId) {
        // 先检查是否已存在关联
        String checkSql = "SELECT COUNT(*) FROM article_tag WHERE article_id = ? AND tag_id = ?";
        Integer count = executeQueryForSingleValue(checkSql, Integer.class, articleId, tagId);

        if (count != null && count > 0) {
            return 0; // 已存在关联
        }

        String sql = "INSERT INTO article_tag (article_id, tag_id) VALUES (?, ?)";
        int result = executeUpdate(sql, articleId, tagId);

        if (result > 0) {
            // 增加标签使用次数
            updateTagUseCount(tagId);
        }

        return result;
    }

    /**
     * 移除文章的标签
     */
    public int removeTagFromArticle(int articleId, int tagId) {
        String sql = "DELETE FROM article_tag WHERE article_id = ? AND tag_id = ?";
        return executeUpdate(sql, articleId, tagId);
    }

    /**
     * 清除文章的所有标签
     */
    public int clearArticleTags(int articleId) {
        String sql = "DELETE FROM article_tag WHERE article_id = ?";
        return executeUpdate(sql, articleId);
    }

    /**
     * 获取热门标签（按使用次数排序）
     */
    public List<Tag> getHotTags(int limit) {
        String sql = "SELECT * FROM tag WHERE status = 1 ORDER BY use_count DESC LIMIT ?";
        return executeQuery(sql, Tag.class, limit);
    }

    /**
     * 搜索标签（简化版）- 修正参数问题
     */
    public List<Tag> searchTags(String keyword) {
        if (keyword == null || keyword.trim().isEmpty()) {
            return getAllActiveTags();
        }

        // 简化SQL，确保参数正确
        String sql = "SELECT * FROM tag WHERE status = 1 AND name LIKE ? ORDER BY use_count DESC, name ASC";
        return executeQuery(sql, Tag.class, "%" + keyword.trim() + "%");
    }

    /**
     * 根据标签名称搜索相关文章
     */
    public List<com.blog.entity.Article> getArticlesByTagName(String tagName) {
        String sql = "SELECT a.* FROM article a " +
                "INNER JOIN article_tag at ON a.id = at.article_id " +
                "INNER JOIN tag t ON at.tag_id = t.id " +
                "WHERE t.name LIKE ? AND a.status = 1 " +
                "ORDER BY a.likes DESC, a.hits DESC";
        return executeQuery(sql, com.blog.entity.Article.class, "%" + tagName + "%");
    }
}