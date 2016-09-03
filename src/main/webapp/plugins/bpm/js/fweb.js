/* 
 * fweb.util.js
 * author: zhangbaojian
 * Date: 2014-10-28
 * updateDate: 2014-01-13
 * version:1.0.0
 */
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
			},
			prompt:function(content,options){
				var defaultOptions = {
						bindRemoveEvents:["scroll", "mousedown", "keydown"],
						isKeepDefualtEvents: false,
						relativeLeft:0,
						relativeTop:0
				};
				var newOptions = $.extend({},defaultOptions,options);
				this.each(function(i, element){
					element = $(element);
					var prompt = $('<div class="prompt"><div><before></before><after></after></div></div>');
					var x = element.offset().top + $(this).outerHeight() + 4 - newOptions.relativeTop;
					var y = element.offset().left - newOptions.relativeLeft;
					prompt.css({top:x,left:y});
					var span = $("<span>");
					span.append(content);
					prompt.append(span);
					prompt.appendTo("body");
					$(window).bindRemovePrompt(newOptions.bindRemoveEvents);
					if(newOptions.isKeepDefualtEvents){
						$(window).bindRemovePrompt(defaultOptions.bindRemoveEvents);
					}
				});
			},
			bindRemovePrompt: function(events){
				var me = this;
				if(!$.isArray(events)){
					events = ["scroll", "mousedown", "keydown"];
				}
				$.each(events, function(i, event){
					me.bind(event, removePrompt);
				});
				function removePrompt(){
					$("div.prompt").remove();
				}
			},
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
				disable_search: false,
				onchange : false,//false/function(value, text, writeValue) {},
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
					no_results_text : "没有找到!",
					disable_search: newOptions.disable_search
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
								me.find("option:selected").removeAttr("selected");
								if($.isFunction(newOptions.onchange)){
									setChangeValue();
								}
								
							}
							
						});
					}
				}
				if($.isFunction(newOptions.onchange)){
					me.bind("change", function(){
						if(!newOptions.multiple){
							me.data(id, "");
						}
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
		},
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
						if(data[id] == null || data[id] === ""){
							label.append(newOptions.defaultEmptyValToDetail);
						} else {
							label.append(data[id]);
						}
					});
				}
			}
		},
		dataGrid: function(options,param){
			var me = this;
			var newOptions;
			var pageNo;
			var colspan = 0;
			var resizeNum = 0;
			var userGrid = [];
			var gridId = me.attr("id");
			//提供用户调用的方法
			if (typeof options == 'string') {
				switch(options){
					case 'getSelections'://获取选中的数据数组或根据行ids数组获取行数据数组，一般适用于checkbox
						return getSelections(param);
					case 'getSelectIds'://获取选中的ID数组，一般适用于checkbox
						return getSelectIds();
					case 'getSelection'://获取选中的单行数据或根据行id获取行数据，一般适用于radio
						return getSelection(param);
					case 'getSelectId'://获取选中的单行ID，一般适用于radio
						return getSelectId();
					case 'getAllData'://获取表格的数据
						return getAllData();
					case 'addRow'://添加表格行
						addRow(param);
						return;
					case 'editRow'://编辑表格行数据
						editRow(param);
						return;
					case 'saveRow'://保存表格行数据
						saveRow(param);
						return;
					case 'updateRow':
						updateRow(param);
						return;
					case 'reload'://重新加载表格数据方法
						reload(param);
				}
				return;
			}
			//表格的默认属性,用户可以自己定义
			var defaultOptions = {
			    align:"left",//表头位置
				idField:"id",//数据的主键字段
				pagination:false,//是否分页
				pageSize:10,//10/{xs:6,sm:10,md:15,lg:25,ml:30}分页大小,根据屏幕不同的分辨率显示不同的页数
				rownum:false,//是否显示行号
				checkbox:false,//是否显示checkbox
				radio:false, //是否显示radio
				param:"",//请求参数
				url:"",//请求URL
				saveUrl:"",//行编辑数据保存URL
				extSaveParam:{},//行编辑数据扩展参数
				saveValidate:function(row, tr){return true},//保存前验证回调函数
				beforeSave:function(row, tr){return row},//保存前回调函数
				afterSave:function(isSuccess, row, tr){return false},//保存后回调函数
				enableRowEditEvent:false,//是否启用双击鼠标进行编辑保存行数据
				type:"get",//提交方式
				data:{},//表格数据
				//表格列[{{字段，表头，宽度，位置，是否鼠标放上显示表格内容数据false/true/function(row){}，是否排序，是否显示，根据表格分辨率显示级别(xs/sm/md/lg/ml)，合并行的级别，渲染回调函数，行编辑类型(text/select/myself/date,选项，点击事件，示例：{type:"select",options:{value:"sexValue",text:"sexText",data/url:sexData})}]
				columns:[{name:"",title:"",width:"",align:"",showContent:false,sort:false,display:true,level:"",mergeLevel:1,render:function(row){},editor:{type:"",options:{},click:function(){}}}],
				dblclickRow:false,//双击事件false/function(e){}
				loadSuccess:function(data){},//加载成功之后回调函数
				loadError:function (XMLHttpRequest, textStatus, errorThrown) {},//加载失败之后回调函数
				headerContextMenu:false,//显示/隐藏列菜单false/true/["loginId","userName"]
				fixedHeader:false,//false/true动态设置单元格td的宽度
			    height:false,//表格高度 false/300/function(){}
				userId:"",//根据用户ID保存用户定义的headerContextMenu的显示/隐藏列信息，保存到cookie
				initSortField:false //初始化排序字段false/{"userName":"desc"}
			};
			//初始化数据
			init();
			//加载表格
			load();
			//绑定resize事件
			$(window).resize(hideColumnsByWidth);
			$(window).resize(setWidth);
			
			function load(){
				if(newOptions.url != ""){
					var param = me.data(gridId).param;
					var url = newOptions.url;
					if(newOptions.pagination){
						url += (url.indexOf('?') > -1 ? '&':'?') + "pageIndex=" + (pageNo - 1) + "&pageSize="+ newOptions.pageSize
					}
					$.ajax({
						url : url,
						type : newOptions.type,
						data : param,
						contentType : 'application/json;charset=UTF-8',
						error : newOptions.loadError,
						success : function(data) {
							if($.isArray(data)){
								newOptions.data.data = data;
								newOptions.data.total = data.length;
							} else {
								newOptions.data = data;
							}
							drawGrid();
						}
					});
				} else {
					drawGrid();
				}
			}
			
			function init(){
				newOptions = $.extend({},defaultOptions,options);
				initPageNo(newOptions.param);
				initColumns();
				setPageSizeByHeight();
				initUserGridCookie(newOptions.userId);
				me.data(gridId, newOptions);
				initSort();
				//保存用户个性化设置的隐藏显示列
				me.data(gridId).userGrid = userGrid;
			}
			function initPageNo(param){
				pageNo = parseInt(me.find("#pageNo").text()) || 1
				//判断下一次查询与上一次查询条件是否一致;如果不一致，页码设置为1
				if(typeof param == "string" && me.data(gridId) != undefined
						&& me.data(gridId).param != param ){
					pageNo = 1;
				} else if($.isArray(param) && me.data(gridId) != undefined ){
					if($.toJSON(param) != $.toJSON(me.data(gridId).param)){
						pageNo = 1;
					}
				}
			}
			
			function initUserGridCookie(userId){
				if(newOptions.headerContextMenu){
					var userGridCookie = $.cookie("userGrid_" + userId);
					if(userGridCookie != undefined){
						userGrid = userGridCookie.split(",");
					} else if(me.data(gridId) != undefined && me.data(gridId).userGrid != undefined){
						userGrid = me.data(gridId).userGrid;
					}
					$.each(newOptions.columns, function(i, column){
						if(column.display == false && $.inArray(column.name, userGrid) == -1 
								&& (newOptions.headerContextMenu == true || $.inArray(column.name, newOptions.headerContextMenu) > -1)){
							userGrid.push(column.name);
						}
					});
				}
			}
			
			function initColumns(){
				//针对多表头/表头进行封装成数组
				var dataColumns = [];
				var headerGroupColumns = [];
				wrapColumns(dataColumns,headerGroupColumns,newOptions.columns, 0);
				newOptions.columns = dataColumns;
				newOptions.headerGroupColumns = headerGroupColumns;
			}
			
			function reload(param){
				initPageNo(param);
				newOptions = me.data(gridId);
				if(param != undefined){
					newOptions.param = param
				}
				initUserGridCookie(newOptions.userId);
				load();
			}
			
			function drawGrid(){
				if(me.hasClass("datagrid")){
					drawTbody().replaceAll(me.find("div.data_div"));
					if(newOptions.pagination){
						setPageValue(me.find("div.pagination_div"))
					}
				} else {
					me.addClass("datagrid");
					me.append(drawThead());
					me.append(drawTbody());
					if(newOptions.pagination){
						me.append(drawPagination());
					}
					hideColumnsByWidth();
				}
				if(newOptions.height || newOptions.fixedHeader){
					setWidth();
				}
				if(newOptions.headerContextMenu){
					showCookieColumns(userGrid.toString());
				}
				newOptions.loadSuccess(newOptions.data);
			}
			
			function setWidth(){
				//动态设置表格的宽度
				if(newOptions.height || newOptions.fixedHeader){
					var threadDiv = me.find("div.thread_div");
					var dataDiv = me.find("div.data_div");
					if(newOptions.height){
						var tableWidth = threadDiv.width()-17;
						me.find("table").outerWidth(tableWidth);
						dataDiv.find(".data_div_con").outerWidth(tableWidth);
					} 
					if(newOptions.fixedHeader){
						var emptyTds = dataDiv.find("tr.empty_tr td");
						emptyTds.each(function(i, td){
							td = $(td);
							var name = td.attr("name");
							var th = threadDiv.find("th[name='"+name+"']:first");
							var width = th.outerWidth();
							td.outerWidth(width);
						});
					}
					addScroll();
				}
			}
			
			function hideColumnsByWidth(){
				if(resizeNum == 1){
					resizeNum = 0
					return;
				}
				resizeNum++;
				var tableWidth = me.width();
				var columns = me.data(gridId).columns;
				$.each(columns,function(i,column){
					var level = column.level;
					if(level){
						if(tableWidth >= 1024 && tableWidth < 1280 && level == "ml"){
							hideColumn(column);
						} else if (tableWidth >= 800 && tableWidth < 1024 && (level == "ml" || level == "lg")){
							hideColumn(column);
						} else if (tableWidth >= 600 && tableWidth < 800 && (level == "ml" || level == "lg" || level == "md")){
							hideColumn(column);
						} else if (tableWidth < 600 && (level == "ml" || level == "lg" || level == "md" || level == "sm")){
							hideColumn(column);
						} else if($.inArray(column.name,userGrid) == -1){
							showColumn(column);
						}
					}
				});
			}
			
			function hideColumn(column){
				var name = column.name;
				var pid = column.pid;
				var ths = me.find("tr th[name='"+name+"']");
				if(pid && ths.is(":visible")){
					var pth = me.find("tr th[name='"+pid+"']");
					var colspan = parseInt(pth.attr("colspan"));
					if(colspan == 1){
						me.find("tr th[name='"+pid+"']").hide();
					}
					pth.attr("colspan",colspan-1);
				}
				ths.hide();
				me.find("tr td[name='"+name+"']").hide();
			}
			
			function showColumn(column){
				var name = column.name;
				var pid = column.pid;
				var ths = me.find("tr th[name='"+name+"']");
				if(pid && ths.is(":hidden")){
					var pth = me.find("tr th[name='"+pid+"']");
					var colspan = parseInt(pth.attr("colspan"));
					pth.attr("colspan",colspan+1);
					me.find("tr th[name='"+pid+"']").show();
				}
				ths.show();
				me.find("tr td[name='"+name+"']").show();
			}
			
			function setPageSizeByHeight(){
				if(!$.isNumeric(newOptions.pageSize)){
					var winHeight = window.screen.height;
					if(winHeight > 1280){
						newOptions.pageSize = newOptions.pageSize.ml;
					} else if(winHeight > 900 && winHeight <= 1280){
						newOptions.pageSize = newOptions.pageSize.lg;
					} if (winHeight > 768 && winHeight <= 900){
						newOptions.pageSize = newOptions.pageSize.md;
					} else if (winHeight > 600 && winHeight <= 768){
						newOptions.pageSize = newOptions.pageSize.sm;
					} else if (winHeight <= 600){
						newOptions.pageSize = newOptions.pageSize.xs;
					} 
				}
			}
			function wrapColumns(dataColumns,headerGroupColumns,columns,level, pid){
				++level;
				$.each(columns,function(i,column){
					if(pid != undefined){
						column.pid = pid;
					}
					if(headerGroupColumns.length < level ){
						var iColumns = [];
						iColumns.push(column);
						headerGroupColumns.push(iColumns);
					} else {
						headerGroupColumns[level-1].push(column);
					}
					
					if(column.columns){
						wrapColumns(dataColumns,headerGroupColumns,column.columns,level, column.name);
					} else {
						dataColumns.push(column);
						
					}
				});
				return level;
			}
			
			function drawThead(){
				//画出表头
				var threadDiv = $('<div class="thread_div">');
				var threadTable = $('<table class="table table-striped table-bordered table-hover datagrid">');
				var thead = $("<thead></thead>");
				$.each(newOptions.headerGroupColumns,function(i,header){
					var tr = $("<tr>");
					$.each(header,function(j,column){
						var th = $("<th>");
						th.css("text-align", newOptions.align);
						th.attr("name", column.name);
						th.append(column.title);
						if(column.width){
							th.width(column.width);
						}
						if(column.sort){
							var span = $("<span class=\"glyphicon\">");
							th.append(span);
							th.bind("click", column.name, sortClick);
							if(newOptions.initSortField && newOptions.initSortField[column.name]){
								addSort(span, column.name);
							}
						}
						if(column.display != undefined && !column.display){
							th.hide();
						}
						if(column.level){
							th.attr("level", column.level);
						} 
						if(column.columns){
							th.attr("colspan", column.columns.length);
						}
						if(column.pid){
							th.attr("pid", column.pid);
						}
						tr.append(th);
					});
					thead.append(tr);
				});
				//添加序号,checkbox,radio
				var trFirst = thead.find("tr:first");
				if(newOptions.rownum){
					var rownumTh = $("<th>序号</th>");
					rownumTh.css("text-align", newOptions.align);
					rownumTh.width(60);
					rownumTh.attr("name", "rownum");
					rownumTh.prependTo(trFirst);
				}
				if(newOptions.checkbox){
					var checkbox = $('<input type="checkbox" id="selectAll">');
					checkbox.bind("click", function(){
						var selectCheckbox = me.find("input[name='selectOne']");
						$.each(selectCheckbox,function(i,selectOne){
							selectOne.checked = checkbox[0].checked;
						});
					});
					var checkboxTh = $("<th>");
					checkboxTh.css("text-align", "left");
					checkboxTh.width(35);
					checkboxTh.append(checkbox);
					checkboxTh.attr("name", "checkbox");
					checkboxTh.prependTo(trFirst);
				}
				if(newOptions.radio){
					var radio = $('<input type="radio" id="selectAll" disabled>');
					var radioTh = $("<th>");
					radioTh.css("text-align", "left");
					radioTh.width(35);
					radioTh.append(radio);
					radioTh.attr("name", "radio");
					radioTh.prependTo(trFirst);
				}
				//合并多表头
				if(newOptions.headerGroupColumns.length > 1){
					trFirst.find("th:not(th[colspan])").attr("rowspan",newOptions.headerGroupColumns.length);
					addEmptyTrToThread(thead);
					threadTable.addClass("group_table");
				}
				
				if(newOptions.headerContextMenu){
					headerContextMenu(thead);
				} 
				threadTable.append(thead);
				threadDiv.append(threadTable);
				return threadDiv;
			}
			
			function addEmptyTrToThread(thead){
				var tr = $('<tr class="empty_tr">');
				if(newOptions.radio){
					var radioTh = $('<th>');
					radioTh.width(35);
					radioTh.attr("name", "radio");
					tr.append(radioTh);
				}
				if(newOptions.checkbox){
					var checkboxTh = $('<th>');
					checkboxTh.width(35);
					checkboxTh.attr("name", "checkbox");
					tr.append(checkboxTh);
				}
				if(newOptions.rownum){
					var rownumTh = $('<th>');
					rownumTh.width(60);
					rownumTh.attr("name", "rownum");
					tr.append(rownumTh);
				}
				$.each(newOptions.columns, function(j,column){
					var th = $('<th>');
					th.width(column.width);
					th.attr("name", column.name);
					if(column.display != undefined && !column.display){
						th.hide();
					}
					tr.append(th);
				});
				tr.prependTo(thead);
				return tr;
			}
			
			function headerContextMenu(thead){
				var items = [];
				$.each(newOptions.columns,function(i,column){
					if(newOptions.headerContextMenu == true || $.inArray(column.name,newOptions.headerContextMenu) > -1){
						var item = {};
						item.name = column.name;
						item.text = column.title;
						item.checkbox = true;
						items.push(item);
					}
				});
				thead.contextMenu({
					items:items,
					buttons:[
					{text:"保存",click:function(menu){
						var inputArray = menu.find("input:not(:checked)");
						var userGridTemp = [];
						$.each(inputArray, function(j,input){
							userGridTemp.push(input.name);
						});
						if(!$.isEmptyObject(newOptions.userId)){
							$.cookie("userGrid_" + newOptions.userId,userGridTemp.toString(),{expires:365});
						}
						userGrid = userGridTemp;
						me.data(gridId).userGrid = userGrid;
						showCookieColumns(userGridTemp.toString());
						//动态设置表格的宽度
						setWidth();
					}},
			        {text:"取消"}],
			        onShowMenu : function(menu){
			        	var userGrid = $.cookie("userGrid_" + newOptions.userId);
			        	if(userGrid != undefined){
			        		//根据cookie列显示checkbox选中
			        		var columns = userGrid.split(",");
			        		menu.find(":checkbox").each(function(i,input){
								if($.inArray(input.name,columns) > -1){
									input.checked = false;
								} else {
									input.checked = true;
								}
							});
			        	} else {
			        		//根据默认列显示checkbox选中
			        		var ths = me.find("th:hidden");
			        		menu.find(":checkbox").each(function(i,input){
			        			var flag = true;
			        			ths.each(function(j,th){
			        				if( $(th).attr("name") == input.name){
			        					flag = false;
										return false;
									}
			        			});
			        			input.checked = flag;
							});
			        	}
			        }
				}); 
			}
			
			function showCookieColumns(userGridStr){
				var userGridCookie = $.cookie("userGrid_" + newOptions.userId) || userGridStr;
				if(userGridCookie != undefined){
					var ths = me.find("th");
					var columns = userGridCookie.split(",");
					$.each(newOptions.columns,function(i,column){
						var name = column.name;
						if($.inArray(name,columns) > -1){
							hideColumn(column)
						} else if(newOptions.headerContextMenu == true || $.inArray(name,newOptions.headerContextMenu) > -1){
							//把隐藏的的显示出来
							showColumn(column);
						}
					});
				}
			}
			
			function sortClick(event){
				var columnName = event.data;
				var span = $(this).find("span");
				var hasclazz = span.hasClass("glyphicon-chevron-down");
				var upOrDown = null;
				initSort();
				if(hasclazz){
					span.addClass("glyphicon-chevron-up");
					upOrDown = "desc";
				} else {
					span.addClass("glyphicon-chevron-down");
					upOrDown = "asc";
				}
				addSortParam(columnName, upOrDown);
				load();
			}
			
			function addSortParam(columnName, upOrDown){
				var param = me.data(gridId).param;
				var sortField = {};
				var sortOrder = {};
				sortField.name = "sortField";
				sortField.value = columnName;
				sortOrder.name = "sortOrder";
				sortOrder.value = upOrDown;
				
				if($.isEmptyObject(param)){
					var paramTemp = [];
					paramTemp.push(sortField);
					paramTemp.push(sortOrder);
					me.data(gridId).param = paramTemp;
				} else if(typeof param == "string"){
					var paramTemp;
					try{
						paramTemp = $.parseJSON(param); 
						paramTemp.sortField = columnName;
						paramTemp.sortOrder = upOrDown;
						paramTemp = $.toJSON(paramTemp);
					} catch(e){
						var i = param.indexOf("sortField");
						if( i > -1){
							paramTemp = param.substring(0,i);
						}
						paramTemp += "&sortField=" + columnName + "&sortOrder=" + upOrDown;
					}
					me.data(gridId).param = paramTemp;
				} else if($.isArray(param)){
					var sortFieldTemp;
					var sortOrderTemp;
					$.each(param, function(i, o){
						if(o.name == "sortField"){
							sortFieldTemp = o;
						}
						if(o.name == "sortOrder"){
							sortOrderTemp = o;
						}
					});
					if(sortFieldTemp != undefined){
						param.splice($.inArray(sortOrderTemp,param),1);
					}
					if(sortOrderTemp != undefined){
						param.splice($.inArray(sortOrderTemp,param),1);
					}
					param.push(sortField);
					param.push(sortOrder);
				}
			}
			
			function initSort(){
				me.find(".glyphicon-chevron-down").removeClass("glyphicon-chevron-down");
				me.find(".glyphicon-chevron-up").removeClass("glyphicon-chevron-up");
				if(newOptions.initSortField){
					$.each(newOptions.initSortField, function(columnName, upOrDown){
						addSortParam(columnName, upOrDown);
						return false;
					});
				}
			}
			
			function addSort(span, columnName){
				if(newOptions.initSortField[columnName] == "asc"){
					span.addClass("glyphicon-chevron-down");
				} else if(newOptions.initSortField[columnName] == "desc"){
					span.addClass("glyphicon-chevron-up");
				}
			}
			function drawScroll(tableHeight, dataDiv){
				var threadHeight;
				if(newOptions.headerGroupColumns.length == 1){
					threadHeight = 40;
				} else {
					threadHeight = 75;
				}
				tableHeight = tableHeight - threadHeight;
				if(newOptions.pagination){
					tableHeight = tableHeight -38
				}
				dataDiv.outerHeight(tableHeight);
				var borderDiv = dataDiv.find("div.data_div_con");
				dataDiv.removeClass("data_div_visible");
				borderDiv.css("top", threadHeight);
				borderDiv.outerHeight(tableHeight);
			}
			
			function addScroll(dataDiv){
				dataDiv = dataDiv || me.find("div.data_div");
				if($.isNumeric(newOptions.height)){
					drawScroll(newOptions.height, dataDiv);
				} else if($.isFunction(newOptions.height)){
					drawScroll(newOptions.height(), dataDiv);
				}
			}
			function drawTbody(){
				var dataDiv = $('<div class="data_div data_div_visible">');
				if(newOptions.height){
					var borderDiv = $('<div class="data_div_con"></div>');
					dataDiv.append(borderDiv);
					addScroll(dataDiv);
				}
				var dataTable = $('<table class="table table-striped table-bordered table-hover datagrid">');
				var tbody = $("<tbody></tbody>");
				addEmptyTr(tbody);
				if($.isEmptyObject(newOptions.data.data)){
					if(newOptions.checkbox){
						++colspan;
					}
					if(newOptions.radio){
						++colspan;
					}
					if(newOptions.rownum){
						++colspan;
					}
					colspan += newOptions.columns.length;
					var tr0 = $('<tr index="-1"><td colspan="'+colspan+'">没有查询到数据</td></tr>');
					tr0.find("td").addClass("empty_data");
					if($.isFunction(newOptions.dblclickRow)){
						tr0.bind("dblclick",newOptions.dblclickRow);
					}
					tbody.append(tr0);
					dataTable.append(tbody);
					dataDiv.append(dataTable);
					return dataDiv;
				}
				var startNum = newOptions.pageSize * (pageNo-1);
				var groupTd = [];//存储合并行
				var rows = newOptions.data.data;
				var tableTrClassFlag = false;
				$.each(rows, function(i, row){
					var tr = $("<tr index=\"" + i + "\">");
					var provThIsRowSpan = true;//判断前面的单元格行是否合并
					if($.isFunction(newOptions.dblclickRow)){
						tr.bind("dblclick",row,newOptions.dblclickRow);
					}
					if(newOptions.checkbox){
						var checkbox = $('<input type="checkbox" name="selectOne" value="">');
						if(row[newOptions.idField] != "undefined" && row[newOptions.idField] != null && row[newOptions.idField] != ""){
							checkbox.val(row[newOptions.idField]);
						}
						var td = $("<td>");
						td.css("text-align", "center");
						td.append(checkbox);
						td.attr("name", "checkbox");
						tr.append(td);
					}
					if(newOptions.radio){
						var radio = $('<input type="radio" name="selectOne" value="">');
						if(row[newOptions.idField] != "undefined" && row[newOptions.idField] != null && row[newOptions.idField] != ""){
							radio.val(row[newOptions.idField]);
						}
						var td = $("<td>");
						td.css("text-align", "center");
						td.attr("name", "radio");
						td.append(radio);
						tr.append(td);
					}
					if(newOptions.rownum){
						++startNum;
						var td = $("<td>");
						td.append(startNum);
						td.attr("name", "rownum");
						tr.append(td);
					}
					$.each(newOptions.columns,function(j,column){
						var td = $('<td>');
						if(column.mergeLevel){
							//表格合并：判断当前行的数据与前一行的数据是否相等，前一行是否已经合并
							if(i != 0 && rows[i-1][column.name] == row[column.name] && provThIsRowSpan){
								var rowspan = parseInt(groupTd[j].attr("rowspan")) || 1;
								groupTd[j].attr("rowspan", rowspan + 1);
								groupTd[j].css("vertical-align", "middle");
								provThIsRowSpan = true;
								tableTrClassFlag = true;
							} else {
								drawTd(td, column, row);
								tr.append(td);
								groupTd[j] = td;
								provThIsRowSpan = false;
							}
						} else {
							drawTd(td, column, row);
							tr.append(td);
						}
					});
					if(newOptions.enableRowEditEvent){
						tr.bind("dblclick", dblclickTr);
						tr.bind("click", clickTr);
					}
					tbody.append(tr);
				});
				if(tableTrClassFlag){
					me.find("table").removeClass("table-striped table-hover");
					dataTable.removeClass("table-striped table-hover");
				}
				dataTable.append(tbody);
				dataDiv.append(dataTable);
				return dataDiv;
			}
			
			function addEmptyTr(tbody){
				var tr = $('<tr class="empty_tr">');
				if(newOptions.radio){
					var radioTd = $('<td>');
					radioTd.width(35);
					radioTd.attr("name", "radio");
					tr.append(radioTd);
				}
				if(newOptions.checkbox){
					var checkboxTd = $('<td>');
					checkboxTd.width(35);
					checkboxTd.attr("name", "checkbox");
					tr.append(checkboxTd);
				}
				if(newOptions.rownum){
					var rownumTd = $('<td>');
					rownumTd.width(60);
					rownumTd.attr("name", "rownum");
					tr.append(rownumTd);
				}
				$.each(newOptions.columns, function(j,column){
					var td = $('<td>');
					td.width(column.width);
					td.attr("name", column.name);
					if(column.display != undefined && !column.display){
						td.hide();
					}
					tr.append(td);
				});
				
				tbody.append(tr);
				return tr;
			}
			
			function drawTd(td, column, row){
				if(column.align){
					td.css("text-align", column.align);
				}
				
				if("opt" == column.name && typeof column.render === "function"){
					td.attr("opt", true);
					var render = column.render(row);
					td.append(render);
					//showTitle(column, row, td);
				} else if(typeof column.render === "function"){
					var render = column.render(row);
					td.append(render);
					showTitle(column, row, td);
				} else {
					td.append(row[column.name]);
					showTitle(column, row, td);
				}
				if(column.name == newOptions.idField){
					td.attr(newOptions.idField,row[column.name]);
				}
				if(column.editor != undefined && column.editor != null){
					td.attr("editorType",column.editor.type);
				}
				if(column.display != undefined && !column.display){
					td.hide();
				}
				td.attr("name", column.name);
			}
			
			function showTitle(column, row, td){
				if(column.name=="opt")
					column.showContent  = false;
				column.showContent = column.showContent==undefined?true:column.showContent;
				if($.isFunction(column.showContent)){
					td.attr("title",column.showContent(row));
				} else if(column.showContent){
					if($.isFunction(column.render)){
						td.attr("title",column.render(row));
					} else {
						td.attr("title",row[column.name]);
					}
				}
			}
			
			function dblclickTr(){
				var tr = $(this);
				saveRow(tr,"dblclick");
			}
			
			function editRow(trOrId){
				var tr;
				if(typeof trOrId == 'string'){
					var idField = me.data(gridId).idField;
					tr = me.find("tr td["+idField+"='"+trOrId+"']").parent();
				} else {
					tr = trOrId;
				}
				tr.find('td[editorType]').each(function (m, tdTemp){
					var td = $(tdTemp);
					var editorType = td.attr("editorType");
					var editorName = td.attr("name");
					addEditor(editorType, editorName, td, tr, true);
				});
				var input = tr.find("input[type='text']").first();
				if(input.length > 0){
					input.focus();
				}
			}
			
			function addEditor(editorType, editorName, td, tr, updateFlag){
				var columns = me.data(gridId).columns;
				tr.attr("update",updateFlag || false);
				switch(editorType){
				case "text":
					if(td.find("input").length > 0){
						return;
					}
					var val = td.html();
					var input = $('<input type="text" class="form-control edit_content" value="'+val+'"/>');
					td.addClass("edit_td");
					input.attr("name", editorName);
					td.html(input);
					input.focusout(function() {
						var newVal = input.val();
						if(newVal != val){
							td.attr("update",true)
							tr.attr("update",true);
						}
					});
					$.each(columns,function(i,column){
						if(column.name == editorName){
							if(column.editor && $.isFunction(column.editor.click)){
								input.bind("click",column.editor.click);
							}
							if(column.editor && column.editor.options && column.editor.options.eventType){
								input.bind(column.editor.options.eventType,column.editor.options.eventFunction);
							}
							return false;
						}
					});
					break;
				case "select":
					if(td.find("select").length > 0){
						return;
					}
					var val = td.html();
					var select = $('<select class="form-control edit_content">');
					var options = null;
					$.each(columns,function(i,column){
						if(column.name == editorName){
							options = column.editor.options;
							return false;
						}
					});
					if(options.url != undefined && options.data == undefined){
						$.ajax({
							url : options.url,
							type : 'get',
							contentType : 'application/json;charset=UTF-8',
							async : false,
							success : function(data){
								options.data = data;
							},
							error : function(data) {
								$.alert("request " + options.url + " error");
							}
						});
					}
					
					$.each(options.data,function(i,option){
						var optionTemp = $('<option value="'+option[options.value]+'">'+option[options.text]+'</option>');
						if(option[options.value] == val || option[options.text] == val){
							optionTemp.attr("selected", true);
						}
						select.append(optionTemp);
					});
					td.addClass("edit_td");
					td.html(select);
					select.change(function() {
						var newVal = select.find("option:selected").val();
						if(newVal != val){
							td.attr("update",true)
							tr.attr("update",true);
						}
					});
					break;
				case "myself":
					if(td.find("#"+editorName).length > 0){
						return;
					}
					var options = null;
					var row = {};
					$.each(columns,function(i,column){
						if(column.name == editorName){
							options = column.editor.options;
							return false;
						}
					});
					if($.isFunction(options)){
						td.addClass("edit_td");
						var data = me.data(gridId).data;
						if($.isEmptyObject(data) || $.isEmptyObject(data.data)){
							td.html(options(null,tr));
						} else {
							var index = tr.attr("index");
							td.html(options(data.data[index],tr));
						}
					}
					break;
				case "date":
					if(td.find("input").length > 0){
						return;
					}
					var val = td.html();
					var options = {language : "zh-CN",autoclose : true,startView : 2,minView : 0,maxView : 2, format: "yyyy-mm-dd hh:ii:ss"};
					$.each(columns,function(i,column){
						if(column.name == editorName){
							$.extend(options, column.editor.options);
							return false;
						}
					});
					td.addClass("edit_td");
					var input = $('<input type="text" class="form-control edit_content" value="' + val + '">');
					input.attr("name", editorName);
					if(options.eventType){
						var eventType = options.eventType;
						var eventFunction = options.eventFunction;
						delete options.eventType;
						delete options.eventFunction;
						input.datetimepicker(options).on(eventType,eventFunction);
					} else {
						input.datetimepicker(options);
					}
					
					td.html(input);
					input.change(function() {
						var newVal = input.val();
						if(newVal != val){
							td.attr("update",true)
							tr.attr("update",true);
						}
					});
					break;
				}
			}

			function clickTr(){
				saveRow($(this), "click");
			}
			
			function saveRow(trOrId, type){
				var tr;
				if(typeof trOrId == 'string'){
					var idField = me.data(gridId).idField;
					tr = me.find("tr td["+idField+"='"+trOrId+"']").parent();
				} else {
					tr = trOrId;
				}
				var editTr = null;
				if(type == undefined){
					if(tr.attr("update") == undefined){
						return ;
					} else {
						editTr = tr;
					}
				} else {
					editTr = tr.parent().find('tr[update]');
				}
				if(editTr.length > 0){
					var newOptions = me.data(gridId);
					$.each(editTr, function (i, editTrTemp){
						if("click" == type && tr[0] == editTrTemp){
							return false;
						}
						editTrTemp = $(editTrTemp);
						var index = $(this).attr("index");
						var updateData = {};
						var id = null;
						$(this).find('td').each(function (m, tdTemp){
							var td = $(tdTemp);
							var idValue = td.attr(newOptions.idField);
							if(idValue != undefined){
								id = idValue;
							}
							
							var editorType = td.attr("editorType");
							var editor = td.attr("name")
							if(td.attr("editorType") != undefined){
								var val = null;
								var cacheValue = null;
								switch(editorType){
									case "text":
										val = td.find("input").val();
										cacheValue = val;
										break;
									case "select":
										val = td.find("select option:selected").val();
										var text = td.find("select option:selected").text();
										cacheValue = text;
										break;
									case "myself":
										val = td.find("#"+editor).val();
										var showValue = td.find("#"+editor).attr("showValue");
										cacheValue = val;
										break;
									case "date":
										val = td.find("input").val();
										cacheValue = val;
										break;
									
								}
								if(editTrTemp.attr("update")=="true" || editTrTemp.attr("insert")=="true"){
									updateData[editor] = val;
								}
							}
							
						});
						if(!$.isEmptyObject(updateData) && !$.isEmptyObject(newOptions.saveUrl)
								&& (editTrTemp.attr("update")=="true" || editTrTemp.attr("insert")=="true")){
							$(this).removeAttr("update");
							var type = null;
							if($.isEmptyObject(id)){
								type = "post";
							} else {
								type = "put";
								updateData[newOptions.idField] = id;
							}
							if(!$.isEmptyObject(newOptions.extSaveParam)){
								$.extend(updateData, newOptions.extSaveParam);
							}
							if(!newOptions.saveValidate(updateData, editTrTemp)){
								editRow(editTrTemp);
								return ;
							}
							updateData = newOptions.beforeSave(updateData, editTrTemp);
							$.ajax({
								url : newOptions.saveUrl,
								type : type,
								data : $.toJSON(updateData),
								contentType : 'application/json;charset=UTF-8',
								success : function (data){
									newOptions.data = newOptions.data || {};
									newOptions.data.data = newOptions.data.data || [];
									newOptions.data.total = newOptions.data.total || 0;
									if("post" == type && data){
										editTrTemp.find('td['+ newOptions.idField +']').attr(newOptions.idField, data[newOptions.idField]);
										$.each(newOptions.columns,function (i, column){
											if(column.name == "opt" ){
												editTrTemp.find('td[opt]').html(column.render(data));
												return false;
											}
										});
										newOptions.data.data[index]=data;
										if(newOptions.checkbox){
											editTrTemp.find("input[name='selectOne']").val(data[newOptions.idField]);
										}
										if(newOptions.radio){
											editTrTemp.find("input[name='selectOne']").val(data[newOptions.idField]);
										}
										if($.isFunction(newOptions.dblclickRow)){
											tr.bind("dblclick",data,newOptions.dblclickRow);
										}
										newOptions.data.total = newOptions.data.total+1;
									} else {
										if($.isEmptyObject(data)){
											newOptions.data.data[index] = newOptions.data.data[index] || {};
											$.extend(newOptions.data.data[index], updateData);
										} else {
											newOptions.data.data[index] = data;
										}
									}
									savePageRow(editTrTemp);
									newOptions.afterSave(true,data,editTrTemp);
								},
								error : function(data) {
									if(newOptions.afterSave(false,data,editTrTemp) == false){
										editRow(editTrTemp);
										$.alert("error","保存失败："+$.toJSON(data));
									}
								}
							});
						} else if("dblclick" == type){
							savePageRow(editTrTemp);
							editRow(tr);
						} else{
							savePageRow(editTrTemp);
							newOptions.afterSave(true,updateData,editTrTemp);
							$(this).removeAttr("update");
						}
					});
				} else if("dblclick" == type){
					editRow(tr);
				}
			}
			
			function savePageRow(editTrTemp){
				editTrTemp.find('td').each(function (m, tdTemp){
					var td = $(tdTemp);
					var editorType = td.attr("editorType");
					var editor = td.attr("name")
					if(td.attr("editorType") != undefined){
						var val = null;
						switch(editorType){
							case "text":
								val = td.find("input").val();
								td.removeClass("edit_td");
								td.html(val);
								break;
							case "select":
								var text = td.find("select option:selected").text();
								td.removeClass("edit_td");
								td.html(text);
								break;
							case "myself":
								var showValue = td.find("#"+editor).attr("showValue");
								td.removeClass("edit_td");
								td.html(showValue);
								break;
							case "date":
								val = td.find("input").val();
								td.removeClass("edit_td");
								td.html(val);
								break;
						}
					}
				});
			}
			
			function drawPagination(){
				var pagination = $('<div class="pagination_div">'+
									'<ul class=\"pagination\">'+
									'<li class="previous" id="pageFrist"><a href="javascript:void(0)"><span class="glyphicon glyphicon-fast-backward"></span></a></li>'+
									'<li class="previous" id="pageUp"><a href="javascript:void(0)"><span class="glyphicon glyphicon-backward"></span></a></li>'+
									'<li class="next" id="pageDown"><a href="javascript:void(0)"><span class="glyphicon glyphicon-forward"></span></a></li>'+
									'<li class="next" id="pageLast"><a href="javascript:void(0)"><span class="glyphicon glyphicon-fast-forward"></span></a></li>'+
									'<li class="next page_right"><a>'+
										'第 <span id="pageNo"></span> 页 / 共 <span id="pageTotal"></span> 页&nbsp;&nbsp;共&nbsp;'+'<span id="total"></span>&nbsp;行</a>'+
									'</li></ul></div>');
				
				setPageValue(pagination);
				bindPage(pagination);
				return pagination;
			}
			
			function setPageValue(pagination){
				if(newOptions.data.total <= newOptions.pageSize){
					pagination.find("li[id]").addClass("disabled v_disabled");
				} else if(pageNo == 1){
					pagination.find("li[id]").removeClass("disabled v_disabled");
					pagination.find("#pageUp").addClass("disabled v_disabled");
					pagination.find("#pageFrist").addClass("disabled v_disabled");
				}
				var pageTotalInit = Math.ceil(newOptions.data.total / newOptions.pageSize);
				var pageTotal = pageTotalInit == 0 ? 1 : pageTotalInit;
				pagination.find("#total").html(newOptions.data.total);
				pagination.find("#pageNo").html(pageNo);
				pagination.find("#pageTotal").html(pageTotal);
			}
			
			function bindPage(pagination){
				pagination.find("#pageFrist").bind("click", function(){
					if(!$(this).hasClass("disabled")){
						pageNo = 1;
						pagination.find("li[id]").removeClass("disabled v_disabled");
						$(this).addClass("disabled v_disabled");
						pagination.find("#pageUp").addClass("disabled");
						load();
					}
				});
				pagination.find("#pageUp").bind("click", function(){
					pageNo = parseInt(pagination.find("#pageNo").text());
					if(!$(this).hasClass("disabled") && pageNo - 1 != 0){
						pageNo = pageNo - 1;
						pagination.find("li[id]").removeClass("disabled v_disabled");
						if(pageNo == 1){
							$(this).addClass("disabled v_disabled");
							pagination.find("#pageFrist").addClass("disabled v_disabled");
						}
						load();
					}
				});
				pagination.find("#pageDown").bind("click", function(){
					var pageTotal = parseInt(pagination.find("#pageTotal").text());
					pageNo = parseInt(pagination.find("#pageNo").text());
					if(!$(this).hasClass("disabled v_disabled") && pageNo != pageTotal){
						pageNo = pageNo + 1;
						pagination.find("li[id]").removeClass("disabled v_disabled");
						if(pageNo == pageTotal){
							$(this).addClass("disabled v_disabled");
							pagination.find("#pageLast").addClass("disabled v_disabled");
						}
						load();
					}
				});
				pagination.find("#pageLast").bind("click", function(){
					if(!$(this).hasClass("disabled v_disabled")){
						var pageTotal = parseInt(pagination.find("#pageTotal").text());
						pageNo = pageTotal;
						pagination.find("li[id]").removeClass("disabled v_disabled");
						$(this).addClass("disabled v_disabled");
						pagination.find("#pageDown").addClass("disabled v_disabled");
						load();
					}
				});
			}

			function getSelections(rowIds){
				var data = me.data(gridId).data;
				var rows = [];
				if($.isArray(rowIds)){
					$.each(rowIds, function(i, rowId){
						var idField = me.data(gridId).idField;
						var index = me.find("tr td["+idField+"='"+rowId+"']").parent().attr("index");
						rows.push(data.data[index]);
					});
				} else {
					var selections = me.find("input[name='selectOne']:checked");
					$.each(selections,function(i,selectOne){
						var index = $(this).parent().parent().attr("index")
						rows.push(data.data[index]);
					});
				}
				return rows;
			}
			
			function getSelectIds(){
				var data = me.data(gridId).data;
				var idField = me.data(gridId).idField;
				var rows = [];
				var selections = me.find("input[name='selectOne']:checked");
				$.each(selections,function(i,selectOne){
					var index = $(this).parent().parent().attr("index")
					rows.push(data.data[index][idField]);
				});
				return rows;
			}
			
			function getSelection(rowId){
				var data = me.data(gridId).data;
				var index;
				if(rowId != undefined){
					var idField = me.data(gridId).idField;
					index = me.find("tr td["+idField+"='"+rowId+"']").parent().attr("index");
				} else {
					index = me.find("input[name='selectOne']:checked").parent().parent().attr("index");
				}
				return data.data[index];
			}
			
			function getSelectId(){
				var data = me.data(gridId).data;
				var idField = me.data(gridId).idField;
				var index = me.find("input[name='selectOne']:checked").parent().parent().attr("index");
				return data.data[index][idField];
			}
			
			function getAllData(){
				return me.data(gridId).data;
			}
			
			function addRow(row){
				var newOptions = me.data(gridId);
				var tbody = me.find("tbody");
				var lastTr = tbody.find("tr:last");
				var lastIndex = 0;
				if(lastTr.length > 0){
					lastIndex = parseInt(lastTr.attr("index"))+1;
				}
				
				var tr = $("<tr index=\"" + lastIndex + "\">");
				if(newOptions.checkbox){
					var checkbox = $('<input type="checkbox" name="selectOne" value="">');
					var td = $("<td>");
					td.css("text-align", "center");
					td.append(checkbox);
					td.attr("name","checkbox");
					tr.append(td);
				}
				if(newOptions.radio){
					var radio = $('<input type="radio" name="selectOne" value="">');
					var td = $("<td>");
					td.css("text-align", "center");
					td.attr("name","radio");
					td.append(radio);
					tr.append(td);
				}
				if(newOptions.rownum){
					++lastIndex;
					var td = $("<td>");
					td.attr("name","rownum");
					td.append(lastIndex);
					tr.append(td);
				}
				$.each(newOptions.columns,function(i,column){
					var td = $('<td>');
					if(column.align){
						td.css("text-align", column.align);
					}
					if(column.name == newOptions.idField){
						td.attr(newOptions.idField,"");
					} else if(column.editor != undefined && column.editor != null){
						td.attr("editorType",column.editor.type);
						addEditor(column.editor.type, column.name, td, tr);
					} else if("opt" != column.name) {
						if(row == undefined){
							td.attr("editorType","text");
							addEditor("text", column.name, td, tr);
						} else {
							var value = row[column.name] || '';
							td.append(value);
						}
					} else {
						td.attr("opt",true);
						if($.isFunction(column.render)){
							td.append(column.render({}));
						}
					}
					
					if(column.display != undefined && !column.display){
						td.hide();
					}
					td.attr("name",column.name);
					tr.attr("insert",true);
					tr.append(td);
				});
				if(newOptions.enableRowEditEvent){
					tr.bind("dblclick", dblclickTr);
					tr.bind("click", clickTr);
				}
				if(lastTr.attr("index") == -1){
					tr.replaceAll(lastTr);
				} else {
					tbody.append(tr);
				}
				var input = tr.find("input[type='text']").first();
				if(input.length > 0){
					input.focus();
				}
			}
			
			function addRowData(row){
				var newOptions = me.data(gridId);
				var tbody = me.find("tbody");
				var lastTr = tbody.find("tr:last");
				var lastIndex = 0;
				if(lastTr.length > 0){
					lastIndex = parseInt(lastTr.attr("index"))+1;
				}
				
				var tr = $("<tr index=\"" + lastIndex + "\">");
				if(newOptions.checkbox){
					var checkbox = $('<input type="checkbox" name="selectOne" value="">');
					var td = $("<td>");
					td.css("text-align", "center");
					td.append(checkbox);
					td.attr("name","checkbox");
					tr.append(td);
				}
				if(newOptions.radio){
					var radio = $('<input type="radio" name="selectOne" value="">');
					var td = $("<td>");
					td.css("text-align", "center");
					td.attr("name","radio");
					td.append(radio);
					tr.append(td);
				}
				if(newOptions.rownum){
					++lastIndex;
					var td = $("<td>");
					td.attr("name","rownum");
					td.append(lastIndex);
					tr.append(td);
				}
				$.each(newOptions.columns,function(i,column){
					var td = $('<td>');
					if(column.align){
						td.css("text-align", column.align);
					}
					if(column.name == newOptions.idField){
						td.attr(newOptions.idField,"");
					} else if(column.editor != undefined && column.editor != null){
						td.attr("editorType",column.editor.type);
						addEditor(column.editor.type, column.name, td, tr);
					} else if("opt" != column.name) {
						td.append(row[column.name]);
					} else {
						td.attr("opt",true);
						if($.isFunction(column.render)){
							td.append(column.render({}));
						}
					}
					
					if(column.display != undefined && !column.display){
						td.hide();
					}
					td.attr("name",column.name);
					tr.attr("insert",true);
					tr.append(td);
				});
				if(newOptions.enableRowEditEvent){
					tr.bind("dblclick", dblclickTr);
					tr.bind("click", clickTr);
				}
				if(lastTr.attr("index") == -1){
					tr.replaceAll(lastTr);
				} else {
					tbody.append(tr);
				}
				var input = tr.find("input[type='text']").first();
				if(input.length > 0){
					input.focus();
				}
			}
			
			function updateRow(row){
				var newOptions = me.data(gridId);
				var idField = newOptions.idField;
				var	tr = me.find("tr td["+idField+"='"+row[idField]+"']").parent();
				var index = tr.attr("index");
				newOptions.data = newOptions.data || {};
				newOptions.data.data = newOptions.data.data || [];
				newOptions.data.data[index] = newOptions.data.data[index] || {};
				$.extend(newOptions.data.data[index], row);
				
				$.each(newOptions.columns,function(i,column){
					var td = tr.find("td[name='"+column.name+"']");
					if(column.editor != undefined && column.editor != null && row[column.name] != undefined){
						switch(column.editor.type){
							case "text":
								td.find("input").val(row[column.name]);
								break;
							case "select":
								td.find("select option:selected").removeAttr("selected");
								td.find("select option").each(function(i, option){
									if(option.val()==row[column.name] || option.text()==row[column.name]){
										option.attr("selected", true);
										return false;
									}
								});
								break;
							case "date":
								td.find("input").val(row[column.name]);
								break;
						}
						showTitle(column, row, td);
					} else if(row[column.name] != undefined){
						var content;
						if($.isFunction(column.render)){
							content = column.render(row);
						} else {
							content = row[column.name];
						}
						td.html(content);
						showTitle(column, row, td);
					}
				});
			}
		}
	});
	
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
		},
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
				btnDiv.append(delBtn);
				btnDiv.append(cancelBtn);
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
	
	//from表单验证扩展
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
	}
	
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
	}
})(jQuery);

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

