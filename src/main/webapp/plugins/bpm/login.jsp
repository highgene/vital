<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE HTML>
<html lang="en">
<head>
<meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1" />
<meta charset="utf-8" />
<title></title>
<script type="text/javascript" src="${Config.staticURL}fwebUI/js/jquery-2.1.1.min.js"></script>
<script type="text/javascript" src="${Config.staticURL}fwebUI/js/security.js"></script>
<script type="text/javascript" src="${Config.staticURL}fwebUI/js/base64.js"></script>
<script type="text/javascript" src="${Config.staticURL}fwebUI/js/jquery.cookie.js"></script>
<script type="text/javascript" src="${Config.staticURL}fwebUI/js/jquery.json-2.2.js"></script>
<link rel="stylesheet" href="${Config.staticURL}fwebUI/css/style/css/login.css"/>
<script type="text/javascript">
if(window.parent.$("iframe").length > 0){
	window.parent.location = '${Config.baseURL}';
}
var flag = false;
$(function() {
var loginName = $.cookie("cac_loginName");
var password = $.cookie("cac_password");
if(!$.isEmptyObject(loginName) && !$.isEmptyObject(password)){
	document.getElementById("loginName").value = loginName;
	document.getElementById("password").value = password;
	document.getElementById('cookieId').checked = true;
}

//回车事件查询
$('#password').keydown(function(e){
	document.getElementById('tip').innerHTML = "&nbsp;"
	if(e.keyCode == 13){
		login();
	}
});
$('#loginName').keydown(function(e){
	document.getElementById('tip').innerHTML = "&nbsp;"
	if(e.keyCode == 13){
		login();
	}
});
});
function login(){
	var loginName = document.getElementById("loginName").value;
	var password = document.getElementById("password").value;
	if(loginName == ''){
		document.getElementById('tip').innerHTML = "请输入用户名";
		return false;
	}
	if(password == ''){
		document.getElementById('tip').innerHTML = "请输入密码";
		return false;
	}
	document.getElementById('button').disabled = true;
	document.getElementById('button').innerHTML="正在登录...";
	$.ajax({           
	    url: '${Config.baseURL}sso/client/rsakey?loginName='+loginName,    //请求地址   
	    method:"get",
	    success: function(RSAKey) {
	    	var key = RSAUtils.getKeyPair(RSAKey.exponent, '', RSAKey.modulus);
	    	var pwd = RSAUtils.encryptedString(key, password + RSAKey.random);
	    	$.ajax({           
	   	     url: '${Config.baseURL}sso/client/login',    //请求地址   
	   	     method:"post",
	   	     data:$.toJSON({loginName:loginName,password:pwd,random:RSAKey.random}),
	   	     contentType : 'application/json;charset=UTF-8',
	   	     //成功时回调      
	   	     success: function(resOrg, options) {
	   	    	 if(resOrg == "0001"){
	   	    		 if(document.getElementById('cookieId').checked){
	   		    		 $.cookie("cac_loginName", loginName,{expires:365});
	   		    		 $.cookie("cac_password", password,{expires:365});
	   		    	 } else {
	   		    		 $.cookie("cac_loginName", '');
	   		    		 $.cookie("cac_password", '');
	   		    	 }
	   		    	 document.getElementById('button').disabled = false;
	   		    	 window.location = "${pageContext.request.contextPath}";
	   	    	 } else {
	   	    		document.getElementById('button').disabled = false;
	   	 	    	document.getElementById('tip').innerHTML = "用户名或密码错误，请重新输入";
	   	 	  		document.getElementById('button').innerHTML="登录";
	   	    	 }
	   	    },
	   	    error:function(f,o){
	   	    	document.getElementById('button').disabled = false;
	   	    	document.getElementById('tip').innerHTML = "用户名或密码错误，请稍后再试";
   	 	  		document.getElementById('button').innerHTML="登录";
	   		}
	   	});
	   	},
	   	error:function(f,o){
	   		document.getElementById('button').disabled = false;
   	    	document.getElementById('tip').innerHTML = "用户名或密码错误，请稍后再试";
	 	  	document.getElementById('button').innerHTML="登录";
		}
	});
}
function register(){
	window.location.href='${Config.baseURL}view/cac/login/regist';
}

function clearPwd(e){
	document.getElementById("password").value = "";
	flag = true;
}
</script>
</head>
<body>
<div class="login">
	<h1 class="login_logo"></h1>

			<dl>
				<dt></dt>
				<dd><input class="us" id="loginName" placeholder="用户名/手机/邮箱"/> </dd>
				<dd><input class="pw" id="password" type="password" placeholder="密码" onfocus="clearPwd()"/></dd>
				<dd class="xcdl_wjmm"><a href="${Config.baseURL}view/cac/login/findPwd" class="wjmm">忘记密码</a><input type="checkbox" id="cookieId">保存登录信息</dd>
				<dd id="tip" style="color: red;">&nbsp;</dd>
				<dd class="buts"><button onclick="login()" id="button">登  录</button><button type="button" class="active" onclick="register();">注  册</button></dd>
			</dl>
		<!-- <div class="other">
			<h3>可以使用以下方式登录</h3>
			<p>
			<a class="qq"></a>
			<a class="sina"></a>
			<a class="crs"></a>
			<a class="weixin"></a>
			</p>
		</div> -->
	
</div>

<div class="login_copy">版权所有：北京恒华科技</div>

</body>
</html>
