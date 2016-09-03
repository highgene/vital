/*本文件主要存储每个页面的共用js片段*/

/*左侧菜单点击效果*/
$(".menu-list > li").click(function(){
	$(this).siblings("li").removeClass("unfold");
	if($(this).hasClass("unfold")){
		$(this).removeClass("unfold");
	}else{
		$(this).addClass("unfold");
	};
});
$(".secondMenu > li").click(function(){
	$(this).addClass("unfold").siblings("li").removeClass("unfold");
	return false;
});
$(".thirdMenu > li").click(function(){
	$(this).addClass("click").siblings("li").removeClass("click");
	return false;
});

//菜单展开收起js
$(".toggleBtn").click(function(){
	$("aside").toggleClass("hideMenu");
	$(this).toggleClass("open");
	Resize();
})

/*tag标签片段*/
//tags元素上禁止鼠标右键
$(".tags").bind("contextmenu",function(){
	return false;
});
//右键单击tag标签显示关闭选项
$(".tag-list li").mousedown(function(e){
	if(e.which == 3){
		console.log(e.pageX,e.pageY);
		$(".closeOption").fadeIn(200);
		$(".closeOption").css({"top":e.pageY,"left":e.pageX});
	};
});
$(".closeOption-list li").mouseover(function(){
	$(this).addClass("hover").siblings("li").removeClass("hover");
});
//单击页面任何位置隐藏tag关闭选项
$(document).mousedown(function(e){
	if(e.which == 1){
		$(".closeOption").hide();
	}
});

