package com.bjpowernode.crm.web.filter;

import com.bjpowernode.crm.utils.DateTimeUtil;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.io.IOException;


//@webFilter()
@WebFilter({"*.do"})
public class EncodingFilter implements Filter {
    private static final Logger logger= LoggerFactory.getLogger(EncodingFilter.class);
    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain filterChain) throws IOException, ServletException {
        logger.info("字符集过滤器执行开始");
        request.setCharacterEncoding("UTF-8");


        response.setContentType("text/html;charset=utf-8");

        filterChain.doFilter(request, response);
        logger.info("字符集过滤器执行结束");
    }


}
