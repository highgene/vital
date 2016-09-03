<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<div class="v_box">
	<div id="processImgDiv"></div>
	<div class="widget-header ui-sortable-handle">
		<h4>
			&nbsp;当前:<span id="currentTask"></span>
		</h4>
	</div>
	<div class="v_mt_5">
		<div class="row col-sm-11">
			<form id="saveForm" class="form-horizontal" role="form">
				<div class="form-group">
					<div class="col-sm-12">
						<label class="col-sm-2 control-label">下一步</label>
						<div class="col-sm-10">
							<select class="col-sm-12" id="nextActivity" name="nextActivity"></select>
						</div>
					</div>
				</div>
				<div class="form-group" style="display: none"
					id="nextReciverItemDiv">
					<div class="col-sm-12">
						<label class="col-sm-2 control-label">接收人</label>
						<div id="nextReceiverDiv" class="col-sm-10">
							<select class="form-control" id="nextReceiver"
								class="chosen-select" data-placeholder="请选择任务接收人"
								name="nextReceiver"></select>
						</div>
					</div>
				</div>
				<div class="form-group">
					<div class="col-sm-12">
						<label class="col-sm-2 control-label"><a href="#"
							onclick="showOpinion()">填写备注</a></label>
						<div class="col-sm-10" id="opinionDiv" style="display: none">
							<textarea class="form-control" id="opinion" name="opinion"
								class="form-control" rows=6></textarea>
						</div>
					</div>
				</div>
			</form>
		</div>
	</div>
</div>
<div class="col-xs-12 clearfix form-actions v_btn_brn">
	<div class="col-xs-12">
		<button id="executeButton" class="btn btn-sm btn-info" type="button" data-loading-text='正在提交...'>
			<i class="ace-icon fa fa-arrow-circle-right bigger-130"></i> <span
				class="bigger-110">确定</span>
		</button>
	</div>
</div>
<script type="text/javascript">

	var businessDataId = '${param.id}';
	var processKey = '${param.processKey}';
	var options = null;
	var serverData = null;
	//初始化页面
	$(function() {
		options = parent.bpmOptions || bpmOptions;
		var bpm =  new BPM();
		var url = getPath(options.basePath) + 'bpm/bpm/process/';
		var data = $.toJSON(options.variables);
		//获取流程状态，如果业务数据还没有关联的流程，则新建一个流程实例并返还状态
		$.ajax({
			url : url,
			type : 'POST',
			data : data,
			contentType : 'application/json;charset=UTF-8',
			success : function(data) {
				serverData = data;
				initForm(data);
			},
			error : function() {
				$.alert("error", "初始化流程状态失败！");
			}
		});
		
		$("#nextActivity").click(transitionChange);
		$("#executeButton").click(executeProcess);
	});
	function showOpinion(){
		$("#opinionDiv").css("display", '');
	}
	//执行流程
	function executeProcess(){
		$("#executeButton").button('loading');
		var variables = options.variables;
		//组织下一环节处理人
		var nextActivity = $("#nextActivity").val();
		var nextReceiver = $("#nextReceiver").val();
		
		var nextReceivers = {};
		nextReceivers[nextActivity+""]=nextReceiver;
		variables.nextReceivers= nextReceiver;
		variables.nextActivity= nextActivity;
		variables.reason = $("#opinion").val();
		if(serverData.currentTasks != null)
			variables.taskId = serverData.currentTasks[0].id;
		variables.processInstanceId = serverData.instanceId;
		var bpm =  new BPM();
		bpm.process(options);
	}
	//重选下一步活动时，重新加载候选接收人
	function transitionChange(){
		initAssigneeSelect(serverData, $("#nextActivity").val());
	}
	//初始化表单
	function initForm(data) {
		if(data.currentTasks == null || data.currentTasks[0].length == 0){
			$("#currentTask").append("完成");
			$("#saveForm").hide();
			$("#executeButton").click(function (){
				$("#executeButton").button('loading');
				window.parent.$('#processDialog').modal('hide');
			});
			return ;
		}
		$("#currentTask").append(data.currentTasks[0].name);
		//初始化下一活动下拉框
		var nexts = $("#nextActivity");
		nexts.empty();
		var leaves = data.currentTasks[0].leaveTransitions;
		
		for (var i = 0; i < leaves.length; i++) {
			var back = "";
			var selectVal = "selected";
			if(leaves[i].back){
				back = "退回 : ";
				selectVal = "";
			}
			var optionContent = "<option "+selectVal+" value=\""+leaves[i].taskKey+"\">"+back+ leaves[i].destination + "</option>";
			nexts.append(optionContent);
		}
		//初始化任务接收人下拉框
		initAssigneeSelect(data, nexts.val());
	}
	//加载候选人下拉框
	function initAssigneeSelect(data , leaveTransition){
		var leaveTransitions = data.currentTasks[0].leaveTransitions;
		$("#nextReceiverDiv").empty();
		var nextReceiverSelect = "";

		var hasTaskConfig = false;
		for(var i =0; i< leaveTransitions.length ; i++){
			if(leaveTransitions[i].taskKey == leaveTransition){
				if(leaveTransitions[i].taskConfig == null 
						|| leaveTransitions[i].taskConfig == 'null'){
					continue;
				}
				var assignees = leaveTransitions[i].taskConfig.assigneeList;
				var tip = "data-placeholder=\"请选择任务接收人\"";
				//是会签时，可以选择多个人
				if(leaveTransitions[i].taskConfig.multiInstance ){
					
					if(assignees.length == 0)
						tip = "";
					nextReceiverSelect = "<select "+tip+" class=\"form-control\" multiple=true id=\"nextReceiver\" class=\"chosen-select\" name=\"nextReceiver\">";
				}else
					nextReceiverSelect = "<select "+tip+" class=\"form-control\" id=\"nextReceiver\" class=\"chosen-select\" name=\"nextReceiver\">";
				
				nextReceiverSelect +="<option value=\""+assignees[0].id+"\" >"+assignees[0].realName+"</option>";
				for(var j = 1; j < assignees.length; j++){
					
					nextReceiverSelect +=
							"<option value='"+assignees[j].id+"'>"+ assignees[j].realName + "</option>";
				}
				hasTaskConfig = true;
				break;
			}
		}
		if(!hasTaskConfig){
			$("#nextReciverItemDiv").css("display","none");
		}else{
			$("#nextReciverItemDiv").css("display","");
		}
		$("#nextReceiverDiv").append(nextReceiverSelect);
		$('#nextReceiver').chosen({
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
	}

</script>
</body>
</html>