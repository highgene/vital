/**
 * Copyright &copy; 2012-2014 <a href="http://www.haijintech.com">HaiJinTech</a> All rights reserved.
 */
package com.hhwy.vital.modules.sys.dao;

import com.hhwy.vital.common.persistence.CrudDao;
import com.hhwy.vital.common.persistence.annotation.MyBatisDao;
import com.hhwy.vital.modules.sys.entity.Domain;

import java.util.List;

/**
 * 授权领域DAO接口
 * @author zbx
 * @version 2016-06-30
 */
@MyBatisDao
public interface DomainDao extends CrudDao<Domain> {


    public List<Domain> findNoSysList(Domain domain);
	
}