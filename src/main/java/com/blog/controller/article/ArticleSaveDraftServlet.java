package com.blog.controller.article;

import com.blog.dao.ArticleDAO;
import com.blog.entity.Article;
import com.blog.entity.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.io.PrintWriter;
import java.time.LocalDateTime;
import java.util.List;

@WebServlet("/article/save-draft")
public class ArticleSaveDraftServlet extends HttpServlet {
    private ArticleDAO articleDAO = new ArticleDAO();

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // 设置请求和响应的字符编码为UTF-8，解决中文乱码问题
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        // 设置响应类型为JSON
        response.setContentType("application/json;charset=UTF-8");
        PrintWriter out = response.getWriter();

        // 检查用户是否登录
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        if (user == null) {
            out.println("{\"success\": false, \"message\": \"用户未登录\"}");
            return;
        }

        // 获取表单数据
        String title = request.getParameter("title");
        String content = request.getParameter("content");
        String draftIdStr = request.getParameter("draftId");

        try {
            int result;
            String message;
            Integer newDraftId = null;

            // 处理标题和内容
            if (title == null || title.trim().isEmpty()) {
                title = "无标题草稿";
            }
            if (content == null || content.trim().isEmpty()) {
                content = "暂无内容";
            }

            if (draftIdStr != null && !draftIdStr.trim().isEmpty()) {
                // 更新现有草稿
                int draftId = Integer.parseInt(draftIdStr);
                Article draft = articleDAO.getDraftById(draftId, user.getId());

                if (draft != null) {
                    draft.setTitle(title.trim());
                    draft.setContent(content.trim());
                    draft.setEditTime(LocalDateTime.now());

                    // 自动生成摘要
                    String summary = content.trim().length() > 100 ?
                            content.trim().substring(0, 100) + "..." : content.trim();
                    draft.setSummary(summary);

                    result = articleDAO.updateDraft(draft);
                    message = result > 0 ? "草稿更新成功！" : "草稿更新失败";
                    newDraftId = draftId;
                } else {
                    out.println("{\"success\": false, \"message\": \"草稿不存在或您没有权限编辑此草稿\"}");
                    return;
                }
            } else {
                // 创建新草稿
                Article draft = new Article();
                draft.setTitle(title.trim());
                draft.setContent(content.trim());
                draft.setUserId(user.getId());
                draft.setStatus(ArticleDAO.STATUS_DRAFT); // 使用DAO中的常量
                draft.setIsComment(1);
                draft.setHits(0);
                draft.setLikes(0);
                draft.setPostTime(LocalDateTime.now());
                draft.setEditTime(LocalDateTime.now());

                // 自动生成摘要
                String summary = content.trim().length() > 100 ?
                        content.trim().substring(0, 100) + "..." : content.trim();
                draft.setSummary(summary);

                result = articleDAO.saveDraft(draft);
                message = result > 0 ? "草稿保存成功！" : "草稿保存失败";

                // 获取新创建的草稿ID（简化实现）
                if (result > 0) {
                    // 查询用户最新的草稿获取ID
                    List<Article> drafts = articleDAO.getDraftsByUserId(user.getId());
                    if (!drafts.isEmpty()) {
                        newDraftId = drafts.get(0).getId();
                    }
                }
            }

            // 返回JSON响应
            if (result > 0) {
                out.println("{\"success\": true, \"message\": \"" + message + "\", \"draftId\": " + newDraftId + "}");
            } else {
                out.println("{\"success\": false, \"message\": \"" + message + "\"}");
            }

        } catch (Exception e) {
            e.printStackTrace();
            out.println("{\"success\": false, \"message\": \"系统错误，保存失败\"}");
        }
    }
}