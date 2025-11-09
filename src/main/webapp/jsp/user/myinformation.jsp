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
        /* 全局布局：主体内容避开侧边栏和头部 */
        .main-wrapper {
            margin-left: 200px; /* 侧边栏展开宽度 */
            margin-top: 60px;  /* 头部导航栏高度 */
            min-height: calc(100vh - 60px);
            padding: 20px;
            box-sizing: border-box;
            background: #f0f2f5;
        }

        /* 侧边栏折叠时，主体内容自适应 */
        .sidebar-container.collapsed ~ .main-wrapper {
            margin-left: 64px;
        }

        .info-container {
            background: rgba(255, 255, 255, 0.8);
            backdrop-filter: blur(5px);
            border-radius: 12px;
            padding: 30px;
            box-shadow: 0 4px 12px rgba(0,0,0,0.1);
            margin-bottom: 20px;
        }

        .form-group {
            margin-bottom: 25px;
        }

        .form-label {
            display: block;
            margin-bottom: 8px;
            font-weight: 600;
            color: #333;
            font-size: 14px;
        }

        .form-input {
            width: 100%;
            padding: 10px;
            border: 1px solid #ddd;
            border-radius: 6px;
            font-size: 14px;
            transition: border-color 0.3s ease;
            box-sizing: border-box;
        }

        .form-input:focus {
            outline: none;
            border-color: rgba(102, 188, 234, 0.8);
            box-shadow: 0 0 0 2px rgba(102, 188, 234, 0.2);
        }

        .form-textarea {
            width: 100%;
            padding: 10px;
            border: 1px solid #ddd;
            border-radius: 6px;
            font-size: 14px;
            resize: vertical;
            min-height: 80px;
            transition: border-color 0.3s ease;
            box-sizing: border-box;
        }

        .form-textarea:focus {
            outline: none;
            border-color: rgba(102, 188, 234, 0.8);
            box-shadow: 0 0 0 2px rgba(102, 188, 234, 0.2);
        }

        .avatar-section {
            display: flex;
            align-items: center;
            gap: 20px;
            margin-bottom: 25px;
        }

        .avatar-preview {
            width: 100px;
            height: 100px;
            border-radius: 50%;
            object-fit: cover;
            border: 3px solid rgba(102, 188, 234, 0.8);
            box-shadow: 0 2px 8px rgba(102, 188, 234, 0.2);
        }

        .avatar-upload-btn {
            padding: 8px 20px;
            background: linear-gradient(135deg, rgba(102, 188, 234, 0.76) 0%, rgba(126, 197, 228, 0.66) 100%);
            color: white;
            border: none;
            border-radius: 6px;
            cursor: pointer;
            font-size: 14px;
            transition: all 0.3s;
        }

        .avatar-upload-btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 8px rgba(102, 188, 234, 0.3);
        }

        #avatarFile {
            display: none;
        }

        .btn-submit {
            padding: 12px 30px;
            background: linear-gradient(135deg, rgba(102, 188, 234, 0.76) 0%, rgba(126, 197, 228, 0.66) 100%);
            color: white;
            border: none;
            border-radius: 6px;
            cursor: pointer;
            font-size: 16px;
            font-weight: 600;
            transition: all 0.3s;
        }

        .btn-submit:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 8px rgba(102, 188, 234, 0.3);
        }

        .btn-submit:disabled {
            background: #ccc;
            cursor: not-allowed;
            transform: none;
        }

        .error-message {
            color: #ff4d4f;
            font-size: 12px;
            margin-top: 5px;
            display: none;
        }

        .success-message {
            color: #52c41a;
            font-size: 14px;
            margin-top: 10px;
            padding: 10px;
            background: #f6ffed;
            border-radius: 4px;
            display: none;
        }
    </style>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
</head>
<body>
<jsp:include page="/jsp/user/head.jsp"/>
<jsp:include page="/jsp/user/sidebar.jsp"/>

