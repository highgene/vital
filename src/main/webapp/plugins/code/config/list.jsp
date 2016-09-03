<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<div class="easyui-layout" data-options="fit:true" > 
		 <div data-options="region:'center'">
	        <table  id="listDg" class="easyui-datagrid" style="width:100%;height:auto"
		            data-options="iconCls: 'icon-edit',
		            			singleSelect:true,
		            			fit:true,
		            			url:'${Config.staticURL}code/config/listProperties/${param.funId}',
		            			method:'get',
		            			onClickCell: listOnClickCell,
								onEndEdit: listOnEndEdit",
								sortName:'serialNumber',
								sortOrder:'ASC'>
	        <thead  frozen="true">
	            <tr>
	                <th data-options="field:'name',width:100,align:'center'">属性名称</th>
	                <th data-options="field:'desc',width:80,align:'center'">属性描述</th>
	                </tr>
	         </thead>
	         <thead><tr>
	                <th data-options="field:'tableHeadMerge',width:80,align:'center',editor:'textbox'">表头分组</th>
	                <th data-options="field:'isList',width:40,align:'center',
	               					formatter:function(value,row){
				                        if(row.isList =='on'){
				                        	return '是';
				                        }else
				                        	return '否';
				                    },
									editor:{type:'checkbox',options:{on:'on',off:'off'}}">列表<br>显示</th>
	                <th data-options="field:'isQuery',width:40,align:'center',
	                 				formatter:function(value,row){
				                        if(row.isQuery == 'on'){
				                        	return '是';
				                        }else
				                        	return '否';
				                    },
									editor:{type:'checkbox',options:{on:'on',off:'off'}}">是否<br>查询</th>
	                <th data-options="field:'queryType',width:60,
									formatter:function(value,row){
										return row.queryTypeDesc;
									},
									editor:{
										type:'combobox',
										options:{
											valueField:'id',
											textField:'name',
											method:'get',
											url:'${Config.staticURL}code/config/selectOptions/conditions',
											 onSelect:function(record){
				                                    	var currentRow = $('#listDg').datagrid('getSelected');
				                                    	var index = $('#listDg').datagrid('getRowIndex',currentRow);
				                                    	currentRow['queryTypeDesc']=record['name'];
				                                    	$('#listDg').datagrid('updateRow',{index:index,row:currentRow});
				                                    }
											
										}
									}">查询条件</th>
	                <th data-options="field:'queryControl',width:100,align:'center',
									formatter:function(value,row){
										return row.queryControlDesc;
									},
									editor:{
										type:'combobox',
										options:{
											valueField:'id',
											textField:'name',
											method:'get',
											url:'${Config.staticURL}code/config/selectOptions/queryControls',
											 onSelect:function(record){
				                                    	var currentRow = $('#listDg').datagrid('getSelected');
				                                    	var index = $('#listDg').datagrid('getRowIndex',currentRow);
				                                    	currentRow['queryControlDesc']=record['name'];
				                                    	$('#listDg').datagrid('updateRow',{index:index,row:currentRow});
				                                    }
											
										}
									}">查询控件</th>
	                <th data-options="field:'dataSource',width:120,align:'center',editor:'textbox'">数据来源(SQL)</th>
	                <th data-options="field:'serialNumber',width:40,align:'center',editor:'textbox'">顺序</th>
	                <th data-options="field:'columnWidth',width:40,align:'center',editor:'textbox'">列宽</th>
	                <th data-options="field:'style',width:100,align:'center',editor:'textbox'">样式</th>
	                <th data-options="field:'link',width:100,align:'center',editor:'textbox'">链接</th>
	                <th data-options="field:'sortName',width:40,align:'center',
	                				formatter:function(value,row){
										if(row.sortName == 'on'){
				                        	return '是';
				                        }else
				                        	return '否';
									},
									editor:{
										type:'checkbox',options:{on:'on',off:'off'}
									}">是否<br/>排序</th>
					<th data-options="field:'sortOrder',width:60,align:'center',
									formatter:function(value,row){
										console.log(row.sortOrder);
										if(row.sortOrder == 'asc'){
				                        	return '顺序';
				                        }else
				                        	return '倒序';
									},
									editor:{
										type:'combobox',
										options:{
											valueField:'id',
											textField:'name',
											method:'get',
											url:'${Config.staticURL}code/config/selectOptions/sortOrders'
											
										}
									}">次序</th>		
	            </tr>
	        </thead>
	    </table>
	    </div>
	    <div data-options="region:'south'" style="height:180px;">
	    <fieldset><legend>表格选项</legend>
	      <form id="listForm" action="code/config/listOption" target="listTargat" method="post"  enctype="multipart/form-data">
	        <table cellpadding="5" data-options="fit:true">
                <tr>
                   <td style="text-align:right"><b>选择</b>:</td>
                   <td><input type="radio" name="selectrow" value="single"/>单选 
                    <input type="radio" name="selectrow" value="multiple"/>复选
                    <input type="radio" name="selectrow" value="no"/>不显示选择按钮 
                    <input id="listFunId" type="hidden" name="funId" ></input></td>
                <td style="text-align:right"><b>其他选项</b>:</td>
                <td><input name="serialnumber" type="checkbox">序号</input>
                    <input name="subtotal" type="checkbox">小计</input>
                    <input name="total" type="checkbox">合计</input>
                    <input name="paging" type="checkbox" >分页</input>
                   </td>
               </tr>
               <tr>
                   <td style="text-align:right"><b>每页行数</b>:</td>
                   <td><input class="easyui-numberbox" type="text" name="pagesize" min="1" max="100" style="width:120px"></input></td>
                   <td style="text-align:right"><b>锁定列</b>:</td>
                   <td><input class="easyui-numberbox" type="text" name="lock" min="0" max="8" style="width:120px"></input></td>
               </tr>
               <tr>
               <td style="text-align:right"><b>列表模板</b>:</td>
                   <td cols=2><input name="listtemplateFile" data-options="prompt:'选择html格式文件'" class="easyui-filebox" style="width:100%;"></input></td>
                   <td><input type=button value="查看列表模板" onclick="viewListtemplate();"></input>
                   <input type=button value="查看列表查询语句" onclick="viewListSQL();"></input></td>
               </tr>
           </table>
	    </form></fieldset>
	    <iframe id="listTargat" name="listTargat" style="display:none"></iframe>
	    <div style="text-align:right;padding:5px">
            <a href="javascript:void(0)" class="easyui-linkbutton"  data-options="iconCls:'icon-save'" onclick="saveList()">保存配置</a></div>
	  </div>
	  </div>
	  <div id="sqlViewerDialog" class="easyui-dialog"  closed="true"  style="width:80%;height:500px;padding:10px" 
	 	 data-options="title:'查看模板',
			iconCls:'icon-search', 
			maximizable:true,
			resizable:true,
			autoOpen: false">
		<textarea id="sqlViewer" cols="108" rows="20">&nbsp;</textarea>
		<button onclick="saveSQL()">保存SQL语句</button>
