<#import "page/queryControls.ftl" as controls>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Code Generate</title>
    <#include "header.ftl"/>
</head>
<body >
<div style="height:25px">
	<div style="width:80%;float: left">
	<form id="queryForm_${funId}">
	 <#list queryControls as control>
		<b>${control.title}</b>: <@controls.textbox name="${control.name}" width="${control.width}" value=""/>
	</#list>
	<#if (queryControls?size>0)>
	<a href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-search'" onclick="searchData()">查询</a>
	<#else>
	&nbsp;
	</#if>
	<input type=hidden name="funId" value="${funId}"/>
	</form>
	</div>
	<div >
	<#list buttons as button>
		<#include "buttons/${button.type}.ftl">
	</#list>
	</div>
</div>
<div id="win" class="easyui-window" title="Form Window"  closed="true" style="width:600px;height:400px"
            data-options="iconCls:'icon-save',modal:true">
        <iframe id="formFrame" style="width:99%;height:98%;scrollbars:no"></iframe>
</div>
<div region="center">
<table id="${funId}List"  style="width:100%; "></table></div>
<script type="text/javascript" charst="utf-8">
    var funId = '${funId}';
    var basePath = '${baseURL}';
    var listURL = basePath+'${listURL}';
    var gridId = funId+'List';
    var queryFormId = 'queryForm_'+funId;
  
	$(function() {
		$('#'+gridId).datagrid({
			url : listURL, 
			<#if singleSelect?? >
			//选择
			singleSelect:${singleSelect},
			</#if>
			<#if serialnumber??>
			//序号
			rownumbers:${serialnumber},
			</#if>
			<#if paging??>
			pagination:"${paging}",
			</#if>
			pageNumber: 1,
			pageSize:${pageSize},
			fitColumns : false,	
			loadMsg : "正在加载数据", 
			queryParams: {
				funId: funId,
				page:1,
				rows:10
			},
			<#if frozenColumns?? >
			//冻结列
			frozenColumns:${frozenColumns},
			</#if>
			columns : [${columns}]
		});
	});
</script>   
<script type="text/javascript"
	src="${staticURL}code/js/list-preview.js"></script>
</body>
</html>