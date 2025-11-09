<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page isELIgnored="false" %>
<%@ page import="com.blog.entity.User" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%
    // 检查用户是否登录
    User user = (User) session.getAttribute("user");
    if (user == null) {
        response.sendRedirect(request.getContextPath() + "/user/login");
        return;
    }
    String contextPath = request.getContextPath();
%>
<html>
<head>
    <title>个人主页 - 个人博客系统</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body {
            font-family: 'Microsoft YaHei', Arial, sans-serif;
            background: #f0f2f5;
            color: #333;
            line-height: 1.6;
        }

        /* 搜索框样式 - 适配玻璃感风格 */
        .search-container {
            background: rgba(255,255,255,0.8); /* 半透明白色背景 */
            backdrop-filter: blur(8px); /* 玻璃模糊效果 */
            padding: 18px 0;
            box-shadow: 0 2px 8px rgba(0,0,0,0.1);
            margin-bottom: 30px;
        }
        .search-box {
            max-width: 800px;
            margin: 0 auto;
            display: flex;
            gap: 10px;
        }
        .search-input {
            flex: 1;
            padding: 8px 25px;;
            border: 1px solid rgba(200,200,200,0.5); /* 浅灰色边框 */
            border-radius: 20px; /* 圆形输入框 */
            font-size: 16px;
            outline: none;
            transition: all 0.3s ease;
            background: rgba(255,255,255,0.5); /* 输入框半透明 */
        }
        .search-input:focus {
            border-color: #66d6ea; /* 头部主色调 */
            box-shadow: 0 0 0 2px rgba(102, 214, 234, 0.2);
        }
        .search-btn {
            padding: 8px 25px;;
            background: linear-gradient(135deg, #66d6ea 0%, #bbd8e1 100%); /* 头部渐变背景 */
            color: white;
            border: none;
            border-radius: 20px; /* 圆形按钮 */
            font-size: 16px;
            cursor: pointer;
            transition: all 0.3s ease;
        }
        .search-btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 8px rgba(102, 214, 234, 0.3);
        }

        /* 轮播器样式 - 适配玻璃感（补充缺失样式） */
        .carousel-container {
            max-width: 1200px;
            margin: 0 auto 30px;
            position: relative; /* 父容器相对定位，子元素绝对定位 */
            height: 400px;
            overflow: hidden;
            border-radius: 12px;
            box-shadow: 0 8px 20px rgba(0,0,0,0.15);
        }

        /* 关键：所有轮播图默认隐藏并叠加 */
        .carousel-slide {
            position: absolute; /* 绝对定位，让所有图叠在一起 */
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            opacity: 0; /* 默认隐藏 */
            transition: opacity 0.5s ease; /* 平滑切换动画 */
        }

        /* 只有 active 的轮播图才显示 */
        .carousel-slide.active {
            opacity: 1;
        }

        .carousel-slide img {
            width: 100%;
            height: 100%;
            object-fit: cover;
            filter: brightness(0.85);
        }

        .carousel-dots {
            position: absolute;
            bottom: 20px;
            left: 50%;
            transform: translateX(-50%);
            display: flex;
            gap: 10px;
            z-index: 10; /* 确保指示器在轮播图上方 */
        }

        .carousel-dot {
            width: 12px;
            height: 12px;
            border-radius: 50%;
            background: rgba(255,255,255,0.5);
            cursor: pointer;
            transition: all 0.3s ease;
        }

        .carousel-dot.active {
            background: white;
            width: 30px;
            border-radius: 6px;
        }

        /* 热门文章样式 - 适配玻璃感卡片 */
        .hot-articles {
            max-width: 1200px;
            margin: 0 auto 50px;
        }
        .section-title {
            font-size: 24px;
            color: #333;
            margin-bottom: 20px;
            padding-bottom: 10px;
            border-bottom: 2px solid #66d6ea; /* 头部主色调下划线 */
            display: inline-block;
        }
        .articles-list {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(280px, 1fr));
            gap: 20px;
        }
        .article-card {
            background: rgba(255,255,255,0.8); /* 半透明白色卡片 */
            backdrop-filter: blur(5px); /* 轻微模糊 */
            border-radius: 12px; /* 大圆角 */
            overflow: hidden;
            box-shadow: 0 4px 12px rgba(0,0,0,0.1);
            transition: all 0.3s ease;
            border: 1px solid rgba(200,200,200,0.3);
        }
        .article-card:hover {
            transform: translateY(-8px);
            box-shadow: 0 8px 16px rgba(102, 214, 234, 0.2);
        }
        .article-content {
            padding: 20px;
        }
        .article-title {
            font-size: 18px;
            margin-bottom: 10px;
            color: #333;
            text-decoration: none;
            display: block;
            transition: color 0.3s;
        }
        .article-title:hover {
            color: #66d6ea; /* 头部主色调 hover */
        }
        .article-summary {
            color: #666;
            font-size: 14px;
            margin-bottom: 15px;
            display: -webkit-box;
            -webkit-line-clamp: 3;
            -webkit-box-orient: vertical;
            overflow: hidden;
        }
        .article-meta {
            display: flex;
            justify-content: space-between;
            font-size: 12px;
            color: #666;
        }
        .meta-item {
            display: flex;
            align-items: center;
            gap: 5px;
        }
        .meta-item i {
            font-size: 14px;
            color: #66d6ea; /* 图标主色调 */
        }

        /* 无数据样式 */
        .empty-article {
            grid-column: 1/-1;
            text-align: center;
            padding: 50px;
            color: #999;
            background: rgba(255,255,255,0.8);
            border-radius: 12px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.1);
        }

        /* 响应式适配 */
        @media (max-width: 768px) {
            .carousel-container {
                height: 250px;
            }
            .search-box {
                padding: 0 20px;
            }
            .articles-list {
                padding: 0 20px;
            }
        }
    </style>
    <!-- Font Awesome 图标库 -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
