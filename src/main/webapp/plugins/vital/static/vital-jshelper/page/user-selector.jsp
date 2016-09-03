<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/plugins/vital/views/include/taglib.jsp"%>
<html>
<head>
	<title>用户选择</title>
	<meta name="decorator" content="default"/>
	<script src="../jquery/jquery-1.8.3.min.js" type="text/javascript"></script>
	<link href="../jquery-ztree/3.5.12/css/zTreeStyle/zTreeStyle.min.css" rel="stylesheet" type="text/css"/>
	<script src="../jquery-ztree/3.5.12/js/jquery.ztree.all-3.5.min.js" type="text/javascript"></script>
	<link href="../jquery-select2/3.4/select2.min.css" rel="stylesheet">
	<script src="../jquery-select2/3.4/select2.min.js" type="text/javascript"></script>
	<link href="../vital-selector.css" rel="stylesheet">
	<script src="../vital-selector.js" type="text/javascript"></script></head>
<style>
.selector-title{
	font-weight: bold;
    color: #333;
    font-size: 15px;
    line-height: 27px;
    padding: 5px;
}

.content-left,.content-right{
width:250px;
float:left;
}


.selector-tree{
width:100%;
}

.select-role,.select-user{
width:70%;
}

hr{
border: 0.1px solid #fff;
}

fieldset {
	min-height: 400px;
}

.content{
	padding: 10px;
}

#chose-case{
border:1px solid #A0A0A4;
height:322px;
overflow:auto;
}

.chose-case input,.chose-case label,li label{
cursor: pointer;
}

.hidden{
	display: none;
}

.show{
	display: block;
}

ul,li{
	list-style: none;
	margin: 0px;
	padding: 0px;
	font-weight: normal;
	color:black;
	font-family: "microsoft yahei";
}

