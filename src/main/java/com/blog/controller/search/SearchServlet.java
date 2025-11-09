//package com.blog.controller.search;
//
//import com.blog.dao.ArticleDAO;
//import com.blog.dao.TagDAO;
//import com.blog.dao.UserDAO;
//import com.blog.entity.Article;
//import com.blog.entity.Tag;
//import com.blog.entity.User;
//
//import javax.servlet.ServletException;
//import javax.servlet.annotation.WebServlet;
//import javax.servlet.http.HttpServlet;
//import javax.servlet.http.HttpServletRequest;
//import javax.servlet.http.HttpServletResponse;
//import java.io.IOException;
//import java.util.HashMap;
//import java.util.List;
//import java.util.Map;
//
//@WebServlet("/search")
//public class SearchServlet extends HttpServlet {
//    private ArticleDAO articleDAO = new ArticleDAO();
//    private TagDAO tagDAO = new TagDAO();
//    private UserDAO userDAO = new UserDAO();
//
//    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
//        try {
//            String keyword = request.getParameter("keyword");
//            String type = request.getParameter("type"); // 搜索类型：all, article, tag, user
//
//            System.out.println("=== 搜索开始 ===");
//            System.out.println("搜索关键词: " + keyword + ", 类型: " + type);
//
//            if (keyword == null || keyword.trim().isEmpty()) {
//                System.out.println("关键词为空，重定向到首页");
//                response.sendRedirect(request.getContextPath() + "/home");
//                return;
//            }
//
//            keyword = keyword.trim();
//            if (type == null) type = "all";
//
//            // 存储所有搜索结果
//            Map<String, Object> searchResults = new HashMap<>();
//            Map<String, Integer> resultCounts = new HashMap<>();
//
//            // 文章搜索 - 增强版（支持标签搜索）
//            if ("all".equals(type) || "article".equals(type)) {
//                try {
//                    System.out.println("开始搜索文章（包含标签搜索）...");
//                    List<Article> articles = articleDAO.searchArticles(keyword);
//                    System.out.println("文章搜索结果数量: " + (articles != null ? articles.size() : 0));
//
//                    // 为每篇文章设置标签信息
//                    if (articles != null) {
//                        for (Article article : articles) {
//                            List<String> tagNames = articleDAO.getArticleTagNames(article.getId());
//                            // 设置标签名称列表到文章对象中
//                            article.setTagNames(tagNames);
//                        }
//                    }
//
//                    searchResults.put("articles", articles);
//                    resultCounts.put("articles", articles != null ? articles.size() : 0);
//                } catch (Exception e) {
//                    System.err.println("文章搜索失败: " + e.getMessage());
//                    e.printStackTrace();
//                    searchResults.put("articles", null);
//                    resultCounts.put("articles", 0);
//                }
//            }
//
//            // 标签搜索
//            if ("all".equals(type) || "tag".equals(type)) {
//                try {
//                    System.out.println("开始搜索标签...");
//                    List<Tag> tags = tagDAO.searchTags(keyword);
//                    System.out.println("标签搜索结果数量: " + (tags != null ? tags.size() : 0));
//
//                    // use_count字段就是关联文章数量，不需要额外查询
//                    // 标签对象中已经有use_count字段，直接使用即可
//
//                    searchResults.put("tags", tags);
//                    resultCounts.put("tags", tags != null ? tags.size() : 0);
//                } catch (Exception e) {
//                    System.err.println("标签搜索失败: " + e.getMessage());
//                    e.printStackTrace();
//                    searchResults.put("tags", null);
//                    resultCounts.put("tags", 0);
//                }
//            }
//
//            // 用户搜索
//            if ("all".equals(type) || "user".equals(type)) {
//                try {
//                    System.out.println("开始搜索用户...");
//                    List<User> users = userDAO.searchUsersByUsername(keyword);
//                    System.out.println("用户搜索结果数量: " + (users != null ? users.size() : 0));
//                    searchResults.put("users", users);
//                    resultCounts.put("users", users != null ? users.size() : 0);
//                } catch (Exception e) {
//                    System.err.println("用户搜索失败: " + e.getMessage());
//                    e.printStackTrace();
//                    searchResults.put("users", null);
//                    resultCounts.put("users", 0);
//                }
//            }
//
//            // 设置请求属性
//            request.setAttribute("searchResults", searchResults);
//            request.setAttribute("resultCounts", resultCounts);
//            request.setAttribute("keyword", keyword);
//            request.setAttribute("searchType", type);
//
//            // 计算总结果数
//            int totalCount = resultCounts.values().stream().mapToInt(Integer::intValue).sum();
//            request.setAttribute("totalCount", totalCount);
//
//            System.out.println("=== 搜索完成 ===");
//            System.out.println("搜索结果统计: " + resultCounts);
//            System.out.println("总结果数: " + totalCount);
//
//            // 转发到搜索结果页面
//            request.getRequestDispatcher("/jsp/search/search.jsp").forward(request, response);
//
//        } catch (Exception e) {
//            System.err.println("搜索过程发生异常: " + e.getMessage());
//            e.printStackTrace();
//            response.sendRedirect(request.getContextPath() + "/home?error=搜索失败");
//        }
//    }
//}
package com.blog.controller.search;

