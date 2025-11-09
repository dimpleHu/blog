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

        .article-actions {
            display: flex;
            gap: 10px;
            margin-top: 10px;
        }

        .btn-action {
            padding: 6px 16px;
            border: none;
            border-radius: 4px;
            font-size: 13px;
            cursor: pointer;
            transition: all 0.3s;
            display: inline-flex;
            align-items: center;
            gap: 5px;
        }

        .btn-delete {
            background: #ff4d4f;
            color: white;
        }

        .btn-delete:hover {
            background: #ff7875;
            transform: translateY(-1px);
        }

        .btn-privacy {
            background: #1890ff;
            color: white;
        }

        .btn-privacy:hover {
            background: #40a9ff;
            transform: translateY(-1px);
        }

        .btn-privacy.private {
            background: #722ed1;
        }

        .btn-privacy.private:hover {
            background: #9254de;
        }

        .btn-action:disabled {
            background: #d9d9d9;
            color: #999;
            cursor: not-allowed;
            transform: none;
        }

        .status-badge {
            display: inline-block;
            padding: 2px 8px;
            border-radius: 10px;
            font-size: 12px;
            font-weight: 500;
            margin-left: 10px;
        }

        .status-private {
            background: #f0f0ff;
            color: #722ed1;
        }

        .status-public {
            background: #f6ffed;
            color: #52c41a;
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

        /* 分页样式 */
        .pagination {
            display: flex;
            justify-content: center;
            align-items: center;
            gap: 10px;
            margin-top: 30px;
            padding: 20px 0;
        }

        .pagination a, .pagination span {
            padding: 8px 16px;
            border: 1px solid #e0e0e0;
            border-radius: 4px;
            text-decoration: none;
            color: #333;
            transition: all 0.3s;
        }

        .pagination a:hover {
            background: rgba(102, 188, 234, 0.1);
            border-color: rgba(102, 188, 234, 0.8);
            color: rgba(102, 188, 234, 0.8);
        }

        .pagination .current {
            background: linear-gradient(135deg, rgba(102, 188, 234, 0.76) 0%, rgba(126, 197, 228, 0.66) 100%);
            color: white;
            border-color: rgba(102, 188, 234, 0.8);
        }

        .pagination .disabled {
            color: #ccc;
            cursor: not-allowed;
            pointer-events: none;
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
                            <div class="article-item" id="article-item-${article.id}">
                                <div style="display: flex; justify-content: space-between; align-items: flex-start;">
                                    <div style="flex: 1;">
                                        <a href="${pageContext.request.contextPath}/article/detail?id=${article.id}"
                                           class="article-title">${article.title}</a>
                                        <c:if test="${article.status == 3}">
                                            <span class="status-badge status-private">私密</span>
                                        </c:if>
                                        <c:if test="${article.status == 1}">
                                            <span class="status-badge status-public">公开</span>
                                        </c:if>
                                        <div class="article-meta">
                                            <span>发布时间: ${article.postTime}</span>
                                            <span>浏览: ${article.hits}</span>
                                            <span>点赞: ${article.likes}</span>
                                        </div>
                                        <div class="article-actions">
                                            <button class="btn-action btn-delete" onclick="deleteArticle(${article.id})">
                                                <i class="fas fa-trash"></i> 删除
                                            </button>
                                            <c:choose>
                                                <c:when test="${article.status == 3}">
                                                    <button class="btn-action btn-privacy private" 
                                                            onclick="togglePrivacy(${article.id}, ${article.status})">
                                                        <i class="fas fa-lock"></i> 设为公开
                                                    </button>
                                                </c:when>
                                                <c:otherwise>
                                                    <button class="btn-action btn-privacy" 
                                                            onclick="togglePrivacy(${article.id}, ${article.status})">
                                                        <i class="fas fa-unlock"></i> 设为私密
                                                    </button>
                                                </c:otherwise>
                                            </c:choose>
                                        </div>
                                    </div>
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

            <!-- 分页 -->
            <c:if test="${totalPages > 1}">
                <div class="pagination">
                    <!-- 上一页 -->
                    <c:if test="${currentPage > 1}">
                        <a href="${pageContext.request.contextPath}/article/my-articles?page=${currentPage - 1}">上一页</a>
                    </c:if>
                    
                    <!-- 第一页 -->
                    <c:if test="${currentPage > 2}">
                        <a href="${pageContext.request.contextPath}/article/my-articles?page=1">1</a>
                    </c:if>
                    
                    <!-- 省略号 -->
                    <c:if test="${currentPage > 3}">
                        <span>...</span>
                    </c:if>
                    
                    <!-- 当前页及前后页 -->
                    <c:forEach begin="${currentPage > 2 ? currentPage - 1 : 1}" 
                               end="${currentPage < totalPages - 1 ? currentPage + 1 : totalPages}" 
                               var="i">
                        <c:choose>
                            <c:when test="${i == currentPage}">
                                <span class="current">${i}</span>
                            </c:when>
                            <c:otherwise>
                                <a href="${pageContext.request.contextPath}/article/my-articles?page=${i}">${i}</a>
                            </c:otherwise>
                        </c:choose>
                    </c:forEach>
                    
                    <!-- 省略号 -->
                    <c:if test="${currentPage < totalPages - 2}">
                        <span>...</span>
                    </c:if>
                    
                    <!-- 最后一页 -->
                    <c:if test="${currentPage < totalPages - 1 && totalPages > 1}">
                        <a href="${pageContext.request.contextPath}/article/my-articles?page=${totalPages}">${totalPages}</a>
                    </c:if>
                    
                    <!-- 下一页 -->
                    <c:if test="${currentPage < totalPages}">
                        <a href="${pageContext.request.contextPath}/article/my-articles?page=${currentPage + 1}">下一页</a>
                    </c:if>
                </div>
            </c:if>
        </div>
    </div>
</div>

<script>
    // 删除文章
    function deleteArticle(articleId) {
        if (!confirm('确定要删除这篇文章吗？删除后文章将不再显示。')) {
            return;
        }

        const btn = event.target.closest('.btn-delete');
        const originalHTML = btn.innerHTML;
        btn.disabled = true;
        btn.innerHTML = '<i class="fas fa-spinner fa-spin"></i> 删除中...';

        fetch('${pageContext.request.contextPath}/article/delete', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/x-www-form-urlencoded',
            },
            body: 'articleId=' + articleId
        })
        .then(response => response.json())
        .then(data => {
            if (data.success) {
                // 移除文章项
                const articleItem = document.getElementById('article-item-' + articleId);
                if (articleItem) {
                    articleItem.style.transition = 'opacity 0.3s';
                    articleItem.style.opacity = '0';
                    setTimeout(() => {
                        articleItem.remove();
                        // 如果列表为空，刷新页面
                        if (document.querySelectorAll('.article-item').length === 0) {
                            window.location.reload();
                        }
                    }, 300);
                }
                showMessage(data.message || '删除成功', 'success');
            } else {
                showMessage(data.message || '删除失败', 'error');
                btn.disabled = false;
                btn.innerHTML = originalHTML;
            }
        })
        .catch(error => {
            console.error('Error:', error);
            showMessage('删除失败，请重试', 'error');
            btn.disabled = false;
            btn.innerHTML = originalHTML;
        });
    }

    // 切换私密/公开状态
    function togglePrivacy(articleId, currentStatus) {
        const btn = event.target.closest('.btn-privacy');
        const originalHTML = btn.innerHTML;
        btn.disabled = true;
        btn.innerHTML = '<i class="fas fa-spinner fa-spin"></i> 处理中...';

        fetch('${pageContext.request.contextPath}/article/toggle-privacy', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/x-www-form-urlencoded',
            },
            body: 'articleId=' + articleId
        })
        .then(response => response.json())
        .then(data => {
            if (data.success) {
                showMessage(data.message || '操作成功', 'success');
                // 刷新页面以更新状态显示
                setTimeout(() => {
                    window.location.reload();
                }, 1000);
            } else {
                showMessage(data.message || '操作失败', 'error');
                btn.disabled = false;
                btn.innerHTML = originalHTML;
            }
        })
        .catch(error => {
            console.error('Error:', error);
            showMessage('操作失败，请重试', 'error');
            btn.disabled = false;
            btn.innerHTML = originalHTML;
        });
    }

    // 显示消息提示
    function showMessage(message, type) {
        const messageDiv = document.createElement('div');
        messageDiv.className = 'message-toast';
        
        // 根据类型设置背景色
        const bgColor = type === 'success' ? '#52c41a' : '#ff4d4f';
        
        messageDiv.style.cssText = 
            'position: fixed;' +
            'top: 20px;' +
            'right: 20px;' +
            'padding: 14px 20px;' +
            'border-radius: 6px;' +
            'color: white !important;' +
            'font-weight: 500;' +
            'font-size: 14px;' +
            'line-height: 1.5;' +
            'z-index: 10000;' +
            'background: ' + bgColor + ' !important;' +
            'box-shadow: 0 4px 12px rgba(0,0,0,0.15);' +
            'display: flex;' +
            'align-items: center;' +
            'gap: 10px;' +
            'min-width: 200px;' +
            'max-width: 400px;' +
            'word-wrap: break-word;' +
            'white-space: normal;' +
            'opacity: 1;';

        const icon = type === 'success' ? 'fa-check-circle' : 'fa-exclamation-circle';
        messageDiv.innerHTML = 
            '<i class="fas ' + icon + '" style="font-size: 16px; flex-shrink: 0; color: white !important;"></i>' +
            '<span style="color: white !important; display: inline-block;">' + message + '</span>';

        document.body.appendChild(messageDiv);

        setTimeout(function() {
            if (messageDiv.parentNode) {
                messageDiv.style.transition = 'opacity 0.3s ease';
                messageDiv.style.opacity = '0';
                setTimeout(function() {
                    if (messageDiv.parentNode) {
                        messageDiv.remove();
                    }
                }, 300);
            }
        }, 3000);
    }
</script>

<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
</body>
</html>