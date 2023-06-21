<?xml version="1.0" encoding="UTF-8"?>
<!-- 
    Descrizione documento:     	Foglio di stile per Documento di trasporto UBL 2.1 Peppol BIS 3
    Versione : 					1.0
    Prodotto il :              	Dicembre 2015       
    PProdotto da :             	Intercent-ER
    Ambito:                    	Intercent-ER - Piloti Peppol
-->
<xsl:stylesheet xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:cac="urn:oasis:names:specification:ubl:schema:xsd:CommonAggregateComponents-2" xmlns:cbc="urn:oasis:names:specification:ubl:schema:xsd:CommonBasicComponents-2" xmlns:in="urn:oasis:names:specification:ubl:schema:xsd:DespatchAdvice-2" xmlns:ext="urn:oasis:names:specification:ubl:schema:xsd:CommonExtensionComponents-2" xmlns:cr="http://www.ubl-italia.org/ns/CrossReference" version="2.0" exclude-result-prefixes="cac cbc in">
    <xd:doc xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl" scope="stylesheet">
        <xd:desc>
            <xd:p><xd:b>Created on:</xd:b> Dec 02, 2015</xd:p>
            <xd:p><xd:b>Author:</xd:b> Intercent-ER</xd:p>
            <xd:p/>
        </xd:desc>
    </xd:doc>
    <xsl:param name="xclUnitOfMeasureCode"/>
    <xsl:param name="xclPaymentMeansCode"/>
	<xsl:param name="xclProvinceItaliane"/>
	<xsl:param name="xclOrderTypeCode"/>
	<xsl:param name="xclHandlingCode"/>
    
    <xsl:decimal-format name="number" decimal-separator="," grouping-separator="."/>
    <xsl:template match="/">
        <html>
            <head>
                <title>DDT</title>
                <style type="text/css">
                    /* general text properties */
                    .in-body {
                        font-family: serif
                    }
                    .in-box-label {
                        font-family: "Arial", sans-serif;
                        font-style:italic;
                        font-size:72%;
                        margin-left: 1pt;
                        margin-right:1pt;
                        margin-top:1pt
                    }
                    .box-text {
                        font-family: "Arial", sans-serif;
                        font-size:70%;
                        line-height:15pt;
                        margin-left: 1pt;
                        margin-right:1pt
                    }
                    .title-text {
                        font-family:"Arial", sans-serif;
                        font-weight:bold;
                        font-size:90%
                        margin-left:10pt;
                    }
                    .subtitle-text {
                        font-family:"Arial", sans-serif;
                        font-weight:bold;
                        font-size:80%;
                        margin-left: 1pt;
                        margin-right:1pt
                    }
                    .in-table {
                        border-collapse:collapse;
                        border-color: #000000;
                        table-layout:fixed
                    }
                    .in-form-column {
                        width:8.33%
                    }
                    .in-counter-cell {
                        border:none
                    }
                    .in-cell-data {
                        margin-top:0pt;
                        margin-bottom:0pt
                    }
                    .in-cell-data-background {
                    }
                    .in-cell-data-center {
                        text-align:center
                    }
                    .in-cell-base {
                        border:solid;
                        border-width:1pt
                    }
                    .in-cell-end-override {
                        border-right-style:none
                    }
                    .in-cell-after-override {
                        border-bottom-style:none
                    }
                    .in-cell-line-background {
                        background-color:#b8b8b8;
                        font-weight:bold
                    }
                    .in-cell-filler-background {
                        background-color:#e8e8e8
                    }
                    .fixed-height{
                        min-height: 40px;
                        display:block;
                    }
                    .law-warning{
                        font-style: italic;
                        font-size: 70%;
                    }
                    .border-left{
                        border-left: 1px solid;
                    }
                    .no-bottom-border{
                        border-bottom: none;
                    }
                    .allowance-charge{
                        list-style-type: none;
                        padding: 0px;
                        margin: 0px;
                    }
                    .allowance-charge LI{
                    }  
                    H1{
                        font-size:120%;
                        font-family: "Arial", sans-serif;
                    }
                    
                    H2{
                        font-family: "Arial", sans-serif;
                        font-size:100%;
                    }
                    
                    H3{
                    font-size:90%;
                    }
                    
                    .padded{
                        padding-top:20px;
                        padding-bottom:10px;
                        display:block;
                    }
                    
                    .riepilogo-fattura{
                        width:100%;
                        border:1px solid black;
                        padding: 0;
                        margin: 0;
                        border-spacing: 0;
                        border-collapse: collapse;
                    }
                    .dati-fattura{
                    width:100%;
                    height:150px;
                    border: none;
                    padding: 0;
                    margin: 0;
                    border-spacing: 0;
                    border-collapse: collapse;
                    }
                    
                    .dati-documento{
                    width:100%;
                    height:50px;
                    border: none;
                    padding: 0;
                    margin: 0;
                    border-spacing: 0;
                    border-collapse: collapse;
                    }
                    
                    .no-border{
                    border:0 !important;
                    }
                    .riepilogo-fattura TD{
                    border:1px solid black;
                    padding: 0;
                    margin: 0;
                    vertical-align: top;         
                    }
                    .party-row{
                        height:150px;
                    }
                    
					.h50{
						height: 50px;
					}
					.h80{
						height: 80px;
					}
					.h100px{
                        height: 100px;
                    }
					
	
                    .border-bottom{
                    	border-bottom:1px solid black !important;
                    }
					.border-right{
                    	border-right:1px solid black !important;
                    }
					
					.border-left{
                    	border-left:1px solid black !important;
                    }
                    
                    .party-column{
                        width:50%;
                    }
                    
                    .riepilogo-PDC{
                    width:100%;
                    border:1px solid black;
                    padding: 0;
                    margin: 0;
                    border-spacing: 0;
                    border-collapse: collapse;
                    }
                    .riepilogo-PDC TH{
                    font-family: "Arial", sans-serif;
                    font-size:70%;
                    font-style:italic;
                    border-right:1px solid black;
                    height:30px;
                    }
                    .w-50 {
                    width:50%;
                    }
					.w-66 {
                    width:67%;
                    }
					.w-90 {
                    width:90%;
                    }
					.w-33 {
                    width:33%;
                    }
                    .w-40{
                    width:40%;
                    }
                    .w-30{
                    width:30%;
                    }
                    .w-25{
                    width:25%;
                    }
                    .w-15{
                    width:15%;
                    }
                    .w-10{
                    width:10%;
                    }
                    .w-5{
                    width:5%;
                    }
					
					.w-100{
					width:100%;
					}
                    
                    
                    
                    .righe-fattura{
                     width:100%;
                     border:1px solid black;
                     padding: 0;
                     margin: 0;
                     border-spacing: 0;
                     border-collapse: collapse;
                    }
                    .righe-fattura TH{
                        font-family: "Arial", sans-serif;
                        font-size:70%;
                        font-style:italic;
                        border-right:1px solid black;
                        height:30px;
                    }
                    
                    .empty-cell-filler{
                        height: 1.5em;
                    }
                    
                    .page-break{ page-break-inside:avoid }
                    
                    table { page-break-inside:auto }
                    tr    { page-break-inside:avoid; page-break-after:auto }
                    thead { display:table-header-group }
                    tfoot { display:table-footer-group }
                    
                    .block{
                        display:block;
                    }
                    
                    .h100{
                    	height:100%;
                    }
                    
                    .attachment-list{
                    	list-style-type: none;
                    }
					
					.float-right{
						float:right;
						margin-top:20px;
						clear:both;
					}
					
					.float-right-last{
						float:right;
						margin-bottom: 30px;
						display:block;
						clear:both;
					}
					
					.nowraptext{
						white-space: nowrap;
						word-break: break-all;
					}
					
					.bold{
						font-weight:bold;
					}
					
					.margin-right{
						margin-right:20px;
					}
					
					.header-linea{
						padding-top: 5px;
						padding-bottom:3px;
						margin:0;
					}
					
					.no-margin{
						margin:0;
						padding:0;
					}
                </style>
            </head>
            <body class="in-body">
            	<div class="page-break">
                <h1>DDT </h1>
                <h2>Rappresentazione UBL Peppol BIS 3</h2>
                <table class="riepilogo-fattura" summary="riepilogo ddt">
                    <tr class="party-row">
                        <td class="party-column">
                            <h2 class="in-box-label">Mittente</h2>
                            <xsl:call-template name="in-party">
								<xsl:with-param name="party" select="/in:DespatchAdvice/cac:DespatchSupplierParty/cac:Party"/>
							</xsl:call-template>
                        </td>
                        <td>
                            <table class="dati-fattura" summary="dati fattura">
                                <tr class="dati-fattura-row dati-fattura-border">
                                    <td class="no-border border-right border-bottom h100px w-33 in-cell-filler-background">
                                        <h2 class="in-box-label">Numero DDT</h2>
									   <span class="box-text">
										   <xsl:call-template name="in-id">
													<xsl:with-param name="id" select="/in:DespatchAdvice"/>
											</xsl:call-template>
										</span>
                                    </td>
                                    <td class="no-border border-right border-bottom h100px w-33 in-cell-filler-background">  
                                        <h2 class="in-box-label">Data DDT</h2>
										<span class="box-text">
											<xsl:call-template name="format-date">
												<xsl:with-param name="date">
													<xsl:value-of select="/in:DespatchAdvice/cbc:IssueDate"/>
												</xsl:with-param>
											</xsl:call-template>
										</span>
                                    </td>
									<td class="no-border border-bottom h100px w-33 in-cell-filler-background">
                                        <h2 class="in-box-label">Riferimento Ordine</h2>
										<xsl:if test="/in:DespatchAdvice/cac:OrderReference">										
											<xsl:if test="/in:DespatchAdvice/cac:OrderReference/cbc:DocumentStatuCode">
												<div class="box-text"> Stato: <xsl:value-of select="/in:DespatchAdvice/cac:OrderReference/cbc:DocumentStatuCode"/>
												</div>
											</xsl:if>
										</xsl:if>
                                    </td>
						        </tr>
								<tr>
                                   
									<td class="no-border border-right w-33 h100px">
										<h2 class="in-box-label">Altri Riferimenti</h2>
											<xsl:for-each select="/in:DespatchAdvice/cac:AdditionalDocumentReference">
												<div class="box-text">
													<xsl:value-of select="cbc:DocumentType"/>: <xsl:value-of select="cbc:ID"/>
													<xsl:if test="cbc:IssueDate">(<xsl:value-of select="cbc:IssueDate"/>)</xsl:if>
													<xsl:if test="cac:Attachment"> - contiene allegato
														<xsl:if test="cac:Attachment/cac:ExternalReference">(<xsl:value-of select="cac:Attachment/cac:ExternalReference/cbc:URI"/>)</xsl:if>
													</xsl:if>
												</div>
											</xsl:for-each>
									</td>
									<td class="no-border w-66 h100px" colspan="2"> 
                                        <h2 class="in-box-label">Note</h2>
                                        <xsl:call-template name="in-note"/>
                                    </td>
									
                                </tr>                   						
                            </table>
                        </td>
                    </tr>
                    <tr class="party-row">
                        <td>
                            <h2 class="in-box-label">Destinatario</h2>
                            <xsl:call-template name="in-party">
								<xsl:with-param name="party" select="/in:DespatchAdvice/cac:DeliveryCustomerParty/cac:Party"/>
							</xsl:call-template>
							<xsl:if test="/in:DespatchAdvice/cac:DeliveryCustomerParty/cac:Party/cac:DeliveryContact">
								<xsl:call-template name="contact">
									<xsl:with-param name="contact" select="/in:DespatchAdvice/cac:DeliveryCustomerParty/cac:Party/cac:DeliveryContact"/>
								</xsl:call-template>
							</xsl:if>
                        </td>
						<td>
                            <h2 class="in-box-label">Fornitore / Venditore"</h2>
                            <xsl:call-template name="in-party">
								<xsl:with-param name="party" select="/in:DespatchAdvice/cac:SellerSupplierParty/cac:Party"/>
							</xsl:call-template>
                        </td>							
                    </tr>
					<tr class="party-row">
                        <td>
                            <h2 class="in-box-label">Cliente/Acquirente</h2>
                            <xsl:call-template name="in-party">
								<xsl:with-param name="party" select="/in:DespatchAdvice/cac:BuyerCustomerParty/cac:Party"/>
							</xsl:call-template>
                        </td>		
						<td>
                            <h2 class="in-box-label">Richiedente</h2>
                            <xsl:call-template name="in-party">
								<xsl:with-param name="party" select="/in:DespatchAdvice/cac:OriginatorCustomerParty/cac:Party"/>
							</xsl:call-template>
                        </td>							
                    </tr>
				</table>
                </div>
				
				
					
				<!-- DESPATCH LINE { -->
				
               	<div class="page-break">
                <h1>Righe DDT</h1>
                <table class="righe-fattura" summary="righe ddt">

                    <thead>
                        <tr>
                            <th scope="col" class="in-cell-filler-background">Nome/Descrizione/Note</th>
							<th scope="col" class="in-cell-filler-background">Cod. Articolo Fornitore</th>
							<th scope="col" class="in-cell-filler-background">Cod. Articolo Standard</th>
							<th scope="col" class="in-cell-filler-background">Quantità</th>
							<th scope="col" class="in-cell-filler-background">UdM</th>
							<th scope="col" class="in-cell-filler-background">Quantità per Confezione</th>
							<th scope="col" class="in-cell-filler-background">Informazioni Articolo</th>
                            <th scope="col" class="in-cell-filler-background">Quantità Inevasa / Motivo</th>
							<th scope="col" class="in-cell-filler-background">Pericolosità Articolo</th>
							<th scope="col" class="in-cell-filler-background">Tipo Consegna</th>
							<th scope="col" class="in-cell-filler-background">Codici Imballo</th>
							<th scope="col" class="in-cell-filler-background">Riferimento Ordine</th>	
                        </tr>
                    </thead>
                    <tbody>
                        <xsl:for-each select="/in:DespatchAdvice/cac:DespatchLine">
                            <tr>
								<!-- Nome/Descrizione/Note -->
								<td class="in-cell-base">
									<div>
										<xsl:for-each select="cac:Item">
											<div class="box-text">
												<xsl:value-of select="cbc:Name"/>
											</div>
											<xsl:for-each select="cbc:AdditionalInformation" >
												<div class="box-text">
													<xsl:value-of select="text()"/>
												</div>
											</xsl:for-each>
										</xsl:for-each>
										<div class="box-text">
											<xsl:value-of select="cbc:Note"/>
										</div>
									</div>
                                </td>

								<!-- Cod. Articolo Fornitore -->
								 <td class="in-cell-base">
									<div class="box-text">
										   <xsl:call-template name="in-id">
												<xsl:with-param name="id" select="cac:Item/cac:SellersItemIdentification"/>
											</xsl:call-template>
									</div>
                                </td>

								<!-- Cod. Articolo Standard -->
								 <td class="in-cell-base">
									<div class="box-text">
											<xsl:call-template name="in-id">
												<xsl:with-param name="id" select="cac:Item/cac:StandardItemIdentification"/>
											</xsl:call-template>
											<xsl:if test="cac:Item/cac:StandardItemIdentification/cbc:ID/@schemeID">
											(<xsl:value-of select="cac:Item/cac:StandardItemIdentification/cbc:ID/@schemeID"/>)
										</xsl:if>
									</div>
                                </td>
								
								<!-- Qtà -->
								<td class="in-cell-base">
									<div class="box-text">
										<xsl:call-template name="format-amount">
											<xsl:with-param name="amount" select="cbc:DeliveredQuantity"/>
										</xsl:call-template>
									</div>
                                </td>
								
								<!-- UdM -->
								<td class="in-cell-base  in-cell-data-center">
                                    <div class="box-text">
                                   	 <xsl:value-of select="if (document($xclUnitOfMeasureCode)//Value[@ColumnRef='xname']/SimpleValue[../../Value[@ColumnRef='code']/SimpleValue=current()/cbc:DeliveredQuantity/@unitCode]) then document($xclUnitOfMeasureCode)//Value[@ColumnRef='xname']/SimpleValue[../../Value[@ColumnRef='code']/SimpleValue=current()/cbc:DeliveredQuantity/@unitCode][1] else cbc:DeliveredQuantity/@unitCode"/>
                                    </div>
                                </td>
								
								<!-- Quantità per Confezione -->
								<td class="in-cell-base  in-cell-data-center">
									<div class="box-text">
										<xsl:choose>
											<xsl:when test="cbc:DeliveredQuantity[@unitCode='PK']">
												<xsl:value-of select="cac:Item/cbc:PackQuantity"/>
											</xsl:when>
											<xsl:otherwise>
												<xsl:value-of select="cac:Item/cbc:PackSizeNumeric"/>
											</xsl:otherwise>
										</xsl:choose>
									</div>
								</td>
								
								<!-- Informazioni Articolo -->
								 <td class="in-cell-base">
										<div>
                                            <ul style="border:0;margin:0;padding:0">
													<xsl:for-each select="cac:Item/cac:ItemInstance">
														<li style="list-style-type:none;">
															<xsl:if test="cbc:SerialID">
																<div class="box-text"><b>Seriale:</b> <xsl:value-of select="cbc:SerialID"/></div>
															</xsl:if>
															<xsl:if test="cac:LotIdentification/cbc:LotNumberID">
																<div class="box-text"><b>Lotto:</b> <xsl:value-of select="cac:LotIdentification/cbc:LotNumberID"/></div>
															</xsl:if>
															<xsl:if test="cac:LotIdentification/cbc:ExpiryDate">
																<div class="box-text"><b>Scadenza:</b>
																	<xsl:call-template name="format-date">
																		<xsl:with-param name="date">
																			<xsl:value-of select="cac:LotIdentification/cbc:ExpiryDate"/>
																		</xsl:with-param>
																	</xsl:call-template>
																</div>
															</xsl:if>
														</li>
													</xsl:for-each>
										   </ul>
									</div>
                                </td>
								
								<!-- Qtà Inevasa/Motivo -->
								 <td class="in-cell-base">
									<div>
										<xsl:if test="cbc:OutstandingQuantity">
											<div class="box-text"><b>Qtà:</b> 
											<xsl:call-template name="format-amount">
												<xsl:with-param name="amount" select="cbc:OutstandingQuantity"/>
											</xsl:call-template>
											</div>
										</xsl:if>
										<xsl:if test="cbc:OutstandingReason"><div class="box-text"><b>Motivo:</b> <xsl:value-of select="cbc:OutstandingReason"/></div></xsl:if>
									</div>
                                </td>
																												
								 <!-- Pericolosità Articolo -->
								 <td class="in-cell-base">
										<div>
                                            <ul style="border:0;margin:0;padding:0">
													<xsl:for-each select="cac:Item/cac:HazardousItem">
														<li style="list-style-type:none;">
															 <xsl:if test="cbc:ID"><div class="box-text"><b>Id:</b> <xsl:value-of select="cbc:ID"/></div></xsl:if> 
															 <div class="box-text"><b>UNDGCode:</b> <xsl:value-of select="cbc:UNDGCode"/></div>
															 <xsl:if test="cbc:TechnicalName"><div class="box-text"><b>Den. Tecnica:</b> <xsl:value-of select="cbc:TechnicalName"/></div></xsl:if>
															 <xsl:if test="cbc:CategoryName"><div class="box-text"><b>Categoria:</b> <xsl:value-of select="cbc:CategoryName"/></div></xsl:if>
															 <div class="box-text"><b>Id. Classe:</b> <xsl:value-of select="cbc:HazardClassID"/></div>
														</li>
													</xsl:for-each>
										   </ul>
									</div>
                                </td>
								
								<!-- Tipo Consegna -->
								 <td class="in-cell-base">
										<div class="box-text">
											<xsl:if test="cac:Shipment/cbc:ID != 'NA'">
												<div><b>Id:</b> <xsl:value-of select="cac:Shipment/cbc:ID"/></div>
											</xsl:if>
                                            <b>Codice trattamento: </b>
											<xsl:if test="cac:Shipment/cbc:HandlingCode">
												<xsl:variable name="handlingCodeVar">
													<xsl:value-of  select="cac:Shipment/cbc:HandlingCode"/>
												</xsl:variable>
												<xsl:value-of select="$handlingCodeVar"/>
												<xsl:for-each select="document($xclHandlingCode)//SimpleCodeList/Row">
													<xsl:if test="Value[@ColumnRef='code']/SimpleValue=$handlingCodeVar">
													- <xsl:value-of select="Value[@ColumnRef='nome']/SimpleValue"/>
													</xsl:if>
												</xsl:for-each>
											</xsl:if>
											
											<xsl:if test="(cac:Shipment/cac:GoodsItem/cac:Temperature) or (cac:Shipment/cac:GoodsItem/cac:MinimumTemperature)or (cac:Shipment/cac:GoodsItem/cac:MaximumTemperature)">
												<div class="margin-top-8"><b>Temperature</b></div>
											</xsl:if>
                                            <xsl:if test="cac:Shipment/cac:GoodsItem/cac:Temperature">
												<div><xsl:value-of select="cac:Shipment/cac:GoodsItem/cac:Temperature/cbc:AttributeID"/>:
													<xsl:call-template name="temperature">
														<xsl:with-param name="temperature" select="cac:Shipment/cac:GoodsItem/cac:Temperature"/>
													</xsl:call-template>
												</div>
											</xsl:if>
                                            <xsl:if test="cac:Shipment/cac:GoodsItem/cac:MinimumTemperature">
												<div><xsl:value-of select="cac:Shipment/cac:GoodsItem/cac:MinimumTemperature/cbc:AttributeID"/> minima:
												<xsl:call-template name="temperature">
														<xsl:with-param name="temperature" select="cac:Shipment/cac:GoodsItem/cac:MinimumTemperature"/>
												</xsl:call-template>
												</div>
											</xsl:if>
											<xsl:if test="cac:Shipment/cac:GoodsItem/cac:MaximumTemperature">
												<div><xsl:value-of select="cac:Shipment/cac:GoodsItem/cac:MaximumTemperature/cbc:AttributeID"/> massima:
												<xsl:call-template name="temperature">
													<xsl:with-param name="temperature" select="cac:Shipment/cac:GoodsItem/cac:MaximumTemperature"/>
												</xsl:call-template>
												</div>
											</xsl:if>
									</div>
                                </td>	
								
								<!-- Codici Imballo -->
								 <td class="in-cell-base">
										<div class="box-text">
                                            <ul style="border:0;margin:0;padding:0">
													<xsl:for-each select="cac:Shipment/cac:TransportHandlingUnit">
														<li style="list-style-type:none;">
															 <xsl:if test="cbc:ID"><div><b>Id:</b> <xsl:value-of select="cbc:ID"/></div></xsl:if>
															 <xsl:if test="cbc:TransportHandlingUnitTypeCode"><div><b>Tipo:</b> <xsl:value-of select="cbc:TransportHandlingUnitTypeCode"/></div></xsl:if>
															 <xsl:if test="cbc:ShippingMarks"><div><b>Marca:</b> <xsl:value-of select="cbc:ShippingMarks"/></div></xsl:if>
															 
															 <xsl:for-each select="cac:TransportHandlingUnit/cac:MeasurementDimension">
																<div class="box-text">
																	<xsl:value-of select="cbc:AttributeID"/>
																	<xsl:if test="cbc:Measure"><xsl:value-of select="cbc:Measure"/></xsl:if>
																</div>
															</xsl:for-each>
														</li>
												</xsl:for-each>
										   </ul>
									</div>
                                </td>

								<!-- Rif. Ordine -->
								<td class="in-cell-base">
									<div class="box-text">
                                            <ul style="border:0;margin:0;padding:0">
													<xsl:for-each select="cac:OrderLineReference">
														<li style="list-style-type:none;">Riga nr. <xsl:value-of select="cbc:LineID"/> - <xsl:value-of select="cac:OrderReference/cbc:ID"/>
															<xsl:if test="cac:OrderReference/cbc:IssuedDate"> data 
																<xsl:call-template name="format-date">
																	<xsl:with-param name="date">
																		<xsl:value-of select="cac:OrderReference/cbc:IssuedDate"/>
																	</xsl:with-param>
																</xsl:call-template>
															</xsl:if>
															<xsl:if test="cac:OrderReference/cbc:DocumentType"> tipo doc. <xsl:value-of select="cac:OrderReference/cbc:DocumentType"/></xsl:if>															
														</li>
													</xsl:for-each>
										   </ul>
									</div>
                                </td>
                           </tr>
						  </xsl:for-each>
                    </tbody>
                </table>
                </div>
				<!-- } DESPATCH LINE -->
				
				
				<!-- SHIPMENT { -->
			   <xsl:if test="/in:DespatchAdvice/cac:Shipment">
			   
				   <div class="page-break">
					<h1>Dettaglio Spedizione</h1>
					<table class="riepilogo-fattura" summary="riepilogo ddt">
					
						<tr class="party-row">
							<td class="in-cell-base">
								<h2 class="in-box-label">Informazioni Generali</h2>
								<div class="box-text">Id. spedizione: <xsl:value-of select="/in:DespatchAdvice/cac:Shipment/cbc:ID"/>
								</div>
								<xsl:if test="/in:DespatchAdvice/cac:Shipment/cbc:Information">
								<div class="box-text">Informazioni/Note: <xsl:value-of select="/in:DespatchAdvice/cac:Shipment/cbc:Information"/>
								</div>
								</xsl:if>
								
								<xsl:if test="/in:DespatchAdvice/cac:Shipment/cbc:GrossWeightMeasure">
									<div class="box-text">
										Peso Lordo: 
										<xsl:call-template name="format-amount">
											<xsl:with-param name="amount" select="/in:DespatchAdvice/cac:Shipment/cbc:GrossWeightMeasure"/>
										</xsl:call-template>
										&#160;
										<xsl:variable name="unitOfMeasureCodeVar">
											<xsl:value-of select="/in:DespatchAdvice/cac:Shipment/cbc:GrossWeightMeasure/@unitCode"/>
										</xsl:variable>
										<xsl:for-each select="document($xclUnitOfMeasureCode)//SimpleCodeList/Row">
											<xsl:if test="Value[@ColumnRef='code']/SimpleValue=$unitOfMeasureCodeVar">
												<xsl:value-of select="Value[@ColumnRef='xname']/SimpleValue"/>
											</xsl:if>
										</xsl:for-each>
									</div>
								</xsl:if>
								<xsl:if test="/in:DespatchAdvice/cac:Shipment/cbc:GrossVolumeMeasure">
									<div class="box-text">
										Volume:
										<xsl:call-template name="format-amount">
											<xsl:with-param name="amount" select="/in:DespatchAdvice/cac:Shipment/cbc:GrossVolumeMeasure"/>
										</xsl:call-template>
										&#160;
										<xsl:variable name="unitOfMeasureCodeVar">
											<xsl:value-of select="/in:DespatchAdvice/cac:Shipment/cbc:GrossVolumeMeasure/@unitCode"/>
										</xsl:variable>
										<xsl:for-each select="document($xclUnitOfMeasureCode)//SimpleCodeList/Row">
											<xsl:if test="Value[@ColumnRef='code']/SimpleValue=$unitOfMeasureCodeVar">
												<xsl:value-of select="Value[@ColumnRef='xname']/SimpleValue"/>
											</xsl:if>
										</xsl:for-each>
									</div>
								</xsl:if>
								<xsl:if test="/in:DespatchAdvice/cac:Shipment/cbc:TotalTransportHandlingUnitQuantity">
								<div class="box-text">Colli: 
									<xsl:call-template name="format-amount">
										<xsl:with-param name="amount" select="/in:DespatchAdvice/cac:Shipment/cbc:TotalTransportHandlingUnitQuantity"/>
									</xsl:call-template>
								</div>
								</xsl:if>
								
							</td>
							
							<xsl:if test="/in:DespatchAdvice/cac:Shipment/cac:Consignment">
								<td class="in-cell-base">
									<h2 class="in-box-label">Dettaglio Trasporto</h2>
									<div class="box-text">Id. consegna: <xsl:value-of select="/in:DespatchAdvice/cac:Shipment/cac:Consignment/cbc:ID"/>
									</div>
									<xsl:if test="/in:DespatchAdvice/cac:Shipment/cbc:Information">
										<div class="box-text">Informazioni/Note: <xsl:value-of select="/in:DespatchAdvice/cac:Shipment/cac:Consignment/cbc:Information"/>
										</div>
									</xsl:if>
									
									<xsl:if test="/in:DespatchAdvice/cac:Shipment/cac:Consignment/cac:CarrierParty">
											<h2 class="in-box-label margin-top-20">Vettore</h2>
											<xsl:call-template name="in-party">
												<xsl:with-param name="party" select="/in:DespatchAdvice/cac:Shipment/cac:Consignment/cac:CarrierParty"/>
											</xsl:call-template>
										</xsl:if>
								</td>
							</xsl:if>
							
							<xsl:if test="/in:DespatchAdvice/cac:Shipment/cac:Delivery">
								<td class="in-cell-base">
									<h2 class="in-box-label">Dettaglio Consegna</h2>
									
									<xsl:if test="/in:DespatchAdvice/cac:Shipment/cac:Delivery/cbc:TrackingID"><div class="box-text"><b>Identificativo: </b><xsl:value-of select="/in:DespatchAdvice/cac:Shipment/cac:Delivery/cbc:TrackingID"/></div></xsl:if>
									
									
									<xsl:if test="/in:DespatchAdvice/cac:Shipment/cac:Delivery/cac:Despatch">
										  <div class="box-text">
											Identificativo del luogo di consegna:
												<xsl:call-template name="format-date">
													<xsl:with-param name="date">
														<xsl:value-of select="/in:DespatchAdvice/cac:Shipment/cac:Delivery/cac:Despatch/cbc:ActualDespatchDate"/>
													</xsl:with-param>
												</xsl:call-template>
											<span style="width: 0.7em; display: inline-block;"/>
											<xsl:value-of select="/in:DespatchAdvice/cac:Shipment/cac:Delivery/cac:Despatch/cbc:ActualDespatchTime"/>
										   </div>  
										   
											<xsl:if test="/in:DespatchAdvice/cac:Shipment/cac:Delivery/cac:Despatch">
											 <div class="box-text">
											 Indirizzo: 
												<xsl:call-template name="postal-address">
													<xsl:with-param name="address" select="/in:DespatchAdvice/cac:Shipment/cac:Delivery/cac:Despatch/cac:DespatchAddress"/>
												</xsl:call-template>
											  </div>	
											</xsl:if>
									</xsl:if>
									<xsl:if test="/in:DespatchAdvice/cac:Shipment/cac:Delivery/cac:EstimatedDeliveryPeriod">
											<div class="box-text">Periodo consegna previsto: dal <xsl:value-of select="/in:DespatchAdvice/cac:Shipment/cac:Delivery/cac:EstimatedDeliveryPeriod/cbc:StartDate"/>
											 al <xsl:value-of select="/in:DespatchAdvice/cac:Shipment/cac:Delivery/cac:EstimatedDeliveryPeriod/cbc:EndDate"/></div>
									</xsl:if>
								</td>
							</xsl:if>
						</tr>
					</table>
					</div>
				</xsl:if>
				
            </body>
        </html>
    </xsl:template>

	
	<xsl:template name="in-id">
		 <xsl:param name="id"/>
			<xsl:if test="$id/cbc:ID">
				<xsl:apply-templates mode="line" select="$id/cbc:ID"/>
			</xsl:if>
			<xsl:if test="$id/cbc:ExtendedID">
				<xsl:apply-templates mode="line" select="$id/cbc:ExtendedID"/>
			</xsl:if>
	</xsl:template>

    <xsl:template name="in-note">
        <span class="box-text">
		<xsl:if test="/in:DespatchAdvice/cbc:Note"> 
            <xsl:apply-templates mode="line" select="/in:DespatchAdvice/cbc:Note"/>
		</xsl:if>
        </span>
    </xsl:template>

	<xsl:template name="temperature">
		 <xsl:param name="temperature"/>
				<xsl:value-of select="$temperature/cbc:Measure"/> 
				<xsl:call-template name="format-temp-unit-measure">
					<xsl:with-param name="um" select="$temperature/cbc:Measure/@unitCode"/>
				</xsl:call-template>
	</xsl:template>
 

	<xsl:template name="party-identification">
		<xsl:param name="identification"/>
		<div class="box-text">
			<xsl:if test="$identification/cbc:ID/@schemeID">
				<xsl:value-of select="$identification/cbc:ID/@schemeID"/>: 
			</xsl:if>
			<xsl:if test="$identification/cbc:ID">
				<xsl:value-of select="$identification/cbc:ID"/>
			</xsl:if>
		</div>
	</xsl:template>
	<xsl:template name="party-name">
		<xsl:param name="name"/>
		<xsl:if test="$name/cbc:Name">
			<xsl:value-of select="$name/cbc:Name"/>
		</xsl:if>
	</xsl:template>
	<xsl:template name="postal-address">
		 <xsl:param name="address"/>
		    <xsl:if test="$address/cbc:ID">
				ID: <xsl:value-of select="$address/cbc:ID"/><br/>
			</xsl:if> 
			<xsl:if test="$address/cbc:StreetName">
				<xsl:value-of select="$address/cbc:StreetName"/> 
			</xsl:if>
			<xsl:if test="$address/cbc:AdditionalStreetName">
				<xsl:value-of select="$address/cbc:AdditionalStreetName"/> 
			</xsl:if>
			<xsl:if test="$address/cbc:PostalZone">
				<xsl:value-of select="$address/cbc:PostalZone"/> 
			</xsl:if>
			<xsl:if test="$address/cbc:CityName">
				<xsl:text>, </xsl:text>
				<xsl:value-of select="$address/cbc:CityName"/> 
			</xsl:if>
			<xsl:if test="$address/cbc:CountrySubentity or $address/cac:Country/cbc:IdentificationCode">
				<xsl:text> (</xsl:text><xsl:value-of select="$address/cbc:CountrySubentity"/><xsl:text> </xsl:text><xsl:value-of select="$address/cac:Country/cbc:IdentificationCode"/>)
			</xsl:if>
	</xsl:template>
	
	<xsl:template name="contact">
		<xsl:param name="contact"/>
		<xsl:if test="$contact/cbc:Name">
			<span style="width:250px;display:inline-block;">Referente: <xsl:value-of select="$contact/cbc:Name"/></span>
		</xsl:if>
		<xsl:if test="$contact/cbc:ElectronicMail">
			<span style="width:250px;display:inline-block;">Email: <xsl:value-of select="$contact/cbc:ElectronicMail"/></span>
		</xsl:if>
		<xsl:if test="$contact/cbc:Telephone">
			<span style="width:150px;display:inline-block;">Telefono: <xsl:value-of select="$contact/cbc:Telephone"/></span>
		</xsl:if>
		<xsl:if test="$contact/cbc:Telefax">
			<span style="width:150px;display:inline-block;">Fax: <xsl:value-of select="$contact/cbc:Telefax"/></span>
		</xsl:if>
	</xsl:template>
	<xsl:template name="person">
		<xsl:param name="person"/>
			<span style="width:250px;display:inline-block;">Id. documento: <xsl:value-of select="$person/cac:IdentityDocumentReference/cbc:ID"/></span>

		<xsl:if test="$person/cac:IdentityDocumentReference/cbc:DocumentType">
			<span style="width:250px;display:inline-block;">Tipo Documento: <xsl:value-of select="$person/cac:IdentityDocumentReference/cbc:DocumentType"/></span>
		</xsl:if>
		
	</xsl:template>
	
	<xsl:template name="party-legal-entity">
		<xsl:param name="legal-entity"/>
		<xsl:if test="$legal-entity/cbc:RegistrationName">
			<xsl:value-of select="$legal-entity/cbc:RegistrationName"/>
		</xsl:if>
		
		<xsl:if test="$legal-entity/cbc:RegistrationName">
			(Reg. Imprese di <xsl:value-of select="document($xclProvinceItaliane)//Value[@ColumnRef='name']/SimpleValue[../../Value[@ColumnRef='code']/SimpleValue=$legal-entity/cac:RegistrationAddress/cbc:CityName]"/> n. <xsl:value-of select="$legal-entity/cbc:CompanyID"/>)
		</xsl:if>
	</xsl:template>
	
	<xsl:template name="party-tax-scheme">
		<xsl:param name="scheme"/>
		<xsl:if test="$scheme/cbc:CompanyID[contains(@schemeID,':VAT')]">
			<span style="width:150px;display:inline-block;">
			P. IVA <xsl:value-of select="$scheme/cbc:CompanyID[contains(@schemeID,':VAT')]"/>
			</span>
		</xsl:if>
	</xsl:template>
	
    <xsl:template name="in-party">
	    <xsl:param name="party"/>
		<xsl:if test="$party/cac:PartyName">
			<div class="box-text">
				<xsl:call-template name="party-name">
					<xsl:with-param name="name" select="$party/cac:PartyName"/>
				</xsl:call-template>
			</div>
		</xsl:if>
		<xsl:call-template name="party-identification">
			<xsl:with-param name="identification" select="$party/cac:PartyIdentification"/>
		</xsl:call-template>
		<xsl:if test="$party/cbc:EndpointID">
			<div class="box-text">
				Identificativo endpoint: <xsl:value-of select="$party/cbc:EndpointID"/>
			</div>
		</xsl:if>
		<xsl:if test="$party/cac:PostalAddress">
			<div class="box-text">
				<xsl:call-template name="postal-address">
					<xsl:with-param name="address" select="$party/cac:PostalAddress"/>
				</xsl:call-template>
			</div>
		</xsl:if>
		<xsl:if test="$party/cac:PartyTaxScheme">
			<div class="box-text">
				<xsl:call-template name="party-tax-scheme">
					<xsl:with-param name="scheme" select="$party/cac:PartyTaxScheme"/>
				</xsl:call-template>
			</div>
		</xsl:if>
		<xsl:if test="$party/cac:PartyLegalEntity">
			<div class="box-text">
				<xsl:call-template name="party-legal-entity">
					<xsl:with-param name="legal-entity" select="$party/cac:PartyLegalEntity"/>
				</xsl:call-template>
			</div>
		</xsl:if>
		<xsl:if test="$party/cac:Contact">
			<div class="box-text">
				<xsl:call-template name="contact">
					<xsl:with-param name="contact" select="$party/cac:Contact"/>
				</xsl:call-template>
			</div>
		</xsl:if>
		<xsl:if test="$party/cac:Person">
			<div class="box-text">
				<xsl:call-template name="person">
					<xsl:with-param name="person" select="$party/cac:Person"/>
				</xsl:call-template>
			</div>
		</xsl:if>
	</xsl:template>
	
	<xsl:template name="format-amount">
		<xsl:param name="amount"/>
		<xsl:if test="$amount and $amount != ''">
			<span nowrap="nowrap">
			   <xsl:value-of select="format-number($amount, '#.##0,##########', 'number')"/>
			</span>
		</xsl:if>
    </xsl:template>
	
	<xsl:template name="format-date">
		<xsl:param name="date"/>
		<xsl:if test="$date and $date != ''">
	        <xsl:value-of select="format-date($date, '[D01]/[M01]/[Y0001]')"/>
		</xsl:if>
	</xsl:template>
	
	<xsl:template name="format-temp-unit-measure">
        <xsl:param name="um"/>
		<xsl:choose>
			<xsl:when test="$um = 'CEL'">
				&#8451;
			</xsl:when>
			<xsl:when test="$um = 'FAR'">
				&#8457;
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$um"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
</xsl:stylesheet>