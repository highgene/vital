<%@ taglib prefix="s" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/plugins/vital/views/include/taglib.jsp" %>
<html>
<head>
    <title>用户授权</title>
    <meta name="decorator" content="blank"/>
    <script type="text/javascript">
        $(".js-example-basic-multiple").select2();
        var map=new Map();
        function roleCheck(obj,roleid) {
            if(obj.checked){
                $("#select_"+roleid).attr("disabled",false);
            }else{
                $("#select_"+roleid).attr("disabled",true);
                $("#select_"+roleid).val(null).trigger("change");
                map.delete(roleid.toString());
            }
        }

        var targetid="${target.id}";
        function userChange(obj) {
            if ($("#"+obj.id.replace("select_","chk_")).attr("checked")){
                map.set(obj.id.replace("select_",""),$("#"+obj.id).val());
            }
        }

        $(document).ready(function() {
            $.getJSON("${ctx}/sys/user/userRoleDataByTarget?targetId=${target.id}",function(data){
                for(var roleid in data){
                    map.set(roleid,data[roleid]);
                    var users=data[roleid];
                    $("#chk_"+roleid).attr("checked",true);
                    $("#select_"+roleid).attr("disabled",false);
                    $("#select_"+roleid).val(users).trigger("change");
                }
            });
        });


    </script>
</head>
<body>

        <table width="80%" cellspacing="25px" align="center">
            <thead>
            <tr>
                <th align="left">角色名称</th><th align="left">用户名称</th>
            </tr>
            </thead>

            <c:forEach items="${roleList}" var="role">
                <tr>
                    <td>
                        <input type="checkbox" id="chk_${role.id}" value="${role.id}" onchange="roleCheck(this,'${role.id}')"/>${role.roleName}
                    </td>
                    <td>
                        <select id="select_${role.id}" class="js-example-basic-multiple" multiple="multiple" style="width: 300px" disabled="disabled" onchange="userChange(this)">
                            <c:forEach items="${userList}" var="user">
                                <option value="${user.id}">${user.realName}</option>
                            </c:forEach>
                        </select>
                    </td>
                </tr>
            </c:forEach>
        </table>

</body>
</html>
