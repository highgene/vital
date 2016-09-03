/**
 * Copyright &copy; 2012-2014 <a href="http://www.haijintech.com">HaiJinTech</a> All rights reserved.
 */
package com.hhwy.vital.utility.front;

import com.google.common.collect.Lists;
import com.google.common.collect.Maps;
import com.hhwy.vital.common.utils.StringUtils;
import com.hhwy.vital.common.web.BaseController;
import com.hhwy.vital.modules.sys.dao.RoleDao;
import com.hhwy.vital.modules.sys.dao.UserDao;
import com.hhwy.vital.modules.sys.entity.Domain;
import com.hhwy.vital.modules.sys.entity.Office;
import com.hhwy.vital.modules.sys.entity.Role;
import com.hhwy.vital.modules.sys.entity.Target;
import com.hhwy.vital.modules.sys.entity.User;
import com.hhwy.vital.modules.sys.service.DomainService;
import com.hhwy.vital.modules.sys.service.OfficeService;
import com.hhwy.vital.modules.sys.service.SystemService;
import com.hhwy.vital.modules.sys.service.TargetService;

import org.apache.shiro.authz.annotation.RequiresPermissions;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpServletResponse;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * 前端接口Controller
 * @author zk
 */
@Controller
@RequestMapping(value = "${adminPath}/sys/helper")
public class HelperController extends BaseController {

	@Autowired
	private OfficeService officeService;
	@Autowired
	private SystemService systemService;
	@Autowired
	private TargetService targetService;
	@Autowired
	private DomainService domainService;
	@Autowired
	private UserDao userDao;
	@Autowired
	private RoleDao roleDao;
	
	/**
	 * 根据组织获取用户JSON数据。
	 * @param response
	 * @return
	 */
	@RequiresPermissions("user")
	@ResponseBody
	@RequestMapping(value = "user_by_org")
	public List<Map<String, Object>> userByOrgData(String domainId, String targetId, String orgid, String userName, HttpServletResponse response) {
		
		List<Map<String, Object>> mapList = Lists.newArrayList();
		User user = new User();
		//根据组织id获取用户
		
		if(StringUtils.isBlank(orgid) || "undefined".equals(orgid)){
			return null;
		}
		
		//根据用户名检索 ，为空则检索所有 
		if(StringUtils.isBlank(userName) || "undefined".equals(userName)){
			userName = "";
		}
		
		//结果去重
		Map<String, Object> distinctmap = new HashMap<String, Object>(); 
		
		for (int j = 0; j < orgid.split(",").length; j++) {
			
			user.setOffice(new Office(orgid.split(",")[j]));
			user.setRealName(userName);
			List<User> list = userDao.findList(user);
			
			for (int i=0; i<list.size(); i++){
				User e = list.get(i);
				Map<String, Object> map = new HashMap<String, Object>(); 
				
				if(distinctmap.containsKey(e.getId())){
				}else{
					map.put("id", e.getId());
					map.put("name", e.getRealName());
					
					distinctmap.put(e.getId(), map);
					mapList.add(map);
				}
			}
		}
		return mapList;
	}
	
	/**
	 * 根据角色获取用户JSON数据。
	 * @param response
	 * @return
	 */
	@RequiresPermissions("user")
	@ResponseBody
	@RequestMapping(value = "user_by_role")
	public List<Map<String, Object>> userByRoleData(String roleId, String userName, HttpServletResponse response) {
		
		List<Map<String, Object>> mapList = Lists.newArrayList();
		User user = new User();
		//根据组织id获取用户
		
		if(StringUtils.isBlank(roleId) || "undefined".equals(roleId)){
			return null;
		}
		
		//根据用户名/登录名检索 ，为空则检索所有 
		if(StringUtils.isBlank(userName) || "undefined".equals(userName)){
			userName = "";
		}
		
		//结果去重
		Map<String, Object> distinctmap = new HashMap<String, Object>(); 
		
		for (int j = 0; j < roleId.split(",").length; j++) {
			
			user.setRole(new Role(roleId.split(",")[j]));
			user.setRealName(userName);
			List<User> list = userDao.findList(user);
			
			for (int i=0; i<list.size(); i++){
				User e = list.get(i);
				Map<String, Object> map = Maps.newHashMap();
				
				if(distinctmap.containsKey(e.getId())){
				}else{
					map.put("id", e.getId());
					map.put("name", e.getRealName());
					distinctmap.put(e.getId(), map);
					mapList.add(map);
				}
			}
		}
		
		return mapList;
	}
	/**
	 * 获取角色JSON数据。
	 * @param response
	 * @return
	 */
	@RequiresPermissions("user")
	@ResponseBody
	@RequestMapping(value = "role")
	public List<Map<String, Object>> roleData(String domainId, HttpServletResponse response) {
		
		List<Map<String, Object>> mapList = Lists.newArrayList();
		Role role = new Role();
		List<Role> list = roleDao.findAllList(role);
		
		for (int i=0; i<list.size(); i++){
			Role e = list.get(i);
			Map<String, Object> map = Maps.newHashMap();
			map.put("id", e.getId());
			map.put("name", e.getRoleName());
			mapList.add(map);
		}
		return mapList;
	}
	
	/**
	 * 获取领域JSON数据。
	 * @param response
	 * @return
	 */
	@RequiresPermissions("user")
	@ResponseBody
	@RequestMapping(value = "domain")
	public List<Map<String, Object>> domainData(HttpServletResponse response) {
		
		List<Map<String, Object>> mapList = Lists.newArrayList();
		
		List<Domain> list = domainService.findList(null);
		
		for (int i=0; i<list.size(); i++){
			Domain e = list.get(i);
			Map<String, Object> map = Maps.newHashMap();
			map.put("id", e.getId());
			map.put("name", e.getDomainName());
			mapList.add(map);
		}
		return mapList;
	}
	
	/**
	 * 获取实例JSON数据。
	 * @param response
	 * @return
	 */
	@RequiresPermissions("user")
	@ResponseBody
	@RequestMapping(value = "target")
	public List<Map<String, Object>> targetData(String domainId, HttpServletResponse response) {
		
		List<Map<String, Object>> mapList = Lists.newArrayList();
		
		Target target = new Target();
		target.setDomainId(domainId);
		
		List<Target> list = targetService.findList(target);
		
		for (int i=0; i<list.size(); i++){
			Target e = list.get(i);
			Map<String, Object> map = Maps.newHashMap();
			map.put("id", e.getId());
			map.put("name", e.getObjectName());
			mapList.add(map);
		}
		return mapList;
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
	@RequestMapping(value = "office/treeData")
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

}
