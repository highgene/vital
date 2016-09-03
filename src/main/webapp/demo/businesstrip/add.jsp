<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE HTML>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>添加</title>
<%@ include file="/demo/header.jsp"%>
</head>
<body class="no-skin v_no_y" >
<div class="row v_m_lr_15">
<div class="scrollable" data-size="325" data-position="left">
	<div class="col-sm-12">
	<form id="saveForm" class="form-horizontal" role="form">
	    <div class="form-group">
	    	<div class="col-sm-6">
			  <label class="col-sm-3 control-label">出差单号</label>
		      <div class="col-sm-9 required-field-block">
				  <b class="required-icon">*</b>
				  <div class="text-left pt-7"><strong id="btNumber"></strong></div>
				  <input type="text" name="btNumber" hidden>
		      </div>
		    </div>
		    <div class="col-sm-6">
			  <label class="col-sm-3 control-label">申请日期</label>
		      <div class="col-sm-9">
		      	<div class="text-left pt-7"><strong id="applyDate"></strong></div>
		      	<input type="text" name="applyDate" hidden>
		      </div>
		    </div>
	    </div>
	    <div class="form-group">
	    	<div class="col-sm-6">
			  <label class="col-sm-3 control-label">计划开始时间</label>
		      <div class="col-sm-9 required-field-block">
		     	<b class="required-icon">*</b>
		      	<input type="text" class="form-control" name="planStartDate" id="planStartDate" required>
		      </div>
		    </div>
	    	<div class="col-sm-6">
			  <label class="col-sm-3 control-label">计划结束时间</label>
		      <div class="col-sm-9 required-field-block">
				  <b class="required-icon">*</b>
				  <input type="text" class="form-control" name="planEndDate" id="planEndDate" required>
		      </div>
		    </div>
	    </div>
	    <div class="form-group">
	    	<div class="col-sm-6">
			  <label class="col-sm-3 control-label">合计天数</label>
		      <div class="col-sm-9">
		      	<div class="text-left pt-7"><strong id="planNumberDays"></strong></div>
		      	<input type="text" name="planNumberDays" hidden>
		      </div>
		    </div>
	    	<div class="col-sm-6">
			  <label class="col-sm-3 control-label">出差地点</label>
		      <div class="col-sm-9">
				  <input type="text" class="form-control" name="address">
		      </div>
		    </div>
		    
	    </div>
	    <div class="form-group">
		    <div class="col-sm-6">
			 <label class="col-sm-3 control-label">交通工具</label>
		      <div class="col-sm-9 ">
				  <input type="text" class="form-control" name="vehicle" >
		      </div>
		    </div>
	    </div>
	    <div class="form-group">
	    	<div class="col-sm-12">
			  <label class="col-sm-2 control-label" style="width: 89px;">出差事由</label>
		      <div class="col-sm-10" style="width: 649px;">
		      	<textarea type="text" class="form-control" name="reason"></textarea>
		      </div>
		    </div>
	    </div>
	</form>
	</div>
</div>
</div>
<div class="col-xs-12 clearfix form-actions v_btn_brn">
	<a> <span class="btn btn-sm btn-primary"><i class="ace-icon fa fa-floppy-o bigger-130"></i><span class="bigger-110">保存</span>
	</span>
	</a>&nbsp;&nbsp; 
	<a> <span class="btn btn-sm btn-success"><i class="ace-icon fa fa-check bigger-130"></i><span class="bigger-110">提交</span>
	</span>
	</a>
</div>

<script type="text/javascript">
var basePath = '${Config.baseURL}';
var bpmBasePath = basePath;
var btNumber = Math.round(Math.random()*100000000);
var applyDate = new Date();
var planNumberDays;
$("#btNumber").html(btNumber);
$("input[name='btNumber']").val(btNumber);
$("#applyDate").html(applyDate.format("yyyy-MM-dd"));
$("input[name='applyDate']").val(applyDate.format("yyyy-MM-dd HH:mm:ss"));
var submitFlag = false;
//保存
$(".btn-primary").click(function(){
	submitFlag = false;
	$("#saveForm").submit();
});
//提交
$(".btn-success").click(function(){
	submitFlag = true;
	$("#saveForm").submit();
});

