<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<link rel="stylesheet" href="${Config.staticURL}/plugins/code/style/themes/bootstrap/easyui.css">
<script type="text/javascript" src="${Config.staticURL}/plugins/code/js/jquery.min.js"></script>
<script type="text/javascript" src="${Config.staticURL}/plugins/code/js/jquery.easyui.min.js"></script>
<script type="text/javascript" src="${Config.staticURL}/plugins/code/js/easyui-lang-zh_CN.js"></script>
<script type="text/javascript" src="${Config.staticURL}/plugins/code/js/jquery.form.js"></script>
<script type="text/javascript" src="${Config.staticURL}/plugins/code/js/jquery.json-2.2.js"></script>
<style type="text/css">
  #sui_form {
    margin: 0;
    padding: 10px 30px;
  }
  
  .fitem {
    margin-bottom: 5px;
    color:green
  }
  
  .fitem label {
    display: inline-block;
    width: 80px;
  }
</style>
</head>
<body>
  <table id="sui_datagrid" class="easyui-datagrid" style="height:100%;width:100%;"
  	data-options="
    <#if ((listOptions.paging)?? && (listOptions.paging== "on"))>
    	url: '${Config.basePath}' + '${sceneName}/page/?funId=${listOptions.funId}',
    <#else>
    	url: '${Config.basePath}' + '${sceneName}/page/?page=1&rows=1000&funId=${listOptions.funId}',
    </#if>
    method:'get',
    <#if ((listOptions.paging)?? && (listOptions.paging== "on"))>
    	pagination: true,
    <#else>
    	pagination: false,
    </#if>
    toolbar:'#toolbar',
    <#if ((listOptions.serialnumber)?? && (listOptions.serialnumber== "on"))>
    	rownumbers: true,
    <#else>
    	rownumbers: false,
    </#if>
    fitColumns: false,
    <#if (listOptions.selectrow == "multiple")>
    	singleSelect: false,
    <#else>
    	singleSelect: true,
    </#if>
  	idField:'id',
  	<#if (listOptions.pagesize >0)>
    	pageSize: ${listOptions.pagesize},
    <#else>
    	pageSize: 10,
    </#if>
  	pageList:[${listOptions.pagesize}, ${listOptions.pagesize*2}, ${listOptions.pagesize*3}, ${listOptions.pagesize*4}, ${listOptions.pagesize*5}]
  	">
    <thead frozen="true">
		<tr>
		<#list lockProperties as property>
    		<#if (property.isList == "on")>
			<th field=${property.name} width=${property.columnWidth} 
	        data-options="formatter:formatter_fun"
	        rowspan=${property.rowspan} checkbox=${property.checkbox}>${property.desc!}</th>
        	</#if>
    	</#list>
		</tr>
	</thead>
    <thead>
	<#if (listProperties?size > 0)>
	    <tr>
	    	<#list listProperties as property>
	    		<#if ((property.isList)?? && (property.isList== "on"))>
	    			<#if (property.tableHeadMerge == '')>
	        <th field=${property.name!} width=${property.columnWidth!} 
	        data-options="formatter:formatter_fun"
	        rowspan=${property.rowspan!} checkbox=${property.checkbox!}>${property.desc!}</th>
	    			<#else>
	        <th data-options="formatter:formatter_fun" 
	        colspan=${property.colspan!} >${property.tableHeadMerge!}</th>
	    			</#if>
	    		</#if>
	    	</#list>
		</tr>
	</#if>
	<#if (secondListProperties?size > 0)>
		<tr>
			<#list secondListProperties as property>
				<#if property.isList == "on">
		<th field=${property.name!} width=${property.columnWidth!} 
		data-options="formatter:formatter_fun">${property.desc!}</th>
				</#if>
			</#list>
		</tr>
	</#if>
    </thead>
  </table>

  <div id="toolbar">
      <div class="btn-group" data-toggle="buttons" style="margin-top:5px;margin-bottom: 5px;">
        <button type="button" class="btn btn-success btn-labeled" onclick="doAdd()">
          <span>添加</span>
        </button>
        <button type="button" class="btn btn-green btn-labeled" onclick="doEdit()">
          <span>编辑</span>
        </button>
        <button type="button" class="btn btn-labeled btn-danger" onclick="doRemove()">
          <span>删除</span>
        </button>
      </div>
      
      <div>
        <form id="query">
        	<#list (lockProperties + listProperties + secondListProperties)  as property>
			<#if (property.isList?? && property.isList == "on" && property.isQuery?? && property.isQuery == "on")>
            <span>
                <span>${property.desc!}:</span>
                <#if property.queryControl??>
	                <#if (property.queryControl == 'textbox')>
	                <span>
	                    <input name="${property.name!}" style="line-height:16px;width:100px;border:1px solid #ccc">
	                </span>
	                </#if>
					<#if (property.queryControl == 'combobox')>
	                <span>
	                    <input class="easyui-combobox" name="${property.name!}" style="width: 100px"
	                    						 data-options="valueField: 'optionId',
	                    									    textField: 'optionText',
	                    									    url: '${property.dataSource!}',
	                    									    method: 'get'"></input>
	                </span>
	                </#if>
					<#if (property.queryControl == 'datebox')>
	                <span>
	                    <input name="${property.name!}" class="easyui-datebox" style="width: 100px"/>
	                </span>
	                </#if>
				<#else>
	                <span>
	                    <input name="${property.name!}" style="line-height:16px;width:100px;border:1px solid #ccc">
	                </span>
                </#if>
				<span>
                    <input name="${property.name!}" style="line-height:16px;width:100px;border:1px solid #ccc">
                </span>
                <input name="${property.name!}_queryType" value="${property.queryType!}" hidden>
            </span>
			</#if>
			</#list>
        </form>
        <button type="button" class="btn btn-labeled btn-success" onclick="doSearch()">
          <span>查询</span>
        </button>
      </div>
  </div>
  
  <!--form表单-->
  <div id="sui_dialog" class="easyui-dialog" buttons="#dlg-buttons" style="width:450px;height:300px;padding:10px 20px" closed="true">
    <form id="sui_form" method="post">
    <#list formProperties as property>
        <#if property.control??>
	        <#if (property.control == 'textbox')>
	        <div class="fitem">
	    		<label for="${property.name}">${property.desc!}:</label>
	    		<input class="easyui-validatebox" type="text" name="${property.name}" value="${property.defaultValue}" placeholder="${property.tip}" data-options="required:${(property.required=='on')?c}" />
	        </div>
	        </#if>
	        <#if (property.control == 'file')>
	        <div class="fitem">
	    		<label for="${property.name}">${property.desc!}:</label>
	    		<input class="easyui-validatebox" type="file" name="${property.name}" data-options="required:${(property.required=='on')?c}" />
	        </div>
	        </#if>
			<#if (property.control == 'combobox')>
	        <div class="fitem">
	        	<label for="${property.name}">${property.desc!}:</label>
	            <input class="easyui-combobox" name="${property.name!}"
	            						 data-options="valueField: 'optionId',
	            									    textField: 'optionText',
	            									    url: '${property.dataSource!}',
	            									    method: 'get'"></input>
	        </div>
	        </#if>
			<#if (property.control == 'datebox')>
	        <div class="fitem">
	        	<label for="${property.name}">${property.desc!}:</label>
	            <input name="${property.name!}" class="easyui-datebox"/>
	        </div>
	        </#if>
		<#else>
	        <div class="fitem">
	    		<label for="${property.name}">${property.desc!}:</label>
	    		<input class="easyui-validatebox" type="text" name="${property.name}" value="${property.defaultValue!}" data-options="required:${(property.required?? && property.required=='on')?c}" />
	        </div>
	    </#if>
    </#list>
    </form>
  </div>
  <div id="dlg-buttons">
    <a class="easyui-linkbutton" onclick="doSave()">保存</a>
    <a class="easyui-linkbutton" onclick="doClose()">取消</a>
  </div>