import com.blog.dao.ArticleDAO;
import com.blog.dao.TagDAO;
import com.blog.dao.UserDAO;
import com.blog.entity.Article;
import com.blog.entity.Tag;
import com.blog.entity.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@WebServlet("/search")
public class SearchServlet extends HttpServlet {
    private ArticleDAO articleDAO = new ArticleDAO();
    private TagDAO tagDAO = new TagDAO();
    private UserDAO userDAO = new UserDAO();

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            String keyword = request.getParameter("keyword");
            String type = request.getParameter("type");

            System.out.println("=== 搜索开始 ===");
            System.out.println("搜索关键词: " + keyword + ", 类型: " + type);

            if (keyword == null || keyword.trim().isEmpty()) {
                response.sendRedirect(request.getContextPath() + "/home");
                return;
            }

            keyword = keyword.trim();
            if (type == null) type = "all";

            Map<String, Object> searchResults = new HashMap<>();
            Map<String, Integer> resultCounts = new HashMap<>();

            // 文章搜索 - 关键修正：确保能搜索到标签相关的文章
            if ("all".equals(type) || "article".equals(type)) {
                try {
                    System.out.println("开始搜索文章（包含标签搜索）...");
                    List<Article> articles = articleDAO.searchArticles(keyword);
                    System.out.println("文章搜索结果数量: " + (articles != null ? articles.size() : 0));

                    // 调试信息：显示搜索到的文章标题
                    if (articles != null && !articles.isEmpty()) {
                        System.out.println("搜索到的文章标题:");
                        for (Article article : articles) {
                            System.out.println(" - " + article.getTitle());
                        }
                    }

                    searchResults.put("articles", articles);
                    resultCounts.put("articles", articles != null ? articles.size() : 0);
                } catch (Exception e) {
                    System.err.println("文章搜索失败: " + e.getMessage());
                    e.printStackTrace();
                    searchResults.put("articles", null);
                    resultCounts.put("articles", 0);
                }
            }

            // 标签搜索
            if ("all".equals(type) || "tag".equals(type)) {
                try {
                    System.out.println("开始搜索标签...");
                    List<Tag> tags = tagDAO.searchTags(keyword);
                    System.out.println("标签搜索结果数量: " + (tags != null ? tags.size() : 0));
                    searchResults.put("tags", tags);
                    resultCounts.put("tags", tags != null ? tags.size() : 0);
                } catch (Exception e) {
                    System.err.println("标签搜索失败: " + e.getMessage());
                    e.printStackTrace();
                    searchResults.put("tags", null);
                    resultCounts.put("tags", 0);
                }
            }

            // 用户搜索
            if ("all".equals(type) || "user".equals(type)) {
                try {
                    System.out.println("开始搜索用户...");
                    List<User> users = userDAO.searchUsersByUsername(keyword);
                    System.out.println("用户搜索结果数量: " + (users != null ? users.size() : 0));
                    searchResults.put("users", users);
                    resultCounts.put("users", users != null ? users.size() : 0);
                } catch (Exception e) {
                    System.err.println("用户搜索失败: " + e.getMessage());
                    e.printStackTrace();
                    searchResults.put("users", null);
                    resultCounts.put("users", 0);
                }
            }

            // 设置请求属性
            request.setAttribute("searchResults", searchResults);
            request.setAttribute("resultCounts", resultCounts);
            request.setAttribute("keyword", keyword);
            request.setAttribute("searchType", type);

            int totalCount = resultCounts.values().stream().mapToInt(Integer::intValue).sum();
            request.setAttribute("totalCount", totalCount);

            System.out.println("=== 搜索完成 ===");
            System.out.println("搜索结果统计: " + resultCounts);
            System.out.println("总结果数: " + totalCount);

            request.getRequestDispatcher("/jsp/search/search.jsp").forward(request, response);

        } catch (Exception e) {
            System.err.println("搜索过程发生异常: " + e.getMessage());
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/home?error=搜索失败");
        }
    }
}



