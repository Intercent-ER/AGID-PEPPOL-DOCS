<html lang="en">
	<head>
		<title>Peppol BIS 3</title>
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
		<script src="js/bootstrap.bundle.js"></script>


	</head>
	<body>
		<%@include file="inc/header_other-ENG.jsp" %>

			<div id="main" class="container" style="display: block;">

				<div class="page-header">
					<h1>Index: <span id="home-title">Peppol BIS 3 (other processes)</span>
					</h1>
				</div>

				<dl class="dl-horizontal">
					<dd>
						<%@include file="../peppol-bis-3-ENG/menu/jumbo-list.html" %>
					</dd>
					<dt style="font-size: 18px">Release Notes</dt>
					<dd>
						<%@include file="../peppol-bis-3-ENG/menu/intro-list.html" %>
					</dd>
					<dt style="font-size: 18px">Documentation</dt>
					<dd>
						<%@include file="../peppol-bis-3-ENG/menu/bis-list.html" %>
					</dd>
					<dt style="font-size: 18px">Syntax</dt>
					<dd>
						<%@include file="../peppol-bis-3-ENG/menu/syntax-list.html" %>
					</dd>
					<dt style="font-size: 18px">Rules</dt>
					<dd>
						<%@include file="../peppol-bis-3-ENG/menu/rule-list.html" %>
					</dd>
					<dt style="font-size: 18px">Codelists</dt>
					<dd>
						<%@include file="../peppol-bis-3-ENG/menu/codelist-list.html" %>
					</dd>
					<dt style="font-size: 18px">Stylesheets</dt>
					<dd>
						<%@include file="../peppol-bis-3-ENG/menu/stylesheet-list.html" %>
					</dd>
					<dt style="font-size: 18px">Downloads</dt>
					<dd>
						<%@include file="../peppol-bis-3-ENG/menu/download-list.html" %>
					</dd>
				</dl>
			</div>
		</body>
	</html>