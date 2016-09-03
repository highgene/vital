/**
 * Copyright &copy; 2012-2014 <a href="http://www.haijintech.com">HaiJinTech</a> All rights reserved.
 */
package com.hhwy.vital.modules.demo.service;

import java.util.List;

import com.hhwy.vital.common.persistence.Page;
import com.hhwy.vital.common.service.CrudService;
import com.hhwy.vital.modules.demo.entity.Project;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.hhwy.vital.modules.demo.dao.ProjectDao;

/**
 * 工程领域Service
 * @author zbx
 * @version 2016-08-07
 */
@Service
@Transactional(readOnly = true)
public class ProjectService extends CrudService<ProjectDao, Project> {

	public Project get(String id) {
		return super.get(id);
	}
	
	public List<Project> findList(Project project) {
		return super.findList(project);
	}
	
	public Page<Project> findPage(Page<Project> page, Project project) {
		return super.findPage(page, project);
	}
	
	@Transactional(readOnly = false)
	public void save(Project project) {
		super.save(project);
	}
	
	@Transactional(readOnly = false)
	public void delete(Project project) {
		super.delete(project);
	}
	
}