<%--
  Created by IntelliJ IDEA.
  User: 24946
  Date: 2022/11/21
  Time: 20:08
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String baseUrl = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort() + "/" + request.getContextPath()+"/";
%>
<html>
<head>
    <base href="<%=baseUrl%>">
    <title>Title</title>
</head>
<body>

<!--

   add/create:跳转到添加页，或者打开添加操作的模态窗口
   save:执行添加操作
   edit:跳转到修改页，或者打开修改操作的模态窗口
   update:执行修改操作
   get:执行查询操作   find/select/query/...
   特殊操作 login等


 -->
$.ajax({
url :"",
data:{

},
type : "",
dataType: "json",
success: function(response){

}

})
</body>
</html>
