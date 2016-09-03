<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<HTML>
<HEAD>
<TITLE>您访问的地址不正确！！！</TITLE>
<META http-equiv=Content-Type content="text/html; charset=UTF-8">
<STYLE type=text/css>
.font14 {
	FONT-SIZE: 14px
}

.font12 {
	FONT-SIZE: 12px
}

.font12 a {
	FONT-SIZE: 12px;
	color: #CC0000;
	text-decoration: none;
}
</STYLE>
</HEAD>
<BODY>
	<TABLE height=500 cellSpacing=0 cellPadding=0 width=500 align=center
		background=${pageContext.request.contextPath}/error/error.gif border=0>
		<TBODY>
			<TR>
				<TD height=330></TD>
			</TR>
			<TR>
				<TD vAlign=top>
					<DIV class=font14 align=center>
						<STRONG>你访问的页面域名<FONT color=#0099ff>不存在</FONT>或者<FONT color=#ff0000>请求错误！</FONT></STRONG><BR>
						<SPAN class=font12>
							<FONT color=#666666>返回<A href="${pageContext.request.contextPath}/index.jsp">恒华伟业</A>首页......
							</FONT>
						</SPAN>
					</DIV>
				</TD>
			</TR>
		</TBODY>
	</TABLE>
</BODY>
</HTML>
