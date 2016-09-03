
# Ȩ�������Fweb Vital Plugin���ӿ�ʹ��ָ��
-----------------------------


## һ��ǰ�˽ӿ�
### 1.1 JS UI �ؼ�
ͨ��JS�ؼ�����ʽ��������ģ���ṩUI�ؼ���

* ��Ҫ�����JS�ļ�
``
<script type="text/javascript" src="vital-1.0.1.js">
``

δ����� ...

* �û�ѡ��ؼ�

δ����� ...


* ����ѡ��ؼ�


### 1.2 JSTL ��ǩ
����Apache Shiro JSP Tags��ǩ����ϸʹ�ð�����ο���
<http://shiro.apache.org/web.html#Web-taglibrary>




## ������˽ӿ�
### 2.1 �Զ���ӿ�

#### 2.1.1 ��Ự��صĽӿ�

> com.hhwy.vital.utility
> User SessionHelper.getCurrentUser()
> 
> String SessionHelper.getCurrentUserId()
>
> boolean SessionHelper.login��String loginName, String password��
>
> void SessionHelper.logout()
>>

δ����� ...


#### 2.1.2 ��״̬�ķ���ӿ�

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
> boolean SecurityHelper.hasPermission��String userId,String targetId,String resourceId��
>
>>

δ����� ...


#### 2.1.3 Ȩ����֤�ӿ�

> com.hhwy.vital.utility
> boolean SecurityHelper.hasPermission��String userId,String targetId,String resourceId��
> 
> boolean SecurityHelper.isAdministrator(String userId, targetId)
>
> boolean SecurityHelper.isManager(String userId, targetId)
>
> boolean SecurityHelper.hasURLPerssion(String URL, String userId)
>>

δ����� ...

### 2.2 Apache Shiro�ṩ��ԭ���ӿ�

#### 2.2.1 ��ʽ����
��ϸ��ο���<http://shiro.apache.org/documentation.html>



#### 2.2.2 ע������

��ϸ��ο���<http://shiro.apache.org/documentation.html>
