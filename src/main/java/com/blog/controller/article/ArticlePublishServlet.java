package com.blog.controller.article;

import com.blog.dao.ArticleDAO;
import com.blog.dao.TagDAO;
import com.blog.entity.Article;
import com.blog.entity.Tag;
import com.blog.entity.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.time.LocalDateTime;
import java.util.Arrays;
import java.util.List;
import java.util.stream.Collectors;

@WebServlet("/article/publish")
public class ArticlePublishServlet extends HttpServlet {
    private ArticleDAO articleDAO = new ArticleDAO();
    private TagDAO tagDAO = new TagDAO();

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // 检查用户是否登录
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/user/login");
            return;
        }

        // 检查是否有草稿ID参数，用于编辑草稿
        String draftIdStr = request.getParameter("draftId");
        if (draftIdStr != null && !draftIdStr.trim().isEmpty()) {
            try {
                int draftId = Integer.parseInt(draftIdStr);
                Article draft = articleDAO.getDraftById(draftId, user.getId());

                if (draft != null) {
                    // 将草稿数据设置到request中，用于表单回显
                    request.setAttribute("draftId", draftId);
                    request.setAttribute("title", draft.getTitle());
                    request.setAttribute("content", draft.getContent());

                    // 获取草稿的标签
                    List<Integer> tagIds = articleDAO.getArticleTagIds(draftId);
                    request.setAttribute("selectedTagIds", tagIds);
                } else {
                    request.setAttribute("error", "草稿不存在或您没有权限编辑此草稿");
                }
            } catch (NumberFormatException e) {
                request.setAttribute("error", "草稿ID格式错误");
            } catch (Exception e) {
                e.printStackTrace();
                request.setAttribute("error", "获取草稿失败");
            }
        }

        // 获取所有可用标签
        List<Tag> allTags = tagDAO.getAllActiveTags();
        request.setAttribute("allTags", allTags);

        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        // 转发到发布文章页面
        request.getRequestDispatcher("/jsp/article/publish.jsp").forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // 检查用户是否登录
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/user/login");
            return;
        }

        // 获取表单数据
        String title = request.getParameter("title");
        String content = request.getParameter("content");
        String draftIdStr = request.getParameter("draftId");
        String[] tagIds = request.getParameterValues("tagIds"); // 获取选中的标签ID

        // 验证输入
        if (!validateInput(title, content, request, response)) {
            return;
        }

        try {
            int result;
            String message;
            int articleId = 0;

            if (draftIdStr != null && !draftIdStr.trim().isEmpty()) {
                // 从草稿发布
                articleId = publishFromDraft(draftIdStr, user.getId(), title, content, tagIds);
                result = articleId > 0 ? 1 : 0;
                message = result > 0 ? "草稿发布成功！" : "草稿发布失败";
            } else {
                // 创建新文章
                articleId = createNewArticle(user.getId(), title, content, tagIds);
                result = articleId > 0 ? 1 : 0;
                message = result > 0 ? "文章发布成功！" : "文章发布失败";
            }

            if (result > 0) {
                session.setAttribute("message", message);
                // 发布成功，跳转到文章详情页
                response.sendRedirect(request.getContextPath() + "/article/detail?id=" + articleId);
            } else {
                handleFailure(request, response, message, title, content, draftIdStr, tagIds);
            }

        } catch (Exception e) {
            e.printStackTrace();
            handleFailure(request, response, "系统错误，请稍后重试", title, content, draftIdStr, null);
        }
    }

    /**
     * 验证输入数据
     */
    private boolean validateInput(String title, String content, HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String draftIdStr = request.getParameter("draftId");

        if (title == null || title.trim().isEmpty()) {
            setErrorAndForward(request, response, "文章标题不能为空", title, content, draftIdStr, null);
            return false;
        }

        if (content == null || content.trim().isEmpty()) {
            setErrorAndForward(request, response, "文章内容不能为空", title, content, draftIdStr, null);
            return false;
        }

        if (title.trim().length() > 200) {
            setErrorAndForward(request, response, "文章标题不能超过200个字符", title, content, draftIdStr, null);
            return false;
        }

        return true;
    }

    /**
     * 从草稿发布（带标签）
     */
    private int publishFromDraft(String draftIdStr, int userId, String title, String content, String[] tagIds) {
        try {
            int draftId = Integer.parseInt(draftIdStr);
            Article draft = articleDAO.getDraftById(draftId, userId);

            if (draft != null) {
                // 更新草稿为发布状态
                draft.setTitle(title.trim());
                draft.setContent(content.trim());
                draft.setStatus(Article.STATUS_PUBLISHED);
                draft.setPostTime(LocalDateTime.now());
                draft.setEditTime(LocalDateTime.now());

                // 自动生成摘要
                String summary = generateSummary(content);
                draft.setSummary(summary);

                // 更新文章
                int result = articleDAO.publishDraft(draft);

                if (result > 0) {
                    // 设置标签
                    if (tagIds != null && tagIds.length > 0) {
                        List<Integer> tagIdList = Arrays.stream(tagIds)
                                .map(Integer::parseInt)
                                .collect(Collectors.toList());
                        articleDAO.setArticleTags(draftId, tagIdList);
                    }
                    return draftId;
                }
            }
        } catch (NumberFormatException e) {
            e.printStackTrace();
        }
        return 0;
    }

    /**
     * 创建新文章（带标签）
     */
    private int createNewArticle(int userId, String title, String content, String[] tagIds) {
        Article article = new Article();
        article.setTitle(title.trim());
        article.setContent(content.trim());
        article.setUserId(userId);
        article.setStatus(Article.STATUS_PUBLISHED);
        article.setIsComment(1);
        article.setHits(0);
        article.setLikes(0);
        article.setPostTime(LocalDateTime.now());
        article.setEditTime(LocalDateTime.now());

        // 自动生成摘要
        String summary = generateSummary(content);
        article.setSummary(summary);

        // 保存文章并返回ID
        int articleId = articleDAO.addArticleReturnId(article);

        if (articleId > 0 && tagIds != null && tagIds.length > 0) {
            // 设置标签
            List<Integer> tagIdList = Arrays.stream(tagIds)
                    .map(Integer::parseInt)
                    .collect(Collectors.toList());
            articleDAO.setArticleTags(articleId, tagIdList);
        }

        return articleId;
    }

    /**
     * 生成文章摘要
     */
    private String generateSummary(String content) {
        if (content == null || content.trim().isEmpty()) {
            return "暂无摘要";
        }
        String trimmedContent = content.trim();
        return trimmedContent.length() > 100 ?
                trimmedContent.substring(0, 100) + "..." : trimmedContent;
    }

    /**
     * 设置错误信息并转发
     */
    private void setErrorAndForward(HttpServletRequest request, HttpServletResponse response,
                                    String error, String title, String content, String draftIdStr, String[] tagIds)
            throws ServletException, IOException {

        // 重新获取标签数据
        List<Tag> allTags = tagDAO.getAllActiveTags();
        request.setAttribute("allTags", allTags);

        if (tagIds != null) {
            List<Integer> selectedTagIds = Arrays.stream(tagIds)
                    .map(Integer::parseInt)
                    .collect(Collectors.toList());
            request.setAttribute("selectedTagIds", selectedTagIds);
        }

        request.setAttribute("error", error);
        request.setAttribute("title", title);
        request.setAttribute("content", content);
        request.setAttribute("draftId", draftIdStr);
        request.getRequestDispatcher("/jsp/article/publish.jsp").forward(request, response);
    }

    /**
     * 处理失败情况
     */
    private void handleFailure(HttpServletRequest request, HttpServletResponse response,
                               String error, String title, String content, String draftIdStr, String[] tagIds)
            throws ServletException, IOException {

        setErrorAndForward(request, response, error, title, content, draftIdStr, tagIds);
    }
}