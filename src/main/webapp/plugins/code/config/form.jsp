<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<div class="easyui-layout" data-options="fit:true" > 
		 <div data-options="region:'center'">
			<table id="formDg" class="easyui-datagrid"  style="width:100%;height:auto"
	            data-options="singleSelect:true,
	            				fit:true,
	            				url:'${Config.staticURL}code/config/formProperties/${param.funId}',
	            				method:'get',
	            				onClickCell: formOnClickCell,
								onEndEdit: formOnEndEdit">
	        <thead  frozen="true">
	            <tr>
	                <th data-options="field:'name',width:120,align:'center'">属性名称</th>
	                <th data-options="field:'desc',width:80,align:'center'">属性描述</th>
	         </thead>
	         <thead><tr>
	                <th data-options="field:'control',width:80,align:'center',
						                formatter:function(value,row){
				                                return row.controlDesc;
				                            },
				                            editor:{
				                                type:'combobox',
				                                options:{
				                                    valueField:'id',
				                                    textField:'name',
				                                    method:'get',
				                                    url:'${Config.staticURL}code/config/selectOptions/formControls',
				                                    onSelect:function(record){
				                                    	var currentRow = $('#formDg').datagrid('getSelected');
				                                    	var index = $('#formDg').datagrid('getRowIndex',currentRow);
				                                    	currentRow['controlDesc']=record['name'];
				                                    	$('#formDg').datagrid('updateRow',{index:index,row:currentRow});
				                                    }
				                                }
				                                
				                            }">控件类型</th>
	                <th data-options="field:'required',width:40,align:'center',
	                			 	formatter:function(value,row){
				                        if(row.required == 'on')
				                        	return '是';
				                        else
				                        	return '否';
				                    },
	               					editor:{type:'checkbox',options:{on:'on',off:'off'}}">必填</th>
	                <th data-options="field:'defaultValue',width:120,editor:'textbox'">默认值</th>
	                <th data-options="field:'insertable',width:40,align:'center',
	                				formatter:function(value,row){
				                        if(row.insertable == 'on')
				                        	return '是';
				                        else
				                        	return '否';
				                    },
	               					editor:{type:'checkbox',options:{on:'on',off:'off'}}">新增<br>编辑</th>
	                <th data-options="field:'updatable',width:40,align:'center',
	                	            formatter:function(value,row){
				                        if(row.updatable == 'on')
				                        	return '是';
				                        else
				                        	return '否';
				                    },
	               					editor:{type:'checkbox',options:{on:'on',off:'off'}}">更新<br>编辑</th>
	                <th data-options="field:'tip',width:160,align:'center',editor:'textbox'">填写提示</th>
	                <th data-options="field:'contact',width:160,align:'center',editor:'textbox'">联动</th>
	            </tr>
	        </thead>
	    </table>
	    </div>
	    <div data-options="region:'south'" style="height:180px;">
	   	 <fieldset><legend>表单选项</legend>
	      <form id="formForm"  action="code/config/formOption" target="formTargat" method="post" enctype="multipart/form-data">
	        <table cellpadding="5">
             
               <tr>
                    <td style="text-align:right"><b>表单模板</b>:</td>
                   <td><input name="formtemplateFile" data-options="prompt:'选择html文件'" class="easyui-filebox" style="width:100%;"></input></td>
                   <td><input type=button value="查看表单模板" onclick="viewFormtemplate();"></input>
                    <input id="k" type="hidden" name="funId" ></input></td>
               </tr>
           </table>
	    </form>
	    </fieldset>
	    <iframe id="formTargat" name="formTargat" style="display:none"></iframe>
	     <div style="text-align:right;padding:5px">
            <a href="javascript:void(0)" class="easyui-linkbutton"  data-options="iconCls:'icon-save'" onclick="saveForm()">保存配置</a>
		</div>
		</div>
		</div>
<script type="text/javascript">
var formEditIndex = undefined;
$(document).ready(function(){
	$('#formForm').form('load', basePath+'code/config/formOption/'+funId);
});
function formEndEditing(){
	if (formEditIndex == undefined){return true}
	if ($('#formDg').datagrid('validateRow', formEditIndex)){
		$('#formDg').datagrid('endEdit', formEditIndex);
		formEditIndex = undefined;
		return true;
	} else {
		return false;
	}
}
function formOnClickCell(index, field){
	if (formEditIndex != index){
		if (formEndEditing()){
			$('#formDg').datagrid('selectRow', index)
					.datagrid('beginEdit', index);
			var ed = $('#formDg').datagrid('getEditor', {index:index,field:field});
			if (ed){
				($(ed.target).data('textbox') ? $(ed.target).textbox('textbox') : $(ed.target)).focus();
			}
			formEditIndex = index;
		} else {
			setTimeout(function(){
				$('#formDg').datagrid('selectRow', formEditIndex);
			},0);
		}
	}
}
function formOnEndEdit(index, row){
	var ed = $(this).datagrid('getEditor', {
		index: index,
		field: 'name'
	});
}
function viewFormtemplate(){
	//templateViewer
	$.ajax({
		url : basePath + "code/codelibs/getTemplateContent/"+funId+"/form",
		type : 'get',
		cache : false,
		success : function(data) {
			$("#templateViewer").val(data["templateContent"]);
			$("#templateViewerDialog").dialog({"title":"查看表单模板"});
			$("#templateViewerDialog").dialog("open");
		},
		error : function() {
		}
	});	
}
function saveForm(){
	formAccept();
	submitFormForm();
}
function submitFormForm(){
	$('#formForm').attr("action",basePath+"code/config/formOption");
	$("#formForm").submit();
}
function formAccept(){
	if (formEndEditing()){
		var rows = $('#formDg').datagrid('getRows');
		for(var i =0; i < rows.length; i++){
			rows[i]['funId']=funId;
		}
			
		$.ajax({
			url : basePath + "code/config/formProperty",
			type : 'post',
			cache : false,
			data : $.toJSON(rows),
			contentType : 'application/json;charset=UTF-8',
			success : function(data) {
				$('#formDg').datagrid('acceptChanges');
				frames['预览']=true;
				$('#formDg').datagrid('load');
				$.messager.show({
					title : '提示信息!', 
					msg : '保存成功！'
				});
			}
		});
	}
}
</script>
