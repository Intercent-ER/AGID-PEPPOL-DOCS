<!DOCTYPE html>
<html lang="en">
    <head>
        <title>Specifiche PEPPOL 3.0</title>
        <meta charset="utf-8"/>
        <meta http-equiv="X-UA-Compatible" content="IE=edge"/>
        <meta name="viewport" content="width=device-width, initial-scale=1"/>

        <link rel="stylesheet" href="/css/bootstrap.css"/>
        <link rel="stylesheet" href="/css/structure.css?v=1.1"/>
        <link rel="stylesheet" href="/css/font-awesome.min.css?v=4.7.0"/>
        <!--link rel="stylesheet" href="/pdfjs/web/viewer.css"/>
        <!--link rel="resource" type="application/l10n" href="/pdfjs/web/locale/it/viewer.properties"/-->

        <!--[if lt IE 9]>
        <script src="https://oss.maxcdn.com/html5shiv/3.7.3/html5shiv.min.js"></script>
        <script src="https://oss.maxcdn.com/respond/1.4.2/respond.min.js"></script>
        <![endif]-->
        <script src="/js/jquery-1.12.4.min.js"></script>
        <script src="/js/bootstrap.js"></script>
        <!--script src="/pdfjs/build/pdf.js" defer></script>
        <script src="/pdfjs/web/embedded-pdf-viewer.js" defer></script-->
        <script>
            //<![CDATA[
            $(function () {
                var $html = $("html"), $body = $("body"), $main = $("#main"), $guide = $("#guide").hide(), $adoc = $("#adoc-viewer"), $loader = $("#loader");
                var defBis = "peppol-bis-invoice-3";

                $.bis = $.bis || {};
                $.bis.initBIS = function ($bis) {
                    var bisRef = $bis.attr("href");
                    $("#home-title").text($bis.text());
                    // Home Menu
                    $("#syntax-menu").load(bisRef + '/menu/syntax-menu.html .dropdown-menu > li');
                    $("#rule-menu").load(bisRef + '/menu/rule-menu.html .dropdown-menu > li');
                    $("#codelist-menu").load(bisRef + '/menu/codelist-menu.html .dropdown-menu > li');
                    // Home List
                    $("#intro-list").load(bisRef + '/menu/intro-list.html .list-group > a');
                    $("#bis-list").load(bisRef + '/menu/bis-list.html .list-group > a');
                    $("#syntax-list").load(bisRef + '/menu/syntax-list.html .list-group > a');
                    $("#rule-list").load(bisRef + '/menu/rule-list.html .list-group > a');
                    $("#codelist-list").load(bisRef + '/menu/codelist-list.html .list-group > a');
                };

                $.bis.current = $("#peppol-bis a[href='" + defBis + "']");
                $.bis.initBIS($.bis.current);

                $('#peppol-bis a').click(function (e) {
                    e.preventDefault();

                    var $bis = $(this);
                    $.bis.current = $bis;

                    $("#peppol-bis > button:first").text($bis.text());
                    $guide.hide();
                    $main.show();
                    $.bis.initBIS($bis);
                });

                $(document).on("click", "#intro-list a, #bis-list a", function (e) {
                    e.preventDefault();

                    var $a = $(this);
                    var doc = $a.attr("href");
                    $main.hide();
                    if (doc.indexOf("format=pdf") !== -1) {
                        $guide.html($loader).show();
                        $adoc.empty().attr("src", "/pdfjs/web/viewer.html?file=" + encodeURIComponent(doc));
                    } else if (doc !== $adoc.attr("src")) {
                        $guide.html($loader).show();
                        $adoc.empty().attr("src", doc);
                    } else {
                        $guide.hide();
                        $adoc.show();
                    }
                }).on("click", "#intro-list a .asciidoc-pdf, #bis-list a .asciidoc-pdf", function (e) {
                    e.stopImmediatePropagation();
                    e.preventDefault();

                    var $a = $(this).parent("a");
                    var doc = $a.attr("href") + "?format=pdf";
                    $main.hide();
                    $guide.html($loader).show();
                    $adoc.empty().attr("src", "/pdfjs/web/viewer.html?file=" + encodeURIComponent(doc));
                }).on("click", "#syntax-menu a, #syntax-list a, #rule-menu a, #rule-list a, #codelist-menu a, #codelist-list a, #section-menu a", function (e) {
                    e.preventDefault();
                    var $item = $(this), href = $item.attr("href");
                    $body.removeClass("adoc-mode");
                    $main.hide();
                    $guide.html($loader).show();
                    $.bis.currentMenu = $item.closest(".dropdown-menu, .list-group").attr("id");
                    $.bis.currentTitle = $item.text();
                    $.bis.currentUrl = href;
                    $guide.load(href + " #main > *", function (e) {
                        $loader.appendTo("#parking");
                        $("#context").text($.bis.currentTitle);
                        $("#path .active").text($.bis.currentTitle);
                    });
                }).on("click", "#bis-section", function (e) {
                    e.preventDefault();
                    var $section = $(this);
                    $body.removeClass("adoc-mode");
                    $main.hide();
                    $guide.html($loader).show();
                    $guide.load($.bis.current.attr("href") + '/menu/' + $section.attr("href") + ".html #main > *", function (e) {
                        $loader.appendTo("#parking");
                    });
                }).on("click", "#bis-item", function (e) {
                    e.preventDefault();
                    var $item = $(this), href = $item.attr("href");
                    $main.hide();
                    $guide.html($loader).show();
                    $guide.load(href + " #main > *", function (e) {
                        $loader.appendTo("#parking");
                        $("#context").text($.bis.currentTitle);
                        $("#path .active").text($.bis.currentTitle);
                    });
                }).on("click", "#peppol-bis > button:first, #bis-index", function (e) {
                    e.preventDefault();

                    $guide.hide();
                    $main.show();
                    $.bis.initBIS($.bis.current);
                });

                $adoc.load(function () {
                    $loader.appendTo("#parking");
                    $body.addClass("adoc-mode");
                });

                $(document).on("click", "#path li.subcontext a", function (e) {
                    e.preventDefault();
                    var ctx = $("#" + $(this).attr("href"));
                    changeSyntaxContext(ctx);
                }).on("click", "#syntax tr > td > a", function (e) {
                    e.preventDefault();
                    var ctx = $(this);
                    changeSyntaxContext(ctx, true);
                }).on("click", "#rules tr > td > a", function (e) {
                    e.preventDefault();
                    var ctx = $(this);
                    changeRulesContext(ctx);
                });

                function changeSyntaxContext(ctx, showRef) {
                    var $syntax = $("#syntax");
                    var branch = ctx.closest("tr");
                    var level = parseInt(branch.attr("data-level"));
                    if (!showRef)
                        $syntax.removeClass("show-references");
                    else
                        $syntax.addClass("show-references");
                    $("tr").show();
                    branch.nextAll("tr").filter(function () {
                        return parseInt($(this).data("level")) <= level;
                    }).first().hide().nextAll().hide();
                    branch.prevAll("tr").hide();

                    var parent = branch, pid;
                    $("#path").empty();
                    for (i = level; i >= 0; i--) {
                        if (i < level) {
                            parent = parent.prevAll("tr[data-level='" + i + "']").first();
                        }
                        pid = parent.attr("id");
                        $("#path").prepend('<li class="subcontext"><a href="' + pid + '">' + parent.find("> td > a").text() + '</a></li>');
                    }
                    // <li><a href="../../../">Home</a></li>
                    $("#path").prepend('<li><a href="#" id="bis-index">Indice</a></li><li><a id="bis-item" href="' + $.bis.currentUrl + '">' + $.bis.currentTitle + '</a></li>');
                    var activeNode = $("#path").find("li").last();
                    activeNode.html(activeNode.find("a").text()).addClass("active");
                    $("#context").text(activeNode.text());
                }

                function changeRulesContext(ctx) {
                    var branch = ctx.closest("tr"), activeContext = branch.find("> td > a").text();

                    $("#path").html('<li><a id="bis-index" href="#">Indice</a></li><li><a id="bis-section" href="rule-home">Regole</a></li><li><a id="bis-item" href="' + $.bis.currentUrl + '">' + $.bis.currentTitle + '</a></li><li class="active">' + activeContext + '</li>');
                    $("#context").text(activeContext);
                    $("#rules").hide();
                    $("#rule").find(".message").text(branch.find(".message").text()).end()
                            .find(".context").text(branch.data("context")).end()
                            .find(".test").text(branch.data("test")).end().show();
                }
            });
            //]]>
        </script>
    </head>
    <body>

        <nav class="navbar navbar-default navbar-fixed-top">

            <div class="container">

                <div class="navbar-header">
                    <button type="button" class="navbar-toggle collapsed" data-toggle="collapse"
                            data-target="#bs-example-navbar-collapse-1" aria-expanded="false">
                        <span class="sr-only">Toggle navigation</span>
                        <span class="icon-bar"></span>
                        <span class="icon-bar"></span>
                        <span class="icon-bar"></span>
                    </button>
                    <!--a class="navbar-brand" href="#">Specifiche PEPPOL 3.0</a-->
                    <!--a class="navbar-brand" href="#">AGID</a-->
                    <a class="navbar-brand" href="#" style="margin-top: -15px;"><img src="/images/credits.png" height="50" alt="AGID"></a>
                </div>

                <div class="collapse navbar-collapse" id="bs-example-navbar-collapse-1">
                    <ul class="nav navbar-nav">
                        <li class="btn-group" id="peppol-bis">
                            <button type="button" class="btn btn-primary" style="margin-top: 8px;">PEPPOL BIS Fatturazione 3.0</button>
                            <button type="button" class="btn btn-primary dropdown-toggle" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false" style="margin-top: 8px;">
                                <span class="caret"></span>
                                <span class="sr-only">Toggle Dropdown</span>
                            </button>
                            <ul class="dropdown-menu">
                                <li><a href="peppol-bis-invoice-3">PEPPOL BIS Fatturazione 3.0</a></li>
                                <li><a href="peppol-bis-3">PEPPOL BIS 3.0</a></li>
                            </ul>
                        </li>

                        <li class="dropdown">
                            <a href="#" class="dropdown-toggle" data-toggle="dropdown" role="button" aria-haspopup="true" aria-expanded="false">Sintassi <span class="caret"></span></a>
                            <ul class="dropdown-menu" id="syntax-menu">
                            </ul>
                        </li>

                        <li class="dropdown">
                            <a href="#" class="dropdown-toggle" data-toggle="dropdown" role="button" aria-haspopup="true" aria-expanded="false">Regole <span class="caret"></span></a>
                            <ul class="dropdown-menu" id="rule-menu">

                                <!--li><a href="./rules/T01/PEPPOL Order transaction 3.0_Rules.htm">Regole di business per Ordine Semplice PEPPOL 3.0 </a></li>
                                <li><a href="./rules/T76/Order Response transaction 3.0_Rules.htm">Regole di business per Risposta all'Ordine PEPPOL 3.0</a></li>
                                <li><a href="#" style="color:#c60000;">Regole di business per Ordine Pre-Concordato PEPPOL 3.0</a></li>
                                <li><a href="#" style="color:#c60000;">Regole base per Ordine Pre-Concordato PEPPOL 3.0</a></li-->

                            </ul>
                        </li>

                        <li class="dropdown">
                            <a href="#" class="dropdown-toggle" data-toggle="dropdown" role="button" aria-haspopup="true" aria-expanded="false">Codifiche <span class="caret"></span></a>
                            <ul class="dropdown-menu" id="codelist-menu">
                            </ul>
                        </li>
                    </ul>
                </div>
            </div>
        </nav>

        <div id="main" class="container">

            <div class="page-header">
                <h1>Indice :: <span id="home-title"></span></h1>
            </div>

            <dl class="dl-horizontal">

                <dt>Introduzione</dt>
                <dd>
                    <div class="list-group" id="intro-list">
                    </div>
                </dd>

                <dt>Documentazione</dt>
                <dd>
                    <div class="list-group" id="bis-list">
                    </div>
                </dd>

                <dt>Sintassi</dt>
                <dd>
                    <div class="list-group" id="syntax-list">
                    </div>
                </dd>

                <dt>Regole</dt>
                <dd>
                    <div class="list-group" id="rule-list">
                    </div>
                </dd>

                <dt>Codifiche</dt>
                <dd>
                    <div class="list-group" id="codelist-list">
                    </div>
                </dd>

                <dt>Downloads</dt>
                <dd>
                    <div class="list-group" id="download-list">

                        <a href="./attachments/Intercent-ER-Esempi-Xml-Peppol-3.zip" class="list-group-item">
                            <h4 class="list-group-item-heading">File di esempio</h4>
                        </a>
                        <a href="./attachments/Schematron.zip" class="list-group-item">
                            <h4 class="list-group-item-heading">File schematron</h4>
                        </a>
                        <a href="./attachments/Tool_Validazione_PEPPOL_BIS_3.0_NSO-Test_v1.3.1.zip" class="list-group-item">
                            <h4 class="list-group-item-heading">Tool di validazione</h4>
                        </a>

                    </div>
                </dd>

            </dl>

        </div>

        <div id="guide" class="container">

        </div>
        <iframe id="adoc-viewer" name="adocViewer" src="" style="display: none; width: 100%; height: 100%; border: none" allowfullscreen webkitallowfullscreen></iframe>
        <%--jsp:include page="/pdfjs/web/embedded-pdf-viewer.jsp" flush="true"></jsp:include--%>
        <div id="parking" style="display: none;">
            <div id="loader"><i class="spinner fa fa-spinner fa-pulse fa-3x"></i></div>
        </div>

    </body>
</html>