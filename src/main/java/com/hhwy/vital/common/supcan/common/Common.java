/**
 * Copyright &copy; 2012-2014 <a href="http://www.haijintech.com">HaiJinTech</a> All rights reserved.
 */
package com.hhwy.vital.common.supcan.common;

import java.util.List;

import com.google.common.collect.Lists;
import com.hhwy.vital.common.supcan.common.fonts.Font;
import com.hhwy.vital.common.supcan.common.properties.Properties;
import com.hhwy.vital.common.utils.IdGen;
import com.thoughtworks.xstream.annotations.XStreamAlias;

/**
 *  Common
 * @author zbx
 * @version 2013-11-04
 */
public class Common {

	/**
	 * 属性对象
	 */
	@XStreamAlias("Properties")
	protected Properties properties;
	
	/**
	 * 字体对象
	 */
	@XStreamAlias("Fonts")
	protected List<Font> fonts;

	public Common() {
		properties = new Properties(IdGen.uuid());
		fonts = Lists.newArrayList(
				new Font("宋体", "134", "-12"),
				new Font("宋体", "134", "-13", "700"));
	}
	
	public Common(Properties properties) {
		this();
		this.properties = properties;
	}
	
	public Properties getProperties() {
		return properties;
	}

	public void setProperties(Properties properties) {
		this.properties = properties;
	}

	public List<Font> getFonts() {
		return fonts;
	}

	public void setFonts(List<Font> fonts) {
		this.fonts = fonts;
	}

}
