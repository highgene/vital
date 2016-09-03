<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Code Generate</title>
    <%@ include file="../header.jsp"%>
</head>
<body>
<table id="tg" class="easyui-datagrid" style="padding: 1px; text-align: left;"
		data-options="
			idField: 'id',
			fit:true,
			iconCls: 'icon-ok',
			rownumbers: true,
			striped:true,
			singleSelect:true,
			fitColumns: true,
			url: '${Config.basePath}code/config/getCodes/${param.funId}',
			method: 'get'			
		">
	<thead>
		<tr>
			<th data-options="field:'codeType',width:30">代码类型</th>
			<th data-options="field:'codePackagePath',width:120">包路径</th>
			<th data-options="field:'codeFileName',width:180,
				formatter:function(value , record , index){
 						return '<a href=javascript:void(0) style=text-decoration:none onClick=showCode('+index+')>'+value+'</a>' ;
				}"
			>代码文件</th>
			<th data-options="field:'codeFilePath',width:30,hidden:true"></th>
		</tr>
	</thead>
</table>
<div id="codeDialog" style="overflow: hidden;">
	<iframe id="ifc" width="100%" height="100%" src="" frameborder="0" scrolling="auto" marginheight="0" marginwidth="0"></iframe>
</div>
<div id="codeContent" ></div>
<script type="text/javascript">
	var basePath = '${Config.baseURL}';
	function showCode(index){
		$("#codeDialog").dialog({
			title:'代码预览',
			width : 800,  
		    height : 500, 
		    resizable : true,
		    maximizable : true,
		    closed : true,
		    cache : false,
		    modal : true
		});
		var dataGridData = $('#tg').datagrid('getData');
		var codeFilePath = dataGridData.rows[index].codeFilePath;
		$.ajax({
			url : basePath + "code/config/getCodeContent",
			type : 'post',
			cache : false,
			data : codeFilePath,
			contentType : 'application/json;charset=UTF-8',
			success : function(data) {
				var codeContent = data && data.content ? data.content:"";
				$("#codeContent").html(codeContent);	
				$('#codeDialog').dialog('open');
				$("#ifc").attr("src","${Config.staticURL}code/config/codeContent.jsp");
			},
			error : function() {
			}
		});
		
	}
</script>    
</body>
</html>