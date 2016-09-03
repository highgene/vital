<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<title>Insert title here</title>
<script type="text/javascript" src="<%=basePath%>code/js/jquery.min.js"></script>
 
   <link type="text/css" rel="stylesheet" href="<%=basePath%>code/js/codeHeigLight/shCoreDefault.css"/>
   <script type="text/javascript"	src="<%=basePath%>code/js/codeHeigLight/shCore.js"></script>
   <script type="text/javascript"	src="<%=basePath%>code/js/codeHeigLight/shBrushJava.js"></script>
<script type="text/javascript">
$(function(){
	SyntaxHighlighter.all();
	var codeContent = window.parent.$("#codeContent").html();
	$("#code_Block").html(codeContent);	
});
</script>
</head>
<body>
   <pre id="code_Block" class="brush: java;toolbar:false;"></pre>
</body>
</html>