<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE HTML>
<html>
<%@include file="static/vital-jshelper/header.jsp"%>
<script type="text/javascript">

$(function(){
	$("#choseUser").click(function(){
		//showUser = function(domainid, targetid, orgids, multi, roleid, selected, callback)
		showUser('','','315fae91e2f74c7dbd982b0cccb4eea0,e133470e6e2b4380b61e2eb7ce7330a9',1,'','',function(users){
			$("#rs").html(JSON.stringify(users))
		});
	});
	
	$("#choseOrg").click(function(){
		showOrg('1bbdbfd91e0c11e6866500ff5d77254e','', 0, '315fae91e2f74c7dbd982b0cccb4eea0,e133470e6e2b4380b61e2eb7ce7330a9',function(orgs){
			$("#rs").html(JSON.stringify(orgs));
		});
	});
})

</script>
<body>
<p>JS控件开发测试</p>
<br>
<p id="rs"></p>
<button id="choseUser">选择用户</button>
<button id="choseOrg">选择组织机构</button>
</body>
</html>
