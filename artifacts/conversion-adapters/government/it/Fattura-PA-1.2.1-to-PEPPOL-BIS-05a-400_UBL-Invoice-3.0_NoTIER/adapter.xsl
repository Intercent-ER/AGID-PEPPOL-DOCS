<?xml version="1.0" encoding="UTF-8"?>
<!--Stylesheet synthesized using Javest A2A Mapper environment.-->

<xsl:stylesheet xmlns:ds="http://www.w3.org/2000/09/xmldsig#"
   xmlns:ext="urn:oasis:names:specification:ubl:schema:xsd:CommonExtensionComponents-2"
   xmlns="urn:oasis:names:specification:ubl:schema:xsd:Invoice-2"
   xmlns:in="http://ivaservizi.agenziaentrate.gov.it/docs/xsd/fatture/v1.2"
   xmlns:xsmap="http://www.javest.com/ns/mapper/snippet"
   xmlns:asmap="http://www.javest.com/ns/mapper/snippet/attribute"
   xmlns:cac="urn:oasis:names:specification:ubl:schema:xsd:CommonAggregateComponents-2"
   xmlns:cbc="urn:oasis:names:specification:ubl:schema:xsd:CommonBasicComponents-2"
   xmlns:xsd="http://www.w3.org/2001/XMLSchema"
   xmlns:ccts="urn:un:unece:uncefact:documentation:2"
   xmlns:cr="http://www.ubl-italia.org/ns/CrossReference"
   xmlns:xsl="http://www.w3.org/1999/XSL/Transform" exclude-result-prefixes="xsmap asmap in ds" version="2.0">
   <xsl:output indent="no"/>
   <xsl:param name="xclTipoDocumento" as="xsd:string">xcl/TipoDocumento.gc</xsl:param>
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
   <xsl:template match="/in:FatturaElettronica" mode="SistemaEmittente">
      <xsl:param name="CN" select="."/>
      <xsl:param name="CNP" select="1"/>
      <xsl:if test=".[@SistemaEmittente]">
         <ext:UBLExtension>
            <ext:ExtensionURI>
               <xsl:text>urn:fdc:agid.gov.it:fatturapa:SistemaEmittente</xsl:text>
            </ext:ExtensionURI>
            <ext:ExtensionContent>
               <cbc:Description>
                  <xsl:value-of select="@SistemaEmittente"/>
               </cbc:Description>
            </ext:ExtensionContent>
         </ext:UBLExtension>
      </xsl:if>
   </xsl:template>
   <xsl:template match="/in:FatturaElettronica/FatturaElettronicaHeader/SoggettoEmittente">
      <xsl:param name="CN" select="."/>
      <xsl:param name="CNP" select="1"/>
      <xsl:if test=".[@SistemaEmittente]">
         <ext:UBLExtension>
            <ext:ExtensionURI>
               <xsl:text>urn:fdc:agid.gov.it:fatturapa:SoggettoEmittente</xsl:text>
            </ext:ExtensionURI>
            <ext:ExtensionContent>
               <cbc:TypeCode>
                  <xsl:value-of select="."/>
               </cbc:TypeCode>
            </ext:ExtensionContent>
         </ext:UBLExtension>
      </xsl:if>
   </xsl:template>
   <xsl:template match="/in:FatturaElettronica/FatturaElettronicaBody/DatiGenerali/DatiContratto/CodiceCIG" mode="CIG_Contratto_Riga">
      <xsl:param name="CN" select="."/>
      <xsl:param name="CNP" select="1"/>
      <xsl:if test="../RiferimentoNumeroLinea[normalize-space()]=$CN/NumeroLinea[normalize-space()]">
         <cac:DocumentReference>
            <cbc:ID>
               <xsl:if test=".">
                  <xsl:attribute name="schemeID">
                     <xsl:text>AGB</xsl:text>
                  </xsl:attribute>
               </xsl:if>
               <xsl:value-of select="."/>
            </cbc:ID>
            <cbc:DocumentTypeCode>
               <xsl:text>130</xsl:text>
            </cbc:DocumentTypeCode>
         </cac:DocumentReference>
      </xsl:if>
   </xsl:template>
   <xsl:template match="/in:FatturaElettronica/FatturaElettronicaBody/DatiGenerali/DatiContratto/CodiceCUP" mode="CUP_Contratto_Riga">
      <xsl:param name="CN" select="."/>
      <xsl:param name="CNP" select="1"/>
      <xsl:if test="../RiferimentoNumeroLinea[normalize-space()]=$CN/NumeroLinea[normalize-space()]">
         <cac:DocumentReference>
            <cbc:ID>
               <xsl:if test=".">
                  <xsl:attribute name="schemeID">
                     <xsl:text>AEP</xsl:text>
                  </xsl:attribute>
               </xsl:if>
               <xsl:value-of select="."/>
            </cbc:ID>
            <cbc:DocumentTypeCode>
               <xsl:text>130</xsl:text>
            </cbc:DocumentTypeCode>
         </cac:DocumentReference>
      </xsl:if>
   </xsl:template>
   <xsl:template match="/in:FatturaElettronica/FatturaElettronicaBody/DatiGenerali/DatiContratto/IdDocumento" mode="Contratto_Riga">
      <xsl:param name="CN" select="."/>
      <xsl:param name="CNP" select="1"/>
      <xsl:if test="../RiferimentoNumeroLinea[normalize-space()]=$CN/NumeroLinea[normalize-space()]">
         <cac:DocumentReference>
            <cbc:ID>
               <xsl:if test=".">
                  <xsl:attribute name="schemeID">
                     <xsl:text>CT</xsl:text>
                  </xsl:attribute>
               </xsl:if>
               <xsl:value-of select="."/>
            </cbc:ID>
            <cbc:DocumentTypeCode>
               <xsl:text>130</xsl:text>
            </cbc:DocumentTypeCode>
         </cac:DocumentReference>
      </xsl:if>
   </xsl:template>
   <xsl:template match="/in:FatturaElettronica/FatturaElettronicaBody/DatiGenerali/DatiConvenzione/CodiceCommessaConvenzione" mode="CodiceCommessaConvenzione_Convenzione_Riga">
      <xsl:param name="CN" select="."/>
      <xsl:param name="CNP" select="1"/>
      <xsl:if test="../RiferimentoNumeroLinea[normalize-space()]=$CN/NumeroLinea[normalize-space()]">
         <cac:DocumentReference>
            <cbc:ID>
               <xsl:if test=".">
                  <xsl:attribute name="schemeID">
                     <xsl:text>AVV</xsl:text>
                  </xsl:attribute>
               </xsl:if>
               <xsl:value-of select="."/>
            </cbc:ID>
            <cbc:DocumentTypeCode>
               <xsl:text>130</xsl:text>
            </cbc:DocumentTypeCode>
         </cac:DocumentReference>
      </xsl:if>
   </xsl:template>
   <xsl:template match="/in:FatturaElettronica/FatturaElettronicaBody/DatiGenerali/DatiDDT" mode="DespatchLineReference">
      <xsl:param name="CN" select="."/>
      <xsl:param name="CNP" select="1"/>
      <xsl:if test="(RiferimentoNumeroLinea[normalize-space()]=$CN/NumeroLinea[normalize-space()] or (RiferimentoNumeroLinea and count(../../DatiBeniServizi/DettaglioLinee)=1)) and count($CN/AltriDatiGestionali[TipoDato = 'DatiDDT']) = 0">
         <cac:DespatchLineReference>
            <cbc:LineID>
               <xsl:text>NA</xsl:text>
            </cbc:LineID>
            <cac:DocumentReference>
               <cbc:ID>
                  <xsl:value-of select="NumeroDDT"/>
               </cbc:ID>
               <cbc:IssueDate>
                  <xsl:value-of select="DataDDT"/>
               </cbc:IssueDate>
            </cac:DocumentReference>
         </cac:DespatchLineReference>
      </xsl:if>
   </xsl:template>
   <xsl:template match="/in:FatturaElettronica/FatturaElettronicaBody/DatiGenerali/DatiOrdineAcquisto" mode="OrderLineReference">
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
   <xsl:template match="/in:FatturaElettronica/FatturaElettronicaBody/DatiGenerali/DatiOrdineAcquisto/CodiceCommessaConvenzione" mode="CodiceCommessaConvenzione_Riga">
      <xsl:param name="CN" select="."/>
      <xsl:param name="CNP" select="1"/>
      <xsl:if test="../RiferimentoNumeroLinea[normalize-space()]=$CN/NumeroLinea[normalize-space()] or (../RiferimentoNumeroLinea and count(../../../DatiBeniServizi/DettaglioLinee)=1)">
         <cac:DocumentReference>
            <cbc:ID>
               <xsl:if test=".">
                  <xsl:attribute name="schemeID">
                     <xsl:text>ON</xsl:text>
                  </xsl:attribute>
               </xsl:if>
               <xsl:value-of select="concat(../IdDocumento, '#', ../Data, '#', .)"/>
            </cbc:ID>
            <cbc:DocumentTypeCode>
               <xsl:text>130</xsl:text>
            </cbc:DocumentTypeCode>
         </cac:DocumentReference>
      </xsl:if>
   </xsl:template>
   <xsl:template match="/in:FatturaElettronica/FatturaElettronicaBody/DatiGenerali/DatiTrasporto">
      <xsl:param name="CN" select="."/>
      <xsl:param name="CNP" select="1"/>
      <xsl:if test="NumeroColli &gt; 0 or DataInizioTrasporto or IndirizzoResa or DatiAnagraficiVettore or PesoLordo &gt; 0.00 or PesoNetto &gt; 0.00">
         <cac:Delivery>
            <xsl:if test="DataOraConsegna and not(DataOraConsegna = /in:FatturaElettronica/FatturaElettronicaBody/DatiGenerali/Data)">
               <cbc:ActualDeliveryDate>
                  <xsl:value-of select="DataOraConsegna"/>
               </cbc:ActualDeliveryDate>
            </xsl:if>
            <xsl:apply-templates select="IndirizzoResa">
               <xsl:with-param name="CN" select="current()"/>
               <xsl:with-param name="CNP" select="position()"/>
            </xsl:apply-templates>
            <xsl:if test="DatiAnagraficiVettore">
               <xsl:apply-templates select="DatiAnagraficiVettore">
                  <xsl:with-param name="CN" select="current()"/>
                  <xsl:with-param name="CNP" select="position()"/>
               </xsl:apply-templates>
            </xsl:if>
            <xsl:if test="CasualeTrasporto or DataOraRitiro or DataInizioTrasporto">
               <cac:Despatch>
                  <xsl:if test="CasualeTrasporto">
                     <cbc:Instructions>
                        <xsl:value-of select="CasualeTrasporto"/>
                     </cbc:Instructions>
                  </xsl:if>
                  <xsl:if test="DataOraRitiro">
                     <xsl:if test="contains(DataOraRitiro, 'T')">
                        <cbc:RequestDespatchDate>
                           <xsl:value-of select="substring-before(DataOraRitiro, 'T')"/>
                        </cbc:RequestDespatchDate>
                        <cbc:RequestDespatchTime>
                           <xsl:value-of select="substring-after(DataOraRitiro, 'T')"/>
                        </cbc:RequestDespatchTime>
                     </xsl:if>
                     <xsl:if test="not(contains(DataOraRitiro, 'T'))">
                        <cbc:RequestDespatchDate>
                           <xsl:value-of select="DataOraRitiro"/>
                        </cbc:RequestDespatchDate>
                     </xsl:if>
                  </xsl:if>
                  <xsl:if test="DataInizioTrasporto">
                     <cbc:ActualDespatchDate>
                        <xsl:value-of select="DataInizioTrasporto"/>
                     </cbc:ActualDespatchDate>
                  </xsl:if>
               </cac:Despatch>
            </xsl:if>
            <xsl:if test="PesoLordo &gt; 0.00 or PesoNetto &gt; 0.00 or NumeroColli or Descrizione or MezzoTrasporto">
               <cac:Shipment>
                  <cbc:ID>
                     <xsl:text>NA</xsl:text>
                  </cbc:ID>
                  <xsl:if test="PesoLordo &gt; 0.00">
                     <cbc:GrossWeightMeasure>
                        <xsl:attribute name="unitCode">
                           <xsl:value-of select="UnitaMisuraPeso"/>
                        </xsl:attribute>
                        <xsl:value-of select="PesoLordo"/>
                     </cbc:GrossWeightMeasure>
                  </xsl:if>
                  <xsl:if test="PesoNetto &gt; 0.00">
                     <cbc:NetWeightMeasure>
                        <xsl:attribute name="unitCode">
                           <xsl:value-of select="UnitaMisuraPeso"/>
                        </xsl:attribute>
                        <xsl:value-of select="PesoNetto"/>
                     </cbc:NetWeightMeasure>
                  </xsl:if>
                  <xsl:if test="NumeroColli">
                     <cbc:TotalTransportHandlingUnitQuantity>
                        <xsl:value-of select="NumeroColli"/>
                     </cbc:TotalTransportHandlingUnitQuantity>
                  </xsl:if>
                  <xsl:if test="Descrizione">
                     <cac:GoodsItem>
                        <cbc:Description>
                           <xsl:value-of select="Descrizione"/>
                        </cbc:Description>
                     </cac:GoodsItem>
                  </xsl:if>
                  <xsl:if test="MezzoTrasporto">
                     <cac:ShipmentStage>
                        <cbc:TransportMeansTypeCode>
                           <xsl:value-of select="MezzoTrasporto"/>
                        </cbc:TransportMeansTypeCode>
                     </cac:ShipmentStage>
                     <!-- <cbc:NetWeightMeasure>
                        <xsl:variable name="variable_d1e393a1050145">
                           <xsl:value-of select="if (document($xclUnitOfMeasureCode)//Value[@ColumnRef='code']/SimpleValue[../../Value[@ColumnRef='xname']/SimpleValue=current()/UnitaMisuraPeso][1]) then document($xclUnitOfMeasureCode)//Value[@ColumnRef='code']/SimpleValue[../../Value[@ColumnRef='xname']/SimpleValue=current()/UnitaMisuraPeso][1] else 'KGM'"/>
                        </xsl:variable>
                        <xsl:if test="string($variable_d1e393a1050145)">
                           <xsl:attribute name="unitCode">
                              <xsl:value-of select="string($variable_d1e393a1050145)"/>
                           </xsl:attribute>
                        </xsl:if>
                        <xsl:value-of select="PesoNetto"/>
                     </cbc:NetWeightMeasure> -->
                  </xsl:if>
               </cac:Shipment>
            </xsl:if>
         </cac:Delivery>
      </xsl:if>
   </xsl:template>
   <xsl:template match="StabileOrganizzazione" mode="StabileOrganizzazione_CedentePrestatore">
      <xsl:param name="CN" select="."/>
      <xsl:param name="CNP" select="1"/>
      <xsl:if test=".">
         <cac:AgentParty>
            <cac:PostalAddress>
               <cbc:StreetName>
                  <xsl:value-of select="if (matches(Indirizzo, '(\s|,)(\d+|s.n.c|snc)')) then if (NumeroCivico) then if (matches(Indirizzo, concat('(\s|,)',NumeroCivico))) then Indirizzo else concat(Indirizzo, ', ', NumeroCivico) else Indirizzo else concat(Indirizzo, if (NumeroCivico) then concat(', ', NumeroCivico) else '')"/>
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
                  <cbc:IdentificationCode>
                     <xsl:value-of select="Nazione"/>
                  </cbc:IdentificationCode>
               </cac:Country>
            </cac:PostalAddress>
         </cac:AgentParty>
      </xsl:if>
   </xsl:template>
   <xsl:template match="StabileOrganizzazione" mode="StabileOrganizzazione_CessionarioCommittente">
      <xsl:param name="CN" select="."/>
      <xsl:param name="CNP" select="1"/>
      <xsl:if test=".">
         <cac:AgentParty>
            <cac:PostalAddress>
               <cbc:StreetName>
                  <xsl:value-of select="if (matches(Indirizzo, '(\s|,)(\d+|s.n.c|snc)')) then if (NumeroCivico) then if (matches(Indirizzo, concat('(\s|,)',NumeroCivico))) then Indirizzo else concat(Indirizzo, ', ', NumeroCivico) else Indirizzo else concat(Indirizzo, if (NumeroCivico) then concat(', ', NumeroCivico) else '')"/>
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
                  <cbc:IdentificationCode>
                     <xsl:value-of select="Nazione"/>
                  </cbc:IdentificationCode>
               </cac:Country>
            </cac:PostalAddress>
         </cac:AgentParty>
      </xsl:if>
   </xsl:template>
   <xsl:template match="/in:FatturaElettronica/FatturaElettronicaHeader/DatiTrasmissione/CodiceDestinatario">
      <xsl:param name="CN" select="."/>
      <xsl:param name="CNP" select="1"/>
      <cbc:EndpointID>
         <xsl:choose>
            <xsl:when test="../FormatoTrasmissione='FPR12' and .='0000000' and ../PECDestinatario">
               <xsl:attribute name="schemeID">
                  <xsl:text>0202</xsl:text>
               </xsl:attribute>
               <xsl:value-of select="../PECDestinatario"/>
            </xsl:when>
            <xsl:when test="../FormatoTrasmissione='FPR12' and .='0000000'">
               <xsl:attribute name="SchemeID">
                  <xsl:text>0205</xsl:text>
               </xsl:attribute>
               <xsl:text>0000000</xsl:text>
            </xsl:when>
            <xsl:when test="../FormatoTrasmissione='FPR12' and .='XXXXXXX'">
               <xsl:attribute name="schemeID">
                  <xsl:text>0205</xsl:text>
               </xsl:attribute>
               <xsl:text>XXXXXXX</xsl:text>
            </xsl:when>
            <xsl:when test="../FormatoTrasmissione='FPR12'">
               <xsl:attribute name="schemeID">
                  <xsl:text>0205</xsl:text>
               </xsl:attribute>
               <xsl:value-of select="."/>
            </xsl:when>
            <xsl:otherwise>
               <xsl:attribute name="schemeID">
                  <xsl:text>0201</xsl:text>
               </xsl:attribute>
               <xsl:value-of select="."/>
            </xsl:otherwise>
         </xsl:choose>
      </cbc:EndpointID>
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
            <cac:Party>
               <xsl:if test="CodiceFiscale">
                  <cac:PartyIdentification>
                     <cbc:ID>
                        <xsl:attribute name="schemeID">
                           <xsl:text>0210</xsl:text>
                        </xsl:attribute>
                        <xsl:value-of select="CodiceFiscale"/>
                     </cbc:ID>
                  </cac:PartyIdentification>
               </xsl:if>
               <xsl:if test="Anagrafica/CodEORI">
                  <cac:PartyIdentification>
                     <cbc:ID>
                        <xsl:value-of select="concat('EORI:', Anagrafica/CodEORI)"/>
                     </cbc:ID>
                  </cac:PartyIdentification>
               </xsl:if>
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
               <xsl:if test="Anagrafica[Nome or Cognome]">
                  <cac:Person>
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
                  </cac:Person>
               </xsl:if>
            </cac:Party>
         </cac:ServiceProviderParty>
      </xsl:if>
   </xsl:template>
   <xsl:template match="FatturaElettronicaBody/DatiGenerali/DatiOrdineAcquisto[1]">
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
   </xsl:template>
   <xsl:template match="FatturaElettronicaBody/DatiGenerali/DatiFattureCollegate">
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
      <xsl:if test="../FatturaPrincipale">
         <cac:AdditionalDocumentReference>
            <cbc:ID>
               <xsl:value-of select="../FatturaPrincipale/NumeroFatturaPrincipale"/>
            </cbc:ID>
            <cbc:IssueDate>
               <xsl:value-of select="../FatturaPrincipale/DataFatturaPrincipale"/>
            </cbc:IssueDate>
         </cac:AdditionalDocumentReference>
      </xsl:if>
   </xsl:template>
   <xsl:template match="FatturaElettronicaBody/DatiGenerali/DatiDDT[1]">
      <cac:DespatchDocumentReference>
         <cbc:ID>
            <xsl:value-of select="NumeroDDT"/>
         </cbc:ID>
         <xsl:if test="Data">
            <cbc:IssueDate>
               <xsl:value-of select="DataDDT"/>
            </cbc:IssueDate>
         </xsl:if>
      </cac:DespatchDocumentReference>
   </xsl:template>
   <xsl:template match="FatturaElettronicaBody/DatiGenerali/DatiRicezione[1]">
      <cac:ReceiptDocumentReference>
         <cbc:ID>
            <xsl:value-of select="IdDocumento"/>
         </cbc:ID>
      </cac:ReceiptDocumentReference>
   </xsl:template>
   <xsl:template match="FatturaElettronicaBody/DatiGenerali/DatiContratto[1]">
      <xsl:if test="CodiceCIG">
         <cac:OriginatorDocumentReference>
            <cbc:ID>
               <xsl:value-of select="CodiceCIG"/>
            </cbc:ID>
         </cac:OriginatorDocumentReference>
      </xsl:if>
      <cac:ContractDocumentReference>
         <cbc:ID>
            <xsl:value-of select="IdDocumento"/>
         </cbc:ID>
      </cac:ContractDocumentReference>
   </xsl:template>
   <xsl:template match="FatturaElettronicaBody/DatiGenerali/DatiConvenzione">
      <cac:AdditionalDocumentReference>
         <cbc:ID>
            <xsl:if test="CodiceCommessaConvenzione">
               <xsl:attribute name="schemeID">
                  <xsl:text>AVV</xsl:text>
               </xsl:attribute>
            </xsl:if>
            <xsl:value-of select="CodiceCommessaConvenzione"/>
         </cbc:ID>
      </cac:AdditionalDocumentReference>
   </xsl:template>
   <xsl:template match="FatturaElettronicaBody/DatiGenerali/DatiSAL">
      <cac:AdditionalDocumentReference>
         <cbc:ID>
            <xsl:if test="RiferimentoFase">
               <xsl:attribute name="schemeID">
                  <xsl:text>AOR</xsl:text>
               </xsl:attribute>
            </xsl:if>
            <xsl:value-of select="RiferimentoFase"/>
         </cbc:ID>
      </cac:AdditionalDocumentReference>
   </xsl:template>
   <xsl:template match="FatturaElettronicaBody/Allegati">
      <cac:AdditionalDocumentReference>
         <cbc:ID>
            <xsl:value-of select="NomeAttachment"/>
         </cbc:ID>
         <xsl:if test="DescrizioneAttachment">
            <cbc:DocumentDescription>
               <xsl:value-of select="DescrizioneAttachment"/>
            </cbc:DocumentDescription>
         </xsl:if>
         <cac:Attachment>
            <cbc:EmbeddedDocumentBinaryObject>
               <xsl:if test="Attachment">
                  <xsl:attribute name="mimeCode">
                     <xsl:if test="FormatoAttachment">
                        <xsl:value-of select="FormatoAttachment"/>
                     </xsl:if>
                     <xsl:if test="not(FormatoAttachment)">
                        <xsl:text>x</xsl:text>
                     </xsl:if>
                  </xsl:attribute>
               </xsl:if>
               <xsl:value-of select="Attachment"/>
            </cbc:EmbeddedDocumentBinaryObject>
         </cac:Attachment>
      </cac:AdditionalDocumentReference>
   </xsl:template>
   <xsl:template match="FatturaElettronicaBody/DatiGenerali/DatiContratto[1]/CodiceCUP">
      <cac:ProjectReference>
         <cbc:ID>
            <xsl:value-of select="CodiceCUP"/>
         </cbc:ID>
      </cac:ProjectReference>
   </xsl:template>
   <xsl:template match="AltriDatiGestionali" mode="NaturaOriginale">
      <xsl:param name="CN" select="."/>
      <xsl:param name="CNP" select="1"/>
      <xsl:if test="TipoDato='Natura'">
         <cbc:ID>
            <xsl:value-of select="RiferimentoTesto"/>
         </cbc:ID>
      </xsl:if>
   </xsl:template>
   <xsl:template match="AltriDatiGestionali[upper-case(TipoDato)!='NOTA' and TipoDato!='DatiDDT']" mode="AltriDatiGestionali_Item">
      <xsl:param name="CN" select="."/>
      <xsl:param name="CNP" select="1"/>
      <cac:AdditionalItemProperty>
         <cbc:Name>
            <xsl:value-of select="TipoDato"/>
         </cbc:Name>
         <cbc:Value>
            <xsl:choose>
               <xsl:when test="TipoDato = 'Testo'">
                  <xsl:value-of select="RiferimentoTesto"/>
               </xsl:when>
               <xsl:when test="TipoDato = 'Numero'">
                  <xsl:value-of select="RiferimentoNumero"/>
               </xsl:when>
               <xsl:when test="TipoDato = 'Data'">
                  <xsl:value-of select="RiferimentoData"/>
               </xsl:when>
               <xsl:otherwise>
                  <xsl:choose>
                     <xsl:when test="RiferimentoTesto and RiferimentoNumero and RiferimentoData">
                        <xsl:value-of select="concat(RiferimentoTesto,' ',RiferimentoNumero,' ',RiferimentoData)"/>
                     </xsl:when>
                     <xsl:when test="RiferimentoTesto and RiferimentoNumero">
                        <xsl:value-of select="concat(RiferimentoTesto,' ',RiferimentoNumero)"/>
                     </xsl:when>
                     <xsl:when test="RiferimentoTesto and RiferimentoData">
                        <xsl:value-of select="concat(RiferimentoTesto,' ',RiferimentoData)"/>
                     </xsl:when>
                     <xsl:when test="RiferimentoNumero and RiferimentoData">
                        <xsl:value-of select="concat(RiferimentoNumero,' ',RiferimentoData)"/>
                     </xsl:when>
                     <xsl:otherwise>
                        <xsl:value-of select="concat(RiferimentoTesto, RiferimentoNumero, RiferimentoData)"/>
                     </xsl:otherwise>
                  </xsl:choose>
               </xsl:otherwise>
            </xsl:choose>
         </cbc:Value>
      </cac:AdditionalItemProperty>
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
            <xsl:variable name="variable_d1e571a1050721">
               <xsl:value-of select="CodiceTipo"/>
            </xsl:variable>
            <xsl:if test="string($variable_d1e571a1050721)">
               <xsl:attribute name="listID">
                  <xsl:value-of select="string($variable_d1e571a1050721)"/>
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
            <xsl:variable name="variable_d1e572a1050721">
               <xsl:value-of select="CodiceTipo"/>
            </xsl:variable>
            <xsl:if test="string($variable_d1e572a1050721)">
               <xsl:attribute name="listID">
                  <xsl:value-of select="string($variable_d1e572a1050721)"/>
               </xsl:attribute>
            </xsl:if>
            <xsl:value-of select="CodiceValore"/>
         </cbc:ItemClassificationCode>
      </xsl:if>
   </xsl:template>
   <xsl:template match="CodiceArticolo[contains(',STANDARDITEMIDENTIFICATION,AIC,EMEA,PARAF,EAN,', concat(',',upper-case(CodiceTipo),','))][1]" mode="StandardItemID2">
      <xsl:param name="CN" select="."/>
      <xsl:param name="CNP" select="1"/>
      <xsl:if test="count(../CodiceArticolo[upper-case(CodiceTipo)='AICFARMACO'])=0">
         <cac:StandardItemIdentification>
            <cbc:ID>
               <xsl:variable name="variable_d1e567a1051010">
                  <xsl:value-of select="CodiceTipo"/>
               </xsl:variable>
               <xsl:if test="string($variable_d1e567a1051010)">
                  <xsl:attribute name="schemeID">
                     <xsl:value-of select="string($variable_d1e567a1051010)"/>
                  </xsl:attribute>
               </xsl:if>
               <xsl:value-of select="CodiceValore"/>
            </cbc:ID>
         </cac:StandardItemIdentification>
      </xsl:if>
   </xsl:template>
   <xsl:template match="CodiceArticolo[1]">
      <xsl:param name="CN" select="."/>
      <xsl:param name="CNP" select="1"/>
      <xsl:if test="upper-case(CodiceTipo) = 'CARB' or upper-case(CodiceTipo) = 'AICFARMACO'">
         <cac:SellersItemIdentification>
            <cbc:ID>
               <xsl:value-of select="upper-case(CodiceTipo)"/>
               <xsl:text>:</xsl:text>
               <xsl:value-of select="CodiceValore"/>
            </cbc:ID>
         </cac:SellersItemIdentification>
      </xsl:if>
      <xsl:if test="not(upper-case(CodiceTipo) = 'CARB' or upper-case(CodiceTipo) = 'AICFARMACO')">
         <cac:StandardItemIdentification>
            <cbc:ID>
               <xsl:if test="CodiceTipo">
                  <xsl:attribute name="schemeID">
                     <xsl:value-of select="CodiceTipo"/>
                  </xsl:attribute>
               </xsl:if>
               <xsl:value-of select="CodiceValore"/>
            </cbc:ID>
         </cac:StandardItemIdentification>
      </xsl:if>
   </xsl:template>
   <xsl:template match="CodiceArticolo[not(CodiceTipo)][position() &gt; 1] | CodiceArticolo[CodiceTipo and CodiceTipo!='AICFARMACO' and CodiceTipo!='AIC']" mode="AdditionalID">
      <xsl:param name="CN" select="."/>
      <xsl:param name="CNP" select="1"/>
      <xsl:if test="not(CodiceTipo) or not(contains(',STANDARDITEMIDENTIFICATION,SELLERITEMIDENTIFICATION,ITEMCLASSIFICATIONCODE,CPV,UNSPSC,ECL@SS,ECLASS,COMMODITYCODE,TARIC,', concat(',',upper-case(CodiceTipo),',')))">
         <cac:AdditionalItemIdentification>
            <cbc:ID>
               <xsl:variable name="variable_d1e569a1051010">
                  <xsl:value-of select="CodiceTipo"/>
               </xsl:variable>
               <xsl:if test="string($variable_d1e569a1051010)">
                  <xsl:attribute name="schemeID">
                     <xsl:value-of select="string($variable_d1e569a1051010)"/>
                  </xsl:attribute>
               </xsl:if>
               <xsl:value-of select="CodiceValore"/>
            </cbc:ID>
         </cac:AdditionalItemIdentification>
      </xsl:if>
   </xsl:template>
   <xsl:template match="CodiceFiscale">
      <xsl:param name="CN" select="."/>
      <xsl:param name="CNP" select="1"/>
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
   </xsl:template>
   <xsl:template match="Contatti">
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
   <xsl:template match="DatiAnagrafici/Anagrafica/Denominazione" mode="NomeCessionarioCommittente1">
      <xsl:param name="CN" select="."/>
      <xsl:param name="CNP" select="1"/>
      <cac:PartyName>
         <cbc:Name>
            <xsl:value-of select="."/>
         </cbc:Name>
      </cac:PartyName>
   </xsl:template>
   <xsl:template match="DatiAnagrafici/Anagrafica/Denominazione" mode="NomeRappresentanteFiscale1">
      <xsl:param name="CN" select="."/>
      <xsl:param name="CNP" select="1"/>
      <cac:PartyName>
         <cbc:Name>
            <xsl:value-of select="."/>
         </cbc:Name>
      </cac:PartyName>
   </xsl:template>
   <xsl:template match="DatiAnagrafici/Anagrafica[Nome or Cognome]" mode="NomeCedentePrestatore2">
      <xsl:param name="CN" select="."/>
      <xsl:param name="CNP" select="1"/>
      <cac:PartyName>
         <cbc:Name>
            <xsl:value-of select="normalize-space(concat(Nome, ' ', Cognome))"/>
         </cbc:Name>
      </cac:PartyName>
   </xsl:template>
   <xsl:template match="DatiAnagrafici/Anagrafica[Nome or Cognome]" mode="NomeCessionarioCommittente2">
      <xsl:param name="CN" select="."/>
      <xsl:param name="CNP" select="1"/>
      <cac:PartyName>
         <cbc:Name>
            <xsl:value-of select="normalize-space(concat(Nome, ' ', Cognome))"/>
         </cbc:Name>
      </cac:PartyName>
   </xsl:template>
   <xsl:template match="DatiAnagrafici/Anagrafica[Nome or Cognome]" mode="NomeRappresentanteFiscale2">
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
         <xsl:variable name="variable_d1e220a1051010">
            <xsl:value-of select="document($xclVATSchemes)//Value[@ColumnRef='VATSchemeID']/SimpleValue[../../Value[@ColumnRef='code']/SimpleValue=current()/upper-case(IdPaese)][1]"/>
         </xsl:variable>
         <xsl:value-of select="concat(IdPaese, IdCodice)"/>
      </cbc:CompanyID>
   </xsl:template>
   <xsl:template match="DatiAnagrafici/IdFiscaleIVA" mode="VAT_CessionaroCommittente">
      <xsl:param name="CN" select="."/>
      <xsl:param name="CNP" select="1"/>
      <cac:PartyTaxScheme>
         <cbc:CompanyID>
            <xsl:variable name="variable_d1e315a1051010">
               <xsl:value-of select="document($xclVATSchemes)//Value[@ColumnRef='VATSchemeID']/SimpleValue[../../Value[@ColumnRef='code']/SimpleValue=current()/upper-case(IdPaese)][1]"/>
            </xsl:variable>
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
      <cac:CarrierParty>
         <xsl:if test="CodiceFiscale">
            <cac:PartyIdentification>
               <cbc:ID>
                  <xsl:value-of select="CodiceFiscale"/>
               </cbc:ID>
            </cac:PartyIdentification>
         </xsl:if>
         <xsl:if test="Anagrafica/Denominazione">
            <cac:PartyName>
               <cbc:Name>
                  <xsl:value-of select="Anagrafica/Denominazione"/>
               </cbc:Name>
            </cac:PartyName>
         </xsl:if>
         <cac:PartyTaxScheme>
            <cbc:CompanyID>
               <xsl:value-of select="concat(IdFiscaleIVA/IdPaese, IdFiscaleIVA/IdCodice)"/>
            </cbc:CompanyID>
            <cac:TaxScheme>
               <cbc:ID>
                  <xsl:text>VAT</xsl:text>
               </cbc:ID>
            </cac:TaxScheme>
         </cac:PartyTaxScheme>
         <xsl:if test="Anagrafica/Nome or Anagrafica/Cognome or NumeroLicenzaGuida">
            <cac:Person>
               <xsl:if test="Anagrafica/Nome">
                  <cbc:Name>
                     <xsl:value-of select="Anagrafica/Nome"/>
                  </cbc:Name>
               </xsl:if>
               <xsl:if test="Anagrafica/Cognome">
                  <cbc:Cognome>
                     <xsl:value-of select="Anagrafica/Cognome"/>
                  </cbc:Cognome>
               </xsl:if>
               <xsl:if test="NumeroLicenzaGuida">
                  <cac:IdentityDocumentReference>
                     <cbc:ID>
                        <xsl:value-of select="NumeroLicenzaGuida"/>
                     </cbc:ID>
                     <cbc:DocumentType>
                        <xsl:text>40</xsl:text>
                     </cbc:DocumentType>
                  </cac:IdentityDocumentReference>
               </xsl:if>
            </cac:Person>
         </xsl:if>
      </cac:CarrierParty>
   </xsl:template>
   <xsl:template match="DatiBeniServizi/DatiRiepilogo" mode="Estensione_Arrotondamento_Riepilogo_IVA">
      <xsl:param name="CN" select="."/>
      <xsl:param name="CNP" select="1"/>
      <xsl:if test="Arrotondamento &gt; 0.00 and position() &lt;= 2">
         <ext:UBLExtension>
            <ext:ExtensionURI>
               <xsl:value-of select="concat('urn:fdc:agid.gov.it:fatturapa:RiepilogoIVA:Arrotondamento::', position())"/>
            </ext:ExtensionURI>
            <ext:ExtensionContent>
               <cbc:Amount currencyID="EUR">
                  <xsl:value-of select="Arrotondamento"/>
               </cbc:Amount>
            </ext:ExtensionContent>
         </ext:UBLExtension>
      </xsl:if>
   </xsl:template>
   <xsl:template match="DatiGenerali/DatigeneraliDocumento" mode="Estensione_Sconto_Maggiorazione_IVA">
      <xsl:param name="CN" select="."/>
      <xsl:param name="CNP" select="1"/>
      <xsl:if test="ScontoMaggiorazione">
         <ext:UBLExtension>
            <ext:ExtensionURI>
               <xsl:text>urn:fdc:agid.gov.it:fatturapa:ScontoMaggiorazione</xsl:text>
            </ext:ExtensionURI>
            <ext:ExtensionContent>
               <xsl:variable name="currenyID">
                  <xsl:value-of select="/in:FatturaElettronica/FatturaElettronicaBody/DatiGenerali/DatiGeneraliDocumento/Divisa"/>
               </xsl:variable>
               <cac:AllowanceCharge>
                  <cbc:ChargeIndicator>
                     <xsl:if test="ScontoMaggiorazione/Tipo = 'SC'">
                        <xsl:text>false</xsl:text>
                     </xsl:if>
                     <xsl:if test="ScontoMaggiorazione/Tipo = 'MG'">
                        <xsl:text>true</xsl:text>
                     </xsl:if>
                  </cbc:ChargeIndicator>
                  <xsl:if test="Percentuale">
                     <cbc:MultiplierFactorNumeric>
                        <xsl:value-of select="Percentuale"/>
                     </cbc:MultiplierFactorNumeric>
                  </xsl:if>
                  <cbc:Amount>
                     <xsl:if test="$currenyID">
                        <xsl:attribute name="currencyID">
                           <xsl:value-of select="string($currenyID)"/>
                        </xsl:attribute>
                     </xsl:if>
                     <xsl:value-of select="format-number(Importo,'###########0.00')"/>
                  </cbc:Amount>
               </cac:AllowanceCharge>
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
   <xsl:template match="DatiGenerali/DatiGeneraliDocumento/DatiRitenuta" mode="TipoRitenuta">
      <xsl:param name="CN" select="."/>
      <xsl:param name="CNP" select="1"/>
      <ext:UBLExtension>
         <ext:ExtensionURI>
            <xsl:value-of select="concat('urn:fdc:agid.gov.it:fatturapa:TipoRitenuta::', position())"/>
         </ext:ExtensionURI>
         <ext:ExtensionContent>
            <cbc:TypeCode>
               <xsl:value-of select="TipoRitenuta"/>
            </cbc:TypeCode>
         </ext:ExtensionContent>
      </ext:UBLExtension>
   </xsl:template>
   <xsl:template match="DatiGenerali/DatiGeneraliDocumento/Art73">
      <xsl:param name="CN" select="."/>
      <xsl:param name="CNP" select="1"/>
      <ext:UBLExtension>
         <ext:ExtensionURI>
            <xsl:text>urn:fdc:agid.gov.it:fatturapa:Art73</xsl:text>
         </ext:ExtensionURI>
         <ext:ExtensionContent>
            <cbc:TypeCode>
               <xsl:text>SI</xsl:text>
            </cbc:TypeCode>
         </ext:ExtensionContent>
      </ext:UBLExtension>
   </xsl:template>
   <xsl:template match="DatiGenerali/DatiGeneraliDocumento/TipoDocumento">
      <xsl:param name="CN" select="."/>
      <xsl:param name="CNP" select="1"/>
      <ext:UBLExtension>
         <ext:ExtensionURI>
            <xsl:text>urn:fdc:agid.gov.it:fatturapa:TipoDocumento</xsl:text>
         </ext:ExtensionURI>
         <ext:ExtensionContent>
            <cbc:TypeCode>
               <xsl:value-of select="."/>
            </cbc:TypeCode>
         </ext:ExtensionContent>
      </ext:UBLExtension>
   </xsl:template>
   <xsl:template match="FatturaElettronicaBody">
      <xsl:param name="CN" select="."/>
      <xsl:param name="CNP" select="1"/>
      <ext:UBLExtensions>
         <xsl:apply-templates select="/in:FatturaElettronica" mode="SistemaEmittente">
            <xsl:with-param name="CN" select="current()"/>
            <xsl:with-param name="CNP" select="position()"/>
         </xsl:apply-templates>
         <xsl:apply-templates select="/in:FatturaElettronica/FatturaElettronicaHeader/SoggettoEmittente">
            <xsl:with-param name="CN" select="current()"/>
            <xsl:with-param name="CNP" select="position()"/>
         </xsl:apply-templates>
         <xsl:apply-templates select="DatiGenerali/DatiGeneraliDocumento/TipoDocumento">
            <xsl:with-param name="CN" select="current()"/>
            <xsl:with-param name="CNP" select="position()"/>
         </xsl:apply-templates>
         <xsl:apply-templates select="DatiGenerali/DatiGeneraliDocumento/DatiRitenuta" mode="TipoRitenuta">
            <xsl:with-param name="CN" select="current()"/>
            <xsl:with-param name="CNP" select="position()"/>
         </xsl:apply-templates>
         <xsl:apply-templates select="DatiGenerali/DatiGeneraliDocumento/Art73">
            <xsl:with-param name="CN" select="current()"/>
            <xsl:with-param name="CNP" select="position()"/>
         </xsl:apply-templates>
         <xsl:apply-templates select="DatiBeniServizi/DatiRiepilogo" mode="Estensione_Arrotondamento_Riepilogo_IVA">
            <xsl:with-param name="CN" select="current()"/>
            <xsl:with-param name="CNP" select="position()"/>
         </xsl:apply-templates>
         <!-- Può essere chiamato da un eventuale apply template per uno sconto in testata -->
         <xsl:apply-templates select="DatiGenerali/DatigeneraliDocumento" mode="Estensione_Sconto_Maggiorazione_IVA">
            <xsl:with-param name="CN" select="current()"/>
            <xsl:with-param name="CNP" select="position()"/>
         </xsl:apply-templates>
      </ext:UBLExtensions>
   </xsl:template>
   <xsl:template match="FatturaElettronicaBody/DatiBeniServizi/DatiRiepilogo[position() &lt;= 2]">
      <xsl:param name="CN" select="."/>
      <xsl:param name="CNP" select="1"/>
      <cac:TaxSubtotal>
         <cbc:TaxableAmount>
            <xsl:variable name="variable_d1e427a1049836">
               <xsl:value-of select="/in:FatturaElettronica/FatturaElettronicaBody/DatiGenerali/DatiGeneraliDocumento/Divisa"/>
            </xsl:variable>
            <xsl:if test="string($variable_d1e427a1049836)">
               <xsl:attribute name="currencyID">
                  <xsl:value-of select="string($variable_d1e427a1049836)"/>
               </xsl:attribute>
            </xsl:if>
            <xsl:value-of select="ImponibileImporto"/>
         </cbc:TaxableAmount>
         <cbc:TaxAmount>
            <xsl:variable name="variable_d1e428a1049836">
               <xsl:value-of select="/in:FatturaElettronica/FatturaElettronicaBody/DatiGenerali/DatiGeneraliDocumento/Divisa"/>
            </xsl:variable>
            <xsl:if test="string($variable_d1e428a1049836)">
               <xsl:attribute name="currencyID">
                  <xsl:value-of select="string($variable_d1e428a1049836)"/>
               </xsl:attribute>
            </xsl:if>
            <xsl:value-of select="Imposta"/>
         </cbc:TaxAmount>
         <cac:TaxCategory>
            <cbc:ID>
               <xsl:choose>
                  <xsl:when test="/in:FatturaElettronica/FatturaElettronicaBody/DatiBeniServizi/DatiRiepilogo[1]/EsigibilitaIVA = 'S'">
                     <xsl:text>B</xsl:text>
                  </xsl:when>
                  <xsl:when test="Natura and not(/in:FatturaElettronica/FatturaElettronicaBody/DatiBeniServizi/DatiRiepilogo[1]/EsigibilitaIVA = 'S')">
                     <xsl:value-of select="document($xclCategoriaImposte)//Value[@ColumnRef='xcode']/SimpleValue[../../Value[@ColumnRef='code']/SimpleValue=current()/Natura][1]"/>
                  </xsl:when>
                  <xsl:otherwise>
                     <!-- Da ricontrollare per "AA" -->
                     <xsl:value-of select="(if (AliquotaIVA &gt;= 20) then 'S' else 'AA')"/>
                  </xsl:otherwise>
               </xsl:choose>
            </cbc:ID>
            <cbc:Percent>
               <xsl:value-of select="AliquotaIVA"/>
            </cbc:Percent>
            <xsl:if test="Natura">
               <cbc:TaxExemptionReason>
                  <xsl:if test="Natura and Natura = 'N1'">
                     <xsl:value-of select="Natura"/>
                  </xsl:if>
                  <xsl:if test="not(Natura = 'N1')">
                     <xsl:value-of select="concat(Natura, RiferimentoNormativo)"/>
                  </xsl:if>
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
      <cac:InvoiceLine>
         <cbc:ID>
            <xsl:value-of select="normalize-space(NumeroLinea)"/>
         </cbc:ID>
         <cbc:InvoicedQuantity>
            <xsl:variable name="variable_d1e455a1050145">
               <xsl:value-of select="if (document($xclUnitOfMeasureCode)//Value[@ColumnRef='code']/SimpleValue[../../Value[@ColumnRef='xname']/SimpleValue=current()/UnitaMisura][1]) then document($xclUnitOfMeasureCode)//Value[@ColumnRef='code']/SimpleValue[../../Value[@ColumnRef='xname']/SimpleValue=current()/UnitaMisura][1] else 'C62'"/>
            </xsl:variable>
            <xsl:if test="string($variable_d1e455a1050145)">
               <xsl:attribute name="unitCode">
                  <xsl:value-of select="string($variable_d1e455a1050145)"/>
               </xsl:attribute>
            </xsl:if>
            <xsl:value-of select="if (Quantita) then Quantita else 1.00"/>
         </cbc:InvoicedQuantity>
         <cbc:LineExtensionAmount>
            <xsl:variable name="variable_d1e456a1049836">
               <xsl:value-of select="/in:FatturaElettronica/FatturaElettronicaBody/DatiGenerali/DatiGeneraliDocumento/Divisa"/>
            </xsl:variable>
            <xsl:if test="string($variable_d1e456a1049836)">
               <xsl:attribute name="currencyID">
                  <xsl:value-of select="string($variable_d1e456a1049836)"/>
               </xsl:attribute>
            </xsl:if>
            <xsl:value-of select="format-number(PrezzoTotale,'###########0.00')"/>
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
         <!-- Da revisionare tutti i riferimenti e additional item property-->
         <xsl:apply-templates select="/in:FatturaElettronica/FatturaElettronicaBody/DatiGenerali/DatiOrdineAcquisto" mode="OrderLineReference">
            <xsl:with-param name="CN" select="current()"/>
            <xsl:with-param name="CNP" select="position()"/>
         </xsl:apply-templates>
         <xsl:apply-templates select="/in:FatturaElettronica/FatturaElettronicaBody/DatiGenerali/DatiDDT" mode="DespatchLineReference">
            <xsl:with-param name="CN" select="current()"/>
            <xsl:with-param name="CNP" select="position()"/>
         </xsl:apply-templates>
         <xsl:apply-templates select="/in:FatturaElettronica/FatturaElettronicaBody/DatiGenerali/DatiOrdineAcquisto/CodiceCommessaConvenzione" mode="CodiceCommessaConvenzione_Riga">
            <xsl:with-param name="CN" select="current()"/>
            <xsl:with-param name="CNP" select="position()"/>
         </xsl:apply-templates>
         <xsl:apply-templates select="/in:FatturaElettronica/FatturaElettronicaBody/DatiGenerali/DatiConvenzione/CodiceCommessaConvenzione" mode="CodiceCommessaConvenzione_Convenzione_Riga">
            <xsl:with-param name="CN" select="current()"/>
            <xsl:with-param name="CNP" select="position()"/>
         </xsl:apply-templates>
         <xsl:apply-templates select="/in:FatturaElettronica/FatturaElettronicaBody/DatiGenerali/DatiContratto/CodiceCommessaConvenzione" mode="Contratto_Riga">
            <xsl:with-param name="CN" select="current()"/>
            <xsl:with-param name="CNP" select="position()"/>
         </xsl:apply-templates>
         <xsl:apply-templates select="/in:FatturaElettronica/FatturaElettronicaBody/DatiGenerali/DatiContratto/CodiceCUP" mode="CUP_Contratto_Riga">
            <xsl:with-param name="CN" select="current()"/>
            <xsl:with-param name="CNP" select="position()"/>
         </xsl:apply-templates>
         <xsl:apply-templates select="/in:FatturaElettronica/FatturaElettronicaBody/DatiGenerali/DatiContratto/CodiceCIG" mode="CIG_Contratto_Riga">
            <xsl:with-param name="CN" select="current()"/>
            <xsl:with-param name="CNP" select="position()"/>
         </xsl:apply-templates>
         <cac:Item>
            <cbc:Name>
               <xsl:value-of select="normalize-space(Descrizione)"/>
            </cbc:Name>
            <xsl:apply-templates select="CodiceArticolo[1]">
               <xsl:with-param name="CN" select="current()"/>
               <xsl:with-param name="CNP" select="position()"/>
            </xsl:apply-templates>
            <!-- Da capire come fare
            <xsl:apply-templates select="CodiceArticolo[contains(',STANDARDITEMIDENTIFICATION,AIC,EMEA,PARAF,EAN,', concat(',',upper-case(CodiceTipo),','))][1]" mode="StandardItemID2">
               <xsl:with-param name="CN" select="current()"/>
               <xsl:with-param name="CNP" select="position()"/>
            </xsl:apply-templates>
            <xsl:apply-templates select="CodiceArticolo[not(CodiceTipo)][position() &gt; 1] | CodiceArticolo[CodiceTipo and CodiceTipo!='AICFARMACO' and CodiceTipo!='AIC']" mode="AdditionalID">
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
            </xsl:if> -->
            <cac:ClassifiedTaxCategory>
               <xsl:apply-templates select="AltriDatiGestionali" mode="NaturaOriginale">
                  <xsl:with-param name="CN" select="current()"/>
                  <xsl:with-param name="CNP" select="position()"/>
               </xsl:apply-templates>
               <xsl:if test="not(AltriDatiGestionali[TipoDato='Natura']/RiferimentoTesto)">
                  <cbc:ID>
                     <xsl:value-of select="if (Natura) then document($xclCategoriaImposte)//Value[@ColumnRef='xcode']/SimpleValue[../../Value[@ColumnRef='code']/SimpleValue=current()/Natura][1] else (if (AliquotaIVA &gt;= 20) then 'S' else 'AA')"/>
                  </cbc:ID>
               </xsl:if>
               <cbc:Percent>
                  <xsl:value-of select="if (AliquotaIVA) then AliquotaIVA else '0'"/>
               </cbc:Percent>
               <cac:TaxScheme>
                  <cbc:ID>
                     <xsl:text>VAT</xsl:text>
                  </cbc:ID>
               </cac:TaxScheme>
            </cac:ClassifiedTaxCategory>
            <xsl:if test="TipoCessionePrestazione">
               <cac:AdditionalItemProperty>
                  <cbc:Name>
                     <xsl:text>TipoCessionePrestazione</xsl:text>
                  </cbc:Name>
                  <cbc:Value>
                     <xsl:value-of select="TipoCessionePrestazione"/>
                  </cbc:Value>
               </cac:AdditionalItemProperty>
            </xsl:if>
            <xsl:if test="Ritenuta">
               <cac:AdditionalItemProperty>
                  <cbc:Name>
                     <xsl:text>RITENUTA</xsl:text>
                  </cbc:Name>
                  <cbc:Value>
                     <xsl:text>SI</xsl:text>
                  </cbc:Value>
               </cac:AdditionalItemProperty>
            </xsl:if>
            <!-- Da verificare per N1 -->
            <xsl:if test="Natura">
               <cac:AdditionalItemProperty>
                  <cbc:Name>
                     <xsl:text>NATURA</xsl:text>
                  </cbc:Name>
                  <cbc:Value>
                     <xsl:value-of select="Natura"/>
                  </cbc:Value>
               </cac:AdditionalItemProperty>
            </xsl:if>
            <!-- Da verificare -->
            <xsl:apply-templates select="AltriDatiGestionali[upper-case(TipoDato)!='NOTA' and TipoDato!='DatiDDT']" mode="AltriDatiGestionali_Item">
               <xsl:with-param name="CN" select="current()"/>
               <xsl:with-param name="CNP" select="position()"/>
            </xsl:apply-templates>
            <!-- Da testare -->
            <xsl:if test="../../DatiVeicoli">
               <cac:AdditionalItemProperty>
                  <cbc:Name>
                     <xsl:text>DatiVeicoli</xsl:text>
                  </cbc:Name>
                  <cbc:Value>
                     <xsl:value-of select="concat(Data, '#', TotalePercorso)"/>
                  </cbc:Value>
               </cac:AdditionalItemProperty>
            </xsl:if>
         </cac:Item>
         <cac:Price>
            <xsl:variable name="currenyID">
               <xsl:value-of select="/in:FatturaElettronica/FatturaElettronicaBody/DatiGenerali/DatiGeneraliDocumento/Divisa"/>
            </xsl:variable>
            <xsl:variable name="amount">
               <xsl:choose>
                  <xsl:when test="ScontoMaggiorazione/Importo and ScontoMaggiorazione/Tipo = 'MG'">
                     <xsl:value-of select="0 - ScontoMaggiorazione/Importo"/>
                  </xsl:when>
                  <xsl:when test="ScontoMaggiorazione/Importo and ScontoMaggiorazione/Tipo = 'SC'">
                     <xsl:value-of select="ScontoMaggiorazione/Importo"/>
                  </xsl:when>
                  <xsl:when test="not(ScontoMaggiorazione/Importo) and ScontoMaggiorazione/Percentuale and ScontoMaggiorazione/Tipo = 'MG'">
                     <xsl:value-of select="0 - (PrezzoUnitario / 100 * ScontoMaggiorazione/Percentuale)"/>
                  </xsl:when>
                  <xsl:when test="not(ScontoMaggiorazione/Importo) and ScontoMaggiorazione/Percentuale and ScontoMaggiorazione/Tipo = 'SC'">
                     <xsl:value-of select="PrezzoUnitario / 100 * ScontoMaggiorazione/Percentuale"/>
                  </xsl:when>
                  <xsl:otherwise>
                     <xsl:text>0</xsl:text>
                  </xsl:otherwise>
               </xsl:choose>
            </xsl:variable>
            <cbc:PriceAmount>
               <xsl:if test="$currenyID">
                  <xsl:attribute name="currencyID">
                     <xsl:value-of select="string($currenyID)"/>
                  </xsl:attribute>
               </xsl:if>
               <xsl:value-of select="format-number(PrezzoUnitario - $amount,'###########0.00')"/>
            </cbc:PriceAmount>
            <cac:AllowanceCharge>
               <cbc:ChargeIndicator>
                  <xsl:text>false</xsl:text>
               </cbc:ChargeIndicator>
               <cbc:Amount>
                  <xsl:if test="$currenyID">
                     <xsl:attribute name="currencyID">
                        <xsl:value-of select="string($currenyID)"/>
                     </xsl:attribute>
                  </xsl:if>
                  <xsl:value-of select="format-number($amount,'###########0.00')"/>
               </cbc:Amount>
               <cbc:BaseAmount>
                  <xsl:if test="$currenyID">
                     <xsl:attribute name="currencyID">
                        <xsl:value-of select="string($currenyID)"/>
                     </xsl:attribute>
                  </xsl:if>
                  <xsl:value-of select="format-number(PrezzoUnitario,'###########0.00')"/>
               </cbc:BaseAmount>
            </cac:AllowanceCharge>
         </cac:Price>
      </cac:InvoiceLine>
   </xsl:template>
   <xsl:template match="FatturaElettronicaBody/DatiGenerali/DatiGeneraliDocumento" mode="LegalMonetaryTotal">
      <xsl:param name="CN" select="."/>
      <xsl:param name="CNP" select="1"/>
      <cac:LegalMonetaryTotal>
         <xsl:variable name="lineExtensionAmount" select="sum(../../DatiBeniServizi/DettaglioLinee/PrezzoTotale)"/>
         <xsl:variable name="variable_d1e449a1049836">
            <xsl:value-of select="Divisa"/>
         </xsl:variable>
         <xsl:variable name="taxInclusiveAmount">
            <xsl:if test="ImportoTotaleDocumento">
               <xsl:value-of select="ImportoTotaleDocumento"/>
            </xsl:if>
            <xsl:if test="not(ImportoTotaleDocumento)">
               <xsl:value-of select="$lineExtensionAmount+sum(ScontoMaggiorazione[Tipo='MG']/Importo)-sum(ScontoMaggiorazione[Tipo='SC']/Importo)+sum(../../DatiBeniServizi/DatiRiepilogo/Imposta)"/>
            </xsl:if>
         </xsl:variable>
         <xsl:variable name="payableAmount">
            <xsl:choose>
               <xsl:when test="../../DatiPagamento[1]/DettaglioPagamento/ImportoPagamento">
                  <xsl:value-of select="sum(../../DatiPagamento[1]/DettaglioPagamento/ImportoPagamento)"/>
               </xsl:when>
               <xsl:when test="not(../../DatiPagamento[1]/DettaglioPagamento/ImportoPagamento) and ImponibileImporto">
                  <xsl:value-of select="ImportoTotaleDocumento+Arrotondamento"/>
               </xsl:when>
               <xsl:otherwise>
                  <xsl:value-of select="$lineExtensionAmount+sum(ScontoMaggiorazione[Tipo='MG']/Importo)-sum(ScontoMaggiorazione[Tipo='SC']/Importo)+sum(../../DatiBeniServizi/DatiRiepilogo/Imposta)+Arrotondamento"/>
               </xsl:otherwise>
            </xsl:choose>
         </xsl:variable>
         <cbc:LineExtensionAmount>
            <xsl:if test="string($variable_d1e449a1049836)">
               <xsl:attribute name="currencyID">
                  <xsl:value-of select="string($variable_d1e449a1049836)"/>
               </xsl:attribute>
            </xsl:if>
            <xsl:value-of select="format-number($lineExtensionAmount,'###########0.00')"/>
         </cbc:LineExtensionAmount>
         <cbc:TaxExclusiveAmount>
            <xsl:if test="string($variable_d1e449a1049836)">
               <xsl:attribute name="currencyID">
                  <xsl:value-of select="string($variable_d1e449a1049836)"/>
               </xsl:attribute>
            </xsl:if>
            <xsl:value-of select="format-number($lineExtensionAmount+sum(ScontoMaggiorazione[Tipo='MG']/Importo)-sum(ScontoMaggiorazione[Tipo='SC']/Importo),'###########0.00')"/>
         </cbc:TaxExclusiveAmount>
         <cbc:TaxInclusiveAmount>
            <xsl:if test="string($variable_d1e449a1049836)">
               <xsl:attribute name="currencyID">
                  <xsl:value-of select="string($variable_d1e449a1049836)"/>
               </xsl:attribute>
            </xsl:if>
            <xsl:value-of select="format-number($taxInclusiveAmount,'###########0.00')"/>
         </cbc:TaxInclusiveAmount>
         <cbc:AllowanceTotalAmount>
            <xsl:if test="string($variable_d1e449a1049836)">
               <xsl:attribute name="currencyID">
                  <xsl:value-of select="string($variable_d1e449a1049836)"/>
               </xsl:attribute>
            </xsl:if>
            <xsl:value-of select="format-number(sum(ScontoMaggiorazione[Tipo='SC']/Importo),'###########0.00')"/>
         </cbc:AllowanceTotalAmount>
         <cbc:ChargeTotalAmount>
            <xsl:if test="string($variable_d1e449a1049836)">
               <xsl:attribute name="currencyID">
                  <xsl:value-of select="string($variable_d1e449a1049836)"/>
               </xsl:attribute>
            </xsl:if>
            <xsl:value-of select="format-number(sum(ScontoMaggiorazione[Tipo='MG']/Importo),'###########0.00')"/>
         </cbc:ChargeTotalAmount>
         <xsl:if test="$taxInclusiveAmount &gt; $payableAmount">
            <cbc:PrepaidAmount>
               <xsl:variable name="variable_d1e450a1049836">
                  <xsl:value-of select="Divisa"/>
               </xsl:variable>
               <xsl:if test="string($variable_d1e450a1049836)">
                  <xsl:attribute name="currencyID">
                     <xsl:value-of select="string($variable_d1e450a1049836)"/>
                  </xsl:attribute>
               </xsl:if>
               <xsl:value-of select="format-number($taxInclusiveAmount - $payableAmount,'###########0.00')"/>
            </cbc:PrepaidAmount>
         </xsl:if>
         <xsl:if test="Arrotondamento &gt; 0.00">
            <cbc:PayableRoundingAmount>
               <xsl:variable name="variable_d1e450a1049836">
                  <xsl:value-of select="Divisa"/>
               </xsl:variable>
               <xsl:if test="string($variable_d1e450a1049836)">
                  <xsl:attribute name="currencyID">
                     <xsl:value-of select="string($variable_d1e450a1049836)"/>
                  </xsl:attribute>
               </xsl:if>
               <xsl:value-of select="format-number(Arrotondamento,'###########0.00')"/>
            </cbc:PayableRoundingAmount>
         </xsl:if>
         <cbc:PayableAmount>
            <xsl:variable name="variable_d1e451a1049836">
               <xsl:value-of select="Divisa"/>
            </xsl:variable>
            <xsl:if test="string($variable_d1e451a1049836)">
               <xsl:attribute name="currencyID">
                  <xsl:value-of select="string($variable_d1e451a1049836)"/>
               </xsl:attribute>
            </xsl:if>
            <xsl:value-of select="format-number($payableAmount,'###########0.00')"/>
            <!-- <xsl:value-of select="if (ImportoTotaleDocumento) then ImportoTotaleDocumento else format-number(sum(/in:FatturaElettronica/FatturaElettronicaBody/DatiBeniServizi/DettaglioLinee/PrezzoTotale)+sum(ScontoMaggiorazione[Tipo='MG']/Importo) -sum(ScontoMaggiorazione[Tipo='SC']/Importo)&#xA;+sum(/in:FatturaElettronica/FatturaElettronicaBody/DatiBeniServizi/DatiRiepilogo/Imposta)+sum(Arrotondamento),'###########0.00')"/> -->
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
   <xsl:template match="FatturaElettronicaBody/DatiGenerali/DatiGeneraliDocumento/DatiRitenuta">
      <xsl:param name="CN" select="."/>
      <xsl:param name="CNP" select="1"/>
      <cac:TaxSubtotal>
         <cbc:TaxAmount>
            <xsl:variable name="variable_d1e439a1049836">
               <xsl:value-of select="/in:FatturaElettronica/FatturaElettronicaBody/DatiGenerali/DatiGeneraliDocumento/Divisa"/>
            </xsl:variable>
            <xsl:if test="string($variable_d1e439a1049836)">
               <xsl:attribute name="currencyID">
                  <xsl:value-of select="string($variable_d1e439a1049836)"/>
               </xsl:attribute>
            </xsl:if>
            <xsl:value-of select="ImportoRitenuta"/>
         </cbc:TaxAmount>
         <cac:TaxCategory>
            <cbc:ID>
               <xsl:text>S</xsl:text>
            </cbc:ID>
            <cbc:Percent>
               <xsl:value-of select="AliquotaRitenuta"/>
            </cbc:Percent>
            <cac:TaxScheme>
               <cbc:ID>
                  <xsl:text>SWT</xsl:text>
               </cbc:ID>
               <cbc:TaxTypeCode>
                  <xsl:value-of select="CausalePagamento"/>
               </cbc:TaxTypeCode>
            </cac:TaxScheme>
         </cac:TaxCategory>
      </cac:TaxSubtotal>
   </xsl:template>
   <xsl:template match="FatturaElettronicaBody/DatiGenerali/DatiGeneraliDocumento/DatiBollo">
      <xsl:param name="CN" select="."/>
      <xsl:param name="CNP" select="1"/>
      <cac:AllowanceCharge>
         <cbc:ChargeIndicator>
            <xsl:text>true</xsl:text>
         </cbc:ChargeIndicator>
         <cbc:AllowanceChargeReasonCode>
            <xsl:text>SAE</xsl:text>
         </cbc:AllowanceChargeReasonCode>
         <cbc:AllowanceChargeReason>
            <xsl:text>BOLLO</xsl:text>
         </cbc:AllowanceChargeReason>
         <cbc:Amount>
            <xsl:variable name="currencyID_value">
               <xsl:value-of select="/in:FatturaElettronica/FatturaElettronicaBody/DatiGenerali/DatiGeneraliDocumento/Divisa"/>
            </xsl:variable>
            <xsl:if test="string($currencyID_value)">
               <xsl:attribute name="currencyID">
                  <xsl:value-of select="string($currencyID_value)"/>
               </xsl:attribute>
            </xsl:if>
            <xsl:if test="ImportoBollo">
               <xsl:value-of select="format-number(ImportoBollo,'###########0.00')"/>
            </xsl:if>
            <xsl:if test="not(ImportoBollo)">
               <xsl:text>0</xsl:text>
            </xsl:if>
         </cbc:Amount>
         <cac:TaxCategory>
            <cbc:ID>
               <xsl:text>Z</xsl:text>
            </cbc:ID>
            <cbc:Percent>
               <xsl:text>0</xsl:text>
            </cbc:Percent>
            <cac:TaxScheme>
               <cbc:ID>
                  <xsl:text>VAT</xsl:text>
               </cbc:ID>
            </cac:TaxScheme>
         </cac:TaxCategory>
      </cac:AllowanceCharge>
   </xsl:template>
   <xsl:template match="FatturaElettronicaBody/DatiGenerali/DatiGeneraliDocumento/DatiCassaPrevidenziale">
      <xsl:param name="CN" select="."/>
      <xsl:param name="CNP" select="1"/>
      <cac:AllowanceCharge>
         <cbc:ChargeIndicator>
            <xsl:text>true</xsl:text>
         </cbc:ChargeIndicator>
         <cbc:AllowanceChargeReasonCode>
            <xsl:text>ZZZ</xsl:text>
         </cbc:AllowanceChargeReasonCode>
         <cbc:AllowanceChargeReason>
            <xsl:value-of select="concat(TipoCassa, Ritenuta, Natura)"/>
         </cbc:AllowanceChargeReason>
         <cbc:MultiplierFactorNumeric>
            <xsl:value-of select="AlCassa"/>
         </cbc:MultiplierFactorNumeric>
         <cbc:Amount>
            <xsl:variable name="currencyID_value">
               <xsl:value-of select="/in:FatturaElettronica/FatturaElettronicaBody/DatiGenerali/DatiGeneraliDocumento/Divisa"/>
            </xsl:variable>
            <xsl:if test="string($currencyID_value)">
               <xsl:attribute name="currencyID">
                  <xsl:value-of select="string($currencyID_value)"/>
               </xsl:attribute>
            </xsl:if>
            <xsl:value-of select="ImportoContributoCassa"/>
         </cbc:Amount>
         <xsl:if test="ImponibileCassa">
            <cbc:BaseAmount>
               <xsl:variable name="currencyID_value">
                  <xsl:value-of select="/in:FatturaElettronica/FatturaElettronicaBody/DatiGenerali/DatiGeneraliDocumento/Divisa"/>
               </xsl:variable>
               <xsl:if test="string($currencyID_value)">
                  <xsl:attribute name="currencyID">
                     <xsl:value-of select="string($currencyID_value)"/>
                  </xsl:attribute>
               </xsl:if>
               <xsl:value-of select="ImponibileCassa"/>
            </cbc:BaseAmount>
         </xsl:if>
         <cac:TaxCategory>
            <!-- Da verificare -->
            <cbc:ID>
               <xsl:if test="Natura">
                  <xsl:value-of select="document($xclCategoriaImposte)//Value[@ColumnRef='xcode']/SimpleValue[../../Value[@ColumnRef='code']/SimpleValue=current()/Natura][1]"/>
               </xsl:if>
               <xsl:if test="not(Natura)">
                  <xsl:text>S</xsl:text>
               </xsl:if>
            </cbc:ID>
            <cbc:Percent>
               <xsl:value-of select="AliquotaIVA"/>
            </cbc:Percent>
            <cac:TaxScheme>
               <cbc:ID>
                  <xsl:text>VAT</xsl:text>
               </cbc:ID>
            </cac:TaxScheme>
         </cac:TaxCategory>
      </cac:AllowanceCharge>
   </xsl:template>
   <xsl:template match="FatturaElettronicaBody/DatiGenerali/DatiGeneraliDocumento/ScontoMaggiorazione">
      <xsl:param name="CN" select="."/>
      <xsl:param name="CNP" select="1"/>
      <xsl:if test="Importo">
         <cac:AllowanceCharge>
            <cbc:ChargeIndicator>
               <xsl:if test="Tipo = 'MG'">
                  <xsl:text>true</xsl:text>
               </xsl:if>
               <xsl:if test="Tipo = 'SC'">
                  <xsl:text>false</xsl:text>
               </xsl:if>
               <!-- Da chiedere a Iacopo 
               <xsl:value-of select="Tipo = 'MG'"/> -->
            </cbc:ChargeIndicator>
            <cbc:Amount>
               <xsl:variable name="variable_d1e423a1049836">
                  <xsl:value-of select="/in:FatturaElettronica/FatturaElettronicaBody/DatiGenerali/DatiGeneraliDocumento/Divisa"/>
               </xsl:variable>
               <xsl:if test="string($variable_d1e423a1049836)">
                  <xsl:attribute name="currencyID">
                     <xsl:value-of select="string($variable_d1e423a1049836)"/>
                  </xsl:attribute>
               </xsl:if>
               <xsl:value-of select="Importo"/>
            </cbc:Amount>
         </cac:AllowanceCharge>
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
   <xsl:template match="FatturaElettronicaBody/DatiPagamento[1]/DettaglioPagamento" mode="ModalitàPagamento">
      <xsl:param name="CN" select="."/>
      <xsl:param name="CNP" select="1"/>
      <cac:PaymentMeans>
         <!-- Da vedere se funziona e come viene tradotto -->
         <cbc:PaymentMeansCode>
            <xsl:value-of select="if ((document($xclPaymentMeansCode)//Value[@ColumnRef='code']/SimpleValue[../../Value[@ColumnRef='xcode']/SimpleValue=current()/ModalitaPagamento])[1]) then (document($xclPaymentMeansCode)//Value[@ColumnRef='code']/SimpleValue[../../Value[@ColumnRef='xcode']/SimpleValue=current()/ModalitaPagamento])[1] else '9'"/>
         </cbc:PaymentMeansCode>
         <xsl:if test="CodicePagamento">
            <cbc:PaymentID>
               <xsl:value-of select="CodicePagamento"/>
            </cbc:PaymentID>
         </xsl:if>
         <!-- Da chiedere come deve essere gestito, se per esempio c'è solo il bic -->
         <xsl:if test="IBAN">
            <cac:PayeeFinancialAccount>
               <cbc:ID>
                  <xsl:value-of select="IBAN"/>
               </cbc:ID>
               <xsl:if test="BIC">
                  <cac:FinancialInstitutionBranch>
                     <cbc:ID>
                        <xsl:value-of select="BIC"/>
                     </cbc:ID>
                  </cac:FinancialInstitutionBranch>
               </xsl:if>
            </cac:PayeeFinancialAccount>
         </xsl:if>
      </cac:PaymentMeans>
   </xsl:template>
   <xsl:template match="FatturaElettronicaBody/DatiPagamento[1]/DettaglioPagamento[1]" mode="TerminiPagamento">
      <xsl:param name="CN" select="."/>
      <xsl:param name="CNP" select="1"/>
      <cac:PaymentTerms>
         <cbc:Note>
            <xsl:if test="../CondizioniPagamento and GiorniTerminiPagamento">
               <xsl:value-of select="concat(../CondizioniPagamento, '#', GiorniTerminiPagamento)"/>
            </xsl:if>
            <xsl:if test="not(../CondizioniPagamento and GiorniTerminiPagamento)">
               <xsl:value-of select="concat(../CondizioniPagamento, GiorniTerminiPagamento)"/>
            </xsl:if>
         </cbc:Note>
         <xsl:if test="ScontoPagamentoAnticipato">
            <cbc:SettlementDiscountAmount>
               <xsl:variable name="variable_d1e411a1049836">
                  <xsl:value-of select="/in:FatturaElettronica/FatturaElettronicaBody/DatiGenerali/DatiGeneraliDocumento/Divisa"/>
               </xsl:variable>
               <xsl:if test="string($variable_d1e411a1049836)">
                  <xsl:attribute name="currencyID">
                     <xsl:value-of select="string($variable_d1e411a1049836)"/>
                  </xsl:attribute>
               </xsl:if>
               <xsl:value-of select="ScontoPagamentoAnticipato"/>
            </cbc:SettlementDiscountAmount>
         </xsl:if>
         <xsl:if test="PenalitaPagamentiRitardati">
            <cbc:PenaltyAmount>
               <xsl:variable name="variable_d1e411a1049836">
                  <xsl:value-of select="/in:FatturaElettronica/FatturaElettronicaBody/DatiGenerali/DatiGeneraliDocumento/Divisa"/>
               </xsl:variable>
               <xsl:if test="string($variable_d1e411a1049836)">
                  <xsl:attribute name="currencyID">
                     <xsl:value-of select="string($variable_d1e411a1049836)"/>
                  </xsl:attribute>
               </xsl:if>
               <xsl:value-of select="PenalitaPagamentiRitardati"/>
            </cbc:PenaltyAmount>
         </xsl:if>
         <xsl:if test="DataLimitePagamentoAnticipato">
            <cac:SettlementPeriod>
               <cbc:EndDate>
                  <xsl:value-of select="DataLimitePagamentoAnticipato"/>
               </cbc:EndDate>
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
   <xsl:template match="FatturaElettronicaHeader/CedentePrestatore">
      <xsl:param name="CN" select="."/>
      <xsl:param name="CNP" select="1"/>
      <cac:AccountingSupplierParty>
         <cac:Party>
            <!-- Da chiedere da cosa viene preso l'endpoint -->
            <cbc:EndpointID schemeID="0211">00000000000</cbc:EndpointID>
            <xsl:if test="DatiAnagrafici/Anagrafica/CodEORI or (DatiAnagrafici/AlboProfessionale and DatiAnagrafici/NumeroIscrizioneAlbo and DatiAnagrafici/DataIscrizioneAlbo) or (IscrizioneREA/Ufficio and IscrizioneREA/NumeroREA)">
               <cac:PartyIdentification>
                  <cbc:ID>
                     <xsl:choose>
                        <xsl:when test="DatiAnagrafici/Anagrafica/CodEORI">
                           <xsl:value-of select="concat('EORI:', DatiAnagrafici/Anagrafica/CodEORI)"/>
                        </xsl:when>
                        <xsl:when test="DatiAnagrafici/AlboProfessionale and DatiAnagrafici/NumeroIscrizioneAlbo and DatiAnagrafici/DataIscrizioneAlbo">
                           <xsl:value-of select="concat('ALBO:', DatiAnagrafici/AlboProfessionale, '#', DatiAnagrafici/NumeroIscrizioneAlbo, '#', DatiAnagrafici/DataIscrizioneAlbo)"/>
                        </xsl:when>
                        <xsl:when test="IscrizioneREA/Ufficio and IscrizioneREA/NumeroREA">
                           <xsl:value-of select="concat('REA:', IscrizioneREA/Ufficio, '#', IscrizioneREA/NumeroREA)"/>
                        </xsl:when>
                     </xsl:choose>
                  </cbc:ID>
               </cac:PartyIdentification>
            </xsl:if>

            <xsl:apply-templates select="Sede" mode="Sede_CedentePrestatore">
               <xsl:with-param name="CN" select="current()"/>
               <xsl:with-param name="CNP" select="position()"/>
            </xsl:apply-templates>
            <cac:PartyTaxScheme>
               <xsl:apply-templates select="DatiAnagrafici/IdFiscaleIVA" mode="VAT_CedentePrestatore">
                  <xsl:with-param name="CN" select="current()"/>
                  <xsl:with-param name="CNP" select="position()"/>
               </xsl:apply-templates>
               <xsl:if test="DatiAnagrafici/RegimeFiscale">
                  <cbc:TaxLevelCode>
                     <xsl:value-of select="DatiAnagrafici/RegimeFiscale"/>
                  </cbc:TaxLevelCode>
               </xsl:if>
               <cac:TaxScheme>
                  <cbc:ID>
                     <xsl:text>VAT</xsl:text>
                  </cbc:ID>
               </cac:TaxScheme>
            </cac:PartyTaxScheme>
            <cac:PartyLegalEntity>
               <cbc:RegistrationName>
                  <xsl:choose>
                     <xsl:when test="DatiAnagrafici/Anagrafica/Denominazione">
                        <xsl:value-of select="concat('Denominazione:', DatiAnagrafici/Anagrafica/Denominazione)"/>
                     </xsl:when>
                     <xsl:when test="DatiAnagrafici/Anagrafica[Nome or Cognome]">
                        <xsl:value-of select="normalize-space(concat('Nome&amp;Cognome:', DatiAnagrafici/Anagrafica/Nome, '#', DatiAnagrafici/Anagrafica/Cognome))"/>
                     </xsl:when>
                  </xsl:choose>
               </cbc:RegistrationName>
               <xsl:if test="DatiAnagrafici/CodiceFiscale">
                  <cbc:CompanyID schemeID="0210">
                     <xsl:value-of select="DatiAnagrafici/CodiceFiscale"/>
                  </cbc:CompanyID>
               </xsl:if>
               <xsl:if test="IscrizioneREA/CapitaleSociale or IscrizioneREA/SocioUnico or IscrizioneREA/StatoLiquidazione">
                  <cbc:CompanyLegalForm>
                     <xsl:value-of select="concat(IscrizioneREA/CapitaleSociale, '#', IscrizioneREA/SocioUnico, '#', IscrizioneREA/StatoLiquidazione)"/>
                  </cbc:CompanyLegalForm>
               </xsl:if>
            </cac:PartyLegalEntity>
            <xsl:apply-templates select="Contatti">
               <xsl:with-param name="CN" select="current()"/>
               <xsl:with-param name="CNP" select="position()"/>
            </xsl:apply-templates>
            <xsl:apply-templates select="StabileOrganizzazione" mode="StabileOrganizzazione_CedentePrestatore">
               <xsl:with-param name="CN" select="current()"/>
               <xsl:with-param name="CNP" select="position()"/>
            </xsl:apply-templates>
            <xsl:apply-templates select="/in:FatturaElettronica/FatturaElettronicaHeader/TerzoIntermediarioOSoggettoEmittente/DatiAnagrafici">
               <xsl:with-param name="CN" select="current()"/>
               <xsl:with-param name="CNP" select="position()"/>
            </xsl:apply-templates>
         </cac:Party>
      </cac:AccountingSupplierParty>
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
            <xsl:if test="DatiAnagrafici/Anagrafica/CodEORI">
               <cac:PartyIdentification>
                  <cbc:ID>
                     <xsl:value-of select="concat('EORI:', DatiAnagrafici/Anagrafica/CodEORI)"/>
                  </cbc:ID>
               </cac:PartyIdentification>
            </xsl:if>
            <xsl:apply-templates select="Sede" mode="Sede_CessionarioCommittente">
               <xsl:with-param name="CN" select="current()"/>
               <xsl:with-param name="CNP" select="position()"/>
            </xsl:apply-templates>
            <xsl:apply-templates select="DatiAnagrafici/IdFiscaleIVA" mode="VAT_CessionaroCommittente">
               <xsl:with-param name="CN" select="current()"/>
               <xsl:with-param name="CNP" select="position()"/>
            </xsl:apply-templates>
            <cac:PartyLegalEntity>
               <cbc:RegistrationName>
                  <xsl:choose>
                     <xsl:when test="DatiAnagrafici/Anagrafica/Denominazione">
                        <xsl:value-of select="concat('Denominazione:', DatiAnagrafici/Anagrafica/Denominazione)"/>
                     </xsl:when>
                     <xsl:when test="DatiAnagrafici/Anagrafica[Nome or Cognome]">
                        <xsl:value-of select="normalize-space(concat('Nome&amp;Cognome:', Nome, '#', Cognome))"/>
                     </xsl:when>
                  </xsl:choose>
               </cbc:RegistrationName>
               <xsl:if test="DatiAnagrafici/CodiceFiscale">
                  <cbc:CompanyID schemeID="0210">
                     <xsl:value-of select="DatiAnagrafici/CodiceFiscale"/>
                  </cbc:CompanyID>
               </xsl:if>
            </cac:PartyLegalEntity>
            <!-- Da verificare dove mettere la pec se c'è anche l'endpoint -->
            <!-- <cac:Contact>
               <xsl:if test="/in:FatturaElettronica/FatturaElettronicaHeader/DatiTrasmissione/PECDestinatario">
                  <cbc:ElectronicMail>
                     <xsl:value-of select="concat('pec:', /in:FatturaElettronica/FatturaElettronicaHeader/DatiTrasmissione/PECDestinatario)"/>
                  </cbc:ElectronicMail>
               </xsl:if>
            </cac:Contact> -->
            <xsl:apply-templates select="StabileOrganizzazione" mode="StabileOrganizzazione_CessionarioCommittente">
               <xsl:with-param name="CN" select="current()"/>
               <xsl:with-param name="CNP" select="position()"/>
            </xsl:apply-templates>
            <xsl:if test="RappresentanteFiscale">
               <cac:PowerOfAttorney>
                  <cac:AgentParty>
                     <cac:PartyTaxScheme>
                        <cbc:CompanyID>
                           <xsl:value-of select="concat(RappresentanteFiscale/IdFiscaleIVA/IdPaese, RappresentanteFiscale/IdFiscaleIVA/IdCodice)"/>
                        </cbc:CompanyID>
                        <cac:TaxScheme>
                           <cbc:ID>
                              <xsl:text>VAT</xsl:text>
                           </cbc:ID>
                        </cac:TaxScheme>
                     </cac:PartyTaxScheme>
                     <cac:PartyLegalEntity>
                        <cbc:RegistrationName>
                           <xsl:if test="RappresentanteFiscale/Denominazione">
                              <xsl:value-of select="RappresentanteFiscale/Denominazione"/>
                           </xsl:if>
                           <xsl:if test="not(RappresentanteFiscale/Denominazione)">
                              <xsl:value-of select="RappresentanteFiscale/Nome"/>
                              <xsl:text>#</xsl:text>
                              <xsl:value-of select="RappresentanteFiscale/Denominazione"/>
                           </xsl:if>
                        </cbc:RegistrationName>
                     </cac:PartyLegalEntity>
                     <xsl:if test="RappresentanteFiscale[Nome or Cognome]">
                        <cac:Person>
                           <cbc:FirstName>
                              <xsl:value-of select="RappresentanteFiscale/Nome"/>
                           </cbc:FirstName>
                           <cbc:FamilyName>
                              <xsl:value-of select="RappresentanteFiscale/Cognome"/>
                           </cbc:FamilyName>
                        </cac:Person>
                     </xsl:if>
                  </cac:AgentParty>
               </cac:PowerOfAttorney>
            </xsl:if>
         </cac:Party>
      </cac:AccountingCustomerParty>
   </xsl:template>
   <xsl:template match="FatturaElettronicaBody/DatiPagamento[1]/DettaglioPagamento[1]">
      <xsl:param name="CN" select="."/>
      <xsl:param name="CNP" select="1"/>
      <xsl:if test="NomeQuietanzante or CognomeQuietanzante or Beneficiario or CFQuietanzante">
         <cac:PayeeParty>
            <xsl:if test="NomeQuietanzante or CognomeQuietanzante">
               <cac:PartyIdentification>
                  <cbc:ID>
                     <xsl:value-of select="concat(CognomeQuietanzante, NomeQuietanzante)"/>
                  </cbc:ID>
               </cac:PartyIdentification>
            </xsl:if>
            <xsl:if test="Beneficiario">
               <cac:PartyName>
                  <cbc:Name>
                     <xsl:value-of select="Beneficiario"/>
                  </cbc:Name>
               </cac:PartyName>
            </xsl:if>
            <xsl:if test="CFQuietanzante">
               <cac:PartyLegalEntity>
                  <cbc:CompanyID schemeID="0210">
                     <xsl:value-of select="CognomeQuietanzante"/>
                  </cbc:CompanyID>
               </cac:PartyLegalEntity>
            </xsl:if>
         </cac:PayeeParty>
      </xsl:if>
   </xsl:template>
   <xsl:template match="FatturaElettronicaHeader/RappresentanteFiscale">
      <xsl:param name="CN" select="."/>
      <xsl:param name="CNP" select="1"/>
      <cac:TaxRepresentativeParty>
         <xsl:if test="DatiAnagrafici/CodiceFiscale">
            <cac:PartyIdentification>
               <cbc:ID>
                  <xsl:attribute name="schemeID">
                     <xsl:text>0210</xsl:text>
                  </xsl:attribute>
                  <xsl:value-of select="DatiAnagrafici/CodiceFiscale"/>
               </cbc:ID>
            </cac:PartyIdentification>
         </xsl:if>
         <xsl:if test="DatiAnagrafici/Anagrafica/CodEori">
            <cac:PartyIdentification>
               <cbc:ID>
                  <xsl:value-of select="concat('EORI:', DatiAnagrafici/Anagrafica/CodEor)"/>
               </cbc:ID>
            </cac:PartyIdentification>
         </xsl:if>
         <xsl:choose>
            <xsl:when test="DatiAnagrafici/Anagrafica/Denominazione">
               <cac:PartyName>
                  <cbc:Name>
                     <xsl:value-of select="concat('Denominazione:', DatiAnagrafici/Anagrafica/Denominazione)"/>
                  </cbc:Name>
               </cac:PartyName>
            </xsl:when>
            <xsl:when test="DatiAnagrafici/Anagrafica[Nome or Cognome]">
               <cac:PartyName>
                  <cbc:Name>
                     <xsl:value-of select="concat('Nome&amp;Cognome:', DatiAnagrafici/Anagrafica/Nome, '#', DatiAnagrafici/Anagrafica/Cognome)"/>
                  </cbc:Name>
               </cac:PartyName>
            </xsl:when>
         </xsl:choose>
         <cac:PartyTaxScheme>
            <cbc:CompanyID>
               <xsl:value-of select="concat(DatiAnagrafici/IdFiscaleIVA/IdPaese, DatiAnagrafici/IdFiscaleIVA/IdCodice)"/>
            </cbc:CompanyID>
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
         <xsl:variable name="variable_d1e272a1051010">
            <xsl:value-of select="document($xclVATSchemes)//Value[@ColumnRef='VATSchemeID']/SimpleValue[../../Value[@ColumnRef='code']/SimpleValue=current()/upper-case(IdPaese)][1]"/>
         </xsl:variable>
         <xsl:value-of select="concat(IdPaese, IdCodice)"/>
      </cbc:CompanyID>
   </xsl:template>
   <xsl:template match="IdFiscaleIVA">
      <xsl:param name="CN" select="."/>
      <xsl:param name="CNP" select="1"/>
      <cbc:CompanyID>
         <xsl:variable name="variable_d1e376a1051010">
            <xsl:value-of select="document($xclVATSchemes)//Value[@ColumnRef='VATSchemeID']/SimpleValue[../../Value[@ColumnRef='code']/SimpleValue=current()/upper-case(IdPaese)][1]"/>
         </xsl:variable>
         <xsl:if test="string($variable_d1e376a1051010)">
            <xsl:attribute name="schemeID">
               <xsl:value-of select="string($variable_d1e376a1051010)"/>
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
            <cbc:StreetName>
               <xsl:value-of select="Indirizzo"/>
            </cbc:StreetName>
            <xsl:if test="NumeroCivico">
               <cbc:AdditionalStreetName>
                  <xsl:value-of select="NumeroCivico"/>
               </cbc:AdditionalStreetName>
            </xsl:if>
            <cbc:CityName>
               <xsl:value-of select="Comune"/>
            </cbc:CityName>
            <cbc:PostalZone>
               <xsl:value-of select="CAP"/>
            </cbc:PostalZone>
            <cbc:CountrySubentity>
               <xsl:value-of select="Provincia"/>
            </cbc:CountrySubentity>
            <cac:Country>
               <cbc:IdentificationCode>
                  <xsl:value-of select="Nazione"/>
               </cbc:IdentificationCode>
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
               <xsl:variable name="variable_d1e241a1049836">
                  <xsl:value-of select="/in:FatturaElettronica/FatturaElettronicaBody/DatiGenerali/DatiGeneraliDocumento/Divisa"/>
               </xsl:variable>
               <xsl:if test="string($variable_d1e241a1049836)">
                  <xsl:attribute name="currencyID">
                     <xsl:value-of select="string($variable_d1e241a1049836)"/>
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
   <xsl:template match="Sede" mode="Sede_CedentePrestatore">
      <xsl:param name="CN" select="."/>
      <xsl:param name="CNP" select="1"/>
      <cac:PostalAddress>
         <cbc:StreetName>
            <xsl:value-of select="Indirizzo"/>
         </cbc:StreetName>
         <xsl:if test="NumeroCivico">
            <cbc:AdditionalStreetName>
               <xsl:value-of select="NumeroCivico"/>
            </cbc:AdditionalStreetName>
         </xsl:if>
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
            <cbc:IdentificationCode>
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
            <xsl:value-of select="Indirizzo"/>
         </cbc:StreetName>
         <xsl:if test="NumeroCivico">
            <cbc:AdditionalStreetName>
               <xsl:value-of select="NumeroCivico"/>
            </cbc:AdditionalStreetName>
         </xsl:if>
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
            <cbc:IdentificationCode>
               <xsl:value-of select="Nazione"/>
            </cbc:IdentificationCode>
         </cac:Country>
      </cac:PostalAddress>
   </xsl:template>

   <!-- Inizio creazione documento -->
   <xsl:template match="/in:FatturaElettronica" name="root">
      <xsl:param name="CN" select="."/>
      <xsl:param name="CNP" select="1"/>
      <Invoice>
         <xsl:apply-templates select="FatturaElettronicaBody">
            <xsl:with-param name="CN" select="current()"/>
            <xsl:with-param name="CNP" select="position()"/>
         </xsl:apply-templates>
         <cbc:UBLVersionID>
            <xsl:text>2.1</xsl:text>
         </cbc:UBLVersionID>
         <cbc:CustomizationID>
            <xsl:if test="FatturaElettronicaHeader/CedentePrestatore/Sede/Nazione = 'IT'">
               <xsl:text>urn:cen.eu:en16931:2017#compliant#urn:fdc:peppol.eu:2017:poacc:billing:3.0#conformant#urn:www.agid.gov.it:trns:fattura:3</xsl:text>
            </xsl:if>
            <xsl:if test="not(FatturaElettronicaHeader/CedentePrestatore/Sede/Nazione = 'IT')">
               <xsl:text>urn:cen.eu:en16931:2017#compliant#urn:fdc:peppol.eu:2017:poacc:billing:3.0#compliant#urn:www.agid.gov.it:trns:fattura:3</xsl:text>
            </xsl:if>
         </cbc:CustomizationID>
         <cbc:ProfileID>
            <xsl:text>urn:fdc:peppol.eu:2017:poacc:billing:01:1.0</xsl:text>
         </cbc:ProfileID>
         <cbc:ID>
            <xsl:value-of select="FatturaElettronicaBody/DatiGenerali/DatiGeneraliDocumento/Numero"/>
         </cbc:ID>
         <cbc:IssueDate>
            <xsl:value-of select="FatturaElettronicaBody/DatiGenerali/DatiGeneraliDocumento/Data"/>
         </cbc:IssueDate>
         <xsl:if test="FatturaElettronicaBody/DatiPagamento[1]/DettaglioPagamento[1]/DataScadenzaPagamento">
            <cbc:DueDate>
               <xsl:value-of select="FatturaElettronicaBody/DatiPagamento[1]/DettaglioPagamento[1]/DataScadenzaPagamento"/>
            </cbc:DueDate>
         </xsl:if>
         <cbc:InvoiceTypeCode>
            <xsl:value-of select="document($xclTipoDocumento)//Value[@ColumnRef='xcode']/SimpleValue[../../Value[@ColumnRef='code']/SimpleValue=current()/FatturaElettronicaBody/DatiGenerali/DatiGeneraliDocumento/TipoDocumento][1]"/>
         </cbc:InvoiceTypeCode>
         <xsl:apply-templates select="FatturaElettronicaBody/DatiGenerali/DatiGeneraliDocumento/Causale">
            <xsl:with-param name="CN" select="current()"/>
            <xsl:with-param name="CNP" select="position()"/>
         </xsl:apply-templates>
         <cbc:DocumentCurrencyCode>
            <xsl:value-of select="FatturaElettronicaBody/DatiGenerali/DatiGeneraliDocumento/Divisa"/>
         </cbc:DocumentCurrencyCode>
         <xsl:if test="FatturaElettronicaHeader/CedentePrestatore/RiferimentoAmministrazione">
            <cbc:AccountingCost>
               <xsl:value-of select="FatturaElettronicaHeader/CedentePrestatore/RiferimentoAmministrazione"/>
            </cbc:AccountingCost>
         </xsl:if>

         <!-- Da chiedere se corretto -->
         <cbc:BuyerReference>
            <xsl:if test="FatturaElettronicaBody/DatiGenerali/DatiOrdineAcquisto/CodiceCommessaConvenzione">
               <xsl:value-of select="concat(FatturaElettronicaBody/DatiGenerali/DatiOrdineAcquisto/IdDocumento, '#', FatturaElettronicaBody/DatiGenerali/DatiOrdineAcquisto/Data, '#', FatturaElettronicaBody/DatiGenerali/DatiOrdineAcquisto/CodiceCommessaConvenzione)"/>
            </xsl:if>
            <xsl:if test="not(FatturaElettronicaBody/DatiGenerali/DatiOrdineAcquisto/CodiceCommessaConvenzione)">
               <xsl:text>#NO#</xsl:text>
            </xsl:if>
         </cbc:BuyerReference>

         <xsl:if test="FatturaElettronicaBody/DatiBeniServizi/DatiRiepilogo[1]/EsigibilitaIVA and (FatturaElettronicaBody/DatiBeniServizi/DatiRiepilogo[1]/EsigibilitaIVA = 'I' or FatturaElettronicaBody/DatiBeniServizi/DatiRiepilogo[1]/EsigibilitaIVA = 'D')">
            <cac:InvoicePeriod>
               <cbc:DescriptionCode>
                  <xsl:choose>
                     <xsl:when test="FatturaElettronicaBody/DatiBeniServizi/DatiRiepilogo[1]/EsigibilitaIVA = 'I' and FatturaElettronicaBody/DatiGenerali/DatiGeneraliDocumento/Data = FatturaElettronicaBody/DatiGenerali/DatiTrasporto/DataOraConsegna">
                        <xsl:text>3</xsl:text>
                     </xsl:when>
                     <xsl:when test="FatturaElettronicaBody/DatiBeniServizi/DatiRiepilogo[1]/EsigibilitaIVA = 'I' and not(FatturaElettronicaBody/DatiGenerali/DatiGeneraliDocumento/Data = FatturaElettronicaBody/DatiGenerali/DatiTrasporto/DataOraConsegna)">
                        <xsl:text>35</xsl:text>
                     </xsl:when>
                     <xsl:otherwise>
                        <xsl:text>432</xsl:text>
                     </xsl:otherwise>
                  </xsl:choose>
               </cbc:DescriptionCode>
            </cac:InvoicePeriod>
         </xsl:if>

         <xsl:apply-templates select="FatturaElettronicaBody/DatiGenerali/DatiOrdineAcquisto[1]">
            <xsl:with-param name="CN" select="current()"/>
            <xsl:with-param name="CNP" select="position()"/>
         </xsl:apply-templates>
         <xsl:apply-templates select="FatturaElettronicaBody/DatiGenerali/DatiFattureCollegate">
            <xsl:with-param name="CN" select="current()"/>
            <xsl:with-param name="CNP" select="position()"/>
         </xsl:apply-templates>
         <xsl:apply-templates select="FatturaElettronicaBody/DatiGenerali/DatiDDT[1]">
            <xsl:with-param name="CN" select="current()"/>
            <xsl:with-param name="CNP" select="position()"/>
         </xsl:apply-templates>
         <xsl:apply-templates select="FatturaElettronicaBody/DatiGenerali/DatiRicezione[1]">
            <xsl:with-param name="CN" select="current()"/>
            <xsl:with-param name="CNP" select="position()"/>
         </xsl:apply-templates>
         <xsl:apply-templates select="FatturaElettronicaBody/DatiGenerali/DatiContratto[1]">
            <xsl:with-param name="CN" select="current()"/>
            <xsl:with-param name="CNP" select="position()"/>
         </xsl:apply-templates>
         <xsl:apply-templates select="FatturaElettronicaBody/DatiGenerali/DatiConvenzione">
            <xsl:with-param name="CN" select="current()"/>
            <xsl:with-param name="CNP" select="position()"/>
         </xsl:apply-templates>
         <xsl:apply-templates select="FatturaElettronicaBody/DatiGenerali/DatiSAL">
            <xsl:with-param name="CN" select="current()"/>
            <xsl:with-param name="CNP" select="position()"/>
         </xsl:apply-templates>
         <xsl:apply-templates select="FatturaElettronicaBody/Allegati">
            <xsl:with-param name="CN" select="current()"/>
            <xsl:with-param name="CNP" select="position()"/>
         </xsl:apply-templates>
         <xsl:apply-templates select="FatturaElettronicaBody/DatiGenerali/DatiContratto[1]/CodiceCUP">
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
         <xsl:apply-templates select="FatturaElettronicaBody/DatiPagamento[1]/DettaglioPagamento[1]">
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
         <xsl:apply-templates select="FatturaElettronicaBody/DatiPagamento[1]/DettaglioPagamento" mode="ModalitàPagamento">
            <xsl:with-param name="CN" select="current()"/>
            <xsl:with-param name="CNP" select="position()"/>
         </xsl:apply-templates>
         <xsl:apply-templates select="FatturaElettronicaBody/DatiPagamento[1]/DettaglioPagamento[1]" mode="TerminiPagamento">
            <xsl:with-param name="CN" select="current()"/>
            <xsl:with-param name="CNP" select="position()"/>
         </xsl:apply-templates>
         <xsl:apply-templates select="FatturaElettronicaBody/DatiGenerali/DatiGeneraliDocumento/DatiBollo">
            <xsl:with-param name="CN" select="current()"/>
            <xsl:with-param name="CNP" select="position()"/>
         </xsl:apply-templates>
         <xsl:apply-templates select="FatturaElettronicaBody/DatiGenerali/DatiGeneraliDocumento/DatiCassaPrevidenziale">
            <xsl:with-param name="CN" select="current()"/>
            <xsl:with-param name="CNP" select="position()"/>
         </xsl:apply-templates>
         <!-- Da chiedere come fare per l'amount che potrebbe non esserci visto che importo potrebbe
            non essere vlorizzato -->
         <xsl:apply-templates select="FatturaElettronicaBody/DatiGenerali/DatiGeneraliDocumento/ScontoMaggiorazione">
            <xsl:with-param name="CN" select="current()"/>
            <xsl:with-param name="CNP" select="position()"/>
         </xsl:apply-templates>
         <cac:TaxTotal>
            <cbc:TaxAmount>
               <xsl:variable name="variable_d1e425a1049836">
                  <xsl:value-of select="FatturaElettronicaBody/DatiGenerali/DatiGeneraliDocumento/Divisa"/>
               </xsl:variable>
               <xsl:if test="string($variable_d1e425a1049836)">
                  <xsl:attribute name="currencyID">
                     <xsl:value-of select="string($variable_d1e425a1049836)"/>
                  </xsl:attribute>
               </xsl:if>
               <xsl:value-of select="format-number(sum(FatturaElettronicaBody/DatiBeniServizi/DatiRiepilogo[position() &lt;= 2]/Imposta),'###########0.00')"/>
            </cbc:TaxAmount>
            <xsl:apply-templates select="FatturaElettronicaBody/DatiBeniServizi/DatiRiepilogo[position() &lt;= 2]">
               <xsl:with-param name="CN" select="current()"/>
               <xsl:with-param name="CNP" select="position()"/>
            </xsl:apply-templates>
         </cac:TaxTotal>
         <xsl:if test="FatturaElettronicaBody/DatiGenerali/DatiGeneraliDocumento/DatiRitenuta">
            <cac:WithholdingTaxTotal>
               <cbc:TaxAmount>
                  <xsl:variable name="variable_d1e437a1049836">
                     <xsl:value-of select="/in:FatturaElettronica/FatturaElettronicaBody/DatiGenerali/DatiGeneraliDocumento/Divisa"/>
                  </xsl:variable>
                  <xsl:if test="string($variable_d1e437a1049836)">
                     <xsl:attribute name="currencyID">
                        <xsl:value-of select="string($variable_d1e437a1049836)"/>
                     </xsl:attribute>
                  </xsl:if>
                  <xsl:value-of select="format-number(sum(FatturaElettronicaBody/DatiGenerali/DatiGeneraliDocumento/DatiRitenuta/ImportoRitenuta),'###########0.00')"/>
               </cbc:TaxAmount>
               <xsl:apply-templates select="FatturaElettronicaBody/DatiGenerali/DatiGeneraliDocumento/DatiRitenuta">
                  <xsl:with-param name="CN" select="current()"/>
                  <xsl:with-param name="CNP" select="position()"/>
               </xsl:apply-templates>
            </cac:WithholdingTaxTotal>
         </xsl:if>
         <xsl:apply-templates select="FatturaElettronicaBody/DatiGenerali/DatiGeneraliDocumento" mode="LegalMonetaryTotal">
            <xsl:with-param name="CN" select="current()"/>
            <xsl:with-param name="CNP" select="position()"/>
         </xsl:apply-templates>
         <xsl:apply-templates select="FatturaElettronicaBody/DatiBeniServizi/DettaglioLinee">
            <xsl:with-param name="CN" select="current()"/>
            <xsl:with-param name="CNP" select="position()"/>
         </xsl:apply-templates>
      </Invoice>
   </xsl:template>

   <xsl:template match="/">
      <xsl:apply-templates select="/in:FatturaElettronica"/>
   </xsl:template>
</xsl:stylesheet>