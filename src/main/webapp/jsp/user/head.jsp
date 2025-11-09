<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.blog.entity.User" %>
<%
    User user = (User) session.getAttribute("user");
    String contextPath = request.getContextPath();
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>个人博客系统</title>
    <style>
        /* 在head.jsp的CSS开头添加 */
        .navbar * {
            margin: initial;
            padding: initial;
            box-sizing: border-box;
        }

        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Microsoft YaHei', Arial, sans-serif;
            background-color: #f5f5f5;
        }

        /* 导航栏主色调：和login.jsp按钮一致的浅蓝绿渐变，降低亮度更柔和 */
        .navbar {
            background: linear-gradient(135deg, rgba(102, 188, 234, 0.92) 0%, rgba(126, 197, 228, 0.85) 100%);
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            position: sticky;
            top: 0;
            z-index: 1000;
        }

        .nav-container {
            max-width: 1200px;
            margin: 0 auto;
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 0 20px;
            height: 60px;
        }

        .logo {
            color: white;
            font-size: 24px;
            font-weight: bold;
            text-decoration: none;
            display: flex;
            align-items: center;
            padding-left: 40px;
        }

        .logo i {
            margin-right: 10px;
            font-size: 28px;
        }

        .nav-menu {
            display: flex;
            list-style: none;
            margin: 0;
            padding: 0;
        }

        .nav-item {
            margin: 0 10px;
        }

        .nav-link {
            color: white !important;
            text-decoration: none;
            padding: 8px 16px;
            border-radius: 20px;
            transition: all 0.3s ease;
            display: flex;
            align-items: center;
            font-size: 14px;
        }

        .nav-link i {
            margin-right: 5px;
            font-size: 16px;
            color: white !important;
        }

        /* hover效果：保持白色半透明，和原风格一致 */
        .nav-link:hover {
            background: rgba(255,255,255,0.2);
            transform: translateY(-2px);
        }

        /* 激活状态：加深白色半透明，增强辨识度，确保文字清晰可见 */
        .nav-link.active {
            background: rgba(255,255,255,0.4) !important;
            color: #fff !important;
            font-weight: 600;
        }

        .nav-link.active i {
            color: #fff !important;
        }

        .user-info {
            display: flex;
            align-items: center;
            color: white;
        }

        .welcome {
            margin-right: 15px;
            font-size: 14px;
        }

        /* 按钮样式：和login.jsp按钮渐变一致，保持视觉统一 */
        .logout-btn {
            background: linear-gradient(135deg, rgba(102, 188, 234, 0.8) 0%, rgba(126, 197, 228, 0.7) 100%);
            color: white;
            border: 1px solid rgba(255,255,255,0.3);
            padding: 6px 12px;
            border-radius: 15px;
            text-decoration: none;
            font-size: 12px;
            transition: all 0.3s ease;
            box-shadow: 0 2px 4px rgba(102, 188, 234, 0.2);
        }

        .logout-btn:hover {
            background: linear-gradient(135deg, #55c5da 0%, #a9cdd8 100%);
            transform: translateY(-1px);
            box-shadow: 0 4px 8px rgba(102, 188, 234, 0.3);
        }

        /* 移动端响应式 */
        @media (max-width: 768px) {
            .nav-container {
                flex-direction: column;
                height: auto;
                padding: 10px 20px;
            }

            .nav-menu {
                margin: 10px 0;
                flex-wrap: wrap;
                justify-content: center;
            }

            .nav-item {
                margin: 5px;
            }

            .user-info {
                margin-top: 10px;
                margin-bottom: 10px;
            }
        }
    </style>
    <!-- 使用Font Awesome图标 -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
</head>
<body>
<!-- 导航栏 -->
<nav class="navbar">
    <div class="nav-container">
        <!-- 网站Logo -->
        <a href="<%= contextPath %>/jsp/home.jsp" class="logo">
            <i class="fas fa-blog"></i>
            个人博客系统
        </a>

        <!-- 导航菜单 -->
        <ul class="nav-menu">
            <li class="nav-item">
                <a href="<%= contextPath %>/user/home" class="nav-link <%= request.getServletPath().contains("home") ? "active" : "" %>">
                    <i class="fas fa-home"></i>首页
                </a>
            </li>
            <li class="nav-item">
                <a href="<%= contextPath %>/article/publish" class="nav-link <%= request.getServletPath().contains("publish") ? "active" : "" %>">
                    <i class="fas fa-edit"></i>
                    发布文章
                </a>
            </li>
            <li class="nav-item">
                <a href="<%= contextPath %>/user/profile" class="nav-link <%= request.getRequestURI().contains("/user/profile") || request.getRequestURI().contains("/profile") ? "active" : "" %>">
                    <i class="fas fa-user"></i>
                    个人中心
                </a>
            </li>
        </ul>

        <!-- 用户信息和退出登录 -->
        <div class="user-info">
            <% if (user != null) { %>
            <span class="welcome">欢迎，<%= user.getUsername() %>！</span>
            <a href="<%= contextPath %>/user/logout" class="logout-btn">
                <i class="fas fa-sign-out-alt"></i>
                退出登录
            </a>
            <% } else { %>
            <a href="<%= contextPath %>/user/login" class="logout-btn">
                <i class="fas fa-sign-in-alt"></i>
                登录
            </a>
            <% } %>
        </div>
    </div>
</nav>
</body>
</html>