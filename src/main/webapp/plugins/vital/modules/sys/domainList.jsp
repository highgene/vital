<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/plugins/vital/views/include/taglib.jsp"%>
<html>
<head>
	<title>授权领域管理</title>
	<meta name="decorator" content="default"/>
	<!--引入css-->
	<link rel="stylesheet" type="text/css" href="${ctxStatic}/css/base.css"/>
	<link rel="stylesheet" type="text/css" href="${ctxStatic}/css/index.css"/>
	<script type="text/javascript">
		$(document).ready(function() {
			
		});
		function page(n,s){
			$("#pageIndex").val(n);
			$("#pageSize").val(s);
			$("#searchForm").submit();
        	return false;
        }
        function open_target(targetid) {
//			var menu=top.$("[href$='/a/sys/target/']");
//			menu.attr('href','/a/sys/target/form?id='+targetid);
//			top.addTab(menu, true);
//			menu.attr('href','/a/sys/target/');

			$("#searchForm").attr("action","${ctx}/sys/target/form?id="+targetid);
			$("#searchForm").submit();
		}
		function add() {
			$("#searchForm").attr("action","${ctx}/sys/domain/form");
			$("#searchForm").submit();
		}
	</script>
</head>
<body>
	<form:form id="searchForm" modelAttribute="domain" action="${ctx}/sys/domain/" method="post" class="breadcrumb form-search">
		<input id="pageIndex" name="pageIndex" type="hidden" value="${page.pageIndex}"/>
		<input id="pageSize" name="pageSize" type="hidden" value="${page.pageSize}"/>
			<li><label>领域名称：</label>
				<form:input path="domainName" htmlEscape="false" maxlength="50" class="input-medium"/>
			</li>
			<li class="btns"><input id="btnSubmit" class="btn btn-primary" type="submit" value="查询"/></li>

		<div class="f-r">
			<shiro:hasPermission name="sys_domain_edit">
				<li class="btns"><input id="btnAdd" class="btn btn-primary" type="submit" value="新增" onclick="add()"/></li>
			</shiro:hasPermission>
		</div>
		<div class="clear"></div>
	</form:form>
	<sys:message content="${message}"/>
	<table class="dataTable mar-t20" width="100%" border="0" cellspacing="0" cellpadding="0">
		<thead>
			<tr>
				<th>领域编码</th>
				<th>领域名称</th>
				<th>业务表名</th>
				<th>字段名</th>
				<th>URL地址</th>
				<th>默认实例</th>
				<th>是否内置</th>
				<th>是否启用组织机构</th>
				<th>是否启用多例模式</th>
				<th>创建时间</th>
				<th>描述</th>
				<shiro:hasPermission name="sys_domain_edit"><th>操作</th></shiro:hasPermission>
			</tr>
		</thead>
		<tbody>
		<c:forEach items="${page.list}" var="domain">
			<tr style="word-break: keep-all;white-space:nowrap;">
				<td>
					${domain.domainCode}
				</td>
				<td>
					<c:if test="${domain.id eq '1'}">
						${domain.domainName}
					</c:if>
					<c:if test="${domain.id ne '1'}">
						<a href="${ctx}/sys/domain/form?id=${domain.id}">${domain.domainName}</a>
					</c:if>
				</td>
				<td>
					${domain.entityName}
				</td>
				<td>
					${domain.pkName}
				</td>
				<td>
					${domain.summaryUrl}
				</td>
				<td>
					<a href="javascript:open_target('${domain.defaultTargetId}')">${domain.defaultTargetName}</a>
				</td>
				<td>
					${fns:getDictLabel(domain.innate, 'yes_no', '')}
				</td>
				<td>
					${fns:getDictLabel(domain.enableOrg, 'yes_no', '')}
				</td>
				<td>
					${fns:getDictLabel(domain.enableMulti, 'yes_no', '')}
				</td>
				<td>
					<fmt:formatDate value="${domain.createTime}" pattern="yyyy-MM-dd HH:mm:ss"/>
				</td>
				<td>
					${domain.description}
				</td>
				<shiro:hasPermission name="sys_domain_edit"><td>

					<c:if test="${domain.id ne '1'}">
						<a href="${ctx}/sys/domain/form?id=${domain.id}">修改</a>
						<a href="${ctx}/sys/domain/delete?id=${domain.id}" onclick="return confirmx('确认要删除该授权领域吗？', this.href)">删除</a>
					</c:if>
				</td></shiro:hasPermission>
			</tr>
		</c:forEach>
		</tbody>
	</table>
	<div class="pagination">${page}</div>
</body>
</html>