<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/plugins/vital/views/include/taglib.jsp"%>
<html>
<head>
	<title>菜单管理</title>
	<meta name="decorator" content="default"/>
	<%@include file="/plugins/vital/views/include/treetable.jsp" %>
	<link rel="stylesheet" type="text/css" href="${ctxStatic}/css/vital.css"/>

	<script type="text/javascript">
		$(document).ready(function() {
			$("#treeTable").treeTable({expandLevel : 3}).show();
		});
    	function updateSort() {
			loading('正在提交，请稍等...');
	    	$("#listForm").attr("action", "${ctx}/sys/menu/updateSort");
	    	$("#listForm").submit();
    	}
		function add() {
			$("#searchForm").attr("action","${ctx}/sys/menu/form");
			$("#searchForm").submit();
		}
	</script>
</head>
<body>
	<sys:message content="${message}"/>
	<form:form id="searchForm" modelAttribute="menu" action="${ctx}/sys/menu/" method="post" class="breadcrumb form-search">
			<li>
				<label>所在领域：</label>
				<form:select path="domainId">
					<form:options items="${domainList}" itemLabel="domainName" itemValue="id" htmlEscape="false"/>
				</form:select>
			</li>
			<li class="btns"><input id="btnSearch" class="btn btn-primary" type="submit" value="查询"/></li>

		<div class="f-r">
			<shiro:hasPermission name="sys_menu_edit">
				<li class="btns"><input id="btnAdd" class="btn btn-primary" type="submit" value="新增" onclick="add()"/></li>
			</shiro:hasPermission>
		</div>
		<div class="clear"></div>
	</form:form>

	<form id="listForm" method="post"> <!--table table-striped table-bordered table-condensed hide -->
		<table id="treeTable" class="dataTable mar-t20" width="100%" border="0" cellspacing="0" cellpadding="0">
			<thead>
			<tr>
				<th>名称</th>
				<th>链接</th>
				<th style="text-align:center;">排序</th>
				<th>可见</th><th>权限标识</th>
				<shiro:hasPermission name="sys_menu_edit"><th>操作</th></shiro:hasPermission>
			</tr>
			</thead>
			<tbody>
			<c:forEach items="${list}" var="menu">
				<tr id="${menu.id}" pId="${menu.parent.id ne '1'?menu.parent.id:'0'}">
					<td style="text-align: left" nowrap><i class="icon-${not empty menu.icon?menu.icon:' hide'}"></i><a href="${ctx}/sys/menu/form?id=${menu.id}">${menu.resourceName}</a></td>
					<td title="${menu.url}">${fns:abbr(menu.url,30)}</td>
					<td style="text-align:center;">
						<shiro:hasPermission name="sys_menu_edit">
							<input type="hidden" name="ids" value="${menu.id}"/>
							<input name="sorts" type="text" value="${menu.serial}" style="width:50px;margin:0;padding:0;text-align:center;">
						</shiro:hasPermission><shiro:lacksPermission name="sys_menu_edit">
							${menu.serial}
						</shiro:lacksPermission>
					</td>
					<td>${menu.isShow eq '1'?'显示':'隐藏'}</td>
					<td title="${menu.permission}">${fns:abbr(menu.permission,30)}</td>
					<shiro:hasPermission name="sys_menu_edit">
						<td nowrap>
							<a href="${ctx}/sys/menu/form?id=${menu.id}">修改</a>
							<a href="${ctx}/sys/menu/delete?id=${menu.id}" onclick="return confirmx('要删除该资源及所有子资源项吗？', this.href)">删除</a>
							<a href="${ctx}/sys/menu/form?parent.id=${menu.id}">添加资源</a>
						</td>
					</shiro:hasPermission>
				</tr>
			</c:forEach>
			</tbody>
		</table>
		<shiro:hasPermission name="sys_menu_edit">
			<div class="form-actions pagination-left">
				<input id="btnSubmit" class="btn btn-primary" type="button" value="保存排序" onclick="updateSort();"/>
			</div>
		</shiro:hasPermission>
	 </form>
</body>
</html>