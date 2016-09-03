<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/plugins/vital/views/include/taglib.jsp"%>
<html>
<head>
	<title>工程描述管理</title>
	<meta name="decorator" content="default"/>
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
	<ul class="nav nav-tabs">
		<li class="active"><a href="${ctx}/demo/projectDesc/">工程描述列表</a></li>
		<shiro:hasPermission name="demo_projectDesc_edit:${projectId}"><li><a href="${ctx}/demo/projectDesc/form">工程描述添加</a></li></shiro:hasPermission>
	</ul>

	<form:form id="searchForm" modelAttribute="projectDesc" action="${ctx}/demo/projectDesc/" method="post" class="breadcrumb form-search">
		<input id="pageIndex" name="pageIndex" type="hidden" value="${page.pageIndex}"/>
		<input id="pageSize" name="pageSize" type="hidden" value="${page.pageSize}"/>
		<ul class="ul-form">
			<li>
				<label>工程：</label>
				<form:select path="projectId">
					<form:options items="${projectList}" itemLabel="projectName" itemValue="id" htmlEscape="false"/>
				</form:select>
			</li>
			<li class="btns"><input id="btnSearch" class="btn btn-primary" type="submit" value="查询"/></li>

			<shiro:hasPermission name="demo_projectDesc_export:${projectId}">
				<li class="btns"><input id="btn1" class="btn btn-primary" type="submit" value="导出"/></li>
			</shiro:hasPermission>
			<shiro:hasPermission name="demo_projectDesc_print:${projectId}">
				<li class="btns"><input id="btn2" class="btn btn-primary" type="submit" value="打印"/></li>
			</shiro:hasPermission>
			<shiro:hasPermission name="demo_projectDesc_add:${projectId}">
				<li class="btns"><input id="btn3" class="btn btn-primary" type="submit" value="添加"/></li>
			</shiro:hasPermission>

			<li class="clearfix"></li>
		</ul>
	</form:form>

	<sys:message content="${message}"/>
	<table class="dataTable mar-t20" width="100%" border="0" cellspacing="0" cellpadding="0">
		<thead>
			<tr>
				<th>登录名</th>
				<th>编码</th>
				<th>顺序号</th>
				<th>其他字段</th>
				<th>update_time</th>
				<th>备注</th>
				<th>操作</th>
			</tr>
		</thead>
		<tbody>
		<c:forEach items="${page.list}" var="projectDesc">
			<tr>
				<td><a href="${ctx}/demo/projectDesc/form?id=${projectDesc.id}">${projectDesc.name}	</a></td>
				<td>${projectDesc.code}	</td>
				<td>${projectDesc.serial}	</td>
				<td>${projectDesc.other}	</td>
				<td><fmt:formatDate value="${projectDesc.updateTime}" pattern="yyyy-MM-dd HH:mm:ss"/>	</td>
				<td>${projectDesc.description}	</td>
				<td>
					<shiro:hasPermission name="demo_projectDesc_edit:${projectId}">
						<a href="${ctx}/demo/projectDesc/form?id=${projectDesc.id}">修改</a>
					</shiro:hasPermission>
					<shiro:hasPermission name="demo_projectDesc_delete:${projectId}">
						<a href="${ctx}/demo/projectDesc/delete?id=${projectDesc.id}" onclick="return confirmx('确认要删除该工程描述吗？', this.href)">删除</a>
					</shiro:hasPermission>


				</td>
			</tr>
		</c:forEach>
		</tbody>
	</table>
	<div class="pagination">${page}</div>
</body>
</html>