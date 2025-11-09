<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page isELIgnored="false" %>
<c:if test="${empty sessionScope.user}">
    <c:redirect url="${pageContext.request.contextPath}/jsp/user/login.jsp"/>
</c:if>
<!DOCTYPE html>
<html>
<head>
    <title>侧边栏</title>
    <style>
        .sidebar-container {
            z-index: 1000; /* 低于头部的1001，确保头部在上方 */
        }
        /* 侧边栏容器（毛玻璃效果+统一主色调） */
        .sidebar-container {
            position: fixed;
            left: 0;
            top: 0;
            height: 100vh;
            /* 毛玻璃核心样式：半透明背景+模糊 */
            background: rgba(255, 255, 255, 0.85);
            backdrop-filter: blur(10px);
            -webkit-backdrop-filter: blur(10px); /* 兼容Safari */
            color: #333; /* 文字主色改为深色，适配浅色背景 */
            z-index: 1000;
            transition: width 0.3s ease;
            box-shadow: 2px 0 12px rgba(102, 188, 234, 0.15); /* 统一主色调阴影 */
            border-right: 1px solid rgba(102, 188, 234, 0.2); /* 统一主色调细边框 */
        }

        .sidebar-container.collapsed {
            width: 64px;
        }

        .sidebar-container.expanded {
            width: 200px;
        }

        /* 折叠按钮（统一主色调适配） */
        .collapse-toggle {
            height: 56px;
            display: flex;
            align-items: center;
            justify-content: center;
            border-bottom: 1px solid rgba(102, 188, 234, 0.2); /* 统一主色调边框 */
            cursor: pointer;
            transition: all 0.3s;
            background: #66BCEAEA;
        }

        .collapse-toggle:hover {
            background: rgba(102, 188, 234, 0.1); /*  hover 加深 */
        }

        .collapse-icon {
            font-size: 18px;
            color: rgba(102, 188, 234, 0.66); /* 统一主色调图标 */
            transition: transform 0.3s;
        }

        .sidebar-container.collapsed .collapse-icon {
            transform: rotate(180deg);
        }

        .collapse-text {
            color: rgba(102, 188, 234, 0.76);
            display: none; /* 新增：隐藏文字 */
        }

        /* 用户信息区域（适配浅色毛玻璃+统一主色调） */
        .user-info {
            padding: 20px;
            border-bottom: 1px solid rgba(102, 188, 234, 0.2);
            text-align: center;
            transition: all 0.3s;
            overflow: hidden;
        }

        .sidebar-container.collapsed .user-info {
            padding: 10px;
        }

        .user-avatar {
            width: 40px;
            height: 40px;
            border-radius: 50%;
            object-fit: cover;
            margin-bottom: 10px;
            border: 2px solid rgba(102, 188, 234, 0.8); /* 统一主色调边框 */
            box-shadow: 0 0 8px rgba(102, 188, 234, 0.3); /* 统一主色调阴影 */
        }

        .sidebar-container.collapsed .user-avatar {
            margin-bottom: 0;
        }

        /* 默认头像背景色统一 */
        .user-avatar[style*="background"] {
            background: rgba(102, 188, 234, 0.8) !important;
        }

        .user-name {
            font-size: 14px;
            font-weight: 600;
            color: #333; /* 文字深色 */
            margin-bottom: 5px;
            white-space: nowrap;
            overflow: hidden;
            text-overflow: ellipsis;
        }

        .sidebar-container.collapsed .user-name {
            display: none;
        }

        /* 菜单样式（统一主色调核心适配） */
        .sidebar-menu {
            height: calc(100vh - 120px);
            overflow-y: auto;
            padding: 10px 0;
        }

        .menu-item {
            display: flex;
            align-items: center;
            height: 56px;
            padding: 0 20px;
            color: #666; /* 菜单文字默认色 */
            text-decoration: none;
            transition: all 0.3s;
            border-left: 3px solid transparent;
            position: relative;
        }

        .sidebar-container.collapsed .menu-item {
            padding: 0 16px;
            justify-content: center;
        }

        .menu-item:hover {
            background: rgba(102, 188, 234, 0.1); /*  hover 主色背景 */
            color: rgba(102, 188, 234, 0.8); /*  hover 文字主色 */
        }

        .menu-item.active {
            background: rgba(102, 188, 234, 0.15); /* 激活主色背景 */
            border-left-color: rgba(102, 188, 234, 0.8); /* 激活主色边框 */
            color: rgba(102, 188, 234, 0.8); /* 激活文字主色 */
        }

        .menu-icon {
            font-size: 16px;
            margin-right: 16px;
            width: 20px;
            text-align: center;
            color: rgba(102, 188, 234, 0.8); /* 图标统一主色调 */
        }

        .sidebar-container.collapsed .menu-icon {
            margin-right: 0;
        }

        .menu-text {
            font-size: 14px;
            white-space: nowrap;
            overflow: hidden;
            text-overflow: ellipsis;
        }

        .sidebar-container.collapsed .menu-text {
            display: none;
        }

        /* 徽章样式（统一主色调适配） */
        .menu-badge {
            background: linear-gradient(135deg, rgba(102, 188, 234, 0.76) 0%, rgba(126, 197, 228, 0.66) 100%); /* 统一主色渐变 */
            color: white;
            padding: 2px 6px;
            border-radius: 10px;
            font-size: 12px;
            margin-left: auto;
            min-width: 20px;
            text-align: center;
            box-shadow: 0 2px 4px rgba(102, 188, 234, 0.2);
        }

        .sidebar-container.collapsed .menu-badge {
            position: absolute;
            top: 8px;
            right: 8px;
            margin-left: 0;
            font-size: 10px;
            padding: 1px 4px;
        }

        /* 子菜单样式（适配毛玻璃+统一主色调） */
        .submenu {
            background: rgba(102, 188, 234, 0.05); /* 子菜单主色背景 */
        }

        .submenu-item {
            height: 40px;
            padding-left: 50px;
            display: flex;
            align-items: center;
            font-size: 13px;
            color: #66d; /* 子菜单文字色 */
            text-decoration: none;
            transition: all 0.3s;
        }


        .sidebar-container.collapsed .submenu {
            display: none;
        }

        /* 主内容区域适配（保持原有逻辑） */
        .main-content {
            margin-left: 200px;
            transition: margin-left 0.3s ease;
            min-height: 100vh;
            background: #f0f2f5;
        }

        .sidebar-container.collapsed ~ .main-content {
            margin-left: 64px;
        }

        /* 移动端适配（优化统一主色调按钮） */
        @media (max-width: 768px) {
            .sidebar-container {
                transform: translateX(-100%);
            }

            .sidebar-container.mobile-open {
                transform: translateX(0);
            }

            .main-content {
                margin-left: 0 !important;
            }

            .mobile-toggle {
                position: fixed;
                top: 15px;
                left: 15px;
                z-index: 1001;
                background: linear-gradient(135deg, rgba(102, 188, 234, 0.76) 0%, rgba(126, 197, 228, 0.66) 100%); /* 统一主色渐变按钮 */
                color: white;
                border: none;
                padding: 8px;
                border-radius: 8px; /* 大圆角适配玻璃感 */
                cursor: pointer;
                display: block;
                box-shadow: 0 4px 8px rgba(102, 188, 234, 0.3);
            }
        }

        @media (min-width: 769px) {
            .mobile-toggle {
                display: none;
            }
        }

        /* 滚动条样式（统一主色调适配） */
        .sidebar-menu::-webkit-scrollbar {
            width: 4px;
        }

        .sidebar-menu::-webkit-scrollbar-track {
            background: rgba(102, 188, 234, 0.05); /* 主色轨道 */
        }

        .sidebar-menu::-webkit-scrollbar-thumb {
            background: rgba(102, 188, 234, 0.6); /* 统一主色滚动条 */
            border-radius: 2px;
        }

        .sidebar-menu::-webkit-scrollbar-thumb:hover {
            background: rgba(102, 188, 234, 0.8); /* 滚动条 hover 加深 */
        }

        /* 动画效果（统一主色调优化） */
        .menu-item::before {
            content: '';
            position: absolute;
            top: 0;
            left: -100%;
            width: 100%;
            height: 100%;
            background: linear-gradient(90deg, transparent, rgba(102, 188, 234, 0.1), transparent); /* 统一主色渐变动画 */
            transition: left 0.5s;
        }

        .menu-item:hover::before {
            left: 100%;
        }

        /* 分隔线（统一主色调适配） */
        .sidebar-menu div[style*="background"] {
            background: rgba(102, 188, 234, 0.2) !important; /* 统一主色调分隔线 */
        }

        /* 子菜单箭头颜色统一 */
        .menu-item i[class*="chevron-down"] {
            color: rgba(102, 188, 234, 0.66) !important;
        }
    </style>
