/**
 * Copyright &copy; 2012-2014 <a href="http://www.haijintech.com">HaiJinTech</a> All rights reserved.
 */
package com.hhwy.vital.modules.sys.web;

import com.google.common.collect.Lists;
import com.google.common.collect.Maps;
import com.hhwy.vital.modules.sys.entity.*;
import com.hhwy.vital.modules.sys.utils.UserUtils;
import com.hhwy.vital.common.persistence.Page;
import com.hhwy.vital.common.utils.Collections3;
import com.hhwy.vital.common.utils.StringUtils;
import com.hhwy.vital.common.web.BaseController;
import com.hhwy.vital.modules.sys.service.OfficeService;
import com.hhwy.vital.modules.sys.service.RoleService;
import com.hhwy.vital.modules.sys.service.SystemService;
import com.hhwy.vital.modules.sys.service.UserRoleService;
import org.apache.shiro.authz.annotation.RequiresPermissions;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import javax.servlet.http.HttpServletResponse;
import java.util.List;
import java.util.Map;

/**
 * 角色Controller
 * @author zbx
 * @version 2013-12-05
 */
@Controller
@RequestMapping(value = "${adminPath}/sys/role")
public class RoleController extends BaseController {

	@Autowired
	private SystemService systemService;
	
	@Autowired
	private OfficeService officeService;

	@Autowired
	UserRoleService userRoleService;
	@Autowired
	RoleService roleService;
	
	@ModelAttribute("role")
	public Role get(@RequestParam(required=false) String id) {
		if (StringUtils.isNotBlank(id)){
			return systemService.getRole(id);
		}else{
			return new Role();
		}
	}
	
	@RequiresPermissions("sys_role_view")
	@RequestMapping(value = {"list", ""})
	public String list(Role role, Model model) {
		//领域
		List<Domain> domainList = systemService.getDomainDao().findAllList(new Domain());
		model.addAttribute("domainList", domainList);
		if (role == null || StringUtils.isEmpty(role.getDomainId())) {
			role=new Role();
			role.setDomainId(domainList.get(0).getId());
		}
		List<Role> list = systemService.getRoleDao().findAllList(role);
		model.addAttribute("list", list);

		return "/view/vital/modules/sys/roleList";
	}

	@RequiresPermissions("sys_role_view")
	@RequestMapping(value = "form")
	public String form(Role role, Model model) {

		model.addAttribute("role", role);
		model.addAttribute("menuList", systemService.findAllMenu(new Menu()));
		model.addAttribute("officeList", officeService.findAll());
        //领域
        model.addAttribute("domainList",systemService.getDomainDao().findAllList(new Domain()));
		//TAGS
		model.addAttribute("allTags", roleService.getAllTags());
		return "/view/vital/modules/sys/roleForm";
	}
	
	@RequiresPermissions("sys_role_edit")
	@RequestMapping(value = "save")
	public String save(Role role, Model model, RedirectAttributes redirectAttributes) {
		if(!UserUtils.getUser().isAdmin()){
			addMessage(redirectAttributes, "越权操作，只有超级管理员才能修改此数据！");
			return "redirect:" + adminPath + "/sys/role/?repage&domainId="+role.getDomainId();
		}
		if (!beanValidator(model, role)){
			return form(role, model);
		}
		if (!"true".equals(checkName(role.getOldName(), role.getRoleName()))){
			addMessage(model, "保存角色'" + role.getRoleName() + "'失败, 角色名已存在");
			return form(role, model);
		}
		if (!"true".equals(checkEnname(role.getOldEnname(), role.getRoleCode()))){
			addMessage(model, "保存角色'" + role.getRoleName() + "'失败, 英文名已存在");
			return form(role, model);
		}
		systemService.saveRole(role);
		addMessage(redirectAttributes, "保存角色'" + role.getRoleName() + "'成功");
		return "redirect:" + adminPath + "/sys/role/?repage&domainId="+role.getDomainId();
	}
	
	@RequiresPermissions("sys_role_edit")
	@RequestMapping(value = "delete")
	public String delete(Role role, RedirectAttributes redirectAttributes) {
		if(!UserUtils.getUser().isAdmin() ){
			addMessage(redirectAttributes, "越权操作，只有超级管理员才能修改此数据！");
			return "redirect:" + adminPath + "/sys/role/?repage&domainId="+role.getDomainId();
		}
		systemService.deleteRole(role);
		addMessage(redirectAttributes, "删除角色成功");
		return "redirect:" + adminPath + "/sys/role/?repage&domainId="+role.getDomainId();
	}
	
	/**
	 * 角色分配页面
	 * @param role
	 * @param model
	 * @return
	 */
	@RequiresPermissions("sys_role_edit")
	@RequestMapping(value = "assign")
	public String assign(Role role, Model model) {
		List<User> userList = systemService.findUser(new User(new Role(role.getId())));
		model.addAttribute("userList", userList);
		return "/view/vital/modules/sys/roleAssign";
	}
	
	/**
	 * 角色分配 -- 打开角色分配对话框
	 * @param role
	 * @param model
	 * @return
	 */
	@RequiresPermissions("sys_role_view")
	@RequestMapping(value = "usertorole")
	public String selectUserToRole(Role role, Model model) {
		List<User> userList = systemService.findUser(new User(new Role(role.getId())));
		model.addAttribute("role", role);
		model.addAttribute("userList", userList);
		model.addAttribute("selectIds", Collections3.extractToString(userList, "loginName", ","));
		model.addAttribute("officeList", officeService.findAll());
		return "/view/vital/modules/sys/selectUserToRole";
	}
	
