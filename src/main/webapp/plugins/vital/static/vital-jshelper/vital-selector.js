/**
 * 根据url参数列表参数名 获取值
 */
function getQueryString(name) { 
	var reg = new RegExp("(^|&)" + name + "=([^&]*)(&|$)", "i"); 
	var r = window.location.search.substr(1).match(reg); 
	if (r != null) return unescape(r[2]); return null; 
}

//访问权限接口的地址
var url = "/vital/a/";

//初始化实例工程
function refreshCase(domainid, callback){

	
	$.get(url + 'sys/helper/target',{domainId:domainid},function(tags){
		
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

//初始化领域
function initDomain(domainid){

	$.get(url + 'sys/helper/domain',function(domains){
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

 
/**
 * 刷新组织机构树
 */
function refreshTree(isCheckBoxSupport, selected){
	//isCheckBoxSupport = $('[name="isMuilty"]:checked').val()=='Y'?true:false;
	var setting = {
		data: {
		simpleData: {
			enable: true
		}
	}};
	if(isCheckBoxSupport){
		setting = {check:{enable:isCheckBoxSupport,nocheckInherit:true},view:{selectedMulti:false},
				data:{simpleData:{enable:true}},callback:{onClick:zTreeOnClick,onCheck:zTreeOnCheck}};
	}
	// 组织机构数据
	var zNodes=[];
	$.ajax({url:url + 'sys/helper/office/treeData',
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

//获取机构选择结果
function getSelectOrgs() {
	var nodes = $('[name="isMuilty"]:checked').val()=='Y'?tree.getCheckedNodes(true):tree.getSelectedNodes();
	
	var orgs = [];
	for(var i=0; i<nodes.length; i++) {
		orgs.push(nodes[i]);
	}
	return orgs;
}

/**
 
 获取组织机构下的人员
 domainid, 表示在限定的领域下面选择，默认为系统领域
 targetid，表示在限定的工程实例中选择，默认为系统实例'eeeeefd91e0c11e6866500ff5d77254e'
 orgids，表示强制在指定的机构中选人，多个用逗号隔开，默认为空；
 roleid, 指定角色， 默认为空
 multi，表示是人员多选，还是单选。0是单选，1多选（默认值）；
 selected，表示已选中的用户，多个用逗号隔开，默认为空；
 callback，是在选人操作完成后后，回调的方法名称，回调返回选择用户的集合
*/
//获取数据条件

var showUser = function(domainid, targetid, orgids, multi, roleid, selected, callback){
	if(typeof domainid == 'undefined' || domainid == null || domainid === ''){
		//默认系统领域
		domainid = 'c0019e621f5a11e6866500ff5eeeeeee';
	}
	
	$.jBox.open("iframe:/vital/plugins/vital/static/vital-jshelper/page/user-selector.jsp?url="+url+"&domainid="+domainid+"&targetid="+targetid+"&orgids="+orgids+"&multi="+multi+"&roleid"+roleid+"&selected"+selected, "用户选择",800,510,{
		buttons:{"选择":"ok", "关闭":true}, bottomText:"",submit:function(v, h, f){
			
			var users = h.find("iframe")[0].contentWindow.getChoseUser();
			if (v=="ok"){
				if($.isFunction(callback)){
					callback(users);
				}
				return true;
			}
		}, loaded:function(h){
			$(".jbox-content", top.document).css("overflow-y","hidden");
		}
	});
}

/**
		 
获取组织机构
domainid,表示在限定的领域下面选择，默认为系统领域
targetid，表示在限定的工程实例中选择，默认为系统实例'eeeeefd91e0c11e6866500ff5d77254e'
multi，表示是否多选，0是单选，1多选（默认值）；
selected，表示已选中的机构，默认为空，多个用逗号隔开,并且注意此时强制多选即multi强制为1；
callback，是在选取组织机构操作完成后后，回调的方法名称，回掉返回所选组织机构对象集合；
*/
var showOrg = function(domainid, targetid, multi, selected, callback){

	if(typeof domainid == 'undefined' || domainid == null || domainid === ''){
		//默认系统领域
		domainid = 'c0019e621f5a11e6866500ff5eeeeeee';
	}
	
	if(typeof targetid == 'undefined' || targetid == null || targetid === ''){
		//默认系统实例'eeeeefd91e0c11e6866500ff5d77254e'
		targetid = 'eeeeefd91e0c11e6866500ff5d77254e';
	}
	
	if(typeof multi == 'undefined' || multi == null || multi === '' || (typeof selected != 'undefined' && selected != null && selected !== '')){
		//默认多选 或者当 已存在已选机构id时 强制多选
		multi = 1;
	}
	
	$.jBox.open("iframe:/vital/plugins/vital/static/vital-jshelper/page/org-selector.jsp?url="+url+"&domainid="+domainid+"&targetid="+targetid+"&multi="+multi+"&selected="+selected, "组织机构选择",400,500,{
		buttons:{"选择":"ok", "关闭":true}, bottomText:"",submit:function(v, h, f){
			
			var orgids = h.find("iframe")[0].contentWindow.getSelectOrgs();
			if (v=="ok"){
				if(typeof callback == 'function'){
					callback(orgids);
				}
				return true;
			}
		}, loaded:function(h){
			$(".jbox-content", top.document).css("overflow-y","hidden");
		}
	});
}