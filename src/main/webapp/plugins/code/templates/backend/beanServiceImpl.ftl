<#--包名-->
package ${bean.packagePath}.${bean.lowerPackageName}.service.impl;

import java.beans.BeanInfo;
import java.beans.Introspector;
import java.beans.PropertyDescriptor;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Set;
import java.util.HashMap;
import java.util.Map;
import com.hhwy.framework.annotation.CodeGenerateInfo;
import com.hhwy.framework.persistent.DAO;

import java.util.Iterator;
import java.util.Map.Entry;
import com.hhwy.code.common.FunctionHelper;
import com.hhwy.code.config.domain.CodeFunction;
import com.hhwy.code.config.model.Config;
import com.hhwy.code.config.model.FormProperty;
import com.hhwy.framework.util.JsonUtils;
<#--引入接口类-->
import ${bean.packagePath}.${bean.lowerPackageName}.service.${bean.name}Service;
import com.hhwy.framework.persistent.QueryResult;
import com.hhwy.code.persistent.CommonDao;
import com.hhwy.framework.persistent.query.IWhereClause;
import com.hhwy.framework.persistent.query.impl.WhereClauseImpl;
<#--引入实体类-->
import ${bean.packagePath}.${bean.lowerPackageName}.domain.${bean.name};
import org.apache.commons.lang3.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

/**
 * ${bean.name}Service
 * @author ${annotation.author}
 * @date ${annotation.date}
 * @version ${annotation.version}
 */
@Component
@CodeGenerateInfo(functionId="${codeGenerateInfo.functionId}", templateId="${codeGenerateInfo.templateId}", desc="${codeGenerateInfo.desc}")
public class ${bean.name}ServiceImpl implements ${bean.name}Service {

	public static final Logger log = LoggerFactory.getLogger(${bean.name}ServiceImpl.class);
	
	@Autowired
	DAO<?> dao;
	@Autowired
	CommonDao commonDao;
	
	
	
	/**
	 * 分页获取对象${bean.name}
	 * @param ID
	 * @return ${bean.name}
	 */
	public QueryResult<?> get${bean.name}ByPage(Map<String, String> param){
		return commonDao.getPage(param);
	}
	
	
	public Map<String, Class<?>> getBeanNameTypeMap() {
		try {
			BeanInfo beanInfo = Introspector.getBeanInfo(${bean.name}.class);
			PropertyDescriptor[] propertyDesc = beanInfo.getPropertyDescriptors();
			Map<String, Class<?>> ntMap = new HashMap<>();
			for (int i = 0; i < propertyDesc.length; i++) {
				if (propertyDesc[i].getName().compareToIgnoreCase("class") == 0)
					continue;
				ntMap.put(propertyDesc[i].getName(), propertyDesc[i].getPropertyType());
			}
			return ntMap;
		} catch (Exception e) {
			e.printStackTrace();
		}
		return null;
	}
	
	/**
	 * 根据ID获取对象${bean.name}
	 * @param ID
	 * @return ${bean.name}
	 */
	public ${bean.name} get${bean.name}ById(String id) {
		return dao.findById(id, ${bean.name}.class);
	}
	
	/**
	 * 根据ID获取对象Map<String,Object> checkbox的转化
	 * @param ID
	 * @return Map<String,Object>
	 */
	public Map<String,Object> get${bean.name}DataById(String id,String funId) {
		Map<String,Object> map = JsonUtils.covertValue(dao.findById(id, ${bean.name}.class),Map.class);
		if(null!=map){
			CodeFunction function = FunctionHelper.getFunction(funId);
			Config config = function.getConfig();
			Map<String, FormProperty> formProperties = config.getFormProperties();
			Iterator<Entry<String, FormProperty>> iterator = formProperties.entrySet().iterator();
			while(iterator.hasNext()){
				Entry<String, FormProperty> next = iterator.next();
				if("checkbox".equals(next.getValue().getControl())){
					String name = next.getValue().getName();
					Object object = map.get(name);
					if(object!=null&&!"".equals(object.toString())){
						String[] split = String.valueOf(object).split(",");
						map.put(name,split);
					}
				}
			}
		}
		return map;
	}
	/**
	 * 添加对象${bean.name}
	 * @param 实体对象
	 */
	public void save${bean.name}(${bean.name} ${bean.lowerName}) {
		dao.save(${bean.lowerName});
	}
	
	/**
	 * 更新对象${bean.name}
	 * @param 实体对象
	 */
	public void update${bean.name}(${bean.name} ${bean.lowerName}) {
		dao.update(${bean.lowerName});
	}
	
	/**
	 * 删除对象${bean.name}
	 * @param id数据组
	 */
	public void delete${bean.name}(String[] ids) {
		dao.delete(ids, ${bean.name}.class);
	}	
}