<div class="main-wrapper">
    <div class="content-header">
        <h1 class="content-title">${pageTitle}</h1>
    </div>
    <div class="content-body">
        <div class="info-container">
            <form id="userInfoForm" action="${pageContext.request.contextPath}/user/update-info" method="post" enctype="multipart/form-data">
                <!-- 头像上传 -->
                <div class="form-group">
                    <div class="form-label">头像</div>
                    <div class="avatar-section">
                        <img src="${pageContext.request.contextPath}/${not empty user.avatar ? user.avatar : 'images/avatar/default-avatar.jpg'}" 
                             alt="头像" class="avatar-preview" id="avatarPreview">
                        <div>
                            <label for="avatarFile" class="avatar-upload-btn">
                                <i class="fas fa-upload"></i> 选择头像
                            </label>
                            <input type="file" id="avatarFile" name="avatarFile" accept="image/*">
                        </div>
                    </div>
                </div>

                <!-- 用户名 -->
                <div class="form-group">
                    <label class="form-label">用户名</label>
                    <input type="text" name="username" class="form-input" 
                           value="${user.username}" required maxlength="20">
                    <div class="error-message" id="usernameError"></div>
                </div>

                <!-- 手机号 -->
                <div class="form-group">
                    <label class="form-label">手机号</label>
                    <input type="text" name="phonenumber" class="form-input" 
                           value="${user.phonenumber}" maxlength="11">
                    <div class="error-message" id="phonenumberError"></div>
                </div>

                <!-- 性别 -->
                <div class="form-group">
                    <label class="form-label">性别</label>
                    <select name="gender" class="form-input">
                        <option value="0" ${user.gender == 0 ? 'selected' : ''}>保密</option>
                        <option value="1" ${user.gender == 1 ? 'selected' : ''}>男</option>
                        <option value="2" ${user.gender == 2 ? 'selected' : ''}>女</option>
                    </select>
                </div>

                <!-- 个性签名 -->
                <div class="form-group">
                    <label class="form-label">个性签名</label>
                    <textarea name="signature" class="form-textarea" 
                              maxlength="100" placeholder="请输入个性签名">${user.signature}</textarea>
                </div>

                <!-- 提交按钮 -->
                <div class="form-group">
                    <button type="submit" class="btn-submit" id="submitBtn">
                        <i class="fas fa-save"></i> 保存修改
                    </button>
                </div>

                <!-- 成功消息 -->
                <div class="success-message" id="successMessage"></div>
            </form>
        </div>
    </div>
</div>

<script>
    // 头像预览
    document.getElementById('avatarFile').addEventListener('change', function(e) {
        const file = e.target.files[0];
        if (file) {
            const reader = new FileReader();
            reader.onload = function(e) {
                document.getElementById('avatarPreview').src = e.target.result;
            };
            reader.readAsDataURL(file);
        }
    });

    // 表单提交
    document.getElementById('userInfoForm').addEventListener('submit', function(e) {
        e.preventDefault();
        
        const submitBtn = document.getElementById('submitBtn');
        const formData = new FormData(this);
        
        // 禁用提交按钮
        submitBtn.disabled = true;
        submitBtn.innerHTML = '<i class="fas fa-spinner fa-spin"></i> 保存中...';
        
        // 隐藏错误和成功消息
        document.querySelectorAll('.error-message').forEach(el => {
            el.style.display = 'none';
        });
        document.getElementById('successMessage').style.display = 'none';
        
        fetch('${pageContext.request.contextPath}/user/update-info', {
            method: 'POST',
            body: formData
        })
        .then(response => response.json())
        .then(data => {
            if (data.success) {
                document.getElementById('successMessage').textContent = data.message || '修改成功！';
                document.getElementById('successMessage').style.display = 'block';
                
                // 更新头像预览
                if (data.avatarPath) {
                    document.getElementById('avatarPreview').src = '${pageContext.request.contextPath}/' + data.avatarPath;
                }
                
                // 3秒后刷新页面以更新session中的用户信息
                setTimeout(() => {
                    window.location.reload();
                }, 1500);
            } else {
                // 显示错误消息
                if (data.field && data.message) {
                    const errorEl = document.getElementById(data.field + 'Error');
                    if (errorEl) {
                        errorEl.textContent = data.message;
                        errorEl.style.display = 'block';
                    }
                } else {
                    alert(data.message || '修改失败，请重试');
                }
                submitBtn.disabled = false;
                submitBtn.innerHTML = '<i class="fas fa-save"></i> 保存修改';
            }
        })
        .catch(error => {
            console.error('Error:', error);
            alert('网络错误，请重试');
            submitBtn.disabled = false;
            submitBtn.innerHTML = '<i class="fas fa-save"></i> 保存修改';
        });
    });
</script>
</body>
</html>
