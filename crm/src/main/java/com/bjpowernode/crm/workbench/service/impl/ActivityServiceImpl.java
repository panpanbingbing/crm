package com.bjpowernode.crm.workbench.service.impl;

import com.bjpowernode.crm.utils.DateTimeUtil;
import com.bjpowernode.crm.utils.SqlSessionUtil;
import com.bjpowernode.crm.vo.PaginationVO;
import com.bjpowernode.crm.workbench.dao.ActivityDao;
import com.bjpowernode.crm.workbench.dao.ActivityRemarkDao;
import com.bjpowernode.crm.workbench.domain.Activity;
import com.bjpowernode.crm.workbench.service.ActivityService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.util.List;
import java.util.Map;

public class ActivityServiceImpl implements ActivityService {
    public static final Logger  logger = LoggerFactory.getLogger(ActivityServiceImpl.class);
    static final ActivityDao activityDao = SqlSessionUtil.getSqlSession().getMapper(ActivityDao.class);
    static final ActivityRemarkDao activityRemark = SqlSessionUtil.getSqlSession().getMapper(ActivityRemarkDao.class);


    @Override
    public boolean createActivity(Activity activity) {
        logger.info( "createActivityStart");

        boolean flan = false;
        int count = activityDao.createActivity(activity);
        if (count == 1) {
            flan = true;
        }

        logger.info( "createActivityEnd");
        return flan;

    }

    @Override
    public PaginationVO<Activity> PageList(Map<String, Object> pageMap) {
        logger.info( "PageListStart");

        List<Activity> activityList= activityDao.createPageList(pageMap);
        int count = activityDao.countPageList(pageMap);

        PaginationVO<Activity> pagination = new PaginationVO<Activity>();
        pagination.setDataList(activityList);
        pagination.setTotal(count);

        logger.info( "PageListEnd");
        return pagination;
    }

    @Override
    public boolean deleteActivity(String[] ids) {
        logger.info( "deleteActivityStart");
        boolean result = false;

        int count1= activityRemark.getDeleteActivityRemark(ids);
        int count2= activityRemark.deleteActivityRemark(ids);
        int count3= activityDao.deleteActivity(ids);

        if (count1==count2){
            result=true;
        }
        if(count3==ids.length){
            result=true;
        }

        logger.info( "deleteActivityEnd");
        return result;
    }
}
