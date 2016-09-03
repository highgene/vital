/**
 * Copyright &copy; 2012-2014 <a href="http://www.haijintech.com">HaiJinTech</a> All rights reserved.
 */
package com.hhwy.vital.modules.sys.web;

import com.google.common.collect.Lists;
import com.google.common.collect.Maps;
import com.hhwy.vital.common.beanvalidator.BeanValidators;
import com.hhwy.vital.common.config.Global;
import com.hhwy.vital.common.persistence.Page;
import com.hhwy.vital.common.utils.ConfigHelper;
import com.hhwy.vital.common.utils.DateUtils;
import com.hhwy.vital.common.utils.SpringContextHolder;
import com.hhwy.vital.common.utils.StringUtils;
import com.hhwy.vital.common.utils.excel.ExportExcel;
import com.hhwy.vital.common.utils.excel.ImportExcel;
import com.hhwy.vital.common.web.BaseController;
import com.hhwy.vital.modules.sys.entity.*;
import com.hhwy.vital.modules.sys.service.SystemService;
import com.hhwy.vital.modules.sys.service.TargetService;
import com.hhwy.vital.modules.sys.service.UserRoleService;
import com.hhwy.vital.modules.sys.utils.UserUtils;
import org.apache.shiro.authz.annotation.RequiresPermissions;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.ApplicationContext;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.validation.ConstraintViolationException;
import java.util.*;

/**
 * 用户Controller
 * @author zbx
 * @version 2013-8-29
 */
@Controller
@RequestMapping(value = "${adminPath}/sys/user")
public class VitalUserController extends BaseController {

	@Autowired
	private SystemService systemService;
	@Autowired
	private TargetService targetService;
	@Autowired
	private UserRoleService userRoleService;
	
	@ModelAttribute
	public User get(@RequestParam(required=false) String id) {
		if (StringUtils.isNotBlank(id)){
			User user = systemService.getUser(id);
			return user;
		}else{
			return new User();
		}
	}

	@RequiresPermissions("sys_user_view")
	@RequestMapping(value = {"index"})
	public String index(User user, Model model) {
		return "/view/vital/modules/sys/userIndex";
	}

	@RequiresPermissions("sys_user_view")
	@RequestMapping(value = {"list", ""})
	public String list(User user, HttpServletRequest request, HttpServletResponse response, Model model) {
		Page<User> page = systemService.findUser(new Page<User>(request, response), user);
        model.addAttribute("page", page);
		model.addAttribute("currentUser", UserUtils.getUser());

		System.out.println(ConfigHelper.getConfig("sys.user.organization"));

		return "/view/vital/modules/sys/userList";
	}
	
	@ResponseBody
	@RequiresPermissions("sys_user_view")
	@RequestMapping(value = {"listData"})
	public Page<User> listData(User user, HttpServletRequest request, HttpServletResponse response, Model model) {
		Page<User> page = systemService.findUser(new Page<User>(request, response), user);
		return page;
	}

	@RequiresPermissions("sys_user_view")
	@RequestMapping(value = "form")
	public String form(User user, Model model) {

		if (user.getOffice()==null || user.getOffice().getId()==null){
			user.setOffice(UserUtils.getUser().getOffice());
		}
		model.addAttribute("user", user);
		model.addAttribute("allRoles", systemService.findAllRole());
		return "/view/vital/modules/sys/userForm";
	}

	@RequiresPermissions("sys_user_edit")
	@RequestMapping(value = "save")
	public String save(User user, HttpServletRequest request, Model model, RedirectAttributes redirectAttributes) {

		user.setOffice(new Office(request.getParameter("office.id")));

		// 如果新密码为空，则不更换密码
		if (StringUtils.isNotBlank(user.getNewPassword())) {
			user.setPassword(SystemService.entryptPassword(user.getNewPassword()));
		}

		if (!beanValidator(model, user)){
			return form(user, model);
		}
		if (!"true".equals(checkLoginName(user.getOldLoginName(), user.getLoginName()))){
			addMessage(model, "保存用户'" + user.getLoginName() + "'失败，登录名已存在");
			return form(user, model);
		}
		// 角色数据有效性验证，过滤不在授权内的角色
		List<Role> roleList = Lists.newArrayList();
		List<String> roleIdList = user.getRoleIdList();
		for (Role r : systemService.findAllRole()){
			if (roleIdList.contains(r.getId())){
				roleList.add(r);
			}
		}
		user.setRoleList(roleList);
		// 保存用户信息
		systemService.saveUser(user);
		// 清除当前用户缓存
		if (user.getLoginName().equals(UserUtils.getUser().getLoginName())){
			UserUtils.clearCache();
			//UserUtils.getCacheMap().clear();
		}
		addMessage(redirectAttributes, "保存用户'" + user.getLoginName() + "'成功");
		return "redirect:" + adminPath + "/sys/user/list?repage";
	}
	
