package com.blog.dao;

import com.blog.entity.Article;
import com.blog.entity.User;
import com.blog.util.JDBCUtils;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;
import java.util.List;

public class ArticleDAO extends BaseDAO {

    // 状态常量
    public static final int STATUS_PUBLISHED = 1; // 已发布
    public static final int STATUS_DRAFT = 2;      // 草稿
    public static final int STATUS_PRIVATE = 3;    // 私密
    public static final int STATUS_DELETED = 0;    // 已删除

    /**
     * 添加文章（支持草稿和发布）
     */
    public int addArticle(Article article) {
        String sql = "INSERT INTO article (title, content, summary, cover_image, status, is_comment, user_id, post_time, edit_time, hits, likes) " +
                "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        return executeUpdate(sql,
                article.getTitle(), article.getContent(), article.getSummary(),
                article.getCoverImage(), article.getStatus(), article.getIsComment(),
                article.getUserId(), article.getPostTime(), article.getEditTime(),
                article.getHits(), article.getLikes());
    }

    /**
     * 保存草稿（其实就是添加状态为2的文章）
     */
    public int saveDraft(Article article) {
        article.setStatus(STATUS_DRAFT);
        return addArticle(article);
    }

    /**
     * 查询用户的草稿列表
     */
    public List<Article> getDraftsByUserId(int userId) {
        String sql = "SELECT a.*, u.username, u.avatar " +
                "FROM article a LEFT JOIN user u ON a.user_id = u.id " +
                "WHERE a.user_id = ? AND a.status = ? " +
                "ORDER BY a.edit_time DESC";
        return executeQuery(sql, Article.class, userId, STATUS_DRAFT);
    }

    /**
     * 根据ID查询草稿（确保是当前用户的草稿）
     */
    public Article getDraftById(int draftId, int userId) {
        String sql = "SELECT a.*, u.username, u.avatar " +
                "FROM article a LEFT JOIN user u ON a.user_id = u.id " +
                "WHERE a.id = ? AND a.user_id = ? AND a.status = ?";
        return executeQueryForObject(sql, Article.class, draftId, userId, STATUS_DRAFT);
    }

    /**
     * 更新草稿
     */
    public int updateDraft(Article article) {
        String sql = "UPDATE article SET title=?, content=?, summary=?, cover_image=?, " +
                "is_comment=?, edit_time=? WHERE id=? AND user_id=? AND status=?";
        return executeUpdate(sql,
                article.getTitle(), article.getContent(), article.getSummary(),
                article.getCoverImage(), article.getIsComment(), article.getEditTime(),
                article.getId(), article.getUserId(), STATUS_DRAFT);
    }

    /**
     * 查询用户草稿数量
     */
    public int getUserDraftCount(int userId) {
        String sql = "SELECT COUNT(*) FROM article WHERE user_id = ? AND status = ?";
        Integer count = executeQueryForSingleValue(sql, Integer.class, userId, STATUS_DRAFT);
        return count != null ? count : 0;
    }

    /**
     * 删除草稿
     */
    public int deleteDraft(int draftId, int userId) {
        String sql = "DELETE FROM article WHERE id = ? AND user_id = ? AND status = ?";
        return executeUpdate(sql, draftId, userId, STATUS_DRAFT);
    }

    /**
     * 根据ID查询文章（包含作者信息，且只查询非删除状态）
     */
