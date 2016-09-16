<%@ page contentType="text/html" pageEncoding="UTF-8" %>
<%@taglib prefix="shiro" uri="http://shiro.apache.org/tags" %>
<!DOCTYPE html>
<html>
<head>
    <jsp:include page="/template/head.jsp">
        <jsp:param name="pageTitle" value="个人资料"></jsp:param>
    </jsp:include>
    <%@include file="/template/include/bootstrap-dialog.jspf" %>
    <%@include file="/template/include/form.jspf" %>
    <%@include file="/template/include/jsencrypt.jspf" %>
    <%@include file="/template/include/ladda.jspf" %>
</head>
<body>
<div class="container body-content">
    <form id="form" class="form-horizontal" data-toggle="validator" role="form">
        <div class="form-group">
            <label class="col-xs-2 control-label">姓名</label>
            <div class="col-xs-3">
                <p class="form-control-static"><shiro:principal property="name"/></p>
            </div>
        </div>
        <div class="form-group">
            <label class="col-xs-2 control-label">所属营业部</label>
            <div class="col-xs-3">
                <p class="form-control-static"><shiro:principal property="department"/></p>
            </div>
        </div>
        <div class="form-group">
            <label class="col-xs-2 control-label">所属部门</label>
            <div class="col-xs-3">
                <p class="form-control-static"><shiro:principal property="organization"/></p>
            </div>
        </div>
        <div class="form-group">
            <label class="col-xs-2 control-label">角色</label>
            <div class="col-xs-3">
                <p class="form-control-static"><shiro:principal property="role"/></p>
            </div>
        </div>
        <div class="form-group">
            <label class="col-xs-2 control-label">登陆名</label>
            <div class="col-xs-3">
                <p class="form-control-static"><shiro:principal property="loginID"/></p>
            </div>
        </div>
        <div class="form-group has-feedback">
            <label class="col-xs-2 control-label">原密码</label>
            <div class="col-xs-3">
                <input id="OldPassword" minlength="6" maxlength="16" type="password" class="form-control" required/>
                <span class="glyphicon form-control-feedback" aria-hidden="true"></span>
            </div>
            <span class="help-block with-errors"></span>
        </div>
        <div class="form-group has-feedback">
            <label class="col-xs-2 control-label">新密码</label>
            <div class="col-xs-3">
                <input id="NewPassword" minlength="6" maxlength="16" type="password" class="form-control" required/>
                <span class="glyphicon form-control-feedback" aria-hidden="true"></span>
            </div>
            <span class="help-block with-errors"></span>
        </div>
        <div class="form-group has-feedback">
            <label class="col-xs-2 control-label">确认新密码</label>
            <div class="col-xs-3">
                <input type="password" minlength="6" maxlength="16" class="form-control" data-match="#NewPassword" data-match-error="两次输入不匹配。" required/>
                <span class="glyphicon form-control-feedback" aria-hidden="true"></span>
            </div>
            <span class="help-block with-errors"></span>
        </div>
        <div class="form-group has-feedback">
            <div class="col-xs-offset-2" style="padding-left: 15px">
                <button type="submit" class="btn btn-primary btn-lg ladda-button" data-style="expand-right"><span class="ladda-label">修改密码</span></button>
            </div>
        </div>
    </form>
    <script type="text/javascript">
        $("#form").validator().on("submit", function (e) {
            if (!e.isDefaultPrevented()) {
                if ($("#OldPassword").val() == $("#NewPassword").val()) {
                    BootstrapDialog.show({
                        size: BootstrapDialog.SIZE_SMALL,
                        type: BootstrapDialog.TYPE_INFO,
                        title: "提示",
                        message: "新密码和原密码相同"
                    });
                    $("#form")[0].reset();
                    return false;
                }
                Ladda.create($("#form button[type='submit']")[0]).start();
                var data = {
                    OldPassword: encrypt.encrypt($("#OldPassword").val() + "#" + (new Date()).valueOf()),
                    NewPassword: encrypt.encrypt($("#NewPassword").val() + "#" + (new Date()).valueOf())
                };
                $.ajax({
                    contentType: "application/json",
                    url: "${pageContext.request.contextPath}/api/account/password/change",
                    type: "POST",
                    data: JSON.stringify(data),
                    dataType: "json",
                    success: function (msg) {
                        Ladda.stopAll();
                        if (msg != null && msg.success) {
                            BootstrapDialog.show({
                                size: BootstrapDialog.SIZE_SMALL,
                                type: BootstrapDialog.TYPE_SUCCESS,
                                title: "成功",
                                message: "密码已经修改成功",
                                onhide: function (dialogRef) {
                                    window.location.href = "${pageContext.request.contextPath}/account/logout";
                                }
                            });
                            setTimeout(function () {
                                window.location.href = "${pageContext.request.contextPath}/account/logout";
                            }, 1.5 * 1000);
                        }
                        else {
                            BootstrapDialog.show({
                                size: BootstrapDialog.SIZE_SMALL,
                                type: BootstrapDialog.TYPE_WARNING,
                                title: "失败",
                                message: msg.message
                            });
                            $("#form")[0].reset();
                        }
                    },
                    error: function (jqXHR, textStatus, errorThrown) {
                        Ladda.stopAll();
                        $("#form")[0].reset();
                        BootstrapDialog.show({
                            size: BootstrapDialog.SIZE_SMALL,
                            type: BootstrapDialog.TYPE_WARNING,
                            title: "错误",
                            message: textStatus + ":" + errorThrown
                        });
                    }
                });
                return false;
            }
        });
    </script>
</div>
<%@include file="/template/footer.jspf" %>
</body>
</html>
