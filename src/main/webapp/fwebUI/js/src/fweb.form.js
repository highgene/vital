/* 
 * fweb.form.js
 * author: zhangbaojian
 * Date: 2014-10-28
 */
(function($) {
	$.fn.extend({
		dataForm: function(options){
			var me = this;
			var defaultOptions = {
					url:"",
					type:"get",
					param:"",
					pageName:"eidt",//eidt/detail
					defaultEmptyValToDetail:"无",
					data:{},
					loadSuccess:function(data){}
			}
			var newOptions = $.extend({},defaultOptions,options);
			if(newOptions.url != ""){
				$.ajax({
					url : newOptions.url,
					type : newOptions.type,
					param: newOptions.param,
					contentType : 'application/json;charset=UTF-8',
					success : function(data) {
						newOptions.data = data;
						initFormData(newOptions.data);
						newOptions.loadSuccess(data);
					}
				});
			} else {
				initFormData(newOptions.data);
				newOptions.loadSuccess(data);
			}
			
			function initFormData(data){
				if(newOptions.pageName == "eidt"){
					var inputs = me.find("input[name]");
					$.each(inputs,function(i, input){
						input = $(input);
						var name = input.attr("name");
						if(input.is(":radio") || input.is(":checkbox")){
							if(input.val() == data[name]){
								input.attr("checked", "checked");
							}
						} else {
							input.val(data[name]);
						}
					});
					var selects = me.find("select[name]");
					$.each(selects,function(i, select){
						select = $(select);
						var name = select.attr("name");
						select.find("option[value='"+data[name]+"']").attr("selected", "selected");
					});
				} else if(newOptions.pageName == "detail"){
					var labels = me.find("strong[id]");
					$.each(labels,function(i, label){
						label = $(label);
						var id = label.attr("id");
						if(data[id] == null || data[id] == ""){
							label.append(newOptions.defaultEmptyValToDetail);
						} else {
							label.append(data[id]);
						}
					});
				}
			}
		}
	});
})(jQuery);