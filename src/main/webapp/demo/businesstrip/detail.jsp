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
<div class="scrollable" data-size="365" data-position="left">
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
			  <label class="col-sm-3 control-label">计划天数</label>
		      <div class="col-sm-9">
		      	<div class="text-left pt-7"><strong id="planNumberDays"></strong></div>
		      </div>
		    </div>
	    </div>
	    <div class="form-group">
	    	<div class="col-sm-6">
			  <label class="col-sm-3 control-label">出差地址</label>
		      <div class="col-sm-9">
				  <div class="text-left pt-7"><strong id="address"></strong></div>
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
	    	<div class="col-sm-6">
			  <label class="col-sm-3 control-label">交通工具</label>
		      <div class="col-sm-9">
				  <div class="text-left pt-7"><strong id="vehicle"></strong></div>
		      </div>
		    </div>
			<div class="col-sm-6">
			  <label class="col-sm-3 control-label">实际出差开始时间</label>
		      <div class="col-sm-9">
		      	<div class="text-left pt-7"><strong id="realStartDate"></strong></div>
		      </div>
		    </div>
	    </div>
	    <div class="form-group">
	    	<div class="col-sm-6">
			  <label class="col-sm-3 control-label">出差实际结束时间</label>
		      <div class="col-sm-9">
				  <div class="text-left pt-7"><strong id="realEndDate"></strong></div>
		      </div>
		    </div>
			<div class="col-sm-6">
			  <label class="col-sm-3 control-label">申请日期</label>
		      <div class="col-sm-9">
		      	<div class="text-left pt-7"><strong id="applyDate"></strong></div>
		      </div>
		    </div>
	    </div>
	    <div class="form-group">
	    	<div class="col-sm-6">
			  <label class="col-sm-3 control-label">实际出差天数</label>
		      <div class="col-sm-9">
				  <div class="text-left pt-7"><strong id="realNumberDays"></strong></div>
		      </div>
		    </div>
			<div class="col-sm-6">
			  <label class="col-sm-3 control-label">流程状态</label>
		      <div class="col-sm-9">
		      	<div class="text-left pt-7"><strong id="processstatus"></strong></div>
		      </div>
		    </div>
	    </div>
	    <div class="form-group">
	    	<div class="col-sm-6">
			  <label class="col-sm-3 control-label">当前处理人</label>
		      <div class="col-sm-9">
				  <div class="text-left pt-7"><strong id="taskMan"></strong></div>
		      </div>
		    </div>
			<div class="col-sm-6">
			  <label class="col-sm-3 control-label">申请人</label>
		      <div class="col-sm-9">
		      	<div class="text-left pt-7"><strong id="applyUser"></strong></div>
		      </div>
		    </div>
	    </div>
		<div class="form-group">
	    	<div class="col-sm-6">
			  <label class="col-sm-3 control-label">申请人部门</label>
		      <div class="col-sm-9">
				  <div class="text-left pt-7"><strong id="deptId"></strong></div>
		      </div>
		    </div>
	    </div>
	</form>
	</div>
</div>
</div>

<script type="text/javascript">
var basePath = '${Config.baseURL}';
$("#saveForm").dataForm({
	url:basePath + "businessTrip/${param.id}",
	pageName:"detail"
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