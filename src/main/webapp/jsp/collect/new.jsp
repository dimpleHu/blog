<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page isELIgnored="false" %>
<c:if test="${empty sessionScope.user}">
    <c:redirect url="${pageContext.request.contextPath}/jsp/user/login.jsp"/>
</c:if>
<html>
<head>
    <title>创建收藏夹 - 个人博客系统</title>
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
            padding: 0;
            margin: 0;
        }
        .container {
            max-width: 500px;
            margin: 0 auto;
            padding: 0;
        }
        .header {
            background: white;
            padding: 20px;
            border-bottom: 1px solid #f0f0f0;
            text-align: center;
        }
        .header h2 {
            font-size: 18px;
            font-weight: 600;
            color: #333;
            margin: 0;
        }
        .content {
            background: white;
            padding: 20px;
        }
        .form-group {
            margin-bottom: 20px;
        }
        .form-label {
            display: block;
            margin-bottom: 8px;
            font-weight: 600;
            color: #333;
            font-size: 14px;
        }
        .form-input {
            width: 100%;
            padding: 10px;
            border: 1px solid #ddd;
            border-radius: 6px;
            font-size: 14px;
            transition: border-color 0.3s ease;
        }
        .form-input:focus {
            outline: none;
            border-color: #1890ff;
            box-shadow: 0 0 0 2px rgba(24, 144, 255, 0.2);
        }
        .form-textarea {
            width: 100%;
            padding: 10px;
            border: 1px solid #ddd;
            border-radius: 6px;
            font-size: 14px;
            resize: vertical;
            min-height: 80px;
            transition: border-color 0.3s ease;
        }
        .form-textarea:focus {
            outline: none;
            border-color: #1890ff;
            box-shadow: 0 0 0 2px rgba(24, 144, 255, 0.2);
        }
        .char-count {
            text-align: right;
            font-size: 12px;
            color: #999;
            margin-top: 5px;
        }
        .char-count.warning {
            color: #faad14;
        }
        .char-count.error {
            color: #ff4d4f;
        }
        .switch-group {
            display: flex;
            gap: 30px;
            margin-bottom: 20px;
        }
        .switch-item {
            display: flex;
            align-items: center;
            gap: 8px;
        }
        .switch-label {
            font-size: 14px;
            color: #666;
            cursor: pointer;
        }
        .switch {
            position: relative;
            width: 44px;
            height: 24px;
        }
        .switch input {
            opacity: 0;
            width: 0;
            height: 0;
        }
        .slider {
            position: absolute;
            cursor: pointer;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background-color: #ccc;
            transition: .4s;
            border-radius: 24px;
        }
        .slider:before {
            position: absolute;
            content: "";
            height: 18px;
            width: 18px;
            left: 3px;
            bottom: 3px;
            background-color: white;
            transition: .4s;
            border-radius: 50%;
        }
        input:checked + .slider {
            background-color: #1890ff;
        }
        input:checked + .slider:before {
            transform: translateX(20px);
        }
        .button-group {
            display: flex;
            gap: 10px;
            justify-content: flex-end;
        }
        .btn {
            padding: 8px 16px;
            border: none;
            border-radius: 6px;
            font-size: 14px;
            cursor: pointer;
            transition: all 0.3s ease;
            min-width: 80px;
        }
        .btn-secondary {
            background: #f5f5f5;
            color: #666;
            border: 1px solid #ddd;
        }
        .btn-secondary:hover {
            background: #e6e6e6;
        }
        .btn-primary {
            background: #1890ff;
            color: white;
        }
        .btn-primary:hover {
            background: #40a9ff;
        }
        .btn-primary:disabled {
            background: #ccc;
            cursor: not-allowed;
        }
        .error-message {
            color: #ff4d4f;
            font-size: 12px;
            margin-top: 5px;
            display: none;
        }
        .success-message {
            color: #52c41a;
            font-size: 12px;
            margin-top: 5px;
            display: none;
        }
    </style>
