/**
 * Copyright &copy; 2012-2014 <a href="http://www.haijintech.com">HaiJinTech</a> All rights reserved.
 */
package com.hhwy.vital.modules.demo.web;

import com.hhwy.vital.common.config.Global;
import com.hhwy.vital.common.persistence.Page;
import com.hhwy.vital.common.utils.StringUtils;
import com.hhwy.vital.common.web.BaseController;
import com.hhwy.vital.modules.demo.entity.Project;
import com.hhwy.vital.modules.demo.service.ProjectService;
import com.hhwy.vital.modules.sys.entity.Office;
import com.hhwy.vital.modules.sys.entity.User;
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

/**
 * 工程领域Controller
 *
 * @author zbx
 * @version 2016-08-07
 */
@Controller
@RequestMapping(value = "${adminPath}/demo/project")
public class ProjectController extends BaseController {

    @Autowired
    private ProjectService projectService;

    @ModelAttribute
    public Project get(@RequestParam(required = false) String id) {
        Project entity = null;
        if (StringUtils.isNotBlank(id)) {
            entity = projectService.get(id);
        }
        if (entity == null) {
            entity = new Project();
        }
        return entity;
    }

    @RequiresPermissions("demo_project_view")
    @RequestMapping(value = {"list", ""})
    public String list(Project project, HttpServletRequest request, HttpServletResponse response, Model model) {
        Page<Project> page = projectService.findPage(new Page<Project>(request, response), project);
        model.addAttribute("page", page);
        return "/view/vital/modules/demo/projectList";
    }

    @RequiresPermissions("demo_project_view")
    @RequestMapping(value = "form")
    public String form(Project project, Model model) {
        model.addAttribute("project", project);
        return "/view/vital/modules/demo/projectForm";
    }

    @RequiresPermissions("demo_project_edit")
    @RequestMapping(value = "save")
    public String save(Project project, Model model, RedirectAttributes redirectAttributes) {
        if (!beanValidator(model, project)) {
            return form(project, model);
        }
        projectService.save(project);
        addMessage(redirectAttributes, "保存工程领域成功");
        return "redirect:" + Global.getAdminPath() + "/demo/project/?repage";
    }

    @RequiresPermissions("demo_project_edit")
    @RequestMapping(value = "delete")
    public String delete(Project project, RedirectAttributes redirectAttributes) {
        projectService.delete(project);
        addMessage(redirectAttributes, "删除工程领域成功");
        return "redirect:" + Global.getAdminPath() + "/demo/project/?repage";
    }


    @RequiresPermissions("demo_project_view")
    @RequestMapping(value = "windows")
    public String windows(Project project, Model model) {
        model.addAttribute("office", new Office());
        model.addAttribute("user", new User());
        return "/view/vital/modules/demo/windowsDemo";
    }

}