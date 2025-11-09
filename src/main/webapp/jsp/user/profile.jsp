<%--<%@ page contentType="text/html;charset=UTF-8" language="java" %>--%>
<%--<%@ page import="com.blog.entity.User" %>--%>
<%--<%--%>
<%--    User user = (User) session.getAttribute("user");--%>
<%--    if (user == null) {--%>
<%--        response.sendRedirect(request.getContextPath() + "/user/login");--%>
<%--        return;--%>
<%--    }--%>
<%--%>--%>
<%--<html>--%>
<%--<head>--%>
<%--    <title>个人信息 - 个人博客系统</title>--%>
<%--    <style>--%>
<%--        .content {--%>
<%--            max-width: 1200px;--%>
<%--            margin: 20px auto;--%>
<%--            padding: 20px;--%>
<%--        }--%>

<%--        .profile-card {--%>
<%--            background: white;--%>
<%--            padding: 30px;--%>
<%--            border-radius: 8px;--%>
<%--            box-shadow: 0 2px 10px rgba(0,0,0,0.1);--%>
<%--        }--%>

<%--        .user-info {--%>
<%--            display: grid;--%>
<%--            grid-template-columns: 150px 1fr;--%>
<%--            gap: 20px;--%>
<%--            align-items: center;--%>
<%--        }--%>

<%--        .avatar {--%>
<%--            width: 120px;--%>
<%--            height: 120px;--%>
<%--            border-radius: 50%;--%>
<%--            object-fit: cover;--%>
<%--        }--%>

<%--        .info-item {--%>
<%--            margin-bottom: 10px;--%>
<%--            padding: 10px;--%>
<%--            background: #f8f9fa;--%>
<%--            border-radius: 4px;--%>
<%--        }--%>

<%--        .info-label {--%>
<%--            font-weight: bold;--%>
<%--            color: #333;--%>
<%--        }--%>
<%--        .container {--%>
<%--            max-width: 1200px;--%>
<%--            margin: 0 auto;--%>
<%--            padding: 20px;--%>
<%--        }--%>
<%--        .dashboard {--%>
<%--            display: grid;--%>
<%--            grid-template-columns: 1fr 300px;--%>
<%--            gap: 20px;--%>
<%--        }--%>
<%--        .main-content {--%>
<%--            display: grid;--%>
<%--            gap: 20px;--%>
<%--        }--%>
<%--        .user-info-item {--%>
<%--            display: flex;--%>
<%--            justify-content: space-between;--%>
<%--            padding: 8px 0;--%>
<%--            border-bottom: 1px solid #f0f0f0;--%>
<%--        }--%>
<%--        .user-info-item:last-child {--%>
<%--            border-bottom: none;--%>
<%--        }--%>

<%--        .card {--%>
<%--            background: white;--%>
<%--            border-radius: 8px;--%>
<%--            padding: 24px;--%>
<%--            box-shadow: 0 2px 8px rgba(0,0,0,0.1);--%>
<%--        }--%>
<%--        .card h2 {--%>
<%--            margin: 0 0 16px 0;--%>
<%--            color: #1890ff;--%>
<%--            font-size: 18px;--%>
<%--            border-bottom: 2px solid #f0f0f0;--%>
<%--            padding-bottom: 8px;--%>
<%--        }--%>
<%--        .stats {--%>
<%--            display: grid;--%>
<%--            grid-template-columns: repeat(3, 1fr);--%>
<%--            gap: 16px;--%>
<%--            margin-top: 16px;--%>
<%--        }--%>
<%--        .stat-item {--%>
<%--            text-align: center;--%>
<%--            padding: 16px;--%>
<%--            background: #f0f8ff;--%>
<%--            border-radius: 4px;--%>
<%--        }--%>
<%--        .stat-number {--%>
<%--            font-size: 24px;--%>
<%--            font-weight: bold;--%>
<%--            color: #1890ff;--%>
<%--        }--%>
<%--        .stat-label {--%>
<%--            font-size: 12px;--%>
<%--            color: #666;--%>
<%--            margin-top: 4px;--%>
<%--        }--%>
<%--    </style>--%>
<%--</head>--%>
<%--<body>--%>
<%--<jsp:include page="head.jsp"/>--%>
<%--<jsp:include page="sidebar.jsp"/>--%>

<%--<div class="content">--%>
<%--    <div class="profile-card">--%>
<%--        <h2>个人中心</h2>--%>
<%--        <div class="user-info">--%>
<%--            <div>--%>
<%--                <img src="<%= user.getAvatar() != null ? user.getAvatar() : "images/default-avatar.jpg" %>"--%>
<%--                     alt="头像" class="avatar">--%>
<%--            </div>--%>
<%--            <div>--%>
<%--                <div class="info-item">--%>
<%--                    <span class="info-label">用户名：</span>--%>
<%--                    <%= user.getUsername() %>--%>
<%--                </div>--%>
<%--                <div class="info-item">--%>
<%--                    <span class="info-label">手机号：</span>--%>
<%--                    <%= user.getPhonenumber() %>--%>
<%--                </div>--%>
<%--                <div class="info-item">--%>
<%--                    <span class="info-label">注册时间：</span>--%>
<%--                    <%= user.getCreateTime() %>--%>
<%--                </div>--%>
<%--            </div>--%>

