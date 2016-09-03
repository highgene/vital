<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>台账代码生成组件</title>
    <%@ include file="../header.jsp"%>
</head>
<body>
<div style="margin:0 0;"></div>
    <div class="easyui-layout" data-options="fit:true" >
    <div data-options="region:'north'" style="height:50px;background-image:url('${Config.staticURL}code/bg.jpg');">
         <h2 style="font-family:'微软雅黑'; font-weight:normal;">&nbsp;&nbsp;代码生成组件</h2>
    </div>
    <div data-options="region:'south',split:true" style="height:50px;">
    	<ul id="msg"></ul>
    </div>
    <div data-options="region:'west',split:true" title="功能树" style="width:200px;">
   		<div id="funTree" class="easyui-panel"  data-options="fit:true,href:'${Config.basePath}view/code/config/tree'" style="padding:1px" >
		 </div>
    </div>
    <div data-options="region:'center',title:'功能配置',iconCls:'icon-ok'">
    <div class="easyui-layout" data-options="fit:true" >
    <div data-options="region:'north'" style="height:36px;">&nbsp;
        <a href="javascript:void(0)" onclick="newFunction();" class="easyui-linkbutton" data-options="iconCls:'icon-add'">新增功能</a>
        <a href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-more'"
									onclick="viewFunctionConfig()">查看功能配置(JSON)</a>
    	<a href="javascript:void(0)" onclick="deploy()" class="easyui-linkbutton" data-options="iconCls:'icon-save'">部署</a>
    	<a href="javascript:void(0)" onclick="previewFunction()" class="easyui-linkbutton" data-options="iconCls:'icon-search'">预览</a>
    	<input class="easyui-searchbox" data-options="prompt:'请输入查询树的内容：',searcher:doSearch,menu:'#menunname'"  style="width:200px"></input>
   		<div id="menunname" style="width:120px">  
    	<div name="mzvalue">名字</div>  
   	</div>
    </div>  
    <div data-options="region:'center',split:true" style="height:50px;">
    <div id="funTabs" class="easyui-tabs"  data-options="fit:true,onSelect:function(title,index){refreshFrame(title,index)}">
    <div title="功能定义" data-options="iconCls:'icon-ok',closable:false,fit:true" style="padding:1px">
		<div id="功能定义" data-options="fit:true,isLoaded:false" style="padding:1px" ></div>
    </div>
    <div title="表配置" data-options="iconCls:'icon-ok',closable:false" style="padding:1px">
		<div id="表配置" data-options="fit:true" style="padding:0px" ></div>
    </div>
    <div title="子功能配置" data-options="iconCls:'icon-ok',closable:false" style="padding:1px">
    	<div id="子功能配置"  data-options="fit:true" style="padding:0px" ></div>
    </div>        
    <div title="列表配置" data-options="iconCls:'icon-ok',closable:false" style="padding:1px">
    	<div id="列表配置" class="easyui-panel"  data-options="fit:true" style="padding:0px" ></div>
    </div>
    <div title="表单配置" data-options="iconCls:'icon-ok',closable:false" style="padding:1px">
    	<div id="表单配置" class="easyui-panel"  data-options="fit:true" style="padding:0px" ></div>
    </div>
    <div title="预览" data-options="iconCls:'icon-ok',closable:false" style="padding:1px">
    	<div id="预览" class="easyui-panel"  data-options="fit:true" style="padding:0px" ></div>
    </div>
    <div title="代码" data-options="iconCls:'icon-smartart'" style="padding:1px">
    	<div id="代码" class="easyui-panel"  data-options="fit:true" style="padding:0px" ></div>
   	</div>
   	<div title="台账树" data-options="iconCls:'icon-smartart'" style="padding:1px">
    	<div id="台账树" class="easyui-panel"  data-options="fit:true" style="padding:0px" ></div>
   	</div>
   	<div title="选项" data-options="iconCls:'icon-smartart'" style="padding:1px">
    	<div id="选项" class="easyui-panel"  data-options="fit:true" style="padding:0px" ></div>
   	</div>
    <div title="代码模板" data-options="iconCls:'icon-smartart',closable:false" style="padding:1px">
    	<div id="代码模板" class="easyui-panel"  data-options="fit:true" style="padding:0px" ></div>
   	</div>
    <div title="说明" data-options="iconCls:'icon-help',closable:false" style="padding:10px">
           <ul>
           <b>代码生成的说明</b><br><br>
           1. 代码生成通过功能配置信息和代码模板，生成后端接口和前端页面结构；<br>
           2. 服务端代码生成的内容包括controller、domain、service;<br>
           3. 前端结构生成的包括列表、表单及其详细信息；<br><br>
           <b>操作流程</b><br><br>
           1.点击"新增功能"按钮，设置功能定义--> 配置实体 --> 配置子功能 --> 配置列表 --> 配置表单 --> 功能预览 --> 功能发布
           </ul>
   	</div>
    </div>
    </div>
