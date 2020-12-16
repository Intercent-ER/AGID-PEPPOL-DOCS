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
							<button type="button" class="btn btn-primary btn-agid" style="margin-top: 8px;">PEPPOL BIS Fatturazione 3</button>
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
											<a href="xml/peppol-bis-invoice-3/agid-ubl-invoice.html">Fattura PEPPOL 3.0</a>
										</li>
										<li>
											<a href="xml/peppol-bis-invoice-3/agid-ubl-creditnote.html">Nota di Credito PEPPOL 3.0</a>
										</li>
									</ul>
								</li>

								<li class="dropdown">
									<a href="#" class="dropdown-toggle link-agid" data-toggle="dropdown" role="button" aria-haspopup="true" aria-expanded="false">Regole <span class="caret"/>
									</a>
									<ul class="dropdown-menu" id="rule-menu">
										<li>
											<a href="xml/sch/peppolbis-en16931-ubl-3.0-invoice/Schematron/AGID-EN16931-UBL.html">Regole di business BIS PEPPOL per la Fatturazione 3.0</a>
										</li>
									</ul>
								</li>

								<li class="dropdown">
									<a href="#" class="dropdown-toggle link-agid" data-toggle="dropdown" role="button" aria-haspopup="true" aria-expanded="false">Codifiche <span class="caret"/>
									</a>
									<ul class="dropdown-menu" id="codelist-menu" style="max-height: 610px; overflow-y: scroll;">
										<li class="locale">
											<a href="peppol-bis-invoice-3/structure/codelist/it/SiglaProvince.xml">Sigla Province (IT)</a>
										</li>

										<li class="locale">
											<a href="peppol-bis-invoice-3/structure/codelist/it/TipoCassaPrevidenziale.xml">Tipo Cassa Previdenziale (IT)</a>
										</li>

										<li>
											<a href="peppol-bis-invoice-3/structure/codelist/icd.xml">ISO 6523 ICD list</a>
										</li>

										<li>
											<a href="peppol-bis-invoice-3/structure/codelist/eas.xml">Electronic Address Scheme (EAS)</a>
										</li>

										<li>
											<a href="peppol-bis-invoice-3/structure/codelist/ISO3166-1_Alpha2.xml">ISO 3166-1:Alpha2 Country codes</a>
										</li>

										<li>
											<a href="peppol-bis-invoice-3/structure/codelist/ISO4217_2015.xml">ISO 4217 Currency codes</a>
										</li>

										<li>
											<a href="peppol-bis-invoice-3/structure/codelist/UNECERec20-11e.xml">UN/ECE Recommendation 20</a>
										</li>

										<li>
											<a href="peppol-bis-invoice-3/structure/codelist/UNECERec21-9e.xml">UN/ECE Recommendation 21</a>
										</li>

										<li>
											<a href="peppol-bis-invoice-3/structure/codelist/UNCL5305.xml">Duty or tax or fee category code (Subset of UNCL5305)</a>
										</li>

										<li>
											<a href="peppol-bis-invoice-3/structure/codelist/UNCL7143.xml">Item type identification code (UNCL7143)</a>
										</li>

										<li>
											<a href="peppol-bis-invoice-3/structure/codelist/UNCL1001-inv.xml">Invoice type code (UNCL1001 subset)</a>
										</li>

										<li>
											<a href="peppol-bis-invoice-3/structure/codelist/UNCL1001-cn.xml">Credit note type code (UNCL1001 subset)</a>
										</li>

										<li>
											<a href="peppol-bis-invoice-3/structure/codelist/UNCL1153.xml">Invoiced object identifier scheme (UNCL 1153)</a>
										</li>

										<li>
											<a href="peppol-bis-invoice-3/structure/codelist/UNCL2005.xml">VAT date code (UNCL2005 subset)</a>
										</li>

										<li>
											<a href="peppol-bis-invoice-3/structure/codelist/UNCL4461.xml">Payment means code (UNCL4461)</a>
										</li>

										<li>
											<a href="peppol-bis-invoice-3/structure/codelist/UNCL5189.xml">Allowance reason codes (UNCL5189 subset)</a>
										</li>

										<li>
											<a href="peppol-bis-invoice-3/structure/codelist/UNCL7161.xml">Charge reason code (UNCL7161)</a>
										</li>

										<li>
											<a href="peppol-bis-invoice-3/structure/codelist/MimeCode.xml">Mime code (subset of IANA code list)</a>
										</li>

										<li>
											<a href="peppol-bis-invoice-3/structure/codelist/SEPA.xml">SEPA indicator</a>
										</li>

										<li>
											<a href="peppol-bis-invoice-3/structure/codelist/VATEX.xml">VATEX code list</a>
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