	@RequiresPermissions("sys_user_edit")
	@RequestMapping(value = "delete")
	public String delete(User user, RedirectAttributes redirectAttributes) {
		if (UserUtils.getUser().getId().equals(user.getId())){
			addMessage(redirectAttributes, "删除用户失败, 不允许删除当前用户");
		}else if (User.isAdmin(user.getId())){
			addMessage(redirectAttributes, "删除用户失败, 不允许删除超级管理员用户");
		}else{
			systemService.deleteUser(user);
			addMessage(redirectAttributes, "删除用户成功");
		}
		return "redirect:" + adminPath + "/sys/user/list?repage";
	}
	
	/**
	 * 导出用户数据
	 * @param user
	 * @param request
	 * @param response
	 * @param redirectAttributes
	 * @return
	 */
	@RequiresPermissions("sys_user_view")
    @RequestMapping(value = "export", method=RequestMethod.POST)
    public String exportFile(User user, HttpServletRequest request, HttpServletResponse response, RedirectAttributes redirectAttributes) {
		try {
            String fileName = "用户数据"+ DateUtils.getDate("yyyyMMddHHmmss")+".xlsx";
            Page<User> page = systemService.findUser(new Page<User>(request, response, -1), user);
    		new ExportExcel("用户数据", User.class).setDataList(page.getList()).write(response, fileName).dispose();
    		return null;
		} catch (Exception e) {
			addMessage(redirectAttributes, "导出用户失败！失败信息："+e.getMessage());
		}
		return "redirect:" + adminPath + "/sys/user/list?repage";
    }

	/**
	 * 导入用户数据
	 * @param file
	 * @param redirectAttributes
	 * @return
	 */
	@RequiresPermissions("sys_user_edit")
    @RequestMapping(value = "import", method=RequestMethod.POST)
    public String importFile(MultipartFile file, RedirectAttributes redirectAttributes) {
		try {
			int successNum = 0;
			int failureNum = 0;
			StringBuilder failureMsg = new StringBuilder();
			ImportExcel ei = new ImportExcel(file, 1, 0);
			List<User> list = ei.getDataList(User.class);
			for (User user : list){
				try{
					if ("true".equals(checkLoginName("", user.getLoginName()))){
						user.setPassword(SystemService.entryptPassword("123456"));
						BeanValidators.validateWithException(validator, user);
						systemService.saveUser(user);
						successNum++;
					}else{
						failureMsg.append("<br/>登录名 "+user.getLoginName()+" 已存在; ");
						failureNum++;
					}
				}catch(ConstraintViolationException ex){
					failureMsg.append("<br/>登录名 "+user.getLoginName()+" 导入失败：");
					List<String> messageList = BeanValidators.extractPropertyAndMessageAsList(ex, ": ");
					for (String message : messageList){
						failureMsg.append(message+"; ");
						failureNum++;
					}
				}catch (Exception ex) {
					failureMsg.append("<br/>登录名 "+user.getLoginName()+" 导入失败："+ex.getMessage());
				}
			}
			if (failureNum>0){
				failureMsg.insert(0, "，失败 "+failureNum+" 条用户，导入信息如下：");
			}
			addMessage(redirectAttributes, "已成功导入 "+successNum+" 条用户"+failureMsg);
		} catch (Exception e) {
			addMessage(redirectAttributes, "导入用户失败！失败信息："+e.getMessage());
		}
		return "redirect:" + adminPath + "/sys/user/list?repage";
    }
	
	/**
	 * 下载导入用户数据模板
	 * @param response
	 * @param redirectAttributes
	 * @return
	 */
	@RequiresPermissions("sys_user_view")
    @RequestMapping(value = "import/template")
    public String importFileTemplate(HttpServletResponse response, RedirectAttributes redirectAttributes) {
		try {
            String fileName = "用户数据导入模板.xlsx";
    		List<User> list = Lists.newArrayList(); list.add(UserUtils.getUser());
    		new ExportExcel("用户数据", User.class, 2).setDataList(list).write(response, fileName).dispose();
    		return null;
		} catch (Exception e) {
			addMessage(redirectAttributes, "导入模板下载失败！失败信息："+e.getMessage());
		}
		return "redirect:" + adminPath + "/sys/user/list?repage";
    }