</body>

<script type="text/javascript">
  var url;
  var isEdit = false;
  
  function doAdd() {
        $('#sui_dialog').dialog('open').dialog('setTitle', '添加');
        $('#sui_form').form('clear');
        $("#sui_form input").each(function () {
	        setFormDefaultValue(this);
	    });
        url = "${Config.basePath}" + "${sceneName}";
        isEdit = false;
  }
  function doSave(){
	var boolean = $('#sui_form').form('validate');
	if(!boolean){
		return;
	}
    var formData = this.serializeObject($('#sui_form'));
    if(isEdit){
        var row = $('#sui_datagrid').datagrid('getSelected');
        formData.id = row.id;
    }
    $.ajax({
        url : url,
        type : 'post',
        data : $.toJSON(formData),
        contentType : 'application/json;charset=UTF-8',
        success : function(result) {
        	if(result && result.length){
        		var msg = '';
        		for(var index in result){
        			msg +=  '字段' + result[index].field + '错误！' + result[index].defaultMessage;
        		}
				$.messager.show({
					title: '错误',
		            msg: msg
				});
        	}else{
	          $('#sui_dialog').dialog('close');
	          $('#sui_datagrid').datagrid('reload');
        	}
        },
        error : function() {
          $.messager.show({
            title: '错误',
            msg: '保存出现错误！'
          });
        }
    });
    isEdit = false;
  }
  function doEdit () {
        var row = $('#sui_datagrid').datagrid('getSelected');
        if (row) {
          $('#sui_dialog').dialog('open').dialog('setTitle', '编辑');
          $('#sui_form').form('load', row);
          url = "${Config.basePath}" + "${sceneName}";
          isEdit = true;
        }
        else{
          	$.messager.confirm('错误','请选择要修改的数据')
        }
      }
      
    function doRemove() {
        var row = $('#sui_datagrid').datagrid('getSelected');
        if (row) {
            var remove_data = "${Config.basePath}" + "${sceneName}/" + row.id;
            $.messager.confirm('Del', '你确定要删除这条信息吗？', function (r) {
                if (r) {
                    $.ajax({
                        url : remove_data,
                        type : 'delete',
                        success : function(data) {
                            $('#sui_datagrid').datagrid('reload');
                        },
                        error : function(jqXHR, textStatus, errorThrown) {
                          $.messager.show({
                            title: '错误',
                            msg: result.msg
                          });
                        }
                    });
                }
            });
        }else{
            $.messager.confirm('错误','请选择要删除的数据')
        }
      }
      
     function doSearch() {
        $('#sui_datagrid').datagrid('load', serializeObject($('#query')));
      }
      
      function doClose (){
        $('#sui_dialog').dialog('close')
      }
      
      function formatter_fun(value, row, index){
    		var suEasyuiGridMetaData = {
			<#list (listProperties + secondListProperties + lockProperties) as property>
    			<#if (property.style?? || property.link??)>
        		${property.name}:{"style":"${property.style}", "link": "${property.link}"},
        		</#if>
        	</#list>
    		};
    	
        	var styleAndLink = suEasyuiGridMetaData[this.field];
        	if(styleAndLink){
        		if(styleAndLink.style && !styleAndLink.link){
        			return '<span style='+styleAndLink.style+'>'+ value +'</span>';
        		}else if(styleAndLink.link && !styleAndLink.style){
        			return '<a href='+styleAndLink.link+'>'+ value +'</a>';
        		}else if(styleAndLink.style && styleAndLink.link){
        			return '<a href='+styleAndLink.link+' style='+styleAndLink.style+'>'+ value +'</a>';
        		}else{
        			return value;
        		}
        	}else{
        		return value;
        	}
	    }
      
  function setFormDefaultValue(oInput){
  	var defauleValue = $(oInput).attr("value");
	$(oInput).val(defauleValue).css("color", "#999");

    return $("#sui_form").each(function () {
        $(oInput).focus(function () {
            if ($(oInput).val() == defauleValue) {
                $(oInput).val("").css("color", "#000"); //输入值的颜色 
            }
        }).blur(function () {
            if ($(oInput).val() == "") {
                $(oInput).val(defauleValue).css("color", "#999"); //默认值的颜色 
            }
        });
    });
  }
  
  function serializeObject($object) {
        var o = {};
        var a = $object.serializeArray();
        $.each(a, function() {
            if (o[this.name]) {
                if (!o[this.name].push) {
                    o[this.name] = [ o[this.name] ];
                }
                o[this.name].push(this.value || '');
            } else {
                o[this.name] = this.value || '';
            }
        });
        return o;
      }
</script>
</html>