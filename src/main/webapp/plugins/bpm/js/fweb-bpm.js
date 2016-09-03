/**
 * 插件说明：流程操作接口，提供流程的发起、传递（完成任务）、取回、认领任务、 委托、转发、获取当前任务表单项配置等。
 * 
 * 作 者：lihuiming
 * 
 * 创建日期：2014.11.11
 * 
 * 一、参数说明 1. 流程操作选项 
 * options :{ 
 * 		//应用跟路径或者流程服务路径 
 * 		basePath: "", 
 * 		//执行成功后回调方法
 * 		success: function (data){}, 
 * 		//流程相关参数和变量 
 * 		variables : {}, 
 * 		//业务表单Id 
 * 		formId:"",
 *		//日志表格容器 
 *		logTableId:"", 
 *		//流程图容器Id 
 *		imgId:"" , 
 *      //业务表单提交方法
 *      businessSubmitFun:""
 * } 
 * 2. * 流程相关参数和变量 
 * variables:{ 
 * 		//流程名称 
 * 		name : "" , 
 * 		//流程定义的key 
 * 		processKey : "", 
 * 		//流程定义id
 * 		processDefinitionId: "", 
 * 		//流程实例id 
 * 		processInstanceId: "" , 
 * 		//业务标识，可以使用业务数据的ID
 * 		businessKey : "", 
 * 		//任务id 
 *      taskId : "", 
 * 		//认领任务的人的id 
 * 		claimUserId:"", 
 * 		//下一步活动
 * 		nextActivity : "", 
 * 		//下一任务接收人 
 * 		nextReceivers : {} , 
 * 		//任务操作原因 , 意见
 * 		reason:"" 
 * } 
 * 3. * 下一环节任务处理人 
 * nextReceivers:{  任务名称: userid, 任务名称2: userid2 ... } 
 * 
 * 二、要求和约束 1.
 * 使用流程服务的业务，其业务表必须有以下字段： 
 *  1) process_instance_id (length :32 char ) 
 *  2) task_name (length :200 char)
 *  3) task_man (length :32 char) 
 *  4) process_status (length :32 char)
 * 
 */
;
var $ = jQuery;
var businessSubmitFun = null;
/**
 * 
 * //业务表单的id formId:"", //下一活动显示为下拉框的容器id, 或者按钮 nextTransitionSelectId:"",
 * //下一活动显示为按钮的容器id nextTransitionButtonId:"", //日志表格id logTableId:""
 */
function BPM() {};

/**
 * 初始化流程
 */
BPM.prototype.init = function(options) {
	options.log = this.queryLog;
	this.processKey = options.variables.processKey;
	if(typeof(options.formId) != 'undefined')
		this.businessForm = $("#" + options.formId);
	
	if(typeof(options.businessSubmitFun) != 'undefined')
		businessSubmitFun = options.businessSubmitFun;
	
	options.bpm = BPM.prototype;

	var processInstanceId = $("input[name=processInstanceId]").val();
	var taskId = this.getTaskId(processInstanceId);
	if (taskId != null && taskId.length > 0) {
		this.loadProcessStatus(options , taskId);
	} else {
		this.startProcess(options);
	}
	
};
/**
 * 启动新流程
 */
BPM.prototype.startProcess = function(options) {
	var startProcessUrl = getPath(options.basePath) + "bpm/process";
	$.ajax({
		url : startProcessUrl,
		type : 'post',
		data : $.toJSON(options.variables),
		contentType : 'application/json;charset=UTF-8',
		success : function(data) {
			if (typeof (options.success) != 'undefined') {
				options.success(data);
			}
			options.variables['processInstanceId']=data.instanceId;
			options.variables = $.extend({},options.variables, data);
			options.bpm.loadProcessStatus(options);
		},
		error : function() {
			$.alert("error", "启动流程失败！");
		}
	});
};
/**
 * 加载流程状态信息
 */
