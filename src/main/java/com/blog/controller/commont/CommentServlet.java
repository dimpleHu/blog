package com.blog.controller.commont;

import com.blog.dao.CommentDAO;
import com.blog.dao.UserDAO;
import com.blog.entity.Comment;
import com.blog.entity.User;
import com.fasterxml.jackson.databind.ObjectMapper; // 导入Jackson（需添加依赖）
import com.fasterxml.jackson.databind.SerializationFeature;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.Enumeration;
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
        // 禁用将日期写为时间戳，使用 ISO-8601 格式
        objectMapper.disable(SerializationFeature.WRITE_DATES_AS_TIMESTAMPS);
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
                response.setCharacterEncoding("UTF-8");
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
                System.out.println("加载评论列表，文章ID: " + articleId);
                
                List<Comment> comments = commentDAO.getCommentsByArticleId(articleId);
                System.out.println("查询到评论数量: " + (comments != null ? comments.size() : 0));
                
                // 为每个评论及其回复设置用户信息
                if (comments != null) {
                    HttpSession session = request.getSession();
                    User currentUser = (User) session.getAttribute("user");
                    int currentUserId = currentUser != null ? currentUser.getId() : 0;
                    
                    for (Comment comment : comments) {
                        // 设置评论的用户信息
                        if (comment.getUserId() != null) {
                            User author = userDAO.getUserById(comment.getUserId());
                            if (author != null) {
                                comment.setUser(author);
                                System.out.println("设置评论用户信息，评论ID: " + comment.getId() + ", 用户名: " + author.getUsername());
                            } else {
                                System.out.println("警告：评论ID " + comment.getId() + " 的用户ID " + comment.getUserId() + " 不存在");
                                // 创建一个匿名用户对象
                                User anonymousUser = new User();
                                anonymousUser.setId(0);
                                anonymousUser.setUsername("匿名用户");
                                comment.setUser(anonymousUser);
                            }
                        }
                        
                        // 设置当前用户是否已点赞该评论
                        if (currentUserId > 0) {
                            boolean hasLiked = commentDAO.hasUserLikedComment(comment.getId(), currentUserId);
                            comment.setLiked(hasLiked);
                        }
                        
                        // 设置回复的用户信息
                        if (comment.getReplies() != null && !comment.getReplies().isEmpty()) {
                            System.out.println("评论ID " + comment.getId() + " 有 " + comment.getReplies().size() + " 条回复");
                            for (Comment reply : comment.getReplies()) {
                                if (reply.getUserId() != null) {
                                    User replyAuthor = userDAO.getUserById(reply.getUserId());
                                    if (replyAuthor != null) {
                                        reply.setUser(replyAuthor);
                                    } else {
                                        // 创建一个匿名用户对象
                                        User anonymousUser = new User();
                                        anonymousUser.setId(0);
                                        anonymousUser.setUsername("匿名用户");
                                        reply.setUser(anonymousUser);
                                    }
                                }
                                
                                // 设置当前用户是否已点赞该回复
                                if (currentUserId > 0) {
                                    boolean hasLiked = commentDAO.hasUserLikedComment(reply.getId(), currentUserId);
                                    reply.setLiked(hasLiked);
                                }
                            }
                        }
                    }
                }

                int totalCount = commentDAO.getCommentCountByArticleId(articleId);
                Map<String, Object> result = new HashMap<>();
                result.put("success", true);
                result.put("comments", comments != null ? comments : new ArrayList<>());
                result.put("totalCount", totalCount);

                String json = objectMapper.writeValueAsString(result);
                System.out.println("返回JSON长度: " + json.length());
                out.println(json);
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
        
        // 设置请求字符编码，必须在读取参数之前设置
        request.setCharacterEncoding("UTF-8");
        
        // 设置响应头和编码，必须在获取Writer之前设置
        response.setContentType("application/json;charset=UTF-8");
        response.setCharacterEncoding("UTF-8");
        response.setHeader("Cache-Control", "no-cache");
        response.setHeader("Pragma", "no-cache");
        
        PrintWriter out = null;
        try {
            out = response.getWriter();

            HttpSession session = request.getSession();
            User user = (User) session.getAttribute("user");

            System.out.println("收到POST请求，路径: " + pathInfo);
            System.out.println("用户: " + (user != null ? user.getUsername() : "未登录"));
            
            // 调试：打印所有请求参数
            System.out.println("=== 请求参数调试开始 ===");
            Enumeration<String> paramNames = request.getParameterNames();
            while (paramNames.hasMoreElements()) {
                String paramName = paramNames.nextElement();
                String paramValue = request.getParameter(paramName);
                System.out.println("参数名: " + paramName + ", 参数值: " + paramValue);
            }
            System.out.println("=== 请求参数调试结束 ===");
            
            // 调试：打印请求体
            System.out.println("请求方法: " + request.getMethod());
            System.out.println("Content-Type: " + request.getContentType());
            System.out.println("Content-Length: " + request.getContentLength());

            if (user == null) {
                System.out.println("用户未登录，返回401");
                Map<String, Object> result = new HashMap<>();
                result.put("success", false);
                result.put("message", "请先登录");
                result.put("code", 401);
                String json = objectMapper.writeValueAsString(result);
                out.print(json);
                out.flush();
                return;
            }

            if ("/add".equals(pathInfo)) {
                String articleIdStr = request.getParameter("articleId");
                String content = request.getParameter("content");

                System.out.println("添加评论请求，文章ID: " + articleIdStr + ", 内容: " + content);

                if (articleIdStr == null || content == null || content.trim().isEmpty()) {
                    System.out.println("参数验证失败");
                    Map<String, Object> result = new HashMap<>();
                    result.put("success", false);
                    result.put("message", "参数不能为空");
                    String json = objectMapper.writeValueAsString(result);
                    out.print(json);
                    out.flush();
                    return;
                }

                Comment comment = new Comment();
                comment.setContent(content.trim());
                comment.setArticleId(Integer.parseInt(articleIdStr));
                comment.setUserId(user.getId());
                comment.setParentId(0);

                System.out.println("准备添加评论，用户ID: " + user.getId() + ", 文章ID: " + comment.getArticleId());
                int result = commentDAO.addComment(comment);
                System.out.println("评论添加结果: " + result);

                Map<String, Object> responseResult = new HashMap<>();
                if (result > 0) {
                    responseResult.put("success", true);
                    responseResult.put("message", "评论发表成功");
                } else {
                    responseResult.put("success", false);
                    responseResult.put("message", "评论发表失败");
                }
                String json = objectMapper.writeValueAsString(responseResult);
                System.out.println("返回响应: " + json);
                out.print(json);
                out.flush();

            } else if ("/reply".equals(pathInfo)) {
                String articleIdStr = request.getParameter("articleId");
                String parentIdStr = request.getParameter("parentId");
                String content = request.getParameter("content");

                System.out.println("添加回复请求，文章ID: " + articleIdStr + ", 父评论ID: " + parentIdStr + ", 内容: " + content);

                if (articleIdStr == null || parentIdStr == null || content == null || content.trim().isEmpty()) {
                    System.out.println("参数验证失败");
                    Map<String, Object> result = new HashMap<>();
                    result.put("success", false);
                    result.put("message", "参数不能为空");
                    String json = objectMapper.writeValueAsString(result);
                    out.print(json);
                    out.flush();
                    return;
                }

                Comment comment = new Comment();
                comment.setContent(content.trim());
                comment.setArticleId(Integer.parseInt(articleIdStr));
                comment.setUserId(user.getId());
                comment.setParentId(Integer.parseInt(parentIdStr));

                System.out.println("准备添加回复，用户ID: " + user.getId() + ", 文章ID: " + comment.getArticleId() + ", 父评论ID: " + comment.getParentId());
                int result = commentDAO.addComment(comment);
                System.out.println("回复添加结果: " + result);

                Map<String, Object> responseResult = new HashMap<>();
                if (result > 0) {
                    responseResult.put("success", true);
                    responseResult.put("message", "回复发表成功");
                } else {
                    responseResult.put("success", false);
                    responseResult.put("message", "回复发表失败");
                }
                String json = objectMapper.writeValueAsString(responseResult);
                System.out.println("返回响应: " + json);
                out.print(json);
                out.flush();
            } else if ("/delete".equals(pathInfo)) {
                // 删除评论
                String commentIdStr = request.getParameter("commentId");
                
                if (commentIdStr == null || commentIdStr.trim().isEmpty()) {
                    Map<String, Object> result = new HashMap<>();
                    result.put("success", false);
                    result.put("message", "评论ID不能为空");
                    String json = objectMapper.writeValueAsString(result);
                    out.print(json);
                    out.flush();
                    return;
                }
                
                int commentId = Integer.parseInt(commentIdStr);
                int result = commentDAO.deleteComment(commentId, user.getId());
                
                Map<String, Object> responseResult = new HashMap<>();
                if (result > 0) {
                    responseResult.put("success", true);
                    responseResult.put("message", "评论已删除");
                } else {
                    responseResult.put("success", false);
                    responseResult.put("message", "删除失败，评论不存在或无权删除");
                }
                String json = objectMapper.writeValueAsString(responseResult);
                out.print(json);
                out.flush();
                
            } else if ("/like".equals(pathInfo)) {
                // 点赞评论
                String commentIdStr = request.getParameter("commentId");
                
                if (commentIdStr == null || commentIdStr.trim().isEmpty()) {
                    Map<String, Object> result = new HashMap<>();
                    result.put("success", false);
                    result.put("message", "评论ID不能为空");
                    String json = objectMapper.writeValueAsString(result);
                    out.print(json);
                    out.flush();
                    return;
                }
                
                int commentId = Integer.parseInt(commentIdStr);
                boolean success = commentDAO.likeComment(commentId, user.getId());
                
                Map<String, Object> responseResult = new HashMap<>();
                if (success) {
                    int likes = commentDAO.getCommentLikes(commentId);
                    responseResult.put("success", true);
                    responseResult.put("message", "点赞成功");
                    responseResult.put("likes", likes);
                    responseResult.put("liked", true);
                } else {
                    responseResult.put("success", false);
                    responseResult.put("message", "点赞失败，可能已点赞");
                }
                String json = objectMapper.writeValueAsString(responseResult);
                out.print(json);
                out.flush();
                
            } else if ("/unlike".equals(pathInfo)) {
                // 取消点赞评论
                String commentIdStr = request.getParameter("commentId");
                
                if (commentIdStr == null || commentIdStr.trim().isEmpty()) {
                    Map<String, Object> result = new HashMap<>();
                    result.put("success", false);
                    result.put("message", "评论ID不能为空");
                    String json = objectMapper.writeValueAsString(result);
                    out.print(json);
                    out.flush();
                    return;
                }
                
                int commentId = Integer.parseInt(commentIdStr);
                boolean success = commentDAO.unlikeComment(commentId, user.getId());
                
                Map<String, Object> responseResult = new HashMap<>();
                if (success) {
                    int likes = commentDAO.getCommentLikes(commentId);
                    responseResult.put("success", true);
                    responseResult.put("message", "取消点赞成功");
                    responseResult.put("likes", likes);
                    responseResult.put("liked", false);
                } else {
                    responseResult.put("success", false);
                    responseResult.put("message", "取消点赞失败，可能未点赞");
                }
                String json = objectMapper.writeValueAsString(responseResult);
                out.print(json);
                out.flush();
            } else {
                System.out.println("未知的路径: " + pathInfo);
                Map<String, Object> result = new HashMap<>();
                result.put("success", false);
                result.put("message", "未知的请求路径: " + pathInfo);
                String json = objectMapper.writeValueAsString(result);
                out.print(json);
                out.flush();
            }
        } catch (Exception e) {
            e.printStackTrace();
            System.err.println("处理评论请求时发生错误: " + e.getMessage());
            if (out != null) {
                Map<String, Object> errorResult = new HashMap<>();
                errorResult.put("success", false);
                errorResult.put("message", "系统错误: " + e.getMessage());
                String json = objectMapper.writeValueAsString(errorResult);
                out.print(json);
                out.flush();
            }
        }
    }
}