</div>
<script type="text/javascript">
var listEditIndex = undefined;
$(document).ready(function(){
	$('#listForm').form('load', basePath+'code/config/listOption/'+funId);
});
function listEndEditing(){
	if (listEditIndex == undefined){return true}
	if ($('#listDg').datagrid('validateRow', listEditIndex)){
		$('#listDg').datagrid('endEdit', listEditIndex);
		listEditIndex = undefined;
		return true;
	} else {
		return false;
	}
}
function listOnClickCell(index, field){
	if (listEditIndex != index){
		if (listEndEditing()){
			$('#listDg').datagrid('selectRow', index)
					.datagrid('beginEdit', index);
			var ed = $('#listDg').datagrid('getEditor', {index:index,field:field});
			if (ed){
				($(ed.target).data('textbox') ? $(ed.target).textbox('textbox') : $(ed.target)).focus();
			}
			listEditIndex = index;
		} else {
			setTimeout(function(){
				$('#listDg').datagrid('selectRow', listEditIndex);
			},0);
		}
	}
}
function viewListtemplate(){
	//templateViewer
	$.ajax({
		url : basePath + "codelibs/getTemplateContent/"+funId+"/list",
		type : 'get',
		cache : false,
		success : function(data) {
			$("#templateViewer").val(data["templateContent"]);
			$("#templateViewerDialog").dialog({"title":"查看列表模板"});
			$("#templateViewerDialog").dialog("open");
		},
		error : function() {
		}
	});	
}
function viewListSQL(){
	$.ajax({
		url : basePath + "code/config/sql/"+funId,
		type : 'get',
		cache : false,
		success : function(data) {
			$("#sqlViewer").val(data["sql"]);
			$("#sqlViewerDialog").dialog({"title":"查看列表SQL语句"});
			$("#sqlViewerDialog").dialog("open");
		},
		error : function() {
		}
	});	
	
}
function saveSQL(){
	var data = {};
	data['sql']= $('#sqlViewer').val();
	$.ajax({
		url : basePath + "code/config/sql/"+funId,
		type : 'post',
		data: data,
		success : function(data) {
			$("#sqlViewerDialog").dialog("close");
			$.messager.show({
				title : '提示信息!', 
				msg : 'SQL保存成功！'
			});
		},
		error : function() {
		}
	});	
	
}
function listOnEndEdit(index, row){
	var ed = $(this).datagrid('getEditor', {
		index: index,
		field: 'name'
	});
}
function saveList(){
	listAccept();
	submitListForm();
}
function submitListForm(){
	$('#listForm').attr("action",basePath+"code/config/listOption");
	$("#listForm").submit();
}

function listAccept(){
	if (listEndEditing()){
		var rows = $('#listDg').datagrid('getRows');
		for(var i =0; i < rows.length; i++){
			rows[i]['funId']=funId;
		}
			
		$.ajax({
			url : basePath + "code/config/listProperty",
			type : 'post',
			cache : false,
			data : $.toJSON(rows),
			contentType : 'application/json;charset=UTF-8',
			success : function(data) {
				$('#listDg').datagrid('acceptChanges');
				frames['预览']=true;
				$('#listDg').datagrid('load');
				$.messager.show({
					title : '提示信息!', 
					msg : '保存成功！'
				});
			}
		});
	}
}
</script>
