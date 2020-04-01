<xsl:stylesheet version="2.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:stx="urn:fdc:difi.no:2017:vefa:structure-1"
                xmlns:cus="urn:fdc:agid.gov.it:peppol:customization"
                exclude-result-prefixes="stx cus">
    <!--
            Author: JAVEST by Roberto Cisternino
            Version 1.4
    -->
    <xsl:output method="html"
                    doctype-system="about:legacy-compat"
                    encoding="UTF-8"
                    indent="yes" />
    <xs:import namespace="urn:fdc:difi.no:2017:vefa:structure-1" schemaLocation="../../xsd/structure-1.xsd"/>
    <xs:import namespace="urn:fdc:agid.gov.it:peppol:customization" schemaLocation="../../xsd/agid-peppol-customization-1.0.xsd"/>
    <xsl:variable name="transaction" select="/stx:Structure/cus:Extension/cus:Name/text() | /stx:Structure/cus:Restriction/cus:Name/text()"/>

    <xsl:template match="/">
        <html data-transaction="{$transaction}">
            <head>
                <title>PEPPOL BIS Billing 3.0 | Struttura</title>
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
                <script src="/js/jquery.js"/>
                <script src="/js/bootstrap.js"/>
                <script type="text/javascript">
                    //<![CDATA[
					//debugger;//@ sourceURL=agid.js
						$(function () {
							var $html = $("html");
							var $syntax = $("#syntax");
							var source = window.location.href.split('?')[0];
							var transaction = $html.data("transaction");
							
							$("#path").on("click", "li.subcontext a", function(e) {
								e.preventDefault();
								var ctx = $("#" + $(this).attr("href"));
								changeContext(ctx);
							});
							
							$syntax.find("tr > td > a").click(function(e) {
								e.preventDefault();
								var ctx = $(this);
								changeContext(ctx, true);
							});
						
							function changeContext(ctx, showRef) {
								var branch = ctx.closest("tr");
								var level = parseInt(branch.attr("data-level"));
								if (!showRef)
									$syntax.removeClass("show-references");
								else
									$syntax.addClass("show-references");
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
								$("#path").prepend('<li><a href="'+source+'">'+transaction+'</a></li>');
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
                        <li class="active">
                            <xsl:value-of select="$transaction"/>
                        </li>
                    </ol>

                    <div class="page-header">
                        <h1 id="context">
                            <xsl:value-of select="$transaction"/>
                        </h1>
                    </div>

                    <div class="page-header" style="margin-top:0;padding-top:10px">
                        <img style="width: 255px; height: 68px;margin-left:5%;" alt="AGID" src="images/logo_AgID.jpg"/>
                        <img style="width: 225px; height: 103px;margin-left:40%;" alt="Intercent-ER" src="images/logo_INTERCENT-ER.jpg"/>
                    </div>																	

                    <div class="table-responsive">
                        <table class="table table-striped" style="table-layout: fixed">
                            <thead>
                                <tr>
                                    <th style="width: 7%">Cardinalità</th>
                                    <th style="width: 9%">ID</th>
                                    <th style="width: 28%">Nome</th>
                                    <th style="width: 49%">Descrizione</th>
                                    <th style="width: 7%">Stato</th>
                                </tr>
                            </thead>
                            <tbody id="syntax">
                                <xsl:apply-templates select="/stx:Structure/stx:Document"/>
                            </tbody>
                        </table>
                    </div>
					
                    <!--div class="table-responsive">
                            <table class="table table-striped">
                                    <thead>
                                            <tr>
                                                    <th style="width: 5%">ID regola/messaggio</th>
                                                    <th style="width: 35%">Severità</th>
                                            </tr>
                                    </thead>
                                    <tbody id="semantics">
                                            <xsl:apply-templates select="/stx:Structure/stx:Document"/>
                                    </tbody>
                            </table>
                    </div-->
                </div>
            </body>
        </html>
    </xsl:template>

    <xsl:template match="stx:Value" priority="2">
        <p>
            <xsl:choose>
                <xsl:when test="@type='FIXED'">
                    <xsl:text>Valore fisso:</xsl:text>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:text>Valore di esempio:</xsl:text>
                </xsl:otherwise>
            </xsl:choose>
            <code>
                <xsl:value-of select="."/>
            </code>
        </p>
    </xsl:template>

    <xsl:template match="stx:Reference" priority="3">
        <code>
            <xsl:value-of select="."/>
        </code>
    </xsl:template>
	
    <xsl:template name="dots">
        <xsl:param name="count" select="1"/>
        <xsl:if test="$count &gt; 0">
            <xsl:text>• &#160; </xsl:text>
            <xsl:call-template name="dots">
                <xsl:with-param name="count" select="$count - 1"/>
            </xsl:call-template>
        </xsl:if>
    </xsl:template>
	
    <xsl:template match="stx:Include" priority="1">
        <xsl:param name="level" select="0"/>
        <xsl:param name="parentId" select="''"/>
        <xsl:param name="rowClass" select="''"/>
        <xsl:apply-templates select="document(.)/stx:Element">
            <xsl:with-param name="level" select="$level"/>
            <xsl:with-param name="parentId" select="$parentId"/>
            <xsl:with-param name="rowClass" select="$rowClass"/>
        </xsl:apply-templates>
    </xsl:template>
	
    <xsl:template match="stx:Document | stx:Element" priority="1">
        <xsl:param name="level" select="0"/>
        <xsl:param name="parentId" select="''"/>
        <xsl:param name="rowClass" select="''"/>
        <xsl:variable name="card">
            <xsl:choose>
                <xsl:when test="@cardinality">
                    <xsl:value-of select="@cardinality"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:text>1..1</xsl:text>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="extension" select="contains(@cus:custom, 'extension')"/>
        <xsl:variable name="restriction" select="contains(@cus:custom, 'restriction')"/>
        <xsl:variable name="rule" select="contains(@cus:custom, 'rule')"/>
        <xsl:variable name="fixedValue" select="contains(@cus:custom, 'fixed-value')"/>
        <xsl:variable name="customCardinality" select="contains(@cus:custom, 'cardinality')"/>
        <xsl:variable name="mandatory" select="contains(@cus:custom, 'fixed-value') or @cus:note='mandatory'"/>
        <xsl:variable name="location">
            <xsl:apply-templates select="." mode="syntax-get-full-path"/>
        </xsl:variable>
        <xsl:variable name="references" select="stx:Reference[@type='BUSINESS_TERM']"/>
        <xsl:variable name="rules" select="stx:Reference[@type='RULE']"/>
        <xsl:variable name="codelists" select="stx:Reference[@type='CODE_LIST']"/>
        <xsl:variable name="rowId" select="if (string-length($parentId) &gt; 0) then concat($parentId, '.', position()) else if ($level = 0) then '' else string(position())"/>
        <xsl:variable name="customClass" select="replace(@cus:custom, ',', ' ')"/>
        <xsl:variable name="newRowClass">
            <xsl:choose>
                <xsl:when test="$extension or $restriction">
                    <xsl:value-of select="$customClass"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="$rowClass"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <tr id="{translate(translate(substring-after($location,'/'),':','-'),'/','_')}" data-level="{$level}">
            <xsl:if test="$extension or $restriction or $fixedValue">
                <xsl:attribute name="class">
                    <xsl:value-of select="$customClass"/>
                </xsl:attribute>
            </xsl:if>
            <xsl:if test="string-length($newRowClass) &gt; 0">
                <xsl:attribute name="class">
                    <xsl:value-of select="$newRowClass"/>
                </xsl:attribute>
            </xsl:if>
            <td>
                <xsl:if test="$customCardinality">
                    <xsl:attribute name="class">cardinality</xsl:attribute>
                </xsl:if>
                <span>
                    <xsl:value-of select="$card"/>
                </span>
            </td>
            <td>
                <code class="rowid">
                    <xsl:value-of select="$rowId"/>
                </code>
            </td>
            <td>
                <xsl:call-template name="dots">
                    <xsl:with-param name="count" select="$level"/>
                </xsl:call-template>
                <a href="#">
                    <xsl:value-of select="stx:Term"/>
                </a>
            </td>
            <td>
                <p>
                    <strong>
                        <xsl:value-of select="stx:Name"/>
                    </strong>
                    <br/>
                    <em>
                        <xsl:value-of select="stx:Description"/>
                    </em>
                </p>
                <xsl:apply-templates select="stx:Value"/>
                <xsl:if test="$references">
                    <p class="references">
                        <xsl:text>Termine di business:</xsl:text>
                        <xsl:apply-templates select="$references"/>
                    </p>
                </xsl:if>
                <xsl:if test="$rules">
                    <p class="references">
                        <xsl:text>Regole:</xsl:text>
                        <xsl:apply-templates select="$rules"/>
                    </p>
                </xsl:if>
                <xsl:if test="$codelists">
                    <p class="references">
                        <xsl:text>Codifiche:</xsl:text>
                        <xsl:apply-templates select="$codelists"/>
                    </p>
                </xsl:if>
            </td>
            <td>
                <xsl:if test="$mandatory">
                    <i class="fa fa-exclamation fa-fw" title="Elemento diventato obbligatorio"/>
                </xsl:if>
                <xsl:if test="$extension">
                    <small>Estensione</small>
                </xsl:if>
                <xsl:if test="$restriction">
                    <small>Restrizione</small>
                </xsl:if>
                <xsl:if test="$rule">
                    <i class="fa fa-check fa-fw" title="Regola/e italiane"/>
                </xsl:if>
                <xsl:if test="@cus:note='new'">
                    <i class="fa fa-map-pin fa-fw" title="Nuovo elemento"/>
                </xsl:if>
            </td>
        </tr>
        <xsl:apply-templates select="stx:Element | stx:Attribute | stx:Include">
            <xsl:with-param name="level" select="$level + 1"/>
            <xsl:with-param name="parentId" select="$rowId"/>
            <xsl:with-param name="rowClass" select="$newRowClass"/>
        </xsl:apply-templates>
    </xsl:template>

    <xsl:template match="stx:Attribute" priority="0">
        <xsl:param name="level" select="0"/>
        <xsl:param name="parentId" select="''"/>
        <xsl:param name="rowClass" select="''"/>
        <xsl:variable name="card">
            <xsl:choose>
                <xsl:when test="@cardinality">
                    <xsl:value-of select="@cardinality"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:text>M</xsl:text>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="extension" select="contains(@cus:custom, 'extension')"/>
        <xsl:variable name="restriction" select="contains(@cus:custom, 'restriction')"/>
        <xsl:variable name="rule" select="contains(@cus:custom, 'rule')"/>
        <xsl:variable name="fixedValue" select="contains(@cus:custom, 'fixed-value')"/>
        <xsl:variable name="customCardinality" select="contains(@cus:custom, 'cardinality')"/>
        <xsl:variable name="mandatory" select="contains(@cus:custom, 'fixed-value') or @cus:note='mandatory'"/>
        <xsl:variable name="location">
            <xsl:apply-templates select="." mode="syntax-get-full-path"/>
        </xsl:variable>
        <xsl:variable name="references" select="stx:Reference[@type='BUSINESS_TERM']"/>
        <xsl:variable name="rules" select="stx:Reference[@type='RULE']"/>
        <xsl:variable name="codelists" select="stx:Reference[@type='CODE_LIST']"/>
        <tr id="{translate(translate(substring-after($location,'/'),':','-'),'/','_')}" data-level="{$level}">
            <xsl:if test="$extension or $restriction or $fixedValue">
                <xsl:attribute name="class">
                    <xsl:value-of select="replace(@cus:custom, ',', ' ')"/>
                </xsl:attribute>
            </xsl:if>
            <xsl:if test="string-length($rowClass) &gt; 0">
                <xsl:attribute name="class">
                    <xsl:value-of select="$rowClass"/>
                </xsl:attribute>
            </xsl:if>
            <td>
                <xsl:if test="$customCardinality">
                    <xsl:attribute name="class">cardinality</xsl:attribute>
                </xsl:if>
                <span>
                    <xsl:value-of select="$card"/>
                </span>
            </td>
            <td>
                <code class="rowid">
                    <xsl:value-of select="concat($parentId, '.', position())"/>
                </code>
            </td>
            <td>
                <xsl:call-template name="dots">
                    <xsl:with-param name="count" select="$level"/>
                </xsl:call-template>
                <a href="#">
                    <xsl:value-of select="concat('@',stx:Term)"/>
                </a>
            </td>
            <td>
                <p>
                    <strong>
                        <xsl:value-of select="stx:Name"/>
                    </strong>
                    <br/>
                    <em>
                        <xsl:value-of select="stx:Description"/>
                    </em>
                </p>
                <xsl:apply-templates select="stx:Value"/>
                <xsl:if test="$references">
                    <p class="references">
                        <xsl:text>Termine di business:</xsl:text>
                        <xsl:apply-templates select="$references"/>
                    </p>
                </xsl:if>
                <xsl:if test="$rules">
                    <p class="references">
                        <xsl:text>Regole:</xsl:text>
                        <xsl:apply-templates select="$rules"/>
                    </p>
                </xsl:if>
                <xsl:if test="$codelists">
                    <p class="references">
                        <xsl:text>Codifiche:</xsl:text>
                        <xsl:apply-templates select="$codelists"/>
                    </p>
                </xsl:if>
            </td>
            <td>
                <xsl:if test="$mandatory">
                    <i class="fa fa-exclamation fa-fw" title="Attributo diventato obbligatorio"/>
                </xsl:if>
                <xsl:if test="$extension">
                    <small>Estensione</small>
                </xsl:if>
                <xsl:if test="$restriction">
                    <small>Restrizione</small>
                </xsl:if>
                <xsl:if test="$rule">
                    <i class="fa fa-check fa-fw" title="Regola/e italiane"/>
                </xsl:if>
                <xsl:if test="@cus:note='new'">
                    <i class="fa fa-map-pin fa-fw" title="Nuovo attributo"/>
                </xsl:if>
            </td>
        </tr>
    </xsl:template>

    <xsl:template match="node()" mode="syntax-get-full-path">
        <xsl:for-each select="ancestor-or-self::*">
            <xsl:if test="contains('Document,Element', name(.))">
                <xsl:text>/</xsl:text>
                <xsl:value-of select="stx:Term"/>
            </xsl:if>
            <xsl:if test="contains('Attribute', name(.))">
                <xsl:text>/@</xsl:text>
                <xsl:value-of select="stx:Term"/>
            </xsl:if>
        </xsl:for-each>
    </xsl:template>

</xsl:stylesheet>