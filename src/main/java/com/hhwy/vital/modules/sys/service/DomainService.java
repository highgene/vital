/**
 * Copyright &copy; 2012-2014 <a href="http://www.haijintech.com">HaiJinTech</a> All rights reserved.
 */
package com.hhwy.vital.modules.sys.service;

import com.hhwy.vital.common.service.CrudService;
import com.hhwy.vital.common.persistence.Page;
import com.hhwy.vital.common.utils.StringUtils;
import com.hhwy.vital.modules.sys.dao.DomainDao;
import com.hhwy.vital.modules.sys.dao.TargetDao;
import com.hhwy.vital.modules.sys.entity.Domain;
import com.hhwy.vital.modules.sys.entity.Target;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

/**
 * 授权领域Service
 * @author zbx
 * @version 2016-06-30
 */
@Service
@Transactional(readOnly = true)
public class DomainService extends CrudService<DomainDao, Domain> {
    @Autowired
	TargetDao targetDao;

	public Domain get(String id) {
		return super.get(id);
	}
	
	public List<Domain> findList(Domain domain) {
		return super.findList(domain);
	}
	
	public Page<Domain> findPage(Page<Domain> page, Domain domain) {
		return super.findPage(page, domain);
	}
	
	@Transactional(readOnly = false)
	public void save(Domain domain) {
		boolean isNew = StringUtils.isEmpty(domain.getId());

		if (isNew) {
			Target target = new Target();
			target.setDomainId(domain.getId());
			target.setIsDefault(1);
			target.setObjectName("默认实例");
			target.setDescription("默认实例");
			target.preInsert();
			targetDao.insert(target);

			domain.setDefaultTargetId(target.getId());
			super.save(domain);
			target.setDomainId(domain.getId());
			target.preUpdate();
			targetDao.update(target);
		} else {
			super.save(domain);
		}


	}
	
	@Transactional(readOnly = false)
	public void delete(Domain domain) {
		super.delete(domain);
	}
	
}