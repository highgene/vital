<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<table id="buttonsDg" class="easyui-datagrid"  style="width:100%;height:auto"
	            data-options="fit:true,
	            iconCls: 'icon-edit',
	            singleSelect:true,
	            url:'${Config.staticURL}code/config/buttons/${param.funId}',
	            method:'get',
	            toolbar:subFunctionToolbar,
	            onClickCell: buttonOnClickCell
	            ">
    <thead>
        <tr>
        	<th data-options="field:'name',width:80,align:'center',editor:'textbox'">按钮名字</th>
            <th data-options="field:'type',width:80,align:'center',formatter:function(value,row){
										return row.typeDesc;
									},
									editor:{
										type:'combobox',
										options:{
											valueField:'id',
											textField:'name',
											method:'get',
											url:'${Config.staticURL}code/config/selectOptions/buttons',
											required:true,
											onSelect:selectType									
										}
									}">功能类型</th>
            <th data-options="field:'page',width:100,align:'center',
				            		formatter:function(value,row){
										return row.pageDesc;
									},
									editor:{
										type:'combobox',
										options:{
											valueField:'id',
											textField:'name',
											method:'get',
											url:'${Config.staticURL}code/config/selectOptions/pageTypes',
											required:true
										}
									}">所属页面</th>
            <th data-options="field:'code',width:80,align:'center',
            				  editor:{
            				  	type:'textbox',
            				  	options:{
            				  		required:true
            				  	}		
            				  }">编码</th>
            <th data-options="field:'serialNumber',width:80,align:'center',editor:'textbox'">顺序</th>
            <th data-options="field:'config',width:380,align:'center',editor:'textbox'">配置</th>
        </tr>
    </thead>
</table>

<script type="text/javascript">
var buttonEditIndex = undefined;
function buttonEndEditing(){
	if (buttonEditIndex == undefined){return true}
	if ($('#buttonsDg').datagrid('validateRow', buttonEditIndex)){
		$('#buttonsDg').datagrid('endEdit', buttonEditIndex);
		buttonEditIndex = undefined;
		return true;
	} else {
		return false;
	}
}
function buttonOnClickCell(index, field){
	if (buttonEditIndex != index){
		if (buttonEndEditing()){
			$('#buttonsDg').datagrid('selectRow', index)
					.datagrid('beginEdit', index);
			var ed = $('#buttonsDg').datagrid('getEditor', {index:index,field:field});
			if (ed){
				($(ed.target).data('textbox') ? $(ed.target).textbox('textbox') : $(ed.target)).focus();
			}
			buttonEditIndex = index;
		} else {
			setTimeout(function(){
				$('#buttonsDg').datagrid('selectRow', buttonEditIndex);
			},0);
		}
	}
}
function buttonOnEndEdit(index, row){
	var ed = $(this).datagrid('getEditor', {
		index: index,
		field: 'name'
	});
}
function buttonAppend(){
	if (buttonEndEditing()){
		var rowObject ={'page':'list'};
		
		$('#buttonsDg').datagrid('appendRow',rowObject);
		buttonEditIndex = $('#buttonsDg').datagrid('getRows').length-1;
		$('#buttonsDg').datagrid('selectRow', buttonEditIndex)
				.datagrid('beginEdit', buttonEditIndex);
	}
}
function buttonRemoveit(){
	if (buttonEditIndex == undefined){return}
	$('#buttonsDg').datagrid('cancelEdit', buttonEditIndex)
			.datagrid('deleteRow', buttonEditIndex);
	buttonEditIndex = undefined;
}
function buttonAccept(){
	if (buttonEndEditing()){
		var rows = $('#buttonsDg').datagrid('getRows');
		for(var i =0; i < rows.length; i++){
			rows[i]['funId']=funId;
		}
		$.ajax({
			url : basePath + "code/config/button",
			type : 'post',
			cache : false,
			data : $.toJSON(rows),
			contentType : 'application/json;charset=UTF-8',
			success : function(data) {
				$('#buttonsDg').datagrid('acceptChanges');
				$('#buttonsDg').datagrid('load');
				$.messager.show({
					title : '提示信息!', 
					msg : '保存成功！'
				});
			}
		});
	}
}
var subFunctionToolbar = [{
    text:'添加子功能',
    iconCls:'icon-add',
    handler:function(){buttonAppend();}
},{
    text:'删除子功能',
    iconCls:'icon-remove',
    handler:function(){buttonRemoveit();}
},{
    text:'保存',
    iconCls:'icon-save',
    handler:function(){buttonAccept();}
}];

function selectType(record){
	var ed = $("#buttonsDg").datagrid('getEditor', {
		index: buttonEditIndex,
		field: 'name'
	});
	$(ed.target).textbox('setValue',record.name);
}

</script>
