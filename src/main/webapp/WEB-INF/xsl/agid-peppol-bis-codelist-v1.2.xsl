<xsl:stylesheet version="2.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:cl="urn:fdc:difi.no:2017:vefa:structure:CodeList-1"
                exclude-result-prefixes="cl">
    <!--
            Author: JAVEST by Roberto Cisternino
            Version 1.1
    -->
    <xsl:output method="html"
                doctype-system="about:legacy-compat"
                encoding="UTF-8"
                indent="yes" />
    <xs:import namespace="urn:fdc:difi.no:2017:vefa:structure-1" schemaLocation="../../xsd/structure-1.xsd"/>
    <xsl:variable name="codelist" select="/cl:CodeList/cl:Title/text()"/>

    <xsl:template match="/cl:CodeList">
        <html data-codelist="{$codelist}">
            <head>
                <title>PEPPOL BIS Billing 3.0 | Codifiche</title>
                <meta charset="utf-8"/>
                <meta http-equiv="X-UA-Compatible" content="IE=edge"/>
                <meta name="viewport" content="width=device-width, initial-scale=1"/>

                <link rel="stylesheet" href="css/bootstrap.css"/>
                <link rel="stylesheet" href="css/structure.css"/>
                <link rel="stylesheet" href="https://use.fontawesome.com/releases/v5.7.2/css/all.css" integrity="sha384-fnmOCqbTlWIlj8LyTjo7mOUStjsKC4pOpQbqyi7RrhN7udi9RwhKkMHpvLbHG9Sr" crossorigin="anonymous"/>
                <link rel="stylesheet" href="css/agid-custom.css?v=1.3"/>

                <!--[if lt IE 9]>
                        <script src="https://oss.maxcdn.com/html5shiv/3.7.3/html5shiv.min.js"></script>
                        <script src="https://oss.maxcdn.com/respond/1.4.2/respond.min.js"></script>
                <![endif]-->
                <script src="js/jquery.js"/>
                <script src="js/bootstrap.js"/>
                <script type="text/javascript">
                    //<![CDATA[
                    //debugger;//@ sourceURL=agid.js
                            $(function () {
                                    var $html = $("html");
                                    var $cl = $("#codelist");
                                    var source = window.location.href.split('?')[0];
                                    var codelist = $html.data("codelist");

                                    $("#path").on("click", "li.subcontext a", function(e) {
                                            e.preventDefault();
                                            var ctx = $("#" + $(this).attr("href"));
                                            changeContext(ctx);
                                    });

                                    $cl.find("tr > td > a").click(function(e) {
                                            e.preventDefault();
                                            var ctx = $(this);
                                            changeContext(ctx, true);
                                    });

                                    function changeContext(ctx, showRef) {
                                            var branch = ctx.closest("tr");
                                            var level = parseInt(branch.attr("data-level"));
                                            if (!showRef)
                                                    $cl.removeClass("show-references");
                                            else
                                                    $cl.addClass("show-references");
                                            $("tr").show();
                                            branch.nextAll("tr").filter(function() {
                                                    return parseInt($(this).data("level")) <= level;
                                            }).first().hide().nextAll().hide();
                                            branch.prevAll("tr").hide();

                                            var parent = branch, pid;
                                            $("#path").empty();
                                            for (i = level; i >= 0; i--) {
                                                    if (i < level) {
                                                            parent = parent.prevAll("tr[data-level='"+i+"']").first();
                                                    }
                                                    pid = parent.attr("id");
                                                    $("#path").prepend('<li class="subcontext"><a href="'+pid+'">'+parent.find("> td > a").text()+'</a></li>');
                                            }
                                            // <li><a href="../../../">Home</a></li>
                                            $("#path").prepend('<li><a href="'+source+'">'+codelist+'</a></li>');
                                            var activeNode = $("#path").find("li").last();
                                            activeNode.html(activeNode.find("a").text()).addClass("active");
                                            $("#context").text(activeNode.text());
                                    }
                            });
                    //]]>
                </script>
            </head>
            <body>
                <div id="main" class="container">

                    <ol id="path" class="breadcrumb">
                        <li>
                            <a href="#" id="bis-index">Indice</a>
                        </li>
                        <li>
                            <a href="codelist-home" id="bis-section">Codifiche</a>
                        </li>
                        <li class="active">
                            <xsl:value-of select="$codelist"/>
                        </li>
                    </ol>

                    <div class="page-header">
                        <h1 id="context">
                            <xsl:value-of select="$codelist"/>
                        </h1>
                    </div>

                    <div class="page-header" style="margin-top:0;padding-top:10px">
                        <img style="width: 255px; height: 68px;margin-left:5%;" alt="AGID" src="images/logo_AgID.jpg"/>
                        <img style="width: 225px; height: 103px;margin-left:40%;" alt="Intercent-ER" src="images/logo_INTERCENT-ER.jpg"/>
                    </div>																	

                    <dl class="dl-horizontal">
                        <dt>Identificatore</dt>
                        <dd><xsl:value-of select="cl:Identifier"/></dd>
                        <dt>Agenzia</dt>
                        <dd><xsl:value-of select="cl:Agency"/></dd>
                        <dt>Versione</dt>
                        <dd><xsl:value-of select="cl:Version"/></dd>
                        <dt>Utilizzo</dt>
                        <dd></dd>
                        <dt>Codifica</dt>
                        <dd id="codelist">
                            <xsl:apply-templates select="//cl:Code"/>
                        </dd>
                    </dl>
                </div>
            </body>
        </html>
    </xsl:template>

    <xsl:template match="cl:Code" priority="1">
        <div id="{cl:Id}" style="margin-bottom: 5pt;">
            <code>
                <xsl:value-of select="cl:Id"/>
            </code>
            <br/>
            <strong>
                <xsl:value-of select="cl:Name"/>
            </strong>
            <br/>
            <p>
                <xsl:value-of select="cl:Description"/>
            </p>
            <xsl:if test="cl:LocalId">
            <code class="locale indent">
                Correlato a [<xsl:value-of select="cl:LocalId"/>]
            </code>
            </xsl:if>
            <xsl:if test="cl:LocalName">
            <strong class="locale indent">
                <xsl:value-of select="cl:LocalName"/>
            </strong>
            </xsl:if>
            <xsl:if test="cl:LocalDescription">
            <p class="locale indent">
                <xsl:value-of select="cl:LocalDescription"/>
            </p>
            </xsl:if>
            <xsl:if test="cl:LocalUsageNotes">
            <p class="locale indent">
                <i>
                    <xsl:value-of select="cl:LocalUsageNotes"/>
                </i>
            </p>
            </xsl:if>
        </div>
    </xsl:template>

</xsl:stylesheet>