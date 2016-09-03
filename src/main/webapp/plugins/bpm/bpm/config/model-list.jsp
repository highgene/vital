<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/fwebUI/header.jsp"%>   
<div class="row">
	<div class="tab-content">
		<div class="tab-pane active" id="home2">
			<div class="v_box" id="v_box_header2">
				<div class="widget-header ui-sortable-handle">
						<form id="searchForm">
							<div id="nav-search" class="nav-search">
								<span class="input-icon v-search"> <input type="text"
									name="name" class="v-search-input" placeholder="流程名称">
									<i class="ace-icon fa fa-search nav-search-icon"></i>
								</span> <a onclick="queryConfig()"><span
									class="btn btn-xs btn-primary" id="search_inform"> <i
										class="ace-icon fa fa-search bigger-120"></i> <span
										class="bigger-110">查询</span>
								</span></a>
							</div>
						</form>
					<!-- <div class="widget-toolbar no-border">
						<a id="createModel" href="javascript:void(0)"><span class="btn btn-xs btn-primary">
								<i class="ace-icon fa fa-plus-circle bigger-130"></i> <span
								class="bigger-110">创建模型</span>
						</span></a>
						<a id="importModel" href="javascript:void(0)"><span class="btn btn-xs btn-primary">
								<i class="ace-icon fa fa-plus-circle bigger-130"></i> <span
								class="bigger-110">导入模型</span>
						</span></a>
					</div> -->
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
$(function() {
	$('#createModel').button({
		icons: {
			primary: 'ui-icon-plus'
		}
	}).click(function() {
		$.openWindow({
			id : "fwebModal	",
			width : 600,
			height : 280,
			destroy : true,
			url : basePath + "view/bpm/bpm/config/createModel",
			title : "模型创建",
			showDefaultButton : false
		});
	});
	$('#importModel').button({
		icons: {
			primary: 'ui-icon-plus'
		}
	}).click(function() {
		$.openWindow({
			id : "fwebModal	",
			width : 600,
			height : 280,
			destroy : true,
			url : basePath + "view/bpm/bpm/config/importModel",
			title : "模型导入",
			showDefaultButton : false
		});
	});
});
function showSvgTip() {
	alert('点击"编辑"链接,在打开的页面中打开控制台执行\njQuery(".ORYX_Editor *").filter("svg")\n即可看到svg标签的内容.');
}
function queryConfig() {
	var a = $("#searchForm").serializeArray();
	$("#configGrid")
		.dataGrid(
		{
			url : basePath + "bpm/bpm/model/listModelData?processDefinitionId=${param.processDefinitionId}",
			type : "get",
			align : "center",
			pagination : true,
			rownum : false,
			param : $("#searchForm").serializeArray(),
			/* dblclickRow : function(row){
				parent.location = basePath+ 'bpm/modeler.html?modelId='+row.data.id
			}, */
			loadSuccess : function(data){
				var $table = $("#configGrid").find("table:last");
				$table.find("tr").css("cursor","pointer").attr("title","单击选择行").click(function(){
					var id = $(this).children("[id]").attr("id");
					parent.location = basePath+ 'bpm/modeler.html?modelId='+id;
				});
			},
			pageSize : 10,
			columns : [
					{
						name : "id",
						title : "ID",
						width : "10",
						display : false
					},
					{
						name : "key",
						width: 120,
						title : "标识符"
					},
					{
						name : "name",
						title : "流程名称",
						width:120
					},
					
					{
						name : "version",
						width: 50,
						title : "版本"
					},
					{
						name : "createTime",
						width: 160,
						title : "创建时间",
						render : function(row) {
							return new Date(row.createTime).format("yyyy-MM-dd HH:mm:ss");
						}
					},
					{
						name : "lastUpdateTime",
						width: 160,
						title : "最后更新时间",
						render : function(row) {
							return new Date(row.lastUpdateTime).format("yyyy-MM-dd HH:mm:ss");
						}
					},
					{
						name : "metaInfo",
						title : "元数据"
					}/* ,
					{
						name : "opt",
						title : "操作",
						width : 250,
						render : function(row) {
							return '<div class="hidden-sm hidden-xs action-buttons">'
									+ '<a class="blue" title="编辑" target="_blank" href="'+basePath+ 'bpm/modeler.html?modelId='+ row.id+ '"><i class="ace-icon fa fa-gear bigger-130"></i></a>'
									+ '<a class="blue" title="部署" href="javascript:void(0)" onclick="deploy(\''+row.id+'\')"><i class="ace-icon fa fa-play bigger-130"></i></a>'
									+'导出(<a href="'+basePath+ 'bpm/bpm/model/export/'+row.id+'/bpmn" target="_blank">BPMN</a>'
									+'|&nbsp;<a href="'+basePath+ 'bpm/bpm/model/export/'+row.id+'/json" target="_blank">JSON</a>'
									+'|&nbsp;<a href="javascript:;" onclick=\'showSvgTip()\'>SVG</a>)'
									+ '<a class="red" href="javascript:void(0)" onclick="deleteModel(\''+ row.id+ '\')"><i class="ace-icon fa fa-trash-o bigger-130"></i></a>'
									+ '</div>';
						} 
					}*/ ]
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
	window.location.href=basePath + "view/bpm/bpm/config/testProcess?id=" + id+"&processKey="+key;

}
function deploy(id){
	$.ajax({
		url : basePath+ 'bpm/bpm/model/deploy/'+ id,
		type : 'get',
		dataType:'json',
		success : function(data) {
			$.alert("msg",data);
			queryConfig();
		},
		error : function(jqXHR, textStatus, errorThrown) {
			$.alert("error", "部署失败！");
		}
	});
}

//删除
function deleteModel(id) {
	$.confirm("确认删除模型吗", function(flag) {
		if (flag) {
			$.ajax({
				url : basePath + "bpm/bpm/model/delete/" + id,
				type : 'delete',
				success : function(data) {
					$.alert("msg","删除成功！");
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
