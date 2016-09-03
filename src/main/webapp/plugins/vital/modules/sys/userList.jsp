<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/plugins/vital/views/include/taglib.jsp"%>
<html>
<head>
	<title>用户管理</title>
	<meta name="decorator" content="default"/>
	<!--引入css-->
	<link rel="stylesheet" type="text/css" href="${ctxStatic}/css/base.css"/>
	<link rel="stylesheet" type="text/css" href="${ctxStatic}/css/index.css"/>
	<script type="text/javascript">
		$(document).ready(function() {
		});
		function page(n,s){
			if(n) $("#pageIndex").val(n);
			if(s) $("#pageSize").val(s);
			$("#searchForm").attr("action","${ctx}/sys/user/list");
			$("#searchForm").submit();
	    	return false;
	    }
	    function lock(userid) {
			$.jBox.confirm("确认要锁定该用户吗？","系统提示",function(v,h,f){
				if(v=="ok"){
					$.post("${ctx}/sys/user/lock", {id:userid}, function(data){
						$("#btnSubmit").click();
					}, "text");
				}
			},{buttonsFocus:1});
			top.$('.jbox-body .jbox-icon').css('top','55px');
		}
		function unlock(userid) {
			$.jBox.confirm("确认要锁定该用户吗？","系统提示",function(v,h,f){
				if(v=="ok"){
					$.post("${ctx}/sys/user/unlock", {id:userid}, function(data){
						$("#btnSubmit").click();
					}, "text");
				}
			},{buttonsFocus:1});
			top.$('.jbox-body .jbox-icon').css('top','55px');
		}
		function add() {
			$("#searchForm").attr("action","${ctx}/sys/user/form");
			$("#searchForm").submit();
		}

	</script>
