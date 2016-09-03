/**
 * Copyright &copy; 2012-2014 <a href="http://www.haijintech.com">HaiJinTech</a> All rights reserved.
 */
package com.hhwy.vital.modules.sys.utils;

import com.hhwy.vital.common.service.BaseService;
import com.hhwy.vital.common.utils.CacheUtils;
import com.hhwy.vital.common.utils.SpringContextHolder;
import com.hhwy.vital.modules.sys.dao.MenuDao;
import com.hhwy.vital.modules.sys.dao.OfficeDao;
import com.hhwy.vital.modules.sys.dao.RoleDao;
import com.hhwy.vital.modules.sys.dao.UserDao;
import com.hhwy.vital.modules.sys.entity.Menu;
import com.hhwy.vital.modules.sys.entity.Office;
import com.hhwy.vital.modules.sys.entity.Role;
import com.hhwy.vital.modules.sys.entity.User;
import com.hhwy.vital.modules.sys.security.SystemAuthorizingRealm.Principal;
import org.apache.shiro.SecurityUtils;
import org.apache.shiro.UnavailableSecurityManagerException;
import org.apache.shiro.session.InvalidSessionException;
import org.apache.shiro.session.Session;
import org.apache.shiro.subject.Subject;

import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.List;

/**
 * 用户工具类
 * @author zbx
 * @version 2013-12-05
 */
public class UserUtils {

	private static UserDao userDao = SpringContextHolder.getBean(UserDao.class);
	private static RoleDao roleDao = SpringContextHolder.getBean(RoleDao.class);
	private static MenuDao menuDao = SpringContextHolder.getBean(MenuDao.class);
	private static OfficeDao officeDao = SpringContextHolder.getBean(OfficeDao.class);

	public static final String USER_CACHE = "userCache";
	public static final String USER_CACHE_ID_ = "id_";
	public static final String USER_CACHE_LOGIN_NAME_ = "ln";
	public static final String USER_CACHE_LIST_BY_OFFICE_ID_ = "oid_";

	public static final String CACHE_ROLE_LIST = "roleList";
	public static final String CACHE_MENU_LIST = "menuList";
	public static final String CACHE_AREA_LIST = "areaList";
	public static final String CACHE_OFFICE_LIST = "officeList";
	public static final String CACHE_OFFICE_ALL_LIST = "officeAllList";
	
	/**
	 * 根据ID获取用户
	 * @param id
	 * @return 取不到返回null
	 */
	public static User get(String id){
		User user = (User) CacheUtils.get(USER_CACHE, USER_CACHE_ID_ + id);
		if (user ==  null){
			user = userDao.get(id);
			if (user == null){
				return null;
			}
			user.setRoleList(roleDao.findList(new Role(user)));
			CacheUtils.put(USER_CACHE, USER_CACHE_ID_ + user.getId(), user);
			CacheUtils.put(USER_CACHE, USER_CACHE_LOGIN_NAME_ + user.getLoginName(), user);
		}
		return user;
	}
	
	/**
	 * 根据登录名获取用户
	 * @param loginName
	 * @return 取不到返回null
	 */
	public static User getByLoginName(String loginName){
		User user = (User)CacheUtils.get(USER_CACHE, USER_CACHE_LOGIN_NAME_ + loginName);
		if (user == null){
			user = userDao.getByLoginName(new User(null, loginName));
			if (user == null){
				return null;
			}
			user.setRoleList(roleDao.findList(new Role(user)));
			CacheUtils.put(USER_CACHE, USER_CACHE_ID_ + user.getId(), user);
			CacheUtils.put(USER_CACHE, USER_CACHE_LOGIN_NAME_ + user.getLoginName(), user);
		}
		return user;
	}
	
	/**
	 * 清除当前用户缓存
	 */
	public static void clearCache(){
		removeCache(CACHE_ROLE_LIST);
		removeCache(CACHE_MENU_LIST);
		removeCache(CACHE_AREA_LIST);
		removeCache(CACHE_OFFICE_LIST);
		removeCache(CACHE_OFFICE_ALL_LIST);
		UserUtils.clearCache(getUser());
	}
	
