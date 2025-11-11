package com.blog.filter;

import javax.servlet.*;
import javax.servlet.annotation.WebFilter;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.io.PrintWriter;

/**
 * 登录验证过滤器
 * 拦截需要登录才能访问的页面，未登录用户显示提示并跳转到登录页
 * 
 * 注意：Filter执行顺序应该设置为在AutoLoginFilter之后执行
 */
@WebFilter(
    filterName = "AuthFilter",
    urlPatterns = {
        "/article/publish",
        "/article/save-draft",
        "/article/drafts",
        "/article/my-articles",
        "/article/delete",
        "/article/delete-draft",
        "/article/toggle-privacy",
        "/user/profile",
        "/user/my-information",
        "/user/update-info",
        "/user/avatar-upload",
        "/user/stats",
        "/article/my-collect",
        "/folder/*",
        "/comment/add",
        "/comment/reply",
        "/comment/delete",
        "/comment/like",
        "/comment/unlike",
        "/article/like",
        "/article/check-like"
    }
)
public class AuthFilter implements Filter {
    
    // 允许未登录访问的路径（这些路径不需要登录）
    private static final String[] ALLOWED_PATHS = {
        "/home",
        "/index",
        "/",
        "/search",
        "/article/detail",
        "/article/list",
        "/comment/list",
        "/comment/drawer",
        "/user/login",
        "/user/register",
        "/jsp/",
        "/images/",
        "/css/",
        "/js/",
        "/WEB-INF/"
    };
    
    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        // 初始化
    }
    
    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        
        HttpServletRequest httpRequest = (HttpServletRequest) request;
        HttpServletResponse httpResponse = (HttpServletResponse) response;
        HttpSession session = httpRequest.getSession(false);
        
        // 检查是否已登录
        boolean isLoggedIn = session != null && session.getAttribute("user") != null;
        
        // 如果已登录，直接放行
        if (isLoggedIn) {
            chain.doFilter(request, response);
            return;
        }
        
        // 检查是否是允许的路径
        String requestURI = httpRequest.getRequestURI();
        String contextPath = httpRequest.getContextPath();
        String path = requestURI.substring(contextPath.length());
        
        if (isAllowedPath(path)) {
            chain.doFilter(request, response);
            return;
        }
        
        // 未登录且访问需要登录的页面，显示提示并跳转
        String requestType = httpRequest.getHeader("X-Requested-With");
        boolean isAjax = "XMLHttpRequest".equals(requestType);
        
        if (isAjax) {
            // AJAX请求，返回JSON响应
            httpResponse.setContentType("application/json;charset=UTF-8");
            httpResponse.setCharacterEncoding("UTF-8");
            PrintWriter out = httpResponse.getWriter();
            out.println("{\"success\": false, \"message\": \"请先登录\", \"code\": 401, \"redirect\": \"" + 
                       contextPath + "/user/login\"}");
            out.flush();
        } else {
            // 普通请求，显示提示并跳转
            httpResponse.setContentType("text/html;charset=UTF-8");
            httpResponse.setCharacterEncoding("UTF-8");
            PrintWriter out = httpResponse.getWriter();
            out.println("<script>");
            out.println("alert('请先登录');");
            out.println("window.location.href = '" + contextPath + "/user/login';");
            out.println("</script>");
            out.flush();
        }
    }
    
    /**
     * 检查路径是否在允许列表中
     */
    private boolean isAllowedPath(String path) {
        if (path == null || path.isEmpty()) {
            return true; // 根路径允许访问
        }
        
        for (String allowedPath : ALLOWED_PATHS) {
            if (path.startsWith(allowedPath)) {
                return true;
            }
        }
        
        return false;
    }
    
    @Override
    public void destroy() {
        // 清理资源
    }
}

