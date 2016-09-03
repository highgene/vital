<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE HTML>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>User List</title>
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
							<input type="text" name="birthDate" class="v-search-input" placeholder="birthDate">
							<i class="ace-icon fa fa-search nav-search-icon"></i>
						</span>
						<span class="input-icon v-search">
							<input type="text" name="email" class="v-search-input" placeholder="email">
							<i class="ace-icon fa fa-search nav-search-icon"></i>
						</span>
						<a onclick="queryUser()"><span class="btn btn-xs btn-primary" id="search_inform">
							<i class="ace-icon fa fa-search bigger-120"></i> 
							<span class="bigger-110">查询</span>
						</span></a>
					</div>
					</form>
					<div class="widget-toolbar no-border">
						<a onclick="addUser()" ><span class="btn btn-xs btn-primary"> 
							<i class="ace-icon fa fa-plus-circle bigger-130"></i> 
							<span class="bigger-110">添加</span>
						</span></a>
					</div>
				</div>
			</div>
			<div class="v_box_frame">
				<div class="v_mt_5">
					<div class="row">
						<div class="col-xs-12">
							<div id="userGrid"></div>
						</div>
					</div>
				</div>
			</div>
		</div>
	</div>
</div>

<script type="text/javascript">
var basePath = '${Config.baseURL}';
queryUser();
//查询
function queryUser(){
	$("#userGrid").dataGrid({
		checkbox:true,
		url:basePath + "user/page/",
		type:"get",
		pagination:true,
		rownum:true,
		param:$("#searchForm").serializeArray(),
		pageSize:10,
		columns:[
			{name:"id",title:"ID",width:"250",display:false},
			{name:"birthDate",title:"birthDate",render: function(row) {
			return '<a href="javascript:void(0)" onclick="userDetail(\''+row.id+'\')">'+row.birthDate+'</a>';}},
				{name:"email",title:"email"},
			{name:"loginId",title:"loginId"},
			{name:"mobilePhone",title:"mobilePhone"},
			{name:"password",title:"password"},
			{name:"phone",title:"phone"},
			{name:"photo",title:"photo"},
			{name:"sex",title:"sex"},
			{name:"signCard",title:"signCard"},
			{name:"userName",title:"userName"},
			{name:"workId",title:"workId"},
			{name:"opt",title:"操作",render: function(row){
				return '<div class="hidden-sm hidden-xs action-buttons">'
				+ '<a class="green" href="javascript:void(0)" onclick="editUser(\''+row.id+'\')"> <i class="ace-icon fa fa-pencil bigger-130"></i></a>'
				+ '<a class="red" href="javascript:void(0)" onclick="deleteUser(\''+row.id+'\')"><i class="ace-icon fa fa-trash-o bigger-130"></i></a>'
				+ '</div>';}}
		],
		headerContextMenu:true
	});
}
//回车事件查询
$('.v-search-input').keydown(function(e){
	if(e.keyCode == 13){
	   queryUser();
	   //也可以用下面reload()方法
	   //$("#userGrid").dataGrid("reload", $("#searchForm").serializeArray());
	}
}); 
//添加
function addUser() {
	$.openWindow({
		id:"fwebModal",
		width : 800,
		height : 400,
		destroy : true,
		url : basePath + "view/demo/user/add",
		title : "添加",
		showDefaultButton : false
	});
}
//编辑
function editUser(id) {
	$.openWindow({
		id:"fwebModal",
		width : 800,
		height : 400,
		destroy : true,
		url : basePath + "view/demo/user/edit?id="+id,
		title : "编辑",
		showDefaultButton : false
	});
}
//详细信息
function userDetail(id) {
	$.openWindow({
		id:"fwebModal",
		width : 800,
		height : 400,
		destroy : true,
		url : basePath + "view/demo/user/detail?id="+id,
		title : "详细信息",
		showDefaultButton : false
	});
}
//删除
function deleteUser(id) {
	$.confirm("确认删除吗", function(flag){
		if(flag){
			$.ajax({
				url : basePath + "user/" + id,
				type : 'delete',
				success : function(data) {
					queryUser();
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