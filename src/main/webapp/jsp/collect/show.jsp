<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page isELIgnored="false" %>
<c:if test="${empty sessionScope.user}">
    <c:redirect url="${pageContext.request.contextPath}/jsp/user/login.jsp"/>
</c:if>
<!DOCTYPE html>
<html>
<head>
    <title>添加收藏夹 - 个人博客系统</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        body {
            font-family: 'Microsoft YaHei', Arial, sans-serif;
            background: white;
            color: #333;
            line-height: 1.6;
            padding: 0;
            margin: 0;
        }
        .container {
            width: 100%;
            max-width: 100%;
            margin: 0;
            padding: 0;
        }
        .header {
            background: white;
            padding: 16px 20px;
            border-bottom: 1px solid #f0f0f0;
            text-align: center;
            position: sticky;
            top: 0;
            z-index: 10;
        }
        .header h2 {
            font-size: 16px;
            font-weight: 600;
            color: #333;
            margin: 0;
        }
        .content {
            background: white;
            padding: 0;
        }
        .create-folder-section {
            padding: 12px 20px;
            border-bottom: 1px solid #f0f0f0;
            cursor: pointer;
            transition: background 0.3s ease;
        }
        .create-folder-section:hover {
            background: #f8f9fa;
        }
        .create-folder-content {
            display: flex;
            align-items: center;
            gap: 8px;
            color: #ff4d4f;
            font-weight: 600;
            font-size: 14px;
        }
        .create-folder-icon {
            font-size: 14px;
        }
        .folder-section {
            padding: 12px 20px;
            border-bottom: 1px solid #f0f0f0;
        }
        .section-title {
            font-size: 13px;
            color: #666;
            margin-bottom: 8px;
            font-weight: 600;
            display: flex;
            align-items: center;
            gap: 8px;
        }
        .recent-tag {
            background: #fff7e6;
            color: #fa8c16;
            padding: 2px 6px;
            border-radius: 10px;
            font-size: 11px;
            font-weight: 600;
        }
        .folder-list {
            display: flex;
            flex-direction: column;
            gap: 8px;
        }
        .folder-item {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 10px;
            border: 1px solid #f0f0f0;
            border-radius: 6px;
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
            font-size: 14px;
            display: flex;
            align-items: center;
            gap: 8px;
        }
        .folder-meta {
            font-size: 12px;
            color: #999;
            display: flex;
            align-items: center;
            gap: 8px;
        }
        .folder-count {
            color: #666;
        }
        .folder-privacy {
            padding: 2px 6px;
            border-radius: 10px;
            font-size: 11px;
            font-weight: 600;
        }
        .folder-public {
            background: #f6ffed;
            color: #52c41a;
            border: 1px solid #b7eb8f;
        }
        .folder-private {
            background: #fff2f0;
            color: #ff4d4f;
            border: 1px solid #ffccc7;
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
            min-width: 50px;
            height: 28px;
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
        .btn-disabled {
            background: #f5f5f5;
            color: #999;
            cursor: not-allowed;
        }
        .empty-state {
            text-align: center;
            padding: 40px 20px;
            color: #999;
        }
        .empty-icon {
            font-size: 36px;
            margin-bottom: 12px;
            color: #ccc;
        }
        .empty-text {
            font-size: 14px;
            margin-bottom: 8px;
        }
        .empty-subtext {
            font-size: 12px;
            color: #999;
        }
        /* 原有样式保持不变，新增取消收藏按钮样式 */
        .btn-remove {
            background: #ff4d4f;
            color: white;
            border: none;
            padding: 6px 12px;
            border-radius: 4px;
            font-size: 12px;
            cursor: pointer;
            transition: background 0.3s ease;
            min-width: 50px;
            height: 28px;
        }
        .btn-remove:hover {
            background: #ff7875;
        }
        .btn-remove:disabled {
            background: #f5f5f5;
            color: #999;
            cursor: not-allowed;
        }
        .btn-removing {
            background: #ffa39e;
        }
    </style>
</head>
<body>
<div class="container">
    <div class="header">
        <h2>添加收藏夹</h2>
    </div>

    <div class="content">
        <!-- 创建收藏夹按钮 -->
        <div class="create-folder-section" id="createFolderBtn">
            <div class="create-folder-content">
                <i class="fas fa-plus-circle create-folder-icon"></i>
                <span>创建收藏夹</span>
            </div>
        </div>

        <!-- 所有收藏夹 -->
        <c:choose>
            <c:when test="${not empty allFolders}">
                <div class="folder-section">
                    <div class="section-title">我的收藏夹</div>
                    <div class="folder-list">
                        <c:forEach items="${allFolders}" var="folder">
                            <div class="folder-item" id="folder-item-${folder.id}">
                                <div class="folder-info">
                                    <div class="folder-name">
                                            ${folder.name}
                                        <c:if test="${folder.recent}">
                                            <span class="recent-tag">最近</span>
                                        </c:if>
                                    </div>
                                    <div class="folder-meta">
                                        <span class="folder-count">${folder.itemCount}条内容</span>
                                        <span class="folder-privacy ${folder.isPublic == 1 ? 'folder-public' : 'folder-private'}">
                                                ${folder.isPublic == 1 ? '公开' : '私密'}
                                        </span>
                                    </div>
                                </div>
                                <div class="folder-action">
                                    <!-- 已收藏状态显示取消收藏按钮 -->
                                    <c:choose>
                                        <c:when test="${folder.isInFolder == 1}">
                                            <button class="btn-remove"
                                                    id="remove-btn-${folder.id}"
                                                    data-article-id="${articleId}"
                                                    data-folder-id="${folder.id}">
                                                <i class="fas fa-times"></i> 取消收藏
                                            </button>
                                        </c:when>
                                        <c:otherwise>
                                            <!-- 未收藏状态显示收藏按钮 -->
                                            <button class="btn-add"
                                                    id="add-btn-${folder.id}"
                                                    data-article-id="${articleId}"
                                                    data-folder-id="${folder.id}">
                                                <i class="fas fa-plus"></i> 收藏
                                            </button>
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                            </div>
                        </c:forEach>
                    </div>
                </div>
            </c:when>
            <c:otherwise>
                <div class="empty-state">
                    <i class="fas fa-folder-open empty-icon"></i>
                    <div class="empty-text">暂无收藏夹</div>
                    <div class="empty-subtext">点击上方"创建收藏夹"开始收藏</div>
                </div>
            </c:otherwise>
        </c:choose>
    </div>
</div>

<script>
    // 全局存储文章ID
    const globalArticleId = ${articleId};

    // 使用事件委托处理所有点击事件
    document.addEventListener('click', function(e) {
        // 处理创建收藏夹按钮点击
        if (e.target.closest('#createFolderBtn')) {
            e.preventDefault();
            if (window.parent && window.parent.showCreateFolderModal) {
                window.parent.showCreateFolderModal();
            }
            return;
        }

        // 处理收藏按钮点击
        const addBtn = e.target.closest('.btn-add');
        if (addBtn && !addBtn.disabled) {
            e.preventDefault();
            e.stopPropagation();

            const articleId = addBtn.getAttribute('data-article-id');
            const folderId = addBtn.getAttribute('data-folder-id');

            if (articleId && folderId) {
                handleAddToFolder(addBtn, parseInt(articleId), parseInt(folderId));
            }
        }

        // 处理取消收藏按钮点击
        const removeBtn = e.target.closest('.btn-remove');
        if (removeBtn && !removeBtn.disabled) {
            e.preventDefault();
            e.stopPropagation();

            const articleId = removeBtn.getAttribute('data-article-id');
            const folderId = removeBtn.getAttribute('data-folder-id');

            if (articleId && folderId) {
                handleRemoveFromFolder(removeBtn, parseInt(articleId), parseInt(folderId));
            }
        }
    });

    // 处理添加到收藏夹的逻辑
    function handleAddToFolder(button, articleId, folderId) {
        console.log('开始收藏 - 文章ID:', articleId, '收藏夹ID:', folderId);

        if (!articleId || !folderId || isNaN(articleId) || isNaN(folderId)) {
            console.error('参数无效:', {articleId, folderId});
            if (window.parent && window.parent.showMessage) {
                window.parent.showMessage('参数错误，请刷新页面重试', 'error');
            }
            return;
        }

        if (button.disabled) {
            console.log('按钮已禁用，忽略点击');
            return;
        }

        // 保存原始状态
        const originalHTML = button.innerHTML;
        const originalClasses = button.className;

        // 更新按钮状态
        button.disabled = true;
        button.innerHTML = '<i class="fas fa-spinner fa-spin"></i> 收藏中';

        const params = new URLSearchParams();
        params.append('articleId', articleId);
        params.append('folderId', folderId);

        console.log('发送收藏请求，参数:', params.toString());

        fetch('${pageContext.request.contextPath}/folder/add', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/x-www-form-urlencoded',
            },
            body: params
        })
            .then(response => {
                console.log('响应状态:', response.status);
                if (!response.ok) {
                    throw new Error('网络响应异常: ' + response.status);
                }
                return response.json();
            })
            .then(data => {
                console.log('收藏响应:', data);
                if (data.success) {
                    // 收藏成功，更新按钮状态为取消收藏
                    updateButtonToRemoveState(button, articleId, folderId);

                    // 通知父页面更新状态
                    if (window.parent && window.parent.updateFavoriteButton) {
                        window.parent.updateFavoriteButton(true);
                    }

                    // 显示成功消息
                    if (window.parent && window.parent.showMessage) {
                        window.parent.showMessage('收藏成功！', 'success');
                    }

                    // 2秒后关闭弹窗
                    setTimeout(() => {
                        if (window.parent && window.parent.closeFavoriteModal) {
                            window.parent.closeFavoriteModal();
                        }
                    }, 2000);
                } else {
                    // 收藏失败状态恢复
                    button.disabled = false;
                    button.innerHTML = originalHTML;
                    button.className = originalClasses;

                    if (window.parent && window.parent.showMessage) {
                        window.parent.showMessage(data.message || '收藏失败', 'error');
                    }
                }
            })
            .catch(error => {
                console.error('收藏失败:', error);
                // 异常状态恢复
                button.disabled = false;
                button.innerHTML = originalHTML;
                button.className = originalClasses;

                if (window.parent && window.parent.showMessage) {
                    window.parent.showMessage('收藏失败，请检查网络连接', 'error');
                }
            });
    }

    // 处理取消收藏的逻辑
    function handleRemoveFromFolder(button, articleId, folderId) {
        console.log('开始取消收藏 - 文章ID:', articleId, '收藏夹ID:', folderId);

        if (!articleId || !folderId || isNaN(articleId) || isNaN(folderId)) {
            console.error('参数无效:', {articleId, folderId});
            if (window.parent && window.parent.showMessage) {
                window.parent.showMessage('参数错误，请刷新页面重试', 'error');
            }
            return;
        }

        if (button.disabled) {
            console.log('按钮已禁用，忽略点击');
            return;
        }

        // 保存原始状态
        const originalHTML = button.innerHTML;
        const originalClasses = button.className;

        // 更新按钮状态
        button.disabled = true;
        button.classList.add('btn-removing');
        button.innerHTML = '<i class="fas fa-spinner fa-spin"></i> 取消中';

        const params = new URLSearchParams();
        params.append('articleId', articleId);
        params.append('folderId', folderId);

        console.log('发送取消收藏请求，参数:', params.toString());

        fetch('${pageContext.request.contextPath}/folder/remove', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/x-www-form-urlencoded',
            },
            body: params
        })
            .then(response => {
                console.log('响应状态:', response.status);
                if (!response.ok) {
                    throw new Error('网络响应异常: ' + response.status);
                }
                return response.json();
            })
            .then(data => {
                console.log('取消收藏响应:', data);
                if (data.success) {
                    // 取消收藏成功，更新按钮状态为收藏
                    updateButtonToAddState(button, articleId, folderId);

                    // 通知父页面更新状态
                    if (window.parent && window.parent.updateFavoriteButton) {
                        window.parent.updateFavoriteButton(false);
                    }

                    // 显示成功消息
                    if (window.parent && window.parent.showMessage) {
                        window.parent.showMessage('已取消收藏', 'success');
                    }

                    // 2秒后关闭弹窗
                    setTimeout(() => {
                        if (window.parent && window.parent.closeFavoriteModal) {
                            window.parent.closeFavoriteModal();
                        }
                    }, 2000);
                } else {
                    // 取消收藏失败状态恢复
                    button.disabled = false;
                    button.classList.remove('btn-removing');
                    button.innerHTML = originalHTML;
                    button.className = originalClasses;

                    if (window.parent && window.parent.showMessage) {
                        window.parent.showMessage(data.message || '取消收藏失败', 'error');
                    }
                }
            })
            .catch(error => {
                console.error('取消收藏失败:', error);
                // 异常状态恢复
                button.disabled = false;
                button.classList.remove('btn-removing');
                button.innerHTML = originalHTML;
                button.className = originalClasses;

                if (window.parent && window.parent.showMessage) {
                    window.parent.showMessage('取消收藏失败，请检查网络连接', 'error');
                }
            });
    }

    // 将按钮更新为取消收藏状态
    function updateButtonToRemoveState(button, articleId, folderId) {
        const newButton = document.createElement('button');
        newButton.className = 'btn-remove';
        newButton.id = 'remove-btn-' + folderId;
        newButton.setAttribute('data-article-id', articleId);
        newButton.setAttribute('data-folder-id', folderId);
        newButton.innerHTML = '<i class="fas fa-times"></i> 取消收藏';

        button.parentNode.replaceChild(newButton, button);
    }

    // 将按钮更新为收藏状态
    function updateButtonToAddState(button, articleId, folderId) {
        const newButton = document.createElement('button');
        newButton.className = 'btn-add';
        newButton.id = 'add-btn-' + folderId;
        newButton.setAttribute('data-article-id', articleId);
        newButton.setAttribute('data-folder-id', folderId);
        newButton.innerHTML = '<i class="fas fa-plus"></i> 收藏';

        button.parentNode.replaceChild(newButton, button);
    }

    // 页面加载时初始化
    document.addEventListener('DOMContentLoaded', function() {
        console.log('收藏夹页面加载完成，文章ID:', globalArticleId);
        console.log('收藏夹数量:', ${not empty allFolders ? allFolders.size() : 0});

        // 验证所有按钮是否正确渲染
        const addButtons = document.querySelectorAll('.btn-add');
        const removeButtons = document.querySelectorAll('.btn-remove');
        console.log('找到的收藏按钮数量:', addButtons.length);
        console.log('找到的取消收藏按钮数量:', removeButtons.length);

        addButtons.forEach(btn => {
            const articleId = btn.getAttribute('data-article-id');
            const folderId = btn.getAttribute('data-folder-id');
            console.log('收藏按钮 - 文章ID:', articleId, '收藏夹ID:', folderId);
        });

        removeButtons.forEach(btn => {
            const articleId = btn.getAttribute('data-article-id');
            const folderId = btn.getAttribute('data-folder-id');
            console.log('取消收藏按钮 - 文章ID:', articleId, '收藏夹ID:', folderId);
        });
    });

    // 保留showCreateFolderModal函数
    window.showCreateFolderModal = function() {
        if (window.parent && window.parent.showCreateFolderModal) {
            window.parent.showCreateFolderModal();
        }
    };
</script>

<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
</body>
</html>