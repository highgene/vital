/* 
 * fweb.datagrid.js
 * author: zhangbaojian
 * Date: 2014-10-28
 */
(function($) {
	$.fn.extend({
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
						addRow();
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
				//表格列[{{字段，表头，宽度，位置，是否鼠标放上显示表格内容数据，是否排序，是否显示，根据表格分辨率显示级别(xs/sm/md/lg/ml)，合并行的级别，渲染回调函数，行编辑类型(text/select/myself/date,选项，点击事件，示例：{type:"select",options:{value:"sexValue",text:"sexText",data/url:sexData})}]
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
						url = url + "?pageIndex=" + (pageNo - 1) + "&pageSize="+ newOptions.pageSize
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
					if(column.showContent){
						td.attr("title",render);
					}
				} else if(typeof column.render === "function"){
					var render = column.render(row);
					td.append(render);
					if(column.showContent){
						td.attr("title",render);
					}
				} else {
					td.append(row[column.name]);
					if(column.showContent){
						td.attr("title",row[column.name]);
					}
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
			
			function addRow(){
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
						td.attr("editorType","text");
						addEditor("text", column.name, td, tr);
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
						if(column.showContent){
							td.attr("title",row[column.name]);
						}
					} else if(row[column.name] != undefined){
						var content;
						if($.isFunction(column.render)){
							content = column.render(row);
						} else {
							content = row[column.name];
						}
						td.html(content);
						if(column.showContent){
							td.attr("title",content);
						}
					}
				});
			}
		}
	});
})(jQuery);