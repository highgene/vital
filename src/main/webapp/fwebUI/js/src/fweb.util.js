/* 
 * fweb.util.js
 * author: zhangbaojian
 * Date: 2014-10-28
 */
(function($) {
	$.fn.extend({
		/**
		 * 将form表单序列为JSON对象
		 */
		serializeObject : function() {
			var o = {};
			var a = this.serializeArray();
			$.each(a, function() {
				if (o[this.name]) {
					if (!o[this.name].push) {
						o[this.name] = [ o[this.name] ];
					}
					o[this.name].push(this.value || '');
				} else {
					o[this.name] = this.value || '';
				}
			});
			return o;
		},
		/**
		 * 将查询条件的form表单序列为JSON对象
		 */
		serializeFilter : function() {
			var me = this;
			var f = {};
			var o = {};
			var a = this.serializeArray();
			var ret = {};
			var flag = this.attr("filter")
			$.each(a, function() {
				var opt = me.find("input[name='" + this.name + "']")
						.attr("oper");
				if (o[this.name]) {
					if (!o[this.name].push) {
						f[this.name] = [ f[this.name] ];
						o[this.name] = [ o[this.name] ];
					}
					f[this.name].push(opt || '');
					o[this.name].push(this.value || '');
				} else {
					f[this.name] = opt || '';
					o[this.name] = this.value || '';
				}
			});
			ret.filter = o;
			if (flag) {
				ret.oper = f;
			}
			return ret;
		},
		/**
		 * 将查询条件的form表单序列化为get参数字符串
		 * @param isEncode 是否对参数进行编码 true编码
		 */
		serializeParamStr : function(isEncode) {
			var param = "";
			var a = this.serializeArray();
			$.each(a, function() {
				var value = "";
				if(isEncode){
					value =  encodeURIComponent(this.value) || "";
				} else {
					value =  this.value || "";
				}
				param += this.name + "=" + value + "&"
			});
			return param.substring(0, param.length - 1);
		},
	});
})(jQuery);