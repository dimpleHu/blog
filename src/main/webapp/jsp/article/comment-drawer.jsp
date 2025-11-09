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
            background: white;
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
            display: flex;
            justify-content: space-between;
            align-items: flex-start;
        }
        .comment-header-left {
            flex: 1;
        }
        .comment-close-btn {
            background: none;
            border: none;
            font-size: 24px;
            cursor: pointer;
            color: #999;
            padding: 0;
            width: 32px;
            height: 32px;
            display: flex;
            align-items: center;
            justify-content: center;
            border-radius: 4px;
            transition: all 0.3s ease;
        }
        .comment-close-btn:hover {
            background: #f5f5f5;
            color: #333;
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
            padding: 16px 20px;
            border-bottom: 1px solid #f0f0f0;
            transition: background 0.3s ease;
            position: relative;
            background: #fff;
        }
        .comment-item:hover {
            background: #fafafa;
        }
        .comment-item:last-child {
            border-bottom: none;
        }
        .comment-content {
            font-size: 14px;
            line-height: 1.6;
            color: #333;
            margin-bottom: 8px;
            word-wrap: break-word;
            white-space: pre-wrap;
        }
        .comment-meta {
            display: flex;
            align-items: center;
            gap: 12px;
            font-size: 12px;
            color: #999;
            margin-top: 8px;
            flex-wrap: wrap;
        }
        .comment-author {
            font-weight: 600;
            color: #1890ff;
        }
        .comment-time {
            color: #999;
        }
        .comment-actions-row {
            display: flex;
            align-items: center;
            gap: 12px;
            margin-top: 8px;
            flex-wrap: wrap;
        }
        .comment-actions {
            position: absolute;
            right: 20px;
            top: 15px;
            opacity: 0;
            transition: opacity 0.3s ease;
            display: flex;
            align-items: center;
            gap: 8px;
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
            padding: 4px 8px;
            border-radius: 4px;
            transition: background 0.3s ease;
            display: inline-flex;
            align-items: center;
            gap: 4px;
        }
        .btn-reply:hover {
            background: #e6f7ff;
        }
        .btn-delete-comment {
            background: none;
            border: none;
            color: #ff4d4f;
            font-size: 12px;
            cursor: pointer;
            padding: 4px 8px;
            border-radius: 4px;
            transition: background 0.3s ease;
            display: inline-flex;
            align-items: center;
            gap: 4px;
        }
        .btn-delete-comment:hover {
            background: #fff2f0;
        }
        .btn-like-comment {
            background: none;
            border: none;
            color: #666;
            font-size: 12px;
            cursor: pointer;
            padding: 4px 8px;
            border-radius: 4px;
            transition: all 0.3s ease;
            display: inline-flex;
            align-items: center;
            gap: 4px;
        }
        .btn-like-comment:hover {
            color: #1890ff;
            background: #f0f7ff;
        }
        .btn-like-comment.liked {
            color: #1890ff;
        }
        .btn-like-comment.liked i {
            color: #1890ff;
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
            position: relative;
        }
        .reply-content {
            font-size: 13px;
            line-height: 1.5;
            color: #333;
            margin-bottom: 6px;
        }
        .reply-meta {
            display: flex;
            align-items: center;
            gap: 12px;
            font-size: 11px;
            color: #999;
            margin-bottom: 6px;
            flex-wrap: wrap;
        }
        .reply-actions-row {
            display: flex;
            align-items: center;
            gap: 12px;
            flex-wrap: wrap;
        }
        .reply-actions {
            position: absolute;
            right: 10px;
            top: 10px;
            opacity: 0;
            transition: opacity 0.3s ease;
            display: flex;
            align-items: center;
            gap: 8px;
        }
        .reply-item:hover .reply-actions {
            opacity: 1;
        }
        .comment-input-section {
            padding: 20px;
            border-top: 1px solid #f0f0f0;
            background: white;
            flex-shrink: 0;
            min-height: 150px;
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
            color: #999;
        }
        .empty-subtext {
            font-size: 12px;
            color: #ccc;
        }
    </style>
