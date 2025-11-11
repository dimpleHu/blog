package com.blog.controller.folder;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/folder/new")
public class FolderNewServlet extends HttpServlet {
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // 转发到创建收藏夹的JSP页面
        String jspPath = "/jsp/collect/new.jsp";
        request.getRequestDispatcher(jspPath).forward(request, response);
    }
}

