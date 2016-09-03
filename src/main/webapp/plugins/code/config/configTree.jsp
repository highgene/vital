<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<div id="functionDg" class="easyui-panel" data-options="fit:true" style="padding: 1px; text-align: left;">
	<form id="treeOptionsForm" method="post" action="code/config/treeOptions" target="treeTarget"  enctype="multipart/form-data" >
		<fieldset ><legend>基本属性</legend>
		<table cellpadding="5" style="width:500px">
			<tr>
				<td style="text-align: right;width:80px"><b>树&nbsp;名&nbsp;称:</b></td>
				<td><input class="easyui-textbox" type="text" name="treeName" id="treeName"
					data-options="required:true" style="width: 290px"></input>
					</input></td>
			</tr>
			<tr>
				<td style="text-align: right;width:80px"><b>树&nbsp;编&nbsp;码:</b></td>
				<td><input class="easyui-textbox" type="text" name="treeCode" id="treeCode"
					data-options="required:true" style="width: 290px"></input></td>
			</tr>
			<tr>
				<td style="text-align: right;width:80px"><b>节点编码字段:</b></td>
				<td><input class="easyui-textbox" name="nodeIdField" id="nodeIdField"
					data-options="required:true" style="width: 290px"></input></td>
			</tr>
			<tr>
				<td style="text-align: right;width:80px"><b>节点文本字段:</b></td>
				<td><input class="easyui-textbox" type="text" name="nodeTextField" id="nodeTextField"
					data-options="required:true" style="width:290px"></input>
				</td>
			</tr>
			<tr>
				<td style="text-align: right;width:80px"><b>父级关联字段:</b></td>
				<td><input class="easyui-textbox" name="parentIdField" id="parentIdField"
					data-options="required:true" style="width: 290px">
					<input type="hidden" id="pFunId" name="funId"></input></td>
			</tr>
			<tr>
				<td style="text-align: right;width:80px"><b>根节点编码:</b></td>
				<td><input class="easyui-textbox" name="rootCode" id="rootCode"
					data-options="required:true" style="width: 290px">
			</tr>
			<tr>
				<td style="text-align: right;width:80px"><b>排序字段:</b></td>
				<td><input class="easyui-textbox" name="orderField" id="orderField"
					data-options="required:true" style="width: 290px">
			</tr>
			<tr>
				<td style="text-align: right"><b>是否可拖拽:</b></td>
				<td>
					<input type="radio" value="1" name="dragFlag"/>是
					<input type="radio" value="0" name="dragFlag"/>否
				</td>
			</tr>
			<tr>
				<td style="text-align: right"><b>是否异步加载:</b></td>
				<td>
					<input type="radio" value="1" name="asyncFlag"/>是
					<input type="radio" value="0" name="asyncFlag"/>否
				</td>
			</tr>
			<tr>
				<td style="text-align: right"><b>复选框:</b></td>
				<td>
					<input type="radio" value="1" name="checkboxFlag"/>是
					<input type="radio" value="0" name="checkboxFlag"/>否
				</td>
			</tr>
			<tr>
				<td style="text-align: right"><b>节点样式:</b></td>
				<td>
					<select name="styleType" id="styleType">
						<option value="1">样式1</option>
						<option value="2">样式2</option>
						<option value="3">样式3</option>
					</select>
				</td>
			</tr>
			<tr>
				<td style="text-align: right;width:80px"><b>点击回调方法:</b></td>
				<td><input class="easyui-textbox" name="nodeClickFun" id="nodeClickFun"
					style="width: 290px"></input></td>
			</tr>
			<tr>
				<td style="text-align: right"><b>添加右键菜单:</b></td>
				<td>
					<input type="radio" value="1" name="contextMenuFlag"/>是
					<input type="radio" value="0" name="contextMenuFlag"/>否
				</td>
			</tr>
			<tr>
				<td style="text-align: right"><b>自定义模板:</b></td>
				<td>
					<input name="treeTemplateFile" data-options="prompt:'选择FTL格式文件'" class="easyui-filebox" style="width:220px;"></input>
					<input type=button value="查看模板" onclick="viewTreeTemplate();">
				</td>
			</tr>
		</table>
		</fieldset>
	</form>
	<iframe id="treeTarget" name="treeTarget" style="display:none"></iframe>
	<fieldset id="menuField">
		<legend>右键菜单列表</legend>
		<div>
			<div id="tb" style="height:auto;vertical-align:middle">
				<a href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-add',plain:true" onclick="appendRow()">添加</a>
				<a href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-remove',plain:true" onclick="removeRow()">移除</a>
			</div>
			<table id="menuDataGrid" class="easyui-datagrid" style="width:245px;height:auto"
				data-options="
				iconCls: 'icon-edit',
				singleSelect: true,
				onClickCell: onClickCells,
				onEndEdit:onEndEdits">
				<thead>
					<th data-options="field:'text',width:80,align:'center',editor:{type:'textbox',options:{required:false}}">菜单名</th>
					<th data-options="field:'clickFun',width:80,align:'center',editor:{type:'textbox',options:{required:false}}">方法名</th>
					<th data-options="field:'orderNo',width:80,align:'center',editor:{type:'textbox',options:{required:false}}">排序</th>
				</thead>
			</table>
		</div>
	</fieldset>
	
	<div style="text-align:right;width:400px;height:80px">
		<a href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-save'"
									onclick="submitForm()">保存功能</a>&nbsp;
		<a href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-remove'"
									onclick="preview()">预览</a>
	</div>
