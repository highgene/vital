<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="/fwebUI/header.jsp"%>   
<div class="row v_m_lr_15">
<div class="scrollable" data-size="285" data-position="left">
	<div class="col-sm-12">
	<form id="saveForm" action="${Config.baseURL}bpm/bpm/model/create" target="_blank" method="post">
		<table>
			<tr>
				<td>名称：</td>
				<td>
					<input id="name" name="name" type="text" />
				</td>
			</tr>
			<tr>
				<td>KEY：</td>
				<td>
					<input id="key" name="key" type="text" />
				</td>
			</tr>
			<tr>
				<td>描述：</td>
				<td>
					<textarea id="description" name="description" style="width:300px;height: 50px;"></textarea>
				</td>
			</tr>
		</table>
        </form>
	</div>
</div>
</div>
<div class="col-xs-12 clearfix form-actions v_btn_brn">
	<a> <span class="btn btn-sm btn-primary pull-right"> <i class="ace-icon fa fa-floppy-o bigger-130"></i> <span class="bigger-110">创建模型</span> </span> </a>&nbsp;&nbsp; 
</div>
</body>
</html>
<script type="text/javascript">
var basePath = '${Config.baseURL}';
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
		if (!$('#name').val()) {
			$.alert('error','请填写名称！');
			$('#name').focus();
			return false;
		}
		if (!$('#key').val()) {
			$.alert('error','请填写key！');
			$('#key').focus();
			return false;
		}
		$.ajax({
			url:basePath + 'bpm/bpm/model/checkKey/' + $('#key').val().trim(),
			success : function(result){
				if(result){
					form.submit();
					setTimeout(function(){window.parent.$('#fwebModal_create').modal('hide');},1000);
				}else{
					$.alert('error','key已存在请更换');
				}
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