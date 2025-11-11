package com.blog.filter;

import com.blog.entity.User;
import com.blog.service.UserService;
import com.blog.service.impl.UserServiceImpl;
import com.blog.util.RememberMeUtil;

import javax.servlet.*;
import javax.servlet.annotation.WebFilter;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

/**
 * 自动登录过滤器
 * 检查Cookie中的记住我token，如果有效则自动登录
 */
@WebFilter(urlPatterns = {"/*"})
public class AutoLoginFilter implements Filter {
    
    private UserService userService = new UserServiceImpl();
    
    // 不需要自动登录的路径
    private static final String[] EXCLUDE_PATHS = {
        "/user/login",
        "/user/register",
        "/user/logout",
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
        
        // 如果session中已有用户信息，直接放行
        if (session != null && session.getAttribute("user") != null) {
            chain.doFilter(request, response);
            return;
        }
        
        // 检查是否在排除路径中
        String requestURI = httpRequest.getRequestURI();
        String contextPath = httpRequest.getContextPath();
        String path = requestURI.substring(contextPath.length());
        
        if (isExcludePath(path)) {
            chain.doFilter(request, response);
            return;
        }
        
        // 检查Cookie中的记住我token
        javax.servlet.http.Cookie[] cookies = httpRequest.getCookies();
        if (cookies != null) {
            for (javax.servlet.http.Cookie cookie : cookies) {
                if (RememberMeUtil.getCookieName().equals(cookie.getName())) {
                    String token = cookie.getValue();
                    if (token != null && !token.isEmpty()) {
                        // 验证token并获取用户ID
                        Integer userId = RememberMeUtil.validateAndParseToken(token);
                        if (userId != null) {
                            // token有效，查询用户信息
                            User user = userService.getUserById(userId);
                            if (user != null && (user.getStatus() == null || user.getStatus() != 0)) {
                                // 用户存在且未被禁用，自动登录
                                if (session == null) {
                                    session = httpRequest.getSession(true);
                                }
                                session.setAttribute("user", user);
                                session.setMaxInactiveInterval(30 * 60); // 30分钟超时
                                
                                System.out.println("自动登录成功，用户ID: " + userId);
                            } else {
                                // 用户不存在或已被禁用，清除无效Cookie
                                clearRememberMeCookie(httpRequest, httpResponse);
                            }
                        } else {
                            // token无效或已过期，清除Cookie
                            clearRememberMeCookie(httpRequest, httpResponse);
                        }
                    }
                    break;
                }
            }
        }
        
        chain.doFilter(request, response);
    }
    
    /**
     * 检查路径是否在排除列表中
     */
    private boolean isExcludePath(String path) {
        if (path == null || path.isEmpty()) {
            return false;
        }
        
        for (String excludePath : EXCLUDE_PATHS) {
            if (path.startsWith(excludePath)) {
                return true;
            }
        }
        
        return false;
    }
    
    /**
     * 清除记住我Cookie
     */
    private void clearRememberMeCookie(HttpServletRequest request, HttpServletResponse response) {
        javax.servlet.http.Cookie cookie = new javax.servlet.http.Cookie(
            RememberMeUtil.getCookieName(), "");
        cookie.setMaxAge(0);
        cookie.setPath(request.getContextPath() + "/");
        response.addCookie(cookie);
    }
    
    @Override
    public void destroy() {
        // 清理资源
    }
}