	/**
	 * 角色分配 -- 根据部门编号获取用户列表
	 * @param officeId
	 * @param response
	 * @return
	 */
	@RequiresPermissions("sys_role_view")
	@ResponseBody
	@RequestMapping(value = "users")
	public List<Map<String, Object>> users(String officeId, HttpServletResponse response) {
		List<Map<String, Object>> mapList = Lists.newArrayList();
		User user = new User();
		user.setOffice(new Office(officeId));
		Page<User> page = systemService.findUser(new Page<User>(1, -1), user);
		for (User e : page.getList()) {
			Map<String, Object> map = Maps.newHashMap();
			map.put("id", e.getId());
			map.put("pId", 0);
			map.put("name", e.getLoginName());
			mapList.add(map);			
		}
		return mapList;
	}
	
	/**
	 * 角色分配 -- 从角色中移除用户
	 * @param userId
	 * @param roleId
	 * @param redirectAttributes
	 * @return
	 */
	@RequiresPermissions("sys_role_edit")
	@RequestMapping(value = "outrole")
	public String outrole(String userId, String roleId, RedirectAttributes redirectAttributes) {
		Role role = systemService.getRole(roleId);
		User user = systemService.getUser(userId);
		if (UserUtils.getUser().getId().equals(userId)) {
			addMessage(redirectAttributes, "无法从角色【" + role.getRoleName() + "】中移除用户【" + user.getRealName() + "】自己！");
		}else {
			if (user.getRoleList().size() <= 1){
				addMessage(redirectAttributes, "用户【" + user.getRealName() + "】从角色【" + role.getRoleName() + "】中移除失败！这已经是该用户的唯一角色，不能移除。");
			}else{
				Boolean flag = systemService.outUserInRole(role, user);
				if (!flag) {
					addMessage(redirectAttributes, "用户【" + user.getRealName() + "】从角色【" + role.getRoleName() + "】中移除失败！");
				}else {
					addMessage(redirectAttributes, "用户【" + user.getRealName() + "】从角色【" + role.getRoleName() + "】中移除成功！");
				}
			}		
		}
		return "redirect:" + adminPath + "/sys/role/assign?id="+role.getId();
	}
	
	/**
	 * 角色分配
	 * @param role
	 * @param idsArr
	 * @param redirectAttributes
	 * @return
	 */
	@RequiresPermissions("sys_role_edit")
	@RequestMapping(value = "assignrole")
	public String assignRole(Role role, String[] idsArr, RedirectAttributes redirectAttributes) {
		StringBuilder msg = new StringBuilder();
		int newNum = 0;
		for (int i = 0; i < idsArr.length; i++) {
			User user = systemService.assignUserToRole(role, systemService.getUser(idsArr[i]));
			if (null != user) {
				msg.append("<br/>新增用户【" + user.getRealName() + "】到角色【" + role.getRoleName() + "】！");
				newNum++;
			}
		}
		addMessage(redirectAttributes, "已成功分配 "+newNum+" 个用户"+msg);
		return "redirect:" + adminPath + "/sys/role/assign?id="+role.getId();
	}

	/**
	 * 验证角色名是否有效
	 * @param oldName
	 * @param name
	 * @return
	 */
	@RequiresPermissions("user")
	@ResponseBody
	@RequestMapping(value = "checkName")
	public String checkName(String oldName, String name) {
		if (name!=null && name.equals(oldName)) {
			return "true";
		} else if (name!=null && systemService.getRoleByName(name) == null) {
			return "true";
		}
		return "false";
	}

	/**
	 * 验证角色英文名是否有效
	 * @return
	 */
	@RequiresPermissions("user")
	@ResponseBody
	@RequestMapping(value = "checkEnname")
	public String checkEnname(String oldEnname, String roleCode) {
		if (roleCode!=null && roleCode.equals(oldEnname)) {
			return "true";
		} else if (roleCode!=null && systemService.getRoleByEnname(roleCode) == null) {
			return "true";
		}
		return "false";
	}


	/**
	 * 给角色授权
	 * @param role
	 * @param model
	 * @return
	 */
	@RequiresPermissions("sys_role_edit")
	@RequestMapping(value = "roleAuthorize")
	public String roleAuthorize(Role role, Model model) {
		model.addAttribute("role", role);
		Target target=new Target();
		target.setDomainId(role.getDomainId());
		model.addAttribute("targetList", systemService.getTargetDao().findList(target));
		model.addAttribute("userList",  systemService.getUserDao().findAllList());
		return "/view/vital/modules/sys/roleAuthorize";
	}

	/**
	 * 保存权限
	 * @param role
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "saveAuthorize")
	public String saveAuthorize(Role role, Model model, String target_users) {
		model.addAttribute("role", role);
		//保存角色与用户的对应关系
		userRoleService.saveTargetUser(role,target_users);
		return "redirect:" + adminPath + "/sys/role/list?repage&domainId="+role.getDomainId();
	}

	/**
	 * 角色分配资源
	 * @param role
	 * @param model
     * @return
     */
	@RequiresPermissions("sys_role_edit")
	@RequestMapping(value = "roleBindingResource")
	public String roleBindingResource(Role role, Model model) {
		model.addAttribute("role", role);
		Menu menu = new Menu();
		menu.setDomainId(role.getDomainId());
		model.addAttribute("menuList", systemService.getMenuDao().findList(menu));
		return "/view/vital/modules/sys/roleBindingResource";
	}

    /**
     * 角色分配资源
     * @param role
     * @param model
     * @return
     */
    @RequiresPermissions("sys_role_edit")
    @RequestMapping(value = "saveResource")
    public String saveResource(Role role, Model model) {
        model.addAttribute("role", role);
        systemService.updateResource(role);
        return "redirect:" + adminPath + "/sys/role/list?repage&domainId="+role.getDomainId();
    }

}