</style>
<script type="text/javascript">

	//获取数据条件
	var url = getQueryString("url");
	var domainid = getQueryString("domainid");
	var targetid = getQueryString("targetid");
	
	var orgids = getQueryString("orgids");
	var multi = getQueryString("multi");
	var roleid = getQueryString("roleid");
	var selected = getQueryString("selected");
	
	var result = {};
	
	var tree={};
	$(document).ready(function(){

		//初始化领域
		initDomain(domainid);
		
		//初始化实例选择下拉列表
		refreshCase(domainid,function(s){
			targetid = s;
			refreshTree(true,orgids);
		});
		
		//领域改变事件
		$("#select-domain").on("change",function(e){
			domainid = e.val;
			refreshCase(domainid,function(s){
				targetid = s;
				refreshTree(true,orgids);
			});
			refreshRole(domainid);
		})
		
		//实例改变事件
		$("#select-case").on("change",function(e){
			targetid = e.val;
			refreshTree(true,orgids);
		})
		
		//初始化组织机构树
		refreshTree(true,orgids);
		
		//初始化角色
		refreshRole(domainid);
		
		//显示用户
		refreshUserByOrg(domainid);
		
		//初始化选人事件
		initChoseUserEvent();
	});
	
	//刷新角色数据
	function refreshRole(domainid, roleid, callback){
		$.get(url + 'sys/helper/role?domainId='+this.domainid,function(roles){
			var roleItems = '';
			
			$.each(roles,function(i,rs){
				if(this.roleid == rs.id){
					roleItems += '<li><input id="'+i+'" type="checkbox" checked="checked" name="role" value="'+rs.id+'" onchange="onRoleChange()"/><label for="'+i+'">'+rs.name+'</label></li>'
				}else{
					roleItems += '<li><input id="'+i+'" type="checkbox" name="role" value="'+rs.id+'" onchange="onRoleChange()"/><label for="'+i+'">'+rs.name+'</label></li>'
				}
			})
			
			$("#select-role").html(roleItems);
			
		})
	}
	
	//监听树节点文本选取事件
	 function zTreeOnClick(event, treeId, treeNode, clickFlag) {
		tree.checkNode(treeNode, !treeNode.checked, true, true);
		var orgs = getSelectOrgs();
		var orgids = '';
		for(var i=0;i<orgs.length;i++){
			orgids += (orgs[i].id + ((i==(orgs.length-1))?"":","));
		}
		
		refreshUserByOrg(domainid,targetid,orgids,$('[name="username"]').val(),function(rs){
			result = rs;
		});
	 }
	 
	 //监听复选框 选取事件
	 function zTreeOnCheck(event, treeId, treeNode, clickFlag) {
		var orgs = getSelectOrgs();
		var orgids = '';
		for(var i=0;i<orgs.length;i++){
			orgids += (orgs[i].id + ((i==(orgs.length-1))?"":","));
		}
		
		refreshUserByOrg(domainid,targetid,orgids,$('[name="username"]').val(),function(rs){
			result = rs;
		});
	 } 
	 
	//根据组织 刷新用户列表
	function refreshUserByOrg(d, t, o, r, callback){
		$.get(url + 'sys/helper/user_by_org?domainId='+d+'&targetId='+t+"&orgid="+o+"&userName="+r,function(users){
			var userItems = '';
			var obj = {};
			
			$.each(users,function(i,rs){
				
				obj[rs.id] = rs;
				if(selected == rs.id){
					
					userItems += '<option value="'+rs.id+'" selected="selected">'+rs.name+'</option>';
				}else{
					userItems += '<option value="'+rs.id+'">'+rs.name+'</option>';
				}
			})
			$("#select-user").html(userItems);
			$("#selected-user").html('');
			
			//回调返回 检索结果用户对象
			if($.isFunction(callback)){
				callback(obj);
			}
		})
	}

	//角色改变事件
	function onRoleChange(){
		
		var roid = '';
		$('input[name="role"]:checked').each(function(i,item){
			roid += (item.value + (($('input[name="role"]:checked').length-1 === i)?"":","));
		})
		refreshUserByRole(roid, $('[name="username"]').val(), function(rs){
			result = rs;
		});
	}
	
	//根据角色 刷新用户列表
	function refreshUserByRole(d, r, callback){
		$.get(url + 'sys/helper/user_by_role?roleId='+d+"&userName="+r,function(users){
			var userItems = '';
			var obj = {};
			
			$.each(users,function(i,rs){
				
				obj[rs.id] = rs;
				if(selected == rs.id){
					
					userItems += '<option value="'+rs.id+'" selected="selected">'+rs.name+'</option>';
				}else{
					userItems += '<option value="'+rs.id+'">'+rs.name+'</option>';
				}
			})
			$("#select-user").html(userItems);
			$("#selected-user").html('');
			
			//回调返回 检索结果用户对象
			if($.isFunction(callback)){
				callback(obj);
			}
		})
	}
	
	function initChoseUserEvent(){
		
		//移到右边
		$('#add').click(function(){
			//先判断是否有选中
			if(!$("#select-user option").is(":selected")){			
			}
			//获取选中的选项，删除并追加给对方
			else{
				$('#select-user option:selected').appendTo('#selected-user');
			}	
		});
			
		//移到左边
		$('#remove').click(function(){
			//先判断是否有选中
			if(!$("#selected-user option").is(":selected")){			
			}
			else{
				$('#selected-user option:selected').appendTo('#select-user');
			}
		});
		
		//全部移到右边
		$('#add_all').click(function(){
			//获取全部的选项,删除并追加给对方
			$('#select-user option').appendTo('#selected-user');
		});
		
		//全部移到左边
		$('#remove_all').click(function(){
			$('#selected-user option').appendTo('#select-user');
		});
		
		//双击选项
		$('#select-user').dblclick(function(){ //绑定双击事件
			//获取全部的选项,删除并追加给对方
			$("option:selected",this).appendTo('#selected-user'); //追加给对方
		});
		
		//双击选项
		$('#selected-user').dblclick(function(){
			$("option:selected",this).appendTo('#select-user');
		});
		
		$(window).keydown(function(event){
			switch(event.keyCode){
				case 13:
					refreshChoseCase();
					break;
			}
		});
		
		refreshChoseCase();
		
		if(multi == 0){
			//单选
			$("#selected-user").removeProp("multiple");
		}else{
			//多选
			$("#selected-user").prop("multiple","multiple");
		}
	}
	
	//刷新选择模板
	function refreshChoseCase(){
		var ck_type = $('[name="ck-type"]:checked').val();
		if(ck_type ==='role'){
			$("#select-org").removeClass("show");
			$("#select-org").addClass("hidden");
			$("#select-role").removeClass("hidden");
			$("#select-role").addClass("show");
			var roid = '';
			$('input[name="role"]:checked').each(function(i,item){
				
				roid += (item.value + (($('input[name="role"]:checked').length-1 === i)?"":","));
			})
			
			refreshUserByRole(roid, $('[name="username"]').val(), function(rs){
				result = rs;
			});
		}else if(ck_type ==='org'){
			$("#select-role").removeClass("show");
			$("#select-role").addClass("hidden");
			$("#select-org").removeClass("hidden");
			$("#select-org").addClass("show");
			var orgs = getSelectOrgs();
			var orgids = '';
			for(var i=0;i<orgs.length;i++){
				orgids += (orgs[i].id + ((i==(orgs.length-1))?"":","));
			}
			
			refreshUserByOrg(domainid,targetid,orgids,$('[name="username"]').val(),function(rs){
				result = rs;
			});
		}
	}
	
	//获取最终选择中的用户对象
	function getChoseUser(){
		var selectObjs = null;
		
		var rs = [];
		
		if(multi === 0){
			//单选
			selectObjs = $("#selected-user");
			rs.push(result[selectObjs.val()])
		}else{
			//多选
			selectObjs = $("#selected-user option");
			
			for(var i=0;i<selectObjs.length;i++){
				rs.push(result[selectObjs[i].value])
			}
		}
		return rs;
	}
