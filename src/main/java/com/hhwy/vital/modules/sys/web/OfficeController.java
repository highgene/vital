/**
 * Copyright &copy; 2012-2014 <a href="http://www.haijintech.com">HaiJinTech</a> All rights reserved.
 */
package com.hhwy.vital.modules.sys.web;

import com.google.common.collect.Lists;
import com.google.common.collect.Maps;
import com.hhwy.vital.modules.sys.service.OfficeService;
import com.hhwy.vital.modules.sys.utils.UserUtils;
import com.hhwy.vital.common.utils.StringUtils;
import com.hhwy.vital.common.web.BaseController;
import com.hhwy.vital.modules.sys.entity.Office;
import com.hhwy.vital.modules.sys.entity.User;
import com.hhwy.vital.modules.sys.service.SystemService;
import com.hhwy.vital.modules.sys.utils.DictUtils;
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
 * 机构Controller
 * @author zbx
 * @version 2013-5-15
 */
@Controller
@RequestMapping(value = "${adminPath}/sys/office")
public class OfficeController extends BaseController {

	@Autowired
	private OfficeService officeService;
	@Autowired
	private SystemService systemService;
	
	@ModelAttribute("office")
	public Office get(@RequestParam(required=false) String id) {
		if (StringUtils.isNotBlank(id)){
			Office office = officeService.get(id);
			return office;
		}else{
			return new Office();
		}
	}

	@RequiresPermissions("sys_office_view")
	@RequestMapping(value = {""})
	public String index(Office office, Model model) {
		return "/view/vital/modules/sys/officeIndex";
	}

	@RequiresPermissions("sys_office_view")
	@RequestMapping(value = {"list"})
	public String list(Office office, Model model) {
		office = new Office();
		office.setTargetId("eeeeefd91e0c11e6866500ff5d77254e");
		List<Office> list = officeService.findList(office);
		model.addAttribute("list", list);
		return "/view/vital/modules/sys/officeList";
	}
	
	@RequiresPermissions("sys_office_view")
	@RequestMapping(value = "form")
	public String form(Office office, Model model) {
		User user = UserUtils.getUser();
		if (office.getParent()==null || StringUtils.isEmpty(office.getParent().getId())){
			office.setParent(user.getOffice());
		}
		office.setParent(officeService.get(office.getParent().getId()));
		// 自动获取排序号
//		if (StringUtils.isBlank(office.getId())&&office.getParent()!=null){
//			int size = 0;
//			List<Office> list = officeService.findAll();
//			for (int i=0; i<list.size(); i++){
//				Office e = list.get(i);
//				if (e.getParent()!=null && e.getParent().getId()!=null
//						&& e.getParent().getId().equals(office.getParent().getId())){
//					size++;
//				}
//			}
//			office.setCode(office.getParent().getCode() + StringUtils.leftPad(String.valueOf(size > 0 ? size+1 : 1), 3, "0"));
//		}
		model.addAttribute("office", office);
		return "/view/vital/modules/sys/officeForm";
	}
	
	@RequiresPermissions("sys_office_edit")
	@RequestMapping(value = "save")
	public String save(Office office, Model model, RedirectAttributes redirectAttributes) {
		if (!beanValidator(model, office)){
			return form(office, model);
		}
		office.setTargetId("eeeeefd91e0c11e6866500ff5d77254e");
		officeService.save(office);
		
		if(office.getChildDeptList()!=null){
			Office childOffice = null;
			for(String id : office.getChildDeptList()){
				childOffice = new Office();
				childOffice.setName(DictUtils.getDictLabel(id, "sys_office_common", "未知"));
				childOffice.setParent(office);
				childOffice.setType("2");
				officeService.save(childOffice);
			}
		}
		UserUtils.removeCache(UserUtils.CACHE_OFFICE_ALL_LIST);
		UserUtils.removeCache(UserUtils.CACHE_OFFICE_LIST);
		addMessage(redirectAttributes, "保存机构'" + office.getName() + "'成功");
		String id = "0".equals(office.getParentId()) ? "" : office.getParentId();
		return "redirect:" + adminPath + "/sys/office/list";
	}
	
	@RequiresPermissions("sys_office_edit")
	@RequestMapping(value = "delete")
	public String delete(Office office, RedirectAttributes redirectAttributes) {

		officeService.delete(office);
		addMessage(redirectAttributes, "删除机构成功");
		UserUtils.removeCache(UserUtils.CACHE_OFFICE_ALL_LIST);
		UserUtils.removeCache(UserUtils.CACHE_OFFICE_LIST);
		return "redirect:" + adminPath + "/sys/office/list";
	}

	/**
	 * 获取机构JSON数据。
	 * @param extId 排除的ID
	 * @param type	类型（1：公司；2：部门/小组/其它：3：用户）
	 * @param grade 显示级别
	 * @param response
	 * @return
	 */
	@RequiresPermissions("user")
	@ResponseBody
	@RequestMapping(value = "treeData")
	public List<Map<String, Object>> treeData(@RequestParam(required=false) String extId, @RequestParam(required=false) String type,
			@RequestParam(required=false) Long grade, @RequestParam(required=false) Boolean isAll, String targetId, HttpServletResponse response) {
		if (StringUtils.isEmpty(targetId)){
			targetId = "eeeeefd91e0c11e6866500ff5d77254e";
		}
		List<Map<String, Object>> mapList = Lists.newArrayList();
		Office office = new Office();
		office.setTargetId(targetId);
		List<Office> list = officeService.getDao().findListByTarget(office);
		for (int i=0; i<list.size(); i++){
			Office e = list.get(i);
			if ((StringUtils.isBlank(extId) || (extId!=null && !extId.equals(e.getId()) && e.getParentIds().indexOf(","+extId+",")==-1))
					&& (type == null || (type != null && (type.equals("1") ? type.equals(e.getType()) : true)))
					){
				Map<String, Object> map = Maps.newHashMap();
				map.put("id", e.getId());
				map.put("pId", e.getParentId());
				map.put("pIds", e.getParentIds());
				map.put("name", e.getName());
				if (type != null && "3".equals(type)){
					map.put("isParent", true);
				}
				mapList.add(map);
			}
		}
		return mapList;
	}
	@RequiresPermissions("sys_office_edit")
	@RequestMapping(value = "office_save")
	public String office_save(Office office, Model model, RedirectAttributes redirectAttributes) {

		if (!beanValidator(model, office)){
			return form(office, model);
		}
		if (office.getParent().getId()!=null&&!"".equals(office.getParent().getId())){
			Office parent=officeService.get(office.getParent().getId());
			office.setTargetId(parent.getTargetId());
		}
		officeService.save(office);
		addMessage(redirectAttributes, "保存机构'" + office.getName() + "'成功");
		return "redirect:" + adminPath + "/sys/target/office_list?targetId="+office.getTargetId();
	}

	/**
	 * 批量修改菜单排序
	 */
	@RequiresPermissions("sys_office_edit")
	@RequestMapping(value = "updateSort")
	public String updateSort(String[] ids, Integer[] sorts, RedirectAttributes redirectAttributes) {
		for (int i = 0; i < ids.length; i++) {
			Office office = new Office(ids[i]);
			office.setSort(sorts[i]);
			systemService.updateOfficeSort(office);
		}
		addMessage(redirectAttributes, "保存组织排序成功!");
		return "redirect:" + adminPath + "/sys/office/list";
	}

}
