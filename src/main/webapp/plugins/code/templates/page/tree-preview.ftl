<link rel="stylesheet" type="text/css"
	href="${baseURL}code/style/themes/bootstrap/easyui.css"/>
<link rel="stylesheet" type="text/css"
	href="${baseURL}code/style/themes/icon.css"/>
<link rel="stylesheet" type="text/css"
	href="${baseURL}code/style/themes/demo.css"/>
<script type="text/javascript"
	src="${baseURL}code/js/jquery.min.js"></script>
<script type="text/javascript"
	src="${baseURL}code/js/jquery.easyui.min.js"></script>
<script type="text/javascript"
	src="${baseURL}code/js/jquery.json-2.2.js"></script>
<ul id="${funId}dataTree" class="easyui-tree" style="width:140px;">
</ul>
<#if contextMenuFlag==1>
<div id="${funId}contextMenu" class="easyui-menu"  style="width:80px;">
	<#if contextMenuList??>
	<#list contextMenuList as menuItem>
		<div onclick="callFun(${menuItem.clickFun})">${menuItem.text}</div>
	</#list>
	</#if>
</div>
</#if>

<script type="text/javascript" charst="utf-8">
	
	var treeId = '#${funId}dataTree';
	var menuId = '#${funId}contextMenu';
	
	//调用右键菜单的方法
	function callFun(fun){
		var node = $(treeId).tree('getSelected');
		fun(node);
	}
	
	//点击回调方法
	function callback(node){
		alert(node.text);
	}
	
	//获取选中的节点
	function getCheckedNode(){
		var nodes = $(treeId).tree("getChecked");
		console.log(nodes);
	}
	
	//初始化台账树
	$(function() {
		$(treeId).tree({   
			//URL分为一次性加载和异步加载
		    url: "${baseURL}code/${dataUrl}",
		    <#if asyncFlag==1>
		    	//展开前触发事件
		    	onBeforeExpand:function(node){
					$(treeId).tree("options").queryParams["${parentIdField}"] = node.id;
					$(treeId).tree("options").queryParams["${parentIdField}_queryType"] = "=";
		    	},
			</#if>		
		    <#if dragFlag==1>
		    	//判断是否开启拖拽
				dnd:true,
				//后续需要处理拖拽的相关操作方法
		    </#if>		    
		    <#if checkboxFlag==1>
		    //判断是否显示复选框
		    	checkbox:true,
		    </#if>
		    <#if contextMenuFlag==1>
		    	//判断是否加载设置右键菜单
			    onContextMenu: function(e, node){
						e.preventDefault();
						// 查找节点
						$(treeId).tree('select', node.target);
						// 显示快捷菜单
						$(menuId).menu('show', {
							left: e.pageX,
							top: e.pageY
						});
				},
		    </#if>
		    <#if nodeClickFun??>
			    //节点点击事件
			    onClick:function(node){
			    	${nodeClickFun}(node);
			    },
		    </#if>
			    method : "get",
			    queryParams:{
			     	<#if asyncFlag==1>
			     	${parentIdField}:'${rootCode}',
			     	${parentIdField}_queryType:"=",
			     	</#if>
			     	rootCode:'${rootCode}',		//根节点编码
			     	parentIdField:'${parentIdField}',	//父ID字段
			     	nodeTextField:'${nodeTextField}',	//节点名称字段
			     	nodeIdField:'${nodeIdField}',		//节点ID字段
			    	pageSize:1000,		//默认查询数量
			    	pageIndex:0			//默认查询第一页
			    }
		}); 
		
	});
</script>   
