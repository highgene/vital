/**
 * Copyright &copy; 2012-2014 <a href="http://www.haijintech.com">HaiJinTech</a> All rights reserved.
 */
package com.hhwy.vital.modules.sys.entity;

import com.hhwy.vital.common.persistence.DataEntity;
import org.hibernate.validator.constraints.Length;

import javax.xml.bind.annotation.XmlAttribute;

/**
 * 字典Entity
 * @author zbx
 * @version 2013-05-15
 */
public class Dict extends DataEntity<Dict> {

	private static final long serialVersionUID = 1L;
//	private String type;	// 类型
	private Integer sort=0;	// 排序
	//private String parentId;//父Id


	 private  String    paramName; //参数名 即 类型
	private  String 	cnName; //'参数中文名',标签
	private  String 	paramValue; // '参数值',
	private  int 	innate; //'是否内置参数',
	private  String 	defaultValue; // '默认值',


	public Dict() {
		super();
	}
	
	public Dict(String id){
		super(id);
	}
	
	public Dict(String cnName, String paramValue){
		this.cnName = cnName;
		this.paramValue = paramValue;
	}
	
	@XmlAttribute
	@Length(min=1, max=100)
	public String getParamValue() {
		return paramValue;
	}

	public void setParamValue(String paramValue) {
		this.paramValue = paramValue;
	}
	
	@XmlAttribute
	@Length(min=1, max=100)
	public String getCnName() {
		return cnName;
	}

	public void setCnName(String cnName) {
		this.cnName = cnName;
	}

	@Length(min=1, max=100)
	public String getParamName() {
		return paramName;
	}

	public void setParamName(String paramName) {
		this.paramName = paramName;
	}


	public Integer getSort() {
		return sort;
	}

	public void setSort(Integer sort) {
		this.sort = sort;
	}

	public int getInnate() {
		return innate;
	}

	public void setInnate(int innate) {
		this.innate = innate;
	}

	public String getDefaultValue() {
		return defaultValue;
	}

	public void setDefaultValue(String defaultValue) {
		this.defaultValue = defaultValue;
	}


	public String getLabel() {
		return cnName;
	}

	public void setLabel(String cnName) {
		this.cnName = cnName;
	}

	public String getValue() {
		return paramValue;
	}

	public void setValue(String paramValue) {
		this.paramValue = paramValue;
	}

	@Override
	public String toString() {
		return paramValue;
	}

}