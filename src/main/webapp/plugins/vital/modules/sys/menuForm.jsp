<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/plugins/vital/views/include/taglib.jsp"%>
<html>
<head>
	<title>菜单管理</title>
	<meta name="decorator" content="default"/>
	<%@include file="/plugins/vital/views/include/treeview.jsp" %>
	<script type="text/javascript">
		$(document).ready(function() {
			$("#name").focus();
			$("#inputForm").validate({
				submitHandler: function(form){
					loading('正在提交，请稍等...');
					form.submit();
				},
				errorContainer: "#messageBox",
				errorPlacement: function(error, element) {
					$("#messageBox").text("输入有误，请先更正。");
					if (element.is(":checkbox")||element.is(":radio")||element.parent().is(".input-append")){
						error.appendTo(element.parent().parent());
					} else {
						error.insertAfter(element);
					}
				}
			});
		});
		$(document).ready(function () {
			$("#tags").select2({
				tags:${allTags},
				maximumInputLength: 10
			});
		});
	</script>
</head>
<body>
	<form:form id="inputForm" modelAttribute="menu" action="${ctx}/sys/menu/save" method="post" class="form-horizontal">
		<form:hidden path="id"/>
		<sys:message content="${message}"/>
		<div class="control-group">
			<label class="control-label">上级菜单:</label>
			<div class="controls">
                <sys:treeselect id="menu" name="parent.id" value="${menu.parent.id}" labelName="parent.resourceName" labelValue="${menu.parent.resourceName}"
					title="菜单" url="/sys/menu/treeData" extId="${menu.id}" cssClass="required"/>
			</div>
		</div>
		<div class="control-group">
			<label class="control-label">资源名称:</label>
			<div class="controls">
				<form:input path="resourceName" htmlEscape="false" maxlength="50" class="required input-xlarge"/>
				<span class="help-inline"><font color="red">*</font> </span>
			</div>
		</div>
		<div class="control-group">
			<label class="control-label">资源类型:</label>
			<div class="controls">
				<form:select path="resourceType" class="input-medium">
					<form:options items="${fns:getDictList('resource_type')}" itemLabel="label" itemValue="value" htmlEscape="false"/>
				</form:select>
			</div>
		</div>
		<div class="control-group">
			<label class="control-label">所在领域:</label>
			<div class="controls">
				<form:select path="domainId">
					<form:options items="${domainList}" itemLabel="domainName" itemValue="id" htmlEscape="false"/>
				</form:select>
			</div>
		</div>
		<div class="control-group">
			<label class="control-label">全局权限:</label>
			<div class="controls">
				<form:select path="globalPermissions" class="input-medium">
					<form:options items="${fns:getDictList('global_permission')}" itemLabel="label" itemValue="value" htmlEscape="false"/>
				</form:select>
			</div>
		</div>
		<div class="control-group">
			<label class="control-label">标签:</label>
			<div class="controls">
				<input type="hidden" id="tags" name="tags" style="width:300px" value="${menu.tags}"/>
			</div>
		</div>

		<div class="control-group">
			<label class="control-label">链接:</label>
			<div class="controls">
				<form:input path="url" htmlEscape="false" maxlength="2000" class="input-xxlarge"/>
			</div>
		</div>

		<%--<div class="control-group">--%>
			<%--<label class="control-label">图标:</label>--%>
			<%--<div class="controls">--%>
				<%--<sys:iconselect id="icon" name="icon" value="${menu.icon}"/>--%>
			<%--</div>--%>
		<%--</div>--%>
		<div class="control-group">
			<label class="control-label">排序:</label>
			<div class="controls">
				<form:input path="serial" htmlEscape="false" maxlength="50" class="required digits input-small"/>
			</div>
		</div>
		<div class="control-group">
			<label class="control-label">可见:</label>
			<div class="controls">
				<form:radiobuttons path="isShow" items="${fns:getDictList('show_hide')}" itemLabel="label" itemValue="value" htmlEscape="false" class="required"/>
			</div>
		</div>
		<div class="control-group">
			<label class="control-label">权限标识:</label>
			<div class="controls">
				<form:input path="permission" htmlEscape="false" maxlength="100" class="input-xxlarge"/>
			</div>
		</div>
		<div class="control-group">
			<label class="control-label">API:</label>
			<div class="controls">
				<form:textarea path="api" htmlEscape="false" rows="3" maxlength="200" class="input-xxlarge"/>
			</div>
		</div>
		<div class="control-group">
			<label class="control-label">备注:</label>
			<div class="controls">
				<form:textarea path="description" htmlEscape="false" rows="3" maxlength="200" class="input-xxlarge"/>
			</div>
		</div>
		<div class="form-actions">
			<shiro:hasPermission name="sys_menu_edit"><input id="btnSubmit" class="btn btn-primary" type="submit" value="确 定"/>&nbsp;</shiro:hasPermission>
			<input id="btnCancel" class="btn btn-primary" type="button" value="取 消" onclick="history.go(-1)"/>
		</div>
	</form:form>
</body>
</html>