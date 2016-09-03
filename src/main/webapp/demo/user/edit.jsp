<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE HTML>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>编辑</title>
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
		      <div class="col-sm-9 required-field-block">
				  <b class="required-icon">*</b>
				  <input type="text" class="form-control" name="birthDate" required>
		      </div>
		    </div>
			<div class="col-sm-6">
			  <label class="col-sm-3 control-label">email</label>
		      <div class="col-sm-9">
		      	<input type="text" class="form-control" name="email">
		      </div>
		    </div>
	    </div>
	    <div class="form-group">
	    	<div class="col-sm-6">
			  <label class="col-sm-3 control-label">loginId</label>
		      <div class="col-sm-9 required-field-block">
				  <b class="required-icon">*</b>
				  <input type="text" class="form-control" name="loginId" required>
		      </div>
		    </div>
			<div class="col-sm-6">
			  <label class="col-sm-3 control-label">mobilePhone</label>
		      <div class="col-sm-9">
		      	<input type="text" class="form-control" name="mobilePhone">
		      </div>
		    </div>
	    </div>
	    <div class="form-group">
	    	<div class="col-sm-6">
			  <label class="col-sm-3 control-label">password</label>
		      <div class="col-sm-9 required-field-block">
				  <b class="required-icon">*</b>
				  <input type="text" class="form-control" name="password" required>
		      </div>
		    </div>
			<div class="col-sm-6">
			  <label class="col-sm-3 control-label">phone</label>
		      <div class="col-sm-9">
		      	<input type="text" class="form-control" name="phone">
		      </div>
		    </div>
	    </div>
	    <div class="form-group">
	    	<div class="col-sm-6">
			  <label class="col-sm-3 control-label">photo</label>
		      <div class="col-sm-9 required-field-block">
				  <b class="required-icon">*</b>
				  <input type="text" class="form-control" name="photo" required>
		      </div>
		    </div>
			<div class="col-sm-6">
			  <label class="col-sm-3 control-label">sex</label>
		      <div class="col-sm-9">
		      	<input type="text" class="form-control" name="sex">
		      </div>
		    </div>
	    </div>
	    <div class="form-group">
	    	<div class="col-sm-6">
			  <label class="col-sm-3 control-label">signCard</label>
		      <div class="col-sm-9 required-field-block">
				  <b class="required-icon">*</b>
				  <input type="text" class="form-control" name="signCard" required>
		      </div>
		    </div>
			<div class="col-sm-6">
			  <label class="col-sm-3 control-label">userName</label>
		      <div class="col-sm-9">
		      	<input type="text" class="form-control" name="userName">
		      </div>
		    </div>
	    </div>
		<div class="form-group">
	    	<div class="col-sm-6">
			  <label class="col-sm-3 control-label">workId</label>
		      <div class="col-sm-9 required-field-block">
				  <b class="required-icon">*</b>
				  <input type="text" class="form-control" name="workId" required>
		      </div>
		    </div>
	    </div>
	</form>
	</div>
</div>
</div>
<div class="col-xs-12 clearfix form-actions v_btn_brn">
	<a> <span class="btn btn-sm btn-primary pull-right"> <i class="ace-icon fa fa-floppy-o bigger-130"></i> <span class="bigger-110">保存</span> </span> </a>&nbsp;&nbsp; 
</div>

<script type="text/javascript">
var basePath = '${Config.baseURL}';
$("#saveForm").dataForm({
	url:basePath + "user/${param.id}"
});
$(".btn-primary").click(function(){
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
		var user = $(form).serializeObject();
		user.id = "${param.id}";
		$.ajax({
			url : basePath + "user",
			type : 'post',
			data : $.toJSON(user),
			contentType : 'application/json;charset=UTF-8',
			success : function(data) {
				window.parent.$('#fwebModal').modal('hide');
				window.parent.queryUser();
			},
			error : function() {
				$.alert("error","保存失败！");
			}
		});
    } 
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