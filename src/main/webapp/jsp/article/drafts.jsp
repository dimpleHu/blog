<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page isELIgnored="false" %> <!-- 关键：开启 EL 表达式解析 -->
<html>
<head>
    <title>草稿箱 - 个人博客系统</title>
    <style>
        .content {
            max-width: 1200px;
            margin: 20px auto;
            padding: 20px;
        }

        .drafts-container {
            background: rgba(255,255,255,0.8); /* 半透明白色容器 */
            backdrop-filter: blur(8px); /* 玻璃模糊 */
            padding: 30px;
            border-radius: 12px; /* 大圆角 */
            box-shadow: 0 4px 12px rgba(0,0,0,0.1);
            border: 1px solid rgba(200,200,200,0.3);
        }

        .draft-item {
            border: 1px solid rgba(200,200,200,0.3);
            border-radius: 12px; /* 大圆角 */
            padding: 20px;
            margin-bottom: 15px;
            transition: all 0.3s ease;
            background: rgba(255,255,255,0.5); /* 子项半透明 */
        }

        .draft-item:hover {
            box-shadow: 0 4px 8px rgba(102, 214, 234, 0.2);
            border-color: #66d6ea; /* 头部主色调边框 */
            transform: translateY(-5px);
        }

        .draft-title {
            font-size: 18px;
            font-weight: bold;
            margin-bottom: 10px;
            color: #333;
        }

        .draft-summary {
            color: #666;
            margin-bottom: 10px;
            line-height: 1.5;
        }

        .draft-meta {
            display: flex;
            justify-content: space-between;
            align-items: center;
            font-size: 12px;
            color: #666;
        }

        .draft-actions {
            display: flex;
            gap: 10px;
        }

        .btn {
            padding: 6px 12px; /* 按钮尺寸调整 */
            border: none;
            border-radius: 20px; /* 圆形按钮 */
            cursor: pointer;
            text-decoration: none;
            font-size: 12px;
            color: white;
            transition: all 0.3s ease;
        }

        .btn-edit {
            background: linear-gradient(135deg, #66d6ea 0%, #bbd8e1 100%); /* 头部渐变 */
        }

        .btn-edit:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 8px rgba(102, 214, 234, 0.3);
        }

        .btn-publish {
            background: linear-gradient(135deg, #92e6a7 0%, #c3f0d1 100%); /* 发布绿色渐变 */
        }

        .btn-publish:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 8px rgba(146, 230, 167, 0.3);
        }

        .btn-delete {
            background: linear-gradient(135deg, #ff9a9a 0%, #ffc0c0 100%); /* 删除红色渐变 */
        }

        .btn-delete:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 8px rgba(255, 154, 154, 0.3);
        }

        .empty-state {
            text-align: center;
            padding: 40px;
            color: #999;
        }

        .alert-error {
            background: rgba(255, 242, 240, 0.8); /* 错误半透明背景 */
            border: 1px solid rgba(255, 204, 199, 0.5);
            color: #a8071a;
            padding: 10px;
            border-radius: 8px;
            margin-bottom: 20px;
        }

        /* 调试信息样式 */
        .debug-info {
            background: rgba(240, 240, 240, 0.8); /* 调试信息半透明背景 */
            border: 1px solid rgba(200, 200, 200, 0.3);
            padding: 15px;
            margin-bottom: 20px;
            border-radius: 8px;
            font-family: monospace;
            font-size: 14px;
        }

        .debug-title {
            font-weight: bold;
            margin-bottom: 10px;
            color: #333;
        }
    </style>
</head>
<body>
<%@ include file="/jsp/user/head.jsp" %>

<div class="content">
    <div class="drafts-container">
        <h2>草稿箱 (${draftCount != null ? draftCount : 0})</h2>

        <c:if test="${not empty error}">
            <div class="alert-error">${error}</div>
        </c:if>

        <c:choose>
            <c:when test="${not empty drafts}">
                <c:forEach items="${drafts}" var="draft">
                    <div class="draft-item">
                        <div class="draft-title">
                                ${draft.title != null ? draft.title : "无标题"}
                        </div>
                        <div class="draft-summary">
                                ${draft.summary != null ? draft.summary : "暂无摘要"}
                        </div>
                        <div class="draft-meta">
                            <span>最后编辑: ${draft.editTime != null ? draft.editTime : "未知"}</span>
                            <div class="draft-actions">
                                <a href="${pageContext.request.contextPath}/article/publish?draftId=${draft.id}"
                                   class="btn btn-publish" onclick="return confirm('确定要发布这篇草稿吗？')">
                                    <i class="fas fa-paper-plane"></i> 发布
                                </a>
                                <a href="${pageContext.request.contextPath}/article/publish?draftId=${draft.id}"
                                   class="btn btn-edit">
                                    <i class="fas fa-edit"></i> 编辑
                                </a>
                                <a href="${pageContext.request.contextPath}/article/delete-draft?id=${draft.id}"
                                   class="btn btn-delete" onclick="return confirm('确定要删除这篇草稿吗？')">
                                    <i class="fas fa-trash"></i> 删除
                                </a>
                            </div>
                        </div>
                    </div>
                </c:forEach>
            </c:when>
            <c:otherwise>
                <div class="empty-state">
                    <i class="fas fa-inbox" style="font-size: 48px; margin-bottom: 20px;"></i>
                    <p>暂无草稿</p>
                    <a href="${pageContext.request.contextPath}/article/publish" class="btn btn-edit">去写文章</a>
                </div>
            </c:otherwise>
        </c:choose>
    </div>
</div>

<script>
    // 浏览器控制台调试信息
    console.log("=== 草稿箱页面调试信息 ===");
    console.log("草稿列表数量：", ${drafts != null ? drafts.size() : 0});
    console.log("草稿统计数量：", ${draftCount != null ? draftCount : 0});
    console.log("错误信息：", "${error != null ? error : '无'}");
    console.log("当前用户：", "${sessionScope.user.username}");
    console.log("用户ID：", "${sessionScope.user.id}");

    // 如果有草稿数据，详细输出
    <c:if test="${not empty drafts}">
    <c:forEach items="${drafts}" var="draft" varStatus="status">
    console.log("草稿${status.index + 1}: ID=${draft.id}, 标题='${draft.title}', 状态=${draft.status}");
    </c:forEach>
    </c:if>
</script>

<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
</body>
</html>