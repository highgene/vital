/**
 * Copyright &copy; 2012-2014 <a href="http://www.haijintech.com">HaiJinTech</a> All rights reserved.
 */
package com.hhwy.vital.modules.sys.utils;

import com.alibaba.druid.support.json.JSONUtils;
import com.google.common.collect.Lists;
import com.google.common.collect.Maps;
import com.hhwy.vital.common.mapper.JsonMapper;
import com.hhwy.vital.common.utils.CacheUtils;
import com.hhwy.vital.common.utils.SpringContextHolder;
import com.hhwy.vital.modules.sys.dao.DictDao;
import com.hhwy.vital.modules.sys.entity.Dict;
import org.apache.commons.lang3.StringUtils;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

/**
 * 字典工具类
 * @author zbx
 * @version 2013-5-29
 */
public class DictUtils {
	
	private static DictDao dictDao = SpringContextHolder.getBean(DictDao.class);

	public static final String CACHE_DICT_MAP = "dictMap";
	
	public static String getDictLabel(String value, String type, String defaultValue){
		if (StringUtils.isNotBlank(type) && StringUtils.isNotBlank(value)){
			for (Dict dict : getDictList(type)){
				if (type.equals(dict.getParamName()) && value.equals(dict.getParamValue())){
					return dict.getCnName();
				}
			}
		}
		return defaultValue;
	}
	
	public static String getDictLabels(String values, String type, String defaultValue){
		if (StringUtils.isNotBlank(type) && StringUtils.isNotBlank(values)){
			List<String> valueList = Lists.newArrayList();
			for (String value : StringUtils.split(values, ",")){
				valueList.add(getDictLabel(value, type, defaultValue));
			}
			return StringUtils.join(valueList, ",");
		}
		return defaultValue;
	}

	public static String getDictValue(String label, String type, String defaultLabel){
		if (StringUtils.isNotBlank(type) && StringUtils.isNotBlank(label)){
			for (Dict dict : getDictList(type)){
				if (type.equals(dict.getParamName()) && label.equals(dict.getCnName())){
					return dict.getParamValue();
				}
			}
		}
		return defaultLabel;
	}
	
	public static List<Dict> getDictList(String type){
		@SuppressWarnings("unchecked")
		Map<String, List<Dict>> dictMap = (Map<String, List<Dict>>) CacheUtils.get(CACHE_DICT_MAP);
		if (dictMap==null){
			dictMap = Maps.newHashMap();
			List<Dict> allList = dictDao.findAllList(new Dict());
			for (Dict dict : allList){
				List<Dict> dictList = dictMap.get(dict.getParamName());
				if (dictList != null){
					dictList.add(dict);
				}else{
					List list=parseToList(dict.getParamValue());
					dictMap.put(dict.getParamName(), list);
				}
			}
			CacheUtils.put(CACHE_DICT_MAP, dictMap);
		}
		List<Dict> dictList = dictMap.get(type);
		if (dictList == null){
			dictList = Lists.newArrayList();
		}
		return dictList;
	}
	private static List<Dict> parseToList(String json){
		List list = new ArrayList();
		Object parse = null;
		try {
			parse = JSONUtils.parse(json);
			List<Map<String,String>> tt= (List<Map<String,String>>) parse;
			for (Map<String,String> map : tt) {
				for (String key : map.keySet()) {
					Dict dict = new Dict();
					dict.setParamName(map.get(key));
					dict.setParamValue(key);
					dict.setCnName(map.get(key));
					list.add(dict);
				}
			}

		} catch (Exception e) {
		}
		return list;
	}
	
	/**
	 * 返回字典列表（JSON）
	 * @param type
	 * @return
	 */
	public static String getDictListJson(String type){
		return JsonMapper.toJsonString(getDictList(type));
	}

}
