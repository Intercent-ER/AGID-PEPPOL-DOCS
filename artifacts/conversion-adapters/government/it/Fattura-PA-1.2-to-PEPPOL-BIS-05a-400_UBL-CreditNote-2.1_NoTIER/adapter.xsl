<?xml version="1.0" encoding="UTF-8"?>
<!--Stylesheet synthesized using Javest A2A Mapper environment.-->

<xsl:stylesheet xmlns:ds="http://www.w3.org/2000/09/xmldsig#"
                xmlns:ext="urn:oasis:names:specification:ubl:schema:xsd:CommonExtensionComponents-2"
                xmlns:in="http://ivaservizi.agenziaentrate.gov.it/docs/xsd/fatture/v1.2"
                xmlns:xsmap="http://www.javest.com/ns/mapper/snippet"
                xmlns="urn:oasis:names:specification:ubl:schema:xsd:CreditNote-2"
                xmlns:asmap="http://www.javest.com/ns/mapper/snippet/attribute"
                xmlns:cac="urn:oasis:names:specification:ubl:schema:xsd:CommonAggregateComponents-2"
                xmlns:cbc="urn:oasis:names:specification:ubl:schema:xsd:CommonBasicComponents-2"
                xmlns:xsd="http://www.w3.org/2001/XMLSchema"
                xmlns:ccts="urn:un:unece:uncefact:documentation:2"
                xmlns:cr="http://www.ubl-italia.org/ns/CrossReference"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                exclude-result-prefixes="xsmap asmap in ds"
                version="2.0">
   <xsl:output indent="no"/>
   <xsl:param name="xclFormatoAttachment" as="xsd:string">xcl/FormatoAttachment.gc</xsl:param>
   <xsl:param name="xclVATSchemes" as="xsd:string">xcl/VATSchemes.gc</xsl:param>
   <xsl:param name="xclPaymentMeansCode" as="xsd:string">xcl/PaymentMeansCode-2.1.gc</xsl:param>
   <xsl:param name="xclCategoriaImposte" as="xsd:string">xcl/CategoriaImposte.gc</xsl:param>
   <xsl:param name="xclUnitOfMeasureCode" as="xsd:string">xcl/UnitOfMeasureCode-2.1.gc</xsl:param>
   <!--
