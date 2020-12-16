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
						<div class="list-group" id="jumbo-list"/>
					</dd>


					<dt>Note di Rilascio</dt>
					<dd>
						<div class="list-group" id="intro-list">
							<a href="docs/others/guides/release-notes-it/3-order-only/main.html" class="list-group-item">
								<h4 class="list-group-item-heading">PEPPOL BIS Ordinazione Semplice 3.2.0<span class="locale">.1(IT)&nbsp;</span>
								</h4>
							</a>
							<a href="docs/others/guides/release-notes-it/28-ordering/main.html" class="list-group-item">
								<h4 class="list-group-item-heading">PEPPOL BIS Ordinazione Completa 3.2.0<span class="locale">.1(IT)&nbsp;</span>
								</h4>
							</a>
							<a href="docs/others/guides/release-notes-it/30-despatchadvice/main.html" class="list-group-item">
								<h4 class="list-group-item-heading">PEPPOL BIS Documento di Trasporto 3.1.0<span class="locale">.4(IT)&nbsp;</span>
								</h4>
							</a>
						</div>
					</dd>
					<dt>Documentazione</dt>
					<dd>
						<div class="list-group" id="intro-list">
							<a href="docs/others/guides/profiles/3-order-only/main.html" class="list-group-item">
								<h4 class="list-group-item-heading">PEPPOL BIS Ordinazione Semplice 3.2.0<span class="locale">.1(IT)&nbsp;</span>
									<br/>
									<span style="font-size: 12pt">(Documentazione a supporto degli implementatori)</span>
								</h4>
							</a>
							<a href="docs/others/guides/profiles/28-ordering/main.html" class="list-group-item">
								<h4 class="list-group-item-heading">PEPPOL BIS Ordinazione Completa 3.2.0<span class="locale">.1(IT)&nbsp;</span>
									<br/>
									<span style="font-size: 12pt">(Documentazione a supporto degli implementatori)</span>
								</h4>
							</a>
							<a href="docs/others/guides/profiles/30-despatchadvice/main.html" class="list-group-item">
								<h4 class="list-group-item-heading">PEPPOL BIS Documento di Trasporto 3.1.0<span class="locale">.4(IT)&nbsp;</span>
									<br/>
									<span style="font-size: 12pt">(Documentazione a supporto degli implementatori)</span>
								</h4>
							</a>
						</div>
					</dd>
					<dt>Regole</dt>
					<dd>
						<div class="list-group" id="intro-list">
							<a href="xml/sch/peppolbis-trdm001-3.0-order/Schematron/AGID-PEPPOL-T01.html" class="list-group-item">
								<h4 class="list-group-item-heading">Regole di business per Ordine Semplice PEPPOL 3.2</h4>
							</a>
							<a href="xml/sch/peppolbis-trdm076-3.0-order-response/Schematron/AGID-PEPPOL-T76.html" class="list-group-item">
								<h4 class="list-group-item-heading">Regole di business per Risposta all'Ordine PEPPOL 3.0</h4>
							</a>
							<a href="xml/sch/peppolbis-trdm016-3.0-despatch-advice/Schematron/AGID-PEPPOL-T16.html" class="list-group-item">
								<h4 class="list-group-item-heading">Regole di business per il Documento di Trasporto PEPPOL 3.1</h4>
							</a>
						</div>
					</dd>
					<dt>Codifiche</dt>
					<dd>
						<div class="list-group" id="intro-list">
							<a href="xml/peppol-bis-3/codelist/UNCL1229.html" class="list-group-item">
								<h4 class="list-group-item-heading">Action code (UNCL1229)</h4>
							</a>
							<a href="xml/peppol-bis-3/codelist/UNCL5189.html" class="list-group-item">
								<h4 class="list-group-item-heading">Allowance reason codes (UNCL5189 subset)</h4>
							</a>
							<a href="xml/peppol-bis-3/codelist/UNCL4343.html" class="list-group-item">
								<h4 class="list-group-item-heading">Application Response type code (UNCL4343 Subset)</h4>
							</a>
							<a href="xml/peppol-bis-3/codelist/TrueFalse.html" class="list-group-item">
								<h4 class="list-group-item-heading">Boolean indicator (openPEPPOL)</h4>
							</a>
							<a href="xml/peppol-bis-3/codelist/ActionCode_header.html" class="list-group-item">
								<h4 class="list-group-item-heading">Catalogue Action code, header level (openPEPPOL)</h4>
							</a>
							<a href="xml/peppol-bis-3/codelist/ActionCode_line.html" class="list-group-item">
								<h4 class="list-group-item-heading">Catalogue Action code, line level (openPEPPOL)</h4>
							</a>
							<a href="xml/peppol-bis-3/codelist/CausalePagamento.html" class="list-group-item locale">
								<h4 class="list-group-item-heading">Causale Pagamento (IT)</h4>
							</a>
							<a href="xml/peppol-bis-3/codelist/UNCL7161.html" class="list-group-item">
								<h4 class="list-group-item-heading">Charge reason code (UNCL7161)</h4>
							</a>
							<a href="xml/peppol-bis-3/codelist/ClarificationListID.html" class="list-group-item">
								<h4 class="list-group-item-heading">Clarification list identifier (openPEPPOL)</h4>
							</a>
							<a href="xml/peppol-bis-3/codelist/ISO3166-1_Alpha2.html" class="list-group-item">
								<h4 class="list-group-item-heading">Country codes (ISO 3166-1:Alpha2)</h4>
							</a>
							<a href="xml/peppol-bis-3/codelist/ISO4217_2015.html" class="list-group-item">
								<h4 class="list-group-item-heading">Currency codes (ISO 4217)</h4>
							</a>
							<a href="xml/peppol-bis-3/codelist/UNCL8273.html" class="list-group-item">
								<h4 class="list-group-item-heading">Dangerous goods regulations code (UNCL8273)</h4>
							</a>
							<a href="xml/peppol-bis-3/codelist/UNCL1001.html" class="list-group-item">
								<h4 class="list-group-item-heading">Document name code, full list (UNCL1001)</h4>
							</a>
							<a href="xml/peppol-bis-3/codelist/UNCL5305.html" class="list-group-item">
								<h4 class="list-group-item-heading">Duty or tax or fee category code (UNCL5305)</h4>
							</a>
							<a href="xml/peppol-bis-3/codelist/eas.html" class="list-group-item">
								<h4 class="list-group-item-heading">Electronic Address Scheme (EAS)</h4>
							</a>
							<a href="xml/peppol-bis-3/codelist/EsclusioniCIG.html" class="list-group-item locale">
								<h4 class="list-group-item-heading">Esclusioni CIG (IT)</h4>
							</a>
							<a href="xml/peppol-bis-3/codelist/UNCL4079.html" class="list-group-item locale">
								<h4 class="list-group-item-heading">Handling instruction description code (UNCL4079)</h4>
							</a>
							<a href="xml/peppol-bis-3/codelist/ICD.html" class="list-group-item">
								<h4 class="list-group-item-heading">ISO 6523 ICD list</h4>
							</a>
							<a href="xml/peppol-bis-3/codelist/Image.html" class="list-group-item">
								<h4 class="list-group-item-heading">Image code (openPEPPOL)</h4>
							</a>
							<a href="xml/peppol-bis-3/codelist/UNCL4343-T111.html" class="list-group-item">
								<h4 class="list-group-item-heading">Invoice status code (UNCL4343 Subset)</h4>
							</a>
							<a href="xml/peppol-bis-3/codelist/UNCL7143.html" class="list-group-item">
								<h4 class="list-group-item-heading">Item type identification code (UNCL7143)</h4>
							</a>
							<a href="xml/peppol-bis-3/codelist/UNCL6313.html" class="list-group-item">
								<h4 class="list-group-item-heading">Measured attribute code (UNCL6313)</h4>
							</a>
							<a href="xml/peppol-bis-3/codelist/UNCL6313-T16.html" class="list-group-item">
								<h4 class="list-group-item-heading">Measured attribute code for despatch advice (UNCL6313 Subset)</h4>
							</a>
							<a href="xml/peppol-bis-3/codelist/MimeCode.html" class="list-group-item">
								<h4 class="list-group-item-heading">Mime code (IANA Subset)</h4>
							</a>
							<a href="xml/peppol-bis-3/codelist/UNCL4343-T76.html" class="list-group-item">
								<h4 class="list-group-item-heading">Order Response type code (UNCL4343 Subset)</h4>
							</a>
							<a href="xml/peppol-bis-3/codelist/UNCL1001_T01.html" class="list-group-item">
								<h4 class="list-group-item-heading">Order type code (UNCL1001 subset)</h4>
							</a>
							<a href="xml/peppol-bis-3/codelist/GS17009.html" class="list-group-item">
								<h4 class="list-group-item-heading">Packaging level code (GS1 7009)</h4>
							</a>
							<a href="xml/peppol-bis-3/codelist/UNCL5387.html" class="list-group-item">
								<h4 class="list-group-item-heading">Price type codes (UNCL5387)</h4>
							</a>
							<a href="xml/peppol-bis-3/codelist/UNECERec20-11e.html" class="list-group-item">
								<h4 class="list-group-item-heading">Recommandation 20, including Recommandation 21 codes - prefixed with X (UN/ECE)</h4>
							</a>
							<a href="xml/peppol-bis-3/codelist/UNECERec21-9e.html" class="list-group-item">
								<h4 class="list-group-item-heading">Recommandation 21 (UN/ECE)</h4>
							</a>
							<a href="xml/peppol-bis-3/codelist/OPStatusAction.html" class="list-group-item">
								<h4 class="list-group-item-heading">Status Clarification Action (OpenPEPPOL)</h4>
							</a>
							<a href="xml/peppol-bis-3/codelist/OPStatusReason.html" class="list-group-item">
								<h4 class="list-group-item-heading">Status Clarification Reason (OpenPEPPOL)</h4>
							</a>
							<a href="xml/peppol-bis-3/codelist/StatusReason.html" class="list-group-item">
								<h4 class="list-group-item-heading">Status reason code (openPEPPOL)</h4>
							</a>
						</div>
					</dd>
					<dt>Fogli di stile</dt>
					<dd>
						<div class="list-group" id="intro-list">
							<a href="https://notier.regione.emilia-romagna.it/notier/foglioStile.html?tipoDocumento=ORDINE&amp;formato=BIS_3&amp;versione=2.1" class="list-group-item" target="_blank">
								<h4 class="list-group-item-heading">Foglio di Stile per l'Ordine PEPPOL 3.1</h4>
							</a>
							<a href="https://notier.regione.emilia-romagna.it/notier/foglioStile.html?tipoDocumento=DOCUMENTO_DI_TRASPORTO&amp;formato=BIS_3&amp;versione=2.1" class="list-group-item" target="_blank">
								<h4 class="list-group-item-heading">Foglio di Stile per il Documento di Trasporto PEPPOL 3.1</h4>
							</a>
						</div>
					</dd>
					<dt>Downloads</dt>
					<dd>
						<div class="list-group" id="intro-list">
							<a href="https://notier.regione.emilia-romagna.it/notier/foglioStile.html?tipoDocumento=ORDINE&amp;formato=BIS_3&amp;versione=2.1" class="list-group-item" target="_blank">
								<h4 class="list-group-item-heading">Foglio di Stile per l'Ordine PEPPOL 3.1</h4>
							</a>
							<a href="https://notier.regione.emilia-romagna.it/notier/foglioStile.html?tipoDocumento=DOCUMENTO_DI_TRASPORTO&amp;formato=BIS_3&amp;versione=2.1" class="list-group-item" target="_blank">
								<h4 class="list-group-item-heading">Foglio di Stile per il Documento di Trasporto PEPPOL 3.1</h4>
							</a>
						</div>
					</dd>
				</dl>
			</div>
		</body>
	</html>