//    public Article getArticleById(int id) {
//        String sql = "SELECT a.*, u.username, u.avatar " +
//                "FROM article a LEFT JOIN user u ON a.user_id = u.id " +
//                "WHERE a.id = ? AND a.status != ?";
//        return executeQueryForObject(sql, Article.class, id, STATUS_DELETED);
//    }

    /**
     * 根据ID获取文章（仅已发布）
     */
    public Article getArticleById(int articleId) {
        String sql = "SELECT a.*, u.username, u.avatar " +
                "FROM article a " +
                "LEFT JOIN user u ON a.user_id = u.id " +
                "WHERE a.id = ? AND a.status = ?";
        Article article = executeQueryForObject(sql, Article.class, articleId, STATUS_PUBLISHED);
        setAuthorForArticle(article);
        return article;
    }

    /**
     * 根据ID和用户ID获取文章（任意状态，用于用户管理自己的文章）
     */
    public Article getArticleByIdForUser(int articleId, int userId) {
        String sql = "SELECT a.*, u.username, u.avatar " +
                "FROM article a LEFT JOIN user u ON a.user_id = u.id " +
                "WHERE a.id = ? AND a.user_id = ?";
        return executeQueryForObject(sql, Article.class, articleId, userId);
    }

    /**
     * 查询用户的所有文章（已发布和私密，不包括删除的）
     */
    public List<Article> getArticlesByUserId(int userId) {
        String sql = "SELECT a.*, u.username, u.avatar " +
                "FROM article a LEFT JOIN user u ON a.user_id = u.id " +
                "WHERE a.user_id = ? AND (a.status = ? OR a.status = ?) " +
                "ORDER BY a.post_time DESC";
        return executeQuery(sql, Article.class, userId, STATUS_PUBLISHED, STATUS_PRIVATE);
    }

    /**
     * 分页查询用户的所有文章（已发布和私密，不包括删除的）
     */
    public List<Article> getArticlesByUserId(int userId, int page, int pageSize) {
        String sql = "SELECT a.*, u.username, u.avatar " +
                "FROM article a LEFT JOIN user u ON a.user_id = u.id " +
                "WHERE a.user_id = ? AND (a.status = ? OR a.status = ?) " +
                "ORDER BY a.post_time DESC LIMIT ?, ?";
        int start = (page - 1) * pageSize;
        return executeQuery(sql, Article.class, userId, STATUS_PUBLISHED, STATUS_PRIVATE, start, pageSize);
    }

    /**
     * 获取用户的文章总数（已发布和私密）
     */
    public int getUserArticleCount(int userId) {
        String sql = "SELECT COUNT(*) FROM article WHERE user_id = ? AND (status = ? OR status = ?)";
        Integer count = executeQueryForSingleValue(sql, Integer.class, userId, STATUS_PUBLISHED, STATUS_PRIVATE);
        return count != null ? count : 0;
    }

    /**
     * 查询所有公开文章（已发布）
     */
    public List<Article> getAllPublicArticles() {
        String sql = "SELECT a.*, u.username, u.avatar " +
                "FROM article a LEFT JOIN user u ON a.user_id = u.id " +
                "WHERE a.status = ? " +
                "ORDER BY a.post_time DESC";
        return executeQuery(sql, Article.class, STATUS_PUBLISHED);
    }

    /**
     * 分页查询文章（已发布）
     */
    public List<Article> getArticlesByPage(int page, int pageSize) {
        String sql = "SELECT a.*, u.username, u.avatar " +
                "FROM article a LEFT JOIN user u ON a.user_id = u.id " +
                "WHERE a.status = ? " +
                "ORDER BY a.post_time DESC LIMIT ?, ?";
        int start = (page - 1) * pageSize;
        return executeQuery(sql, Article.class, STATUS_PUBLISHED, start, pageSize);
    }

    /**
     * 更新文章
     */
    public int updateArticle(Article article) {
        String sql = "UPDATE article SET title=?, content=?, summary=?, cover_image=?, " +
                "status=?, is_comment=?, edit_time=NOW() WHERE id=?";
        return executeUpdate(sql,
                article.getTitle(), article.getContent(), article.getSummary(),
                article.getCoverImage(), article.getStatus(), article.getIsComment(),
                article.getId());
    }

    /**
     * 删除文章（软删除，将status改为2）
     */
    public int deleteArticle(int articleId) {
        String sql = "UPDATE article SET status = ? WHERE id = ?";
        return executeUpdate(sql, 2, articleId); // status=2表示已删除
    }

    /**
     * 更新文章状态（用于私密/公开切换）
     */
    public int updateArticleStatus(int articleId, int status) {
        String sql = "UPDATE article SET status = ? WHERE id = ?";
        return executeUpdate(sql, status, articleId);
    }

    /**
     * 增加文章浏览量
     */
    public int increaseHits(int articleId) {
        String sql = "UPDATE article SET hits = hits + 1 WHERE id = ?";
        return executeUpdate(sql, articleId);
    }

    /**
     * 增加文章点赞数
     */
    public int increaseLikes(int articleId) {
        String sql = "UPDATE article SET likes = likes + 1 WHERE id = ?";
        return executeUpdate(sql, articleId);
    }

    /**
     * 查询文章总数（已发布）
     */
    public int getArticleCount() {
        String sql = "SELECT COUNT(*) FROM article WHERE status = ?";
        Integer count = executeQueryForSingleValue(sql, Integer.class, STATUS_PUBLISHED);
        return count != null ? count : 0;
    }

    /**
     * 获取热门文章（按点赞数+浏览量排序，已发布）
     * @param limit 返回的文章数量
     * @return 热门文章列表
     */
    public List<Article> getHotArticles(int limit) {
        String sql = "SELECT a.*, u.username, u.avatar " +
                "FROM article a LEFT JOIN user u ON a.user_id = u.id " +
                "WHERE a.status = ? " +
                "ORDER BY a.likes DESC, a.hits DESC " +
                "LIMIT ?";
        return executeQuery(sql, Article.class, STATUS_PUBLISHED, limit);
    }

    /**
     * 辅助方法：为Article设置author信息
     */
    private void setAuthorForArticle(Article article) {
        if (article != null && article.getUserId() != null) {
            Connection conn = null;
            PreparedStatement pstmt = null;
            ResultSet rs = null;
            try {
                String userSql = "SELECT id, username, avatar FROM user WHERE id = ?";
                conn = JDBCUtils.getConnection();
                pstmt = conn.prepareStatement(userSql);
                pstmt.setInt(1, article.getUserId());
                rs = pstmt.executeQuery();
                if (rs.next()) {
                    User author = new User();
                    author.setId(rs.getInt("id"));
                    author.setUsername(rs.getString("username"));
                    author.setAvatar(rs.getString("avatar"));
                    article.setAuthor(author);
                }
            } catch (Exception e) {
                e.printStackTrace();
            } finally {
                JDBCUtils.close(conn, pstmt, rs);
            }
        }
    }
    
    /**
     * 辅助方法：为Article列表设置author信息
     */
    private void setAuthorForArticles(List<Article> articles) {
        if (articles != null && !articles.isEmpty()) {
            for (Article article : articles) {
                setAuthorForArticle(article);
            }
        }
    }

    /**
     * 获取相关文章（基于标签推荐）
     * @param excludeArticleId 排除的文章ID
     * @param tagIds 文章的标签ID列表
     * @param limit 返回的文章数量
     * @return 相关文章列表
     */
    public List<Article> getRelatedArticles(int excludeArticleId, List<Integer> tagIds, int limit) {
        // 如果文章没有标签，返回空列表
        if (tagIds == null || tagIds.isEmpty()) {
            return new java.util.ArrayList<>();
        }
        
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        List<Article> result = new java.util.ArrayList<>();
        
        try {
            conn = JDBCUtils.getConnection();
            
            // 如果只有1个标签，直接找这个标签下浏览量最高的文章
            if (tagIds.size() == 1) {
                int tagId = tagIds.get(0);
                String sql = "SELECT DISTINCT a.*, u.username, u.avatar " +
                        "FROM article a " +
                        "LEFT JOIN user u ON a.user_id = u.id " +
                        "INNER JOIN article_tag at ON a.id = at.article_id " +
                        "WHERE a.status = ? AND a.id != ? AND at.tag_id = ? " +
                        "ORDER BY a.hits DESC " +
                        "LIMIT ?";
                pstmt = conn.prepareStatement(sql);
                pstmt.setInt(1, STATUS_PUBLISHED);
                pstmt.setInt(2, excludeArticleId);
                pstmt.setInt(3, tagId);
                pstmt.setInt(4, limit);
                rs = pstmt.executeQuery();
                
                while (rs.next() && result.size() < limit) {
                    Article article = mapResultSetToArticle(rs);
                    if (article != null) {
                        result.add(article);
                    }
                }
            } else {
                // 多个标签的情况
                // 1. 首先找同时拥有所有标签的文章（按浏览量排序）
                StringBuilder sqlBuilder = new StringBuilder();
                sqlBuilder.append("SELECT DISTINCT a.*, u.username, u.avatar, COUNT(DISTINCT at.tag_id) as common_tags ");
                sqlBuilder.append("FROM article a ");
                sqlBuilder.append("LEFT JOIN user u ON a.user_id = u.id ");
                sqlBuilder.append("INNER JOIN article_tag at ON a.id = at.article_id ");
                sqlBuilder.append("WHERE a.status = ? AND a.id != ? AND at.tag_id IN (");
                
                // 构建IN子句
                for (int i = 0; i < tagIds.size(); i++) {
                    if (i > 0) sqlBuilder.append(",");
                    sqlBuilder.append("?");
                }
                sqlBuilder.append(") ");
                sqlBuilder.append("GROUP BY a.id ");
                sqlBuilder.append("HAVING common_tags = ? "); // 同时拥有所有标签
                sqlBuilder.append("ORDER BY a.hits DESC ");
                sqlBuilder.append("LIMIT ?");
                
                pstmt = conn.prepareStatement(sqlBuilder.toString());
                int paramIndex = 1;
                pstmt.setInt(paramIndex++, STATUS_PUBLISHED);
                pstmt.setInt(paramIndex++, excludeArticleId);
                for (Integer tagId : tagIds) {
                    pstmt.setInt(paramIndex++, tagId);
                }
                pstmt.setInt(paramIndex++, tagIds.size()); // 共同标签数
                pstmt.setInt(paramIndex++, limit);
                rs = pstmt.executeQuery();
                
                while (rs.next() && result.size() < limit) {
                    Article article = mapResultSetToArticle(rs);
                    if (article != null) {
                        result.add(article);
                    }
                }
                
                // 2. 如果不足3篇，再找拥有部分标签的文章（按共同标签数降序，然后按浏览量排序）
                if (result.size() < limit) {
                    JDBCUtils.close(null, pstmt, rs);
                    
                    sqlBuilder = new StringBuilder();
                    sqlBuilder.append("SELECT DISTINCT a.*, u.username, u.avatar, COUNT(DISTINCT at.tag_id) as common_tags ");
                    sqlBuilder.append("FROM article a ");
                    sqlBuilder.append("LEFT JOIN user u ON a.user_id = u.id ");
                    sqlBuilder.append("INNER JOIN article_tag at ON a.id = at.article_id ");
                    sqlBuilder.append("WHERE a.status = ? AND a.id != ? AND at.tag_id IN (");
                    
                    for (int i = 0; i < tagIds.size(); i++) {
                        if (i > 0) sqlBuilder.append(",");
                        sqlBuilder.append("?");
                    }
                    sqlBuilder.append(") ");
                    sqlBuilder.append("AND a.id NOT IN (");
                    // 排除已经找到的文章
                    if (!result.isEmpty()) {
                        for (int i = 0; i < result.size(); i++) {
                            if (i > 0) sqlBuilder.append(",");
                            sqlBuilder.append("?");
                        }
                    } else {
                        sqlBuilder.append("0"); // 如果没有已找到的文章，用0占位
                    }
                    sqlBuilder.append(") ");
                    sqlBuilder.append("GROUP BY a.id ");
                    sqlBuilder.append("HAVING common_tags > 0 "); // 至少有一个共同标签
                    sqlBuilder.append("ORDER BY common_tags DESC, a.hits DESC ");
                    sqlBuilder.append("LIMIT ?");
                    
                    pstmt = conn.prepareStatement(sqlBuilder.toString());
                    paramIndex = 1;
                    pstmt.setInt(paramIndex++, STATUS_PUBLISHED);
                    pstmt.setInt(paramIndex++, excludeArticleId);
                    for (Integer tagId : tagIds) {
                        pstmt.setInt(paramIndex++, tagId);
                    }
                    // 添加已找到的文章ID
                    for (Article article : result) {
                        pstmt.setInt(paramIndex++, article.getId());
                    }
                    pstmt.setInt(paramIndex++, limit - result.size());
                    rs = pstmt.executeQuery();
                    
                    while (rs.next() && result.size() < limit) {
                        Article article = mapResultSetToArticle(rs);
                        if (article != null) {
                            result.add(article);
                        }
                    }
                }
            }
            
            // 如果最终不足3篇，返回空列表
            if (result.size() < 3) {
                return new java.util.ArrayList<>();
            }
            
            return result;
            
        } catch (Exception e) {
            e.printStackTrace();
            return new java.util.ArrayList<>();
        } finally {
            JDBCUtils.close(conn, pstmt, rs);
        }
    }
    
    /**
     * 获取相关文章（兼容旧方法，基于标签推荐）
     * @param excludeArticleId 排除的文章ID
     * @param limit 返回的文章数量
     * @return 相关文章列表（如果没有标签则返回空列表）
     */
    public List<Article> getRelatedArticles(int excludeArticleId, int limit) {
        // 获取文章的标签
        TagDAO tagDAO = new TagDAO();
        List<com.blog.entity.Tag> tags = tagDAO.getTagsByArticleId(excludeArticleId);
        
        if (tags == null || tags.isEmpty()) {
            return new java.util.ArrayList<>();
        }
        
        // 提取标签ID列表
        List<Integer> tagIds = new java.util.ArrayList<>();
        for (com.blog.entity.Tag tag : tags) {
            tagIds.add(tag.getId());
        }
        
        return getRelatedArticles(excludeArticleId, tagIds, limit);
    }
    
    /**
     * 从ResultSet映射Article对象（包含username和avatar字段）
     */
    private Article mapResultSetToArticle(ResultSet rs) throws Exception {
        Article article = new Article();
        article.setId(rs.getInt("id"));
        article.setTitle(rs.getString("title"));
        article.setContent(rs.getString("content"));
        article.setSummary(rs.getString("summary"));
        article.setCoverImage(rs.getString("cover_image"));
        article.setStatus(rs.getInt("status"));
        article.setIsComment(rs.getInt("is_comment"));
        article.setUserId(rs.getInt("user_id"));
        
        // 处理时间字段
        java.sql.Timestamp postTime = rs.getTimestamp("post_time");
        if (postTime != null) {
            article.setPostTime(postTime.toLocalDateTime());
        }
        java.sql.Timestamp editTime = rs.getTimestamp("edit_time");
        if (editTime != null) {
            article.setEditTime(editTime.toLocalDateTime());
        }
        
        article.setHits(rs.getInt("hits"));
        article.setLikes(rs.getInt("likes"));
        
        // 设置作者信息
        String username = rs.getString("username");
        String avatar = rs.getString("avatar");
        if (username != null || avatar != null) {
            User author = new User();
            author.setId(article.getUserId());
            author.setUsername(username);
            author.setAvatar(avatar);
            article.setAuthor(author);
        }
        
        return article;
    }

    /**
     * 获取最新文章（已发布）
     * @param limit 返回的文章数量
     * @return 最新文章列表
     */
    public List<Article> getLatestArticles(int limit) {
        String sql = "SELECT a.*, u.username, u.avatar " +
                "FROM article a LEFT JOIN user u ON a.user_id = u.id " +
                "WHERE a.status = ? " +
                "ORDER BY a.post_time DESC " +
                "LIMIT ?";
        return executeQuery(sql, Article.class, STATUS_PUBLISHED, limit);
    }

    /**
     * 添加文章并返回文章ID（使用自增ID）
     */
    public int addArticleReturnId(Article article) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        try {
            String sql = "INSERT INTO article (title, content, summary, cover_image, status, is_comment, user_id, post_time, edit_time, hits, likes) " +
                    "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";

            conn = JDBCUtils.getConnection();
            pstmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);

            pstmt.setString(1, article.getTitle());
            pstmt.setString(2, article.getContent());
            pstmt.setString(3, article.getSummary());
            pstmt.setString(4, article.getCoverImage());
            pstmt.setInt(5, article.getStatus());
            pstmt.setInt(6, article.getIsComment());
            pstmt.setInt(7, article.getUserId());
            pstmt.setObject(8, article.getPostTime());
            pstmt.setObject(9, article.getEditTime());
            pstmt.setInt(10, article.getHits());
            pstmt.setInt(11, article.getLikes());

            int result = pstmt.executeUpdate();

            if (result > 0) {
                rs = pstmt.getGeneratedKeys();
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
            return 0;
        } catch (Exception e) {
            e.printStackTrace();
            return 0;
        } finally {
            JDBCUtils.close(conn, pstmt, rs);
        }
    }

    /**
     * 获取用户最新创建的文章ID（已发布）
     */
    public int getLatestArticleId(int userId) {
        String sql = "SELECT id FROM article WHERE user_id = ? AND status = ? ORDER BY id DESC LIMIT 1";
        Integer latestId = executeQueryForSingleValue(sql, Integer.class, userId, STATUS_PUBLISHED);
        return latestId != null ? latestId : 0;
    }

    /**
     * 从草稿发布（更新草稿为发布状态）
     */
    public int publishDraft(Article draft) {
        String sql = "UPDATE article SET title=?, content=?, summary=?, cover_image=?, " +
                "status=?, is_comment=?, post_time=?, edit_time=? WHERE id=? AND user_id=?";
        return executeUpdate(sql,
                draft.getTitle(), draft.getContent(), draft.getSummary(),
                draft.getCoverImage(), STATUS_PUBLISHED, draft.getIsComment(),
                draft.getPostTime(), draft.getEditTime(),
                draft.getId(), draft.getUserId());
    }

    /**
     * 检查用户是否已经点赞过某篇文章
     */
    public boolean hasUserLikedArticle(int articleId, int userId) {
        String sql = "SELECT COUNT(*) FROM article_like WHERE article_id = ? AND user_id = ?";
        Integer count = executeQueryForSingleValue(sql, Integer.class, articleId, userId);
        return count != null && count > 0;
    }

    /**
     * 添加点赞记录
     */
    public int addLikeRecord(int articleId, int userId) {
        String sql = "INSERT INTO article_like (article_id, user_id) VALUES (?, ?)";
        return executeUpdate(sql, articleId, userId);
    }

    /**
     * 删除点赞记录
     */
    public int removeLikeRecord(int articleId, int userId) {
        String sql = "DELETE FROM article_like WHERE article_id = ? AND user_id = ?";
        return executeUpdate(sql, articleId, userId);
    }

    /**
     * 增加文章点赞数（带用户验证，防止重复点赞）
     */
    public int increaseLikesWithCheck(int articleId, int userId) {
        Connection conn = null;
        PreparedStatement pstmt = null;

        try {
            conn = JDBCUtils.getConnection();
            conn.setAutoCommit(false);

            // 检查是否已点赞
            String checkSql = "SELECT COUNT(*) FROM article_like WHERE article_id = ? AND user_id = ?";
            pstmt = conn.prepareStatement(checkSql);
            pstmt.setInt(1, articleId);
            pstmt.setInt(2, userId);
            ResultSet rs = pstmt.executeQuery();

            if (rs.next() && rs.getInt(1) > 0) {
                return 0; // 已点赞，返回0
            }

            // 添加点赞记录
            String insertSql = "INSERT INTO article_like (article_id, user_id) VALUES (?, ?)";
            pstmt = conn.prepareStatement(insertSql);
            pstmt.setInt(1, articleId);
            pstmt.setInt(2, userId);
            int recordResult = pstmt.executeUpdate();

            if (recordResult <= 0) {
                conn.rollback();
                return -1; // 插入失败
            }

            // 更新文章点赞数
            String updateSql = "UPDATE article SET likes = likes + 1 WHERE id = ?";
            pstmt = conn.prepareStatement(updateSql);
            pstmt.setInt(1, articleId);
            int updateResult = pstmt.executeUpdate();

            if (updateResult <= 0) {
                conn.rollback();
                return -1; // 更新失败
            }

            // 获取最新点赞数
            String selectSql = "SELECT likes FROM article WHERE id = ?";
            pstmt = conn.prepareStatement(selectSql);
            pstmt.setInt(1, articleId);
            rs = pstmt.executeQuery();

            int newLikes = 0;
            if (rs.next()) {
                newLikes = rs.getInt("likes");
            }

            conn.commit();
            return newLikes;

        } catch (Exception e) {
            try {
                if (conn != null) conn.rollback();
            } catch (Exception ex) {
                ex.printStackTrace();
            }
            e.printStackTrace();
            return -1;
        } finally {
            JDBCUtils.close(conn, pstmt);
        }
    }

    /**
     * 获取文章当前点赞数
     */
    public int getArticleLikes(int articleId) {
        String sql = "SELECT likes FROM article WHERE id = ?";
        Integer likes = executeQueryForSingleValue(sql, Integer.class, articleId);
        return likes != null ? likes : 0;
    }

    /**
     * 获取用户点赞过的文章列表（已发布）
     */
    public List<Article> getLikedArticlesByUserId(int userId) {
        String sql = "SELECT a.*, u.username, u.avatar " +
                "FROM article a " +
                "LEFT JOIN user u ON a.user_id = u.id " +
                "INNER JOIN article_like al ON a.id = al.article_id " +
                "WHERE al.user_id = ? AND a.status = ? " +
                "ORDER BY al.like_time DESC";
        return executeQuery(sql, Article.class, userId, STATUS_PUBLISHED);
    }

    /**
     * 为文章设置标签
     */
    public int setArticleTags(int articleId, List<Integer> tagIds) {
        TagDAO tagDAO = new TagDAO();
        int result = 0;

        // 先清除原有标签
        tagDAO.clearArticleTags(articleId);

        // 添加新标签
        for (Integer tagId : tagIds) {
            if (tagId != null && tagId > 0) {
                result += tagDAO.addTagToArticle(articleId, tagId);
            }
        }

        return result;
    }

    /**
     * 获取文章的标签ID列表
     */
    public List<Integer> getArticleTagIds(int articleId) {
        String sql = "SELECT tag_id FROM article_tag WHERE article_id = ?";
        return executeQueryForList(sql, Integer.class, articleId);
    }


    /**
     * 获取所有已发布的文章
     */
    public List<Article> getPublishedArticles() {
        String sql = "SELECT a.*, u.username, u.avatar " +
                "FROM article a LEFT JOIN user u ON a.user_id = u.id " +
                "WHERE a.status = ? " +
                "ORDER BY a.post_time DESC";
        return executeQuery(sql, Article.class, STATUS_PUBLISHED);
    }



    /**
     * 根据标签搜索已发布文章
     */
    public List<Article> getPublishedArticlesByTag(String tagName) {
        String sql = "SELECT a.*, u.username, u.avatar " +
                "FROM article a " +
                "LEFT JOIN user u ON a.user_id = u.id " +
                "INNER JOIN article_tag at ON a.id = at.article_id " +
                "INNER JOIN tag t ON at.tag_id = t.id " +
                "WHERE a.status = ? AND t.name LIKE ? " +
                "ORDER BY a.post_time DESC";
        return executeQuery(sql, Article.class, STATUS_PUBLISHED, "%" + tagName + "%");
    }

    /**
     * 增强搜索文章（支持标题、内容、作者、标签多字段搜索）
     */