	/**
	 * 验证登录名是否有效
	 * @param oldLoginName
	 * @param loginName
	 * @return
	 */
	@ResponseBody
	@RequiresPermissions("sys_user_edit")
	@RequestMapping(value = "checkLoginName")
	public String checkLoginName(String oldLoginName, String loginName) {
		if (loginName !=null && loginName.equals(oldLoginName)) {
			return "true";
		} else if (loginName !=null && systemService.getUserByLoginName(loginName) == null) {
			return "true";
		}
		return "false";
	}

	/**
	 * 用户信息显示及保存
	 * @param user
	 * @param model
	 * @return
	 */
	@RequiresPermissions("user")
	@RequestMapping(value = "info")
	public String info(User user, HttpServletResponse response, Model model) {
		User currentUser = UserUtils.getUser();
		if (StringUtils.isNotBlank(user.getRealName())){
			currentUser.setEmail(user.getEmail());
			currentUser.setMobile(user.getMobile());
			currentUser.setDescription(user.getDescription());
			currentUser.setAvatar(user.getAvatar());
			systemService.updateUserInfo(currentUser);
			model.addAttribute("message", "保存用户信息成功");
		}
		model.addAttribute("user", currentUser);
		model.addAttribute("Global", new Global());
		return "/view/vital/modules/sys/userInfo";
	}

	/**
	 * 返回用户信息
	 * @return
	 */
	@RequiresPermissions("user")
	@ResponseBody
	@RequestMapping(value = "infoData")
	public User infoData() {
		return UserUtils.getUser();
	}

	/**
	 * 修改个人用户密码
	 * @param oldPassword
	 * @param newPassword
	 * @param model
	 * @return
	 */
	@RequiresPermissions("user")
	@RequestMapping(value = "modifyPwd")
	public String modifyPwd(String oldPassword, String newPassword, Model model) {
		User user = UserUtils.getUser();
		if (StringUtils.isNotBlank(oldPassword) && StringUtils.isNotBlank(newPassword)){
			if (SystemService.validatePassword(oldPassword, user.getPassword())){
				systemService.updatePasswordById(user.getId(), user.getLoginName(), newPassword);
				model.addAttribute("message", "修改密码成功");
			}else{
				model.addAttribute("message", "修改密码失败，旧密码错误");
			}
		}
		model.addAttribute("user", user);
		return "/view/vital/modules/sys/userModifyPwd";
	}

	/**
	 * 登录时修改个人用户密码
	 * @param oldPassword
	 * @param newPassword
	 * @param model
	 * @return
	 */
	@RequiresPermissions("user")
	@RequestMapping(value = "loginModifyPwd")
	public String loginModifyPwd(String oldPassword, String newPassword, Model model) {
		User user = UserUtils.getUser();
		if (StringUtils.isNotBlank(oldPassword) && StringUtils.isNotBlank(newPassword)){
			if (SystemService.validatePassword(oldPassword, user.getPassword())){
				systemService.updatePasswordById(user.getId(), user.getLoginName(), newPassword,0);
				model.addAttribute("message", "修改密码成功");
				return "redirect:" + adminPath+"/logout";
			}else{
				model.addAttribute("message", "修改密码失败，旧密码错误");
			}
		}
		model.addAttribute("user", user);
		return "/view/vital/modules/sys/loginModifyPwd";
	}
	/**
	 * 修改个人用户密码
	 * @param oldPassword
	 * @param newPassword
	 * @param model
	 * @return
	 */
	@RequiresPermissions("user")
	@RequestMapping(value = "modifyPwd2Page")
	public String modifyPwd2Page(String oldPassword, String newPassword, Model model) {
		User user = UserUtils.getUser();
		if (StringUtils.isNotBlank(oldPassword) && StringUtils.isNotBlank(newPassword)){
			if (SystemService.validatePassword(oldPassword, user.getPassword())){
				systemService.updatePasswordById(user.getId(), user.getLoginName(), newPassword);
				model.addAttribute("message", "修改密码成功");
			}else{
				model.addAttribute("message", "修改密码失败，旧密码错误");
			}
		}
		model.addAttribute("user", user);
		return "/view/vital/modules/sys/userModifyPwd2";
	}
	/**
	 * 修改个人用户密码
	 * @param newPassword
	 * @param model
	 * @return
	 */
	@RequiresPermissions("user")
	@ResponseBody
	@RequestMapping(value = "modifyPwd2")
	public String modifyPwd2(User user, String newPassword, Model model) {
		if ( StringUtils.isNotBlank(newPassword)){
			systemService.updatePasswordById(user.getId(), user.getLoginName(), newPassword);
			return "true";
		}
		return "输入错误!";
	}
	
