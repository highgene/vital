/**
 * Copyright &copy; 2012-2014 <a href="http://www.haijintech.com">HaiJinTech</a> All rights reserved.
 */
package com.hhwy.vital.modules.sys.web;

import com.google.common.collect.Maps;
import com.hhwy.vital.common.config.Global;
import com.hhwy.vital.common.security.shiro.session.SessionDAO;
import com.hhwy.vital.common.servlet.ValidateCodeServlet;
import com.hhwy.vital.common.utils.CacheUtils;
import com.hhwy.vital.common.utils.CookieUtils;
import com.hhwy.vital.common.utils.IdGen;
import com.hhwy.vital.common.utils.StringUtils;
import com.hhwy.vital.common.web.BaseController;
import com.hhwy.vital.modules.sys.entity.Menu;
import com.hhwy.vital.modules.sys.entity.User;
import com.hhwy.vital.modules.sys.security.FormAuthenticationFilter;
import com.hhwy.vital.modules.sys.security.SystemAuthorizingRealm;
import com.hhwy.vital.modules.sys.utils.UserUtils;
import org.apache.shiro.authz.UnauthorizedException;
import org.apache.shiro.authz.annotation.RequiresPermissions;
import org.apache.shiro.web.util.WebUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.Map;

/**
 * 登录Controller
 * @author zbx
 * @version 2013-5-31
 */
@Controller
public class LoginController extends BaseController {
	
	@Autowired
	private SessionDAO sessionDAO;
	
	/**
	 * 管理登录
	 */
	@RequestMapping(value = "${adminPath}/login", method = RequestMethod.GET)
	public String login(HttpServletRequest request, HttpServletResponse response, Model model) {
		SystemAuthorizingRealm.Principal principal = UserUtils.getPrincipal();
		System.out.println("login 123 ...");

		if (logger.isDebugEnabled()){
			logger.debug("login, active session size: {}", sessionDAO.getActiveSessions(false).size());
		}

		// 如果已登录，再次访问主页，则退出原账号。
		if (Global.TRUE.equals(Global.getConfig("notAllowRefreshIndex"))){
			CookieUtils.setCookie(response, "LOGINED", "false");
		}
		
		// 如果已经登录，则跳转到管理首页
		if(principal != null && !principal.isMobileLogin()){
			return "redirect:" + adminPath;
		}
		return "/view/vital/modules/sys/sysLogin";
	}

	/**
	 * 登录失败，真正登录的POST请求由Filter完成
	 */
	@RequestMapping(value = "${adminPath}/login", method = RequestMethod.POST)
	public String loginFail(HttpServletRequest request, HttpServletResponse response, Model model) {
		SystemAuthorizingRealm.Principal principal = UserUtils.getPrincipal();
		
		// 如果已经登录，则跳转到管理首页
		if(principal != null){
			return "redirect:" + adminPath;
		}

		String username = WebUtils.getCleanParam(request, FormAuthenticationFilter.DEFAULT_USERNAME_PARAM);
		boolean rememberMe = WebUtils.isTrue(request, FormAuthenticationFilter.DEFAULT_REMEMBER_ME_PARAM);
		boolean mobile = WebUtils.isTrue(request, FormAuthenticationFilter.DEFAULT_MOBILE_PARAM);
		String exception = (String)request.getAttribute(FormAuthenticationFilter.DEFAULT_ERROR_KEY_ATTRIBUTE_NAME);
		String message = (String)request.getAttribute(FormAuthenticationFilter.DEFAULT_MESSAGE_PARAM);
		
		if (StringUtils.isBlank(message) || StringUtils.equals(message, "null")){
			message = "用户或密码错误, 请重试.";
		}

		model.addAttribute(FormAuthenticationFilter.DEFAULT_USERNAME_PARAM, username);
		model.addAttribute(FormAuthenticationFilter.DEFAULT_REMEMBER_ME_PARAM, rememberMe);
		model.addAttribute(FormAuthenticationFilter.DEFAULT_MOBILE_PARAM, mobile);
		model.addAttribute(FormAuthenticationFilter.DEFAULT_ERROR_KEY_ATTRIBUTE_NAME, exception);
		model.addAttribute(FormAuthenticationFilter.DEFAULT_MESSAGE_PARAM, message);
		
		if (logger.isDebugEnabled()){
			logger.debug("login fail, active session size: {}, message: {}, exception: {}", 
					sessionDAO.getActiveSessions(false).size(), message, exception);
		}
		
		// 非授权异常，登录失败，验证码加1。
		if (!UnauthorizedException.class.getName().equals(exception)){
			model.addAttribute("isValidateCodeLogin", isValidateCodeLogin(username, true, false));
		}
		// 验证失败清空验证码
		request.getSession().setAttribute(ValidateCodeServlet.VALIDATE_CODE, IdGen.uuid());

		return "/view/vital/modules/sys/sysLogin";
	}

