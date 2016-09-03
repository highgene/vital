/**
 * Copyright &copy; 2012-2014 <a href="http://www.haijintech.com">HaiJinTech</a> All rights reserved.
 */
package com.hhwy.vital.modules.sys.utils;

import com.google.common.collect.Lists;
import com.google.common.collect.Maps;
import com.hhwy.vital.common.config.Global;
import com.hhwy.vital.common.utils.CacheUtils;
import com.hhwy.vital.common.utils.SpringContextHolder;
import com.hhwy.vital.common.utils.StringUtils;
import com.hhwy.vital.modules.sys.dao.LogDao;
import com.hhwy.vital.modules.sys.dao.MenuDao;
import com.hhwy.vital.modules.sys.entity.Log;
import com.hhwy.vital.modules.sys.entity.Menu;
import com.hhwy.vital.modules.sys.entity.User;
import org.apache.shiro.authz.annotation.RequiresPermissions;
import org.springframework.web.method.HandlerMethod;

import javax.servlet.http.HttpServletRequest;
import java.lang.reflect.Method;
import java.util.List;
import java.util.Map;

/**
 * 字典工具类
 * @author zbx
 * @version 2014-11-7
 */
public class LogUtils {
	
	public static final String CACHE_MENU_NAME_PATH_MAP = "menuNamePathMap";
	
	private static LogDao logDao = SpringContextHolder.getBean(LogDao.class);
	private static MenuDao menuDao = SpringContextHolder.getBean(MenuDao.class);
	
	/**
	 * 保存日志
	 */
	public static void saveLog(HttpServletRequest request, String title){
		saveLog(request, null, null, title);
	}
	
	/**
	 * 保存日志
	 */
	public static void saveLog(HttpServletRequest request, Object handler, Exception ex, String title){
		User user = UserUtils.getUser();
		if (user != null && user.getId() != null){
			Log log = new Log();
			log.setRequestUri(request.getRequestURI());
			log.setMethod(request.getMethod());

			log.setLogMessage(request.getRequestURI()+"?"+log.getParams(request.getParameterMap()));
			log.setResourceId(title);
			log.setClientIp(StringUtils.getRemoteAddr(request));
			log.setClientAgent(request.getHeader("user-agent"));
			// 异步保存日志
			new SaveLogThread(log, handler, ex).start();
		}
	}

	/**
	 * 保存日志线程
	 */
	public static class SaveLogThread extends Thread{
		
		private Log log;
		private Object handler;
		private Exception ex;
		
		public SaveLogThread(Log log, Object handler, Exception ex){
			super(SaveLogThread.class.getSimpleName());
			this.log = log;
			this.handler = handler;
			this.ex = ex;
		}
		
		@Override
		public void run() {
			// 获取日志标题
			if (StringUtils.isBlank(log.getResourceId())){
				String permission = "";
				if (handler instanceof HandlerMethod){
					Method m = ((HandlerMethod)handler).getMethod();
					RequiresPermissions rp = m.getAnnotation(RequiresPermissions.class);
					permission = (rp != null ? StringUtils.join(rp.value(), ",") : "");
				}
				log.setResourceId(getMenuNamePath(log.getRequestUri(), permission));
			}
			// 如果无标题并无异常日志，则不保存信息
			if (StringUtils.isBlank(log.getResourceId()) && StringUtils.isBlank(log.getLogMessage())){
				return;
			}
			// 保存日志信息
			log.preInsert();
			if (!StringUtils.isEmpty(log.getResourceId())){
				logDao.insert(log);
			}
		}
	}

	/**
	 * 获取菜单名称路径（如：系统设置-机构用户-用户管理-编辑）
	 */
	public static String getMenuNamePath(String requestUri, String permission){
		String href = StringUtils.substringAfter(requestUri, Global.getAdminPath());
		@SuppressWarnings("unchecked")
		Map<String, String> menuMap = (Map<String, String>) CacheUtils.get(CACHE_MENU_NAME_PATH_MAP);
		if (menuMap == null){
			menuMap = Maps.newHashMap();
			List<Menu> menuList = menuDao.findAllList(new Menu());
			for (Menu menu : menuList){
				// 获取菜单名称路径（如：系统设置-机构用户-用户管理-编辑）
				String namePath = "";
				if (menu.getParentIds() != null){
					List<String> namePathList = Lists.newArrayList();
					for (String id : StringUtils.split(menu.getParentIds(), ",")){
						if (Menu.getRootId().equals(id)){
							continue; // 过滤跟节点
						}
						for (Menu m : menuList){
							if (m.getId().equals(id)){
								namePathList.add(m.getResourceName());
								break;
							}
						}
					}
					namePathList.add(menu.getResourceName());
					namePath = StringUtils.join(namePathList, "/");

					for (String path:namePathList){
						namePath=namePath.replaceAll(path+"/"+path,path);
					}

				}
				// 设置菜单名称路径
				if (StringUtils.isNotBlank(menu.getUrl())){
					menuMap.put(menu.getUrl(), namePath);
				}else if (StringUtils.isNotBlank(menu.getPermission())){
					for (String p : StringUtils.split(menu.getPermission())){
						menuMap.put(p, namePath);
					}
				}
				
			}
			CacheUtils.put(CACHE_MENU_NAME_PATH_MAP, menuMap);
		}
		String menuNamePath = menuMap.get(href);
		if (menuNamePath == null){
			for (String p : StringUtils.split(permission)){
				menuNamePath = menuMap.get(p);
				if (StringUtils.isNotBlank(menuNamePath)){
					break;
				}
			}
			if (menuNamePath == null){
				return "";
			}
		}
		return menuNamePath;
	}

	
}