/**
 * var myDate = new Date();
 * myDate.getYear(); //获取当前年份(2位)
 * myDate.getFullYear(); //获取完整的年份(4位,1970-????)
 * myDate.getMonth(); //获取当前月份(0-11,0代表1月)
 * myDate.getDate(); //获取当前日(1-31)
 * myDate.getDay(); //获取当前星期X(0-6,0代表星期天)
 * myDate.getTime(); //获取当前时间(从1970.1.1开始的毫秒数)
 * myDate.getHours(); //获取当前小时数(0-23)
 * myDate.getMinutes(); //获取当前分钟数(0-59)
 * myDate.getSeconds(); //获取当前秒数(0-59)
 * myDate.getMilliseconds(); //获取当前毫秒数(0-999)
 * myDate.toLocaleDateString(); //获取当前日期
 * myDate.toLocaleTimeString(); //获取当前时间
 * myDate.toLocaleString( ); //获取日期与时间
 * 
 * 扩展方法
 * Date.prototype.isLeapYear 判断闰年
 * Date.prototype.format 日期格式化
 * Date.prototype.dateAdd 日期计算
 * Date.prototype.dateDiff 比较日期差
 * Date.prototype.toString 日期转字符串
 * Date.prototype.toArray 日期分割为数组
 * Date.prototype.datePart 取日期的部分信息
 * Date.prototype.maxDayOfDate 取日期所在月的最大天数
 * Date.prototype.weekNumOfYear 判断日期所在年的第几周
 * stringToDate 字符串转日期型
 * isValidDate 验证日期有效性
 * checkDateTime 完整日期时间检查
 * daysBetween 日期天数差
 */

