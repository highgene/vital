/* =========================================================
 * kq-calendar.js
 * =========================================================
 * Improvement by WangJS @2014-12-1
 * Refactoring by WangJS @2015-1-30
 * 考勤统计前端UI组件
 */
(function ($) {

	var eCalendar = function (options, object) {
		
		var enableToday = true;	//是否应用当日 可作为查询当月与历史月份的标识依据
        var settings = $.extend({}, $.fn.eCalendar.defaults, options);
		var currentTime = initDate(settings.currentTime);
		
		// 初始化全局变量	
		//ad-XX为数字应用于计算
        var adDay = currentTime.getDate();
        var adMonth = currentTime.getMonth();
        var adYear = currentTime.getFullYear();
        
        //d-XX为字符串形式 用于适配日期格式YYYY-MM-DD，如“2014-01-07”
        var dDay = adDay < 10 ? "0" + adDay : adDay;
        var dMonth = adMonth+1 < 10 ? "0"+(adMonth+1) : adMonth+1;
        var dYear = adYear;
        
        //当前Dom对象
        var instance = object;
        
        //工作日设置，及特殊工作日调整设置
        var weekparam = ["sundayWorking","mondayWorking","tuesdayWorking","wednesdayWorking","thursdayWorking","fridayWorking","saturdayWorking"];
        var kq_WorkDay = new Array();
        
        //日期生成函数
        function initDate(param){
			var date;
			if(typeof param != Date){  //支持’yyyy-MM-dd'的日期字符串输入
				 date = new Date(param); 
			}
			var today = new Date();
			if(today.getMonth() == date.getMonth() && today.getFullYear() == date.getFullYear()){
				date = today;
			}else{
				enableToday = false;
			}
			return date;
		}
        
        //查询按钮事件函数
        var buttonEvent = function() {
        	var year = $("#selectYear",instance).val();
        	var month = $("#selectMonth",instance).val();
        	instance.eCalendar({
        		url : settings.url,
        		recordURL : settings.recordURL,
        		workDayURL : settings.workDayURL,
        		workSetURL : settings.workSetURL,
        		currentTime : new Date(year,month-1,1)
        	});
        }
        
        //日期点击查询事件
        var clickEvent = function() {
			if($(".c-event-grid").is(":hidden")){		
				$(this).addClass('c-mouse-over');			       
				var d = $(this).attr('data-event-day');
				loadRecord(dYear,dMonth,d);
				$('div.c-event-item[data-event-day="' + d + '"]').addClass('c-event-over');
			}else{
				if($(this).hasClass("c-mouse-over")){
					$(this).removeClass('c-mouse-over');
					var d = $(this).attr('data-event-day');
					$('div.c-event-item[data-event-day="' + d + '"]').removeClass('c-event-over');
					$('div.c-event-body').empty();
				}else{
					var last = $(this).parent().find(".c-mouse-over");
					last.removeClass("c-mouse-over");
					var ld = $(last).attr('data-event-day');
					$('div.c-event-item[data-event-day="' + ld + '"]').removeClass('c-event-over');
					$('div.c-event-body').empty();
					
					$(this).addClass('c-mouse-over');			       
					var d = $(this).attr('data-event-day');
					loadRecord(dYear,dMonth,d);
					$('div.c-event-item[data-event-day="' + d + '"]').addClass('c-event-over');
				}
			}		
		}
        
		//获取考勤表必要信息
		function loadEvents() {
        	var workMonth = dYear + "-" + dMonth;
            if (typeof settings.url != 'undefined' && settings.url != '') {
                $.ajax({
					url: settings.url + "/" + workMonth,
                    async: false,
                    data : {userId:settings.userId},
					method : "get",
                    success: function (result) {
                        settings.events = result;
                    },
                    error: function(XMLHttpRequest, textStatus, errorThrown) {
                        if(XMLHttpRequest.status == 401){
                        	alert("授权码已失效，无法获取考勤信息，请重新登陆");
                        }else{
                        	alert("获取考勤记录信息失败");
                        }
                    },
                });
                $.ajax({
                	url : settings.workDayURL,
                	type : "get",
                	async: false,
                	success : function(json){
                		$(weekparam).each(function(index,item){
                			//初始化工作日配置信息
                			weekparam[index] = json[weekparam[index]] == 0 ? true : false;
                		});
                	},
                	error: function() {
                        alert("获取工作日配置信息失败");
                    }
                });
                $.ajax({
                	url : settings.workSetURL,
                	type : "get",
                	async: false,
                	data : {"workingMonth": workMonth},
                	success : function(json){
                		$(json).each(function(index,item){
                			//获取例外工作日或节假日配置信息
                			kq_WorkDay.push({"day" : new Date(item.setDay).getDate(),"isWork": item.isWorkingDay == 0});
                		});
                	},
                	error: function() {
                        alert("获取工作日配置信息失败");
                    }
                });
            }
        }
		
        //获取指定日的打卡记录
		function loadRecord(year,month,day) {
        	if(typeof settings.recordURL == "undefined" || settings.recordURL === '')
        		return;		//未指定打卡记录路径 不去请求数据
        	if(typeof day == 'undefined' || day === ''){
        		var eventList = init_kqEventData(new Array());
                $('div.c-event-body').append(eventList);
        		return;
        	}
        	
        	var date = year + "-" + month + "-" + day; 
        	$.ajax({
        		url : settings.recordURL,
        		method : "get",
        		data : { "workDate" : date , userId:settings.userId},
        		success : function(json){},
        		error: function(XMLHttpRequest, textStatus, errorThrown) {
                    if(XMLHttpRequest.status == 401){
                    	alert("授权码已失效，请重新登陆");
                    }else{
                    	alert("获取打卡记录信息失败");
                    }
                },
        	}).done(function(data){
        		 var eventList = init_kqEventData(data);
                 $('div.c-event-body').append(eventList);
        	})
        }
		
        //显示每日打卡事件
        function init_kqEventData(data){
        	var eventList = $('<div/>').addClass('c-event-list');
        	if(data.length == 0){
        		var item = $('<div/>').addClass('c-event-item');
        		var time = $('<div/>').addClass('title').html('当日无打卡记录');
        		item.append(time);
        		eventList.append(item);
        	}else{
        		for (var i = 0; i < data.length; i++) {
                    var d = new Date(data[i].clockInTime.replace(/-/g,"/"));
                    var item = $('<div/>').addClass('c-event-item');
                    var time = $('<div/>').addClass('title').html('时间：' + data[i].clockInTime + '<br/>');
                    var position = $('<div/>').addClass('description').html('位置： 经度:' + data[i].longitude + '   纬度：' + data[i].latitude + '<br/>');
					var place = $('<div/>').addClass('description').html('打卡地点：' + data[i].clockInAddress + '<br/><br/>');
					if(data[i].effective == 1) {
						time.addClass("c-error");
						position.addClass('c-error');
						place.addClass('c-error');
					}
					item.attr('data-event-day', d.getDate());
					item.append(time).append(position).append(place);
					eventList.append(item);
                }
        	}
            return eventList;
        }
        
        //考勤表表头生成
        function createCalendarTitle() {
        	var cMonth = $('<div/>').addClass('c-month c-grid-title');
            var year_select = $("<select/>");
            var month_select = $("<select/>");
            var queryBtn = $("<button/>");
            var toyear = new Date().getFullYear();
        	for(var i=1;i<13;i++){
        		month_select.append("<option value='"+ i +"'>"+i+"</option>");
        	}
        	for(var i=2011;i< toyear+2 ;i++){
        		year_select.append("<option value='"+ i +"'>"+i+"</option>");
        	}
        	year_select.attr('id','selectYear').val(adYear);
        	month_select.attr('id','selectMonth').val(adMonth+1);
        	queryBtn.attr("id","CalendarBtn").addClass("btn btn-sm btn-default").html(" 查询 ");
        	queryBtn.on("click",buttonEvent);
            cMonth.append(year_select).append(' 年 ').append(month_select).append(' 月 ').append(queryBtn);
            return cMonth;
        }
        
        //考勤表图例
        function createCalendarDemo(){
        	var cPrevious = $('<div/>').addClass('c-previous c-grid-title c-pad-top');
        	
        	var normal = $('<div/>');
        	var normal_color = $('<div/>').addClass('normal').html('出勤');
        	normal.append(normal_color);
        	
        	var error = $('<div/>');
        	var error_color = $('<div/>').addClass('error').html('迟到/早退');
        	error.append(error_color);
        	
        	var trip = $('<div/>');
        	var trip_color = $('<div/>').addClass('trip').html('出差');
        	trip.append(trip_color);
        	
        	var leave = $('<div/>');
        	var leave_color = $('<div/>').addClass('leave').html('请假');
        	leave.append(leave_color);
        	
        	var absence = $('<div/>');
        	var absence_color = $('<div/>').addClass('absence').html('缺勤');
        	absence.append(absence_color);
        	
        	var today = $('<div/>');
        	var today_color = $('<div/>').addClass('today').html('今日');
        	today.append(today_color);
        	
            cPrevious.append(normal).append(error).append(trip).append(leave).append(absence).append(today);
            return cPrevious;
        }
        
        //考勤表生成
        function print(){
        	loadEvents();
            var dWeekDayOfMonthStart = new Date(adYear, adMonth, 1).getDay();
            var dLastDayOfMonth = new Date(adYear, adMonth + 1, 0).getDate();
            var dLastDayOfPreviousMonth = new Date(dYear, dMonth, 0).getDate() - dWeekDayOfMonthStart + 1;
            
            var cBody = $('<div/>').addClass('c-grid');
            var cEvents = $('<div/>').addClass('c-event-grid');
            var cEventsBody = $('<div/>').addClass('c-event-body');
            cEvents.append($('<div/>').addClass('c-event-title c-pad-top').html(settings.eventTitle));
            cEvents.append(cEventsBody);
            var cMonth = createCalendarTitle();
            var cPrevious = createCalendarDemo();
            cBody.append(cPrevious);
            cBody.append(cMonth);
            for (var i = 0; i < settings.weekDays.length; i++) {
                var cWeekDay = $('<div/>').addClass('c-week-day');
                cWeekDay.html(settings.weekDays[i]);
                cBody.append(cWeekDay);
            }
            var day = 1;
            var str_day;
            var dayOfNextMonth = 1;
            for (var i = 0; i < 42; i++) {
                var cDay = $('<div/>');
				var start = $('<div/>').attr("title","正常");	//定义考勤DIV
				var date = $('<div/>');
				var end = $('<div/>').attr("title","正常");
				//处理当本月以周日开始时，考勤日历表只显示下一个月日期的情况
				if (dWeekDayOfMonthStart == 0 && i < 7){	
					cDay.addClass('c-day-previous-month');
					start.addClass('c-time-field-miss');
					date.html(dLastDayOfPreviousMonth - 7 + i);
					end.addClass('c-time-field-miss');
                    cDay.append(start).append(date).append(end);
				}else if (i < dWeekDayOfMonthStart) {
                    cDay.addClass('c-day-previous-month');
					start.addClass('c-time-field-miss');
					date.html(dLastDayOfPreviousMonth++);
					end.addClass('c-time-field-miss');
                    cDay.append(start).append(date).append(end);
                } else if (day <= dLastDayOfMonth) {
                	var flag = false;	//是否拥有今天对应数据的标识
                	//着色今天
                    if (enableToday && day == adDay) {
                        cDay.addClass('c-today');
                    }
                    /*------------循环后台数据配置前端考勤表日期状态  start------------*/
                    for (var j = 0; j < settings.events.length; j++) {
                        var d = new Date(settings.events[j].workDate.replace(/-/g,"/"));
                        if (d.getDate() == day && d.getMonth() == adMonth && d.getFullYear() == adYear) {
                        	if(settings.events[j].dayState == "1"){
								cDay.addClass('c-event-error');
								cDay.attr("title","缺勤");
								start.removeAttr("title");
								end.removeAttr("title");
							}else if(settings.events[j].dayState == "2"){
								cDay.addClass('c-event-normal');
								cDay.attr("title","迟到/早退");
								if(settings.events[j].inTimeState == '1'){
									start.addClass('error');
									start.attr("title","迟到");
								}
								if(settings.events[j].offTimeState == '3'){
									end.addClass('error');
									end.attr("title","早退");
								}
							}else if(settings.events[j].dayState == "3"){
								cDay.addClass('c-event-leave');
								cDay.attr("title","请假");
							}else if(settings.events[j].dayState == "4"){
								cDay.addClass('c-event-trip');
								cDay.attr("title","出差");
							}else if(settings.events[j].dayState == "0"){
								cDay.addClass('c-event-normal');
								cDay.attr("title","出勤");
							}
                        	
							//是否显示上下班打卡事件取决于后台是否有上下班打卡数据
							if(settings.events[j].clockInTime == null || 
									settings.events[j].clockInTime == ''){
								start.addClass("c-time-field-miss");
								start.removeAttr("title");
							}else{
								start.addClass('c-time-field');
								start.html(settings.events[j].clockInTime);
							}
							if(settings.events[j].clockOffTime == null || 
									settings.events[j].clockOffTime == ''){
								end.addClass("c-time-field-miss");
								end.removeAttr("title");
							}else{
								end.addClass('c-time-field');
								end.html(settings.events[j].clockOffTime);
							}
							date.addClass('c-date-field');
							flag = true;	//设置当日有数据，不启用自动补全机制
                        }
                    }
					/*------------循环后台数据配置前端考勤表日期状态  end------------*/
                    if(flag){									
						cDay.append(start).append(date).append(end);
					}else{
						//自动数据补全机制，for:后台无考勤数据及打卡结算数据则为缺勤）
						//结合工作日设置数据，处理无打卡数据的自然日显示信息
						var targetDay = enableToday ? adDay : dLastDayOfMonth;
						
						var isWorkDay = weekparam[i % 7];
						$(kq_WorkDay).each(function(index,item){
							if(day == item.day){
								isWorkDay = item.isWork;	//查找当前日期是否属于工作日特殊设置队列
							}
						});
						//当月及历史月自动补全不存在考勤记录的自然天 状态为缺勤
						if(day <= targetDay && currentTime <= new Date()){
							if(isWorkDay && day < targetDay){
								cDay.addClass('c-event-error');
								cDay.attr("title","缺勤");
								start.removeAttr("title");
								end.removeAttr("title");
							}
							if(day == targetDay){
								//是否查询当月数据对于的“今日”状态的区别
								if(enableToday){//区别是否为当前月，若是当前月则为今天，数据未结算，不进行补全
									cDay.attr('data-event-day', day);
								}else{
									if(isWorkDay){
										cDay.addClass('c-event-error');
										cDay.attr("title","缺勤");
										cDay.attr('data-event-day', day);
										start.removeAttr("title");
										end.removeAttr("title");
									}
								}
							}
						}
						start.addClass('c-time-field-miss');
						end.addClass('c-time-field-miss');
						cDay.append(start).append(date).append(end);
					}
                    str_day = day < 10 ? "0" + day : "" + day;	//天的日期格式适配
					date.html(day++);
					cDay.attr('data-event-day', str_day);
					cDay.addClass('c-day').on('click', clickEvent);
                } else {
					cDay.addClass('c-day-next-month');
					start.addClass('c-time-field-miss');
					date.html(dayOfNextMonth++);
					end.addClass('c-time-field-miss');
                    cDay.append(start).append(date).append(end);
                }
                cBody.append(cDay);
           }
            
           //若不是查询当月则不默认显示当日的打卡数据
           if(enableToday){	
            	$.ajax({
            		url : settings.recordURL,
            		method : "get",
            		data : { "workDate" : dYear + "-" + dMonth + "-" + dDay ,userId:settings.userId},
            		success : function(json){},
            		error: function(XMLHttpRequest, textStatus, errorThrown) {
                        alert("获取今日打卡记录信息失败");
                    },
            	}).done(function(data){
            		 var eventList = init_kqEventData(data);
                     $(cEventsBody).append(eventList);
            	});
           } 
           $(instance).addClass('calendar');
           $(instance).html(cBody);
           $(instance).height($(instance).parent().parent().height() - 180);
           if($(instance).height() < 500){
        	   $(instance).height(500);
           }
           $(instance).append(cEvents);
        }
        
        return print();
	}
	
	$.fn.eCalendar = function (oInit) {
        return this.each(function () {
            return eCalendar(oInit, $(this));
        });
    };
    
    $.fn.eCalendar.defaults = {
		currentTime : new Date(),//'2014-12-10'
        weekDays: ['周日', '周一', '周二', '周三', '周四', '周五', '周六'],
        eventTitle: '当日打卡记录',
        url: '',
        recordURL : '',
        workDayURL : '',
        workSetURL : '',
        userId:'',
        events:[]
    };
})(jQuery);
