<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/plugins/vital/views/include/taglib.jsp"%>
<html>
<head>
	<title>机构管理</title>
	<meta name="decorator" content="default"/>
	<!--引入css-->
	<link rel="stylesheet" type="text/css" href="${ctxStatic}/css/base.css"/>
	<link rel="stylesheet" type="text/css" href="${ctxStatic}/css/index.css"/>
	<%@include file="/plugins/vital/views/include/treetable.jsp" %>
	<link rel="stylesheet" type="text/css" href="${ctxStatic}/css/vital.css"/>
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

		function updateSort() {
			loading('正在提交，请稍等...');
			$("#listForm").attr("action", "${ctx}/sys/office/updateSort");
			$("#listForm").submit();
		}
		function add() {
			$("#listForm").attr("action","${ctx}/sys/office/form?parent.id=${office.id}");
			$("#listForm").submit();
		}
	</script>
</head>
<body>
	<sys:message content="${message}"/>
	<form id="listForm" method="post">
		<div class="f-r">
			<shiro:hasPermission name="sys_office_edit">
				&nbsp;<input id="btnAdd" class="btn btn-primary" type="submit" value="新增" onclick="add()"/>
			</shiro:hasPermission>
		</div>
		<br>
		<div class="clear"></div>
	<table id="treeTable" class="dataTable mar-t20" width="100%" border="0" cellspacing="0" cellpadding="0">
		<thead><tr><th>机构名称</th><th>机构编码</th><th>排序</th><th>机构类型</th><th>备注</th><shiro:hasPermission name="sys_office_edit"><th>操作</th></shiro:hasPermission></tr></thead>
		<tbody id="treeTableList"></tbody>
	</table>
	<script type="text/template" id="treeTableTpl">
		<tr id="{{row.id}}" pId="{{pid}}">
			<td style="text-align: left"><a href="${ctx}/sys/office/form?id={{row.id}}">{{row.name}}</a></td>
			<td>{{row.code}}</td>
			<td style="text-align:center;">
				<shiro:hasPermission name="sys_office_edit">
					<input type="hidden" name="ids" value="{{row.id}}"/>
					<input name="sorts" type="text" value="{{row.sort}}" style="width:50px;margin:0;padding:0;text-align:center;">
				</shiro:hasPermission>
				<shiro:lacksPermission name="sys_office_edit">
					${office.sort}
				</shiro:lacksPermission>
			</td>
			<td>{{dict.type}}</td>
			<td>{{row.description}}</td>
			<shiro:hasPermission name="sys_office_edit"><td>
				<a href="${ctx}/sys/office/form?id={{row.id}}">修改</a>
				<a href="${ctx}/sys/office/delete?id={{row.id}}" onclick="return confirmx('要删除该机构及所有子机构项吗？', this.href)">删除</a>
				<a href="${ctx}/sys/office/form?parent.id={{row.id}}">添加机构</a>
			</td></shiro:hasPermission>
		</tr>
	</script>
	<shiro:hasPermission name="sys_office_edit">
		<div class="form-actions pagination-left">
			<input id="btnSubmit" class="btn btn-primary" type="button" value="保存排序" onclick="updateSort();"/>
		</div>
	</shiro:hasPermission>
	</form>
</body>
</html>