//+---------------------------------------------------
// 判断闰年
//+---------------------------------------------------
Date.prototype.isLeapYear = function(){
	return (0==this.getYear()%4&&((this.getYear() % 100 != 0)||(this.getYear() % 400 == 0)));
}
//+---------------------------------------------------
// 日期格式化
// 格式 YYYY/yyyy/YY/yy 表示年份
// MM/M 月份
// W/w 星期
// dd/DD/d/D 日期
// hh/HH/h/H 时间
// mm/m 分钟
// ss/SS/s/S 秒
//+---------------------------------------------------
Date.prototype.format = function(formatStr){
	var str = formatStr;
	var Week = ['日','一','二','三','四','五','六'];
	
	str=str.replace(/yyyy|YYYY/,this.getFullYear());
	str=str.replace(/yy|YY/,(this.getYear() % 100)>9?(this.getYear() % 100).toString():'0' + (this.getYear() % 100));
	var month = this.getMonth()+1;
	str=str.replace(/MM/,month > 9 ? '' + month:'0' + month);
	str=str.replace(/M/g,month);
	
	str=str.replace(/w|W/g,Week[this.getDay()]);
	
	str=str.replace(/dd|DD/,this.getDate()>9?this.getDate().toString():'0' + this.getDate());
	str=str.replace(/d|D/g,this.getDate());
	
	str=str.replace(/hh|HH/,this.getHours()>9?this.getHours().toString():'0' + this.getHours());
	str=str.replace(/h|H/g,this.getHours());
	str=str.replace(/mm/,this.getMinutes()>9?this.getMinutes().toString():'0' + this.getMinutes());
	str=str.replace(/m/g,this.getMinutes());
	
	str=str.replace(/ss|SS/,this.getSeconds()>9?this.getSeconds().toString():'0' + this.getSeconds());
	str=str.replace(/s|S/g,this.getSeconds());
	
	return str;
}

