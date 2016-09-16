<%@ taglib prefix="shiro" uri="http://shiro.apache.org/tags" %>
<%@ page contentType="text/html" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <jsp:include page="/template/head.jsp">
        <jsp:param name="pageTitle" value="部门二次考核"></jsp:param>
    </jsp:include>
    <%@include file="/template/include/bootstrap-table.jspf" %>
</head>
<body>
<div class="container body-content">
    <div id="toolbar"></div>
    <table id="table"></table>
    <style type="text/css">
        .string {
            overflow: auto;
            text-overflow: ellipsis;
            width: 12em;
        }

        .money {
            overflow: auto;
            text-overflow: ellipsis;
            width: 10em;
        }

        a.editable-click {
            border-bottom: none;
        }

        .editableform .form-control {
            width: 100%;
        }
    </style>
    <script type="text/javascript">
        function money(value, row, index) {
            if (value == null || value == undefined) {
                return;
            }
            if (value == '-') {
                return value;
            }
            return value.toFixed(2);
        }
    </script>
    <script type="text/javascript">
        function IncreaseIdentification(data) {
            for (var i = 0; i < data.length; i++) {
                data[i].Id = i;
            }
        }

        $(function () {
            $.fn.editable.defaults.showbuttons = false;
            $.fn.editable.defaults.emptyclass = "editable";
            $.fn.editable.defaults.mode = "inline";
            var high = $(this).height() - 160;
            if (high <= 64) {
                high = 64;
            }
            $("#table").bootstrapTable({
                        columns: [
                            [
                                {title: "ID", field: "Id", visible: false},
                                {title: "部门", field: "Department", align: "center", class: "string"},
                                {title: "部门", field: "Organization", align: "center", class: "string"},
                                {title: "服务人", field: "Name", align: "center", class: "string"},
                                {title: "服务奖金预发放值", field: "Payment", align: "center", class: "money", formatter: money},
                                {title: "服务奖金调整", field: "Adjust", align: "center", class: "money", editable: {type: "number", step: 0.01}, formatter: money},
                                {title: "备注", field: "Remark", align: "center", class: "string", editable: {type: "textarea", emptytext: "[无]", rows: 2}}
                            ]
                        ],
                        uniqueId: "Id",
                        url: "${pageContext.request.contextPath}/api/data/adjust/get",
                        height: high,
                        contextMenuAutoClickRow: true,
                        locale: "zh-CN",
                        toolbar: "#toolbar",
                        height: high,
                        search: true,
                        showColumns: true,
                        showRefresh: true,
                        minimumCountColumns: 3,
                        contextMenuAutoClickRow: true,
                        onClickRow: function (row, $el) {
                            $("#table").find(".success").removeClass("success");
                            $el.addClass("success");
                        },
                        onLoadSuccess: function (data) {
                            IncreaseIdentification(data);
                            $("#table").bootstrapTable("load", data);
                        },
                        onEditableSave: function (field, row, oldValue, $el) {
                            var id = row.Id;
                            var currentValue = eval("row." + field);
                            var oldRow = $.extend(true, {}, row);
                            oldRow[field] = oldValue;
                            switch (field) {
                                case "Remark":
                                    if (currentValue == oldValue) {
                                        $("#table").bootstrapTable("resetView");
                                        return;
                                    }
                                    break;
                                default:
                                    currentValue = parseFloat(currentValue);
                                    if (isNaN(currentValue)) {
                                        $("#table").bootstrapTable("updateByUniqueId", {
                                            id: id,
                                            row: oldRow
                                        });
                                        BootstrapDialog.show({
                                            size: BootstrapDialog.SIZE_SMALL,
                                            type: BootstrapDialog.TYPE_DANGER,
                                            title: "错误",
                                            message: "输入的数据有错"
                                        });
                                        $("#table").bootstrapTable("resetView");
                                        return;
                                    }
                                    currentValue = parseFloat(currentValue);
                                    if (currentValue == oldValue) {
                                        $("#table").bootstrapTable("resetView");
                                        return;
                                    }
                                    break;
                            }

                            $.ajax({
                                type: "POST",
                                contentType: "application/json",
                                url: "${pageContext.request.contextPath}/api/data/adjust/update",
                                data: JSON.stringify(row),
                                dataType: "json",
                                success: function (msg) {
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
                                error: function (e) {
                                    $("#table").bootstrapTable("updateByUniqueId", {
                                        id: id,
                                        row: oldRow
                                    });
                                    $("#table").bootstrapTable("resetView");
                                    BootstrapDialog.show({
                                        size: BootstrapDialog.SIZE_SMALL,
                                        type: BootstrapDialog.TYPE_DANGER,
                                        title: "错误",
                                        message: "服务器错误"
                                    });
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
            if (high < 160) {
                high = 160;
            }
            $("#table").bootstrapTable("resetView", {height: high});
        });
    </script>
</body>
</html>
