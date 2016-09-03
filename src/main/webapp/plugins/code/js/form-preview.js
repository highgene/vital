	function formRemoveData(){
		$.messager.confirm("操作提示", "确认删除吗？", function (ok) {  
	       if(ok){
				$.ajax({
					url : formUrl+searchId,
					type : 'delete',
					success : function(data) {
						$.messager.alert('操作提示', '删除成功！','info');
					},
					error : function() {
						$.messager.alert('操作提示', '删除失败！','error');
					}
				});
	       }
		});
	}
	function formCancel(){
			if (confirm("您确定要离开本页吗？")) {
			window.opener= null;
			window.open("","_self");
			window.close();
			if(window){
			   window.location.href="about:blank";
			}
			} else {} 
}
	function formTopWindowClose(){
		$('#formDialog').dialog('close');
}

