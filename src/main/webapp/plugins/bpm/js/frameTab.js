function CreateDiv(tabid, url, name,reload) {
	///如果当前tabid存在直接显示已经打开的tab
	tabid = tabid.replace(/\./g,"_");
	__saveIntoStack(tabid);
	if (document.getElementById("div_" + tabid) == null) {
		//创建iframe
		var box = document.createElement("iframe");
		var boxdiv = document.getElementById("div_pannel");
		box.id = "div_" + tabid;
		box.src = url;
		box.height = boxdiv.offsetHeight + 'px';
		box.frameBorder = 0;
		box.width = "100%";
		document.getElementById("div_pannel").appendChild(box);

		//遍历并清除开始存在的tab当前效果并隐藏其显示的div
		var tablist = document.getElementById("div_tab").getElementsByTagName('li');
		var pannellist = document.getElementById("div_pannel").getElementsByTagName('iframe');
		if (tablist.length > 0) {
			for (i = 0; i < tablist.length; i++) {
				tablist[i].className = "";
				pannellist[i].style.display = "none";
			}
		}

		//创建li菜单
		var tab = document.createElement("li");
		tab.className = "crent";
		tab.id = tabid;
		var litxt = "<span><a href=\"javascript:;\" onclick=\"javascript:CreateDiv('" + tabid + "','" + url + "','" + name + "'," + reload + ")\" title=" + name + " class=\"menua\">" + name + "</a><a class=\"menua_cloes\" data-action=\"close\" onclick=\"RemoveDiv('" + tabid + "')\" href=\"javascript:;\" title=\"关闭当前窗口\"><i class=\"ace-icon fa fa-times\"></i></a></span>";
		tab.innerHTML = litxt;

		document.getElementById("div_tab").appendChild(tab);
		
		tabElementArray.push(tabid);
		resetTabDiv("add");
	} else {
		var tablist = document.getElementById("div_tab").getElementsByTagName('li');
		var pannellist = document.getElementById("div_pannel").getElementsByTagName('iframe');
		for (i = 0; i < tablist.length; i++) {
			tablist[i].className = "";
			pannellist[i].style.display = "none"
		}
		$("#div_tab").find("#"+tabid).addClass('crent');
		var iframe = document.getElementById("div_" + tabid);
		if(reload){
			iframe.src = url;
		}
		iframe.style.display = 'block';
		
		resetTabDiv("reShow");
	}
	var navlist = $(".nav-list");
	navlist.find("li").removeClass();
	var menu = navlist.find("#" + tabid)
	if(menu.find(".submenu").length > 0){
		menu.addClass("open hsub");
	}
	if(menu.parent().hasClass("submenu")){
		menu.parent().parent().addClass("active open hsub");
	}
	menu.addClass("active");
}
function RemoveDiv(tabid,erpRefresh) {
	var parentWindowTabId = __prepareRemoveDiv(tabid);
	__removeFromStack(tabid);
	var nextShowTabId = parentWindowTabId || windowTabStack[windowTabStack.length-1];
	var ob = $("#div_tab").find("#"+tabid);
	ob.remove();
	var obdiv = document.getElementById("div_" + tabid);
	obdiv.parentNode.removeChild(obdiv);
	
	removeFromTabArray(tabid);
	
	//显示下一个div
	var tablist = document.getElementById("div_tab").getElementsByTagName('li');
	var pannellist = document.getElementById("div_pannel").getElementsByTagName('iframe');
	if (tablist.length > 0) {
		if(nextShowTabId){
			$("#div_tab").find("#"+nextShowTabId+">span>a:first").trigger("click");
			try{
			    if(erpRefresh){
				  var iframeOld = document.getElementById("div_" + nextShowTabId);
				  iframeOld.contentWindow.erpRefresh();
			    }
			}catch(e){}
		}else{
			tablist[tablist.length - 1].className = 'crent';
			pannellist[tablist.length - 1].style.display = 'block';
		}
	}
}

windowRelationMap = {};
function CreateSubDiv(tabid, url, name, reload){
	tabid = tabid.replace(/\./g,"_");
	var parentWindowTabId = $(".crent").get(0).id;
	var parentWindowTabIds = windowRelationMap[tabid];
	if(parentWindowTabIds && parentWindowTabIds.length){
		var index = -1;
		if((index=$.inArray(parentWindowTabId, parentWindowTabIds))>-1){
			parentWindowTabIds.splice(index, 1);
		}
		parentWindowTabIds.push(parentWindowTabId);
	}else{
		windowRelationMap[tabid] = [parentWindowTabId];
	}
	CreateDiv(tabid, url, name, reload);
}

function __prepareRemoveDiv(tabid){
	var parentWindowTabIds = windowRelationMap[tabid];
	var parentWindowTabId;
	if(parentWindowTabIds && parentWindowTabIds.length){
		for(var i in parentWindowTabIds){
			if($("#"+parentWindowTabIds[i]).length){
				$("#div_"+parentWindowTabIds[i]).get(0).src = $("#div_"+parentWindowTabIds[i]).get(0).src;
				parentWindowTabId = parentWindowTabIds[i];
			}else{
				parentWindowTabIds.splice(i, 1);
			}
		}
	}
	return parentWindowTabId;
}

windowTabStack=[];
function __saveIntoStack(tabid){
	__removeFromStack(tabid);
	windowTabStack.push(tabid);
}
function __removeFromStack(tabid){
	var index = -1;
	if((index=$.inArray(tabid, windowTabStack))>-1){
		windowTabStack.splice(index, 1);
	}
}

