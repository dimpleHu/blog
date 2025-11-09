<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page isELIgnored="false" %>
<c:if test="${empty sessionScope.user}">
    <c:redirect url="${pageContext.request.contextPath}/jsp/user/login.jsp"/>
</c:if>
<html>
<head>
    <title>${article.title} - 个人博客系统</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        body {
            font-family: 'Microsoft YaHei', Arial, sans-serif;
            background: #f5f7fa;
            color: #333;
            line-height: 1.6;
        }
        .article-container {
            max-width: 1000px;
            margin: 20px auto;
            padding: 0 20px;
        }
        .article-card {
            background: white;
            border-radius: 12px;
            box-shadow: 0 4px 20px rgba(0,0,0,0.08);
            overflow: hidden;
            margin-bottom: 30px;
        }
        .article-header {
            padding: 40px 40px 20px;
            border-bottom: 1px solid #f0f0f0;
        }
        .article-title {
            font-size: 32px;
            font-weight: 700;
            color: #1a1a1a;
            margin-bottom: 15px;
            line-height: 1.3;
        }
        .article-meta {
            display: flex;
            align-items: center;
            gap: 20px;
            flex-wrap: wrap;
            font-size: 14px;
            color: #666;
        }
        .meta-item {
            display: flex;
            align-items: center;
            gap: 6px;
        }
        .meta-item i {
            font-size: 16px;
        }
        .author-avatar {
            width: 32px;
            height: 32px;
            border-radius: 50%;
            object-fit: cover;
        }

        /* 标签样式 */
        .tag-section {
            margin-top: 20px;
            padding: 15px 0;
            border-top: 1px solid #f0f0f0;
        }
        .tag-label {
            font-size: 14px;
            color: #666;
            margin-bottom: 10px;
            display: flex;
            align-items: center;
            gap: 5px;
        }
        .tag-label i {
            color: #66d6ea;
        }
        .tag-list {
            display: flex;
            gap: 8px;
            flex-wrap: wrap;
        }
        .tag {
            padding: 6px 12px;
            background: #f0f7ff;
            color: #1890ff;
            border-radius: 20px;
            font-size: 12px;
            border: 1px solid #d6e4ff;
            transition: all 0.3s ease;
            text-decoration: none;
            display: inline-block;
        }
        .tag:hover {
            background: #1890ff;
            color: white;
            transform: translateY(-1px);
            box-shadow: 0 2px 8px rgba(24, 144, 255, 0.3);
        }
        .no-tags {
            font-size: 12px;
            color: #999;
            font-style: italic;
        }

        .article-content {
            padding: 40px;
            font-size: 16px;
            line-height: 1.8;
            color: #2d3748;
        }
        .article-content p {
            margin-bottom: 20px;
        }
        .article-footer {
            padding: 20px 40px;
            background: #f8f9fa;
            border-top: 1px solid #f0f0f0;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        .action-buttons {
            display: flex;
            gap: 10px;
        }
        .btn {
            padding: 8px 16px;
            border: none;
            border-radius: 6px;
            cursor: pointer;
            text-decoration: none;
            font-size: 14px;
            display: inline-flex;
            align-items: center;
            gap: 5px;
            transition: all 0.3s ease;
        }
        .btn-like {
            background: #fff;
            border: 1px solid #e8e8e8;
            color: #666;
        }
        .btn-like:hover {
            border-color: #ff4d4f;
            color: #ff4d4f;
        }
        .btn-like.liked {
            background: #fff2f0;
            border-color: #ff4d4f;
            color: #ff4d4f;
        }
        .stats {
            display: flex;
            gap: 20px;
            font-size: 14px;
            color: #666;
        }
        .related-articles {
            margin-top: 40px;
        }
        .section-title {
            font-size: 20px;
            font-weight: 600;
            margin-bottom: 20px;
            color: #1a1a1a;
            padding-bottom: 10px;
            border-bottom: 2px solid #1890ff;
        }
        .related-list {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
            gap: 20px;
        }
        .related-card {
            background: white;
            padding: 20px;
            border-radius: 8px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.1);
            transition: transform 0.3s ease;
        }
        .related-card:hover {
            transform: translateY(-2px);
        }
        .related-title {
            font-size: 16px;
            font-weight: 600;
            margin-bottom: 10px;
            color: #333;
            text-decoration: none;
            display: block;
        }
        .related-title:hover {
            color: #1890ff;
        }
        .error-message {
            text-align: center;
            padding: 60px 20px;
            color: #666;
        }
        .error-message i {
            font-size: 48px;
            margin-bottom: 20px;
            color: #ff4d4f;
        }

        /* 取消点赞按钮样式 */
        .btn-unlike {
            background: #fff2f0;
            border: 1px solid #ff4d4f;
            color: #ff4d4f;
            padding: 8px 16px;
            border-radius: 6px;
            cursor: pointer;
            font-size: 14px;
            display: inline-flex;
            align-items: center;
            gap: 5px;
            transition: all 0.3s ease;
        }

        .btn-unlike:hover {
            background: #ff4d4f;
            color: white;
            transform: translateY(-1px);
            box-shadow: 0 2px 8px rgba(255, 77, 79, 0.3);
        }

        .btn-unlike:disabled {
            opacity: 0.6;
            cursor: not-allowed;
        }

        /* 收藏按钮样式 */
        .btn-favorite {
            background: #fff;
            border: 1px solid #e8e8e8;
            color: #666;
            padding: 8px 16px;
            border-radius: 6px;
            cursor: pointer;
            font-size: 14px;
            display: inline-flex;
            align-items: center;
            gap: 5px;
            transition: all 0.3s ease;
        }

        .btn-favorite:hover {
            border-color: #ffc107;
            color: #ffc107;
        }

        .btn-favorite.favorited {
            background: #fffbf0;
            border-color: #ffc107;
            color: #ffc107;
        }

        .btn-favorite:disabled {
            opacity: 0.6;
            cursor: not-allowed;
        }

        /* 评论按钮样式 */
        .btn-comment {
            background: #fff;
            border: 1px solid #e8e8e8;
            color: #666;
            padding: 8px 16px;
            border-radius: 6px;
            cursor: pointer;
            font-size: 14px;
            display: inline-flex;
            align-items: center;
            gap: 5px;
            transition: all 0.3s ease;
        }

        .btn-comment:hover {
            border-color: #1890ff;
            color: #1890ff;
        }

        /* 弹窗样式 */
        .modal-overlay {
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: rgba(0, 0, 0, 0.5);
            display: none;
            justify-content: center;
            align-items: center;
            z-index: 1000;
        }

        .modal-content {
            background: white;
            border-radius: 12px;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.3);
            max-width: 500px;
            width: 90%;
            max-height: 80vh;
            overflow: hidden;
        }

        .modal-header {
            padding: 20px;
            border-bottom: 1px solid #f0f0f0;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .modal-title {
            font-size: 18px;
            font-weight: 600;
            color: #333;
            display: flex;
            align-items: center;
            gap: 8px;
        }

        .modal-close {
            background: none;
            border: none;
            font-size: 20px;
            cursor: pointer;
            color: #999;
            padding: 5px;
        }

        .modal-close:hover {
            color: #666;
        }

        .modal-body {
            padding: 20px;
            max-height: 400px;
            overflow-y: auto;
        }

        /* 收藏夹列表样式 */
        .folder-section {
            margin-bottom: 20px;
        }

        .section-title {
            font-size: 14px;
            color: #666;
            margin-bottom: 10px;
            font-weight: 600;
        }

        .folder-list {
            display: flex;
            flex-direction: column;
            gap: 10px;
        }

        .folder-item {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 12px;
            border: 1px solid #f0f0f0;
            border-radius: 8px;
            transition: all 0.3s ease;
        }

        .folder-item:hover {
            border-color: #1890ff;
            background: #f0f7ff;
        }

        .folder-info {
            flex: 1;
        }

        .folder-name {
            font-weight: 600;
            color: #333;
            margin-bottom: 4px;
        }

        .folder-meta {
            font-size: 12px;
            color: #999;
        }

        .folder-action {
            margin-left: 10px;
        }

        .btn-add {
            background: #1890ff;
            color: white;
            border: none;
            padding: 6px 12px;
            border-radius: 4px;
            font-size: 12px;
            cursor: pointer;
            transition: background 0.3s ease;
        }

        .btn-add:hover {
            background: #40a9ff;
        }

        .btn-added {
            background: #52c41a;
            color: white;
        }

        .btn-added:hover {
            background: #73d13d;
        }

        .create-folder-btn {
            background: #f0f7ff;
            border: 1px dashed #1890ff;
            color: #1890ff;
            padding: 12px;
            border-radius: 8px;
            cursor: pointer;
            text-align: center;
            font-weight: 600;
            transition: all 0.3s ease;
            margin-top: 10px;
        }

        .create-folder-btn:hover {
            background: #e6f7ff;
        }

        /* 评论弹窗样式 */
        .comment-drawer {
            position: fixed;
            top: 0;
            right: 0;
            width: 400px;
            height: 100vh;
            background: white;
            box-shadow: -5px 0 15px rgba(0,0,0,0.1);
            z-index: 1001;
            display: flex;
            flex-direction: column;
        }

        .drawer-header {
            padding: 20px;
            border-bottom: 1px solid #f0f0f0;
            background: #fff;
            position: sticky;
            top: 0;
            z-index: 10;
        }

        .drawer-title {
            font-size: 18px;
            font-weight: 600;
            color: #333;
            display: flex;
            align-items: center;
            gap: 8px;
        }

        .drawer-close {
            background: none;
            border: none;
            font-size: 20px;
            cursor: pointer;
            color: #999;
            padding: 5px;
            position: absolute;
            right: 15px;
            top: 15px;
        }

        .drawer-close:hover {
            color: #666;
        }

        .comment-count {
            font-size: 14px;
            color: #666;
            margin-top: 5px;
        }

        .drawer-body {
            flex: 1;
            overflow-y: auto;
            padding: 0;
        }

        .comment-list {
            padding: 0;
        }

        .comment-item {
            padding: 15px 20px;
            border-bottom: 1px solid #f8f8f8;
            transition: background 0.3s ease;
            position: relative;
        }

        .comment-item:hover {
            background: #f8f9fa;
        }

        .comment-content {
            font-size: 14px;
            line-height: 1.6;
            color: #333;
            margin-bottom: 8px;
        }

        .comment-meta {
            display: flex;
            align-items: center;
            gap: 10px;
            font-size: 12px;
            color: #999;
        }

        .comment-author {
            font-weight: 600;
            color: #1890ff;
        }

        .comment-time {
            color: #999;
        }

        .comment-actions {
            position: absolute;
            right: 20px;
            top: 15px;
            opacity: 0;
            transition: opacity 0.3s ease;
        }

        .comment-item:hover .comment-actions {
            opacity: 1;
        }

        .btn-reply {
            background: none;
            border: none;
            color: #1890ff;
            font-size: 12px;
            cursor: pointer;
            padding: 2px 6px;
            border-radius: 3px;
            transition: background 0.3s ease;
        }

        .btn-reply:hover {
            background: #e6f7ff;
        }

        .btn-collapse {
            background: none;
            border: none;
            color: #ff4d4f;
            font-size: 12px;
            cursor: pointer;
            padding: 2px 6px;
            border-radius: 3px;
            transition: background 0.3s ease;
        }

        .btn-collapse:hover {
            background: #fff2f0;
        }

        .reply-form {
            margin-top: 10px;
            padding: 10px;
            background: #f8f9fa;
            border-radius: 6px;
            display: none;
        }

        .reply-form.active {
            display: block;
        }

        .reply-input {
            width: 100%;
            padding: 8px 12px;
            border: 1px solid #ddd;
            border-radius: 4px;
            resize: vertical;
            min-height: 60px;
            font-size: 14px;
            margin-bottom: 8px;
        }

        .reply-input:focus {
            outline: none;
            border-color: #1890ff;
        }

        .char-count {
            text-align: right;
            font-size: 12px;
            color: #999;
            margin-bottom: 8px;
        }

        .btn-send {
            background: #1890ff;
            color: white;
            border: none;
            padding: 6px 16px;
            border-radius: 4px;
            cursor: pointer;
            font-size: 12px;
            transition: background 0.3s ease;
        }

        .btn-send:hover {
            background: #40a9ff;
        }

        .btn-send:disabled {
            background: #ccc;
            cursor: not-allowed;
        }

        .replies-list {
            margin-top: 10px;
            padding-left: 15px;
            border-left: 2px solid #e8e8e8;
        }

        .reply-item {
            padding: 10px;
            background: #f8f9fa;
            border-radius: 4px;
            margin-bottom: 8px;
        }

        .reply-content {
            font-size: 13px;
            line-height: 1.5;
            color: #333;
        }

        .reply-meta {
            font-size: 11px;
            color: #999;
            margin-top: 4px;
        }

        .comment-input-section {
            padding: 20px;
            border-top: 1px solid #f0f0f0;
            background: white;
        }

        .comment-input {
            width: 100%;
            padding: 12px;
            border: 1px solid #ddd;
            border-radius: 6px;
            resize: vertical;
            min-height: 80px;
            font-size: 14px;
            margin-bottom: 10px;
        }

        .comment-input:focus {
            outline: none;
            border-color: #1890ff;
        }

        .input-actions {
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .btn-comment-send {
            background: #1890ff;
            color: white;
            border: none;
            padding: 8px 20px;
            border-radius: 6px;
            cursor: pointer;
            font-size: 14px;
            transition: background 0.3s ease;
        }

        .btn-comment-send:hover {
            background: #40a9ff;
        }

        .btn-comment-send:disabled {
            background: #ccc;
            cursor: not-allowed;
        }

        .empty-comments {
            text-align: center;
            padding: 40px 20px;
            color: #999;
        }

        .empty-icon {
            font-size: 48px;
            margin-bottom: 16px;
            color: #ccc;
        }

        .empty-text {
            font-size: 14px;
            margin-bottom: 8px;
        }

        @media (max-width: 768px) {
            .article-container {
                padding: 0 15px;
            }
            .article-header {
                padding: 30px 20px 15px;
            }
            .article-title {
                font-size: 24px;
            }
            .article-content {
                padding: 20px;
            }
            .article-footer {
                padding: 15px 20px;
                flex-direction: column;
                gap: 15px;
                align-items: flex-start;
            }
            .comment-drawer {
                width: 100%;
            }
        }
    </style>
</head>
<body>
<%@ include file="/jsp/user/head.jsp" %>

<div class="article-container">
    <c:if test="${not empty sessionScope.message}">
        <div class="alert alert-success" style="background: #f6ffed; border: 1px solid #b7eb8f; color: #389e0d; padding: 12px; border-radius: 6px; margin-bottom: 20px;">
            <i class="fas fa-check-circle"></i> ${sessionScope.message}
            <c:remove var="message" scope="session"/>
        </div>
    </c:if>

    <c:choose>
        <c:when test="${not empty article}">
            <!-- 文章内容 -->
            <div class="article-card">
                <div class="article-header">
                    <h1 class="article-title">${article.title}</h1>
                    <div class="article-meta">
                        <div class="meta-item">
                            <c:choose>
                                <c:when test="${not empty article.author.avatar}">
                                    <img src="${article.author.avatar}" alt="头像" class="author-avatar">
                                </c:when>
                                <c:otherwise>
                                    <i class="fas fa-user-circle"></i>
                                </c:otherwise>
                            </c:choose>
                            <span>${article.author.username}</span>
                        </div>
                        <div class="meta-item">
                            <i class="fas fa-calendar"></i>
                            <span>${article.postTime}</span>
                        </div>
                        <div class="meta-item">
                            <i class="fas fa-eye"></i>
                            <span>${article.hits} 浏览</span>
                        </div>
                        <div class="meta-item">
                            <i class="fas fa-thumbs-up"></i>
                            <span id="likeCount">${article.likes} 点赞</span>
                        </div>
                    </div>

                    <!-- 标签显示区域 -->
                    <div class="tag-section">
                        <div class="tag-label">
                            <i class="fas fa-tags"></i> 文章标签
                        </div>
                        <div class="tag-list">
                            <c:choose>
                                <c:when test="${not empty article.tags}">
                                    <c:forEach items="${article.tags}" var="tag">
                                        <a href="${pageContext.request.contextPath}/search?keyword=${tag.name}&type=article"
                                           class="tag" title="搜索包含此标签的文章">
                                            <i class="fas fa-hashtag"></i>${tag.name}
                                        </a>
                                    </c:forEach>
                                </c:when>
                                <c:otherwise>
                                    <span class="no-tags">暂无标签</span>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>
                </div>

                <div class="article-content">
                        ${article.content}
                </div>

                <div class="article-footer">
                    <div class="action-buttons">
                        <!-- 点赞按钮 -->
                        <button class="btn btn-like" id="likeBtn" onclick="likeArticle(${article.id})">
                            <i class="fas fa-thumbs-up"></i>
                            <span id="likeText">点赞</span>
                        </button>

                        <!-- 收藏按钮 -->
                        <button class="btn btn-favorite" id="favoriteBtn" onclick="showFavoriteDialog(${article.id})">
                            <i class="fas fa-star" id="favoriteIcon"></i>
                            <span id="favoriteText">收藏</span>
                        </button>

                        <!-- 评论按钮 -->
                        <button class="btn btn-comment" id="commentBtn" onclick="showCommentDrawer(${article.id})">
                            <i class="fas fa-comment"></i>
                            <span>评论</span>
                        </button>
                    </div>
                    <div class="stats">
                        <span class="stat-item">最后编辑: ${article.editTime}</span>
                    </div>
                </div>
            </div>

            <!-- 相关文章 -->
            <c:if test="${not empty relatedArticles}">
                <div class="related-articles">
                    <h3 class="section-title">相关推荐</h3>
                    <div class="related-list">
                        <c:forEach items="${relatedArticles}" var="related">
                            <div class="related-card">
                                <a href="${pageContext.request.contextPath}/article/detail?id=${related.id}"
                                   class="related-title">${related.title}</a>
                                <div style="font-size: 12px; color: #666; margin-top: 5px;">
                                    <span>${related.author.username} • ${related.postTime}</span>
                                </div>
                            </div>
                        </c:forEach>
                    </div>
                </div>
            </c:if>
        </c:when>
        <c:otherwise>
            <div class="error-message">
                <i class="fas fa-exclamation-triangle"></i>
                <h2>文章不存在</h2>
                <p>抱歉，您要查看的文章不存在或已被删除</p>
            </div>
        </c:otherwise>
    </c:choose>
</div>

<!-- 收藏弹窗 -->
<div id="favoriteModal" class="modal-overlay">
    <div class="modal-content">
        <div class="modal-header">
            <h3 class="modal-title">
                <i class="fas fa-folder-plus" style="color: #ffc107;"></i>
                添加收藏夹
            </h3>
            <button class="modal-close" onclick="closeFavoriteModal()">&times;</button>
        </div>
        <div class="modal-body" id="folderListContent">
            <!-- 内容由JavaScript动态加载 -->
        </div>
    </div>
</div>

<!-- 评论弹窗 -->
<div id="commentDrawer" class="comment-drawer" style="display: none;">
    <div class="drawer-body" id="commentBody">
        <!-- 内容由iframe加载 -->
        <iframe id="commentIframe" style="width: 100%; height: 100%; border: none;"></iframe>
    </div>
</div>

<script>
    // 页面加载时检查点赞状态
    document.addEventListener('DOMContentLoaded', function () {
        checkLikeStatus(${article.id});
    });

    // 点赞相关函数
    function checkLikeStatus(articleId) {
        fetch('${pageContext.request.contextPath}/article/check-like?id=' + articleId, {
            method: 'GET'
        })
            .then(response => response.json())
            .then(data => {
                if (data.success) {
                    updateLikeButton(data.hasLiked);
                }
            })
            .catch(error => console.error('检查点赞状态失败:', error));
    }

    function updateLikeButton(hasLiked) {
        const likeBtn = document.getElementById('likeBtn');
        const likeText = document.getElementById('likeText');

        if (hasLiked) {
            likeBtn.classList.add('liked');
            likeBtn.classList.remove('btn-like');
            likeBtn.classList.add('btn-unlike');
            likeBtn.innerHTML = '<i class="fas fa-thumbs-up"></i> 点赞';
            likeBtn.disabled = false;
        } else {
            likeBtn.classList.remove('liked');
            likeBtn.classList.remove('btn-unlike');
            likeBtn.classList.add('btn-like');
            likeBtn.innerHTML = '<i class="fas fa-thumbs-up"></i> 点赞';
            likeBtn.disabled = false;
        }
    }

    function likeArticle(articleId) {
        const likeBtn = document.getElementById('likeBtn');
        const likeCount = document.getElementById('likeCount');

        if (likeBtn.disabled) return;

        likeBtn.disabled = true;

        const isLiked = likeBtn.classList.contains('liked');
        const action = isLiked ? 'unlike' : 'like';

        likeBtn.innerHTML = '<i class="fas fa-spinner fa-spin"></i> ' + (isLiked ? '取消中...' : '点赞中...');

        fetch('${pageContext.request.contextPath}/article/like?id=' + articleId + '&action=' + action, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/x-www-form-urlencoded',
            }
        })
            .then(response => response.json())
            .then(data => {
                if (data.success) {
                    likeCount.textContent = data.likes + ' 点赞';
                    updateLikeButton(action === 'like');
                    showMessage(data.message, 'success');
                } else {
                    showMessage(data.message, 'error');
                    checkLikeStatus(articleId);
                }
            })
            .catch(error => {
                console.error('Error:', error);
                showMessage('操作失败，请稍后重试', 'error');
                checkLikeStatus(articleId);
            })
            .finally(() => {
                likeBtn.disabled = false;
            });
    }

    // 收藏相关函数
    function showFavoriteDialog(articleId) {
        console.log('显示收藏弹窗，文章ID:', articleId);

        const modalBody = document.getElementById('folderListContent');
        modalBody.innerHTML = `
            <iframe id="folderIframe"
                    src="${pageContext.request.contextPath}/folder/list?articleId=${article.id}"
                    style="width: 100%; height: 400px; border: none;">
            </iframe>
        `;

        document.getElementById('favoriteModal').style.display = 'flex';
    }

    function closeFavoriteModal() {
        document.getElementById('favoriteModal').style.display = 'none';
    }

    // 评论相关函数
    // 确保评论弹窗正确初始化
    /*function showCommentDrawer(articleId) {
        console.log('显示评论弹窗，文章ID:', articleId);

        const commentDrawer = document.getElementById('commentDrawer');
        const commentIframe = document.getElementById('commentIframe');

        if (!commentDrawer || !commentIframe) {
            console.error('评论弹窗元素未找到');
            showMessage('评论功能加载失败，请刷新页面重试', 'error');
            return;
        }

        // 设置iframe源
        commentIframe.src = '${pageContext.request.contextPath}/comment/drawer?articleId=' + articleId;
        commentDrawer.style.display = 'flex';

        // 监听iframe加载完成
        commentIframe.onload = function() {
            console.log('评论iframe加载完成');
            try {
                // 调用iframe中的初始化函数
                if (commentIframe.contentWindow && commentIframe.contentWindow.initCommentDrawer) {
                    commentIframe.contentWindow.initCommentDrawer(articleId);
                }
            } catch (e) {
                console.error('初始化评论弹窗失败:', e);
            }
        };

        // 监听iframe加载错误
        commentIframe.onerror = function() {
            console.error('评论iframe加载失败');
            showMessage('评论功能加载失败，请刷新页面重试', 'error');
            commentDrawer.style.display = 'none';
        };
    }*/
    // 确保评论弹窗正确初始化
    function showCommentDrawer(articleId) {
        console.log('显示评论弹窗，文章ID:', articleId);

        const commentDrawer = document.getElementById('commentDrawer');
        const commentIframe = document.getElementById('commentIframe');

        if (!commentDrawer || !commentIframe) {
            console.error('评论弹窗元素未找到');
            showMessage('评论功能加载失败，请刷新页面重试', 'error');
            return;
        }

        // 修复：设置正确的iframe路径（后端新增的/drawer路径）
        commentIframe.src = '${pageContext.request.contextPath}/comment/drawer?articleId=' + articleId;
        commentDrawer.style.display = 'flex';

        // 监听iframe加载完成
        commentIframe.onload = function() {
            console.log('评论iframe加载完成');
            try {
                // 调用iframe中的初始化函数
                if (commentIframe.contentWindow && commentIframe.contentWindow.initCommentDrawer) {
                    commentIframe.contentWindow.initCommentDrawer(articleId);
                }
            } catch (e) {
                console.error('初始化评论弹窗失败:', e);
            }
        };

        // 监听iframe加载错误
        commentIframe.onerror = function() {
            console.error('评论iframe加载失败');
            showMessage('评论功能加载失败，请刷新页面重试', 'error');
            commentDrawer.style.display = 'none';
        };
    }

    function closeCommentDrawer() {
        document.getElementById('commentDrawer').style.display = 'none';
    }

    // 点击遮罩层关闭弹窗
    document.addEventListener('click', function(e) {
        if (e.target.classList.contains('modal-overlay')) {
            closeFavoriteModal();
        }
        if (e.target.id === 'commentDrawer') {
            closeCommentDrawer();
        }
    });

    // 显示消息提示
    function showMessage(message, type) {
        const existingAlert = document.querySelector('.alert-message');
        if (existingAlert) {
            existingAlert.remove();
        }

        const alertDiv = document.createElement('div');
        alertDiv.className = 'alert-message';
        alertDiv.style.cssText = `
            position: fixed;
            top: 20px;
            right: 20px;
            padding: 12px 20px;
            border-radius: 6px;
            color: white;
            font-weight: bold;
            z-index: 1000;
            background: ${type == 'success' ? '#52c41a' : '#ff4d4f'};
            box-shadow: 0 4px 12px rgba(0,0,0,0.15);
        `;

        const iconClass = type == 'success' ? 'fa-check-circle' : 'fa-exclamation-circle';
        alertDiv.innerHTML = `<i class="fas ${iconClass}"></i> ${message}`;

        document.body.appendChild(alertDiv);

        setTimeout(() => {
            alertDiv.style.opacity = '0';
            setTimeout(() => alertDiv.remove(), 300);
        }, 3000);
    }
</script>

<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
</body>
</html>