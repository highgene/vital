<#--包名-->
package ${bean.packagePath}.${bean.lowerPackageName}.service;

<#--引入接口类-->
import ${bean.packagePath}.${bean.lowerPackageName}.service.${bean.name}Service;
import ${bean.packagePath}.${bean.lowerPackageName}.service.impl.${bean.name}ServiceImpl;
import com.hhwy.framework.annotation.CodeGenerateInfo;
import com.hhwy.framework.persistent.QueryResult;
import com.hhwy.framework.test.ServiceTest;
<#--引入实体类-->
import ${bean.packagePath}.${bean.lowerPackageName}.domain.${bean.name};
import com.hhwy.framework.container.AppContainer;
import org.junit.*;
import static org.junit.Assert.*;
<#list list as metaData>
<#if metaData.importPackage>
import ${metaData.importPackage};
</#if>
</#list>
/**
 * ${bean.name}Service
 * @author ${annotation.author}
 * @date ${annotation.date}
 * @version ${annotation.version}
 */
@CodeGenerateInfo(functionId="${codeGenerateInfo.functionId}", templateId="${codeGenerateInfo.templateId}", desc="${codeGenerateInfo.desc}")
public class ${bean.name}ServiceTest  extends ServiceTest{

	/**
	 * ${bean.lowerName}Service
	 */
	private ${bean.name}Service ${bean.lowerName}Service = AppContainer.getBean(${bean.name}ServiceImpl.class);
	private String id;
	private ${bean.name} ${bean.lowerName};
	private String[] ids;
	
	@Before
	public void before() {
	    start();
	    ${bean.lowerName} = new ${bean.name}();
<#list list as metaData>
	    ${bean.lowerName}.set${metaData.upperPropertyName}(${metaData.testValue});
</#list>
	    ${bean.lowerName}Service.save${bean.name}(${bean.lowerName});
		id = ${bean.lowerName}.getId();
		ids = new String[]{id};
	}
	
	@After
	public void after() {
	    end();
	}
	
	@Test
	public void TestGet${bean.name}ByPage() {
		QueryResult<${bean.name}> result = ${bean.lowerName}Service.get${bean.name}ByPage(null);
		assertNotNull(result.getTotal());
	}
	
	@Test
	public void testGet${bean.name}ById() {
		${bean.lowerName}Service.get${bean.name}ById(id);
	}
	
	@Test
	public void testGet${bean.name}DataById() {
		${bean.lowerName}Service.get${bean.name}DataById(id);
	}	
	
	@Test
	public void testSave${bean.name}() {
		${bean.lowerName}Service.save${bean.name}(${bean.lowerName});
	}
	
	@Test
	public void testUpdate${bean.name}() {
		${bean.lowerName}Service.update${bean.name}(${bean.lowerName});
	}
	
	@Test
	public void testDelete${bean.name}() {
		${bean.lowerName}Service.delete${bean.name}(ids);
	}	
}