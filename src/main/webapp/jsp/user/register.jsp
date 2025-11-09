<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page isELIgnored="false" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
    <title>用户注册 - 个人博客系统</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body {
            font-family: 'Microsoft YaHei', Arial, sans-serif;
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            /* 和登录页统一背景图 */
            background: url("${pageContext.request.contextPath}/images/icon/banner1.jpg") no-repeat center center;
            background-size: cover;
            position: relative;
        }
        /* 背景遮罩（和登录页一致的透明度） */
        body::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: rgba(0, 0, 0, 0.3);
            z-index: -1;
        }

        /* 注册容器（和登录页统一的透明毛玻璃风格） */
        .register-container {
            width: 450px;
            background: rgba(255, 255, 255, 0.15); /* 15%透明度，几乎透明 */
            backdrop-filter: blur(10px);
            border-radius: 16px;
            box-shadow: 0 8px 32px rgba(0, 0, 0, 0.15);
            overflow: hidden;
            border: 1px solid rgba(255, 255, 255, 0.1); /* 淡色边框 */
        }

        /* 注册头部（和登录页统一的渐变+透明度） */
        .register-header {
            background: linear-gradient(135deg, rgba(102, 188, 234, 0.76) 0%, rgba(126, 197, 228, 0.66) 100%);
            color: white;
            padding: 30px;
            text-align: center;
            position: relative;
        }
        .register-header h1 {
            margin: 0;
            font-size: 26px;
            font-weight: 500;
            letter-spacing: 1px;
        }
        .register-header::after {
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

        /* 注册表单区域 */
        .register-body {
            padding: 35px 30px;
        }

        /* 表单组样式 */
        .form-group {
            margin-bottom: 22px;
            position: relative;
        }
        .form-group label {
            display: block;
            margin-bottom: 8px;
            color: white; /* 标签文字改为白色（和登录页一致） */
            font-size: 14px;
            font-weight: 500;
        }
        .form-control {
            width: 100%;
            padding: 14px 15px 14px 40px;
            border: 1px solid rgba(200, 200, 200, 0.3); /* 淡色边框 */
            border-radius: 8px;
            font-size: 15px;
            transition: all 0.3s ease;
            background: rgba(255, 255, 255, 0.2); /* 透明背景 */
            color: white; /* 输入文字白色 */
        }
        /* 输入框占位符样式（和登录页一致） */
        .form-control::placeholder {
            color: rgba(255, 255, 255, 0.7);
        }
        /* 输入框图标（保持主色调） */
        .form-group i {
            position: absolute;
            left: 15px;
            top: 42px;
            color: #66d6ea;
            font-size: 16px;
        }
        .form-control:focus {
            outline: none;
            border-color: #66d6ea;
            box-shadow: 0 0 0 3px rgba(102, 214, 234, 0.2);
            background: rgba(255, 255, 255, 0.3); /* 聚焦时稍亮 */
        }

        /* 表单提示文字（改为白色半透明） */
        .form-hint {
            font-size: 12px;
            color: rgba(255, 255, 255, 0.7);
            margin-top: 5px;
            display: flex;
            align-items: center;
            gap: 5px;
        }
        .form-hint i {
            position: static;
            font-size: 12px;
            color: rgba(255, 255, 255, 0.5);
        }

        /* 注册按钮（和登录页统一的渐变） */
        .btn-register {
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
        .btn-register:hover {
            background: linear-gradient(135deg, #55c5da 0%, #a9cdd8 100%);
            transform: translateY(-2px);
            box-shadow: 0 6px 12px rgba(102, 214, 234, 0.3);
        }
        .btn-register:active {
            transform: translateY(0);
        }

        /* 链接区域（和登录页统一的白色文字） */
        .register-links {
            text-align: center;
            margin-top: 25px;
            padding-top: 20px;
            border-top: 1px solid rgba(200, 200, 200, 0.3);
        }
        .register-links a {
            color: white;
            text-decoration: none;
            font-size: 14px;
            font-weight: 500;
            transition: color 0.3s;
        }
        .register-links a:hover {
            text-decoration: none;
            color: #bbd8e1; /*  hover 色和登录页一致 */
        }

        /* 提示框样式（和登录页统一的透明风格） */
        .alert {
            padding: 12px 15px;
            border-radius: 8px;
            margin-bottom: 25px;
            font-size: 14px;
            display: flex;
            align-items: center;
            gap: 8px;
            background: rgba(255, 255, 255, 0.1);
            border: 1px solid rgba(255, 255, 255, 0.1);
            color: white;
        }
        .alert i {
            font-size: 16px;
        }
        .alert-error {
            border-color: rgba(255, 204, 199, 0.3);
        }

        /* 响应式适配（保持原有逻辑） */
        @media (max-width: 500px) {
            .register-container {
                width: 90%;
                margin: 0 auto;
            }
            .register-body {
                padding: 25px 20px;
            }
            .form-group {
                margin-bottom: 18px;
            }
        }
    </style>
    <!-- Font Awesome 图标库 -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
</head>
<body>
<div class="register-container">
    <div class="register-header">
        <h1>用户注册</h1>
    </div>

    <div class="register-body">
        <%-- 显示错误信息 --%>
        <c:if test="${not empty error}">
            <div class="alert alert-error">
                <i class="fas fa-exclamation-circle"></i>
                <span>${error}</span>
            </div>
        </c:if>

        <form action="${pageContext.request.contextPath}/user/register" method="post" onsubmit="return validateForm()">
            <div class="form-group">
                <i class="fas fa-user"></i>
                <label for="username">用户名：</label>
                <input type="text" id="username" name="username"
                       value="${username}" class="form-control"
                       placeholder="3-20个字符" required>
                <div class="form-hint">
                    <i class="fas fa-info-circle"></i>
                    用户名长度3-20个字符，支持中文、英文、数字
                </div>
            </div>

            <div class="form-group">
                <i class="fas fa-lock"></i>
                <label for="password">密码：</label>
                <input type="password" id="password" name="password"
                       class="form-control" placeholder="至少6位" required>
                <div class="form-hint">
                    <i class="fas fa-info-circle"></i>
                    密码长度不能少于6位
                </div>
            </div>

            <div class="form-group">
                <i class="fas fa-lock-open"></i>
                <label for="confirmPassword">确认密码：</label>
                <input type="password" id="confirmPassword" name="confirmPassword"
                       class="form-control" placeholder="请再次输入密码" required>
            </div>

            <div class="form-group">
                <i class="fas fa-phone"></i>
                <label for="phonenumber">手机号：</label>
                <input type="tel" id="phonenumber" name="phonenumber"
                       value="${phonenumber}" class="form-control"
                       placeholder="11位手机号码" required>
                <div class="form-hint">
                    <i class="fas fa-info-circle"></i>
                    请输入有效的手机号码
                </div>
            </div>

            <button type="submit" class="btn-register">注册</button>
        </form>

        <div class="register-links">
            <a href="${pageContext.request.contextPath}/user/login">已有账号？立即登录</a>
        </div>
    </div>
</div>

<script>
    function validateForm() {
        const username = document.getElementById('username').value.trim();
        const password = document.getElementById('password').value;
        const confirmPassword = document.getElementById('confirmPassword').value;
        const phonenumber = document.getElementById('phonenumber').value.trim();

        // 验证用户名
        if (username.length < 3 || username.length > 20) {
            alert('用户名长度必须在3-20个字符之间');
            return false;
        }

        // 验证密码
        if (password.length < 6) {
            alert('密码长度不能少于6位');
            return false;
        }

        if (password !== confirmPassword) {
            alert('两次输入的密码不一致');
            return false;
        }

        // 验证手机号
        const phoneRegex = /^1[3-9]\d{9}$/;
        if (!phoneRegex.test(phonenumber)) {
            alert('请输入正确的手机号码');
            return false;
        }

        return true;
    }

    // 实时验证手机号格式
    document.getElementById('phonenumber').addEventListener('blur', function() {
        const phone = this.value.trim();
        const phoneRegex = /^1[3-9]\d{9}$/;
        if (phone && !phoneRegex.test(phone)) {
            this.style.borderColor = '#ff4d4f';
        } else {
            this.style.borderColor = 'rgba(200, 200, 200, 0.3)';
        }
    });
</script>
</body>
</html>