/* 
 * fweb.contextmenu.js
 * author: zhangbaojian
 * Date: 2014-10-28
 */
(function($) {
	$.fn.dropdownmenu = function(options) {
		var defaults = {
			width:80,
			eventPosX : 'pageX',
			eventPosY : 'pageY',
			onShowMenu : function(menu){},
			items: [{ id: "", text: "", click:function(e){}}],
		};

		var cur = $.extend({}, defaults, options);
		
		var menu = $('<div class="widget-menu">');
		var ul = $('<ul class="dropdown-menu dropdown-light-blue dropdown-closer">');
		ul.css({"min-width":cur.width, zIndex : '10000'});
		$.each(cur.items,function(i,item){
			var li = $('<li>');
			var a = $('<a href="javascript:void(0)">');
			li.attr("id",item.id);
			a.append(item.text);
			a.bind("click", item.click);
			li.append(a);
			ul.append(li);
		});
		menu.append(ul);
		menu.appendTo('body');
		var me = $(this);
		$(this).addClass("dropdownmenu");
		$(this).bind('click', showMenu);
		return this;
		
		function showMenu(e){
			if(menu.hasClass("open")){
				return;
			}
			cur.onShowMenu(menu);
			var left = e[cur.eventPosX];
			var top = e[cur.eventPosY];
			if (left + cur.width > $(document.body).width()) {
				left -= cur.width;
			}
			if (top + ul.outerHeight() > $(document.body).height()) {
				top -= ul.outerHeight();
			}
			ul.css({'left' : left,'top' : top});
			$(document).bind('click', function(e){
				$(".widget-menu").removeClass("open");
				var target = $(e.target); 
				if(target.closest(".dropdownmenu").length > 0){ 
					menu.addClass("open");
				}
			});
		}
	};
})(jQuery);
