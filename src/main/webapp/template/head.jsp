<%@page contentType="text/html; charset=utf-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="X-UA-Compatible" content="IE=edge,Chrome=1"/>
    <meta http-equiv="X-UA-Compatible" content="IE=9"/>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <link href="${pageContext.request.contextPath}/img/logo.ico" rel="shortcut icon">
    <title><%= request.getParameter("pageTitle") %>
    </title>
    <%@include file="/template/include/bootstrap.jspf" %>
    <%@include file="/template/include/bootstrap-ie.jspf" %>
    <script type="text/javascript">
        var RootURL = "${pageContext.request.contextPath}/";
    </script>
</head>
<body>
<div class="container body-content">
    <%@include file="/template/navigate.jspf" %>
</div>
</body>
</html>