//    public List<Article> searchArticles(String keyword) {
//        if (keyword == null || keyword.trim().isEmpty()) {
//            return getPublishedArticles();
//        }
//
//        // 增强的SQL：同时搜索文章标题、内容、作者和标签
//        String sql = "SELECT DISTINCT a.*, u.username, u.avatar " +
//                "FROM article a " +
//                "LEFT JOIN user u ON a.user_id = u.id " +
//                "LEFT JOIN article_tag at ON a.id = at.article_id " +
//                "LEFT JOIN tag t ON at.tag_id = t.id " +
//                "WHERE a.status = ? AND " +
//                "(a.title LIKE ? OR a.content LIKE ? OR a.summary LIKE ? " +
//                "OR u.username LIKE ? OR t.name LIKE ?) " +
//                "ORDER BY a.post_time DESC";
//
//        return executeQuery(sql, Article.class, STATUS_PUBLISHED,
//                "%" + keyword + "%", "%" + keyword + "%", "%" + keyword + "%",
//                "%" + keyword + "%", "%" + keyword + "%");
//    }

    /**
     * 根据标签名称搜索相关文章
     */
//    public List<Article> getArticlesByTagName(String tagName) {
//        String sql = "SELECT DISTINCT a.*, u.username, u.avatar " +
//                "FROM article a " +
//                "LEFT JOIN user u ON a.user_id = u.id " +
//                "INNER JOIN article_tag at ON a.id = at.article_id " +
//                "INNER JOIN tag t ON at.tag_id = t.id " +
//                "WHERE a.status = ? AND t.name LIKE ? " +
//                "ORDER BY a.post_time DESC";
//        return executeQuery(sql, Article.class, STATUS_PUBLISHED, "%" + tagName + "%");
//    }

    /**
     * 获取文章的标签名称列表
     */
