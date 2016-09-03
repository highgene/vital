/**
 * Copyright &copy; 2012-2014 <a href="http://www.haijintech.com">HaiJinTech</a> All rights reserved.
 */
package com.hhwy.vital.modules.demo.dao;

import com.hhwy.vital.common.persistence.CrudDao;
import com.hhwy.vital.common.persistence.annotation.MyBatisDao;
import com.hhwy.vital.modules.demo.entity.ProjectDesc;

/**
 * 工程描述DAO接口
 * @author zbx
 * @version 2016-08-14
 */
@MyBatisDao
public interface ProjectDescDao extends CrudDao<ProjectDesc> {
	
}