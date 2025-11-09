package com.blog.controller.commont;

import com.blog.dao.CommentDAO;
import com.blog.dao.UserDAO;
import com.blog.entity.Comment;
import com.blog.entity.User;
import com.fasterxml.jackson.databind.ObjectMapper; // 导入Jackson（需添加依赖）

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import com.fasterxml.jackson.datatype.jsr310.JavaTimeModule;

@WebServlet("/comment/*")
public class CommentServlet extends HttpServlet {
    private CommentDAO commentDAO = new CommentDAO();
    private UserDAO userDAO = new UserDAO(); // 用于查询评论作者信息
    private ObjectMapper objectMapper = new ObjectMapper(); // 用Jackson序列化JSON（更可靠）
    public CommentServlet() {
        // 注册 JavaTimeModule，支持 Java 8 时间类型
        objectMapper.registerModule(new JavaTimeModule());
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String pathInfo = request.getPathInfo();
        try {
            // 1. 处理评论弹窗页面请求（转发到drawer.jsp）
            if ("/drawer".equals(pathInfo)) {
                response.setContentType("text/html;charset=UTF-8");
                String articleIdStr = request.getParameter("articleId");
                if (articleIdStr != null) {
                    request.setAttribute("articleId", articleIdStr);
                }
                request.getRequestDispatcher("/jsp/article/comment-drawer.jsp").forward(request, response);
                return;
            }

            // 2. 处理评论列表请求（返回JSON）
            if ("/list".equals(pathInfo)) {
                response.setContentType("application/json;charset=UTF-8");
                PrintWriter out = response.getWriter();
                String articleIdStr = request.getParameter("articleId");

                if (articleIdStr == null || articleIdStr.isEmpty()) {
                    Map<String, Object> result = new HashMap<>();
                    result.put("success", false);
                    result.put("message", "文章ID不能为空");
                    out.println(objectMapper.writeValueAsString(result));
                    return;
                }

                int articleId = Integer.parseInt(articleIdStr);
                List<Comment> comments = commentDAO.getCommentsByArticleId(articleId);
                for (Comment comment : comments) {
                    User author = userDAO.getUserById(comment.getUserId());
                    comment.setUser(author);
                }

                int totalCount = commentDAO.getCommentCountByArticleId(articleId);
                Map<String, Object> result = new HashMap<>();
                result.put("success", true);
                result.put("comments", comments);
                result.put("totalCount", totalCount);

                out.println(objectMapper.writeValueAsString(result));
                return;
            }

            // 未知路径
            response.setContentType("application/json;charset=UTF-8");
            PrintWriter out = response.getWriter();
            Map<String, Object> result = new HashMap<>();
            result.put("success", false);
            result.put("message", "未知路径");
            out.println(objectMapper.writeValueAsString(result));
        } catch (Exception e) {
            e.printStackTrace();
            response.setContentType("application/json;charset=UTF-8");
            PrintWriter out = response.getWriter();
            Map<String, Object> result = new HashMap<>();
            result.put("success", false);
            result.put("message", "系统错误: " + e.getMessage());
            out.println(objectMapper.writeValueAsString(result));
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String pathInfo = request.getPathInfo();
        response.setContentType("application/json;charset=UTF-8");
        PrintWriter out = response.getWriter();

        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        if (user == null) {
            Map<String, Object> result = new HashMap<>();
            result.put("success", false);
            result.put("message", "请先登录");
            result.put("code", 401);
            out.println(objectMapper.writeValueAsString(result));
            return;
        }

        try {
            if ("/add".equals(pathInfo)) {
                String articleIdStr = request.getParameter("articleId");
                String content = request.getParameter("content");

                if (articleIdStr == null || content == null || content.trim().isEmpty()) {
                    Map<String, Object> result = new HashMap<>();
                    result.put("success", false);
                    result.put("message", "参数不能为空");
                    out.println(objectMapper.writeValueAsString(result));
                    return;
                }

                Comment comment = new Comment();
                comment.setContent(content.trim());
                comment.setArticleId(Integer.parseInt(articleIdStr));
                comment.setUserId(user.getId());
                comment.setParentId(0);

                int result = commentDAO.addComment(comment);
                if (result > 0) {
                    Map<String, Object> successResult = new HashMap<>();
                    successResult.put("success", true);
                    successResult.put("message", "评论发表成功");
                    out.println(objectMapper.writeValueAsString(successResult));
                } else {
                    Map<String, Object> failResult = new HashMap<>();
                    failResult.put("success", false);
                    failResult.put("message", "评论发表失败");
                    out.println(objectMapper.writeValueAsString(failResult));
                }

            } else if ("/reply".equals(pathInfo)) {
                String articleIdStr = request.getParameter("articleId");
                String parentIdStr = request.getParameter("parentId");
                String content = request.getParameter("content");

                if (articleIdStr == null || parentIdStr == null || content == null || content.trim().isEmpty()) {
                    Map<String, Object> result = new HashMap<>();
                    result.put("success", false);
                    result.put("message", "参数不能为空");
                    out.println(objectMapper.writeValueAsString(result));
                    return;
                }

                Comment comment = new Comment();
                comment.setContent(content.trim());
                comment.setArticleId(Integer.parseInt(articleIdStr));
                comment.setUserId(user.getId());
                comment.setParentId(Integer.parseInt(parentIdStr));

                int result = commentDAO.addComment(comment);
                if (result > 0) {
                    Map<String, Object> successResult = new HashMap<>();
                    successResult.put("success", true);
                    successResult.put("message", "回复发表成功");
                    out.println(objectMapper.writeValueAsString(successResult));
                } else {
                    Map<String, Object> failResult = new HashMap<>();
                    failResult.put("success", false);
                    failResult.put("message", "回复发表失败");
                    out.println(objectMapper.writeValueAsString(failResult));
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
            Map<String, Object> errorResult = new HashMap<>();
            errorResult.put("success", false);
            errorResult.put("message", "系统错误: " + e.getMessage());
            out.println(objectMapper.writeValueAsString(errorResult));
        }
    }
}