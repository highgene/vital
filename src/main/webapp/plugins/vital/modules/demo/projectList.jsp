<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/plugins/vital/views/include/taglib.jsp"%>
<html>
<head>
	<title>工程管理</title>
	<meta name="decorator" content="default"/>
	<script type="text/javascript">
		$(document).ready(function() {
			
		});
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
		<li class="active"><a href="${ctx}/demo/project/">工程列表</a></li>
		<shiro:hasPermission name="demo_project_edit"><li><a href="${ctx}/demo/project/form">工程添加</a></li></shiro:hasPermission>
	</ul>
	<form:form id="searchForm" modelAttribute="project" action="${ctx}/demo/project/" method="post" class="breadcrumb form-search">
		<input id="pageIndex" name="pageIndex" type="hidden" value="${page.pageIndex}"/>
		<input id="pageSize" name="pageSize" type="hidden" value="${page.pageSize}"/>
		<ul class="ul-form">
			<li><label>工程名：</label>
				<form:input path="projectName" htmlEscape="false" maxlength="50" class="input-medium"/>
			</li>
			<li class="btns"><input id="btnSubmit" class="btn btn-primary" type="submit" value="查询"/></li>
			<li class="clearfix"></li>
		</ul>
	</form:form>
	<sys:message content="${message}"/>
	<table class="dataTable mar-t20" width="100%" border="0" cellspacing="0" cellpadding="0">
		<thead>
			<tr>
				<th>工程名</th>
				<th>管理员</th>
				<th>顺序号</th>
				<th>创建时间</th>
				<th>创建用户</th>
				<th>update_time</th>
				<th>修改用户</th>
				<th>备注</th>
				<shiro:hasPermission name="demo_project_edit"><th>操作</th></shiro:hasPermission>
			</tr>
		</thead>
		<tbody>
		<c:forEach items="${page.list}" var="project">
			<tr>
				<td><a href="${ctx}/demo/project/form?id=${project.id}">
					${project.projectName}
				</a></td>
				<td>
					${project.manager}
				</td>
				<td>
					${project.serial}
				</td>
				<td>
					<fmt:formatDate value="${project.createTime}" pattern="yyyy-MM-dd HH:mm:ss"/>
				</td>
				<td>
					${project.createUser.id}
				</td>
				<td>
					<fmt:formatDate value="${project.updateTime}" pattern="yyyy-MM-dd HH:mm:ss"/>
				</td>
				<td>
					${project.updateUser.id}
				</td>
				<td>
					${project.description}
				</td>
				<shiro:hasPermission name="demo_project_edit"><td>
    				<a href="${ctx}/demo/project/form?id=${project.id}">修改</a>
					<a href="${ctx}/demo/project/delete?id=${project.id}" onclick="return confirmx('确认要删除该工程吗？', this.href)">删除</a>
				</td></shiro:hasPermission>
			</tr>
		</c:forEach>
		</tbody>
	</table>
	<div class="pagination">${page}</div>
</body>
</html>