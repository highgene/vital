(function($) {
	$.fn.extend({
		prompt:function(content){
			this.each(function(i, element){
				element = $(element);
				var prompt = $('<div class="prompt"><div><before></before><after></after></div></div>');
				var x = element.offset().top + $(this).outerHeight() + 4;
				var y = element.offset().left;
				prompt.css({top:x,left:y});
				var span = $("<span>");
				span.append(content);
				prompt.append(span);
				prompt.appendTo("body");
				$(document).one('click', function(){
					prompt.remove();
				});
			});
		}
	});
})(jQuery);

/*.prompt {
	max-width: 280px;
	background-color: #FFFFE0;
	border: 1px solid #F7CE39;
	color: #333;
	font-size: 12px;
	padding: 5px 10px;
	z-index: 10;
	position: absolute;
}
.prompt div {
	width: 12px;
	left: 15%;
	margin-left: -6px;
	height: 6px;
	text-indent: 0px;
	overflow: hidden;
	position: absolute;
	top: -6px;
}

.prompt div before {
	border-color: transparent transparent #F7CE39;
	border-style: dashed dashed solid;
	bottom: 0px;
	width: 0px;
	height: 0px;
	overflow: hidden;
	border-width: 6px;
	position: absolute;
}

.prompt div after {
	border-color: transparent transparent #FFFFE0;
	border-style: dashed dashed solid;
	bottom: -1px;
	width: 0px;
	height: 0px;
	overflow: hidden;
	border-width: 6px;
	position: absolute;
}*/