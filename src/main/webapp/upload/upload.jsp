<%@ taglib prefix="shiro" uri="http://shiro.apache.org/tags" %>
<%@ page contentType="text/html" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <jsp:include page="/template/head.jsp">
        <jsp:param name="pageTitle" value="数据导入"></jsp:param>
    </jsp:include>
    <%@include file="/template/include/bootstrap-datepicker.jspf" %>
    <%@include file="/template/include/bootstrap-fileinput.jspf" %>
    <%@include file="/template/include/bootstrap-dialog.jspf" %>
    <%@include file="/template/include/ladda.jspf" %>
    <script type="text/javascript">
        function resize() {
            var high = $(this).height() - 224;
            if (high < 128) {
                high = 128;
            }
            $("#resultDisplay").height(high);
        }
    </script>
</head>
<body>
<div class="container body-content">
    <div class="row">
        <div class="col-xs-5">
            <div id="date" class="input-group date">
                <input type="text" class="form-control input-lg" readonly/>
                <span class="input-group-addon"><span class="glyphicon glyphicon-calendar"></span></span>
            </div>
        </div>
        <script type="text/javascript">
            $(function () {
                $("#date").datepicker({
                    viewMode: "years",
                    minViewMode: "days",
                    endDate: "0d",
                    startDate: "-5y",
                    language: "zh-CN"
                });
                $("#date").datepicker("setDate", "0d");
            });
        </script>
        <button id="uploadButton" class="btn btn-primary btn-lg ladda-button" disabled="disabled" data-style="expand-right"><span class="ladda-label">上传</span></button>
        <button id="mergeButton" class="btn btn-primary btn-lg ladda-button" data-style="expand-right"><span class="ladda-label">数据归档</span></button>
        <button id="removeButton" class="btn btn-primary btn-lg ladda-button" onclick="removeData(3)" data-style="expand-right"><span class="ladda-label">删除历史数据</span></button>
        <script type="text/javascript">
            $(function () {
                $("#uploadButton").click(function () {
                    $("#uploadButton").text("正在处理...");
                    Ladda.create(this).start();
                    $("#uploadFile").fileinput("upload");
                    setTimeout(calculateStatus, delay);
                });
                $("#mergeButton").click(function () {
                    $(this).text("正在处理...");
                    Ladda.create(this).start();
                    
                    var selectDate = $("#date input").val();
                    var selectYear = selectDate.substring(0, 4);
                    var selectMonth = selectDate.substring(5, 7);
                    var selectDay = selectDate.substring(8, 10);
                    var url = "${pageContext.request.contextPath}/api/upload/merge/" + selectYear + "/" + selectMonth + "/" + selectDay;

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
                                    message: "数据归档成功"
                                });
                            } else {
                                BootstrapDialog.show({
                                    size: BootstrapDialog.SIZE_SMALL,
                                    type: BootstrapDialog.TYPE_WARNING,
                                    title: "警告",
                                    message: mes.message
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
                        },
                        complete: function (url, options) {
                            Ladda.stopAll();
                            $("#mergeButton").text("数据归档");
                        }
                    });
					setTimeout(calculateStatus, delay);
                });
            });

            function removeData(number) {
                $("#removeButton").text("正在处理...");
                Ladda.create($("#removeButton")[0]).start();
				
                var selectDate = $("#date input").val();
                var selectYear = selectDate.substring(0, 4);
                var selectMonth = selectDate.substring(5, 7);
                var selectDay = selectDate.substring(8, 10);
                var url = "${pageContext.request.contextPath}/api/calculate/excuse/删除/" + selectYear + "/" + selectMonth;
                if (number >= 3) {
                    url = "${pageContext.request.contextPath}/api/calculate/excuse/删除/" + selectYear + "/" + selectMonth + "/" + selectDay;
                }

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
                                message: "删除历史数据成功"
                            });
                        } else {
                            BootstrapDialog.show({
                                size: BootstrapDialog.SIZE_SMALL,
                                type: BootstrapDialog.TYPE_WARNING,
                                title: "警告",
                                message: mes.message
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
                    },
                    complete: function (url, options) {
                        Ladda.stopAll();
                        $("#removeButton").text("删除历史数据");
                    }
                });
				setTimeout(calculateStatus, delay);
            }
        </script>
    </div>
</div>
<br/>
<div class="container body-content">
    <div class="row">
        <div class="col-xs-8">
            <input id="uploadFile" name="uploadFile" type="file" multiple class="file-loading">
        </div>
        <div class="col-xs-4">
            <textarea id="resultDisplay" disabled="disabled" class="form-control" style="resize: none;"></textarea>
            <script type="text/javascript">
                $(function () {
                    resize();
                });
                $(window).resize(function () {
                    resize();
                });
            </script>
        </div>
    </div>
    <script>
        $(function () {
            $("#uploadFile").fileinput({
                language: "zh",
                uploadUrl: "${pageContext.request.contextPath}/api/upload/import",
                uploadAsync: false,
                previewFileIcon: "<i class='fa fa-file'></i>",
                enctype: "multipart/form-data",
                allowedPreviewTypes: null,
                previewFileIconSettings: {
                    "dbf": '<i class="fa fa-database text-warning"></i>',
                    "xls": '<i class="fa fa-file-excel-o text-success"></i>'
                },
                previewFileExtSettings: {
                    "dbf": function (ext) {
                        return ext.match(/(dbf)$/i);
                    },
                    "xls": function (ext) {
                        return ext.match(/(xls|xlsx)$/i);
                    }
                },
                allowedFileExtensions: ["xls", "dbf"],
                showUploadedThumbs: false
            });
            $("#uploadFile").on("fileselect", function (event, numFiles, label) {
                $("#uploadButton").removeAttr("disabled");
            });

            $("#uploadFile").on("filecleared", function (event) {
                $("#uploadButton").attr("disabled", "disabled");
            });

            $("#uploadFile").on("filepreupload", function (event, previewId, index) {
                Ladda.create($("#uploadButton")[0]).start();
                $("#uploadButton").text("正在处理...");
                setTimeout(calculateStatus, delay);
            });

            $("#uploadFile").on("fileuploaded", function (event, data, previewId, index) {
                Ladda.stopAll();
                $("#uploadButton").text("上传");
            });

            $("#uploadFile").on("filebatchpreupload", function (event, data, previewId, index) {
                Ladda.create($("#uploadButton")[0]).start();
                $(this).text("正在处理...");
                setTimeout(calculateStatus, delay);
            });

            $("#uploadFile").on("filebatchuploadsuccess", function (event, data, previewId, index) {
                Ladda.stopAll();
                $("#uploadButton").text("上传");
            });
        });
    </script>
</div>
<%@include file="/template/footer.jspf" %>
<script type="text/javascript">
    var delay = 300;
    function calculateStatus() {
        $.ajax({
            url: "${pageContext.request.contextPath}/api/calculate/display",
            cache: false,
            async: false,
            type: "POST",
            contentType: "application/json",
            dataType: "json",
            timeout: 100,
            success: function (data) {
                if (!data.finish) {
                    if (data.message != null) {
                        for (var i = 0; i < data.message.length; i++) {
                            $("#resultDisplay").append(data.message[i] + "\r\n");
                            $("#resultDisplay").scrollTop($("#resultDisplay")[0].scrollHeight);
                        }
                    }
                    setTimeout(calculateStatus, delay);
                }
            },
            error: function (jqXHR, textStatus, errorThrown) {
                setTimeout(calculateStatus, delay);
            }
        });
    }
</script>
</body>
</html>
