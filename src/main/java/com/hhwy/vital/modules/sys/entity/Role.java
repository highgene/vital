/**
 * Copyright &copy; 2012-2014 <a href="http://www.haijintech.com">HaiJinTech</a> All rights reserved.
 */
package com.hhwy.vital.modules.sys.entity;

import com.google.common.collect.Lists;
import com.hhwy.vital.common.persistence.DataEntity;
import org.apache.commons.lang3.StringUtils;
import org.hibernate.validator.constraints.Length;

import java.util.List;

/**
 * 角色Entity
 *
 * @author zbx
 * @version 2013-12-05
 */
public class Role extends DataEntity<Role> {

    private static final long serialVersionUID = 1L;
    private String roleName;    // 角色名称
    private String roleCode;    // 英文名称
    private String globalPermissions;// 权限类型


    private String oldName;    // 原角色名称
    private String oldEnname;    // 原英文名称


    private String domainId;
    private int innate;
    private String tags;


    private User user;        // 根据用户ID查询角色列表

    //	private List<User> userList = Lists.newArrayList(); // 拥有用户列表
    private List<Menu> menuList = Lists.newArrayList(); // 拥有菜单列表
    private List<Office> officeList = Lists.newArrayList(); // 按明细设置数据范围

    // 数据范围（1：所有数据；2：所在公司及以下数据；3：所在公司数据；4：所在部门及以下数据；5：所在部门数据；8：仅本人数据；9：按明细设置）
    public static final String DATA_SCOPE_ALL = "1";
    public static final String DATA_SCOPE_COMPANY_AND_CHILD = "2";
    public static final String DATA_SCOPE_COMPANY = "3";
    public static final String DATA_SCOPE_OFFICE_AND_CHILD = "4";
    public static final String DATA_SCOPE_OFFICE = "5";
    public static final String DATA_SCOPE_SELF = "8";
    public static final String DATA_SCOPE_CUSTOM = "9";

    public Role() {
        super();
    }

    public Role(String id) {
        super(id);
    }

    public Role(User user) {
        this();
        this.user = user;
    }


    @Length(min = 1, max = 100)
    public String getRoleName() {
        return roleName;
    }

    public void setRoleName(String roleName) {
        this.roleName = roleName;
    }

    @Length(min = 1, max = 100)
    public String getRoleCode() {
        return roleCode;
    }

    public void setRoleCode(String roleCode) {
        this.roleCode = roleCode;
    }

    @Length(min = 1, max = 100)
    public String getGlobalPermissions() {
        return globalPermissions;
    }

    public void setGlobalPermissions(String globalPermissions) {
        this.globalPermissions = globalPermissions;
    }


    public String getOldName() {
        return oldName;
    }

    public void setOldName(String oldName) {
        this.oldName = oldName;
    }

    public String getOldEnname() {
        return oldEnname;
    }

    public void setOldEnname(String oldEnname) {
        this.oldEnname = oldEnname;
    }

    public String getDomainId() {
        return domainId;
    }

    public void setDomainId(String domainId) {
        this.domainId = domainId;
    }

    public int getInnate() {
        return innate;
    }

    public void setInnate(int innate) {
        this.innate = innate;
    }

    public String getTags() {
        return tags;
    }

    public void setTags(String tags) {
        this.tags = tags;
    }

    public List<Menu> getMenuList() {
        return menuList;
    }

    public void setMenuList(List<Menu> menuList) {
        this.menuList = menuList;
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

    public List<Office> getOfficeList() {
        return officeList;
    }

    public void setOfficeList(List<Office> officeList) {
        this.officeList = officeList;
    }

    public List<String> getOfficeIdList() {
        List<String> officeIdList = Lists.newArrayList();
        for (Office office : officeList) {
            officeIdList.add(office.getId());
        }
        return officeIdList;
    }

    public void setOfficeIdList(List<String> officeIdList) {
        officeList = Lists.newArrayList();
        for (String officeId : officeIdList) {
            Office office = new Office();
            office.setId(officeId);
            officeList.add(office);
        }
    }

    public String getOfficeIds() {
        return StringUtils.join(getOfficeIdList(), ",");
    }

    public void setOfficeIds(String officeIds) {
        officeList = Lists.newArrayList();
        if (officeIds != null) {
            String[] ids = StringUtils.split(officeIds, ",");
            setOfficeIdList(Lists.newArrayList(ids));
        }
    }

    /**
     * 获取权限字符串列表
     */
    public List<String> getPermissions() {
        List<String> permissions = Lists.newArrayList();
        for (Menu menu : menuList) {
            if (menu.getPermission() != null && !"".equals(menu.getPermission())) {
                permissions.add(menu.getPermission());
            }
        }
        return permissions;
    }

    public User getUser() {
        return user;
    }

    public void setUser(User user) {
        this.user = user;
    }

//	public boolean isAdmin(){
//		return isAdmin(this.id);
//	}
//	
//	public static boolean isAdmin(String id){
//		return id != null && "1".equals(id);
//	}

//	@Transient
//	public String getMenuNames() {
//		List<String> menuNameList = Lists.newArrayList();
//		for (Menu menu : menuList) {
//			menuNameList.add(menu.getName());
//		}
//		return StringUtils.join(menuNameList, ",");
//	}
}