	/**
	 * 清除指定用户缓存
	 * @param user
	 */
	public static void clearCache(User user){
		CacheUtils.remove(USER_CACHE, USER_CACHE_ID_ + user.getId());
		CacheUtils.remove(USER_CACHE, USER_CACHE_LOGIN_NAME_ + user.getLoginName());
		if (user.getOffice() != null && user.getOffice().getId() != null){
			CacheUtils.remove(USER_CACHE, USER_CACHE_LIST_BY_OFFICE_ID_ + user.getOffice().getId());
		}
	}
	
	/**
	 * 获取当前用户
	 * @return 取不到返回 new User()
	 */
	public static User getUser(){
		Principal principal = getPrincipal();
		if (principal!=null){
			User user = get(principal.getId());
			if (user != null){
				return user;
			}
			return new User();
		}
		// 如果没有登录，则返回实例化空的User对象。
		return new User();
	}

	/**
	 * 获取当前用户角色列表
	 * @return
	 */
	public static List<Role> getRoleList(){
		@SuppressWarnings("unchecked")
		List<Role> roleList = null;// (List<Role>)getCache(CACHE_ROLE_LIST);
		if (roleList == null){
			User user = getUser();
			if (user.isAdmin()){
				roleList = roleDao.findAllList(new Role());
			}else{
				Role role = new Role();
				role.getSqlMap().put("dsf", BaseService.dataScopeFilter(user.getCurrentUser(), "o", "u"));
				roleList = roleDao.findList(role);
			}
			putCache(CACHE_ROLE_LIST, roleList);
		}
		return roleList;
	}
	
	/**
	 * 获取当前用户授权菜单
	 * @return
	 */
	public static List<Menu> getMenuList(Menu menu){
		@SuppressWarnings("unchecked")
		List<Menu> menuList = null;//(List<Menu>)getCache(CACHE_MENU_LIST);
		if (menuList == null){
			User user = getUser();
			if (user.isAdmin()){
				menuList = menuDao.findList(menu);
			}else{
				Menu m = new Menu();
				m.setUserId(user.getId());
				menuList = menuDao.findByUserId(m);
			}
			putCache(CACHE_MENU_LIST, menuList);
		}
		return menuList;
	}
	/**
	 * 获取当前用户授权菜单
	 * @return
	 */
	public static List<Menu> getMenuList(){
		clearCache();
		@SuppressWarnings("unchecked")
		List<Menu> menuList = (List<Menu>)getCache(CACHE_MENU_LIST);
		if (menuList == null){
			User user = getUser();
			if (user.isAdmin()){
				menuList = menuDao.findAllList(new Menu());
			}else{
				Menu m = new Menu();
				m.setUserId(user.getId());
				menuList = menuDao.findByUserId(m);
			}

			if(null!=menuList && menuList.size()>0){
				for (int i = 0; i < menuList.size(); i++) {
					String isExistNode = "0";
					for (int j = 0; j < menuList.size(); j++) {
						if (menuList.get(j).getParent()!=null
								&& menuList.get(j).getParent().getId()!=null
								&& menuList.get(j).getParent().getId().equals(menuList.get(i).getId())
								&& menuList.get(j).getIsShow()==1
								&& menuList.get(j).getIsShow()==1){
							isExistNode = "1";
						}
					}
					menuList.get(i).setIsExistNode(isExistNode);
				}
			}
			putCache(CACHE_MENU_LIST, menuList);
		}

		return menuList;
	}


