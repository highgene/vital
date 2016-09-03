/**
 * Copyright &copy; 2012-2014 <a href="http://www.haijintech.com">HaiJinTech</a> All rights reserved.
 */
package com.hhwy.vital.modules.sys.entity;

import com.fasterxml.jackson.annotation.JsonFormat;
import com.fasterxml.jackson.annotation.JsonIgnore;
import com.google.common.collect.Lists;
import com.hhwy.vital.common.supcan.annotation.treelist.cols.SupCol;
import com.hhwy.vital.common.utils.excel.annotation.ExcelField;
import com.hhwy.vital.common.utils.excel.fieldtype.RoleListType;
import com.hhwy.vital.common.persistence.DataEntity;
import com.hhwy.vital.common.utils.Collections3;
import org.apache.commons.lang3.StringUtils;
import org.hibernate.validator.constraints.Email;
import org.hibernate.validator.constraints.Length;

import javax.validation.constraints.NotNull;
import java.util.Date;
import java.util.List;

/**
 * 用户Entity
 * @author zbx
 * @version 2013-12-05
 */
public class User extends DataEntity<User> {

	private static final long serialVersionUID = 1L;

	private Office office;	// 归属部门
	private String loginName;// 登录名
	private String password;// 密码
	private String idCard;		// 身份证
	private String realName;	// 姓名
	private String email;	// 邮箱
	private String mobile;	// 手机
	private Date lastLoginedTime;	// 最后登陆日期
	private int isdisabled;	// 是否允许登陆
	private String avatar;	// 头像
	private String oldLoginName;// 原登录名
	private String newPassword;	// 新密码

	private Role role;	// 根据角色查询用户条件
	private List<Role> roleList = Lists.newArrayList(); // 拥有角色列表

	private String salt ;        // '密码加密混淆码，8位的随机字符串，每次修改密码或重置密码时重新生成',
	private int fails;       // '连续登录失败次数',
	private int isChangingPassword;// DEFAULT b'0' COMMENT '下次登录是否必须修改密码',
	private int logined;       // DEFAULT '0' COMMENT '登录成功总次数',
	private Date unlock_time ;    //DATETIME COMMENT '连续输错密码3次，帐号锁定10分钟，这是解锁时间',
	private int serial ;        // DEFAULT '0' COMMENT '顺序号',
	private int sex;//性别
	private List<Menu> menuList = Lists.newArrayList(); // 拥有菜单列表


	public User() {
		super();
		this.isdisabled = 0;
	}
	
	public User(String id){
		super(id);
	}

	public User(String id, String loginName){
		super(id);
		this.loginName = loginName;
	}

	public User(Role role){
		super();
		this.role = role;
	}
	
	public String getAvatar() {
		return avatar;
	}

	public void setAvatar(String avatar) {
		this.avatar = avatar;
	}

	public int getIsdisabled() {
		return isdisabled;
	}

	public void setIsdisabled(int isdisabled) {
		this.isdisabled = isdisabled;
	}

	@SupCol(isUnique="true", isHide="true")
	@ExcelField(title="ID", type=1, align=2, sort=1)
	public String getId() {
		return id;
	}

	
	@JsonIgnore
	@NotNull(message="归属部门不能为空")
	@ExcelField(title="归属部门", align=2, sort=25)
	public Office getOffice() {
		return office;
	}

	public void setOffice(Office office) {
		this.office = office;
	}

	@Length(min=1, max=100, message="登录名长度必须介于 1 和 100 之间")
	@ExcelField(title="登录名", align=2, sort=30)
	public String getLoginName() {
		return loginName;
	}

	public void setLoginName(String loginName) {
		this.loginName = loginName;
	}

	@JsonIgnore
	@Length(min=1, max=100, message="密码长度必须介于 1 和 100 之间")
	public String getPassword() {
		return password;
	}

	public void setPassword(String password) {
		this.password = password;
	}

	@Length(min=1, max=100, message="姓名长度必须介于 1 和 100 之间")
	@ExcelField(title="姓名", align=2, sort=40)
	public String getRealName() {
		return realName;
	}
	
	@Length(min=1, max=100, message="工号长度必须介于 1 和 100 之间")
	@ExcelField(title="工号", align=2, sort=45)
	public String getIdCard() {
		return idCard;
	}

	public void setIdCard(String idCard) {
		this.idCard = idCard;
	}

	public void setRealName(String realName) {
		this.realName = realName;
	}

