/**
 * Copyright &copy; 2012-2014 <a href="http://www.haijintech.com">HaiJinTech</a> All rights reserved.
 */
package com.hhwy.vital.modules.sys.dao;

import com.hhwy.vital.common.persistence.CrudDao;
import com.hhwy.vital.common.persistence.annotation.MyBatisDao;
import com.hhwy.vital.modules.sys.entity.UserRole;
import java.util.List;
/**
 * 用户权限DAO接口
 * @author zbx
 * @version 2016-07-10
 */
@MyBatisDao
public interface UserRoleDao extends CrudDao<UserRole> {

    public int deleteByUserId(UserRole userRole);
    public int deleteByRoleId(UserRole userRole);
    public int deleteByTargetId(UserRole userRole);
    public List<UserRole> findByTarget(UserRole userRole);
    public List<UserRole> findByRole(UserRole userRole);
    public List<UserRole> findSystemList();


}