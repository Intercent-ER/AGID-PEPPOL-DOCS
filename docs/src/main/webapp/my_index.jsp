<html lang="en">
	<head>
		<title>Specifiche PEPPOL 3</title>
		<meta charset="utf-8">
			<meta http-equiv="X-UA-Compatible" content="IE=edge">
				<meta name="viewport" content="width=device-width, initial-scale=1">

					<link rel="stylesheet" href="css/bootstrap.css"/>
					<link rel="stylesheet" href="css/structure.css?v=1.1"/>
					<link rel="stylesheet" href="css/font-awesome.min.css?v=4.7.0"/>
					<link rel="stylesheet" href="css/agid-custom.css?v=1.4"/>
				</head>
				<body>

					<div id="main" class="container">
						<h1>Indice : <span id="home-title">PEPPOL BIS 3 (altri processi)</span>
						</h1>

						<h2> Note di Rilascio </h2>
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
						<h2> Documentazione </h2>
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
						<h2> Sintassi </h2>
						<a href="xml/peppol-bis-3/agid-ubl-order.html" class="list-group-item">
							<h4 class="list-group-item-heading">Ordine Semplice PEPPOL 3.2</h4>
						</a>
						<a href="xml/peppol-bis-3/agid-ubl-order-response.html" class="list-group-item">
							<h4 class="list-group-item-heading">Risposta all'Ordine PEPPOL 3.0</h4>
						</a>
						<a href="xml/peppol-bis-3/agid-ubl-despatch-advice.html" class="list-group-item">
							<h4 class="list-group-item-heading">Documento di Trasporto PEPPOL 3.1</h4>
						</a>
						
						<h2> Regole </h2>
						
								<a href="sch/peppolbis-trdm001-3.0-order/Schematron/AGID-PEPPOL-T01.sch" class="list-group-item">
									<h4 class="list-group-item-heading">Regole di business per Ordine Semplice PEPPOL 3.2</h4>
								</a>
								<a href="sch/peppolbis-trdm076-3.0-order-response/Schematron/AGID-PEPPOL-T76.sch" class="list-group-item">
									<h4 class="list-group-item-heading">Regole di business per Risposta all'Ordine PEPPOL 3.0</h4>
								</a>
								<a href="sch/peppolbis-trdm016-3.0-despatch-advice/Schematron/AGID-PEPPOL-T16.sch" class="list-group-item">
									<h4 class="list-group-item-heading">Regole di business per il Documento di Trasporto PEPPOL 3.1</h4>
								</a>

						<h2>Codifiche</h2>
								<a href="peppol-bis-3/structure/codelist/UNCL1229.xml" class="list-group-item">
									<h4 class="list-group-item-heading">Action code (UNCL1229)</h4>
								</a>
								<a href="peppol-bis-3/structure/codelist/UNCL5189.xml" class="list-group-item">
									<h4 class="list-group-item-heading">Allowance reason codes (UNCL5189 subset)</h4>
								</a>
								<a href="peppol-bis-3/structure/codelist/UNCL4343.xml" class="list-group-item">
									<h4 class="list-group-item-heading">Application Response type code (UNCL4343 Subset)</h4>
								</a>
								<a href="peppol-bis-3/structure/codelist/TrueFalse.xml" class="list-group-item">
									<h4 class="list-group-item-heading">Boolean indicator (openPEPPOL)</h4>
								</a>
								<a href="peppol-bis-3/structure/codelist/ActionCode_header.xml" class="list-group-item">
									<h4 class="list-group-item-heading">Catalogue Action code, header level (openPEPPOL)</h4>
								</a>
								<a href="peppol-bis-3/structure/codelist/ActionCode_line.xml" class="list-group-item">
									<h4 class="list-group-item-heading">Catalogue Action code, line level (openPEPPOL)</h4>
								</a>
								<a href="peppol-bis-3/structure/codelist/it/CausalePagamento.xml" class="list-group-item locale">
									<h4 class="list-group-item-heading">Causale Pagamento (IT)</h4>
								</a>
								<a href="peppol-bis-3/structure/codelist/UNCL7161.xml" class="list-group-item">
									<h4 class="list-group-item-heading">Charge reason code (UNCL7161)</h4>
								</a>
								<a href="peppol-bis-3/structure/codelist/ClarificationListID.xml" class="list-group-item">
									<h4 class="list-group-item-heading">Clarification list identifier (openPEPPOL)</h4>
								</a>
								<a href="peppol-bis-3/structure/codelist/ISO3166-1_Alpha2.xml" class="list-group-item">
									<h4 class="list-group-item-heading">Country codes (ISO 3166-1:Alpha2)</h4>
								</a>
								<a href="peppol-bis-3/structure/codelist/ISO4217_2015.xml" class="list-group-item">
									<h4 class="list-group-item-heading">Currency codes (ISO 4217)</h4>
								</a>
								<a href="peppol-bis-3/structure/codelist/UNCL8273.xml" class="list-group-item">
									<h4 class="list-group-item-heading">Dangerous goods regulations code (UNCL8273)</h4>
								</a>
								<a href="peppol-bis-3/structure/codelist/UNCL1001.xml" class="list-group-item">
									<h4 class="list-group-item-heading">Document name code, full list (UNCL1001)</h4>
								</a>
								<a href="peppol-bis-3/structure/codelist/UNCL5305.xml" class="list-group-item">
									<h4 class="list-group-item-heading">Duty or tax or fee category code (UNCL5305)</h4>
								</a>
								<a href="peppol-bis-3/structure/codelist/eas.xml" class="list-group-item">
									<h4 class="list-group-item-heading">Electronic Address Scheme (EAS)</h4>
								</a>
								<a href="peppol-bis-3/structure/codelist/it/EsclusioniCIG.xml" class="list-group-item locale">
									<h4 class="list-group-item-heading">Esclusioni CIG (IT)</h4>
								</a>
								<a href="peppol-bis-3/structure/codelist/UNCL4079.xml" class="list-group-item locale">
									<h4 class="list-group-item-heading">Handling instruction description code (UNCL4079)</h4>
								</a>
								<a href="peppol-bis-3/structure/codelist/ICD.xml" class="list-group-item">
									<h4 class="list-group-item-heading">ISO 6523 ICD list</h4>
								</a>
								<a href="peppol-bis-3/structure/codelist/Image.xml" class="list-group-item">
									<h4 class="list-group-item-heading">Image code (openPEPPOL)</h4>
								</a>
								<a href="peppol-bis-3/structure/codelist/UNCL4343-T111.xml" class="list-group-item">
									<h4 class="list-group-item-heading">Invoice status code (UNCL4343 Subset)</h4>
								</a>
								<a href="peppol-bis-3/structure/codelist/UNCL7143.xml" class="list-group-item">
									<h4 class="list-group-item-heading">Item type identification code (UNCL7143)</h4>
								</a>
								<a href="peppol-bis-3/structure/codelist/UNCL6313.xml" class="list-group-item">
									<h4 class="list-group-item-heading">Measured attribute code (UNCL6313)</h4>
								</a>
								<a href="peppol-bis-3/structure/codelist/UNCL6313-T16.xml" class="list-group-item">
									<h4 class="list-group-item-heading">Measured attribute code for despatch advice (UNCL6313 Subset)</h4>
								</a>
								<a href="peppol-bis-3/structure/codelist/MimeCode.xml" class="list-group-item">
									<h4 class="list-group-item-heading">Mime code (IANA Subset)</h4>
								</a>
								<a href="peppol-bis-3/structure/codelist/UNCL4343-T76.xml" class="list-group-item">
									<h4 class="list-group-item-heading">Order Response type code (UNCL4343 Subset)</h4>
								</a>
								<a href="peppol-bis-3/structure/codelist/UNCL1001_T01.xml" class="list-group-item">
									<h4 class="list-group-item-heading">Order type code (UNCL1001 subset)</h4>
								</a>
								<a href="peppol-bis-3/structure/codelist/GS17009.xml" class="list-group-item">
									<h4 class="list-group-item-heading">Packaging level code (GS1 7009)</h4>
								</a>
								<a href="peppol-bis-3/structure/codelist/UNCL5387.xml" class="list-group-item">
									<h4 class="list-group-item-heading">Price type codes (UNCL5387)</h4>
								</a>
								<a href="peppol-bis-3/structure/codelist/UNECERec20-11e.xml" class="list-group-item">
									<h4 class="list-group-item-heading">Recommandation 20, including Recommandation 21 codes - prefixed with X (UN/ECE)</h4>
								</a>
								<a href="peppol-bis-3/structure/codelist/UNECERec21-9e.xml" class="list-group-item">
									<h4 class="list-group-item-heading">Recommandation 21 (UN/ECE)</h4>
								</a>
								<a href="peppol-bis-3/structure/codelist/OPStatusAction.xml" class="list-group-item">
									<h4 class="list-group-item-heading">Status Clarification Action (OpenPEPPOL)</h4>
								</a>
								<a href="peppol-bis-3/structure/codelist/OPStatusReason.xml" class="list-group-item">
									<h4 class="list-group-item-heading">Status Clarification Reason (OpenPEPPOL)</h4>
								</a>
								<a href="peppol-bis-3/structure/codelist/StatusReason.xml" class="list-group-item">
									<h4 class="list-group-item-heading">Status reason code (openPEPPOL)</h4>
								</a>

						<h2>Fogli di stile</h2>
								<a href="https://notier.regione.emilia-romagna.it/notier/foglioStile.html?tipoDocumento=ORDINE&amp;formato=BIS_3&amp;versione=2.1" class="list-group-item" target="_blank">
									<h4 class="list-group-item-heading">Foglio di Stile per l'Ordine PEPPOL 3.1</h4>
								</a>
								<a href="https://notier.regione.emilia-romagna.it/notier/foglioStile.html?tipoDocumento=DOCUMENTO_DI_TRASPORTO&amp;formato=BIS_3&amp;versione=2.1" class="list-group-item" target="_blank">
									<h4 class="list-group-item-heading">Foglio di Stile per il Documento di Trasporto PEPPOL 3.1</h4>
								</a>

						<h2>Downloads</h2>
								<a href="attachments/Intercent-ER-Esempi-Xml-Peppol-3.zip" class="list-group-item">
									<h4 class="list-group-item-heading">File di esempio</h4>
								</a>
								<a href="attachments/NoTI-ER-PEPPOL-Schematron-2.2.9.zip" class="list-group-item">
									<h4 class="list-group-item-heading">File schematron</h4>
								</a>
								<a href="attachments/NoTI-ER-PEPPOL-Validator-2.2.9.zip" class="list-group-item">
									<h4 class="list-group-item-heading">Tool di validazione</h4>
								</a>
								<a href="attachments/NoTI-ER-PEPPOL-Converter-2.4.3.zip" class="list-group-item">
									<h4 class="list-group-item-heading">Tool di conversione (valido per BIS 2.1)</h4>
								</a>
					</dl>

				</div>
			</body>
		</html>