package com.hhwy.vital.utility;

import com.hhwy.vital.modules.sys.entity.User;
import com.hhwy.vital.modules.sys.utils.UserUtils;

/**
 * 
 * <b>类 名 称：</b>SessionHelper<br/>
 * <b>类 描 述：</b>会话相关接口帮助类<br/>
 * <b>创 建 人：</b>zk<br/>
 * <b>修改时间：</b>2016年8月17日 上午8:43:12<br/>
 * <b>修改备注：</b><br/>
 * @version 1.0.0<br/>
 */
public class SessionHelper {
	
	public static User getCurrentUser(){
		return UserUtils.getUser();
		//TODO【后端接口】获取当前用户对象
	}
	
	public static String getCurrentUserId(){
		
		//TODO【后端接口】获取当前登录用户ID
		return null;
	}
	
	public static boolean login(String userName, String password){
		
		//TODO【后端接口】登录
		return false;
	}
	
	public static void loginout(){
		
		//TODO【后端接口】注销
	}
}
