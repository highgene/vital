<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/plugins/vital/views/include/taglib.jsp"%>
<html>
<head>
	<title>弹出窗示例</title>
	<meta name="decorator" content="default"/>
	<script type="text/javascript">
	</script>
</head>
<body>

	<form:form id="inputForm" class="form-horizontal">

		<div class="control-group">
			<label class="control-label">机构选择:</label>
			<div class="controls">
				<sys:treeselect id="office1" name="office1" value="${office.parent.id}" labelName="parent.name" labelValue="${office.parent.name}"
								title="机构" url="/sys/office/treeData" extId="${office.id}" cssClass="" allowClear="${office.currentUser.admin}"/>
			</div>
		</div>

		<div class="control-group">
			<label class="control-label">用户选择:</label>
			<div class="controls">
				<sys:treeselect id="user1" name="user1" value="${user.id}" labelName="user.name" labelValue="${user.realName}"
								title="用户" url="/sys/office/treeData?type=3" cssClass="" allowClear="true" notAllowSelectParent="true"/>
			</div>
		</div>

		<div class="control-group">
			<label class="control-label">机构选择(多选):</label>
			<div class="controls">
				<sys:treeselect id="office2" name="office2" value="${office.parent.id}" labelName="parent.name" labelValue="${office.parent.name}"
								title="机构" url="/sys/office/treeData" extId="${office.id}" cssClass="" allowClear="${office.currentUser.admin}" notAllowSelectParent="true" checked="true"/>
			</div>
		</div>

		<div class="control-group">
			<label class="control-label">用户选择(多选):</label>
			<div class="controls">
				<sys:treeselect id="user2" name="user2" value="${user.id}" labelName="user.name" labelValue="${user.realName}"
								title="用户" url="/sys/office/treeData?type=3" cssClass="" allowClear="true"  notAllowSelectParent="true" checked="true"/>
			</div>
		</div>
  

	</form:form>
</body>
</html>