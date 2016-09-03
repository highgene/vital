<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<table id="entityDg" class="easyui-datagrid"  style="width:100%;height:auto"
		data-options="fit:true,
			iconCls: 'icon-edit',
			singleSelect: true,
			toolbar: '#tb',
			url: '${Config.staticURL}code/config/properties/${param.funId}',
			method: 'get',
			onClickCell: onClickCell,
			onEndEdit: onEndEdit,
			onLoadSuccess: initStatus
		">
	<thead  frozen="true">
		<tr>
			<th data-options="field:'id',hidden:true,align:'center'">id</th>
			<th data-options="field:'name',width:120,editor:{type:'textbox',options:{required:true}}">字段名</th>
			<th data-options="field:'desc',width:80,align:'center',editor:{type:'textbox'}">字段描述</th>
  </thead>
       <thead><tr>
			<th data-options="field:'type',width:80,align:'center',
					formatter:function(value,row){
						return row.typeDesc;
					},
					editor:{
						type:'combobox',
						options:{
							valueField:'id',
							textField:'name',
							method:'get',
							url:'${Config.staticURL}code/config/selectOptions/fieldTypes',
							required:true,
							
						}
					}">类型</th>
			<th data-options="field:'length',width:40,align:'center',editor:{type:'numberbox',options:{precision:0}}">长度</th>
			<th data-options="field:'precision',width:40,align:'center',editor:'numberbox'">精度</th>
			<th data-options="field:'notNull',width:40,align:'center',
								formatter:function(value,row){
									 if(row.notNull =='on'){
				                        	return '是';
				                        }else
				                        	return '否';
								},editor:{type:'checkbox',options:{on:'on',off:'off'}}">非空</th>
			<th data-options="field:'alias',width:100,align:'center',editor:'textbox'">别名</th>
			<th data-options="field:'refProperty',width:120,align:'center',editor:'textbox'">引用字段</th>
			<th data-options="field:'parameter',width:40,align:'center',formatter:function(value,row){
									 if(row.parameter =='on'){
				                        	return '是';
				                        }else
				                        	return '否';
								},editor:{type:'checkbox',options:{on:'on',off:'off'}}">参数</th>
			<th data-options="field:'scope',width:60,align:'center',
								editor:{
									type:'combobox',
									options:{
										valueField:'id',
										textField:'name',
										method:'get',
										url:'${Config.staticURL}code/config/selectOptions/parameterScope'
									}
								}">作用范围</th>
			<th data-options="field:'annotation',width:160,align:'center',editor:'textbox' ">注解</th>
			<th data-options="field:'ss',width:60,formatter:function(value,row,index){
									 return linkRef(value,row,index); 
								} ">关联字段</th>
		</tr>
	</thead>
</table>

<div id="tb" style="height:auto;vertical-align:middle">
	<a href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-add',plain:true" onclick="append()">添加属性</a>
	<a href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-remove',plain:true" onclick="removeit()">移除属性</a>
	<a href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-save',plain:true" onclick="accept()">保存</a>
	<input id=bpmCheckbox type=checkbox value="bpm" onclick="addBpmSupport(this.checked)">支持流程
</div>
<div id="referenceDialog" class="easyui-dialog" title="选择引用字段"  closed="true" style="width:680px;height:450px;"
            data-options="iconCls:'icon-save',modal:true">
</div>
<script type="text/javascript">
var editIndex = undefined;
var funId = '${param.funId}';
var rowObject ={};
var currentFieldName = null;
function linkRef(value,row,index){
	currentFieldName = row['name'];
	return '<button  onclick="showReference(\''+value+'\',\''+index+'\');">选择</button>';
	
}
function showReference(value,index){
	$('#referenceDialog').dialog('refresh', basePath+'view/code/config/referenceField?fieldName='+currentFieldName);
	$('#referenceDialog').dialog("open")
}
function initStatus(){
	if(checkBpmSupport()){
		$("#bpmCheckbox").attr("checked", true);
	}
}
$(document).ready(function(){
	$.ajax({
		url : basePath + "code/config/property",
		type : 'get',
		cache : false,
		contentType : 'application/json;charset=UTF-8',
		success : function(data) {
			rowObject = data;
		}
	});
});
function endEditing(){
	if (editIndex == undefined){return true}
	if ($('#entityDg').datagrid('validateRow', editIndex)){
		$('#entityDg').datagrid('endEdit', editIndex);
		editIndex = undefined;
		return true;
	} else {
		return false;
	}
}

