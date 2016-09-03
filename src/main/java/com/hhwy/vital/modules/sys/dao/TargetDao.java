/**
 * Copyright &copy; 2012-2014 <a href="http://www.haijintech.com">HaiJinTech</a> All rights reserved.
 */
package com.hhwy.vital.modules.sys.dao;

import com.hhwy.vital.common.persistence.CrudDao;
import com.hhwy.vital.modules.sys.entity.Target;
import com.hhwy.vital.common.persistence.annotation.MyBatisDao;

import java.util.List;

/**
 * 授权实例DAO接口
 * @author zbx
 * @version 2016-07-01
 */
@MyBatisDao
public interface TargetDao extends CrudDao<Target> {


    /**
     * 根据领域查找实例
     * @param target
     * @return
     */
    public List<Target> findListByDomain(Target target);
	
}