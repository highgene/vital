<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/plugins/vital/views/include/taglib.jsp"%>
<html>
<head>
	<title>授权实例管理</title>
	<meta name="decorator" content="default"/>
	<!--引入css-->
	<link rel="stylesheet" type="text/css" href="${ctxStatic}/css/base.css"/>
	<link rel="stylesheet" type="text/css" href="${ctxStatic}/css/index.css"/>
	<script type="text/javascript">
		function assign(targetid) {
			$.jBox.open("iframe:${ctx}/sys/target/targetAuthorize?id="+targetid, "设置权限",810,$(top.document).height()-200	,{
				buttons:{"确定分配":"ok", "关闭":true}, bottomText:"为实例授权。",submit:function(v, h, f){
					var map = h.find("iframe")[0].contentWindow.map;
					var targetid = h.find("iframe")[0].contentWindow.targetid;
					if (v=="ok"){
						// 执行保存
						loading('正在提交，请稍等...');
						//处理map
						var role_users="";
						if (map){
							map.forEach(function(value,key){
								for(var v in value){
									role_users+=","+key+"#"+value[v];
								}
							});
						}

						$('#role_users').val(role_users);
						$('#id').val(targetid);
						$('#targetAuthorizeForm').submit();
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
			$("#pageIndex").val(n);
			$("#pageSize").val(s);
			$("#searchForm").submit();
        	return false;
        }
		function add() {
			$("#searchForm").attr("action","${ctx}/sys/target/form");
			$("#searchForm").submit();
		}
	</script>
</head>
<body>
	<form id="targetAuthorizeForm" action="${ctx}/sys/target/saveAuthorize" method="post" class="hide">
		<input type="hidden" id="id" name="id" value=""/>
		<input id="role_users" type="hidden" name="role_users" value=""/>
	</form>

	<form:form id="searchForm" modelAttribute="target" action="${ctx}/sys/target/" method="post" class="breadcrumb form-search">
		<input id="pageIndex" name="pageIndex" type="hidden" value="${page.pageIndex}"/>
		<input id="pageSize" name="pageSize" type="hidden" value="${page.pageSize}"/>
			<li><label>实例名称：</label>
				<form:input path="objectName" htmlEscape="false" maxlength="100" class="input-medium"/>
			</li>
			<li>
			<label>所在领域：</label>
			<form:select path="domainId">
				<form:options items="${domainList}" itemLabel="domainName" itemValue="id" htmlEscape="false"/>
			</form:select>
			</li>
			<li class="btns"><input id="btnSubmit" class="btn btn-primary" type="submit" value="查询"/></li>
		<div class="f-r">
			<shiro:hasPermission name="sys_target_edit">
				<li class="btns"><input id="btnAdd" class="btn btn-primary" type="submit" value="新增" onclick="add()"/></li>
			</shiro:hasPermission>
		</div>
		<div class="clear"></div>
	</form:form>
	<sys:message content="${message}"/>
	<table class="dataTable mar-t20" width="100%" border="0" cellspacing="0" cellpadding="0">
		<thead>
			<tr>
				<th>实例ID</th>
				<th>实例名称</th>
				<th>实例编码</th>
				<th>创建时间</th>
				<shiro:hasPermission name="sys_target_edit"><th>操作</th></shiro:hasPermission>
			</tr>
		</thead>
		<tbody>
		<c:forEach items="${page.list}" var="target">
			<tr style="word-break: keep-all;white-space:nowrap;">
				<td>
						${target.id}
				</td>
				<td>
					<c:if test="${target.id eq '1'}">
						${target.objectName}
					</c:if>
					<c:if test="${target.id ne '1'}">
						<a href="${ctx}/sys/target/form?id=${target.id}">${target.objectName}${target.isDefault==1?"(默认)":""}</a>
					</c:if>
				</td>
				<td>
						${target.objectCode}
				</td>
				<td>
					<fmt:formatDate value="${target.createTime}" pattern="yyyy-MM-dd HH:mm:ss"/>
				</td>
				<shiro:hasPermission name="sys_target_edit"><td>
					<c:if test="${target.id ne '1'}">
						<a href="javascript:assign('${target.id}')">授权</a>
						<c:if test="${target.enableOrg==1}">
							<a href="${ctx}/sys/target/office_list?targetId=${target.id}">设置组织机构</a>
						</c:if>
						<c:if test="${target.isDefault!=1}">
							<a href="${ctx}/sys/target/form?id=${target.id}">修改</a>
							<a href="${ctx}/sys/target/delete?id=${target.id}" onclick="return confirmx('确认要删除该授权实例吗？', this.href)">删除</a>
						</c:if>
					</c:if>
				</td></shiro:hasPermission>
			</tr>
		</c:forEach>
		</tbody>
	</table>
	<div class="pagination">${page}</div>
</body>
</html>