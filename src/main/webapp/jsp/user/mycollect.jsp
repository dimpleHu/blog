<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page isELIgnored="false" %>
<c:if test="${empty sessionScope.user}">
    <c:redirect url="${pageContext.request.contextPath}/jsp/user/login.jsp"/>
</c:if>
<html>
<head>
    <title>我的收藏夹 - 个人博客系统</title>
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

        .folders-container {
            background: rgba(255, 255, 255, 0.8);
            backdrop-filter: blur(5px);
            border-radius: 12px;
            padding: 30px;
            box-shadow: 0 4px 12px rgba(0,0,0,0.1);
            margin-bottom: 20px;
        }

        .folder-list {
            display: flex;
            flex-direction: column;
            gap: 20px;
        }

        .folder-item {
            border: 1px solid #f0f0f0;
            border-radius: 8px;
            padding: 20px;
            transition: all 0.3s ease;
        }

        .folder-item:hover {
            border-color: rgba(102, 188, 234, 0.8);
            box-shadow: 0 2px 8px rgba(102, 188, 234, 0.1);
        }

        .folder-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 15px;
        }

        .folder-title {
            font-size: 18px;
            font-weight: 600;
            color: #333;
            text-decoration: none;
        }

        .folder-meta {
            display: flex;
            gap: 20px;
            font-size: 14px;
            color: #666;
        }

        .toggle-btn {
            background: none;
            border: none;
            color: #666;
            cursor: pointer;
            font-size: 14px;
        }

        .folder-articles {
            display: none; /* 默认隐藏 */
            margin-top: 10px;
            border-top: 1px solid #f0f0f0;
            padding-top: 10px;
            background-color: #f5f5f5; /* 展开项灰色背景 */
            border-radius: 4px;
        }

        .article-list {
            display: flex;
            flex-direction: column;
            gap: 10px;
            padding: 8px;
        }

        .article-item a {
            color: #333;
            text-decoration: none;
            font-size: 16px;
            display: block;
            padding: 8px;
            transition: color 0.3s ease;
        }

        .article-item a:hover {
            color: #1890ff; /* 鼠标悬停文字变蓝 */
            text-decoration: none;
        }

        .empty-state {
            text-align: center;
            padding: 60px 20px;
            color: #999;
        }
    </style>
    <script>
        // 页面加载完成后再绑定事件（确保DOM已完全渲染）
        document.addEventListener('DOMContentLoaded', function() {
            // 给所有切换按钮绑定点击事件
            document.querySelectorAll('.toggle-btn').forEach(btn => {
                btn.addEventListener('click', function() {
                    // 找到当前按钮所在的收藏夹项
                    const folderItem = this.closest('.folder-item');
                    // 找到对应的文章列表
                    const articles = folderItem.querySelector('.folder-articles');

                    // 切换显示/隐藏
                    if (articles.style.display === 'block') {
                        articles.style.display = 'none';
                        this.textContent = '展开';
                    } else {
                        articles.style.display = 'block';
                        this.textContent = '收起';
                    }
                });
            });
        });
    </script>
</head>
<body>
<jsp:include page="/jsp/user/head.jsp"/>
<jsp:include page="/jsp/user/sidebar.jsp"/>

<div class="main-wrapper">
    <div class="content-header">
        <h1 class="content-title">我的收藏夹</h1>
    </div>
    <div class="content-body">
        <div class="folders-container">
            <c:choose>
                <c:when test="${not empty folderMapList}">
                    <div class="folder-list">
                        <c:forEach items="${folderMapList}" var="folderMap">
                            <div class="folder-item">
                                <div class="folder-header">
                                    <span class="folder-title">${folderMap.folder.name}</span>
                                    <!-- 移除onclick属性，通过JS事件委托绑定 -->
                                    <button class="toggle-btn">展开</button>
                                </div>
                                <div class="folder-meta">
                                    <span>最近更新: ${folderMap.recentUpdateTime}</span>
                                    <span>内容: ${folderMap.folder.itemCount}</span>
                                </div>
                                <div class="folder-articles">
                                    <div class="article-list">
                                        <c:forEach items="${folderMap.articles}" var="article">
                                            <div class="article-item">
                                                <a href="${pageContext.request.contextPath}/article/detail?id=${article.id}">${article.title}</a>
                                            </div>
                                        </c:forEach>
                                    </div>
                                </div>
                            </div>
                        </c:forEach>
                    </div>
                </c:when>
                <c:otherwise>
                    <div class="empty-state">
                        <i class="fas fa-folder-open" style="font-size: 48px; margin-bottom: 20px;"></i>
                        <p>暂无收藏夹</p>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>
    </div>
</div>
</body>
</html>