</head>
<body>
<!-- 移动端切换按钮 -->
<button class="mobile-toggle" onclick="toggleMobileSidebar()">
    <i class="fas fa-bars"></i>
</button>

<!-- 侧边栏 -->
<div class="sidebar-container expanded" id="sidebar">
    <!-- 折叠按钮 -->
    <div class="collapse-toggle" onclick="toggleSidebar()">
        <i class="fas fa-bars collapse-icon"></i>
        <span class="collapse-text" style="margin-left: 10px; font-size: 14px;"></span>
    </div>

    <!-- 用户信息：核心修改处（删除标签内的注释） -->
    <div class="user-info">
        <c:choose>
            <c:when test="${not empty sessionScope.user.avatar}">
                <img src="${pageContext.request.contextPath}${sessionScope.user.avatar}" alt="头像" class="user-avatar">
            </c:when>
            <c:otherwise>
                <img src="${pageContext.request.contextPath}/images/avatar/default-avatar.jpg" alt="默认头像" class="user-avatar">
            </c:otherwise>
        </c:choose>
        <div class="user-name">${sessionScope.user.username}</div>
    </div>

    <!-- 菜单 -->
    <nav class="sidebar-menu">
        <!-- 我的收藏 -->
        <a href="${pageContext.request.contextPath}/article/my-collect" class="menu-item" id="menu-collect">
            <i class="fas fa-heart menu-icon"></i>
            <span class="menu-text">我的收藏</span>
            <span class="menu-badge" id="collect-count">0</span>
        </a>

        <!-- 我的文章 -->
        <a href="${pageContext.request.contextPath}/article/my-articles" class="menu-item" id="menu-articles">
            <i class="fas fa-file-alt menu-icon"></i>
            <span class="menu-text">我的文章</span>
            <span class="menu-badge" id="article-count">0</span>
        </a>

        <a href="${pageContext.request.contextPath}/article/drafts" class="menu-item" id="menu-drafts">
            <i class="fas fa-inbox menu-icon"></i>
            <span class="menu-text">草稿箱</span>
            <span class="menu-badge" id="draft-count">0</span>
        </a>

        <!-- 个人信息 -->
        <a href="${pageContext.request.contextPath}/user/my-information" class="menu-item" id="menu-info">
            <i class="fas fa-user-cog menu-icon"></i>
            <span class="menu-text">个人信息</span>
        </a>

    </nav>
