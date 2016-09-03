/*本文件主要存储一些需要自适应游览器宽度的元素的js片段*/
function Resize(){
	$(".column").width(($(".main-right").width()-12)/2);
	$(".column").height(($(".main-right").height()-73)/2);
	$(".column-list li a").each(function(index){
		var timeW = $(this).siblings("time").width();
		var issuerW = $(this).siblings(".issuer").width();	
		console.log(timeW);
		$(this).css("max-width",$(".column-list").width()-timeW-issuerW-60);
	});
}