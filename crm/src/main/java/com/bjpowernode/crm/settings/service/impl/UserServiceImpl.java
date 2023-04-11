package com.bjpowernode.crm.settings.service.impl;

import com.bjpowernode.crm.exception.LoginException;
import com.bjpowernode.crm.settings.dao.UserDao;
import com.bjpowernode.crm.settings.domain.User;
import com.bjpowernode.crm.settings.service.UserService;
import com.bjpowernode.crm.utils.DateTimeUtil;
import com.bjpowernode.crm.utils.SqlSessionUtil;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class UserServiceImpl implements UserService {
    public static final Logger logger = LoggerFactory.getLogger(UserServiceImpl.class);
    private UserDao userDao = SqlSessionUtil.getSqlSession().getMapper(UserDao.class);

    @Override
    public User login(String username, String password, String ip) throws LoginException {
        logger.info("User业务层登录方法执行开始");
        Map<String, String> map = new HashMap<String, String>();
        map.put("loginAct", username);
        map.put("loginPwd", password);

        String currTime = DateTimeUtil.getSysTime();
        User user = userDao.login(map);

        if (user == null) {
            throw new LoginException("账号密码错误");
        } else if (user.getExpireTime().compareTo(currTime) < 0) {
            throw new LoginException("账号已失效");
        } else if ("0".equals(user.getLockState())) {
            throw new LoginException("账号已锁定");
        }

        logger.info("User业务层登录方法执行结束");
        return user;
    }

    @Override
    public List<User> getUserList() {
        logger.info("User业务层获取用户列表方法执行开始");
        List<User> userList = userDao.getUserList();
       logger.info("User业务层获取用户列表方法执行结束");
        return userList;
    }
}
