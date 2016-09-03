<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>复制功能</title>
    <link rel="stylesheet" type="text/css" href="<%=basePath%>code/style/themes/bootstrap/easyui.css"/>
	<link rel="stylesheet" type="text/css" href="<%=basePath%>code/style/themes/icon.css"/>
	<link rel="stylesheet" type="text/css" href="<%=basePath%>code/style/themes/demo.css"/>
	<script type="text/javascript" src="<%=basePath%>code/js/jquery.min.js"></script>
	<script type="text/javascript" src="<%=basePath%>code/js/jquery.easyui.min.js"></script>
	<script type="text/javascript" src="<%=basePath%>code/js/jquery.json-2.2.js"></script>
	<script type="text/javascript" src="<%=basePath%>code/js/hhxy.js"></script>
</head>
<body>
<div id="copyfunctionDg" class="easyui-panel" data-options="fit:true" style="padding: 1px; text-align: left;height: 400px;">
	<form id="copyfunctionForm" method="post" >
		<fieldset ><legend>基本属性</legend>
		<table cellpadding="5" style="width:500px">
			<tr>
				<td style="text-align: right;width:80px"><b>场景名称:</b></td>
				<td><input id="scene_copy" class="easyui-textbox" type="text" name="scene"  validType="isExist['scene']"
					data-options="required:true" style="width: 290px"></input>
					<input type="hidden" name="id"></input></td>
			</tr>
			<tr>
				<td style="text-align: right;width:80px"><b>名称空间:</b></td>
				<td><input class="easyui-textbox" type="text" name="namespace"
					data-options="required:true" style="width: 290px" value="com.hhwy"></input></td>
			</tr>
			<tr>
				<td style="text-align: right;width:80px"><b>功能编号:</b></td>
				<td><input id="nfunId" class="easyui-textbox" type="text" name="funId" validType="isExist['funId']"
					data-options="required:true" style="width: 290px"></input>
					<input type="hidden" id="copyoFunId" name="oFunId"></input></td>
			</tr>
			<tr>
				<td style="text-align: right;width:80px"><b>功能名称:</b></td>
				<td><input class="easyui-textbox" name="name" validType="isExist['name']"
					data-options="required:true" style="width: 290px"></input></td>
			</tr>
			<tr>
				<td style="text-align: right;width:80px"><b>表&nbsp;名&nbsp;称:</b></td>
				<td ><select class="easyui-combobox" name="tableName" style="width: 290px" value="defaut_1"
							data-options="required:true,
										valueField: 'id',
									    textField: 'text',prompt:'可以选择已有的表，或者新建表',
									    url:'<%=basePath%>code/config/tables',
									    method:'get'"></select> 
					</td>
			</tr>
			<tr>
				<td style="text-align: right"><b>代码模板:</b></td>
				<td  title="选择生成代码的模板"><select id="templateCombobox" class="easyui-combobox" name="template" style="width: 290px"
						 data-options="valueField: 'id',
									    textField: 'text',
									    url: '<%=basePath%>code/codelibs/getTemplates',
									    method: 'get'"></select> </td>
			</tr>
			<tr>
				<td style="text-align: right;width:80px"><b>上级节点:</b></td>
				<td>
					<select class="easyui-combotree" style="width:290px;" name="parentText"
						data-options="
							panelHeight:180,
							url:'<%=basePath%>code/config/getFunctionsById',
                 			method:'get',
			                animate:true,
			                onClick: function(node){
								$('#copyParentId').val(node.id);
							}"/>
					<input id="copyParentId" type="hidden" name="parentId"></input>
				</td>
			</tr>
			<tr>
				<td style="text-align: right;width:80px"><b>资源路径:</b></td>
				<td><input class="easyui-textbox" name="resourcePath" data-options="prompt:'在权限资源树中的路径，格式：node1/node2/...'"
					 style="width: 290px"></input> </td>
			</tr>
		</table>
		</fieldset>
		<fieldset><legend>扩展配置</legend>
		<table cellpadding="5" style="width:500px">
			<tr>
				<td style="text-align: right;width:80px"><b>选择流程:</b></td>
				<td><select class="easyui-combobox" name="bpmKey" style="width: 290px"
						 data-options="valueField: 'id',
									    textField: 'name',
									    url: '<%=basePath%>code/config/processList',
									    method: 'get'"></select></td>
			</tr>
			<tr>
				<td style="width:80px">&nbsp;</td>
				<td  style="text-align: left; padding: 5px">
				</td>
			</tr>
		</table>
		</fieldset>
		<div style="text-align:right;width:550px;height:35px;margin-top: 10px;">
			<a href="javascript:void(0)" class="easyui-linkbutton" 
				data-options="iconCls:'icon-save'" onclick="copyConfirm()">确定</a>&nbsp;
			<a href="javascript:void(0)" class="easyui-linkbutton" 
				data-options="iconCls:'icon-cancel'" onclick="copyCancel()">取消</a>
		</div>
	</form>
</div>
<script type="text/javascript">
	var basePath = window.parent.basePath;
	var funId = window.parent.funId;
	
	$(function(){
		// 自定义的校验器
		$.extend($.fn.validatebox.defaults.rules, {   
			isExist: {
				validator : function(value, param){ 
					var result = false;
					$.ajax({
						url : basePath + "code/copyConfig/getValidateIsExist",
						data : {field:param[0],value:value},
						type : 'post',
						async : false,
						success : function(data) {
							result = data.isExist;
						},
						error : function() {
						}
					});
					return result;
				}, 
    			message : "已经存在"  
			}
		});
		$('#copyfunctionForm').get(0).reset();   //清空表单数据 
		$('#copyfunctionForm').form('load', basePath+'code/config/'+funId);//加载form表单数据
	});
	
	//确定
	function copyConfirm() {
		if(!$("#copyfunctionForm").form("validate")) return;
		$("#copyoFunId").val(funId);
		$.ajax({
			url : basePath + "code/copyConfig/saveFunction",
			type : 'post',
			cache : false,
			data : $.toJSON($("#copyfunctionForm").serializeObject()),
			contentType : 'application/json;charset=UTF-8',
			async:false,
			success : function(data) {
				var result = eval('('+data+')');
				window.parent.$.messager.show({
					title : '提示信息!' , 
					msg : result.result
				});
				if( !(result && result.state && result.state == 'success') ) return;
				funId= $("#funId").val();
				window.parent.refreshTree();
				copyCancel();
			},
			error : function() {
				window.parent.$.messager.alert("操作提示", "操作失败！","error");
			}
		});
	}
	
	//取消
	function copyCancel(){
		window.parent.$('#copy').dialog('close'); //关闭窗口
	}
</script>
</body>
</html>