function onClickCell(index, field){
	if (editIndex != index){
		if (endEditing()){
			$('#entityDg').datagrid('selectRow', index)
					.datagrid('beginEdit', index);
			var ed = $('#entityDg').datagrid('getEditor', {index:index,field:field});
			if (ed){
				($(ed.target).data('textbox') ? $(ed.target).textbox('textbox') : $(ed.target)).focus();
			}
			editIndex = index;
		} else {
			setTimeout(function(){
				$('#entityDg').datagrid('selectRow', editIndex);
			},0);
		}
	}
}
function onEndEdit(index, row){
	var ed = $(this).datagrid('getEditor', {
		index: index,
		field: 'name'
	});
}
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
function append(){
	if (endEditing()){
		$('#entityDg').datagrid('appendRow',cloneObj(rowObject));
		editIndex = $('#entityDg').datagrid('getRows').length-1;
		$('#entityDg').datagrid('selectRow', editIndex)
				.datagrid('beginEdit', editIndex);
	}
}
function addBpmSupport(checked){
	var bpmRows= [] ;
	bpmRows[0]={'name':'process_status','desc':'流程状态','type':'String','length':'200','precision':'0', 'nullable':'true','alias':'process_status_'};
	bpmRows[1]={'name':'task_man','desc':'任务处理人','type':'String','length':'200','precision':'0', 'nullable':'true','alias':'task_man_'};
	bpmRows[2]={'name':'process_instance_id','desc':'流程实例id','type':'String','length':'32','precision':'0', 'nullable':'true','alias':'process_instance_id_'};
	bpmRows[3]={'name':'task_name','desc':'任务名称','type':'String','length':'200','precision':'0', 'nullable':'true','alias':'task_name_'};
	for(var i =0 ; i < bpmRows.length;i++){
		if(checked)
			$('#entityDg').datagrid('appendRow',bpmRows[i]);
		else{
			var rows = $('#entityDg').datagrid('getRows');
			for(var j =0; j <rows.length;j++){
				if(rows[j]['name'] == bpmRows[i]['name']){
					$('#entityDg').datagrid('deleteRow', j);
				}
			}
		}
	}
}
function checkBpmSupport(){
	var rows = $('#entityDg').datagrid('getRows');
	for(var j =0; j <rows.length;j++){
		if(rows[j]['name'] == 'process_instance_id'){
			return true;
		}
	}
	return fasle;
}
function removeit(){
	if (editIndex == undefined){return}
	$('#entityDg').datagrid('cancelEdit', editIndex)
			.datagrid('deleteRow', editIndex);
	editIndex = undefined;
}
function accept(){
	if (endEditing()){
		var rows = $('#entityDg').datagrid('getRows');
		for(var i =0; i < rows.length; i++){
			rows[i]['funId']=funId;
		}
		$.ajax({
			url : basePath + "code/config/property",
			type : 'post',
			cache : false,
			data : $.toJSON(rows),
			contentType : 'application/json;charset=UTF-8',
			success : function(data) {
				$('#entityDg').datagrid('acceptChanges');
				frames['列表配置']=true;
				frames['表单配置']=true;
				frames['预览']=true;
				$('#entityDg').datagrid('load');
				$.messager.show({
					title : '提示信息!', 
					msg : '保存成功！'
				});
			}
		});
	}
}
function reject(){
	$('#entityDg').datagrid('rejectChanges');
	editIndex = undefined;
}
function getChanges(){
	var rows = $('#entityDg').datagrid('getChanges');
	alert(rows.length+' rows are changed!');
}
</script>