<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>组件DEMO</title>
<%@ include file="/demo/header.jsp"%>
</head>
<body>
	<div class="container main" style="width: 100%">
      	<ul class="nav nav-tabs" style="z-index: 10000; width: 600px;">
		   <li><a href="${Config.baseURL}view/demo/user/list">代码生成DEMO</a></li>
		   <li class="active"><a href="${Config.baseURL}view/demo/user/userGrid" style="color: red;">UI组件DEMO</a></li>
		   <li ><a href="${Config.baseURL}view/demo/user/grid">表格行合并DEMO</a></li>
		   <li ><a href="${Config.baseURL}view/demo/bpm/config/definitionList">流程后台配置</a></li>
		   <li ><a href="${Config.baseURL}view/demo/businesstrip/list">出差流程DEMO</a></li>
		</ul>
		<div class="panel panel-default">
			<div class="panel-body">
				<form id="searchForm" filter="true">
					<div class="row">
						<div class="col-sm-3">
							<div class="input-group ">
								<span class="input-group-addon">用户名</span> <input type="text"
									class="form-control" placeholder="用户名" oper="like" value=""
									name="loginId" width="98%">
							</div>
						</div>
						<div class="col-sm-3">
							<div class="input-group ">
								<span class="input-group-addon">姓名</span> <input type="text"
									class="form-control" placeholder="姓名" name="userName" oper="like" value="">
							</div>
						</div>
						<div class="col-sm-3">
							<select id="sexSelect"></select>
						</div>
						<div class="col-sm-1">
							<div class="btn-group btn-group-sm">
								<a class="btn btn-info" id="queryUser"><span
									class="glyphicon glyphicon-plus"></span> 查 询 </a>
							</div>
						</div>
					</div>
				</form>
			</div>
			<div class="panel panel-default">
				<div class="panel-heading">
					<strong>用戶列表</strong>&nbsp;&nbsp;&nbsp;&nbsp;
					<div class="btn-group btn-group-sm">
						<!-- Button trigger modal -->
						<a class="btn btn-info " onclick="openUserDatail()">
						  <span class="glyphicon glyphicon-plus"></span> 打开对话框
						</a>
					</div>
					<div class="btn-group btn-group-sm">
						<!-- Button trigger modal -->
						<a class="btn btn-info " onclick="openAlert()">
						  <span class="glyphicon glyphicon-plus"></span> 打开警告框
						</a>
					</div>
					<div class="btn-group btn-group-sm">
						<!-- Button trigger modal -->
						<a class="btn btn-info " onclick="openConfirm()">
						  <span class="glyphicon glyphicon-plus"></span> 打开确认框
						</a>
					</div>
					<div class="btn-group btn-group-sm">
						<!-- Button trigger modal -->
						<a class="btn btn-info " onclick="getSelect()">
						  <span class="glyphicon glyphicon-plus"></span> 获取选中的行数据
						</a>
					</div>
					<div class="btn-group btn-group-sm">
						<!-- Button trigger modal -->
						<a class="btn btn-info " onclick="getSelectIds()">
						  <span class="glyphicon glyphicon-plus"></span> 获取选中的行数据ID
						</a>
					</div>
					<div class="btn-group btn-group-sm">
						<!-- Button trigger modal -->
						<a class="btn btn-info " onclick="addRow()">
						  <span class="glyphicon glyphicon-plus"></span>添加行
						</a>
					</div>
				</div>
				<div id="userGrid"></div>
			</div>
		</div>
	</div>
	
