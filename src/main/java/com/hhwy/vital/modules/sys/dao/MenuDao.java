/**
 * Copyright &copy; 2012-2014 <a href="http://www.haijintech.com">HaiJinTech</a> All rights reserved.
 */
package com.hhwy.vital.modules.sys.dao;

import com.hhwy.vital.common.persistence.CrudDao;
import com.hhwy.vital.common.persistence.annotation.MyBatisDao;
import com.hhwy.vital.modules.sys.entity.Menu;

import java.util.List;

/**
 * 菜单DAO接口
 * @author zbx
 * @version 2014-05-16
 */
@MyBatisDao
public interface MenuDao extends CrudDao<Menu> {

	public List<Menu> findByParentIdsLike(Menu menu);

	public List<Menu> findList(Menu menu);

	public List<Menu> findByUserId(Menu menu);

	public List<Menu> findByRoleId(Menu menu);

	public List<Menu> findPermissionsByUserId(Menu menu);


	public List<Menu> findAllSelectMenu(Menu menu);
	
	public int updateParentIds(Menu menu);
	
	public int updateSort(Menu menu);
	
}
