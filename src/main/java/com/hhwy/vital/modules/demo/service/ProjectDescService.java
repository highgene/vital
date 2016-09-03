/**
 * Copyright &copy; 2012-2014 <a href="http://www.haijintech.com">HaiJinTech</a> All rights reserved.
 */
package com.hhwy.vital.modules.demo.service;

import java.util.List;

import com.hhwy.vital.common.service.CrudService;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.hhwy.vital.common.persistence.Page;
import com.hhwy.vital.modules.demo.entity.ProjectDesc;
import com.hhwy.vital.modules.demo.dao.ProjectDescDao;

/**
 * 工程描述Service
 * @author zbx
 * @version 2016-08-14
 */
@Service
@Transactional(readOnly = true)
public class ProjectDescService extends CrudService<ProjectDescDao, ProjectDesc> {

	public ProjectDesc get(String id) {
		return super.get(id);
	}
	
	public List<ProjectDesc> findList(ProjectDesc projectDesc) {
		return super.findList(projectDesc);
	}
	
	public Page<ProjectDesc> findPage(Page<ProjectDesc> page, ProjectDesc projectDesc) {
		return super.findPage(page, projectDesc);
	}
	
	@Transactional(readOnly = false)
	public void save(ProjectDesc projectDesc) {
		super.save(projectDesc);
	}
	
	@Transactional(readOnly = false)
	public void delete(ProjectDesc projectDesc) {
		super.delete(projectDesc);
	}
	
}