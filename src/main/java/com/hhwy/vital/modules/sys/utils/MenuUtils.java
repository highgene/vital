/**
 * Copyright &copy; 2012-2014 <a href="http://www.haijintech.com">HaiJinTech</a> All rights reserved.
 */
package com.hhwy.vital.modules.sys.utils;

import com.google.common.collect.Lists;
import com.hhwy.vital.modules.sys.entity.Menu;
import org.apache.commons.lang3.StringUtils;

import java.util.List;

/**
 * 菜单工具类
 * @author zbx
 * @version 2016-7-10
 */
public class MenuUtils {
	public static String getMenuIds(List<Menu> list) {
		List<String> menuIdList = Lists.newArrayList();
		for (Menu menu : list) {
			menuIdList.add(menu.getId());
		}
		return StringUtils.join(menuIdList, ",");
	}
}
