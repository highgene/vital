<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/plugins/vital/views/include/taglib.jsp"%>
<html>
<head>
	<title>授权结果</title>
	<meta name="decorator" content="default"/>
	<%@include file="/plugins/vital/views/include/treetable.jsp" %>
	<script type="text/javascript">

		var tpl={};
		var rootId = "1";
		allSelectMenuMap=new Map();
		//	下拉框改变时
		function targetChanged(domainId) {
			var targetid=$("#target_"+domainId).val();
			var selectMenus = allSelectMenuMap.get(targetid);
			if (!selectMenus){
				selectMenus=[]
			}
			$("#treeTableList").empty();


			addRow("#treeTableList", tpl, selectMenus, rootId, true);
			$("#treeTable").treeTable({expandLevel : 4}).show();

		}

		function addRow(list, tpl, data, pid, root){
			for (var i=0; i<data.length; i++){
				var row = data[i];
				if ((${fns:jsGetVal('row.parentId')}) == pid){
					$(list).append(Mustache.render(tpl, {
						dict: {
							type: getDictLabel(${fns:toJson(fns:getDictList('sys_office_type'))}, row.type)
						}, pid: (root?0:pid), menu: row
					}));
					addRow(list, tpl, data, row.id);
				}
			}
		}


		$(document).ready(function() {
			tpl = $("#treeTableTpl").html().replace(/(\/\/\<!\-\-)|(\/\/\-\->)/g,"");
			var defaultDomainId='${domainList[0].id}';

			//	获取选中菜单
			$.getJSON("${ctx}/sys/user/allSelectMenu?userId=${user.id}",function(data) {
				for (var targetid in data) {//数据封装成Map
					list = []
					for (var menu in data[targetid]) {
						list.push(data[targetid][menu]);
					}
					allSelectMenuMap.set(targetid, list);
				}
				//设置默认
				targetChanged(defaultDomainId);
			});
		});

	</script>
</head>
<body>
<div class="control-group">
	<ul id="myTab" class="nav nav-tabs">
		<c:forEach items="${domainList}" var="domain"  varStatus="st">
			<li class="${st.index=='0'?"active":""}"> <a href="#domain_${domain.id}" data-toggle="tab"  onclick="javascript:targetChanged('${domain.id}')">${domain.domainName}</a></li>
		</c:forEach>

	</ul>
	<div id="myTabContent" class="tab-content">
		<c:forEach items="${domainList}" var="domain" varStatus="st">
			<div class="tab-pane fade ${st.index=='0'?"in active":""}" id="domain_${domain.id}">

					<div class="control-group" <c:if test="${domain.enableMulti!='1'}">hidden</c:if> >
						<div class="controls">
							<label class="control-label">所属实例:</label>
							<form:select path="id" onchange="javascript:targetChanged('${domain.id}')" id="target_${domain.id}">
								<form:options items="${targetMap[domain.id]}" itemLabel="objectName" itemValue="id" htmlEscape="false"/>
							</form:select>
						</div>
					</div>

			</div>
		</c:forEach>
	</div>
</div>
<table id="treeTable" class="table table-striped table-bordered table-condensed hide">
	<thead>
	<tr>
		<th>名称</th>
		<th>角色名称</th>
	</tr>
	</thead>
	<tbody id="treeTableList"></tbody>
</table>

<script type="text/template" id="treeTableTpl">
	<tr id="{{menu.id}}" pId="{{pid}}">
		<td nowrap>{{menu.resourceName}}</td>
		<td title="{{menu.roleName}}">{{menu.roleName}}</td>
	</tr>
</script>

</body>
</html>