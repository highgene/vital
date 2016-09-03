/**
 * Copyright &copy; 2012-2014 <a href="http://www.haijintech.com">HaiJinTech</a> All rights reserved.
 */
package com.hhwy.vital.modules.sys.service;

import com.hhwy.vital.common.persistence.Page;
import com.hhwy.vital.common.service.CrudService;
import com.hhwy.vital.modules.sys.dao.TargetDao;
import com.hhwy.vital.modules.sys.entity.Target;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

/**
 * 授权实例Service
 * @author zbx
 * @version 2016-07-01
 */
@Service
@Transactional(readOnly = true)
public class TargetService extends CrudService<TargetDao, Target> {

	@Autowired
	private TargetDao targetDao;

	public Target get(String id) {
		return super.get(id);
	}
	
	public List<Target> findList(Target target) {
		return super.findList(target);
	}
	
	public Page<Target> findPage(Page<Target> page, Target target) {
		return super.findPage(page, target);
	}
	
	@Transactional(readOnly = false)
	public void save(Target target) {
		super.save(target);
	}
	
	@Transactional(readOnly = false)
	public void delete(Target target) {
		super.delete(target);
	}

	public List<Target> findAllList(){
		return targetDao.findAllList();
	}
	
}