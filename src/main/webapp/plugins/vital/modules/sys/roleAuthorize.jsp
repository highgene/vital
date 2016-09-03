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
        var roleid="${role.id}";
        var targetid="${target.id}";

        function targetCheck(obj,targetid) {
            if(obj.checked){
                $("#select_"+targetid).attr("disabled",false);
            }else{
                $("#select_"+targetid).attr("disabled",true);
                $("#select_"+targetid).val(null).trigger("change");
                map.delete(targetid.toString());
            }
        }

        function userChange(obj) {
            if ($("#"+obj.id.replace("select_","chk_")).attr("checked")){
                map.set(obj.id.replace("select_",""),$("#"+obj.id).val());
            }
        }

        $(document).ready(function() {
            $.getJSON("${ctx}/sys/user/userRoleDataByRole?roleId=${role.id}",function(data){
                for(var targetid in data){
                    map.set(targetid,data[targetid]);
                    var users=data[targetid];
                    $("#chk_"+targetid).attr("checked",true);
                    $("#select_"+targetid).attr("disabled",false);
                    $("#select_"+targetid).val(users).trigger("change");
                }
            });
        });


    </script>
</head>
<body>

        <table width="80%" cellspacing="25px" align="center">
            <thead>
            <tr>
                <th align="left">实例名称</th><th align="left">用户名称</th>
            </tr>
            </thead>

            <c:forEach items="${targetList}" var="target">
                <tr>
                    <td>
                        <input type="checkbox" id="chk_${target.id}" value="${target.id}" onchange="targetCheck(this,'${target.id}')"/>${target.objectName}
                    </td>
                    <td>
                        <select id="select_${target.id}" class="js-example-basic-multiple" multiple="multiple" style="width: 300px" disabled="disabled" onchange="userChange(this)">
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
