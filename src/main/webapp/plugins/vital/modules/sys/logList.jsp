<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/plugins/vital/views/include/taglib.jsp"%>
<html>
<head>
	<title>日志管理</title>
	<meta name="decorator" content="default"/>
	<!--引入css-->
	<link rel="stylesheet" type="text/css" href="${ctxStatic}/css/base.css"/>
	<link rel="stylesheet" type="text/css" href="${ctxStatic}/css/index.css"/>
	<script type="text/javascript">
		function page(n,s){
			$("#pageIndex").val(n);
			$("#pageSize").val(s);
			$("#searchForm").submit();
	    	return false;
	    }
	</script>
</head>
<body>
<!-- 	<ul class="nav nav-tabs"> -->
<%-- 		<li class="active"><a href="${ctx}/sys/log/">日志列表</a></li> --%>
<!-- 	</ul> -->
	<form:form id="searchForm" action="${ctx}/sys/log/" method="post" class="breadcrumb form-search">
		<input id="pageIndex" name="pageIndex" type="hidden" value="${page.pageIndex}"/>
		<input id="pageSize" name="pageSize" type="hidden" value="${page.pageSize}"/>
		<div>
		<div style="margin-top:8px;">
			<label>日期范围：&nbsp;</label><input id="beginDate" name="beginDate" type="text" readonly="readonly" maxlength="20" class="input-mini Wdate"
				value="<fmt:formatDate value="${log.beginDate}" pattern="yyyy-MM-dd"/>" onclick="WdatePicker({dateFmt:'yyyy-MM-dd',isShowClear:false});"/>
			<label>&nbsp;--&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</label><input id="endDate" name="endDate" type="text" readonly="readonly" maxlength="20" class="input-mini Wdate"
				value="<fmt:formatDate value="${log.endDate}" pattern="yyyy-MM-dd"/>" onclick="WdatePicker({dateFmt:'yyyy-MM-dd',isShowClear:false});"/>&nbsp;&nbsp;
			&nbsp;&nbsp;&nbsp;<input id="logMessage" name="logMessage" type="text" maxlength="50" class="input-mini" value="${log.logMessage}"/>
			&nbsp;&nbsp;&nbsp;<input id="btnSubmit" class="btn btn-primary" type="submit" value="查询"/>&nbsp;&nbsp;
		</div>
			<div class="clear"></div>
	</form:form>
	<sys:message content="${message}"/>
	<table class="dataTable mar-t20" width="100%" border="0" cellspacing="0" cellpadding="0">
		<thead>
		<tr>
			<th>操作菜单</th>
			<th>操作用户</th>
			<th>URI</th>
			<th>操作者IP</th>
			<th>操作时间</th>
		</thead>
		<tbody><%request.setAttribute("strEnter", "\n");request.setAttribute("strTab", "\t");%>
		<c:forEach items="${page.list}" var="log">
			<tr style="word-break: keep-all;white-space:nowrap;">
				<td >${log.resourceId}</td>
				<td>${log.createUser.realName}</td>
				<td><strong>${log.logMessage}</strong></td>
				<td>${log.clientIp}</td>
				<td><fmt:formatDate value="${log.createTime}" type="both"  pattern="yyyy-MM-dd HH:mm:ss"/></td>
			</tr>
		</c:forEach>
		</tbody>
	</table>
	<div class="pagination">${page}</div>
</body>
</html>