package com.bjpowernode.crm.workbench.service;

import com.bjpowernode.crm.vo.PaginationVO;
import com.bjpowernode.crm.workbench.domain.Activity;

import java.util.Map;

public interface ActivityService {
    boolean createActivity(Activity activity);

    PaginationVO<Activity> PageList(Map<String, Object> pageMap);

    boolean deleteActivity(String[] ids);
}
