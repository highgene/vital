<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/plugins/vital/views/include/taglib.jsp"%>
<!DOCTYPE html>
<html>
<head>

	<meta charset="utf-8">
	<meta name="viewport" content="width=device-width, initial-scale=1.0">
	<meta name="renderer" content="webkit">
	<meta http-equiv="Cache-Control" content="no-siteapp" />
	<title>${fns:getConfig('productName')}</title>

	<link rel="shortcut icon" href="favicon.ico">
	<link href="${ctxStatic }/index/css/bootstrap.min14ed.css?v=3.3.6" rel="stylesheet">
	<link href="${ctxStatic }/index/css/font-awesome.min93e3.css?v=4.4.0" rel="stylesheet">
	<link href="${ctxStatic }/index/css/animate.min.css" rel="stylesheet">
	<link href="${ctxStatic }/index/css/style.min862f.css?v=4.1.0" rel="stylesheet">

	<style type="text/css">

	</style>

	<!--引入css-->
	<link rel="stylesheet" type="text/css" href="${ctxStatic}/vital/css/base.css"/>
	<link rel="stylesheet" type="text/css" href="${ctxStatic}/vital/css/index.css"/>
</head>

<c:set var="menuList" value="${fns:getMenuList()}" />

<body class="fixed-sidebar full-height-layout gray-bg  pace-done fixed-nav skin-1" style="overflow:hidden">

<header>
	<h1 class="logo f-l"></h1>
	<div class="itemName"></div>
	<div class="head-right f-r">
		<div class="weather f-r mar-t5">
			<i class="icon f-l"><img src="${ctxStatic}/vital/images/weatherIcon.png"/></i>
			<span class="f-l">多云</span>
			<span class="f-l">20℃/30℃</span>
		</div>
		<div class="user mar-t10 clear f-r" style="overflow:visible">
			<h2 class="f-l">操作员，您好，欢迎您登录</h2>
			<div class="inform p-r mar-l20 f-l">
				<i class="icon f-l"></i>
				<h3 class="f-l">12</h3>
			</div>
			<div class="user-switch mar-l20 f-l">
				<i class="icon f-l"></i>
				<h3 class="f-l">角色切换</h3>
			</div>
			<div class="exit mar-l20 mar-r10 f-l">
				<a href="${ctx}/logout" title="注销"><i class="icon f-l"></i><h3 class="f-l">注销</h3></a>
			</div>
		</div>
	</div>
</header>

