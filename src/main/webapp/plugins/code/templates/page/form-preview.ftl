<#import "form-controls.ftl" as controls>
<#setting number_format="#">
<div >
	<div class="list-add-header">
		<span>
				
				<#if action=="add">
				${gnmc!}-新增
				<#elseif action=="edit">
				${gnmc!}-修改
				<#else>
				${gnmc!}-展示
				</#if>
		</span>
	</div>						
	<div class="list-add-main mar-t10">
		<form id="pageForm_${funId}">
			<#if formControls ??>
				<#list formControls?sort_by(["serialNumber"]) as control>
				  <#if control.control != "radiobox"&& control.control != "checkbox">
					<#if control_index % 2 == 0>
					<div class="f-l mar-t20 list-add-item">
					<#else>
					<div class="f-r mar-t20 list-add-item">
					</#if>
				  <#elseif control_index % 2 == 0>
				  	<div class="f-l mar-t20" >
				  <#elseif control_index % 2 == 1>
				  	<div class="f-r mar-t20" >
				  </#if>
					<label for="">${control.title}:</label>
						<#if control.control=="textbox">
				    	<@controls.textbox name="${control.name}" required="${control.required}" width="${control.width}" value="${control.defaultValue!}" isshow="${control.isshow!}" precision="${control.precision!}" type="${control.type}" maxlength="${control.maxlength}" tip="${control.tip}" title="${control.title}" />
						</#if>
						<#if control.control=="file">
				    	<@controls.file name="${control.name}" required="${control.required}" width="${control.width}" value ="${control.defaultValue!}"  isshow="${control.isshow!}" maxlength="${control.maxlength}" tip="${control.tip}" title="${control.title}"/>
						</#if>
						<#if control.control=="datetimebox">
				    	<@controls.datetimebox name="${control.name}" value="${control.defaultValue!}" width="${control.width}"  required="${control.required}" isshow="${control.isshow!}" maxlength="${control.maxlength}" tip="${control.tip}" title="${control.title}"/>
						</#if>
						<#if control.control=="datebox">
				    	<@controls.datebox name="${control.name}" value="${control.defaultValue!}" width="${control.width}" required="${control.required}" isshow="${control.isshow!}" maxlength="${control.maxlength}" tip="${control.tip}" title="${control.title}"/>
						</#if>
						<#if control.control=="textareabox">
				    	<@controls.textareabox name="${control.name}" value="${control.defaultValue!}" width="${control.width}" required="${control.required}" isshow="${control.isshow!}" maxlength="${control.maxlength}" tip="${control.tip}" title="${control.title}"/>
						</#if>
						<#if control.control=="imgbox">
				    	<@controls.imgbox  url="${control.url}" isshow="${control.isshow!}"/>
						</#if>
						<#if control.control=="combobox">
				    	<@controls.combobox name="${control.name}" options=control.options value="${control.defaultValue!}" required="${control.required}" isshow="${control.isshow!}" maxlength="${control.maxlength}" tip="${control.tip}" title="${control.title}"/>
						</#if>
						<#if control.control=="radiobox">
				    	<@controls.radiobox name="${control.name}" options=control.options value="${control.defaultValue!}" required="${control.required}" isshow="${control.isshow!}" maxlength="${control.maxlength}" tip="${control.tip}" title="${control.title}"/>
						</#if>
						<#if control.control=="checkbox">
				    	<@controls.checkbox name="${control.name}" options=control.options checkednames=control.checkednames required="${control.required}" isshow="${control.isshow!}" maxlength="${control.maxlength}" tip="${control.tip}" title="${control.title}"/>
						</#if>
					</div>
					<#if control_index % 2 == 1>
					<div class="clear"></div>
					</#if>
				    </#list>
		    	</#if>
		    	<#if action=="edit">
		    		<input  hidden="true"  type="text" name="id"/>
		    	</#if>
		   	 </form>
		   	<div class="clear"></div>
		   	<@controls.formbuttons fbuttons=buttons />
	</div>
</div>

<script type="text/javascript" charst="utf-8">
	$(":submit").click(function(){
		if(!$("#pageForm_${funId}").form('validate')){
		return false;
		}
	})
	var formUrl 	= '${baseURL!}${mapping!}/${controllerMapping!}/';
	var funId   	= '${funId!}';
	var searchId	= '${id!}';
	var formControls= formControls;
	<#if action=="edit">
	     $("#pageForm_"+funId).form('load', formUrl+'form/'+funId+'/'+searchId);
	</#if>
	<@controls.formClicks formControls=formControls />
</script>
	
<script type="text/javascript"
	src="${staticURL}code/js/form-preview.js"></script>