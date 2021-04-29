<!-- 
    Descrizione documento:      Foglio di stile per Ordine italiano UBL 2.1 PEPPOL BIS 3
    Versione : 			     	1.2
    Prodotto il :               Giugno 2020
    Prodotto da :             	Intercent-ER
    Ambito:  	                Intercent-ER - Piloti Peppol
 -->
<xsl:stylesheet xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:cac="urn:oasis:names:specification:ubl:schema:xsd:CommonAggregateComponents-2"
    xmlns:cbc="urn:oasis:names:specification:ubl:schema:xsd:CommonBasicComponents-2"
    xmlns:in="urn:oasis:names:specification:ubl:schema:xsd:Order-2"
    xmlns:ext="urn:oasis:names:specification:ubl:schema:xsd:CommonExtensionComponents-2"
    xmlns:cr="http://www.ubl-italia.org/ns/CrossReference" version="2.0" exclude-result-prefixes="cac cbc in">
    <xd:doc xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl" scope="stylesheet">
        <xd:desc>
            <xd:p>
                <xd:b>Created on:</xd:b>
Jun 30, 2020
            </xd:p>
            <xd:p>
                <xd:b>Author:</xd:b>
Intercent-ER
            </xd:p>
            <xd:p/>
        </xd:desc>
    </xd:doc>
    <xsl:param name="xclUnitOfMeasureCode"/>
    <xsl:param name="xclPaymentMeansCode"/>
    <xsl:param name="xclProvinceItaliane"/>
    <xsl:param name="xclOrderTypeCode"/>
    <xsl:decimal-format name="number" decimal-separator="," grouping-separator="."/>
    <xsl:template match="/">
        <html>
            <head>
                <title>ORDINE</title>
                <style type="text/css"> 
                    /* general text properties */ 
                    .in-body { font-family: serif } 
                    .in-box-label { font-family: "Arial", sans-serif; font-style:italic; font-size:72%; margin-left: 1pt; margin-right:1pt; margin-top:1pt } 
                    .box-text { font-family: "Arial", sans-serif; font-size:70%; line-height:15pt; margin-left: 1pt; margin-right:1pt } 
                    .title-text { font-family:"Arial", sans-serif; font-weight:bold; font-size:90%; margin-left:10pt; } 
                    .subtitle-text { font-family:"Arial", sans-serif; font-weight:bold; font-size:80%; margin-left: 1pt; margin-right:1pt } 
                    .in-table { border-collapse:collapse; border-color: #000000; table-layout:CHANGED (24-09-2019, @author "Manuel Gozzi") } 
                    .in-form-column { width:8.33% } .in-counter-cell { border:none } .in-cell-data { margin-top:0pt; margin-bottom:0pt } 
                    .in-cell-data-background { } .in-cell-data-center { text-align:center } .in-cell-base { border:solid; border-width:1pt } 
                    .in-cell-end-override { border-right-style:none } .in-cell-after-override { border-bottom-style:none } 
                    .in-cell-line-background { background-color:#b8b8b8; font-weight:bold } 
                    .in-cell-filler-background { background-color:#e8e8e8 } 
                    .CHANGED (24-09-2019, @author "Manuel Gozzi")-height{ min-height: 40px; display:block; } 
                    .law-warning{ font-style: italic; font-size: 70%; } .border-left{ border-left: 1px solid; } 
                    .no-bottom-border{ border-bottom: none; } .allowance-charge{ list-style-type: none; padding: 0px; margin: 0px; } 
                    .allowance-charge LI{ } 
                    H1{ font-size:120%; font-family: "Arial", sans-serif; } 
                    H2{ font-family: "Arial", sans-serif; font-size:100%; } 
                    H3{ font-size:90%; } 
                    .padded{ padding-top:20px; padding-bottom:10px; display:block; } 
                    .riepilogo-fattura{ width:100%; border:1px solid black; padding: 0; margin: 0; border-spacing: 0; border-collapse: collapse; } 
                    .dati-fattura{ width:100%; height:150px; border: none; padding: 0; margin: 0; border-spacing: 0; border-collapse: collapse; } 
                    .dati-documento{ width:100%; height:50px; border: none; padding: 0; margin: 0; border-spacing: 0; border-collapse: collapse; } 
                    .no-border{ border:0 !important; } .riepilogo-fattura TD{ border:1px solid black; padding: 0; margin: 0; vertical-align: top; } 
                    .party-row{ height:150px; } .h50{ height: 50px; } .h80{ height: 80px; } .h100px{ height: 100px; } 
                    .border-bottom{ border-bottom:1px solid black !important; } .border-right{ border-right:1px solid black !important; } 
                    .border-left{ border-left:1px solid black !important; } .party-column{ width:50%; } 
                    .riepilogo-PDC{ width:100%; border:1px solid black; padding: 0; margin: 0; border-spacing: 0; border-collapse: collapse; } 
                    .riepilogo-PDC TH{ font-family: "Arial", sans-serif; font-size:70%; font-style:italic; border-right:1px solid black; height:30px; } 
                    .w-50 { width:50%; } 
                    .w-66 { width:67%; } 
                    .w-90 { width:90%; } 
                    .w-33 { width:33%; } 
                    .w-40{ width:40%; } 
                    .w-30{ width:30%; } 
                    .w-25{ width:25%; } 
                    .w-15{ width:15%; } 
                    .w-10{ width:10%; } 
                    .w-5{ width:5%; } 
                    .w-100{ width:100%; } 
                    .righe-fattura{ width:100%; border:1px solid black; padding: 0; margin: 0; border-spacing: 0; border-collapse: collapse; } 
                    .righe-fattura TH{ font-family: "Arial", sans-serif; font-size:70%; font-style:italic; border-right:1px solid black; height:30px; } 
                    .empty-cell-filler{ height: 1.5em; } 
                    .page-break{ page-break-inside:avoid } 
                    table { page-break-inside:auto } 
                    tr { page-break-inside:avoid; page-break-after:auto } 
                    thead { display:table-header-group } 
                    tfoot { display:table-footer-group } 
                    .block{ display:block; } 
                    .h100{ height:100%; } 
                    .attachment-list{ list-style-type: none; } 
                    .floatright{ float:right; } 
                    .float-right{ float:right; margin-top:20px; clear:both; } 
                    .float-right-last{ float:right; margin-bottom: 30px; display:block; clear:both; } 
                    .nowraptext{ white-space: nowrap; word-break: break-all; } 
                    .bold{ font-weight:bold; } 
                    .margin-right{ margin-right:20px; } 
                    .header-linea{ padding-top: 5px; padding-bottom:3px; margin:0; } 
                    .no-margin{ margin:0; padding:0; } 
                    .font-size-80 { font-size: 80%; } </style>
            </head>
            <body class="in-body">
                <div class="page-break">
                    <h1>Ordine</h1>
                    <!--  CHANGED (24-09-2019, @author "Manuel Gozzi"): togliere "Rappresentazione UBL ver. " e inserire "Rappresentazione UBL ver. PEPPOL BIS 3.0"  -->
                    <h2>Rappresentazione UBL PEPPOL BIS 3</h2>
                    <div class="box-text">
                        CustomizationID: <xsl:value-of select="/in:Order/cbc:CustomizationID"/>
                    <br />
                        ProfileID: <xsl:value-of select="/in:Order/cbc:ProfileID"/>
                </div>
                <table class="riepilogo-fattura" summary="riepilogo fattura">
                    <tr class="party-row">
                        <td class="party-column">
                            <h2 class="in-box-label">Acquirente</h2>
                            <xsl:call-template name="in-party">
                                <xsl:with-param name="party" select="/in:Order/cac:BuyerCustomerParty/cac:Party"/>
                            </xsl:call-template>
                        </td>
                        <td>
                            <table class="dati-fattura" summary="dati fattura">
                                <tr class="dati-fattura-row dati-fattura-border">
                                    <td class="no-border border-right border-bottom h100px w-33 in-cell-filler-background">
                                        <h2 class="in-box-label">Numero ordine</h2>
                                        <xsl:call-template name="in-id"/>
                                    </td>
                                    <td class="no-border border-right border-bottom h100px w-33 in-cell-filler-background">
                                        <h2 class="in-box-label">Data ordine</h2>
                                        <span class="box-text">
                                            <xsl:call-template name="format-date">
                                                <xsl:with-param name="date">
                                                    <xsl:value-of select="/in:Order/cbc:IssueDate"/>
                                                </xsl:with-param>
                                            </xsl:call-template>
                                            <!--  CHANGED (24-09-2019, @author "Manuel Gozzi"): aggiunto "cbc:IssueTime", come parametro opzionale  -->
                                            <xsl:if test="/in:Order/cbc:IssueTime">
ora
                                                <xsl:value-of select="/in:Order/cbc:IssueTime"/>
                                            </xsl:if>
                                        </span>
                                    </td>
                                    <td class="no-border border-bottom h100px w-33 in-cell-filler-background">
                                        <h2 class="in-box-label">Valuta</h2>
                                        <xsl:call-template name="in-currency"/>
                                    </td>
                                </tr>
                            </table>
                            <table class="dati-fattura h80">
                                <tr>
                                    <td class="no-border border-bottom w-100">
                                        <h2 class="in-box-label">Tipo ordinazione</h2>

                                        <div class="box-text">

                                            <xsl:choose>
                                                <xsl:when test="/in:Order/cbc:OrderTypeCode = '227'">
                                                    <xsl:call-template name="order-type">
                                                        <xsl:with-param name="description" select='"Ordine di consegna (227"'/>
                                                    </xsl:call-template>
                                                </xsl:when>
                                                <xsl:otherwise>
                                                    <xsl:call-template name="order-type">
                                                        <xsl:with-param name="description" select='"Ordine di acquisto (220"'/>
                                                    </xsl:call-template>
                                                </xsl:otherwise>
                                            </xsl:choose>

                                        </div>
                                    </td>
                                </tr>
                            </table>

                            <table class="dati-fattura h80">
                                <tr>
                                    <td class="no-border border-bottom w-100">
                                        <h2 class="in-box-label">Tipo documento</h2>

                                        <div class="box-text">

                                            <xsl:choose>
                                                <xsl:when test="contains(/in:Order/cac:OrderDocumentReference/cbc:ID, 'Cancelled')">
                                                    <span>ORDINE DI REVOCA</span>
                                                </xsl:when>
                                                <xsl:when test="contains(/in:Order/cac:OrderDocumentReference/cbc:ID, 'Revised')">
                                                    <span>ORDINE SOSTITUTIVO</span>
                                                </xsl:when>
                                                <xsl:when test="contains(/in:Order/cac:OrderDocumentReference/cbc:ID, 'Connected')">
                                                    <span>ORDINE COLLEGATO</span>
                                                </xsl:when>
                                                <xsl:when test="contains(/in:Order/cac:OrderDocumentReference/cbc:ID, 'Invoice')">
                                                    <span>ORDINE CONVALIDA</span>
                                                </xsl:when>
                                                <xsl:otherwise>ORDINE INIZIALE</xsl:otherwise>
                                            </xsl:choose>
                                        </div>
                                    </td>
                                </tr>
                            </table>
                            <table class="dati-fattura">
                                <tr>
                                    <td class="no-border border-right w-33 h100px">
                                        <h2 class="in-box-label">Ordine precedente</h2>
                                        <!--  CHANGED (24-09-2019, @author "Manuel Gozzi"): rimossi stato, tipo, data  -->
                                        <xsl:if test="/in:Order/cac:OrderDocumentReference">
                                            <div class="box-text">
Numero:
                                                <xsl:value-of select="/in:Order/cac:OrderDocumentReference/cbc:ID"/>
                                            </div>
                                        </xsl:if>
                                    </td>
                                    <td class="no-border border-right w-33 h100px">
                                        <!--  CHANGED (24-09-2019, @author "Manuel Gozzi"): rimosso "Documento che ha originato l'ordine", inserito nuovo valore  -->
                                        <h2 class="in-box-label">Codice identificativo gara (CIG)</h2>
                                        <!--  CHANGED (24-09-2019, @author "Manuel Gozzi"): rimossi tipo, data  -->
                                        <xsl:if test="/in:Order/cac:OriginatorDocumentReference">
                                            <div class="box-text">
                                                <!--  CHANGED (24-09-2019, @author "Manuel Gozzi"): rimosso "Numero"  -->
                                                <xsl:value-of select="/in:Order/cac:OriginatorDocumentReference/cbc:ID"/>
                                            </div>
                                        </xsl:if>
                                    </td>
                                    <td class="no-border w-33 h100px">
                                        <h2 class="in-box-label">Contratto</h2>
                                        <xsl:if test="/in:Order/cac:Contract">
                                            <div class="box-text">
Numero:
                                                <xsl:value-of select="/in:Order/cac:Contract/cbc:ID"/>
                                            </div>
                                            <!--  CHANGED (24-09-2019, @author "Manuel Gozzi"): rimosso il tipo di contratto  -->
                                        </xsl:if>
                                    </td>
                                </tr>
                            </table>
                        </td>
                    </tr>
                    <tr class="party-row">
                        <td>
                            <h2 class="in-box-label">Fornitore</h2>
                            <xsl:call-template name="in-party">
                                <xsl:with-param name="party" select="/in:Order/cac:SellerSupplierParty/cac:Party"/>
                            </xsl:call-template>
                        </td>
                        <td>
                            <table class="dati-fattura" summary="Note e riferimento amministrativo">
                                <tr>
                                    <td class="no-border border-right w-33 border-bottom">
                                        <h2 class="in-box-label">Centro di costo</h2>
                                        <div class="box-text">
                                            <xsl:value-of select="/in:Order/cbc:AccountingCost"/>
                                        </div>
                                    </td>
                                    <td class="no-border border-right w-33 border-bottom">
                                        <h2 class="in-box-label">Data di scadenza</h2>
                                        <div class="box-text">
                                            <xsl:call-template name="format-date">
                                                <xsl:with-param name="date">
                                                    <xsl:value-of select="/in:Order/cac:ValidityPeriod/cbc:EndDate"/>
                                                </xsl:with-param>
                                            </xsl:call-template>
                                        </div>
                                    </td>
                                    <td class="no-border w-33 border-bottom">
                                        <h2 class="in-box-label">Termini di pagamento</h2>
                                        <span class="box-text">
                                            <xsl:value-of select="/in:Order/cac:PaymentTerms/cbc:Note"/>
                                        </span>
                                    </td>
                                </tr>
                                <tr class="dati-fattura-row h80">
                                    <td class="no-border" colspan="3">
                                        <h2 class="in-box-label">Note</h2>
                                        <xsl:call-template name="in-note"/>
                                    </td>
                                </tr>
                            </table>
                        </td>
                    </tr>
                    <tr class="h50">
                        <td>
                            <h2 class="in-box-label">Committente (Ufficio Ordinante)</h2>
                            <xsl:call-template name="in-party">
                                <xsl:with-param name="party" select="/in:Order/cac:OriginatorCustomerParty/cac:Party"/>
                            </xsl:call-template>
                        </td>
                        <td class="h50">
                            <table class="dati-documento h100" summary="Dati ordine e contratto">
                                <tr>
                                    <td class="w-66 no-border border-right h50">
                                        <h2 class="in-box-label">Informazioni sulla consegna</h2>
                                        <xsl:call-template name="delivery">
                                            <xsl:with-param name="del" select="/in:Order/cac:Delivery"/>
                                        </xsl:call-template>
                                    </td>
                                    <td class="w-33 no-border h50">
                                        <h2 class="in-box-label">Termini di consegna</h2>
                                        <span class="box-text">
                                            <xsl:if test="/in:Order/cac:DeliveryTerms/cac:DeliveryLocation">
                                                <xsl:value-of select="/in:Order/cac:DeliveryTerms/cac:DeliveryLocation"/>
                                            </xsl:if>
                                        </span>
                                    </td>
                                </tr>
                            </table>
                        </td>
                    </tr>
                    <tr class="h50">
                        <td>
                            <h2 class="in-box-label">Intestatario Fattura</h2>
                            <xsl:call-template name="in-party">
                                <xsl:with-param name="party" select="/in:Order/cac:AccountingCustomerParty/cac:Party"/>
                            </xsl:call-template>
                        </td>
                        <td>
                            <h2 class="in-box-label">Altri Riferimenti</h2>
                            <xsl:for-each select="/in:Order/cac:AdditionalDocumentReference">
                                <div class="box-text">
                                    <xsl:choose>

                                        <xsl:when test="cbc:DocumentType">
                                            <xsl:value-of select="cbc:DocumentType"/>
                                            <xsl:text>:</xsl:text>
                                            <xsl:value-of select="cbc:ID"/>
                                        </xsl:when>

                                        <xsl:otherwise>
                                            <xsl:text>Id doc.:</xsl:text>
                                            <xsl:value-of select="cbc:ID"/>
                                        </xsl:otherwise>
                                    </xsl:choose>
                                    <xsl:if test="cac:Attachment">
- contiene allegato
                                        <xsl:if test="cac:Attachment/cac:ExternalReference">
                                            <xsl:text> (</xsl:text>
                                            <xsl:value-of select="cac:Attachment/cac:ExternalReference/cbc:URI"/>
                                            <xsl:text>)</xsl:text>
                                        </xsl:if>
                                    </xsl:if>
                                </div>
                            </xsl:for-each>
                        </td>
                    </tr>
                </table>
            </div>
            <div class="page-break">
                <h1>Righe ordine</h1>
                <table class="righe-fattura" summary="righe fattura">
                    <thead>
                        <tr>
                            <th scope="col" class="in-cell-filler-background">Nome/Descrizione/Note</th>
                            <th scope="col" class="in-cell-filler-background">Cod. Articolo Fornitore</th>
                            <th scope="col" class="in-cell-filler-background">Cod. Articolo Standard</th>
                            <th scope="col" class="in-cell-filler-background">Quantità</th>
                            <th scope="col" class="in-cell-filler-background">UdM</th>
                            <th scope="col" class="in-cell-filler-background">Quantità per Confezione</th>
                            <th scope="col" class="in-cell-filler-background">Consegna</th>
                            <th scope="col" class="in-cell-filler-background">Informazioni Articolo</th>
                            <!--  CHANGED (24-09-2019, @author "Manuel Gozzi"): rimossa la dicitura "Contratto"  -->
                            <th scope="col" class="in-cell-filler-background">Documento</th>
                            <th scope="col" class="in-cell-filler-background">Centro di Costo</th>
                            <th scope="col" class="in-cell-filler-background">Prezzo Unitario</th>
                            <th scope="col" class="in-cell-filler-background">Sconti / Maggiorazioni</th>
                            <th scope="col" class="in-cell-filler-background">Imponibile</th>
                            <th scope="col" class="in-cell-filler-background">IVA %</th>
                            <!--  CHANGED (24-09-2019, @author "Manuel Gozzi"): rimuovere la colonna "Imposte"  -->
                            <!--  CHANGED (24-09-2019, @author "Manuel Gozzi"): aggiungere colonna "lotto"  -->
                            <th scope="col" class="in-cell-filler-background">Lotto</th>
                        </tr>
                    </thead>
                    <tbody>
                        <xsl:for-each select="/in:Order/cac:OrderLine">
                            <tr>
                                <!--  Nome/Descrizione/Note  -->
                                <td class="in-cell-base">
                                    <div class="box-text">
                                        <div class="no-margin">
                                            <div>
                                                <xsl:value-of select="cac:LineItem/cac:Item/cbc:Name"/>
                                            </div>
                                            <div>
                                                <xsl:value-of select="cac:LineItem/cac:Item/cbc:Description"/>
                                            </div>
                                            <div>
                                                <xsl:value-of select="cbc:Note"/>
                                            </div>
                                            <xsl:if test="cac:LineItem/cac:OriginatorParty">
                                                <div>
Ordine effettuato da:
                                                    <xsl:value-of select="cac:LineItem/cac:OriginatorParty/cac:PartyName/cbc:Name"/>
(
                                                    <xsl:value-of select="cac:LineItem/cac:OriginatorParty/cac:PartyIdentification/cbc:ID"/>
)
                                                </div>
                                            </xsl:if>
                                            <xsl:if test="cac:LineItem/cac:Item/cac:ItemSpecificationDocumentReference">
                                                <div>
Riferimenti documentali:
                                                    <ul style="border:0;margin:0;padding:0">
                                                        <xsl:for-each select="cac:LineItem/cac:Item/cac:ItemSpecificationDocumentReference">
                                                            <li style="list-style-type:none;">
                                                                <xsl:value-of select="cbc:ID"/>
                                                            </li>
                                                        </xsl:for-each>
                                                    </ul>
                                                </div>
                                            </xsl:if>
                                            <xsl:if test="cac:LineItem/cac:Item/cac:CommodityClassification">
                                                <div>
Categoria merceologica:
                                                    <ul style="border:0;margin:0;padding:0">
                                                        <xsl:for-each select="cac:LineItem/cac:Item/cac:CommodityClassification">
                                                            <li style="list-style-type:none;">
                                                                <xsl:value-of select="cbc:ItemClassificationCode"/>
                                                            </li>
                                                        </xsl:for-each>
                                                    </ul>
                                                </div>
                                            </xsl:if>
                                            <xsl:if test="cac:LineItem/cbc:PartialDeliveryIndicator">
                                                <span nowrap="nowrap">
Consegna parziale:
                                                    <xsl:if test="cac:LineItem/cbc:PartialDeliveryIndicator eq 'true'"> si </xsl:if>
                                                    <xsl:if test="cac:LineItem/cbc:PartialDeliveryIndicator eq 'false'"> no </xsl:if>
                                                </span>
                                            </xsl:if>
                                        </div>
                                    </div>
                                </td>
                                <!--  Cod. art. fornitore  -->
                                <td class="in-cell-base">
                                    <div class="box-text">
                                        <xsl:value-of select="cac:LineItem/cac:Item/cac:SellersItemIdentification/cbc:ID"/>
                                    </div>
                                </td>
                                <!--  Cod. art. standard  -->
                                <td class="in-cell-base">
                                    <div class="box-text">
                                        <xsl:value-of select="cac:LineItem/cac:Item/cac:StandardItemIdentification/cbc:ID"/>
                                        <!--  CHANGED (24-09-2019, @author "Manuel Gozzi"): rimosso "schemaID"  -->
                                    </div>
                                </td>
                                <!--  Quantità  -->
                                <td class="in-cell-base in-cell-data-center">
                                    <div class="box-text" align="right">
                                        <xsl:value-of select="cac:LineItem/cbc:Quantity"/>
                                    </div>
                                </td>
                                <!--  UdM  -->
                                <td class="in-cell-base in-cell-data-center">
                                    <div class="box-text">
                                        <!--  TODO: verificare l'aggiornamento delle code list su NoTI-ER  -->
                                        <xsl:value-of select="if (document($xclUnitOfMeasureCode)//Value[@ColumnRef='xname']/SimpleValue[../../Value[@ColumnRef='code']/SimpleValue=current()/cac:LineItem/cbc:Quantity/@unitCode]) then document($xclUnitOfMeasureCode)//Value[@ColumnRef='xname']/SimpleValue[../../Value[@ColumnRef='code']/SimpleValue=current()/cac:LineItem/cbc:Quantity/@unitCode][1] else cac:LineItem/cbc:Quantity/@unitCode"/>
                                    </div>
                                </td>
                                <!--  Quantità per confezione  -->
                                <td class="in-cell-base in-cell-data-center">
                                    <div class="box-text">
                                        <xsl:for-each select="cac:LineItem/cac:Item/cac:AdditionalItemProperty">
                                            <xsl:if test="((./cbc:Name = 'PackQuantity') or (./cbc:Name = 'PackSizeNumeric'))">
                                                <li style="list-style-type:none;">
                                                    <xsl:value-of select="cbc:Value"/>
                                                </li>
                                            </xsl:if>
                                        </xsl:for-each>
                                    </div>
                                </td>
                                <!--  Periodo di consegna  -->
                                <td class="in-cell-base in-cell-data-center">
                                    <xsl:if test="cac:LineItem/cac:Delivery/cbc:ID">
                                        <div class="box-text">
                                        Id.: <xsl:value-of select="cac:LineItem/cac:Delivery/cbc:ID"/>
                                        </div>
                                    </xsl:if>
                                    <xsl:if test="cac:LineItem/cac:Delivery/cac:RequestedDeliveryPeriod">
                                        <div class="box-text">
                                            Periodo di consegna:
                                            <xsl:call-template name="format-date">
                                                <xsl:with-param name="date">
                                                    <xsl:value-of select="cac:LineItem/cac:Delivery/cac:RequestedDeliveryPeriod/cbc:StartDate"/>
                                                </xsl:with-param>
                                            </xsl:call-template>
                                            <xsl:if test="cac:LineItem/cac:Delivery/cac:RequestedDeliveryPeriod/cbc:StartDate and cac:LineItem/cac:Delivery/cac:RequestedDeliveryPeriod/cbc:EndDate"> - </xsl:if>
                                            <xsl:call-template name="format-date">
                                                <xsl:with-param name="date">
                                                    <xsl:value-of select="cac:LineItem/cac:Delivery/cac:RequestedDeliveryPeriod/cbc:EndDate"/>
                                                </xsl:with-param>
                                            </xsl:call-template>
                                        </div>
                                    </xsl:if>
                                </td>
                                <!--  Informazioni Articolo  -->
                                <td class="in-cell-base in-cell-data-center">
                                    <xsl:if test="cac:LineItem/cac:Item/cac:AdditionalItemProperty">
                                        <div class="box-text">
                                            <ul style="border:0;margin:0;padding:0">
                                                <xsl:for-each select="cac:LineItem/cac:Item/cac:AdditionalItemProperty">
                                                    <xsl:if test="(not(./cbc:Name = 'PackQuantity') and not(./cbc:Name = 'PackSizeNumeric'))">
                                                        <li style="list-style-type:none;">
                                                            <xsl:value-of select="cbc:Value"/>
                                                        </li>
                                                    </xsl:if>
                                                </xsl:for-each>
                                            </ul>
                                        </div>
                                    </xsl:if>
                                </td>
                                <!--  Documento  -->
                                <td class="in-cell-base in-cell-data-center">
                                    <!--  CHANGED (24-09-2019, @author "Manuel Gozzi"): rimuovere cac:DocumentReference e inserire ItemSpecificationDocumentReference / ID; parsare (?)  -->
                                    <!--  CHANGED (24-09-2019, @author "Manuel Gozzi"): lascio commentato il vecchio codice, così da
                                        poter verificare il funzionamento  -->
                                    <xsl:if test="cac:LineItem/cac:Item/cac:ItemSpecificationDocumentReference">
                                        <div class="box-text" align="left" style="min-width: 100px">
                                            <xsl:for-each select="cac:LineItem/cac:Item/cac:ItemSpecificationDocumentReference">
Id doc.:
                                                <xsl:value-of select="cbc:ID"/>
                                                <br/>
                                                <!--  Tipo doc.:<xsl:value-of select="cbc:DocumentType"/><br/>
												<xsl:if test="cbc:IssueDate">
													Data:
													<xsl:call-template name="format-date">
														<xsl:with-param name="date">
															<xsl:value-of select="cbc:IssueDate"/>
														</xsl:with-param>
													</xsl:call-template>
												</xsl:if>  -->
                                            </xsl:for-each>
                                        </div>
                                    </xsl:if>
                                </td>
                                <!--  Centro di costo  -->
                                <td class="in-cell-base">
                                    <div class="box-text">
                                        <xsl:value-of select="cac:LineItem/cbc:AccountingCost"/>
                                    </div>
                                </td>
                                <!--  Prezzo  -->
                                <td class="in-cell-base in-cell-data-center">
                                    <div class="box-text" align="right">
                                        <xsl:if test="cac:LineItem/cac:Price/cbc:BaseQuantity">
                                            <xsl:text>(per </xsl:text>
                                            <xsl:value-of select="cac:LineItem/cac:Price/cbc:BaseQuantity"/>
                                            <xsl:text>) </xsl:text>
                                        </xsl:if>
                                        <xsl:call-template name="format-amount-nofloat">
                                            <xsl:with-param name="amount">
                                                <xsl:value-of select="cac:LineItem/cac:Price/cbc:PriceAmount"/>
                                            </xsl:with-param>
                                        </xsl:call-template>

                                    </div>
                                </td>
                                <!--  Sconti / Magg.  -->
                                <td class="in-cell-base in-cell-data-center">
                                    <div class="box-text" align="right">
                                        <ul class="allowance-charge">
                                            <xsl:if test="cac:LineItem/cac:AllowanceCharge">
                                                <li>
                                                    <xsl:value-of select="cac:LineItem/cac:AllowanceCharge/cbc:AllowanceChargeReason"/>
                                                    <xsl:text>: </xsl:text>
                                                    <xsl:if test="cac:LineItem/cac:AllowanceCharge/cbc:ChargeIndicator eq 'false'"> Sconto </xsl:if>
                                                    <xsl:if test="cac:LineItem/cac:AllowanceCharge/cbc:ChargeIndicator eq 'true'"> Maggiorazione </xsl:if>
                                                    <!--  CHANGED (24-09-2019, @author "Manuel Gozzi"): aggiungere la percentuale (cbc:MultiplierFactorNumeric), tenendo conto che è opzionale  -->
                                                    <xsl:if test="cac:LineItem/cac:AllowanceCharge/cbc:MultiplierFactorNumeric">
                                                        <xsl:text>(</xsl:text>
                                                        <xsl:value-of select="cac:LineItem/cac:AllowanceCharge/cbc:MultiplierFactorNumeric"/>
                                                        <xsl:text>%): </xsl:text>
                                                    </xsl:if>

                                                    <xsl:call-template name="format-amount-nofloat">
                                                        <xsl:with-param name="amount">
                                                            <xsl:value-of select="cac:LineItem/cac:AllowanceCharge/cbc:Amount"/>
                                                        </xsl:with-param>
                                                    </xsl:call-template>
                                                    <xsl:if test="cac:LineItem/cac:AllowanceCharge/cbc:BaseAmount">
su
                                                        <xsl:call-template name="format-amount-nofloat">
                                                            <xsl:with-param name="amount">
                                                                <xsl:value-of select="cac:LineItem/cac:AllowanceCharge/cbc:BaseAmount"/>
                                                            </xsl:with-param>
                                                        </xsl:call-template>
                                                    </xsl:if>
                                                </li>
                                            </xsl:if>
                                            <xsl:if test="cac:LineItem/cac:Price/cac:AllowanceCharge">
                                                <li>
                                                    <xsl:if test="cac:LineItem/cac:Price/cac:AllowanceCharge/cbc:AllowanceChargeReason">
                                                        <xsl:value-of select="cac:LineItem/cac:Price/cac:AllowanceCharge/cbc:AllowanceChargeReason"/>
                                                        <xsl:text>:</xsl:text>
                                                    </xsl:if>

                                                    <xsl:if test="cac:LineItem/cac:Price/cac:AllowanceCharge/cbc:ChargeIndicator eq 'false'"> Sconto </xsl:if>
                                                    <xsl:if test="cac:LineItem/cac:Price/cac:AllowanceCharge/cbc:ChargeIndicator eq 'true'"> Maggiorazione </xsl:if>
                                                    <!--  CHANGED (24-09-2019, @author "Manuel Gozzi"): ripetere l'aggiunta della percentuale (cbc:MultiplierFactorNumeric),
                                                    tenendo conto che è opzionale  -->
                                                    <xsl:call-template name="format-amount-nofloat">
                                                        <xsl:with-param name="amount">
                                                            <xsl:value-of select="cac:LineItem/cac:Price/cac:AllowanceCharge/cbc:Amount"/>
                                                        </xsl:with-param>
                                                    </xsl:call-template>
                                                    <xsl:if test="cac:LineItem/cac:Price/cac:AllowanceCharge/cbc:BaseAmount">
su
                                                        <xsl:call-template name="format-amount-nofloat">
                                                            <xsl:with-param name="amount">
                                                                <xsl:value-of select="cac:LineItem/cac:Price/cac:AllowanceCharge/cbc:BaseAmount"/>
                                                            </xsl:with-param>
                                                        </xsl:call-template>
                                                    </xsl:if>
                                                </li>
                                            </xsl:if>
                                        </ul>
                                    </div>
                                </td>
                                <!--  Imponibile  -->
                                <td class="in-cell-base in-cell-data-center">
                                    <div class="box-text" align="right">
                                        <xsl:call-template name="format-amount">
                                            <xsl:with-param name="amount">
                                                <xsl:value-of select="cac:LineItem/cbc:LineExtensionAmount"/>
                                            </xsl:with-param>
                                        </xsl:call-template>
                                    </div>
                                </td>
                                <!--  IVA  -->
                                <td class="in-cell-base in-cell-data-center">
                                    <xsl:if test="cac:LineItem/cac:Item/cac:ClassifiedTaxCategory/cbc:Percent">
                                        <div class="box-text" align="right">
                                            <xsl:value-of select="cac:LineItem/cac:Item/cac:ClassifiedTaxCategory/cbc:Percent"/>
                                        </div>
                                    </xsl:if>
                                </td>
                                <!--  Imposte  -->
                                <!--  CHANGED (24-09-2019, @author "Manuel Gozzi"): rimossa cella "Imposte"  -->
                                <!--  CHANGED (24-09-2019, @author "Manuel Gozzi"): aggiungere cella "lotto/seriale"  -->
                                <!--  Lotto  -->
                                <td class="in-cell-base in-cell-data-center">
                                    <div class="box-text" align="right">
                                        <xsl:value-of select="cac:LineItem/cac:Item/cac:ItemInstance/cac:LotIdentification"/>
                                    </div>
                                </td>
                            </tr>
                        </xsl:for-each>
                    </tbody>
                </table>
            </div>
            <xsl:if test="/in:Order/cac:AllowanceCharge">
                <div class="page-break">
                    <h1>Sconti/Maggiorazioni sull'ordine</h1>
                    <table id="allowance-charge" class="riepilogo-PDC w-50" summary="Subtotali">
                        <thead>
                            <tr>
                                <th scope="col" class="w-90 in-cell-filler-background">Motivazione</th>
                                <th scope="col" class="in-cell-filler-background">Importo</th>
                            </tr>
                        </thead>
                        <tbody>
                            <xsl:for-each select="/in:Order/cac:AllowanceCharge">
                                <tr>
                                    <td class="in-cell-base in-cell-data-center">
                                        <div class="box-text" align="left">
                                            <xsl:value-of select="cbc:AllowanceChargeReason"/>
                                        </div>
                                    </td>
                                    <td class="in-cell-base in-cell-data-center" style="min-width: 115px">
                                        <span class="box-text">
                                            <!--  CHANGED (24-09-2019, @author "Manuel Gozzi"): aggiunto moltiplicatore (%)  -->
                                            <xsl:if test="cbc:ChargeIndicator eq 'false'"> Sconto </xsl:if>
                                            <xsl:if test="cbc:ChargeIndicator eq 'true'"> Maggiorazione </xsl:if>
                                            <xsl:if test="cbc:MultiplierFactorNumeric">
                                                <xsl:text>(</xsl:text>
                                                <xsl:value-of select="cbc:MultiplierFactorNumeric"/>
                                                <xsl:text>%)</xsl:text>
                                            </xsl:if>
                                            <xsl:text>: </xsl:text>
                                            <xsl:call-template name="format-amount">
                                                <xsl:with-param name="amount">
                                                    <xsl:value-of select="cbc:Amount"/>
                                                </xsl:with-param>
                                            </xsl:call-template>
                                        </span>
                                    </td>
                                </tr>
                            </xsl:for-each>
                        </tbody>
                    </table>
                </div>
            </xsl:if>
            <div class="page-break">
                <h1>Riepilogo importi</h1>
                <table id="riepilogo" class="riepilogo-PDC w-50" summary="Subtotali">
                    <tbody>
                        <tr>
                            <td class="in-cell-base in-cell-filler-background box-text"> Totale imponibile </td>
                            <td class="in-cell-base in-cell-data-center box-text">
                                <xsl:call-template name="format-amount">
                                    <xsl:with-param name="amount">
                                        <xsl:value-of select="/in:Order/cac:AnticipatedMonetaryTotal/cbc:LineExtensionAmount"/>
                                    </xsl:with-param>
                                </xsl:call-template>
                            </td>
                        </tr>
                        <tr>
                            <td class="in-cell-base in-cell-filler-background box-text"> Totale sconti </td>
                            <td class="in-cell-base in-cell-data-center box-text">
                                <xsl:call-template name="format-amount">
                                    <xsl:with-param name="amount">
                                        <xsl:value-of select="/in:Order/cac:AnticipatedMonetaryTotal/cbc:AllowanceTotalAmount"/>
                                    </xsl:with-param>
                                </xsl:call-template>
                            </td>
                        </tr>
                        <tr>
                            <td class="in-cell-base in-cell-filler-background box-text"> Totale maggiorazioni </td>
                            <td class="in-cell-base in-cell-data-center box-text">
                                <xsl:call-template name="format-amount">
                                    <xsl:with-param name="amount">
                                        <xsl:value-of select="/in:Order/cac:AnticipatedMonetaryTotal/cbc:ChargeTotalAmount"/>
                                    </xsl:with-param>
                                </xsl:call-template>
                            </td>
                        </tr>
                        <tr>
                            <td class="in-cell-base in-cell-filler-background box-text"> Totale Ordine senza IVA </td>
                            <td class="in-cell-base in-cell-data-center box-text">
                                <xsl:call-template name="format-amount">
                                    <xsl:with-param name="amount">
                                        <xsl:value-of select="/in:Order/cac:AnticipatedMonetaryTotal/cbc:TaxExclusiveAmount"/>
                                    </xsl:with-param>
                                </xsl:call-template>
                            </td>
                        </tr>
                        <tr>
                            <td class="in-cell-base in-cell-filler-background box-text"> Totale IVA </td>
                            <td class="in-cell-base in-cell-data-center box-text">
                                <xsl:call-template name="format-amount">
                                    <xsl:with-param name="amount">
                                        <xsl:value-of select="/in:Order/cac:TaxTotal/cbc:TaxAmount"/>
                                    </xsl:with-param>
                                </xsl:call-template>
                            </td>
                        </tr>
                        <tr>
                            <td class="in-cell-base in-cell-filler-background box-text"> Arrotondamento totale Ordine </td>
                            <td class="in-cell-base in-cell-data-center box-text">
                                <xsl:call-template name="format-amount">
                                    <xsl:with-param name="amount">
                                        <xsl:value-of select="/in:Order/cac:AnticipatedMonetaryTotal/cbc:PayableRoundingAmount"/>
                                    </xsl:with-param>
                                </xsl:call-template>
                            </td>
                        </tr>
                        <tr>
                            <td class="in-cell-base in-cell-filler-background box-text"> Totale Ordine incluso IVA </td>
                            <td class="in-cell-base in-cell-data-center box-text">
                                <xsl:call-template name="format-amount">
                                    <xsl:with-param name="amount">
                                        <xsl:value-of select="/in:Order/cac:AnticipatedMonetaryTotal/cbc:TaxInclusiveAmount"/>
                                    </xsl:with-param>
                                </xsl:call-template>
                            </td>
                        </tr>
                        <tr>
                            <td class="in-cell-base in-cell-filler-background box-text"> Importo prepagato </td>
                            <td class="in-cell-base in-cell-data-center box-text">
                                <xsl:call-template name="format-amount">
                                    <xsl:with-param name="amount">
                                        <xsl:value-of select="/in:Order/cac:AnticipatedMonetaryTotal/cbc:PrepaidAmount"/>
                                    </xsl:with-param>
                                </xsl:call-template>
                            </td>
                        </tr>
                        <tr>
                            <td class="in-cell-base in-cell-filler-background box-text bold font-size-80"> Totale da pagare </td>
                            <td class="in-cell-base in-cell-data-center box-text bold font-size-80">
                                <xsl:call-template name="format-amount">
                                    <xsl:with-param name="amount">
                                        <xsl:value-of select="/in:Order/cac:AnticipatedMonetaryTotal/cbc:PayableAmount"/>
                                    </xsl:with-param>
                                </xsl:call-template>
                            </td>
                        </tr>
                    </tbody>
                </table>
            </div>
            <!--  CHANGED (24-09-2019, @author "Manuel Gozzi"): in precedenza "in:Invoice", ora "in:Order"  -->
            <xsl:if test="in:Order/cac:AdditionalDocumentReference/cac:Attachment/cbc:EmbeddedDocumentBinaryObject">
                <div style="margin-top: 10px" class="page-break">
                    <xsl:variable name="NumAllegati">
                        <!--  CHANGED (24-09-2019, @author "Manuel Gozzi"): in precedenza "in:Invoice", ora "in:Order"  -->
                        <xsl:value-of select="count(in:Order/cac:AdditionalDocumentReference/cac:Attachment/cbc:EmbeddedDocumentBinaryObject)"/>
                    </xsl:variable>
                    <div class="box-text">
                        <span style="font-weight: bold">
                            <xsl:if test="$NumAllegati =1 "> E' presente un allegato:</xsl:if>
                            <xsl:if test="$NumAllegati >1">
Sono presenti
                                <xsl:value-of select="$NumAllegati"/>
allegati:
                            </xsl:if>
                        </span>
                        <ul style="margin: 0; padding: 0" class="attachment-list">
                            <!--  CHANGED (24-09-2019, @author "Manuel Gozzi"): in precedenza "in:Invoice", ora "in:Order"  -->
                            <xsl:for-each select="in:Order/cac:AdditionalDocumentReference/cac:Attachment/cbc:EmbeddedDocumentBinaryObject">
                                <li>
                                    <xsl:value-of select="../../cbc:DocumentType"/>
                                    <xsl:if test="../../cac:Attachment/cbc:EmbeddedDocumentBinaryObject/@mimeCode">
(
                                        <xsl:value-of select="../../cac:Attachment/cbc:EmbeddedDocumentBinaryObject/@mimeCode"/>
)
                                    </xsl:if>
                                </li>
                            </xsl:for-each>
                        </ul>
                    </div>
                </div>
            </xsl:if>
        </body>
    </html>
</xsl:template>
<xsl:template name="in-id">
    <span class="box-text">
        <xsl:apply-templates mode="line" select="/in:Order/cbc:ID"/>
    </span>
    <xsl:if test="/in:Order/cbc:OrderTypeCode">
        <div class="box-text">
            <xsl:variable name="orderTypeCodeVar">
                <xsl:value-of select="/in:Order/cbc:OrderTypeCode"/>
            </xsl:variable>
            <xsl:value-of select="$orderTypeCodeVar"/>
            <!--  TODO: aggiungere la valutazione dei sottoinsiemi definiti nella Codelist (tab. OrderTypeCode)  -->
            <xsl:for-each select="document($xclOrderTypeCode)//SimpleCodeList/Row">
                <xsl:if test="Value[@ColumnRef='code']/SimpleValue=$orderTypeCodeVar">
-
                    <xsl:value-of select="Value[@ColumnRef='nome']/SimpleValue"/>
                </xsl:if>
            </xsl:for-each>
        </div>
    </xsl:if>
</xsl:template>
<xsl:template name="in-currency">
    <span class="box-text">
        <xsl:apply-templates mode="line" select="/in:Order/cbc:DocumentCurrencyCode"/>
    </span>
</xsl:template>
<xsl:template name="po-customer-id">
    <xsl:apply-templates mode="line" select="/in:Invoice/cac:OrderReference/cbc:ID"/>
</xsl:template>
<xsl:template name="po-date">
    <xsl:apply-templates mode="line" select="/in:Invoice/cac:OrderReference/cbc:IssueDate"/>
</xsl:template>
<xsl:template name="in-note">
    <ul style="border:0;padding:0;margin:0">
        <xsl:for-each select="/in:Order/cbc:Note">
            <span class="box-text" style="border:0;padding:0;margin:0">
                <li style="list-style-type:none">
                    <xsl:value-of select="current()"/>
                </li>
            </span>
        </xsl:for-each>
    </ul>
</xsl:template>
<xsl:template name="in-supplier">
    <xsl:call-template name="in-party">
        <xsl:with-param name="party" select="/in:Invoice/cac:AccountingSupplierParty/cac:Party"/>
    </xsl:call-template>
    <div class="box-text">
Codice IPA
        <xsl:value-of select="/in:Invoice/cac:AccountingSupplierParty/cac:Party/cac:PartyIdentification/cbc:ID[@schemeID='IT:IPA']"/>
    </div>
    <div class="box-text">
Codice EORI
        <xsl:value-of select="/in:Invoice/cac:AdditionalDocumentReference[cbc:DocumentType='EORI CedentePrestatore']/cbc:ID"/>
    </div>
</xsl:template>
<xsl:template name="in-serviceprovider">
    <xsl:param name="tipoServizio"/>
    <xsl:param name="showDisclaimer"/>
    <xsl:if test="/in:Invoice/cac:AccountingSupplierParty/cac:Party/cac:ServiceProviderParty[cbc:ServiceType=$tipoServizio]/cac:Party">
        <xsl:call-template name="in-party">
            <xsl:with-param name="party" select="/in:Invoice/cac:AccountingSupplierParty/cac:Party/cac:ServiceProviderParty[cbc:ServiceType=$tipoServizio]/cac:Party"/>
        </xsl:call-template>
        <xsl:if test="$showDisclaimer">
            <div class="box-text">
                <span class="law-warning">Fattura emessa per conto del cedente o prestatore art.21 secondo comma lettera n) DPR 633/72 </span>
            </div>
        </xsl:if>
    </xsl:if>
</xsl:template>
<xsl:template name="in-customer">
    <xsl:call-template name="in-party">
        <xsl:with-param name="party" select="/in:Invoice/cac:AccountingCustomerParty/cac:Party"/>
    </xsl:call-template>
    <div class="box-text">
Codice IPA
        <xsl:value-of select="/in:Invoice/cac:AccountingCustomerParty/cac:Party/cac:PartyIdentification/cbc:ID[@schemeID='IT:IPA']"/>
    </div>
</xsl:template>

<xsl:template name="order-type">

    <xsl:param name="description"/>

    <xsl:choose>
        <xsl:when test="/in:Order/cac:DeliveryTerms/cbc:SpecialTerms = 'OF'">
            <span>220 - Ordinazione di fatturazione (220#OF)</span>
        </xsl:when>
        <xsl:when test="/in:Order/cac:DeliveryTerms/cbc:SpecialTerms = 'OFR'">
            <span>220 - Ordinazione di fatturazione e reintegro (220#OFR)</span>
        </xsl:when>
        <xsl:when test="/in:Order/cac:DeliveryTerms/cbc:SpecialTerms = 'ON'">
            <span>220 - Ordinazione di noleggio (220#ON)</span>
        </xsl:when>
        <xsl:when test="/in:Order/cac:DeliveryTerms/cbc:SpecialTerms = 'OR'">
            <span>220 - Ordinazione di regolazione (220#OR)</span>
        </xsl:when>
        <xsl:when test="/in:Order/cac:DeliveryTerms/cbc:SpecialTerms = 'OB'">
            <span>220 - Ordinazione a budget (220#OB)</span>
        </xsl:when>
        <xsl:when test="/in:Order/cac:DeliveryTerms/cbc:SpecialTerms = 'CD'">
            <span>227 - Ordinazione in conto deposito (227#CD)</span>
        </xsl:when>
        <xsl:when test="/in:Order/cac:DeliveryTerms/cbc:SpecialTerms = 'CV'">
            <span>227 - Ordinazione in conto visione (227#CV)</span>
        </xsl:when>
        <xsl:when test="/in:Order/cac:DeliveryTerms/cbc:SpecialTerms = 'CG'">
            <span>227 - Ordinazione in comodato gratuito (227#CG)</span>
        </xsl:when>
        <xsl:when test="/in:Order/cac:DeliveryTerms/cbc:SpecialTerms = 'CN'">
            <span>227 - Ordinazione in conto noleggio (227#CN)</span>
        </xsl:when>
        <xsl:otherwise>
            <xsl:value-of select="$description"/>
            <xsl:if test="/in:Order/cac:DeliveryTerms/cbc:SpecialTerms">
                <xsl:text>#</xsl:text>
                <xsl:value-of select="/in:Order/cac:DeliveryTerms/cbc:SpecialTerms"/>
            </xsl:if>
            <xsl:text>)</xsl:text>
        </xsl:otherwise>
    </xsl:choose>

</xsl:template>

<xsl:template name="delivery">
    <xsl:param name="del"/>
    <div class="box-text">
ID:
                                                                                                                                                                                                                                                            <!--  CHANGED (24-09-2019, @author "Manuel Gozzi"): rimosso livello "Address" sopra a "ID"  -->
        <xsl:value-of select="$del/cac:DeliveryLocation/cbc:ID"/>
    </div>
    <div class="box-text">
Indirizzo:
        <xsl:call-template name="postal-address">
            <xsl:with-param name="address" select="$del/cac:DeliveryLocation/cac:Address"/>
        </xsl:call-template>
    </div>
    <xsl:call-template name="in-party">
        <xsl:with-param name="party" select="$del/cac:DeliveryParty"/>
    </xsl:call-template>
    <xsl:if test="$del/cac:RequestedDeliveryPeriod">
        <div class="box-text">
Data consegna dal:
            <xsl:call-template name="format-date">
                <xsl:with-param name="date">
                    <xsl:value-of select="$del/cac:RequestedDeliveryPeriod/cbc:StartDate"/>
                </xsl:with-param>
            </xsl:call-template>
            <br/>
Data consegna al:
            <xsl:call-template name="format-date">
                <xsl:with-param name="date">
                    <xsl:value-of select="$del/cac:RequestedDeliveryPeriod/cbc:EndDate"/>
                </xsl:with-param>
            </xsl:call-template>
        </div>
    </xsl:if>
</xsl:template>
<xsl:template name="party-identification">
    <xsl:param name="identification"/>
    <!--  NOTE (24-09-2019, @author "Manuel Gozzi"): discutere del cambiamento da "IT:VAT" -> "9906" ecc...  -->
    <!--  CHANGED (24-09-2019, @author "Manuel Gozzi"): inserito "switch" che controlla il valore dello schemeID e "decide"
        se è p.iva, c.f. o IPA (non previsto qui)  -->
    <xsl:if test="$identification/cbc:ID">

        <div class="box-text">

    Identificativo aggiuntivo

            <xsl:if test="$identification/cbc:ID/@schemeID">

                <xsl:choose>

                    <xsl:when test="$identification/cbc:ID/@schemeID = '9906'">P.IVA</xsl:when>

                    <xsl:when test="$identification/cbc:ID/@schemeID = '9907'">CF</xsl:when>

                    <xsl:when test="$identification/cbc:ID/@schemeID = '9921'">IPA</xsl:when>

                    <xsl:when test="$identification/cbc:ID/@schemeID = '0201'">IPA</xsl:when>

                    <xsl:otherwise>IT</xsl:otherwise>
                </xsl:choose>
                <xsl:text>:</xsl:text>
            </xsl:if>
            <!-- NOTE (24-09-2019, @author "Manuel Gozzi"): verificare se, nel caso di 9906:ITxxx occorra di inserire la sigla "IT" sopra -->

            <xsl:value-of select="$identification/cbc:ID"/>

            <xsl:if test="$identification/cbc:ID/@schemeID">
                <xsl:text> (</xsl:text>
                <xsl:value-of select="$identification/cbc:ID/@schemeID"/>
                <xsl:text>)</xsl:text>
            </xsl:if>
        </div>
    </xsl:if>
</xsl:template>
<xsl:template name="party-name">
    <xsl:param name="name"/>
    <xsl:if test="$name/cbc:Name">
        <xsl:value-of select="$name/cbc:Name"/>
    </xsl:if>
</xsl:template>
<xsl:template name="postal-address">
    <xsl:param name="address"/>
    <xsl:if test="$address/cbc:StreetName">
        <xsl:value-of select="concat($address/cbc:StreetName, ' ')"/>
    </xsl:if>
    <xsl:if test="$address/cbc:AdditionalStreetName">
        <xsl:value-of select="concat($address/cbc:AdditionalStreetName, ' ')"/>
    </xsl:if>
    <xsl:if test="$address/cbc:PostalZone">
        <xsl:value-of select="concat($address/cbc:PostalZone, ' ')"/>
    </xsl:if>
    <xsl:if test="$address/cbc:CityName">
        <xsl:value-of select="concat($address/cbc:CityName, ' ')"/>
    </xsl:if>
    <!--  CHANGED (24-09-2019 @author Manuel Gozzi): aggiungere cac:AddressLine, tenendo conto di formattarla in modo particolare
            a seconda del tipo di party (nella consegna in questa sede figura l'orario di consegna)  -->
    <!--  TODO (24-09-2019 @author Manuel Gozzi): distinguere il party in cui in questa sede viene
            indicato l'orario di consegna  -->

    <xsl:if test="$address/cbc:CountrySubentity">
        <xsl:text>(</xsl:text>
        <xsl:value-of select="$address/cbc:CountrySubentity"/>
        <xsl:text>) </xsl:text>
    </xsl:if>
    <xsl:if test="$address/cac:AddressLine/cbc:Line">
        <xsl:value-of select="$address/cac:AddressLine/cbc:Line"/>
    </xsl:if>
    <div class="box-text" style="font-size: 100%; margin: 0">
            Codice Paese:
        <xsl:value-of select="$address/cac:Country/cbc:IdentificationCode"/>
    </div>
</xsl:template>
<xsl:template name="party-tax-scheme">
    <xsl:param name="scheme"/>
    <xsl:if test="$scheme/cac:TaxScheme/cbc:ID = 'VAT'">
        <span style="width:150px;display:inline-block;">
            <!--  CHANGED: delegato controllo a TaxScheme / ID, rimosso attributo "schemeID", non più presente in BIS 3.0  -->
P.IVA:
            <xsl:value-of select="$scheme/cbc:CompanyID"/>
        </span>
    </xsl:if>
</xsl:template>
<xsl:template name="party-legal-entity">
    <xsl:param name="legal-entity"/>
    <xsl:if test="$legal-entity/cbc:RegistrationName">
        <xsl:value-of select="$legal-entity/cbc:RegistrationName"/>
    </xsl:if>
    <!--  CHANGED (24-09-2019, @author "Manuel Gozzi")  -->
    <xsl:if test="$legal-entity/cbc:RegistrationAddress">
(Reg. Imprese di
        <xsl:value-of select="document($xclProvinceItaliane)//Value[@ColumnRef='name']/SimpleValue[../../Value[@ColumnRef='code']/SimpleValue=$legal-entity/cac:RegistrationAddress/cbc:CityName]"/>
n.
        <xsl:value-of select="$legal-entity/cbc:CompanyID"/>
)
    </xsl:if>
</xsl:template>
<xsl:template name="contact">
    <!--  CHANGED (24-09-2019, @author "Manuel Gozzi"): rimosso id e fax  -->
    <xsl:param name="contact"/>
    <xsl:if test="$contact/cbc:Name">
        Referente: <xsl:value-of select="$contact/cbc:Name"/>
    </xsl:if>
    <xsl:if test="$contact/cbc:ElectronicMail">
        Email: <xsl:value-of select="$contact/cbc:ElectronicMail"/>
    </xsl:if>
    <xsl:if test="$contact/cbc:Telephone">
        Telefono: <xsl:value-of select="$contact/cbc:Telephone"/>
    </xsl:if>
</xsl:template>
<xsl:template name="in-party">
    <xsl:param name="party"/>

    <xsl:choose>

        <xsl:when test="$party/cac:PartyName">
            <div class="box-text">
                <xsl:call-template name="party-name">
                    <xsl:with-param name="name" select="$party/cac:PartyName"/>
                </xsl:call-template>
            </div>
        </xsl:when>

        <xsl:when test="not ($party/cac:PartyName) and $party/cac:PartyLegalEntity">
            <xsl:call-template name="party-legal-entity">
                <xsl:with-param name="legal-entity" select="$party/cac:PartyLegalEntity"/>
            </xsl:call-template>
        </xsl:when>


    </xsl:choose>
    <xsl:if test="$party/cbc:EndpointID">
        <div class="box-text">
Identificativo endpoint
            <xsl:value-of select="$party/cbc:EndpointID/@schemeID"/>
            <xsl:text>:</xsl:text>
            <xsl:value-of select="$party/cbc:EndpointID"/>
        </div>
    </xsl:if>
    <xsl:call-template name="party-identification">
        <xsl:with-param name="identification" select="$party/cac:PartyIdentification"/>
    </xsl:call-template>
    <xsl:if test="$party/cac:PostalAddress">
        <div class="box-text">
Indirizzo:
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
    <xsl:if test="$party/cac:PartyName and $party/cac:PartyLegalEntity">
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
</xsl:template>
<xsl:template name="format-pipe">
    <xsl:param name="value"/>
    <xsl:if test="$value and $value != ''">
        <xsl:for-each select="tokenize($value,'\|')">
            <xsl:if test=". != ''">
                <xsl:sequence select="."/>
            </xsl:if>
        </xsl:for-each>
    </xsl:if>
</xsl:template>
<xsl:template name="format-amount">
    <xsl:param name="amount"/>
    <xsl:if test="$amount and $amount != ''">
        <span nowrap="nowrap" class="floatright">
            <xsl:value-of select="format-number($amount, '#.##0,00########', 'number')"/>
        </span>
    </xsl:if>
</xsl:template>
<xsl:template name="format-date">
    <xsl:param name="date"/>
    <xsl:if test="$date and $date != ''">
        <xsl:value-of select="format-date($date, '[D01]/[M01]/[Y0001]')"/>
    </xsl:if>
</xsl:template>
<xsl:template name="format-amount-nofloat">
    <xsl:param name="amount"/>
    <xsl:if test="$amount and $amount != ''">
        <span nowrap="nowrap">
            <xsl:value-of select="format-number($amount, '#.##0,00########', 'number')"/>
        </span>
    </xsl:if>
</xsl:template>
<xsl:template name="allowance-charge">
    <xsl:param name="charge-indicator"/>
    <xsl:param name="amount"/>
    <xsl:if test="$charge-indicator = 'false'">-</xsl:if>
    <xsl:call-template name="format-amount">
        <xsl:with-param name="amount">
            <xsl:value-of select="$amount"/>
        </xsl:with-param>
    </xsl:call-template>
</xsl:template>
<xsl:template name="document-data">
    <xsl:param name="campo"/>
    <xsl:param name="suffix"/>
    <xsl:param name="cup"/>
    <xsl:param name="cig"/>
    <xsl:param name="commessa"/>
    <div class="box-text">
Identificativo
        <xsl:value-of select="$suffix"/>
:
        <xsl:value-of select="$campo/cbc:ID"/>
    </div>
    <div class="box-text">
Data
        <xsl:value-of select="$suffix"/>
:
        <xsl:call-template name="format-date">
            <xsl:with-param name="date">
                <xsl:value-of select="$campo/cbc:IssueDate"/>
            </xsl:with-param>
        </xsl:call-template>
    </div>
    <div class="box-text">
Codice Commessa Convenzione:
        <xsl:value-of select="/in:Invoice/cac:AdditionalDocumentReference[./cbc:DocumentType=$commessa]/cbc:ID"/>
    </div>
    <div class="box-text">
Codice CIG:
        <xsl:value-of select="/in:Invoice/cac:AdditionalDocumentReference[./cbc:DocumentType=$cig]/cbc:ID"/>
    </div>
    <div class="box-text">
Codice CUP:
        <xsl:value-of select="/in:Invoice/cac:AdditionalDocumentReference[./cbc:DocumentType=$cup]/cbc:ID"/>
    </div>
</xsl:template>
<xsl:template name="dato-collegato-linea">
    <xsl:param name="titolo"/>
    <xsl:param name="nomeCig"/>
    <xsl:param name="nomeCup"/>
    <xsl:param name="nomeCommessaConvenzione"/>
    <xsl:if test="cac:DocumentReference[./cbc:DocumentType=$nomeCig]/cbc:ID or cac:DocumentReference[./cbc:DocumentType=$nomeCup]/cbc:ID or cac:DocumentReference[./cbc:DocumentType=$nomeCommessaConvenzione]/cbc:ID">
        <div class="box-text no-margin" align="left">
            <h3 class="header-linea">
                <xsl:value-of select="$titolo"/>
            </h3>
            <xsl:if test="cac:DocumentReference[./cbc:DocumentType=$nomeCig]/cbc:ID">
                <xsl:call-template name="dato-linea">
                    <xsl:with-param name="dato">
                        <xsl:value-of select="cac:DocumentReference[./cbc:DocumentType=$nomeCig]/cbc:ID"/>
                    </xsl:with-param>
                    <xsl:with-param name="label">CIG</xsl:with-param>
                </xsl:call-template>
            </xsl:if>
            <xsl:if test="cac:DocumentReference[./cbc:DocumentType=$nomeCup]/cbc:ID">
                <xsl:call-template name="dato-linea">
                    <xsl:with-param name="dato">
                        <xsl:value-of select="cac:DocumentReference[./cbc:DocumentType=$nomeCup]/cbc:ID"/>
                    </xsl:with-param>
                    <xsl:with-param name="label">CUP</xsl:with-param>
                </xsl:call-template>
            </xsl:if>
            <xsl:if test="cac:DocumentReference[./cbc:DocumentType=$nomeCommessaConvenzione]/cbc:ID">
                <xsl:call-template name="dato-linea">
                    <xsl:with-param name="dato">
                        <xsl:value-of select="cac:DocumentReference[./cbc:DocumentType=$nomeCommessaConvenzione]/cbc:ID"/>
                    </xsl:with-param>
                    <xsl:with-param name="label">Commessa Convenzione</xsl:with-param>
                </xsl:call-template>
            </xsl:if>
        </div>
    </xsl:if>
</xsl:template>
<xsl:template name="dato-linea">
    <xsl:param name="dato"/>
    <xsl:param name="label"/>
    <xsl:if test="$dato">
        <span class="margin-right">
            <span class="bold margin">
                <xsl:value-of select="$label"/>
:
            </span>
            <xsl:value-of select="$dato"/>
        </span>
    </xsl:if>
</xsl:template>
<xsl:template name="dati-collegati-linea">
    <xsl:call-template name="dato-collegato-linea">
        <xsl:with-param name="titolo">Contratto</xsl:with-param>
        <xsl:with-param name="nomeCig">CIG_CONTRATTO</xsl:with-param>
        <xsl:with-param name="nomeCup">CUP_CONTRATTO</xsl:with-param>
        <xsl:with-param name="nomeCommessaConvenzione">CommessaConvenzione_CONTRATTO</xsl:with-param>
    </xsl:call-template>
    <xsl:call-template name="dato-collegato-linea">
        <xsl:with-param name="titolo">Convenzione</xsl:with-param>
        <xsl:with-param name="nomeCig">CIG_CONVENZIONE</xsl:with-param>
        <xsl:with-param name="nomeCup">CUP_CONVENZIONE</xsl:with-param>
        <xsl:with-param name="nomeCommessaConvenzione">CommessaConvenzione_CONVENZIONE</xsl:with-param>
    </xsl:call-template>
    <xsl:call-template name="dato-collegato-linea">
        <xsl:with-param name="titolo">Ricezione</xsl:with-param>
        <xsl:with-param name="nomeCig">CIG_RICEZIONE</xsl:with-param>
        <xsl:with-param name="nomeCup">CUP_RICEZIONE</xsl:with-param>
        <xsl:with-param name="nomeCommessaConvenzione">CommessaConvenzione_RICEZIONE</xsl:with-param>
    </xsl:call-template>
    <xsl:call-template name="dato-collegato-linea">
        <xsl:with-param name="titolo">Fatture Collegate</xsl:with-param>
        <xsl:with-param name="nomeCig">CIG_FATTURE_COLLEGATE</xsl:with-param>
        <xsl:with-param name="nomeCup">CUP_FATTURE_COLLEGATE</xsl:with-param>
        <xsl:with-param name="nomeCommessaConvenzione">CommessaConvenzione_FATTURE_COLLEGATE</xsl:with-param>
    </xsl:call-template>
</xsl:template>
</xsl:stylesheet>