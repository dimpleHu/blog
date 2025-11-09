<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String contextPath = request.getContextPath();
    // 注意：此处不再从Session获取头像，改为页面加载后通过AJAX查询
%>
<!DOCTYPE html>
<html>
<head>
    <title>上传头像</title>
    <style>
        .avatar-container { max-width: 500px; margin: 50px auto; text-align: center; }
        .avatar-preview {
            width: 150px; height: 150px; border-radius: 50%;
            object-fit: cover; border: 2px solid #66d6ea; margin-bottom: 20px;
        }
        .upload-btn {
            padding: 10px 30px; background: linear-gradient(135deg, #66d6ea 0%, #bbd8e1 100%);
            color: white; border: none; border-radius: 20px; cursor: pointer; font-size: 16px;
        }
        #fileInput { display: none; }
        #message { margin-top: 20px; color: red; }
    </style>
</head>
<body>
<div class="avatar-container">
    <h2>上传用户头像</h2>
    <!-- 预览图：初始显示默认图，加载后替换为查询到的用户头像 -->
    <img src="<%= contextPath %>/images/avatar/default.png" class="avatar-preview" id="previewImg">

    <!-- 表单：action路径不变，需确保用户已登录（可通过Cookie或后端拦截验证） -->
    <form action="<%= contextPath %>/user/avatar-upload" method="post" enctype="multipart/form-data">
        <label for="fileInput" class="upload-btn">选择图片</label>
        <input type="file" id="fileInput" name="avatarFile" accept="image/*"> <!-- 仅允许图片 -->
        <br><br>
        <button type="submit" class="upload-btn">确认上传</button>
    </form>

    <div id="message"></div>
</div>

<script>
    // 1. 页面加载时，查询当前用户头像（核心：无Session，通过接口获取）
    window.onload = function() {
        // 假设用户登录状态通过Cookie存储（如"userId=1"），此处从Cookie获取用户ID
        const userId = getCookie("userId"); // 自定义方法：从Cookie提取userId

        if (!userId) {
            // 未登录：提示并跳转登录页
            document.getElementById("message").textContent = "请先登录！";
            setTimeout(() => {
                window.location.href = "<%= contextPath %>/jsp/login.jsp";
            }, 1500);
            return;
        }

        // 2. AJAX请求后端接口，查询当前用户头像
        fetch("<%= contextPath %>/user/get-avatar?userId=" + userId)
            .then(response => response.json())
            .then(data => {
                if (data.success && data.avatarPath) {
                    // 有头像：渲染用户头像
                    document.getElementById("previewImg").src = "<%= contextPath %>/" + data.avatarPath;
                } else {
                    // 无头像：保持默认图
                    document.getElementById("previewImg").src = "<%= contextPath %>/images/avatar/default.png";
                }
            })
            .catch(error => {
                console.error("查询头像失败：", error);
                document.getElementById("message").textContent = "查询头像失败，请刷新重试！";
            });
    };

    // 3. 图片预览功能（无修改）
    function previewAvatar(fileInput) {
        const file = fileInput.files[0];
        if (file) {
            const reader = new FileReader();
            reader.onload = e => document.getElementById("previewImg").src = e.target.result;
            reader.readAsDataURL(file);
        }
    }
    // 绑定预览事件
    document.getElementById("fileInput").addEventListener("change", previewAvatar);

    // 4. 辅助方法：从Cookie中提取指定名称的值（如userId）
    function getCookie(name) {
        const cookieArr = document.cookie.split("; ");
        for (let i = 0; i < cookieArr.length; i++) {
            const [cookieName, cookieValue] = cookieArr[i].split("=");
            if (cookieName === name) {
                return decodeURIComponent(cookieValue); // 解码特殊字符
            }
        }
        return null; // 未找到对应Cookie
    }
</script>
</body>
</html>