	/**
	 * 获取当前用户授权菜单
	 * @return
	 */
	public static LinkedHashMap<String,LinkedHashMap<String,LinkedHashMap>> getMenuTree(){
		LinkedHashMap<String,LinkedHashMap<String,LinkedHashMap>> linkedMap = new LinkedHashMap<>();

		List<Menu> menuList = getMenuList();
		for (Menu menu : menuList) {
			if (menu.getIsShow()==1){//如果是菜单
				String parentIds=menu.getParentIds();
				String[] ids = parentIds.split(",");
				if (ids.length==2){//第一级菜单
					linkedMap.put(menu.getId(),new LinkedHashMap<String,LinkedHashMap>());
				}
				if (ids.length==3){//第二级菜单
					LinkedHashMap secondMap = linkedMap.get(menu.getParentId());
					secondMap.put(menu.getId(), new LinkedHashMap<String,String>());
				}
				if (ids.length==4){//第三级菜单
					LinkedHashMap secondMap = linkedMap.get(ids[2]);
					LinkedHashMap thirdMap= (LinkedHashMap) secondMap.get(ids[3]);
					thirdMap.put(menu.getId(), null);
				}
//				if (ids.length==5){//第四级菜单
//					LinkedHashMap secondMap = linkedMap.get(ids[2]);
//					LinkedHashMap thirdMap= (LinkedHashMap) secondMap.get(ids[3]);
//					thirdMap.put(menu.getId(), null);
//				}
			}
		}
		return linkedMap;
	}

	/**
	 * 获取当前用户授权菜单
	 * @return
	 */
	public static HashMap<String,Menu> getMenuMap(){
		HashMap<String,Menu> menuMap = new HashMap<>();

		List<Menu> menuList = getMenuList();
		for (Menu menu : menuList) {
			menuMap.put(menu.getId(), menu);
		}
		return menuMap;
	}

	
	/**
	 * 获取当前用户有权限访问的部门
	 * @return
	 */
	public static List<Office> getOfficeList(){
		@SuppressWarnings("unchecked")
		List<Office> officeList = (List<Office>)getCache(CACHE_OFFICE_LIST);
		if (officeList == null){
			User user = getUser();
			if (user.isAdmin()){
				officeList = officeDao.findAllList(new Office());
			}else{
				Office office = new Office();
				office.getSqlMap().put("dsf", BaseService.dataScopeFilter(user, "a", ""));
				officeList = officeDao.findList(office);
			}
			putCache(CACHE_OFFICE_LIST, officeList);
		}
		return officeList;
	}

	/**
	 * 获取当前用户有权限访问的部门
	 * @return
	 */
	public static List<Office> getOfficeAllList(){
		@SuppressWarnings("unchecked")
		List<Office> officeList = (List<Office>)getCache(CACHE_OFFICE_ALL_LIST);
		if (officeList == null){
			officeList = officeDao.findAllList(new Office());
		}
		return officeList;
	}
	
	/**
	 * 获取授权主要对象
	 */
	public static Subject getSubject(){
		return SecurityUtils.getSubject();
	}
	
	/**
	 * 获取当前登录者对象
	 */
	public static Principal getPrincipal(){
		try{
			Subject subject = SecurityUtils.getSubject();
			Principal principal = (Principal)subject.getPrincipal();
			if (principal != null){
				return principal;
			}
		}catch (UnavailableSecurityManagerException e) {
			
		}catch (InvalidSessionException e){
			
		}
		return null;
	}
	
	public static Session getSession(){
		try{
			Subject subject = SecurityUtils.getSubject();
			Session session = subject.getSession(false);
			if (session == null){
				session = subject.getSession();
			}
			if (session != null){
				return session;
			}
		}catch (InvalidSessionException e){
			
		}
		return null;
	}
	
	// ============== User Cache ==============
	
	public static Object getCache(String key) {
		return getCache(key, null);
	}
	
	public static Object getCache(String key, Object defaultValue) {
		Object obj = getSession().getAttribute(key);
		return obj==null?defaultValue:obj;
	}

	public static void putCache(String key, Object value) {
		getSession().setAttribute(key, value);
	}

	public static void removeCache(String key) {
		getSession().removeAttribute(key);
	}
	
}