	/**
	 * 登录成功，进入管理首页
	 */
	@RequiresPermissions("user")
	@RequestMapping(value = "${adminPath}")
	public String index(HttpServletRequest request, HttpServletResponse response,Model model) {
		SystemAuthorizingRealm.Principal principal = UserUtils.getPrincipal();
		//用于以下Tree和Map用于生成左侧菜单
		LinkedHashMap<String,LinkedHashMap<String,LinkedHashMap>> menuTree = UserUtils.getMenuTree();
		model.addAttribute("menuTree", menuTree);
		HashMap<String, Menu> menuMap = UserUtils.getMenuMap();
		model.addAttribute("menuMap", menuMap);

		Menu firstMenu = new Menu();
		for (String menuId:menuTree.keySet()){
 			LinkedHashMap<String, LinkedHashMap> subMenu = menuTree.get(menuId);
			if (subMenu != null || subMenu.size() > 0) {
				for (String menuId2:subMenu.keySet()) {
					subMenu = subMenu.get(menuId2);
					if (subMenu != null || subMenu.size() > 0) {
						for (String menuId3:subMenu.keySet()) {
							firstMenu= menuMap.get(menuId3);
							break;
						}
					} else {
						firstMenu= menuMap.get(menuId2);
						break;
					}
				}
			}else {
				firstMenu= menuMap.get(menuId);
				break;
			}
			break;
		}
		model.addAttribute("firstMenu", firstMenu);

		// 登录成功后，验证码计算器清零
		isValidateCodeLogin(principal.getLoginName(), false, true);
		
		if (logger.isDebugEnabled()){
			logger.debug("show index, active session size: {}", sessionDAO.getActiveSessions(false).size());
		}

		User user = UserUtils.getUser();
		if (user.getIsChangingPassword()==1){
			return "redirect:" + adminPath + "/sys/user/loginModifyPwd";
		}
		
		// 如果已登录，再次访问主页，则退出原账号。
		if (Global.TRUE.equals(Global.getConfig("notAllowRefreshIndex"))){
			String logined = CookieUtils.getCookie(request, "LOGINED");
			if (StringUtils.isBlank(logined) || "false".equals(logined)){
				CookieUtils.setCookie(response, "LOGINED", "true");
			}else if (StringUtils.equals(logined, "true")){
				UserUtils.getSubject().logout();
				return "redirect:" + adminPath + "/login";
			}
		}

		return "/view/vital/modules/sys/sysIndex";
	}
	
	/**
	 * 获取主题方案
	 */
	@RequestMapping(value = "/theme/{theme}")
	public String getThemeInCookie(@PathVariable String theme, HttpServletRequest request, HttpServletResponse response){
		if (StringUtils.isNotBlank(theme)){
			CookieUtils.setCookie(response, "theme", theme);
		}else{
			theme = CookieUtils.getCookie(request, "theme");
		}
		return "redirect:"+request.getParameter("url");
	}
	
	/**
	 * 是否是验证码登录
	 * @param useruame 用户名
	 * @param isFail 计数加1
	 * @param clean 计数清零
	 * @return
	 */
	@SuppressWarnings("unchecked")
	public static boolean isValidateCodeLogin(String useruame, boolean isFail, boolean clean){
		Map<String, Integer> loginFailMap = (Map<String, Integer>) CacheUtils.get("loginFailMap");
		if (loginFailMap==null){
			loginFailMap = Maps.newHashMap();
			CacheUtils.put("loginFailMap", loginFailMap);
		}
		Integer loginFailNum = loginFailMap.get(useruame);
		if (loginFailNum==null){
			loginFailNum = 0;
		}
		if (isFail){
			loginFailNum++;
			loginFailMap.put(useruame, loginFailNum);
		}
		if (clean){
			loginFailMap.remove(useruame);
		}
		//return loginFailNum >= 3;
		return false;
	}
}
