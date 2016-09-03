package com.hhwy.vital.utility;


/**
 * 
 * <b>类 名 称：</b>SecurityHelper<br/>
 * <b>类 描 述：</b>安全验证接口帮助类<br/>
 * <b>创 建 人：</b>zk<br/>
 * <b>修改时间：</b>2016年8月17日 上午8:43:12<br/>
 * <b>修改备注：</b><br/>
 * @version 1.0.0<br/>
 */
public class SecurityHelper {
	
	public static boolean hasPermission(String userId,String targetId,String resourceId){
		
		//TODO【后端接口】验证
		return false;
	}
	
	public static boolean isAdministrator(String userId, String targetId){
		
		//TODO【后端接口】验证指定用户是否为超级管理员
		return false;
	}
	
	public static boolean isManager(String userId,String targetId){
		
		//TODO【后端接口】验证指定用户是否为系统管理员
		return false;
	}
	
	public static boolean hasURLPerssion(String URL, String userId){
		
		//TODO【后端接口】验证指定的URL对指定用户是否有权限
		return false;
	}
	
}
