package com.blog.controller.user;

import com.blog.dao.UserDAO;
import com.blog.entity.User;
import com.blog.util.UploadUtils;

import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import javax.servlet.http.Part;
import java.io.File;
import java.io.IOException;
import java.io.PrintWriter;

@MultipartConfig(
        fileSizeThreshold = 1024 * 1024 * 2, // 2MB阈值
        maxFileSize = 1024 * 1024 * 5,      // 单个文件最大5MB
        maxRequestSize = 1024 * 1024 * 10    // 总请求最大10MB
)
@WebServlet("/user/update-info")
public class UpdateUserInfoServlet extends HttpServlet {
    private UserDAO userDAO = new UserDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("application/json;charset=UTF-8");
        PrintWriter out = response.getWriter();

        HttpSession session = request.getSession();
        User currentUser = (User) session.getAttribute("user");
        
        if (currentUser == null) {
            out.println("{\"success\": false, \"message\": \"请先登录\"}");
            return;
        }

        try {
            String username = request.getParameter("username");
            String phonenumber = request.getParameter("phonenumber");
            String genderStr = request.getParameter("gender");
            String signature = request.getParameter("signature");

            // 验证用户名
            if (username == null || username.trim().isEmpty()) {
                out.println("{\"success\": false, \"field\": \"username\", \"message\": \"用户名不能为空\"}");
                return;
            }
            username = username.trim();
            if (username.length() > 20) {
                out.println("{\"success\": false, \"field\": \"username\", \"message\": \"用户名不能超过20个字符\"}");
                return;
            }

            // 检查用户名是否已被其他用户使用
            User existingUser = userDAO.getUserByUsername(username);
            if (existingUser != null && existingUser.getId() != currentUser.getId()) {
                out.println("{\"success\": false, \"field\": \"username\", \"message\": \"用户名已被使用\"}");
                return;
            }

            // 处理头像上传
            String avatarPath = currentUser.getAvatar();
            Part avatarPart = request.getPart("avatarFile");
            if (avatarPart != null && avatarPart.getSize() > 0) {
                try {
                    String originalFileName = avatarPart.getSubmittedFileName();
                    String uniqueFileName = UploadUtils.generateUniqueFileName(originalFileName);
                    
                    String saveDir = request.getServletContext().getRealPath("/images/avatar/");
                    File dir = new File(saveDir);
                    if (!dir.exists()) {
                        dir.mkdirs();
                    }
                    String savePath = saveDir + File.separator + uniqueFileName;
                    avatarPart.write(savePath);
                    
                    avatarPath = "/images/avatar/" + uniqueFileName;
                } catch (RuntimeException e) {
                    out.println("{\"success\": false, \"message\": \"" + e.getMessage() + "\"}");
                    return;
                }
            }

            // 更新用户信息
            User user = new User();
            user.setId(currentUser.getId());
            user.setUsername(username);
            user.setPhonenumber(phonenumber != null ? phonenumber.trim() : null);
            user.setGender(genderStr != null ? Integer.parseInt(genderStr) : 0);
            user.setSignature(signature != null ? signature.trim() : null);
            user.setAvatar(avatarPath);
            user.setLastLoginTime(currentUser.getLastLoginTime());

            int result = userDAO.updateUser(user);

            if (result > 0) {
                // 更新session中的用户信息
                User updatedUser = userDAO.getUserById(currentUser.getId());
                session.setAttribute("user", updatedUser);
                
                out.println("{\"success\": true, \"message\": \"修改成功\", \"avatarPath\": \"" + avatarPath + "\"}");
            } else {
                out.println("{\"success\": false, \"message\": \"修改失败，请重试\"}");
            }

        } catch (Exception e) {
            e.printStackTrace();
            out.println("{\"success\": false, \"message\": \"系统错误: " + e.getMessage() + "\"}");
        } finally {
            out.close();
        }
    }
}