</div>
<p id="msg_功能定义"><b>功能定义:</b>定义功能的基本属性，包括功能名称、编号、实体的名称和代码模板</p>
<p id="msg_表配置"><b>表配置:</b>配置表的属性，即与数据库表映射的实体对象，实体属性即数据库的字段。
					其中id、createUser、createTime、updateUser、updateTime是公有字段不需要配置。<br><b>注：引用字段使用'@Transient'注解!</b></p>
<p id="msg_子功能配置"><b>子功能配置:</b>配置功能各个页面的按钮</p>
<p id="msg_列表配置"><b>列表配置:</b>配置列表的属性，包括显示哪些列、查询条件等</p>
<p id="msg_表单配置"><b>表单配置:</b>配置表单属性，包括字段的控件类型、编辑状态等</p>
<p id="msg_预览"><b>功能预览:</b>查看功能配置的效果</p>
<p id="msg_代码"><b>代码管理:</b>管理生产的代码信息，提供查看、提交svn等功能</p>
<p id="msg_台账树"><b>台账树:</b>台账配置成通用树菜单，台账数据作为菜单项</p>
<p id="msg_选项"><b>选项:</b>台账配置成通用选择控件，台账数据作为选项</p>
<p id="msg_代码模板"><b>代码模板:</b>代码模板库，提供查询、模板信息概览的功能</p>
<div id="templateViewerDialog" class="easyui-dialog"  closed="true"  style="width:80%;height:500px;padding:10px" 
	 	 data-options="title:'查看模板',
			iconCls:'icon-search', 
			maximizable:true,
			resizable:true,
			autoOpen: false">
		<textarea id="templateViewer" cols="108" rows="20">&nbsp;</textarea>
</div>

<script type="text/javascript">
var basePath = '${Config.basePath}';
//功能树数据
var treeData = null;	
var frames = {};
var funId = "";
var frameUrls = {'功能定义':'view/code/config/function',
			'表配置':'view/code/config/entity',
			'子功能配置':'view/code/config/buttons',
			'列表配置':'view/code/config/list',
			'表单配置':'view/code/config/form',
			'预览':'code/page/preview/list/easyui',
			'代码':'view/code/config/code',
			'台账树':'view/code/config/configTree',
			'选项':'view/code/config/options',
			'代码模板':'view/code/config/templateList'};
function init(functionId){
	funId = functionId;
	for(var i = 0; i <= 7; i++){
		frames['功能定义']=true;
		frames['表配置']=true;
		frames['子功能配置']=true;
		frames['列表配置']=true;
		frames['表单配置']=true;
		frames['预览']=true;
		frames['代码']=true;
		frames['台账树']=true;
		frames['选项']=true;
		frames['代码模板']=true;
	}
	$("#funTabs").tabs('select',0);
	refreshFrame('功能定义');
}
function deploy(){
	if(funId == "undefined" || funId== ""){
		$.messager.alert('警告','请选择功能后执行编译操作！');
		return;		
	}
	
	$.ajax({
		url : basePath + "code/config/deploy/"+funId,
		type : 'get',
		cache : false,
		success : function(data) {
			$.messager.show({
				title : '提示信息!', 
				msg : '部署成功！'
			});
		},
		error : function() {
		}
	});
	
}
function previewFunction(){
	window.open(basePath + "code/page/preview/alone/list/easyui?funId="+funId,'_previewFunction','width=800,height=600');
}
function uploadSVN(){
	$('#uploadSVNDialog').dialog('setTitle','上传到SVN');
	$('#uploadSVNDialog').dialog('open');
}
(function($) {
	$.fn.extend({
		serializeObject : function() {
			var o = {};
			var a = this.serializeArray();
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
		},
	});
})(jQuery);
function viewFunctionConfig(){
	
	window.open(basePath+'view/code/config/functionJSON?funId='+funId,'_viewFunction','top=0,left=0,width=800,height=600,scrollbars=yes')
}
$(document).ready(function(){
	init();
});
function refreshFrame(title,index){
	$("#msg").html($("#msg_"+title).html());
	if(frames[title]){
		frames[title]=false;
		var frameUrl ;
		frameUrl = frameUrls[title]+"?funId="+funId;
		
		$("#"+title).panel({
		   	 href:basePath+frameUrl
		});
	}
}
function refreshTree(){
	$("#funTree").panel({
	    href:basePath+'view/code/config/tree'
	});
}
function newFunction(){
	init();
	$("#funTabs").tabs('select',0);
}
function doSearch(value,name){
	var flag=false;
	if(name=="idvalue"){
		var node= $('#functionTree').tree('find',value);
		if(node!=null){
			$('#functionTree').tree('expandTo', node.target).tree('scrollTo',node.target).tree('select', node.target);
			init(node.id);
			flag = true;
		}
	}
	if(name=="mzvalue"){
		var children = $('#functionTree').tree("getChildren");
		for(var i=0;i<children.length&&!flag;i++){
			if(children[i].text.split("[")[0].indexOf(value)>=0&&!flag){
				$('#functionTree').tree('expandTo', children[i].target).tree('scrollTo',children[i].target).tree('select', children[i].target);
				init(children[i].attributes.funId);
				flag = true;
			}
		}
	}
	if(!flag){
		init();
		refreshTree();
		alert("没有找到该节点，请添加！");
	}
 }
</script>
</body>
</html>