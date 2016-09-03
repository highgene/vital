/* 
 * fweb.alert.js
 * author: zhangbaojian
 * Date: 2014-10-28
 */
(function($) {
	$.extend({
		alert: function(type, content, callBack, confirmBtnFlag) {
			top.$.alertMsg(type, content, callBack, confirmBtnFlag);
		},
		alertMsg: function(type, content, callBack, confirmBtnFlag){
			var alertDiv = $('<div class="v_label_warning">'+
					'<span class="label label-warning"></span>'+
				'</div>');
			var i = $('<i>');
			if(type == "success"){
				i.removeClass();
				i.addClass("ace-icon fa fa-check bigger-120");
			} else if(type == "warning"){
				i.removeClass();
				i.addClass("ace-icon fa fa-exclamation-triangle bigger-120");
			} else if(type == "info"){
				i.removeClass();
				i.addClass("ace-icon fa fa-exclamation-triangle bigger-120");
			} else if(type == "error"){
				i.removeClass();
				i.addClass("ace-icon fa fa-exclamation-triangle bigger-120");
			} else if (type == "confirm"){
				$.confirm(content, callBack, confirmBtnFlag);
				return ;
			}
			var span = alertDiv.find("span");
			span.append(i);
			span.append(content);
			var body = $("body");
			var v_label = body.find(".v_label_warning");
			if(v_label.length > 0){
				alertDiv.replaceAll(v_label);
			} else {
				body.append(alertDiv);
			}
			var width = (body.width()-alertDiv.width())/2 + "px";
			alertDiv.css("left", width);
			
			alertDiv.animate({opacity: 1.0}, 25000).fadeOut(5000,function(){ 
				alertDiv.remove(); 
			});
			span.bind("click", function(){
				alertDiv.stop();
				alertDiv.fadeOut(1000,function(){ 
					alertDiv.remove(); 
				});
			});
		},
		confirm: function(content, callBack, btnFlag){
			var confirmDialog = $('<div class="ui-dialog" style="height: auto; width: 300px; top: 20%; left: 35%;"></div>');
			var title = $('<div class="ui-dialog-titlebar"><div class="widget-header "><h4 class="smaller">确认框</h4></div></div>');
			var closeBtn = $('<button class="ui-dialog-titlebar-close"></button>');
			
			title.append(closeBtn);
			confirmDialog.append(title);
			confirmDialog.append('<div class="ui-dialog-content"><div class="space-6"></div><div class="alert bigger-110">'+content+'</div></div>');
			
			var footer = $('<div class="ui-dialog-buttonpane ui-helper-clearfix"><div class="ui-dialog-buttonset"></div></div>');
			var btnDiv = footer.find(".ui-dialog-buttonset");
			
			var delBtn, cancelBtn;
			if(btnFlag){
				delBtn = $('<button class="btn btn-primary btn-xs ui-button ui-button-text-only"><span class="ui-button-text">确定</span></button>');
				cancelBtn = $('<button class="btn btn-xs ui-button ui-button-text-only"><span class="ui-button-text">取消</span></button>');
				btnDiv.append(cancelBtn);
				btnDiv.append(delBtn);
			} else {
				delBtn = $('<button class="btn btn-danger btn-xs"><i class="ace-icon fa fa-trash-o bigger-110"></i>&nbsp;删除</button>');
				cancelBtn = $('<button class="btn btn-xs"><i class="ace-icon fa fa-times bigger-110"></i>&nbsp;取消</button>');
				btnDiv.append(delBtn);
				btnDiv.append(cancelBtn);
			}
			
			
			confirmDialog.append(footer);
			
			var body = $("body");
			body.append(confirmDialog);
			var overlayDiv = $('<div class="ui-widget-overlay ui-front"></div>');
			body.append(overlayDiv);
			
			closeBtn.bind("click", function(){
				overlayDiv.remove();
				confirmDialog.remove();
			});
			delBtn.bind("click", function(){
				overlayDiv.remove();
				confirmDialog.remove();
				if($.isFunction(callBack)){
					callBack(true);
				}
			});
			cancelBtn.bind("click", function(){
				overlayDiv.remove();
				confirmDialog.remove();
				if($.isFunction(callBack)){
					callBack(false);
				}
			});
		}
	});
})(jQuery);