<%--&lt;%&ndash;            <div class="sidebar">&ndash;%&gt;--%>
<%--&lt;%&ndash;                <div class="card">&ndash;%&gt;--%>
<%--&lt;%&ndash;                    <h2>数据统计</h2>&ndash;%&gt;--%>
<%--&lt;%&ndash;                    <div class="stats">&ndash;%&gt;--%>
<%--&lt;%&ndash;                        <div class="stat-item">&ndash;%&gt;--%>
<%--&lt;%&ndash;                            <div class="stat-number">0</div>&ndash;%&gt;--%>
<%--&lt;%&ndash;                            <div class="stat-label">文章数</div>&ndash;%&gt;--%>
<%--&lt;%&ndash;                        </div>&ndash;%&gt;--%>
<%--&lt;%&ndash;                        <div class="stat-item">&ndash;%&gt;--%>
<%--&lt;%&ndash;                            <div class="stat-number">0</div>&ndash;%&gt;--%>
<%--&lt;%&ndash;                            <div class="stat-label">评论数</div>&ndash;%&gt;--%>
<%--&lt;%&ndash;                        </div>&ndash;%&gt;--%>
<%--&lt;%&ndash;                        <div class="stat-item">&ndash;%&gt;--%>
<%--&lt;%&ndash;                            <div class="stat-number">0</div>&ndash;%&gt;--%>
<%--&lt;%&ndash;                            <div class="stat-label">收藏数</div>&ndash;%&gt;--%>
<%--&lt;%&ndash;                        </div>&ndash;%&gt;--%>
<%--&lt;%&ndash;                    </div>&ndash;%&gt;--%>
<%--&lt;%&ndash;                </div>&ndash;%&gt;--%>
<%--&lt;%&ndash;            </div>&ndash;%&gt;--%>
<%--        </div>--%>
<%--    </div>--%>
<%--</div>--%>

<%--<div class="container">--%>
<%--    <div class="dashboard">--%>
<%--        <div class="main-content">--%>
<%--            <div class="card">--%>
<%--                <h2>个人资料</h2>--%>
<%--                <div class="user-info">--%>
<%--                    <div class="user-info-item">--%>
<%--                        <span class="label">用户名：</span>--%>
<%--                        <span class="value"><%= user.getUsername() %></span>--%>
<%--                    </div>--%>
<%--                    <div class="user-info-item">--%>
<%--                        <span class="label">手机号：</span>--%>
<%--                        <span class="value"><%= user.getPhonenumber() %></span>--%>
<%--                    </div>--%>
<%--                    <div class="user-info-item">--%>
<%--                        <span class="label">注册时间：</span>--%>
<%--                        <span class="value"><%= user.getCreateTime() %></span>--%>
<%--                    </div>--%>
<%--                    <div class="user-info-item">--%>
<%--                        <span class="label">最后登录：</span>--%>
<%--                        <span class="value">--%>
<%--                                <%= user.getLastLoginTime() != null ? user.getLastLoginTime() : "首次登录" %>--%>
<%--                            </span>--%>
<%--                    </div>--%>
<%--                </div>--%>
<%--            </div>--%>
<%--        </div>--%>
<%--    </div>--%>
<%--</div>--%>
<%--</body>--%>
<%--</html>--%>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.blog.entity.User" %>
<%
    User user = (User) session.getAttribute("user");
    if (user == null) {
        response.sendRedirect(request.getContextPath() + "/user/login");
        return;
    }
