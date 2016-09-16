<%@ page contentType="text/html" pageEncoding="UTF-8" %>
<%@taglib prefix="shiro" uri="http://shiro.apache.org/tags" %>
<!DOCTYPE html>
<html>
<head>
    <jsp:include page="/template/head.jsp">
        <jsp:param name="pageTitle" value="提成基数计算表[报表查询]"></jsp:param>
    </jsp:include>
    <%@include file="/template/include/bootstrap-table.jspf" %>
    <%@include file="/template/include/bootstrap-datepicker.jspf" %>
    <%@include file="/template/include/bootstrap-dialog.jspf" %>
    <%@include file="/template/include/ladda.jspf" %>
    <%@include file="report.jspf" %>
</head>
<body>
<div class="container body-content">
    <div id="toolbar">
        <div class="col-xs-3">
            <div id="date" class="input-group date">
                <input type="text" class="form-control input-lg" readonly/>
                <span class="input-group-addon"><span class="glyphicon glyphicon-calendar"></span></span>
            </div>
        </div>
        <button id="queryButton" class="btn btn-primary btn-lg ladda-button" data-style="expand-right"><span class="ladda-label">查询</span></button>
        <%@include file="export.jspf" %>
    </div>
    <table id="table"></table>
    <script type="text/javascript">
        $(function () {
            $("#table").bootstrapTable({
                        columns: [
                            [
                                {title: "营业部", field: "Department", align: "center", class: "string"},
                                {title: "部门", field: "Organization", align: "center", class: "string"},
                                {title: "姓名", field: "Name", align: "center", class: "string"},
                                {title: "当月流失资产对应收入", field: "Row01", align: "center", class: "double", formatter: "money"},
                                {title: "当月流失佣金对应收入", field: "Row02", align: "center", class: "double", formatter: "money"},
                                {title: "息费", field: "Row03", align: "center", class: "double", formatter: "money"},
                                {title: "普通及担保品交易净佣", field: "Row04", align: "center", class: "double", formatter: "money"},
                                {title: "信用交易净佣", field: "Row05", align: "center", class: "double", formatter: "money"},
                                {title: "净息费", field: "Row06", align: "center", class: "double", formatter: "money"},
                                {title: "可提成基数", field: "Row07", align: "center", class: "double", formatter: "money"},
                                {title: "月度资产贡献达标率", field: "Row08", align: "center", class: "double", formatter: "percentage"},
                                {title: "提成基数", field: "Row09", align: "center", class: "double", formatter: "money"}
                            ]
                        ],
                        method: "get",
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
                            for (var i = 0; i < data.length; i++) {
                                if (data[i].Department == "总计") {
                                    $("#table").bootstrapTable("mergeCells", {index: i, field: "Department", colspan: 3});
                                    $("#table tr[data-index='" + i + "']").addClass("danger");
                                    continue;
                                }
                                if (data[i].Organization == "总计") {
                                    $("#table").bootstrapTable("mergeCells", {index: i, field: "Organization", colspan: 2});
                                    $("#table tr[data-index='" + i + "']").addClass("info");
                                    continue;
                                }
                                if (data[i].Name == "总计") {
                                    $("#table tr[data-index='" + i + "']").addClass("warning");
                                }
                            }
                        },
                        onLoadError: function (status, res) {
                            BootstrapDialog.show({
                                size: BootstrapDialog.SIZE_SMALL,
                                type: BootstrapDialog.TYPE_DANGER,
                                title: "错误",
                                message: "此月份数据不存在"
                            });
                        }
                    }
            );
        });
    </script>
    <%@include file="/template/footer.jspf" %>
</body>
</html>