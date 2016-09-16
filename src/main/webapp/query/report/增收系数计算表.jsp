<%@ page contentType="text/html" pageEncoding="UTF-8" %>
<%@taglib prefix="shiro" uri="http://shiro.apache.org/tags" %>
<!DOCTYPE html>
<html>
<head>
    <jsp:include page="/template/head.jsp">
        <jsp:param name="pageTitle" value="增收系数计算表[报表查询]"></jsp:param>
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
                                {title: "累计流失佣金对应收入", field: "Row01", align: "center", class: "double", formatter: "money"},
                                {title: "累计流失资产对应收入", field: "Row02", align: "center", class: "double", formatter: "money"},
                                {title: "隐形流失客户资产对应收入", field: "Row03", align: "center", class: "double", formatter: "money"},
                                {title: "利差", field: "Row04", align: "center", class: "double", formatter: "money"},
                                {title: "息费", field: "Row05", align: "center", class: "double", formatter: "money"},
                                {title: "普通及担保品交易净佣", field: "Row06", align: "center", class: "double", formatter: "money"},
                                {title: "信用交易净佣", field: "Row07", align: "center", class: "double", formatter: "money"},
                                {title: "天天利收入", field: "Row08", align: "center", class: "double", formatter: "money"},
                                {title: "水星1收入", field: "Row09", align: "center", class: "double", formatter: "money"},
                                {title: "水星2收入", field: "Row10", align: "center", class: "double", formatter: "money"},
                                {title: "产品销售收入", field: "Row11", align: "center", class: "double", formatter: "money"},
                                {title: "降佣年损失", field: "Row12", align: "center", class: "double", formatter: "money"},
                                {title: "收入合计", field: "Row13", align: "center", class: "double", formatter: "money"},
                                {title: "基期收入市占率", field: "Row14", align: "center", class: "double", formatter: "percentage"},
                                {title: "本期市场收入", field: "Row15", align: "center", class: "double", formatter: "money"},
                                {title: "本期目标创收额", field: "Row16", align: "center", class: "double", formatter: "money"},
                                {title: "收入市占率差额", field: "Row17", align: "center", class: "double", formatter: "money"},
                                {title: "收入市占率完成率", field: "Row18", align: "center", class: "double", formatter: "percentage"},
                                {title: "月度服务指标增收系数", field: "Row19", align: "center", class: "double", formatter: "percentage"}
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
                        resizable: true,
                        onClickRow: function (row, $el) {
                            $("#table").find(".success").removeClass("success");
                            $el.addClass("success");
                        },
                        onLoadSuccess: function (data) {
                            dyeing(data);
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