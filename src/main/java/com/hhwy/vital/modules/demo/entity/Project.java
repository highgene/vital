/**
 * Copyright &copy; 2012-2014 <a href="http://www.haijintech.com">HaiJinTech</a> All rights reserved.
 */
package com.hhwy.vital.modules.demo.entity;

import org.hibernate.validator.constraints.Length;

import com.hhwy.vital.common.persistence.DataEntity;

/**
 * 工程领域Entity
 * @author zbx
 * @version 2016-08-07
 */
public class Project extends DataEntity<Project> {
	
	private static final long serialVersionUID = 1L;
	private String projectName;		// 工程名
	private String manager;		// 管理员
	private String serial;		// 顺序号
	
	public Project() {
		super();
	}

	public Project(String id){
		super(id);
	}

	@Length(min=0, max=50, message="工程名长度必须介于 0 和 50 之间")
	public String getProjectName() {
		return projectName;
	}

	public void setProjectName(String projectName) {
		this.projectName = projectName;
	}
	
	@Length(min=0, max=50, message="管理员长度必须介于 0 和 50 之间")
	public String getManager() {
		return manager;
	}

	public void setManager(String manager) {
		this.manager = manager;
	}
	
	@Length(min=0, max=11, message="顺序号长度必须介于 0 和 11 之间")
	public String getSerial() {
		return serial;
	}

	public void setSerial(String serial) {
		this.serial = serial;
	}
	
}