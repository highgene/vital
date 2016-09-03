/**
 * Copyright &copy; 2012-2014 <a href="http://www.haijintech.com">HaiJinTech</a> All rights reserved.
 */
package com.hhwy.vital.modules.demo.entity;

import org.hibernate.validator.constraints.Length;

import com.hhwy.vital.common.persistence.DataEntity;

/**
 * 工程描述Entity
 * @author zbx
 * @version 2016-08-14
 */
public class ProjectDesc extends DataEntity<ProjectDesc> {
	
	private static final long serialVersionUID = 1L;
	private String name;		// 登录名
	private String code;		// 编码
	private String serial;		// 顺序号
	private String other;		// 其他字段
	private String projectId;		// 工程ID
	
	public ProjectDesc() {
		super();
	}

	public ProjectDesc(String id){
		super(id);
	}

	@Length(min=0, max=50, message="登录名长度必须介于 0 和 50 之间")
	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}
	
	@Length(min=0, max=50, message="编码长度必须介于 0 和 50 之间")
	public String getCode() {
		return code;
	}

	public void setCode(String code) {
		this.code = code;
	}
	
	@Length(min=0, max=11, message="顺序号长度必须介于 0 和 11 之间")
	public String getSerial() {
		return serial;
	}

	public void setSerial(String serial) {
		this.serial = serial;
	}
	
	@Length(min=0, max=50, message="其他字段长度必须介于 0 和 50 之间")
	public String getOther() {
		return other;
	}

	public void setOther(String other) {
		this.other = other;
	}
	
	@Length(min=1, max=50, message="工程ID长度必须介于 1 和 50 之间")
	public String getProjectId() {
		return projectId;
	}

	public void setProjectId(String projectId) {
		this.projectId = projectId;
	}
	
}