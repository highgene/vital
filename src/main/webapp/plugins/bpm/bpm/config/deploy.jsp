<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="/fwebUI/header.jsp"%>   
<div class="row v_m_lr_15">
<div class="scrollable" data-size="285" data-position="left">
	<div class="col-sm-12">
	<form id="saveForm" class="form-horizontal" role="form">
	    <div class="form-group">
			<div class="col-sm-6">
		      <div class="col-xs-9">
		      	<fweb:file table="act_re_deployment" field="groupId" repeat="true"
							acceptFileTypes="bpmn|bpmn20.xml" />
		      </div>
		    </div>
	    </div>
	    
	</form>
	</div>
</div>
</div>
<div class="col-xs-12 clearfix form-actions v_btn_brn">
	<a> <span class="btn btn-sm btn-primary pull-right"> <i class="ace-icon fa fa-floppy-o bigger-130"></i> <span class="bigger-110">部署流程</span> </span> </a>&nbsp;&nbsp; 
</div>
<input type="hidden" id="baseFilePath" value="<%=com.hhwy.framework.configure.ConfigHelper.getConfig("unstructured.store.url")%>"/>
<script type="text/javascript" src="${Config.staticURL}fwebUI/js/fileupload/bpm.fileupload.js"></script>
</body>
</html>
<script type="text/javascript">
var basePath = '${Config.baseURL}';
$(".btn-primary").click(function(){
	$("#saveForm").submit();
});
$(document).ready(function(){
	initFile('groupId');
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
		var groupId = $("#groupId").val();
		$.ajax({
			url : basePath + "bpm/bpm/config/resource/"+groupId,
			type : 'POST',
			data : $.toJSON($(form).serializeObject()),
			contentType : 'application/json;charset=UTF-8',
			success : function(data) {
				window.parent.$('#fwebModal').modal('hide');
				window.parent.queryConfig();
			},
			error : function() {
				$.alert("error","部署失败！");
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