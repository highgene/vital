<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE HTML>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>出差申请列表</title>
<%@ include file="/demo/header.jsp"%>
</head>
<body class="no-skin v_no_y" >
<div class="row">
	<div class="tab-content">
		<div class="tab-pane active" id="home2">
			<div class="v_box" id="v_box_header2">
				<div class="widget-header ui-sortable-handle">
					<form id="searchForm">
					<div id="nav-search" class="nav-search">
						<span class="input-icon v-search">
							<select id="time" name="taskMan" class="form-control" style="width: 260px;" placeholder="出差时间" required>
								<option value="">请选择出差时间</option>
							  	<option value="1">1月</option>
							  	<option value="2">2月</option>
							  	<option value="3">3月</option>
							</select>
						</span>
						<a onclick="queryBusinessTrip()"><span class="btn btn-xs btn-primary" id="search_inform">
							<i class="ace-icon fa fa-search bigger-120"></i> 
							<span class="bigger-110">查询</span>
						</span></a>
					</div>
					</form>
					<div class="widget-toolbar no-border">
						<a onclick="addBusinessTrip()" ><span class="btn btn-xs btn-primary"> 
							<i class="ace-icon fa fa-plus-circle bigger-130"></i> 
							<span class="bigger-110">出差申请</span>
						</span></a>
					</div>
				</div>
			</div>
			<div class="v_box_frame">
				<div class="v_mt_5">
					<div class="row">
						<div class="col-xs-12">
							<div id="businessTripGrid"></div>
						</div>
					</div>
				</div>
			</div>
		</div>
	</div>
</div>

<script type="text/javascript">
var basePath = '${Config.baseURL}';
var bpmBasePath = basePath;
var bpm = new BPM();
queryBusinessTrip();
//查询
function queryBusinessTrip(){
	$("#businessTripGrid").dataGrid({
		checkbox:true,
		url:basePath + "businessTrip/page/",
		type:"get",
		pagination:true,
		rownum:true,
		param:$("#searchForm").serializeArray(),
		pageSize:10,
		columns:[
			{name:"id",title:"ID",width:"300"},
			{name:"btNumber",title:"出差单号",render: function(row) {
			return '<a href="javascript:void(0)" onclick="businessTripDetail(\''+row.id+'\')">'+row.btNumber+'</a>';}},
				{name:"planStartDate",title:"计划开始时间"},
			{name:"planEndDate",title:"计划结束时间"},
			{name:"planNumberDays",title:"合计天数"},
			{name:"address",title:"出差地点"},
			{name:"reason",title:"出差事由"},
			{name:"processStatus",title:"流程状态"
				/* , render: function(row) {
					if("1"==row.processstatus){
						return "草稿";
					} else if("2" == row.processstatus){
						return "流转中";
					} else if("3" == row.processstatus){
						return "完成";
					}
				} */
			},
			{name:"opt",title:"操作",render: function(row){
					var opt = $('<div class="hidden-sm hidden-xs action-buttons"></div>');
					if("待审批"==row.processStatus){
						opt.append('<a class="green" href="javascript:void(0)" onclick="approveBusinessTrip(\''+row.id+'\',\''+row.processInstanceId+'\')">审批</a>');
					} else if("完成"==row.processStatus){
						opt.append('<a class="red" href="javascript:void(0)" onclick="deleteBusinessTrip(\''+row.id+'\')"><i class="ace-icon fa fa-trash-o bigger-130"></i></a>');
					} else {
						opt.append('<a class="green" href="javascript:void(0)" onclick="editBusinessTrip(\''+row.id+'\',\''+row.processInstanceId+'\')"> <i class="ace-icon fa fa-pencil bigger-130"></i></a>');
						opt.append('<a class="red" href="javascript:void(0)" onclick="deleteBusinessTrip(\''+row.id+'\')"><i class="ace-icon fa fa-trash-o bigger-130"></i></a>');
					}
					return opt;
				}
			}
		]
	});
}
//回车事件查询
$('.v-search-input').keydown(function(e){
	if(e.keyCode == 13){
	   queryBusinessTrip();
	}
}); 
//添加
function addBusinessTrip() {
	$.openWindow({
		id:"fwebModal",
		width : 800,
		height : 400,
		destroy : true,
		url : basePath + "view/demo/businesstrip/add",
		title : "添加",
		showDefaultButton : false
	});
}
//编辑
function editBusinessTrip(id, proccesInstanceId) {
	
	if(proccesInstanceId != "null"){
		bpm.getStatus({
			basePath:bpmBasePath,
			variables : {
				processInstanceId : proccesInstanceId,
			},
			success : function(data){
				var taskConfig = data.currentTasks[0].taskConfig;
				var url = taskConfig.url;
				$.openWindow({
					id:"fwebModal",
					width : 800,
					height : 400,
					destroy : true,
					url : basePath + url + "?id="+id,
					title : "编辑",
					showDefaultButton : false
				});
			}
		});
	} else {
		$.openWindow({
			id:"fwebModal",
			width : 800,
			height : 400,
			destroy : true,
			url : basePath + "view/demo/businesstrip/edit?id="+id,
			title : "编辑",
			showDefaultButton : false
		});
	}
	
}
//详细信息
function businessTripDetail(id) {
	$.openWindow({
		id:"fwebModal",
		width : 800,
		height : 500,
		destroy : true,
		url : basePath + "view/demo/businesstrip/detail?id="+id,
		title : "详细信息",
		showDefaultButton : false
	});
}
//删除
function deleteBusinessTrip(id) {
	$.confirm("确认删除吗", function(flag){
		if(flag){
			$.ajax({
				url : basePath + "businessTrip/" + id,
				type : 'delete',
				success : function(data) {
					queryBusinessTrip();
				},
				error : function(jqXHR, textStatus, errorThrown) {
					$.alert("error","删除失败！");
				}
			});
		}
	});
}
//审批
function approveBusinessTrip(id, proccesInstanceId){
	bpm.getStatus({
		basePath:bpmBasePath,
		variables : {
			processInstanceId : proccesInstanceId,
		},
		success : function(data){
			var taskConfig = data.currentTasks[0].taskConfig;
			var url = taskConfig.url;
			$.openWindow({
				id:"fwebModal",
				width : 800,
				height : 420,
				destroy : true,
				url : basePath + url + "?id="+id,
				title : "审批信息",
				showDefaultButton : false
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