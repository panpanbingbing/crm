package com.bjpowernode.crm.web.filter;

import com.bjpowernode.crm.utils.DateTimeUtil;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.io.IOException;

@WebFilter({"*.do", "*.jsp","*.html"})
public class LoginFilter implements Filter {
    private static final Logger logger = LoggerFactory.getLogger(LoginFilter.class);

    @Override
    public void doFilter(ServletRequest servletRequest, ServletResponse servletResponse, FilterChain filterChain) throws IOException, ServletException {

        logger.info("验证是否登录过滤器开始");
        HttpServletRequest request = (HttpServletRequest) servletRequest;
        HttpServletResponse response = (HttpServletResponse) servletResponse;
        String path = request.getServletPath();


        logger.debug("访问路径："+path+"");
        if ("/login.jsp".equals(path) || "/settings/user/login.do".equals(path) ||"/index.html".equals(path)) {
            filterChain.doFilter(request, response);
        } else {


            HttpSession session = request.getSession();
            Object user = session.getAttribute("user");

            logger.info("session中得user对象："+user+"");

            if (user != null) {
                filterChain.doFilter(request, response);
            } else {
                response.sendRedirect(request.getContextPath() + "/index.html");
            }
        }
        logger.info("验证是否登录过滤器结束");
    }
}
