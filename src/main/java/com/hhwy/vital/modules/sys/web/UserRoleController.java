/**
 * Copyright &copy; 2012-2014 <a href="http://www.haijintech.com">HaiJinTech</a> All rights reserved.
 */
package com.hhwy.vital.modules.sys.web;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.shiro.authz.annotation.RequiresPermissions;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.hhwy.vital.common.config.Global;
import com.hhwy.vital.common.persistence.Page;
import com.hhwy.vital.common.web.BaseController;
import com.hhwy.vital.common.utils.StringUtils;
import com.hhwy.vital.modules.sys.entity.UserRole;
import com.hhwy.vital.modules.sys.service.UserRoleService;

/**
 * 用户权限Controller
 * @author zbx
 * @version 2016-07-10
 */
@Controller
@RequestMapping(value = "${adminPath}/sys/userRole")
public class UserRoleController extends BaseController {

	@Autowired
	private UserRoleService userRoleService;
	
	@ModelAttribute
	public UserRole get(@RequestParam(required=false) String id) {
		UserRole entity = null;
		if (StringUtils.isNotBlank(id)){
			entity = userRoleService.get(id);
		}
		if (entity == null){
			entity = new UserRole();
		}
		return entity;
	}
	
	@RequiresPermissions("sys:userRole:view")
	@RequestMapping(value = {"list", ""})
	public String list(UserRole userRole, HttpServletRequest request, HttpServletResponse response, Model model) {
		Page<UserRole> page = userRoleService.findPage(new Page<UserRole>(request, response), userRole); 
		model.addAttribute("page", page);
		return "/view/vital/modules/sys/userRoleList";
	}

	@RequiresPermissions("sys:userRole:view")
	@RequestMapping(value = "form")
	public String form(UserRole userRole, Model model) {
		model.addAttribute("userRole", userRole);
		return "/view/vital/modules/sys/userRoleForm";
	}

	@RequiresPermissions("sys:userRole:edit")
	@RequestMapping(value = "save")
	public String save(UserRole userRole, Model model, RedirectAttributes redirectAttributes) {
		if (!beanValidator(model, userRole)){
			return form(userRole, model);
		}
		userRoleService.save(userRole);
		addMessage(redirectAttributes, "保存用户权限成功");
		return "redirect:"+Global.getAdminPath()+"/sys/userRole/?repage";
	}
	
	@RequiresPermissions("sys:userRole:edit")
	@RequestMapping(value = "delete")
	public String delete(UserRole userRole, RedirectAttributes redirectAttributes) {
		userRoleService.delete(userRole);
		addMessage(redirectAttributes, "删除用户权限成功");
		return "redirect:"+Global.getAdminPath()+"/sys/userRole/?repage";
	}

}