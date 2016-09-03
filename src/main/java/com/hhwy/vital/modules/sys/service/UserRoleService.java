/**
 * Copyright &copy; 2012-2014 <a href="http://www.haijintech.com">HaiJinTech</a> All rights reserved.
 */
package com.hhwy.vital.modules.sys.service;

import com.hhwy.vital.common.service.CrudService;
import com.hhwy.vital.modules.sys.dao.UserRoleDao;
import com.hhwy.vital.modules.sys.entity.UserRole;
import com.hhwy.vital.common.persistence.Page;
import com.hhwy.vital.modules.sys.entity.Role;
import com.hhwy.vital.modules.sys.entity.Target;
import com.hhwy.vital.modules.sys.entity.User;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

/**
 * 用户权限Service
 * @author zbx
 * @version 2016-07-10
 */
@Service
@Transactional(readOnly = true)
public class UserRoleService extends CrudService<UserRoleDao, UserRole> {
	@Autowired
    UserRoleDao userRoleDao;

	public UserRole get(String id) {
		return super.get(id);
	}
	
	public List<UserRole> findList(UserRole userRole) {
		return super.findList(userRole);
	}
	
	public Page<UserRole> findPage(Page<UserRole> page, UserRole userRole) {
		return super.findPage(page, userRole);
	}
	
	@Transactional(readOnly = false)
	public void save(UserRole userRole) {
		userRoleDao.deleteByUserId(userRole);
		super.save(userRole);
	}

	@Transactional(readOnly = false)
	public void save(User user, String target_roles,String systemDomainIds) {
		UserRole userRole=new UserRole();
		userRole.setUser(user);
		userRoleDao.deleteByUserId(userRole);
		//保存系统领域
		if (systemDomainIds!=null){
			String [] list=systemDomainIds.split(",");
			if (list!=null){
				for (String role_id:list){
					if (role_id!=null&&!"".equals(role_id)){
						userRole = new UserRole();
						userRole.setUser(user);
						userRole.setRoleId(role_id);
						userRole.setTargetId("eeeeefd91e0c11e6866500ff5d77254e");//系统领域默认的实例
						super.save(userRole);
					}
				}
			}
		}
		//保存其他领域
		if (target_roles!=null){
			String [] list=target_roles.split(",");
			if (list!=null){
				for (String str:list){
					if (str!=null){
						String[] target_role=str.split("#");
						if (target_role!=null&&target_role.length==2){
							String targetId=target_role[0];
							String roleId = target_role[1];
							userRole = new UserRole();
							userRole.setUser(user);
							userRole.setTargetId(targetId);
							userRole.setRoleId(roleId);
							super.save(userRole);
						}
					}
				}
			}
		}

	}

	@Transactional(readOnly = false)
	public void saveRoleUser(Target target, String role_users) {
		UserRole userRole=new UserRole();
		userRole.setTargetId(target.getId());
		userRoleDao.deleteByTargetId(userRole);
		//保存角色与用户的对应关系
		if (role_users!=null){
			String [] list=role_users.split(",");
			if (list!=null){
				for (String str:list){
					if (str!=null){
						String[] role_user=str.split("#");
						if (role_user!=null&&role_user.length==2){
							String roleId=role_user[0];
							String userId = role_user[1];
							userRole = new UserRole();
							userRole.setUser(new User(userId));
							userRole.setTargetId(target.getId());
							userRole.setRoleId(roleId);
							super.save(userRole);
						}
					}
				}
			}
		}

	}

	@Transactional(readOnly = false)
	public void saveTargetUser(Role role, String target_users) {
		UserRole userRole=new UserRole();
		userRole.setRoleId(role.getId());
		userRoleDao.deleteByTargetId(userRole);
		//保存实例与用户的对应关系
		if (target_users!=null){
			String [] list=target_users.split(",");
			if (list!=null){
				for (String str:list){
					if (str!=null){
						String[] target_user=str.split("#");
						if (target_user!=null&&target_user.length==2){
							String targetId=target_user[0];
							String userId = target_user[1];
							userRole = new UserRole();
							userRole.setUser(new User(userId));
							userRole.setTargetId(targetId);
							userRole.setRoleId(role.getId());
							super.save(userRole);
						}
					}
				}
			}
		}

	}

	public UserRoleDao getUserRoleDao() {
		return userRoleDao;
	}

	public void setUserRoleDao(UserRoleDao userRoleDao) {
		this.userRoleDao = userRoleDao;
	}

	@Transactional(readOnly = false)
	public void delete(UserRole userRole) {
		super.delete(userRole);
	}
	
}