//+---------------------------------------------------
//| 日期计算
//+---------------------------------------------------
Date.prototype.dateAdd = function(strInterval, Number) {
	var dtTmp = this;
	switch (strInterval) {
		case 's' :return new Date(Date.parse(dtTmp) + (1000 * Number));
		case 'n' :return new Date(Date.parse(dtTmp) + (60000 * Number));
		case 'h' :return new Date(Date.parse(dtTmp) + (3600000 * Number));
		case 'd' :return new Date(Date.parse(dtTmp) + (86400000 * Number));
		case 'w' :return new Date(Date.parse(dtTmp) + ((86400000 * 7) * Number));
		case 'q' :return new Date(dtTmp.getFullYear(), (dtTmp.getMonth()) + Number*3, dtTmp.getDate(), dtTmp.getHours(), dtTmp.getMinutes(), dtTmp.getSeconds());
		case 'm' :return new Date(dtTmp.getFullYear(), (dtTmp.getMonth()) + Number, dtTmp.getDate(), dtTmp.getHours(), dtTmp.getMinutes(), dtTmp.getSeconds());
		case 'y' :return new Date((dtTmp.getFullYear() + Number), dtTmp.getMonth(), dtTmp.getDate(), dtTmp.getHours(), dtTmp.getMinutes(), dtTmp.getSeconds());
	}
}

