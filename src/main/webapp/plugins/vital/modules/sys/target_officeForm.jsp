<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/plugins/vital/views/include/taglib.jsp"%>
<html>
<head>
	<title>机构管理</title>
	<meta name="decorator" content="default"/>
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
	</script>
</head>
<body>
	<ul class="nav nav-tabs">
		<li><a href="${ctx}/sys/target/?domainId=${target.domainId}">授权实例列表</a></li>
		<shiro:hasPermission name="sys_target_edit"><li><a href="${ctx}/sys/target/form?domainId=${target.domainId}">授权实例添加</a></li></shiro:hasPermission>
		<li><a href="${ctx}/sys/target/office_list?targetId=${office.targetId}">机构列表</a></li>
		<li class="active"><a href="${ctx}/sys/target/office_form?targetId=${office.targetId}">机构<shiro:hasPermission name="sys_office_edit">${not empty office.id?'修改':'添加'}</shiro:hasPermission><shiro:lacksPermission name="sys_office_edit">查看</shiro:lacksPermission></a></li>
	</ul><br/>
	<form:form id="inputForm" modelAttribute="office" action="${ctx}/sys/office/office_save" method="post" class="form-horizontal">
		<form:hidden path="id"/>
		<sys:message content="${message}"/>
        <form:hidden path="targetId" />

		<table>
			<tr>
				<td>
					<div class="control-group">
						<label class="control-label">机构编码:</label>
						<div class="controls">
							<form:input path="code" htmlEscape="false" maxlength="50"/>
						</div>
					</div>
				</td>
				<td>
					<div class="control-group">
						<label class="control-label">机构名称:</label>
						<div class="controls">
							<form:input path="name" htmlEscape="false" maxlength="50" class="required"/>
							<span class="help-inline"><font color="red">*</font> </span>
						</div>
					</div>
				</td>
			</tr>
			<tr>

				<td>
					<div class="control-group">
						<label class="control-label">机构类型:</label>
						<div class="controls">
							<form:select path="type" class="input-medium">
								<form:options items="${fns:getDictList('sys_office_type')}" itemLabel="label" itemValue="value" htmlEscape="false"/>
							</form:select>
						</div>
					</div>
				</td>
				<td>
					<div class="control-group">
						<label class="control-label">公司地址:</label>
						<div class="controls">
							<form:input path="orgAddr" htmlEscape="false" maxlength="50"/>
						</div>
					</div>
				</td>
			</tr>
			<tr>

				<td>
					<div class="control-group">
						<label class="control-label">联系人:</label>
						<div class="controls">
							<form:input path="username" htmlEscape="false" maxlength="50"/>
						</div>
					</div>
				</td>
				<td>
					<div class="control-group">
						<label class="control-label">联系电话:</label>
						<div class="controls">
							<form:input path="phone" htmlEscape="false" maxlength="50"/>
						</div>
					</div>
				</td>
			</tr>
			<tr>
				<td>
					<div class="control-group">
						<label class="control-label">级次:</label>
						<div class="controls">
							<form:select path="orgLevel">
								<form:options items="${fns:getDictList('org_level')}" itemLabel="label" itemValue="value" htmlEscape="false"/>
							</form:select>
						</div>
					</div>
				</td>
				<td>

					<div class="control-group">
						<label class="control-label">级次:</label>
						<div class="controls">
							<form:select path="orgLocation">
								<form:options items="${fns:getDictList('org_location')}" itemLabel="label" itemValue="value" htmlEscape="false"/>
							</form:select>
						</div>
					</div>
				</td>
			</tr>
			<tr>
				<td colspan="2">
					<div class="control-group">
						<label class="control-label">备注:</label>
						<div class="controls">
							<form:textarea path="description" htmlEscape="false" rows="3" maxlength="200" class="input-xlarge" cssStyle="width: 95%"/>
						</div>
					</div>
				</td>
			</tr>
		</table>



		<td>
			<div class="control-group">
				<label class="control-label">上级机构:</label>
				<div class="controls">
					<sys:treeselect id="office" name="parent.id" value="${office.parent.id}" labelName="parent.name" labelValue="${office.parent.name}"
									title="机构" url="/sys/office/treeData?targetId=${office.targetId}" extId="${office.id}" cssClass="" allowClear="${office.currentUser.admin}"/>
				</div>
			</div>
		</td>






		<div class="form-actions">
			<shiro:hasPermission name="sys_office_edit"><input id="btnSubmit" class="btn btn-primary" type="submit" value="确 定"/>&nbsp;</shiro:hasPermission>
			<input id="btnCancel" class="btn btn-primary" type="button" value="取 消" onclick="history.go(-1)"/>
		</div>
	</form:form>
</body>
</html>