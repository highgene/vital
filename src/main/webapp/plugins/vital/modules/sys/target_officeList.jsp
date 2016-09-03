<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/plugins/vital/views/include/taglib.jsp"%>
<html>
<head>
	<title>机构管理</title>
	<meta name="decorator" content="default"/>
	<%@include file="/plugins/vital/views/include/treetable.jsp" %>
	<script type="text/javascript">
		$(document).ready(function() {
			var tpl = $("#treeTableTpl").html().replace(/(\/\/\<!\-\-)|(\/\/\-\->)/g,"");
			var data = ${fns:toJson(list)}, rootId = "${not empty office.id ? office.id : '0'}";
			addRow("#treeTableList", tpl, data, rootId, true);
			$("#treeTable").treeTable({expandLevel : 5});
		});
		function addRow(list, tpl, data, pid, root){
			for (var i=0; i<data.length; i++){
				var row = data[i];
				if ((${fns:jsGetVal('row.parentId')}) == pid){
					$(list).append(Mustache.render(tpl, {
						dict: {
							type: getDictLabel(${fns:toJson(fns:getDictList('sys_office_type'))}, row.type)
						}, pid: (root?0:pid), row: row
					}));
					addRow(list, tpl, data, row.id);
				}
			}
		}
	</script>
</head>
<body>
	<ul class="nav nav-tabs">
		<li><a href="${ctx}/sys/target/?domainId=${target.domainId}">授权实例列表</a></li>
		<shiro:hasPermission name="sys_target_edit"><li><a href="${ctx}/sys/target/form?domainId=${target.domainId}">授权实例添加</a></li></shiro:hasPermission>
		<li class="active"><a href="${ctx}/sys/target/office_list?targetId=${office.targetId}">机构列表</a></li>
		<shiro:hasPermission name="sys_office_edit"><li><a href="${ctx}/sys/target/office_form?targetId=${office.targetId}">机构添加</a></li></shiro:hasPermission>
	</ul>
	<sys:message content="${message}"/>
	<table id="treeTable" class="table table-striped table-bordered table-condensed">
		<thead><tr><th>机构名称</th><th>机构编码</th><th>机构类型</th><th>备注</th><shiro:hasPermission name="sys_office_edit"><th>操作</th></shiro:hasPermission></tr></thead>
		<tbody id="treeTableList"></tbody>
	</table>
	<script type="text/template" id="treeTableTpl">
		<tr id="{{row.id}}" pId="{{pid}}">
			<td><a href="${ctx}/sys/target/office_form?id={{row.id}}">{{row.name}}</a></td>
			<td>{{row.code}}</td>
			<td>{{dict.type}}</td>
			<td>{{row.description}}</td>
			<shiro:hasPermission name="sys_office_edit"><td>
				<a href="${ctx}/sys/target/office_form?id={{row.id}}">修改</a>
				<a href="${ctx}/sys/target/office_delete?id={{row.id}}" onclick="return confirmx('要删除该机构及所有子机构项吗？', this.href)">删除</a>
				<a href="${ctx}/sys/target/office_form?parentId={{row.id}}">添加机构</a>
			</td></shiro:hasPermission>
		</tr>
	</script>
</body>
</html>