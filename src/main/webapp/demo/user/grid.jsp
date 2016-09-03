<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE HTML>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>
<%@ include file="/demo/header.jsp"%>
<script type="text/javascript"
	src="${Config.staticURL}fwebUI/fweb.js"></script>
<style type="text/css">
table td {
	border: 1px solid red;
}
</style>
</head>
<body>
	<div class="container main" style="width: 100%">
      	<ul class="nav nav-tabs">
		   <li><a href="${Config.baseURL}view/demo/user/list">代码生成DEMO</a></li>
		   <li><a href="${Config.baseURL}view/demo/user/userGrid">UI组件DEMO</a></li>
		   <li class="active"><a href="${Config.baseURL}view/demo/user/grid" style="color: red;">表格行合并DEMO</a></li>
		   <li ><a href="${Config.baseURL}view/demo/bpm/config/definitionList">流程后台配置</a></li>
		   <li ><a href="${Config.baseURL}view/demo/businesstrip/list">出差流程DEMO</a></li>
		</ul>
		<div id="grid"></div>
	</div>
<script type="text/javascript">
var data = {"data":[ {"city":"北京","sex":"男","name":"张三","phone":"158103554","birthday":"2014-01-09"},
                     {"city":"北京","sex":"男","name":"张三","phone":"158103554","birthday":"2014-01-09"},
			         {"city":"北京","sex":"男","name":"李四","phone":"158103554","birthday":"2014-01-09"},
			         {"city":"北京","sex":"女","name":"李四","phone":"158103554","birthday":"2014-01-09"},
			         {"city":"北京","sex":"女","name":"suze","phone":"158fds54","birthday":""},
			         {"city":"北京","sex":"女","name":"suze","phone":"158fds54","birthday":""},
			         {"city":"北京","sex":"女","name":"suze","phone":"158fds54","birthday":"2014-01-09"},
			         {"city":"上海","sex":"女","name":"suze","phone":"158fds554","birthday":"2014-01-09"},
			         {"city":"上海","sex":"女","name":"李四","phone":"158fds554","birthday":"2014-01-09"},
			         {"city":"上海","sex":"女","name":"suze","phone":"158fds554","birthday":"2014-01-09"},
			         {"city":"上海","sex":"女","name":"李四","phone":"158fds554","birthday":"2014-01-09"},
			         {"city":"上海","sex":"女","name":"suze","phone":"158fds554","birthday":"2014-01-09"},
			         {"city":"上海","sex":"女","name":"李四","phone":"158fds554","birthday":"2014-01-09"},
			         {"city":"上海","sex":"女","name":"suze","phone":"158fds554","birthday":"2014-01-09"},
			         {"city":"上海","sex":"女","name":"李四","phone":"158fds554","birthday":"2014-01-09"},
			         {"city":"上海","sex":"女","name":"李四","phone":"158fds554","birthday":"2014-01-09"},
			         {"city":"天津","sex":"男","name":"李四","phone":"158fds554","birthday":"2014-01-09"},
			         {"city":"天津","sex":"男","name":"suze","phone":"158fds554","birthday":"2014-01-09"},
			         {"city":"天津","sex":"男","name":"suze","phone":"158fds554","birthday":"2014-01-09"},
			         {"city":"天津","sex":"女","name":"suze","phone":"158fds554","birthday":"2014-01-09"}],
         "total":20};
var columns = [{name:"city",title:"城市",mergeLevel :1},
               {name:"sex",title:"性别",mergeLevel :2},
               {name:"name",title:"姓名",mergeLevel :3},
               {name:"phone",title:"手机",level:"md"},
               {name:"birthday",title:"生日"}
                       ];
	$("#grid").dataGrid({
		columns:columns,
		data:data,
		radio:true,
		pagination:true,
		pageSize: 20,
		rownum:true,
		headerContextMenu:true,
		height:getHeight,
		loadSuccess: function(){
		}
	});
	
	function getHeight(){
		var docHeight = $(window).innerHeight();
		var navHeight = $(".nav").outerHeight();
		var tableHeight = docHeight - navHeight;
		return tableHeight;
	}
</script>
</body>
</html>