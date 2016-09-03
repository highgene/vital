<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/plugins/vital/views/include/taglib.jsp"%>
<html>
<head>
	<title>工程描述管理</title>
	<meta name="decorator" content="default"/>
	<script type="text/javascript">
		$(document).ready(function() {
			//$("#name").focus();
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
		<li><a href="${ctx}/demo/projectDesc/">工程描述列表</a></li>
		<li class="active"><a href="${ctx}/demo/projectDesc/form?id=${projectDesc.id}">工程描述<shiro:hasPermission name="demo:projectDesc:edit">${not empty projectDesc.id?'修改':'添加'}</shiro:hasPermission><shiro:lacksPermission name="demo:projectDesc:edit">查看</shiro:lacksPermission></a></li>
	</ul><br/>
	<form:form id="inputForm" modelAttribute="projectDesc" action="${ctx}/demo/projectDesc/save" method="post" class="form-horizontal">
		<form:hidden path="id"/>
		<sys:message content="${message}"/>		
		<div class="control-group">
			<label class="control-label">名称：</label>
			<div class="controls">
				<form:input path="name" htmlEscape="false" maxlength="50" class="input-xlarge "/>
			</div>
		</div>
		<div class="control-group">
			<label class="control-label">工程：</label>
			<div class="controls">
				<form:select path="projectId">
					<form:options items="${projectList}" itemLabel="projectName" itemValue="id" htmlEscape="false"/>
				</form:select>
			</div>
		</div>

		<div class="control-group">
			<label class="control-label">顺序号：</label>
			<div class="controls">
				<form:input path="serial" htmlEscape="false" maxlength="11" class="input-xlarge "/>
			</div>
		</div>
		<div class="control-group">
			<label class="control-label">其他字段：</label>
			<div class="controls">
				<form:input path="other" htmlEscape="false" maxlength="50" class="input-xlarge "/>
			</div>
		</div>
		<div class="control-group">
			<label class="control-label">备注：</label>
			<div class="controls">
				<form:textarea path="description" htmlEscape="false" rows="4" maxlength="500" class="input-xxlarge "/>
			</div>
		</div>
		<div class="form-actions">
			<shiro:hasPermission name="demo_projectDesc_edit"><input id="btnSubmit" class="btn btn-primary" type="submit" value="确 定"/>&nbsp;</shiro:hasPermission>
			<input id="btnCancel" class="btn btn-primary" type="button" value="取 消" onclick="history.go(-1)"/>
		</div>
	</form:form>
</body>
</html>