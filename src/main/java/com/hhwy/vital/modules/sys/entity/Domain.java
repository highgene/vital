/**
 * Copyright &copy; 2012-2014 <a href="http://www.haijintech.com">HaiJinTech</a> All rights reserved.
 */
package com.hhwy.vital.modules.sys.entity;

import com.hhwy.vital.common.persistence.DataEntity;
import org.hibernate.validator.constraints.Length;

/**
 * 授权领域Entity
 * @author zbx
 * @version 2016-06-30
 */
public class Domain extends DataEntity<Domain> {
	
	private static final long serialVersionUID = 1L;
	private String domainCode;		// 领域编码
	private String domainName;		// 领域名称
	private String entityName;		// 业务表名
	private String pkName;		// 字段名
	private String summaryUrl;		// URL地址
	private Integer innate;		// 是否内置
	private Integer enableOrg;		// 是否启用组织机构
	private Integer enableMulti;		// 是否启用多例模式
	private String defaultTargetId;		// 默认实例ID

	private String defaultTargetName;		// 默认实例ID
	
	public Domain() {
		super();
	}

	public Domain(String id){
		super(id);
	}

	@Length(min=0, max=50, message="领域编码长度必须介于 0 和 50 之间")
	public String getDomainCode() {
		return domainCode;
	}

	public void setDomainCode(String domainCode) {
		this.domainCode = domainCode;
	}
	
	@Length(min=0, max=50, message="领域名称长度必须介于 0 和 50 之间")
	public String getDomainName() {
		return domainName;
	}

	public void setDomainName(String domainName) {
		this.domainName = domainName;
	}
	
	@Length(min=0, max=50, message="业务表名长度必须介于 0 和 50 之间")
	public String getEntityName() {
		return entityName;
	}

	public void setEntityName(String entityName) {
		this.entityName = entityName;
	}
	
	@Length(min=0, max=50, message="字段名长度必须介于 0 和 50 之间")
	public String getPkName() {
		return pkName;
	}

	public void setPkName(String pkName) {
		this.pkName = pkName;
	}
	
	@Length(min=0, max=200, message="URL地址长度必须介于 0 和 200 之间")
	public String getSummaryUrl() {
		return summaryUrl;
	}

	public void setSummaryUrl(String summaryUrl) {
		this.summaryUrl = summaryUrl;
	}
	
	public Integer getInnate() {
		return innate;
	}

	public void setInnate(Integer innate) {
		this.innate = innate;
	}
	
	public Integer getEnableOrg() {
		return enableOrg;
	}

	public void setEnableOrg(Integer enableOrg) {
		this.enableOrg = enableOrg;
	}
	
	public Integer getEnableMulti() {
		return enableMulti;
	}

	public void setEnableMulti(Integer enableMulti) {
		this.enableMulti = enableMulti;
	}
	
	@Length(min=0, max=50, message="默认实例ID长度必须介于 0 和 50 之间")
	public String getDefaultTargetId() {
		return defaultTargetId;
	}

	public void setDefaultTargetId(String defaultTargetId) {
		this.defaultTargetId = defaultTargetId;
	}

	public String getDefaultTargetName() {
		return defaultTargetName;
	}

	public void setDefaultTargetName(String defaultTargetName) {
		this.defaultTargetName = defaultTargetName;
	}
}