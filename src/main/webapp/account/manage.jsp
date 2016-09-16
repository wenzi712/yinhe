<%@ page contentType="text/html" pageEncoding="UTF-8" %>
<%@taglib prefix="shiro" uri="http://shiro.apache.org/tags" %>
<!DOCTYPE html>
<html>
<head>
    <jsp:include page="/template/head.jsp">
        <jsp:param name="pageTitle" value="用户管理"></jsp:param>
    </jsp:include>
    <%@include file="/template/include/bootstrap-table.jspf" %>
    <%@include file="/template/include/bootstrap-dialog.jspf" %>
    <%@include file="/template/include/form.jspf" %>
    <%@include file="/template/include/ladda.jspf" %>
    <%@include file="/template/include/jsencrypt.jspf" %>
</head>
<body>
<div class="container body-content">
    <div id="toolbar">
        <button id="UpdateUserButton" class="btn btn-primary btn-lg ladda-button" data-style="expand-right"><span class="ladda-label">更新用户表</span></button>
        <script type="text/javascript">
            $(function () {
                $("#UpdateUserButton").click(function () {
                    Ladda.create(this).start();
                    var now = new Date();
                    var url = "${pageContext.request.contextPath}/api/calculate/excuse/用户管理/" + now.getFullYear() + "/" + (now.getMonth() + 1);
                    $.ajax({
                        type: "POST",
                        contentType: "application/json",
                        url: url,
                        dataType: "json",
                        success: function (msg) {
                            if (msg.success) {
                                BootstrapDialog.show({
                                    size: BootstrapDialog.SIZE_SMALL,
                                    type: BootstrapDialog.TYPE_SUCCESS,
                                    title: "成功",
                                    message: "更新成功"
                                });
                                $("#table").bootstrapTable("refresh");
                            }
                            else {
                                BootstrapDialog.show({
                                    size: BootstrapDialog.SIZE_SMALL,
                                    type: BootstrapDialog.TYPE_WARNING,
                                    title: "警告",
                                    message: "更新错误"
                                });
                            }
                        },
                        error: function (jqXHR, textStatus, errorThrown) {
                            BootstrapDialog.show({
                                size: BootstrapDialog.SIZE_SMALL,
                                type: BootstrapDialog.TYPE_DANGER,
                                title: "错误",
                                message: textStatus + ":" + errorThrown
                            });
                        },
                        complete: function (url, options) {
                            Ladda.stopAll();
                        }
                    });
                });
            })

        </script>
    </div>
    <table id="table"></table>
    <ul id="table-context-menu" class="dropdown-menu">
        <li data-item="delete"><a>删除</a></li>
    </ul>
    <style type="text/css">
        .string {
            overflow: auto;
            text-overflow: ellipsis;
            min-width: 12em;
        }

        .boolean {
            overflow: auto;
            text-overflow: ellipsis;
            min-width: 10em;
        }

        .password {
            overflow: auto;
            text-overflow: ellipsis;
            min-width: 10em;
        }

        a.editable-click {
            border-bottom: none;
        }

        .editableform .form-control {
            width: 100%;
        }

        .editable-empty, .editable-empty:hover, .editable-empty:focus {
            font-style: normal;
        }
    </style>
    <script type="text/javascript">
        var roles = [];
        $.ajax({
            url: "${pageContext.request.contextPath}/api/account/list/role",
            async: false,
            success: function (result) {
                for (var item in result.roles) {
                    roles.push({value: result.roles[item], text: result.roles[item]});
                }
            }
        });
        var save = [{value: true, text: "允许"},
            {value: false, text: "禁止"}
        ];

        function IncreaseIdentification(data) {
            for (var i = 0; i < data.length; i++) {
                data[i].Id = i;
            }
        }

        $(function () {
            $.fn.editable.defaults.showbuttons = false;
            $.fn.editable.defaults.mode = "inline";
            var high = $(this).height() - 160;
            if (high <= 160) {
                high = 160;
            }

            $("#table").bootstrapTable({
                        columns: [
                            [
                                {title: "ID", field: "Id", visible: false},
                                {title: "营业部", field: "Department", align: "center", class: "string"},
                                {title: "部门", field: "Organization", align: "center", class: "string"},
                                {title: "姓名", field: "Name", align: "center", class: "string"},
                                {title: "角色", field: "Role", align: "center", class: "string", editable: {type: "select", source: roles}},
                                {title: "存档权限", field: "Export", align: "center", class: "boolean", editable: {type: "select", source: save}},
                                {title: "登录名", field: "LoginID", align: "center", class: "string", editable: {type: "text", emptytext: "[指定登陆名]", minlength: 6, maxlength: 16}},
                                {title: "密码", field: "Password", align: "center", class: "password", editable: {type: "password", emptytext: "[重置密码]", placeholder: "密码", minlength: 6, maxlength: 16}}
                            ]
                        ],
                        uniqueId: "Id",
                        url: "${pageContext.request.contextPath}/api/account/manage/get",
                        toolbar: "#toolbar",
                        locale: "zh-CN",
                        height: high,
                        search: true,
                        showColumns: true,
                        showRefresh: true,
                        minimumCountColumns: 3,
                        contextMenuAutoClickRow: true,
                        contextMenu: "#table-context-menu",
                        onClickRow: function (row, $el) {
                            $("#table").find(".success").removeClass("success");
                            $el.addClass("success");
                        },
                        onLoadSuccess: function (data) {
                            IncreaseIdentification(data);
                            $("#table").bootstrapTable("load", data);
                        },

                        onContextMenuItem: function (row, $el) {
                            switch ($el.data("item")) {
                                case "delete":
                                    BootstrapDialog.confirm({
                                        type: BootstrapDialog.TYPE_DANGER,
                                        title: "信息",
                                        message: "确认删除[" + row.LoginID + "]?",
                                        btnCancelLabel: "取消",
                                        btnOKLabel: "删除",
                                        btnOKClass: "btn-danger",
                                        callback: function (result) {
                                            if (result && row.LoginID != null) {
                                                $.ajax({
                                                    type: "DELETE",
                                                    contentType: "application/json",
                                                    url: "${pageContext.request.contextPath}/api/account/manage/delete/" + row.LoginID,
                                                    dataType: "json",
                                                    success: function (msg) {
                                                        if (msg != null && msg.success) {
                                                            BootstrapDialog.show({
                                                                size: BootstrapDialog.SIZE_SMALL,
                                                                type: BootstrapDialog.TYPE_SUCCESS,
                                                                title: "成功",
                                                                message: "用户删除成功"
                                                            });
                                                            $("#table").bootstrapTable("refresh");
                                                        }
                                                        else {
                                                            BootstrapDialog.show({
                                                                size: BootstrapDialog.SIZE_SMALL,
                                                                type: BootstrapDialog.TYPE_WARNING,
                                                                title: "失败",
                                                                message: msg.message
                                                            });
                                                        }
                                                    },
                                                    error: function (jqXHR, textStatus, errorThrown) {
                                                        BootstrapDialog.show({
                                                            size: BootstrapDialog.SIZE_SMALL,
                                                            type: BootstrapDialog.TYPE_WARNING,
                                                            title: "错误",
                                                            message: textStatus + ":" + errorThrown
                                                        });
                                                    }
                                                });
                                            }
                                        }
                                    });
                                    break;
                            }
                        },
                        onEditableSave: function (field, row, oldValue, $el) {
                            var id = row.Id;
                            var currentRow = $.extend(true, {}, row);
                            var oldRow = $.extend(true, {}, row);
                            oldRow[field] = oldValue;
                            switch (field) {
                                case "Export":
                                    oldRow[field] = $.parseJSON(row[field]);
                                    break;
                                case "LoginID":
                                    var isContinue = false;
                                    if (!currentRow.LoginID) {
                                        $("#table").bootstrapTable("updateByUniqueId", {
                                            id: id,
                                            row: oldRow
                                        });
                                        $("#table").bootstrapTable("resetView");
                                        BootstrapDialog.show({
                                            size: BootstrapDialog.SIZE_SMALL,
                                            type: BootstrapDialog.TYPE_DANGER,
                                            title: "错误",
                                            message: "登录名不能为空"
                                        });
                                        return;
                                    }
                                    $.ajax({
                                        url: "${pageContext.request.contextPath}/api/account/manage/exist?LoginID=" + currentRow.LoginID,
                                        async: false,
                                        success: function (result) {
                                            isContinue = !(result.exist);
                                        }
                                    });
                                    if (!isContinue) {
                                        BootstrapDialog.show({
                                            size: BootstrapDialog.SIZE_SMALL,
                                            type: BootstrapDialog.TYPE_DANGER,
                                            title: "错误",
                                            message: "登录名已经存在"
                                        });
                                        $("#table").bootstrapTable("updateByUniqueId", {
                                            id: id,
                                            row: oldRow
                                        });
                                        $("#table").bootstrapTable("resetView");
                                        return;
                                    }
                                    break;
                                case "Password":
                                    if (!currentRow.Password) {
                                        BootstrapDialog.show({
                                            size: BootstrapDialog.SIZE_SMALL,
                                            type: BootstrapDialog.TYPE_DANGER,
                                            title: "错误",
                                            message: "密码为空"
                                        });
                                        return;
                                    }
                                    currentRow.Password = encrypt.encrypt(currentRow.Password + "#" + (new Date()).valueOf());
                                    break;
                            }

                            $.ajax({
                                type: "POST",
                                contentType: "application/json",
                                async: false,
                                url: "${pageContext.request.contextPath}/api/account/manage/update",
                                data: JSON.stringify(currentRow),
                                dataType: "json",
                                success: function (msg) {
                                    switch (field) {
                                        case "Password":
                                        case "Export":
                                            $("#table").bootstrapTable("updateByUniqueId", {
                                                id: id,
                                                row: oldRow
                                            });
                                            $("#table").bootstrapTable("resetView");
                                            return;
                                    }

                                    if (!msg.success) {
                                        $("#table").bootstrapTable("updateByUniqueId", {
                                            id: id,
                                            row: oldRow
                                        });
                                        $("#table").bootstrapTable("resetView");
                                        BootstrapDialog.show({
                                            size: BootstrapDialog.SIZE_SMALL,
                                            type: BootstrapDialog.TYPE_DANGER,
                                            title: "错误",
                                            message: "服务器未保存"
                                        });
                                    }
                                },
                                error: function (jqXHR, textStatus, errorThrown) {
                                    $("#table").bootstrapTable("updateByUniqueId", {
                                        id: id,
                                        row: oldRow
                                    });
                                    $("#table").bootstrapTable("resetView");
                                }
                            });
                        }
                    }
            );
        });
    </script>
    <%@include file="/template/footer.jspf" %>
    <script type="text/javascript">
        $(window).resize(function () {
            var high = $(this).height() - 160;
            if (high <= 160) {
                high = 160;
            }
            $("#table").bootstrapTable("resetView", {height: high});
        });
    </script>
</body>
</html>
