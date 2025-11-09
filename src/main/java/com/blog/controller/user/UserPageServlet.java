package com.blog.controller.user;

import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/user/*")
public class UserPageServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException {
        // 提取路径参数（如 /user/home → path = "home"）
        String path = request.getPathInfo();
        if (path == null || path.equals("/")) {
            path = "home"; // 默认跳首页
        } else {
            path = path.substring(1); // 去掉开头的斜杠
        }

        // 关键修改：如果是 home 路径，转发到 HomeServlet（触发其逻辑）
        if ("home".equals(path)) {
            try {
                // 转发到 /home，让 HomeServlet 处理数据查询
                request.getRequestDispatcher("/home").forward(request, response);
            } catch (Exception e) {
                e.printStackTrace();
                response.sendRedirect(request.getContextPath() + "/user/404");
            }
            return;
        }

        // 其他路径（如 /user/register、/user/info）仍按原有逻辑处理
        String jspPath = "/jsp/user/" + path + ".jsp";
        try {
            request.getRequestDispatcher(jspPath).forward(request, response);
        } catch (Exception e) {
            response.sendRedirect(request.getContextPath() + "/user/404");
        }
    }
}