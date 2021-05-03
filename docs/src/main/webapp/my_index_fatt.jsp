<html lang="en">
	<head>
		<title>PEPPOL BIS version 3</title>
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
		<%@include file="inc/header_fatt.jsp" %>

			<div id="main" class="container" style="display: block;">

				<div class="page-header">
					<h1>Indice : <span id="home-title">PEPPOL BIS 3 (altri processi)</span>
					</h1>
				</div>

				<dl class="dl-horizontal">
					<dd>
						<%@include file="../peppol-bis-invoice-3-ITA/menu/jumbo-list.html" %>
					</dd>
					<dt>Note di Rilascio</dt>
					<dd>
						<%@include file="../peppol-bis-invoice-3-ITA/menu/intro-list.html" %>
					</dd>
					<dt>Documentazione</dt>
					<dd>
						<%@include file="../peppol-bis-invoice-3-ITA/menu/bis-list.html" %>
					</dd>
					<dt>Sintassi</dt>
					<dd>
						<%@include file="../peppol-bis-invoice-3-ITA/menu/syntax-list.html" %>
					</dd>
					<dt>Regole</dt>
					<dd>
						<%@include file="../peppol-bis-invoice-3-ITA/menu/rule-list.html" %>
					</dd>
					<dt>Codifiche</dt>
					<dd>
						<%@include file="../peppol-bis-invoice-3-ITA/menu/codelist-list.html" %>
					</dd>
					<dt>Fogli di stile</dt>
					<dd>
						<%@include file="../peppol-bis-invoice-3-ITA/menu/stylesheet-list.html" %>
					</dd>
					<dt>Downloads</dt>
					<dd>
						<%@include file="../peppol-bis-invoice-3-ITA/menu/download-list.html" %>
					</dd>
				</dl>
			</div>
		</body>
	</html>