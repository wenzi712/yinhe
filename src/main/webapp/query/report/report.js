var tableName = $("title").text();
tableName = tableName.replace("[报表查询]", "").trim();
var now = new Date();
var url = RootURL + "api/report/get/" + tableName + "/" + now.getFullYear() + "/" + (now.getMonth() + 1);

var high = $(this).height() - 192;
if (high < 64) {
    high = 64;
}

$(window).resize(function () {
    var high = $(this).height() - 192;
    if (high < 64) {
        high = 64;
    }
    $("#table").bootstrapTable("resetView", {height: high});
});

function dyeing(data) {
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
}

$(function () {
    $("#date").datepicker({
        viewMode: "years",
        minViewMode: "months",
        format: "yyyy年mm月",
        endDate: "0m",
        startDate: "-5y",
        language: "zh-CN"
    });
    $("#date").datepicker("setDate", "0m");
});

$(function () {
    $("#queryButton").click(function () {
        Ladda.create(this).start();
        var selectDate = $("#date input").val();
        var selectYear = selectDate.substring(0, 4);
        var selectMonth = selectDate.substring(5, 7);
        $.ajax({
            type: "get",
            contentType: "application/json",
            url: RootURL + "api/report/get/" + tableName + "/" + selectYear + "/" + selectMonth,
            dataType: "json",
            success: function (data) {
                $("#table").bootstrapTable("load", data);
                dyeing(data);
                Ladda.stopAll();
            },
            error: function (jqXHR, textStatus, errorThrown) {
                BootstrapDialog.show({
                    size: BootstrapDialog.SIZE_SMALL,
                    type: BootstrapDialog.TYPE_DANGER,
                    title: "错误",
                    message: "此月份数据不存在"
                });
                Ladda.stopAll();
            }
        });
    });
});

function double(value, row, index) {
    if (value == null) {
        return;
    }
    if (value == '-') {
        return value;
    }
    return value.toFixed(4);
}

function integer(value, row, index) {
    if (value == null) {
        return;
    }
    return value.toFixed(0);
}

function money(value, row, index) {
    if (value == null) {
        return;
    }
    if (value == '-') {
        return value;
    }
    return value.toFixed(2);
}

function percentage(value, row, index) {
    if (value == null) {
        return;
    }
    if (value == '-') {
        return value;
    }
    return (value * 100).toFixed(2) + "%";
}