</head>
<body>
	<form:form id="searchForm" modelAttribute="user" action="${ctx}/sys/user/list" method="post" class="breadcrumb form-search ">
		<input id="pageIndex" name="pageIndex" type="hidden" value="${page.pageIndex}"/>
		<input id="pageSize" name="pageSize" type="hidden" value="${page.pageSize}"/>
		<sys:tableSort id="orderBy" name="orderBy" value="${page.orderBy}" callback="page();"/>

		<li><label>登录名：</label><form:input path="loginName" htmlEscape="false" maxlength="50" class="input-medium"/></li>
		<li><label>所在机构：</label><sys:treeselect id="office" name="office.id" value="${user.office.id}" labelName="office.name" labelValue="${user.office.name}"
												title="部门" url="/sys/office/treeData?type=2" cssClass="input-small" allowClear="true" notAllowSelectParent="true"/></li>
		<li><label>姓&nbsp;&nbsp;&nbsp;名：</label><form:input path="realName" htmlEscape="false" maxlength="50" class="input-medium"/></li>
		<li class="btns"><input id="btnSubmit" class="btn btn-primary" type="submit" value="查询" onclick="return page();"/></li>

		<div class="f-r">
			<shiro:hasPermission name="sys_user_edit">
				<li class="btns"><input id="btnAdd" class="btn btn-primary" type="submit" value="新增" onclick="add()"/></li>
			</shiro:hasPermission>
		</div>
		<div class="clear"></div>
	</form:form>
	<sys:message content="${message}"/>
	<table class="dataTable mar-t20" width="100%" border="0" cellspacing="0" cellpadding="0">
		<thead><tr>
			<th class="sort-column login_name">登录名</th>
			<th class="sort-column name">姓名</th>
			<th>手机</th>
			<th>邮箱</th>
			<th>登录次数</th>
			<th>最近登录时间</th>
			<th>创建时间</th>
			<shiro:hasPermission name="sys_user_edit"><th>操作</th></shiro:hasPermission>
		</tr></thead>
		<tbody>
		<c:forEach items="${page.list}" var="user">
			<tr>
				<td><a href="${ctx}/sys/user/form?id=${user.id}">${user.loginName}</a></td>
				<td>${user.realName}</td>
				<td>${user.mobile}</td>
				<td>${user.email}</td>
				<td>${user.logined}</td>
				<td><fmt:formatDate value="${user.lastLoginedTime}" type="both" dateStyle="full" pattern="yyyy-MM-dd HH:mm:ss"/></td>
				<td><fmt:formatDate value="${user.createTime}" type="both" dateStyle="full" pattern="yyyy-MM-dd HH:mm:ss"/></td>
				<shiro:hasPermission name="sys_user_edit"><td>
					<a href="javascript:assign('${user.id}')">授权</a>
					<a href="javascript:showAuthorize('${user.id}')">授权结果</a>
    				<a href="${ctx}/sys/user/form?id=${user.id}">编辑</a>
					<c:if test="${user.isdisabled==1}">
						<a href="javascript:unlock('${user.id}')">解锁</a>
					</c:if>
					<c:if test="${user.isdisabled!=1}">
						<a href="javascript:lock('${user.id}')">锁定</a>
					</c:if>
					<a href="javascript:modifyPwd('${user.id}')">重置密码</a>
					<c:if test="${currentUser.id!=user.id}">
						<a href="${ctx}/sys/user/delete?id=${user.id}" onclick="return confirmx('确认要删除该用户吗？', this.href)">删除</a>
					</c:if>
				</td></shiro:hasPermission>
			</tr>
		</c:forEach>
		</tbody>
	</table>
	<div class="pagination">${page}</div>
	<!--授权页面-->
	<form id="userAuthorizeForm" action="${ctx}/sys/user/saveAuthorize" method="post" class="hide">
		<input type="hidden" id="id" name="id" value="${user.id}"/>
		<input id="target_roles" type="hidden" name="target_roles" value=""/>
		<input id="systemDomainIds" type="hidden" name="systemDomainIds" value=""/>
	</form>

	<!--授权页面-->
	<script type="text/javascript">
		function assign(userid) {
			$.jBox.open("iframe:${ctx}/sys/user/userAuthorize?id="+userid, "设置权限",810,600	,{
				buttons:{"确定分配":"ok", "关闭":true}, bottomText:"为实例分配角色。",submit:function(v, h, f){
					var map = h.find("iframe")[0].contentWindow.map;
					var userid = h.find("iframe")[0].contentWindow.userid;
					var systemDomainIds = h.find("iframe")[0].contentWindow.getSystemDomain();
					if (v=="ok"){
						// 执行保存
						loading('正在提交，请稍等...');
						//处理map
						var target_roles="";
						if (map){
							map.forEach(function(value,key){
								for(var v in value){
									target_roles+=","+key+"#"+value[v];
								}
							});
						}

						$('#target_roles').val(target_roles);
						$('#id').val(userid);
						$('#systemDomainIds').val(systemDomainIds);
						$('#userAuthorizeForm').submit();
						return true;
					}
				}, loaded:function(h){
					$(".jbox-content", top.document).css("overflow-y","hidden");
				}
			});
		}

		function showAuthorize(userid) {
			$.jBox.open("iframe:${ctx}/sys/user/userShowAuthorize?id="+userid, "授权结果",810,600,{
				buttons:{"关闭":true}, bottomText:"查看授权结果。",submit:function(v, h, f){
				}, loaded:function(h){
					$(".jbox-content", top.document).css("overflow-y","hidden");
				}
			});
		}


		function modifyPwd(userid) {
			var token=$.jBox.open("iframe:${ctx}/sys/user/modifyPwd2Page", "修改密码",610,$(top.document).height()-400	,{
				buttons:{"确定":"ok", "关闭":true}, bottomText:"修改密码。",submit:function(v, h, f){
					if (v=="ok"){
						var newPassword = h.find("iframe")[0].contentWindow.$("#newPassword").val();
						var confirmNewPassword = h.find("iframe")[0].contentWindow.$("#confirmNewPassword").val();
						if(newPassword!=confirmNewPassword){
							alert("两次密码不一致!");
							return false;
						}
						$.post("${ctx}/sys/user/modifyPwd2", {id:userid,newPassword:newPassword,confirmNewPassword:confirmNewPassword}, function(data){
							if("true"==data){
								alert("密码修改成功!");
								$.jBox.close(token);
								return true;
							}
						}, "text");
						return false;
					}
				}, loaded:function(h){
					$(".jbox-content", top.document).css("overflow-y","hidden");
				}
			});
		}
		//alert(ApplicationResources.sys_user_login_name)
	</script>
	<fmt:message key="sys.user.organization"/>
</body>
</html>