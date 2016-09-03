<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<div class="easyui-panel"
	style="width: 100%; height:100%; padding: 30px 60px;">
	<form id="referenceForm">
	<div style="margin-bottom: 20px">
		<b>选择引用表：</b><select class="easyui-combobox" name="refTableName" style="width: 100%;" 
			data-options="valueField: 'id',
					    textField: 'text',
					    url:'${Config.baseURL}code/config/tables',
					    method:'get',
					    onSelect: function(record){selectTable(record)}"></select> 
	
	</div>
	<div style="margin-bottom: 20px">
		<b>选择字段：</b><select  id="refFieldName" class="easyui-combobox" name="refFieldName" style="width: 100%;" 
			data-options="valueField: 'id',
					    textField: 'text',
					    required: true,
					    onSelect: function(record){selectField(record)}"></select> 
	
	</div>
	<div style="margin-bottom: 20px">
		<b>关联字段：</b><select  id="relationFieldName" class="easyui-combobox" name="relationFieldName" style="width: 100%;" 
			data-options="valueField: 'id',
					    textField: 'text',
					    required: true,
					    onSelect: function(record){selectRelationFieldName(record)}"></select> 
	
	</div>
	<div style="margin-bottom: 20px">
		<b>过滤条件：</b><input id="condition" class="easyui-textbox" type="text" name=""condition""
					data-options="prompt:'引用表数据过滤，如:字典项表，可以填写dict_id=\'123\' ！'" style="width: 100%;" >
	
	</div>
	<input type="button" onclick="addReferenceField()" value="添加引用字段">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
	<input type="button" onclick="javascript:$('#referenceDialog').dialog('close');" value="取消">
	</form>
	
</div>
<script type="text/javascript">
var baseURL = '${Config.baseURL}';
var currentRefTable = null;
var currentRefField = null;
var currentRelationFieldName = '';
function selectTable(record){
	currentRefTable =record['id'];
	currentRefField = null;
	currentRelationFieldName = '';
	$('#refFieldName').combobox('reload',baseURL+'code/config/fields/'+record['id']);
	var data = $('#refFieldName').combobox('getData');
	$('#relationFieldName').combobox('reload',baseURL+'code/config/fields/'+record['id']);
	
}
function selectField(record){
	currentRefField = record['id'];
}
function selectRelationFieldName(record){
	currentRelationFieldName = record['id'];
}
function addReferenceField(){
	var refProperty = currentFieldName+':'+currentRefTable+':'+currentRefField+':'+currentRelationFieldName+':['+$('#condition').val()+']';

	var newProperty ={'name':currentFieldName+'_'+currentRefField,'desc':'','type':'String','refProperty':refProperty,'annotation':'@Transient'};
	$('#entityDg').datagrid('appendRow',newProperty);
	$('#referenceDialog').dialog('close');
} 

</script>