</head>
<body>
<jsp:include page="head.jsp"/>

<!-- 搜索框区域 -->
<div class="search-container">
    <form class="search-box" action="${pageContext.request.contextPath}/search" method="get">
        <input type="text" name="keyword" class="search-input"
               placeholder="搜索文章标题、标签、用户..." value="${param.keyword}">
        <button type="submit" class="search-btn">
            <i class="fas fa-search"></i> 搜索
        </button>
    </form>
</div>

<!-- 轮播器区域 -->
<div class="carousel-container">
    <div class="carousel-slide active">
        <img src="${pageContext.request.contextPath}/images/icon/banner1.jpg" alt="轮播图1">
    </div>
    <div class="carousel-slide">
        <img src="${pageContext.request.contextPath}/images/icon/banner2.jpg" alt="轮播图2">
    </div>
    <div class="carousel-slide">
        <img src="${pageContext.request.contextPath}/images/icon/banner3.jpg" alt="轮播图3">
    </div>
    <!-- 轮播指示器 -->
    <div class="carousel-dots">
        <div class="carousel-dot active" data-index="0"></div>
        <div class="carousel-dot" data-index="1"></div>
        <div class="carousel-dot" data-index="2"></div>
    </div>
</div>
<!-- 热门文章区域（点赞最多的4篇） -->
<div class="hot-articles">
    <h2 class="section-title">热门推荐</h2>
    <div class="articles-list">
        <c:choose>
            <c:when test="${not empty hotArticles}">
                <c:forEach items="${hotArticles}" var="article">
                    <div class="article-card">
                        <div class="article-content">
                            <a href=${pageContext.request.contextPath}/article/detail?id=${article.id} class="article-title">
                                    ${article.title}
                            </a>
                            <p class="article-summary">${article.summary}</p>
                            <div class="article-meta">
                                <div class="meta-item">
                                    <i class="fas fa-thumbs-up" style="color: #ff4d4f;"></i>
                                    <span>${article.likes} 点赞</span>
                                </div>
                                <div class="meta-item">
                                    <i class="fas fa-eye" style="color: #1890ff;"></i>
                                    <span>${article.hits} 浏览</span>
                                </div>
                                <div class="meta-item">
                                    <i class="fas fa-user" style="color: #52c41a;"></i>
                                    <span>${article.author.username}</span>
                                </div>
                            </div>
                        </div>
                    </div>
                </c:forEach>
            </c:when>
            <c:otherwise>
                <div class="empty-article">
                    <i class="fas fa-file-alt" style="font-size: 48px; margin-bottom: 20px;"></i>
                    <p>暂无热门文章</p>
                </div>
            </c:otherwise>
        </c:choose>
    </div>
</div>

<!-- 轮播器脚本 -->
<script>
    // 轮播自动切换
    const slides = document.querySelectorAll('.carousel-slide');
    const dots = document.querySelectorAll('.carousel-dot');
    let currentIndex = 0;
    const slideInterval = 5000; // 5秒切换一次

    // 切换轮播图
    function showSlide(index) {
        slides.forEach(slide => slide.classList.remove('active'));
        dots.forEach(dot => dot.classList.remove('active'));
        slides[index].classList.add('active');
        dots[index].classList.add('active');
        currentIndex = index;
    }

    // 自动切换
    setInterval(() => {
        let nextIndex = (currentIndex + 1) % slides.length;
        showSlide(nextIndex);
    }, slideInterval);

    // 点击指示器切换
    dots.forEach(dot => {
        dot.addEventListener('click', () => {
            const index = parseInt(dot.getAttribute('data-index'));
            showSlide(index);
        });
    });
</script>
</body>
</html>