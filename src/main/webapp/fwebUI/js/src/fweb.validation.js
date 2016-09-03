/* 
 * fweb.validation.js
 * 扩展jquery.validate.js,把提示信息改为中文
 * author: zhangbaojian
 * Date: 2014-10-28
 */
(function($) {
	$.extend($.validator.messages, {
		required: "必填",
		remote: "请修正该字段",
		email: "请输入正确格式的电子邮件",
		url: "请输入正确的网址",
		date: "请输入正确的日期",
		dateISO: "请输入正确的日期 (ISO)",
		number: "请输入正确的数字",
		digits: "请输入正整数",
		creditcard: "请输入合法的信用卡号",
		equalTo: "请再次输入相同的值",
		accept: "请输入拥有合法后缀名的字符串",
		maxlength: $.validator.format("请输入一个 长度最多是{0}的字符串"),
		minlength: $.validator.format("请输入一个 长度最少是{0}的字符串"),
		rangelength: $.validator.format("请输入 一个长度介于{0}和{1}之间的字符串"),
		range: $.validator.format("请输入一个介于{0}和{1}之间的值"),
		max: $.validator.format("请输入一个最大为{0}的值"),
		min: $.validator.format("请输入一个最小为{0}的值"),
		isIntEqZero: "请输入整数0",
		isIntGtZero: "请输入大于0的整数",
		isIntGteZero: "请输入大于或等于0的整数",
		isIntNEqZero: "请输入不等于0的整数",
		isIntLtZero: "请输入小于0的整数",
		isIntLteZero: "请输入小于或等于0的整数",
		isFloatEqZero: "请输入浮点数0",
		isFloatGtZero: "请输入大于0浮点数",
		isFloatGteZero: "请输入大于或等于0浮点数",
		isFloatNEqZero: "请输入不等于0浮点数",
		isFloatLtZero: "请输入小于0浮点数",
		isFloatLteZero: "请输入小于或等于0浮点数",
		isFloat: "请输入浮点数",
		is2Float:"请输入正确的浮点数，且小数点后保留2位",
		isInteger: "请输入整数",
		isChineseChar: "请输入中文",
		isChinese: "请输入汉字",
		isEnglish: "请输入英文字符",
		isMobile: "请输入正确的手机号码",
		isPhone: "请输入正确的电话号码",
		isTel: "请输入正确的联系方式",
		isQQ: "请输入正确的QQ",
		isZipCode: "请输入正确的邮政编码",
		isPwd: "以字母开头，长度在6-12之间，只能包含字符、数字和下划线",
		isIdCardNo: "请输入正确的身份证号码",
		ip: "请输入正确的IP地址",
		stringCheck: "只能包含中文、英文、数字、下划线等字符",
		isRightfulString: "请输入正确的字符，包含a-zA-Z0-9-_",
		isContainsSpecialChar: "请输入正确的字符，不包含中英文特殊字符",
		time: "请输入正确的时间，00:00-23:59",
		time12h: "请输入正确的时间，hh:mm:ss am/pm"
	});
	
	$.extend($.validator.methods, {
		isIntEqZero: function(value, element) {
			value = parseInt(value);
			return this.optional(element) || value == 0;
		},
		isIntGtZero: function(value, element) {
			value = parseInt(value);
			return this.optional(element) || value > 0;
		},
		isIntGteZero: function(value, element) {
			value = parseInt(value);
			return this.optional(element) || value >= 0;
		},
		isIntNEqZero: function(value, element) {
			value = parseInt(value);
			return this.optional(element) || value != 0;
		},
		isIntLtZero: function(value, element) {
			value = parseInt(value);
			return this.optional(element) || value < 0;
		},
		isIntLteZero: function(value, element) {
			value = parseInt(value);
			return this.optional(element) || value <= 0;
		},
		isFloatEqZero: function(value, element) {
			value = parseFloat(value);
			return this.optional(element) || value == 0;
		},
		isFloatGtZero: function(value, element) {
			value = parseFloat(value);
			return this.optional(element) || value > 0;
		},
		isFloatGteZero: function(value, element) {
			value = parseFloat(value);
			return this.optional(element) || value >= 0;
		},
		isFloatNEqZero: function(value, element) {
			value = parseFloat(value);
			return this.optional(element) || value != 0;
		},
		isFloatLtZero: function(value, element) {
			value = parseFloat(value);
			return this.optional(element) || value < 0;
		},
		isFloatLteZero: function(value, element) {
			value = parseFloat(value);
			return this.optional(element) || value <= 0;
		},
		isFloat: function(value, element) {
			return this.optional(element) || /^[-\+]?\d+(\.\d+)?$/.test(value);
		},
		is2Float: function(value, element) {
			return this.optional(element) || /^[-\+]?\d+(\.\d{2})+$/.test(value);
		},
		isInteger: function(value, element) {
			return this.optional(element) || (/^[-\+]?\d+$/.test(value) && parseInt(value));
		},
		isChineseChar: function(value, element) {
			return this.optional(element) || /^[\u0391-\uFFE5]+$/.test(value);
		},
		isChinese: function(value, element) {
			return this.optional(element) || /^[\u4e00-\u9fa5]+$/.test(value);
		},
		isEnglish:  function(value, element) {
			return this.optional(element) || /^[A-Za-z]+$/.test(value);
		},
		isMobile: function(value, element) {
			var length = value.length;
			return this.optional(element) || (length == 11 && /^(((13[0-9]{1})|(15[0-9]{1})|(18[0-9]{1}))+\d{8})$/.test(value));
		},
		isPhone: function(value, element) {
			var tel = /^(\d{3,4}-?)?\d{7,9}$/g;
			return this.optional(element) || (tel.test(value));
		},
		isTel: function(value, element) {
			var length = value.length;
			var mobile = /^(((13[0-9]{1})|(15[0-9]{1})|(18[0-9]{1}))+\d{8})$/;
			var tel = /^(\d{3,4}-?)?\d{7,9}$/g;
			return this.optional(element) || tel.test(value) || (length == 11 && mobile.test(value));
		},
		isQQ: function(value, element) {
			return this.optional(element) || /^[1-9]\d{4,12}$/;
		},
		isZipCode: function(value, element) {
			var zip = /^[0-9]{6}$/;
			return this.optional(element) || (zip.test(value));
		},
		isPwd: function(value, element) {
			return this.optional(element) || /^[a-zA-Z]\\w{6,12}$/.test(value);
		},
		isIdCardNo: function(value, element) {
			return this.optional(element) || isIdCardNo(value);
			//身份证号码的验证规则
			function isIdCardNo(num) {
				// if (isNaN(num)) {alert("输入的不是数字！"); return false;}
				var len = num.length, re;
				if (len == 15)
					re = new RegExp(/^(\d{6})()?(\d{2})(\d{2})(\d{2})(\d{2})(\w)$/);
				else if (len == 18)
					re = new RegExp(/^(\d{6})()?(\d{4})(\d{2})(\d{2})(\d{3})(\w)$/);
				else {
					// alert("输入的数字位数不对。");
					return false;
				}
				var a = num.match(re);
				if (a != null) {
					if (len == 15) {
						var D = new Date("19" + a[3] + "/" + a[4] + "/" + a[5]);
						var B = D.getYear() == a[3] && (D.getMonth() + 1) == a[4]
								&& D.getDate() == a[5];
					} else {
						var D = new Date(a[3] + "/" + a[4] + "/" + a[5]);
						var B = D.getFullYear() == a[3]
								&& (D.getMonth() + 1) == a[4]
								&& D.getDate() == a[5];
					}
					if (!B) {
						// alert("输入的身份证号 "+ a[0] +" 里出生日期不对。");
						return false;
					}
				}
				if (!re.test(num)) {
					// alert("身份证最后一位只能是数字和字母。");
					return false;
				}
				return true;
			}
		},
		ip: function(value, element) {
			return this.optional(element) || /^(([1-9]|([1-9]\d)|(1\d\d)|(2([0-4]\d|5[0-5])))\.)(([1-9]|([1-9]\d)|(1\d\d)|(2([0-4]\d|5[0-5])))\.){2}([1-9]|([1-9]\d)|(1\d\d)|(2([0-4]\d|5[0-5])))$/.test(value);
		},
		stringCheck: function(value, element) {
			return this.optional(element) || /^[a-zA-Z0-9\u4e00-\u9fa5-_]+$/.test(value);
		},
		isRightfulString: function(value, element) {
			return this.optional(element) || /^[A-Za-z0-9_-]+$/.test(value);
		},
		isContainsSpecialChar: function(value, element) {
			var reg = RegExp(/[(\ )(\`)(\~)(\!)(\@)(\#)(\$)(\%)(\^)(\&)(\*)(\()(\))(\+)(\=)(\|)(\{)(\})(\')(\:)(\;)(\')(',)(\[)(\])(\.)(\<)(\>)(\/)(\?)(\~)(\！)(\@)(\#)(\￥)(\%)(\…)(\&)(\*)(\（)(\）)(\—)(\+)(\|)(\{)(\})(\【)(\】)(\‘)(\；)(\：)(\”)(\“)(\’)(\。)(\，)(\、)(\？)]+/);
			return this.optional(element) || !reg.test(value);
		},
		time: function(value, element) {
			return this.optional(element) || /^([01]\d|2[0-3])(:[0-5]\d){1,2}$/.test(value);
		},
		time12h: function(value, element) {
			return this.optional(element) || /^((0?[1-9]|1[012])(:[0-5]\d){1,2}(\ ?[AP]M))$/i.test(value);
		},
	});
})(jQuery);