/**
 * Copyright &copy; 2012-2014 <a href="http://www.haijintech.com">HaiJinTech</a> All rights reserved.
 */
package com.hhwy.vital.modules.sys.web;

import com.google.common.collect.Lists;
import com.google.common.collect.Maps;
import com.hhwy.vital.modules.sys.entity.Dict;
import com.hhwy.vital.modules.sys.service.DictService;
import com.hhwy.vital.common.persistence.Page;
import com.hhwy.vital.common.utils.StringUtils;
import com.hhwy.vital.common.web.BaseController;
import org.apache.commons.lang.StringEscapeUtils;
import org.apache.shiro.authz.annotation.RequiresPermissions;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.List;
import java.util.Map;

/**
 * 字典Controller
 * @author zbx
 * @version 2014-05-16
 */
@Controller
@RequestMapping(value = "${adminPath}/sys/dict")
public class DictionaryController extends BaseController {

	@Autowired
	private DictService dictService;

	@ModelAttribute
	public Dict get(@RequestParam(required=false) String id) {
		if (StringUtils.isNotBlank(id)){
			return dictService.get(id);
		}else{
			return new Dict();
		}
	}

	@RequiresPermissions("sys_dict_view")
	@RequestMapping(value = {"list", ""})
	public String list(Dict dict, HttpServletRequest request, HttpServletResponse response, Model model) {
		List<String> typeList = dictService.findTypeList();
		model.addAttribute("typeList", typeList);
		Page<Dict> page = dictService.findPage(new Page<Dict>(request, response), dict);
		model.addAttribute("page", page);
		return "/view/vital/modules/sys/dictList";
	}

	@RequiresPermissions("sys_dict_view")
	@RequestMapping(value = "form")
	public String form(Dict dict, Model model) {
		dict.setParamValue(StringEscapeUtils.escapeHtml(dict.getParamValue()));
		model.addAttribute("dict", dict);
		return "/view/vital/modules/sys/dictForm";
	}

	@RequiresPermissions("sys_dict_edit")
	@RequestMapping(value = "save")//@Valid 
	public String save(Dict dict, Model model, RedirectAttributes redirectAttributes) {
		if (!beanValidator(model, dict)){
			return form(dict, model);
		}
		dict.setParamValue(StringEscapeUtils.unescapeHtml(dict.getParamValue()));
		dictService.save(dict);
		addMessage(redirectAttributes, "保存字典'" + dict.getCnName() + "'成功");
		return "redirect:" + adminPath + "/sys/dict/?repage";
	}

	@RequiresPermissions("sys_dict_edit")
	@RequestMapping(value = "delete")
	public String delete(Dict dict, RedirectAttributes redirectAttributes) {
		dictService.delete(dict);
		addMessage(redirectAttributes, "删除字典成功");
		return "redirect:" + adminPath + "/sys/dict/?repage";
	}

	@RequiresPermissions("user")
	@ResponseBody
	@RequestMapping(value = "treeData")
	public List<Map<String, Object>> treeData(@RequestParam(required=false) String type, HttpServletResponse response) {
		List<Map<String, Object>> mapList = Lists.newArrayList();
		Dict dict = new Dict();
		dict.setParamName(type);
		List<Dict> list = dictService.findList(dict);
		for (int i=0; i<list.size(); i++){
			Dict e = list.get(i);
			Map<String, Object> map = Maps.newHashMap();
			map.put("id", e.getId());
			map.put("name", StringUtils.replace(e.getCnName(), " ", ""));
			mapList.add(map);
		}
		return mapList;
	}

	@ResponseBody
	@RequestMapping(value = "listData")
	public List<Dict> listData(@RequestParam(required=false) String type) {
		Dict dict = new Dict();
		dict.setParamName(type);
		return dictService.findList(dict);
	}

}