</head>
<body>
<div class="comment-container">
    <div class="comment-header">
        <div class="comment-header-left">
            <div class="comment-title">
                <i class="fas fa-comments"></i>
                评论
            </div>
            <div class="comment-count" id="commentCount">0 条评论</div>
        </div>
        <button class="comment-close-btn" onclick="closeCommentDrawer()" title="关闭评论">
            <i class="fas fa-times"></i>
        </button>
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
    let contextPath = '${pageContext.request.contextPath}' || '';
    let currentUserId = ${sessionScope.user != null ? sessionScope.user.id : 0};

    // 初始化评论弹窗
    window.initCommentDrawer = function(articleId) {
        currentArticleId = articleId;
        console.log('初始化评论弹窗，文章ID:', articleId);
        
        // 如果上下文路径为空，尝试从当前URL获取
        if (!contextPath || contextPath.trim() === '') {
            const path = window.location.pathname;
            console.log('当前路径:', path);
            
            // 从路径中提取上下文路径
            // 例如: /blog_war_exploded/comment/drawer -> /blog_war_exploded
            const match = path.match(/^(\/[^\/]+)/);
            if (match && match[1]) {
                contextPath = match[1];
            } else {
                contextPath = '';
            }
            
            console.log('从URL获取上下文路径:', contextPath || '(空，使用相对路径)');
        }
        
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

        // 修复：获取上下文路径（在iframe中也能正确工作）
        if (!contextPath) {
            const path = window.location.pathname;
            const pathParts = path.split('/');
            if (pathParts.length > 1) {
                contextPath = '/' + pathParts[1];
            }
        }
        const url = contextPath + '/comment/list?articleId=' + articleId;
        
        console.log('加载评论，URL:', url, '文章ID:', articleId, '上下文路径:', contextPath);

        fetch(url, {
            method: 'GET',
            credentials: 'same-origin' // 确保携带cookie
        })
            .then(response => {
                console.log('评论请求响应状态:', response.status);
                if (!response.ok) {
                    throw new Error('网络错误: ' + response.status);
                }
                return response.json();
            })
            .then(data => {
                console.log('评论数据:', data);
                if (data.success) {
                    renderComments(data.comments || []);
                    updateCommentCount(data.totalCount || 0);
                } else {
                    showError('加载评论失败: ' + (data.message || '未知错误'));
                }
            })
            .catch(error => {
                console.error('加载评论失败:', error);
                showError('加载评论失败，请重试: ' + error.message);
            });
    }

    // 渲染评论列表
    function renderComments(comments) {
        const commentList = document.getElementById('commentList');
        console.log('开始渲染评论列表，评论数量:', comments ? comments.length : 0);

        if (!commentList) {
            console.error('评论列表容器不存在！');
            return;
        }

        try {
            if (!comments || comments.length === 0) {
                commentList.innerHTML = '<div class="empty-comments">' +
                    '<i class="fas fa-comment-dots empty-icon"></i>' +
                    '<div class="empty-text">暂无评论</div>' +
                    '<div class="empty-subtext">快来发表第一条评论吧</div>' +
                    '</div>';
                return;
            }

            let html = '';
            comments.forEach((comment, index) => {
                try {
                    console.log('渲染第' + (index + 1) + '条评论:', comment);
                    const commentHtml = renderCommentItem(comment);
                    if (commentHtml) {
                        html += commentHtml;
                    } else {
                        console.warn('评论项渲染返回空，评论ID:', comment ? comment.id : 'unknown');
                    }
                } catch (error) {
                    console.error('渲染评论项失败:', error, comment);
                    // 渲染一个错误状态的评论项
                    html += '<div class="comment-item" style="border-left: 4px solid #ff4d4f;">' +
                        '<div class="comment-content" style="color: #ff4d4f;">评论加载失败</div>' +
                        '<div class="comment-meta">' +
                        '<span class="comment-time">加载错误</span>' +
                        '</div>' +
                        '</div>';
                }
            });
            
            console.log('生成的HTML长度:', html.length);
            console.log('生成的HTML预览:', html.substring(0, 500));
            
            // 清空容器
            commentList.innerHTML = '';
            
            // 使用 insertAdjacentHTML 而不是 innerHTML，确保DOM更新
            commentList.insertAdjacentHTML('beforeend', html);
            
            // 验证渲染结果
            setTimeout(function() {
                const renderedItems = commentList.querySelectorAll('.comment-item');
                console.log('实际渲染的评论项数量:', renderedItems.length);
                
                if (renderedItems.length === 0 && comments.length > 0) {
                    console.error('评论项未成功渲染到DOM中！');
                    console.error('commentList元素:', commentList);
                    console.error('commentList.innerHTML长度:', commentList.innerHTML.length);
                    commentList.innerHTML = '<div class="empty-comments">' +
                        '<i class="fas fa-exclamation-triangle empty-icon"></i>' +
                        '<div class="empty-text">评论渲染失败</div>' +
                        '<div class="empty-subtext">请刷新页面重试</div>' +
                        '</div>';
                } else {
                    // 检查每个评论项的内容
                    renderedItems.forEach(function(item, index) {
                        const content = item.querySelector('.comment-content');
                        const author = item.querySelector('.comment-author');
                        console.log('评论项 ' + (index + 1) + ':', {
                            content: content ? content.textContent : '无内容',
                            author: author ? author.textContent : '无作者',
                            visible: item.offsetHeight > 0
                        });
                    });
                }
            }, 100);
        } catch (error) {
            console.error('渲染评论列表失败:', error);
            commentList.innerHTML = '<div class="empty-comments">' +
                '<i class="fas fa-exclamation-triangle empty-icon"></i>' +
                '<div class="empty-text">评论加载失败</div>' +
                '<div class="empty-subtext">请刷新页面重试</div>' +
                '</div>';
        }
    }

    // 渲染单个评论项
    function renderCommentItem(comment) {
        console.log("开始渲染单个评论项", comment);
        
        if (!comment || !comment.id) {
            console.error('评论数据无效:', comment);
            return '';
        }
        
        const createTime = formatTime(comment.createTime);
        const hasReplies = comment.replies && comment.replies.length > 0;
        const username = escapeHtml((comment.user && comment.user.username) ? comment.user.username : '匿名用户');
        const commentContent = escapeHtml(comment.content || '');
        const commentId = comment.id;
        const commentUserId = comment.userId || 0;
        const isOwnComment = currentUserId > 0 && commentUserId === currentUserId;
        const isLiked = comment.liked === true;

        // 构建HTML字符串，确保所有变量都正确转义
        const likesCount = comment.likes || 0;
        let html = '<div class="comment-item" data-comment-id="' + commentId + '">';
        html += '<div class="comment-content">' + commentContent + '</div>';
        html += '<div class="comment-meta">';
        html += '<span class="comment-author">' + username + '</span>';
        html += '<span class="comment-time">' + createTime + '</span>';
        html += '</div>';
        html += '<div class="comment-actions-row">';
        html += '<button class="btn-like-comment ' + (isLiked ? 'liked' : '') + '" onclick="toggleCommentLike(' + commentId + ', ' + (isLiked ? 'true' : 'false') + ')">';
        html += '<i class="fas fa-thumbs-up"></i> <span class="likes-count-' + commentId + '">' + likesCount + '</span>';
        html += '</button>';
        html += '</div>';
        html += '<div class="comment-actions">';
        html += '<button class="btn-reply" onclick="toggleReplyForm(' + commentId + ')"><i class="fas fa-reply"></i> 回复</button>';
        if (isOwnComment) {
            html += '<button class="btn-delete-comment" onclick="deleteComment(' + commentId + ')"><i class="fas fa-trash"></i> 删除</button>';
        }
        html += '</div>';
        html += '<div class="reply-form" id="replyForm-' + commentId + '">';
        html += '<textarea class="reply-input" id="replyInput-' + commentId + '" placeholder="回复 ' + username + '..." maxlength="1000"></textarea>';
        html += '<div class="char-count">';
        html += '<span id="replyCharCount-' + commentId + '">0</span>/1000';
        html += '</div>';
        html += '<button class="btn-send" onclick="submitReply(' + commentId + ')">发送</button>';
        html += '</div>';
        if (hasReplies) {
            html += renderReplies(comment.replies);
        }
        html += '</div>';
        
        return html;
    }
    
    // HTML转义函数
    function escapeHtml(text) {
        if (!text) return '';
        const map = {
            '&': '&amp;',
            '<': '&lt;',
            '>': '&gt;',
            '"': '&quot;',
            "'": '&#039;'
        };
        return String(text).replace(/[&<>"']/g, function(m) { return map[m]; });
    }

    // 渲染回复列表
    function renderReplies(replies) {
        if (!replies || replies.length === 0) return '';
        let html = '<div class="replies-list">';
        replies.forEach(reply => {
            const createTime = formatTime(reply.createTime);
            const username = escapeHtml((reply.user && reply.user.username) ? reply.user.username : '匿名用户');
            const replyContent = escapeHtml(reply.content || '');
            const replyId = reply.id;
            const replyUserId = reply.userId || 0;
            const isOwnReply = currentUserId > 0 && replyUserId === currentUserId;
            const isLiked = reply.liked === true;
            const likesCount = reply.likes || 0;
            
            html += '<div class="reply-item" data-comment-id="' + replyId + '">';
            html += '<div class="reply-content">' + replyContent + '</div>';
            html += '<div class="reply-meta">';
            html += '<span class="comment-author">' + username + '</span>';
            html += '<span class="comment-time">' + createTime + '</span>';
            html += '</div>';
            html += '<div class="reply-actions-row">';
            html += '<button class="btn-like-comment ' + (isLiked ? 'liked' : '') + '" onclick="toggleCommentLike(' + replyId + ', ' + (isLiked ? 'true' : 'false') + ')">';
            html += '<i class="fas fa-thumbs-up"></i> <span class="likes-count-' + replyId + '">' + likesCount + '</span>';
            html += '</button>';
            html += '</div>';
            html += '<div class="reply-actions">';
            if (isOwnReply) {
                html += '<button class="btn-delete-comment" onclick="deleteComment(' + replyId + ')"><i class="fas fa-trash"></i> 删除</button>';
            }
            html += '</div>';
            html += '</div>';
        });
        html += '</div>';
        return html;
    }

    // 切换回复表单显示/隐藏
    function toggleReplyForm(commentId) {
        console.log('切换回复表单，评论ID:', commentId);
        const replyForm = document.getElementById('replyForm-' + commentId);
        const replyBtn = document.querySelector('[data-comment-id="' + commentId + '"] .btn-reply');

        if (!replyForm) {
            console.error('回复表单不存在，ID: replyForm-' + commentId);
            return;
        }
        
        if (!replyBtn) {
            console.error('回复按钮不存在，评论ID: ' + commentId);
            return;
        }

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
                // 移除旧的事件监听器，避免重复绑定
                const newReplyInput = replyInput.cloneNode(true);
                replyInput.parentNode.replaceChild(newReplyInput, replyInput);
                newReplyInput.addEventListener('input', function() {
                    const newCharCount = document.getElementById('replyCharCount-' + commentId);
                    if (newCharCount) {
                        newCharCount.textContent = this.value.length;
                    }
                });
                newReplyInput.focus();
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

        // 修复：获取上下文路径
        if (!contextPath) {
            const path = window.location.pathname;
            const pathParts = path.split('/');
            if (pathParts.length > 1) {
                contextPath = '/' + pathParts[1];
            }
        }
        const encodedContent = encodeURIComponent(content);
        console.log('提交评论，文章ID:', currentArticleId, '内容:', content);
        console.log('请求URL:', contextPath + '/comment/add');
        
        // 构建请求体
        const requestBody = 'articleId=' + currentArticleId + '&content=' + encodedContent;
        console.log('请求体:', requestBody);
        
        fetch(contextPath + '/comment/add', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8',
            },
            credentials: 'same-origin',
            body: requestBody
        })
            .then(response => {
                console.log('评论提交响应状态:', response.status);
                console.log('响应Content-Type:', response.headers.get('Content-Type'));
                
                // 先读取响应文本，以便调试
                return response.text().then(text => {
                    console.log('评论提交响应原始文本:', text);
                    
                    if (!response.ok) {
                        throw new Error('HTTP错误: ' + response.status + ' - ' + text);
                    }
                    
                    // 尝试解析JSON
                    try {
                        const data = JSON.parse(text);
                        return data;
                    } catch (e) {
                        console.error('JSON解析失败:', e, '响应文本:', text);
                        throw new Error('响应格式错误: ' + text);
                    }
                });
            })
            .then(data => {
                console.log('评论提交响应数据:', data);
                if (data && data.success) {
                    // 清空输入框
                    const commentInput = document.getElementById('commentInput');
                    const charCount = document.getElementById('charCount');
                    if (commentInput) commentInput.value = '';
                    if (charCount) charCount.textContent = '0';

                    // 重新加载评论列表
                    loadComments(currentArticleId);
                    showSuccess('评论发表成功');
                } else {
                    showError(data ? (data.message || '评论失败') : '评论失败：响应格式错误');
                }
            })
            .catch(error => {
                console.error('评论失败:', error);
                showError('评论失败: ' + (error.message || '请检查网络连接'));
            })
            .finally(() => {
                if (submitBtn) {
                submitBtn.disabled = false;
                submitBtn.innerHTML = '发表评论';
                }
            });
    }

    // 提交回复
    function submitReply(commentId) {
        console.log('提交回复，评论ID:', commentId);
        console.log('当前文章ID:', currentArticleId);
        
        // 先检查回复输入框
        const replyInputId = 'replyInput-' + commentId;
        const replyInput = document.getElementById(replyInputId);
        if (!replyInput) {
            console.error('回复输入框不存在，ID:', replyInputId);
            console.error('所有回复输入框:', document.querySelectorAll('[id^="replyInput-"]'));
            showError('回复输入框不存在，请刷新页面重试');
            return;
        }
        
        const content = replyInput.value.trim();
        console.log('回复内容:', content);
        if (!content) {
            showError('请输入回复内容');
            return;
        }

        if (!currentArticleId) {
            console.error('文章ID不存在');
            showError('文章ID不存在');
            return;
        }

        // 修复：使用多种方式查找提交按钮
        let submitBtn = document.querySelector('#replyForm-' + commentId + ' .btn-send');
        if (!submitBtn) {
            // 尝试直接通过ID查找
            submitBtn = document.querySelector('button[onclick*="submitReply(' + commentId + ')"]');
        }
        if (!submitBtn) {
            // 尝试在回复表单中查找按钮
            const replyForm = document.getElementById('replyForm-' + commentId);
            if (replyForm) {
                submitBtn = replyForm.querySelector('.btn-send');
            }
        }
        
        if (!submitBtn) {
            console.error('回复提交按钮不存在，评论ID:', commentId);
            console.error('回复表单元素:', document.getElementById('replyForm-' + commentId));
            console.error('所有回复表单:', document.querySelectorAll('[id^="replyForm-"]'));
            console.error('所有发送按钮:', document.querySelectorAll('.btn-send'));
            showError('回复提交按钮不存在，请刷新页面重试');
            return;
        }
        
        console.log('找到提交按钮:', submitBtn);
        submitBtn.disabled = true;
        submitBtn.innerHTML = '<i class="fas fa-spinner fa-spin"></i> 发送中...';

        // 修复：获取上下文路径
        if (!contextPath) {
            const path = window.location.pathname;
            const pathParts = path.split('/');
            if (pathParts.length > 1) {
                contextPath = '/' + pathParts[1];
            }
        }
        const encodedContent = encodeURIComponent(content);
        console.log('提交回复，文章ID:', currentArticleId, '父评论ID:', commentId, '内容:', content);
        console.log('请求URL:', contextPath + '/comment/reply');
        
        // 构建请求体
        const requestBody = 'articleId=' + currentArticleId + '&parentId=' + commentId + '&content=' + encodedContent;
        console.log('请求体:', requestBody);
        
        fetch(contextPath + '/comment/reply', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8',
            },
            credentials: 'same-origin',
            body: requestBody
        })
            .then(response => {
                console.log('回复提交响应状态:', response.status);
                console.log('响应Content-Type:', response.headers.get('Content-Type'));
                
                // 先读取响应文本，以便调试
                return response.text().then(text => {
                    console.log('回复提交响应原始文本:', text);
                    
                    if (!response.ok) {
                        throw new Error('HTTP错误: ' + response.status + ' - ' + text);
                    }
                    
                    // 尝试解析JSON
                    try {
                        const data = JSON.parse(text);
                        return data;
                    } catch (e) {
                        console.error('JSON解析失败:', e, '响应文本:', text);
                        throw new Error('响应格式错误: ' + text);
                    }
                });
            })
            .then(data => {
                console.log('回复提交响应数据:', data);
                if (data && data.success) {
                    // 清空回复框并收起
                    const replyCharCount = document.getElementById('replyCharCount-' + commentId);
                    if (replyInput) replyInput.value = '';
                    if (replyCharCount) replyCharCount.textContent = '0';
                    toggleReplyForm(commentId);

                    // 重新加载评论列表
                    loadComments(currentArticleId);
                    showSuccess('回复发表成功');
                } else {
                    showError(data ? (data.message || '回复失败') : '回复失败：响应格式错误');
                }
            })
            .catch(error => {
                console.error('回复失败:', error);
                showError('回复失败: ' + (error.message || '请检查网络连接'));
            })
            .finally(() => {
                if (submitBtn) {
                submitBtn.disabled = false;
                submitBtn.innerHTML = '发送';
                }
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
        if (!message || message.trim() === '') {
            console.warn('showMessage: 消息为空');
            return;
        }
        
        console.log('显示消息:', message, '类型:', type);
        
        // 移除之前的消息
        const existingMessages = document.querySelectorAll('.comment-message-toast');
        existingMessages.forEach(msg => msg.remove());
        
        const messageDiv = document.createElement('div');
        messageDiv.className = 'comment-message-toast';
        messageDiv.style.cssText = `
            position: fixed;
            top: 20px;
            right: 20px;
            padding: 14px 20px;
            border-radius: 6px;
            color: white !important;
            font-weight: 500;
            font-size: 14px;
            line-height: 1.5;
            z-index: 99999;
            background: ${type == 'success' ? '#52c41a' : '#ff4d4f'} !important;
            box-shadow: 0 4px 12px rgba(0,0,0,0.15);
            display: flex;
            align-items: center;
            gap: 10px;
            min-width: 200px;
            max-width: 400px;
            word-wrap: break-word;
            white-space: normal;
            opacity: 1;
        `;

        const icon = type == 'success' ? 'fa-check-circle' : 'fa-exclamation-circle';
        const escapedMessage = escapeHtml(message);
        
        // 确保文字内容正确设置
        messageDiv.innerHTML = `
            <i class="fas ${icon}" style="font-size: 16px; flex-shrink: 0;"></i>
            <span style="color: white !important; display: inline-block;">${escapedMessage}</span>
        `;
        
        console.log('消息内容:', escapedMessage);
        console.log('消息元素:', messageDiv);

        document.body.appendChild(messageDiv);
        
        // 验证消息是否添加成功
        setTimeout(() => {
            const addedMessage = document.querySelector('.comment-message-toast');
            if (addedMessage) {
                const textContent = addedMessage.textContent || addedMessage.innerText;
                console.log('消息已添加，文本内容:', textContent);
                console.log('消息元素样式:', window.getComputedStyle(addedMessage));
            } else {
                console.error('消息元素未成功添加到DOM');
            }
        }, 100);

        setTimeout(() => {
            if (messageDiv.parentNode) {
                messageDiv.style.transition = 'opacity 0.3s ease';
                messageDiv.style.opacity = '0';
                setTimeout(() => {
                    if (messageDiv.parentNode) {
                        messageDiv.remove();
                    }
                }, 300);
            }
        }, 3000);
    }
    
    // 删除评论
    function deleteComment(commentId) {
        if (!confirm('确定要删除这条评论吗？删除后，所有回复也会被删除。')) {
            return;
        }
        
        const url = contextPath + '/comment/delete';
        const formData = new URLSearchParams();
        formData.append('commentId', commentId);
        
        fetch(url, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/x-www-form-urlencoded',
            },
            credentials: 'same-origin',
            body: formData
        })
        .then(response => response.json())
        .then(data => {
            if (data.success) {
                showSuccess(data.message || '评论已删除');
                // 重新加载评论列表
                if (currentArticleId) {
                    loadComments(currentArticleId);
                }
            } else {
                showError(data.message || '删除失败');
            }
        })
        .catch(error => {
            console.error('删除评论失败:', error);
            showError('删除失败，请重试');
        });
    }
    
    // 切换评论点赞状态
    function toggleCommentLike(commentId, isLiked) {
        const url = contextPath + (isLiked ? '/comment/unlike' : '/comment/like');
        const formData = new URLSearchParams();
        formData.append('commentId', commentId);
        
        fetch(url, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/x-www-form-urlencoded',
            },
            credentials: 'same-origin',
            body: formData
        })
        .then(response => response.json())
        .then(data => {
            if (data.success) {
                // 更新点赞按钮状态
                const likeBtn = document.querySelector('[onclick="toggleCommentLike(' + commentId + ', ' + isLiked + ')"]');
                const likesSpan = document.querySelector('.likes-count-' + commentId);
                
                if (likeBtn && likesSpan) {
                    if (data.liked) {
                        likeBtn.classList.add('liked');
                        likeBtn.setAttribute('onclick', 'toggleCommentLike(' + commentId + ', true)');
                    } else {
                        likeBtn.classList.remove('liked');
                        likeBtn.setAttribute('onclick', 'toggleCommentLike(' + commentId + ', false)');
                    }
                    likesSpan.textContent = data.likes || 0;
                }
            } else {
                showError(data.message || '操作失败');
            }
        })
        .catch(error => {
            console.error('点赞操作失败:', error);
            showError('操作失败，请重试');
        });
    }
    
    // 关闭评论抽屉（通知父窗口）
    function closeCommentDrawer() {
        // 如果在iframe中，通知父窗口关闭
        if (window.parent && window.parent !== window) {
            try {
                window.parent.postMessage({type: 'closeCommentDrawer'}, '*');
            } catch (e) {
                console.error('无法通知父窗口关闭评论抽屉:', e);
            }
        }
    }
</script>

<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
</body>
</html>