	@Email(message="邮箱格式不正确")
	@Length(min=0, max=200, message="邮箱长度必须介于 1 和 200 之间")
	@ExcelField(title="邮箱", align=1, sort=50)
	public String getEmail() {
		return email;
	}

	public void setEmail(String email) {
		this.email = email;
	}
	
	@Length(min=0, max=200, message="手机长度必须介于 1 和 200 之间")
	@ExcelField(title="手机", align=2, sort=60)
	public String getMobile() {
		return mobile;
	}

	public void setMobile(String mobile) {
		this.mobile = mobile;
	}


	@ExcelField(title="备注", align=1, sort=900)
	public String getDescription() {
		return description;
	}

	@ExcelField(title="创建时间", type=0, align=1, sort=90)
	public Date getCreateTime() {
		return createTime;
	}


	@JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
	@ExcelField(title="最后登录日期", type=1, align=1, sort=110)
	public Date getLastLoginedTime() {
		return lastLoginedTime;
	}

	public void setLastLoginedTime(Date lastLoginedTime) {
		this.lastLoginedTime = lastLoginedTime;
	}

	public Role getRole() {
		return role;
	}

	public void setRole(Role role) {
		this.role = role;
	}

	@JsonIgnore
	@ExcelField(title="拥有角色", align=1, sort=800, fieldType=RoleListType.class)
	public List<Role> getRoleList() {
		return roleList;
	}
	
	public void setRoleList(List<Role> roleList) {
		this.roleList = roleList;
	}

	@JsonIgnore
	public List<String> getRoleIdList() {
		List<String> roleIdList = Lists.newArrayList();
		for (Role role : roleList) {
			roleIdList.add(role.getId());
		}
		return roleIdList;
	}

	public void setRoleIdList(List<String> roleIdList) {
		roleList = Lists.newArrayList();
		for (String roleId : roleIdList) {
			Role role = new Role();
			role.setId(roleId);
			roleList.add(role);
		}
	}
	
	/**
	 * 用户拥有的角色名称字符串, 多个角色名称用','分隔.
	 */
	public String getRoleNames() {
		return Collections3.extractToString(roleList, "name", ",");
	}
	
	public boolean isAdmin(){
		return isAdmin(this.id);
	}
	
	public static boolean isAdmin(String id){
		return id != null && "1".equals(id);
	}

	public static long getSerialVersionUID() {
		return serialVersionUID;
	}

	public String getSalt() {
		return salt;
	}

	public void setSalt(String salt) {
		this.salt = salt;
	}

	public int getFails() {
		return fails;
	}

	public void setFails(int fails) {
		this.fails = fails;
	}

	public int getIsChangingPassword() {
		return isChangingPassword;
	}

	public void setIsChangingPassword(int isChangingPassword) {
		this.isChangingPassword = isChangingPassword;
	}

	public int getLogined() {
		return logined;
	}

	public void setLogined(int logined) {
		this.logined = logined;
	}

	public Date getUnlock_time() {
		return unlock_time;
	}

	public void setUnlock_time(Date unlock_time) {
		this.unlock_time = unlock_time;
	}

	public int getSerial() {
		return serial;
	}

	public void setSerial(int serial) {
		this.serial = serial;
	}

	public String getNewPassword() {
		return newPassword;
	}

	public void setNewPassword(String newPassword) {
		this.newPassword = newPassword;
	}

	public String getOldLoginName() {
		return oldLoginName;
	}

	public void setOldLoginName(String oldLoginName) {
		this.oldLoginName = oldLoginName;
	}

	public int getSex() {
		return sex;
	}
	public void setSex(int sex) {
		this.sex = sex;
	}
	public String getMenuIds() {
		return StringUtils.join(getMenuIdList(), ",");
	}

	public void setMenuIds(String menuIds) {
		menuList = Lists.newArrayList();
		if (menuIds != null) {
			String[] ids = StringUtils.split(menuIds, ",");
			setMenuIdList(Lists.newArrayList(ids));
		}
	}
	public List<String> getMenuIdList() {
		List<String> menuIdList = Lists.newArrayList();
		for (Menu menu : menuList) {
			menuIdList.add(menu.getId());
		}
		return menuIdList;
	}
	public void setMenuIdList(List<String> menuIdList) {
		menuList = Lists.newArrayList();
		for (String menuId : menuIdList) {
			Menu menu = new Menu();
			menu.setId(menuId);
			menuList.add(menu);
		}
	}

	@Override
	public String toString() {
		return id;
	}
}