</div>
<script type="text/javascript">
	var basePath = '${Config.baseURL}';		//基础访问URL
	var editIndex = undefined;				//当前编辑行索引
	var funId = '${param.funId}';
	
	//右键菜单属性对象
	var rowObject = {"text":"","clickFun":"","orderNo":""};
	
	//加载数据
	function initData(data){
		//设置右键菜单
		if(data.contextMenuFlag=="1"){
			$('#menuField').show();
			if(data.contextMenuList!=null && data.contextMenuList.length>0){
				var list = {"total":data.contextMenuList.length,"rows":data.contextMenuList};
				$('#menuDataGrid').datagrid('loadData',list);
			}
		}else{
			$('#menuField').hide();
		}	
	}
	
	//初始化方法
	$(document).ready(function(){
		$.get(basePath+'code/config/treeOptions/'+funId,function(data){
			if(data!=null){
				initData(data);
			}
			$('#treeOptionsForm').form('load',data);
		});
		//右键菜单添加绑定事件
		$('input[name="contextMenuFlag"]').on("change",function(){
			var flag = $(this).val();
			if(flag=="1"){				
				$('#menuField').show();
			}else{
				$('#menuField').hide();
			}
		});
	});
		
	//预览
	function preview(){
		window.open(basePath+'code/page/preview/tree/easyui?funId='+funId,'top=0,left=0,width=800,height=600,scrollbars=yes');
	}
	
	//表单提交
	function submitForm(){
		$("#pFunId").val(funId);		//提交前设置funId,防止值为空
		getContextMenuListArray();		//获取右键菜单列表
		var treeOptions = $("#treeOptionsForm").serializeObject();
		console.log(treeOptions);
		$("#treeOptionsForm").submit();
	}
	
	
	//克隆对象
	function cloneObj(obj){  
	    function Fn(){}  
	    Fn.prototype = obj;  
	    var o = new Fn();  
	    for(var a in o){  
	        if(typeof o[a] == "object") {  
	            o[a] = clone(o[a]);  
	        }  
	    }  
	    return o;  
	}
	
	//获取表格的数据
	function getContextMenuList(){
		if(endEditing()){
			var rows = $('#menuDataGrid').datagrid('getRows');
			return rows;
		}
	}
	
	//获取表格的数据,将其转换
	function getContextMenuListArray(){
		if(endEditing()){
			var rows = $('#menuDataGrid').datagrid('getRows');
			$('input[name^="contextMenuList"]').remove();		//每次保存前移除原来的数据
			$(rows).each(function(index){
				for(var name in this){
					var $input = $(['<input type="hidden" name="contextMenuList[',index,'][',name,']" value="',this[name],'"/>'].join(''));
					$('#treeOptionsForm').append($input);
				}
			});
		}
	}
	
	//添加
	function appendRow(){
		if(endEditing()){
			var rowData = $.extend({},rowObject);
			$('#menuDataGrid').datagrid('appendRow',rowData);
			editIndex = $('#menuDataGrid').datagrid('getRows').length-1;
			$('#menuDataGrid').datagrid('selectRow', editIndex).datagrid('beginEdit', editIndex);
		}
	}
	
	//删除行
	function removeRow(){
		if (editIndex == undefined){return}
		$('#menuDataGrid').datagrid('cancelEdit', editIndex)
				.datagrid('deleteRow', editIndex);
		editIndex = undefined;
	}
	
	//点击单元格事件
	function onClickCells(index, field){
		if (editIndex != index){
			if (endEditing()){
				$('#menuDataGrid').datagrid('selectRow', index).datagrid('beginEdit', index);
				var ed = $('#menuDataGrid').datagrid('getEditor', {index:index,field:field});
				console.log(ed);
				if (ed){
					($(ed.target).data('textbox') ? $(ed.target).textbox('textbox') : $(ed.target)).focus();
				}
				editIndex = index;
			} else {
				setTimeout(function(){
					$('#menuDataGrid').datagrid('selectRow', editIndex);
				},0);
			}
		}
	}
	
	function onEndEdits(index, row){
		var ed = $(this).datagrid('getEditor', {
			index: index,
			field: 'name'
		});
	}
	
	//结束编辑
	function endEditing(){
		if (editIndex == undefined){return true}
		if ($('#menuDataGrid').datagrid('validateRow', editIndex)){
			$('#menuDataGrid').datagrid('endEdit', editIndex);
			editIndex = undefined;
			return true;
		} else {
			return false;
		}
	}
	
	//查看上传的自定义模板
	function viewTreeTemplate(){
		$.ajax({
			url : basePath + "code/config/treeOptions/"+funId,
			type : 'get',
			cache : false,
			success : function(data) {
				$("#templateViewer").val(data["treeTemplate"]);
				$("#templateViewerDialog").dialog("open");
			},
			error : function() {
			}
		});	
	}
</script>