</div>

<!-- 主内容区域 -->
<div class="main-content" id="mainContent">
    <!-- 页面具体内容会在这里显示 -->
</div>

<script>
    // 侧边栏折叠状态
    let isCollapsed = false;

    // 切换侧边栏折叠状态
    function toggleSidebar() {
        const sidebar = document.getElementById('sidebar');
        const mainContent = document.getElementById('mainContent');
        const collapseIcon = document.querySelector('.collapse-icon');
        const collapseText = document.querySelector('.collapse-text');

        isCollapsed = !isCollapsed;

        if (isCollapsed) {
            sidebar.classList.remove('expanded');
            sidebar.classList.add('collapsed');
            collapseText.textContent = '展开';
        } else {
            sidebar.classList.remove('collapsed');
            sidebar.classList.add('expanded');
            collapseText.textContent = '收起';
        }

        // 保存状态到本地存储
        localStorage.setItem('sidebarCollapsed', isCollapsed);
    }

    // 切换子菜单显示
    function toggleSubmenu(submenuId) {
        const submenu = document.getElementById(submenuId);
        if (submenu.style.display === 'none') {
            submenu.style.display = 'block';
        } else {
            submenu.style.display = 'none';
        }
    }

    // 移动端侧边栏切换
    function toggleMobileSidebar() {
        const sidebar = document.getElementById('sidebar');
        sidebar.classList.toggle('mobile-open');
    }

    // 页面加载时恢复折叠状态
    document.addEventListener('DOMContentLoaded', function() {
        // 从本地存储读取折叠状态
        const savedState = localStorage.getItem('sidebarCollapsed');
        if (savedState === 'true') {
            isCollapsed = true;
            const sidebar = document.getElementById('sidebar');
            const collapseText = document.querySelector('.collapse-text');

            sidebar.classList.remove('expanded');
            sidebar.classList.add('collapsed');
            collapseText.textContent = '展开';
        }

        // 高亮当前菜单项
        highlightCurrentMenu();

        // 加载用户统计数据
        loadUserStats();

        // 点击主内容区域关闭移动端侧边栏
        document.getElementById('mainContent').addEventListener('click', function() {
            if (window.innerWidth <= 768) {
                document.getElementById('sidebar').classList.remove('mobile-open');
            }
        });
    });

    // 高亮当前菜单项
    function highlightCurrentMenu() {
        const currentPath = window.location.pathname;
        const menuItems = document.querySelectorAll('.menu-item');

        menuItems.forEach(item => {
            if (item.href && currentPath.includes(item.getAttribute('href'))) {
                item.classList.add('active');
            }
        });
    }

    // 加载用户数据统计
    function loadUserStats() {
        fetch('${pageContext.request.contextPath}/user/stats')
            .then(response => response.json())
            .then(data => {
                if (data.success) {
                    document.getElementById('article-count').textContent = data.articleCount || 0;
                    document.getElementById('collect-count').textContent = data.collectCount || 0;
                    document.getElementById('draft-count').textContent = data.draftCount || 0;
                }
            })
            .catch(error => {
                console.error('加载用户统计失败:', error);
            });
    }

    // 响应式处理
    window.addEventListener('resize', function() {
        if (window.innerWidth > 768) {
            document.getElementById('sidebar').classList.remove('mobile-open');
        }
    });
</script>

<!-- 引入图标库 -->
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
</body>
</html>