
# 权限组件（Fweb Vital Plugin）接口使用指南
-----------------------------


## 一、前端接口
### 1.1 JS UI 控件
通过JS控件的形式，向其他模块提供UI控件。

* 需要引入的JS文件
``
<script type="text/javascript" src="vital-1.0.1.js">
``

未完待续 ...

* 用户选择控件

未完待续 ...


* 机构选择控件


### 1.2 JSTL 标签
采用Apache Shiro JSP Tags标签，详细使用帮助请参考：
<http://shiro.apache.org/web.html#Web-taglibrary>




## 二、后端接口
### 2.1 自定义接口

#### 2.1.1 与会话相关的接口

> com.hhwy.vital.utility
> User SessionHelper.getCurrentUser()
> 
> String SessionHelper.getCurrentUserId()
>
> boolean SessionHelper.login（String loginName, String password）
>
> void SessionHelper.logout()
>>

未完待续 ...


#### 2.1.2 无状态的服务接口

> com.hhwy.vital.utility
> User ServiceHelper.getUserById(String userId)
> 
> User ServiceHelper.getUserByLoginName(String loginName)
>
> List<User> ServiceHelper.getUsersByOrgId(String orgId, String targetId)
>
> List<User> ServiceHelper.getUsersByRoleId(String roleId)
>
> List<User> ServiceHelper.getUsersBy(String roleId,String targetId)
>
> List<User> ServiceHelper.getUsersBy(String where)  
>
> List<Organization> ServiceHelper.getOrganizationsBy(String parentId,null)
>
> List<Organization> ServiceHelper.getOrganizationsBy(String parentId,String tagId)
>
> Role ServiceHelper.getRoleById(String roleIdl)
>
> Role ServiceHelper.getRoleByCode(String roleCode)
>
> List<Role> ServiceHelper.getRolesBy(String tagId,null,null)
>
> List<Role> ServiceHelper.getRolesBy(null,null,String userID)
>
> List<Role> ServiceHelper.getRolesBy(null,String domainId,null)
>
> List<Resource> ServiceHelper.getResourcesBy(String roleId, null)
>
> List<Resource> ServiceHelper.getResourcesBy(null,String userId)
>
> boolean SecurityHelper.hasPermission（String userId,String targetId,String resourceId）
>
>>

未完待续 ...


#### 2.1.3 权限验证接口

> com.hhwy.vital.utility
> boolean SecurityHelper.hasPermission（String userId,String targetId,String resourceId）
> 
> boolean SecurityHelper.isAdministrator(String userId, targetId)
>
> boolean SecurityHelper.isManager(String userId, targetId)
>
> boolean SecurityHelper.hasURLPerssion(String URL, String userId)
>>

未完待续 ...

### 2.2 Apache Shiro提供的原生接口

#### 2.2.1 显式调用
详细请参考：<http://shiro.apache.org/documentation.html>



#### 2.2.2 注解引用

详细请参考：<http://shiro.apache.org/documentation.html>
