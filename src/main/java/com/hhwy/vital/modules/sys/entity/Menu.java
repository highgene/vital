/**
 * Copyright &copy; 2012-2014 <a href="http://www.haijintech.com">HaiJinTech</a> All rights reserved.
 */
package com.hhwy.vital.modules.sys.entity;

import com.fasterxml.jackson.annotation.JsonBackReference;
import com.fasterxml.jackson.annotation.JsonIgnore;
import com.hhwy.vital.common.persistence.DataEntity;
import org.hibernate.validator.constraints.Length;

import javax.validation.constraints.NotNull;
import java.util.ArrayList;
import java.util.List;

/**
 * 菜单Entity
 * @author zbx
 * @version 2013-05-15
 */
public class Menu extends DataEntity<Menu> {

	private static final long serialVersionUID = 1L;
	private Menu parent;	// 父级菜单
	private String parentIds; // 所有父级编号
	private String resourceName; 	// 名称
	private String url; 	// 链接
//	private String target; 	// 目标（ mainFrame、_blank、_self、_parent、_top）
	private String icon; 	// 图标
	private Integer serial; 	// 排序
	private int disabled; 	// 是否在菜单中显示（1：显示；0：不显示）
	private String permission; // 权限标识

	private String domainId; //
	private String tooltip; //资源的功能提示',
	private String sid; //
	private String resourceType; //'虚结点、子系统、模块、菜单、权限（操作、按钮）',
	private String api; //'多行的文本，形式如下： METHOD:/url/** METHOD:*/get/post/put/delete 例如： *:/api/user/** GET:/api/user/**',
	private String tags; //'标签，通过标签可以过滤，形成新的资源树集合',
	private String globalPermissions; //'全局权限：supervisor/administrator/general supervisor：超级管理员，一切权限不受限，主要用于系统维护，一般不交付给业务人员 administrator：系统管理员，也是交付给客户的最高权限，具有绝大部分系统管理权限，除一些影响系统运行的配置项之外（比如：资源树、内置参数、平台层的一些配置功能），所有业务功能不受限 general：根据授权表来决定权限，不能将supervisor/administrator的功能赋给一般角色（general）',

	private String isExistNode;//是否存在节点（1：存在；0：不存在）

	private String targetId;
	private String userId;
	private String roleName;
	private String roleId;
	
	public Menu(){
		super();
		this.serial = 30;
		this.disabled =1;
	}
	
	public Menu(String id){
		super(id);
	}
	
	@JsonBackReference
	@NotNull
	public Menu getParent() {
		return parent;
	}

	public void setParent(Menu parent) {
		this.parent = parent;
	}

	@Length(min=1, max=2000)
	public String getParentIds() {
		return parentIds;
	}

	public void setParentIds(String parentIds) {
		this.parentIds = parentIds;
	}
	
	@Length(min=1, max=100)
	public String getResourceName() {
		return resourceName;
	}

	public void setResourceName(String resourceName) {
		this.resourceName = resourceName;
	}

	@Length(min=0, max=2000)
	public String getUrl() {
		return url;
	}

	public void setUrl(String url) {
		this.url = url;
	}

	
	@Length(min=0, max=100)
	public String getIcon() {
		return icon;
	}

	public void setIcon(String icon) {
		this.icon = icon;
	}
	
	@NotNull
	public Integer getSerial() {
		return serial;
	}
	
	public void setSerial(Integer serial) {
		this.serial = serial;
	}

	public int getIsShow() {
		return disabled;
	}

	public void setIsShow(int disabled) {
		this.disabled = disabled;
	}

	@Length(min=0, max=200)
	public String getPermission() {
		return permission;
	}

	public void setPermission(String permission) {
		this.permission = permission;
	}

	public String getParentId() {
		return parent != null && parent.getId() != null ? parent.getId() : "0";
	}

	public String getRoleId() {
		return roleId;
	}

	public void setRoleId(String roleId) {
		this.roleId = roleId;
	}

	@JsonIgnore
	public static void sortList(List<Menu> list, List<Menu> sourcelist, String parentId, boolean cascade){
		for (int i=0; i<sourcelist.size(); i++){
			Menu e = sourcelist.get(i);
			if (e.getParent()!=null && e.getParent().getId()!=null&& e.getParent().getId().equals(parentId)){
				list.add(e);
				if (cascade){
					// 判断是否还有子节点, 有则继续获取子节点
					for (int j=0; j<sourcelist.size(); j++){
						Menu child = sourcelist.get(j);
						if (child.getParent()!=null && child.getParent().getId()!=null&& child.getParent().getId().equals(e.getId())){
							sortList(list, sourcelist, e.getId(), true);
							break;
						}
					}
				}
			}
		}
	}

	@JsonIgnore
	public static List<Menu>  sortList(List<Menu> sourcelist, String parentId, boolean cascade){
		List<Menu> list = new ArrayList<Menu>();
		for (int i=0; i<sourcelist.size(); i++){
			Menu e = sourcelist.get(i);
			if (e.getParent()!=null && e.getParent().getId()!=null&& e.getParent().getId().equals(parentId)){
				list.add(e);
				if (cascade){
					// 判断是否还有子节点, 有则继续获取子节点
					for (int j=0; j<sourcelist.size(); j++){
						Menu child = sourcelist.get(j);
						if (child.getParent()!=null && child.getParent().getId()!=null&& child.getParent().getId().equals(e.getId())){
							sortList(list, sourcelist, e.getId(), true);
							break;
						}
					}
				}
			}
		}
		return list;
	}

	@JsonIgnore
	public static String getRootId(){
		return "1";
	}
	
	public String getUserId() {
		return userId;
	}

	public void setUserId(String userId) {
		this.userId = userId;
	}

	public String getDomainId() {
		return domainId;
	}

	public void setDomainId(String domainId) {
		this.domainId = domainId;
	}

	public String getTooltip() {
		return tooltip;
	}

	public void setTooltip(String tooltip) {
		this.tooltip = tooltip;
	}

	public String getSid() {
		return sid;
	}

	public void setSid(String sid) {
		this.sid = sid;
	}

	public String getResourceType() {
		return resourceType;
	}

	public void setResourceType(String resourceType) {
		this.resourceType = resourceType;
	}

	public String getApi() {
		return api;
	}

	public void setApi(String api) {
		this.api = api;
	}

	public String getTags() {
		return tags;
	}

	public void setTags(String tags) {
		this.tags = tags;
	}

	public String getGlobalPermissions() {
		return globalPermissions;
	}

	public void setGlobalPermissions(String globalPermissions) {
		this.globalPermissions = globalPermissions;
	}

	public String getTargetId() {
		return targetId;
	}

	public void setTargetId(String targetId) {
		this.targetId = targetId;
	}

	public String getRoleName() {
		return roleName;
	}

	public void setRoleName(String roleName) {
		this.roleName = roleName;
	}

	@Override
	public String toString() {
		return id;
	}

	public String getIsExistNode() {
		return isExistNode;
	}

	public void setIsExistNode(String isExistNode) {
		this.isExistNode = isExistNode;
	}
}