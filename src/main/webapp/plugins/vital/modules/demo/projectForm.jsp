<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/plugins/vital/views/include/taglib.jsp"%>
<html>
<head>
	<title>工程管理</title>
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
		<li><a href="${ctx}/demo/project/">工程列表</a></li>
		<li class="active"><a href="${ctx}/demo/project/form?id=${project.id}">工程<shiro:hasPermission name="demo_project_edit">${not empty project.id?'修改':'添加'}</shiro:hasPermission><shiro:lacksPermission name="demo_project_edit">查看</shiro:lacksPermission></a></li>
	</ul><br/>
	<form:form id="inputForm" modelAttribute="project" action="${ctx}/demo/project/save" method="post" class="form-horizontal">
		<sys:message content="${message}"/>

		<c:if test="${project.id !=null}">
			<div class="control-group">
				<label class="control-label">ID：</label>
				<div class="controls">
					<form:input path="id" htmlEscape="false" maxlength="50" class="input-xlarge " readonly="true"/>
				</div>
			</div>
		</c:if>

		
		<div class="control-group">
			<label class="control-label">工程名：</label>
			<div class="controls">
				<form:input path="projectName" htmlEscape="false" maxlength="50" class="input-xlarge "/>
			</div>
		</div>
		<div class="control-group">
			<label class="control-label">管理员：</label>
			<div class="controls">
				<form:input path="manager" htmlEscape="false" maxlength="50" class="input-xlarge "/>
			</div>
		</div>
		<div class="control-group">
			<label class="control-label">顺序号：</label>
			<div class="controls">
				<form:input path="serial" htmlEscape="false" maxlength="11" class="input-xlarge "/>
			</div>
		</div>
		<div class="control-group">
			<label class="control-label">备注：</label>
			<div class="controls">
				<form:textarea path="description" htmlEscape="false" rows="4" maxlength="500" class="input-xxlarge "/>
			</div>
		</div>
		<div class="form-actions">
			<shiro:hasPermission name="demo_project_edit"><input id="btnSubmit" class="btn btn-primary" type="submit" value="确 定"/>&nbsp;</shiro:hasPermission>
			<input id="btnCancel" class="btn btn-primary" type="button" value="取 消" onclick="history.go(-1)"/>
		</div>
	</form:form>
</body>
</html>