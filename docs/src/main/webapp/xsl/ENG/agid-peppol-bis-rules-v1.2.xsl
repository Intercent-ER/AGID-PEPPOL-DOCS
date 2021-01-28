<xsl:stylesheet version="2.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:sch="http://purl.oclc.org/dsdl/schematron"
                exclude-result-prefixes="sch xs">
    <!--
            Author: JAVEST by Roberto Cisternino
            Version 1.2
    -->   
    <xsl:output method="html"
                doctype-system="about:legacy-compat"
                encoding="UTF-8"
                indent="yes" />
    <xs:import namespace="http://purl.oclc.org/dsdl/schematron" schemaLocation="../../xsd/iso/schematron/iso-schematron.xsd"/>
    <xsl:variable name="rules" select="/sch:schema/sch:title"/>

    <xsl:template match="/sch:schema">
        <html data-rules="{$rules}">
            <head>
                <title>PEPPOL BIS Billing 3.0 | Regole</title>
                <meta charset="utf-8"/>
                <meta http-equiv="X-UA-Compatible" content="IE=edge"/>
                <meta name="viewport" content="width=device-width, initial-scale=1"/>

                <link rel="stylesheet" href="../../../../css/bootstrap.css"/>
                <link rel="stylesheet" href="../../../../css/structure.css"/>
                <link rel="stylesheet" href="https://use.fontawesome.com/releases/v5.7.2/css/all.css" integrity="sha384-fnmOCqbTlWIlj8LyTjo7mOUStjsKC4pOpQbqyi7RrhN7udi9RwhKkMHpvLbHG9Sr" crossorigin="anonymous"/>
                <link rel="stylesheet" href="../../../../css/agid-custom.css?v=1.3"/>

                <!--[if lt IE 9]>
                        <script src="https://oss.maxcdn.com/html5shiv/3.7.3/html5shiv.min.js"></script>
                        <script src="https://oss.maxcdn.com/respond/1.4.2/respond.min.js"></script>
                <![endif]-->
                <script src="../../../../js/jquery.js"/>
                <script src="../../../../js/bootstrap.js"/>
                <script type="text/javascript">
                    //<![CDATA[
                    debugger;//@ sourceURL=agid.js
                    $(function () {
                    var $html = $("html");

                    var source = window.location.href.split('?')[0];
                    var rules = $html.data("rules");

                    $("#rule").hide();
                    $("#rules").show();

                    $("#path").on("click", "li.subcontext a", function(e) {
                    e.preventDefault();
                    var ctx = $("#" + $(this).attr("href"));
                    changeContext(ctx);
                    });

                    $("#rules tr > td > a").click(function(e) {
                    e.preventDefault();
                    var ctx = $(this);
                    changeContext(ctx);
                    });

                    function changeContext(ctx) {
                    var branch = ctx.closest("tr"), activeContext = branch.find("> td > a").text();

                    $("#path").html('<li><a href="'+source+'">'+rules+'</a></li><li class="active">'+activeContext+'</li>');
                    // <li><a href="../../../">Home</a></li>
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
                <div id="main" class="container">

                    <ol id="path" class="breadcrumb">
                        <li>
                            <a href="../../../../my_index-ENG.jsp" id="bis-index">Indice</a>
                        </li>
                        <li class="active">
                            <xsl:value-of select="$rules"/>
                        </li>
                    </ol>

                    <div class="page-header">
                        <h1 id="context">
                            <xsl:value-of select="$rules"/>
                        </h1>
                    </div>

                    <div class="table-responsive">
                        <table class="table table-striped">
                            <thead>
                                <tr>
                                    <th>Identificatore / Messaggio</th>
                                    <th style="width: 5%">Severità</th>
                                </tr>
                            </thead>
                            <tbody id="rules">
                                <xsl:apply-templates select="sch:include | //sch:rule/sch:assert">
                                    <xsl:sort select="@id"/>
                                </xsl:apply-templates>
                            </tbody>
                        </table>
                    </div>

                    <dl id="rule" class="dl-horizontal" style="display:none">
                        <dt>Messaggio</dt>
                        <dd>
                            <p class="message lead"/>
                        </dd>

                        <dt>Contesto</dt>
                        <dd>
                            <code class="context"/>
                        </dd>

                        <dt>Test</dt>
                        <dd>
                            <code class="test"/>
                        </dd>
                    </dl>

                </div>
            </body>
        </html>
    </xsl:template>

    <xsl:template match="sch:assert" priority="1">
        <xsl:param name="ruleCtx" select="../@context"/>
        <xsl:variable name="ruleTest" select="@test"/>
        <xsl:variable name="ruleID" select="@id"/>
        <xsl:variable name="ruleFlag" select="@flag"/>
        <xsl:variable name="ruleText" select="text()"/>
        <tr id="{$ruleID}" data-context="{$ruleCtx}" data-test="{$ruleTest}">
            <td>
                <a href="#">
                    <xsl:value-of select="$ruleID"/>
                </a>
                <br/>
                <span class="message">
                    <xsl:value-of select="$ruleText"/>
                </span>
            </td>
            <td style="width: 5%;">
                <xsl:value-of select="$ruleFlag"/>
            </td>
        </tr>
    </xsl:template>

    <xsl:template match="sch:include" priority="1">
        <xsl:apply-templates select="document(@href)//sch:rule/sch:assert">
            <xsl:sort select="@id"/>
        </xsl:apply-templates>
    </xsl:template>

</xsl:stylesheet>					