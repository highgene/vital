/**
 * Copyright &copy; 2012-2014 <a href="http://www.haijintech.com">HaiJinTech</a> All rights reserved.
 */
package com.hhwy.vital.modules.sys.entity;

import com.hhwy.vital.common.persistence.DataEntity;
import com.hhwy.vital.common.utils.StringUtils;
import org.apache.commons.lang3.builder.ReflectionToStringBuilder;

import java.util.Date;
import java.util.Map;

/**
 * 日志Entity
 * @author zbx
 * @version 2014-8-19
 */
public class Log extends DataEntity<Log> {

	private static final long serialVersionUID = 1L;
//	private String type; 		// 日志类型（1：接入日志；2：错误日志）
//	private String title;		// 日志标题
//	private String remoteAddr; 	// 操作用户的IP地址
	private String requestUri; 	// 操作的URI
	private String method; 		// 操作的方式
//	private String params; 		// 操作提交的数据
//	private String userAgent;	// 操作用户代理信息
//	private String exception; 	// 异常信息
//
	private Date beginDate;		// 开始日期
	private Date endDate;		// 结束日期


	private String execution=" ";// '执行的进程/类/代码位置等',
	private String logLevel;//
	private String logMessage;//消息
	private String resourceId;//  '资源ID',
	private String targetId;//  '授权对象ID',
	private String clientIp;// '客户端IP',
	private String clientAgent;//  '客户端描述信息',
	private String search;//查询关键字



	
	// 日志类型（1：接入日志；2：错误日志）
	public static final String TYPE_ACCESS = "1";
	public static final String TYPE_EXCEPTION = "2";
	
	public Log(){
		super();
	}
	
	public Log(String id){
		super(id);
	}
	



	public String getExecution() {
		return execution;
	}

	public void setExecution(String execution) {
		this.execution = execution;
	}

	public String getLogLevel() {
		return logLevel;
	}

	public void setLogLevel(String logLevel) {
		this.logLevel = logLevel;
	}

	public String getLogMessage() {
		return logMessage;
	}

	public void setLogMessage(String logMessage) {
		this.logMessage = logMessage;
	}

	public String getResourceId() {
		return resourceId;
	}

	public void setResourceId(String resourceId) {
		this.resourceId = resourceId;
	}

	public String getTargetId() {
		return targetId;
	}

	public void setTargetId(String targetId) {
		this.targetId = targetId;
	}

	public String getClientIp() {
		return clientIp;
	}

	public void setClientIp(String clientIp) {
		this.clientIp = clientIp;
	}

	public String getClientAgent() {
		return clientAgent;
	}

	public void setClientAgent(String clientAgent) {
		this.clientAgent = clientAgent;
	}

	public String getRequestUri() {
		return requestUri;
	}

	public void setRequestUri(String requestUri) {
		this.requestUri = requestUri;
	}

	public String getMethod() {
		return method;
	}

	public void setMethod(String method) {
		this.method = method;
	}

	public Date getEndDate() {
		return endDate;
	}

	public void setEndDate(Date endDate) {
		this.endDate = endDate;
	}

	public Date getBeginDate() {
		return beginDate;
	}

	public void setBeginDate(Date beginDate) {
		this.beginDate = beginDate;
	}

	public String getSearch() {
		return search;
	}

	public void setSearch(String search) {
		this.search = search;
	}

	/**
	 * 设置请求参数
	 * @param paramMap
	 */
	@SuppressWarnings({ "unchecked", "rawtypes" })
	public String getParams(Map paramMap){
		if (paramMap == null){
			return "";
		}
		StringBuilder params = new StringBuilder();
		for (Map.Entry<String, String[]> param : ((Map<String, String[]>)paramMap).entrySet()){
			params.append(("".equals(params.toString()) ? "" : "&") + param.getKey() + "=");
			String paramValue = (param.getValue() != null && param.getValue().length > 0 ? param.getValue()[0] : "");
			params.append(StringUtils.abbr(StringUtils.endsWithIgnoreCase(param.getKey(), "password") ? "" : paramValue, 100));
		}
		return params.toString();
	}
	
	@Override
	public String toString() {
		return ReflectionToStringBuilder.toString(this);
	}
}