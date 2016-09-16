<%@ page contentType="text/html;charset=utf-8" language="java" %>

<!DOCTYPE html>
<html>
<head>
    <jsp:include page="/template/head.jsp">
        <jsp:param name="pageTitle" value="<%=com.yinhe.config.Parameter.PROJECT_NAME %>"></jsp:param>
    </jsp:include>
</head>
<body>
<div class="container body-content">
    <%@include file="/template/footer.jspf" %>
</div>
</body>
</html>
