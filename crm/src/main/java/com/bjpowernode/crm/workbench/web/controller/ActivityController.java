package com.bjpowernode.crm.workbench.web.controller;

import com.bjpowernode.crm.settings.domain.User;
import com.bjpowernode.crm.settings.service.UserService;
import com.bjpowernode.crm.settings.service.impl.UserServiceImpl;
import com.bjpowernode.crm.utils.DateTimeUtil;
import com.bjpowernode.crm.utils.PrintJson;
import com.bjpowernode.crm.utils.ServiceFactory;
import com.bjpowernode.crm.utils.UUIDUtil;
import com.bjpowernode.crm.vo.PaginationVO;
import com.bjpowernode.crm.workbench.domain.Activity;
import com.bjpowernode.crm.workbench.service.ActivityService;
import com.bjpowernode.crm.workbench.service.impl.ActivityServiceImpl;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@WebServlet({"/workbench/activity/getUserList.do",
        "/workbench/activity/saveActivity.do",
        "/workbench/activity/pageList.do",
        "/workbench/activity/deleteActivity.do"})
public class ActivityController extends HttpServlet {

    private static final Logger logger = LoggerFactory.getLogger(ActivityController.class);
    @Override
    protected void service(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String path = request.getServletPath();
        if ("/workbench/activity/getUserList.do".equals(path)) {
            doGetUserList(request, response);
        } else if ("/workbench/activity/saveActivity.do".equals(path)) {
            doSaveActivity(request, response);
        } else if ("/workbench/activity/pageList.do".equals(path)) {
            doPageList(request, response);

        } else if ("/workbench/activity/deleteActivity.do".equals(path)) {
            doDeleteActivity(request, response);
        }
    }

    private void doDeleteActivity(HttpServletRequest request, HttpServletResponse response) {
        logger.info("doDeleteActivityStart");
        ActivityService activityService = (ActivityService) ServiceFactory.getService(new ActivityServiceImpl());
        String[] ids = request.getParameterValues("id");


        boolean flag = activityService.deleteActivity(ids);

        PrintJson.printJsonFlag(response, flag);

        logger.info("doDeleteActivityStart");
    }

    private void doPageList(HttpServletRequest request, HttpServletResponse response) {
        ActivityService activity = (ActivityService) ServiceFactory.getService(new ActivityServiceImpl());

        String name = request.getParameter("name");
        String owner = request.getParameter("owner");
        String startDate = request.getParameter("startDate");
        String endDate = request.getParameter("endDate");


        String pageNoStr = request.getParameter("pageNo");
        int pageNo = Integer.valueOf(pageNoStr);
//        int pageNo = 2;


        //每页展现的记录数
        String pageSizeStr = request.getParameter("pageSize");
        int pageSize = Integer.valueOf(pageSizeStr);
//        int pageSize = 5;



        //计算出略过的记录数
        int skipCount = (pageNo-1)*pageSize;


        Map<String, Object> pageMap = new HashMap<String, Object>();
        pageMap.put("skipCount", skipCount);
        pageMap.put("pageSize", pageSize);
        pageMap.put("name", name);
        pageMap.put("owner", owner);
        pageMap.put("startDate", startDate);
        pageMap.put("endDate", endDate);

        PaginationVO<Activity> vo = activity.PageList(pageMap);
        PrintJson.printJsonObj(response, vo);


    }

    private void doSaveActivity(HttpServletRequest request, HttpServletResponse response) {
        logger.info("doSaveActivityStart");
        ActivityService activityService = (ActivityService) ServiceFactory.getService(new ActivityServiceImpl());


        String owner = request.getParameter("owner");
        String name = request.getParameter("name");
        String startDate = request.getParameter("startDate");
        String endDate = request.getParameter("endDate");
        String cost = request.getParameter("cost");
        String description = request.getParameter("description");
        User createBys = (User) request.getSession().getAttribute("user");
        String userName = createBys.getName();
        Activity activity = new Activity();
        activity.setId(UUIDUtil.getUUID());
        activity.setOwner(owner);
        activity.setName(name);
        activity.setStartDate(startDate);
        activity.setEndDate(endDate);
        activity.setCost(cost);
        activity.setDescription(description);
        activity.setCreateTime(DateTimeUtil.getSysTime());
        activity.setCreateBy(userName);

        boolean i = activityService.createActivity(activity);

        PrintJson.printJsonFlag(response, i);
        logger.debug("doSaveActivityEnd");
    }

    private void doGetUserList(HttpServletRequest request, HttpServletResponse response) {
        logger.debug("获取用户信息开始");
        UserService userService = (UserService) ServiceFactory.getService(new UserServiceImpl());

        List<User> userlist = userService.getUserList();
        PrintJson.printJsonObj(response, userlist);
        logger.debug("获取用户信息结束");
    }
}
