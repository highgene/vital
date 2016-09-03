<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/demo/header.jsp"%>
<div class="row">
	<div class="tab-content">
		<div class="tab-pane active" id="home2">
			<div class="v_box" id="v_box_header2">
				<div class="widget-header ui-sortable-handle">
					<div class="widget-toolbar no-border" style="z-index: 10000">
						<a onclick="returnDefinitionList()"><span
							class="btn btn-xs btn-primary"> <i
								class="ace-icon fa fa-chevron-left bigger-130"></i> <span
								class="bigger-110">返回流程定义列表</span>
						</span></a>
					</div>
				</div>
			</div>
			<form id="saveForm" class="form-horizontal" role="form">
				<div class="v_box_frame">
					<div class="v_mt_5">
						<div class="row">
							<div class="col-xs-12">
								<table id="configGrid"></table>
							</div>
						</div>
					</div>
				</div>
				<input type="hidden" name="definitionId" value="${param.id}">
			</form>
		</div>
	</div>
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
	var definitionId = '${param.id}';

	$(document).ready(function() {
		queryConfig();

	});

	function queryConfig() {
		$("#configGrid")
				.dataGrid(
						{
							checkbox : false,
							url : basePath + "bpm/config/taskdeinitionList/"
									+ definitionId,
							type : "get",
							align : "center",
							pagination : false,
							rownum : false,
							param : $("#searchForm").serializeArray(),
							pageSize : 10,
							enableRowEditEvent : true,
							loadSuccess : initForm,
							columns : [
									{
										name : "key",
										title : "id",
										width : "10",
										display : false
									},
									{
										name : "order",
										title : "id",
										width : "10",
										display : false,
										render : function(row){
											var inputHTML = "<input type=hidden name=\"order_"+ row.key+ "\" value=\""+row.order+"\">";
											
											return inputHTML;
										}
									},
									{
										width : 100,
										name : "key",
										title : "任务标识<br>(key)"
									},
									{
										width : 180,
										name : "name",
										title : "任务名称"
									},
									{
										width : 100,
										name : "extStatus",
										title : "状态",
										render : function(row){
											var inputHTML = "<input style=\"width:80px;\" type=text name=\"extStatus_"+ row.key+ "\" value=\""+row.extStatus+"\">";
											
											return inputHTML;
										}
									},
									{
										width : 80,
										name : "assigneeType",
										title : "配置类型",
										render : function(row){
											var inputHTML = "<select  id=\"assigneeType_"+ row.key +"\" name=\"assigneeType_"+ row.key +"\" onchange=\"setType(this.value,'assignees_"+row.key+"','"+row.assignees+"')\">";
											if(row.assigneeType == '0'){
												inputHTML += "<option selected value=\"0\">用户</option>";
												inputHTML += "<option value=\"1\">角色</option>";
											}else{
												inputHTML += "<option value=\"0\">用户</option>";
												inputHTML += "<option selected value=\"1\">角色</option>";
											}
											inputHTML += "</select>";
											return inputHTML;
										}
									},
									{
										name : "assignees",
										title : "任务参与者",
										render : function(row) {
											var val = "";
											if (row.assignees != null
													&& row.assignees != 'null')
												val = row.assignees;

											var inputHTML = "<select defaultVal=\""+row.assignees+"\" key=\""+row.key+"\" id=\"assignees_"
													+ row.key
													+ "\" class=\"chosen-select\" data-placeholder=\"请选择任务参与人\" multiple=\"multiple\" name=\"assignees_"
													+ row.key
													+ "\"  style=\"width:100%;display:none\"></select>";
											return inputHTML;
										}
									},
									{
										name : "sameTaskMan",
										title : "相同处理人",
										render : function(row) {
											var val = "";
											if (row.assignees != null
													&& row.assignees != 'null')
												val = row.assignees;

											var inputHTML = "<select class=\"sameTaskMan\" defaultVal=\""+row.sameTaskMan+"\" key=\""+row.key+"\" id=\"sameTaskMan_"
													+ row.key
													+ "\" data-placeholder=\"请选择相同人员的任务\" name=\"sameTaskMan_"
													+ row.key
													+ "\" style=\"width:100%;\"></select>";
											return inputHTML;
										}
									},
									{
										width : 260,
										name : "url",
										title : "表单URL",
										render : function(row){
											var inputHTML = "<input style=\"width:100%;\" type=text name=\"url_"+ row.key+ "\" value=\""+row.url+"\">";
											
											return inputHTML;
										}
									} ,
									{
										width:40,
										name:"opt",
										title:"消息",
										render : function(row){
											var inputHTML = '<div class="hidden-sm hidden-xs action-buttons">'
											+ '<a class="blue" title="配置消息" href="javascript:void(0)" onclick="configMessage(\''+row.key+'\',\''+row.definitionId+'\',\''+row.name+'\')"><i class="ace-icon fa fa-comment-o bigger-130"></i></a>';
											
											return inputHTML;
										}
									}]
						});
	}
	//返回流程定义列表
	function returnDefinitionList() {

		location.href = basePath + "view/demo/bpm/config/definitionList";
	}
	//保存
	function saveConfig(id, name, version) {
		$.ajax({
			url : basePath + "bpm/config/taskconfig/",
			type : 'post',
			data : $.toJSON($("#saveForm").serializeObject()),
			contentType : 'application/json;charset=UTF-8',
			success : function(data) {
				$.alert("success", "保存成功！");
			},
			error : function() {
				$.alert("error", "保存失败！");
			}
		});
	}
	
	function initForm(result) {
		var data = result.data;
		$("td[name=assignees]").css("overflow", "visible");
		$("td[name=sameTaskMan]").css("overflow", "visible");
		var sameTaskMans = $("select[class=sameTaskMan]");
		for(var i =0; i < sameTaskMans.length;i++){
			var sameTaskMan = sameTaskMans[i];
			$("#"+sameTaskMan.id).append("<option value='0' >无</option>");
			for(var j= 0; j < data.length; j++){
				var defaultVal = sameTaskMan.attributes["defaultVal"].value;
				var selected = "";
				if(typeof(defaultVal) != 'undefined'){
					var defaultVals = defaultVal.split(",");
					$(defaultVals).each(function(i, defaultVal_el) {
						if (data[j].key == defaultVal_el) {
							selected = "selected=true";
						}
					});
				}
				$("#"+sameTaskMan.id).append("<option value='"+data[j].key+"' "+selected+">"+ data[j].name + "</option>");
				
			}
		}
		
		var selects = $("select[class=chosen-select]");
		
		for (var i = 0; i < selects.length; i++) {
			var selectId = selects[i].id;
			var url = basePath + "bpm/config/userList";
			var type = $("#assigneeType_"+selects[i].attributes["key"].value).val();
			setType(type, selectId, selects[i].attributes["defaultVal"].value);
		}
	}
	function setType(type, id, defaultVal){
		var url = basePath + "bpm/config/";
		if(type == 0){
			url += "userList";
		}else{
			url += "roleList";
		}
		var selectId = id;
		initSelect(url, selectId, defaultVal) ;
	}
	function initSelect(url,  selectId, defaultVal) {

		$.ajax({
			url : url,
			type : "get",
			cache : true,
			contentType : 'application/json;charset=UTF-8',
			success : function(data){
				
				initAssignees(selectId, data, defaultVal);
			},
			error : function(jqXHR, textStatus, errorThrown) {
				alert('error')
			}
		});
	}
	function initAssignees(selectId, data, defaultVal) {
		var currentSelect = $("#" + selectId);
		currentSelect.empty();
		
		var selectAll = "";
		if(defaultVal == 0)
			selectAll = "selected";
		
		currentSelect.append("<option value=\"0\" "+selectAll+">全部</option>");
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
					var name = el.realName;
					if(typeof(name) == 'undefined')
						name = el.roleName;
					
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
	function configMessage(taskKey, definitionId, taskName){
		$.openWindow({
			id : "messageConfigWin",
			width : 860,
			height : 500,
			destroy : true,
			url : basePath + "view/demo/bpm/config/messageConfig?taskKey=" + taskKey+"&definitionId="+definitionId,
			title : "消息配置 【"+taskName+"】",
			showDefaultButton : false
		});
		
	}
	//框架JS
	mainH();
	function mainH() {
		var winH = $(window).height();
		var VH2 = $("#v_box_header2").height();
		$(".v_box_frame").css({
			height : winH - VH2 - 2
		});
	}

	$(window).resize(function() {
		mainH();
	});
</script>
</body>
</html>
