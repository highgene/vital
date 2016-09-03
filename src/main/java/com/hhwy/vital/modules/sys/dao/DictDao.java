/**
 * Copyright &copy; 2012-2014 <a href="http://www.haijintech.com">HaiJinTech</a> All rights reserved.
 */
package com.hhwy.vital.modules.sys.dao;

import java.util.List;

import com.hhwy.vital.common.persistence.annotation.MyBatisDao;
import com.hhwy.vital.modules.sys.entity.Dict;
import com.hhwy.vital.common.persistence.CrudDao;

/**
 * 字典DAO接口
 * @author zbx
 * @version 2014-05-16
 */
@MyBatisDao
public interface DictDao extends CrudDao<Dict> {

	public List<String> findTypeList(Dict dict);
	
}
