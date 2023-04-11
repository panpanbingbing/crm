package com.bjpowernode.crm.utils;

import java.lang.reflect.InvocationHandler;
import java.lang.reflect.Method;
import java.lang.reflect.Proxy;

import org.apache.ibatis.session.SqlSession;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class TransactionInvocationHandler implements InvocationHandler{
	public static final Logger	logger= LoggerFactory.getLogger(TransactionInvocationHandler.class);
	private Object target;
	
	public TransactionInvocationHandler(Object target){
		
		this.target = target;
		
	}

//	@Override
	public Object invoke(Object proxy, Method method, Object[] args) throws Throwable {
		logger.info("代理方法执行");
		SqlSession session = null;
		
		Object obj = null;

		try{
			session = SqlSessionUtil.getSqlSession();

			obj = method.invoke(target, args);

			session.commit();
//			SqlSessionUtil.myClose(session);myClose
		}catch(Exception e){

			session.rollback();
			e.printStackTrace();
			
			//处理的是什么异常，继续往上抛什么异常
			throw e.getCause();
		}finally{
//			SqlSessionUtil.myClose(session);
		}
		logger.info("代理方法执行结束");
		return obj;
	}
	
	public Object getProxy(){
		
		return Proxy.newProxyInstance(target.getClass().getClassLoader(), target.getClass().getInterfaces(),this);
		
	}
	
}











































