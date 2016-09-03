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
		      <div class="col-sm-9">
				  <div class="text-left pt-7"><strong id="btNumber"></strong></div>
		      </div>
		    </div>
			<div class="col-sm-6">
			  <label class="col-sm-3 control-label">计划开始时间</label>
		      <div class="col-sm-9">
		      	<div class="text-left pt-7"><strong id="planStartDate"></strong></div>
		      </div>
		    </div>
	    </div>
	    <div class="form-group">
	    	<div class="col-sm-6">
			  <label class="col-sm-3 control-label">计划结束时间</label>
		      <div class="col-sm-9">
				  <div class="text-left pt-7"><strong id="planEndDate"></strong></div>
		      </div>
		    </div>
			<div class="col-sm-6">
			  <label class="col-sm-3 control-label">合计天数</label>
		      <div class="col-sm-9">
		      	<div class="text-left pt-7"><strong id="planNumberDays"></strong></div>
		      </div>
		    </div>
	    </div>
	    <div class="form-group">
	    	<div class="col-sm-6">
			  <label class="col-sm-3 control-label">实际开始时间</label>
		      <div class="col-sm-9">
		      	<div class="text-left pt-7"><strong id="realStartDate"></strong></div>
		      </div>
		    </div>
			<div class="col-sm-6">
			  <label class="col-sm-3 control-label">实际结束时间</label>
		      <div class="col-sm-9">
		      	<div class="text-left pt-7"><strong id="realEndDate"></strong></div>
		      </div>
		    </div>
	    </div>
	    <div class="form-group">
	    	<div class="col-sm-6">
			  <label class="col-sm-3 control-label">出差地点</label>
		      <div class="col-sm-9">
				  <div class="text-left pt-7"><strong id="address"></strong></div>
		      </div>
		    </div>
		    <div class="col-sm-6">
			 <label class="col-sm-3 control-label">交通工具</label>
		      <div class="col-sm-9 ">
				  <div class="text-left pt-7"><strong id="vehicle"></strong></div>
		      </div>
		    </div>
	    </div>
	    <div class="form-group">
			<div class="col-sm-6">
			  <label class="col-sm-3 control-label">申请日期</label>
		      <div class="col-sm-9">
		      	<div class="text-left pt-7"><strong id="applyDate"></strong></div>
		      </div>
		    </div>
		    <div class="col-sm-6">
			  <label class="col-sm-3 control-label">出差事由</label>
		      <div class="col-sm-9">
		      	<div class="text-left pt-7"><strong id="reason"></strong></div>
		      </div>
		    </div>
	    </div>
	    <div class="form-group">
		    <div class="col-sm-12">
			  <label class="col-sm-2 control-label"  style="width: 89px;">流程信息</label>
		      <div class="col-sm-10"  style="width: 649px;">
				  <div id="logGrid"></div>
		      </div>
		    </div>
	    </div>
	</form>
	</div>
</div>
</div>
<div class="col-xs-12 clearfix form-actions v_btn_brn">
	<a> <span class="btn btn-sm btn-primary"><i class="ace-icon fa fa-floppy-o bigger-130"></i><span class="bigger-110">审批</span>
	</span>
	</a>&nbsp;&nbsp; 
</div>

<script type="text/javascript">
var basePath = '${Config.baseURL}';
var bpmBasePath = basePath;
var businessTripData;
var bpm = new BPM();
//初始化数据
$("#saveForm").dataForm({
	url:basePath + "businessTrip/${param.id}",
	pageName:"detail",
	loadSuccess: function(data){
		businessTripData = data;
		bpm.loadProcessStatus({
			basePath : bpmBasePath,
			logTableId : "logGrid",
			variables : {
				processInstanceId : businessTripData.processInstanceId,
			},
		});
	}
});

	$(".btn-primary").click(function() {
		executeBpm(businessTripData);
	});
	
	function executeBpm(businessTrip){
		var bpm = new BPM();
		bpm.execute({
		    variables: {
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
		businessTripData = $.extend(businessTrip, businessTripData);
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
	function closeWindow(){
		window.parent.$('#fwebModal').modal('hide');
		window.parent.queryBusinessTrip();
	}

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
