package com.hhwy.vital.utility;

import com.hhwy.vital.common.utils.SpringContextHolder;
import com.hhwy.vital.modules.sys.dao.MenuDao;
import com.hhwy.vital.modules.sys.entity.Menu;
import com.hhwy.vital.modules.sys.entity.Office;
import com.hhwy.vital.modules.sys.entity.Role;
import com.hhwy.vital.modules.sys.entity.User;

import java.util.List;

/**
 * 
 * <b>类 名 称：</b>ServiceHelper<br/>
 * <b>类 描 述：</b>资源获取帮助类<br/>
 * <b>创 建 人：</b>zk<br/>
 * <b>修改时间：</b>2016年8月17日 上午8:43:12<br/>
 * <b>修改备注：</b><br/>
 * @version 1.0.0<br/>
 */
public class ServiceHelper {
	private static MenuDao menuDao = SpringContextHolder.getBean(MenuDao.class);
	/** -------------------    用户资源     ------------------------------**/
	
	public static User getUserById(String userId){
		
		//TODO【后端接口】根据用户id获取用户
		return null;
	}
	
	public static User getUserByLoginName(String loginName){
		
		//TODO【后端接口】根据用户登录名获取用户
		return null;
	}
	
	public static List<User> getUsersByOrgId(String orgId, String targetId){
		
		//TODO【后端接口】根据组织id和实例，实例为空就是系统的默认实例
		return null;
	}
	
	public static List<User> getUsersByRoleId(String roleId){
		
		//TODO【后端接口】根据角色id获取用户
		return null;
	}
	
	public static List<User> getUsersBy(String roleId,String targetId){
		
		//TODO【后端接口】根据角色和实例，实例为空就是系统的默认实例
		return null;
	}
	
	public static List<User> getUsersBy(String where){
		
		//TODO【后端接口】根据传入SQL的where子句，提供接口
		return null;
	}
	
	
	/** -------------------    机构资源     ------------------------------**/
	
	/** -- !!!!! 注意组织资源 后面需命名修改 统一为Organization 不要再用Office了!!!!! --**/
	
	public static Office getOrganizationById(String orgId){
		
		//TODO【后端接口】根据Id获取组织机构
		return null;
	}
	
	public static Office getOrganizationByCode(String orgCode){
		
		//TODO【后端接口】根据机构编码获取组织机构
		return null;
	}
	
	public static List<Office> getOrganizationsByParentId(String parentId){
		
		//TODO【后端接口】根据parentId获取组织机构集合
		return null;
	}
	
	public static List<Office> getOrganizationsBy(String parentId, String targetId){
		
		//TODO【后端接口】根据parentId和实例 获取组织机构
		return null;
	}
	
	/** -------------------    角色资源     ------------------------------**/
	
	public static Role getRoleById(String roleId){
		
		//TODO【后端接口】根据Id获取角色
		return null;
	}
	
	public static Role getRoleByCode(String roleCode){
		
		//TODO【后端接口】根据角色编码获取角色
		return null;
	}
	
	public static List<Role> getRolesByTargetId(String targetId){
		
		//TODO【后端接口】根据targetId获取角色集合
		return null;
	}
	
	public static List<Role> getRolesByUserId(String userId){
		
		//TODO【后端接口】根据userId 获取角色集合
		return null;
	}
	
	public static List<Role> getRolesByDomainId(String domainId){
		
		//TODO【后端接口】根据domainId 获取角色集合
		return null;
	}
	
	/** -------------------    Resource资源     ------------------------------**/
	
	/** -- !!!!! 注意组织资源 后面需命名修改 统一为Organization 不要再用Menu了!!!!! --**/
	
	public static List<Menu> getResourcesByRoleId(String roleId){
		Menu menu = new Menu();
		menu.setRoleId(roleId);
		List<Menu> menuLIst = menuDao.findByRoleId(menu);
		return menuLIst;
		//TODO【后端接口】根据roleId 获取资源
	}
	
	public static List<Menu> getResourcesByUserId(String userId){
		Menu menu = new Menu();
		menu.setUserId(userId);
		List<Menu> menuLIst = menuDao.findByUserId(menu);
		return menuLIst;
		//TODO【后端接口】根据userId 获取资源
	}
}
