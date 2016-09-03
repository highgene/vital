/**
 * Copyright &copy; 2012-2014 <a href="http://www.haijintech.com">HaiJinTech</a> All rights reserved.
 */
package com.hhwy.vital.modules.sys.dao;

import com.hhwy.vital.modules.sys.entity.Log;
import com.hhwy.vital.common.persistence.CrudDao;
import com.hhwy.vital.common.persistence.annotation.MyBatisDao;

/**
 * 日志DAO接口
 * @author zbx
 * @version 2014-05-16
 */
@MyBatisDao
public interface LogDao extends CrudDao<Log> {

}
