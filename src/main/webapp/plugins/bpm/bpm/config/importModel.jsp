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
							acceptFileTypes="bpmn20.xml|bpmn" />
		      </div>
		    </div>
	    </div>
	    
	</form>
	</div>
</div>
</div>
<div class="col-xs-12 clearfix form-actions v_btn_brn">
	<a> <span class="btn btn-sm btn-primary pull-right"> <i class="ace-icon fa fa-floppy-o bigger-130"></i> <span class="bigger-110">导入模型</span> </span> </a>&nbsp;&nbsp; 
</div>
</body>
<input type="hidden" id="baseFilePath" value="<%=com.hhwy.framework.configure.ConfigHelper.getConfig("unstructured.store.url")%>"/>
<script type="text/javascript" src="${Config.staticURL}fwebUI/js/fileupload/bpm.fileupload.js"></script>
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
			url : basePath + "bpm/bpm/model/importModel/"+groupId,
			type : 'POST',
			data : $.toJSON($(form).serializeObject()),
			contentType : 'application/json;charset=UTF-8',
			dataType:'json',
			success : function(data) {
				if(data['modelId']){
					$.alert("success","导入成功！")
					window.parent.$('#fwebModal_import').modal('hide');
					window.parent.queryConfig();
					parent.window.location = basePath + 'bpm/modeler.html?modelId='+data['modelId'];
				}else{
					$.alert("error","导入失败!"+data['msg']);
				}
			},
			error : function() {
				$.alert("error","导入失败！");
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