<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/plugins/vital/views/include/taglib.jsp"%>
<html>
<head>
	<title>分配角色</title>
	<meta name="decorator" content="default"/>
	<!--引入css-->
	<link rel="stylesheet" type="text/css" href="${ctxStatic}/css/base.css"/>
	<link rel="stylesheet" type="text/css" href="${ctxStatic}/css/index.css"/>
</head>
<body>
	<ul class="nav nav-tabs">
		<li><a href="${ctx}/sys/role/">角色列表</a></li>
		<li class="active"><a href="${ctx}/sys/role/assign?id=${role.id}"><shiro:hasPermission name="sys_role_edit">角色分配</shiro:hasPermission><shiro:lacksPermission name="sys_role_edit">人员列表</shiro:lacksPermission></a></li>
	</ul>
	<div class="container-fluid breadcrumb">
		<div class="row-fluid span12">
			<span class="span4">角色名称: <b>${role.roleName}</b></span>
			<span class="span4">英文名称: ${role.roleCode}</span>
		</div>
		<div class="row-fluid span8">
			<span class="span4">角色类型: ${role.globalPermissions}</span>
		</div>
	</div>
	<sys:message content="${message}"/>
	<div class="breadcrumb">
		<form id="assignRoleForm" action="${ctx}/sys/role/assignrole" method="post" class="hide">
			<input type="hidden" name="id" value="${role.id}"/>
			<input id="idsArr" type="hidden" name="idsArr" value=""/>
		</form>
		<input id="assignButton" class="btn btn-primary" type="submit" value="分配角色"/>
		<script type="text/javascript">
			$("#assignButton").click(function(){
				$.jBox.open("iframe:${ctx}/sys/role/usertorole?id=${role.id}", "分配角色",810,$(top.document).height()-240,{
					buttons:{"确定分配":"ok", "清除已选":"clear", "关闭":true}, bottomText:"通过选择部门，然后为列出的人员分配角色。",submit:function(v, h, f){
						var pre_ids = h.find("iframe")[0].contentWindow.pre_ids;
						var ids = h.find("iframe")[0].contentWindow.ids;
						//nodes = selectedTree.getSelectedNodes();
						if (v=="ok"){
							// 删除''的元素
							if(ids[0]==''){
								ids.shift();
								pre_ids.shift();
							}
							if(pre_ids.sort().toString() == ids.sort().toString()){
								$.jBox.tip("未给角色【${role.roleName}】分配新成员！", 'info');
								return false;
							};
					    	// 执行保存
					    	loading('正在提交，请稍等...');
					    	var idsArr = "";
					    	for (var i = 0; i<ids.length; i++) {
					    		idsArr = (idsArr + ids[i]) + (((i + 1)== ids.length) ? '':',');
					    	}
					    	$('#idsArr').val(idsArr);
					    	$('#assignRoleForm').submit();
					    	return true;
						} else if (v=="clear"){
							h.find("iframe")[0].contentWindow.clearAssign();
							return false;
		                }
					}, loaded:function(h){
						$(".jbox-content", top.document).css("overflow-y","hidden");
					}
				});
			});
		</script>
	</div>
	<table class="dataTable mar-t20" width="100%" border="0" cellspacing="0" cellpadding="0">
		<thead><tr><th>所在机构</th><th>登录名</th><th>姓名</th><th>手机</th><shiro:hasPermission name="sys_user_edit"><th>操作</th></shiro:hasPermission></tr></thead>
		<tbody>
		<c:forEach items="${userList}" var="user">
			<tr>
				<td>${user.office.name}</td>
				<td><a href="${ctx}/sys/user/form?id=${user.id}">${user.loginName}</a></td>
				<td>${user.realName}</td>
				<td>${user.mobile}</td>
				<shiro:hasPermission name="sys_role_edit"><td>
					<a href="${ctx}/sys/role/outrole?userId=${user.id}&roleId=${role.id}" 
						onclick="return confirmx('确认要将用户<b>[${user.loginName}]</b>从<b>[${role.roleName}]</b>角色中移除吗？', this.href)">移除</a>
				</td></shiro:hasPermission>
			</tr>
		</c:forEach>
		</tbody>
	</table>
</body>
</html>
