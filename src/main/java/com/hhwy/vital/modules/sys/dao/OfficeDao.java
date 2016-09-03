/**
 * Copyright &copy; 2012-2014 <a href="http://www.haijintech.com">HaiJinTech</a> All rights reserved.
 */
package com.hhwy.vital.modules.sys.dao;

import com.hhwy.vital.common.persistence.TreeDao;
import com.hhwy.vital.modules.sys.entity.Office;
import com.hhwy.vital.common.persistence.annotation.MyBatisDao;

import java.util.List;

/**
 * 机构DAO接口
 * @author zbx
 * @version 2014-05-16
 */
@MyBatisDao
public interface OfficeDao extends TreeDao<Office> {

    /**
     * 根据实例查找组织机构
     * @param office
     * @return
     */
    public List<Office> findListByTarget(Office office);
    public int updateSort(Office office);


}
