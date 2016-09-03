(function($) {
	/**
	 * 验证提示信息的显示
	 */
	$.testRemind = (function() {
		var fnMouseDown = function(e) {
			if (!e || !e.target) return;
			$(".valid_div").remove();
			$(document).unbind("mousedown", fnMouseDown);
		}, fnKeyDown = function(e) {
			if (!e || !e.target) return;
			if (e.target.tagName.toLowerCase() !== "body") {
				$(".valid_div").remove();
				$(document).unbind("keydown", fnKeyDown);
			}
		},fnScroll = function(e) {
			if (!e || !e.target) return;
			$(".valid_div").remove();
			$(window).unbind("scroll", fnScroll);
		}, funResize = function() {
			$(".valid_div").remove();
			$(window).unbind("resize", funResize);
		};
		return {
			bind: function() {
				$(document).bind({
					mousedown: 	fnMouseDown,
					keydown: fnKeyDown
				});
				$(window).bind("scroll", fnScroll);
				$(window).bind("resize", funResize);
			}
		};		
	})();
	
	$.fn.extend({
		/**
		 * 验证提示信息的显示
		 */
		hideRemind : function(){
			var validDivId = this[0].id || this[0].name;
			$("#valid_" + validDivId).remove();
		},
		isVisible: function() {
			return $(this).attr("type") !== "hidden" && $(this).css("display") !== "none" && $(this).css("visibility") !== "hidden";
		},
		showRemind : function(content, options){
			if ($(this).isVisible()){
				$(this).testRemind(content, options);
			}else{
				// 元素隐藏，寻找关联提示元素
				var selector = $(this).attr("data-target");
				var target = $("#" + selector);
				if (target.size() == 0) {
					target = $("." + selector);
				}
				if (target.size()) {
					if (target.offset().top < $(window).scrollTop()) {
						$(window).scrollTop(target.offset().top - 50);
					}
					target.testRemind(content, options);
				} else {
					if (content) 
						$.alert("error", content);	
				}
			}
		},
		testRemind: function(content, options) {
			var validDivId = this[0].id || this[0].name;
			var requireValidateBlock;
			var requiredBlock;
			var validDivAppendTo = (requireValidateBlock=$(this).parents(".require-validate-block")).length?
					requireValidateBlock:(requiredBlock = $(this).parents(".required-field-block")).length?
					requiredBlock : $(this).parent();
			var isGridBlock = /col-[a-z]{2}-[0-9]{1,2}/.test(validDivAppendTo.attr("class"));
			var validDiv = validDivAppendTo.find("#valid_"+ validDivId);
			if(validDiv.length && options == undefined){
				$(validDiv[0]).find("#content").text(content);
			}else{
				var defaults = {
					size: 6,	// 三角的尺寸
					align: "left",	//三角的位置，默认居中
					relativeLeft:0,
					relativeTop:0,
					css: {
						maxWidth: 280,
						backgroundColor: "#FFFFE0",
						borderColor: "#F7CE39",
						color: "#333",
						fontSize: "12px",
						padding: "5px 10px",
						zIndex: 10
					}
				};
				
				options = options || {};
				options.css = $.extend({}, defaults.css, options.css);
				
				var params = $.extend({}, defaults, options || {});
				
				// 如果元素不可见，不处理
				if (!content) return;
				
				var objAlign = {
					"center": "50%",
					"left": "15%",
					"right": "85%"	
				}, align = objAlign[params.align] || "50%";
				
				params.css.position = "absolute";
				params.css.top = "-99px";
				params.css.border = "1px solid " + params.css.borderColor;
				
				this.remind = $('<div id="valid_'+ validDivId +'" class="valid_div"><span id=\'content\'>'+ content +'</span></div>').css(params.css);
				validDivAppendTo.append(this.remind);
				
				// IE6 max-width的处理
				var maxWidth;
				if (!window.XMLHttpRequest && (maxWidth = parseInt(params.css.maxWidth)) && this.remind.width() > maxWidth) {
					 this.remind.width(maxWidth);	
				}
				
				// 当前元素的位置，提示框的方向
				var offset = $(this).offset();
				if (!offset) return $(this);
				var direction = "bottom";
				//var remindTop = offset.top + $(this).outerHeight() + params.size;
				var remindTop = (isGridBlock?0:offset.top)+$(this).outerHeight() + params.size;
				
				// 创建三角
				var fnCreateCorner = function(beforeOrAfter) {
					// CSS名称值与变量，主要用来mini后节约文件大小
					var transparent = "transparent", dashed = "dashed", solid = "solid";
					
					// CSS样式对象们
					var cssWithDirection = {}, cssWithoutDirection = {
						// 与方向无关的CSS
						//left: align,
						width: 0,
						height: 0,
						overflow: "hidden",
						//marginLeft: (-1 * params.size) + "px",
						borderWidth: params.size + "px",
						position: "absolute"
					}, cssFinalUsed = {};
					
					// before颜色为边框色
					// after为背景色
					// 方向由direction决定
					if (beforeOrAfter === "before") {
						cssWithDirection = {
							"top": {
								borderColor: [params.css.borderColor, transparent, transparent, transparent].join(" "),
								borderStyle: [solid, dashed, dashed, dashed].join(" "),
								top: 0
							},
							"bottom": {
								borderColor: [transparent, transparent, params.css.borderColor, ""].join(" "),
								borderStyle: [dashed, dashed, solid, dashed].join(" "),
								bottom: 0
							}	
						};	
					} else if (beforeOrAfter === "after") {
						cssWithDirection = {
							"top": {
								borderColor: params.css.backgroundColor + ["", transparent, transparent, transparent].join(" "),
								borderStyle: [solid, dashed, dashed, dashed].join(" "),
								top: -1
							},
							"bottom": {
								borderColor: [transparent, transparent, params.css.backgroundColor, ""].join(" "),
								borderStyle: [dashed, dashed, solid, dashed].join(" "),
								bottom: -1
							}	
						};	
					} else {
						cssWithDirection = null;
						cssWithoutDirection = null;
						cssFinalUsed = null;
						return null;	
					}
					
					cssFinalUsed = $.extend({}, cssWithDirection[direction], cssWithoutDirection);
					
					return $('<'+ beforeOrAfter +'></'+ beforeOrAfter +'>').css(cssFinalUsed);
				};
				
				// 限高
				var cssOuterLimit = {
					width: 2 * params.size,
					left: align,
					marginLeft: (-1 * params.size) + "px",
					height: params.size,
					textIndent: 0,
					overflow: "hidden",
					position: "absolute"
				};
				if (direction == "top") {
					cssOuterLimit["bottom"] = -1 * params.size;
				} else {
					cssOuterLimit["top"] = -1 * params.size;
				}
				
				this.remind.css({
					//left: offset.left,
					left: (isGridBlock?15:offset.left - params.relativeLeft),
					top: remindTop - params.relativeTop, 
					// marginLeft: ($(this).outerWidth() - this.remind.outerWidth()) * 0.5 + /*因为三角位置造成的偏移*/ this.remind.outerWidth() * (50 - parseInt(align)) / 100		
					// 等于下面这个：
					//marginLeft: $(this).outerWidth() * 0.5 - this.remind.outerWidth() * parseInt(align) / 100
				}).prepend($('<div></div>').css(cssOuterLimit).append(fnCreateCorner("before")).append(fnCreateCorner("after")));
				
				$.testRemind.bind();
				return $(this);
			}
		}
	});
})(jQuery);