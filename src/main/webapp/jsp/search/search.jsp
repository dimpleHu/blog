<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page isELIgnored="false" %>
<c:if test="${empty sessionScope.user}">
    <c:redirect url="${pageContext.request.contextPath}/jsp/user/login.jsp"/>
</c:if>
<html>
<head>
    <title>搜索"${keyword}" - 个人博客系统</title>
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

        /* 搜索框样式 */
        .search-container {
            background: rgba(255,255,255,0.8);
            backdrop-filter: blur(8px);
            padding: 18px 0;
            box-shadow: 0 2px 8px rgba(0,0,0,0.1);
            margin-bottom: 30px;
        }
        .search-box {
            max-width: 800px;
            margin: 0 auto;
            display: flex;
            gap: 10px;
            padding: 0 20px;
        }
        .search-input {
            flex: 1;
            padding: 12px 25px;
            border: 1px solid rgba(200,200,200,0.5);
            border-radius: 20px;
            font-size: 16px;
            outline: none;
            transition: all 0.3s ease;
            background: rgba(255,255,255,0.5);
        }
        .search-input:focus {
            border-color: #66d6ea;
            box-shadow: 0 0 0 2px rgba(102, 214, 234, 0.2);
        }
        .search-btn {
            padding: 12px 25px;
            background: linear-gradient(135deg, #66d6ea 0%, #bbd8e1 100%);
            color: white;
            border: none;
            border-radius: 20px;
            font-size: 16px;
            cursor: pointer;
            transition: all 0.3s ease;
            display: flex;
            align-items: center;
            gap: 8px;
        }
        .search-btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 8px rgba(102, 214, 234, 0.3);
        }

        /* 搜索结果容器 */
        .search-results {
            max-width: 1200px;
            margin: 0 auto 30px;
            padding: 0 20px;
        }

        /* 搜索头部信息 */
        .search-header {
            background: rgba(255,255,255,0.8);
            backdrop-filter: blur(8px);
            padding: 25px;
            border-radius: 12px;
            margin-bottom: 30px;
            box-shadow: 0 4px 12px rgba(0,0,0,0.1);
            border: 1px solid rgba(200,200,200,0.3);
        }
        .search-header h2 {
            font-size: 22px;
            color: #333;
            margin-bottom: 12px;
            display: flex;
            align-items: center;
        }
        .search-header h2 i {
            color: #66d6ea;
            margin-right: 10px;
            font-size: 24px;
        }
        .result-count {
            color: #666;
            margin-bottom: 15px;
            font-size: 15px;
        }
        .search-keyword {
            color: #66d6ea;
            font-weight: bold;
            padding: 2px 5px;
            border-radius: 4px;
            background: rgba(102, 214, 234, 0.1);
        }

        /* 标签页样式 */
        .search-tabs {
            background: rgba(255,255,255,0.8);
            backdrop-filter: blur(8px);
            border-radius: 12px;
            margin-bottom: 30px;
            box-shadow: 0 4px 12px rgba(0,0,0,0.1);
            border: 1px solid rgba(200,200,200,0.3);
        }
        .tab-header {
            display: flex;
            border-bottom: 1px solid rgba(200,200,200,0.3);
        }
        .tab-item {
            padding: 15px 25px;
            cursor: pointer;
            font-size: 16px;
            border-bottom: 3px solid transparent;
            transition: all 0.3s ease;
            display: flex;
            align-items: center;
            gap: 8px;
        }
        .tab-item:hover {
            background: rgba(102, 214, 234, 0.1);
        }
        .tab-item.active {
            border-bottom-color: #66d6ea;
            color: #66d6ea;
            font-weight: bold;
        }
        .tab-count {
            background: #66d6ea;
            color: white;
            border-radius: 12px;
            padding: 2px 8px;
            font-size: 12px;
        }
        .tab-content {
            padding: 0;
            display: none;
        }
        .tab-content.active {
            display: block;
        }

        /* 文章列表网格布局 */
        .articles-list {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(280px, 1fr));
            gap: 25px;
            padding: 25px;
        }

        /* 文章卡片样式 */
        .article-card {
            background: rgba(255,255,255,0.8);
            backdrop-filter: blur(5px);
            border-radius: 12px;
            overflow: hidden;
            box-shadow: 0 4px 12px rgba(0,0,0,0.1);
            transition: all 0.3s ease;
            border: 1px solid rgba(200,200,200,0.3);
        }
        .article-card:hover {
            transform: translateY(-8px);
            box-shadow: 0 8px 16px rgba(102, 214, 234, 0.2);
        }
        .article-content {
            padding: 22px;
        }
        .article-title {
            font-size: 18px;
            margin-bottom: 12px;
            color: #333;
            text-decoration: none;
            display: block;
            transition: color 0.3s;
            line-height: 1.5;
        }
        .article-title:hover {
            color: #66d6ea;
        }
        .article-summary {
            color: #666;
            font-size: 14px;
            margin-bottom: 18px;
            display: -webkit-box;
            -webkit-line-clamp: 3;
            -webkit-box-orient: vertical;
            overflow: hidden;
            line-height: 1.6;
        }

        /* 文章元信息 */
        .article-meta {
            display: flex;
            flex-wrap: wrap;
            gap: 12px;
            font-size: 12px;
            color: #666;
        }
        .article-meta span {
            display: flex;
            align-items: center;
            gap: 5px;
        }
        .article-meta i {
            font-size: 14px;
            color: #66d6ea;
        }

        /* 文章标签样式 */
        .article-tags {
            margin-bottom: 15px;
            font-size: 12px;
            color: #666;
            display: flex;
            align-items: center;
            flex-wrap: wrap;
            gap: 5px;
        }
        .tag-badge {
            background: rgba(102, 214, 234, 0.1);
            color: #66d6ea;
            padding: 2px 8px;
            border-radius: 12px;
            font-size: 11px;
            border: 1px solid rgba(102, 214, 234, 0.3);
        }

        /* 标签列表样式 */
        .tags-list {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 20px;
            padding: 25px;
        }
        .tag-card {
            background: rgba(255,255,255,0.8);
            backdrop-filter: blur(5px);
            border-radius: 12px;
            padding: 20px;
            text-align: center;
            box-shadow: 0 4px 12px rgba(0,0,0,0.1);
            transition: all 0.3s ease;
            border: 1px solid rgba(200,200,200,0.3);
        }
        .tag-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 8px 16px rgba(102, 214, 234, 0.2);
        }
        .tag-name {
            font-size: 18px;
            font-weight: bold;
            color: #333;
            margin-bottom: 10px;
        }
        .tag-color {
            width: 40px;
            height: 40px;
            border-radius: 50%;
            margin: 0 auto 10px;
            border: 3px solid rgba(255,255,255,0.8);
        }
        .tag-meta {
            font-size: 12px;
            color: #666;
        }

        /* 用户列表样式 */
        .users-list {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 20px;
            padding: 25px;
        }
        .user-card {
            background: rgba(255,255,255,0.8);
            backdrop-filter: blur(5px);
            border-radius: 12px;
            padding: 20px;
            display: flex;
            align-items: center;
            gap: 15px;
            box-shadow: 0 4px 12px rgba(0,0,0,0.1);
            transition: all 0.3s ease;
            border: 1px solid rgba(200,200,200,0.3);
        }
        .user-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 8px 16px rgba(102, 214, 234, 0.2);
        }
        .user-avatar {
            width: 60px;
            height: 60px;
            border-radius: 50%;
            object-fit: cover;
            border: 3px solid #66d6ea;
        }
        .user-info {
            flex: 1;
        }
        .user-name {
            font-size: 18px;
            font-weight: bold;
            color: #333;
            margin-bottom: 5px;
            text-decoration: none;
        }
        .user-name:hover {
            color: #66d6ea;
        }
        .user-signature {
            color: #666;
            font-size: 14px;
            display: -webkit-box;
            -webkit-line-clamp: 2;
            -webkit-box-orient: vertical;
            overflow: hidden;
        }
        .user-meta {
            font-size: 12px;
            color: #999;
            margin-top: 5px;
        }

        /* 无结果样式 */
        .no-result {
            text-align: center;
            padding: 60px 20px;
            color: #999;
            background: rgba(255,255,255,0.8);
            border-radius: 12px;
            margin: 25px;
            box-shadow: 0 4px 12px rgba(0,0,0,0.1);
            border: 1px solid rgba(200,200,200,0.3);
        }
        .no-result i {
            font-size: 60px;
            margin-bottom: 25px;
            color: #66d6ea;
            opacity: 0.6;
        }
        .no-result p {
            font-size: 16px;
            margin-bottom: 30px;
            line-height: 1.8;
        }
        .no-result p span {
            color: #66d6ea;
            font-weight: bold;
        }

        /* 按钮样式 */
        .btn {
            padding: 10px 22px;
            background: linear-gradient(135deg, #66d6ea 0%, #bbd8e1 100%);
            color: white;
            border: none;
            border-radius: 20px;
            font-size: 14px;
            cursor: pointer;
            text-decoration: none;
            transition: all 0.3s ease;
            display: inline-flex;
            align-items: center;
            gap: 8px;
        }
        .btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 8px rgba(102, 214, 234, 0.3);
            color: white;
        }

        @media (max-width: 768px) {
            .search-results {
                padding: 0 15px;
            }
            .search-header {
                padding: 20px;
            }
            .tab-item {
                padding: 12px 15px;
                font-size: 14px;
            }
            .articles-list, .tags-list, .users-list {
                grid-template-columns: 1fr;
                gap: 15px;
                padding: 15px;
            }
            .user-card {
                flex-direction: column;
                text-align: center;
            }
            .search-box {
                flex-direction: column;
                gap: 15px;
            }
            .search-input, .search-btn {
                width: 100%;
                border-radius: 10px;
            }
        }
    </style>
