<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page isELIgnored="false" %>
<html>
<head>
    <title>用户登录 - 个人博客系统</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body {
            font-family: 'Microsoft YaHei', Arial, sans-serif;
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            background: url("${pageContext.request.contextPath}/images/icon/banner1.jpg") no-repeat center center;
            background-size: cover; /* 背景图自适应全屏 */
            position: relative;
        }
        /* 背景遮罩（降低图片亮度，让表单更清晰） */
        body::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: rgba(0, 0, 0, 0.3); /* 黑色半透明遮罩 */
            z-index: -1;
        }

        /* 登录容器（透明毛玻璃感） */
        .login-container {
            width: 400px;
            background: rgba(255, 255, 255, 0.15); /* 透明度降低到15%，几乎透明 */
            backdrop-filter: blur(10px); /* 毛玻璃模糊效果 */
            border-radius: 16px;
            box-shadow: 0 8px 32px rgba(0, 0, 0, 0.15);
            overflow: hidden;
            border: 1px solid rgba(255, 255, 255, 0.1); /* 更淡的边框 */
        }

        /* 登录头部 - 保持原有样式，确保标题可见 */
        .login-header {
            background: linear-gradient(135deg, rgba(102, 188, 234, 0.76) 0%, rgba(126, 197, 228, 0.66) 100%); /* 头部也加透明度 */
            color: white;
            padding: 30px;
            text-align: center;
            position: relative;
        }

        /* 输入框 - 调整背景透明度，确保输入可见 */
        .form-control {
            width: 100%;
            padding: 14px 15px 14px 40px;
            border: 1px solid rgba(200, 200, 200, 0.3); /* 边框更淡 */
            border-radius: 8px;
            font-size: 15px;
            transition: all 0.3s ease;
            background: rgba(255, 255, 255, 0.2); /* 输入框背景更透明 */
            color: white; /* 文字改为白色，避免和背景融合 */
        }
        .form-control::placeholder {
            color: rgba(255, 255, 255, 0.7); /* 占位符也改为白色半透明 */
        }
        .form-control:focus {
            outline: none;
            border-color: #66d6ea;
            box-shadow: 0 0 0 3px rgba(102, 214, 234, 0.2);
            background: rgba(255, 255, 255, 0.3); /* 聚焦时背景稍亮 */
        }

        /* 按钮 - 保持原有渐变，确保可见 */
        .btn-login {
            width: 100%;
            padding: 14px;
            background: linear-gradient(135deg, rgba(102, 188, 234, 0.76) 0%, rgba(126, 197, 228, 0.66) 100%);
            color: white;
            border: none;
            border-radius: 8px;
            font-size: 16px;
            font-weight: 500;
            cursor: pointer;
            transition: all 0.3s ease;
            box-shadow: 0 4px 8px rgba(102, 214, 234, 0.2);
        }

        /* 链接 - 文字改为白色 */
        .login-links a {
            color: white;
            text-decoration: none;
            font-size: 14px;
            font-weight: 500;
            transition: color 0.3s;
        }
        .login-links a:hover {
            color: #bbd8e1;
        }

        /* 提示框 - 调整背景和文字颜色 */
        .alert {
            padding: 12px 15px;
            border-radius: 8px;
            margin-bottom: 25px;
            font-size: 14px;
            display: flex;
            align-items: center;
            gap: 8px;
            background: rgba(255, 255, 255, 0.1); /* 提示框也透明 */
            border: 1px solid rgba(255, 255, 255, 0.1);
            color: white; /* 文字白色 */
        }
        .alert-error {
            border-color: rgba(255, 204, 199, 0.3);
        }
        .alert-success {
            border-color: rgba(183, 235, 143, 0.3);
        }

        .login-header h1 {
            margin: 0;
            font-size: 26px;
            font-weight: 500;
            letter-spacing: 1px;
        }
        .login-header::after {
            content: '';
            position: absolute;
            bottom: 0;
            left: 50%;
            transform: translateX(-50%);
            width: 60px;
            height: 3px;
            background: rgba(255, 255, 255, 0.8);
            border-radius: 3px;
        }

        /* 登录表单区域 */
        .login-body {
            padding: 35px 30px;
        }

        /* 表单组样式 */
        .form-group {
            margin-bottom: 25px;
            position: relative;
        }
        .form-group label {
            display: block;
            margin-bottom: 8px;
            color: #333;
            font-size: 14px;
            font-weight: 500;
        }

        /* 输入框图标 */
        .form-group i {
            position: absolute;
            left: 15px;
            top: 42px;
            color: #66d6ea; /* 主色调图标 */
            font-size: 16px;
        }

        .btn-login:hover {
            background: linear-gradient(135deg, #55c5da 0%, #a9cdd8 100%);
            transform: translateY(-2px);
            box-shadow: 0 6px 12px rgba(102, 214, 234, 0.3);
        }
        .btn-login:active {
            transform: translateY(0);
        }

        /* 链接区域 */
        .login-links {
            text-align: center;
            margin-top: 25px;
            padding-top: 20px;
            border-top: 1px solid rgba(200, 200, 200, 0.3);
        }

        .alert i {
            font-size: 16px;
        }

        /* 响应式适配 */
        @media (max-width: 450px) {
            .login-container {
                width: 90%;
                margin: 0 auto;
            }
            .login-body {
                padding: 25px 20px;
            }
            .form-group {
                margin-bottom: 20px;
            }
        }
    </style>
    <!-- Font Awesome 图标库（用于输入框图标） -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
</head>
<body>
<div class="login-container">
    <div class="login-header">
        <h1>个人博客系统</h1>
    </div>

    <div class="login-body">
        <%-- 显示错误信息 --%>
        <c:if test="${not empty error}">
            <div class="alert alert-error">
                <i class="fas fa-exclamation-circle"></i>
                <span>${error}</span>
            </div>
        </c:if>

        <%-- 显示注册成功信息 --%>
        <c:if test="${param.success eq '1'}">
            <div class="alert alert-success">
                <i class="fas fa-check-circle"></i>
                <span>注册成功，请登录</span>
            </div>
        </c:if>

        <form action="${pageContext.request.contextPath}/user/login" method="post">
            <div class="form-group">
                <i class="fas fa-user"></i>
                <label for="username">用户名：</label>
                <input type="text" id="username" name="username"
                       value="${param.username}" class="form-control"
                       placeholder="请输入用户名" required>
            </div>

            <div class="form-group">
                <i class="fas fa-lock"></i>
                <label for="password">密码：</label>
                <input type="password" id="password" name="password"
                       class="form-control" placeholder="请输入密码" required>
            </div>

            <button type="submit" class="btn-login">登录</button>
        </form>

        <div class="login-links">
            <a href="${pageContext.request.contextPath}/user/register">还没有账号？立即注册</a>
        </div>
    </div>
</div>
</body>
</html>