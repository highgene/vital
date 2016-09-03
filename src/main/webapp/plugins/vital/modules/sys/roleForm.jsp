<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/plugins/vital/views/include/taglib.jsp"%>
<html>
<head>
	<title>角色管理</title>
	<meta name="decorator" content="default"/>
	<%@include file="/plugins/vital/views/include/treeview.jsp" %>
	<script type="text/javascript">
		//菜单
		var zNodes=[
				<c:forEach items="${menuList}" var="menu">{id:"${menu.id}", pId:"${not empty menu.parent.id?menu.parent.id:0}", name:"${not empty menu.parent.id?menu.resourceName:'权限列表'}",domainId:"${menu.domainId}"},
			</c:forEach>];
		var setting = {check:{enable:true,nocheckInherit:true},view:{selectedMulti:false},
			data:{simpleData:{enable:true}},callback:{beforeClick:function(id, node){
				tree.checkNode(node, !node.checked, true, true);
				return false;
			}}};
		var tree={};

		$(document).ready(function(){
			$("#name").focus();
			$("#inputForm").validate({
				rules: {
					name: {remote: "${ctx}/sys/role/checkName?oldName=" + encodeURIComponent("${role.roleName}")},
					roleCode: {remote: "${ctx}/sys/role/checkEnname?oldEnname=" + encodeURIComponent("${role.roleCode}")}
				},
				messages: {
					name: {remote: "角色名已存在"},
					roleCode: {remote: "英文名已存在"}
				},
				submitHandler: function(form){
					var ids = [], nodes = tree.getCheckedNodes(true);
					for(var i=0; i<nodes.length; i++) {
						ids.push(nodes[i].id);
					}
					$("#menuIds").val(ids);
					var ids2 = [], nodes2 = tree.getCheckedNodes(true);
					for(var i=0; i<nodes2.length; i++) {
						ids2.push(nodes2[i].id);
					}
					$("#officeIds").val(ids2);
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

			//初始化菜单
			initMenu();
		});

		function initMenu() {
			// 用户-菜单
			var domainId=$("#domainId").val();
			var menus = getMenuByDomainId(zNodes, domainId);//根据领域获取菜单
			// 初始化树结构
			tree = $.fn.zTree.init($("#menuTree"), setting, menus);
			// 不选择父节点
			tree.setting.check.chkboxType = { "Y" : "ps", "N" : "s" };
			// 默认选择节点
			var ids = "${role.menuIds}".split(",");
			for(var i=0; i<ids.length; i++) {
				var node = tree.getNodeByParam("id", ids[i]);
				try{tree.checkNode(node, true, false);}catch(e){}
			}
			// 默认展开全部节点
			tree.expandAll(true);
		}

		$(document).ready(function () {
			$("#tags").select2({
				tags:${allTags},
				maximumInputLength: 10
			});
		});
		
		function domainChange() {
			initMenu();
		}

		function getMenuByDomainId(menus,domainId) {
			var nodes=[];
			for(var i=0;i<menus.length;i++){
				var menu=menus[i];
				if (domainId==menu.domainId){
					nodes.push(menu);
				}
			}
			return nodes;
		}
		
	</script>
</head>
<body>
	<form:form id="inputForm" modelAttribute="role" action="${ctx}/sys/role/save" method="post" class="form-horizontal">
		<form:hidden path="id"/>
		<sys:message content="${message}"/>
		<div class="control-group">
			<label class="control-label">角色编码:</label>
			<div class="controls">
				<input id="oldEnname" name="oldEnname" type="hidden" value="${role.roleCode}">
				<form:input path="roleCode" htmlEscape="false" maxlength="50" class="required"/>
				<span class="help-inline"><font color="red">*</font> 角色编码</span>
			</div>
		</div>
		<div class="control-group">
			<label class="control-label">角色名称:</label>
			<div class="controls">
				<input id="oldName" name="oldName" type="hidden" value="${role.roleName}">
				<form:input path="roleName" htmlEscape="false" maxlength="50" class="required"/>
				<span class="help-inline"><font color="red">*</font> </span>
			</div>
		</div>
		<div class="control-group">
			<label class="control-label">是否内置:</label>
			<div class="controls">
				<form:select path="innate">
					<form:options items="${fns:getDictList('yes_no')}" itemLabel="label" itemValue="value" htmlEscape="false"/>
				</form:select>
			</div>
		</div>
		<div class="control-group">
			<label class="control-label">所在领域:</label>
			<div class="controls">
				<form:select path="domainId" onchange="domainChange()">
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
				<input type="hidden" id="tags" name="tags" style="width:300px" value="${role.tags}"/>
			</div>
		</div>

		<div class="control-group">
			<label class="control-label">角色授权:</label>
			<div class="controls">
				<div id="menuTree" class="ztree" style="margin-top:3px;float:left;"></div>
				<form:hidden path="menuIds"/>
				<div id="officeTree" class="ztree" style="margin-left:100px;margin-top:3px;float:left;"></div>
				<form:hidden path="officeIds"/>
			</div>
		</div>
		<div class="control-group">
			<label class="control-label">备注:</label>
			<div class="controls">
				<form:textarea path="description" htmlEscape="false" rows="3" maxlength="200" class="input-xlarge"/>
			</div>
		</div>
		<div class="form-actions">
			<c:if test="${fns:getUser().admin}">
				<shiro:hasPermission name="sys_role_edit"><input id="btnSubmit" class="btn btn-primary" type="submit" value="确 定"/>&nbsp;</shiro:hasPermission>
			</c:if>
			<input id="btnCancel" class="btn btn-primary" type="button" value="取 消" onclick="history.go(-1)"/>
		</div>
	</form:form>
</body>
</html>