//+---------------------------------------------------
//| 比较日期差 dtEnd 格式为日期型或者 有效日期格式字符串
//+---------------------------------------------------
Date.prototype.dateDiff = function(strInterval, dtEnd) {
	var dtStart = this;
	//如果是字符串转换为日期型
	if (typeof dtEnd == 'string' ){
		dtEnd = StringToDate(dtEnd);
	}
	switch (strInterval) {
		case 's' :return parseInt((dtEnd - dtStart) / 1000);
		case 'n' :return parseInt((dtEnd - dtStart) / 60000);
		case 'h' :return parseInt((dtEnd - dtStart) / 3600000);
		case 'd' :return parseInt((dtEnd - dtStart) / 86400000);
		case 'w' :return parseInt((dtEnd - dtStart) / (86400000 * 7));
		case 'm' :return (dtEnd.getMonth()+1)+((dtEnd.getFullYear()-dtStart.getFullYear())*12) - (dtStart.getMonth()+1);
		case 'y' :return dtEnd.getFullYear() - dtStart.getFullYear();
	}
}

//+---------------------------------------------------
//| 日期输出字符串
//+---------------------------------------------------
Date.prototype.showString = function(showWeek){
	var myDate= this;
	var str = myDate.toLocaleDateString();
	if (showWeek){
		var Week = ['日','一','二','三','四','五','六'];
		str += ' 星期' + Week[myDate.getDay()];
	}
	return str;
}

