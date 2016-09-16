<%@ page contentType="text/html" pageEncoding="UTF-8" %>
<%@taglib prefix="shiro" uri="http://shiro.apache.org/tags" %>
<!DOCTYPE html>
<html>
<head>
    <jsp:include page="/template/head.jsp">
        <jsp:param name="pageTitle" value="月度考核参数设置"></jsp:param>
    </jsp:include>
    <%@include file="/template/include/bootstrap-table.jspf" %>
    <%@include file="/template/include/bootstrap-dialog.jspf" %>
    <%@include file="/template/include/form.jspf" %>
</head>
<body>
<div class="container body-content">
    <div id="toolbar">
        <button class="btn btn-success btn-lg" data-toggle="modal" data-target="#addModal">增加</button>
    </div>
    <table id="table"></table>
    <ul id="table-context-menu" class="dropdown-menu">
        <li data-item="delete"><a>删除</a></li>
        <li data-item="add"><a>增加</a></li>
    </ul>
    <style type="text/css">
        .string {
            overflow: auto;
            text-overflow: ellipsis;
            width: 16em;
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
            if (value == null) {
                return;
            }
            if (value == '-') {
                return value;
            }
            return value.toFixed(2);
        }
    </script>
    <script type="text/javascript">
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
                                {title: "参数名称", field: "Name", align: "center", class: "string"},
                                {title: "分段标识1", field: "SectionSign1", align: "center", class: "money", editable: {type: "number", step: 0.01}, formatter: money},
                                {title: "分段标识2", field: "SectionSign2", align: "center", class: "money", editable: {type: "number", step: 0.01}, formatter: money},
                                {title: "参数1", field: "Parameter1", align: "center", class: "money", editable: {type: "number", step: 0.01}, formatter: money},
                                {title: "参数2", field: "Parameter2", align: "center", class: "money", editable: {type: "number", step: 0.01}, formatter: money},
                                {title: "参数3", field: "Parameter3", align: "center", class: "money", editable: {type: "number", step: 0.01}, formatter: money}
                            ]
                        ],
                        uniqueId: "Name",
                        url: "${pageContext.request.contextPath}/api/parameter/get",
                        toolbar: "#toolbar",
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
                        onContextMenuItem: function (row, $el) {
                            switch ($el.data("item")) {
                                case "delete":
                                    BootstrapDialog.confirm({
                                        type: BootstrapDialog.TYPE_DANGER,
                                        title: "信息",
                                        message: "确认删除[" + row.Name + "]?",
                                        btnCancelLabel: "取消",
                                        btnOKLabel: "删除",
                                        btnOKClass: "btn-danger",
                                        callback: function (result) {
                                            if (result && row.Name != null) {
                                                $.ajax({
                                                    type: "DELETE",
                                                    contentType: "application/json",
                                                    url: "${pageContext.request.contextPath}/api/parameter/delete/" + row.Name,
                                                    dataType: "json",
                                                    success: function (data, textStatus, jqXHR) {
                                                        if (data != null && data.success) {
                                                            BootstrapDialog.show({
                                                                size: BootstrapDialog.SIZE_SMALL,
                                                                type: BootstrapDialog.TYPE_SUCCESS,
                                                                title: "成功",
                                                                message: "参数删除成功"
                                                            });
                                                            $("#table").bootstrapTable("refresh");
                                                        }
                                                        else {
                                                            BootstrapDialog.show({
                                                                size: BootstrapDialog.SIZE_SMALL,
                                                                type: BootstrapDialog.TYPE_WARNING,
                                                                title: "失败",
                                                                message: data.message
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
                                case "add":
                                    $("#addModal").modal("show");
                                    break;
                            }
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
                                $("#table").bootstrapTable("resetView");
                                BootstrapDialog.show({
                                    size: BootstrapDialog.SIZE_SMALL,
                                    type: BootstrapDialog.TYPE_DANGER,
                                    title: "错误",
                                    message: "输入的数据有错"
                                });
                                return;
                            }
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
                                url: "${pageContext.request.contextPath}/api/parameter/update",
                                data: JSON.stringify(row),
                                dataType: "json",
                                success: function (msg) {
                                    if (!msg.success) {
                                        $("#table").bootstrapTable("updateByUniqueId", {
                                            id: id,
                                            row: oldRow
                                        });
                                        $("#table").bootstrapTable("resetView");
                                    }
                                },
                                error: function (e) {
                                    console.log("ERROR: ", e);
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

    <!--Add Modal-->
    <div id="addModal" class="modal fade" tabindex="-1" role="dialog" data-backdrop="static">
        <div class="modal-dialog">
            <div class="modal-content">
                <!--Modal Header-->
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal">
                        <span aria-hidden="true">&times;</span>
                        <span class="sr-only">关闭</span>
                    </button>
                    <h4 class="modal-title">增加参数</h4>
                </div>
                <form id="addForm" class="form-horizontal" data-toggle="validator">
                    <!--Modal Body-->
                    <div class="modal-body">
                        <div class="form-group has-feedback">
                            <label class="col-xs-3 control-label">参数名称</label>
                            <div class="col-xs-5">
                                <input name="Name" type="text" class="form-control" data-remote="${pageContext.request.contextPath}/api/parameter/exist" data-remote-error="参数名称已存在。" required/>
                                <span class="glyphicon form-control-feedback" aria-hidden="true"></span>
                            </div>
                            <span class="help-block with-errors"></span>
                        </div>
                        <div class="form-group has-feedback">
                            <label class="col-xs-3 control-label">分段标识1</label>
                            <div class="col-xs-5">
                                <input name="SectionSign1" type="number" value="0.00" step="0.01" class="form-control" required/>
                                <span class="glyphicon form-control-feedback" aria-hidden="true"></span>
                            </div>
                            <span class="help-block with-errors"></span>
                        </div>
                        <div class="form-group has-feedback">
                            <label class="col-xs-3 control-label">分段标识2</label>
                            <div class="col-xs-5">
                                <input name="SectionSign2" type="number" value="0.00" step="0.01" class="form-control" required/>
                                <span class="glyphicon form-control-feedback" aria-hidden="true"></span>
                            </div>
                            <span class="help-block with-errors"></span>
                        </div>
                        <div class="form-group has-feedback">
                            <label class="col-xs-3 control-label">参数1</label>
                            <div class="col-xs-5">
                                <input name="Parameter1" type="number" value="0.00" step="0.01" class="form-control" required/>
                                <span class="glyphicon form-control-feedback" aria-hidden="true"></span>
                            </div>
                            <span class="help-block with-errors"></span>
                        </div>
                        <div class="form-group has-feedback">
                            <label class="col-xs-3 control-label">参数2</label>
                            <div class="col-xs-5">
                                <input name="Parameter2" type="number" value="0.00" step="0.01" class="form-control" required/>
                                <span class="glyphicon form-control-feedback" aria-hidden="true"></span>
                            </div>
                            <span class="help-block with-errors"></span>
                        </div>
                        <div class="form-group has-feedback">
                            <label class="col-xs-3 control-label">参数3</label>
                            <div class="col-xs-5">
                                <input name="Parameter3" type="number" value="0.00" step="0.01" class="form-control" required/>
                                <span class="glyphicon form-control-feedback" aria-hidden="true"></span>
                            </div>
                            <span class="help-block with-errors"></span>
                        </div>
                    </div>
                    <!--Modal Footer-->
                    <div class="modal-footer">
                        <button type="button" class="btn btn-default" data-dismiss="modal">取消</button>
                        <button type="submit" class="btn btn-success">增加</button>
                    </div>
                </form>
            </div>
        </div>
    </div>
    <script type="application/javascript">
        $(function () {
            $("#addModal").on("hidden.bs.modal", function () {
                $("#addForm").resetForm();
            });

            $("#addForm").validator().on("submit", function (e) {
                if (!e.isDefaultPrevented()) {
                    var data = $("#addForm").serializeObject();
                    $.ajax({
                        contentType: "application/json",
                        cache: false,
                        async: false,
                        url: "${pageContext.request.contextPath}/api/parameter/add",
                        type: "POST",
                        data: JSON.stringify(data),
                        dataType: "json",
                        contentType: "application/json",
                        success: function (msg) {
                            $("#addForm").resetForm();
                            if (msg != null && msg.success) {
                                BootstrapDialog.show({
                                    size: BootstrapDialog.SIZE_SMALL,
                                    type: BootstrapDialog.TYPE_SUCCESS,
                                    title: "成功",
                                    message: "参数添加成功"
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
                            $("#addForm").resetForm();
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
        });
    </script>
</body>
</html>