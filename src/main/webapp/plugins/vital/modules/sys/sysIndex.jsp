<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/plugins/vital/views/include/taglib.jsp"%>
<!DOCTYPE html>
<html>

<head>
	<meta charset="UTF-8">
	<meta http-equiv="X-UA-Compatible" content="IE=Edge,chrome=1" />
	<meta name="viewport" content="width=device-width,initial-scale=1,user-scalable=no" />
	<title>综合管理信息系统</title>
	<script type="text/javascript">
		if(this != top) {
			top.location.replace(window.location)
		}
	</script>
	<!--引入css-->
	<link rel="stylesheet" type="text/css" href="${ctxStatic }/index/css/base.css" />
	<link rel="stylesheet" type="text/css" href="${ctxStatic }/index/css/index.css" />

	<!-- bootstrap & fontawesome -->
	<link rel="stylesheet" href="${ctxStatic }/index/awesome/font-awesome.min.css" />
	<!-- ace styles -->
	<link rel="stylesheet" href="${ctxStatic }/index/ace/css/ace.min.css" id="main-ace-style" />
	<!--[if lte IE 9]>
	<link rel="stylesheet" href="${ctxStatic }/index/ace/css/ace-part2.min.css"  />
	<![endif]-->
	<link rel="stylesheet" href="${ctxStatic }/index/ace/css/ace-skins.min.css" />
	<link rel="stylesheet" href="${ctxStatic }/index/ace/css/ace-rtl.min.css" />
	<!--[if lte IE 9]>
	<link rel="stylesheet" href="${ctxStatic }/index/ace/css/ace-ie.min.css"  />
	<![endif]-->
	<!-- ace settings handler -->
	<script src="${ctxStatic }/index/ace/js/ace-extra.min.js" type="text/javascript" charset="utf-8"></script>
	<!-- HTML5shiv and Respond.js for IE8 to support HTML5 elements and media queries -->
	<!--[if lte IE 8]>
	<script src="${ctxStatic }/index/js/html5shiv.min.js" ></script>
	<script src="${ctxStatic }/index/js/respond.min.js" ></script>
	<![endif]-->

	<!--引入js-->
	<script src="${ctxStatic }/index/js/jquery.js" type="text/javascript" charset="utf-8"></script>
	<script src="${ctxStatic }/index/js/frameTab.js" type="text/javascript" charset="utf-8"></script>

</head>