BPM.prototype.loadProcessStatus = function (options){
	//显示流程图
	if(typeof(options.imgId) != 'undefined')
		this.showImg(options);
	//显示流程日志
	if(typeof(options.logTableId) != 'undefined')
		this.queryLog(options);

};
var bpmOptions;
BPM.prototype.execute =function (options){
	options.bpm = this;
	bpmOptions = options;
	var height = 280;
	//if(typeof(bpmOptions.opinion) == 'undefined' || !bpmOptions.opinion)
	//	height = 300;
	
	url = getPath(options.basePath) + "view/bpm/runtime/process.html";
	$.openWindow({
		id : "processDialog",
		width : 800,
		height : height,
		destroy : true,
		url : url,
		title : "提交流程",
		showDefaultButton : false,
		onAfterHidden:options.onAfterHidden
	});

};
//加载流程页面 传入流程参数，加载页面的标签ID：loadId,流程的URL，如果自定义样式，可以copy：view/bpm/runtime/process.html进行修改，然后以loadUrl传给流程
BPM.prototype.executeLoad =function (options, callback){
	options.bpm = this;
	bpmOptions = options;
	var insertTag = $("#"+options.loadId);
	var loadUrl = options.loadUrl || (getPath(options.basePath) + "view/bpm/runtime/process.html");
	insertTag.load(loadUrl,function(){
		if($.isFunction(callback)){
			callback();
		}
	});
}
/**
 * 填充表单
 * processInstanceId、taskName、taskMan、processStatus
 */
BPM.prototype.fillForm= function(options){
	var items = ["processInstanceId","taskName","taskMan","processStatus"];
	for(var i = 0; i < items.length; i++){
		var formItem = $("#"+options.formId+" > input[name="+items[i]+"]");
		var value = getValue(options, items[i]);
		if(formItem.length == 0){
			
			var itemHtml = "<input type=\"hidden\" id=\""+items[i]+"\" name=\""+items[i]+"\" value=\""+value+"\">";
			$("#"+options.formId).append(itemHtml);
		}else{
			
			$("#"+options.formId+" > input[name="+items[i]+"]").val(value);
		}
	}
};

function getValue(options , itemName ){
	var value = null;
	switch(itemName){
		case "processInstanceId":
			value =  options.variables.processInstanceId;
			break;
		case "taskName":
			if(options.currentTasks != null){
				value = options.currentTasks[0].name;
			}else{
				value = "完成";
			}
				
			break;
		case "taskMan":
			if(options.currentTasks != null){
				value = options.currentTasks[0].assignee;
			}else{
				value = "";
			}
					
			break;
		case "processStatus":
			value = options.status;
			break;
	}
	return value ;
}

function getAssignee(leaveTransition, taskKey){
	var selectHtml = "";
	var assigneeList = leaveTransition.taskConfig.assigneeList;
	var inputType = "radio";
	if(leaveTransition.taskConfig.multiInstance)
		inputType = "checkbox";
		
	for(var i =0; i < assigneeList.length; i++){
		var user = assigneeList[i];
		selectHtml += "<input type='"+inputType+"' name='assignee_"+taskKey+"' value="+user.id+">"+user.realName+"</input><br/>";
	}
	selectHtml += "<button class='btn btn-sm btn-success' onclick=execute('"+taskKey+"')><span class='bigger-110'>确定</span></button>";
	return selectHtml;
}


/**
 * 从url中取出taskId
 */
BPM.prototype.getTaskId = function(processInstanceId) {
	var taskId = null;
	var url = location.search;

	if (url.indexOf("?") != -1) {
		var str = url.substr(1);
		var params = str.split("&");
		for ( var i = 0; i < params.length; i++) {
			var kv = params[i].split("=");
			if (kv[0] == 'taskId')
				return kv[1];
		}
	}
	
	return taskId;
};
/**
 * 获取当前流程待办地址,并回调业务方法
 */