//+---------------------------------------------------
//| 把日期分割成数组
//+---------------------------------------------------
Date.prototype.toArray = function(){
	var myDate = this;
	var myArray = Array();
	myArray[0] = myDate.getFullYear();
	myArray[1] = myDate.getMonth();
	myArray[2] = myDate.getDate();
	myArray[3] = myDate.getHours();
	myArray[4] = myDate.getMinutes();
	myArray[5] = myDate.getSeconds();
	return myArray;
}

//+---------------------------------------------------
//| 取得日期数据信息
//| 参数 interval 表示数据类型
//| y 年 m月 d日 w星期 ww周 h时 n分 s秒
//+---------------------------------------------------
Date.prototype.datePart = function(interval){
	var myDate = this;
	var partStr='';
	var Week = ['日','一','二','三','四','五','六'];
	switch (interval){
		case 'y' :partStr = myDate.getFullYear();break;
		case 'm' :partStr = myDate.getMonth()+1;break;
		case 'd' :partStr = myDate.getDate();break;
		case 'w' :partStr = Week[myDate.getDay()];break;
		case 'ww' :partStr = myDate.WeekNumOfYear();break;
		case 'h' :partStr = myDate.getHours();break;
		case 'n' :partStr = myDate.getMinutes();break;
		case 's' :partStr = myDate.getSeconds();break;
	}
	return partStr;
}

