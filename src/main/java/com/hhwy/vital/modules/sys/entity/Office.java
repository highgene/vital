/**
 * Copyright &copy; 2012-2014 <a href="http://www.haijintech.com">HaiJinTech</a> All rights reserved.
 */
package com.hhwy.vital.modules.sys.entity;

import com.hhwy.vital.common.persistence.TreeEntity;
import org.hibernate.validator.constraints.Length;

import java.util.List;

/**
 * 机构Entity
 * @author zbx
 * @version 2013-05-15
 */
public class Office extends TreeEntity<Office> {

	private static final long serialVersionUID = 1L;


	private String code; 	// 机构编码 org_code
	private String type; 	// 机构类型（1：单位；2：部门；3：工作组）org_type
	private String targetId ;     //'授权对象ID，所以该机构树，既包含了系统全局的组织机构，也包含各个工程的组织机构，target_id即是工程ID',


	private int		children_count ;     //i'0',
	private String 		sid ;     //'短主键，8位的随机字符串，用于生成path路径',
	private String 		path ;     //'因为id是uuid，太长，所以用object_id作为path的代码',

	private String 		orgAddr ;
	private String 		username ;
	private String 		phone ;

	private String orgLevel; //级次,0:子级,1:平缓
	private String orgLocation; //级次,0:行前,1:行后


	private List<String> childDeptList;//快速添加子部门

	
	public Office(){
		super();
		this.type = "2";
	}

	public Office(String id){
		super(id);
	}
	
	public List<String> getChildDeptList() {
		return childDeptList;
	}

	public void setChildDeptList(List<String> childDeptList) {
		this.childDeptList = childDeptList;
	}


	public Office getParent() {
		return parent;
	}

	public void setParent(Office parent) {
		this.parent = parent;
	}

	
	@Length(min=1, max=1)
	public String getType() {
		return type;
	}

	public void setType(String type) {
		this.type = type;
	}


	@Length(min=0, max=100)
	public String getCode() {
		return code;
	}

	public void setCode(String code) {
		this.code = code;
	}

	public String getTargetId() {
		return targetId;
	}

	public void setTargetId(String targetId) {
		this.targetId = targetId;
	}

	public int getChildren_count() {
		return children_count;
	}

	public void setChildren_count(int children_count) {
		this.children_count = children_count;
	}

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

	public String getOrgAddr() {
		return orgAddr;
	}

	public void setOrgAddr(String orgAddr) {
		this.orgAddr = orgAddr;
	}

	public String getUsername() {
		return username;
	}

	public void setUsername(String username) {
		this.username = username;
	}

	public String getPhone() {
		return phone;
	}

	public void setPhone(String phone) {
		this.phone = phone;
	}

	public String getOrgLevel() {
		return orgLevel;
	}

	public void setOrgLevel(String orgLevel) {
		this.orgLevel = orgLevel;
	}

	public String getOrgLocation() {
		return orgLocation;
	}

	public void setOrgLocation(String orgLocation) {
		this.orgLocation = orgLocation;
	}

	@Override
	public String toString() {
		return name;
	}
}