%>
<html>
<head>
    <title>个人信息 - 个人博客系统</title>
    <style>
        /* 全局布局：侧边栏+头部+主体内容的层级关系 */
        body {
            margin: 0;
            padding: 0;
            font-family: 'Microsoft YaHei', Arial, sans-serif;
            background: #f0f2f5;
        }

        /* 主体内容容器：避开侧边栏和头部的高度 */
        .main-wrapper {
            margin-left: 200px; /* 侧边栏展开时的宽度 */
            margin-top: 60px;  /* 头部导航栏的高度 */
            min-height: calc(100vh - 60px);
            padding: 20px;
            box-sizing: border-box;
        }

        /* 侧边栏折叠时，主体内容自适应 */
        .sidebar-container.collapsed ~ .main-wrapper {
            margin-left: 64px;
        }

        /* 个人信息卡片样式（和系统风格统一） */
        .profile-card {
            background: rgba(255, 255, 255, 0.8);
            backdrop-filter: blur(5px);
            border-radius: 12px;
            box-shadow: 0 4px 12px rgba(0,0,0,0.1);
            padding: 30px;
            margin-bottom: 20px;
        }

        .user-info {
            display: grid;
            grid-template-columns: 150px 1fr;
            gap: 20px;
            align-items: center;
        }

        .avatar {
            width: 120px;
            height: 120px;
            border-radius: 50%;
            object-fit: cover;
            border: 2px solid rgba(102, 188, 234, 0.8);
            box-shadow: 0 0 8px rgba(102, 188, 234, 0.3);
        }

        .info-item {
            margin-bottom: 10px;
            padding: 10px;
            background: #f8f9fa;
            border-radius: 4px;
        }

        .info-label {
            font-weight: bold;
            color: #333;
        }

        /* 数据统计卡片（和侧边栏风格统一） */
        .stats-card {
            background: rgba(255, 255, 255, 0.8);
            backdrop-filter: blur(5px);
            border-radius: 12px;
            box-shadow: 0 4px 12px rgba(0,0,0,0.1);
            padding: 24px;
        }

        .stats-card h2 {
            margin: 0 0 16px 0;
            color: rgba(102, 188, 234, 0.8);
            font-size: 18px;
            border-bottom: 2px solid #f0f0f0;
            padding-bottom: 8px;
        }

        .stats {
            display: grid;
            grid-template-columns: repeat(3, 1fr);
            gap: 16px;
            margin-top: 16px;
        }

        .stat-item {
            text-align: center;
            padding: 16px;
            background: #f0f8ff;
            border-radius: 4px;
        }

        .stat-number {
            font-size: 24px;
            font-weight: bold;
            color: rgba(102, 188, 234, 0.8);
        }

        .stat-label {
            font-size: 12px;
            color: #666;
            margin-top: 4px;
        }

        /* 个人资料卡片（和系统风格统一） */
        .profile-details {
            background: rgba(255, 255, 255, 0.8);
            backdrop-filter: blur(5px);
            border-radius: 12px;
            box-shadow: 0 4px 12px rgba(0,0,0,0.1);
            padding: 24px;
        }

        .profile-details h2 {
            margin: 0 0 16px 0;
            color: rgba(102, 188, 234, 0.8);
            font-size: 18px;
            border-bottom: 2px solid #f0f0f0;
            padding-bottom: 8px;
        }

        .user-info-item {
            display: flex;
            justify-content: space-between;
            padding: 8px 0;
            border-bottom: 1px solid #f0f0f0;
        }

        .user-info-item:last-child {
            border-bottom: none;
        }

        /* 响应式适配 */
        @media (max-width: 768px) {
            .main-wrapper {
                margin-left: 0;
                margin-top: 60px;
            }
            .user-info {
                grid-template-columns: 1fr;
                text-align: center;
            }
            .stats {
                grid-template-columns: 1fr;
            }
        }
    </style>
</head>
<body>
<%-- 引入头部导航（head.jsp） --%>
<jsp:include page="head.jsp"/>

<%-- 引入侧边栏（sidebar.jsp） --%>
<jsp:include page="sidebar.jsp"/>

<%-- 主体内容容器：避开侧边栏和头部的高度 --%>
<div class="main-wrapper">
    <div class="profile-card">
        <h2>个人中心</h2>
        <div class="user-info">
            <div>
                <img src="<%= user.getAvatar() != null ? user.getAvatar() : "images/default-avatar.jpg" %>"
                     alt="头像" class="avatar">
            </div>
            <div>
                <div class="info-item">
                    <span class="info-label">用户名：</span>
                    <%= user.getUsername() %>
                </div>
                <div class="info-item">
                    <span class="info-label">手机号：</span>
                    <%= user.getPhonenumber() %>
                </div>
                <div class="info-item">
                    <span class="info-label">注册时间：</span>
                    <%= user.getCreateTime() %>
                </div>
            </div>
        </div>
    </div>

    <div class="stats-card">
        <h2>数据统计</h2>
        <div class="stats">
            <div class="stat-item">
                <div class="stat-number">0</div>
                <div class="stat-label">文章数</div>
            </div>
            <div class="stat-item">
                <div class="stat-number">0</div>
                <div class="stat-label">评论数</div>
            </div>
            <div class="stat-item">
                <div class="stat-number">0</div>
                <div class="stat-label">收藏数</div>
            </div>
        </div>
    </div>

    <div class="profile-details">
        <h2>个人资料</h2>
        <div class="user-info">
            <div class="user-info-item">
                <span class="label">用户名：</span>
                <span class="value"><%= user.getUsername() %></span>
            </div>
            <div class="user-info-item">
                <span class="label">手机号：</span>
                <span class="value"><%= user.getPhonenumber() %></span>
            </div>
            <div class="user-info-item">
                <span class="label">注册时间：</span>
                <span class="value"><%= user.getCreateTime() %></span>
            </div>
            <div class="user-info-item">
                <span class="label">最后登录：</span>
                <span class="value">
                    <%= user.getLastLoginTime() != null ? user.getLastLoginTime() : "首次登录" %>
                </span>
            </div>
        </div>
    </div>
</div>
</body>
</html>