<div id="wrapper">
	<!--左侧导航开始-->
	<nav class="navbar-default navbar-static-side" role="navigation">
		<div class="nav-close"><i class="fa fa-times-circle"></i></div>
		<div class="sidebar-collapse">
			<ul class="nav" id="side-menu">
				<c:forEach items="${menuTree}" var="menuMap1" varStatus="stat"><!-- 显示第一级菜单-->
						<c:if test="${menuTree[menuMap1.key]==null}"> <!--如果没有第二级菜单-->
							<li class="fa fa-home"><a class="J_menuItem" href="${fn:indexOf(menu.url, '://') eq -1 ? ctx : ''}${menuMap[menuMap1.key].url}">${menuMap[menuMap1.key].resourceName}</a></li>
						</c:if>
						<c:if test="${menuTree[menuMap1.key]!=null}"> <!--如果有第二级菜单-->
							<li >
								<a href="#"><div class="fa fa-home" style="margin-right: 8px"></div><span class="nav-label">${menuMap[menuMap1.key].resourceName}</span><span class="fa arrow"></span></a>
								<ul class="nav nav-second-level">
									<c:forEach items="${menuTree[menuMap1.key]}" var="menuMap2"><!-- 显示第二级菜单-->
										<c:if test="${menuTree[menuMap1.key][menuMap2.key]==null}"><!--如果没有第三级菜单-->
												<li><a class="J_menuItem" href="${fn:indexOf(menu.url, '://') eq -1 ? ctx : ''}${menuMap[menuMap2.key].url}">${menuMap[menuMap2.key].resourceName}</a></li>
										</c:if>
										<c:if test="${menuTree[menuMap1.key][menuMap2.key]!=null}"> <!--如果有第三级菜单-->
											<li>
													<a href="#">${menuMap[menuMap2.key].resourceName} <span class="fa arrow"></span></a>
													<ul class="nav nav-third-level">
														<c:forEach items="${menuTree[menuMap1.key][menuMap2.key]}" var="menuMap3"><!-- 显示第三级菜单-->
															<li><a class="J_menuItem" href="${fn:indexOf(menu.url, '://') eq -1 ? ctx : ''}${menuMap[menuMap3.key].url}">${menuMap[menuMap3.key].resourceName}</a></li>
														</c:forEach>
													</ul>
										</c:if>
									</ul>
							</c:forEach>
						</c:if>
					</li>
				</c:forEach>
			</ul>
		</div>
	</nav>
	<!--左侧导航结束-->
	<!--右侧部分开始-->
	<div id="page-wrapper" class="gray-bg dashbard-1">
		<div class="row content-tabs">
			<button class="roll-nav roll-menu J_tabLeft"><i class="fa fa-outdent"></i></button>
			<button class="roll-nav roll-left J_tabLeft"><i class="fa fa-backward"></i></button>
			<nav class="page-tabs J_menuTabs">
				<div class="page-tabs-content">
				</div>
			</nav>
			<button class="roll-nav roll-right J_tabRight"><i class="fa fa-forward"></i></button>
			<div class="btn-group roll-nav roll-right">
				<button class="dropdown J_tabClose" data-toggle="dropdown">操作<span class="caret"></span></button>
				<ul role="menu" class="dropdown-menu dropdown-menu-right">
					<li class="J_tabShowActive"><a>定位当前选项卡</a></li>
					<li class="J_tabRefreshActive"><a>刷新当前选项卡</a></li>
					<li class="divider"></li>
					<li class="J_tabCloseAll"><a>关闭全部选项卡</a></li>
					<li class="J_tabCloseOther"><a>关闭其他选项卡</a></li>
				</ul>
			</div>
		</div>


		<div class="row J_mainContent" id="content-main"  style="
			margin-left: 1px;
            margin-top: 10px;
            margin-right: 1px;
            margin-bottom: 40px;
            border: 1px solid #c9c9c9;
            border-top: 5px solid #d5dfe5;
            background-color: #fff;" >
			<iframe class="J_iframe" name="iframe0" width="100%" height="100%" src="${ctx}/main" frameborder="0" data-id="${ctx}/main" seamless></iframe>
		</div>


	</div>
	<!--右侧部分结束-->

</div>
<footer>
	<span class="f-l mar-l10">当前版本号1.6.0.11100</span>
	<p class="f-l mar-l30">地址：北京市安定门外大街丙88号 | 邮编：100011 | 公司总机：86-10-64280055</p>
	<span class="f-r mar-r10">当地时间：2016-06-23 16：55</span>
</footer>

<script src="${ctxStatic }/index/js/jquery.min.js?v=2.1.4"></script>
<script src="${ctxStatic }/index/js/bootstrap.min.js?v=3.3.6"></script>
<script src="${ctxStatic }/index/js/plugins/metisMenu/jquery.metisMenu.js"></script>
<script src="${ctxStatic }/index/js/plugins/slimscroll/jquery.slimscroll.min.js"></script>
<script src="${ctxStatic }/index/js/plugins/layer/layer.min.js"></script>
<script src="${ctxStatic }/index/js/hplus.min.js?v=4.1.0"></script>
<script src="${ctxStatic }/index/js/contabs.min.js" ></script>
<script src="${ctxStatic }/index/js/plugins/pace/pace.min.js"></script>
<script type="text/javascript">
	$(document).ready(function() {
		$("#side-menu li:first a:first").click();
		$("#side-menu li ul:first li:first a:first").click();
		$("#side-menu li ul:first li:first ul:first a:first").click();
	});

</script>

</body>
</html>
