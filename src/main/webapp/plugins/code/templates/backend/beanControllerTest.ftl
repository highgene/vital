<#--包名-->
package ${bean.packagePath}.${bean.lowerPackageName}.controller;

<#--引入实体类-->
import ${bean.packagePath}.${bean.lowerPackageName}.domain.${bean.name};
import com.hhwy.framework.annotation.CodeGenerateInfo;
import com.hhwy.framework.test.ControllerTest;
import com.hhwy.framework.persistent.QueryResult;

import static org.junit.Assert.*;
import org.junit.*;
<#list list as metaData>
<#if (metaData.importPackage)>
import ${metaData.importPackage};
</#if>
</#list>

/**
 * ${bean.name}Controller
 * @author ${annotation.author}
 * @date ${annotation.date}
 * @version ${annotation.version}
 */
@CodeGenerateInfo(functionId="${codeGenerateInfo.functionId}", templateId="${codeGenerateInfo.templateId}", desc="${codeGenerateInfo.desc}")
public class ${bean.name}ControllerTest extends ControllerTest {

	/**
	 * ${bean.lowerName}Controller
	 */
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
		super.postForObject("/${bean.lowerName}",${bean.lowerName});
		id = ${bean.lowerName}.getId();
		ids = new String[]{id};
	}
	
	@After
	public void after() {
         end();
	}
	
	@Test
	public void TestGet${bean.name}ByPage() {
		QueryResult<${bean.name}> result = super.getForObject("/${bean.lowerName}/page", null, QueryResult.class);
		assertNotNull(result.getTotal());
	}
	
	@Test
	public void TestGet${bean.name}ById() {
		${bean.name} ${bean.lowerName} = super.getForObject("/${bean.lowerName}/" + id, null, ${bean.name}.class);
		assertNotNull(${bean.lowerName}.getId());
	}
	
	@Test
	public void TestGet${bean.name}DataById() {
		${bean.name} ${bean.lowerName} = super.getForObject("/${bean.lowerName}/" + id, null, ${bean.name}.class);
		assertNotNull(${bean.lowerName}.getId());
	}	
	
	@Test
	public void testSave${bean.name}() {
		super.postForObject("/${bean.lowerName}",${bean.lowerName});
	}
	
	@Test
	public void testUpdate${bean.name}() {
		super.putForObject("/${bean.lowerName}",${bean.lowerName});
	}
	
	@Test
	public void testDelete${bean.name}() {
		super.delForObject("/${bean.lowerName}/" + id, null);
	}	
}