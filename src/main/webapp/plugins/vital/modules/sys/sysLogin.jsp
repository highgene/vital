<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="org.apache.shiro.web.filter.authc.FormAuthenticationFilter"%>
<%@ include file="/plugins/vital/views/include/taglib.jsp"%>
<html>
	<head>
		<title>登陆</title>
		<meta http-equiv="Content-Type" content="text/html;charset=utf-8" />
		<meta name="renderer" content="webkit"><meta http-equiv="X-UA-Compatible" content="IE=8,IE=9,IE=10" />
		<meta http-equiv="Expires" content="0"><meta http-equiv="Cache-Control" content="no-cache">
		<meta http-equiv="Cache-Control" content="no-store">
		<script src="${ctxStatic}/jquery/jquery-1.8.3.min.js" type="text/javascript"></script>
		<link rel="stylesheet" type="text/css" href="${ctxStatic}/css/base.css"/>
		<link rel="stylesheet" type="text/css" href="${ctxStatic}/css/login.css"/>
		<style type="text/css">
		.hide{
			display: none;
		}
		</style>
		<script type="text/javascript">
			$(function(){
				$(".login-u label,.login-p label").each(function(i,item){
					$(this).click(function(){
						$(this).siblings("input").focus();
						$(this).hide();
					})
					if(item.value != ""){
						$(this).hide();
					};
				});
				$(".login-u input,.login-p input").each(function(){
					$(this).blur(function(){
						if($(this).val() == ""){
							$(this).siblings("label").show();
						};
					});
					$(this).focus(function(){
						$(this).siblings("label").hide();
					})
				});
			});
			
			// 如果在框架或在对话框中，则弹出提示并跳转到首页
			if(self.frameElement && self.frameElement.tagName == "IFRAME" || $('#left').length > 0 || $('.jbox').length > 0){
				alert('未登录或登录超时。请重新登录，谢谢！');
				top.location = "${ctx}";
			}
		</script>
	</head>
	<body>
		<form action="${ctx}/login" method="post">
			<div class="container">
				<div class="login-box">
					<div class="login-logo"></div>
					<div class="login-main mar-t10">
						<div class="login-top"></div>
						<div class="login-u">
							<i class="icon" for="username"></i>
							<label for="username">请输入用户名</label>
							<input type="text" name="username" id="username" value="${username}" />
						</div>
						<div class="login-p">
							<i class="icon" for="password"></i>
							<label for="password">请输入密码</label>
							<input type="password" name="password" id="password"/>
						</div>
						<div class="saveUser">
							<input type="checkbox" name="rememberMe" id="rememberMe" ${rememberMe ? 'checked' : ''}/>
							<label for="rememberMe">保存用户名</label>
						</div>
						<div class="clear"></div>
						<div class="saveUser">
							<label id="loginError" style="margin:0 0 5 0; color:#CC6633" class="${empty message ? 'hide' : ''}" >${message}</label>
						</div>
						<div class="login-btn">
							<button type="submit">登陆</button>
						</div>
					</div>
				</div>
				<div class="copy">
					<p>版权所有:中国路桥工程有限责任公司</p>
				</div>
			</div>
		</form>
	</body>
</html>