//    public List<String> getArticleTagNames(int articleId) {
//        String sql = "SELECT t.name FROM tag t " +
//                "INNER JOIN article_tag at ON t.id = at.tag_id " +
//                "WHERE at.article_id = ? AND t.status = 1 " +
//                "ORDER BY t.use_count DESC";
//        return executeQueryForList(sql, String.class, articleId);
//    }

    /**
     * 获取包含特定标签的所有文章
     */
    public List<Article> getArticlesByTagId(int tagId) {
        String sql = "SELECT DISTINCT a.*, u.username, u.avatar " +
                "FROM article a " +
                "LEFT JOIN user u ON a.user_id = u.id " +
                "INNER JOIN article_tag at ON a.id = at.article_id " +
                "WHERE a.status = ? AND at.tag_id = ? " +
                "ORDER BY a.post_time DESC";
        return executeQuery(sql, Article.class, STATUS_PUBLISHED, tagId);
    }

    /**
     * 增强搜索文章（支持标题、内容、作者、标签多字段搜索）- 修正版
     */
    public List<Article> searchArticles(String keyword) {
        if (keyword == null || keyword.trim().isEmpty()) {
            return getPublishedArticles();
        }

        // 修正的SQL：确保能正确搜索到标签相关的文章
        String sql = "SELECT DISTINCT a.*, u.username, u.avatar " +
                "FROM article a " +
                "LEFT JOIN user u ON a.user_id = u.id " +
                "LEFT JOIN article_tag at ON a.id = at.article_id " +
                "LEFT JOIN tag t ON at.tag_id = t.id " +
                "WHERE a.status = ? AND " +
                "(a.title LIKE ? OR a.content LIKE ? OR a.summary LIKE ? " +
                "OR u.username LIKE ? OR t.name LIKE ?) " +
                "ORDER BY a.post_time DESC";

        return executeQuery(sql, Article.class, STATUS_PUBLISHED,
                "%" + keyword + "%", "%" + keyword + "%", "%" + keyword + "%",
                "%" + keyword + "%", "%" + keyword + "%");
    }

    /**
     * 根据标签名称搜索相关文章 - 修正版
     */
    public List<Article> getArticlesByTagName(String tagName) {
        String sql = "SELECT DISTINCT a.*, u.username, u.avatar " +
                "FROM article a " +
                "LEFT JOIN user u ON a.user_id = u.id " +
                "INNER JOIN article_tag at ON a.id = at.article_id " +
                "INNER JOIN tag t ON at.tag_id = t.id " +
                "WHERE a.status = ? AND t.name LIKE ? " +
                "ORDER BY a.post_time DESC";
        return executeQuery(sql, Article.class, STATUS_PUBLISHED, "%" + tagName + "%");
    }

    /**
     * 获取文章的标签名称列表
     */
    public List<String> getArticleTagNames(int articleId) {
        String sql = "SELECT t.name FROM tag t " +
                "INNER JOIN article_tag at ON t.id = at.tag_id " +
                "WHERE at.article_id = ? AND t.status = 1 " +
                "ORDER BY t.use_count DESC";
        return executeQueryForList(sql, String.class, articleId);
    }

    /**
     * 取消点赞（减少点赞数并删除点赞记录）
     */
    public int decreaseLikesWithCheck(int articleId, int userId) {
        Connection conn = null;
        PreparedStatement pstmt = null;

        try {
            conn = JDBCUtils.getConnection();
            conn.setAutoCommit(false);

            // 检查是否已点赞
            String checkSql = "SELECT COUNT(*) FROM article_like WHERE article_id = ? AND user_id = ?";
            pstmt = conn.prepareStatement(checkSql);
            pstmt.setInt(1, articleId);
            pstmt.setInt(2, userId);
            ResultSet rs = pstmt.executeQuery();

            if (rs.next() && rs.getInt(1) == 0) {
                return 0; // 未点赞，返回0
            }

            // 删除点赞记录
            String deleteSql = "DELETE FROM article_like WHERE article_id = ? AND user_id = ?";
            pstmt = conn.prepareStatement(deleteSql);
            pstmt.setInt(1, articleId);
            pstmt.setInt(2, userId);
            int deleteResult = pstmt.executeUpdate();

            if (deleteResult <= 0) {
                conn.rollback();
                return -1; // 删除失败
            }

            // 更新文章点赞数（确保不小于0）
            String updateSql = "UPDATE article SET likes = GREATEST(likes - 1, 0) WHERE id = ?";
            pstmt = conn.prepareStatement(updateSql);
            pstmt.setInt(1, articleId);
            int updateResult = pstmt.executeUpdate();

            if (updateResult <= 0) {
                conn.rollback();
                return -1; // 更新失败
            }

            // 获取最新点赞数
            String selectSql = "SELECT likes FROM article WHERE id = ?";
            pstmt = conn.prepareStatement(selectSql);
            pstmt.setInt(1, articleId);
            rs = pstmt.executeQuery();

            int newLikes = 0;
            if (rs.next()) {
                newLikes = rs.getInt("likes");
            }

            conn.commit();
            return newLikes;

        } catch (Exception e) {
            try {
                if (conn != null) conn.rollback();
            } catch (Exception ex) {
                ex.printStackTrace();
            }
            e.printStackTrace();
            return -1;
        } finally {
            JDBCUtils.close(conn, pstmt);
        }
    }
}