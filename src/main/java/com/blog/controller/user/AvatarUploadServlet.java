package com.blog.controller.user;

import com.blog.dao.UserDAO;
import com.blog.util.UploadUtils;
import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.Part;
import java.io.File;
import java.io.IOException;
import java.io.PrintWriter;

// 保留文件大小限制配置（5MB单文件，10MB总请求）
@MultipartConfig(
        fileSizeThreshold = 1024 * 1024 * 2, // 2MB阈值（内存/临时文件切换）
        maxFileSize = 1024 * 1024 * 5,      // 单个头像最大5MB
        maxRequestSize = 1024 * 1024 * 10    // 总请求最大10MB
)
@WebServlet("/user/avatar-upload") // 接口路径不变
public class AvatarUploadServlet extends HttpServlet {
    private UserDAO userDAO = new UserDAO();

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        resp.setContentType("text/html;charset=UTF-8");
        PrintWriter out = resp.getWriter();
        Integer userId = (Integer) req.getSession().getAttribute("userId");

        // 1. 校验登录状态（无修改）
        if (userId == null) {
            out.write("<script>alert('请先登录！');location.href='"+req.getContextPath()+"/jsp/login.jsp';</script>");
            return;
        }

        // 2. 获取上传文件（name属性与前端一致：avatarFile）
        Part avatarPart = req.getPart("avatarFile");
        if (avatarPart.getSize() == 0) { // 未选择文件
            out.write("<script>alert('请选择头像文件！');history.back();</script>");
            return;
        }

        try {
            // 3. 生成唯一文件名（工具类逻辑不变）
            String originalFileName = avatarPart.getSubmittedFileName();
            String uniqueFileName = UploadUtils.generateUniqueFileName(originalFileName);

            // 4. 核心修改：保存路径改为webapp/images/avatar
            String saveDir = req.getServletContext().getRealPath("/images/avatar/");
            File dir = new File(saveDir);
            if (!dir.exists()) {
                dir.mkdirs(); // 自动创建images/avatar目录（若不存在）
            }
            String savePath = saveDir + File.separator + uniqueFileName; // 完整物理路径

            // 5. 保存文件到目标路径（PPT中Part接口核心方法）
            avatarPart.write(savePath);

            // 6. 数据库存储路径修改：/images/avatar/唯一文件名（统一使用前导斜杠）
            String avatarRelativePath = "/images/avatar/" + uniqueFileName;
            int result = userDAO.updateAvatar(userId, avatarRelativePath);

            if (result > 0) {
                // 7. 更新Session头像路径（确保前端实时加载新路径）
                req.getSession().setAttribute("avatar", avatarRelativePath);
                out.write("<script>alert('头像上传成功！');location.href='"+req.getContextPath()+"/jsp/user/profile.jsp';</script>");
            } else {
                // 数据库失败时删除已上传文件（避免垃圾文件）
                new File(savePath).delete();
                out.write("<script>alert('头像更新失败！');history.back();</script>");
            }
        } catch (RuntimeException e) {
            // 格式校验失败（如非图片文件）
            out.write("<script>alert('"+e.getMessage()+"');history.back();</script>");
        } catch (Exception e) {
            e.printStackTrace();
            out.write("<script>alert('上传失败：" + e.getMessage() + "');history.back();</script>");
        } finally {
            out.close();
        }
    }
}