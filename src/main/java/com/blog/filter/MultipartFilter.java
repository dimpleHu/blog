package com.blog.filter;

import javax.servlet.*;
import javax.servlet.annotation.WebFilter;
import javax.servlet.http.HttpServletRequest;
import java.io.IOException;

/**
 * Multipart请求过滤器
 * 用于处理multipart/form-data请求，将请求包装为可处理文件上传的请求
 */
@WebFilter(filterName = "MultipartFilter", urlPatterns = {"/user/update-info", "/user/avatar-upload"})
public class MultipartFilter implements Filter {

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        // 初始化
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        HttpServletRequest httpRequest = (HttpServletRequest) request;
        
        // 检查是否是multipart请求
        String contentType = httpRequest.getContentType();
        if (contentType != null && contentType.toLowerCase().startsWith("multipart/form-data")) {
            // 如果是multipart请求，直接传递给下一个过滤器或servlet
            // Servlet 3.0+ 的@MultipartConfig注解会自动处理multipart请求
            chain.doFilter(request, response);
        } else {
            // 非multipart请求，直接传递
            chain.doFilter(request, response);
        }
    }

    @Override
    public void destroy() {
        // 清理资源
    }
}

