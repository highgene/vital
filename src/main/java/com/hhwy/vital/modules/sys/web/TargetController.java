/**
 * Copyright &copy; 2012-2014 <a href="http://www.haijintech.com">HaiJinTech</a> All rights reserved.
 */
package com.hhwy.vital.modules.sys.web;

import com.hhwy.vital.common.config.Global;
import com.hhwy.vital.common.persistence.Page;
import com.hhwy.vital.common.utils.StringUtils;
import com.hhwy.vital.common.web.BaseController;
import com.hhwy.vital.modules.sys.entity.Office;
import com.hhwy.vital.modules.sys.entity.Target;
import com.hhwy.vital.modules.sys.service.OfficeService;
import com.hhwy.vital.modules.sys.service.SystemService;
import com.hhwy.vital.modules.sys.service.TargetService;
import com.hhwy.vital.modules.sys.service.UserRoleService;
import com.hhwy.vital.modules.sys.entity.Domain;
import com.hhwy.vital.modules.sys.entity.Role;
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
import java.util.UUID;

/**
 * 授权实例Controller
 *
 * @author zbx
 * @version 2016-07-01
 */
@Controller
@RequestMapping(value = "${adminPath}/sys/target")
public class TargetController extends BaseController {

    @Autowired
    private TargetService targetService;
    @Autowired
    private SystemService systemService;
    @Autowired
    private UserRoleService userRoleService;
    @Autowired
    private OfficeService officeService;


    @ModelAttribute
    public Target get(@RequestParam(required = false) String id) {
        Target entity = null;
        if (StringUtils.isNotBlank(id)) {
            entity = targetService.get(id);
        }
        if (entity == null) {
            entity = new Target();
        }
        return entity;
    }

    @RequiresPermissions("sys_target_view")
    @RequestMapping(value = {"list", ""})
    public String list(Target target, HttpServletRequest request, HttpServletResponse response, Model model) {
        //领域
        List<Domain> domainList = systemService.getDomainDao().findAllList(new Domain());
        model.addAttribute("domainList", domainList);
        if (target == null || StringUtils.isEmpty(target.getDomainId())) {
            target=new Target();
            target.setDomainId(domainList.get(0).getId());
        }

        Page<Target> page = targetService.findPage(new Page<Target>(request, response), target);
        model.addAttribute("page", page);
        return "/view/vital/modules/sys/targetList";
    }

    @RequiresPermissions("sys_target_view")
    @RequestMapping(value = "form")
    public String form(Target target, Model model) {
        if (StringUtils.isEmpty(target.getId())) {
            target.setObjectCode(UUID.randomUUID().toString().substring(0,8));
        }
        model.addAttribute("target", target);
        //领域
        List<Domain> domainList = systemService.getDomainDao().findAllList(new Domain());
        for (int i=domainList.size()-1;i>=0;i--){
            Domain domain = domainList.get(i);
            if (domain.getEnableMulti()==0){
                domainList.remove(i);
            }
        }
        model.addAttribute("domainList", domainList);
        return "/view/vital/modules/sys/targetForm";
    }

    @RequiresPermissions("sys_target_edit")
    @RequestMapping(value = "save")
    public String save(Target target, Model model, RedirectAttributes redirectAttributes) {
        if (!beanValidator(model, target)) {
            return form(target, model);
        }
        targetService.save(target);
        addMessage(redirectAttributes, "保存实例成功");
        return "redirect:" + Global.getAdminPath() + "/sys/target/?repage&domainId="+target.getDomainId();
    }

    @RequiresPermissions("sys_target_edit")
    @RequestMapping(value = "delete")
    public String delete(Target target, RedirectAttributes redirectAttributes) {
        targetService.delete(target);
        addMessage(redirectAttributes, "删除授权实例成功");
        return "redirect:" + Global.getAdminPath() + "/sys/target/?repage&domainId="+target.getDomainId();
    }


    /**
     * 给实例授权
     *
     * @param target
     * @param model
     * @return
     */
    @RequiresPermissions("sys_target_edit")
    @RequestMapping(value = "targetAuthorize")
    public String targetAuthorize(Target target, Model model) {
        model.addAttribute("target", target);
        Role role = new Role();
        if (target != null) {
            role.setDomainId(target.getDomainId());
        }
        List<Role> allList = systemService.getRoleDao().findAllList(role);
        model.addAttribute("roleList", allList);
        model.addAttribute("userList", systemService.getUserDao().findAllList());
        return "/view/vital/modules/sys/targetAuthorize";
    }

    /**
     * 保存权限
     *
     * @param target
     * @param model
     * @return
     */
    @RequestMapping(value = "saveAuthorize")
    public String saveAuthorize(Target target, Model model, String role_users) {
        model.addAttribute("target", target);
        //保存角色与用户的对应关系
        userRoleService.saveRoleUser(target, role_users);
        return "redirect:" + adminPath + "/sys/target/list?repage&domainId="+target.getDomainId();
    }

    /**
     * 根据实例查询组织机构
     *
     * @param office
     * @param model
     * @return
     */
    @RequiresPermissions("sys_target_view")
    @RequestMapping(value = {"office_list"})
    public String office_list(Office office, Model model) {
        List<Office> list = systemService.getOfficeDao().findListByTarget(office);
        model.addAttribute("target", targetService.get(office.getTargetId()));
        model.addAttribute("list", list);
        model.addAttribute("office", office);
        return "/view/vital/modules/sys/target_officeList";
    }

    @RequiresPermissions("sys_target_view")
    @RequestMapping(value = "office_form")
    public String office_form(Office office, Model model, String parentId, String targetId) {
        //新增分两种:
        //1.新增
        //2.添加下级
        office=officeService.get(office);
        if (office==null){
            office = new Office();
        }
        Office parent = null;
        if (!StringUtils.isEmpty(parentId)) {
            parent = officeService.get(parentId);
            office.setParent(parent);
            office.setTargetId(parent.getTargetId());
        }
        if (!StringUtils.isEmpty(targetId)) {
            office.setTargetId(targetId);
        }
        if(office.getParent()!=null&&!StringUtils.isEmpty(office.getParent().getId())){
            office.setParent(officeService.get(office.getParent().getId()));
        }

        model.addAttribute("office", office);
        model.addAttribute("target", targetService.get(office.getTargetId()));
        return "/view/vital/modules/sys/target_officeForm";
    }
    @RequiresPermissions("sys_target_edit")
    @RequestMapping(value = "office_delete")
    public String office_delete(Office office, RedirectAttributes redirectAttributes) {
        office=officeService.get(office);
        officeService.delete(office);
        addMessage(redirectAttributes, "删除机构成功");

        return "redirect:" + adminPath + "/sys/target/office_list?targetId="+office.getTargetId();
    }

}