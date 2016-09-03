<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="/fwebUI/header.jsp"%>   
<div class="row">
	<div class="tab-content">
		<div class="tab-pane active" id="home2">
			<div class="v_box" id="v_box_header2">
				<div class="widget-header ui-sortable-handle">
					<form id="searchForm">
					<input type="hidden" name="defineId" value="${param.id}"> 
					<div id="nav-search" class="nav-search">
						<span class="input-icon v-search">
							<input type="text" name="name" class="v-search-input" placeholder="流程实例名称或业务标识">
							<i class="ace-icon fa fa-search nav-search-icon"></i>
						</span>
						<a onclick="queryProcessinstance()"><span class="btn btn-xs btn-primary" id="search_inform">
							<i class="ace-icon fa fa-search bigger-120"></i> 
							<span class="bigger-110">查询</span>
						</span></a>
					</div>
					</form>
					<div class="widget-toolbar no-border" style="z-index:10000 ">
						
						<a onclick="returnDefinitionList()" ><span class="btn btn-xs btn-primary"> 
							<i class="ace-icon fa fa-chevron-left bigger-130"></i> 
							<span class="bigger-110">返回流程定义列表</span>
						</span></a>
					</div>
				</div>
			</div>
			<div class="v_box_frame">
				<div class="v_mt_5">
					<div class="row">
						<div class="col-xs-12">
							<table id="configGrid"></table>
						</div>
					</div>
				</div>
			</div>
		</div>
	</div>
</div>
<script type="text/javascript">
var basePath = '${Config.baseURL}';
var definitionId = '${param.id}';
queryProcessinstance();

function queryProcessinstance(){
	$("#configGrid").dataGrid({
		checkbox:false,
		url:basePath + "bpm/bpm/config/instanceList/",
		type:"get",
		pagination:true,
		rownum:false,
		param:$("#searchForm").serializeArray(),
		pageSize:10,
		columns:[
			{name:"id",title:"ID",width:"10",display:false},
			{name:"name",title:"实例名称",render: function(row) {
			return '<a href="javascript:void(0)" onclick="testProcess(\''+ row.processDefinitionId+'\',\''+row.name+'\',\''+row.processInstanceId+'\',\''+row.businessKey+'\')">'+row.name+'</a>';}},
			{name:"businessKey",width:160,title:"业务标识"},
			{name:"processDefinitionKey",width:160,title:"流程定义标识",render:function(row){return row['processDefinitionId'].split(":")[0];}},
			{name:"startTime",width:160,title:"开始时间"},
			{name:"endTime",width:160,title:"结束时间"},
			{name:"opt",title:"操作", width:90,render: function(row){
				
				var options = '<div class=" action-buttons">';				
				
				if(row.endTime == null || row.endTime == 'null' && row.endTime == ''){
					options += '<a class="blue" title="强制结束流程实例" href="#" onclick="forceStop(\''+row.processInstanceId+'\')"><i class="ace-icon fa fa-stop bigger-130"></i></a>';
				}else{
					options += '&nbsp;&nbsp;&nbsp;';
				}
				options += '&nbsp;&nbsp;<a class="red" title="删除流程实例" href="#" onclick="deleteConfig(\''+row.processInstanceId+'\',\''+row.endTime+'\')"><i class="ace-icon fa fa-trash-o bigger-130"></i></a>';
					
				options += '</div>';
				return options
				
				}}
		]
	});
}
//回车事件查询
$('.v-search-input').keydown(function(e){
	if(e.keyCode == 13){
		queryProcessinstance();
	}
});
//返回流程定义列表
function returnDefinitionList(){
	
	location.href= basePath + "view/bpm/bpm/config/definitionList";
}
//测试流程
function testProcess(definitionId,name,id,businessKey) {
	window.location.href=basePath + "view/bpm/bpm/config/testProcess?id=" + definitionId+"&processInstanceId="+id+"&businessKey="+businessKey;
}


//强制结束流程
function forceStop(id){
	$.confirm("确认强制结束流程实例吗？【结束流程后，数据将移入历史库中！】", function(flag){
		if(flag){
			$.ajax({
				url : basePath + "bpm/bpm/config/forceStop/" + id,
				type : 'delete',
				success : function(data) {
					queryProcessinstance();
				},
				error : function(jqXHR, textStatus, errorThrown) {
					$.alert("error","操作失败！");
				}
			});
		}
	},true);
	
}
//删除
function deleteConfig(id, endTime) {
		
	$.confirm("确认删除流程实例吗？【删除流程实例将导致相关业务数据的状态失效！】", function(flag){
		if(flag){
			$.ajax({
				url : basePath + "bpm/bpm/config/processintances/" + id,
				type : 'delete',
				success : function(data) {
					queryProcessinstance();
				},
				error : function(jqXHR, textStatus, errorThrown) {
					$.alert("error","删除失败！");
				}
			});
		}
	});
}
//框架JS
mainH();
function mainH(){
	var winH = $(window).height();
	var VH2 = $("#v_box_header2").height();
	$(".v_box_frame").css({ height: winH -VH2 - 2 });
}

$(window).resize(function(){
	mainH();
});
</script>
</body>
</html>
