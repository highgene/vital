<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/plugins/vital/views/include/taglib.jsp"%>

	<div class="accordion" id="menu-${param.parentId}"><c:set var="menuList" value="${fns:getMenuList()}"/><c:set var="firstMenu" value="true"/><c:forEach items="${menuList}" var="menu" varStatus="idxStatus"><c:if test="${menu.parent.id eq (not empty param.parentId ? param.parentId:1)&&menu.isShow eq '1'}">
		<div class="accordion-group">
		    <div class="accordion-heading">
		    	<a class="accordion-toggle" data-toggle="collapse" data-parent="#menu-${param.parentId}" data-href="#collapse-${menu.id}" href="#collapse-${menu.id}" title="${menu.description}"><i class="icon-chevron-${not empty firstMenu && firstMenu ? 'down' : 'right'}"></i>&nbsp;${menu.resourceName}</a>
		    </div>
		    <div id="collapse-${menu.id}" class="accordion-body collapse ${not empty firstMenu && firstMenu ? 'in' : ''}">
				<div class="accordion-inner">
					<ul class="nav nav-list"><c:forEach items="${menuList}" var="menu2"><c:if test="${menu2.parent.id eq menu.id&&menu2.isShow eq '1'}">
						<li><a data-href=".menu3-${menu2.id}" href="${fn:indexOf(menu2.url, '://') eq -1 ? ctx : ''}${not empty menu2.url ? menu2.url : '/404'}" target="mainFrame" ><i class="icon-${not empty menu2.icon ? menu2.icon : 'circle-arrow-right'}"></i>&nbsp;${menu2.resourceName}</a>
							<ul class="nav nav-list hide" style="margin:0;padding-right:0;"><c:forEach items="${menuList}" var="menu3"><c:if test="${menu3.parent.id eq menu2.id&&menu3.isShow ==1}">
								<li class="menu3-${menu2.id} hide"><a href="${fn:indexOf(menu3.url, '://') eq -1 ? ctx : ''}${not empty menu3.url ? menu3.url : '/404'}" target="mainFrame" ><i class="icon-${not empty menu3.icon ? menu3.icon : 'circle-arrow-right'}"></i>&nbsp;${menu3.resourceName}</a></li></c:if>
							</c:forEach></ul></li><c:set var="firstMenu" value="false"/></c:if></c:forEach></ul>
				</div>
		    </div>
		</div>
	</c:if></c:forEach></div>