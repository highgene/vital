/**
 * Copyright &copy; 2012-2014 <a href="http://www.haijintech.com">HaiJinTech</a> All rights reserved.
 */
package com.hhwy.vital.modules.sys.entity;

import org.hibernate.validator.constraints.Length;

import com.hhwy.vital.common.persistence.DataEntity;

/**
 * 授权实例Entity
 * @author zbx
 * @version 2016-07-01
 */
public class Target extends DataEntity<Target> {
	
	private static final long serialVersionUID = 1L;
	private String domainId;		// 领域ID
	private String objectCode;		// 实例短ID
	private String objectName;		// 实例名称
	private String parent;		// 父ID
	private String sid;		// sid
	private String path;		// path
	private Integer enableOrg;		// 是否启用组织机构
	private String newId; //新ID
	private Integer isDefault;//是否默认实例
	
	public Target() {
		super();
	}

	public Target(String id){
		super(id);
	}

	@Length(min=0, max=50, message="领域ID长度必须介于 0 和 50 之间")
	public String getDomainId() {
		return domainId;
	}

	public void setDomainId(String domainId) {
		this.domainId = domainId;
	}
	
	@Length(min=0, max=50, message="实例ID长度必须介于 0 和 50 之间")
	public String getObjectCode() {
		return objectCode;
	}

	public void setObjectCode(String objectCode) {
		this.objectCode = objectCode;
	}
	
	@Length(min=0, max=100, message="实例名称长度必须介于 0 和 100 之间")
	public String getObjectName() {
		return objectName;
	}

	public void setObjectName(String objectName) {
		this.objectName = objectName;
	}
	
	@Length(min=1, max=50, message="父ID长度必须介于 1 和 50 之间")
	public String getParent() {
		return parent;
	}

	public void setParent(String parent) {
		this.parent = parent;
	}
	
	@Length(min=0, max=50, message="sid长度必须介于 0 和 50 之间")
	public String getSid() {
		return sid;
	}

	public void setSid(String sid) {
		this.sid = sid;
	}
	
	public String getPath() {
		return path;
	}

	public void setPath(String path) {
		this.path = path;
	}

	public Integer getEnableOrg() {
		return enableOrg;
	}

	public void setEnableOrg(Integer enableOrg) {
		this.enableOrg = enableOrg;
	}

	public String getNewId() {
		return newId;
	}

	public void setNewId(String newId) {
		this.newId = newId;
	}

	public Integer getIsDefault() {
		return isDefault;
	}

	public void setIsDefault(Integer isDefault) {
		this.isDefault = isDefault;
	}
}