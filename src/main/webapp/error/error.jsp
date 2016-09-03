<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@page import="com.hhwy.framework.exception.ExceptionMessage" %>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<HTML><HEAD><TITLE>服务器异常！！！</TITLE>
<META http-equiv=Content-Type content="text/html; charset=gb2312">
<STYLE type=text/css>
.font16 {
	FONT-SIZE: 16px
}
.font14 {
	FONT-SIZE: 14px
}
.font12 {
	FONT-SIZE: 12px
}
.font12 a{
	FONT-SIZE: 12px; color: #CC0000; text-decoration:none;
}
</STYLE>
</HEAD>
<BODY>
<%Object obj = request.getAttribute("eMsg");
String msg = ((ExceptionMessage)obj).getExceptionMsg();
%>
	<TABLE height=500 cellSpacing=0 cellPadding=0 width=500 align=center background=${pageContext.request.contextPath}/error/error.gif border=0>
	  	<TBODY>
		  <TR>
		    <TD height=330>  </TD>
		  </TR>
		  <TR>
		    <TD vAlign=top>
		      	<DIV class=font16 align=center><STRONG>Sorry!!!&nbsp;&nbsp;服务器出错了：<%=msg %>......</STRONG><br>
		      		<br>
		      		<SPAN  class=font12>
			      		<FONT color=#666666>
			      			返回<A href="${pageContext.request.contextPath}/index.jsp">恒华伟业</A>首页......
			    		</FONT>
		    		</SPAN>
		    	</DIV>
		    </TD>
		  </TR>
		  </TBODY>
	  </TABLE>
</BODY>
</HTML>
