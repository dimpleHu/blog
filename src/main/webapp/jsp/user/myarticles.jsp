<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page isELIgnored="false" %>
<c:if test="${empty sessionScope.user}">
    <c:redirect url="${pageContext.request.contextPath}/jsp/user/login.jsp"/>
</c:if>
<html>
<head>
    <title>${pageTitle} - 个人博客系统</title>
    <style>
        /* 全局布局：主体内容避开侧边栏和头部 */
        .main-wrapper {
            margin-left: 200px; /* 侧边栏展开宽度 */
            margin-top: 60px;  /* 头部导航栏高度 */
            min-height: calc(100vh - 60px);
            padding: 20px;
            box-sizing: border-box;
            background: #f0f2f5;
        }

        /* 侧边栏折叠时，主体内容自适应 */
        .sidebar-container.collapsed ~ .main-wrapper {
            margin-left: 64px;
        }

        .articles-container {
            background: rgba(255, 255, 255, 0.8);
            backdrop-filter: blur(5px);
            border-radius: 12px;
            padding: 30px;
            box-shadow: 0 4px 12px rgba(0,0,0,0.1);
            margin-bottom: 20px;
        }

        .article-list {
            display: flex;
            flex-direction: column;
            gap: 20px;
        }

        .article-item {
            border: 1px solid #f0f0f0;
            border-radius: 8px;
            padding: 20px;
            transition: all 0.3s ease;
        }

        .article-item:hover {
            border-color: rgba(102, 188, 234, 0.8);
            box-shadow: 0 2px 8px rgba(102, 188, 234, 0.1);
        }

        .article-title {
            font-size: 18px;
            font-weight: 600;
            margin-bottom: 10px;
            color: #333;
            text-decoration: none;
        }

        .article-meta {
            display: flex;
            gap: 20px;
            font-size: 14px;
            color: #666;
        }

        .empty-state {
            text-align: center;
            padding: 60px 20px;
            color: #999;
        }

        .empty-state .btn {
            background: linear-gradient(135deg, rgba(102, 188, 234, 0.76) 0%, rgba(126, 197, 228, 0.66) 100%);
            color: white;
            padding: 10px 20px;
            border-radius: 4px;
            text-decoration: none;
            margin-top: 20px;
            display: inline-block;
            transition: all 0.3s;
        }

        .empty-state .btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 8px rgba(102, 188, 234, 0.3);
        }
    </style>
</head>
<body>
<jsp:include page="/jsp/user/head.jsp"/>
<jsp:include page="/jsp/user/sidebar.jsp"/>

<div class="main-wrapper">
    <div class="content-header">
        <h1 class="content-title">${pageTitle}</h1>
    </div>
    <div class="content-body">
        <div class="articles-container">
            <c:choose>
                <c:when test="${not empty articles}">
                    <div class="article-list">
                        <c:forEach items="${articles}" var="article">
                            <div class="article-item">
                                <a href="${pageContext.request.contextPath}/article/detail?id=${article.id}"
                                   class="article-title">${article.title}</a>
                                <div class="article-meta">
                                    <span>发布时间: ${article.postTime}</span>
                                    <span>浏览: ${article.hits}</span>
                                    <span>点赞: ${article.likes}</span>
                                </div>
                            </div>
                        </c:forEach>
                    </div>
                </c:when>
                <c:otherwise>
                    <div class="empty-state">
                        <i class="fas fa-file-alt" style="font-size: 48px; margin-bottom: 20px;"></i>
                        <p>暂无文章</p>
                        <a href="${pageContext.request.contextPath}/article/publish" class="btn">
                            发布第一篇文章
                        </a>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>
    </div>
</div>
</body>
</html>