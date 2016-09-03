/* 
 * 下拉选择控件
 * fweb.select.js
 * author: zhangbaojian
 * Date: 2014-10-28
 */
(function($) {
	$.fn.extend({
		select : function(options) {
			var me = this;
			var id = me.attr("id");
			if(typeof options == "string"){
				switch (options) {
				case "getSelected":
					return getSelected();
				default:
					break;
				}
				return me;
			}
			var dafaultOptions = {
				url : "",
				data : {},
				multiple : false,
				isWrite : false,
				width : "100%",
				placeholder : "",
				defaultVal : [],
				isCancel:true,
				param : "",
				type : "get",
				option:{value:"id", text:"userName"},
				addEmptyOption: true,
				onchange : false,//false/function(value, text) {},
				loadSuccess : function(data) {},
				loadError : function(XMLHttpRequest, textStatus, errorThrown) {}
			};
			var newOptions = $.extend({}, dafaultOptions, options);
			if(newOptions.url != ""){
				$.ajax({
					url : newOptions.url,
					type : newOptions.type,
					cache : true,
					contentType : 'application/json;charset=UTF-8',
					success : function(data) {
						newOptions.data = data;
						drawSelect();
						newOptions.loadSuccess(data);
					},
					error : newOptions.loadError
				});
			} else {
				drawSelect();
				newOptions.loadSuccess(newOptions.data);
			}

			function drawSelect() {
				me.addClass("chosen-select form-control");
				if(newOptions.multiple){
					me.attr("multiple", newOptions.multiple);
				}
				me.attr("data-placeholder", newOptions.placeholder);	
				if(newOptions.addEmptyOption){
					me.append('<option value="" ></option>');
				}
				me.width(newOptions.width);
				$.each(newOptions.data, function(i, row) {
					var option = $('<option value="'+ row[newOptions.option.value] +'">' + row[newOptions.option.text] + "</option>");
					if(!$.isEmptyObject(newOptions.defaultVal)){
						$.each(newOptions.defaultVal, function(i, defaultVal_el) {
							if (row[newOptions.option.value] == defaultVal_el) {
								option.attr("selected", true);
							}
						});
					}
					me.append(option);
				});
				addEvent();
			}
			
			function addEvent(){
				me.chosen({
					allow_single_deselect : newOptions.isCancel,
					no_results_text : "没有找到!"
				});
				$(window).off('resize.chosen').on('resize.chosen', function() {
					me.next().width(newOptions.width);
				}).trigger('resize.chosen');
				if(newOptions.isWrite){
					var div = me.next();
					var writeValue;
					var input = div.find("input[autocomplete]");
					if(newOptions.multiple){
						writeValue = [];
						input.focusout(function(){
							var chosenResults = div.find("ul.chosen-results");
							var noResults = div.find(".no-results");
							if(noResults.length > 0){
								var content = noResults.find("span").html();
								var chosenSingle = div.find("ul.chosen-choices");
								var li = $('<li class="search-choice"><span>'+content+'</span></li>');
								var del = $('<a class="search-choice-close" data-option-array-index="-1"></a>')
								del.bind("click", function(){
									li.remove();
									writeValue.splice($.inArray(content,writeValue),1);
								});
								input.removeClass("default");
								li.append(del);
								chosenSingle.prepend(li);
								writeValue.push(content);
								me.data(id, writeValue)
								if($.isFunction(newOptions.onchange)){
									setChangeValue();
								}
							}
						});
					} else {
						input.focusout(function(){
							var noResults = div.find(".no-results");
							if(noResults.length > 0){
								var content = noResults.find("span").html();
								var chosenSingle = div.find(".chosen-single");
								chosenSingle.html('<span>'+content+'</span><abbr class="search-choice-close"></abbr>');
								chosenSingle.removeClass("chosen-default");
								chosenSingle.addClass("chosen-single-with-deselect");
								writeValue = content;
								me.data(id, writeValue)
								if($.isFunction(newOptions.onchange)){
									setChangeValue();
								}
							}
						});
					}
				}
				if($.isFunction(newOptions.onchange)){
					me.bind("change", function(){
						setChangeValue();
					});
				}
			}
			function setChangeValue(){
				var value = me.val();
				var options = me.find("option:selected");
				var text;
				if(options.length > 1){
					text = [];
					$.each(options, function(i, option){
						text.push($(option).text());
					});
				} else {
					text = options.text();
				}
				newOptions.onchange(value, text, me.data(id));
			}
			
			function getSelected(){
				var optionValue = {};
				var value = me.val();
				var options = me.find("option:selected");
				var text;
				if(options.length > 1){
					text = [];
					$.each(options, function(i, option){
						text.push($(option).text());
					});
				} else {
					text = options.text();
				}
				optionValue.value = value;
				optionValue.text = text;
				optionValue.writeValue = me.data(id);
				return optionValue;
			}
		}
	});
})(jQuery);