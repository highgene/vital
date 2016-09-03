/**
 * Copyright &copy; 2012-2014 <a href="http://www.haijintech.com">HaiJinTech</a> All rights reserved.
 */
package com.hhwy.vital.modules.sys.web;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.hhwy.vital.common.config.Global;
import com.hhwy.vital.common.persistence.Page;
import com.hhwy.vital.common.utils.StringUtils;
import com.hhwy.vital.common.web.BaseController;
import com.hhwy.vital.modules.sys.entity.Domain;
import com.hhwy.vital.modules.sys.service.DomainService;
import org.apache.shiro.authz.annotation.RequiresPermissions;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

/**
 * 授权领域Controller
 * @author zbx
 * @version 2016-06-30
 */
@Controller
@RequestMapping(value = "${adminPath}/sys/domain")
public class DomainController extends BaseController {

	@Autowired
	private DomainService domainService;
	
	@ModelAttribute
	public Domain get(@RequestParam(required=false) String id) {
		Domain entity = null;
		if (StringUtils.isNotBlank(id)){
			entity = domainService.get(id);
		}
		if (entity == null){
			entity = new Domain();
		}
		return entity;
	}
	
	@RequiresPermissions("sys_domain_view")
	@RequestMapping(value = {"list", ""})
	public String list(Domain domain, HttpServletRequest request, HttpServletResponse response, Model model) {
		Page<Domain> page = domainService.findPage(new Page<Domain>(request, response), domain);
		model.addAttribute("page", page);
		return "/view/vital/modules/sys/domainList";
	}

	@RequiresPermissions("sys_domain_view")
	@RequestMapping(value = "form")
	public String form(Domain domain, Model model) {
		model.addAttribute("domain", domain);
		return "/view/vital/modules/sys/domainForm";
	}

	@RequiresPermissions("sys_domain_edit")
	@RequestMapping(value = "save")
	public String save(Domain domain, Model model, RedirectAttributes redirectAttributes) {
		if (!beanValidator(model, domain)){
			return form(domain, model);
		}
		domainService.save(domain);
		addMessage(redirectAttributes, "保存授权领域成功");
		return "redirect:"+ Global.getAdminPath()+"/sys/domain/?repage";
	}
	
	@RequiresPermissions("sys_domain_edit")
	@RequestMapping(value = "delete")
	public String delete(Domain domain, RedirectAttributes redirectAttributes) {
		domainService.delete(domain);
		addMessage(redirectAttributes, "删除授权领域成功");
		return "redirect:"+Global.getAdminPath()+"/sys/domain/?repage";
	}

}