BPM.prototype.todoUrl = function(options ){
	var url = getPath(options.basePath)+'/bpm/todoUrl';
	var data = $.toJSON(options.variables);
	$.ajax({
		url : url,
		type : 'get',
		data : data,
		contentType : 'application/json;charset=UTF-8',
		success : function(data) {
			if (typeof (options.success) != 'undefined')
				options.success(data);
		},
		error : function() {
			$.alert("error", "获取待办地址失败！");
		}
	});
};
/**
 * 通过流程定义的key 启动一个新流程 如果流程实例已经存在，则推进流程
 * 
 * options:{basePath,
 * 
 * variables{ name, processKey, taskId , processInstanceId, nextActivity,
 * nextReceivers, todoUrl }, success}
 */
BPM.prototype.process = function(options) {
	var url = "";
	if (typeof (options.variables.processInstanceId) != "undefined"
			&& options.variables.processInstanceId != ""
			&& typeof (options.variables.taskId) != "undefined"
			&& options.variables.taskId != "") {
		url = getPath(options.basePath) + "bpm/tasks/complete";
	} else {
		url = getPath(options.basePath) + "bpm/process";
	}

	$.ajax({
		url : url,
		type : 'post',
		data : $.toJSON(options.variables),
		contentType : 'application/json;charset=UTF-8',
		success : function(data) {
			data.bpm= options.bpm;
			data.formId = options.formId;
			data.variables=options.variables;
			window.parent.$('#processDialog').modal('hide');
			if(typeof(options.bpm.fillForm) != 'undefined')
				options.bpm.fillForm(data);
			
			if (typeof (options.success) != 'undefined')
				options.success(data);
		},
		error : function() {
			$.alert("error", "执行失败！");
		}
	});
};
/**
 * 更新流程实例的名称，业务key options:{basePath,variables:{name , businessKey ,
 * processInstanceId},success}
 */
BPM.prototype.update = function(options) {
	$.ajax({
		url : getPath(options.basePath) + "bpm/process",
		type : 'put',
		data : $.toJSON(options.variables),
		contentType : 'application/json;charset=UTF-8',
		success : function(data) {
			if (typeof (options.success) != 'undefined')
				options.success(data);

		},
		error : function() {
			$.alert("error", "执行失败！");
		}
	});

};
/**
 * 加载流程日志
 */
BPM.prototype.queryLog = function (option) {
	var url = getPath(option.basePath) + "bpm/log/" + option.variables.processInstanceId;
	$("#logGrid").dataGrid({
		
		checkbox : false,
		url : url,
		type : "get",
		align : "center",
		pagination : false,
		rownum : false,
		pageSize : 50,
		columns : [ {
			name : "name",
			title : "任务名称"
		}, {
			name : "assigneeName",
			title : "处理人"
		}, {
			name : "endTime",
			title : "处理时间"
		}, {
			name : "description",
			title : "备注"
		} ]
	});
};
/**
 * 通过流程定义id 启动一个新流程.
 * options:{basePath,variables:{name,processDefinitionId},success}
 */
BPM.prototype.startProcessById = function(options) {
	$.ajax({
		url : getPath(options.basePath) + "bpm/process/id",
		type : 'post',
		data : $.toJSON(options.variables),
		contentType : 'application/json;charset=UTF-8',
		success : function(data) {
			if (typeof (options.success) != 'undefined')
				options.success(data);

		},
		error : function() {
			$.alert("error", "执行失败！");
		}
	});
};

/**
 * 获取流程日志. options:{basePath,variables:{processInstanceId},success}
 */
BPM.prototype.processLog = function(options) {
	$.ajax({
		url : getPath(options.basePath) + "bpm/log/"
				+ options.variables.processInstanceId,
		type : 'get',
		contentType : 'application/json;charset=UTF-8',
		success : function(data) {
			if (typeof (options.success) != 'undefined')
				options.success(data);
		},
		error : function() {
			$.alert("error", "执行失败！");
		}
	});

};
/**
 * 获取流程当前状态. options:{basePath,variables:{processInstanceId},success}
 */
