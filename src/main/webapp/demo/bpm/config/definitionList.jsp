<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/demo/header.jsp"%>
<div class="row">
	<div class="tab-content">
		<div class="tab-pane active" id="home2">
			<div class="v_box" id="v_box_header2">
				<div class="widget-header ui-sortable-handle">
					<form id="searchForm">
						<div id="nav-search" class="nav-search">
							<span class="input-icon v-search"> <input type="text"
								name="name" class="v-search-input" placeholder="流程名称或标识符">
								<i class="ace-icon fa fa-search nav-search-icon"></i>
							</span> <a onclick="queryConfig()"><span
								class="btn btn-xs btn-primary" id="search_inform"> <i
									class="ace-icon fa fa-search bigger-120"></i> <span
									class="bigger-110">查询</span>
							</span></a>
						</div>
					</form>
					<div class="widget-toolbar no-border">
						<a onclick="addConfig()"><span class="btn btn-xs btn-primary">
								<i class="ace-icon fa fa-plus-circle bigger-130"></i> <span
								class="bigger-110">部署流程</span>
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
queryConfig();

function queryConfig() {
	var a = $("#searchForm").serializeArray();
	$("#configGrid")
		.dataGrid(
		{
			checkbox : false,
			url : basePath + "bpm/config/definitionList/",
			type : "get",
			align : "center",
			pagination : true,
			rownum : false,
			param : $("#searchForm").serializeArray(),
			pageSize : 10,
			columns : [
					{
						name : "id",
						title : "ID",
						width : "10",
						display : false
					},
					{
						name : "name",
						title : "流程名称",
						render : function(row) {
							return '<a href="#" onclick="image(\''
									+ row.id
									+ '\')">'
									+ row.name + '</a>';
						}
					},
					{
						name : "key",
						width: 120,
						title : "标识符"
					},
					{
						
						name : "version",
						width: 50,
						title : "版本"
					},
					{
						name : "resourceName",
						width: 120,
						title : "文件名"
					},
					{
						name : "description",
						title : "描述"
					},
					{
						name : "opt",
						title : "操作",
						width : 160,
						render : function(row) {
							return '<div class="hidden-sm hidden-xs action-buttons">'
									+ '<a class="blue" title="配置任务" href="'+basePath+ 'view/demo/bpm/config/taskList?id='+ row.id+ '"><i class="ace-icon fa fa-gear bigger-130"></i></a>'
									+ '&nbsp;&nbsp;<a class="blue" title="测试流程" href="javascript:void(0)" onclick="testProcess(\'' 
									+ row.id+'\',\''+row.name+'\',\''+row.version + '\',\''+row.key + '\')"><i class="ace-icon fa fa-play bigger-130"></i></a>'
									+ '&nbsp;&nbsp;<a class="green" title="查看【'+ row.name+ '】的实例" href="'+basePath+ 'view/demo/bpm/config/instanceList?id='+ row.id
									+ '"><i class="ace-icon fa fa-list bigger-130"></i></a>'
									+ '&nbsp;&nbsp;&nbsp;&nbsp;<a class="red" href="javascript:void(0)" onclick="deleteConfig(\''+ row.id+ '\')"><i class="ace-icon fa fa-trash-o bigger-130"></i></a>'
									+ '</div>';
						}
					} ]
		});
}
//回车事件查询
$('.v-search-input').keydown(function(e){
	if(e.keyCode == 13){
		queryConfig();
	}
});
//测试流程
function testProcess(id,name,version,key) {
	window.location.href=basePath + "view/demo/bpm/config/testProcess?id=" + id+"&processKey="+key;

}
//部署
function addConfig() {
	$.openWindow({
		id : "fwebModal",
		width : 600,
		height : 280,
		destroy : true,
		url : basePath + "view/demo/bpm/config/deploy",
		title : "部署流程",
		showDefaultButton : false
	});
}

//详细信息
function image(id) {
	$.openWindow({
		id : "fwebModal",
		width : 800,
		height : 400,
		destroy : true,
		url : basePath + "view/demo/bpm/config/definitionImg?id=" + id,
		title : "流程图",
		showDefaultButton : false
	});
}
//删除
function deleteConfig(id) {
	$.confirm("确认删除流程吗", function(flag) {
		if (flag) {
			$.ajax({
				url : basePath + "bpm/config/resource/" + id,
				type : 'delete',
				success : function(data) {
					queryConfig();
				},
				error : function(jqXHR, textStatus, errorThrown) {
					$.alert("error", "删除失败！");
				}
			});
		}
	});
}
//框架JS
mainH();
function mainH() {
	var winH = $(window).height();
	var VH2 = $("#v_box_header2").height();
	$(".v_box_frame").css({
		height : winH - VH2 - 2
	});
}

$(window).resize(function() {
	mainH();
});
</script>
</body>
</html>
