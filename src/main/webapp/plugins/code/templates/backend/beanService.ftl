<#--包名-->
package ${bean.packagePath}.${bean.lowerPackageName}.service;

import java.util.Map;
import com.hhwy.framework.annotation.CodeGenerateInfo;
import com.hhwy.framework.persistent.QueryResult;
<#--引入实体类-->
import ${bean.packagePath}.${bean.lowerPackageName}.domain.${bean.name};

/**
 * I${bean.name}Service
 * @author ${annotation.author}
 * @date ${annotation.date}
 * @version ${annotation.version}
 */
@CodeGenerateInfo(functionId="${codeGenerateInfo.functionId}", templateId="${codeGenerateInfo.templateId}", desc="${codeGenerateInfo.desc}")
public interface ${bean.name}Service{
	
	/**
	 * 分页获取对象${bean.name}
	 * @param ID
	 * @return ${bean.name}
	 */
	public QueryResult<?> get${bean.name}ByPage(Map<String, String> param);
	
	/**
	 * 根据ID获取对象${bean.name}
	 * @param ID
	 * @return ${bean.name}
	 */
	public ${bean.name} get${bean.name}ById(String id);
	
	/**
	 * 根据ID获取对象${bean.name}
	 * checkbox转化成数组
	 * @param ID
	 * @return ${bean.name}
	 */
	public Map<String,Object> get${bean.name}DataById(String id,String funId);
	
	/**
	 * 添加对象${bean.name}
	 * @param 实体对象
	 * @return null
	 */
	public void save${bean.name}(${bean.name} ${bean.lowerName});
	
	/**
	 * 更新对象${bean.name}
	 * @param 实体对象
	 * @return ${bean.name}
	 */
	public void update${bean.name}(${bean.name} ${bean.lowerName});
	
	/**
	 * 删除对象${bean.name}
	 * @param id数据组
	 */
	public void delete${bean.name}(String[] ids);

}