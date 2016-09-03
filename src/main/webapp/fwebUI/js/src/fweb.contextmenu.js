/* 
 * fweb.contextmenu.js
 * author: zhangbaojian
 * Date: 2014-10-28
 */
(function($) {
	$.fn.contextMenu = function(options) {
		var defaults = {
			menuStyle : {
				listStyle : 'none',
				padding : '1px',
				margin : '0px',
				backgroundColor : '#fff',
				border : '1px solid #999',
				width : '105px'
			},
			itemStyle : {
				margin : '0px',
				color : '#000',
				display : 'block',
				cursor : 'default',
				padding : '3px',
				border : '1px solid #fff',
				backgroundColor : 'transparent'
			},
			itemHoverStyle : {
				border : '1px solid #0a246a',
				backgroundColor : '#b6bdd2'
			},
			eventPosX : 'pageX',
			eventPosY : 'pageY',
			shadow : true,
			onShowMenu : function(menu){},
			hover:false,
			items: [{ name: "", text: "", checkbox:false,click:function(e){}}],
			buttons:false//[{text:"保存",click:function(e){}},{text:"取消",click:function(e){}}]
		};

		var cur = $.extend({}, defaults, options);
		
		var menu = $("<div>");
		var ul = $('<ul>');
		$.each(cur.items,function(i,item){
			var li = $('<li>');
			if(item.checkbox){
				li.append('<input type="checkbox" name="'+item.name+'">');
				li.append("&nbsp;");
			}
			li.attr("name",item.name);
			li.append(item.text);
			li.bind("click",item.click);
			li.css(cur.itemStyle);
			
			if(cur.hover){
				li.hover(function() {
							$(this).css(cur.itemHoverStyle);
						}, function() {
							$(this).css(cur.itemStyle);
						});
			}
			ul.append(li);
		});
		ul.css(cur.menuStyle);
		menu.append(ul);
		
		if($.isArray(cur.buttons)){
			showButtons(menu,cur.buttons);
		}
		menu.hide();
		menu.css({position : 'absolute',zIndex : '10000'});
		menu.appendTo('body');
		menu.bind('click', function(e) {
			e.stopPropagation();
		});
		
		var shadow;
		if (cur.shadow) {
			shadow = $('<div></div>').css({
				backgroundColor : '#000',
				position : 'absolute',
				opacity : 0.2,
				zIndex : 499
			}).appendTo('body').hide();
		}
		$(this).bind('contextmenu', showMenu);
		return this;
		
		function showMenu(e){
			cur.onShowMenu(menu);
			var left = e[cur.eventPosX];
			var top = e[cur.eventPosY];
			if (left + menu.outerWidth() > $(document.body).width()) {
				left -= menu.outerWidth();
			}
			if (top + menu.outerHeight() > $(document.body).height()) {
				top -= menu.outerHeight();
			}
			menu.css({'left' : left,'top' : top}).show();
			if (cur.shadow){
				shadow.css({
					width : menu.width(),
					height : menu.height(),
					left : left + 2,
					top : top + 2
				}).show();
			}
			$(document).one('click', hide);
			return false;
		}
		
		function hide(){
			menu.hide();
			shadow.hide();
		}
		
		function showButtons(menu,buttons){
			var li = $('<li>');
			$.each(buttons,function(i,button){
				var span = $('<span class="btn btn-xs"><span class="bigger-110">'+button.text+'</span></span>');
				li.append(span);
				if(i != buttons.length-1){
					li.append("&nbsp;");
				}
				span.bind("click", function(){
					if($.isFunction(button.click)){
						button.click(menu,li);
					}
					hide();
				});
			});
			li.css(cur.itemStyle);
			menu.find("ul").append(li);
		}
	};
})(jQuery);
