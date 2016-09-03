<#--包名-->
package ${bean.packagePath}.${bean.lowerPackageName}.domain;
import com.hhwy.framework.annotation.CodeGenerateInfo;
import com.hhwy.framework.annotation.PropertyDesc;
import com.hhwy.framework.persistent.entity.Domain;
import org.apache.commons.lang3.StringUtils;
import com.hhwy.framework.util.DateTools;
import java.io.Serializable;
import javax.persistence.*;
import javax.validation.constraints.NotNull;
import org.hibernate.validator.constraints.NotBlank;
import org.hibernate.validator.constraints.NotEmpty;
<#assign packFlag=true>
<#list list as metaData>
<#if metaData.importPackage??>
import ${metaData.importPackage};
</#if>
<#if (metaData.propertyType=='Date' || metaData.propertyType=='Timestamp')>
<#if packFlag>
<#assign packFlag=false>
import com.fasterxml.jackson.annotation.JsonFormat;
</#if>
</#if>
</#list>
/**
 * ${bean.name}
 * @author ${annotation.author}
 * @date ${annotation.date}
 * @version ${annotation.version}
 */
@Entity(name="${bean.name}")
@Inheritance(strategy = InheritanceType.SINGLE_TABLE)
@Table(name="${list[0].tableName}")
@CodeGenerateInfo(functionId="${codeGenerateInfo.functionId}", templateId="${codeGenerateInfo.templateId}", desc="${codeGenerateInfo.desc}")
public class ${bean.name} extends Domain implements Serializable {

	/**
	 * serialVersionUID
	 * 
	 * @return the serialVersionUID
	 * @since 1.0.0
	 */
	private static final long serialVersionUID = ${list[0].serialVersionUID?c}L;
	
<#list list as metaData >
    @PropertyDesc("${metaData.comment!}")
<#if metaData.propertyType=='Date'>
    @JsonFormat(pattern="yyyy-MM-dd",timezone = "GMT+8") 
<#elseif metaData.propertyType=='Timestamp'>
	@JsonFormat(pattern="yyyy-MM-dd HH:mm:ss",timezone = "GMT+8") 
</#if>
<#if (metaData.annotation?? && metaData.annotation=='@Transient')>
	@Transient
<#else>
	<#if (metaData.propertyName=='version')>
    @Version
	</#if>
	<#if !(metaData.null)>
	<#if (metaData.propertyType == 'String')>
	@NotBlank
	<#else>
	@NotNull
	</#if>
	</#if>
	<#if (metaData.annotation??)>
	${metaData.annotation}
	</#if>
    @Column(name="${metaData.columnName}", nullable=${metaData.null?c}, length=${metaData.length}) 
</#if>
    private ${metaData.propertyType} ${metaData.propertyName};
    
</#list>
<#list list as metaData>
    public ${metaData.propertyType} get${metaData.upperPropertyName}(){
        return ${metaData.propertyName};
    }
    
    public void set${metaData.upperPropertyName}(<#if metaData.propertyType=='Timestamp'>String<#else>${metaData.propertyType}</#if> ${metaData.propertyName}){
        <#if metaData.propertyType=='Timestamp'>
    	if(null!=${metaData.propertyName}&&StringUtils.isNotBlank(${metaData.propertyName})){
    			try {
					if(${metaData.propertyName}.length()>11){
						this.${metaData.propertyName} = new Timestamp(DateTools.strToDateByYmdHms(${metaData.propertyName}).getTime());
					}else{
						this.${metaData.propertyName} = new Timestamp(DateTools.strToDateByYmd(${metaData.propertyName}).getTime());
					}
				} catch (Exception e) {
					e.printStackTrace();
				}
    	}else{
			this.${metaData.propertyName} = null;
    	}
		<#else>
        this.${metaData.propertyName} = ${metaData.propertyName};
        
        </#if>
    }
    
</#list>
}