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
import java.util.List;

@WebServlet("/article/detail")
public class ArticleDetailServlet extends HttpServlet {
    private ArticleDAO articleDAO = new ArticleDAO();
    private TagDAO tagDAO = new TagDAO();

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            String idStr = request.getParameter("id");
            if (idStr == null || idStr.trim().isEmpty()) {
                response.sendRedirect(request.getContextPath() + "/home");
                return;
            }

            int articleId = Integer.parseInt(idStr);
            System.out.println("加载文章详情，ID: " + articleId);

            // 查询文章详情（包含作者信息）
            Article article = articleDAO.getArticleById(articleId);

            if (article == null) {
                request.setAttribute("error", "文章不存在或已被删除");
                request.getRequestDispatcher("/jsp/article/detail.jsp").forward(request, response);
                return;
            }

            // 增加文章浏览量
            articleDAO.increaseHits(articleId);

            // 获取文章的标签信息 - 关键修改：添加标签数据
            List<Tag> tags = tagDAO.getTagsByArticleId(articleId);
            article.setTags(tags);

            System.out.println("文章 '" + article.getTitle() + "' 的标签数量: " + (tags != null ? tags.size() : 0));
            if (tags != null && !tags.isEmpty()) {
                for (Tag tag : tags) {
                    System.out.println(" - 标签: " + tag.getName());
                }
            }

            // 获取相关文章（同作者的其他文章，最多3篇）
            List<Article> relatedArticles = articleDAO.getRelatedArticles(articleId, 3);
            request.setAttribute("relatedArticles", relatedArticles);

            // 检查用户是否已点赞（需登录后才判断）
            HttpSession session = request.getSession();
            User user = (User) session.getAttribute("user");
            if (user != null) {
                boolean hasLiked = articleDAO.hasUserLikedArticle(articleId, user.getId());
                request.setAttribute("hasLiked", hasLiked);
            }

            request.setAttribute("article", article);
            request.getRequestDispatcher("/jsp/article/detail.jsp").forward(request, response);

        } catch (NumberFormatException e) {
            request.setAttribute("error", "文章ID格式错误");
            request.getRequestDispatcher("/jsp/article/detail.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "获取文章详情失败");
            request.getRequestDispatcher("/jsp/article/detail.jsp").forward(request, response);
        }
    }
}