//+---------------------------------------------------
//| 取得当前日期所在月的最大天数
//+---------------------------------------------------
Date.prototype.maxDayOfDate = function(){
	var myDate = this;
	var ary = myDate.toArray();
	var date1 = (new Date(ary[0],ary[1]+1,1));
	var date2 = date1.dateAdd(1,'m',1);
	var result = dateDiff(date1.Format('yyyy-MM-dd'),date2.Format('yyyy-MM-dd'));
	return result;
}

//+---------------------------------------------------
//| 取得当前日期所在周是一年中的第几周
//+---------------------------------------------------
Date.prototype.weekNumOfYear = function(){
	var myDate = this;
	var ary = myDate.toArray();
	var year = ary[0];
	var month = ary[1]+1;
	var day = ary[2];
	document.write('< script language=VBScript\> \n');
	document.write('myDate = DateValue(\''+month+'-'+day+'-'+year+'\') \n');
	document.write('result = DatePart(\'ww\', myDate) \n');
	document.write(' \n');
	return result;
}
//+---------------------------------------------------
//| 求两个时间的天数差 日期格式为 YYYY-MM-dd
//+---------------------------------------------------
function daysBetween(DateOne,DateTwo){
	var OneMonth = DateOne.substring(5,DateOne.lastIndexOf ('-'));
	var OneDay = DateOne.substring(DateOne.length,DateOne.lastIndexOf ('-')+1);
	var OneYear = DateOne.substring(0,DateOne.indexOf ('-'));
	
	var TwoMonth = DateTwo.substring(5,DateTwo.lastIndexOf ('-'));
	var TwoDay = DateTwo.substring(DateTwo.length,DateTwo.lastIndexOf ('-')+1);
	var TwoYear = DateTwo.substring(0,DateTwo.indexOf ('-'));
	
	var cha=((Date.parse(OneMonth+'/'+OneDay+'/'+OneYear)- Date.parse(TwoMonth+'/'+TwoDay+'/'+TwoYear))/86400000);
	return Math.abs(cha);
}

