/**
 * Copyright &copy; 2012-2014 <a href="http://www.haijintech.com">HaiJinTech</a> All rights reserved.
 */
package com.hhwy.vital.modules.demo.web;

import com.hhwy.vital.common.config.Global;
import com.hhwy.vital.common.persistence.Page;
import com.hhwy.vital.common.utils.StringUtils;
import com.hhwy.vital.common.web.BaseController;
import com.hhwy.vital.modules.demo.entity.Project;
import com.hhwy.vital.modules.demo.entity.ProjectDesc;
import com.hhwy.vital.modules.demo.service.ProjectDescService;
import com.hhwy.vital.modules.demo.service.ProjectService;
import org.apache.shiro.authz.annotation.RequiresPermissions;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.List;

/**
 * 工程描述Controller
 * @author zbx
 * @version 2016-08-14
 */
@Controller
@RequestMapping(value = "${adminPath}/demo/projectDesc")
public class ProjectDescController extends BaseController {

	@Autowired
	private ProjectDescService projectDescService;
	@Autowired
	private ProjectService projectService;
	
	@ModelAttribute
	public ProjectDesc get(@RequestParam(required=false) String id) {
		ProjectDesc entity = null;
		if (StringUtils.isNotBlank(id)){
			entity = projectDescService.get(id);
		}
		if (entity == null){
			entity = new ProjectDesc();
		}
		return entity;
	}
	
	@RequiresPermissions("demo_projectDesc_view")
	@RequestMapping(value = {"list", ""})
	public String list(ProjectDesc projectDesc, HttpServletRequest request, HttpServletResponse response, Model model) {
		List<Project> projectList = projectService.getDao().findAllList();
		model.addAttribute("projectList", projectList);
		if (StringUtils.isEmpty(projectDesc.getProjectId())) {
			if (projectList != null && projectList.size() > 0) {
				projectDesc.setProjectId(projectList.get(0).getId());
			}
		}
		model.addAttribute("projectDesc", projectDesc);
		model.addAttribute("projectId", projectDesc.getProjectId());
		Page<ProjectDesc> page = projectDescService.findPage(new Page<ProjectDesc>(request, response), projectDesc); 
		model.addAttribute("page", page);

		return "/view/vital/modules/demo/projectDescList";
	}

	@RequiresPermissions("demo_projectDesc_view")
	@RequestMapping(value = "form")
	public String form(ProjectDesc projectDesc, Model model) {
		model.addAttribute("projectDesc", projectDesc);
		List<Project> projectList = projectService.getDao().findAllList();
		model.addAttribute("projectList", projectList);
		return "/view/vital/modules/demo/projectDescForm";
	}

	@RequiresPermissions("demo_projectDesc_edit")
	@RequestMapping(value = "save")
	public String save(ProjectDesc projectDesc, Model model, RedirectAttributes redirectAttributes) {
		if (!beanValidator(model, projectDesc)){
			return form(projectDesc, model);
		}
		projectDescService.save(projectDesc);
		addMessage(redirectAttributes, "保存工程描述成功");
		return "redirect:"+Global.getAdminPath()+"/demo/projectDesc/?repage";
	}
	
	@RequiresPermissions("demo_projectDesc_edit")
	@RequestMapping(value = "delete")
	public String delete(ProjectDesc projectDesc, RedirectAttributes redirectAttributes) {
		projectDescService.delete(projectDesc);
		addMessage(redirectAttributes, "删除工程描述成功");
		return "redirect:"+Global.getAdminPath()+"/demo/projectDesc/?repage";
	}

}