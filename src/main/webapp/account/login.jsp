<%@ page contentType="text/html" pageEncoding="UTF-8" %>
<%@taglib prefix="shiro" uri="http://shiro.apache.org/tags" %>
<%@taglib prefix="core" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <jsp:include page="/template/head.jsp">
        <jsp:param name="pageTitle" value="登陆"></jsp:param>
    </jsp:include>
    <%@include file="/template/include/ladda.jspf" %>
    <%@include file="/template/include/form.jspf" %>
    <%@include file="/template/include/bootstrap-dialog.jspf" %>
    <%@include file="/template/include/font-awesome.jspf" %>
    <%@include file="/template/include/jsencrypt.jspf" %>
    <link href="login.css" rel="stylesheet" type="text/css"/>
    <script type="text/javascript">
        var goBakURL = $.url().param("url");
        if (!goBakURL) {
            goBakURL = RootURL;
        }
        if ($.url().param("KickedOut")) {
            BootstrapDialog.show({
                size: BootstrapDialog.SIZE_SMALL,
                type: BootstrapDialog.TYPE_DANGER,
                title: "错误",
                message: "您已从其他地方登陆!"
            });
        }
        if ($.url().param("RequireLogin")) {
            BootstrapDialog.show({
                size: BootstrapDialog.SIZE_SMALL,
                type: BootstrapDialog.TYPE_INFO,
                title: "提示",
                message: "权限不够"
            });
        }
    </script>
    <style type="text/css">
        #particles-js {
            position: absolute;
            top: 0;
            width: 100%;
            height: 95%;
        }

        .container {
            position: relative;
            z-index: 10;
        }

        .body-content {
            position: relative;
            z-index: 50;
        }

        .row {
            position: relative;
            z-index: 10;
        }
    </style>
</head>
<body>
<div class="container">
    <div class="row">
        <div class="col-sx-6">
            <div>
                <img class="profile-img" src="${pageContext.request.contextPath}/img/banner.png" alt="中国银河证券">
                <form id="loginForm" role="form" class="form-signin">
                    <input id="LoginID" type="text" class="form-control" placeholder="用户名" required autofocus>
                    <shiro:user>
                        <script type="text/javascript">
                            $("#LoginID").val("<shiro:principal property="loginID"/>");
                        </script>
                    </shiro:user>
                    <input id="Password" type="password" minlength="6" maxlength="16" class="form-control" placeholder="密码" required>
                    <button type="submit" class="btn btn-lg btn-primary btn-block ladda-button" data-style="expand-left"><span class="ladda-label">登陆</span></button>
                    <div class="pull-left checkbox">
                        <input type="checkbox" id="remember-me" class="styled">
                        <label for="remember-me">记住我</label>
                    </div>
                    <a href="javascript:void(0)" onclick="BootstrapDialog.show({size: BootstrapDialog.SIZE_SMALL,type: BootstrapDialog.TYPE_INFO,title: '提示',message: '请联系管理员!'});" class="pull-right need-help">忘记密码</a><span class="clearfix"></span>
                </form>
            </div>
        </div>
    </div>
</div>
<div id="particles-js"></div>
<script src="${pageContext.request.contextPath}/js/particles.min.js" type="text/javascript"></script>
<script type="text/javascript">
    particlesJS("particles-js", {
        particles: {
            number: {
                value: 20,
                density: {
                    enable: true,
                    value_area: 1E3
                }
            },
            color: {
                value: "#e1e1e1"
            },
            shape: {
                type: "circle",
                stroke: {
                    width: 0,
                    color: "#000000"
                },
                polygon: {
                    nb_sides: 5
                }
            },
            opacity: {
                value: 0.5,
                random: false,
                anim: {
                    enable: false,
                    speed: 1,
                    opacity_min: 0.1,
                    sync: false
                }
            },
            size: {
                value: 15,
                random: true,
                anim: {
                    enable: false,
                    speed: 180,
                    size_min: 0.1,
                    sync: false
                }
            },
            line_linked: {
                enable: true,
                distance: 650,
                color: "#cfcfcf",
                opacity: 0.26,
                width: 1
            },
            move: {
                enable: true,
                speed: 2,
                direction: "none",
                random: true,
                straight: false,
                out_mode: "out",
                bounce: false,
                attract: {
                    enable: false,
                    rotateX: 600,
                    rotateY: 1200
                }
            }
        },
        interactivity: {
            detect_on: "canvas",
            events: {
                onhover: {
                    enable: false,
                    mode: "repulse"
                },
                onclick: {
                    enable: false,
                    mode: "push"
                },
                resize: true
            },
            modes: {
                grab: {
                    distance: 400,
                    line_linked: {
                        opacity: 1
                    }
                },
                bubble: {
                    distance: 400,
                    size: 40,
                    duration: 2,
                    opacity: 8,
                    speed: 3
                },
                repulse: {
                    distance: 200,
                    duration: .4
                },
                push: {
                    particles_nb: 4
                },
                remove: {
                    particles_nb: 2
                }
            }
        },
        retina_detect: true
    });
</script>
<script src="login.min.js" type="text/javascript"></script>
<%@include file="/template/footer.jspf" %>
</body>
</html>
