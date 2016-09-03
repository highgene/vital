]<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/plugins/vital/views/include/taglib.jsp"%>
<html>
<head>
	<title>角色管理</title>
	<meta name="decorator" content="default"/>
	<!--引入css-->
	<link rel="stylesheet" type="text/css" href="${ctxStatic}/css/base.css"/>
	<link rel="stylesheet" type="text/css" href="${ctxStatic}/css/index.css"/>
	<script type="text/javascript">
		function assign(roleid) {
			$.jBox.open("iframe:${ctx}/sys/role/roleAuthorize?id="+roleid, "设置权限",810,$(top.document).height()-200	,{
				buttons:{"确定分配":"ok", "关闭":true}, bottomText:"为实例授权。",submit:function(v, h, f){
					var map = h.find("iframe")[0].contentWindow.map;
					var roleid = h.find("iframe")[0].contentWindow.roleid;

					if (v=="ok"){
						// 执行保存
						loading('正在提交，请稍等...');
						//处理map
						var target_users="";
						if (map){
							map.forEach(function(value,key){
								for(var v in value){
									target_users+=","+key+"#"+value[v];
								}
							});
						}

						$('#target_users').val(target_users);
						$('#id').val(roleid);

						$('#saveForm').attr("action","${ctx}/sys/role/saveAuthorize");
						$('#saveForm').submit();
						return true;
					}
				}, loaded:function(h){
					$(".jbox-content", top.document).css("overflow-y","hidden");
				}
			});
		}

		function roleBindingResource(roleid) {
			$.jBox.open("iframe:${ctx}/sys/role/roleBindingResource?id="+roleid, "分配权限",810,$(top.document).height()-200	,{
				buttons:{"确定分配":"ok", "关闭":true}, bottomText:"为角色分配权限。",submit:function(v, h, f){
                    var ids = h.find("iframe")[0].contentWindow.getSelectMenus();
					if (v=="ok"){
						// 执行保存
						loading('正在提交，请稍等...');
						$('#menuIds').val(ids);
						$('#id').val(roleid);
						$('#saveForm').attr("action","${ctx}/sys/role/saveResource");
						$('#saveForm').submit();
						return true;
					}
				}, loaded:function(h){
					$(".jbox-content", top.document).css("overflow-y","hidden");
				}
			});
		}

		$(document).ready(function() {

		});
		function page(n,s){
			$("#pageIndex").val(1);
			$("#pageSize").val(1000);
			$("#searchForm").submit();
			return false;
		}
		function add() {
			$("#searchForm").attr("action","${ctx}/sys/role/form");
			$("#searchForm").submit();
		}
	</script>
</head>
<body>
<form id="saveForm" action="${ctx}/sys/role/saveAuthorize" method="post" class="hide">
	<input type="hidden" id="id" name="id" value=""/>
	<input id="target_users" type="hidden" name="target_users" value=""/>
	<input id="menuIds" type="hidden" name="menuIds" value=""/>
</form>
	<form:form id="searchForm" modelAttribute="role" action="${ctx}/sys/role/list" method="post" class="breadcrumb form-search ">
		<input id="pageIndex" name="pageIndex" type="hidden" value="1"/>
		<input id="pageSize" name="pageSize" type="hidden" value="1000"/>
		<sys:tableSort id="orderBy" name="orderBy" value="${page.orderBy}" callback="page();"/>

		<label>所在领域：</label>
		<form:select path="domainId">
			<form:options items="${domainList}" itemLabel="domainName" itemValue="id" htmlEscape="false"/>
		</form:select>
		<input id="btnSubmit" class="btn btn-primary" type="submit" value="查询" onclick="return page();"/>

		<div class="f-r">
			<shiro:hasPermission name="sys_role_edit">
				<li class="btns"><input id="btnAdd" class="btn btn-primary" type="submit" value="新增" onclick="add()"/></li>
			</shiro:hasPermission>
		</div>
		<div class="clear"></div>
	</form:form>
	<sys:message content="${message}"/>
	<table class="dataTable mar-t20" width="100%" border="0" cellspacing="0" cellpadding="0">
		<tr>
			<th>角色名称</th>
			<th>角色编码</th>
			<th>全局权限</th>
			<th>标签</th>
			<th>是否内置</th>
			<th>备注</th>
			<shiro:hasPermission name="sys_role_edit"><th>操作</th></shiro:hasPermission></tr>
		<c:forEach items="${list}" var="role">
			<tr>
				<td><a href="form?id=${role.id}">${role.roleName}</a></td>
				<td><a href="form?id=${role.id}">${role.roleCode}</a></td>
				<td>${fns:getDictLabel(role.globalPermissions, 'global_permission', '无')}</td>
				<td>${role.tags}</td>
				<td>${fns:getDictLabel(role.globalPermissions, 'yes_no', '无')}</td>
				<td>${role.description}</td>
				<shiro:hasPermission name="sys_role_edit"><td>
					<a href="javascript:assign('${role.id}')">授权</a>
					<a href="javascript:roleBindingResource('${role.id}')">设置资源权限</a>
					<c:if test="${ fns:getUser().admin}">
						<a href="${ctx}/sys/role/form?id=${role.id}">修改</a>
					</c:if>
					<a href="${ctx}/sys/role/delete?id=${role.id}" onclick="return confirmx('确认要删除该角色吗？', this.href)">删除</a>
				</td></shiro:hasPermission>	
			</tr>
		</c:forEach>
	</table>
</body>
</html>