BPM.prototype.getStatus = function(options) {
	$.ajax({
		url : getPath(options.basePath) + "bpm/status/"
				+ options.variables.processInstanceId,
		type : 'get',
		contentType : 'application/json;charset=UTF-8',
		success : function(data) {
			if (typeof (options.success) != 'undefined')
				options.success(data);
		},
		error : function() {
			$.alert("error", "执行失败！");
		}
	});

};
/**
 * 获取流程当前状态. options:{basePath,variables:{deinitionKey},success}
 */
BPM.prototype.getFirstTaskUsers = function(options) {
	$.ajax({
		url : getPath(options.basePath) + "bpm/firstTaskUsers/"
				+ options.variables.deinitionKey,
		type : 'get',
		contentType : 'application/json;charset=UTF-8',
		success : function(data) {
			if (typeof (options.success) != 'undefined')
				options.success(data);
		},
		error : function() {
			$.alert("error", "执行失败！");
		}
	});

};

/**
 * 用户认领任务 options:{basePath,variables:{taskId,claimUserId}}
 */
BPM.prototype.claimTask = function() {
	$.ajax({
		url : getPath(options.basePath) + "bpm/tasks/claim"
				+ options.variables.processInstanceId,
		type : 'post',
		contentType : 'application/json;charset=UTF-8',
		success : function(data) {
			if (typeof (options.success) != 'undefined')
				options.success(data);
		},
		error : function() {
			$.alert("error", "执行失败！");
		}
	});

},
/**
 * 取回流程，在流程任务未被处理时可以取回.
 * options:{basePath,variables:{processInstanceId},success}
 */
BPM.prototype.retake = function(options) {
	$.ajax({
		url : getPath(options.basePath) + "bpm/process/retake/"
				+ options.variables.processInstanceId,
		type : 'get',
		data : $.toJSON(options.variables),
		contentType : 'application/json;charset=UTF-8',
		success : function(data) {
			if (typeof (options.success) != 'undefined')
				options.success(data);
		},
		error : function() {
			$.alert("error", "执行失败！");
		}
	});
};
/**
 * 显示流程图.
 * options:{basePath,variables:{processInstanceId,processDefinitionId}}
 */
BPM.prototype.showImg = function(options) {
	var img = "";
	var divId = options.variables.imgId;
	
	var definitionId = options.variables.processDefinitionId;
	var instanceId = options.variables.processInstanceId;
	if (typeof (instanceId) == "undefined" || instanceId == '') {
		var imgPath = getPath(options.basePath) + "bpm/config/image/"
				+ definitionId;
	} else {
		var timestamp = new Date().getTime();
		var imgPath = getPath(options.basePath) + "bpm/image/" + instanceId
				+ "?t=" + timestamp;
	}
	// 判断流程图是否已经存在，存在则更新，否则追加
	if ($("#processImage").length > 0) {
		$("#processImage").attr("src", imgPath);
	} else {
		img = "<img id=\"processImage\" alt=\"流程图\" src=\"" + imgPath
				+ "\">";
		var imgContainer = "#processImgDiv";
		if (typeof (divId) != "undefined") {
			imgContainer = "#" + divId;
		}
		$(imgContainer).append(img);
	}
};


function getPath(path) {
	if (typeof (path) == "undefined" || path == '')
		return getBasePath();
	else
		return path;
}
function getBasePath() {
	var locations = (window.location + '').split('/');
	var basePath = "";
	if (window.location.protocol == 'http:') {
		basePath = "http://" + locations[2] + '/' + locations[3];
	} else {
		basePath = "https://" + locations[2] + '/' + locations[3];
	}

	return basePath + "/";
}