<body class="no-skin">
<div class="container">
	<header>
		<h1 class="logo f-l"></h1>
		<div class="itemName"></div>
		<div class="head-right f-r">
			<div class="weather f-r mar-t5">
				<i class="icon f-l"><img src="${ctxStatic }/index/images/weatherIcon.png"/></i>
				<span class="f-l">多云</span>
				<span class="f-l">20℃/30℃</span>
			</div>
			<div class=" clear mar-t10 f-r user">
				<div class="f-l mar-r10 projectName">
					<h3 title="项目综合管理系统">项目综合管理系统</h3>
				</div>
				<h2 class="f-l">${fns:getUser().realName}，您好，欢迎您登录</h2>
				<div class="inform p-r mar-l20 f-l">
					<i class="icon f-l"></i>
					<h3 class="f-l">12</h3>
				</div>
				<div class="exit mar-l20 mar-r10 f-l">
					<a href="${ctx}/logout" title="注销">
						<i class="icon f-l"></i>
						<h3 class="f-l">注销</h3>
					</a>
				</div>
			</div>
		</div>

	</header>
	<div class="main">
		<div class="sidebar responsive sidebar-fixed sidebar-scroll" id="sidebar">
			<div id="sidebar-collapse" class="sidebar-toggle sidebar-collapse" style="z-index: 1;">
				<i onclick="resetTabDiv('resize')" data-icon2="ace-icon fa fa-angle-double-right" data-icon1="ace-icon fa fa-angle-double-left" class="ace-icon fa fa-angle-double-left"></i>
			</div>
			<script type="text/javascript">
				try {
					ace.settings.check('sidebar', 'fixed')
				} catch(e) {}
			</script>



			<div style="position: relative;">
				<div class="nav-wrap">
					<div style="position: relative; top: 0px; transition-property: top; transition-duration: 0.2s;">
						<ul class="nav nav-list" style="top: 0px;">

							<c:forEach items="${menuTree}" var="menuMap1" varStatus="stat"><!-- 显示第一级菜单-->
									<c:if test="${menuTree[menuMap1.key]==null}"> <!--如果没有第二级菜单-->
											<li id="${menuMap[menuMap1.key].id}">
												<a href="#" class="dropdown-toggle" onclick="CreateDiv('${menuMap[menuMap1.key].id}','${ctx}${menuMap[menuMap1.key].url}','${menuMap[menuMap1.key].resourceName}')">
													<i class="menu-icon fa fa-caret-right"></i>${menuMap[menuMap1.key].resourceName}
												</a>
											</li>
									</c:if>
									<c:if test="${menuTree[menuMap1.key]!=null}"> <!--如果有第二级菜单-->
										<li >
												<c:if test="${menuMap[menuMap1.key].url !=''}">
													<a href="#" class="dropdown-toggle" onclick="CreateDiv('${menuMap[menuMap1.key].id}','${ctx}${menuMap[menuMap1.key].url}','${menuMap[menuMap1.key].resourceName}')">
												</c:if>
												<c:if test="${menuMap[menuMap1.key].url ==''}">
													<a href="#" class="dropdown-toggle">
												</c:if>
												<i class="menu-icon gzpt"></i>
												<span class="menu-text">${menuMap[menuMap1.key].resourceName}</span>
												<b class="arrow fa fa-angle-down"></b>
											</a>
											<b class="arrow"></b>
											<ul class="submenu">
													<c:forEach items="${menuTree[menuMap1.key]}" var="menuMap2"><!-- 显示第二级菜单-->
															<c:if test="${menuTree[menuMap1.key][menuMap2.key]==null}"><!--如果没有第三级菜单-->
																	<li id="${menuMap[menuMap2.key].id}">
																		<a href="#" class="dropdown-toggle" onclick="CreateDiv('${menuMap[menuMap2.key].id}','${ctx}${menuMap[menuMap2.key].url}','${menuMap[menuMap2.key].resourceName}')">
																			<i class="menu-icon fa fa-caret-right"></i>${menuMap[menuMap2.key].resourceName}
																		</a>
																	</li>
															</c:if>
															<c:if test="${menuTree[menuMap1.key][menuMap2.key]!=null}"> <!--如果有第三级菜单-->
																	<li class="">
																			<c:if test="${menuMap[menuMap2.key].url !=''}">
																					<a href="#" class="dropdown-toggle" onclick="CreateDiv('${menuMap[menuMap2.key].id}','${ctx}${menuMap[menuMap2.key].url}','${menuMap[menuMap2.key].resourceName}')">
																			</c:if>
																			<c:if test="${menuMap[menuMap2.key].url ==''}">
																					<a href="#" class="dropdown-toggle">
																			</c:if>
																				<i class="menu-icon fa fa-caret-right"></i>${menuMap[menuMap2.key].resourceName}
																				<b class="arrow fa fa-angle-down"></b>
																			</a>
																			<b class="arrow"></b>
																			<ul class="submenu">
																					<c:forEach items="${menuTree[menuMap1.key][menuMap2.key]}" var="menuMap3"><!-- 显示第三级菜单-->
																							<li id="xmxw">
																								<a href="#" class="dropdown-toggle" onclick="CreateDiv('${menuMap[menuMap3.key].id}','${ctx}${menuMap[menuMap3.key].url}','${menuMap[menuMap3.key].resourceName}')">
																									<i class="menu-icon fa fa-caret-right"></i>${menuMap[menuMap3.key].resourceName}
																								</a>
																							</li>
																					</c:forEach>
																			</ul>
																	</li>
															</c:if>
												</c:forEach>
											</ul>
										</li>
										</c:if>
							</c:forEach>
						</ul>
					</div>
				</div>
				<div class="ace-scroll nav-scroll">
					<div class="scroll-track" style="display: none;">
						<div class="scroll-bar" style="transition-property: top; transition-duration: 0.13s; top: 0px;"></div>
					</div>
					<div class="scroll-content" style="">
						<div></div>
					</div>
				</div>
			</div>

			<script type="text/javascript">
				try {
					ace.settings.check('sidebar', 'collapsed')
				} catch(e) {}
			</script>
		</div>
		<div class="main-right main-content">
			<div class="breadcrumbs" id="breadcrumbs">
				<script type="text/javascript">
					try {
						ace.settings.check('breadcrumbs', 'fixed')
					} catch(e) {}
				</script>
				<ul id="div_tab">
					<li class="crent" id="${firstMenu.id}" style="display: block;">
								<span>
									<a href="javascript:;" onclick="javascript:CreateDiv('${firstMenu.id}','${ctx}${firstMenu.url}','${firstMenu.resourceName}',true)" title="${firstMenu.resourceName}" class="menua">${firstMenu.resourceName}</a>
									<a class="menua_cloes" data-action="close" onclick="RemoveDiv('${firstMenu.id}')" href="javascript:;" title="关闭当前窗口"><i class="ace-icon fa fa-times-circle"></i></a>
								</span>
					</li>

				</ul>
				<!-- /.breadcrumb -->
				<div class="v_arrow_lr" id="v_arrow_lr" style="display:none">
					<a href="javascript:;" id="v_arrow_l" onclick="moveBackward()"><i class="ace-icon fa fa-arrow-circle-o-left bigger-140"></i></a>
					<a href="javascript:;" id="v_arrow_r" onclick="moveForward()" class="v_disabled"><i class="ace-icon fa fa-arrow-circle-o-right bigger-140"></i></a>
				</div>
			</div>

			<div class="page-content-area">
				<div class="row" id="div_pannel">
					<iframe id="div_${firstMenu.id}" src="${ctx}${firstMenu.url}" height="90%" frameborder="0" width="100%"></iframe>
				</div>
			</div>

			<footer>
				<span class="f-l mar-l10">当前版本号1.6.0.11100</span>
				<p class="f-l mar-l30">地址：北京市安定门外大街丙88号 | 邮编：100011 | 公司总机：86-10-64280055</p>
				<span class="f-r mar-r10">当地时间：2016-06-23 16：55</span>
			</footer>

		</div>
	</div>

</div>
<script src="${ctxStatic }/index/js/common.js" type="text/javascript" charset="utf-8"></script>
<script src="${ctxStatic }/index/bootstrap/js/bootstrap.min.js" type="text/javascript" charset="utf-8"></script>
<script src="${ctxStatic }/index/ace/js/ace-elements.min.js" type="text/javascript" charset="utf-8"></script>
<script src="${ctxStatic }/index/ace/js/ace.min.js" type="text/javascript" charset="utf-8"></script>
<script type="text/javascript">
	$(function() {
		$(window).resize(function() {
			mainH();
			Resize();
		});
		window.onresize = Resize;

	})
	function mainH() {
		var winH = $(window).height();
		$("#div_pannel,#div_pannel iframe").css({
			height: winH - $("header").height() - $("#breadcrumbs").height()-$("footer").height()-25
		});
	}
	mainH();

</script>
</body>

</html>