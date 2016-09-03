<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/plugins/vital/views/include/taglib.jsp"%>
<html>
<head>
	<title>字典管理</title>
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
		function add() {
			$("#searchForm").attr("action","${ctx}/sys/dict/form?sort=10");
			$("#searchForm").submit();
		}
	</script>
	<script>try{$.jBox.closeTip();}catch(e){}</script>
</head>
<body>
	<form:form id="searchForm" modelAttribute="dict" action="${ctx}/sys/dict/" method="post">
		<input id="pageIndex" name="pageIndex" type="hidden" value="${page.pageIndex}"/>
		<input id="pageSize" name="pageSize" type="hidden" value="${page.pageSize}"/>
		<%--<label>类型：</label>--%>
		<%--<form:select id="paramName" path="paramName" class="input-medium">--%>
			<%--<form:option value="" label=""/>--%>
			<%--<form:options items="${typeList}" htmlEscape="false"/>--%>
		<%--</form:select>--%>
		<%--&nbsp;&nbsp;--%>
		<%--<label>描述 ：</label>--%>
		<%--<form:input path="description" htmlEscape="false" maxlength="50" class="input-medium"/>--%>
		<%--&nbsp;<input id="btnSubmit" class="btn btn-primary" type="submit" value="查询"/>--%>

		<div class="f-r">
			<shiro:hasPermission name="sys_dict_edit">
				<input id="btnAdd" class="btn btn-primary" type="submit" value="新增" onclick="add()"/>
			</shiro:hasPermission>
		</div>
	</form:form>
	<sys:message content="${message}"/>
	<table class="dataTable mar-t20" width="100%" border="0" cellspacing="0" cellpadding="0">
		<thead>
		<tr>
			<th>参数中文名</th>
			<th>参数名称</th>
			<th>参数值</th>
			<th>是否内置</th>
			<th>默认值</th>
			<th>备注</th>
			<shiro:hasPermission name="sys_dict_edit"><th>操作</th></shiro:hasPermission></tr></thead>
		<tbody>
		<c:forEach items="${page.list}" var="dict">
			<tr>
				<td><a href="${ctx}/sys/dict/form?id=${dict.id}">${dict.cnName}</a></td>
				<td><a href="javascript:" onclick="$('#paramName').val('${dict.paramName}');$('#searchForm').submit();return false;">${dict.paramName}</a></td>
				<td>${dict.paramValue}</td>
				<td>${fns:getDictLabel(dict.innate, 'yes_no', '否')}</td>
				<td>${dict.defaultValue}</td>
				<td>${dict.description}</td>
				<shiro:hasPermission name="sys_dict_edit"><td>
    				<a href="${ctx}/sys/dict/form?id=${dict.id}">修改</a>
					<a href="${ctx}/sys/dict/delete?id=${dict.id}&type=${dict.paramName}" onclick="return confirmx('确认要删除该字典吗？', this.href)">删除</a>
    				<a href="<c:url value='${fns:getAdminPath()}/sys/dict/form?type=${dict.paramName}&sort=${dict.sort+10}'><c:param name='description' value='${dict.description}'/></c:url>">添加键值</a>
				</td></shiro:hasPermission>
			</tr>
		</c:forEach>
		</tbody>
	</table>
	<div class="pagination">${page}</div>
</body>
</html>