	@RequiresPermissions("user")
	@ResponseBody
	@RequestMapping(value = "treeData")
	public List<Map<String, Object>> treeData(@RequestParam(required=false) String officeId, HttpServletResponse response) {
		List<Map<String, Object>> mapList = Lists.newArrayList();
		List<User> list = systemService.findUserByOfficeId(officeId);
		for (int i=0; i<list.size(); i++){
			User e = list.get(i);
			Map<String, Object> map = Maps.newHashMap();
			map.put("id", "u_"+e.getId());
			map.put("pId", officeId);
			map.put("name", StringUtils.replace(e.getRealName(), " ", ""));
			mapList.add(map);
		}
		return mapList;
	}

	/**
	 * 用户授权 -- 打开授权页面
	 * @param user
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "userAuthorize")
	public String userAuthorize(User user, Model model) {
		model.addAttribute("user", user);
		//实例
		List<Target> targetList = targetService.findAllList();
		model.addAttribute("targetList",targetList);
		//角色
		List<Role> roleList = systemService.findAllRole();
		Map<String, List<Role>> roleMap = new HashMap<String, List<Role>>();
		for (Role role : roleList) {
			List<Role> roles = roleMap.get(role.getDomainId());
			if (roles == null) {
				roles= new ArrayList<Role>();
				roleMap.put(role.getDomainId(), roles);
			}
			roles.add(role);
		}
		model.addAttribute("roleMap",roleMap);
		//领域
		List<Domain> domainList = systemService.getDomainDao().findList(new Domain());
		model.addAttribute("domainList",domainList);
		Map<String, List<Target>> targetMap = getTargetMap(targetList);
		model.addAttribute("targetMap", targetMap);
		return "/view/vital/modules/sys/userAuthorize";
	}



	/**
	 * 用户授权 --查看授权页面
	 * @param user
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "userShowAuthorize")
	public String userShowAuthorize(User user, Model model) {
		model.addAttribute("user",user);
		model.addAttribute("menuList", systemService.findAllMenu(new Menu()));
		//所有领域
		List<Domain> domainList = systemService.getDomainDao().findAllList(new Domain());
		model.addAttribute("domainList",domainList);
		//根据领域分类实例
		List<Target> targetList = targetService.findAllList();
		Map<String, List<Target>> targetMap = new HashMap<String, List<Target>>();
		for (Target target : targetList) {
			List list = targetMap.get(target.getDomainId());
			if (list == null) {
				list = new ArrayList();
				targetMap.put(target.getDomainId(), list);
			}
			list.add(target);
		}
		model.addAttribute("targetMap", targetMap);
		model.addAttribute("id", "");

		return "/view/vital/modules/sys/userShowAuthorize";
	}

	@RequiresPermissions("user")
	@ResponseBody
	@RequestMapping(value = "allSelectMenu")
	public Map<String, List<Menu>>  allSelectMenu(@RequestParam(required=false) String userId, HttpServletResponse response) {
		Menu menu = new Menu();
		menu.setUserId(userId);
		List<Menu> selectMenuList = systemService.getMenuDao().findAllSelectMenu(menu);
		Map<String, List<Menu>> menuTargetMap = new HashMap<String, List<Menu>>();
		for (Menu menu1 : selectMenuList) {
			List list = menuTargetMap.get(menu1.getTargetId());
			if (list == null) {
				list = new ArrayList();
				menuTargetMap.put(menu1.getTargetId(), list);
			}
			list.add(menu1);
		}
		menuTargetMap.remove(null);

		//对选中的菜单排序
		for (String key : menuTargetMap.keySet()) {
			List list = menuTargetMap.get(key);
			List sortList=Menu.sortList(list,Menu.getRootId(),true);
			menuTargetMap.put(key, sortList);
		}

		return menuTargetMap;
	}


	@RequiresPermissions("user")
	@ResponseBody
	@RequestMapping(value = "userRoleData")
	public Map<String, List> userRoleData(@RequestParam(required=false) String userId, HttpServletResponse response) {
		//获取授权信息
		UserRole userRole=new UserRole();
		userRole.setUser(new User(userId));
		List<UserRole> userRoleList = userRoleService.findList(userRole);
		Map<String,List> userRoleMap=new HashMap<String,List>();
		for (UserRole userRole1 : userRoleList) {
			List list = userRoleMap.get(userRole1.getTargetId());
			if (list==null){
				list=new ArrayList();
				userRoleMap.put(userRole1.getTargetId(), list);
			}
			list.add(userRole1.getRoleId());
		}
		userRoleMap.remove(null);
		return userRoleMap;
	}
	@RequiresPermissions("user")
	@ResponseBody
	@RequestMapping(value = "userRoleDataByTarget")
	public Map<String, List> userRoleDataByTarget(@RequestParam(required=false) String targetId, HttpServletResponse response) {
		//获取授权信息
		UserRole userRole=new UserRole();
		userRole.setTargetId(targetId);
		List<UserRole> userRoleList = userRoleService.getUserRoleDao().findByTarget(userRole);
		Map<String,List> userRoleMap=new HashMap<String,List>();
		for (UserRole userRole1 : userRoleList) {
			List list = userRoleMap.get(userRole1.getRoleId());
			if (list==null){
				list=new ArrayList();
				userRoleMap.put(userRole1.getRoleId(), list);
			}
			list.add(userRole1.getUser().getId());
		}
		userRoleMap.remove(null);
		return userRoleMap;
	}
	@RequiresPermissions("user")
	@ResponseBody
	@RequestMapping(value = "userRoleDataByRole")
	public Map<String, List> userRoleDataByRole(@RequestParam(required=false) String roleId, HttpServletResponse response) {
		//获取授权信息
		UserRole userRole=new UserRole();
		userRole.setRoleId(roleId);
		List<UserRole> userRoleList = userRoleService.getUserRoleDao().findByRole(userRole);
		Map<String,List> userRoleMap=new HashMap<String,List>();
		for (UserRole userRole1 : userRoleList) {
			List list = userRoleMap.get(userRole1.getTargetId());
			if (list==null){
				list=new ArrayList();
				userRoleMap.put(userRole1.getTargetId(), list);
			}
			list.add(userRole1.getUser().getId());
		}
		userRoleMap.remove(null);
		return userRoleMap;
	}
	@RequiresPermissions("user")
	@ResponseBody
	@RequestMapping(value = "selectSystemRoleData")
	public List selectSystemRoleData(@RequestParam(required=false) String userId, HttpServletResponse response) {
		//获取系统领域的授权信息
		UserRole userRole=new UserRole();
		userRole.setUser(new User(userId));
		userRole.setTargetId("1");
		List<UserRole> userRoleList = userRoleService.getUserRoleDao().findSystemList();
		List selectSystemRoleData = new ArrayList();
		for (UserRole userRole1 : userRoleList) {
			selectSystemRoleData.add(userRole1);
		}
		return selectSystemRoleData;
	}
	/**
	 * 保存权限
	 * @param user
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "saveAuthorize")
	public String saveAuthorize(User user, Model model,String target_roles,String systemDomainIds) {
		model.addAttribute("user", user);
		//保存实例与角色的对应关系
		userRoleService.save(user,target_roles,systemDomainIds);
		return "redirect:" + adminPath + "/sys/user/list?repage";
	}

	@RequiresPermissions("sys_user_view")
	@ResponseBody
	@RequestMapping(value = "lock")
	public String lock(User user, Model model) {
		user.setIsdisabled(1);
		systemService.getUserDao().lockUserInfo(user);
		return "true";
	}
	@RequiresPermissions("sys_user_view")
	@ResponseBody
	@RequestMapping(value = "unlock")
	public String unlock(User user, Model model) {
		user.setIsdisabled(0);
		systemService.getUserDao().lockUserInfo(user);
		return "true";
	}

	/**
	 * 将实例按领域分类
	 * @param targetList
	 * @return
	 */
	private Map<String, List<Target>> getTargetMap(List<Target> targetList) {
		//实例
		Map<String, List<Target>> targetMap = new HashMap<String, List<Target>>();
		for (Target target : targetList) {
			List<Target> list = targetMap.get(target.getDomainId());
			if (list==null){
				list = new ArrayList<Target>();
				targetMap.put(target.getDomainId(), list);
			}
			list.add(target);
		}
		return targetMap;
	}
    

}