<script type="text/javascript">
var basePath = '${Config.baseURL}';
		var url = basePath + "user/page";
		var sexUrl = basePath + "user/sex";
		var sexData = [
				    {sexValue:"0",sexText:"男"},
				    {sexValue:"1",sexText:"女"}
				];
		loadGrid();
		
		$("#sexSelect").select({
			//url:sexUrl,
			data:sexData,
			isWrite : true,
			option:{value:"sexValue", text:"sexText"},
			placeholder : "请选择性别",
			defaultVal:["0"]
		});
		
		function loadGrid(){
			$("#userGrid").dataGrid({
				checkbox:true,
				url:url,
				align:"left",
				type:"get",
				saveUrl:basePath+"user",
				pagination:true,
				rownum:true,
				param: $("#searchForm").serializeArray(),
				pageSize:{xs:6,sm:10,md:15,lg:25,ml:30},
				enableRowEditEvent:false,
				columns:[{name:"id",title:"ID",width:"10",align:"center",sort:false,display:false},
				     {name:"info",title:"基本信息",width:"350",columns:[ 
								{name:"loginId",title:"用户名",width:"150",align:"",sort:false,showContent:true,render: function(row){
									return "<a href=\"${Config.baseURL}view/demo/user/userDetail?userId="+row.id+"\">"+row.loginId+"</a>"}},
								{name:"userName",title:"姓名(排序)",width:"150",align:"",sort:true,showContent:true,
										editor:{type:"text",options:{eventType:"click",eventFunction:function(){
											$.alert("info",$(this).val());
										}}}
								}
							]},
					{name:"ext",title:"扩展信息",width:"490",columns:[
						{name:"mobilePhone",title:"手机",width:"100",align:"",sort:false,level:"md",editor:{type:"text"}},
						{name:"sex",title:"性别(sex)",width:"70",align:"",sort:false,level:"lg",editor:{type:"select",options:{value:"sexValue",text:"sexText",data:sexData}}},
						/* {name:"sex",title:"性别",width:"",align:"",sort:false,editor:{type:"select",options:{value:"value",text:"text",url:sexUrl}}}, 从后台取下拉框的值*/
						{name:"birthDate",title:"日期",width:"200",align:"",sort:false,level:"ml",editor:{type:"date",options:{language : "zh-CN",autoclose : true,startView : 2,minView : 0,maxView : 2, format: "yyyy-mm-dd hh:ii:ss"}}}//editor:{type:"myself",options:function(value){return '<input type="text" class="form-control" id="birthDate" showValue="'+value+'" value="'+value+'" style="width: 98%; margin: 0px auto;"/>'}}
					]},
					{name:"opt",title:"操作",align:"",sort:false,render: function(row){
							var menu = $("<a href=\"#\" onclick=\"deleteUser('"+row.id+"')\">删除</a> "
							+"<a href=\"#\" onclick=\"saveUser(this)\">保存</a> "
							+"<a href=\"#\" onclick=\"editUser('"+row.id+"')\">编辑</a> "
							+'<a class="green" name="dropMenu" href="javascript:void(0)"> <i class="ace-icon fa fa-pencil bigger-130"></i>点击菜单</a>');
							
							menu.last("a").dropdownmenu({
								width:80,
								items: [{ id: "toubiao", text: "投标记录", click:function(e){$.alert("succuss", row.id);}},
								        { id: "feiyong", text: "费用维护", click:function(e){$.alert("succuss", row.id);}}],
							});
							return menu;
						}
					}
				],
				dblclickRow:function(event){
					//alert($.toJSON(event.data));
				},
				saveValidate: function(row, tr){
					if(!(row.mobilePhone.length == 11 && /^(((13[0-9]{1})|(15[0-9]{1})|(18[0-9]{1}))+\d{8})$/.test(row.mobilePhone))){
						tr.find("input[name='mobilePhone']").prompt("请输入正确的手机号");
						return false;
					}
					return true;
				},
				afterSave: function(isSuccess, data){
					//alert(isSuccess);
				},
				loadSuccess:function(data){
					//alert($("#userGrid").find("th[name='loginId']").outerWidth())
				},
				headerContextMenu: ["loginId","userName","mobilePhone","sex","birthDate"],
				userId:"test",
				initSortField:{"userName":"asc"}
			});
		}
		
		$("#queryUser").click(function() {
			loadGrid();
		});
	
		//回车事件查询
		$('#searchForm input').keydown(function(e){
			if(e.keyCode == 13){
				loadGrid();
			   //也可以用下面reload()方法
			   //$("#userGrid").dataGrid("reload", $("#searchForm").serializeArray());
			}
		});
		
	function deleteUser(userId) {
		$.ajax({
			url : basePath + "user/" + userId,
			type : 'delete',
			success : function(data) {
				loadGrid();
			},
			error : function(jqXHR, textStatus, errorThrown) {
				alert("error");
			}
		});
	}
	function openAlert() {
		//alert($("select option:selected").val()+"   "+$("select option:selected").text());
		//alert($("table th:eq(1)").html());
		$.alert("warning", "test warning");
	}
	
	function openConfirm(){
		$.confirm("确认对话框", function(flag){
			if(flag){
				$.confirm("删除对话框", function(flag){
					if(flag){
						$.alert("success", "删除成功");
					}
				});
			}
		}, true);
	}
	
	function openUserDatail() {
		$.openWindow({
			id:"fwebModal",
			width : 900,
			height : 400,
			destroy : true,
			url : basePath + "view/demo/user/detail",
			title : '用户详细页面DEMO',
			showDefaultButton : true,
			load:true,
			confirm : function() {
				alert("确定");
				$.alert("success", "success");
				$('#fwebModal').modal('hide');
			}
		});
	}
	function getSelect() {
		var rows = $("#userGrid").dataGrid("getSelections");
		alert($.toJSON(rows));
	}
	function getSelectIds() {
		var rows = $("#userGrid").dataGrid("getSelectIds");
		alert($.toJSON(rows));
	}
	
	function addRow(){
		$("#userGrid").dataGrid("addRow");
	}
	
	function saveUser(me){
		var tr = $(me).parent().parent();
		$("#userGrid").dataGrid("saveRow",tr);
	}
	
	function editUser(rowId){
		$("#userGrid").dataGrid("editRow",rowId);
	}
	
</script>	
</body>
</html>
