<%--<%@ page contentType="text/html;charset=UTF-8" language="java" %>--%>
<%--<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>--%>
<%--<%@ page isELIgnored="false" %> <!-- 关键：开启 EL 表达式解析 -->--%>
<%--<c:if test="${empty sessionScope.user}">--%>
<%--    <c:redirect url="${pageContext.request.contextPath}/jsp/user/login.jsp"/>--%>
<%--</c:if>--%>

<%--<html>--%>
<%--<head>--%>
<%--    <title>--%>
<%--        <c:choose>--%>
<%--            <c:when test="${empty param.draftId}">发布文章</c:when>--%>
<%--            <c:otherwise>编辑草稿</c:otherwise>--%>
<%--        </c:choose> - 个人博客系统--%>
<%--    </title>--%>
<%--    <style>--%>
<%--        .content {--%>
<%--            max-width: 1200px;--%>
<%--            margin: 20px auto;--%>
<%--            padding: 20px;--%>
<%--        }--%>

<%--        .post-form {--%>
<%--            background: rgba(255,255,255,0.8); /* 半透明白色表单 */--%>
<%--            backdrop-filter: blur(8px); /* 玻璃模糊 */--%>
<%--            padding: 30px;--%>
<%--            border-radius: 12px; /* 大圆角 */--%>
<%--            box-shadow: 0 4px 12px rgba(0,0,0,0.1);--%>
<%--            border: 1px solid rgba(200,200,200,0.3);--%>
<%--        }--%>

<%--        .form-group {--%>
<%--            margin-bottom: 20px;--%>
<%--        }--%>

<%--        .form-group label {--%>
<%--            display: block;--%>
<%--            margin-bottom: 5px;--%>
<%--            color: #333;--%>
<%--            font-weight: bold;--%>
<%--        }--%>

<%--        .form-control {--%>
<%--            width: 100%;--%>
<%--            padding: 12px 15px;--%>
<%--            border: 1px solid rgba(200,200,200,0.5);--%>
<%--            border-radius: 20px; /* 圆形输入框 */--%>
<%--            font-size: 14px;--%>
<%--            font-family: inherit;--%>
<%--            background: rgba(255,255,255,0.5); /* 输入框半透明 */--%>
<%--            transition: all 0.3s ease;--%>
<%--        }--%>

<%--        .form-control:focus {--%>
<%--            border-color: #66d6ea; /* 头部主色调 */--%>
<%--            box-shadow: 0 0 0 2px rgba(102, 214, 234, 0.2);--%>
<%--        }--%>

<%--        .btn-group {--%>
<%--            display: flex;--%>
<%--            gap: 10px;--%>
<%--            margin-top: 20px;--%>
<%--        }--%>

<%--        .btn {--%>
<%--            padding: 10px 20px;--%>
<%--            border: none;--%>
<%--            border-radius: 20px; /* 圆形按钮 */--%>
<%--            cursor: pointer;--%>
<%--            font-size: 14px;--%>
<%--            text-decoration: none;--%>
<%--            display: inline-flex;--%>
<%--            align-items: center;--%>
<%--            justify-content: center;--%>
<%--            transition: all 0.3s ease;--%>
<%--        }--%>

