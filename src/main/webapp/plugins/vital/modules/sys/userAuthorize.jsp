<%@ taglib prefix="s" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/plugins/vital/views/include/taglib.jsp" %>
<html>
<head>
    <title>用户授权</title>
    <meta name="decorator" content="blank"/>
    <script type="text/javascript">
        $(".js-example-basic-multiple").select2();

        function targetCheck(obj,targetid) {
            if(obj.checked){
                $("#select_"+targetid).attr("disabled",false);
            }else{
                $("#select_"+targetid).attr("disabled",true);
                $("#select_"+targetid).val(null).trigger("change");
                map.delete(targetid.toString());
            }
        }

        var map=new Map();
        var userid="${user.id}";
        function roleChange(obj) {
            if ($("#"+obj.id.replace("select_","chk_")).attr("checked")){
                map.set(obj.id.replace("select_",""),$("#"+obj.id).val());
            }
        }

        $(document).ready(function() {
            //获取其他领域的授权信息(实例=>角色)
            $.getJSON("${ctx}/sys/user/userRoleData?userId=${user.id}",function(data){
                for(var targetid in data){
                    map.set(targetid,data[targetid]);
                    var roles=data[targetid];
                    $("#chk_"+targetid).attr("checked",true);
                    $("#select_"+targetid).attr("disabled",false);
                    $("#select_"+targetid).val(roles).trigger("change");
                }

            });
            //获取系统领域的授权信息(角色)
            $.getJSON("${ctx}/sys/user/selectSystemRoleData?userId=${user.id}",function(data){
                for(var role_id in data){
                    $("#chk_role_"+data[role_id].roleId).attr("checked",true);
                }
            });
        });

        function getSystemDomain() {
            var str="";
            $('input[name="chk_role"]:checked').each(function(){
                str+=","+$(this).val();
            });
            return str;
        }

    </script>
</head>
<body>

<ul id="myTab" class="nav nav-tabs">
    <s:forEach items="${domainList}" var="domain" varStatus="st">
        <li class="${st.index=='0'?"active":""}">
            <a href="#domain_${domain.id}" data-toggle="tab">${domain.domainName}</a>
        </li>
    </s:forEach>
</ul>
<div id="myTabContent" class="tab-content">

    <s:forEach items="${domainList}" var="domain" varStatus="st">
        <s:if test="${domain.enableMulti=='0'}"><!--系统领域-->
            <div class="tab-pane fade  ${st.index=='0'?"in active":""}" id="domain_${domain.id}" style="margin-left:100px;margin-top:10px">
                <s:forEach items="${roleMap[domain.id]}" var="role">
                    <input type="checkbox" id="chk_role_${role.id}" name="chk_role" value="${role.id}" />${role.roleName}<p>
                </s:forEach>
            </div>
        </s:if>
        <s:if test="${domain.enableMulti=='1'}"><!--其他领域-->
            <div class="tab-pane fade ${st.index=='0'?"in active":""}" id="domain_${domain.id}">
                <br>
                <table width="80%" cellspacing="25px" align="center">
                    <thead>
                    <tr>
                        <th align="left">实例名称</th><th align="left">角色名称</th>
                    </tr>
                    </thead>

                    <c:forEach items="${targetMap[domain.id]}" var="target">
                        <tr>
                            <td>
                                <input type="checkbox" id="chk_${target.id}" value="${target.id}" onchange="targetCheck(this,'${target.id}')"/>${target.objectName}
                            </td>
                            <td>
                                <select id="select_${target.id}" class="js-example-basic-multiple" multiple="multiple" style="width: 300px" disabled="disabled" onchange="roleChange(this)">
                                    <c:forEach items="${roleMap[domain.id]}" var="role">
                                        <option value="${role.id}">${role.roleName}</option>
                                    </c:forEach>
                                </select>
                            </td>
                        </tr>
                    </c:forEach>
                </table>

            </div>
        </s:if>
    </s:forEach>


</div>
</body>
</html>
