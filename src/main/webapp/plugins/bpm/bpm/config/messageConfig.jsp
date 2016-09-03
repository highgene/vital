<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/fwebUI/header.jsp"%>   
<div>
<form id="saveForm" class="form-horizontal" role="form">
<div class="v_mt_5">
	<div class="row">
		<div class="col-xs-12" id="gridDiv">
			<table id="configGrid"></table>
		</div>
	</div>
</div>
<input type="hidden" name="taskKey" value="${param.taskKey}">
<input type="hidden" name="definitionId" value="${param.definitionId}">
</form>
</div>
<div>
<span><b>【注1】</b> 消息模板中可以使用的变量包括：
<br/>&nbsp;&nbsp;&nbsp;&nbsp;流程名称（processDefinitionName）、流程状态（status）、
<br/>&nbsp;&nbsp;&nbsp;&nbsp;下一任务名称（taskName)、待办的接收人（assignee）、
<br/>&nbsp;&nbsp;&nbsp;&nbsp;当前任务处理人（currentUser)、当前任务处理时间（taskTime） 、
<br/>&nbsp;&nbsp;&nbsp;&nbsp;当前任务名称（currentTaskName）、以及页面传递的其他变量
<br/><span><b>【注2】</b>
<br/>&nbsp;&nbsp;&nbsp;&nbsp;发起人： 发起流程的人，一般是填写申请的人
<br/>&nbsp;&nbsp;&nbsp;&nbsp;任务接收人:下一任务的处理人；
<br/>&nbsp;&nbsp;&nbsp;&nbsp;参与人:本流程实例中所有的参与人员；
<br/>&nbsp;&nbsp;&nbsp;&nbsp;已配置人员：所有任务节点配置的全部人员。
</span>
</div>
<div class="col-xs-12 clearfix form-actions v_btn_brn">
	<button id="testProcessButton" onclick="saveConfig();"
		class="btn btn-sm btn-success" type="submit">
		<i class="fa fa-save bigger-130"></i> <span class="bigger-110">保存
		
	</span>
	</button>
