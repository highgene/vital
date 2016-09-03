<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<table id="templateDg" class="easyui-datagrid" style="padding: 1px; text-align: left;"
		data-options="
			fit:true,
			iconCls: 'icon-ok',
			rownumbers: true,
			animate: true,
			collapsible: true,
			fitColumns: true,
			toolbar: '#templatebar',
			url: '${Config.basePath}code/codelibs/page?_t=<%=System.currentTimeMillis() %>',
			method: 'get',
			idField: 'id',
			treeField: 'name',
			pagination: true,
			pageSize: 12,
			pageList: [12,50,100]
		">
	<thead>
		<tr>
			<th data-options="field:'name',width:180">模板名称</th>
			<th data-options="field:'list_',width:60, 
								formatter:function(value,row,index){
									return linkStr('list',value,row,index); 
								}">list</th>
			<th data-options="field:'form_',width:60, 
								formatter:function(value,row,index){
									return linkStr('form',value,row,index); 
								}">form</th>
			<th data-options="field:'detail_',width:60, 
								formatter:function(value,row,index){
									return linkStr('detail',value,row,index); 
								}">detail</th>										
			<th data-options="field:'controller_',width:60, 
								formatter:function(value,row,index){
									return linkStr('controller',value,row,index); 
								}">Controller</th>
			<th data-options="field:'domain_',width:60, 
								formatter:function(value,row,index){
									return linkStr('domain',value,row,index); 
								}">实体</th>
			<th data-options="field:'service_',width:60,
							 formatter:function(value,row,index){
							 	return linkStr('service',value,row,index); 
							 }">Service</th>
			<th data-options="field:'serviceImpl_',width:60, 
							formatter:function(value,row,index){
								return linkStr('serviceImpl',value,row,index); 
							}">Service实现</th>
		</tr>
	</thead>
</table>
<div id="templatebar" style="height:auto;vertical-align:middle">
	<a href="javascript:void(0)" title="把内置模板（code/templates/backend）更新到数据库中！" class="easyui-linkbutton" data-options="iconCls:'icon-add',plain:true" onclick="updateDefaultTemplate()">更新内置模板</a>
</div>
<div id="templateDlg" class="easyui-dialog" title="Basic Dialog"  data-options="iconCls:'icon-save',resizable:true,modal:true,closable: true,closed: true,maximizable:true"
	 style="width:800px;height:600px;padding:10px;">
	<form id="templateForm" action="${Config.basePath}/code/codelibs" method=post target="_blank">
	<textarea id="sourceContent" name="source" style="width:100%;height:500px"></textarea>
	<input type="hidden" id="tid" name="id">
	<input type="hidden" id="templateType" name="templateType">
	<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
	<input type="button" onclick="save()" value="保存">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
	<input type="button" onclick="javascript:$('#templateDlg').dialog('close');" value="取消">
	</form>
</div>
<script type="text/javascript">
var basePath = '${Config.basePath}';
var currentIndex = 0;
var currentType = '';
function linkStr(type,value,row,index){
	return '<button  onclick="show(\''+type+'\',\''+row['id']+'\',\''+index+'\');">'+value+'</button>';
}
function updateDefaultTemplate(){
	
	$.ajax({
		url : basePath + "code/codelibs/updateDefaultTemplate",
		type : 'get',
		success : function(data) {
			$.messager.show({
				title : '提示信息!', 
				msg : '保存成功！'
			});
			$('#templateDg').datagrid('load');
		}
	});
}
function save(){
	var data = $('#templateDg').datagrid('getData');
	data.rows[currentIndex][currentType] = $("#sourceContent").val();
	$("#templateForm").submit();
	$('#templateDlg').dialog('close');
}
function show(type,id,index){
	currentIndex = index;
	currentType = type;
	
	var data = $('#templateDg').datagrid('getData');
	setSource(data.rows[index][type], id,type);
	openFile(type);
}
function setSource(content,id,type){
	$('#sourceContent').val(content);
	$('#tid').val(id);
	$('#templateType').val(type);
}
function openFile(type){
	$('#templateDlg').dialog('setTitle',type+" 模板");
	$('#templateDlg').dialog('open');
}

</script>