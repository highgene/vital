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
<div class="scrollable" data-size="285" data-position="left">
	<div class="col-sm-12">
	<form id="saveForm" class="form-horizontal" role="form">
	    <div class="form-group">
	    	<div class="col-sm-6">
			  <label class="col-sm-3 control-label">birthDate</label>
		      <div class="col-sm-9">
				  <div class="text-left pt-7"><strong id="birthDate"></strong></div>
		      </div>
		    </div>
			<div class="col-sm-6">
			  <label class="col-sm-3 control-label">email</label>
		      <div class="col-sm-9">
		      	<div class="text-left pt-7"><strong id="email"></strong></div>
		      </div>
		    </div>
	    </div>
	    <div class="form-group">
	    	<div class="col-sm-6">
			  <label class="col-sm-3 control-label">loginId</label>
		      <div class="col-sm-9">
				  <div class="text-left pt-7"><strong id="loginId"></strong></div>
		      </div>
		    </div>
			<div class="col-sm-6">
			  <label class="col-sm-3 control-label">mobilePhone</label>
		      <div class="col-sm-9">
		      	<div class="text-left pt-7"><strong id="mobilePhone"></strong></div>
		      </div>
		    </div>
	    </div>
	    <div class="form-group">
	    	<div class="col-sm-6">
			  <label class="col-sm-3 control-label">password</label>
		      <div class="col-sm-9">
				  <div class="text-left pt-7"><strong id="password"></strong></div>
		      </div>
		    </div>
			<div class="col-sm-6">
			  <label class="col-sm-3 control-label">phone</label>
		      <div class="col-sm-9">
		      	<div class="text-left pt-7"><strong id="phone"></strong></div>
		      </div>
		    </div>
	    </div>
	    <div class="form-group">
	    	<div class="col-sm-6">
			  <label class="col-sm-3 control-label">photo</label>
		      <div class="col-sm-9">
				  <div class="text-left pt-7"><strong id="photo"></strong></div>
		      </div>
		    </div>
			<div class="col-sm-6">
			  <label class="col-sm-3 control-label">sex</label>
		      <div class="col-sm-9">
		      	<div class="text-left pt-7"><strong id="sex"></strong></div>
		      </div>
		    </div>
	    </div>
	    <div class="form-group">
	    	<div class="col-sm-6">
			  <label class="col-sm-3 control-label">signCard</label>
		      <div class="col-sm-9">
				  <div class="text-left pt-7"><strong id="signCard"></strong></div>
		      </div>
		    </div>
			<div class="col-sm-6">
			  <label class="col-sm-3 control-label">userName</label>
		      <div class="col-sm-9">
		      	<div class="text-left pt-7"><strong id="userName"></strong></div>
		      </div>
		    </div>
	    </div>
		<div class="form-group">
	    	<div class="col-sm-6">
			  <label class="col-sm-3 control-label">workId</label>
		      <div class="col-sm-9">
				  <div class="text-left pt-7"><strong id="workId"></strong></div>
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
	url:basePath + "user/${param.id}",
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