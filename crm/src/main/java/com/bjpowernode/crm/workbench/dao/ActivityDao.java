package com.bjpowernode.crm.workbench.dao;

import com.bjpowernode.crm.workbench.domain.Activity;

import java.util.List;
import java.util.Map;

public interface ActivityDao {
    int createActivity(Activity activity);

    List<Activity> createPageList(Map<String, Object> pageMap);

    int countPageList(Map<String, Object> pageMap);

    int deleteActivity(String[] ids);
}