</head>
<body>
<div class="container">
    <div class="header">
        <h2>创建收藏夹</h2>
    </div>

    <div class="content">
        <form id="createFolderForm">
            <div class="form-group">
                <label class="form-label">收藏夹标题</label>
                <input type="text" name="name" class="form-input"
                       placeholder="请输入收藏夹标题" maxlength="15"
                       oninput="updateCharCount(this, 'titleCount')">
                <div class="char-count" id="titleCount">0/15</div>
                <div class="error-message" id="titleError"></div>
            </div>

            <div class="form-group">
                <label class="form-label">收藏夹描述（可选）</label>
                <textarea name="description" class="form-textarea"
                          placeholder="请输入收藏夹描述" maxlength="200"
                          oninput="updateCharCount(this, 'descCount')"></textarea>
                <div class="char-count" id="descCount">0/200</div>
            </div>

            <div class="switch-group">
                <div class="switch-item">
                    <label class="switch">
                        <input type="checkbox" name="isPublic" value="1">
                        <span class="slider"></span>
                    </label>
                    <span class="switch-label">公开</span>
                </div>
                <div class="switch-item">
                    <label class="switch">
                        <input type="checkbox" name="isDefault" value="1">
                        <span class="slider"></span>
                    </label>
                    <span class="switch-label">默认</span>
                </div>
            </div>

            <div class="button-group">
                <button type="button" class="btn btn-secondary" onclick="goBack()">返回</button>
                <button type="submit" class="btn btn-primary" id="submitBtn">确认创建</button>
            </div>
        </form>
    </div>
</div>

<script>
    // 字符计数更新
    function updateCharCount(input, countId) {
        const countElement = document.getElementById(countId);
        const length = input.value.length;
        const maxLength = parseInt(input.getAttribute('maxlength'));

        countElement.textContent = length + '/' + maxLength;

        if (length > maxLength * 0.8) {
            countElement.className = 'char-count warning';
        } else if (length > maxLength) {
            countElement.className = 'char-count error';
        } else {
            countElement.className = 'char-count';
        }
    }

    // 表单提交
    document.getElementById('createFolderForm').addEventListener('submit', function(e) {
        e.preventDefault();

        const formData = new FormData(this);
        const submitBtn = document.getElementById('submitBtn');
        const titleInput = document.querySelector('input[name="name"]');
        const titleError = document.getElementById('titleError');

        // 验证标题
        if (!titleInput.value.trim()) {
            titleError.textContent = '收藏夹标题不能为空';
            titleError.style.display = 'block';
            return;
        }

        if (titleInput.value.trim().length > 15) {
            titleError.textContent = '标题不能超过15个字符';
            titleError.style.display = 'block';
            return;
        }

        titleError.style.display = 'none';
        submitBtn.disabled = true;
        submitBtn.innerHTML = '<i class="fas fa-spinner fa-spin"></i> 创建中...';

        fetch('${pageContext.request.contextPath}/folder/create', {
            method: 'POST',
            body: new URLSearchParams(formData)
        })
            .then(response => response.json())
            .then(data => {
                if (data.success) {
                    // 通知父页面创建成功
                    if (window.parent && window.parent.onCreateFolderSuccess) {
                        window.parent.onCreateFolderSuccess(data.folderId);
                    }

                    // 显示成功消息
                    if (window.parent && window.parent.showMessage) {
                        window.parent.showMessage('收藏夹创建成功！', 'success');
                    }

                    // 关闭弹窗
                    if (window.parent && window.parent.closeCreateFolderModal) {
                        window.parent.closeCreateFolderModal();
                    }
                } else {
                    titleError.textContent = data.message;
                    titleError.style.display = 'block';
                    submitBtn.disabled = false;
                    submitBtn.innerHTML = '确认创建';
                }
            })
            .catch(error => {
                console.error('Error:', error);
                titleError.textContent = '创建失败，请重试';
                titleError.style.display = 'block';
                submitBtn.disabled = false;
                submitBtn.innerHTML = '确认创建';
            });
    });

    // 返回按钮
    function goBack() {
        if (window.parent && window.parent.closeCreateFolderModal) {
            window.parent.closeCreateFolderModal();
        }
        if (window.parent && window.parent.showFavoriteDialog) {
            window.parent.showFavoriteDialog(${param.articleId});
        }
    }

    // 页面加载时初始化字符计数
    document.addEventListener('DOMContentLoaded', function() {
        const titleInput = document.querySelector('input[name="name"]');
        const descTextarea = document.querySelector('textarea[name="description"]');

        if (titleInput) updateCharCount(titleInput, 'titleCount');
        if (descTextarea) updateCharCount(descTextarea, 'descCount');
    });
</script>

<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
</body>
</html>