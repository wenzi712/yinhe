<%@ page contentType="text/html" pageEncoding="UTF-8" %>
<%@taglib prefix="shiro" uri="http://shiro.apache.org/tags" %>
<!DOCTYPE html>
<html>
<head>
    <jsp:include page="/template/head.jsp">
        <jsp:param name="pageTitle" value="月度考核数据录入"></jsp:param>
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
            min-width: 10em;
        }

        .money {
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
                                {title: "服务人", field: "Name", align: "center", class: "string"},
                                {title: "其他开户数", field: "OtherAccount", align: "center", class: "money", editable: {type: "number", step: 0.01}, formatter: money},
                                {title: "其他资产", field: "OtherAsset", align: "center", class: "money", editable: {type: "number", step: 0.01}, formatter: money},
                                {title: "合规", field: "HeGui", align: "center", class: "money", editable: {type: "number", step: 0.01}, formatter: money},
                                {title: "行政评价", field: "XingZhengPingJia", align: "center", class: "money", editable: {type: "number", step: 0.01}, formatter: money},
                                {title: "有效覆盖系数", field: "YouXiaoFuGaiXiShu", align: "center", class: "money", editable: {type: "number", step: 0.01}, formatter: money},
                                {title: "重大任务系数1", field: "ZhongDaRenWuXiShu1", align: "center", class: "money", editable: {type: "number", step: 0.01}, formatter: money},
                                {title: "重大任务系数2", field: "ZhongDaRenWuXiShu2", align: "center", class: "money", editable: {type: "number", step: 0.01}, formatter: money},
                                {title: "重大任务系数3", field: "ZhongDaRenWuXiShu3", align: "center", class: "money", editable: {type: "number", step: 0.01}, formatter: money},
                                {title: "重大任务系数4", field: "ZhongDaRenWuXiShu4", align: "center", class: "money", editable: {type: "number", step: 0.01}, formatter: money},
                                {title: "重大任务系数5", field: "ZhongDaRenWuXiShu5", align: "center", class: "money", editable: {type: "number", step: 0.01}, formatter: money},
                                {title: "重大任务系数权重1", field: "ZhongDaRenWuXiShuQuanZhong1", align: "center", class: "money", editable: {type: "number", step: 0.01}, formatter: money},
                                {title: "重大任务系数权重2", field: "ZhongDaRenWuXiShuQuanZhong2", align: "center", class: "money", editable: {type: "number", step: 0.01}, formatter: money},
                                {title: "重大任务系数权重3", field: "ZhongDaRenWuXiShuQuanZhong3", align: "center", class: "money", editable: {type: "number", step: 0.01}, formatter: money},
                                {title: "重大任务系数权重4", field: "ZhongDaRenWuXiShuQuanZhong4", align: "center", class: "money", editable: {type: "number", step: 0.01}, formatter: money},
                                {title: "重大任务系数权重5", field: "ZhongDaRenWuXiShuQuanZhong5", align: "center", class: "money", editable: {type: "number", step: 0.01}, formatter: money}
                            ]
                        ],
                        uniqueId: "Id",
                        url: "${pageContext.request.contextPath}/api/data/get",
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
                            var currentValue = eval("row." + field);
                            currentValue = parseFloat(currentValue);
                            var id = row.Name;
                            var oldRow = $.extend(true, {}, row);
                            oldRow[field] = oldValue;
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
                                return;
                            }
                            currentValue = parseFloat(currentValue);
                            if (currentValue == oldValue) {
                                $("#table").bootstrapTable("updateByUniqueId", {
                                    id: id,
                                    row: oldRow
                                });
                                $("#table").bootstrapTable("resetView");
                                return;
                            }
                            $.ajax({
                                type: "POST",
                                contentType: "application/json",
                                url: "${pageContext.request.contextPath}/api/data/update",
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
            if (high <= 160) {
                high = 160;
            }
            $("#table").bootstrapTable("resetView", {height: high});
        });
    </script>
</body>
</html>
