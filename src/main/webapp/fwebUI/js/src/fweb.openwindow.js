/* 
 * fweb.openwindow.js
 * author: zhangbaojian
 * Date: 2014-10-28
 */
(function($) {
	$.extend({
		openWindow: function(options){
			var defaultOptions = {
			    id:"fwebModal",
			    top:"8%",
				width:900,  
			    height:400,
			    title:"",
			    url:"#",
			    content:"",
			    destroy : false,
			    showDefaultButton:true,
			    confirm : function(){},
			    onAfterHidden:false,
			    load:false
			};
			var nowOptions = $.extend({},defaultOptions,options);
			var body = $("body");
			var model = body.find("#"+nowOptions.id);
			if(model.length == 0){
				model = $("<div class=\"modal fade bs-example-modal-lg\" id=\""+ nowOptions.id +"\" tabindex=\"-1\" role=\"dialog\" aria-labelledby=\"myModalLabel\" aria-hidden=\"true\"  style=\"top:"+nowOptions.top+";\">"
						  +"<div class=\"modal-dialog modal-lg\" style=\"width: "+nowOptions.width+"px;\">"
						    +"<div class=\"modal-content\" >"
						      +"<div class=\"modal-header\">"
						       +"<button type=\"button\" class=\"close\" data-dismiss=\"modal\"><span aria-hidden=\"true\">&times;</span><span class=\"sr-only\">Close</span></button>"
						        +"<h4 class=\"modal-title\" id=\"myModalLabel\"></h4>"
						      +"</div>"
						      +"<div class=\"modal-body v_modal_body\" style=\"height: "+nowOptions.height+"px;text-align: center;\">"
						      +"</div>"
						    +"</div>"
						  +"</div>"
						+"</div>");
				var modelFooter = "<div class=\"modal-footer\">"
						        +"<button type=\"button\" class=\"btn btn-default\" data-dismiss=\"modal\" id=\"close\">关闭</button>"
						        +"<button type=\"button\" class=\"btn btn-primary\">确定</button>"
						      +"</div>"
	
				model.find(".modal-title").append(nowOptions.title);
				if (nowOptions.url != "#"){
					if(nowOptions.load){
						model.find(".modal-body").load(nowOptions.url);
					} else {
						model.find(".modal-body").append("<iframe id=\""+nowOptions.id+"Iframe\" name=\""+nowOptions.id+"Iframe\" src=\""+nowOptions.url+"\" width=\"100%\" style=\"border: 0px; height: "+(nowOptions.height-15)+"px;\"></iframe>");
					}
				} else {
					model.find(".modal-body").append(nowOptions.content);
				}
				if(nowOptions.showDefaultButton){
					model.find(".modal-content").append(modelFooter);
					model.find(".btn-primary").bind("click", nowOptions.confirm);
				}
				
				body.append(model);
				model.modal({
					show: true,
					backdrop:'static'
				});
			} else {
				var iframe = model.find("#"+ nowOptions.id + "Iframe");
				if(nowOptions.url != "#" && iframe.attr("src") != nowOptions.url){
					iframe.attr("src",nowOptions.url);
				}
				model.modal('show');
			}
			if(nowOptions.destroy){
				model.on('hidden.bs.modal', function (e) {
					model.remove();
				});
			}
			if($.isFunction(nowOptions.onAfterHidden)){
				model.on('hidden.bs.modal',nowOptions.onAfterHidden);
			}
		}
	});
})(jQuery);