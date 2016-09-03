<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/fwebUI/header.jsp"%>   
<div class="row v_m_lr_15">
	<div class="scrollable" data-size="580" data-position="left">
		<div class="col-sm-12">
				<div id="processImgDiv"></div>
			<fieldset>
				<legend>表单数据</legend>
				<form id="saveForm" class="form-horizontal" role="form">
					<div class="form-group">
						<div class="col-sm-12">
							<div class="col-sm-12 required-field-block">
								<textarea class="form-control" id="variables" name="variables" rows=6></textarea>
							</div>
						</div>
					</div>
					<div class="form-group">
						<div class="col-sm-12">
							<div class="col-sm-12 required-field-block">
								<input class="form-control" type=text id=businessKey name=businessKey placeholder="请填写：businessKey">
							</div>
						</div>
					</div>
				</form>
			</fieldset>
			<fieldset>
				<legend>流程日志</legend>
				<div class="v_box_frame">
					<div class="v_mt_5">
						<div class="row">
							<div class="col-xs-12">
								<table id="logGrid"></table>
							</div>
						</div>
					</div>
				</div>
			</fieldset>
		</div>
	</div>
</div>
<div class="col-xs-12 clearfix form-actions v_btn_brn">

	<div class="col-xs-12">
		<button id="executeButton"  class="btn btn-sm btn-success">
			<i class="ace-icon fa fa-arrow-circle-right bigger-130"></i><span
				class="bigger-110">执行</span>
		</button>
	</div>
</div>
</body>
</html>
<script type="text/javascript">
	var basePath = '${Config.baseURL}';
	var processDefinitionId = '${param.id}';
	var processKey = '${param.processKey}';
	var businessKey = '${param.businessKey}'
	var processInstanceId = '${param.processInstanceId}';
	
	$("#executeButton").click(function(){
		var bpm = new BPM();
		
		var options = {
			variables: {
				processKey: processKey
			}, 
			success: showProcessStatus,
			formId: "saveForm"
		};
		
		options.variables.businessKey = $("#businessKey").val();
		options.variables = $.extend({},options.variables, getData());
		
		if(options.variables.businessKey.length == 0){
			$.alert("error", "业务数据id不能为空！");
			$("#businessKey").focus();
			return ;
		}
		bpm.execute(options);
	});
	
	function showProcessStatus(options){
		var bpm = new BPM();
		
		if(options.instanceId != null)
			options.variables.processInstanceId = options.instanceId;
		
		options.logTableId="logGrid";
		options.imgId="processImgDiv";
		bpm.loadProcessStatus(options);
		
	}

	
	$(function(){
		var bpm = new BPM();
		var options = {	variables: {}};
		
		if(processInstanceId.length > 0){
			$("#businessKey").val(businessKey);
			
			options.variables.processInstanceId = processInstanceId;
			showProcessStatus(options);
			
			options.success = function(data){
				$("#executeButton").attr("disabled",data['status'] ==='完成');
			};
			bpm.getStatus(options);
		}
	});


	
	//根据表单生成提交数据
	function getData() {
		var data ={};
		var variables = $("#variables").val().split("\n");

		for (var i = 0; i < variables.length; i++) {
			var item = variables[i].split("=");
			if (item.length != 2)
				continue;
			data[item[0]+""]=item[1];
			
		}
		return data;
	}
	
	//框架代码	
	$('.scrollable').each(function() {
		var $this = $(this);
		$(this).ace_scroll({
			size : $this.data('size') || 100,
		});
	});
	$('.scrollable-horizontal').each(function() {
		var $this = $(this);
		$(this).ace_scroll({
			horizontal : true,
			styleClass : 'scroll-top',//show the scrollbars on top(default is bottom)
			size : $this.data('size') || 500,
			mouseWheelLock : true
		}).css({
			'padding-top' : 12
		});
	});

	$(window).on('resize.scroll_reset', function() {
		$('.scrollable-horizontal').ace_scroll('reset');
	});
</script>