/**
 * Copyright &copy; 2012-2014 <a href="http://www.haijintech.com">HaiJinTech</a> All rights reserved.
 */
package com.hhwy.vital.modules.sys.web;

import com.google.common.collect.Lists;
import com.google.common.collect.Maps;
import com.hhwy.vital.modules.sys.utils.UserUtils;
import com.hhwy.vital.common.utils.StringUtils;
import com.hhwy.vital.common.web.BaseController;
import com.hhwy.vital.modules.sys.entity.Domain;
import com.hhwy.vital.modules.sys.entity.Menu;
import com.hhwy.vital.modules.sys.service.SystemService;
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
 * 菜单Controller
 * @author zbx
 * @version 2013-3-23
 */
@Controller
@RequestMapping(value = "${adminPath}/sys/menu")
public class MenuController extends BaseController {

	@Autowired
	private SystemService systemService;
	
	@ModelAttribute("menu")
	public Menu get(@RequestParam(required=false) String id) {
		if (StringUtils.isNotBlank(id)){
			return systemService.getMenu(id);
		}else{
			return new Menu();
		}
	}

	@RequiresPermissions("sys_menu_view")
	@RequestMapping(value = {"list", ""})
	public String list(Menu menu,Model model) {
		//领域
		List<Domain> domainList = systemService.getDomainDao().findAllList(new Domain());
		model.addAttribute("domainList", domainList);
		model.addAttribute("menu", menu);

		List<Menu> list = Lists.newArrayList();
		List<Menu> sourcelist = systemService.findAllMenu(menu);
		Menu.sortList(list, sourcelist, Menu.getRootId(), true);
        model.addAttribute("list", list);
		return "/view/vital/modules/sys/menuList";
	}

	@RequiresPermissions("sys_menu_view")
	@RequestMapping(value = "form")
	public String form(Menu menu, Model model) {
		if (menu.getParent()==null||menu.getParent().getId()==null){
			menu.setParent(new Menu(Menu.getRootId()));
		}
		menu.setParent(systemService.getMenu(menu.getParent().getId()));
		// 获取排序号，最末节点排序号+30
		if (StringUtils.isBlank(menu.getId())){
			List<Menu> list = Lists.newArrayList();
			List<Menu> sourcelist = systemService.findAllMenu(new Menu());
			Menu.sortList(list, sourcelist, menu.getParentId(), false);
			if (list.size() > 0){
				menu.setSerial(list.get(list.size()-1).getSerial() + 30);
			}
		}
		model.addAttribute("menu", menu);
		//领域
		List<Domain> domainList = systemService.getDomainDao().findAllList(new Domain());
		model.addAttribute("domainList",domainList);
		model.addAttribute("allTags", systemService.getAllTags());
		return "/view/vital/modules/sys/menuForm";
	}
	
	@RequiresPermissions("sys_menu_edit")
	@RequestMapping(value = "save")
	public String save(Menu menu, Model model, RedirectAttributes redirectAttributes) {
		if(!UserUtils.getUser().isAdmin()){
			addMessage(redirectAttributes, "越权操作，只有超级管理员才能添加或修改数据！");
			return "redirect:" + adminPath + "/sys/role/?repage";
		}
		if (!beanValidator(model, menu)){
			return form(menu, model);
		}
		systemService.saveMenu(menu);
		addMessage(redirectAttributes, "保存菜单'" + menu.getResourceName() + "'成功");
		return "redirect:" + adminPath + "/sys/menu/?repage&domainId="+menu.getDomainId();
	}
	
	@RequiresPermissions("sys_menu_edit")
	@RequestMapping(value = "delete")
	public String delete(Menu menu, RedirectAttributes redirectAttributes) {
			systemService.deleteMenu(menu);
			addMessage(redirectAttributes, "删除菜单成功");
		return "redirect:" + adminPath + "/sys/menu/?repage&domainId="+menu.getDomainId();
	}

	@RequiresPermissions("user")
	@RequestMapping(value = "tree")
	public String tree() {
		return "/view/vital/modules/sys/menuTree";
	}

	@RequiresPermissions("user")
	@RequestMapping(value = "treeselect")
	public String treeselect(String parentId, Model model) {
		model.addAttribute("parentId", parentId);
		return "/view/vital/modules/sys/menuTreeselect";
	}
	
	/**
	 * 批量修改菜单排序
	 */
	@RequiresPermissions("sys_menu_edit")
	@RequestMapping(value = "updateSort")
	public String updateSort(String[] ids, Integer[] sorts, RedirectAttributes redirectAttributes) {

    	for (int i = 0; i < ids.length; i++) {
    		Menu menu = new Menu(ids[i]);
    		menu.setSerial(sorts[i]);
    		systemService.updateMenuSort(menu);
    	}
    	addMessage(redirectAttributes, "保存菜单排序成功!");
		return "redirect:" + adminPath + "/sys/menu/";
	}
	
	/**
	 * isShowHide是否显示隐藏菜单
	 * @param extId
	 * @param response
	 * @return
	 */
	@RequiresPermissions("user")
	@ResponseBody
	@RequestMapping(value = "treeData")
	public List<Map<String, Object>> treeData(@RequestParam(required=false) String extId,@RequestParam(required=false) String isShowHide, HttpServletResponse response) {
		List<Map<String, Object>> mapList = Lists.newArrayList();
		List<Menu> list = systemService.findAllMenu(new Menu());
		for (int i=0; i<list.size(); i++){
			Menu e = list.get(i);
			if (StringUtils.isBlank(extId) || (extId!=null && !extId.equals(e.getId()) && e.getParentIds().indexOf(","+extId+",")==-1)){
				if(isShowHide != null && isShowHide.equals("0") && e.getIsShow()==0){
					continue;
				}
				Map<String, Object> map = Maps.newHashMap();
				map.put("id", e.getId());
				map.put("pId", e.getParentId());
				map.put("name", e.getResourceName());
				mapList.add(map);
			}
		}
		return mapList;
	}
}
