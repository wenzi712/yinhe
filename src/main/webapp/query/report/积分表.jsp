<%@ page contentType="text/html" pageEncoding="UTF-8" %>
<%@taglib prefix="shiro" uri="http://shiro.apache.org/tags" %>
<!DOCTYPE html>
<html>
<head>
    <jsp:include page="/template/head.jsp">
        <jsp:param name="pageTitle" value="积分表[报表查询]"></jsp:param>
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
                                {title: "营业部", field: "Department", rowspan: 2, align: "center", class: "string", valign: "middle"},
                                {title: "部门", field: "Organization", rowspan: 2, align: "center", class: "string", valign: "middle"},
                                {title: "姓名", field: "Name", rowspan: 2, align: "center", class: "string", valign: "middle"},
                                {title: "基本情况", colspan: 2, align: "center"},
                                {title: "产品销售", colspan: 7, align: "center"},
                                {title: "新开户", colspan: 11, align: "center"},
                                {title: "融资融券", colspan: 5, align: "center"},
                                {title: "其他资产", colspan: 4, align: "center"},
                                {title: "流失资产", colspan: 9, align: "center"},
                                {title: "降佣", colspan: 2, align: "center"},
                                {title: "合规", rowspan: 2, field: "Row33", align: "center", class: "double", formatter: "money", valign: "middle"},
                                {title: "行政评价", rowspan: 2, field: "Row34", align: "center", class: "double", formatter: "money", valign: "middle"},
                                {title: "总分", colspan: 1, align: "center"},
                                {title: "积分对应提成比例", colspan: 3, align: "center"}
							],
                            [
                                //基本情况
                                {title: "服务客户数", field: "Row01", align: "center", class: "double", formatter: "integer"},
                                {title: "服务客户资产(万)", field: "Row02", align: "center", class: "double", formatter: "money"},
                                //产品销售
                                {title: "权益类产品销售金额(万)", field: "Row03", align: "center", class: "double", formatter: "money"},
                                {title: "权益类产品销售得分(0.3分/万)", field: "Row04", align: "center", class: "double", formatter: "money"},
                                {title: "固定收益类销售金额(万)", field: "Row05", align: "center", class: "double", formatter: "money"},
                                {title: "固定收益类产品销售得分(0.1分/万)", field: "Row06", align: "center", class: "double", formatter: "money"},
                                {title: "产品销售总分(合计上限50分)", field: "Row07", align: "center", class: "double", formatter: "money"},
                                {title: "续做固定产品(万)", field: "Row43", align: "center", class: "double", formatter: "money"},
                                {title: "续做固定产品得分(0.1分/万)", field: "Row44", align: "center", class: "double", formatter: "money"},
                                //新开户
                                {title: "新开客户数(1万以下)", field: "Row08", align: "center", class: "double", formatter: "money"},
                                {title: "新开户得分(1分/户)", field: "Row09", align: "center", class: "double", formatter: "money"},
                                {title: "新开客户数(1万以上)", field: "Row10", align: "center", class: "double", formatter: "money"},
                                {title: "新开户得分(2分/户)", field: "Row11", align: "center", class: "double", formatter: "money"},
                                {title: "新开客户数(10万以上)", field: "Row12", align: "center", class: "double", formatter: "money"},
                                {title: "新开户得分(3分/户)", field: "Row13", align: "center", class: "double", formatter: "money"},
                                {title: "新开客户数(50万以上)", field: "Row14", align: "center", class: "double", formatter: "money"},
                                {title: "新开户得分(5分/户)", field: "Row15", align: "center", class: "double", formatter: "money"},
                                {title: "新增资产(万)", field: "Row16", align: "center", class: "double", formatter: "money"},
                                {title: "新增资产得分(0.3分/万)", field: "Row17", align: "center", class: "double", formatter: "money"},
                                {title: "新开户总分(合计上限50分)", field: "Row18", align: "center", class: "double", formatter: "money"},
                                //融资融券
                                {title: "新开客户数", field: "Row19", align: "center", class: "double", formatter: "money"},
                                {title: "新开户得分(3分/户)", field: "Row20", align: "center", class: "double", formatter: "money"},
                                {title: "两融余额市占率差额(万)", field: "Row21", align: "center", class: "double", formatter: "money"},
                                {title: "两融余额市占率差额得分(0.01分/万)", field: "Row22", align: "center", class: "double", formatter: "money"},
                                {title: "两融总分", field: "Row23", align: "center", class: "double", formatter: "money"},
                                //其他资产
                                {title: "其他开户", field: "Row39", align: "center", class: "double", formatter: "money"},
                                {title: "其他开户得分", field: "Row40", align: "center", class: "double", formatter: "money"},
                                {title: "其他资产", field: "Row41", align: "center", class: "double", formatter: "money"},
                                {title: "其他资产得分", field: "Row42", align: "center", class: "double", formatter: "money"},
                                //流失资产
                                {title: "流失客户数", field: "Row24", align: "center", class: "double", formatter: "money"},
                                {title: "流失客户数得分", field: "Row25", align: "center", class: "double", formatter: "money"},
                                {title: "流失资产(万)", field: "Row26", align: "center", class: "double", formatter: "money"},
                                {title: "流失资产得分(0.3分/万)", field: "Row27", align: "center", class: "double", formatter: "money"},
                                {title: "隐形流失资产(万)", field: "Row28", align: "center", class: "double", formatter: "money"},
                                {title: "隐形流失资产得分(0.3分/万)", field: "Row29", align: "center", class: "double", formatter: "money"},
                                {title: "流失年佣金", field: "Row30", align: "center", class: "double", formatter: "money"},
                                {title: "流失年佣金得分(2分/千)", field: "Row31", align: "center", class: "double", formatter: "money"},
                                {title: "流失资产总分", field: "Row32", align: "center", class: "double", formatter: "money"},
                                //降佣
                                {title: "降佣客户数", field: "Row45", align: "center", class: "double", formatter: "money"},
                                {title: "降佣客户积分", field: "Row46", align: "center", class: "double", formatter: "money"},
                                //总分
                                {title: "得分汇总", field: "Row35", align: "center", class: "double", formatter: "money"},
                                //积分对应提成比例
                                {title: "服务积分合格线", field: "Row36", align: "center", class: "double", formatter: "money"},
                                {title: "积分与合格线百分比", field: "Row37", align: "center", class: "double", formatter: "percentage"},
                                {title: "对应提成比例", field: "Row38", align: "center", class: "double", formatter: "money"}
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
