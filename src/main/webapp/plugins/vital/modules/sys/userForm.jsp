<%@ page contentType="text/html;charset=UTF-8" %>
<%
	response.setCharacterEncoding("utf8");
%>
<%@ include file="/plugins/vital/views/include/taglib.jsp"%>
<html>
<head>
	<title>用户管理</title>
	<meta name="decorator" content="default"/>
	<script type="text/javascript">
		$(document).ready(function() {
			$("#no").focus();
			$("#inputForm").validate({
				rules: {
					loginName: {remote: "${ctx}/sys/user/checkLoginName?oldLoginName=" + encodeURIComponent('${user.loginName}')}
				},
				messages: {
					loginName: {remote: "用户登录名已存在"},
					confirmNewPassword: {equalTo: "输入与上面相同的密码"}
				},
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
	<form:form id="inputForm" modelAttribute="user" action="${ctx}/sys/user/save" method="post" class="form-horizontal">
		<form:hidden path="id"/>
		<sys:message content="${message}"/>
		<table>
			<tr>
				<td>
					<div class="control-group">
						<label class="control-label">姓名:</label>
						<div class="controls">
							<form:input path="realName" htmlEscape="false" maxlength="50" class="required"/>
							<span class="help-inline"><font color="red">*</font> </span>
						</div>
					</div>
				</td>
				<td>
					<div class="control-group">
						<label class="control-label">登录名:</label>
						<div class="controls">
							<input id="oldLoginName" name="oldLoginName" type="hidden" value="${user.loginName}">
							<form:input path="loginName" htmlEscape="false" maxlength="50" class="required userName"/>
							<span class="help-inline"><font color="red">*</font> </span>
						</div>
					</div>
				</td>
			</tr>
			<tr>
				<td>
					<div class="control-group">
						<label class="control-label">密码:</label>
						<div class="controls">
							<input id="newPassword" name="newPassword" type="password" value="" maxlength="50" minlength="3" />
							<c:if test="${empty user.id}"><span class="help-inline"><font color="red">*</font> </span></c:if>
						</div>
					</div>
				</td>
				<td>
					<div class="control-group">
						<label class="control-label">确认密码:</label>
						<div class="controls">
							<input id="confirmNewPassword" name="confirmNewPassword" type="password" value="" maxlength="50" minlength="3" equalTo="#newPassword"/>
							<c:if test="${empty user.id}"><span class="help-inline"><font color="red">*</font> </span></c:if>
						</div>
					</div>
				</td>
			</tr>
			<tr>
				<td>
					<div class="control-group">
						<label class="control-label">手机:</label>
						<div class="controls">
							<form:input path="mobile" htmlEscape="false" maxlength="100"/>
						</div>
					</div>
				</td>
				<td>
					<div class="control-group">
						<label class="control-label">身份证:</label>
						<div class="controls">
							<form:input path="idCard" htmlEscape="false" maxlength="50" class="required"/>
							<span class="help-inline"><font color="red">*</font> </span>
						</div>
					</div>
				</td>
			</tr>
			<tr>
				<td>
					<div class="control-group">
						<label class="control-label">性别:</label>
						<div class="controls">
							<form:select path="sex">
								<form:options items="${fns:getDictList('sex')}" itemLabel="label" itemValue="value" htmlEscape="false"/>
							</form:select>
						</div>
					</div>
				</td>
				<td>
					<div class="control-group">
						<label class="control-label">邮箱:</label>
						<div class="controls">
							<form:input path="email" htmlEscape="false" maxlength="100" class="email"/>
						</div>
					</div>
				</td>
			</tr>
			<tr>
				<td>
					<div class="control-group">
						<label class="control-label">所在机构:</label>
						<div class="controls">
							<sys:treeselect id="office" name="office.id" value="${user.office.id}" labelName="office.name" labelValue="${user.office.name}"
											title="部门" url="/sys/office/treeData?type=2" cssClass="required" notAllowSelectParent="true"/>
						</div>
					</div>
				</td>
				<td>
					<div class="control-group">
						<label class="control-label">下次登录修改密码:</label>
						<div class="controls">
							<form:select path="isChangingPassword">
								<form:options items="${fns:getDictList('yes_no')}" itemLabel="label" itemValue="value" htmlEscape="false"/>
							</form:select>
							<span class="help-inline"><font color="red">*</font> </span>
						</div>
					</div>
				</td>
			</tr>
			<tr>
				<td colspan="2">
					<div class="control-group">
						<label class="control-label">顺序号:</label>
						<div class="controls">
							<form:input path="serial" htmlEscape="false" maxlength="50" class="required"/>
						</div>
					</div>
				</td>
			</tr>
			<tr>
			<td colspan="2">
				<div class="control-group">
					<label class="control-label">备注:</label>
					<div class="controls" width="95%">
						<form:textarea path="description" htmlEscape="false" rows="3" maxlength="500"  class="input-xlarge" cssStyle="width: 95%"/>
					</div>
				</div>
			</td>
		</tr>
		</table>

		<div class="form-actions">
			<shiro:hasPermission name="sys_user_edit"><input id="btnSubmit" class="btn btn-primary" type="submit" value="确 定"/>&nbsp;</shiro:hasPermission>
			<input id="btnCancel" class="btn btn-primary" type="button" value="取 消" onclick="history.go(-1)"/>
		</div>
	</form:form>
</body>
</html>