<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/plugins/vital/views/include/taglib.jsp"%>
<html>
<head>
	<title>组织机构选择</title>
	<meta name="decorator" content="default"/>
	<script src="../jquery/jquery-1.8.3.min.js" type="text/javascript"></script>
	<link href="../jquery-ztree/3.5.12/css/zTreeStyle/zTreeStyle.min.css" rel="stylesheet" type="text/css"/>
	<script src="../jquery-ztree/3.5.12/js/jquery.ztree.all-3.5.min.js" type="text/javascript"></script>
	<link href="../jquery-select2/3.4/select2.min.css" rel="stylesheet">
	<script src="../jquery-select2/3.4/select2.min.js" type="text/javascript"></script>
	<script src="../vital-selector.js" type="text/javascript"></script>
	
</head>
<style>
.selector-title{
	font-weight: bold;
    color: #333;
    font-size: 15px;
    line-height: 27px;
    padding: 5px;
}


.selector-tree{
width:100%;
}

#chose-case{
border:1px solid #A0A0A4;
height:410px;
overflow:auto;
}

.select-case,.select-domain{
width:54%;
}

hr{
border: 0.1px solid #fff;
}
</style>
<script type="text/javascript">
	
	//获取数据条件
	var domainid = getQueryString("domainid");
	var targetid = getQueryString("targetid");
	var multi = getQueryString("multi");
	var selected = getQueryString("selected");

	var tree={};
	var isCheckBoxSupport = false;
	
	var isexe = false;
	
	$(document).ready(function(){
		//初始化领域
		initDomain();
		
		//初始化实例选择下拉列表
		refreshCase(function(s){
			targetid = s;
			refreshTree();
		});
		
		//领域改变事件
		$("#select-domain").on("change",function(e){
			domainid = e.val;
			refreshCase(function(s){
				targetid = s;
				refreshTree();
			});
		})
		
		//实例改变事件
		$("#select-case").on("change",function(e){
			targetid = e.val;
			refreshTree();
		})
		
		
		//获取选择按钮 是否支持多选
		if(getQueryString("multi") == 1){
			$("#isMuilty").attr("checked","checked");
		}else{
			$("#isNoMuilty").attr("checked","checked");
		}
		
		refreshTree();
	});
	
	function refreshCase(callback){

		
		$.get('/vital/a/sys/helper/target',{domainId:domainid},function(tags){
			
			var targetItems = '';
			var rid = '';
			$.each(tags,function(i,rs){
				if(targetid == rs.id){
					rid = targetid;
					targetItems += '<option value="'+rs.id+'" selected="selected">'+rs.name+'</option>';
				}else{
					rid = tags[0].id;
					targetItems += '<option value="'+rs.id+'">'+rs.name+'</option>';
				}
			})
			
			$("#select-case").html(targetItems);
			
			$("#select-case").select2();
			
			callback(rid);
		})
		
	}
	
	function initDomain(){

		$.get('/vital/a/sys/helper/domain',function(domains){
			var domainItems = '';
			
			$.each(domains,function(i,rs){
				if(domainid == rs.id){
					
					domainItems += '<option value="'+rs.id+'" selected="selected">'+rs.name+'</option>';
				}else{
					domainItems += '<option value="'+rs.id+'">'+rs.name+'</option>';
				}
			})
			
			$("#select-domain").html(domainItems);
			
			$("#select-domain").select2()
		})
		
	}
	
	
	function refreshTree(){
		isCheckBoxSupport = $('[name="isMuilty"]:checked').val()=='Y'?true:false;
		var setting = {
			data: {
			simpleData: {
				enable: true
			}
		}};
		
		if(isCheckBoxSupport){
			setting = {check:{enable:isCheckBoxSupport,nocheckInherit:true},view:{selectedMulti:false},
					data:{simpleData:{enable:true}},callback:{beforeClick:function(id, node){
						tree.checkNode(node, !node.checked, true, true);
						return false;
					}}};
		}
		// 组织机构数据
		var zNodes=[];
		$.ajax({url:'/vital/a/sys/helper/office/treeData',
				type:'get',
				async:false,
				data: {type:2,targetId:targetid},
				success: function(rs){
					zNodes = rs;
				}
		});
		// 初始化树结构
		tree = $.fn.zTree.init($("#select-org"), setting, zNodes);
		// 不选择父节点
		tree.setting.check.chkboxType = { "Y" : "ps", "N" : "s" };
		// 默认选择节点
		var ids = selected.split(",");
		for(var i=0; i<ids.length; i++) {
			var node = tree.getNodeByParam("id", ids[i]);
			try{tree.checkNode(node, true, false);}catch(e){}
		}
		// 默认展开全部节点
		tree.expandAll(true);
	}
	
</script>
<body>
	<div class="content">
		<div id="chose-case" class="content-left">
			<div class="selector-title" style="display: none">
				<label>选择领域：</label>
				<select id="select-domain" class="select-domain" name="domain">
				  
				</select>
				<br>
				<hr>
				<label>选择工程：</label>
				<select id="select-case" class="select-case" name="target">
				  
				</select>
				<br>
				<hr>
				<div>
				   <label for="isMuilty">是否允许多选：</label>
				   <label class="checkbox-inline">
				      <input type="radio" name="isMuilty" id="isMuilty" 
				         value="Y" checked onchange="refreshTree()"> 是
				   </label>
				   <label class="checkbox-inline">
				      <input type="radio" name="isMuilty" id="isNoMuilty" 
				         value="N" onchange="refreshTree()"> 否
				   </label>
				</div>
			</div>
			
			<div id="select-org" class="ztree selector-tree" style="margin-top:3px;padding: 2px 0px"></div>
		</div>
	</div>
</body>
</html>