<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>

<ul id="functionTree" class="easyui-tree" style="width:100%;height:auto;padding:0px" data-options="
                 url:'${Config.staticURL}code/config/getFunctionsById',
                 method:'get',
                 animate:true,
                 formatter:function(node){
                     var s = node.text;
                     if (node.children){
                         s += '&nbsp;<span style=\'color:blue\'>(' + node.children.length + ')</span>';
                     }
                     return s;
                 },
                 onClick: function(node){
                 	if(node && node.attributes && node.attributes.funId)
						init(node.attributes.funId);
				},
				onLoadSuccess: function(node, data){
					treeData = data;
				}
             ">
</ul>
