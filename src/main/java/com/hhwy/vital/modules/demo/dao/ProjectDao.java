/**
 * Copyright &copy; 2012-2014 <a href="http://www.haijintech.com">HaiJinTech</a> All rights reserved.
 */
package com.hhwy.vital.modules.demo.dao;

import com.hhwy.vital.common.persistence.CrudDao;
import com.hhwy.vital.common.persistence.annotation.MyBatisDao;
import com.hhwy.vital.modules.demo.entity.Project;

/**
 * 工程领域DAO接口
 * @author zbx
 * @version 2016-08-07
 */
@MyBatisDao
public interface ProjectDao extends CrudDao<Project> {
	
}