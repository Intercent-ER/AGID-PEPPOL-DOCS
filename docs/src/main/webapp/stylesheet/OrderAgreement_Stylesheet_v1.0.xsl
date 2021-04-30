<?xml version="1.0" encoding="UTF-8"?>
<!-- Descrizione documento: Foglio di stile per Ordine Pre-Concordato italiano UBL 2.1 PEPPOL BIS 3 Versione : 1.0 Prodotto il : Marzo 2021 Prodotto da : Intercent-ER Ambito: Intercent-ER - Piloti Peppol -->

<xsl:stylesheet xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:cac="urn:oasis:names:specification:ubl:schema:xsd:CommonAggregateComponents-2"
  xmlns:cbc="urn:oasis:names:specification:ubl:schema:xsd:CommonBasicComponents-2"
  xmlns:in="urn:oasis:names:specification:ubl:schema:xsd:OrderResponse-2"
  xmlns:ext="urn:oasis:names:specification:ubl:schema:xsd:CommonExtensionComponents-2"
  xmlns:cr="http://www.ubl-italia.org/ns/CrossReference" version="2.0" exclude-result-prefixes="cac cbc in">
  <xd:doc xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl" scope="stylesheet">
    <xd:desc>
      <xd:p>
        <xd:b>Created on:</xd:b>
        March 01, 2021</xd:p>
      <xd:p>
        <xd:b>Author:</xd:b>
        Intercent-ER</xd:p>
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
        <title>ORDINE PRE-CONCORDATO</title>
        <style type="text/css">
          /* general text properties */
          .in-body {
            font-family: serif;
          }
          .in-box-label {
            font-family: "Arial", sans-serif;
            font-style: italic;
            font-size: 72%;
            margin-left: 1pt;
            margin-right: 1pt;
            margin-top: 1pt;
          }
          .box-text {
            font-family: "Arial", sans-serif;
            font-size: 70%;
            line-height: 15pt;
            margin-left: 1pt;
            margin-right: 1pt;
          }
          .title-text {
            font-family: "Arial", sans-serif;
            font-weight: bold;
            font-size:90%;
            margin-left: 10pt;
          }
          .subtitle-text {
            font-family: "Arial", sans-serif;
            font-weight: bold;
            font-size: 80%;
            margin-left: 1pt;
            margin-right: 1pt;
          }
          .in-table {
            border-collapse: collapse;
            border-color: #000000;
            table-layout: CHANGED (24-09-2019, @author "Manuel Gozzi");
          }
          .in-form-column {
            width: 8.33%;
          }
          .in-counter-cell {
            border: none;
          }
          .in-cell-data {
            margin-top: 0;
            margin-bottom: 0;
          }
          .in-cell-data-background {}
          .in-cell-data-center {
            text-align: center;
          }
          .in-cell-base {
            border: solid;
            border-width: 1pt;
          }
          .in-cell-end-override {
            border-right-style: none;
          }
          .in-cell-after-override {
            border-bottom-style: none;
          }
          .in-cell-line-background {
            background-color: #b8b8b8;
            font-weight: bold;
          }
          .in-cell-filler-background {
            background-color: #e8e8e8;
          }
          .CHANGED (24-09-2019, @author "Manuel Gozzi")-height {
            min-height: 40px;
            display: block;
          }
          .law-warning {
            font-style: italic;
            font-size: 70%;
          }
          .border-left {
            border-left: 1px solid;
          }
          .no-bottom-border {
            border-bottom: none;
          }
          .allowance-charge {
            list-style-type: none;
            padding: 0;
            margin: 0;
          }
          .allowance-charge LI {}
          H1 {
            font-size: 120%;
            font-family: "Arial", sans-serif;
          }
          H2 {
            font-family: "Arial", sans-serif;
            font-size: 100%;
          }
          H3 {
            font-size: 90%;
          }
          .padded {
            padding-top: 20px;
            padding-bottom: 10px;
            display: block;
          }
          .riepilogo-fattura {
            width: 100%;
            border: 1px solid black;
            padding: 0;
            margin: 0;
            border-spacing: 0;
            border-collapse: collapse;
          }
          .dati-fattura {
            width: 100%;
            height: 70px;
            border: none;
            padding: 0;
            margin: 0;
            border-spacing: 0;
            border-collapse: collapse;
          }
          .dati-documento {
            width: 100%;
            height: 50px;
            border: none;
            padding: 0;
            margin: 0;
            border-spacing: 0;
            border-collapse: collapse;
          }
          .no-border {
            border: 0 !important;
          }
          .riepilogo-fattura TD {
            border: 1px solid black;
            padding: 0;
            margin: 0;
            vertical-align: top;
          }
          .party-row {
            height: 150px;
          }
          .h50 {
            height: 50px;
          }
          .h80 {
            height: 80px;
          }
          .h100px {
            height: 100px;
          }
          .border-bottom {
            border-bottom: 1px solid black !important;
          }
          .border-right {
            border-right: 1px solid black !important;
          }
          .border-left {
            border-left: 1px solid black !important;
          }
          .party-column {
            width: 50%;
          }
          .riepilogo-PDC {
            width: 100%;
            border: 1px solid black;
            padding: 0;
            margin: 0;
            border-spacing: 0;
            border-collapse: collapse;
          }
          .riepilogo-PDC TH {
            font-family: "Arial", sans-serif;
            font-size: 70%;
            font-style: italic;
            border-right: 1px solid black;
            height: 30px;
          }
          .w-50 {
            width: 50%;
          }
          .w-66 {
            width: 67%;
          }
          .w-90 {
            width: 90%;
          }
          .w-33 {
            width: 33%;
          }
          .w-40 {
            width: 40%;
          }
          .w-30 {
            width: 30%;
          }
          .w-25 {
            width: 25%;
          }
          .w-15 {
            width: 15%;
          }
          .w-10 {
            width: 10%;
          }
          .w-5 {
            width: 5%;
          }
          .w-100 {
            width: 100%;
          }
          .righe-fattura {
            width: 100%;
            border: 1px solid black;
            padding: 0;
            margin: 0;
            border-spacing: 0;
            border-collapse: collapse;
          }
          .righe-fattura TH {
            font-family: "Arial", sans-serif;
            font-size: 70%;
            font-style: italic;
            border-right: 1px solid black;
            height: 30px;
          }
          .empty-cell-filler {
            height: 1.5em;
          }
          .page-break {
            page-break-inside: avoid;
          }
          table {
            page-break-inside: auto;
          }
          tr {
            page-break-inside: avoid;
            page-break-after: auto;
          }
          thead {
            display: table-header-group;
          }
          tfoot {
            display: table-footer-group;
          }
          .block {
            display: block;
          }
          .h100 {
            height: 100%;
          }
          .attachment-list {
            list-style-type: none;
          }
          .floatright {
            float: right;
          }
          .float-right {
            float: right;
            margin-top: 20px;
            clear: both;
          }
          .float-right-last {
            float: right;
            margin-bottom: 30px;
            display: block;
            clear: both;
          }
          .nowraptext {
            white-space: nowrap;
            word-break: break-all;
          }
          .bold {
            font-weight: bold;
          }
          .margin-right {
            margin-right: 20px;
          }
          .header-linea {
            padding-top: 5px;
            padding-bottom: 3px;
            margin: 0;
          }
          .no-margin {
            margin: 0;
            padding: 0;
          }
          .font-size-80 {
            font-size: 80%;
          }
        </style>
      </head>
      <body class="in-body">
        <div class="page-break">
          <h1>Ordine Pre-Concordato</h1>
          <!-- CHANGED (24-09-2019, @author "Manuel Gozzi"): togliere "Rappresentazione UBL ver. " e inserire "Rappresentazione UBL ver. PEPPOL BIS 3.0" -->
          <h2>Rappresentazione UBL PEPPOL BIS 3</h2>
          <div class="box-text">
            CustomizationID: <xsl:value-of select="/in:OrderResponse/cbc:CustomizationID"/>
          <br />
            ProfileID: <xsl:value-of select="/in:OrderResponse/cbc:ProfileID"/>
        </div>
        <table class="riepilogo-fattura" summary="riepilogo fattura">
          <tr class="party-row">
            <td class="party-column">
              <h2 class="in-box-label">Fornitore</h2>

              <xsl:call-template name="in-party">
                <xsl:with-param name="party" select="/in:OrderResponse/cac:SellerSupplierParty/cac:Party"/>
              </xsl:call-template>
            </td>
            <td>
              <table class="dati-fattura" summary="dati fattura">
                <tr>
                  <td class="no-border border-right border-bottom h100px w-33 in-cell-filler-background">
                    <h2 class="in-box-label">Numero ordine</h2>

                    <xsl:call-template name="in-id"/>
                  </td>
                  <td class="no-border border-right border-bottom h100px w-33 in-cell-filler-background">
                    <h2 class="in-box-label">Data ordine</h2>
                    <span class="box-text">

                      <xsl:call-template name="format-date">

                        <xsl:with-param name="date">
                          <xsl:value-of select="/in:OrderResponse/cbc:IssueDate"/>
                        </xsl:with-param>
                      </xsl:call-template>
                      <!-- CHANGED (24-09-2019, @author "Manuel Gozzi"): aggiunto "cbc:IssueTime", come parametro opzionale -->

                      <xsl:if test="/in:OrderResponse/cbc:IssueTime">
                          ora

                        <xsl:value-of select="/in:OrderResponse/cbc:IssueTime"/>
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
                        <xsl:when test="contains(/in:OrderResponse/cac:DeliveryTerms/cbc:SpecialTerms, '227')">
                          <xsl:call-template name="order-type">
                            <xsl:with-param name="description" select='"Ordinazione di consegna ("'/>
                          </xsl:call-template>
                        </xsl:when>
                        <xsl:when test="contains(/in:OrderResponse/cac:DeliveryTerms/cbc:SpecialTerms, '220')">
                          <xsl:call-template name="order-type">
                            <xsl:with-param name="description" select='"Ordinazione di consegna ("'/>
                          </xsl:call-template>
                        </xsl:when>
                        <xsl:otherwise>
                          <xsl:call-template name="order-type">
                            <xsl:with-param name="description" select='"Ordinazione di acquisto (200"'/>
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
                        <xsl:when test="contains(/in:OrderResponse/cac:OrderReference/cbc:ID, 'Cancelled')">
                          <span>ORDINE PRE-CONCORDATO DI REVOCA</span>
                        </xsl:when>
                        <xsl:when test="contains(/in:OrderResponse/cac:OrderReference/cbc:ID, 'Revised')">
                          <span>ORDINE PRE-CONCORDATO SOSTITUTIVO</span>
                        </xsl:when>
                        <xsl:when test="contains(/in:OrderResponse/cac:OrderReference/cbc:ID, 'Connected')">
                          <span>ORDINE PRE-CONCORDATO COLLEGATO</span>
                        </xsl:when>
                        <xsl:when test="contains(/in:OrderResponse/cac:OrderReference/cbc:ID, 'Invoice')">
                          <span>ORDINE PRE-CONCORDATO DI CONVALIDA</span>
                        </xsl:when>
                        <xsl:otherwise>ORDINE PRE-CONCORDATO INIZIALE</xsl:otherwise>
                      </xsl:choose>
                    </div>
                  </td>
                </tr>
              </table>
              <table class="dati-fattura">
                <tr>
                  <td class="no-border border-right w-33 h100px">
                    <h2 class="in-box-label">Ordine precedente</h2>
                    <!-- CHANGED (24-09-2019, @author "Manuel Gozzi"): rimossi stato, tipo, data -->

                    <xsl:if test="/in:OrderResponse/cac:OrderReference">
                      <div class="box-text">
                          Numero:

                        <xsl:value-of select="/in:OrderResponse/cac:OrderReference/cbc:ID"/>
                      </div>
                    </xsl:if>
                  </td>
                  <td class="no-border border-right w-33 h100px">
                    <!-- CHANGED (24-09-2019, @author "Manuel Gozzi"): rimosso "Documento che ha originato l'ordine", inserito nuovo valore -->
                    <h2 class="in-box-label">Codice identificativo gara (CIG)</h2>
                    <!-- CHANGED (24-09-2019, @author "Manuel Gozzi"): rimossi tipo, data -->

                    <xsl:if test="/in:OrderResponse/cac:OriginatorDocumentReference">
                      <div class="box-text">
                        <!-- CHANGED (24-09-2019, @author "Manuel Gozzi"): rimosso "Numero" -->

                        <xsl:value-of select="/in:OrderResponse/cac:OriginatorDocumentReference/cbc:ID"/>
                      </div>
                    </xsl:if>
                  </td>
                  <td class="no-border w-33 h100px">
                    <h2 class="in-box-label">Contratto</h2>

                    <xsl:if test="/in:OrderResponse/cac:Contract">
                      <div class="box-text">
                          Numero:

                        <xsl:value-of select="/in:OrderResponse/cac:Contract/cbc:ID"/>
                      </div>
                      <!-- CHANGED (24-09-2019, @author "Manuel Gozzi"): rimosso il tipo di contratto -->
                    </xsl:if>
                  </td>
                </tr>
              </table>
            </td>
          </tr>
          <tr class="party-row">
            <td>
              <h2 class="in-box-label">Acquirente</h2>

              <xsl:call-template name="in-party">
                <xsl:with-param name="party" select="/in:OrderResponse/cac:BuyerCustomerParty/cac:Party"/>
              </xsl:call-template>

              <xsl:if test="/in:OrderResponse/cac:BuyerCustomerParty/cac:DeliveryContact">
                <div class="box-text">

                  <xsl:call-template name="delivery-contact">
                    <xsl:with-param name="contact" select="/in:OrderResponse/cac:BuyerCustomerParty/cac:DeliveryContact"/>
                  </xsl:call-template>
                </div>
              </xsl:if>
            </td>
            <!-- Da leiminare il templaate del foreach-->
            <td class="no-border" colspan="3">
              <h2 class="in-box-label">Note</h2>

              <xsl:call-template name="in-note"/>
            </td>
          </tr>
          <tr class="h50">
            <td>
              <h2 class="in-box-label">Committente (Ufficio Ordinante)</h2>

              <xsl:call-template name="in-party">
                <xsl:with-param name="party" select="/in:OrderResponse/cac:OriginatorCustomerParty/cac:Party"/>
              </xsl:call-template>
            </td>
            <td class="h50">
              <table class="dati-documento h100" summary="Dati ordine e contratto">
                <tr>
                  <td class="w-66 no-border border-right h50">
                    <h2 class="in-box-label">Informazioni sulla consegna</h2>

                    <xsl:call-template name="delivery">
                      <xsl:with-param name="del" select="/in:OrderResponse/cac:Delivery"/>
                    </xsl:call-template>
                  </td>
                  <td class="w-33 no-border h50">
                    <h2 class="in-box-label">Termini di consegna</h2>

                    <xsl:if test="/in:OrderResponse/cac:DeliveryTerms/cac:DeliveryLocation/cac:Address">
                      <div class="box-text">
                          Indirizzo:

                        <xsl:call-template name="postal-address">
                          <xsl:with-param name="address" select="/in:OrderResponse/cac:DeliveryTerms/cac:DeliveryLocation/cac:Address"/>
                        </xsl:call-template>
                      </div>
                    </xsl:if>
                  </td>
                </tr>
              </table>
            </td>

          </tr>
          <tr class="h50">
            <td>
              <h2 class="in-box-label">Intestatario Fattura</h2>

              <xsl:call-template name="in-party">
                <xsl:with-param name="party" select="/in:OrderResponse/cac:AccountingCustomerParty/cac:Party"/>
              </xsl:call-template>
            </td>
            <td>
              <h2 class="in-box-label">Altri Riferimenti</h2>

              <xsl:for-each select="/in:OrderResponse/cac:AdditionalDocumentReference">
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


                  <!-- CHANGED (24-09-2019, @author "Manuel Gozzi"): rimossa IssueDate -->

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
              <th scope="col" class="in-cell-filler-background">Periodo di Consegna</th>
              <th scope="col" class="in-cell-filler-background">Informazioni Articolo</th>
              <!-- CHANGED (24-09-2019, @author "Manuel Gozzi"): rimossa la dicitura "Contratto" -->
              <th scope="col" class="in-cell-filler-background">Documento</th>
              <th scope="col" class="in-cell-filler-background">Prezzo Unitario</th>
              <th scope="col" class="in-cell-filler-background">Sconti / Maggiorazioni</th>
              <th scope="col" class="in-cell-filler-background">Imponibile</th>
              <th scope="col" class="in-cell-filler-background">IVA %</th>
              <!-- CHANGED (24-09-2019, @author "Manuel Gozzi"): aggiungere colonna "lotto" -->
              <th scope="col" class="in-cell-filler-background">Certficato</th>
            </tr>
          </thead>
          <tbody>

            <xsl:for-each select="/in:OrderResponse/cac:OrderLine">
              <tr>
                <!-- Nome/Descrizione/Note -->
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
                        <xsl:value-of select="cac:LineItem/cbc:Note"/>
                      </div>

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
                    </div>
                  </div>
                </td>

                <!-- Cod. art. fornitore -->
                <td class="in-cell-base">
                  <div class="box-text">
                    <xsl:value-of select="cac:LineItem/cac:Item/cac:SellersItemIdentification/cbc:ID"/>
                  </div>
                </td>

                <!-- Cod. art. standard -->
                <td class="in-cell-base">
                  <div class="box-text">

                    <xsl:value-of select="cac:LineItem/cac:Item/cac:StandardItemIdentification/cbc:ID"/>
                    <!-- CHANGED (24-09-2019, @author "Manuel Gozzi"): rimosso "schemaID" -->
                  </div>
                </td>

                <!-- Quantità -->
                <td class="in-cell-base  in-cell-data-center">
                  <div class="box-text" align="right">
                    <xsl:value-of select="cac:LineItem/cbc:Quantity"/>
                  </div>
                </td>

                <!-- UdM -->
                <td class="in-cell-base  in-cell-data-center">
                  <div class="box-text">
                    <!-- TODO: verificare l'aggiornamento delle code list su NoTI-ER -->

                    <xsl:value-of select="if (document($xclUnitOfMeasureCode)//Value[@ColumnRef='xname']/SimpleValue[../../Value[@ColumnRef='code']/SimpleValue=current()/cac:LineItem/cbc:Quantity/@unitCode]) then document($xclUnitOfMeasureCode)//Value[@ColumnRef='xname']/SimpleValue[../../Value[@ColumnRef='code']/SimpleValue=current()/cac:LineItem/cbc:Quantity/@unitCode][1] else cac:LineItem/cbc:Quantity/@unitCode"/>
                  </div>
                </td>

                <!-- Quantità per confezione -->
                <td class="in-cell-base  in-cell-data-center">
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

                <!-- Periodo di consegna -->
                <td class="in-cell-base  in-cell-data-center">

                  <xsl:if test="cac:LineItem/cac:Delivery/cac:PromisedDeliveryPeriod">
                    <div class="box-text">

                      <xsl:call-template name="format-date">

                        <xsl:with-param name="date">
                          <xsl:value-of select="cac:LineItem/cac:Delivery/cac:PromisedDeliveryPeriod/cbc:StartDate"/>
                        </xsl:with-param>
                      </xsl:call-template>

                      <xsl:if test="cac:LineItem/cac:Delivery/cac:PromisedDeliveryPeriod/cbc:StartDate and cac:LineItem/cac:Delivery/cac:PromisedDeliveryPeriod/cbc:EndDate">
                          -
                      </xsl:if>

                      <xsl:call-template name="format-date">

                        <xsl:with-param name="date">
                          <xsl:value-of select="cac:LineItem/cac:Delivery/cac:PromisedDeliveryPeriod/cbc:EndDate"/>
                        </xsl:with-param>
                      </xsl:call-template>
                    </div>
                  </xsl:if>
                </td>

                <!-- Informazioni Articolo -->
                <td class="in-cell-base  in-cell-data-center">
                  <div class="box-text">

                    <xsl:if test="cac:LineItem/cac:Item/cac:AdditionalItemProperty">
                      <ul style="border:0;margin:0;padding:0">

                        <xsl:for-each select="cac:LineItem/cac:Item/cac:AdditionalItemProperty">

                          <xsl:if test="(not(./cbc:Name = 'PackQuantity') and not(./cbc:Name = 'PackSizeNumeric'))">
                            <li style="list-style-type:none;">
                              <xsl:value-of select="cbc:Value"/>
                            </li>
                          </xsl:if>
                        </xsl:for-each>
                      </ul>
                    </xsl:if>
                  </div>
                </td>

                <td class="in-cell-base  in-cell-data-center">
                  <!-- CHANGED (24-09-2019, @author "Manuel Gozzi"): rimuovere cac:DocumentReference e inserire ItemSpecificationDocumentReference / ID; parsare (?) -->
                  <!-- CHANGED (24-09-2019, @author "Manuel Gozzi"): lascio commentato il vecchio codice, così da poter verificare il funzionamento -->

                  <xsl:if test="cac:LineItem/cac:Item/cac:ItemSpecificationDocumentReference">
                    <div class="box-text" align="left" style="min-width: 100px">

                      <ul style="border:0;margin:0;padding:0">
                        <xsl:choose>
                          <xsl:when test="cac:LineItem/cac:Item/cac:ItemSpecificationDocumentReference/cbc:DocumentType">
                            <li style="list-style-type:none;">
                              <xsl:value-of select="cac:LineItem/cac:Item/cac:ItemSpecificationDocumentReference/cbc:DocumentType"/>
                              <xsl:text>:</xsl:text>
                              <xsl:value-of select="cac:LineItem/cac:Item/cac:ItemSpecificationDocumentReference/cbc:ID"/>
                            </li>
                          </xsl:when>
                          <xsl:otherwise>
                            <li style="list-style-type:none;">
                              <xsl:text>Id doc.:</xsl:text>
                              <xsl:value-of select="cac:LineItem/cac:Item/cac:ItemSpecificationDocumentReference/cbc:ID"/>
                            </li>
                          </xsl:otherwise>
                        </xsl:choose>

                        <xsl:if test="cac:LineItem/cac:Item/cac:ItemSpecificationDocumentReference/cac:Attachment/cac:ExternalReference/cbc:URI">
                          <li style="list-style-type:none;">
                            <xsl:value-of select="concat('Riferimento esterno: ', cac:LineItem/cac:Item/cac:ItemSpecificationDocumentReference/cac:Attachment/cac:ExternalReference/cbc:URI)"/>
                          </li>
                        </xsl:if>
                      </ul>
                    </div>
                  </xsl:if>
                </td>

                <!-- Prezzo -->
                <td class="in-cell-base  in-cell-data-center">
                  <div class="box-text" align="right">

                    <div>

                      <xsl:if test="cac:LineItem/cac:Price/cbc:BaseQuantity">
                        <span>
                          <xsl:text>(per </xsl:text>
                          <xsl:value-of select="cac:LineItem/cac:Price/cbc:BaseQuantity"/>
                          <xsl:text>) </xsl:text>
                        </span>
                      </xsl:if>

                      <xsl:call-template name="format-amount-nofloat">

                        <xsl:with-param name="amount">
                          <xsl:value-of select="cac:LineItem/cac:Price/cbc:PriceAmount"/>
                        </xsl:with-param>
                      </xsl:call-template>

                    </div>

                    <xsl:if test="cac:LineItem/cac:Price/cbc:PriceType">
                        Informazione sul tipo di prezzo applicato:

                      <xsl:value-of select="cac:LineItem/cac:Price/cbc:PriceType"/>
                    </xsl:if>
                  </div>
                </td>

                <!-- Sconti / Magg. -->
                <td class="in-cell-base  in-cell-data-center">
                  <div class="box-text" align="right">
                    <ul class="allowance-charge">

                      <xsl:if test="cac:LineItem/cac:Price/cac:AllowanceCharge">
                        <li>
                            Sconto:
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

                <!-- Imponibile -->
                <td class="in-cell-base  in-cell-data-center">
                  <div class="box-text" align="right">

                    <xsl:call-template name="format-amount">

                      <xsl:with-param name="amount">
                        <xsl:value-of select="cac:LineItem/cbc:LineExtensionAmount"/>
                      </xsl:with-param>
                    </xsl:call-template>
                  </div>
                </td>

                <!-- IVA -->
                <td class="in-cell-base in-cell-data-center">

                  <xsl:if test="cac:LineItem/cac:Item/cac:ClassifiedTaxCategory/cbc:Percent">
                    <div class="box-text" align="right">
                      <xsl:value-of select="cac:LineItem/cac:Item/cac:ClassifiedTaxCategory/cbc:Percent"/>
                    </div>
                  </xsl:if>
                </td>

                <!-- Certificato -->
                <td class="in-cell-base  in-cell-data-center">

                  <xsl:if test="cac:LineItem/cac:Item/cac:Certificate">
                    <div class="box-text" align="right">
                      <xsl:value-of select="cac:LineItem/cac:Item/cac:Certificate/cbc:ID"/>
                    </div>
                    <div class="box-text" align="right">
                      <xsl:value-of select="cac:LineItem/cac:Item/cac:Certificate/cbc:CertificateType"/>
                    </div>
                  </xsl:if>
                </td>
              </tr>
            </xsl:for-each>
          </tbody>
        </table>
      </div>

      <xsl:if test="/in:OrderResponse/cac:AllowanceCharge">
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

              <xsl:for-each select="/in:OrderResponse/cac:AllowanceCharge">
                <tr>
                  <td class="in-cell-base in-cell-data-center">
                    <div class="box-text" align="left">
                      <xsl:value-of select="cbc:AllowanceChargeReason"/>
                    </div>
                  </td>
                  <td class="in-cell-base  in-cell-data-center" style="min-width: 200px">
                    <span class="box-text">
                      <!-- CHANGED (24-09-2019, @author "Manuel Gozzi"): aggiunto moltiplicatore (%) -->

                      <xsl:if test="cbc:ChargeIndicator eq 'false'">
                          Sconto
                      </xsl:if>

                      <xsl:if test="cbc:ChargeIndicator eq 'true'">
                          Maggiorazione
                      </xsl:if>

                      <xsl:if test="cbc:MultiplierFactorNumeric">
                        <xsl:text>(</xsl:text>
                        <xsl:value-of select="cbc:MultiplierFactorNumeric"/>
                        <xsl:text>%)</xsl:text>
                      </xsl:if>
                      <xsl:text>: </xsl:text>
                      <xsl:call-template name="format-amount-nofloat">
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

      <xsl:if test="/in:OrderResponse/cac:TaxTotal/cac:TaxSubtotal">
        <div class="page-break">
          <h1>Riepiloghi d'IVA</h1>
          <table class="righe-fattura" summary="righe fattura">

            <thead>
              <tr>
                <th scope="col" class="in-cell-filler-background">Codice dell'imposta</th>
                <th scope="col" class="in-cell-filler-background">Aliquota</th>
                <th scope="col" class="in-cell-filler-background">Imponibile</th>
                <th scope="col" class="in-cell-filler-background">Imposta</th>
                <th scope="col" class="in-cell-filler-background">Motivo dell'esenzione</th>
              </tr>
            </thead>
            <tbody>

              <xsl:for-each select="/in:OrderResponse/cac:TaxTotal/cac:TaxSubtotal">
                <tr>

                  <td class="in-cell-base in-cell-data-center">
                    <div class="box-text">

                      <xsl:if test="cac:TaxCategory/cbc:ID">

                        <xsl:value-of select="cac:TaxCategory/cbc:ID"/>

                      </xsl:if>
                    </div>
                  </td>

                  <td class="in-cell-base in-cell-data-center">
                    <div class="box-text">

                      <xsl:if test="cac:TaxCategory/cbc:Percent">

                        <xsl:value-of select="cac:TaxCategory/cbc:Percent"/>

                      </xsl:if>
                    </div>
                  </td>

                  <td class="in-cell-base in-cell-data-center">
                    <div class="box-text">

                      <xsl:if test="cbc:TaxableAmount">

                        <xsl:call-template name="format-amount">

                          <xsl:with-param name="amount">
                            <xsl:value-of select="cbc:TaxableAmount"/>
                          </xsl:with-param>
                        </xsl:call-template>

                      </xsl:if>
                    </div>
                  </td>

                  <td class="in-cell-base in-cell-data-center">
                    <div class="box-text">

                      <xsl:if test="cbc:TaxAmount">

                        <xsl:call-template name="format-amount">

                          <xsl:with-param name="amount">
                            <xsl:value-of select="cbc:TaxAmount"/>
                          </xsl:with-param>
                        </xsl:call-template>

                      </xsl:if>
                    </div>
                  </td>

                  <td class="in-cell-base in-cell-data-center">
                    <div class="box-text">

                      <xsl:if test="cac:TaxCategory/cbc:TaxExemptionReason">

                        <xsl:value-of select="cac:TaxCategory/cbc:TaxExemptionReason"/>

                      </xsl:if>
                    </div>
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
              <td class="in-cell-base in-cell-filler-background box-text">
                  Totale imponibile
              </td>
              <td class="in-cell-base  in-cell-data-center box-text">

                <xsl:call-template name="format-amount">

                  <xsl:with-param name="amount">
                    <xsl:value-of select="/in:OrderResponse/cac:LegalMonetaryTotal/cbc:LineExtensionAmount"/>
                  </xsl:with-param>
                </xsl:call-template>
              </td>
            </tr>
            <tr>
              <td class="in-cell-base in-cell-filler-background box-text">
                  Totale sconti
              </td>
              <td class="in-cell-base  in-cell-data-center box-text">

                <xsl:call-template name="format-amount">

                  <xsl:with-param name="amount">
                    <xsl:value-of select="/in:OrderResponse/cac:LegalMonetaryTotal/cbc:AllowanceTotalAmount"/>
                  </xsl:with-param>
                </xsl:call-template>
              </td>
            </tr>
            <tr>
              <td class="in-cell-base in-cell-filler-background box-text">
                  Totale maggiorazioni
              </td>
              <td class="in-cell-base  in-cell-data-center box-text">

                <xsl:call-template name="format-amount">

                  <xsl:with-param name="amount">
                    <xsl:value-of select="/in:OrderResponse/cac:LegalMonetaryTotal/cbc:ChargeTotalAmount"/>
                  </xsl:with-param>
                </xsl:call-template>
              </td>
            </tr>
            <tr>
              <td class="in-cell-base in-cell-filler-background box-text">
                  Totale Ordine senza IVA
              </td>
              <td class="in-cell-base  in-cell-data-center box-text">

                <xsl:call-template name="format-amount">

                  <xsl:with-param name="amount">
                    <xsl:value-of select="/in:OrderResponse/cac:LegalMonetaryTotal/cbc:TaxExclusiveAmount"/>
                  </xsl:with-param>
                </xsl:call-template>
              </td>
            </tr>
            <tr>
              <td class="in-cell-base in-cell-filler-background box-text">
                  Totale IVA
              </td>
              <td class="in-cell-base  in-cell-data-center box-text">

                <xsl:call-template name="format-amount">

                  <xsl:with-param name="amount">
                    <xsl:value-of select="/in:OrderResponse/cac:TaxTotal/cbc:TaxAmount"/>
                  </xsl:with-param>
                </xsl:call-template>
              </td>
            </tr>
            <tr>
              <td class="in-cell-base in-cell-filler-background box-text">
                  Arrotondamento totale Ordine
              </td>
              <td class="in-cell-base  in-cell-data-center box-text">

                <xsl:call-template name="format-amount">

                  <xsl:with-param name="amount">
                    <xsl:value-of select="/in:OrderResponse/cac:LegalMonetaryTotal/cbc:PayableRoundingAmount"/>
                  </xsl:with-param>
                </xsl:call-template>
              </td>
            </tr>
            <tr>
              <td class="in-cell-base in-cell-filler-background box-text">
                  Totale Ordine incluso IVA
              </td>
              <td class="in-cell-base  in-cell-data-center box-text">

                <xsl:call-template name="format-amount">

                  <xsl:with-param name="amount">
                    <xsl:value-of select="/in:OrderResponse/cac:LegalMonetaryTotal/cbc:TaxInclusiveAmount"/>
                  </xsl:with-param>
                </xsl:call-template>
              </td>
            </tr>
            <tr>
              <td class="in-cell-base in-cell-filler-background box-text">
                  Importo prepagato
              </td>
              <td class="in-cell-base  in-cell-data-center box-text">

                <xsl:call-template name="format-amount">

                  <xsl:with-param name="amount">
                    <xsl:value-of select="/in:OrderResponse/cac:LegalMonetaryTotal/cbc:PrepaidAmount"/>
                  </xsl:with-param>

                </xsl:call-template>
              </td>
            </tr>
            <tr>
              <td class="in-cell-base in-cell-filler-background box-text bold font-size-80">
                  Totale da pagare
              </td>
              <td class="in-cell-base  in-cell-data-center box-text bold font-size-80">

                <xsl:call-template name="format-amount">

                  <xsl:with-param name="amount">
                    <xsl:value-of select="/in:OrderResponse/cac:LegalMonetaryTotal/cbc:PayableAmount"/>
                  </xsl:with-param>
                </xsl:call-template>
              </td>
            </tr>
          </tbody>
        </table>
      </div>

      <xsl:if test="in:OrderResponse/cac:AdditionalDocumentReference/cac:Attachment/cbc:EmbeddedDocumentBinaryObject and (in:OrderResponse/cac:AdditionalDocumentReference/cac:Attachment/cbc:EmbeddedDocumentBinaryObject/@mimeCode or in:OrderResponse/cac:AdditionalDocumentReference/cbc:DocumentType)">

        <div style="margin-top: 10px" class="page-break">
          <xsl:variable name="NumAllegati">
            <xsl:value-of select="count(in:OrderResponse/cac:AdditionalDocumentReference/cac:Attachment/cbc:EmbeddedDocumentBinaryObject)"/>
          </xsl:variable>
          <div class="box-text">
            <span style="font-weight: bold">

              <xsl:if test="$NumAllegati =1 ">
                E' presente un allegato:</xsl:if>

              <xsl:if test="$NumAllegati &gt;1">
                Sono presenti

                <xsl:value-of select="$NumAllegati"/>
                allegati:</xsl:if>
            </span>
            <ul style="margin: 0; padding: 0" class="attachment-list">

              <xsl:for-each select="in:OrderResponse/cac:AdditionalDocumentReference/cac:Attachment/cbc:EmbeddedDocumentBinaryObject">
                <li>
                  <xsl:value-of select="../../cbc:DocumentType"/>
                  <xsl:if test="../../cac:Attachment/cbc:EmbeddedDocumentBinaryObject/@mimeCode">
                    (                    <xsl:value-of select="../../cac:Attachment/cbc:EmbeddedDocumentBinaryObject/@mimeCode"/>
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
    <xsl:apply-templates mode="line" select="/in:OrderResponse/cbc:ID"/>
  </span>
</xsl:template>

<xsl:template name="in-currency">
  <span class="box-text">
    <xsl:apply-templates mode="line" select="/in:OrderResponse/cbc:DocumentCurrencyCode"/>
  </span>
</xsl:template>

<xsl:template name="in-note">
  <ul style="border:0;padding:0;margin:0">

    <xsl:for-each select="/in:OrderResponse/cbc:Note">
      <span class="box-text" style="border:0;padding:0;margin:0">
        <li style="list-style-type:none">
          <xsl:value-of select="current()"/>
        </li>
      </span>
    </xsl:for-each>
  </ul>
</xsl:template>

<xsl:template name="order-type">

  <xsl:param name="description"/>

  <xsl:choose>
    <xsl:when test="contains(/in:OrderResponse/cac:DeliveryTerms/cbc:SpecialTerms, 'OF')">
      <span>220 - Ordinazione di fatturazione (220#OF)</span>
    </xsl:when>
    <xsl:when test="contains(/in:OrderResponse/cac:DeliveryTerms/cbc:SpecialTerms, 'OFR')">
      <span>220 - Ordinazione di fatturazione e reintegro (220#OFR)</span>
    </xsl:when>
    <xsl:when test="contains(/in:OrderResponse/cac:DeliveryTerms/cbc:SpecialTerms, 'ON')">
      <span>220 - Ordinazione di noleggio (220#ON)</span>
    </xsl:when>
    <xsl:when test="contains(/in:OrderResponse/cac:DeliveryTerms/cbc:SpecialTerms, 'OR')">
      <span>220 - Ordinazione di regolazione (220#OR)</span>
    </xsl:when>
    <xsl:when test="contains(/in:OrderResponse/cac:DeliveryTerms/cbc:SpecialTerms, 'OB')">
      <span>220 - Ordinazione a budget (220#OB)</span>
    </xsl:when>
    <xsl:when test="contains(/in:OrderResponse/cac:DeliveryTerms/cbc:SpecialTerms, 'CD')">
      <span>227 - Ordinazione in conto deposito (227#CD)</span>
    </xsl:when>
    <xsl:when test="contains(/in:OrderResponse/cac:DeliveryTerms/cbc:SpecialTerms, 'CV')">
      <span>227 - Ordinazione in conto visione (227#CV)</span>
    </xsl:when>
    <xsl:when test="contains(/in:OrderResponse/cac:DeliveryTerms/cbc:SpecialTerms, 'CG')">
      <span>227 - Ordinazione in comodato gratuito (227#CG)</span>
    </xsl:when>
    <xsl:when test="contains(/in:OrderResponse/cac:DeliveryTerms/cbc:SpecialTerms, 'CN')">
      <span>227 - Ordinazione in conto noleggio (227#CN)</span>
    </xsl:when>
    <xsl:otherwise>
      <xsl:value-of select="$description"/>
      <xsl:if test="/in:OrderResponse/cac:DeliveryTerms/cbc:SpecialTerms">
        <xsl:value-of select="/in:OrderResponse/cac:DeliveryTerms/cbc:SpecialTerms"/>
      </xsl:if>
      <xsl:text>)</xsl:text>
    </xsl:otherwise>
  </xsl:choose>

</xsl:template>

<xsl:template name="delivery">

  <xsl:param name="del"/>

  <xsl:call-template name="in-party">
    <xsl:with-param name="party" select="$del/cac:DeliveryParty"/>
  </xsl:call-template>

  <xsl:if test="$del/cac:PromisedDeliveryPeriod">
    <div class="box-text">
        Data consegna dal:

      <xsl:call-template name="format-date">

        <xsl:with-param name="date">
          <xsl:value-of select="$del/cac:PromisedDeliveryPeriod/cbc:StartDate"/>
        </xsl:with-param>
      </xsl:call-template>
      <xsl:if test="$del/cac:PromisedDeliveryPeriod/cbc:StartTime">, ora:
        <xsl:value-of select="$del/cac:PromisedDeliveryPeriod/cbc:StartTime"/>
      </xsl:if>

      <xsl:choose>

        <xsl:when test="$del/cac:PromisedDeliveryPeriod/cbc:EndDate and $del/cac:PromisedDeliveryPeriod/cbc:EndTime">
            Data consegna al:
          <xsl:call-template name="format-date">
            <xsl:with-param name="date">
              <xsl:value-of select="$del/cac:PromisedDeliveryPeriod/cbc:EndDate"/>
            </xsl:with-param>
          </xsl:call-template>, ora:
          <xsl:value-of select="$del/cac:PromisedDeliveryPeriod/cbc:EndTime"/>
        </xsl:when>

        <xsl:when test="$del/cac:PromisedDeliveryPeriod/cbc:EndDate">
          Data consegna al:
          <xsl:call-template name="format-date">
            <xsl:with-param name="date">
              <xsl:value-of select="$del/cac:PromisedDeliveryPeriod/cbc:EndDate"/>
            </xsl:with-param>
          </xsl:call-template>
        </xsl:when>

        <xsl:when test="$del/cac:PromisedDeliveryPeriod/cbc:EndTime">
          Data consegna al: - , ora:
          <xsl:value-of select="$del/cac:PromisedDeliveryPeriod/cbc:EndTime"/>
        </xsl:when>

      </xsl:choose>


    </div>
  </xsl:if>
</xsl:template>

<xsl:template name="delivery-terms">

  <xsl:param name="del"/>

  <xsl:call-template name="in-party">
    <xsl:with-param name="party" select="$del/cac:DeliveryParty"/>
  </xsl:call-template>

  <xsl:if test="$del/cac:PromisedDeliveryPeriod">
    <div class="box-text">
        Data consegna dal:

      <xsl:call-template name="format-date">

        <xsl:with-param name="date">
          <xsl:value-of select="$del/cac:PromisedDeliveryPeriod/cbc:StartDate"/>
        </xsl:with-param>
      </xsl:call-template>
      <br/>
        Data consegna al:

      <xsl:call-template name="format-date">

        <xsl:with-param name="date">
          <xsl:value-of select="$del/cac:PromisedDeliveryPeriod/cbc:EndDate"/>
        </xsl:with-param>
      </xsl:call-template>
    </div>
  </xsl:if>
</xsl:template>

<xsl:template name="party-identification">

  <xsl:param name="identification"/>
  <!-- NOTE (24-09-2019, @author "Manuel Gozzi"): discutere del cambiamento da "IT:VAT" -> "9906" ecc... -->
  <!-- CHANGED (24-09-2019, @author "Manuel Gozzi"): inserito "switch" che controlla il valore dello schemeID e "decide" se è p.iva, c.f. o IPA (non previsto qui) -->

  <xsl:if test="$identification/cbc:ID">

    <div class="box-text">

    Identificativo:

      <xsl:if test="$identification/cbc:ID/@schemeID">

        <xsl:choose>

          <xsl:when test="$identification/cbc:ID/@schemeID = '9906'">P.IVA</xsl:when>

          <xsl:when test="$identification/cbc:ID/@schemeID = '9907'">CF</xsl:when>

          <xsl:when test="$identification/cbc:ID/@schemeID = '9921'">IPA</xsl:when>

          <xsl:when test="$identification/cbc:ID/@schemeID = '0201'">IPA</xsl:when>

          <xsl:otherwise>IT</xsl:otherwise>
        </xsl:choose>
        <xsl:text> (</xsl:text>
        <xsl:value-of select="$identification/cbc:ID/@schemeID"/>
        <xsl:text>)</xsl:text>
        <xsl:text>: </xsl:text>
      </xsl:if>
      <!-- NOTE (24-09-2019, @author "Manuel Gozzi"): verificare se, nel caso di 9906:ITxxx occorra di inserire la sigla "IT" sopra -->

      <xsl:value-of select="$identification/cbc:ID"/>
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
    <xsl:if test="$address/cbc:StreetName or $address/cbc:AdditionalStreetName">
      <xsl:text>- </xsl:text>
    </xsl:if>
    <xsl:value-of select="concat($address/cbc:PostalZone, ' ')"/>
  </xsl:if>

  <xsl:if test="$address/cbc:CityName">
    <xsl:value-of select="concat($address/cbc:CityName, ' ')"/>
  </xsl:if>
  <!-- CHANGED (24-09-2019 @author Manuel Gozzi): aggiungere cac:AddressLine, tenendo conto di formattarla in modo particolare a seconda del tipo di party (nella consegna in questa sede figura l'orario di consegna) -->
  <!-- TODO (24-09-2019 @author Manuel Gozzi): distinguere il party in cui in questa sede viene indicato l'orario di consegna -->


  <xsl:if test="$address/cbc:CountrySubentity">
    <xsl:text>(</xsl:text>
    <xsl:value-of select="$address/cbc:CountrySubentity"/>
    <xsl:text>) </xsl:text>
  </xsl:if>

  <xsl:if test="$address/cac:AddressLine/cbc:Line">
    <br/>
  Ulteriori informazioni indirizzo:
    <xsl:value-of select="$address/cac:AddressLine/cbc:Line"/>
  </xsl:if>

  <br/>
    Codice Paese:
  <xsl:value-of select="$address/cac:Country/cbc:IdentificationCode"/>


</xsl:template>

<xsl:template name="contact">
  <!-- CHANGED (24-09-2019, @author "Manuel Gozzi"): rimosso id e fax -->

  <xsl:param name="contact"/>

  <xsl:if test="$contact/cbc:Name">
    <span style="width:250px;display:inline-block;">
        Referente:

      <xsl:value-of select="$contact/cbc:Name"/>
    </span>
  </xsl:if>

  <xsl:if test="$contact/cbc:ElectronicMail">
    <span style="width:250px;display:inline-block;">Email:

      <xsl:value-of select="$contact/cbc:ElectronicMail"/>
    </span>
  </xsl:if>

  <xsl:if test="$contact/cbc:Telephone">
    <span style="width:150px;display:inline-block;">Telefono:

      <xsl:value-of select="$contact/cbc:Telephone"/>
    </span>
  </xsl:if>
</xsl:template>

<xsl:template name="delivery-contact">
  <!-- CHANGED (24-09-2019, @author "Manuel Gozzi"): rimosso id e fax -->

  <xsl:param name="contact"/>

  <xsl:if test="$contact/cbc:Name">
    <span style="width:250px;display:inline-block;">
        Referente:

      <xsl:value-of select="$contact/cbc:Name"/>
    </span>
  </xsl:if>

  <xsl:if test="$contact/cbc:ElectronicMail">
    <span style="width:250px;display:inline-block;">Email:

      <xsl:value-of select="$contact/cbc:ElectronicMail"/>
    </span>
  </xsl:if>

  <xsl:if test="$contact/cbc:Telephone">
    <span style="width:150px;display:inline-block;">Telefono:

      <xsl:value-of select="$contact/cbc:Telephone"/>
    </span>
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

    <xsl:when test="not ($party/cac:PartyName)">
      <div class="box-text">
        <xsl:value-of select="$party/cac:PartyLegalEntity"/>
      </div>
    </xsl:when>


  </xsl:choose>

  <xsl:if test="$party/cbc:EndpointID">
    <div class="box-text">
        Identificativo endpoint: 

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

  <xsl:if test="$party/cac:PartyName">
    <div class="box-text">
      <xsl:value-of select="$party/cac:PartyLegalEntity"/>
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