</div>
<script type="text/javascript">
var basePath = '${Config.baseURL}';
var taskKey = '${param.taskKey}';
var gridUrl = "bpm/bpm/config/messageList?taskKey="+taskKey+"&definitionId=${param.definitionId}";
loadGrid();
function loadGrid(){
	
	$("#configGrid")
	.dataGrid(
			{
				checkbox : false,
				url : basePath + gridUrl,
				type : "get",
				align : "center",
				pagination : false,
				rownum : false,	
				loadSuccess : initMessageSelect,
				enableRowEditEvent : true,
				columns : [
						{
							name : "id",
							width : "10",
							display : false,
							render:function(row){
								var inputHTML = "<input type=\"hidden\" name=\"id\" value=\""+row.id+"\">"
									+ "<input type=\"hidden\" name=\"eventType_"+row.id+"\" value=\""+row.eventType+"\">";
								return inputHTML;
							}
						},
						{
							name : "eventTypeDesc",
							title : "任务事件",
							align : "center",
							width : 80,
							render:function(row){
								
								return "<b>"+row.eventTypeDesc+"</b>"
							}
						},
						{
							name : "scope",
							title : "发送范围",
							render:function(row){
								var scopes =row.scope;
								var checked0="", checked1 = "",checked2="", checked3="";
								if(scopes != null){
									if(scopes.indexOf("0") > -1)checked0="checked";
									if(scopes.indexOf("1") > -1)checked1="checked";
									if(scopes.indexOf("2") > -1)checked2="checked";
									if(scopes.indexOf("3") > -1)checked3="checked";
								}
								var inputHTML = "<input type=checkbox "+checked0+" name='scope_"+row.id+"' value=0>发起人&nbsp;&nbsp;";
									inputHTML +="<input type=checkbox "+checked1+" name='scope_"+row.id+"' value=1>任务接收人&nbsp;&nbsp;";
									inputHTML +="<input type=checkbox "+checked2+" name='scope_"+row.id+"' value=2>参与人&nbsp;&nbsp;";
									inputHTML +="<input type=checkbox "+checked3+" name='scope_"+row.id+"' value=3>已配置人员&nbsp;&nbsp;";
								return inputHTML;
								
							}
						},
						{
							name : "scopeRoles",
							title : "自选发送范围",
							width : 260, 
							render:function(row){
								var inputHTML ="";
								inputHTML +="<select selectType=\"scopeRoles\" multiple=\"multiple\" class=\"chosen-select\" data-placeholder=\"选择消息接收者\" style=\"width:80%;display:none\""
									+"defaultVal='"+row.scopeRoles+"' id=\"scopeRoles_"+row.id+"\" name=\"scopeRoles_"+row.id+"\"></select>";
								return inputHTML;
								
							}
						},
						{
							width : 180,
							name : "messageId",
							title : "消息模板",
							render :function(row){
								var inputHTML ="<select selectType=\"messageId\" class=\"chosen-select\" data-placeholder=\"请选择消息模板\" style=\"width:100%;display:none\""
									+"defaultVal='"+row.messageId+"' id=\"messageId_"+row.id+"\" name=\"messageId_"+row.id+"\"></select>";
								return inputHTML;
							}
						}]
			});
	
}
//保存
function saveConfig(id, name, version) {
	$.ajax({
		url : basePath + "bpm/bpm/config/messageConfig/",
		type : 'post',
		data : $.toJSON($("#saveForm").serializeObject()),
		contentType : 'application/json;charset=UTF-8',
		success : function(data) {
			$.alert("success", "保存成功！");
			//window.parent.$('#messageConfigWin').modal('hide');
		},
		error : function() {
			$.alert("error", "保存失败！");
		}
	});
}
function initScopeRoles(){
	var selects = $("select[selectType=scopeRoles]");
	$.ajax({
		url : basePath+"bpm/bpm/config/roleList/",
		type : "get",
		cache : true,
		contentType : 'application/json;charset=UTF-8',
		success : function(data){
			for(var i =0; i < selects.length;i++){
				var selectId = selects[i].id;
				var defaultVal = selects[i].attributes["defaultVal"].value;
				initScopeRolesSelect(selectId, data, defaultVal);
			}
		},
		error : function(jqXHR, textStatus, errorThrown) {
			alert(jqXHR.errorMessage)
		}
	});
	
}
function initScopeRolesSelect(selectId, data, defaultVal) {
	var currentSelect = $("#" + selectId);
	currentSelect.empty();
	$(data).each(
		function(i, el) {
			var selected = "";
			if(typeof(defaultVal) != 'undefined'){
				var defaultVals = defaultVal.split(",");
				$(defaultVals).each(function(i, defaultVal_el) {
					if (el.id == defaultVal_el) {
						selected = "selected=true";
					}
				});
			}
			var name = el.roleName;
			currentSelect.append("<option value='"+el.id+"' "+selected+">"+ name + "</option>");
		}
	);
	
	currentSelect.trigger("chosen:updated");
	currentSelect.chosen({
		allow_single_deselect : true,
		no_results_text : "没有找到!"
	});
	$(window).off('resize.chosen').on('resize.chosen', function() {
		$('.chosen-select').each(function() {
			var $this = $(this);
			$this.next().css({
				'width' : '100%'
			});
		})
	}).trigger('resize.chosen');
	
};
function changeType(event){
	var type = $("#messageType").val();
	gridUrl = "bpm/bpm/config/messageList?taskKey="+taskKey+"&type="+type;
	
	$("#gridDiv").empty();
	$("#gridDiv").append("<table id=\"configGrid\"></table>");
	loadGrid();
}
function initMessageSelect() {
	$("#messageType").change(changeType);
	$("td").css("overflow", "visible");
	var selects = $("select[selectType=messageId]");
	$.ajax({
		url : basePath+"plugin-core/template/?pageSize=0&pageIndex=1000&templateName=&templateSign=",
		type : "get",
		cache : true,
		contentType : 'application/json;charset=UTF-8',
		success : function(data){
			for(var i =0; i < selects.length;i++){
				var selectId = selects[i].id;
				var defaultVal = selects[i].attributes["defaultVal"].value;
				initMessage(selectId, data.data, defaultVal);
			}
		},
		error : function(jqXHR, textStatus, errorThrown) {
			alert(jqXHR.errorMessage)
		}
	});
	
	initScopeRoles();
}
function initMessage(selectId, data, defaultVal) {
	var currentSelect = $("#" + selectId);
	currentSelect.empty();
	$(data).each(
			function(i, el) {
				var selected = "";
				if(typeof(defaultVal) != 'undefined'){
					var defaultVals = defaultVal.split(",");
					$(defaultVals).each(function(i, defaultVal_el) {
						if (el.id == defaultVal_el) {
							selected = "selected=true";
						}
					});
				}
				var name = el.templateName;
				currentSelect.append("<option value='"+el.id+"' "+selected+">"+ name + "</option>");
			});
	
	currentSelect.trigger("chosen:updated");
	currentSelect.chosen({
		allow_single_deselect : true,
		no_results_text : "没有找到!"
	});
	$(window).off('resize.chosen').on('resize.chosen', function() {
		$('.chosen-select').each(function() {
			var $this = $(this);
			$this.next().css({
				'width' : '100%'
			});
		})
	}).trigger('resize.chosen');
	
};
</script>
</body>
</html>