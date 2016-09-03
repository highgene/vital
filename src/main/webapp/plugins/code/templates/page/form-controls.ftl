<#macro textbox name required width value isshow precision maxlength tip title type>
<input class="easyui-textbox" type="text" name="${name}" ${isshow} value="${value}" data-options="required:${required},validType:[<#if precision?length gt 0 >'floatPrecision[${precision}]',</#if> 'length[0,${maxlength}]','${type}']"  invalidMessage="${tip}" missingMessage="${title}不能为空." style="width:${width}"></input>
</#macro>
<#macro combobox name options value required isshow tip title maxlength>
<select class="easyui-combobox" name="${name}"  data-options="required:${required},editable:false " ${isshow}  missingMessage="${title}不能为空.">
	<option value=""></option>
	<#list options as option>
	<option value="${option.value}"  <#if value==option.showValue >selected</#if> >${option.showValue}</option>
	</#list>
</select>
</#macro>

<#--时间选择(精确秒) 6/6/2015 12:00:00 修改源码包$.fn.datebox.defaults.formatter-->
<#macro datetimebox name value required width isshow maxlength tip title>
<input class="easyui-datetimebox" ${isshow} type="text" name="${name}" data-options="required:${required},showSeconds:true,validType:['length[0,${maxlength}]','datetimebox']"  invalidMessage="${tip}" missingMessage="${title}不能为空."  value="${value}" style="width:${width}"></input>
</#macro>

<#--时间选择(精确天) 10/10/2015-->
<#macro datebox name required value width isshow maxlength tip title>
<input class="easyui-datebox" ${isshow}  type="text" name="${name}" data-options="required:${required},validType:['length[0,${maxlength}]','datebox']"  invalidMessage="${tip}" missingMessage="${title}不能为空."  value="${value}"  style="width:${width}"></input>
</#macro>

<#--文件选择-->
<#macro file name required width value isshow maxlength tip title>
<input class="easyui-filebox" ${isshow} type="text" name="${name}" data-options="prompt:'请选择文件...',required:${required}"  missingMessage="${title}不能为空."  style="width:${width}" value="${value}"></input>
</#macro>

<#--图片引用-->
<#macro imgbox url isshow>
<img src='${url}' ${isshow} style="height:100%;width:100%" >
</#macro>

<#--单选框 options:所有单选框按钮  value:默认选择的值-->
<#macro radiobox options value name required isshow maxlength tip title>
	<#list options as option>
	<input type="radio" ${isshow}  name="${name}"  id="radiobox${name}${option.showValue}${option_index}" value="${option.value}" <#if value==option.showValue >checked</#if> /><label for="radiobox${name}${option.showValue}${option_index}">${option.showValue}</label>&nbsp&nbsp
	</#list>
</#macro>

<#--复选框 options:是所有的值 checkednames:选中的值 showValue:显示的值-->
<#macro checkbox name options checkednames required isshow maxlength tip title>
	<#list options as option>
	<input type="checkbox" ${isshow}  name="${name}" <#if required =="true"&&option_index ==0> required </#if> id="checkbox${name}${option.showValue}${option_index}" value="${option.value}" <#list checkednames as checkedname> <#if checkedname==option.showValue >checked</#if> </#list> /><label for="checkbox${name}${option.showValue}${option_index}">${option.showValue}</label>&nbsp&nbsp
	</#list>
</#macro>

<#--文本框 -->
<#macro textareabox name required value width isshow maxlength tip title>
<input class="easyui-textbox" name="${name}" ${isshow} data-options="multiline:true,required:${required},validType:['length[0,${maxlength}]']"  invalidMessage="${tip}" missingMessage="${title}不能为空." value="" style="width:295px;height:100px">
</#macro>

<#--页面的button按钮 样式已经引入 解决按钮冲突问题-->
<#macro formbuttons fbuttons>
<#if buttons ??>
	<div class="f-r mar-t30 list-add-btn">
			    <#list fbuttons as button>
			    	<#if button.type =="cancel">
				    <button  class="f-l cancel" onclick="formTopWindowClose()">${button.name!button.typeDesc}</button>
					</#if>
				</#list>
			    <#list fbuttons as button>
			    	<#if action =="add"&&(button.type =="save"||button.type =="add")>
					<button  class="f-l mar-l15 confirm" onclick="formAddData()">${button.name!button.typeDesc}</button>
					<#elseif action =="edit"&&(button.type =="edit"||button.type =="save")>
					<button  class="f-l mar-l15 confirm" onclick="formEditData()">${button.name!button.typeDesc}</button>
					</#if>
				</#list>
	</div>
</#if>
</#macro>



<#macro formClicks formControls>
	function formAddData(){
		
			var  addSeriData = $('#pageForm_'+funId).serializeObject();

			if($("#pageForm_"+funId).form('validate')){
							//验证checkbox及格式化checkbox数据
							<#list formControls as control>
								//判断checkbox是否必选
								<#if control.control == "checkbox" && control.required=="true">
									if ($(":checkbox[name='${control.name}']:checked").length == 0)
									{
										jQuery.messager.alert('失败:','你的${control.title}按钮未勾选.','info'); 
										return;
									}
								</#if>
								//格式化checkbox数据
								<#if control.control == "checkbox">
								 var array_${control_index} =  addSeriData.${control.name};
										if(array_${control_index} instanceof Array){
										addSeriData.${control.name} = array_${control_index}.join(",");
									}
								</#if>
							</#list>
	
					    $.ajax({
					    url : formUrl,
					    type :'post',
						data:$.toJSON(addSeriData),
					    contentType : 'application/json;charset=UTF-8',
					    success : function(result) {
					    	if(null!=result&&result!=""){
					    		var message="";
					    		for(var i in result){
					    			message = message+(result[i].field+"字段"+result[i].defaultMessage+".")+'<br/>';
					    		}
					    		jQuery.messager.alert('失败:',message,'info'); 
					    	}else{
					    		jQuery.messager.alert('成功:','添加成功！','info'); 
					    	}
					    },
					    error : function() {
					    		jQuery.messager.alert('失败:','添加失败！','info'); 
					    }
					});
			}





	}
	
	function formEditData(){
		var  editSeriData = $('#pageForm_'+funId).serializeObject();
		
		if($("#pageForm_"+funId).form('validate')){
							//验证checkbox及格式化checkbox数据
							<#list formControls as control>
								//判断checkbox是否必选
								<#if control.control == "checkbox" && control.required=="true">
									if ($(":checkbox[name='${control.name}']:checked").length == 0)
									{
										jQuery.messager.alert('失败:','你的${control.title}按钮未勾选.','info'); 
										return;
									}
								</#if>
								//格式化checkbox数据
								<#if control.control == "checkbox">
								 var array_${control_index} =  editSeriData.${control.name};
										if(array_${control_index} instanceof Array){
										editSeriData.${control.name} = array_${control_index}.join(",");
									}
								</#if>
							</#list>
					$.ajax({
					url : formUrl,
					type : 'put',
					data:$.toJSON(editSeriData),
					contentType : 'application/json;charset=UTF-8',
					success : function(result) {
						if(null!=result&&result!=""){
							var message="";
							for(var i in result){
								message = message+(result[i].field+"字段"+result[i].defaultMessage+".")+'<br/>';
							}
							jQuery.messager.alert('失败:',message,'info'); 
						}else{
							jQuery.messager.alert('成功:','修改成功！','info'); 
						}
					},
					error : function() {
						jQuery.messager.alert('失败:','修改失败！','info'); 
					}
				});
			}
	}
</#macro>
