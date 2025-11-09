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
        .info-container {
            background: white;
            border-radius: 8px;
            padding: 30px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.1);
        }

        .info-item {
            display: flex;
            margin-bottom: 20px;
            padding-bottom: 20px;
            border-bottom: 1px solid #f0f0f0;
        }

        .info-label {
            width: 120px;
            font-weight: 600;
            color: #333;
        }

        .info-value {
            flex: 1;
            color: #666;
        }
    </style>
</head>
<body>
<jsp:include page="/jsp/user/head.jsp"/>
<jsp:include page="/jsp/user/sidebar.jsp"/>

<div class="main-content">
    <div class="content-header">
        <h1 class="content-title">${pageTitle}</h1>
    </div>
    <div class="content-body">
        <div class="info-container">
            <div class="info-item">
                <div class="info-label">用户名</div>
                <div class="info-value">${user.username}</div>
            </div>
            <div class="info-item">
                <div class="info-label">注册时间</div>
                <div class="info-value">${user.registerTime}</div>
            </div>
        </div>
    </div>
</div>
</body>
</html>