</script>
<body>
	<div class="content">
		<div class="content-left">
			<fieldset class="selector-title">
				<legend>检索方式</legend>
				<div style="display: none">
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
				</div>
				<div class="chose-case">
					<input type="radio" id="type-org" name="ck-type" value="org" checked="checked" onchange="refreshChoseCase()">
					<label for="type-org">按机构</label>
					<input type="radio" id="type-role" name="ck-type" value="role" onchange="refreshChoseCase()">
					<label for="type-role">按角色</label>
					<br>
					<hr>
				</div>
				<div id="chose-case">
					<div id="select-org" class="ztree selector-tree" style="margin-top:3px;padding: 2px 0px;"></div>
					<ul id="select-role" class="select-role">
						
					</ul>
					
				</div>
			</fieldset>
		</div>
		<div class="content-right">
			<fieldset class="selector-title">
				<legend>人员选择</legend>
				<div class="selector-title" style="display: none">
					<label>角色：</label>
					<select id="select-role1" class="select-role1" name="role1">
					  
					</select>
					<br>
					<hr>
					<div>
					   <label for="isMuilty">是否允许多选：</label>
					   <label class="checkbox-inline">
					      <input type="radio" name="isMuilty" id="isMuilty" 
					         value="Y" checked onchange="refreshTree(true)"> 是
					   </label>
					   <label class="checkbox-inline">
					      <input type="radio" name="isMuilty" id="isNoMuilty" 
					         value="N" onchange="refreshTree(true)"> 否
					   </label>
					</div>
				</div>
				<div class="selector-title">
					<label>依据姓名查询：</label>
					<input type="text" name="username" /> 按下回车键查询
				</div>
				<div class="selector-title">
					<div class="selectbox">
						<div class="select-bar">
							<div style="float:none;font-weight: bold;"><span>候选人</span></div>
						    <select multiple="multiple" id="select-user">
						        
						    </select>
						</div>
						
						<div class="btn-bar">
						    <p><span id="add"><input type="button" class="btn" value=">" title="移动选择项到右侧"></span></p>
						    <p><span id="add_all"><input type="button" class="btn" value=">>" title="全部移到右侧"></span></p>
						    <p><span id="remove"><input type="button" class="btn" value="<" title="移动选择项到左侧"></span></p>
						    <p><span id="remove_all"><input type="button" class="btn" value="<<" title="全部移到左侧"></span></p>
						</div>
						<div class="select-bar">
							<div style="float:none;font-weight: bold;"><span>已选人</span></div>
						    <select id="selected-user" multiple="multiple"></select>
						</div>	
					</div>
				</div>
			</fieldset>
		</div>
	</div>
</body>
</html>