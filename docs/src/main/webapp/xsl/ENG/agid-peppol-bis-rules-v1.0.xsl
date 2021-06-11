<xsl:stylesheet version="2.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:sch="http://purl.oclc.org/dsdl/schematron"
                exclude-result-prefixes="sch">
	<!--
            Author: JAVEST by Roberto Cisternino
            Version 1.0
    -->
	<xsl:output method="html"
                    doctype-system="about:legacy-compat"
                    encoding="UTF-8"
                    indent="yes" />
	<xs:import namespace="http://purl.oclc.org/dsdl/schematron" schemaLocation="../../xsd/iso-schematron.xsd"/>
	<xsl:variable name="rules" select="/sch:schema/sch:title/text()"/>

	<xsl:template match="/sch:schema">
		<html data-rules="{$rules}">
			<head>
				<title>PEPPOL BIS version 3 | Rules</title>
				<meta charset="utf-8"/>
				<meta http-equiv="X-UA-Compatible" content="IE=edge"/>
				<meta name="viewport" content="width=device-width, initial-scale=1"/>

				<link rel="stylesheet" href="css/bootstrap.css"/>
				<link rel="stylesheet" href="css/structure.css"/>
				<link rel="stylesheet" href="https://use.fontawesome.com/releases/v5.7.2/css/all.css" integrity="sha384-fnmOCqbTlWIlj8LyTjo7mOUStjsKC4pOpQbqyi7RrhN7udi9RwhKkMHpvLbHG9Sr" crossorigin="anonymous"/>
				<link rel="stylesheet" href="css/agid-custom.css"/>

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
                                    var $rules = $("#rules");
                                    var source = window.location.href.split('?')[0];
                                    var rules = $html.data("rules");

                                    $("#path").on("click", "li.subcontext a", function(e) {
                                            e.preventDefault();
                                            var ctx = $("#" + $(this).attr("href"));
                                            changeContext(ctx);
                                    });

                                    $rules.find("tr > td > a").click(function(e) {
                                            e.preventDefault();
                                            var ctx = $(this);
                                            changeContext(ctx, true);
                                    });

                                    function changeContext(ctx, showRef) {
                                            var branch = ctx.closest("tr");
                                            var level = parseInt(branch.attr("data-level"));
                                            if (!showRef)
                                                    $rules.removeClass("show-references");
                                            else
                                                    $rules.addClass("show-references");
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
                                            $("#path").prepend('<li><a href="'+source+'">'+rules+'</a></li>');
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
							<a href="#">Indice</a>
						</li>
						<li>
							<a href="#">Regole</a>
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

					<!--div class="page-header" style="margin-top:0;padding-top:10px">
                        <img style="width: 255px; height: 68px;margin-left:5%;" alt="AGID" src="/images/logo_AgID.jpg"/>
                        <img style="width: 225px; height: 103px;margin-left:40%;" alt="Intercent-ER" src="/images/logo_INTERCENT-ER.jpg"/>
                    </div-->	

					<div class="table-responsive">
						<table class="table table-striped">
							<thead>
								<tr>
									<th style="width: 95%">Identificatore / Messaggio</th>
									<th style="width: 5%">Severità</th>
								</tr>
							</thead>
							<tbody id="rules">
								<xsl:apply-templates select="sch:include | //sch:rule"/>
							</tbody>
						</table>
					</div>

				</div>
			</body>
		</html>
	</xsl:template>

	<xsl:template match="sch:rule/sch:assert" priority="1">
		<tr>
			<td style="width: 95%;">
				<xsl:value-of select="@id"/>
				<br/>
				<xsl:value-of select="."/>
			</td>
			<td style="width: 5%;">
				<xsl:value-of select="@flag"/>
			</td>
		</tr>
	</xsl:template>

	<xsl:template match="sch:include" priority="1">
		<xsl:apply-templates select="document(@href)//sch:rule"/>
	</xsl:template>

</xsl:stylesheet>