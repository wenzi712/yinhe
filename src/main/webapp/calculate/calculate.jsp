<%@ page contentType="text/html" pageEncoding="UTF-8" %>
<%@taglib prefix="shiro" uri="http://shiro.apache.org/tags" %>
<!DOCTYPE html>
<html>
<head>
    <jsp:include page="/template/head.jsp">
        <jsp:param name="pageTitle" value="月度考核计算"></jsp:param>
    </jsp:include>
    <%@include file="/template/include/bootstrap-datepicker.jspf" %>
    <%@include file="/template/include/ladda.jspf" %>
    <script type="text/javascript">
        var high = $(this).height() - 224;
        if (high < 128) {
            high = 128;
        }
    </script>
</head>
<body>
<div class="container body-content">
    <div id="alert" class="alert alert-success alert-dismissable" style="display: none;">
        <button type="button" class="close" aria-hidden="true" onclick="$('#alert').hide()">&times;</button>
        <div id="message"></div>
    </div>
</div>
<div class="container body-content">
    <div class="row">
        <div class="col-xs-3">
            <div id="date" class="input-group date">
                <input type="text" class="form-control input-lg" readonly/>
                <span class="input-group-addon"><span class="glyphicon glyphicon-calendar"></span></span>
            </div>
        </div>
        <script type="text/javascript">
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
        </script>
        <button id="calculateButton" class="btn btn-primary btn-lg ladda-button" data-style="expand-right"><span class="ladda-label">月度考核计算</span></button>
        <script type="text/javascript">
            $(function () {
                $("#calculateButton").click(function () {
                    $("#alert").hide();
                    $(this).text("正在处理...");
                    $("#alert").attr("class", "alert alert-info alert-dismissable");
                    $("#message").text("正在处理...请勿刷新或者关闭浏览器!");
                    $("#alert").show();
                    Ladda.create(this).start();

                    var selectDate = $("#date input").val();
                    var selectYear = selectDate.substring(0, 4);
                    var selectMonth = selectDate.substring(5, 7);

                    var url = "${pageContext.request.contextPath}/api/calculate/excuse/月度考核/" + selectYear + "/" + selectMonth;

                    $.ajax({
                        type: "POST",
                        contentType: "application/json",
                        url: url,
                        dataType: "json",
                        success: function (msg) {
                            if (msg.success) {
                                $("#alert").attr("class", "alert alert-success alert-dismissable");
                                $("#message").text("计算完成!");
                                $("#alert").show();
                            }
                            else {
                                $("#alert").attr("class", "alert alert-danger alert-dismissable");
                                $("#message").text(msg.message);
                                $("#alert").show();
                            }
                        },
                        error: function (jqXHR, textStatus, errorThrown) {
                            $("#alert").attr("class", "alert alert-danger alert-dismissable");
                            $("#message").text("错误:" + errorThrown);
                            $("#alert").show();
                        },
                        complete: function (url, options) {
                            Ladda.stopAll();
                            $("#calculateButton").text("月度考核计算");
                        }
                    });
                    setTimeout(calculateStatus, delay);
                });
            });
        </script>
        <button id="orderButton" class="btn btn-primary btn-lg ladda-button" data-style="expand-right"><span class="ladda-label">排序</span></button>
        <script type="text/javascript">
            $(function () {
                $("#orderButton").click(function () {
                    $("#alert").hide();
                    $(this).text("正在处理...");
                    $("#alert").attr("class", "alert alert-info alert-dismissable");
                    $("#message").text("正在处理...请勿刷新或者关闭浏览器!");
                    $("#alert").show();
                    Ladda.create(this).start();

                    var selectDate = $("#date input").val();
                    var selectYear = selectDate.substring(0, 4);
                    var selectMonth = selectDate.substring(5, 7);

                    var url = "${pageContext.request.contextPath}/api/calculate/excuse/排序/" + selectYear + "/" + selectMonth;

                    $.ajax({
                        type: "POST",
                        contentType: "application/json",
                        url: url,
                        dataType: "json",
                        success: function (msg) {
                            if (msg.success) {
                                $("#alert").attr("class", "alert alert-success alert-dismissable");
                                $("#message").text("计算完成!");
                                $("#alert").show();
                            }
                            else {
                                $("#alert").attr("class", "alert alert-danger alert-dismissable");
                                $("#message").text(msg.message);
                                $("#alert").show();
                            }
                        },
                        error: function (jqXHR, textStatus, errorThrown) {
                            $("#alert").attr("class", "alert alert-danger alert-dismissable");
                            $("#message").text("错误:" + errorThrown);
                            $("#alert").show();
                        },
                        complete: function (url, options) {
                            Ladda.stopAll();
                            $("#orderButton").text("排序");
                        }
                    });
                    setTimeout(calculateStatus, delay);
                });
            });
        </script>
        <button id="baseButton" class="btn btn-primary btn-lg ladda-button" data-style="expand-right"><span class="ladda-label">基期计算</span></button>
        &nbsp;&nbsp;&nbsp;&nbsp;
        <script type="text/javascript">
            $(function () {
                $("#baseButton").click(function () {
                    $("#alert").hide();
                    $(this).text("正在处理...");
                    $("#alert").attr("class", "alert alert-info alert-dismissable");
                    $("#message").text("正在处理...请勿刷新或者关闭浏览器!");
                    $("#alert").show();
                    Ladda.create(this).start();
                    var selectDate = $("#date input").val();
                    var selectYear = selectDate.substring(0, 4);
                    var selectMonth = selectDate.substring(5, 7);

                    var url = "${pageContext.request.contextPath}/api/calculate/excuse/基期/" + selectYear + "/" + selectMonth;

                    $.ajax({
                        type: "POST",
                        contentType: "application/json",
                        url: url,
                        dataType: "json",
                        success: function (msg) {
                            if (msg.success) {
                                $("#alert").attr("class", "alert alert-success alert-dismissable");
                                $("#message").text("计算完成!");
                                $("#alert").show();
                            }
                            else {
                                $("#alert").attr("class", "alert alert-danger alert-dismissable");
                                $("#message").text(msg.message);
                                $("#alert").show();
                            }
                        },
                        error: function (jqXHR, textStatus, errorThrown) {
                            $("#alert").attr("class", "alert alert-danger alert-dismissable");
                            $("#message").text(errorThrown);
                            $("#alert").show();
                            calculateStatus();
                        },
                        complete: function (url, options) {
                            ladda.stop();
                            $("#baseButton").text("基期计算");
                        }
                    });
                    setTimeout(calculateStatus, delay);
                });
            });
        </script>
        <button id="saveButton" class="btn btn-primary btn-lg ladda-button" data-style="expand-right"><span class="ladda-label">月度考核存档</span></button>
        <script type="text/javascript">
            $(function () {
                $("#saveButton").click(function () {
                    Ladda.create(this).start();
                    $("#alert").hide();
                    $(this).text("正在处理...");
                    $("#alert").attr("class", "alert alert-info alert-dismissable");
                    $("#message").text("正在处理...请勿刷新或者关闭浏览器!");
                    $("#alert").show();

                    var selectDate = $("#date input").val();
                    var selectYear = selectDate.substring(0, 4);
                    var selectMonth = selectDate.substring(5, 7);

                    $.ajax({
                        type: "POST",
                        contentType: "application/json",
                        url: "${pageContext.request.contextPath}/api/calculate/save/" + selectYear + "/" + selectMonth,
                        dataType: "json",
                        success: function (msg) {
                            if (msg.success) {
                                $("#alert").attr("class", "alert alert-success alert-dismissable");
                                $("#message").text("存档完成!");
                                $("#alert").show();
                            }
                            else {
                                $("#alert").attr("class", "alert alert-danger alert-dismissable");
                                $("#message").text("存档错误");
                                $("#alert").show();
                            }
                        },
                        error: function (jqXHR, textStatus, errorThrown) {
                            $("#alert").attr("class", "alert alert-danger alert-dismissable");
                            $("#message").text(errorThrown);
                            $("#alert").show();
                        },
                        complete: function (url, options) {
                            Ladda.stopAll();
                            $("#saveButton").text("月度考核存档");
                        }
                    });
                });
            });
        </script>
        <button id="initialButton" class="btn btn-primary btn-lg ladda-button" data-style="expand-right"><span class="ladda-label">参数初始化</span></button>
        <script type="text/javascript">
            $(function () {
                $("#initialButton").click(function () {
                    $("#alert").hide();
                    $(this).text("正在处理...");
                    $("#alert").attr("class", "alert alert-info alert-dismissable");
                    $("#message").text("正在初始化......请勿刷新或者关闭浏览器!");
                    $("#alert").show();
                    Ladda.create(this).start();
                    var selectDate = $("#date input").val();

                    $.ajax({
                        type: "POST",
                        contentType: "application/json",
                        url: "${pageContext.request.contextPath}/api/calculate/initial",
                        dataType: "json",
                        success: function (msg) {
                            if (msg.success) {
                                $("#alert").attr("class", "alert alert-success alert-dismissable");
                                $("#message").text("初始化参数完成!");
                                $("#alert").show();
                            }
                            else {
                                $("#alert").attr("class", "alert alert-danger alert-dismissable");
                                $("#message").text("初始化参数错误");
                                $("#alert").show();
                            }
                        },
                        error: function (jqXHR, textStatus, errorThrown) {
                            $("#alert").attr("class", "alert alert-danger alert-dismissable");
                            $("#message").text(errorThrown);
                            $("#alert").show();
                        },
                        complete: function (url, options) {
                            Ladda.stopAll();
                            $("#initialButton").text("参数初始化");
                        }
                    });
                });
            });
        </script>
        <button id="changeButton" class="btn btn-primary btn-lg ladda-button" data-style="expand-right"><span class="ladda-label">选择考核月份</span></button>
        <script type="text/javascript">
            $(function () {
                $("#changeButton").click(function () {
                    Ladda.create(this).start();
                    $("#alert").hide();
                    $(this).text("正在处理...");
                    $("#alert").attr("class", "alert alert-info alert-dismissable");
                    $("#message").text("正在处理...请勿刷新或者关闭浏览器!");
                    $("#alert").show();

                    var selectDate = $("#date input").val();
                    var selectYear = selectDate.substring(0, 4);
                    var selectMonth = selectDate.substring(5, 7);

                    $.ajax({
                        type: "POST",
                        contentType: "application/json",
                        url: "${pageContext.request.contextPath}/api/calculate/excuse/选择/" + selectYear + "/" + selectMonth,
                        dataType: "json",
                        success: function (msg) {
                            if (msg.success) {
                                $("#alert").attr("class", "alert alert-success alert-dismissable");
                                $("#message").text("选择考核月份完成!");
                                $("#alert").show();
                            }
                            else {
                                $("#alert").attr("class", "alert alert-danger alert-dismissable");
                                $("#message").text("错误");
                                $("#alert").show();
                            }
                        },
                        error: function (jqXHR, textStatus, errorThrown) {
                            $("#alert").attr("class", "alert alert-danger alert-dismissable");
                            $("#message").text(errorThrown);
                            $("#alert").show();
                        },
                        complete: function (url, options) {
                            Ladda.stopAll();
                            $("#saveButton").text("选择考核月份");
                        }
                    });
                    setTimeout(calculateStatus, delay);
                });
            });
        </script>
    </div>
</div>
<br/>
<div class="container body-content">
    <textarea id="resultDisplay" disabled="disabled" class="form-control" style="resize: none;"></textarea>
    <script type="text/javascript">
        $(function () {
            $("#resultDisplay").height(high);
        });
        $(window).resize(function () {
            var high = $(this).height() - 320;
            if (high <= 64) {
                high = 64;
            }
            $("#resultDisplay").height(high);
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
            success: function (data) {
                if (!data.finish) {
                    if (data.message != null) {
                        for (var i = 0; i < data.message.length; i++) {
                            $("#resultDisplay").append(data.message[i] + "\r");
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
