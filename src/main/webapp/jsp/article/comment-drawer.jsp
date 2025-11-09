<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ page isELIgnored="false" %>
<c:if test="${empty sessionScope.user}">
    <c:redirect url="${pageContext.request.contextPath}/jsp/user/login.jsp"/>
</c:if>
<!DOCTYPE html>
<html>
<head>
    <title>评论</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        body {
            font-family: 'Microsoft YaHei', Arial, sans-serif;
            background: #f5f7fa;
            height: 100vh;
            overflow: hidden;
            margin: 0;
            padding: 0;
        }
        .comment-container {
            height: 100vh;
            display: flex;
            flex-direction: column;
            background: white;
        }
        .comment-header {
            padding: 20px;
            border-bottom: 1px solid #f0f0f0;
            background: #fff;
            position: sticky;
            top: 0;
            z-index: 10;
        }
        .comment-title {
            font-size: 18px;
            font-weight: 600;
            color: #333;
            display: flex;
            align-items: center;
            gap: 8px;
        }
        .comment-count {
            font-size: 14px;
            color: #666;
            margin-top: 5px;
        }
        .comment-body {
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
    </style>
</head>
<body>
<div class="comment-container">
    <div class="comment-header">
        <div class="comment-title">
            <i class="fas fa-comments"></i>
            评论
        </div>
        <div class="comment-count" id="commentCount">0 条评论</div>
    </div>

    <div class="comment-body" id="commentBody">
        <div class="comment-list" id="commentList">
            <!-- 评论列表由JavaScript动态加载 -->
        </div>
    </div>

    <div class="comment-input-section">
        <textarea class="comment-input" id="commentInput" placeholder="写下你的评论..." maxlength="1000"></textarea>
        <div class="input-actions">
            <div class="char-count">
                <span id="charCount">0</span>/1000
            </div>
            <button class="btn-comment-send" id="submitComment">发表评论</button>
        </div>
    </div>
</div>

<script>
    // 全局变量
    let currentArticleId = null;
    let replyingCommentId = null;

    // 初始化评论弹窗
    window.initCommentDrawer = function(articleId) {
        currentArticleId = articleId;
        console.log('初始化评论弹窗，文章ID:', articleId);
        loadComments(articleId);
        setupEventListeners();
    };

    // 设置事件监听器
    function setupEventListeners() {
        const commentInput = document.getElementById('commentInput');
        const charCount = document.getElementById('charCount');
        const submitBtn = document.getElementById('submitComment');

        // 输入框字符计数
        commentInput.addEventListener('input', function() {
            charCount.textContent = this.value.length;
        });

        // 提交按钮点击事件
        submitBtn.addEventListener('click', submitComment);

        // 回车键发送评论
        commentInput.addEventListener('keydown', function(e) {
            if (e.ctrlKey && e.key === 'Enter') {
                submitComment();
            }
        });
    }

    // 加载评论列表（修复：确保请求路径正确）
    function loadComments(articleId) {
        const commentList = document.getElementById('commentList');
        commentList.innerHTML = '<div style="text-align: center; padding: 40px;">加载中...</div>';

        // 修复：使用绝对路径或正确的相对路径
        fetch('${pageContext.request.contextPath}/comment/list?articleId=' + articleId, {
            method: 'GET'
        })
            .then(response => {
                if (!response.ok) throw new Error('网络错误');
                return response.json();
            })
            .then(data => {
                if (data.success) {
                    renderComments(data.comments);
                    updateCommentCount(data.totalCount);
                } else {
                    showError('加载评论失败: ' + (data.message || '未知错误'));
                }
            })
            .catch(error => {
                console.error('加载评论失败:', error);
                showError('加载评论失败，请重试');
            });
    }

    // 渲染评论列表
    function renderComments(comments) {
        const commentList = document.getElementById('commentList');

        try {
            if (!comments || comments.length === 0) {
                commentList.innerHTML = `
                <div class="empty-comments">
                    <i class="fas fa-comment-dots empty-icon"></i>
                    <div class="empty-text">暂无评论</div>
                    <div class="empty-subtext">快来发表第一条评论吧</div>
                </div>
            `;
                return;
            }

            let html = '';
            comments.forEach(comment => {
                try {
                    html += renderCommentItem(comment);
                } catch (error) {
                    console.error('渲染评论项失败:', error, comment);
                    // 渲染一个错误状态的评论项
                    html += `
                    <div class="comment-item" style="border-left: 4px solid #ff4d4f;">
                        <div class="comment-content" style="color: #ff4d4f;">评论加载失败</div>
                        <div class="comment-meta">
                            <span class="comment-time">加载错误</span>
                        </div>
                    </div>
                `;
                }
            });
            commentList.innerHTML = html;
        } catch (error) {
            console.error('渲染评论列表失败:', error);
            commentList.innerHTML = `
            <div class="empty-comments">
                <i class="fas fa-exclamation-triangle empty-icon"></i>
                <div class="empty-text">评论加载失败</div>
                <div class="empty-subtext">请刷新页面重试</div>
            </div>
        `;
        }
    }

    // 渲染单个评论项
    function renderCommentItem(comment) {
        console.log("开始渲染单个评论项");
        const createTime = formatTime(comment.createTime);
        const hasReplies = comment.replies && comment.replies.length > 0;
        console.log("createtime:",createTime);
        console.log("hasReplies:",hasReplies);

        return `
            <div class="comment-item" data-comment-id="${comment.id}">
                <div class="comment-content">${comment.content}</div>
                <div class="comment-meta">
                    <span class="comment-author">${comment.user.username}</span>
                    <span class="comment-time">${createTime}</span>
                </div>
                <div class="comment-actions">
                    <button class="btn-reply" onclick="toggleReplyForm(${comment.id})">回复</button>
                </div>

                <!-- 回复表单 -->
                <div class="reply-form" id="replyForm-${comment.id}">
                    <textarea class="reply-input" id="replyInput-${comment.id}" placeholder="回复 ${comment.user.username}..." maxlength="1000"></textarea>
                    <div class="char-count">
                        <span id="replyCharCount-${comment.id}">0</span>/1000
                    </div>
                    <button class="btn-send" onclick="submitReply(${comment.id})">发送</button>
                </div>

                <!-- 回复列表 -->
                ${hasReplies ? renderReplies(comment.replies) : ''}
            </div>
        `;
    }

    // 渲染回复列表
    function renderReplies(replies) {
        let html = '<div class="replies-list">';
        replies.forEach(reply => {
            const createTime = formatTime(reply.createTime);
            html += `
                <div class="reply-item">
                    <div class="reply-content">${reply.content}</div>
                    <div class="reply-meta">
                        <span class="comment-author">${reply.user.username}</span>
                        <span class="comment-time">${createTime}</span>
                    </div>
                </div>
            `;
        });
        html += '</div>';
        return html;
    }

    // 切换回复表单显示/隐藏
    function toggleReplyForm(commentId) {
        const replyForm = document.getElementById('replyForm-' + commentId);
        const replyBtn = document.querySelector(`[data-comment-id="${commentId}"] .btn-reply`);

        if (replyForm.classList.contains('active')) {
            // 收起回复框
            replyForm.classList.remove('active');
            replyBtn.textContent = '回复';
            replyingCommentId = null;
        } else {
            // 展开回复框
            closeAllReplyForms();
            replyForm.classList.add('active');
            replyBtn.textContent = '收起';
            replyingCommentId = commentId;

            // 设置回复框事件监听
            const replyInput = document.getElementById('replyInput-' + commentId);
            const charCount = document.getElementById('replyCharCount-' + commentId);

            if (replyInput && charCount) {
                replyInput.addEventListener('input', function() {
                    charCount.textContent = this.value.length;
                });
                replyInput.focus();
            }
        }
    }

    // 关闭所有回复框
    function closeAllReplyForms() {
        const replyForms = document.querySelectorAll('.reply-form');
        const replyBtns = document.querySelectorAll('.btn-reply');

        replyForms.forEach(form => form.classList.remove('active'));
        replyBtns.forEach(btn => btn.textContent = '回复');
        replyingCommentId = null;
    }

    // 提交评论
    function submitComment() {
        const content = document.getElementById('commentInput').value.trim();
        if (!content) {
            showError('请输入评论内容');
            return;
        }

        if (!currentArticleId) {
            showError('文章ID不存在');
            return;
        }

        const submitBtn = document.getElementById('submitComment');
        submitBtn.disabled = true;
        submitBtn.innerHTML = '<i class="fas fa-spinner fa-spin"></i> 发送中...';

        // 移除EL函数调用，直接用JS原生encodeURIComponent
        const encodedContent = encodeURIComponent(content);
        fetch('${pageContext.request.contextPath}/comment/add', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/x-www-form-urlencoded',
            },
            body: `articleId=${currentArticleId}&content=${encodedContent}`
        })
            .then(response => response.json())
            .then(data => {
                if (data.success) {
                    // 清空输入框
                    document.getElementById('commentInput').value = '';
                    document.getElementById('charCount').textContent = '0';

                    // 重新加载评论列表
                    loadComments(currentArticleId);
                    showSuccess('评论发表成功');
                } else {
                    showError(data.message || '评论失败');
                }
            })
            .catch(error => {
                console.error('评论失败:', error);
                showError('评论失败，请检查网络连接');
            })
            .finally(() => {
                submitBtn.disabled = false;
                submitBtn.innerHTML = '发表评论';
            });
    }

    // 提交回复
    function submitReply(commentId) {
        const content = document.getElementById('replyInput-' + commentId).value.trim();
        if (!content) {
            showError('请输入回复内容');
            return;
        }

        if (!currentArticleId) {
            showError('文章ID不存在');
            return;
        }

        const submitBtn = document.querySelector(`#replyForm-${commentId} .btn-send`);
        submitBtn.disabled = true;
        submitBtn.innerHTML = '<i class="fas fa-spinner fa-spin"></i> 发送中...';

        // 移除EL函数调用，直接用JS原生encodeURIComponent
        const encodedContent = encodeURIComponent(content);
        fetch('${pageContext.request.contextPath}/comment/reply', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/x-www-form-urlencoded',
            },
            body: `articleId=${currentArticleId}&parentId=${commentId}&content=${encodedContent}`
        })
            .then(response => response.json())
            .then(data => {
                if (data.success) {
                    // 清空回复框并收起
                    document.getElementById('replyInput-' + commentId).value = '';
                    document.getElementById('replyCharCount-' + commentId).textContent = '0';
                    toggleReplyForm(commentId);

                    // 重新加载评论列表
                    loadComments(currentArticleId);
                    showSuccess('回复发表成功');
                } else {
                    showError(data.message || '回复失败');
                }
            })
            .catch(error => {
                console.error('回复失败:', error);
                showError('回复失败，请检查网络连接');
            })
            .finally(() => {
                submitBtn.disabled = false;
                submitBtn.innerHTML = '发送';
            });
    }

    // 更新评论数量
    function updateCommentCount(count) {
        document.getElementById('commentCount').textContent = count + ' 条评论';
    }

    // 格式化时间
    // 替换原有的formatTime函数
    function formatTime(dateTime) {
        if (!dateTime) return '未知时间';

        // 处理数组格式的LocalDateTime [2025, 11, 7, 23, 22, 5]
        if (Array.isArray(dateTime) && dateTime.length >= 6) {
            try {
                const [year, month, day, hour, minute, second] = dateTime;
                // 月份要减1，因为JavaScript月份从0开始（0=一月，11=十二月）
                const date = new Date(year, month - 1, day, hour, minute, second);
                return formatRelativeTime(date);
            } catch (error) {
                console.error('时间格式化错误:', error, dateTime);
                return '时间格式错误';
            }
        }

        // 处理其他格式（字符串、时间戳等）
        try {
            const date = new Date(dateTime);
            return formatRelativeTime(date);
        } catch (error) {
            console.error('时间格式化错误:', error, dateTime);
            return '无效时间';
        }
    }

    // 相对时间格式化
    function formatRelativeTime(date) {
        const now = new Date();
        const diff = now - date;

        if (diff < 0) return '未来时间';
        if (diff < 60000) return '刚刚';
        if (diff < 3600000) return Math.floor(diff / 60000) + '分钟前';
        if (diff < 86400000) return Math.floor(diff / 3600000) + '小时前';
        if (diff < 604800000) return Math.floor(diff / 86400000) + '天前';

        return date.toLocaleDateString() + ' ' + date.toLocaleTimeString([], {hour: '2-digit', minute:'2-digit'});
    }


    // 显示成功消息
    function showSuccess(message) {
        showMessage(message, 'success');
    }

    // 显示错误消息
    function showError(message) {
        showMessage(message, 'error');
    }

    // 显示消息
    function showMessage(message, type) {
        const messageDiv = document.createElement('div');
        messageDiv.style.cssText = `
            position: fixed;
            top: 20px;
            right: 20px;
            padding: 12px 20px;
            border-radius: 6px;
            color: white;
            font-weight: bold;
            z-index: 1001;
            background: ${type == 'success' ? '#52c41a' : '#ff4d4f'};
            box-shadow: 0 4px 12px rgba(0,0,0,0.15);
        `;

        const icon = type == 'success' ? 'fa-check-circle' : 'fa-exclamation-circle';
        messageDiv.innerHTML = `<i class="fas ${icon}"></i> ${message}`;

        document.body.appendChild(messageDiv);

        setTimeout(() => {
            messageDiv.style.opacity = '0';
            setTimeout(() => messageDiv.remove(), 300);
        }, 3000);
    }
</script>

<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
</body>
</html>