</head>
<body>
<%@ include file="/jsp/user/head.jsp" %>

<!-- 搜索框区域 -->
<div class="search-container">
    <form class="search-box" action="${pageContext.request.contextPath}/search" method="get">
        <input type="text" name="keyword" class="search-input"
               placeholder="搜索文章标题、标签、用户..." value="${keyword}" id="searchInput">
        <button type="submit" class="search-btn">
            <i class="fas fa-search"></i> 搜索
        </button>
    </form>
</div>

<div class="search-results">
    <div class="search-header">
        <h2><i class="fas fa-search"></i> 搜索结果</h2>
        <p class="result-count">
            找到 <span style="color: #66d6ea; font-weight: bold;">${totalCount}</span> 个关于
            "<span class="search-keyword">${keyword}</span>" 的结果
        </p>
    </div>

    <!-- 标签页导航 -->
    <div class="search-tabs">
        <div class="tab-header">
            <div class="tab-item active" data-tab="articles">
                <i class="fas fa-file-alt"></i> 文章
                <span class="tab-count">${resultCounts.articles}</span>
            </div>
            <div class="tab-item" data-tab="tags">
                <i class="fas fa-tags"></i> 标签
                <span class="tab-count">${resultCounts.tags}</span>
            </div>
            <div class="tab-item" data-tab="users">
                <i class="fas fa-users"></i> 用户
                <span class="tab-count">${resultCounts.users}</span>
            </div>
        </div>

        <!-- 文章搜索结果 -->
        <div class="tab-content active" id="articles-tab">
            <c:choose>
                <c:when test="${not empty searchResults.articles}">
                    <div class="articles-list">
                        <c:forEach items="${searchResults.articles}" var="article">
                            <div class="article-card">
                                <div class="article-content">
                                    <a href="${pageContext.request.contextPath}/article/detail?id=${article.id}"
                                       class="article-title">${article.title}</a>
                                    <p class="article-summary">${article.summary}</p>

                                    <!-- 显示文章标签 -->
                                    <c:if test="${not empty article.tagNames}">
                                        <div class="article-tags">
                                            <i class="fas fa-tags" style="color: #66d6ea; margin-right: 5px;"></i>
                                            <c:forEach items="${article.tagNames}" var="tagName">
                                                <span class="tag-badge">${tagName}</span>
                                            </c:forEach>
                                        </div>
                                    </c:if>

                                    <div class="article-meta">
                                        <span><i class="fas fa-user"></i> ${article.author.username}</span>
                                        <span><i class="fas fa-calendar"></i> ${article.postTime}</span>
                                        <span><i class="fas fa-eye"></i> ${article.hits} 浏览</span>
                                        <span><i class="fas fa-thumbs-up"></i> ${article.likes} 点赞</span>
                                    </div>
                                </div>
                            </div>
                        </c:forEach>
                    </div>
                </c:when>
                <c:otherwise>
                    <div class="no-result">
                        <i class="fas fa-file-alt"></i>
                        <p>没有找到关于 "<span>${keyword}</span>" 的文章</p>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>

        <!-- 标签搜索结果 -->
        <div class="tab-content" id="tags-tab">
            <c:choose>
                <c:when test="${not empty searchResults.tags}">
                    <div class="tags-list">
                        <c:forEach items="${searchResults.tags}" var="tag">
                            <div class="tag-card">
                                <div class="tag-color" style="background-color: ${tag.color};"></div>
                                <div class="tag-name">${tag.name}</div>
                                <div class="tag-meta">
                                    <span><i class="fas fa-chart-bar"></i> 使用 ${tag.useCount} 次</span>
                                </div>
                            </div>
                        </c:forEach>
                    </div>
                </c:when>
                <c:otherwise>
                    <div class="no-result">
                        <i class="fas fa-tags"></i>
                        <p>没有找到关于 "<span>${keyword}</span>" 的标签</p>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>

        <!-- 用户搜索结果 -->
        <div class="tab-content" id="users-tab">
            <c:choose>
                <c:when test="${not empty searchResults.users}">
                    <div class="users-list">
                        <c:forEach items="${searchResults.users}" var="user">
                            <div class="user-card">
                                <img src="${pageContext.request.contextPath}${user.avatar}"
                                     alt="${user.username}" class="user-avatar"
                                     onerror="this.src='${pageContext.request.contextPath}/images/default-avatar.png'">
                                <div class="user-info">
                                    <a href="${pageContext.request.contextPath}/user/profile?id=${user.id}"
                                       class="user-name">${user.username}</a>
                                    <p class="user-signature">${user.signature}</p>
                                    <div class="user-meta">
                                        <span><i class="fas fa-calendar"></i> 注册时间: ${user.createTime}</span>
                                    </div>
                                </div>
                            </div>
                        </c:forEach>
                    </div>
                </c:when>
                <c:otherwise>
                    <div class="no-result">
                        <i class="fas fa-users"></i>
                        <p>没有找到关于 "<span>${keyword}</span>" 的用户</p>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>
    </div>
