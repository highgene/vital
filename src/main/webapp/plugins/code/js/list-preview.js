	function addBusinessData(){
		$('#formDialog').dialog({    
	    title: '编辑',    
	    width: '980px',    
	    height: '600px',    
	    closed: false,    
	    cache: false,    
	    href: basePath+'form/preview/form/easyui?action=add&funId='+funId,    
	    modal: true
	});
	}

	function editData(){
		var row = $('#'+gridId).datagrid('getSelected');
		$('#formDialog').dialog({    
	    title: '编辑',    
	    width: '980px',    
	    height: '600px',    
	    closed: false,    
	    cache: false,    
	    href: basePath+'form/preview/form/easyui?action=edit&funId='+funId+'&id='+row['id'],    
	    modal: true
	});
	}
	function removeData(){
		var row = $('#'+gridId).datagrid('getSelected');
		if(row == null){
			$.messager.alert('操作提示', '没有选择要删除的数据！','error');
			return ;
		}
		var rowIndex = $('#'+gridId).datagrid('getRowIndex',row);
		$.messager.confirm("操作提示", "确认删除吗？", function (ok) {  
	       if(ok){
				$.ajax({
					url : deleteURL+row['id'],
					type : 'delete',
					success : function(data) {
						$('#'+gridId).datagrid('deleteRow',rowIndex);
					},
					error : function() {
						$.messager.alert('操作提示', '删除失败！','error');
					}
				});
	       }
		});
	}
	function searchData(){
		 $('#'+gridId).datagrid('load', $('#'+queryFormId).serializeObject());
	}
	function exportData(){
		
		
	}

