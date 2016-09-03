<#--包名-->
package ${bean.packagePath}.${bean.lowerPackageName}.controller;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.HashMap;
<#--引入接口类-->
import com.alibaba.fastjson.JSONObject;
import com.hhwy.code.config.model.TreeNode;
import ${bean.packagePath}.${bean.lowerPackageName}.service.${bean.name}Service;
import com.hhwy.framework.persistent.QueryResult;
<#--引入实体类-->
import ${bean.packagePath}.${bean.lowerPackageName}.domain.${bean.name};
import org.apache.commons.lang3.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;
import com.hhwy.framework.annotation.CodeGenerateInfo;

<#--属性验证-->
import javax.validation.Valid;
import org.springframework.validation.BindingResult;

/**
 * ${bean.name!}Controller
 * @author ${annotation.author!}
 * @date ${annotation.date!}
 * @version ${annotation.version!}
 */
@RestController
@RequestMapping("/${bean.lowerName!}")
@CodeGenerateInfo(functionId="${codeGenerateInfo.functionId!}", templateId="${codeGenerateInfo.templateId!}", desc="${codeGenerateInfo.desc!}")
public class ${bean.name}Controller{

	public static final Logger log = LoggerFactory.getLogger(${bean.name}Controller.class);
	
	/**
	 * ${bean.lowerName!}Service
	 */
	@Autowired
	private ${bean.name}Service ${bean.lowerName}Service;
	
	
		/**
	 * 分页获取对象${bean.name}
	 * @param ID
	 * @return ${bean.name}
	 */
	@RequestMapping(value = "/page", method = RequestMethod.GET)
	public QueryResult<?> get${bean.name}ByPage(@RequestParam Map<String, String> param) {
		QueryResult<?> result = ${bean.lowerName}Service.get${bean.name}ByPage(param);
		return result;
	}
		
	/**
	 * 获取树形结构数据
	 * @Title: get${bean.name}List
	 * @author zhaoweidong
	 * @Description: TODO(这里用一句话描述这个方法的作用)
	 * @param param
	 * @return
	 */
	@RequestMapping(value = "/list", method = RequestMethod.GET)
	public List<TreeNode> get${bean.name}List(@RequestParam Map<String, String> param) {
		List<TreeNode> nodeList = new ArrayList<TreeNode>();
		//节点ID字段
		String id = param.get("nodeIdField") == null ? "id" : param.get("nodeIdField");
		//根目录的编码
		String rootCode = param.get("rootCode") == null ? "id" : param.get("rootCode");
		//父ID关联字段
		String parentId = param.get("parentIdField") == null ? "parentId" : param.get("parentIdField");
		//判断查询条件中，父ID不为空
		if(!StringUtils.isEmpty(param.get(parentId))){
			param.remove(id);
			nodeList = getTreeNodeList(param);
			
		}else{
			//创建根目录节点
			TreeNode rootNode = new TreeNode();
			rootNode.setId(rootCode);			//默认根目录ID
			rootNode.setText("根目录");		//默认根目录名称
			processNodeList(rootNode,param);
			nodeList.add(rootNode);
		}
		return nodeList;
	}
	
	/**
	 * 根据条件查询结果，并封装成树形结构
	 * @Title: getTreeNodeList
	 * @author zhaoweidong
	 * @Description: TODO(这里用一句话描述这个方法的作用)
	 * @param param
	 * @return
	 */
	public List<TreeNode> getTreeNodeList(Map<String, String> param){
		QueryResult<?> result = ${bean.lowerName}Service.get${bean.name}ByPage(param);
		List<TreeNode> nodeList = new ArrayList<TreeNode>();
		List<?> dataList = result.getRows();
		String id = param.get("nodeIdField") == null ? "id" : param.get("nodeIdField");
		String text = param.get("nodeTextField") == null ? "name" : param.get("nodeTextField");
		String parentId = param.get("parentIdField") == null ? "parentId" : param.get("parentIdField");
		for(Object data : dataList){
			JSONObject dataObj = (JSONObject)JSONObject.toJSON(data);	
			TreeNode node = new TreeNode();
			node.setId(dataObj.getString(id));
			node.setText(dataObj.getString(text));			
			node.setAttributes(dataObj);
			node.setPid(dataObj.getString(parentId));
			param.put(parentId, node.getId());
			QueryResult<?> child = ${bean.lowerName}Service.get${bean.name}ByPage(param);
			if(child.getTotal()>0){
				node.setState("closed");
			}else{
				node.setState("open");
			}
			nodeList.add(node);
		}
		return nodeList;
	}
	
	/**
	 * 递归查询组装树形节点
	 * @Title: processNodeList
	 * @author zhaoweidong
	 * @Description: TODO(这里用一句话描述这个方法的作用)
	 * @param treeNode
	 * @param param
	 */
	public void processNodeList(TreeNode treeNode,Map<String,String> param){
		String parentId = param.get("parentIdField") == null ? "parentId" : param.get("parentIdField");
		String pid = treeNode.getId();
		param.put(parentId, pid);				//设置父ID
		param.put(parentId+"_queryType", "=");	//设置查询类型为等于
		List<TreeNode> children = getTreeNodeList(param);
		treeNode.setChildren(children);
		if(children!=null && children.size()>0){
			for(TreeNode node : children){
				processNodeList(node,param);
			}
		}
		
	}
	




	/**
	 * 根据ID获取对象${bean.name}
	 * @param ID
	 * @return ${bean.name}
	 */
	@RequestMapping(value = "/{id}", method = RequestMethod.GET)
	public ${bean.name} get${bean.name}ById(@PathVariable String id) {
		return ${bean.lowerName}Service.get${bean.name}ById(id);
	}	
	
	/**
	 * 根据ID获取对象Map<String,Object>
	 * @param ID
	 * @param funId
	 * @return Map<String,Object>
	 */
	@RequestMapping(value = "/form/{funId}/{id}", method = RequestMethod.GET)
	public Map<String,Object> get${bean.name}DataByNewId(@PathVariable String id,@PathVariable String funId) {
		return ${bean.lowerName}Service.get${bean.name}DataById(id,funId);
	}
	
	/**
	 * 添加对象${bean.name}
	 * @param 实体对象
	 */
	@RequestMapping( method = RequestMethod.POST)
	public Object save${bean.name}(@Valid @RequestBody ${bean.name} ${bean.lowerName}, BindingResult result) {
		if(result.hasErrors()){
			return result.getFieldErrors();
		}
		${bean.lowerName}Service.save${bean.name}(${bean.lowerName});
		return null;
	}
	
	/**
	 * 更新对象${bean.name}
	 * @param 实体对象
	 */
	@RequestMapping( method = RequestMethod.PUT)
	public Object update${bean.name}(@Valid @RequestBody ${bean.name} ${bean.lowerName}, BindingResult result) {
		if(result.hasErrors()){
			return result.getFieldErrors();
		}
		${bean.lowerName}Service.update${bean.name}(${bean.lowerName});
		return null;
	}
	
	/**
	 * 删除对象${bean.name}
	 * @param id
	 */
	@RequestMapping(value = "/{id}", method = RequestMethod.DELETE)
	public void delete${bean.name}(@PathVariable String id) {
		${bean.lowerName}Service.delete${bean.name}(new String[]{id});
	}	
}