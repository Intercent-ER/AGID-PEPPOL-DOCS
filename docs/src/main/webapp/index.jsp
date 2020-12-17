<%@page
    contentType="text/html"
    pageEncoding="UTF-8"
    %><!DOCTYPE html>
<html lang="en">
    <head>
        <title>Specifiche PEPPOL 3</title>
        <meta charset="utf-8"/>
        <meta http-equiv="X-UA-Compatible" content="IE=edge"/>
        <meta name="viewport" content="width=device-width, initial-scale=1"/>

        <link rel="stylesheet" href="css/bootstrap.css"/>
        <link rel="stylesheet" href="css/structure.css?v=1.1"/>
        <link rel="stylesheet" href="css/font-awesome.min.css?v=4.7.0"/>
        <link rel="stylesheet" href="css/agid-custom.css?v=1.4"/>

        <!--[if lt IE 9]>
        <script src="https://oss.maxcdn.com/html5shiv/3.7.3/html5shiv.min.js"></script>
        <script src="https://oss.maxcdn.com/respond/1.4.2/respond.min.js"></script>
        <![endif]-->
        <script src="js/jquery-1.12.4.min.js"></script>
        <script src="js/bootstrap.js"></script>
        <script>
            //<![CDATA[
            $(function () {
                const VER = "55";    // Math.random()*1000000
                var $body = $("body"), $main = $("#main"), $guide = $("#guide").hide(), $adoc = $("#adoc-viewer"), $loader = $("#loader");
                var defBis = "peppol-bis-3";

                $.bis = $.bis || {};
                $.bis.initBIS = function ($bis) {
                    var bisRef = $bis.attr("href");
                    $("#home-title").text($bis.text());
                    // Home Menu
                    $("#syntax-menu").load(bisRef + '/menu/syntax-menu.html?v=' + VER + ' .dropdown-menu > li');
                    $("#rule-menu").load(bisRef + '/menu/rule-menu.html?v=' + VER + ' .dropdown-menu > li');
                    $("#stylesheet-menu").load(bisRef + '/menu/stylesheet-menu.html?v=' + VER + ' .dropdown-menu > li');
                    $("#codelist-menu").load(bisRef + '/menu/codelist-menu.html?v=' + VER + ' .dropdown-menu > li');
                    // Home List
					$("#jumbo-list").load(bisRef + '/menu/jumbo-list.html?v=' + VER + ' .list-group > a');
                    $("#intro-list").load(bisRef + '/menu/intro-list.html?v=' + VER + ' .list-group > a');
                    $("#bis-list").load(bisRef + '/menu/bis-list.html?v=' + VER + ' .list-group > a');
                    $("#syntax-list").load(bisRef + '/menu/syntax-list.html?v=' + VER + ' .list-group > a');
                    $("#rule-list").load(bisRef + '/menu/rule-list.html?v=' + VER + ' .list-group > a');
                    $("#stylesheet-list").load(bisRef + '/menu/stylesheet-list.html?v=' + VER + ' .list-group > a');
                    $("#codelist-list").load(bisRef + '/menu/codelist-list.html?v=' + VER + ' .list-group > a');
                    $("#download-list").load(bisRef + '/menu/download-list.html?v=' + VER + ' .list-group > a');
                };

                $.bis.current = $("#peppol-bis a[href='" + defBis + "']");
                $.bis.initBIS($.bis.current);
                // Bottone di scelta PEPPOL BIS
                $('#peppol-bis a').click(function (e) {
                    e.preventDefault();

                    var $bis = $(this);
                    $.bis.current = $bis;

                    $("#peppol-bis > button:first").text($bis.text());
                    $body.removeClass("adoc-mode");
                    $adoc.hide();
                    $guide.hide();
                    $main.show();
                    $.bis.initBIS($bis);
                });

                $(document).on("click", "#intro-list a, #bis-list a", function (e) {
                    e.preventDefault();

                    var $a = $(this);
                    var doc = '<%=request.getContextPath()%>/' + $a.attr("href");
                    $main.hide();
                    if (doc !== $adoc.attr("src")) {
                        $guide.html($loader).show();
                        $adoc.contents().empty().scrollTop(0);
                        $adoc.attr("src", doc);
                    } else {
                        $guide.hide();
                        $adoc.scrollTop(0).show();
                    }
                }).on("click", "#intro-list a .asciidoc-pdf, #bis-list a .asciidoc-pdf", function (e) {
                    e.stopImmediatePropagation();
                    e.preventDefault();

                    var $a = $(this).parent("a");
                    var doc = '<%=request.getContextPath()%>/' + $a.attr("href") + "?format=pdf";
                    $main.hide();
                    $guide.html($loader).show();
                    $adoc.contents().empty().scrollTop(0);
                    $adoc.attr("src", "pdfjs/web/viewer.html?file=" + encodeURIComponent(doc));
                }).on("click", "#codelist-list a .download-xml", function (e) {
                    e.stopImmediatePropagation();
                    e.preventDefault();
                    var $a = $(this).parent("a");
                    var url = '<%=request.getContextPath()%>/' + $a.attr("href") + "?download=1";

                    var link = document.createElement('a');
                    document.body.appendChild(link);
                    link.href = url;
                    link.target = '_blank';
                    link.click(function () {
                        e.stopImmediatePropagation();
                        link.remove();
                    });
                }).on("click", "#syntax-menu a, #syntax-list a, #rule-menu a, #rule-list a, #codelist-menu a, #codelist-list a, #section-menu a", function (e) {
                    var $item = $(this), href = $item.attr("href") + "?v=" + VER;
                    $.bis.currentMenu = $item.closest(".dropdown-menu, .list-group").attr("id");
                    $.bis.currentTitle = $item.text();
                    $.bis.currentUrl = href;
                    if (!href.startsWith("#") && !href.startsWith("http") && !href.endsWith(".pdf") && !href.endsWith(".zip")) {
                        e.preventDefault();
                        $body.removeClass("adoc-mode");
                        $main.hide();
                        $guide.html($loader).show();
                        $guide.load("<%=request.getContextPath()%>/" + href + " #main > *", function (e) {
                            $loader.appendTo("#parking");
                            $("#context").text($.bis.currentTitle);
                            $("#path .active").text($.bis.currentTitle);
                        });
                    }
                }).on("click", "#bis-section", function (e) {
                    e.preventDefault();
                    var href = $(this).attr("href") + ".html?v=" + VER;
                    $body.removeClass("adoc-mode");
                    $main.hide();
                    $adoc.hide();
                    $guide.html($loader).show();
                    $guide.load($.bis.current.attr("href") + '/menu/' + href + " #main > *", function (e) {
                        $loader.appendTo("#parking");
                    });
                }).on("click", "#bis-item", function (e) {
                    e.preventDefault();
                    var href = $(this).attr("href") + "?v=" + VER;
                    $main.hide();
                    $guide.html($loader).show();
                    $guide.load("<%=request.getContextPath()%>/" + href + " #main > *", function (e) {
                        $loader.appendTo("#parking");
                        $("#context").text($.bis.currentTitle);
                        $("#path .active").text($.bis.currentTitle);
                    });
                }).on("click", "#peppol-bis > button:first, #bis-index", function (e) {
                    e.preventDefault();

                    $guide.hide();
                    $body.removeClass("adoc-mode");
                    $adoc.hide();
                    $main.show();
                    $.bis.initBIS($.bis.current);
                }).on("click", "#path li.subcontext a", function (e) {
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

                $adoc.load(function () {
                    $loader.appendTo("#parking");
                    $body.addClass("adoc-mode");
                    $adoc.contents().on("click", "a", function (e) {
                        var $item = $(this), href = $item.attr("href") + "?v=" + VER;
                        $.bis.currentTitle = $item.text();
                        $.bis.currentUrl = href;
                        if (!href.startsWith("#") && !href.startsWith("http") && !href.endsWith(".pdf") && !href.endsWith(".zip")) {
                            e.preventDefault();
                            $body.removeClass("adoc-mode");
                            $main.hide();
                            $guide.html($loader).show();
                            $guide.load("<%=request.getContextPath()%>/" + href + " #main > *", function (e) {
                                $loader.appendTo("#parking");
                                $("#context").text($.bis.currentTitle);
                                $("#path .active").text($.bis.currentTitle);
                            });
                        }
                    });
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
                // Istruzioni di navigazione
                if (window.history && window.history.pushState) {
                    history.pushState("history-locker", null, location.href);
                    history.back();
                    history.forward();
                    var popstateOnLoad = true;
                    $(window).on("popstate", function (e) {
                        if (popstateOnLoad || e.originalEvent.state !== "history-locker") {
                            popstateOnLoad = false;
                            return;
                        }
                        history.go(1);
                        $('#navigazione').modal('show');
                    });
                }
            });
            String.prototype.startsWith = function (t) {
                return t === this.substring(0, t.length);
            };
            String.prototype.endsWith = function (t) {
                return t === this.substring(this.length - t.length);
            };
            //]]>
        </script>
    </head>
    <body>

        <nav class="navbar navbar-default navbar-fixed-top navbar-agid">

            <div class="container">

                <div class="navbar-header">
                    <button type="button" class="navbar-toggle collapsed" data-toggle="collapse"
                            data-target="#bs-example-navbar-collapse-1" aria-expanded="false">
                        <span class="sr-only">Toggle navigation</span>
                        <span class="icon-bar"></span>
                        <span class="icon-bar"></span>
                        <span class="icon-bar"></span>
                    </button>
                    <a class="navbar-brand" href="<%=request.getContextPath()%>" style="margin-top: -15px;"><img src="images/agid-logo.png" style="margin:10px" alt="AGID"></a>
                </div>

                <div class="collapse navbar-collapse" id="bs-example-navbar-collapse-1">
                    <ul class="nav navbar-nav">
                        <li class="btn-group" id="peppol-bis">
                            <button type="button" class="btn btn-primary btn-agid" style="margin-top: 8px;">PEPPOL BIS 3 (altri processi)</button>
                            <button type="button" class="btn btn-primary dropdown-toggle btn-agid" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false" style="margin-top: 8px;">
                                <span class="caret"></span>
                                <span class="sr-only">Toggle Dropdown</span>
                            </button>
                            <ul class="dropdown-menu">
                                <li><a href="peppol-bis-invoice-3">PEPPOL BIS Fatturazione 3</a></li>
                                <li><a href="peppol-bis-3">PEPPOL BIS 3 (altri processi)</a></li>
                            </ul>
                        </li>

                        <li class="dropdown">
                            <a href="#" class="dropdown-toggle link-agid" data-toggle="dropdown" role="button" aria-haspopup="true" aria-expanded="false">Sintassi <span class="caret"></span></a>
                            <ul class="dropdown-menu" id="syntax-menu">
                            </ul>
                        </li>

                        <li class="dropdown">
                            <a href="#" class="dropdown-toggle link-agid" data-toggle="dropdown" role="button" aria-haspopup="true" aria-expanded="false">Regole <span class="caret"></span></a>
                            <ul class="dropdown-menu" id="rule-menu">
                            </ul>
                        </li>

                        <li class="dropdown">
                            <a href="#" class="dropdown-toggle link-agid" data-toggle="dropdown" role="button" aria-haspopup="true" aria-expanded="false">Codifiche <span class="caret"></span></a>
                            <ul class="dropdown-menu" id="codelist-menu" style="max-height: 610px; overflow-y: scroll;">
                            </ul>
                        </li>

                        <li class="dropdown dropdown-agid">
                            <a href="#" class="dropdown-toggle link-agid" data-toggle="dropdown" role="button" aria-haspopup="true" aria-expanded="false">Fogli di stile <span class="caret"></span></a>
                            <ul class="dropdown-menu" id="stylesheet-menu" style="max-height: 610px; overflow-y: scroll;">
                            </ul>
                        </li>
                    </ul>
                </div>
            </div>
        </nav>

        <div id="main" class="container">

            <div class="page-header">
                <h1>Indice : <span id="home-title"></span></h1>
            </div>

            <dl class="dl-horizontal">
                <dd>
                    <div class="list-group" id="jumbo-list">
                    </div>
                </dd>
			
			
                <dt>Note di Rilascio</dt>
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

                <dt>Fogli di stile</dt>
                <dd>
                    <div class="list-group" id="stylesheet-list">
                    </div>
                </dd>

                <dt>Downloads</dt>
                <dd>
                    <div class="list-group" id="download-list">
                    </div>
                </dd>

            </dl>

        </div>

        <div id="guide" class="container">

        </div>
        <iframe id="adoc-viewer" name="adocViewer" src="" style="display: none; width: 100%; height: 100%; border: none" allowfullscreen webkitallowfullscreen></iframe>
        <div id="parking" style="display: none;">
            <div id="loader"><i class="spinner fa fa-spinner fa-pulse fa-3x"></i></div>
        </div>
        <div class="modal fade" id="navigazione" tabindex="-1" role="dialog" aria-labelledby="myModalLabel">
          <div class="modal-dialog" role="document">
            <div class="modal-content">
              <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                <h4 class="modal-title" id="myModalLabel">Informazioni di Navigazione</h4>
              </div>
              <div class="modal-body">
                <p>Per navigare nella documentazione utilizzare ove disponibile:</p>
                <ul>
                    <li>Il percorso di navigazione all'inizio della pagina</li>
                    <li>Il menu in testata</li>
                    <li>L'indice del documento a sinistra</li>
                </ul>
              </div>
              <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
              </div>
            </div>
          </div>
        </div>
    </body>
</html>