Processing starts at node: /in:FatturaElettronica
See the template rule at end of stylesheet for the default processing of 
the root node.
-->
<xsl:template match="/in:FatturaElettronica/FatturaElettronicaBody/DatiGenerali/DatiContratto"
                 mode="EstremiContratto_Riga">
      <xsl:param name="CN" select="."/>
      <xsl:param name="CNP" select="1"/>
      <xsl:if test="RiferimentoNumeroLinea[normalize-space()]=$CN/NumeroLinea[normalize-space()]">
         <cac:DocumentReference>
            <cbc:ID>
               <xsl:value-of select="IdDocumento"/>
            </cbc:ID>
            <xsl:if test="Data">
               <cbc:IssueDate>
                  <xsl:value-of select="Data"/>
               </cbc:IssueDate>
            </xsl:if>
            <cbc:DocumentType>
               <xsl:text>ESTREMI_CONTRATTO</xsl:text>
            </cbc:DocumentType>
         </cac:DocumentReference>
      </xsl:if>
   </xsl:template>
   <xsl:template match="/in:FatturaElettronica/FatturaElettronicaBody/DatiGenerali/DatiContratto/CodiceCIG"
                 mode="CIG_Contratto_Riga">
      <xsl:param name="CN" select="."/>
      <xsl:param name="CNP" select="1"/>
      <xsl:if test="../RiferimentoNumeroLinea[normalize-space()]=$CN/NumeroLinea[normalize-space()]">
         <cac:DocumentReference>
            <cbc:ID>
               <xsl:value-of select="."/>
            </cbc:ID>
            <cbc:DocumentType>
               <xsl:text>CIG_CONTRATTO</xsl:text>
            </cbc:DocumentType>
         </cac:DocumentReference>
      </xsl:if>
   </xsl:template>
   <xsl:template match="/in:FatturaElettronica/FatturaElettronicaBody/DatiGenerali/DatiContratto/CodiceCUP"
                 mode="CUP_Contratto_Riga">
      <xsl:param name="CN" select="."/>
      <xsl:param name="CNP" select="1"/>
      <xsl:if test="../RiferimentoNumeroLinea[normalize-space()]=$CN/NumeroLinea[normalize-space()]">
         <cac:DocumentReference>
            <cbc:ID>
               <xsl:value-of select="."/>
            </cbc:ID>
            <cbc:DocumentType>
               <xsl:text>CUP_CONTRATTO</xsl:text>
            </cbc:DocumentType>
         </cac:DocumentReference>
      </xsl:if>
   </xsl:template>
   <xsl:template match="/in:FatturaElettronica/FatturaElettronicaBody/DatiGenerali/DatiContratto/CodiceCommessaConvenzione"
                 mode="CodiceCommessaConvenzione_Contratto_Riga">
      <xsl:param name="CN" select="."/>
      <xsl:param name="CNP" select="1"/>
      <xsl:if test="../RiferimentoNumeroLinea[normalize-space()]=$CN/NumeroLinea[normalize-space()]">
         <cac:DocumentReference>
            <cbc:ID>
               <xsl:value-of select="."/>
            </cbc:ID>
            <cbc:DocumentType>
               <xsl:text>CommessaConvenzione_CONTRATTO</xsl:text>
            </cbc:DocumentType>
         </cac:DocumentReference>
      </xsl:if>
   </xsl:template>
   <xsl:template match="/in:FatturaElettronica/FatturaElettronicaBody/DatiGenerali/DatiConvenzione"
                 mode="EstremiConvenzione_Riga">
      <xsl:param name="CN" select="."/>
      <xsl:param name="CNP" select="1"/>
      <xsl:if test="RiferimentoNumeroLinea[normalize-space()]=$CN/NumeroLinea[normalize-space()]">
         <cac:DocumentReference>
            <cbc:ID>
               <xsl:value-of select="IdDocumento"/>
            </cbc:ID>
            <xsl:if test="Data">
               <cbc:IssueDate>
                  <xsl:value-of select="Data"/>
               </cbc:IssueDate>
            </xsl:if>
            <cbc:DocumentType>
               <xsl:text>ESTREMI_CONVENZIONE</xsl:text>
            </cbc:DocumentType>
         </cac:DocumentReference>
      </xsl:if>
   </xsl:template>
   <xsl:template match="/in:FatturaElettronica/FatturaElettronicaBody/DatiGenerali/DatiConvenzione/CodiceCIG"
                 mode="CIG_Convenzione_Riga">
      <xsl:param name="CN" select="."/>
      <xsl:param name="CNP" select="1"/>
      <xsl:if test="../RiferimentoNumeroLinea[normalize-space()]=$CN/NumeroLinea[normalize-space()]">
         <cac:DocumentReference>
            <cbc:ID>
               <xsl:value-of select="."/>
            </cbc:ID>
            <cbc:DocumentType>
               <xsl:text>CIG_CONVENZIONE</xsl:text>
            </cbc:DocumentType>
         </cac:DocumentReference>
      </xsl:if>
   </xsl:template>
   <xsl:template match="/in:FatturaElettronica/FatturaElettronicaBody/DatiGenerali/DatiConvenzione/CodiceCUP"
                 mode="CUP_Convenzione_Riga">
      <xsl:param name="CN" select="."/>
      <xsl:param name="CNP" select="1"/>
      <xsl:if test="../RiferimentoNumeroLinea[normalize-space()]=$CN/NumeroLinea[normalize-space()]">
         <cac:DocumentReference>
            <cbc:ID>
               <xsl:value-of select="."/>
            </cbc:ID>
            <cbc:DocumentType>
               <xsl:text>CUP_CONVENZIONE</xsl:text>
            </cbc:DocumentType>
         </cac:DocumentReference>
      </xsl:if>
   </xsl:template>
   <xsl:template match="/in:FatturaElettronica/FatturaElettronicaBody/DatiGenerali/DatiConvenzione/CodiceCommessaConvenzione"
                 mode="CodiceCommessaConvenzione_Convenzione_Riga">
      <xsl:param name="CN" select="."/>
      <xsl:param name="CNP" select="1"/>
      <xsl:if test="../RiferimentoNumeroLinea[normalize-space()]=$CN/NumeroLinea[normalize-space()]">
         <cac:DocumentReference>
            <cbc:ID>
               <xsl:value-of select="."/>
            </cbc:ID>
            <cbc:DocumentType>
               <xsl:text>CommessaConvenzione_CONVENZIONE</xsl:text>
            </cbc:DocumentType>
         </cac:DocumentReference>
      </xsl:if>
   </xsl:template>
   <xsl:template match="/in:FatturaElettronica/FatturaElettronicaBody/DatiGenerali/DatiDDT"
                 mode="DespatchLineReference">
      <xsl:param name="CN" select="."/>
      <xsl:param name="CNP" select="1"/>
      <xsl:if test="(RiferimentoNumeroLinea[normalize-space()]=$CN/NumeroLinea[normalize-space()] or (RiferimentoNumeroLinea and count(../../DatiBeniServizi/DettaglioLinee)=1)) and count($CN/AltriDatiGestionali[TipoDato = 'DatiDDT']) = 0">
         <cac:DespatchLineReference>
            <cbc:LineID>
               <xsl:text>0</xsl:text>
            </cbc:LineID>
            <cac:DocumentReference>
               <cbc:ID>
                  <xsl:value-of select="NumeroDDT"/>
               </cbc:ID>
               <xsl:if test="DataDDT">
                  <cbc:IssueDate>
                     <xsl:value-of select="DataDDT"/>
                  </cbc:IssueDate>
               </xsl:if>
               <cbc:DocumentType>
                  <xsl:text>DDT</xsl:text>
               </cbc:DocumentType>
            </cac:DocumentReference>
         </cac:DespatchLineReference>
      </xsl:if>
   </xsl:template>
   <xsl:template match="/in:FatturaElettronica/FatturaElettronicaBody/DatiGenerali/DatiFattureCollegate"
                 mode="BillingLineReference">
      <xsl:param name="CN" select="."/>
      <xsl:param name="CNP" select="1"/>
      <xsl:if test="RiferimentoNumeroLinea[normalize-space()]=$CN/NumeroLinea[normalize-space()]">
         <cac:BillingReference>
            <cac:InvoiceDocumentReference>
               <cbc:ID>
                  <xsl:value-of select="IdDocumento"/>
               </cbc:ID>
               <xsl:if test="Data">
                  <cbc:IssueDate>
                     <xsl:value-of select="Data"/>
                  </cbc:IssueDate>
               </xsl:if>
            </cac:InvoiceDocumentReference>
         </cac:BillingReference>
      </xsl:if>
   </xsl:template>
   <xsl:template match="/in:FatturaElettronica/FatturaElettronicaBody/DatiGenerali/DatiFattureCollegate/CodiceCIG"
                 mode="CIG_FattureCollegate_Riga">
      <xsl:param name="CN" select="."/>
      <xsl:param name="CNP" select="1"/>
      <xsl:if test="../RiferimentoNumeroLinea[normalize-space()]=$CN/NumeroLinea[normalize-space()]">
         <cac:DocumentReference>
            <cbc:ID>
               <xsl:value-of select="."/>
            </cbc:ID>
            <cbc:DocumentType>
               <xsl:text>CIG_FATTURE_COLLEGATE</xsl:text>
            </cbc:DocumentType>
         </cac:DocumentReference>
      </xsl:if>
   </xsl:template>
   <xsl:template match="/in:FatturaElettronica/FatturaElettronicaBody/DatiGenerali/DatiFattureCollegate/CodiceCUP"
                 mode="CUP_FattureCollegate_Riga">
      <xsl:param name="CN" select="."/>
      <xsl:param name="CNP" select="1"/>
      <xsl:if test="../RiferimentoNumeroLinea[normalize-space()]=$CN/NumeroLinea[normalize-space()]">
         <cac:DocumentReference>
            <cbc:ID>
               <xsl:value-of select="."/>
            </cbc:ID>
            <cbc:DocumentType>
               <xsl:text>CUP_FATTURE_COLLEGATE</xsl:text>
            </cbc:DocumentType>
         </cac:DocumentReference>
      </xsl:if>
   </xsl:template>
   <xsl:template match="/in:FatturaElettronica/FatturaElettronicaBody/DatiGenerali/DatiFattureCollegate/CodiceCommessaConvenzione"
                 mode="CodiceCommessaConvenzione_FattureCollegate_Riga">
      <xsl:param name="CN" select="."/>
      <xsl:param name="CNP" select="1"/>
      <xsl:if test="../RiferimentoNumeroLinea[normalize-space()]=$CN/NumeroLinea[normalize-space()]">
         <cac:DocumentReference>
            <cbc:ID>
               <xsl:value-of select="."/>
            </cbc:ID>
            <cbc:DocumentType>
               <xsl:text>CommessaConvenzione_FATTURE_COLLEGATE</xsl:text>
            </cbc:DocumentType>
         </cac:DocumentReference>
      </xsl:if>
   </xsl:template>
   <xsl:template match="/in:FatturaElettronica/FatturaElettronicaBody/DatiGenerali/DatiOrdineAcquisto"
                 mode="OrderLineReference">
      <xsl:param name="CN" select="."/>
      <xsl:param name="CNP" select="1"/>
      <xsl:if test="RiferimentoNumeroLinea[normalize-space()]=$CN/NumeroLinea[normalize-space()] or (RiferimentoNumeroLinea and count(../../DatiBeniServizi/DettaglioLinee)=1)">
         <cac:OrderLineReference>
            <cbc:LineID>
               <xsl:value-of select="if (NumItem) then NumItem else '0'"/>
            </cbc:LineID>
            <cac:OrderReference>
               <cbc:ID>
                  <xsl:value-of select="IdDocumento"/>
               </cbc:ID>
               <xsl:if test="Data">
                  <cbc:IssueDate>
                     <xsl:value-of select="Data"/>
                  </cbc:IssueDate>
               </xsl:if>
            </cac:OrderReference>
         </cac:OrderLineReference>
      </xsl:if>
   </xsl:template>
   <xsl:template match="/in:FatturaElettronica/FatturaElettronicaBody/DatiGenerali/DatiOrdineAcquisto/CodiceCIG"
                 mode="CIG_Riga">
      <xsl:param name="CN" select="."/>
      <xsl:param name="CNP" select="1"/>
      <xsl:if test="../RiferimentoNumeroLinea[normalize-space()]=$CN/NumeroLinea[normalize-space()] or (../RiferimentoNumeroLinea and count(../../../DatiBeniServizi/DettaglioLinee)=1)">
         <cac:DocumentReference>
            <cbc:ID>
               <xsl:value-of select="."/>
            </cbc:ID>
            <cbc:DocumentType>
               <xsl:text>CIG</xsl:text>
            </cbc:DocumentType>
         </cac:DocumentReference>
      </xsl:if>
   </xsl:template>
   <xsl:template match="/in:FatturaElettronica/FatturaElettronicaBody/DatiGenerali/DatiOrdineAcquisto/CodiceCUP"
                 mode="CUP_Riga">
      <xsl:param name="CN" select="."/>
      <xsl:param name="CNP" select="1"/>
      <xsl:if test="../RiferimentoNumeroLinea[normalize-space()]=$CN/NumeroLinea[normalize-space()] or (../RiferimentoNumeroLinea and count(../../../DatiBeniServizi/DettaglioLinee)=1)">
         <cac:DocumentReference>
            <cbc:ID>
               <xsl:value-of select="."/>
            </cbc:ID>
            <cbc:DocumentType>
               <xsl:text>CUP</xsl:text>
            </cbc:DocumentType>
         </cac:DocumentReference>
      </xsl:if>
   </xsl:template>
   <xsl:template match="/in:FatturaElettronica/FatturaElettronicaBody/DatiGenerali/DatiOrdineAcquisto/CodiceCommessaConvenzione"
                 mode="CodiceCommessaConvenzione_Riga">
      <xsl:param name="CN" select="."/>
      <xsl:param name="CNP" select="1"/>
      <xsl:if test="../RiferimentoNumeroLinea[normalize-space()]=$CN/NumeroLinea[normalize-space()] or (../RiferimentoNumeroLinea and count(../../../DatiBeniServizi/DettaglioLinee)=1)">
         <cac:DocumentReference>
            <cbc:ID>
               <xsl:value-of select="."/>
            </cbc:ID>
            <cbc:DocumentType>
               <xsl:text>CommessaConvenzione</xsl:text>
            </cbc:DocumentType>
         </cac:DocumentReference>
      </xsl:if>
   </xsl:template>
   <xsl:template match="/in:FatturaElettronica/FatturaElettronicaBody/DatiGenerali/DatiRicezione/CodiceCIG"
                 mode="CIG_Ricezione_Riga">
      <xsl:param name="CN" select="."/>
      <xsl:param name="CNP" select="1"/>
      <xsl:if test="../RiferimentoNumeroLinea[normalize-space()]=$CN/NumeroLinea[normalize-space()]">
         <cac:DocumentReference>
            <cbc:ID>
               <xsl:value-of select="."/>
            </cbc:ID>
            <cbc:DocumentType>
               <xsl:text>CIG_RICEZIONE</xsl:text>
            </cbc:DocumentType>
         </cac:DocumentReference>
      </xsl:if>
   </xsl:template>
   <xsl:template match="/in:FatturaElettronica/FatturaElettronicaBody/DatiGenerali/DatiRicezione/CodiceCUP"
                 mode="CUP_Ricezione_Riga">
      <xsl:param name="CN" select="."/>
      <xsl:param name="CNP" select="1"/>
      <xsl:if test="../RiferimentoNumeroLinea[normalize-space()]=$CN/NumeroLinea[normalize-space()]">
         <cac:DocumentReference>
            <cbc:ID>
               <xsl:value-of select="."/>
            </cbc:ID>
            <cbc:DocumentType>
               <xsl:text>CUP_RICEZIONE</xsl:text>
            </cbc:DocumentType>
         </cac:DocumentReference>
      </xsl:if>
   </xsl:template>
   <xsl:template match="/in:FatturaElettronica/FatturaElettronicaBody/DatiGenerali/DatiRicezione/CodiceCommessaConvenzione"
                 mode="CodiceCommessaConvenzione_Ricezione_Riga">
      <xsl:param name="CN" select="."/>
      <xsl:param name="CNP" select="1"/>
      <xsl:if test="../RiferimentoNumeroLinea[normalize-space()]=$CN/NumeroLinea[normalize-space()]">
         <cac:DocumentReference>
            <cbc:ID>
               <xsl:value-of select="."/>
            </cbc:ID>
            <cbc:DocumentType>
               <xsl:text>CommessaConvenzione_RICEZIONE</xsl:text>
            </cbc:DocumentType>
         </cac:DocumentReference>
      </xsl:if>
   </xsl:template>
   <xsl:template match="/in:FatturaElettronica/FatturaElettronicaBody/DatiGenerali/DatiTrasporto">
      <xsl:param name="CN" select="."/>
      <xsl:param name="CNP" select="1"/>
      <xsl:if test="NumeroColli &gt; 0 or DataInizioTrasporto or IndirizzoResa or DatiAnagraficiVettore or PesoLordo &gt; 0.00 or PesoNetto &gt; 0.00">
         <cac:Delivery>
            <xsl:if test="NumeroColli &gt; 0">
               <cbc:Quantity>
                  <xsl:value-of select="NumeroColli"/>
               </cbc:Quantity>
            </xsl:if>
            <xsl:if test="DataInizioTrasporto">
               <cbc:ActualDeliveryDate>
                  <xsl:value-of select="DataInizioTrasporto"/>
               </cbc:ActualDeliveryDate>
            </xsl:if>
            <xsl:apply-templates select="IndirizzoResa">
               <xsl:with-param name="CN" select="current()"/>
               <xsl:with-param name="CNP" select="position()"/>
            </xsl:apply-templates>
            <xsl:apply-templates select="DatiAnagraficiVettore">
               <xsl:with-param name="CN" select="current()"/>
               <xsl:with-param name="CNP" select="position()"/>
            </xsl:apply-templates>
            <xsl:if test="PesoLordo &gt; 0.00 or PesoNetto &gt; 0.00">
               <cac:Shipment>
                  <cbc:ID>
                     <xsl:text>1</xsl:text>
                  </cbc:ID>
                  <xsl:if test="PesoLordo &gt; 0.00">
                     <cbc:GrossWeightMeasure>
                        <xsl:variable name="variable_d13e388a1050145">
                           <xsl:value-of select="if (document($xclUnitOfMeasureCode)//Value[@ColumnRef='code']/SimpleValue[../../Value[@ColumnRef='xname']/SimpleValue=current()/UnitaMisuraPeso][1]) then document($xclUnitOfMeasureCode)//Value[@ColumnRef='code']/SimpleValue[../../Value[@ColumnRef='xname']/SimpleValue=current()/UnitaMisuraPeso][1] else 'KGM'"/>
                        </xsl:variable>
                        <xsl:if test="string($variable_d13e388a1050145)">
                           <xsl:attribute name="unitCode">
                              <xsl:value-of select="string($variable_d13e388a1050145)"/>
                           </xsl:attribute>
                        </xsl:if>
                        <xsl:value-of select="PesoLordo"/>
                     </cbc:GrossWeightMeasure>
                  </xsl:if>
                  <xsl:if test="PesoNetto &gt; 0.00">
                     <cbc:NetWeightMeasure>
                        <xsl:variable name="variable_d13e389a1050145">
                           <xsl:value-of select="if (document($xclUnitOfMeasureCode)//Value[@ColumnRef='code']/SimpleValue[../../Value[@ColumnRef='xname']/SimpleValue=current()/UnitaMisuraPeso][1]) then document($xclUnitOfMeasureCode)//Value[@ColumnRef='code']/SimpleValue[../../Value[@ColumnRef='xname']/SimpleValue=current()/UnitaMisuraPeso][1] else 'KGM'"/>
                        </xsl:variable>
                        <xsl:if test="string($variable_d13e389a1050145)">
                           <xsl:attribute name="unitCode">
                              <xsl:value-of select="string($variable_d13e389a1050145)"/>
                           </xsl:attribute>
                        </xsl:if>
                        <xsl:value-of select="PesoNetto"/>
                     </cbc:NetWeightMeasure>
                  </xsl:if>
               </cac:Shipment>
            </xsl:if>
         </cac:Delivery>
      </xsl:if>
   </xsl:template>
   <xsl:template match="/in:FatturaElettronica/FatturaElettronicaHeader/CedentePrestatore/StabileOrganizzazione">
      <xsl:param name="CN" select="."/>
      <xsl:param name="CNP" select="1"/>
      <xsl:if test=".">
         <cac:AgentParty>
            <cac:PostalAddress>
               <cbc:StreetName>
                  <xsl:value-of select="if (matches(Indirizzo, '(\s|,)(\d+|s.n.c|snc)')) then if (NumeroCivico and matches(Indirizzo, concat('(\s|,)',NumeroCivico))) then Indirizzo else concat(Indirizzo, ', ', NumeroCivico) else concat(Indirizzo, if (NumeroCivico) then concat(', ', NumeroCivico) else ' s.n.c.')"/>
               </cbc:StreetName>
               <cbc:CityName>
                  <xsl:value-of select="Comune"/>
               </cbc:CityName>
               <cbc:PostalZone>
                  <xsl:value-of select="CAP"/>
               </cbc:PostalZone>
               <xsl:if test="Provincia">
                  <cbc:CountrySubentity>
                     <xsl:value-of select="Provincia"/>
                  </cbc:CountrySubentity>
               </xsl:if>
               <cac:Country>
                  <cbc:IdentificationCode listID="ISO3166-1:Alpha2">
                     <xsl:value-of select="Nazione"/>
                  </cbc:IdentificationCode>
               </cac:Country>
            </cac:PostalAddress>
         </cac:AgentParty>
      </xsl:if>
   </xsl:template>
   <xsl:template match="/in:FatturaElettronica/FatturaElettronicaHeader/DatiTrasmissione">
      <xsl:param name="CN" select="."/>
      <xsl:param name="CNP" select="1"/>
      <cac:ServiceProviderParty>
         <cbc:ServiceType>
            <xsl:text>Trasmissione</xsl:text>
         </cbc:ServiceType>
         <cac:Party>
            <cac:PartyTaxScheme>
               <cbc:CompanyID>
                  <xsl:variable name="variable_d13e282a1051010">
                     <xsl:value-of select="if (upper-case(IdTrasmittente/IdPaese)='IT') then 'IT:CF' else document($xclVATSchemes)//Value[@ColumnRef='VATSchemeID']/SimpleValue[../../Value[@ColumnRef='code']/SimpleValue=current()/upper-case(IdTrasmittente/IdPaese)][1]"/>
                  </xsl:variable>
                  <xsl:if test="string($variable_d13e282a1051010)">
                     <xsl:attribute name="schemeID">
                        <xsl:value-of select="string($variable_d13e282a1051010)"/>
                     </xsl:attribute>
                  </xsl:if>
                  <xsl:value-of select="concat(IdTrasmittente/IdPaese,IdTrasmittente/IdCodice)"/>
               </cbc:CompanyID>
               <cac:TaxScheme>
                  <cbc:ID>
                     <xsl:text>VAT</xsl:text>
                  </cbc:ID>
               </cac:TaxScheme>
            </cac:PartyTaxScheme>
            <xsl:apply-templates select="ContattiTrasmittente">
               <xsl:with-param name="CN" select="current()"/>
               <xsl:with-param name="CNP" select="position()"/>
            </xsl:apply-templates>
         </cac:Party>
      </cac:ServiceProviderParty>
   </xsl:template>
   <xsl:template match="/in:FatturaElettronica/FatturaElettronicaHeader/DatiTrasmissione/CodiceDestinatario">
      <xsl:param name="CN" select="."/>
      <xsl:param name="CNP" select="1"/>
      <cac:PartyIdentification>
         <cbc:ID schemeID="IT:IPA">
            <xsl:value-of select="if (../FormatoTrasmissione='FPR12') then concat('CODDEST:',.) else ."/>
         </cbc:ID>
      </cac:PartyIdentification>
   </xsl:template>
   <xsl:template match="/in:FatturaElettronica/FatturaElettronicaHeader/DatiTrasmissione/PECDestinatario">
      <xsl:param name="CN" select="."/>
      <xsl:param name="CNP" select="1"/>
      <cac:OtherCommunication>
         <cbc:ChannelCode>
            <xsl:text>PEC</xsl:text>
         </cbc:ChannelCode>
         <cbc:Value>
            <xsl:value-of select="."/>
         </cbc:Value>
      </cac:OtherCommunication>
   </xsl:template>
   <xsl:template match="/in:FatturaElettronica/FatturaElettronicaHeader/TerzoIntermediarioOSoggettoEmittente/DatiAnagrafici">
      <xsl:param name="CN" select="."/>
      <xsl:param name="CNP" select="1"/>
      <xsl:if test=".">
         <cac:ServiceProviderParty>
            <cbc:ServiceType>
               <xsl:text>Emissione</xsl:text>
            </cbc:ServiceType>
            <cac:Party>
               <cac:PartyName>
                  <cbc:Name>
                     <xsl:value-of select="Anagrafica/Denominazione"/>
                  </cbc:Name>
               </cac:PartyName>
               <cac:PartyTaxScheme>
                  <xsl:apply-templates select="IdFiscaleIVA" mode="VAT_SoggettoEmittente">
                     <xsl:with-param name="CN" select="current()"/>
                     <xsl:with-param name="CNP" select="position()"/>
                  </xsl:apply-templates>
                  <cac:TaxScheme>
                     <cbc:ID>
                        <xsl:text>VAT</xsl:text>
                     </cbc:ID>
                  </cac:TaxScheme>
               </cac:PartyTaxScheme>
               <xsl:apply-templates select="CodiceFiscale">
                  <xsl:with-param name="CN" select="current()"/>
                  <xsl:with-param name="CNP" select="position()"/>
               </xsl:apply-templates>
            </cac:Party>
         </cac:ServiceProviderParty>
      </xsl:if>
   </xsl:template>
   <xsl:template match="AltriDatiGestionali" mode="DatiDDTOriginali">
      <xsl:param name="CN" select="."/>
      <xsl:param name="CNP" select="1"/>
      <xsl:if test="TipoDato = 'DatiDDT'">
         <cac:DespatchLineReference>
            <cbc:LineID>
               <xsl:value-of select="tokenize(RiferimentoTesto, ':')[2]"/>
            </cbc:LineID>
            <cac:DocumentReference>
               <cbc:ID>
                  <xsl:value-of select="tokenize(RiferimentoTesto, ':')[1]"/>
               </cbc:ID>
               <xsl:if test="RiferimentoData">
                  <cbc:IssueDate>
                     <xsl:value-of select="RiferimentoData"/>
                  </cbc:IssueDate>
               </xsl:if>
               <cbc:DocumentType>
                  <xsl:text>DDT</xsl:text>
               </cbc:DocumentType>
            </cac:DocumentReference>
         </cac:DespatchLineReference>
      </xsl:if>
   </xsl:template>
   <xsl:template match="AltriDatiGestionali" mode="NaturaOriginale">
      <xsl:param name="CN" select="."/>
      <xsl:param name="CNP" select="1"/>
      <xsl:if test="TipoDato = 'Natura'">
         <cbc:ID schemeID="UNCL5305">
            <xsl:value-of select="RiferimentoTesto"/>
         </cbc:ID>
      </xsl:if>
   </xsl:template>
   <xsl:template match="AltriDatiGestionali[upper-case(TipoDato)!='NOTA' and TipoDato!='DatiDDT' and TipoDato!='Natura']"
                 mode="AltriDatiGestionali_Item">
      <xsl:param name="CN" select="."/>
      <xsl:param name="CNP" select="1"/>
      <cac:AdditionalItemProperty>
         <cbc:Name>
            <xsl:value-of select="TipoDato"/>
         </cbc:Name>
         <cbc:Value>
            <xsl:value-of select="concat(RiferimentoTesto,'|',RiferimentoNumero,'|',RiferimentoData)"/>
         </cbc:Value>
      </cac:AdditionalItemProperty>
   </xsl:template>
   <xsl:template match="AltriDatiGestionali[upper-case(TipoDato)='NOTA']"
                 mode="Nota_AltriDatiGestionali">
      <xsl:param name="CN" select="."/>
      <xsl:param name="CNP" select="1"/>
      <xsl:if test="RiferimentoTesto">
         <cbc:Note>
            <xsl:value-of select="RiferimentoTesto"/>
         </cbc:Note>
      </xsl:if>
   </xsl:template>
   <xsl:template match="Anagrafica/Denominazione" mode="NomeVettore1">
      <xsl:param name="CN" select="."/>
      <xsl:param name="CNP" select="1"/>
      <cac:PartyName>
         <cbc:Name>
            <xsl:value-of select="."/>
         </cbc:Name>
      </cac:PartyName>
   </xsl:template>
   <xsl:template match="Anagrafica[Nome or Cognome]" mode="NomeVettore2">
      <xsl:param name="CN" select="."/>
      <xsl:param name="CNP" select="1"/>
      <cac:PartyName>
         <cbc:Name>
            <xsl:value-of select="normalize-space(concat(Nome, ' ', Cognome))"/>
         </cbc:Name>
      </cac:PartyName>
   </xsl:template>
   <xsl:template match="CodiceArticolo" mode="CommodityCode">
      <xsl:param name="CN" select="."/>
      <xsl:param name="CNP" select="1"/>
      <xsl:if test="contains(',CommodityCode,TARIC,', concat(',',CodiceTipo,','))">
         <cbc:CommodityCode>
            <xsl:variable name="variable_d13e555a1050721">
               <xsl:value-of select="CodiceTipo"/>
            </xsl:variable>
            <xsl:if test="string($variable_d13e555a1050721)">
               <xsl:attribute name="listID">
                  <xsl:value-of select="string($variable_d13e555a1050721)"/>
               </xsl:attribute>
            </xsl:if>
            <xsl:value-of select="CodiceValore"/>
         </cbc:CommodityCode>
      </xsl:if>
   </xsl:template>
   <xsl:template match="CodiceArticolo" mode="ItemClassificationCode">
      <xsl:param name="CN" select="."/>
      <xsl:param name="CNP" select="1"/>
      <xsl:if test="contains(',ItemClassificationCode,CPV,UNSPSC,eCl@ss,', concat(',',CodiceTipo,','))">
         <cbc:ItemClassificationCode>
            <xsl:variable name="variable_d13e556a1050721">
               <xsl:value-of select="CodiceTipo"/>
            </xsl:variable>
            <xsl:if test="string($variable_d13e556a1050721)">
               <xsl:attribute name="listID">
                  <xsl:value-of select="string($variable_d13e556a1050721)"/>
               </xsl:attribute>
            </xsl:if>
            <xsl:value-of select="CodiceValore"/>
         </cbc:ItemClassificationCode>
      </xsl:if>
   </xsl:template>
   <xsl:template match="CodiceArticolo[contains(',STANDARDITEMIDENTIFICATION,AIC,EMEA,PARAF,EAN,', concat(',',upper-case(CodiceTipo),','))][1]"
                 mode="StandardItemID2">
      <xsl:param name="CN" select="."/>
      <xsl:param name="CNP" select="1"/>
      <xsl:if test="count(../CodiceArticolo[upper-case(CodiceTipo)='AICFARMACO'])=0">
         <cac:StandardItemIdentification>
            <cbc:ID>
               <xsl:variable name="variable_d13e551a1051010">
                  <xsl:value-of select="CodiceTipo"/>
               </xsl:variable>
               <xsl:if test="string($variable_d13e551a1051010)">
                  <xsl:attribute name="schemeID">
                     <xsl:value-of select="string($variable_d13e551a1051010)"/>
                  </xsl:attribute>
               </xsl:if>
               <xsl:value-of select="CodiceValore"/>
            </cbc:ID>
         </cac:StandardItemIdentification>
      </xsl:if>
   </xsl:template>
   <xsl:template match="CodiceArticolo[not(CodiceTipo) or upper-case(CodiceTipo) = 'SELLERITEMIDENTIFICATION'][1]"
                 mode="SellersItemID">
      <xsl:param name="CN" select="."/>
      <xsl:param name="CNP" select="1"/>
      <cac:SellersItemIdentification>
         <cbc:ID>
            <xsl:value-of select="CodiceValore"/>
         </cbc:ID>
      </cac:SellersItemIdentification>
   </xsl:template>
   <xsl:template match="CodiceArticolo[not(CodiceTipo)][position() &gt; 1] | CodiceArticolo[CodiceTipo and CodiceTipo!='AICFARMACO' and CodiceTipo!='AIC']"
                 mode="AdditionalID">
      <xsl:param name="CN" select="."/>
      <xsl:param name="CNP" select="1"/>
      <xsl:if test="not(CodiceTipo) or not(contains(',STANDARDITEMIDENTIFICATION,SELLERITEMIDENTIFICATION,ITEMCLASSIFICATIONCODE,CPV,UNSPSC,ECL@SS,ECLASS,COMMODITYCODE,TARIC,', concat(',',upper-case(CodiceTipo),',')))">
         <cac:AdditionalItemIdentification>
            <cbc:ID>
               <xsl:variable name="variable_d13e553a1051010">
                  <xsl:value-of select="CodiceTipo"/>
               </xsl:variable>
               <xsl:if test="string($variable_d13e553a1051010)">
                  <xsl:attribute name="schemeID">
                     <xsl:value-of select="string($variable_d13e553a1051010)"/>
                  </xsl:attribute>
               </xsl:if>
               <xsl:value-of select="CodiceValore"/>
            </cbc:ID>
         </cac:AdditionalItemIdentification>
      </xsl:if>
   </xsl:template>
   <xsl:template match="CodiceArticolo[upper-case(CodiceTipo)='AICFARMACO'][1]"
                 mode="StandardItemID">
      <xsl:param name="CN" select="."/>
      <xsl:param name="CNP" select="1"/>
      <cac:StandardItemIdentification>
         <cbc:ID>
            <xsl:variable name="variable_d13e549a1051010">
               <xsl:value-of select="CodiceTipo"/>
            </xsl:variable>
            <xsl:if test="string($variable_d13e549a1051010)">
               <xsl:attribute name="schemeID">
                  <xsl:value-of select="string($variable_d13e549a1051010)"/>
               </xsl:attribute>
            </xsl:if>
            <xsl:value-of select="CodiceValore"/>
         </cbc:ID>
      </cac:StandardItemIdentification>
   </xsl:template>
   <xsl:template match="CodiceFiscale">
      <xsl:param name="CN" select="."/>
      <xsl:param name="CNP" select="1"/>
      <xsl:if test=".">
         <cac:PartyTaxScheme>
            <cbc:CompanyID schemeID="IT:CF">
               <xsl:value-of select="."/>
            </cbc:CompanyID>
            <cac:TaxScheme>
               <cbc:ID>
                  <xsl:text>VAT</xsl:text>
               </cbc:ID>
            </cac:TaxScheme>
         </cac:PartyTaxScheme>
      </xsl:if>
   </xsl:template>
   <xsl:template match="Contatti">
      <xsl:param name="CN" select="."/>
      <xsl:param name="CNP" select="1"/>
      <xsl:if test="Telefono or Fax or Email">
         <cac:Contact>
            <xsl:if test="Telefono">
               <cbc:Telephone>
                  <xsl:value-of select="Telefono"/>
               </cbc:Telephone>
            </xsl:if>
            <xsl:if test="Fax">
               <cbc:Telefax>
                  <xsl:value-of select="Fax"/>
               </cbc:Telefax>
            </xsl:if>
            <xsl:if test="Email">
               <cbc:ElectronicMail>
                  <xsl:value-of select="Email"/>
               </cbc:ElectronicMail>
            </xsl:if>
         </cac:Contact>
      </xsl:if>
   </xsl:template>
   <xsl:template match="ContattiTrasmittente">
      <xsl:param name="CN" select="."/>
      <xsl:param name="CNP" select="1"/>
      <xsl:if test="Telefono or Email">
         <cac:Contact>
            <xsl:if test="Telefono">
               <cbc:Telephone>
                  <xsl:value-of select="Telefono"/>
               </cbc:Telephone>
            </xsl:if>
            <xsl:if test="Email">
               <cbc:ElectronicMail>
                  <xsl:value-of select="Email"/>
               </cbc:ElectronicMail>
            </xsl:if>
            <xsl:apply-templates select="/in:FatturaElettronica/FatturaElettronicaHeader/DatiTrasmissione/PECDestinatario">
               <xsl:with-param name="CN" select="current()"/>
               <xsl:with-param name="CNP" select="position()"/>
            </xsl:apply-templates>
         </cac:Contact>
      </xsl:if>
   </xsl:template>
   <xsl:template match="DatiAnagrafici" mode="Persona_CedentePrestatore">
      <xsl:param name="CN" select="."/>
      <xsl:param name="CNP" select="1"/>
      <xsl:if test="string-length(CodiceFiscale) = 16 or Anagrafica/Cognome">
         <cac:Person>
            <xsl:if test="string-length(CodiceFiscale) = 16">
               <cbc:ID schemeID="IT:CF">
                  <xsl:value-of select="CodiceFiscale"/>
               </cbc:ID>
            </xsl:if>
            <xsl:if test="Anagrafica/Nome">
               <cbc:FirstName>
                  <xsl:value-of select="Anagrafica/Nome"/>
               </cbc:FirstName>
            </xsl:if>
            <xsl:if test="Anagrafica/Cognome">
               <cbc:FamilyName>
                  <xsl:value-of select="Anagrafica/Cognome"/>
               </cbc:FamilyName>
            </xsl:if>
            <xsl:if test="Anagrafica/Titolo">
               <cbc:Title>
                  <xsl:value-of select="Anagrafica/Titolo"/>
               </cbc:Title>
            </xsl:if>
         </cac:Person>
      </xsl:if>
   </xsl:template>
   <xsl:template match="DatiAnagrafici" mode="Persona_CessionarioCommittente">
      <xsl:param name="CN" select="."/>
      <xsl:param name="CNP" select="1"/>
      <xsl:if test="string-length(CodiceFiscale) = 16 or Anagrafica/Cognome">
         <cac:Person>
            <xsl:if test="string-length(CodiceFiscale) = 16">
               <cbc:ID schemeID="IT:CF">
                  <xsl:value-of select="CodiceFiscale"/>
               </cbc:ID>
            </xsl:if>
            <xsl:if test="Anagrafica/Nome">
               <cbc:FirstName>
                  <xsl:value-of select="Anagrafica/Nome"/>
               </cbc:FirstName>
            </xsl:if>
            <xsl:if test="Anagrafica/Cognome">
               <cbc:FamilyName>
                  <xsl:value-of select="Anagrafica/Cognome"/>
               </cbc:FamilyName>
            </xsl:if>
            <xsl:if test="Anagrafica/Titolo">
               <cbc:Title>
                  <xsl:value-of select="Anagrafica/Titolo"/>
               </cbc:Title>
            </xsl:if>
         </cac:Person>
      </xsl:if>
   </xsl:template>
   <xsl:template match="DatiAnagrafici" mode="Persona_RappresentanteFiscale">
      <xsl:param name="CN" select="."/>
      <xsl:param name="CNP" select="1"/>
      <xsl:if test="string-length(CodiceFiscale) = 16 or Anagrafica/Cognome">
         <cac:Person>
            <xsl:if test="string-length(CodiceFiscale) = 16">
               <cbc:ID schemeID="IT:CF">
                  <xsl:value-of select="CodiceFiscale"/>
               </cbc:ID>
            </xsl:if>
            <xsl:if test="Anagrafica/Nome">
               <cbc:FirstName>
                  <xsl:value-of select="Anagrafica/Nome"/>
               </cbc:FirstName>
            </xsl:if>
            <xsl:if test="Anagrafica/Nome">
               <cbc:FamilyName>
                  <xsl:value-of select="Anagrafica/Nome"/>
               </cbc:FamilyName>
            </xsl:if>
            <xsl:if test="Anagrafica/Titolo">
               <cbc:Title>
                  <xsl:value-of select="Anagrafica/Titolo"/>
               </cbc:Title>
            </xsl:if>
         </cac:Person>
      </xsl:if>
   </xsl:template>
   <xsl:template match="DatiAnagrafici/AlboProfessionale">
      <xsl:param name="CN" select="."/>
      <xsl:param name="CNP" select="1"/>
      <cac:CorporateRegistrationScheme>
         <cbc:Name>
            <xsl:value-of select="."/>
         </cbc:Name>
      </cac:CorporateRegistrationScheme>
   </xsl:template>
   <xsl:template match="DatiAnagrafici/Anagrafica/Denominazione" mode="NomeCedentePrestatore1">
      <xsl:param name="CN" select="."/>
      <xsl:param name="CNP" select="1"/>
      <cac:PartyName>
         <cbc:Name>
            <xsl:value-of select="."/>
         </cbc:Name>
      </cac:PartyName>
   </xsl:template>
   <xsl:template match="DatiAnagrafici/Anagrafica/Denominazione"
                 mode="NomeCessionarioCommittente1">
      <xsl:param name="CN" select="."/>
      <xsl:param name="CNP" select="1"/>
      <cac:PartyName>
         <cbc:Name>
            <xsl:value-of select="."/>
         </cbc:Name>
      </cac:PartyName>
   </xsl:template>
   <xsl:template match="DatiAnagrafici/Anagrafica/Denominazione"
                 mode="NomeRappresentanteFiscale1">
      <xsl:param name="CN" select="."/>
      <xsl:param name="CNP" select="1"/>
      <cac:PartyName>
         <cbc:Name>
            <xsl:value-of select="."/>
         </cbc:Name>
      </cac:PartyName>
   </xsl:template>
   <xsl:template match="DatiAnagrafici/Anagrafica[Nome or Cognome]"
                 mode="NomeCedentePrestatore2">
      <xsl:param name="CN" select="."/>
      <xsl:param name="CNP" select="1"/>
      <cac:PartyName>
         <cbc:Name>
            <xsl:value-of select="normalize-space(concat(Nome, ' ', Cognome))"/>
         </cbc:Name>
      </cac:PartyName>
   </xsl:template>
   <xsl:template match="DatiAnagrafici/Anagrafica[Nome or Cognome]"
                 mode="NomeCessionarioCommittente2">
      <xsl:param name="CN" select="."/>
      <xsl:param name="CNP" select="1"/>
      <cac:PartyName>
         <cbc:Name>
            <xsl:value-of select="normalize-space(concat(Nome, ' ', Cognome))"/>
         </cbc:Name>
      </cac:PartyName>
   </xsl:template>
   <xsl:template match="DatiAnagrafici/Anagrafica[Nome or Cognome]"
                 mode="NomeRappresentanteFiscale2">
      <xsl:param name="CN" select="."/>
      <xsl:param name="CNP" select="1"/>
      <cac:PartyName>
         <cbc:Name>
            <xsl:value-of select="normalize-space(concat(Nome, ' ', Cognome))"/>
         </cbc:Name>
      </cac:PartyName>
   </xsl:template>
   <xsl:template match="DatiAnagrafici/CodiceFiscale" mode="CF_CessionaroCommittente">
      <xsl:param name="CN" select="."/>
      <xsl:param name="CNP" select="1"/>
      <xsl:if test="string-length(.) = 11">
         <cac:PartyTaxScheme>
            <cbc:CompanyID schemeID="IT:CF">
               <xsl:value-of select="concat('IT', .)"/>
            </cbc:CompanyID>
            <cac:TaxScheme>
               <cbc:ID>
                  <xsl:text>VAT</xsl:text>
               </cbc:ID>
            </cac:TaxScheme>
         </cac:PartyTaxScheme>
      </xsl:if>
   </xsl:template>
   <xsl:template match="DatiAnagrafici/CodiceFiscale">
      <xsl:param name="CN" select="."/>
      <xsl:param name="CNP" select="1"/>
      <xsl:if test="string-length(.) = 11">
         <cac:PartyTaxScheme>
            <cbc:CompanyID schemeID="IT:CF">
               <xsl:value-of select="concat('IT', .)"/>
            </cbc:CompanyID>
            <cac:TaxScheme>
               <cbc:ID>
                  <xsl:text>VAT</xsl:text>
               </cbc:ID>
            </cac:TaxScheme>
         </cac:PartyTaxScheme>
      </xsl:if>
   </xsl:template>
   <xsl:template match="DatiAnagrafici/IdFiscaleIVA" mode="VAT_CedentePrestatore">
      <xsl:param name="CN" select="."/>
      <xsl:param name="CNP" select="1"/>
      <cbc:CompanyID>
         <xsl:variable name="variable_d13e216a1051010">
            <xsl:value-of select="document($xclVATSchemes)//Value[@ColumnRef='VATSchemeID']/SimpleValue[../../Value[@ColumnRef='code']/SimpleValue=current()/upper-case(IdPaese)][1]"/>
         </xsl:variable>
         <xsl:if test="string($variable_d13e216a1051010)">
            <xsl:attribute name="schemeID">
               <xsl:value-of select="string($variable_d13e216a1051010)"/>
            </xsl:attribute>
         </xsl:if>
         <xsl:value-of select="concat(IdPaese, IdCodice)"/>
      </cbc:CompanyID>
   </xsl:template>
   <xsl:template match="DatiAnagrafici/IdFiscaleIVA" mode="VAT_CessionaroCommittente">
      <xsl:param name="CN" select="."/>
      <xsl:param name="CNP" select="1"/>
      <cac:PartyTaxScheme>
         <cbc:CompanyID>
            <xsl:variable name="variable_d13e311a1051010">
               <xsl:value-of select="document($xclVATSchemes)//Value[@ColumnRef='VATSchemeID']/SimpleValue[../../Value[@ColumnRef='code']/SimpleValue=current()/upper-case(IdPaese)][1]"/>
            </xsl:variable>
            <xsl:if test="string($variable_d13e311a1051010)">
               <xsl:attribute name="schemeID">
                  <xsl:value-of select="string($variable_d13e311a1051010)"/>
               </xsl:attribute>
            </xsl:if>
            <xsl:value-of select="concat(IdPaese, IdCodice)"/>
         </cbc:CompanyID>
         <cac:TaxScheme>
            <cbc:ID>
               <xsl:text>VAT</xsl:text>
            </cbc:ID>
         </cac:TaxScheme>
      </cac:PartyTaxScheme>
   </xsl:template>
   <xsl:template match="DatiAnagrafici/IdFiscaleIVA">
      <xsl:param name="CN" select="."/>
      <xsl:param name="CNP" select="1"/>
      <cbc:CompanyID schemeID="IT:VAT">
         <xsl:value-of select="concat(IdPaese, IdCodice)"/>
      </cbc:CompanyID>
   </xsl:template>
   <xsl:template match="DatiAnagrafici/ProvinciaAlbo">
      <xsl:param name="CN" select="."/>
      <xsl:param name="CNP" select="1"/>
      <cac:RegistrationAddress>
         <cbc:CityName>
            <xsl:value-of select="."/>
         </cbc:CityName>
      </cac:RegistrationAddress>
   </xsl:template>
   <xsl:template match="DatiAnagraficiVettore">
      <xsl:param name="CN" select="."/>
      <xsl:param name="CNP" select="1"/>
      <cac:Despatch>
         <cac:DespatchParty>
            <xsl:apply-templates select="Anagrafica/Denominazione" mode="NomeVettore1">
               <xsl:with-param name="CN" select="current()"/>
               <xsl:with-param name="CNP" select="position()"/>
            </xsl:apply-templates>
            <xsl:apply-templates select="Anagrafica[Nome or Cognome]" mode="NomeVettore2">
               <xsl:with-param name="CN" select="current()"/>
               <xsl:with-param name="CNP" select="position()"/>
            </xsl:apply-templates>
            <cac:PartyTaxScheme>
               <xsl:apply-templates select="IdFiscaleIVA">
                  <xsl:with-param name="CN" select="current()"/>
                  <xsl:with-param name="CNP" select="position()"/>
               </xsl:apply-templates>
               <cac:TaxScheme>
                  <cbc:ID>
                     <xsl:text>VAT</xsl:text>
                  </cbc:ID>
               </cac:TaxScheme>
            </cac:PartyTaxScheme>
            <xsl:if test="string-length(CodiceFiscale) = 16 or Anagrafica/Cognome">
               <cac:Person>
                  <xsl:if test="string-length(CodiceFiscale) = 16">
                     <cbc:ID>
                        <xsl:value-of select="CodiceFiscale"/>
                     </cbc:ID>
                  </xsl:if>
                  <xsl:if test="Anagrafica/Nome">
                     <cbc:FirstName>
                        <xsl:value-of select="Anagrafica/Nome"/>
                     </cbc:FirstName>
                  </xsl:if>
                  <xsl:if test="Anagrafica/Cognome">
                     <cbc:FamilyName>
                        <xsl:value-of select="Anagrafica/Cognome"/>
                     </cbc:FamilyName>
                  </xsl:if>
                  <xsl:if test="Anagrafica/Titolo">
                     <cbc:Title>
                        <xsl:value-of select="Anagrafica/Titolo"/>
                     </cbc:Title>
                  </xsl:if>
                  <xsl:if test="NumeroLicenzaGuida">
                     <cac:IdentityDocumentReference>
                        <cbc:ID>
                           <xsl:value-of select="NumeroLicenzaGuida"/>
                        </cbc:ID>
                        <cbc:DocumentType>
                           <xsl:text>LicenzaGuida</xsl:text>
                        </cbc:DocumentType>
                     </cac:IdentityDocumentReference>
                  </xsl:if>
               </cac:Person>
            </xsl:if>
         </cac:DespatchParty>
      </cac:Despatch>
   </xsl:template>
   <xsl:template match="DatiBeniServizi/DatiRiepilogo" mode="Estensione_Natura_Riepilogo_IVA">
      <xsl:param name="CN" select="."/>
      <xsl:param name="CNP" select="1"/>
      <xsl:if test="contains('|N1|N2|N3|N7|', concat('|', Natura, '|'))">
         <ext:UBLExtension>
            <ext:ExtensionURI>
               <xsl:value-of select="concat('urn:www.ubl-italia.org:spec:fatturapa:xref:natura_riepilogo::', position())"/>
            </ext:ExtensionURI>
            <ext:ExtensionContent>
               <cr:XCode>
                  <xsl:value-of select="Natura"/>
               </cr:XCode>
            </ext:ExtensionContent>
         </ext:UBLExtension>
      </xsl:if>
   </xsl:template>
   <xsl:template match="DatiBeniServizi/DatiRiepilogo"
                 mode="Estensione_SpeseAccessorie_Riepilogo_IVA">
      <xsl:param name="CN" select="."/>
      <xsl:param name="CNP" select="1"/>
      <xsl:if test="SpeseAccessorie &gt; 0.00">
         <ext:UBLExtension>
            <ext:ExtensionURI>
               <xsl:value-of select="concat('urn:www.ubl-italia.org:spec:fatturapa:spese_accessorie_riepilogo::', position())"/>
            </ext:ExtensionURI>
            <ext:ExtensionContent>
               <cbc:Amount currencyID="EUR">
                  <xsl:value-of select="SpeseAccessorie"/>
               </cbc:Amount>
            </ext:ExtensionContent>
         </ext:UBLExtension>
      </xsl:if>
   </xsl:template>
   <xsl:template match="DatiBeniServizi/DatiRiepilogo"
                 mode="Estensione_Arrotondamento_Riepilogo_IVA">
      <xsl:param name="CN" select="."/>
      <xsl:param name="CNP" select="1"/>
      <xsl:if test="Arrotondamento &gt; 0.00">
         <ext:UBLExtension>
            <ext:ExtensionURI>
               <xsl:value-of select="concat('urn:www.ubl-italia.org:spec:fatturapa:arrotondamento_riepilogo::', position())"/>
            </ext:ExtensionURI>
            <ext:ExtensionContent>
               <cbc:Amount currencyID="EUR">
                  <xsl:value-of select="Arrotondamento"/>
               </cbc:Amount>
            </ext:ExtensionContent>
         </ext:UBLExtension>
      </xsl:if>
   </xsl:template>
   <xsl:template match="DatiBeniServizi/DatiRiepilogo[EsigibilitaIVA][1]/EsigibilitaIVA">
      <xsl:param name="CN" select="."/>
      <xsl:param name="CNP" select="1"/>
      <ext:UBLExtension>
         <ext:ExtensionURI>
            <xsl:text>urn:www.ubl-italia.org:spec:fatturapa:esigibilita_iva</xsl:text>
         </ext:ExtensionURI>
         <ext:ExtensionContent>
            <cbc:TaxTypeCode>
               <xsl:value-of select="."/>
            </cbc:TaxTypeCode>
         </ext:ExtensionContent>
      </ext:UBLExtension>
   </xsl:template>
   <xsl:template match="DatiBeniServizi/DettaglioLinee" mode="Estensione_Natura_Riga">
      <xsl:param name="CN" select="."/>
      <xsl:param name="CNP" select="1"/>
      <xsl:if test="contains('|N1|N2|N3|N7|', concat('|', Natura, '|'))">
         <ext:UBLExtension>
            <ext:ExtensionURI>
               <xsl:value-of select="concat('urn:www.ubl-italia.org:spec:fatturapa:xref:natura::', position())"/>
            </ext:ExtensionURI>
            <ext:ExtensionContent>
               <cr:XCode>
                  <xsl:value-of select="Natura"/>
               </cr:XCode>
            </ext:ExtensionContent>
         </ext:UBLExtension>
      </xsl:if>
   </xsl:template>
   <xsl:template match="DatiGenerali/DatiGeneraliDocumento/DatiBollo/ImportoBollo">
      <xsl:param name="CN" select="."/>
      <xsl:param name="CNP" select="1"/>
      <xsl:if test=".">
         <ext:UBLExtension>
            <ext:ExtensionURI>
               <xsl:text>urn:www.ubl-italia.org:spec:fatturapa:bollo</xsl:text>
            </ext:ExtensionURI>
            <ext:ExtensionContent>
               <cbc:TaxAmount currencyID="EUR">
                  <xsl:value-of select="."/>
               </cbc:TaxAmount>
            </ext:ExtensionContent>
         </ext:UBLExtension>
      </xsl:if>
   </xsl:template>
   <xsl:template match="DatiGenerali/DatiGeneraliDocumento/DatiCassaPrevidenziale">
      <xsl:param name="CN" select="."/>
      <xsl:param name="CNP" select="1"/>
      <ext:UBLExtension>
         <ext:ExtensionURI>
            <xsl:value-of select="concat('urn:www.ubl-italia.org:spec:fatturapa:contributo_cassa::', position())"/>
         </ext:ExtensionURI>
         <ext:ExtensionContent>
            <cac:TaxTotal>
               <cbc:TaxAmount>
                  <xsl:variable name="variable_d13e7a1049836">
                     <xsl:value-of select="/in:FatturaElettronica/FatturaElettronicaBody/DatiGenerali/DatiGeneraliDocumento/Divisa"/>
                  </xsl:variable>
                  <xsl:if test="string($variable_d13e7a1049836)">
                     <xsl:attribute name="currencyID">
                        <xsl:value-of select="string($variable_d13e7a1049836)"/>
                     </xsl:attribute>
                  </xsl:if>
                  <xsl:value-of select="ImportoContributoCassa"/>
               </cbc:TaxAmount>
               <cac:TaxSubtotal>
                  <xsl:if test="ImponibileCassa">
                     <cbc:TaxableAmount>
                        <xsl:variable name="variable_d13e9a1049836">
                           <xsl:value-of select="/in:FatturaElettronica/FatturaElettronicaBody/DatiGenerali/DatiGeneraliDocumento/Divisa"/>
                        </xsl:variable>
                        <xsl:if test="string($variable_d13e9a1049836)">
                           <xsl:attribute name="currencyID">
                              <xsl:value-of select="string($variable_d13e9a1049836)"/>
                           </xsl:attribute>
                        </xsl:if>
                        <xsl:value-of select="ImponibileCassa"/>
                     </cbc:TaxableAmount>
                  </xsl:if>
                  <cbc:TaxAmount>
                     <xsl:variable name="variable_d13e10a1049836">
                        <xsl:value-of select="/in:FatturaElettronica/FatturaElettronicaBody/DatiGenerali/DatiGeneraliDocumento/Divisa"/>
                     </xsl:variable>
                     <xsl:if test="string($variable_d13e10a1049836)">
                        <xsl:attribute name="currencyID">
                           <xsl:value-of select="string($variable_d13e10a1049836)"/>
                        </xsl:attribute>
                     </xsl:if>
                     <xsl:value-of select="ImportoContributoCassa"/>
                  </cbc:TaxAmount>
                  <cac:TaxCategory>
                     <cbc:ID schemeID="UNCL5305">
                        <xsl:text>S</xsl:text>
                     </cbc:ID>
                     <cbc:Percent>
                        <xsl:value-of select="AlCassa"/>
                     </cbc:Percent>
                     <cac:TaxScheme>
                        <cbc:ID schemeID="UNCL5153">
                           <xsl:text>SSS</xsl:text>
                        </cbc:ID>
                        <cbc:TaxTypeCode listID="SDICLTC">
                           <xsl:value-of select="TipoCassa"/>
                        </cbc:TaxTypeCode>
                     </cac:TaxScheme>
                  </cac:TaxCategory>
               </cac:TaxSubtotal>
            </cac:TaxTotal>
         </ext:ExtensionContent>
      </ext:UBLExtension>
   </xsl:template>
   <xsl:template match="DatiGenerali/DatiGeneraliDocumento/DatiCassaPrevidenziale/AliquotaIVA">
      <xsl:param name="CN" select="."/>
      <xsl:param name="CNP" select="1"/>
      <xsl:if test=".">
         <ext:UBLExtension>
            <ext:ExtensionURI>
               <xsl:value-of select="concat('urn:www.ubl-italia.org:spec:fatturapa:contributo_cassa:aliquota_iva::', position())"/>
            </ext:ExtensionURI>
            <ext:ExtensionContent>
               <cbc:Percent>
                  <xsl:value-of select="."/>
               </cbc:Percent>
            </ext:ExtensionContent>
         </ext:UBLExtension>
      </xsl:if>
   </xsl:template>
   <xsl:template match="DatiGenerali/DatiGeneraliDocumento/DatiCassaPrevidenziale/Natura">
      <xsl:param name="CN" select="."/>
      <xsl:param name="CNP" select="1"/>
      <xsl:if test=".">
         <ext:UBLExtension>
            <ext:ExtensionURI>
               <xsl:value-of select="concat('urn:www.ubl-italia.org:spec:fatturapa:xref:contributo_cassa:natura_iva::', position())"/>
            </ext:ExtensionURI>
            <ext:ExtensionContent>
               <cr:XCode>
                  <xsl:value-of select="."/>
               </cr:XCode>
            </ext:ExtensionContent>
         </ext:UBLExtension>
      </xsl:if>
   </xsl:template>
   <xsl:template match="DatiGenerali/DatiGeneraliDocumento/DatiCassaPrevidenziale/Ritenuta">
      <xsl:param name="CN" select="."/>
      <xsl:param name="CNP" select="1"/>
      <xsl:if test=".">
         <ext:UBLExtension>
            <ext:ExtensionURI>
               <xsl:value-of select="concat('urn:www.ubl-italia.org:spec:fatturapa:contributo_cassa:ritenuta::', position())"/>
            </ext:ExtensionURI>
            <ext:ExtensionContent>
               <cbc:TaxEvidenceIndicator>
                  <xsl:value-of select="if (. = 'SI') then true() else false()"/>
               </cbc:TaxEvidenceIndicator>
            </ext:ExtensionContent>
         </ext:UBLExtension>
      </xsl:if>
   </xsl:template>
   <xsl:template match="DatiGenerali/DatiGeneraliDocumento/DatiRitenuta">
      <xsl:param name="CN" select="."/>
      <xsl:param name="CNP" select="1"/>
      <ext:UBLExtension>
         <ext:ExtensionURI>
            <xsl:text>urn:www.ubl-italia.org:spec:fatturapa:ritenuta</xsl:text>
         </ext:ExtensionURI>
         <ext:ExtensionContent>
            <cac:WithholdingTaxTotal>
               <cbc:TaxAmount>
                  <xsl:variable name="variable_d13e24a1049836">
                     <xsl:value-of select="/in:FatturaElettronica/FatturaElettronicaBody/DatiGenerali/DatiGeneraliDocumento/Divisa"/>
                  </xsl:variable>
                  <xsl:if test="string($variable_d13e24a1049836)">
                     <xsl:attribute name="currencyID">
                        <xsl:value-of select="string($variable_d13e24a1049836)"/>
                     </xsl:attribute>
                  </xsl:if>
                  <xsl:value-of select="ImportoRitenuta"/>
               </cbc:TaxAmount>
               <cac:TaxSubtotal>
                  <cbc:TaxAmount>
                     <xsl:variable name="variable_d13e26a1049836">
                        <xsl:value-of select="/in:FatturaElettronica/FatturaElettronicaBody/DatiGenerali/DatiGeneraliDocumento/Divisa"/>
                     </xsl:variable>
                     <xsl:if test="string($variable_d13e26a1049836)">
                        <xsl:attribute name="currencyID">
                           <xsl:value-of select="string($variable_d13e26a1049836)"/>
                        </xsl:attribute>
                     </xsl:if>
                     <xsl:value-of select="ImportoRitenuta"/>
                  </cbc:TaxAmount>
                  <cac:TaxCategory>
                     <cbc:ID schemeID="UNCL5305">
                        <xsl:text>S</xsl:text>
                     </cbc:ID>
                     <cbc:Percent>
                        <xsl:value-of select="AliquotaRitenuta"/>
                     </cbc:Percent>
                     <cac:TaxScheme>
                        <cbc:ID schemeID="UNCL5153">
                           <xsl:text>SWT</xsl:text>
                        </cbc:ID>
                        <cbc:TaxTypeCode listID="AE770CP">
                           <xsl:value-of select="CausalePagamento"/>
                        </cbc:TaxTypeCode>
                     </cac:TaxScheme>
                  </cac:TaxCategory>
               </cac:TaxSubtotal>
            </cac:WithholdingTaxTotal>
         </ext:ExtensionContent>
      </ext:UBLExtension>
   </xsl:template>
   <xsl:template match="DatiPagamento/DettaglioPagamento/ModalitaPagamento">
      <xsl:param name="CN" select="."/>
      <xsl:param name="CNP" select="1"/>
      <xsl:if test=". = ('MP04','MP07','MP10','MP11','MP13','MP14','MP16','MP17','MP20','MP21','MP22')">
         <ext:UBLExtension>
            <ext:ExtensionURI>
               <xsl:text>urn:www.ubl-italia.org:spec:fatturapa:modalita_pagamento</xsl:text>
            </ext:ExtensionURI>
            <ext:ExtensionContent>
               <cbc:TypeCode>
                  <xsl:value-of select="."/>
               </cbc:TypeCode>
            </ext:ExtensionContent>
         </ext:UBLExtension>
      </xsl:if>
   </xsl:template>
   <xsl:template match="FatturaElettronicaBody">
      <xsl:param name="CN" select="."/>
      <xsl:param name="CNP" select="1"/>
      <xsl:if test="DatiGenerali/DatiGeneraliDocumento[DatiCassaPrevidenziale or DatiBollo/ImportoBollo or DatiCassaPrevidenziale/AliquotaIVA or DatiCassaPrevidenziale/Ritenuta or DatiCassaPrevidenziale/Natura] or DatiBeniServizi/DettaglioLinee[contains('|N1|N2|N3|N7|', concat('|', Natura, '|'))] or DatiBeniServizi/DatiRiepilogo[EsigibilitaIVA or contains('|N1|N2|N3|N7|', concat('|', Natura, '|'))]">
         <ext:UBLExtensions>
            <xsl:apply-templates select="DatiGenerali/DatiGeneraliDocumento/DatiCassaPrevidenziale">
               <xsl:with-param name="CN" select="current()"/>
               <xsl:with-param name="CNP" select="position()"/>
            </xsl:apply-templates>
            <xsl:apply-templates select="DatiGenerali/DatiGeneraliDocumento/DatiRitenuta">
               <xsl:with-param name="CN" select="current()"/>
               <xsl:with-param name="CNP" select="position()"/>
            </xsl:apply-templates>
            <xsl:apply-templates select="DatiGenerali/DatiGeneraliDocumento/DatiBollo/ImportoBollo">
               <xsl:with-param name="CN" select="current()"/>
               <xsl:with-param name="CNP" select="position()"/>
            </xsl:apply-templates>
            <xsl:apply-templates select="DatiGenerali/DatiGeneraliDocumento/DatiCassaPrevidenziale/AliquotaIVA">
               <xsl:with-param name="CN" select="current()"/>
               <xsl:with-param name="CNP" select="position()"/>
            </xsl:apply-templates>
            <xsl:apply-templates select="DatiGenerali/DatiGeneraliDocumento/DatiCassaPrevidenziale/Ritenuta">
               <xsl:with-param name="CN" select="current()"/>
               <xsl:with-param name="CNP" select="position()"/>
            </xsl:apply-templates>
            <xsl:apply-templates select="DatiBeniServizi/DatiRiepilogo[EsigibilitaIVA][1]/EsigibilitaIVA">
               <xsl:with-param name="CN" select="current()"/>
               <xsl:with-param name="CNP" select="position()"/>
            </xsl:apply-templates>
            <xsl:apply-templates select="DatiGenerali/DatiGeneraliDocumento/DatiCassaPrevidenziale/Natura">
               <xsl:with-param name="CN" select="current()"/>
               <xsl:with-param name="CNP" select="position()"/>
            </xsl:apply-templates>
            <xsl:apply-templates select="DatiBeniServizi/DettaglioLinee" mode="Estensione_Natura_Riga">
               <xsl:with-param name="CN" select="current()"/>
               <xsl:with-param name="CNP" select="position()"/>
            </xsl:apply-templates>
            <xsl:apply-templates select="DatiBeniServizi/DatiRiepilogo" mode="Estensione_Natura_Riepilogo_IVA">
               <xsl:with-param name="CN" select="current()"/>
               <xsl:with-param name="CNP" select="position()"/>
            </xsl:apply-templates>
            <xsl:apply-templates select="DatiPagamento/DettaglioPagamento/ModalitaPagamento">
               <xsl:with-param name="CN" select="current()"/>
               <xsl:with-param name="CNP" select="position()"/>
            </xsl:apply-templates>
            <xsl:apply-templates select="DatiBeniServizi/DatiRiepilogo"
                                 mode="Estensione_SpeseAccessorie_Riepilogo_IVA">
               <xsl:with-param name="CN" select="current()"/>
               <xsl:with-param name="CNP" select="position()"/>
            </xsl:apply-templates>
            <xsl:apply-templates select="DatiBeniServizi/DatiRiepilogo"
                                 mode="Estensione_Arrotondamento_Riepilogo_IVA">
               <xsl:with-param name="CN" select="current()"/>
               <xsl:with-param name="CNP" select="position()"/>
            </xsl:apply-templates>
         </ext:UBLExtensions>
      </xsl:if>
   </xsl:template>
   <xsl:template match="FatturaElettronicaBody/Allegati" mode="Allegati">
      <xsl:param name="CN" select="."/>
      <xsl:param name="CNP" select="1"/>
      <xsl:if test="Attachment">
         <cac:AdditionalDocumentReference>
            <cbc:ID>
               <xsl:value-of select="position()"/>
            </cbc:ID>
            <cbc:DocumentType>
               <xsl:value-of select="NomeAttachment"/>
            </cbc:DocumentType>
            <xsl:if test="DescrizioneAttachment">
               <cbc:DocumentDescription>
                  <xsl:value-of select="DescrizioneAttachment"/>
               </cbc:DocumentDescription>
            </xsl:if>
            <cac:Attachment>
               <cbc:EmbeddedDocumentBinaryObject>
                  <xsl:variable name="variable_d13e185a1050260">
                     <xsl:value-of select="if (document($xclFormatoAttachment)//Value[@ColumnRef='xcode']/SimpleValue[../../Value[@ColumnRef='code']/SimpleValue=current()/upper-case(if (FormatoAttachment) then FormatoAttachment else (if (matches(NomeAttachment, '\.[a-zA-Z]{3,4}$')) then tokenize(NomeAttachment, '\.')[last()] else 'BIN'))][1]) then document($xclFormatoAttachment)//Value[@ColumnRef='xcode']/SimpleValue[../../Value[@ColumnRef='code']/SimpleValue=current()/upper-case(if (FormatoAttachment) then FormatoAttachment else (if (matches(NomeAttachment, '\.[a-zA-Z]{3,4}$')) then tokenize(NomeAttachment, '\.')[last()] else 'BIN'))][1] else 'application/octet-stream'"/>
                  </xsl:variable>
                  <xsl:if test="string($variable_d13e185a1050260)">
                     <xsl:attribute name="mimeCode">
                        <xsl:value-of select="string($variable_d13e185a1050260)"/>
                     </xsl:attribute>
                  </xsl:if>
                  <xsl:value-of select="Attachment"/>
               </cbc:EmbeddedDocumentBinaryObject>
            </cac:Attachment>
         </cac:AdditionalDocumentReference>
      </xsl:if>
   </xsl:template>
   <xsl:template match="FatturaElettronicaBody/DatiBeniServizi/DatiRiepilogo">
      <xsl:param name="CN" select="."/>
      <xsl:param name="CNP" select="1"/>
      <cac:TaxSubtotal>
         <cbc:TaxableAmount>
            <xsl:variable name="variable_d13e423a1049836">
               <xsl:value-of select="/in:FatturaElettronica/FatturaElettronicaBody/DatiGenerali/DatiGeneraliDocumento/Divisa"/>
            </xsl:variable>
            <xsl:if test="string($variable_d13e423a1049836)">
               <xsl:attribute name="currencyID">
                  <xsl:value-of select="string($variable_d13e423a1049836)"/>
               </xsl:attribute>
            </xsl:if>
            <xsl:value-of select="ImponibileImporto"/>
         </cbc:TaxableAmount>
         <cbc:TaxAmount>
            <xsl:variable name="variable_d13e424a1049836">
               <xsl:value-of select="/in:FatturaElettronica/FatturaElettronicaBody/DatiGenerali/DatiGeneraliDocumento/Divisa"/>
            </xsl:variable>
            <xsl:if test="string($variable_d13e424a1049836)">
               <xsl:attribute name="currencyID">
                  <xsl:value-of select="string($variable_d13e424a1049836)"/>
               </xsl:attribute>
            </xsl:if>
            <xsl:value-of select="Imposta"/>
         </cbc:TaxAmount>
         <cac:TaxCategory>
            <cbc:ID schemeID="UNCL5305">
               <xsl:value-of select="if (Natura) then document($xclCategoriaImposte)//Value[@ColumnRef='xcode']/SimpleValue[../../Value[@ColumnRef='code']/SimpleValue=current()/Natura][1] else (if (AliquotaIVA &gt;= 20) then 'S' else 'AA')"/>
            </cbc:ID>
            <cbc:Percent>
               <xsl:value-of select="AliquotaIVA"/>
            </cbc:Percent>
            <xsl:if test="RiferimentoNormativo">
               <cbc:TaxExemptionReason>
                  <xsl:value-of select="RiferimentoNormativo"/>
               </cbc:TaxExemptionReason>
            </xsl:if>
            <cac:TaxScheme>
               <cbc:ID>
                  <xsl:text>VAT</xsl:text>
               </cbc:ID>
            </cac:TaxScheme>
         </cac:TaxCategory>
      </cac:TaxSubtotal>
   </xsl:template>
   <xsl:template match="FatturaElettronicaBody/DatiBeniServizi/DettaglioLinee">
      <xsl:param name="CN" select="."/>
      <xsl:param name="CNP" select="1"/>
      <cac:CreditNoteLine>
         <cbc:ID>
            <xsl:variable name="variable_d13e437a1051010">
               <xsl:value-of select="TipoCessionePrestazione"/>
            </xsl:variable>
            <xsl:if test="string($variable_d13e437a1051010)">
               <xsl:attribute name="schemeID">
                  <xsl:value-of select="string($variable_d13e437a1051010)"/>
               </xsl:attribute>
            </xsl:if>
            <xsl:value-of select="normalize-space(NumeroLinea)"/>
         </cbc:ID>
         <xsl:apply-templates select="AltriDatiGestionali[upper-case(TipoDato)='NOTA']"
                              mode="Nota_AltriDatiGestionali">
            <xsl:with-param name="CN" select="current()"/>
            <xsl:with-param name="CNP" select="position()"/>
         </xsl:apply-templates>
         <cbc:CreditedQuantity unitCodeListID="UNECERec20">
            <xsl:variable name="variable_d13e439a1050145">
               <xsl:value-of select="if (document($xclUnitOfMeasureCode)//Value[@ColumnRef='code']/SimpleValue[../../Value[@ColumnRef='xname']/SimpleValue=current()/UnitaMisura][1]) then document($xclUnitOfMeasureCode)//Value[@ColumnRef='code']/SimpleValue[../../Value[@ColumnRef='xname']/SimpleValue=current()/UnitaMisura][1] else 'C62'"/>
            </xsl:variable>
            <xsl:if test="string($variable_d13e439a1050145)">
               <xsl:attribute name="unitCode">
                  <xsl:value-of select="string($variable_d13e439a1050145)"/>
               </xsl:attribute>
            </xsl:if>
            <xsl:value-of select="if (Quantita) then Quantita else 1.00"/>
         </cbc:CreditedQuantity>
         <cbc:LineExtensionAmount>
            <xsl:variable name="variable_d13e440a1049836">
               <xsl:value-of select="/in:FatturaElettronica/FatturaElettronicaBody/DatiGenerali/DatiGeneraliDocumento/Divisa"/>
            </xsl:variable>
            <xsl:if test="string($variable_d13e440a1049836)">
               <xsl:attribute name="currencyID">
                  <xsl:value-of select="string($variable_d13e440a1049836)"/>
               </xsl:attribute>
            </xsl:if>
            <xsl:value-of select="PrezzoTotale"/>
         </cbc:LineExtensionAmount>
         <xsl:if test="RiferimentoAmministrazione">
            <cbc:AccountingCost>
               <xsl:value-of select="RiferimentoAmministrazione"/>
            </cbc:AccountingCost>
         </xsl:if>
         <xsl:if test="DataInizioPeriodo or DataInizioPeriodo">
            <cac:InvoicePeriod>
               <xsl:if test="DataInizioPeriodo">
                  <cbc:StartDate>
                     <xsl:value-of select="DataInizioPeriodo"/>
                  </cbc:StartDate>
               </xsl:if>
               <xsl:if test="DataFinePeriodo">
                  <cbc:EndDate>
                     <xsl:value-of select="DataFinePeriodo"/>
                  </cbc:EndDate>
               </xsl:if>
            </cac:InvoicePeriod>
         </xsl:if>
         <xsl:apply-templates select="/in:FatturaElettronica/FatturaElettronicaBody/DatiGenerali/DatiOrdineAcquisto"
                              mode="OrderLineReference">
            <xsl:with-param name="CN" select="current()"/>
            <xsl:with-param name="CNP" select="position()"/>
         </xsl:apply-templates>
         <xsl:apply-templates select="/in:FatturaElettronica/FatturaElettronicaBody/DatiGenerali/DatiDDT"
                              mode="DespatchLineReference">
            <xsl:with-param name="CN" select="current()"/>
            <xsl:with-param name="CNP" select="position()"/>
         </xsl:apply-templates>
         <xsl:apply-templates select="AltriDatiGestionali" mode="DatiDDTOriginali">
            <xsl:with-param name="CN" select="current()"/>
            <xsl:with-param name="CNP" select="position()"/>
         </xsl:apply-templates>
         <xsl:apply-templates select="/in:FatturaElettronica/FatturaElettronicaBody/DatiGenerali/DatiFattureCollegate"
                              mode="BillingLineReference">
            <xsl:with-param name="CN" select="current()"/>
            <xsl:with-param name="CNP" select="position()"/>
         </xsl:apply-templates>
         <xsl:apply-templates select="/in:FatturaElettronica/FatturaElettronicaBody/DatiGenerali/DatiOrdineAcquisto/CodiceCommessaConvenzione"
                              mode="CodiceCommessaConvenzione_Riga">
            <xsl:with-param name="CN" select="current()"/>
            <xsl:with-param name="CNP" select="position()"/>
         </xsl:apply-templates>
         <xsl:apply-templates select="/in:FatturaElettronica/FatturaElettronicaBody/DatiGenerali/DatiContratto/CodiceCommessaConvenzione"
                              mode="CodiceCommessaConvenzione_Contratto_Riga">
            <xsl:with-param name="CN" select="current()"/>
            <xsl:with-param name="CNP" select="position()"/>
         </xsl:apply-templates>
         <xsl:apply-templates select="/in:FatturaElettronica/FatturaElettronicaBody/DatiGenerali/DatiConvenzione/CodiceCommessaConvenzione"
                              mode="CodiceCommessaConvenzione_Convenzione_Riga">
            <xsl:with-param name="CN" select="current()"/>
            <xsl:with-param name="CNP" select="position()"/>
         </xsl:apply-templates>
         <xsl:apply-templates select="/in:FatturaElettronica/FatturaElettronicaBody/DatiGenerali/DatiRicezione/CodiceCommessaConvenzione"
                              mode="CodiceCommessaConvenzione_Ricezione_Riga">
            <xsl:with-param name="CN" select="current()"/>
            <xsl:with-param name="CNP" select="position()"/>
         </xsl:apply-templates>
         <xsl:apply-templates select="/in:FatturaElettronica/FatturaElettronicaBody/DatiGenerali/DatiFattureCollegate/CodiceCommessaConvenzione"
                              mode="CodiceCommessaConvenzione_FattureCollegate_Riga">
            <xsl:with-param name="CN" select="current()"/>
            <xsl:with-param name="CNP" select="position()"/>
         </xsl:apply-templates>
         <xsl:apply-templates select="/in:FatturaElettronica/FatturaElettronicaBody/DatiGenerali/DatiOrdineAcquisto/CodiceCUP"
                              mode="CUP_Riga">
            <xsl:with-param name="CN" select="current()"/>
            <xsl:with-param name="CNP" select="position()"/>
         </xsl:apply-templates>
         <xsl:apply-templates select="/in:FatturaElettronica/FatturaElettronicaBody/DatiGenerali/DatiContratto/CodiceCUP"
                              mode="CUP_Contratto_Riga">
            <xsl:with-param name="CN" select="current()"/>
            <xsl:with-param name="CNP" select="position()"/>
         </xsl:apply-templates>
         <xsl:apply-templates select="/in:FatturaElettronica/FatturaElettronicaBody/DatiGenerali/DatiConvenzione/CodiceCUP"
                              mode="CUP_Convenzione_Riga">
            <xsl:with-param name="CN" select="current()"/>
            <xsl:with-param name="CNP" select="position()"/>
         </xsl:apply-templates>
         <xsl:apply-templates select="/in:FatturaElettronica/FatturaElettronicaBody/DatiGenerali/DatiRicezione/CodiceCUP"
                              mode="CUP_Ricezione_Riga">
            <xsl:with-param name="CN" select="current()"/>
            <xsl:with-param name="CNP" select="position()"/>
         </xsl:apply-templates>
         <xsl:apply-templates select="/in:FatturaElettronica/FatturaElettronicaBody/DatiGenerali/DatiFattureCollegate/CodiceCUP"
                              mode="CUP_FattureCollegate_Riga">
            <xsl:with-param name="CN" select="current()"/>
            <xsl:with-param name="CNP" select="position()"/>
         </xsl:apply-templates>
         <xsl:apply-templates select="/in:FatturaElettronica/FatturaElettronicaBody/DatiGenerali/DatiOrdineAcquisto/CodiceCIG"
                              mode="CIG_Riga">
            <xsl:with-param name="CN" select="current()"/>
            <xsl:with-param name="CNP" select="position()"/>
         </xsl:apply-templates>
         <xsl:apply-templates select="/in:FatturaElettronica/FatturaElettronicaBody/DatiGenerali/DatiContratto/CodiceCIG"
                              mode="CIG_Contratto_Riga">
            <xsl:with-param name="CN" select="current()"/>
            <xsl:with-param name="CNP" select="position()"/>
         </xsl:apply-templates>
         <xsl:apply-templates select="/in:FatturaElettronica/FatturaElettronicaBody/DatiGenerali/DatiConvenzione/CodiceCIG"
                              mode="CIG_Convenzione_Riga">
            <xsl:with-param name="CN" select="current()"/>
            <xsl:with-param name="CNP" select="position()"/>
         </xsl:apply-templates>
         <xsl:apply-templates select="/in:FatturaElettronica/FatturaElettronicaBody/DatiGenerali/DatiRicezione/CodiceCIG"
                              mode="CIG_Ricezione_Riga">
            <xsl:with-param name="CN" select="current()"/>
            <xsl:with-param name="CNP" select="position()"/>
         </xsl:apply-templates>
         <xsl:apply-templates select="/in:FatturaElettronica/FatturaElettronicaBody/DatiGenerali/DatiFattureCollegate/CodiceCIG"
                              mode="CIG_FattureCollegate_Riga">
            <xsl:with-param name="CN" select="current()"/>
            <xsl:with-param name="CNP" select="position()"/>
         </xsl:apply-templates>
         <xsl:apply-templates select="/in:FatturaElettronica/FatturaElettronicaBody/DatiGenerali/DatiConvenzione"
                              mode="EstremiConvenzione_Riga">
            <xsl:with-param name="CN" select="current()"/>
            <xsl:with-param name="CNP" select="position()"/>
         </xsl:apply-templates>
         <xsl:apply-templates select="/in:FatturaElettronica/FatturaElettronicaBody/DatiGenerali/DatiContratto"
                              mode="EstremiContratto_Riga">
            <xsl:with-param name="CN" select="current()"/>
            <xsl:with-param name="CNP" select="position()"/>
         </xsl:apply-templates>
         <xsl:apply-templates select="ScontoMaggiorazione" mode="ScontoMaggiorazioneRiga">
            <xsl:with-param name="CN" select="current()"/>
            <xsl:with-param name="CNP" select="position()"/>
         </xsl:apply-templates>
         <cac:Item>
            <cbc:Name>
               <xsl:value-of select="normalize-space(Descrizione)"/>
            </cbc:Name>
            <xsl:apply-templates select="CodiceArticolo[not(CodiceTipo) or upper-case(CodiceTipo) = 'SELLERITEMIDENTIFICATION'][1]"
                                 mode="SellersItemID">
               <xsl:with-param name="CN" select="current()"/>
               <xsl:with-param name="CNP" select="position()"/>
            </xsl:apply-templates>
            <xsl:apply-templates select="CodiceArticolo[upper-case(CodiceTipo)='AICFARMACO'][1]"
                                 mode="StandardItemID">
               <xsl:with-param name="CN" select="current()"/>
               <xsl:with-param name="CNP" select="position()"/>
            </xsl:apply-templates>
            <xsl:apply-templates select="CodiceArticolo[contains(',STANDARDITEMIDENTIFICATION,AIC,EMEA,PARAF,EAN,', concat(',',upper-case(CodiceTipo),','))][1]"
                                 mode="StandardItemID2">
               <xsl:with-param name="CN" select="current()"/>
               <xsl:with-param name="CNP" select="position()"/>
            </xsl:apply-templates>
            <xsl:apply-templates select="CodiceArticolo[not(CodiceTipo)][position() &gt; 1] | CodiceArticolo[CodiceTipo and CodiceTipo!='AICFARMACO' and CodiceTipo!='AIC']"
                                 mode="AdditionalID">
               <xsl:with-param name="CN" select="current()"/>
               <xsl:with-param name="CNP" select="position()"/>
            </xsl:apply-templates>
            <xsl:if test="CodiceArticolo/CodiceTipo[contains(',ITEMCLASSIFICATIONCODE,CPV,UNSPSC,ECL@SS,ECLASS,COMMODITYCODE,TARIC,', concat(',',upper-case(.),','))]">
               <cac:CommodityClassification>
                  <xsl:apply-templates select="CodiceArticolo" mode="CommodityCode">
                     <xsl:with-param name="CN" select="current()"/>
                     <xsl:with-param name="CNP" select="position()"/>
                  </xsl:apply-templates>
                  <xsl:apply-templates select="CodiceArticolo" mode="ItemClassificationCode">
                     <xsl:with-param name="CN" select="current()"/>
                     <xsl:with-param name="CNP" select="position()"/>
                  </xsl:apply-templates>
               </cac:CommodityClassification>
            </xsl:if>
            <cac:ClassifiedTaxCategory>
               <xsl:apply-templates select="AltriDatiGestionali" mode="NaturaOriginale">
                  <xsl:with-param name="CN" select="current()"/>
                  <xsl:with-param name="CNP" select="position()"/>
               </xsl:apply-templates>
               <xsl:if test="not(AltriDatiGestionali[TipoDato='Natura']/RiferimentoTesto)">
                  <cbc:ID schemeID="UNCL5305">
                     <xsl:value-of select="if (Natura) then document($xclCategoriaImposte)//Value[@ColumnRef='xcode']/SimpleValue[../../Value[@ColumnRef='code']/SimpleValue=current()/Natura][1] else (if (AliquotaIVA &gt;= 20) then 'S' else 'AA')"/>
                  </cbc:ID>
               </xsl:if>
               <cbc:Percent>
                  <xsl:value-of select="if (AliquotaIVA) then AliquotaIVA else '0.00'"/>
               </cbc:Percent>
               <cac:TaxScheme>
                  <cbc:ID>
                     <xsl:text>VAT</xsl:text>
                  </cbc:ID>
               </cac:TaxScheme>
            </cac:ClassifiedTaxCategory>
            <xsl:apply-templates select="AltriDatiGestionali[upper-case(TipoDato)!='NOTA' and TipoDato!='DatiDDT' and TipoDato!='Natura']"
                                 mode="AltriDatiGestionali_Item">
               <xsl:with-param name="CN" select="current()"/>
               <xsl:with-param name="CNP" select="position()"/>
            </xsl:apply-templates>
         </cac:Item>
         <cac:Price>
            <cbc:PriceAmount>
               <xsl:variable name="variable_d13e568a1049836">
                  <xsl:value-of select="/in:FatturaElettronica/FatturaElettronicaBody/DatiGenerali/DatiGeneraliDocumento/Divisa"/>
               </xsl:variable>
               <xsl:if test="string($variable_d13e568a1049836)">
                  <xsl:attribute name="currencyID">
                     <xsl:value-of select="string($variable_d13e568a1049836)"/>
                  </xsl:attribute>
               </xsl:if>
               <xsl:value-of select="PrezzoUnitario"/>
            </cbc:PriceAmount>
         </cac:Price>
      </cac:CreditNoteLine>
   </xsl:template>
   <xsl:template match="FatturaElettronicaBody/DatiGenerali/DatiContratto">
      <xsl:param name="CN" select="."/>
      <xsl:param name="CNP" select="1"/>
      <xsl:if test="not(RiferimentoNumeroLinea)">
         <cac:ContractDocumentReference>
            <cbc:ID>
               <xsl:value-of select="IdDocumento"/>
            </cbc:ID>
            <xsl:if test="Data">
               <cbc:IssueDate>
                  <xsl:value-of select="Data"/>
               </cbc:IssueDate>
            </xsl:if>
         </cac:ContractDocumentReference>
      </xsl:if>
   </xsl:template>
   <xsl:template match="FatturaElettronicaBody/DatiGenerali/DatiContratto[not(RiferimentoNumeroLinea)]/CodiceCIG"
                 mode="CIG_CONTRATTO">
      <xsl:param name="CN" select="."/>
      <xsl:param name="CNP" select="1"/>
      <cac:AdditionalDocumentReference>
         <cbc:ID>
            <xsl:value-of select="."/>
         </cbc:ID>
         <cbc:DocumentType>
            <xsl:text>CIG_CONTRATTO</xsl:text>
         </cbc:DocumentType>
      </cac:AdditionalDocumentReference>
   </xsl:template>
   <xsl:template match="FatturaElettronicaBody/DatiGenerali/DatiContratto[not(RiferimentoNumeroLinea)]/CodiceCUP"
                 mode="CUP_CONTRATTO">
      <xsl:param name="CN" select="."/>
      <xsl:param name="CNP" select="1"/>
      <cac:AdditionalDocumentReference>
         <cbc:ID>
            <xsl:value-of select="."/>
         </cbc:ID>
         <cbc:DocumentType>
            <xsl:text>CUP_CONTRATTO</xsl:text>
         </cbc:DocumentType>
      </cac:AdditionalDocumentReference>
   </xsl:template>
   <xsl:template match="FatturaElettronicaBody/DatiGenerali/DatiContratto[not(RiferimentoNumeroLinea)]/CodiceCommessaConvenzione"
                 mode="CodiceCommessaConvenzione_CONTRATTO">
      <xsl:param name="CN" select="."/>
      <xsl:param name="CNP" select="1"/>
      <cac:AdditionalDocumentReference>
         <cbc:ID>
            <xsl:value-of select="."/>
         </cbc:ID>
         <cbc:DocumentType>
            <xsl:text>CommessaConvenzione_CONTRATTO</xsl:text>
         </cbc:DocumentType>
      </cac:AdditionalDocumentReference>
   </xsl:template>
   <xsl:template match="FatturaElettronicaBody/DatiGenerali/DatiConvenzione">
      <xsl:param name="CN" select="."/>
      <xsl:param name="CNP" select="1"/>
      <xsl:if test="not(RiferimentoNumeroLinea)">
         <cac:OriginatorDocumentReference>
            <cbc:ID>
               <xsl:value-of select="IdDocumento"/>
            </cbc:ID>
            <xsl:if test="Data">
               <cbc:IssueDate>
                  <xsl:value-of select="Data"/>
               </cbc:IssueDate>
            </xsl:if>
         </cac:OriginatorDocumentReference>
      </xsl:if>
   </xsl:template>
   <xsl:template match="FatturaElettronicaBody/DatiGenerali/DatiConvenzione[not(RiferimentoNumeroLinea)]/CodiceCIG"
                 mode="CIG_Convenzione">
      <xsl:param name="CN" select="."/>
      <xsl:param name="CNP" select="1"/>
      <cac:AdditionalDocumentReference>
         <cbc:ID>
            <xsl:value-of select="."/>
         </cbc:ID>
         <cbc:DocumentType>
            <xsl:text>CIG_CONVENZIONE</xsl:text>
         </cbc:DocumentType>
      </cac:AdditionalDocumentReference>
   </xsl:template>
   <xsl:template match="FatturaElettronicaBody/DatiGenerali/DatiConvenzione[not(RiferimentoNumeroLinea)]/CodiceCUP"
                 mode="CUP_CONVENZIONE">
      <xsl:param name="CN" select="."/>
      <xsl:param name="CNP" select="1"/>
      <cac:AdditionalDocumentReference>
         <cbc:ID>
            <xsl:value-of select="."/>
         </cbc:ID>
         <cbc:DocumentType>
            <xsl:text>CUP_CONVENZIONE</xsl:text>
         </cbc:DocumentType>
      </cac:AdditionalDocumentReference>
   </xsl:template>
   <xsl:template match="FatturaElettronicaBody/DatiGenerali/DatiConvenzione[not(RiferimentoNumeroLinea)]/CodiceCommessaConvenzione"
                 mode="CodiceCommessaConvenzione_CONVENZIONE">
      <xsl:param name="CN" select="."/>
      <xsl:param name="CNP" select="1"/>
      <cac:AdditionalDocumentReference>
         <cbc:ID>
            <xsl:value-of select="."/>
         </cbc:ID>
         <cbc:DocumentType>
            <xsl:text>CommessaConvenzione_CONVENZIONE</xsl:text>
         </cbc:DocumentType>
      </cac:AdditionalDocumentReference>
   </xsl:template>
   <xsl:template match="FatturaElettronicaBody/DatiGenerali/DatiDDT"
                 mode="DespatchDocumentReference">
      <xsl:param name="CN" select="."/>
      <xsl:param name="CNP" select="1"/>
      <xsl:if test="not(RiferimentoNumeroLinea)">
         <cac:DespatchDocumentReference>
            <cbc:ID>
               <xsl:value-of select="NumeroDDT"/>
            </cbc:ID>
            <xsl:if test="DataDDT">
               <cbc:IssueDate>
                  <xsl:value-of select="DataDDT"/>
               </cbc:IssueDate>
            </xsl:if>
            <cbc:DocumentType>
               <xsl:text>DDT</xsl:text>
            </cbc:DocumentType>
         </cac:DespatchDocumentReference>
      </xsl:if>
   </xsl:template>
   <xsl:template match="FatturaElettronicaBody/DatiGenerali/DatiFattureCollegate"
                 mode="BillingReference">
      <xsl:param name="CN" select="."/>
      <xsl:param name="CNP" select="1"/>
      <xsl:if test="not(RiferimentoNumeroLinea)">
         <cac:BillingReference>
            <cac:InvoiceDocumentReference>
               <cbc:ID>
                  <xsl:value-of select="IdDocumento"/>
               </cbc:ID>
               <xsl:if test="Data">
                  <cbc:IssueDate>
                     <xsl:value-of select="Data"/>
                  </cbc:IssueDate>
               </xsl:if>
            </cac:InvoiceDocumentReference>
         </cac:BillingReference>
      </xsl:if>
   </xsl:template>
   <xsl:template match="FatturaElettronicaBody/DatiGenerali/DatiFattureCollegate[not(RiferimentoNumeroLinea)]/CodiceCIG"
                 mode="CIG_FattureCollegate">
      <xsl:param name="CN" select="."/>
      <xsl:param name="CNP" select="1"/>
      <cac:AdditionalDocumentReference>
         <cbc:ID>
            <xsl:value-of select="."/>
         </cbc:ID>
         <cbc:DocumentType>
            <xsl:text>CIG_FATTURE_COLLEGATE</xsl:text>
         </cbc:DocumentType>
      </cac:AdditionalDocumentReference>
   </xsl:template>
   <xsl:template match="FatturaElettronicaBody/DatiGenerali/DatiFattureCollegate[not(RiferimentoNumeroLinea)]/CodiceCUP"
                 mode="CUP_FATTURE_COLLEGATE">
      <xsl:param name="CN" select="."/>
      <xsl:param name="CNP" select="1"/>
      <cac:AdditionalDocumentReference>
         <cbc:ID>
            <xsl:value-of select="."/>
         </cbc:ID>
         <cbc:DocumentType>
            <xsl:text>CUP_FATTURE_COLLEGATE</xsl:text>
         </cbc:DocumentType>
      </cac:AdditionalDocumentReference>
   </xsl:template>
   <xsl:template match="FatturaElettronicaBody/DatiGenerali/DatiFattureCollegate[not(RiferimentoNumeroLinea)]/CodiceCommessaConvenzione"
                 mode="CodiceCommessaConvenzione_FATTURE_COLLEGATE">
      <xsl:param name="CN" select="."/>
      <xsl:param name="CNP" select="1"/>
      <cac:AdditionalDocumentReference>
         <cbc:ID>
            <xsl:value-of select="."/>
         </cbc:ID>
         <cbc:DocumentType>
            <xsl:text>CommessaConvenzione_FATTURE_COLLEGATE</xsl:text>
         </cbc:DocumentType>
      </cac:AdditionalDocumentReference>
   </xsl:template>
   <xsl:template match="FatturaElettronicaBody/DatiGenerali/DatiGeneraliDocumento"
                 mode="LegalMonetaryTotal">
      <xsl:param name="CN" select="."/>
      <xsl:param name="CNP" select="1"/>
      <cac:LegalMonetaryTotal>
         <xsl:if test="ImportoTotaleDocumento">
            <cbc:TaxInclusiveAmount>
               <xsl:variable name="variable_d13e433a1049836">
                  <xsl:value-of select="Divisa"/>
               </xsl:variable>
               <xsl:if test="string($variable_d13e433a1049836)">
                  <xsl:attribute name="currencyID">
                     <xsl:value-of select="string($variable_d13e433a1049836)"/>
                  </xsl:attribute>
               </xsl:if>
               <xsl:value-of select="ImportoTotaleDocumento"/>
            </cbc:TaxInclusiveAmount>
         </xsl:if>
         <xsl:if test="Arrotondamento &gt; 0.00">
            <cbc:PayableRoundingAmount>
               <xsl:variable name="variable_d13e434a1049836">
                  <xsl:value-of select="Divisa"/>
               </xsl:variable>
               <xsl:if test="string($variable_d13e434a1049836)">
                  <xsl:attribute name="currencyID">
                     <xsl:value-of select="string($variable_d13e434a1049836)"/>
                  </xsl:attribute>
               </xsl:if>
               <xsl:value-of select="Arrotondamento"/>
            </cbc:PayableRoundingAmount>
         </xsl:if>
         <cbc:PayableAmount>
            <xsl:variable name="variable_d13e435a1049836">
               <xsl:value-of select="Divisa"/>
            </xsl:variable>
            <xsl:if test="string($variable_d13e435a1049836)">
               <xsl:attribute name="currencyID">
                  <xsl:value-of select="string($variable_d13e435a1049836)"/>
               </xsl:attribute>
            </xsl:if>
            <xsl:value-of select="if (ImportoTotaleDocumento) then ImportoTotaleDocumento else format-number(sum(/in:FatturaElettronica/FatturaElettronicaBody/DatiBeniServizi/DettaglioLinee/PrezzoTotale)+sum(ScontoMaggiorazione[Tipo='MG']/Importo) -sum(ScontoMaggiorazione[Tipo='SC']/Importo)&#xA;+sum(/in:FatturaElettronica/FatturaElettronicaBody/DatiBeniServizi/DatiRiepilogo/Imposta)+sum(Arrotondamento),'###########0.00')"/>
         </cbc:PayableAmount>
      </cac:LegalMonetaryTotal>
   </xsl:template>
   <xsl:template match="FatturaElettronicaBody/DatiGenerali/DatiGeneraliDocumento/Causale">
      <xsl:param name="CN" select="."/>
      <xsl:param name="CNP" select="1"/>
      <cbc:Note>
         <xsl:value-of select="normalize-space(.)"/>
      </cbc:Note>
   </xsl:template>
   <xsl:template match="FatturaElettronicaBody/DatiGenerali/DatiGeneraliDocumento/ScontoMaggiorazione">
      <xsl:param name="CN" select="."/>
      <xsl:param name="CNP" select="1"/>
      <xsl:if test="Importo">
         <cac:AllowanceCharge>
            <cbc:ChargeIndicator>
               <xsl:value-of select="Tipo = 'MG'"/>
            </cbc:ChargeIndicator>
            <cbc:Amount>
               <xsl:variable name="variable_d13e418a1049836">
                  <xsl:value-of select="/in:FatturaElettronica/FatturaElettronicaBody/DatiGenerali/DatiGeneraliDocumento/Divisa"/>
               </xsl:variable>
               <xsl:if test="string($variable_d13e418a1049836)">
                  <xsl:attribute name="currencyID">
                     <xsl:value-of select="string($variable_d13e418a1049836)"/>
                  </xsl:attribute>
               </xsl:if>
               <xsl:value-of select="Importo"/>
            </cbc:Amount>
         </cac:AllowanceCharge>
      </xsl:if>
   </xsl:template>
   <xsl:template match="FatturaElettronicaBody/DatiGenerali/DatiOrdineAcquisto[1]"
                 mode="OrderReference">
      <xsl:param name="CN" select="."/>
      <xsl:param name="CNP" select="1"/>
      <xsl:if test="IdDocumento and not(RiferimentoNumeroLinea)">
         <cac:OrderReference>
            <cbc:ID>
               <xsl:value-of select="IdDocumento"/>
            </cbc:ID>
            <xsl:if test="Data">
               <cbc:IssueDate>
                  <xsl:value-of select="Data"/>
               </cbc:IssueDate>
            </xsl:if>
         </cac:OrderReference>
      </xsl:if>
   </xsl:template>
   <xsl:template match="FatturaElettronicaBody/DatiGenerali/DatiOrdineAcquisto[not(RiferimentoNumeroLinea)]/CodiceCIG"
                 mode="CIG">
      <xsl:param name="CN" select="."/>
      <xsl:param name="CNP" select="1"/>
      <cac:AdditionalDocumentReference>
         <cbc:ID>
            <xsl:value-of select="."/>
         </cbc:ID>
         <cbc:DocumentType>
            <xsl:text>CIG</xsl:text>
         </cbc:DocumentType>
      </cac:AdditionalDocumentReference>
   </xsl:template>
   <xsl:template match="FatturaElettronicaBody/DatiGenerali/DatiOrdineAcquisto[not(RiferimentoNumeroLinea)]/CodiceCUP"
                 mode="CUP">
      <xsl:param name="CN" select="."/>
      <xsl:param name="CNP" select="1"/>
      <cac:AdditionalDocumentReference>
         <cbc:ID>
            <xsl:value-of select="."/>
         </cbc:ID>
         <cbc:DocumentType>
            <xsl:text>CUP</xsl:text>
         </cbc:DocumentType>
      </cac:AdditionalDocumentReference>
   </xsl:template>
   <xsl:template match="FatturaElettronicaBody/DatiGenerali/DatiOrdineAcquisto[not(RiferimentoNumeroLinea)]/CodiceCommessaConvenzione"
                 mode="CodiceCommessaConvenzione">
      <xsl:param name="CN" select="."/>
      <xsl:param name="CNP" select="1"/>
      <cac:AdditionalDocumentReference>
         <cbc:ID>
            <xsl:value-of select="."/>
         </cbc:ID>
         <cbc:DocumentType>
            <xsl:text>CommessaConvenzione</xsl:text>
         </cbc:DocumentType>
      </cac:AdditionalDocumentReference>
   </xsl:template>
   <xsl:template match="FatturaElettronicaBody/DatiGenerali/DatiOrdineAcquisto[position() &gt; 1]"
                 mode="AdditionalOrders">
      <xsl:param name="CN" select="."/>
      <xsl:param name="CNP" select="1"/>
      <xsl:if test="IdDocumento and not(RiferimentoNumeroLinea)">
         <cac:AdditionalDocumentReference>
            <cbc:ID>
               <xsl:value-of select="IdDocumento"/>
            </cbc:ID>
            <xsl:if test="Data">
               <cbc:IssueDate>
                  <xsl:value-of select="Data"/>
               </cbc:IssueDate>
            </xsl:if>
            <cbc:DocumentType>
               <xsl:text>OrdineAggiuntivo</xsl:text>
            </cbc:DocumentType>
         </cac:AdditionalDocumentReference>
      </xsl:if>
   </xsl:template>
   <xsl:template match="FatturaElettronicaBody/DatiGenerali/DatiRicezione">
      <xsl:param name="CN" select="."/>
      <xsl:param name="CNP" select="1"/>
      <xsl:if test="not(RiferimentoNumeroLinea)">
         <cac:ReceiptDocumentReference>
            <cbc:ID>
               <xsl:value-of select="IdDocumento"/>
            </cbc:ID>
            <xsl:if test="Data">
               <cbc:IssueDate>
                  <xsl:value-of select="Data"/>
               </cbc:IssueDate>
            </xsl:if>
         </cac:ReceiptDocumentReference>
      </xsl:if>
   </xsl:template>
   <xsl:template match="FatturaElettronicaBody/DatiGenerali/DatiRicezione[not(RiferimentoNumeroLinea)]/CodiceCIG"
                 mode="CIG_Ricezione">
      <xsl:param name="CN" select="."/>
      <xsl:param name="CNP" select="1"/>
      <cac:AdditionalDocumentReference>
         <cbc:ID>
            <xsl:value-of select="."/>
         </cbc:ID>
         <cbc:DocumentType>
            <xsl:text>CIG_RICEZIONE</xsl:text>
         </cbc:DocumentType>
      </cac:AdditionalDocumentReference>
   </xsl:template>
   <xsl:template match="FatturaElettronicaBody/DatiGenerali/DatiRicezione[not(RiferimentoNumeroLinea)]/CodiceCUP"
                 mode="CUP_RICEZIONE">
      <xsl:param name="CN" select="."/>
      <xsl:param name="CNP" select="1"/>
      <cac:AdditionalDocumentReference>
         <cbc:ID>
            <xsl:value-of select="."/>
         </cbc:ID>
         <cbc:DocumentType>
            <xsl:text>CUP_RICEZIONE</xsl:text>
         </cbc:DocumentType>
      </cac:AdditionalDocumentReference>
   </xsl:template>
   <xsl:template match="FatturaElettronicaBody/DatiGenerali/DatiRicezione[not(RiferimentoNumeroLinea)]/CodiceCommessaConvenzione"
                 mode="CodiceCommessaConvenzione_RICEZIONE">
      <xsl:param name="CN" select="."/>
      <xsl:param name="CNP" select="1"/>
      <cac:AdditionalDocumentReference>
         <cbc:ID>
            <xsl:value-of select="."/>
         </cbc:ID>
         <cbc:DocumentType>
            <xsl:text>CommessaConvenzione_RICEZIONE</xsl:text>
         </cbc:DocumentType>
      </cac:AdditionalDocumentReference>
   </xsl:template>
   <xsl:template match="FatturaElettronicaBody/DatiGenerali/DatiSAL">
      <xsl:param name="CN" select="."/>
      <xsl:param name="CNP" select="1"/>
      <xsl:if test="RiferimentoFase">
         <cac:AdditionalDocumentReference>
            <cbc:ID>
               <xsl:value-of select="RiferimentoFase"/>
            </cbc:ID>
            <cbc:DocumentType>
               <xsl:text>SAL</xsl:text>
            </cbc:DocumentType>
         </cac:AdditionalDocumentReference>
      </xsl:if>
   </xsl:template>
   <xsl:template match="FatturaElettronicaBody/DatiGenerali/DatiTrasporto/TipoResa">
      <xsl:param name="CN" select="."/>
      <xsl:param name="CNP" select="1"/>
      <cac:DeliveryTerms>
         <cbc:ID>
            <xsl:value-of select="."/>
         </cbc:ID>
      </cac:DeliveryTerms>
   </xsl:template>
   <xsl:template match="FatturaElettronicaBody/DatiGenerali/FatturaPrincipale">
      <xsl:param name="CN" select="."/>
      <xsl:param name="CNP" select="1"/>
      <cac:BillingReference>
         <cac:InvoiceDocumentReference>
            <cbc:ID>
               <xsl:value-of select="NumeroFatturaPrincipale"/>
            </cbc:ID>
            <cbc:IssueDate>
               <xsl:value-of select="DataFatturaPrincipale"/>
            </cbc:IssueDate>
            <cbc:DocumentType>
               <xsl:text>FatturaPrincipale</xsl:text>
            </cbc:DocumentType>
         </cac:InvoiceDocumentReference>
      </cac:BillingReference>
   </xsl:template>
   <xsl:template match="FatturaElettronicaBody/DatiPagamento/DettaglioPagamento"
                 mode="ModalitàPagamento">
      <xsl:param name="CN" select="."/>
      <xsl:param name="CNP" select="1"/>
      <cac:PaymentMeans>
         <cbc:PaymentMeansCode listID="UNCL4461">
            <xsl:value-of select="if ((document($xclPaymentMeansCode)//Value[@ColumnRef='code']/SimpleValue[../../Value[@ColumnRef='xcode']/SimpleValue=current()/ModalitaPagamento])[1]) then (document($xclPaymentMeansCode)//Value[@ColumnRef='code']/SimpleValue[../../Value[@ColumnRef='xcode']/SimpleValue=current()/ModalitaPagamento])[1] else '9'"/>
         </cbc:PaymentMeansCode>
         <xsl:if test="DataScadenzaPagamento">
            <cbc:PaymentDueDate>
               <xsl:value-of select="DataScadenzaPagamento"/>
            </cbc:PaymentDueDate>
         </xsl:if>
         <cbc:PaymentChannelCode>
            <xsl:value-of select="if (IBAN) then 'IBAN' else 'LOCAL'"/>
         </cbc:PaymentChannelCode>
         <xsl:if test="CodicePagamento">
            <cbc:PaymentID>
               <xsl:value-of select="CodicePagamento"/>
            </cbc:PaymentID>
         </xsl:if>
         <xsl:if test="IBAN or CAB or ABI or BIC or IstitutoFinanziario">
            <cac:PayeeFinancialAccount>
               <xsl:if test="IBAN">
                  <cbc:ID>
                     <xsl:variable name="variable_d13e398a1051010">
                        <xsl:value-of select="if (IBAN) then 'IBAN' else 'LOCAL'"/>
                     </xsl:variable>
                     <xsl:if test="string($variable_d13e398a1051010)">
                        <xsl:attribute name="schemeID">
                           <xsl:value-of select="string($variable_d13e398a1051010)"/>
                        </xsl:attribute>
                     </xsl:if>
                     <xsl:value-of select="IBAN"/>
                  </cbc:ID>
               </xsl:if>
               <xsl:if test="Beneficiario">
                  <cbc:Name>
                     <xsl:value-of select="Beneficiario"/>
                  </cbc:Name>
               </xsl:if>
               <xsl:if test="CAB or ABI or BIC or IstitutoFinanziario">
                  <cac:FinancialInstitutionBranch>
                     <xsl:if test="CAB">
                        <cbc:ID schemeID="CAB">
                           <xsl:value-of select="CAB"/>
                        </cbc:ID>
                     </xsl:if>
                     <xsl:if test="ABI or BIC or IstitutoFinanziario">
                        <cac:FinancialInstitution>
                           <xsl:if test="BIC">
                              <cbc:ID schemeID="BIC">
                                 <xsl:value-of select="BIC"/>
                              </cbc:ID>
                           </xsl:if>
                           <xsl:if test="ABI and not(BIC)">
                              <cbc:ID schemeID="ABI">
                                 <xsl:value-of select="ABI"/>
                              </cbc:ID>
                           </xsl:if>
                           <xsl:if test="IstitutoFinanziario">
                              <cbc:Name>
                                 <xsl:value-of select="IstitutoFinanziario"/>
                              </cbc:Name>
                           </xsl:if>
                        </cac:FinancialInstitution>
                     </xsl:if>
                  </cac:FinancialInstitutionBranch>
               </xsl:if>
            </cac:PayeeFinancialAccount>
         </xsl:if>
      </cac:PaymentMeans>
   </xsl:template>
   <xsl:template match="FatturaElettronicaBody/DatiPagamento[1]/DettaglioPagamento[1]"
                 mode="TerminiPagamento">
      <xsl:param name="CN" select="."/>
      <xsl:param name="CNP" select="1"/>
      <cac:PaymentTerms>
         <xsl:if test="ImportoPagamento">
            <cbc:Amount>
               <xsl:variable name="variable_d13e407a1049836">
                  <xsl:value-of select="/in:FatturaElettronica/FatturaElettronicaBody/DatiGenerali/DatiGeneraliDocumento/Divisa"/>
               </xsl:variable>
               <xsl:if test="string($variable_d13e407a1049836)">
                  <xsl:attribute name="currencyID">
                     <xsl:value-of select="string($variable_d13e407a1049836)"/>
                  </xsl:attribute>
               </xsl:if>
               <xsl:value-of select="ImportoPagamento"/>
            </cbc:Amount>
         </xsl:if>
         <xsl:if test="ScontoPagamentoAnticipato &gt; 0.00">
            <cbc:SettlementDiscountAmount>
               <xsl:variable name="variable_d13e408a1049836">
                  <xsl:value-of select="/in:FatturaElettronica/FatturaElettronicaBody/DatiGenerali/DatiGeneraliDocumento/Divisa"/>
               </xsl:variable>
               <xsl:if test="string($variable_d13e408a1049836)">
                  <xsl:attribute name="currencyID">
                     <xsl:value-of select="string($variable_d13e408a1049836)"/>
                  </xsl:attribute>
               </xsl:if>
               <xsl:value-of select="ScontoPagamentoAnticipato"/>
            </cbc:SettlementDiscountAmount>
         </xsl:if>
         <xsl:if test="PenalitaPagamentiRitardati &gt; 0.00">
            <cbc:PenaltyAmount>
               <xsl:variable name="variable_d13e409a1049836">
                  <xsl:value-of select="/in:FatturaElettronica/FatturaElettronicaBody/DatiGenerali/DatiGeneraliDocumento/Divisa"/>
               </xsl:variable>
               <xsl:if test="string($variable_d13e409a1049836)">
                  <xsl:attribute name="currencyID">
                     <xsl:value-of select="string($variable_d13e409a1049836)"/>
                  </xsl:attribute>
               </xsl:if>
               <xsl:value-of select="PenalitaPagamentiRitardati"/>
            </cbc:PenaltyAmount>
         </xsl:if>
         <xsl:if test="DataRiferimentoTerminiPagamento or DataLimitePagamentoAnticipato or GiorniTerminiPagamento">
            <cac:SettlementPeriod>
               <xsl:if test="DataRiferimentoTerminiPagamento">
                  <cbc:StartDate>
                     <xsl:value-of select="DataRiferimentoTerminiPagamento"/>
                  </cbc:StartDate>
               </xsl:if>
               <xsl:if test="DataLimitePagamentoAnticipato">
                  <cbc:EndDate>
                     <xsl:value-of select="DataLimitePagamentoAnticipato"/>
                  </cbc:EndDate>
               </xsl:if>
               <xsl:if test="GiorniTerminiPagamento">
                  <cbc:DurationMeasure unitCode="DAY">
                     <xsl:value-of select="GiorniTerminiPagamento"/>
                  </cbc:DurationMeasure>
               </xsl:if>
            </cac:SettlementPeriod>
         </xsl:if>
         <xsl:if test="DataDecorrenzaPenale">
            <cac:PenaltyPeriod>
               <cbc:StartDate>
                  <xsl:value-of select="DataDecorrenzaPenale"/>
               </cbc:StartDate>
            </cac:PenaltyPeriod>
         </xsl:if>
      </cac:PaymentTerms>
   </xsl:template>
   <xsl:template match="FatturaElettronicaBody/DatiPagamento[1]/DettaglioPagamento[Beneficiario][1]">
      <xsl:param name="CN" select="."/>
      <xsl:param name="CNP" select="1"/>
      <cac:PayeeParty>
         <cac:PartyName>
            <cbc:Name>
               <xsl:value-of select="Beneficiario"/>
            </cbc:Name>
         </cac:PartyName>
      </cac:PayeeParty>
   </xsl:template>
   <xsl:template match="FatturaElettronicaHeader/CedentePrestatore">
      <xsl:param name="CN" select="."/>
      <xsl:param name="CNP" select="1"/>
      <cac:AccountingSupplierParty>
         <xsl:if test="RiferimentoAmministrazione">
            <cbc:CustomerAssignedAccountID>
               <xsl:value-of select="RiferimentoAmministrazione"/>
            </cbc:CustomerAssignedAccountID>
         </xsl:if>
         <cac:Party>
            <xsl:apply-templates select="DatiAnagrafici/Anagrafica/Denominazione" mode="NomeCedentePrestatore1">
               <xsl:with-param name="CN" select="current()"/>
               <xsl:with-param name="CNP" select="position()"/>
            </xsl:apply-templates>
            <xsl:apply-templates select="DatiAnagrafici/Anagrafica[Nome or Cognome]"
                                 mode="NomeCedentePrestatore2">
               <xsl:with-param name="CN" select="current()"/>
               <xsl:with-param name="CNP" select="position()"/>
            </xsl:apply-templates>
            <xsl:apply-templates select="Sede" mode="Sede_CedentePrestatore">
               <xsl:with-param name="CN" select="current()"/>
               <xsl:with-param name="CNP" select="position()"/>
            </xsl:apply-templates>
            <cac:PartyTaxScheme>
               <xsl:apply-templates select="DatiAnagrafici/IdFiscaleIVA" mode="VAT_CedentePrestatore">
                  <xsl:with-param name="CN" select="current()"/>
                  <xsl:with-param name="CNP" select="position()"/>
               </xsl:apply-templates>
               <cac:TaxScheme>
                  <cbc:ID>
                     <xsl:text>VAT</xsl:text>
                  </cbc:ID>
                  <xsl:if test="DatiAnagrafici/RegimeFiscale">
                     <cbc:TaxTypeCode>
                        <xsl:value-of select="DatiAnagrafici/RegimeFiscale"/>
                     </cbc:TaxTypeCode>
                  </xsl:if>
               </cac:TaxScheme>
            </cac:PartyTaxScheme>
            <xsl:if test="string-length(DatiAnagrafici/CodiceFiscale) = 11">
               <cac:PartyTaxScheme>
                  <cbc:CompanyID schemeID="IT:CF">
                     <xsl:value-of select="concat('IT', DatiAnagrafici/CodiceFiscale)"/>
                  </cbc:CompanyID>
                  <cac:TaxScheme>
                     <cbc:ID>
                        <xsl:text>VAT</xsl:text>
                     </cbc:ID>
                  </cac:TaxScheme>
               </cac:PartyTaxScheme>
            </xsl:if>
            <xsl:if test="DatiAnagrafici/NumeroIscrizioneAlbo">
               <cac:PartyLegalEntity>
                  <cbc:CompanyID schemeID="ZZZ">
                     <xsl:value-of select="&#x9;DatiAnagrafici/NumeroIscrizioneAlbo&#x9;"/>
                  </cbc:CompanyID>
                  <xsl:if test="DatiAnagrafici/DataIscrizioneAlbo">
                     <cbc:RegistrationDate>
                        <xsl:value-of select="DatiAnagrafici/DataIscrizioneAlbo"/>
                     </cbc:RegistrationDate>
                  </xsl:if>
                  <xsl:apply-templates select="DatiAnagrafici/ProvinciaAlbo">
                     <xsl:with-param name="CN" select="current()"/>
                     <xsl:with-param name="CNP" select="position()"/>
                  </xsl:apply-templates>
                  <xsl:apply-templates select="DatiAnagrafici/AlboProfessionale">
                     <xsl:with-param name="CN" select="current()"/>
                     <xsl:with-param name="CNP" select="position()"/>
                  </xsl:apply-templates>
               </cac:PartyLegalEntity>
            </xsl:if>
            <xsl:apply-templates select="IscrizioneREA">
               <xsl:with-param name="CN" select="current()"/>
               <xsl:with-param name="CNP" select="position()"/>
            </xsl:apply-templates>
            <xsl:apply-templates select="Contatti">
               <xsl:with-param name="CN" select="current()"/>
               <xsl:with-param name="CNP" select="position()"/>
            </xsl:apply-templates>
            <xsl:apply-templates select="DatiAnagrafici" mode="Persona_CedentePrestatore">
               <xsl:with-param name="CN" select="current()"/>
               <xsl:with-param name="CNP" select="position()"/>
            </xsl:apply-templates>
            <xsl:apply-templates select="/in:FatturaElettronica/FatturaElettronicaHeader/CedentePrestatore/StabileOrganizzazione">
               <xsl:with-param name="CN" select="current()"/>
               <xsl:with-param name="CNP" select="position()"/>
            </xsl:apply-templates>
            <xsl:apply-templates select="/in:FatturaElettronica/FatturaElettronicaHeader/TerzoIntermediarioOSoggettoEmittente/DatiAnagrafici">
               <xsl:with-param name="CN" select="current()"/>
               <xsl:with-param name="CNP" select="position()"/>
            </xsl:apply-templates>
            <xsl:apply-templates select="/in:FatturaElettronica/FatturaElettronicaHeader/DatiTrasmissione">
               <xsl:with-param name="CN" select="current()"/>
               <xsl:with-param name="CNP" select="position()"/>
            </xsl:apply-templates>
         </cac:Party>
      </cac:AccountingSupplierParty>
   </xsl:template>
   <xsl:template match="FatturaElettronicaHeader/CedentePrestatore/DatiAnagrafici/Anagrafica/CodEORI">
      <xsl:param name="CN" select="."/>
      <xsl:param name="CNP" select="1"/>
      <cac:AdditionalDocumentReference>
         <cbc:ID>
            <xsl:value-of select="."/>
         </cbc:ID>
         <cbc:DocumentType>
            <xsl:text>EORI CedentePrestatore</xsl:text>
         </cbc:DocumentType>
      </cac:AdditionalDocumentReference>
   </xsl:template>
   <xsl:template match="FatturaElettronicaHeader/CessionarioCommittente">
      <xsl:param name="CN" select="."/>
      <xsl:param name="CNP" select="1"/>
      <cac:AccountingCustomerParty>
         <cac:Party>
            <xsl:apply-templates select="/in:FatturaElettronica/FatturaElettronicaHeader/DatiTrasmissione/CodiceDestinatario">
               <xsl:with-param name="CN" select="current()"/>
               <xsl:with-param name="CNP" select="position()"/>
            </xsl:apply-templates>
            <xsl:apply-templates select="DatiAnagrafici/Anagrafica/Denominazione"
                                 mode="NomeCessionarioCommittente1">
               <xsl:with-param name="CN" select="current()"/>
               <xsl:with-param name="CNP" select="position()"/>
            </xsl:apply-templates>
            <xsl:apply-templates select="DatiAnagrafici/Anagrafica[Nome or Cognome]"
                                 mode="NomeCessionarioCommittente2">
               <xsl:with-param name="CN" select="current()"/>
               <xsl:with-param name="CNP" select="position()"/>
            </xsl:apply-templates>
            <xsl:apply-templates select="Sede" mode="Sede_CessionarioCommittente">
               <xsl:with-param name="CN" select="current()"/>
               <xsl:with-param name="CNP" select="position()"/>
            </xsl:apply-templates>
            <xsl:apply-templates select="DatiAnagrafici/IdFiscaleIVA" mode="VAT_CessionaroCommittente">
               <xsl:with-param name="CN" select="current()"/>
               <xsl:with-param name="CNP" select="position()"/>
            </xsl:apply-templates>
            <xsl:apply-templates select="DatiAnagrafici/CodiceFiscale" mode="CF_CessionaroCommittente">
               <xsl:with-param name="CN" select="current()"/>
               <xsl:with-param name="CNP" select="position()"/>
            </xsl:apply-templates>
            <cac:Contact>
               <xsl:if test="/in:FatturaElettronica/FatturaElettronicaHeader/DatiTrasmissione/PECDestinatario">
                  <cbc:ElectronicMail>
                     <xsl:value-of select="concat('pec:', /in:FatturaElettronica/FatturaElettronicaHeader/DatiTrasmissione/PECDestinatario)"/>
                  </cbc:ElectronicMail>
               </xsl:if>
            </cac:Contact>
            <xsl:apply-templates select="DatiAnagrafici" mode="Persona_CessionarioCommittente">
               <xsl:with-param name="CN" select="current()"/>
               <xsl:with-param name="CNP" select="position()"/>
            </xsl:apply-templates>
         </cac:Party>
      </cac:AccountingCustomerParty>
   </xsl:template>
   <xsl:template match="FatturaElettronicaHeader/RappresentanteFiscale">
      <xsl:param name="CN" select="."/>
      <xsl:param name="CNP" select="1"/>
      <cac:TaxRepresentativeParty>
         <xsl:apply-templates select="DatiAnagrafici/Anagrafica/Denominazione"
                              mode="NomeRappresentanteFiscale1">
            <xsl:with-param name="CN" select="current()"/>
            <xsl:with-param name="CNP" select="position()"/>
         </xsl:apply-templates>
         <xsl:apply-templates select="DatiAnagrafici/Anagrafica[Nome or Cognome]"
                              mode="NomeRappresentanteFiscale2">
            <xsl:with-param name="CN" select="current()"/>
            <xsl:with-param name="CNP" select="position()"/>
         </xsl:apply-templates>
         <cac:PartyTaxScheme>
            <xsl:apply-templates select="DatiAnagrafici/IdFiscaleIVA">
               <xsl:with-param name="CN" select="current()"/>
               <xsl:with-param name="CNP" select="position()"/>
            </xsl:apply-templates>
            <cac:TaxScheme>
               <cbc:ID>
                  <xsl:text>VAT</xsl:text>
               </cbc:ID>
            </cac:TaxScheme>
         </cac:PartyTaxScheme>
         <xsl:apply-templates select="DatiAnagrafici/CodiceFiscale">
            <xsl:with-param name="CN" select="current()"/>
            <xsl:with-param name="CNP" select="position()"/>
         </xsl:apply-templates>
         <xsl:apply-templates select="DatiAnagrafici" mode="Persona_RappresentanteFiscale">
            <xsl:with-param name="CN" select="current()"/>
            <xsl:with-param name="CNP" select="position()"/>
         </xsl:apply-templates>
      </cac:TaxRepresentativeParty>
   </xsl:template>
   <xsl:template match="IdFiscaleIVA" mode="VAT_SoggettoEmittente">
      <xsl:param name="CN" select="."/>
      <xsl:param name="CNP" select="1"/>
      <cbc:CompanyID>
         <xsl:variable name="variable_d13e268a1051010">
            <xsl:value-of select="document($xclVATSchemes)//Value[@ColumnRef='VATSchemeID']/SimpleValue[../../Value[@ColumnRef='code']/SimpleValue=current()/upper-case(IdPaese)][1]"/>
         </xsl:variable>
         <xsl:if test="string($variable_d13e268a1051010)">
            <xsl:attribute name="schemeID">
               <xsl:value-of select="string($variable_d13e268a1051010)"/>
            </xsl:attribute>
         </xsl:if>
         <xsl:value-of select="concat(IdPaese, IdCodice)"/>
      </cbc:CompanyID>
   </xsl:template>
   <xsl:template match="IdFiscaleIVA">
      <xsl:param name="CN" select="."/>
      <xsl:param name="CNP" select="1"/>
      <cbc:CompanyID>
         <xsl:variable name="variable_d13e372a1051010">
            <xsl:value-of select="document($xclVATSchemes)//Value[@ColumnRef='VATSchemeID']/SimpleValue[../../Value[@ColumnRef='code']/SimpleValue=current()/upper-case(IdPaese)][1]"/>
         </xsl:variable>
         <xsl:if test="string($variable_d13e372a1051010)">
            <xsl:attribute name="schemeID">
               <xsl:value-of select="string($variable_d13e372a1051010)"/>
            </xsl:attribute>
         </xsl:if>
         <xsl:value-of select="concat(IdPaese, IdCodice)"/>
      </cbc:CompanyID>
   </xsl:template>
   <xsl:template match="IndirizzoResa">
      <xsl:param name="CN" select="."/>
      <xsl:param name="CNP" select="1"/>
      <cac:DeliveryLocation>
         <cac:Address>
            <xsl:if test="Indirizzo">
               <cbc:StreetName>
                  <xsl:value-of select="if (matches(Indirizzo, '(\s|,)(\d+|s.n.c|snc)')) then if (NumeroCivico and matches(Indirizzo, concat('(\s|,)',NumeroCivico))) then Indirizzo else concat(Indirizzo, ', ', NumeroCivico) else concat(Indirizzo, if (NumeroCivico) then concat(', ', NumeroCivico) else ' s.n.c.')"/>
               </cbc:StreetName>
            </xsl:if>
            <xsl:if test="Comune">
               <cbc:CityName>
                  <xsl:value-of select="Comune"/>
               </cbc:CityName>
            </xsl:if>
            <xsl:if test="CAP">
               <cbc:PostalZone>
                  <xsl:value-of select="CAP"/>
               </cbc:PostalZone>
            </xsl:if>
            <xsl:if test="Provincia">
               <cbc:CountrySubentity>
                  <xsl:value-of select="Provincia"/>
               </cbc:CountrySubentity>
            </xsl:if>
            <cac:Country>
               <xsl:if test="Nazione">
                  <cbc:IdentificationCode listID="ISO3166-1:Alpha2">
                     <xsl:value-of select="Nazione"/>
                  </cbc:IdentificationCode>
               </xsl:if>
            </cac:Country>
         </cac:Address>
      </cac:DeliveryLocation>
   </xsl:template>
   <xsl:template match="IscrizioneREA">
      <xsl:param name="CN" select="."/>
      <xsl:param name="CNP" select="1"/>
      <cac:PartyLegalEntity>
         <xsl:if test="NumeroREA">
            <cbc:CompanyID schemeID="ZZZ">
               <xsl:value-of select="NumeroREA&#x9;"/>
            </cbc:CompanyID>
         </xsl:if>
         <xsl:if test="SocioUnico = 'SU'">
            <cbc:SoleProprietorshipIndicator>
               <xsl:value-of select="true()"/>
            </cbc:SoleProprietorshipIndicator>
         </xsl:if>
         <cbc:CompanyLiquidationStatusCode>
            <xsl:value-of select="StatoLiquidazione"/>
         </cbc:CompanyLiquidationStatusCode>
         <xsl:if test="CapitaleSociale">
            <cbc:CorporateStockAmount>
               <xsl:variable name="variable_d13e237a1049836">
                  <xsl:value-of select="/in:FatturaElettronica/FatturaElettronicaBody/DatiGenerali/DatiGeneraliDocumento/Divisa"/>
               </xsl:variable>
               <xsl:if test="string($variable_d13e237a1049836)">
                  <xsl:attribute name="currencyID">
                     <xsl:value-of select="string($variable_d13e237a1049836)"/>
                  </xsl:attribute>
               </xsl:if>
               <xsl:value-of select="CapitaleSociale"/>
            </cbc:CorporateStockAmount>
         </xsl:if>
         <cac:RegistrationAddress>
            <xsl:if test="Ufficio">
               <cbc:CityName>
                  <xsl:value-of select="Ufficio"/>
               </cbc:CityName>
            </xsl:if>
         </cac:RegistrationAddress>
         <cac:CorporateRegistrationScheme>
            <cbc:Name>
               <xsl:text>REA</xsl:text>
            </cbc:Name>
         </cac:CorporateRegistrationScheme>
      </cac:PartyLegalEntity>
   </xsl:template>
   <xsl:template match="ScontoMaggiorazione" mode="ScontoMaggiorazioneRiga">
      <xsl:param name="CN" select="."/>
      <xsl:param name="CNP" select="1"/>
      <xsl:if test="Importo">
         <cac:AllowanceCharge>
            <cbc:ChargeIndicator>
               <xsl:value-of select="if (Tipo = 'MG') then true() else false()"/>
            </cbc:ChargeIndicator>
            <cbc:Amount>
               <xsl:variable name="variable_d13e543a1049836">
                  <xsl:value-of select="/in:FatturaElettronica/FatturaElettronicaBody/DatiGenerali/DatiGeneraliDocumento/Divisa"/>
               </xsl:variable>
               <xsl:if test="string($variable_d13e543a1049836)">
                  <xsl:attribute name="currencyID">
                     <xsl:value-of select="string($variable_d13e543a1049836)"/>
                  </xsl:attribute>
               </xsl:if>
               <xsl:value-of select="Importo"/>
            </cbc:Amount>
         </cac:AllowanceCharge>
      </xsl:if>
   </xsl:template>
   <xsl:template match="Sede" mode="Sede_CedentePrestatore">
      <xsl:param name="CN" select="."/>
      <xsl:param name="CNP" select="1"/>
      <cac:PostalAddress>
         <cbc:StreetName>
            <xsl:value-of select="if (matches(Indirizzo, '(\s|,)(\d+|s.n.c|snc)')) then if (NumeroCivico and matches(Indirizzo, concat('(\s|,)',NumeroCivico))) then Indirizzo else concat(Indirizzo, ', ', NumeroCivico) else concat(Indirizzo, if (NumeroCivico) then concat(', ', NumeroCivico) else ' s.n.c.')"/>
         </cbc:StreetName>
         <cbc:CityName>
            <xsl:value-of select="Comune"/>
         </cbc:CityName>
         <cbc:PostalZone>
            <xsl:value-of select="CAP"/>
         </cbc:PostalZone>
         <xsl:if test="Provincia">
            <cbc:CountrySubentity>
               <xsl:value-of select="Provincia"/>
            </cbc:CountrySubentity>
         </xsl:if>
         <cac:Country>
            <cbc:IdentificationCode listID="ISO3166-1:Alpha2">
               <xsl:value-of select="Nazione"/>
            </cbc:IdentificationCode>
         </cac:Country>
      </cac:PostalAddress>
   </xsl:template>
   <xsl:template match="Sede" mode="Sede_CessionarioCommittente">
      <xsl:param name="CN" select="."/>
      <xsl:param name="CNP" select="1"/>
      <cac:PostalAddress>
         <cbc:StreetName>
            <xsl:value-of select="if (matches(Indirizzo, '(\s|,)(\d+|s.n.c|snc)')) then if (NumeroCivico and matches(Indirizzo, concat('(\s|,)',NumeroCivico))) then Indirizzo else concat(Indirizzo, ', ', NumeroCivico) else concat(Indirizzo, if (NumeroCivico) then concat(', ', NumeroCivico) else ' s.n.c.')"/>
         </cbc:StreetName>
         <cbc:CityName>
            <xsl:value-of select="Comune"/>
         </cbc:CityName>
         <cbc:PostalZone>
            <xsl:value-of select="CAP"/>
         </cbc:PostalZone>
         <xsl:if test="Provincia">
            <cbc:CountrySubentity>
               <xsl:value-of select="Provincia"/>
            </cbc:CountrySubentity>
         </xsl:if>
         <cac:Country>
            <cbc:IdentificationCode listID="ISO3166-1:Alpha2">
               <xsl:value-of select="Nazione"/>
            </cbc:IdentificationCode>
         </cac:Country>
      </cac:PostalAddress>
   </xsl:template>
   <xsl:template match="/in:FatturaElettronica" name="root">
      <xsl:param name="CN" select="."/>
      <xsl:param name="CNP" select="1"/>
      <CreditNote>
         <xsl:apply-templates select="FatturaElettronicaBody">
            <xsl:with-param name="CN" select="current()"/>
            <xsl:with-param name="CNP" select="position()"/>
         </xsl:apply-templates>
         <cbc:UBLVersionID>
            <xsl:text>2.1</xsl:text>
         </cbc:UBLVersionID>
         <cbc:CustomizationID>
            <xsl:text>urn:www.cenbii.eu:transaction:biitrns014:ver2.0:extended:urn:www.peppol.eu:bis:peppol5a:ver2.0:extended:urn:www.ubl-italia.org:spec:fatturapa:ver2.0</xsl:text>
         </cbc:CustomizationID>
         <cbc:ProfileID>
            <xsl:text>urn:www.cenbii.eu:profile:bii05:ver2.0</xsl:text>
         </cbc:ProfileID>
         <cbc:ID>
            <xsl:variable name="variable_d13e85a1051010">
               <xsl:value-of select="if (FatturaElettronicaBody/DatiGenerali/DatiGeneraliDocumento/Art73) then 'art73dpr633/72' else ''"/>
            </xsl:variable>
            <xsl:if test="string($variable_d13e85a1051010)">
               <xsl:attribute name="schemeID">
                  <xsl:value-of select="string($variable_d13e85a1051010)"/>
               </xsl:attribute>
            </xsl:if>
            <xsl:value-of select="FatturaElettronicaBody/DatiGenerali/DatiGeneraliDocumento/Numero"/>
         </cbc:ID>
         <cbc:UUID>
            <xsl:value-of select="FatturaElettronicaHeader/DatiTrasmissione/ProgressivoInvio"/>
         </cbc:UUID>
         <cbc:IssueDate>
            <xsl:value-of select="FatturaElettronicaBody/DatiGenerali/DatiGeneraliDocumento/Data"/>
         </cbc:IssueDate>
         <xsl:apply-templates select="FatturaElettronicaBody/DatiGenerali/DatiGeneraliDocumento/Causale">
            <xsl:with-param name="CN" select="current()"/>
            <xsl:with-param name="CNP" select="position()"/>
         </xsl:apply-templates>
         <cbc:DocumentCurrencyCode listID="ISO4217">
            <xsl:value-of select="FatturaElettronicaBody/DatiGenerali/DatiGeneraliDocumento/Divisa"/>
         </cbc:DocumentCurrencyCode>
         <xsl:apply-templates select="FatturaElettronicaBody/DatiGenerali/DatiOrdineAcquisto[1]"
                              mode="OrderReference">
            <xsl:with-param name="CN" select="current()"/>
            <xsl:with-param name="CNP" select="position()"/>
         </xsl:apply-templates>
         <xsl:apply-templates select="FatturaElettronicaBody/DatiGenerali/DatiFattureCollegate"
                              mode="BillingReference">
            <xsl:with-param name="CN" select="current()"/>
            <xsl:with-param name="CNP" select="position()"/>
         </xsl:apply-templates>
         <xsl:apply-templates select="FatturaElettronicaBody/DatiGenerali/FatturaPrincipale">
            <xsl:with-param name="CN" select="current()"/>
            <xsl:with-param name="CNP" select="position()"/>
         </xsl:apply-templates>
         <xsl:apply-templates select="FatturaElettronicaBody/DatiGenerali/DatiDDT"
                              mode="DespatchDocumentReference">
            <xsl:with-param name="CN" select="current()"/>
            <xsl:with-param name="CNP" select="position()"/>
         </xsl:apply-templates>
         <xsl:apply-templates select="FatturaElettronicaBody/DatiGenerali/DatiRicezione">
            <xsl:with-param name="CN" select="current()"/>
            <xsl:with-param name="CNP" select="position()"/>
         </xsl:apply-templates>
         <xsl:apply-templates select="FatturaElettronicaBody/DatiGenerali/DatiContratto">
            <xsl:with-param name="CN" select="current()"/>
            <xsl:with-param name="CNP" select="position()"/>
         </xsl:apply-templates>
         <xsl:apply-templates select="FatturaElettronicaBody/DatiGenerali/DatiOrdineAcquisto[not(RiferimentoNumeroLinea)]/CodiceCommessaConvenzione"
                              mode="CodiceCommessaConvenzione">
            <xsl:with-param name="CN" select="current()"/>
            <xsl:with-param name="CNP" select="position()"/>
         </xsl:apply-templates>
         <xsl:apply-templates select="FatturaElettronicaBody/DatiGenerali/DatiContratto[not(RiferimentoNumeroLinea)]/CodiceCommessaConvenzione"
                              mode="CodiceCommessaConvenzione_CONTRATTO">
            <xsl:with-param name="CN" select="current()"/>
            <xsl:with-param name="CNP" select="position()"/>
         </xsl:apply-templates>
         <xsl:apply-templates select="FatturaElettronicaBody/DatiGenerali/DatiConvenzione[not(RiferimentoNumeroLinea)]/CodiceCommessaConvenzione"
                              mode="CodiceCommessaConvenzione_CONVENZIONE">
            <xsl:with-param name="CN" select="current()"/>
            <xsl:with-param name="CNP" select="position()"/>
         </xsl:apply-templates>
         <xsl:apply-templates select="FatturaElettronicaBody/DatiGenerali/DatiRicezione[not(RiferimentoNumeroLinea)]/CodiceCommessaConvenzione"
                              mode="CodiceCommessaConvenzione_RICEZIONE">
            <xsl:with-param name="CN" select="current()"/>
            <xsl:with-param name="CNP" select="position()"/>
         </xsl:apply-templates>
         <xsl:apply-templates select="FatturaElettronicaBody/DatiGenerali/DatiFattureCollegate[not(RiferimentoNumeroLinea)]/CodiceCommessaConvenzione"
                              mode="CodiceCommessaConvenzione_FATTURE_COLLEGATE">
            <xsl:with-param name="CN" select="current()"/>
            <xsl:with-param name="CNP" select="position()"/>
         </xsl:apply-templates>
         <xsl:apply-templates select="FatturaElettronicaBody/DatiGenerali/DatiOrdineAcquisto[not(RiferimentoNumeroLinea)]/CodiceCUP"
                              mode="CUP">
            <xsl:with-param name="CN" select="current()"/>
            <xsl:with-param name="CNP" select="position()"/>
         </xsl:apply-templates>
         <xsl:apply-templates select="FatturaElettronicaBody/DatiGenerali/DatiContratto[not(RiferimentoNumeroLinea)]/CodiceCUP"
                              mode="CUP_CONTRATTO">
            <xsl:with-param name="CN" select="current()"/>
            <xsl:with-param name="CNP" select="position()"/>
         </xsl:apply-templates>
         <xsl:apply-templates select="FatturaElettronicaBody/DatiGenerali/DatiConvenzione[not(RiferimentoNumeroLinea)]/CodiceCUP"
                              mode="CUP_CONVENZIONE">
            <xsl:with-param name="CN" select="current()"/>
            <xsl:with-param name="CNP" select="position()"/>
         </xsl:apply-templates>
         <xsl:apply-templates select="FatturaElettronicaBody/DatiGenerali/DatiRicezione[not(RiferimentoNumeroLinea)]/CodiceCUP"
                              mode="CUP_RICEZIONE">
            <xsl:with-param name="CN" select="current()"/>
            <xsl:with-param name="CNP" select="position()"/>
         </xsl:apply-templates>
         <xsl:apply-templates select="FatturaElettronicaBody/DatiGenerali/DatiFattureCollegate[not(RiferimentoNumeroLinea)]/CodiceCUP"
                              mode="CUP_FATTURE_COLLEGATE">
            <xsl:with-param name="CN" select="current()"/>
            <xsl:with-param name="CNP" select="position()"/>
         </xsl:apply-templates>
         <xsl:apply-templates select="FatturaElettronicaBody/DatiGenerali/DatiOrdineAcquisto[not(RiferimentoNumeroLinea)]/CodiceCIG"
                              mode="CIG">
            <xsl:with-param name="CN" select="current()"/>
            <xsl:with-param name="CNP" select="position()"/>
         </xsl:apply-templates>
         <xsl:apply-templates select="FatturaElettronicaBody/DatiGenerali/DatiContratto[not(RiferimentoNumeroLinea)]/CodiceCIG"
                              mode="CIG_CONTRATTO">
            <xsl:with-param name="CN" select="current()"/>
            <xsl:with-param name="CNP" select="position()"/>
         </xsl:apply-templates>
         <xsl:apply-templates select="FatturaElettronicaBody/DatiGenerali/DatiConvenzione[not(RiferimentoNumeroLinea)]/CodiceCIG"
                              mode="CIG_Convenzione">
            <xsl:with-param name="CN" select="current()"/>
            <xsl:with-param name="CNP" select="position()"/>
         </xsl:apply-templates>
         <xsl:apply-templates select="FatturaElettronicaBody/DatiGenerali/DatiRicezione[not(RiferimentoNumeroLinea)]/CodiceCIG"
                              mode="CIG_Ricezione">
            <xsl:with-param name="CN" select="current()"/>
            <xsl:with-param name="CNP" select="position()"/>
         </xsl:apply-templates>
         <xsl:apply-templates select="FatturaElettronicaBody/DatiGenerali/DatiFattureCollegate[not(RiferimentoNumeroLinea)]/CodiceCIG"
                              mode="CIG_FattureCollegate">
            <xsl:with-param name="CN" select="current()"/>
            <xsl:with-param name="CNP" select="position()"/>
         </xsl:apply-templates>
         <xsl:apply-templates select="FatturaElettronicaBody/DatiGenerali/DatiSAL">
            <xsl:with-param name="CN" select="current()"/>
            <xsl:with-param name="CNP" select="position()"/>
         </xsl:apply-templates>
         <xsl:apply-templates select="FatturaElettronicaBody/Allegati" mode="Allegati">
            <xsl:with-param name="CN" select="current()"/>
            <xsl:with-param name="CNP" select="position()"/>
         </xsl:apply-templates>
         <xsl:apply-templates select="FatturaElettronicaHeader/CedentePrestatore/DatiAnagrafici/Anagrafica/CodEORI">
            <xsl:with-param name="CN" select="current()"/>
            <xsl:with-param name="CNP" select="position()"/>
         </xsl:apply-templates>
         <xsl:apply-templates select="FatturaElettronicaBody/DatiGenerali/DatiOrdineAcquisto[position() &gt; 1]"
                              mode="AdditionalOrders">
            <xsl:with-param name="CN" select="current()"/>
            <xsl:with-param name="CNP" select="position()"/>
         </xsl:apply-templates>
         <xsl:apply-templates select="FatturaElettronicaBody/DatiGenerali/DatiConvenzione">
            <xsl:with-param name="CN" select="current()"/>
            <xsl:with-param name="CNP" select="position()"/>
         </xsl:apply-templates>
         <xsl:apply-templates select="FatturaElettronicaHeader/CedentePrestatore">
            <xsl:with-param name="CN" select="current()"/>
            <xsl:with-param name="CNP" select="position()"/>
         </xsl:apply-templates>
         <xsl:apply-templates select="FatturaElettronicaHeader/CessionarioCommittente">
            <xsl:with-param name="CN" select="current()"/>
            <xsl:with-param name="CNP" select="position()"/>
         </xsl:apply-templates>
         <xsl:apply-templates select="FatturaElettronicaBody/DatiPagamento[1]/DettaglioPagamento[Beneficiario][1]">
            <xsl:with-param name="CN" select="current()"/>
            <xsl:with-param name="CNP" select="position()"/>
         </xsl:apply-templates>
         <xsl:apply-templates select="FatturaElettronicaHeader/RappresentanteFiscale">
            <xsl:with-param name="CN" select="current()"/>
            <xsl:with-param name="CNP" select="position()"/>
         </xsl:apply-templates>
         <xsl:apply-templates select="/in:FatturaElettronica/FatturaElettronicaBody/DatiGenerali/DatiTrasporto">
            <xsl:with-param name="CN" select="current()"/>
            <xsl:with-param name="CNP" select="position()"/>
         </xsl:apply-templates>
         <xsl:apply-templates select="FatturaElettronicaBody/DatiGenerali/DatiTrasporto/TipoResa">
            <xsl:with-param name="CN" select="current()"/>
            <xsl:with-param name="CNP" select="position()"/>
         </xsl:apply-templates>
         <xsl:apply-templates select="FatturaElettronicaBody/DatiPagamento/DettaglioPagamento"
                              mode="ModalitàPagamento">
            <xsl:with-param name="CN" select="current()"/>
            <xsl:with-param name="CNP" select="position()"/>
         </xsl:apply-templates>
         <xsl:apply-templates select="FatturaElettronicaBody/DatiPagamento[1]/DettaglioPagamento[1]"
                              mode="TerminiPagamento">
            <xsl:with-param name="CN" select="current()"/>
            <xsl:with-param name="CNP" select="position()"/>
         </xsl:apply-templates>
         <xsl:apply-templates select="FatturaElettronicaBody/DatiGenerali/DatiGeneraliDocumento/ScontoMaggiorazione">
            <xsl:with-param name="CN" select="current()"/>
            <xsl:with-param name="CNP" select="position()"/>
         </xsl:apply-templates>
         <cac:TaxTotal>
            <cbc:TaxAmount>
               <xsl:variable name="variable_d13e421a1049836">
                  <xsl:value-of select="FatturaElettronicaBody/DatiGenerali/DatiGeneraliDocumento/Divisa"/>
               </xsl:variable>
               <xsl:if test="string($variable_d13e421a1049836)">
                  <xsl:attribute name="currencyID">
                     <xsl:value-of select="string($variable_d13e421a1049836)"/>
                  </xsl:attribute>
               </xsl:if>
               <xsl:value-of select="format-number(sum(FatturaElettronicaBody/DatiBeniServizi/DatiRiepilogo/Imposta),'###########0.00')"/>
            </cbc:TaxAmount>
            <xsl:apply-templates select="FatturaElettronicaBody/DatiBeniServizi/DatiRiepilogo">
               <xsl:with-param name="CN" select="current()"/>
               <xsl:with-param name="CNP" select="position()"/>
            </xsl:apply-templates>
         </cac:TaxTotal>
         <xsl:apply-templates select="FatturaElettronicaBody/DatiGenerali/DatiGeneraliDocumento"
                              mode="LegalMonetaryTotal">
            <xsl:with-param name="CN" select="current()"/>
            <xsl:with-param name="CNP" select="position()"/>
         </xsl:apply-templates>
         <xsl:apply-templates select="FatturaElettronicaBody/DatiBeniServizi/DettaglioLinee">
            <xsl:with-param name="CN" select="current()"/>
            <xsl:with-param name="CNP" select="position()"/>
         </xsl:apply-templates>
      </CreditNote>
   </xsl:template>

   <xsl:template match="/">
      <xsl:apply-templates select="/in:FatturaElettronica"/>
   </xsl:template>
</xsl:stylesheet>