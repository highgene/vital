/**
 * Copyright &copy; 2012-2014 <a href="http://www.haijintech.com">HaiJinTech</a> All rights reserved.
 */
package com.hhwy.vital.modules.sys.entity;

import org.hibernate.validator.constraints.Length;

import com.hhwy.vital.common.persistence.DataEntity;

/**
 * 用户权限Entity
 * @author zbx
 * @version 2016-07-10
 */
public class UserRole extends DataEntity<UserRole> {
	
	private static final long serialVersionUID = 1L;
	private User user;		// user_id
	private String roleId;		// role_id
	private String targetId;		// target_id
	private String organizationId;		// 组织机构id
	private String duty;		// （工程）职务，工种等，可以不填
	
	public UserRole() {
		super();
	}

	public UserRole(String id){
		super(id);
	}

	public User getUser() {
		return user;
	}

	public void setUser(User user) {
		this.user = user;
	}
	
	@Length(min=0, max=50, message="role_id长度必须介于 0 和 50 之间")
	public String getRoleId() {
		return roleId;
	}

	public void setRoleId(String roleId) {
		this.roleId = roleId;
	}
	
	@Length(min=0, max=50, message="target_id长度必须介于 0 和 50 之间")
	public String getTargetId() {
		return targetId;
	}

	public void setTargetId(String targetId) {
		this.targetId = targetId;
	}
	
	@Length(min=0, max=50, message="组织机构id长度必须介于 0 和 50 之间")
	public String getOrganizationId() {
		return organizationId;
	}

	public void setOrganizationId(String organizationId) {
		this.organizationId = organizationId;
	}
	
	@Length(min=0, max=50, message="（工程）职务，工种等，可以不填长度必须介于 0 和 50 之间")
	public String getDuty() {
		return duty;
	}

	public void setDuty(String duty) {
		this.duty = duty;
	}
	
}