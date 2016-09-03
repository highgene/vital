<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<div id="functionDg" class="easyui-panel" data-options="fit:true" style="padding: 1px; text-align: left;">
	<form id="functionForm" method="post" >
		<fieldset ><legend>基本属性</legend>
		<table cellpadding="5" style="width:700px">
			<tr>
				<td style="text-align: right;width:80px"><b>场景名称:</b></td>
				<td><input class="easyui-textbox" type="text" name="scene"
					data-options="required:true,prompt:'包名称，接口路径'" style="width: 290px"></input>
					<input type="hidden" name="id"></input> <font color="gray"></font></td>
			</tr>
			<tr>
				<td style="text-align: right;width:80px"><b>名称空间:</b></td>
				<td><input class="easyui-textbox" type="text" name="namespace"
					data-options="required:true,prompt:'生成代码的包路径'" style="width: 290px" value="com.hhwy"></input></td>
			</tr>
			<tr>
				<td style="text-align: right;width:80px"><b>功能编号:</b></td>
				<td ><input id="funId" class="easyui-textbox" type="text" name="funId"
					data-options="required:true,prompt:'注意：编号只能在新建时指定，不能修改！'" style="width: 290px"></input>
					<input type="hidden" id="oFunId" name="oFunId"></input> </td>
			</tr>
			<tr>
				<td style="text-align: right;width:80px"><b>功能名称:</b></td>
				<td><input class="easyui-textbox" name="name"
					data-options="required:true,prompt:'功能的名称，描述'" style="width: 290px"></input></td>
			</tr>
			<tr>
				<td style="text-align: right;width:80px"><b>表&nbsp;名&nbsp;称:</b></td>
				<td ><select class="easyui-combobox" name="tableName" style="width: 290px" value="defaut_1"
							data-options="required:true,
										valueField: 'id',
									    textField: 'text',prompt:'可以选择已有的表，或者新建表',
									    url:'${Config.baseURL}code/config/tables',
									    method:'get'"></select> 
					</td>
			</tr>
			<tr>
				<td style="text-align: right"><b>代码模板:</b></td>
				<td  title="选择生成代码的模板"><select id="templateCombobox" class="easyui-combobox" name="template" style="width: 290px"
						 data-options="valueField: 'id',
									    textField: 'text',
									    url: '${Config.baseURL}code/codelibs/getTemplates',
									    method: 'get'"></select> </td>
			</tr>
			<tr>
				<td style="text-align: right;width:80px"><b>上级节点:</b></td>
				<td title="功能在台账功能树上的位置">
					<select class="easyui-combotree" style="width:290px;" name="parentText"
						data-options="
							url:'${Config.staticURL}code/config/getFunctionsById',
                 			method:'get',
			                animate:true,
			                onClick: function(node){
								$('#parentId').val(node.id);
							}"/> 
					<input id="parentId" type="hidden" name="parentId"></input>
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
				<td title="选择当前功能要关联的流程"><select class="easyui-combobox" name="bpmKey" style="width: 290px"
						 data-options="valueField: 'id',
									    textField: 'name',
									    url: '${Config.baseURL}code/config/processList',
									    method: 'get'"></select></td>
			</tr>
			<tr>
				<td style="width:80px">&nbsp;</td>
				<td  style="text-align: left; padding: 5px">
				</td>
			</tr>
		</table>
		</fieldset>
		<div style="text-align:right;width:400px;height:80px">
			<a href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-save'"
										onclick="submitForm()">保存功能</a>&nbsp;&nbsp;&nbsp;&nbsp;
			<a href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-remove'"
										onclick="deleteFunction()">删除功能</a>&nbsp;&nbsp;&nbsp;&nbsp;
			<a href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-edit'"
										onclick="copyFunction()"  title="复制当前台账，创建一个新的台账。">复制功能</a>&nbsp;&nbsp;&nbsp;&nbsp;
			<a href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-edit'"
										onclick="registerFunction()" title="在权限中注册资源，即添加菜单和功能。 	">注册资源</a>
		</div>
	</form>
</div>
<div id="copy" style="overflow: hidden;">
	<iframe id="copyIframe" width="100%" height="100%" src="" frameborder="0" scrolling="auto" marginheight="0" marginwidth="0"></iframe>
</div>
<script type="text/javascript">
	var basePath = '${Config.baseURL}';
	var funId = '${param.funId}';
	$(document).ready(function(){
		 $('#functionForm').form('load', basePath+'code/config/'+funId); 
		 $('#functionForm').form({onLoadSuccess:loadsucc});  
		 
		if(funId != undefined && funId != 'undefined' && funId.length > 0){
			$('#funId').attr("readonly","true");
		}else{
			$('#funId').removeAttr("disabled"); 
		}
		
	});
	function loadsucc(data){  
		if(null == data['template'])
	    	$('#templateCombobox').combobox('setValue', 'default_1');
	}  
	
	//删除功能
	function deleteFunction(){
		if(funId == 'undefined' || !funId){
			$.messager.show({
				title : '提示信息!', 
				msg : "未填写信息，无法删除！"
			});
			return;
		}
		$.messager.confirm("操作提示", "确认删除吗？", function (ok) {  
	       if(ok){
				$.ajax({
					url : basePath + "code/config/"+funId,
					type : 'delete',
					success : function(data) {
						funId= $("#funId").val();
						refreshTree();
						$("#functionForm")[0].reset();
					},
					error : function() {
						$.messager.alert("操作提示", "操作失败！","error");
					}
				});
	       }
		});
	}
	
	//保存功能
	function submitForm() {
		if(!$("#functionForm").form("validate")) return;
		$("#oFunId").val(funId);
		$.ajax({
			url : basePath + "code/config/saveFunction",
			type : 'post',
			cache : false,
			data : $.toJSON($("#functionForm").serializeObject()),
			contentType : 'application/json;charset=UTF-8',
			success : function(data) {
				var result = eval('('+data+')');
				$.messager.show({
					title : '提示信息!', 
					msg : result.result
				});
				if( !(result && result.state && result.state == 'success') ) return;
				funId= $("#funId").val();
				refreshTree();
			},
			error : function() {
			}
		});
	}
	
	//复制功能
	function copyFunction(){
		$("#copy").dialog({
			title:'复制功能',
			width : 660,  
		    height : 480, 
		    resizable : true,
		    closed : true,
		    cache : false,
		    modal : true
		});
		$('#copy').dialog('open');
		$("#copyIframe").attr("src","${Config.staticURL}code/config/copyFunction.jsp");
	}
	
	//注册资源
	function registerFunction(){
		if(funId == 'undefined' || !funId){
			$.messager.show({
				title : '提示信息!', 
				msg : "未填写信息，无法注册资源！"
			});
			return;
		}
		$.ajax({						  
			url : basePath + "code/config/registerResource/"+funId,
			type : 'get',
			cache : false,
			contentType : 'application/json;charset=UTF-8',
			success : function(data) {
				var result = eval('('+data+')');
				$.messager.show({
					title : '提示信息!', 
					msg : result.result
				});
			},
			error : function() {
				$.messager.show({
					title : '提示信息!', 
					msg : "注册资源失败！"
				});
			}
		});
	}
	
</script>