<%--        .btn-publish {--%>
<%--            background: linear-gradient(135deg, #66d6ea 0%, #bbd8e1 100%); /* 头部渐变 */--%>
<%--            color: white;--%>
<%--        }--%>

<%--        .btn-publish:hover {--%>
<%--            transform: translateY(-2px);--%>
<%--            box-shadow: 0 4px 8px rgba(102, 214, 234, 0.3);--%>
<%--        }--%>

<%--        .btn-draft {--%>
<%--            background: linear-gradient(135deg, #92e6a7 0%, #c3f0d1 100%); /* 草稿绿色渐变 */--%>
<%--            color: white;--%>
<%--        }--%>

<%--        .btn-draft:hover {--%>
<%--            transform: translateY(-2px);--%>
<%--            box-shadow: 0 4px 8px rgba(146, 230, 167, 0.3);--%>
<%--        }--%>

<%--        .btn-drafts {--%>
<%--            background: linear-gradient(135deg, #fdd892 0%, #ffe8b3 100%); /* 草稿箱黄色渐变 */--%>
<%--            color: white;--%>
<%--        }--%>

<%--        .btn-drafts:hover {--%>
<%--            transform: translateY(-2px);--%>
<%--            box-shadow: 0 4px 8px rgba(253, 216, 146, 0.3);--%>
<%--        }--%>

<%--        .alert {--%>
<%--            padding: 10px;--%>
<%--            border-radius: 8px;--%>
<%--            margin-bottom: 20px;--%>
<%--        }--%>

<%--        .alert-error {--%>
<%--            background: rgba(255, 242, 240, 0.8); /* 错误半透明背景 */--%>
<%--            border: 1px solid rgba(255, 204, 199, 0.5);--%>
<%--            color: #a8071a;--%>
<%--        }--%>

<%--        .alert-success {--%>
<%--            background: rgba(246, 255, 237, 0.8); /* 成功半透明背景 */--%>
<%--            border: 1px solid rgba(183, 235, 143, 0.5);--%>
<%--            color: #389e0d;--%>
<%--        }--%>

<%--        .draft-info {--%>
<%--            background: rgba(230, 247, 255, 0.8); /* 草稿信息半透明背景 */--%>
<%--            border: 1px solid rgba(145, 217, 255, 0.5);--%>
<%--            padding: 10px;--%>
<%--            border-radius: 8px;--%>
<%--            margin-bottom: 20px;--%>
<%--            font-size: 14px;--%>
<%--        }--%>
<%--    </style>--%>
<%--</head>--%>
<%--<body>--%>
<%--<%@ include file="/jsp/user/head.jsp" %>--%>

<%--<div class="content">--%>
<%--    <div class="post-form">--%>
<%--        <h2>--%>
<%--            <c:choose>--%>
<%--                <c:when test="${empty param.draftId}">发布新文章</c:when>--%>
<%--                <c:otherwise>编辑草稿</c:otherwise>--%>
<%--            </c:choose>--%>
<%--        </h2>--%>

<%--        &lt;%&ndash; 显示错误信息 &ndash;%&gt;--%>
<%--        <c:if test="${not empty requestScope.error}">--%>
<%--            <div class="alert alert-error">${requestScope.error}</div>--%>
<%--        </c:if>--%>

<%--        &lt;%&ndash; 显示成功信息 &ndash;%&gt;--%>
<%--        <c:if test="${not empty sessionScope.message}">--%>
<%--            <div class="alert alert-success">--%>
<%--                    ${sessionScope.message}--%>
<%--                <c:remove var="message" scope="session"/>--%>
<%--            </div>--%>
<%--        </c:if>--%>

<%--        &lt;%&ndash; 草稿信息 &ndash;%&gt;--%>
<%--        <c:if test="${not empty param.draftId}">--%>
<%--            <div class="draft-info">--%>
<%--                <i class="fas fa-edit"></i> 正在编辑草稿，发布后将转为正式文章。--%>
<%--            </div>--%>
<%--        </c:if>--%>

<%--        <form id="articleForm" action="${pageContext.request.contextPath}/article/publish" method="post">--%>
<%--            <input type="hidden" id="draftId" name="draftId" value="${param.draftId}">--%>

<%--            <div class="form-group">--%>
<%--                <label for="title">文章标题</label>--%>
<%--                <input type="text" id="title" name="title" class="form-control"--%>
<%--                       value="${param.title}" placeholder="请输入文章标题" required>--%>
<%--            </div>--%>
<%--            <div class="form-group">--%>
<%--                <label for="content">文章内容</label>--%>
<%--                <textarea id="content" name="content" class="form-control" rows="15"--%>
<%--                          placeholder="请输入文章内容" required>${param.content}</textarea>--%>
<%--            </div>--%>

<%--            <div class="btn-group">--%>
<%--                <button type="submit" class="btn btn-publish">--%>
<%--                    <i class="fas fa-paper-plane"></i>--%>
<%--                    <c:choose>--%>
<%--                        <c:when test="${empty param.draftId}">发布文章</c:when>--%>
<%--                        <c:otherwise>发布草稿</c:otherwise>--%>
<%--                    </c:choose>--%>
<%--                </button>--%>
<%--                <button type="button" id="saveDraftBtn" class="btn btn-draft">--%>
<%--                    <i class="fas fa-save"></i>--%>
<%--                    <c:choose>--%>
<%--                        <c:when test="${empty param.draftId}">保存草稿</c:when>--%>
<%--                        <c:otherwise>更新草稿</c:otherwise>--%>
<%--                    </c:choose>--%>
<%--                </button>--%>
<%--                <a href="${pageContext.request.contextPath}/article/drafts" class="btn btn-drafts">--%>
<%--                    <i class="fas fa-inbox"></i> 草稿箱--%>
<%--                </a>--%>
<%--            </div>--%>
<%--        </form>--%>
<%--    </div>--%>
<%--</div>--%>

<%--<script>--%>
<%--    // 保存草稿功能 - 修复版--%>
<%--    document.addEventListener('DOMContentLoaded', function() {--%>
<%--        const saveDraftBtn = document.getElementById('saveDraftBtn');--%>
<%--        if (saveDraftBtn) {--%>
<%--            saveDraftBtn.addEventListener('click', function() {--%>
<%--                // 获取表单元素--%>
<%--                const form = document.getElementById('articleForm');--%>
<%--                if (!form) {--%>
<%--                    console.error('找不到表单元素');--%>
<%--                    alert('系统错误：找不到表单');--%>
<%--                    return;--%>
<%--                }--%>

<%--                // 关键修复：直接获取输入框的值，而不是使用FormData--%>
<%--                const titleInput = document.getElementById('title');--%>
<%--                const contentInput = document.getElementById('content');--%>
<%--                const draftIdInput = document.getElementById('draftId');--%>

<%--                if (!titleInput || !contentInput) {--%>
<%--                    console.error('找不到标题或内容输入框');--%>
<%--                    alert('系统错误：找不到输入框');--%>
<%--                    return;--%>
<%--                }--%>

<%--                // 获取实际的值--%>
<%--                const title = titleInput.value.trim();--%>
<%--                const content = contentInput.value.trim();--%>
<%--                const draftId = draftIdInput ? draftIdInput.value : '';--%>

<%--                console.log('保存草稿数据:', { title, content: content.substring(0, 50) + '...', draftId });--%>

<%--                // 创建URL编码的表单数据--%>
<%--                const formData = new URLSearchParams();--%>
<%--                formData.append('title', title);--%>
<%--                formData.append('content', content);--%>
<%--                formData.append('draftId', draftId);--%>

<%--                // 显示加载状态--%>
<%--                const originalText = saveDraftBtn.innerHTML;--%>
<%--                saveDraftBtn.innerHTML = '<i class="fas fa-spinner fa-spin"></i> 保存中...';--%>
<%--                saveDraftBtn.disabled = true;--%>

<%--                // 使用AJAX保存草稿--%>
<%--                fetch('${pageContext.request.contextPath}/article/save-draft', {--%>
<%--                    method: 'POST',--%>
<%--                    headers: {--%>
<%--                        'Content-Type': 'application/x-www-form-urlencoded',--%>
<%--                    },--%>
<%--                    body: formData--%>
<%--                })--%>
<%--                    .then(response => {--%>
<%--                        if (!response.ok) {--%>
<%--                            throw new Error('网络响应不正常: ' + response.status);--%>
<%--                        }--%>
<%--                        return response.json();--%>
<%--                    })--%>
<%--                    .then(data => {--%>
<%--                        console.log('服务器响应:', data);--%>
<%--                        if (data.success) {--%>
<%--                            alert(data.message);--%>
<%--                            // 如果是新草稿，更新隐藏的draftId字段--%>
<%--                            if (draftId === '' && data.draftId) {--%>
<%--                                document.getElementById('draftId').value = data.draftId;--%>
<%--                                // 更新按钮文本--%>
<%--                                const publishBtn = document.querySelector('.btn-publish');--%>
<%--                                if (publishBtn) {--%>
<%--                                    publishBtn.innerHTML = '<i class="fas fa-paper-plane"></i> 发布草稿';--%>
<%--                                }--%>
<%--                                // 更新保存按钮文本--%>
<%--                                saveDraftBtn.innerHTML = '<i class="fas fa-save"></i> 更新草稿';--%>
<%--                            }--%>
<%--                        } else {--%>
<%--                            alert('保存失败: ' + (data.message || '未知错误'));--%>
<%--                        }--%>
<%--                    })--%>
<%--                    .catch(error => {--%>
<%--                        console.error('Error:', error);--%>
<%--                        alert('保存失败，请稍后重试: ' + error.message);--%>
<%--                    })--%>
<%--                    .finally(() => {--%>
<%--                        // 恢复按钮状态--%>
<%--                        saveDraftBtn.disabled = false;--%>
<%--                        saveDraftBtn.innerHTML = originalText;--%>
<%--                    });--%>
<%--            });--%>
<%--        }--%>

<%--        // 自动保存功能（可选）--%>
<%--        let autoSaveTimer;--%>
<%--        function startAutoSave() {--%>
<%--            // 清除之前的定时器--%>
<%--            if (autoSaveTimer) {--%>
<%--                clearInterval(autoSaveTimer);--%>
<%--            }--%>

<%--            // 每60秒自动保存一次--%>
<%--            autoSaveTimer = setInterval(() => {--%>
<%--                const title = document.getElementById('title')?.value || '';--%>
<%--                const content = document.getElementById('content')?.value || '';--%>

<%--                // 只有当有内容时才自动保存--%>
<%--                if (title.trim() !== '' || content.trim() !== '') {--%>
<%--                    console.log('自动保存草稿...');--%>
<%--                    document.getElementById('saveDraftBtn')?.click();--%>
<%--                }--%>
<%--            }, 60000); // 60秒--%>
<%--        }--%>

<%--        // 开始自动保存--%>
<%--        startAutoSave();--%>
<%--    });--%>
<%--</script>--%>

<%--<!-- 引入Font Awesome图标 -->--%>
<%--<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">--%>
<%--</body>--%>
<%--</html>--%>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page isELIgnored="false" %>
<c:if test="${empty sessionScope.user}">
    <c:redirect url="${pageContext.request.contextPath}/jsp/user/login.jsp"/>
</c:if>

<html>
<head>
    <title>
        <c:choose>
            <c:when test="${empty param.draftId}">发布文章</c:when>
            <c:otherwise>编辑草稿</c:otherwise>
        </c:choose> - 个人博客系统
    </title>
    <style>
        /* 原有样式保持不变，添加标签相关样式 */

        .content {
            max-width: 1200px;
            margin: 20px auto;
            padding: 20px;
        }

        .post-form {
            background: rgba(255,255,255,0.8); /* 半透明白色表单 */
            backdrop-filter: blur(8px); /* 玻璃模糊 */
            padding: 30px;
            border-radius: 12px; /* 大圆角 */
            box-shadow: 0 4px 12px rgba(0,0,0,0.1);
            border: 1px solid rgba(200,200,200,0.3);
        }

        .form-group {
            margin-bottom: 20px;
        }

        .form-group label {
            display: block;
            margin-bottom: 5px;
            color: #333;
            font-weight: bold;
        }

        .form-control {
            width: 100%;
            padding: 12px 15px;
            border: 1px solid rgba(200,200,200,0.5);
            border-radius: 20px; /* 圆形输入框 */
            font-size: 14px;
            font-family: inherit;
            background: rgba(255,255,255,0.5); /* 输入框半透明 */
            transition: all 0.3s ease;
        }

        .form-control:focus {
            border-color: #66d6ea; /* 头部主色调 */
            box-shadow: 0 0 0 2px rgba(102, 214, 234, 0.2);
        }

        .btn-group {
            display: flex;
            gap: 10px;
            margin-top: 20px;
        }

        .btn {
            padding: 10px 20px;
            border: none;
            border-radius: 20px; /* 圆形按钮 */
            cursor: pointer;
            font-size: 14px;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            transition: all 0.3s ease;
        }

        .btn-publish {
            background: linear-gradient(135deg, #66d6ea 0%, #bbd8e1 100%); /* 头部渐变 */
            color: white;
        }

        .btn-publish:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 8px rgba(102, 214, 234, 0.3);
        }

        .btn-draft {
            background: linear-gradient(135deg, #92e6a7 0%, #c3f0d1 100%); /* 草稿绿色渐变 */
            color: white;
        }

        .btn-draft:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 8px rgba(146, 230, 167, 0.3);
        }

        .btn-drafts {
            background: linear-gradient(135deg, #fdd892 0%, #ffe8b3 100%); /* 草稿箱黄色渐变 */
            color: white;
        }

        .btn-drafts:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 8px rgba(253, 216, 146, 0.3);
        }

        .alert {
            padding: 10px;
            border-radius: 8px;
            margin-bottom: 20px;
        }

        .alert-error {
            background: rgba(255, 242, 240, 0.8); /* 错误半透明背景 */
            border: 1px solid rgba(255, 204, 199, 0.5);
            color: #a8071a;
        }

        .alert-success {
            background: rgba(246, 255, 237, 0.8); /* 成功半透明背景 */
            border: 1px solid rgba(183, 235, 143, 0.5);
            color: #389e0d;
        }

        .draft-info {
            background: rgba(230, 247, 255, 0.8); /* 草稿信息半透明背景 */
            border: 1px solid rgba(145, 217, 255, 0.5);
            padding: 10px;
            border-radius: 8px;
            margin-bottom: 20px;
            font-size: 14px;
        }

        .tag-section {
            margin-bottom: 20px;
        }

        .tag-section label {
            display: block;
            margin-bottom: 10px;
            color: #333;
            font-weight: bold;
        }

        .tags-container {
            display: flex;
            flex-wrap: wrap;
            gap: 8px;
            margin-bottom: 10px;
        }

        .tag-item {
            display: inline-flex;
            align-items: center;
            padding: 6px 12px;
            border-radius: 20px;
            font-size: 12px;
            cursor: pointer;
            transition: all 0.3s ease;
            border: 2px solid transparent;
        }

        .tag-item:hover {
            transform: translateY(-2px);
            box-shadow: 0 2px 8px rgba(0,0,0,0.1);
        }

        .tag-item.selected {
            border-color: #66d6ea;
            box-shadow: 0 0 0 2px rgba(102, 214, 234, 0.2);
        }

        .tag-checkbox {
            display: none;
        }

        .tag-name {
            margin-right: 5px;
        }

        .tag-count {
            background: rgba(255,255,255,0.3);
            padding: 1px 6px;
            border-radius: 10px;
            font-size: 10px;
        }

        .tag-search {
            width: 100%;
            padding: 8px 12px;
            border: 1px solid rgba(200,200,200,0.5);
            border-radius: 20px;
            font-size: 14px;
            margin-bottom: 10px;
            background: rgba(255,255,255,0.5);
        }

        .tag-search:focus {
            border-color: #66d6ea;
            box-shadow: 0 0 0 2px rgba(102, 214, 234, 0.2);
            outline: none;
        }

        .selected-tags {
            display: flex;
            flex-wrap: wrap;
            gap: 8px;
            margin-top: 10px;
            min-height: 40px;
            padding: 10px;
            background: rgba(248,249,250,0.8);
            border-radius: 8px;
            border: 1px dashed #ddd;
        }

        .selected-tag {
            display: inline-flex;
            align-items: center;
            padding: 4px 8px;
            background: #66d6ea;
            color: white;
            border-radius: 15px;
            font-size: 12px;
        }

        .remove-tag {
            margin-left: 5px;
            cursor: pointer;
            font-weight: bold;
        }

        .no-tags {
            color: #999;
            font-style: italic;
        }

        .tag-hint {
            font-size: 12px;
            color: #666;
            margin-top: 5px;
        }
    </style>
</head>
<body>
<%@ include file="/jsp/user/head.jsp" %>

<div class="content">
    <div class="post-form">
        <h2>
            <c:choose>
                <c:when test="${empty requestScope.draftId and empty param.draftId}">发布新文章</c:when>
                <c:otherwise>编辑草稿</c:otherwise>
            </c:choose>
        </h2>

        <%-- 显示错误信息 --%>
        <c:if test="${not empty requestScope.error}">
            <div class="alert alert-error">${requestScope.error}</div>
        </c:if>

        <%-- 显示成功信息 --%>
        <c:if test="${not empty sessionScope.message}">
            <div class="alert alert-success">
                    ${sessionScope.message}
                <c:remove var="message" scope="session"/>
            </div>
        </c:if>

        <%-- 草稿信息 --%>
        <c:if test="${not empty requestScope.draftId or not empty param.draftId}">
            <div class="draft-info">
                <i class="fas fa-edit"></i> 正在编辑草稿，发布后将转为正式文章。
            </div>
        </c:if>

        <form id="articleForm" action="${pageContext.request.contextPath}/article/publish" method="post">
            <input type="hidden" id="draftId" name="draftId" value="${not empty requestScope.draftId ? requestScope.draftId : param.draftId}">

            <div class="form-group">
                <label for="title">文章标题</label>
                <input type="text" id="title" name="title" class="form-control"
                       value="${not empty requestScope.title ? requestScope.title : param.title}" placeholder="请输入文章标题" required>
            </div>

            <%-- 新增：标签选择区域 --%>
            <div class="form-group tag-section">
                <label for="tagSearch">文章标签（可选）</label>
                <input type="text" id="tagSearch" class="tag-search" placeholder="搜索标签...">

                <div class="tags-container" id="tagsContainer">
                    <c:forEach items="${requestScope.allTags}" var="tag">
                        <div class="tag-item" style="background: ${tag.color}; color: white;"
                             data-tag-id="${tag.id}">
                            <input type="checkbox" class="tag-checkbox" id="tag-${tag.id}"
                                   name="tagIds" value="${tag.id}"
                                   <c:if test="${not empty requestScope.selectedTagIds and requestScope.selectedTagIds.contains(tag.id)}">checked</c:if>>
                            <span class="tag-name">${tag.name}</span>
                            <span class="tag-count">${tag.useCount}</span>
                        </div>
                    </c:forEach>
                </div>

                <div class="tag-hint">最多可选择5个标签</div>

                <div class="selected-tags" id="selectedTags">
                    <c:forEach items="${requestScope.allTags}" var="tag">
                        <c:if test="${not empty requestScope.selectedTagIds and requestScope.selectedTagIds.contains(tag.id)}">
                            <span class="selected-tag" data-tag-id="${tag.id}">
                                ${tag.name}
                                <span class="remove-tag">×</span>
                            </span>
                        </c:if>
                    </c:forEach>
                    <c:if test="${empty requestScope.selectedTagIds}">
                        <span class="no-tags">暂未选择标签</span>
                    </c:if>
                </div>
            </div>

            <div class="form-group">
                <label for="content">文章内容</label>
                <textarea id="content" name="content" class="form-control" rows="15"
                          placeholder="请输入文章内容" required><c:out value="${not empty requestScope.content ? requestScope.content : param.content}" escapeXml="false"/></textarea>
            </div>

            <div class="btn-group">
                <button type="submit" class="btn btn-publish">
                    <i class="fas fa-paper-plane"></i>
                    <c:choose>
                        <c:when test="${empty param.draftId}">发布文章</c:when>
                        <c:otherwise>发布草稿</c:otherwise>
                    </c:choose>
                </button>
                <button type="button" id="saveDraftBtn" class="btn btn-draft">
                    <i class="fas fa-save"></i>
                    <c:choose>
                        <c:when test="${empty param.draftId}">保存草稿</c:when>
                        <c:otherwise>更新草稿</c:otherwise>
                    </c:choose>
                </button>
                <a href="${pageContext.request.contextPath}/article/drafts" class="btn btn-drafts">
                    <i class="fas fa-inbox"></i> 草稿箱
                </a>
            </div>
        </form>
    </div>
</div>

<script>
    // 标签选择功能
    document.addEventListener('DOMContentLoaded', function() {
        const maxTags = 5; // 最多选择标签数
        let selectedTags = new Set();

        // 初始化已选标签
        document.querySelectorAll('.tag-checkbox:checked').forEach(checkbox => {
            selectedTags.add(parseInt(checkbox.value));
        });
        updateSelectedTagsDisplay();

        // 标签点击事件
        document.querySelectorAll('.tag-item').forEach(tag => {
            tag.addEventListener('click', function() {
                const checkbox = this.querySelector('.tag-checkbox');
                const tagId = parseInt(this.getAttribute('data-tag-id'));

                if (checkbox.checked) {
                    // 取消选择
                    checkbox.checked = false;
                    selectedTags.delete(tagId);
                    this.classList.remove('selected');
                } else {
                    // 检查是否达到最大选择数
                    if (selectedTags.size >= maxTags) {
                        alert('最多只能选择' + maxTags + '个标签');
                        return;
                    }
                    // 选择标签
                    checkbox.checked = true;
                    selectedTags.add(tagId);
                    this.classList.add('selected');
                }

                updateSelectedTagsDisplay();
            });
        });

        // 移除标签事件
        document.addEventListener('click', function(e) {
            if (e.target.classList.contains('remove-tag')) {
                const tagId = parseInt(e.target.closest('.selected-tag').getAttribute('data-tag-id'));
                selectedTags.delete(tagId);

                // 取消对应的复选框
                const checkbox = document.getElementById('tag-' + tagId);
                if (checkbox) {
                    checkbox.checked = false;
                    checkbox.closest('.tag-item').classList.remove('selected');
                }

                updateSelectedTagsDisplay();
            }
        });

        // 标签搜索功能
        const tagSearch = document.getElementById('tagSearch');
        if (tagSearch) {
            tagSearch.addEventListener('input', function() {
                const searchTerm = this.value.toLowerCase();
                document.querySelectorAll('.tag-item').forEach(tag => {
                    const tagName = tag.querySelector('.tag-name').textContent.toLowerCase();
                    if (tagName.includes(searchTerm)) {
                        tag.style.display = 'inline-flex';
                    } else {
                        tag.style.display = 'none';
                    }
                });
            });
        }

        // 更新已选标签显示
        function updateSelectedTagsDisplay() {
            const selectedTagsContainer = document.getElementById('selectedTags');
            if (!selectedTagsContainer) return;

            selectedTagsContainer.innerHTML = '';

            if (selectedTags.size === 0) {
                selectedTagsContainer.innerHTML = '<span class="no-tags">暂未选择标签</span>';
                return;
            }

            selectedTags.forEach(tagId => {
                const tagItem = document.querySelector('.tag-item[data-tag-id="' + tagId + '"]');
                if (tagItem) {
                    const tagName = tagItem.querySelector('.tag-name').textContent;
                    const tagColor = tagItem.style.backgroundColor;

                    const selectedTag = document.createElement('span');
                    selectedTag.className = 'selected-tag';
                    selectedTag.setAttribute('data-tag-id', tagId);
                    selectedTag.style.background = tagColor;
                    selectedTag.innerHTML = tagName + '<span class="remove-tag">×</span>';

                    selectedTagsContainer.appendChild(selectedTag);
                }
            });
        }

        // 表单提交前验证标签数量
        const articleForm = document.getElementById('articleForm');
        if (articleForm) {
            articleForm.addEventListener('submit', function(e) {
                if (selectedTags.size > maxTags) {
                    e.preventDefault();
                    alert('最多只能选择' + maxTags + '个标签');
                    return false;
                }
            });
        }

        // 保存草稿功能（原有代码，添加标签处理）
        const saveDraftBtn = document.getElementById('saveDraftBtn');
        if (saveDraftBtn) {
            saveDraftBtn.addEventListener('click', function() {
                // 获取表单数据
                const title = document.getElementById('title')?.value || '';
                const content = document.getElementById('content')?.value || '';
                const draftId = document.getElementById('draftId')?.value || '';

                // 构建表单数据，包含标签
                const formData = new URLSearchParams();
                formData.append('title', title);
                formData.append('content', content);
                formData.append('draftId', draftId);

                // 添加选中的标签（关键：保留新增的标签提交逻辑）
                selectedTags.forEach(tagId => {
                    formData.append('tagIds', tagId.toString());
                });

                // 原有保存草稿逻辑（完整填充）
                console.log('保存草稿数据:', {
                    title,
                    content: content.substring(0, 50) + '...',
                    draftId,
                    tagIds: Array.from(selectedTags) // 打印选中的标签ID，便于调试
                });

                // 显示加载状态
                const originalText = saveDraftBtn.innerHTML;
                saveDraftBtn.innerHTML = '<i class="fas fa-spinner fa-spin"></i> 保存中...';
                saveDraftBtn.disabled = true;

                // 使用AJAX保存草稿
                fetch('${pageContext.request.contextPath}/article/save-draft', {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/x-www-form-urlencoded',
                    },
                    body: formData
                })
                    .then(response => {
                        if (!response.ok) {
                            throw new Error('网络响应不正常: ' + response.status);
                        }
                        return response.json();
                    })
                    .then(data => {
                        console.log('服务器响应:', data);
                        if (data.success) {
                            alert(data.message);
                            // 如果是新草稿，更新隐藏的draftId字段
                            if (draftId === '' && data.draftId) {
                                document.getElementById('draftId').value = data.draftId;
                                // 更新按钮文本
                                const publishBtn = document.querySelector('.btn-publish');
                                if (publishBtn) {
                                    publishBtn.innerHTML = '<i class="fas fa-paper-plane"></i> 发布草稿';
                                }
                                // 更新保存按钮文本
                                saveDraftBtn.innerHTML = '<i class="fas fa-save"></i> 更新草稿';
                            }
                        } else {
                            alert('保存失败: ' + (data.message || '未知错误'));
                        }
                    })
                    .catch(error => {
                        console.error('Error:', error);
                        alert('保存失败，请稍后重试: ' + error.message);
                    })
                    .finally(() => {
                        // 恢复按钮状态
                        saveDraftBtn.disabled = false;
                        saveDraftBtn.innerHTML = originalText;
                    });
            });
        }

        // 自动保存功能（可选，保留原有逻辑）
        let autoSaveTimer;
        function startAutoSave() {
            // 清除之前的定时器
            if (autoSaveTimer) {
                clearInterval(autoSaveTimer);
            }

            // 每60秒自动保存一次
            autoSaveTimer = setInterval(() => {
                const title = document.getElementById('title')?.value || '';
                const content = document.getElementById('content')?.value || '';

                // 只有当有内容时才自动保存
                if (title.trim() !== '' || content.trim() !== '') {
                    console.log('自动保存草稿...');
                    document.getElementById('saveDraftBtn')?.click();
                }
            }, 60000); // 60秒
        }

        // 开始自动保存
        startAutoSave();
    });
</script>

<!-- 引入图标库 -->
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
</body>
</html>