</div>

<script>
    // 标签页切换功能
    document.addEventListener('DOMContentLoaded', function() {
        const tabItems = document.querySelectorAll('.tab-item');
        const tabContents = document.querySelectorAll('.tab-content');

        tabItems.forEach(item => {
            item.addEventListener('click', function() {
                const tabId = this.getAttribute('data-tab');

                // 移除所有active类
                tabItems.forEach(tab => tab.classList.remove('active'));
                tabContents.forEach(content => content.classList.remove('active'));

                // 添加active类到当前标签和内容
                this.classList.add('active');
                document.getElementById(tabId + '-tab').classList.add('active');

                // 更新URL参数
                updateUrlParam('type', tabId);
            });
        });

        // 根据URL参数设置初始激活的标签页
        const urlParams = new URLSearchParams(window.location.search);
        const type = urlParams.get('type');
        if (type && ['articles', 'tags', 'users'].includes(type)) {
            const targetTab = document.querySelector(`.tab-item[data-tab="${type}"]`);
            if (targetTab) {
                targetTab.click();
            }
        }

        function updateUrlParam(key, value) {
            const url = new URL(window.location);
            url.searchParams.set(key, value);
            window.history.replaceState({}, '', url);
        }

        // 搜索框自动聚焦
        const searchInput = document.getElementById('searchInput');
        if (searchInput) {
            searchInput.focus();
            // 选中所有文本方便重新搜索
            searchInput.select();
        }

        // 回车键搜索
        searchInput.addEventListener('keypress', function(e) {
            if (e.key === 'Enter') {
                e.preventDefault();
                this.form.submit();
            }
        });
    });
</script>

<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
</body>
</html>