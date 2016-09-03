/**
 * Copyright &copy; 2012-2014 <a href="http://www.haijintech.com">HaiJinTech</a> All rights reserved.
 */
package com.hhwy.vital.modules.sys.service;

import com.hhwy.vital.common.service.CrudService;
import com.hhwy.vital.modules.sys.dao.RoleDao;
import com.hhwy.vital.modules.sys.entity.Role;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.Arrays;
import java.util.HashSet;
import java.util.List;
import java.util.Set;

/**
 * 授权实例Service
 * @author zbx
 * @version 2016-07-01
 */
@Service
@Transactional(readOnly = true)
public class RoleService extends CrudService<RoleDao, Role> {

	@Autowired
	private RoleDao roleDao;

	
	public String getAllTags() {
		Set<String> set = new HashSet();
		List<Role> allList = roleDao.findAllList();
		for (Role role : allList) {
			String tag=role.getTags();
			if (tag!=null&&!"".equals(tag)){
				String[] tags = tag.split(",");
				set.addAll(Arrays.asList(tags));
			}
		}
		String s = set.toString();
		s=s.replaceAll("\\[","\\['").replaceAll(",","','").replaceAll("\\]","'\\]").replaceAll(" ","");
		return s;
	}
	

	

}