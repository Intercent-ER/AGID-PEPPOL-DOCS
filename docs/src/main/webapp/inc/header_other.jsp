<nav class="navbar navbar-default navbar-fixed-top navbar-agid">

	<div class="container">

		<div class="navbar-header">
			<button type="button" class="navbar-toggle collapsed" data-toggle="collapse"
                            data-target="#bs-example-navbar-collapse-1" aria-expanded="false">
				<span class="sr-only">Toggle navigation</span>
				<span class="icon-bar"/>
				<span class="icon-bar"/>
				<span class="icon-bar"/>
			</button>
			<a class="navbar-brand" href="<%=request.getContextPath()%>" style="margin-top: -15px;">
					<img src="images/agid-logo.png" style="margin:10px" alt="AGID">
					</a>
				</div>

				<div class="collapse navbar-collapse" id="bs-example-navbar-collapse-1">
					<ul class="nav navbar-nav">
						<li class="btn-group" id="peppol-bis">
							<button type="button" class="btn btn-primary btn-agid" style="margin-top: 8px;">PEPPOL BIS 3 (altri processi)</button>
							<button type="button" class="btn btn-primary dropdown-toggle btn-agid" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false" style="margin-top: 8px;">
								<span class="caret"/>
								<span class="sr-only">Toggle Dropdown</span>
							</button>
							<ul class="dropdown-menu">
								<li>
									<a href="<%=request.getContextPath()%>/my_index_fatt.jsp">PEPPOL BIS Fatturazione 3</a>
									</li>
									<li>
										<a href="<%=request.getContextPath()%>/my_index.jsp">PEPPOL BIS 3 (altri processi)</a>
										</li>
									</ul>
								</li>

								<li class="dropdown">
									<a href="#" class="dropdown-toggle link-agid" data-toggle="dropdown" role="button" aria-haspopup="true" aria-expanded="false">Sintassi <span class="caret"/>
									</a>
									<ul class="dropdown-menu" id="syntax-menu">
										<li>
											<a href="xml/peppol-bis-3/agid-ubl-order.html">Ordine Semplice PEPPOL 3.2</a>
										</li>
										<li>
											<a href="xml/peppol-bis-3/agid-ubl-order-response.html">Risposta all'Ordine PEPPOL 3.0</a>
										</li>
										<li>
											<a href="xml/peppol-bis-3/agid-ubl-despatch-advice.html">Documento di Trasporto PEPPOL 3.1</a>
										</li>
									</ul>
								</li>

								<li class="dropdown">
									<a href="#" class="dropdown-toggle link-agid" data-toggle="dropdown" role="button" aria-haspopup="true" aria-expanded="false">Regole <span class="caret"/>
									</a>
									<ul class="dropdown-menu" id="rule-menu">
										<li>
											<a href="xml/sch/peppolbis-trdm001-3.0-order/Schematron/AGID-PEPPOL-T01.html">Regole di business per Ordine Semplice PEPPOL 3.2</a>
										</li>
										<li>
											<a href="xml/sch/peppolbis-trdm076-3.0-order-response/Schematron/AGID-PEPPOL-T76.html">Regole di business per Risposta all'Ordine PEPPOL 3.0</a>
										</li>
										<li>
											<a href="xml/sch/peppolbis-trdm016-3.0-despatch-advice/Schematron/AGID-PEPPOL-T16.html">Regole di business per il Documento di Trasporto PEPPOL 3.1</a>
										</li>
									</ul>
								</li>

								<li class="dropdown">
									<a href="#" class="dropdown-toggle link-agid" data-toggle="dropdown" role="button" aria-haspopup="true" aria-expanded="false">Codifiche <span class="caret"/>
									</a>
									<ul class="dropdown-menu" id="codelist-menu" style="max-height: 610px; overflow-y: scroll;">
										<li>
											<a href="xml/peppol-bis-3/codelist/UNCL1229.html">Action code (UNCL1229)</a>
										</li>
										<li>
											<a href="xml/peppol-bis-3/codelist/UNCL5189.html">Allowance reason codes (UNCL5189 subset)</a>
										</li>
										<li>
											<a href="xml/peppol-bis-3/codelist/UNCL4343.html">Application Response type code (UNCL4343 Subset)</a>
										</li>
										<li>
											<a href="xml/peppol-bis-3/codelist/TrueFalse.html">Boolean indicator (openPEPPOL)</a>
										</li>
										<li>
											<a href="xml/peppol-bis-3/codelist/ActionCode_header.html">Catalogue Action code, header level (openPEPPOL)</a>
										</li>
										<li>
											<a href="xml/peppol-bis-3/codelist/ActionCode_line.html">Catalogue Action code, line level (openPEPPOL)</a>
										</li>
										<li class="locale">
											<a href="xml/peppol-bis-3/codelist/CausalePagamento.html">Causale Pagamento (IT)</a>
										</li>
										<li>
											<a href="xml/peppol-bis-3/codelist/UNCL7161.html">Charge reason code (UNCL7161)</a>
										</li>
										<li>
											<a href="xml/peppol-bis-3/codelist/ClarificationListID.html">Clarification list identifier (openPEPPOL)</a>
										</li>
										<li>
											<a href="xml/peppol-bis-3/codelist/ISO3166-1_Alpha2.html">Country codes (ISO 3166-1:Alpha2)</a>
										</li>
										<li>
											<a href="xml/peppol-bis-3/codelist/ISO4217_2015.html">Currency codes (ISO 4217)</a>
										</li>
										<li>
											<a href="xml/peppol-bis-3/codelist/UNCL8273.html">Dangerous goods regulations code (UNCL8273)</a>
										</li>
										<li>
											<a href="xml/peppol-bis-3/codelist/UNCL1001.html">Document name code, full list (UNCL1001)</a>
										</li>
										<li>
											<a href="xml/peppol-bis-3/codelist/UNCL5305.html">Duty or tax or fee category code (UNCL5305)</a>
										</li>
										<li>
											<a href="xml/peppol-bis-3/codelist/eas.html">Electronic Address Scheme (EAS)</a>
										</li>
										<li class="locale">
											<a href="xml/peppol-bis-3/codelist/EsclusioniCIG.html">Esclusioni CIG (IT)</a>
										</li>
										<li class="locale">
											<a href="xml/peppol-bis-3/codelist/UNCL4079.html">Handling instruction description code (UNCL4079)</a>
										</li>
										<li>
											<a href="xml/peppol-bis-3/codelist/ICD.html">ISO 6523 ICD list</a>
										</li>
										<li>
											<a href="xml/peppol-bis-3/codelist/Image.html">Image code (openPEPPOL)</a>
										</li>
										<li>
											<a href="xml/peppol-bis-3/codelist/UNCL4343-T111.html">Invoice status code (UNCL4343 Subset)</a>
										</li>
										<li>
											<a href="xml/peppol-bis-3/codelist/UNCL7143.html">InvoiceItem type identification code (UNCL7143)</a>
										</li>
										<li>
											<a href="xml/peppol-bis-3/codelist/UNCL6313.html">Measured attribute code (UNCL6313)</a>
										</li>
										<li>
											<a href="xml/peppol-bis-3/codelist/UNCL6313-T16.html">Measured attribute code for despatch advice (UNCL6313 Subset)</a>
										</li>
										<li>
											<a href="xml/peppol-bis-3/codelist/MimeCode.html">Mime code (IANA Subset)</a>
										</li>
										<li>
											<a href="xml/peppol-bis-3/codelist/UNCL4343-T76.html">Order Response type code (UNCL4343 Subset)</a>
										</li>
										<li>
											<a href="xml/peppol-bis-3/codelist/UNCL1001_T01.html">Order type code (UNCL1001 subset)</a>
										</li>
										<li>
											<a href="xml/peppol-bis-3/codelist/GS17009.html">Packaging level code (GS1 7009)</a>
										</li>
										<li>
											<a href="xml/peppol-bis-3/codelist/UNCL5387.html">Price type codes (UNCL5387)</a>
										</li>
										<li>
											<a href="xml/peppol-bis-3/codelist/UNECERec20-11e.html">Recommandation 20, including Recommandation 21 codes - prefixed with X (UN/ECE)</a>
										</li>
										<li>
											<a href="xml/peppol-bis-3/codelist/UNECERec21-9e.html">Recommandation 21 (UN/ECE)</a>
										</li>
										<li>
											<a href="xml/peppol-bis-3/codelist/OPStatusAction.html">Status Clarification Action (OpenPEPPOL)</a>
										</li>
										<li>
											<a href="xml/peppol-bis-3/codelist/OPStatusReason.html">Status Clarification Reason (OpenPEPPOL)</a>
										</li>
										<li>
											<a href="xml/peppol-bis-3/codelist/StatusReason.html">Status reason code (openPEPPOL)</a>
										</li>
									</ul>
								</li>

								<li class="dropdown dropdown-agid">
									<a href="#" class="dropdown-toggle link-agid" data-toggle="dropdown" role="button" aria-haspopup="true" aria-expanded="false">Fogli di stile <span class="caret"/>
									</a>
									<ul class="dropdown-menu" id="stylesheet-menu" style="max-height: 610px; overflow-y: scroll;">
										<li>
											<a href="https://notier.regione.emilia-romagna.it/notier/foglioStile.html?tipoDocumento=ORDINE&amp;formato=BIS_3&amp;versione=2.1">Foglio di Stile per l'Ordine PEPPOL 3.1</a>
										</li>
										<li>
											<a href="https://notier.regione.emilia-romagna.it/notier/foglioStile.html?tipoDocumento=DOCUMENTO_DI_TRASPORTO&amp;formato=BIS_3&amp;versione=2.1">Foglio di Stile per il Documento di Trasporto PEPPOL 3.1</a>
										</li>
									</ul>
								</li>
							</ul>
						</div>
					</div>
				</nav>