/**标签翻页***/
tabElementArray = [];
tabArrayCursor = -1;
//添加标签与点击指定标签(包括点击左侧标签栏，点击顶部标签(包括移除某一标签后，显示指定的标签))时，重新设置标签的显示与隐藏
function resetTabDiv(resetType){
	var windowTabSumWidth = $("#div_tab").width();
	var suttleWidthOfBreadcrumbs = $("#breadcrumbs").width()-/*$("#v_arrow_lr").width()*/41-15;//当翻页按钮隐藏时不能取到正确的宽度，因此使用固定值
	switch(resetType){
		case "add" : 
			if(windowTabSumWidth >= suttleWidthOfBreadcrumbs){
				var tempArr_add = tabElementArray.concat();
				showTabs(tempArr_add.reverse(), -1, true);
			}
			break;
		case "reShow" :
			var currentTab = $(".crent");
			//if(windowTabSumWidth <= suttleWidthOfBreadcrumbs) return;
			if(currentTab.css("display")=="none"){//通过左侧导航栏点击隐藏的标签
				var currentTabId = $(".crent").get(0).id;
				var index = $.inArray(currentTabId, tabElementArray);
				if(index<=tabArrayCursor){//点击左侧隐藏的标签
					tabArrayCursor = index - 1;
					showTabs(tabElementArray, tabArrayCursor);
				}else{//点击右侧隐藏的标签
					var tempArr = tabElementArray.concat();
					showTabs(tempArr.reverse(), tempArr.length-index-2, true);
				}
			}else{//点击显示的标签
				showTabs(tabElementArray, tabArrayCursor);
			}
			break;
		case "resize" :
			function resetTabDiv_resize(width, count){
				var BreadcrumbsWidth = $("#breadcrumbs").width();
				if(width != BreadcrumbsWidth){
					showTabs(tabElementArray, tabArrayCursor);
				}else{
					if(count < 15){
						setTimeout(function(){ resetTabDiv_resize(BreadcrumbsWidth, ++count)},10);
					}else{
						showTabs(tabElementArray, tabArrayCursor);
					}
				}
			}
			var BreadcrumbsWidth = $("#breadcrumbs").width();
			resetTabDiv_resize(BreadcrumbsWidth, 0);
			break;
	}
}
function removeFromTabArray(tabid){//从标签数组中移除标签
	var index = $.inArray(tabid, tabElementArray);
	if(index>-1){
		tabElementArray.splice(index, 1);
	}
	if(index<=tabArrayCursor){//可能不会用到
		tabArrayCursor--;
	}
}
function showTabs(tabArray, cursor, isReverse){//显示标签，isReverse为true时表示标签从数组的后端开始遍历显示
	var len = tabArray.length - 1;//当倒序显示时，计算游标的位置
	var tabSumWidth = 0;
	var suttleWidthOfBreadcrumbs = $("#breadcrumbs").width()-/*$("#v_arrow_lr").width()*/41-15;
	var isNotEnough = false;//当关闭显示的标签，使得标签栏未满并且有隐藏的标签时，isNotEnough为true，此时显示隐藏的标签
	for(var i=0; i <= tabArray.length + cursor; i++){
		var node;
		if(i < tabArray.length){
			node = $("#div_tab").find("#"+tabArray[i]);
		}else{//当有多余的位置时，显示隐藏的标签
			isNotEnough = true;
			node = $("#div_tab").find("#"+tabArray[tabArrayCursor]);
		}
		if(i<=cursor){
			node.css("display", "none");
			--len;
			continue;
		}
		tabSumWidth += (node.width() + 10);
		if(tabSumWidth <= suttleWidthOfBreadcrumbs){
			node.css("display", "block");
			if(isReverse){
				tabArrayCursor = --len;
			}
			if(isNotEnough){
				tabArrayCursor = tabArrayCursor-1;
			}
		}else{
			node.css("display", "none");
		}
	}
	showOrHiddenPagination();
}
function moveForward(){//向前移动
	if($("#div_tab").find("#"+tabElementArray[tabElementArray.length-1]).css("display")=="none"){
		showTabs(tabElementArray, ++tabArrayCursor);
	}
}
function moveBackward(){//向后移动
	if(tabArrayCursor>-1){
		showTabs(tabElementArray, --tabArrayCursor);
	}
}
function showOrHiddenPagination(){//显示或隐藏移动标签的按钮
	var firstTabState = $("#div_tab").find("#"+tabElementArray[0]).css("display");
	var lastTabState = $("#div_tab").find("#"+tabElementArray[tabElementArray.length-1]).css("display");
	if(firstTabState == "none" || lastTabState == "none"){
		$("#v_arrow_lr").css("display", "block");
	}else{
		$("#v_arrow_lr").css("display", "none");
	}
	if($("#v_arrow_lr").css("display")=="block"){//标签移动时，更新向前向后按钮是否可点击
		if(firstTabState == "block"){
			$("#v_arrow_l").addClass("v_disabled");
		}else{
			$("#v_arrow_l").removeClass("v_disabled");
		}
		if(lastTabState == "block"){
			$("#v_arrow_r").addClass("v_disabled");
		}else{
			$("#v_arrow_r").removeClass("v_disabled");
		}
	}
}
window.onresize=function(){
	showTabs(tabElementArray, tabArrayCursor);
}