//+---------------------------------------------------
//| 日期合法性验证
//| 格式为：YYYY-MM-DD或YYYY/MM/DD
//+---------------------------------------------------
function isValidDate(DateStr){
	var sDate=DateStr.replace(/(^\s+|\s+$)/g,''); //去两边空格;
	if(sDate==''){
		return true;
	}
	//如果格式满足YYYY-(/)MM-(/)DD或YYYY-(/)M-(/)DD或YYYY-(/)M-(/)D或YYYY-(/)MM-(/)D就替换为''
	//数据库中，合法日期可以是:YYYY-MM/DD(2003-3/21),数据库会自动转换为YYYY-MM-DD格式
	var s = sDate.replace(/[\d]{ 4,4 }[\-/]{ 1 }[\d]{ 1,2 }[\-/]{ 1 }[\d]{ 1,2 }/g,'');
	//说明格式满足YYYY-MM-DD或YYYY-M-DD或YYYY-M-D或YYYY-MM-D
	if (s=='') {
		var t=new Date(sDate.replace(/\-/g,'/'));
		var ar = sDate.split(/[-/:]/);
		if(ar[0] != t.getYear() || ar[1] != t.getMonth()+1 || ar[2] != t.getDate()){
		//alert('错误的日期格式！格式为：YYYY-MM-DD或YYYY/MM/DD。注意闰年。');
		return false;
		}
	} else {
		//alert('错误的日期格式！格式为：YYYY-MM-DD或YYYY/MM/DD。注意闰年。');
		return false;
	}
	return true;
}

//+---------------------------------------------------
//| 日期时间检查
//| 格式为：YYYY-MM-DD HH:MM:SS
//+---------------------------------------------------
function checkDateTime(str){
	var reg = /^(\d+)-(\d{ 1,2 })-(\d{ 1,2 }) (\d{ 1,2 }):(\d{ 1,2 }):(\d{ 1,2 })$/;
	var r = str.match(reg);
	if(r==null)return false;
	r[2]=r[2]-1;
	var d= new Date(r[1],r[2],r[3],r[4],r[5],r[6]);
	if(d.getFullYear()!=r[1])return false;
	if(d.getMonth()!=r[2])return false;
	if(d.getDate()!=r[3])return false;
	if(d.getHours()!=r[4])return false;
	if(d.getMinutes()!=r[5])return false;
	if(d.getSeconds()!=r[6])return false;
	return true;
}
//+---------------------------------------------------
//| 字符串转成日期类型
//| 格式 MM/dd/YYYY MM-dd-YYYY YYYY/MM/dd YYYY-MM-dd
//+---------------------------------------------------
function stringToDate(DateStr){
	var converted = Date.parse(DateStr);
	var myDate = new Date(converted);
	if (isNaN(myDate)){
		//var delimCahar = DateStr.indexOf('/')!=-1?'/':'-';
		var arys= DateStr.split('-');
		myDate = new Date(arys[0],--arys[1],arys[2]);
	}
	return myDate;
}

/*var _hmt = _hmt || [];
(function() {
  var hm = document.createElement("script");
  hm.src = "//hm.baidu.com/hm.js?57149b29ad6693e08127a2fede1117bd";
  var s = document.getElementsByTagName("script")[0]; 
  s.parentNode.insertBefore(hm, s);
})();
*/