$("#saveForm").validate({
	onkeyup : false,
	success : function(label, element) {
		$(element).hideRemind();
	},
	errorPlacement : function(error, element) {
		$(element[0]).showRemind(error.html());
	},
	submitHandler:function(form){
		var businessTrip = $(form).serializeObject();
		businessTrip.processStatus = "草稿";
		//保存出差信息
		$.ajax({
			url : basePath + "businessTrip",
			type : 'post',
			data : $.toJSON(businessTrip),
			contentType : 'application/json;charset=UTF-8',
			success : function(businessTrip) {
				if(submitFlag){
					executeBpm(businessTrip);
				} else {
					closeWindow();
				}
			}
		});
    } 
});

function closeWindow(){
	window.parent.$('#fwebModal').modal('hide');
	window.parent.queryBusinessTrip();
}

function executeBpm(businessTrip){
	var bpm = new BPM();
	bpm.execute({
	    variables: {
	        //流程定义的key(标识符)， 也就是在eclipse设计器中的id
	        processKey: "BusinessTripDemo",
	        //业务数据的id，必填
	        businessKey: businessTrip.id
	     }, 
	    //流程操作完成后回调的方法对象
	    success: function(){
	    	updataBusinessTrip(businessTrip);
	    },
	    //业务表单的id，用以回填流程状态字段
	    formId: "saveForm",
	    basePath:bpmBasePath
	});
}

function updataBusinessTrip(businessTrip){
	var businessTripData = $("#saveForm").serializeObject();
	businessTripData.id = businessTrip.id;
	$.ajax({
		url : basePath + "businessTrip",
		type : 'put',
		data : $.toJSON(businessTripData),
		contentType : 'application/json;charset=UTF-8',
		success : function(data) {
			closeWindow();
		}
	});
}

$("#planStartDate").datetimepicker({language : "zh-CN",autoclose : true,startView : 2,minView : 0,maxView : 2, format: "yyyy-mm-dd hh:ii:ss"}).on('changeDate', function(e){
	var planStartDate = $("#planStartDate").val();
	var planEndDate = $("#planEndDate").val();
	if(planStartDate == "" || planEndDate == ""){
		return ;
	}
	planStartDate = planStartDate.substring(0,10);
	planEndDate = planEndDate.substring(0,10);
	planNumberDays = daysBetween(planStartDate, planEndDate)+1;
	$("#planNumberDays").html(planNumberDays + " 天");
	$("input[name='planNumberDays']").val(planNumberDays);
});
$("#planEndDate").datetimepicker({language : "zh-CN",autoclose : true,startView : 2,minView : 0,maxView : 2, format: "yyyy-mm-dd hh:ii:ss"}).on('changeDate', function(e){
	var planStartDate = $("#planStartDate").val();
	var planEndDate = $("#planEndDate").val();
	if(planStartDate == "" || planEndDate == ""){
		return ;
	}
	planStartDate = planStartDate.substring(0,10);
	planEndDate = planEndDate.substring(0,10);
	planNumberDays = daysBetween(planStartDate, planEndDate)+1;
	$("#planNumberDays").html(planNumberDays + " 天");
	$("input[name='planNumberDays']").val(planNumberDays);
});

//框架代码	
$('.scrollable').each(function () {
	var $this = $(this);
	$(this).ace_scroll({
		size: $this.data('size') || 100,
	});
});
$('.scrollable-horizontal').each(function () {
	var $this = $(this);
	$(this).ace_scroll(
	  {
		horizontal: true,
		styleClass: 'scroll-top',//show the scrollbars on top(default is bottom)
		size: $this.data('size') || 500,
		mouseWheelLock: true
	  }
	).css({'padding-top': 12});
});

$(window).on('resize.scroll_reset', function() {
	$('.scrollable-horizontal').ace_scroll('reset');
});
</script>
</body>
</html>
