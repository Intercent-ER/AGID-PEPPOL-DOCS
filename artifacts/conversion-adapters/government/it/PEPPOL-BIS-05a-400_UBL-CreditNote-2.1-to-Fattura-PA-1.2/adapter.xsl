<?xml version="1.0" encoding="UTF-8"?>
<!--Stylesheet synthesized using Javest A2A Mapper environment.-->

<xsl:stylesheet xmlns:cac="urn:oasis:names:specification:ubl:schema:xsd:CommonAggregateComponents-2"
                xmlns:cbc="urn:oasis:names:specification:ubl:schema:xsd:CommonBasicComponents-2"
                xmlns:ccts="urn:un:unece:uncefact:documentation:2"
                xmlns:saxon="http://saxon.sf.net/"
                xmlns:cr="http://www.ubl-italia.org/ns/CrossReference"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:ds="http://www.w3.org/2000/09/xmldsig#"
                xmlns:ext="urn:oasis:names:specification:ubl:schema:xsd:CommonExtensionComponents-2"
                xmlns:in="urn:oasis:names:specification:ubl:schema:xsd:CreditNote-2"
                xmlns:nx="http://ivaservizi.agenziaentrate.gov.it/docs/xsd/fatture/v1.2"
                xmlns:qdt="urn:oasis:names:specification:ubl:schema:xsd:QualifiedDatatypes-2"
                xmlns:udt="urn:un:unece:uncefact:data:specification:UnqualifiedDataTypesSchemaModule:2"
                xmlns:asmap="http://www.javest.com/ns/mapper/snippet/attribute"
                xmlns:xsmap="http://www.javest.com/ns/mapper/snippet"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                exclude-result-prefixes="xsmap asmap in cac cbc ccts ext saxon qdt udt ds cr"
                version="2.0">
   <xsl:output indent="no"/>
   <xsl:param name="progInvio" as="xs:string">1</xsl:param>
   <xsl:param name="xclProvinceItaliane" as="xs:string">xcl/ProvinceItaliane-1.0.gc</xsl:param>
   <xsl:param name="xclUnitOfMeasureCode" as="xs:string">xcl/UnitOfMeasureCode-2.1.gc</xsl:param>
   <xsl:param name="xclCategoriaImposte" as="xs:string">xcl/CategoriaImposte.gc</xsl:param>
   <xsl:param name="xclPaymentMeansCode" as="xs:string">xcl/PaymentMeansCode-2.1.gc</xsl:param>
   <xsl:param name="xclFormatoAttachment" as="xs:string">xcl/FormatoAttachment.gc</xsl:param>
   <!--
Processing starts at node: /in:CreditNote
See the template rule at end of stylesheet for the default processing of 
the root node.
-->
<xsl:template match="//ext:UBLExtensions/ext:UBLExtension[ext:ExtensionURI=concat('urn:www.ubl-italia.org:spec:fatturapa:arrotondamento_riepilogo::',  1 + count(current()/preceding-sibling::cac:TaxSubtotal))]/ext:ExtensionContent/cbc:Amount">
      <xsl:param name="CN" select="."/>
      <xsl:param name="CNP" select="1"/>
      <Arrotondamento>
         <xsl:value-of select="."/>
      </Arrotondamento>
   </xsl:template>
   <xsl:template match="//ext:UBLExtensions/ext:UBLExtension[ext:ExtensionURI=concat('urn:www.ubl-italia.org:spec:fatturapa:spese_accessorie_riepilogo::', 1 + count(current()/preceding-sibling::cac:TaxSubtotal))]/ext:ExtensionContent/cbc:Amount">
      <xsl:param name="CN" select="."/>
      <xsl:param name="CNP" select="1"/>
      <SpeseAccessorie>
         <xsl:value-of select="."/>
      </SpeseAccessorie>
   </xsl:template>
   <xsl:template match="/in:CreditNote/cac:AccountingSupplierParty/cac:Party"
                 mode="RitenutaPersoneFisiche">
      <xsl:param name="CN" select="."/>
      <xsl:param name="CNP" select="1"/>
      <xsl:if test="cac:Person">
         <TipoRitenuta>
            <xsl:text>RT01</xsl:text>
         </TipoRitenuta>
      </xsl:if>
   </xsl:template>
   <xsl:template match="/in:CreditNote/cac:AccountingSupplierParty/cac:Party"
                 mode="RitenutaPersoneGiuridiche">
      <xsl:param name="CN" select="."/>
      <xsl:param name="CNP" select="1"/>
      <xsl:if test="cac:PartyName/cbc:Name and not(cac:Person)">
         <TipoRitenuta>
            <xsl:text>RT02</xsl:text>
         </TipoRitenuta>
      </xsl:if>
   </xsl:template>
   <xsl:template match="/in:CreditNote/cac:AdditionalDocumentReference[cbc:DocumentType='CIG']/cbc:ID"
                 mode="DatiOrdine_CIG">
      <xsl:param name="CN" select="."/>
      <xsl:param name="CNP" select="1"/>
      <xsl:if test="position()=$CNP">
         <CodiceCIG>
            <xsl:value-of select="."/>
         </CodiceCIG>
      </xsl:if>
   </xsl:template>
   <xsl:template match="/in:CreditNote/cac:AdditionalDocumentReference[cbc:DocumentType='CIG_CONTRATTO' or (not(/in:CreditNote/cac:OrderReference/cbc:ID) and cbc:DocumentType='CIG')]/cbc:ID[1]"
                 mode="DatiContratto_CIG">
      <xsl:param name="CN" select="."/>
      <xsl:param name="CNP" select="1"/>
      <xsl:if test="position()=$CNP">
         <CodiceCIG>
            <xsl:value-of select="."/>
         </CodiceCIG>
      </xsl:if>
   </xsl:template>
   <xsl:template match="/in:CreditNote/cac:AdditionalDocumentReference[cbc:DocumentType='CIG_CONVENZIONE']/cbc:ID"
                 mode="DatiConvenzione_CIG">
      <xsl:param name="CN" select="."/>
      <xsl:param name="CNP" select="1"/>
      <xsl:if test="position()=$CNP">
         <CodiceCIG>
            <xsl:value-of select="."/>
         </CodiceCIG>
      </xsl:if>
   </xsl:template>
   <xsl:template match="/in:CreditNote/cac:AdditionalDocumentReference[cbc:DocumentType='CIG_FATTURE_COLLEGATE']/cbc:ID"
                 mode="DatiFattureCollegate_CIG">
      <xsl:param name="CN" select="."/>
      <xsl:param name="CNP" select="1"/>
      <xsl:if test="position()=$CNP">
         <CodiceCIG>
            <xsl:value-of select="."/>
         </CodiceCIG>
      </xsl:if>
   </xsl:template>
   <xsl:template match="/in:CreditNote/cac:AdditionalDocumentReference[cbc:DocumentType='CIG_RICEZIONE']/cbc:ID"
                 mode="DatiRicezione_CIG">
      <xsl:param name="CN" select="."/>
      <xsl:param name="CNP" select="1"/>
      <xsl:if test="position()=$CNP">
         <CodiceCIG>
            <xsl:value-of select="."/>
         </CodiceCIG>
      </xsl:if>
   </xsl:template>
   <xsl:template match="/in:CreditNote/cac:AdditionalDocumentReference[cbc:DocumentType='CUP']/cbc:ID"
                 mode="DatiOrdine_CUP">
      <xsl:param name="CN" select="."/>
      <xsl:param name="CNP" select="1"/>
      <xsl:if test="position()=$CNP">
         <CodiceCUP>
            <xsl:value-of select="."/>
         </CodiceCUP>
      </xsl:if>
   </xsl:template>
   <xsl:template match="/in:CreditNote/cac:AdditionalDocumentReference[cbc:DocumentType='CUP_CONTRATTO' or (not(/in:CreditNote/cac:OrderReference/cbc:ID) and cbc:DocumentType='CUP')]/cbc:ID[1]"
                 mode="DatiContratto_CUP">
      <xsl:param name="CN" select="."/>
      <xsl:param name="CNP" select="1"/>
      <xsl:if test="position()=$CNP">
         <CodiceCUP>
            <xsl:value-of select="."/>
         </CodiceCUP>
      </xsl:if>
   </xsl:template>
   <xsl:template match="/in:CreditNote/cac:AdditionalDocumentReference[cbc:DocumentType='CUP_CONVENZIONE']/cbc:ID"
                 mode="DatiConvenzione_CUP">
      <xsl:param name="CN" select="."/>
      <xsl:param name="CNP" select="1"/>
      <xsl:if test="position()=$CNP">
         <CodiceCUP>
            <xsl:value-of select="."/>
         </CodiceCUP>
      </xsl:if>
   </xsl:template>
   <xsl:template match="/in:CreditNote/cac:AdditionalDocumentReference[cbc:DocumentType='CUP_FATTURE_COLLEGATE']/cbc:ID"
                 mode="DatiFattureCollegate_CUP">
      <xsl:param name="CN" select="."/>
      <xsl:param name="CNP" select="1"/>
      <xsl:if test="position()=$CNP">
         <CodiceCUP>
            <xsl:value-of select="."/>
         </CodiceCUP>
      </xsl:if>
   </xsl:template>
   <xsl:template match="/in:CreditNote/cac:AdditionalDocumentReference[cbc:DocumentType='CUP_RICEZIONE']/cbc:ID"
                 mode="DatiRicezione_CUP">
      <xsl:param name="CN" select="."/>
      <xsl:param name="CNP" select="1"/>
      <xsl:if test="position()=$CNP">
         <CodiceCUP>
            <xsl:value-of select="."/>
         </CodiceCUP>
      </xsl:if>
   </xsl:template>
   <xsl:template match="/in:CreditNote/cac:AdditionalDocumentReference[cbc:DocumentType='CommessaConvenzione']/cbc:ID"
                 mode="DatiOrdine_Commessa">
      <xsl:param name="CN" select="."/>
      <xsl:param name="CNP" select="1"/>
      <xsl:if test="position()=$CNP">
         <CodiceCommessaConvenzione>
            <xsl:value-of select="."/>
         </CodiceCommessaConvenzione>
      </xsl:if>
   </xsl:template>
   <xsl:template match="/in:CreditNote/cac:AdditionalDocumentReference[cbc:DocumentType='CommessaConvenzione_CONTRATTO' or (not(/in:CreditNote/cac:OrderReference/cbc:ID) and cbc:DocumentType='CommessaConvenzione')]/cbc:ID[1]"
                 mode="DatiContratto_Commessa">
      <xsl:param name="CN" select="."/>
      <xsl:param name="CNP" select="1"/>
      <xsl:if test="position()=$CNP">
         <CodiceCommessaConvenzione>
            <xsl:value-of select="."/>
         </CodiceCommessaConvenzione>
      </xsl:if>
   </xsl:template>
   <xsl:template match="/in:CreditNote/cac:AdditionalDocumentReference[cbc:DocumentType='CommessaConvenzione_CONVENZIONE']/cbc:ID"
                 mode="DatiConvenzione_CommessaConvenzione">
      <xsl:param name="CN" select="."/>
      <xsl:param name="CNP" select="1"/>
      <xsl:if test="position()=$CNP">
         <CodiceCommessaConvenzione>
            <xsl:value-of select="."/>
         </CodiceCommessaConvenzione>
      </xsl:if>
   </xsl:template>
   <xsl:template match="/in:CreditNote/cac:AdditionalDocumentReference[cbc:DocumentType='CommessaConvenzione_FATTURE_COLLEGATE']/cbc:ID"
                 mode="DatiFattureCollegate_CommessaConvenzione">
      <xsl:param name="CN" select="."/>
      <xsl:param name="CNP" select="1"/>
      <xsl:if test="position()=$CNP">
         <CodiceCommessaConvenzione>
            <xsl:value-of select="."/>
         </CodiceCommessaConvenzione>
      </xsl:if>
   </xsl:template>
   <xsl:template match="/in:CreditNote/cac:AdditionalDocumentReference[cbc:DocumentType='CommessaConvenzione_RICEZIONE']/cbc:ID"
                 mode="DatiRicezione_CommessaConvenzione">
      <xsl:param name="CN" select="."/>
      <xsl:param name="CNP" select="1"/>
      <xsl:if test="position()=$CNP">
         <CodiceCommessaConvenzione>
            <xsl:value-of select="."/>
         </CodiceCommessaConvenzione>
      </xsl:if>
   </xsl:template>
   <xsl:template match="/in:CreditNote/cac:AdditionalDocumentReference[cbc:DocumentType='EORI CedentePrestatore']/cbc:ID">
      <xsl:param name="CN" select="."/>
      <xsl:param name="CNP" select="1"/>
      <CodEORI>
         <xsl:value-of select="."/>
      </CodEORI>
   </xsl:template>
   <xsl:template match="/in:CreditNote/cac:CreditNoteLine/cac:DocumentReference[cbc:DocumentType='CIG']/cbc:ID"
                 mode="DatiOrdine_CIG_Riga">
      <xsl:param name="CN" select="."/>
      <xsl:param name="CNP" select="1"/>
      <xsl:if test="position()=$CNP">
         <CodiceCIG>
            <xsl:value-of select="."/>
         </CodiceCIG>
      </xsl:if>
   </xsl:template>
   <xsl:template match="/in:CreditNote/cac:CreditNoteLine/cac:DocumentReference[cbc:DocumentType='CIG_CONTRATTO' or (not(/in:CreditNote/cac:CreditNoteLine/cac:OrderLineReference) and cbc:DocumentType='CIG')]/cbc:ID[1]"
                 mode="DatiContratto_CIG_Riga">
      <xsl:param name="CN" select="."/>
      <xsl:param name="CNP" select="1"/>
      <xsl:if test="position()=$CNP">
         <CodiceCIG>
            <xsl:value-of select="."/>
         </CodiceCIG>
      </xsl:if>
   </xsl:template>
   <xsl:template match="/in:CreditNote/cac:CreditNoteLine/cac:DocumentReference[cbc:DocumentType='CIG_CONVENZIONE']/cbc:ID"
                 mode="DatiConvenzione_CIG_Riga">
      <xsl:param name="CN" select="."/>
      <xsl:param name="CNP" select="1"/>
      <xsl:if test="position()=$CNP">
         <CodiceCIG>
            <xsl:value-of select="."/>
         </CodiceCIG>
      </xsl:if>
   </xsl:template>
   <xsl:template match="/in:CreditNote/cac:CreditNoteLine/cac:DocumentReference[cbc:DocumentType='CIG_FATTURE_COLLEGATE']/cbc:ID"
                 mode="DatiFattureCollegate_CIG_Riga">
      <xsl:param name="CN" select="."/>
      <xsl:param name="CNP" select="1"/>
      <xsl:if test="position()=$CNP">
         <CodiceCIG>
            <xsl:value-of select="."/>
         </CodiceCIG>
      </xsl:if>
   </xsl:template>
   <xsl:template match="/in:CreditNote/cac:CreditNoteLine/cac:DocumentReference[cbc:DocumentType='CIG_RICEZIONE']/cbc:ID"
                 mode="DatiRicezione_CIG_Riga">
      <xsl:param name="CN" select="."/>
      <xsl:param name="CNP" select="1"/>
      <xsl:if test="position()=$CNP">
         <CodiceCIG>
            <xsl:value-of select="."/>
         </CodiceCIG>
      </xsl:if>
   </xsl:template>
   <xsl:template match="/in:CreditNote/cac:CreditNoteLine/cac:DocumentReference[cbc:DocumentType='CUP']/cbc:ID"
                 mode="DatiOrdine_CUP_Riga">
      <xsl:param name="CN" select="."/>
      <xsl:param name="CNP" select="1"/>
      <xsl:if test="position()=$CNP">
         <CodiceCUP>
            <xsl:value-of select="."/>
         </CodiceCUP>
      </xsl:if>
   </xsl:template>
   <xsl:template match="/in:CreditNote/cac:CreditNoteLine/cac:DocumentReference[cbc:DocumentType='CUP_CONTRATTO' or (not(/in:CreditNote/cac:CreditNoteLine/cac:OrderLineReference) and cbc:DocumentType='CUP')]/cbc:ID[1]"
                 mode="DatiContratto_CUP_Riga">
      <xsl:param name="CN" select="."/>
      <xsl:param name="CNP" select="1"/>
      <xsl:if test="position()=$CNP">
         <CodiceCUP>
            <xsl:value-of select="."/>
         </CodiceCUP>
      </xsl:if>
   </xsl:template>
   <xsl:template match="/in:CreditNote/cac:CreditNoteLine/cac:DocumentReference[cbc:DocumentType='CUP_CONVENZIONE']/cbc:ID"
                 mode="DatiConvenzione_CUP_Riga">
      <xsl:param name="CN" select="."/>
      <xsl:param name="CNP" select="1"/>
      <xsl:if test="position()=$CNP">
         <CodiceCUP>
            <xsl:value-of select="."/>
         </CodiceCUP>
      </xsl:if>
   </xsl:template>
   <xsl:template match="/in:CreditNote/cac:CreditNoteLine/cac:DocumentReference[cbc:DocumentType='CUP_FATTURE_COLLEGATE']/cbc:ID"
                 mode="DatiFattureCollegate_CUP_Riga">
      <xsl:param name="CN" select="."/>
      <xsl:param name="CNP" select="1"/>
      <xsl:if test="position()=$CNP">
         <CodiceCUP>
            <xsl:value-of select="."/>
         </CodiceCUP>
      </xsl:if>
   </xsl:template>
   <xsl:template match="/in:CreditNote/cac:CreditNoteLine/cac:DocumentReference[cbc:DocumentType='CUP_RICEZIONE']/cbc:ID"
                 mode="DatiRicezione_CUP_Riga">
      <xsl:param name="CN" select="."/>
      <xsl:param name="CNP" select="1"/>
      <xsl:if test="position()=$CNP">
         <CodiceCUP>
            <xsl:value-of select="."/>
         </CodiceCUP>
      </xsl:if>
   </xsl:template>
   <xsl:template match="/in:CreditNote/cac:CreditNoteLine/cac:DocumentReference[cbc:DocumentType='CommessaConvenzione']/cbc:ID"
                 mode="DatiOrdine_Commessa_Riga">
      <xsl:param name="CN" select="."/>
      <xsl:param name="CNP" select="1"/>
      <xsl:if test="position()=$CNP">
         <CodiceCommessaConvenzione>
            <xsl:value-of select="."/>
         </CodiceCommessaConvenzione>
      </xsl:if>
   </xsl:template>
   <xsl:template match="/in:CreditNote/cac:CreditNoteLine/cac:DocumentReference[cbc:DocumentType='CommessaConvenzione_CONTRATTO' or (not(/in:CreditNote/cac:CreditNoteLine/cac:OrderLineReference) and cbc:DocumentType='CommessaConvenzione')]/cbc:ID[1]"
                 mode="DatiContratto_Commessa_Riga">
      <xsl:param name="CN" select="."/>
      <xsl:param name="CNP" select="1"/>
      <xsl:if test="position()=$CNP">
         <CodiceCommessaConvenzione>
            <xsl:value-of select="."/>
         </CodiceCommessaConvenzione>
      </xsl:if>
   </xsl:template>
   <xsl:template match="/in:CreditNote/cac:CreditNoteLine/cac:DocumentReference[cbc:DocumentType='CommessaConvenzione_CONVENZIONE']/cbc:ID"
                 mode="DatiConvenzione_Commessa_Riga">
      <xsl:param name="CN" select="."/>
      <xsl:param name="CNP" select="1"/>
      <xsl:if test="position()=$CNP">
         <CodiceCommessaConvenzione>
            <xsl:value-of select="."/>
         </CodiceCommessaConvenzione>
      </xsl:if>
   </xsl:template>
   <xsl:template match="/in:CreditNote/cac:CreditNoteLine/cac:DocumentReference[cbc:DocumentType='CommessaConvenzione_FATTURE_COLLEGATE']/cbc:ID"
                 mode="DatiFattureCollegate_Commessa_Riga">
      <xsl:param name="CN" select="."/>
      <xsl:param name="CNP" select="1"/>
      <xsl:if test="position()=$CNP">
         <CodiceCommessaConvenzione>
            <xsl:value-of select="."/>
         </CodiceCommessaConvenzione>
      </xsl:if>
   </xsl:template>
   <xsl:template match="/in:CreditNote/cac:CreditNoteLine/cac:DocumentReference[cbc:DocumentType='CommessaConvenzione_RICEZIONE']/cbc:ID"
                 mode="DatiRicezione_Commessa_Riga">
      <xsl:param name="CN" select="."/>
      <xsl:param name="CNP" select="1"/>
      <xsl:if test="position()=$CNP">
         <CodiceCommessaConvenzione>
            <xsl:value-of select="."/>
         </CodiceCommessaConvenzione>
      </xsl:if>
   </xsl:template>
   <xsl:template match="/in:CreditNote/ext:UBLExtensions/ext:UBLExtension[ext:ExtensionURI='urn:www.ubl-italia.org:spec:fatturapa:contributo_cassa::2']/ext:ExtensionContent/cac:TaxTotal"
                 mode="CassaPrevidenziale2">
      <xsl:param name="CN" select="."/>
      <xsl:param name="CNP" select="1"/>
      <xsl:if test="cac:TaxSubtotal/cac:TaxCategory/cac:TaxScheme[cbc:ID='SSS']">
         <DatiCassaPrevidenziale>
            <TipoCassa>
               <xsl:value-of select="cac:TaxSubtotal/cac:TaxCategory/cac:TaxScheme/cbc:TaxTypeCode"/>
            </TipoCassa>
            <AlCassa>
               <xsl:value-of select="format-number(cac:TaxSubtotal/cac:TaxCategory/cbc:Percent,'##0.00')"/>
            </AlCassa>
            <ImportoContributoCassa>
               <xsl:value-of select="format-number(floor(cbc:TaxAmount * 100 + 0.5) div 100,'###########0.00')"/>
            </ImportoContributoCassa>
            <xsl:if test="cac:TaxSubtotal/cbc:TaxableAmount">
               <ImponibileCassa>
                  <xsl:value-of select="format-number(floor(cac:TaxSubtotal/cbc:TaxableAmount * 100 + 0.5) div 100,'###########0.00')"/>
               </ImponibileCassa>
            </xsl:if>
            <AliquotaIVA>
               <xsl:value-of select="if (/in:CreditNote/ext:UBLExtensions/ext:UBLExtension[ext:ExtensionURI='urn:www.ubl-italia.org:spec:fatturapa:contributo_cassa:aliquota_iva::2']/ext:ExtensionContent/cbc:Percent) then format-number(/in:CreditNote/ext:UBLExtensions/ext:UBLExtension[ext:ExtensionURI='urn:www.ubl-italia.org:spec:fatturapa:contributo_cassa:aliquota_iva::2']/ext:ExtensionContent/cbc:Percent,'##0.00') else format-number(/in:CreditNote/cac:TaxTotal/cac:TaxSubTotal/cac:TaxCategory[cbc:ID='S' and cac:TaxScheme/cbc:ID='VAT']/cbc:Percent,'##0.00')"/>
            </AliquotaIVA>
            <xsl:apply-templates select="/in:CreditNote/ext:UBLExtensions/ext:UBLExtension[ext:ExtensionURI='urn:www.ubl-italia.org:spec:fatturapa:contributo_cassa:ritenuta::2']/ext:ExtensionContent/cbc:TaxEvidenceIndicator[.=true()]">
               <xsl:with-param name="CN" select="current()"/>
               <xsl:with-param name="CNP" select="position()"/>
            </xsl:apply-templates>
            <xsl:if test="/in:CreditNote/ext:UBLExtensions/ext:UBLExtension[ext:ExtensionURI='urn:www.ubl-italia.org:spec:fatturapa:xref:contributo_cassa:natura_iva::2']/ext:ExtensionContent/cr:XCode">
               <Natura>
                  <xsl:value-of select="/in:CreditNote/ext:UBLExtensions/ext:UBLExtension[ext:ExtensionURI='urn:www.ubl-italia.org:spec:fatturapa:xref:contributo_cassa:natura_iva::2']/ext:ExtensionContent/cr:XCode"/>
               </Natura>
            </xsl:if>
         </DatiCassaPrevidenziale>
      </xsl:if>
   </xsl:template>
   <xsl:template match="/in:CreditNote/ext:UBLExtensions/ext:UBLExtension[ext:ExtensionURI='urn:www.ubl-italia.org:spec:fatturapa:contributo_cassa:ritenuta' or ext:ExtensionURI='urn:www.ubl-italia.org:spec:fatturapa:contributo_cassa:ritenuta::1']/ext:ExtensionContent/cbc:TaxEvidenceIndicator[.=true()][1]">
      <xsl:param name="CN" select="."/>
      <xsl:param name="CNP" select="1"/>
      <Ritenuta>
         <xsl:text>SI</xsl:text>
      </Ritenuta>
   </xsl:template>
   <xsl:template match="/in:CreditNote/ext:UBLExtensions/ext:UBLExtension[ext:ExtensionURI='urn:www.ubl-italia.org:spec:fatturapa:contributo_cassa:ritenuta::2']/ext:ExtensionContent/cbc:TaxEvidenceIndicator[.=true()]">
      <xsl:param name="CN" select="."/>
      <xsl:param name="CNP" select="1"/>
      <Ritenuta>
         <xsl:text>SI</xsl:text>
      </Ritenuta>
   </xsl:template>
   <xsl:template match="cac:AccountingCustomerParty">
      <xsl:param name="CN" select="."/>
      <xsl:param name="CNP" select="1"/>
      <CessionarioCommittente>
         <xsl:apply-templates select="cac:Party" mode="CessionarioCommittente_DatiAnagrafici">
            <xsl:with-param name="CN" select="current()"/>
            <xsl:with-param name="CNP" select="position()"/>
         </xsl:apply-templates>
         <xsl:apply-templates select="cac:Party/cac:PostalAddress" mode="CessionarioCommittente_Sede">
            <xsl:with-param name="CN" select="current()"/>
            <xsl:with-param name="CNP" select="position()"/>
         </xsl:apply-templates>
      </CessionarioCommittente>
   </xsl:template>
   <xsl:template match="cac:AccountingCustomerParty/cac:Party/cac:Contact/cbc:ElectronicMail">
      <xsl:param name="CN" select="."/>
      <xsl:param name="CNP" select="1"/>
      <xsl:if test="starts-with(upper-case(.) ,'PEC:')">
         <PECDestinatario>
            <xsl:value-of select="substring-after(., ':')"/>
         </PECDestinatario>
      </xsl:if>
   </xsl:template>
   <xsl:template match="cac:AccountingCustomerParty/cac:Party/cac:PartyIdentification/cbc:ID[1][@schemeID='IT:IPA']"
                 mode="CodiceDestinatario">
      <xsl:param name="CN" select="."/>
      <xsl:param name="CNP" select="1"/>
      <CodiceDestinatario>
         <xsl:value-of select="if (starts-with(upper-case(.), 'CODDEST:')) then substring-after(., ':') else ."/>
      </CodiceDestinatario>
   </xsl:template>
   <xsl:template match="cac:AccountingSupplierParty">
      <xsl:param name="CN" select="."/>
      <xsl:param name="CNP" select="1"/>
      <CedentePrestatore>
         <xsl:apply-templates select="cac:Party" mode="CedentePrestatore_DatiAnagrafici">
            <xsl:with-param name="CN" select="current()"/>
            <xsl:with-param name="CNP" select="position()"/>
         </xsl:apply-templates>
         <xsl:apply-templates select="cac:Party/cac:PostalAddress" mode="CedentePrestatore_Sede">
            <xsl:with-param name="CN" select="current()"/>
            <xsl:with-param name="CNP" select="position()"/>
         </xsl:apply-templates>
         <xsl:apply-templates select="cac:Party/cac:AgentParty/cac:PostalAddress"
                              mode="CedentePrestatore_StabileOrganizzazione">
            <xsl:with-param name="CN" select="current()"/>
            <xsl:with-param name="CNP" select="position()"/>
         </xsl:apply-templates>
         <xsl:apply-templates select="cac:Party/cac:PartyLegalEntity" mode="IscrizioneREA">
            <xsl:with-param name="CN" select="current()"/>
            <xsl:with-param name="CNP" select="position()"/>
         </xsl:apply-templates>
         <xsl:apply-templates select="cac:Party/cac:Contact" mode="CedentePrestatore_Contatti">
            <xsl:with-param name="CN" select="current()"/>
            <xsl:with-param name="CNP" select="position()"/>
         </xsl:apply-templates>
         <xsl:if test="cbc:CustomerAssignedAccountID">
            <RiferimentoAmministrazione>
               <xsl:value-of select="cbc:CustomerAssignedAccountID"/>
            </RiferimentoAmministrazione>
         </xsl:if>
      </CedentePrestatore>
   </xsl:template>
   <xsl:template match="cac:AccountingSupplierParty/cac:Party">
      <xsl:param name="CN" select="."/>
      <xsl:param name="CNP" select="1"/>
      <IdTrasmittente>
         <IdPaese>
            <xsl:text>IT</xsl:text>
         </IdPaese>
         <IdCodice>
            <xsl:text>91252510374</xsl:text>
         </IdCodice>
      </IdTrasmittente>
   </xsl:template>
   <xsl:template match="cac:AdditionalDocumentReference" mode="SAL">
      <xsl:param name="CN" select="."/>
      <xsl:param name="CNP" select="1"/>
      <xsl:if test="cbc:DocumentType='SAL'">
         <DatiSAL>
            <RiferimentoFase>
               <xsl:value-of select="cbc:ID"/>
            </RiferimentoFase>
         </DatiSAL>
      </xsl:if>
   </xsl:template>
   <xsl:template match="cac:AdditionalDocumentReference" mode="Allegati">
      <xsl:param name="CN" select="."/>
      <xsl:param name="CNP" select="1"/>
      <xsl:if test="cac:Attachment/cbc:EmbeddedDocumentBinaryObject">
         <Allegati>
            <NomeAttachment>
               <xsl:value-of select="if (cbc:DocumentType) then cbc:DocumentType else 'non specificato'"/>
            </NomeAttachment>
            <FormatoAttachment>
               <xsl:value-of select="if (document($xclFormatoAttachment)//Value[@ColumnRef='code']/SimpleValue[../../Value[@ColumnRef='xcode']/SimpleValue=current()/cac:Attachment/cbc:EmbeddedDocumentBinaryObject/@mimeCode][1]) then document($xclFormatoAttachment)//Value[@ColumnRef='code']/SimpleValue[../../Value[@ColumnRef='xcode']/SimpleValue=current()/cac:Attachment/cbc:EmbeddedDocumentBinaryObject/@mimeCode][1] else if (matches(cbc:DocumentType,'\.[a-zA-Z]{3,4}$')) then tokenize(cbc:DocumentType, '\.')[last()] else 'binary'"/>
            </FormatoAttachment>
            <xsl:if test="cac:Attachment/cbc:EmbeddedDocumentBinaryObject">
               <Attachment>
                  <xsl:value-of select="cac:Attachment/cbc:EmbeddedDocumentBinaryObject"/>
               </Attachment>
            </xsl:if>
         </Allegati>
      </xsl:if>
   </xsl:template>
   <xsl:template match="cac:AllowanceCharge">
      <xsl:param name="CN" select="."/>
      <xsl:param name="CNP" select="1"/>
      <ScontoMaggiorazione>
         <xsl:if test="cbc:ChargeIndicator=true()">
            <Tipo>
               <xsl:text>MG</xsl:text>
            </Tipo>
         </xsl:if>
         <xsl:if test="cbc:ChargeIndicator=false()">
            <Tipo>
               <xsl:text>SC</xsl:text>
            </Tipo>
         </xsl:if>
         <Importo>
            <xsl:value-of select="format-number(cbc:Amount,'###########0.00')"/>
         </Importo>
      </ScontoMaggiorazione>
   </xsl:template>
   <xsl:template match="cac:AllowanceCharge" mode="ScontoMaggiorazione_Riga">
      <xsl:param name="CN" select="."/>
      <xsl:param name="CNP" select="1"/>
      <xsl:if test=".">
         <ScontoMaggiorazione>
            <Tipo>
               <xsl:value-of select="if (cbc:ChargeIndicator=true()) then 'MG' else 'SC'"/>
            </Tipo>
            <Importo>
               <xsl:value-of select="format-number(cbc:Amount,'###########0.00')"/>
            </Importo>
         </ScontoMaggiorazione>
      </xsl:if>
   </xsl:template>
   <xsl:template match="cac:BillingReference/cac:AdditionalDocumentReference"
                 mode="FatturaPrincipale">
      <xsl:param name="CN" select="."/>
      <xsl:param name="CNP" select="1"/>
      <xsl:if test="cbc:DocumentType='FatturaPrincipale'">
         <FatturaPrincipale>
            <NumeroFatturaPrincipale>
               <xsl:value-of select="cbc:ID"/>
            </NumeroFatturaPrincipale>
            <DataFatturaPrincipale>
               <xsl:value-of select="&#x9;substring(string(cbc:IssueDate),1,10)"/>
            </DataFatturaPrincipale>
         </FatturaPrincipale>
      </xsl:if>
   </xsl:template>
   <xsl:template match="cac:BillingReference/cac:InvoiceDocumentReference"
                 mode="FatturaCollegata">
      <xsl:param name="CN" select="."/>
      <xsl:param name="CNP" select="1"/>
      <xsl:if test="cbc:ID">
         <DatiFattureCollegate>
            <IdDocumento>
               <xsl:value-of select="cbc:ID"/>
            </IdDocumento>
            <xsl:if test="cbc:IssueDate">
               <Data>
                  <xsl:value-of select="&#x9;substring(string(cbc:IssueDate),1,10)"/>
               </Data>
            </xsl:if>
            <xsl:apply-templates select="/in:CreditNote/cac:AdditionalDocumentReference[cbc:DocumentType='CommessaConvenzione_FATTURE_COLLEGATE']/cbc:ID"
                                 mode="DatiFattureCollegate_CommessaConvenzione">
               <xsl:with-param name="CN" select="current()"/>
               <xsl:with-param name="CNP" select="position()"/>
            </xsl:apply-templates>
            <xsl:apply-templates select="/in:CreditNote/cac:AdditionalDocumentReference[cbc:DocumentType='CUP_FATTURE_COLLEGATE']/cbc:ID"
                                 mode="DatiFattureCollegate_CUP">
               <xsl:with-param name="CN" select="current()"/>
               <xsl:with-param name="CNP" select="position()"/>
            </xsl:apply-templates>
            <xsl:apply-templates select="/in:CreditNote/cac:AdditionalDocumentReference[cbc:DocumentType='CIG_FATTURE_COLLEGATE']/cbc:ID"
                                 mode="DatiFattureCollegate_CIG">
               <xsl:with-param name="CN" select="current()"/>
               <xsl:with-param name="CNP" select="position()"/>
            </xsl:apply-templates>
         </DatiFattureCollegate>
      </xsl:if>
   </xsl:template>
   <xsl:template match="cac:ContractDocumentReference">
      <xsl:param name="CN" select="."/>
      <xsl:param name="CNP" select="1"/>
      <xsl:if test="count(/in:CreditNote/cac:CreditNoteLine/cac:DocumentReference[cbc:DocumentType='ESTREMI_CONTRATTO']) = 0">
         <DatiContratto>
            <IdDocumento>
               <xsl:value-of select="cbc:ID"/>
            </IdDocumento>
            <xsl:if test="cbc:IssueDate">
               <Data>
                  <xsl:value-of select="&#x9;substring(string(cbc:IssueDate),1,10)"/>
               </Data>
            </xsl:if>
            <xsl:apply-templates select="/in:CreditNote/cac:AdditionalDocumentReference[cbc:DocumentType='CommessaConvenzione_CONTRATTO' or (not(/in:CreditNote/cac:OrderReference/cbc:ID) and cbc:DocumentType='CommessaConvenzione')]/cbc:ID[1]"
                                 mode="DatiContratto_Commessa">
               <xsl:with-param name="CN" select="current()"/>
               <xsl:with-param name="CNP" select="position()"/>
            </xsl:apply-templates>
            <xsl:apply-templates select="/in:CreditNote/cac:AdditionalDocumentReference[cbc:DocumentType='CUP_CONTRATTO' or (not(/in:CreditNote/cac:OrderReference/cbc:ID) and cbc:DocumentType='CUP')]/cbc:ID[1]"
                                 mode="DatiContratto_CUP">
               <xsl:with-param name="CN" select="current()"/>
               <xsl:with-param name="CNP" select="position()"/>
            </xsl:apply-templates>
            <xsl:apply-templates select="/in:CreditNote/cac:AdditionalDocumentReference[cbc:DocumentType='CIG_CONTRATTO' or (not(/in:CreditNote/cac:OrderReference/cbc:ID) and cbc:DocumentType='CIG')]/cbc:ID[1]"
                                 mode="DatiContratto_CIG">
               <xsl:with-param name="CN" select="current()"/>
               <xsl:with-param name="CNP" select="position()"/>
            </xsl:apply-templates>
         </DatiContratto>
      </xsl:if>
   </xsl:template>
   <xsl:template match="cac:CreditNoteLine">
      <xsl:param name="CN" select="."/>
      <xsl:param name="CNP" select="1"/>
      <DettaglioLinee>
         <NumeroLinea>
            <xsl:value-of select="if (number(cbc:ID) &gt; 0) then number(cbc:ID) else position()"/>
         </NumeroLinea>
         <xsl:apply-templates select="cbc:ID" mode="TipoCessionePrestazione">
            <xsl:with-param name="CN" select="current()"/>
            <xsl:with-param name="CNP" select="position()"/>
         </xsl:apply-templates>
         <xsl:apply-templates select="cac:Item/cac:CommodityClassification/cbc:ItemClassificationCode">
            <xsl:with-param name="CN" select="current()"/>
            <xsl:with-param name="CNP" select="position()"/>
         </xsl:apply-templates>
         <xsl:apply-templates select="cac:Item/cac:CommodityClassification/cbc:CommodityCode">
            <xsl:with-param name="CN" select="current()"/>
            <xsl:with-param name="CNP" select="position()"/>
         </xsl:apply-templates>
         <xsl:apply-templates select="cac:Item/cac:SellersItemIdentification/cbc:ID">
            <xsl:with-param name="CN" select="current()"/>
            <xsl:with-param name="CNP" select="position()"/>
         </xsl:apply-templates>
         <xsl:apply-templates select="cac:Item/cac:StandardItemIdentification/cbc:ID">
            <xsl:with-param name="CN" select="current()"/>
            <xsl:with-param name="CNP" select="position()"/>
         </xsl:apply-templates>
         <Descrizione>
            <xsl:value-of select="normalize-space(cac:Item/cbc:Name)"/>
         </Descrizione>
         <xsl:if test="cbc:CreditedQuantity">
            <Quantita>
               <xsl:value-of select="format-number(cbc:CreditedQuantity,'###########0.00000000')"/>
            </Quantita>
         </xsl:if>
         <xsl:if test="not(cbc:CreditedQuantity)">
            <Quantita>
               <xsl:text>1.00</xsl:text>
            </Quantita>
         </xsl:if>
         <xsl:if test="cbc:CreditedQuantity/@unitCode">
            <UnitaMisura>
               <xsl:value-of select="document($xclUnitOfMeasureCode)//Value[@ColumnRef='xname']/SimpleValue[../../Value[@ColumnRef='code']/SimpleValue=current()/cbc:CreditedQuantity/@unitCode][1]"/>
            </UnitaMisura>
         </xsl:if>
         <xsl:if test="cac:InvoicePeriod/cbc:StartDate">
            <DataInizioPeriodo>
               <xsl:value-of select="&#x9;substring(string(cac:InvoicePeriod/cbc:StartDate),1,10)"/>
            </DataInizioPeriodo>
         </xsl:if>
         <xsl:if test="cac:InvoicePeriod/cbc:EndDate">
            <DataFinePeriodo>
               <xsl:value-of select="&#x9;substring(string(cac:InvoicePeriod/cbc:EndDate),1,10)"/>
            </DataFinePeriodo>
         </xsl:if>
         <PrezzoUnitario>
            <xsl:value-of select="format-number(cac:Price/cbc:PriceAmount,'###########0.00000000')"/>
         </PrezzoUnitario>
         <xsl:apply-templates select="cac:AllowanceCharge" mode="ScontoMaggiorazione_Riga">
            <xsl:with-param name="CN" select="current()"/>
            <xsl:with-param name="CNP" select="position()"/>
         </xsl:apply-templates>
         <PrezzoTotale>
            <xsl:value-of select="format-number(cbc:LineExtensionAmount,'###########0.00000000')"/>
         </PrezzoTotale>
         <xsl:apply-templates select="cac:Item/cac:ClassifiedTaxCategory" mode="AliquotaIVA_Dettaglio">
            <xsl:with-param name="CN" select="current()"/>
            <xsl:with-param name="CNP" select="position()"/>
         </xsl:apply-templates>
         <xsl:if test="cac:WithholdingTaxTotal/cac:TaxSubtotal/cac:TaxCategory/cac:TaxScheme[cbc:ID='SWT']">
            <Ritenuta>
               <xsl:text>SI</xsl:text>
            </Ritenuta>
         </xsl:if>
         <xsl:if test="cac:Item/cac:ClassifiedTaxCategory[cbc:ID and cbc:ID[not(contains(' S AA H ',concat(' ',normalize-space(.),' ')))] and cac:TaxScheme/cbc:ID='VAT']">
            <Natura>
               <xsl:value-of select="if (/in:CreditNote/ext:UBLExtensions/ext:UBLExtension[ext:ExtensionURI = concat('urn:www.ubl-italia.org:spec:fatturapa:xref:natura::', 1 + count(current()/preceding-sibling::cac:CreditNoteLine))]) then /in:CreditNote/ext:UBLExtensions/ext:UBLExtension[ext:ExtensionURI = concat('urn:www.ubl-italia.org:spec:fatturapa:xref:natura::', 1 + count(current()/preceding-sibling::cac:CreditNoteLine))]/ext:ExtensionContent/cr:XCode else (if (/in:CreditNote/ext:UBLExtensions/ext:UBLExtension[ext:ExtensionURI=concat('urn:www.ubl-italia.org:spec:fatturapa:xref:natura::', current()/cac:Item/cac:ClassifiedTaxCategory/cbc:ID)]) then /in:CreditNote/ext:UBLExtensions/ext:UBLExtension[ext:ExtensionURI=concat('urn:www.ubl-italia.org:spec:fatturapa:xref:natura::', current()/cac:Item/cac:ClassifiedTaxCategory/cbc:ID)]/ext:ExtensionContent/cr:XCode else (document($xclCategoriaImposte)//Value[@ColumnRef='code']/SimpleValue[../../Value[@ColumnRef='xcode']/SimpleValue=current()/cac:Item/cac:ClassifiedTaxCategory/cbc:ID])[1])"/>
            </Natura>
         </xsl:if>
         <xsl:if test="cbc:AccountingCost">
            <RiferimentoAmministrazione>
               <xsl:value-of select="cbc:AccountingCost"/>
            </RiferimentoAmministrazione>
         </xsl:if>
         <xsl:apply-templates select="cac:DespatchLineReference">
            <xsl:with-param name="CN" select="current()"/>
            <xsl:with-param name="CNP" select="position()"/>
         </xsl:apply-templates>
         <xsl:apply-templates select="cac:Item/cac:ClassifiedTaxCategory/cbc:ID">
            <xsl:with-param name="CN" select="current()"/>
            <xsl:with-param name="CNP" select="position()"/>
         </xsl:apply-templates>
      </DettaglioLinee>
   </xsl:template>
   <xsl:template match="cac:CreditNoteLine/cac:BillingReference"
                 mode="DatiFattureCollegate_Riga">
      <xsl:param name="CN" select="."/>
      <xsl:param name="CNP" select="1"/>
      <xsl:if test="cac:InvoiceDocumentReference/cbc:ID">
         <DatiFattureCollegate>
            <RiferimentoNumeroLinea>
               <xsl:value-of select="../cbc:ID"/>
            </RiferimentoNumeroLinea>
            <IdDocumento>
               <xsl:value-of select="cac:InvoiceDocumentReference/cbc:ID"/>
            </IdDocumento>
            <xsl:if test="cac:InvoiceDocumentReference/cbc:IssueDate">
               <Data>
                  <xsl:value-of select="substring(string(cac:InvoiceDocumentReference/cbc:IssueDate),1,10)"/>
               </Data>
            </xsl:if>
            <xsl:apply-templates select="/in:CreditNote/cac:CreditNoteLine/cac:DocumentReference[cbc:DocumentType='CommessaConvenzione_FATTURE_COLLEGATE']/cbc:ID"
                                 mode="DatiFattureCollegate_Commessa_Riga">
               <xsl:with-param name="CN" select="current()"/>
               <xsl:with-param name="CNP" select="position()"/>
            </xsl:apply-templates>
            <xsl:apply-templates select="/in:CreditNote/cac:CreditNoteLine/cac:DocumentReference[cbc:DocumentType='CUP_FATTURE_COLLEGATE']/cbc:ID"
                                 mode="DatiFattureCollegate_CUP_Riga">
               <xsl:with-param name="CN" select="current()"/>
               <xsl:with-param name="CNP" select="position()"/>
            </xsl:apply-templates>
            <xsl:apply-templates select="/in:CreditNote/cac:CreditNoteLine/cac:DocumentReference[cbc:DocumentType='CIG_FATTURE_COLLEGATE']/cbc:ID"
                                 mode="DatiFattureCollegate_CIG_Riga">
               <xsl:with-param name="CN" select="current()"/>
               <xsl:with-param name="CNP" select="position()"/>
            </xsl:apply-templates>
         </DatiFattureCollegate>
      </xsl:if>
   </xsl:template>
   <xsl:template match="cac:CreditNoteLine/cac:DespatchLineReference" mode="DatiDDT">
      <xsl:param name="CN" select="."/>
      <xsl:param name="CNP" select="1"/>
      <xsl:if test=".">
         <DatiDDT>
            <NumeroDDT>
               <xsl:value-of select="cac:DocumentReference/cbc:ID"/>
            </NumeroDDT>
            <DataDDT>
               <xsl:value-of select="&#x9;substring(string(cac:DocumentReference/cbc:IssueDate),1,10)"/>
            </DataDDT>
            <RiferimentoNumeroLinea>
               <xsl:value-of select="../cbc:ID"/>
            </RiferimentoNumeroLinea>
         </DatiDDT>
      </xsl:if>
   </xsl:template>
   <xsl:template match="cac:CreditNoteLine/cac:DocumentReference[cbc:DocumentType='ESTREMI_CONTRATTO']"
                 mode="DatiContratto_Riga">
      <xsl:param name="CN" select="."/>
      <xsl:param name="CNP" select="1"/>
      <DatiContratto>
         <RiferimentoNumeroLinea>
            <xsl:value-of select="../cbc:ID"/>
         </RiferimentoNumeroLinea>
         <IdDocumento>
            <xsl:value-of select="cbc:ID"/>
         </IdDocumento>
         <xsl:if test="cbc:IssueDate">
            <Data>
               <xsl:value-of select="&#x9;substring(string(cbc:IssueDate),1,10)"/>
            </Data>
         </xsl:if>
         <xsl:apply-templates select="/in:CreditNote/cac:CreditNoteLine/cac:DocumentReference[cbc:DocumentType='CommessaConvenzione_CONTRATTO' or (not(/in:CreditNote/cac:CreditNoteLine/cac:OrderLineReference) and cbc:DocumentType='CommessaConvenzione')]/cbc:ID[1]"
                              mode="DatiContratto_Commessa_Riga">
            <xsl:with-param name="CN" select="current()"/>
            <xsl:with-param name="CNP" select="position()"/>
         </xsl:apply-templates>
         <xsl:apply-templates select="/in:CreditNote/cac:CreditNoteLine/cac:DocumentReference[cbc:DocumentType='CUP_CONTRATTO' or (not(/in:CreditNote/cac:CreditNoteLine/cac:OrderLineReference) and cbc:DocumentType='CUP')]/cbc:ID[1]"
                              mode="DatiContratto_CUP_Riga">
            <xsl:with-param name="CN" select="current()"/>
            <xsl:with-param name="CNP" select="position()"/>
         </xsl:apply-templates>
         <xsl:apply-templates select="/in:CreditNote/cac:CreditNoteLine/cac:DocumentReference[cbc:DocumentType='CIG_CONTRATTO' or (not(/in:CreditNote/cac:CreditNoteLine/cac:OrderLineReference) and cbc:DocumentType='CIG')]/cbc:ID[1]"
                              mode="DatiContratto_CIG_Riga">
            <xsl:with-param name="CN" select="current()"/>
            <xsl:with-param name="CNP" select="position()"/>
         </xsl:apply-templates>
      </DatiContratto>
   </xsl:template>
   <xsl:template match="cac:CreditNoteLine/cac:DocumentReference[cbc:DocumentType='ESTREMI_CONVENZIONE']"
                 mode="Estremi_Convenzione_Riga">
      <xsl:param name="CN" select="."/>
      <xsl:param name="CNP" select="1"/>
      <DatiConvenzione>
         <RiferimentoNumeroLinea>
            <xsl:value-of select="../cbc:ID"/>
         </RiferimentoNumeroLinea>
         <IdDocumento>
            <xsl:value-of select="cbc:ID"/>
         </IdDocumento>
         <xsl:if test="cbc:IssueDate">
            <Data>
               <xsl:value-of select="&#x9;substring(string(cbc:IssueDate),1,10)"/>
            </Data>
         </xsl:if>
         <xsl:apply-templates select="/in:CreditNote/cac:CreditNoteLine/cac:DocumentReference[cbc:DocumentType='CommessaConvenzione_CONVENZIONE']/cbc:ID"
                              mode="DatiConvenzione_Commessa_Riga">
            <xsl:with-param name="CN" select="current()"/>
            <xsl:with-param name="CNP" select="position()"/>
         </xsl:apply-templates>
         <xsl:apply-templates select="/in:CreditNote/cac:CreditNoteLine/cac:DocumentReference[cbc:DocumentType='CUP_CONVENZIONE']/cbc:ID"
                              mode="DatiConvenzione_CUP_Riga">
            <xsl:with-param name="CN" select="current()"/>
            <xsl:with-param name="CNP" select="position()"/>
         </xsl:apply-templates>
         <xsl:apply-templates select="/in:CreditNote/cac:CreditNoteLine/cac:DocumentReference[cbc:DocumentType='CIG_CONVENZIONE']/cbc:ID"
                              mode="DatiConvenzione_CIG_Riga">
            <xsl:with-param name="CN" select="current()"/>
            <xsl:with-param name="CNP" select="position()"/>
         </xsl:apply-templates>
      </DatiConvenzione>
   </xsl:template>
   <xsl:template match="cac:CreditNoteLine/cac:OrderLineReference"
                 mode="DatiOrdineAcquisto_Riga">
      <xsl:param name="CN" select="."/>
      <xsl:param name="CNP" select="1"/>
      <DatiOrdineAcquisto>
         <RiferimentoNumeroLinea>
            <xsl:value-of select="../cbc:ID"/>
         </RiferimentoNumeroLinea>
         <IdDocumento>
            <xsl:value-of select="if (cac:OrderReference) then cac:OrderReference/cbc:ID else /in:CreditNote/cac:OrderReference/cbc:ID"/>
         </IdDocumento>
         <xsl:if test="cac:OrderReference/cbc:IssueDate or /in:CreditNote/cac:OrderReference/cbc:IssueDate">
            <Data>
               <xsl:value-of select="if (cac:OrderReference) then &#x9;substring(string(cac:OrderReference/cbc:IssueDate),1,10) else substring(string(/in:CreditNote/cac:OrderReference/cbc:IssueDate),1,10)"/>
            </Data>
         </xsl:if>
         <xsl:if test="cbc:LineID != '0'">
            <NumItem>
               <xsl:value-of select="cbc:LineID"/>
            </NumItem>
         </xsl:if>
         <xsl:apply-templates select="/in:CreditNote/cac:CreditNoteLine/cac:DocumentReference[cbc:DocumentType='CommessaConvenzione']/cbc:ID"
                              mode="DatiOrdine_Commessa_Riga">
            <xsl:with-param name="CN" select="current()"/>
            <xsl:with-param name="CNP" select="position()"/>
         </xsl:apply-templates>
         <xsl:apply-templates select="/in:CreditNote/cac:CreditNoteLine/cac:DocumentReference[cbc:DocumentType='CUP']/cbc:ID"
                              mode="DatiOrdine_CUP_Riga">
            <xsl:with-param name="CN" select="current()"/>
            <xsl:with-param name="CNP" select="position()"/>
         </xsl:apply-templates>
         <xsl:apply-templates select="/in:CreditNote/cac:CreditNoteLine/cac:DocumentReference[cbc:DocumentType='CIG']/cbc:ID"
                              mode="DatiOrdine_CIG_Riga">
            <xsl:with-param name="CN" select="current()"/>
            <xsl:with-param name="CNP" select="position()"/>
         </xsl:apply-templates>
      </DatiOrdineAcquisto>
   </xsl:template>
   <xsl:template match="cac:CreditNoteLine/cac:ReceiptLineReference" mode="DatiRicezione_Riga">
      <xsl:param name="CN" select="."/>
      <xsl:param name="CNP" select="1"/>
      <DatiRicezione>
         <RiferimentoNumeroLinea>
            <xsl:value-of select="../cbc:ID"/>
         </RiferimentoNumeroLinea>
         <IdDocumento>
            <xsl:value-of select="if (cac:DocumentReference) then cac:DocumentReference/cbc:ID else /in:CreditNote/cac:ReceiptDocumentReference/cbc:ID"/>
         </IdDocumento>
         <xsl:if test="cac:DocumentReference/cbc:IssueDate or /in:CreditNote/cac:ReceiptDocumentReference/cbc:IssueDate">
            <Data>
               <xsl:value-of select="if (cac:DocumentReference) then &#x9;substring(string(cac:DocumentReference/cbc:IssueDate),1,10) else &#x9;substring(string(/in:CreditNote/cac:ReceiptDocumentReference/cbc:IssueDate),1,10)"/>
            </Data>
         </xsl:if>
         <xsl:if test="cbc:LineID != '0'">
            <NumItem>
               <xsl:value-of select="cbc:LineID"/>
            </NumItem>
         </xsl:if>
         <xsl:apply-templates select="/in:CreditNote/cac:CreditNoteLine/cac:DocumentReference[cbc:DocumentType='CommessaConvenzione_RICEZIONE']/cbc:ID"
                              mode="DatiRicezione_Commessa_Riga">
            <xsl:with-param name="CN" select="current()"/>
            <xsl:with-param name="CNP" select="position()"/>
         </xsl:apply-templates>
         <xsl:apply-templates select="/in:CreditNote/cac:CreditNoteLine/cac:DocumentReference[cbc:DocumentType='CUP_RICEZIONE']/cbc:ID"
                              mode="DatiRicezione_CUP_Riga">
            <xsl:with-param name="CN" select="current()"/>
            <xsl:with-param name="CNP" select="position()"/>
         </xsl:apply-templates>
         <xsl:apply-templates select="/in:CreditNote/cac:CreditNoteLine/cac:DocumentReference[cbc:DocumentType='CIG_RICEZIONE']/cbc:ID"
                              mode="DatiRicezione_CIG_Riga">
            <xsl:with-param name="CN" select="current()"/>
            <xsl:with-param name="CNP" select="position()"/>
         </xsl:apply-templates>
      </DatiRicezione>
   </xsl:template>
   <xsl:template match="cac:DeliveryLocation/cac:Address">
      <xsl:param name="CN" select="."/>
      <xsl:param name="CNP" select="1"/>
      <xsl:if test=".">
         <IndirizzoResa>
            <Indirizzo>
               <xsl:value-of select="cbc:StreetName"/>
            </Indirizzo>
            <CAP>
               <xsl:value-of select="cbc:PostalZone"/>
            </CAP>
            <Comune>
               <xsl:value-of select="cbc:CityName"/>
            </Comune>
            <Provincia>
               <xsl:value-of select="if (string-length(cbc:CountrySubentity)=2 ) then cbc:CountrySubentity else document($xclProvinceItaliane)//Value[@ColumnRef='code']/SimpleValue[contains(lower-case(translate(../../Value[@ColumnRef='name']/SimpleValue,'áàéèíìóòúù','aaeeiioouu')), lower-case(translate(current()/cbc:CountrySubentity,'áàéèíìóòúù','aaeeiioouu')))][1]"/>
            </Provincia>
            <Nazione>
               <xsl:value-of select="if (cac:Country/cbc:IdentificationCode) then cac:Country/cbc:IdentificationCode else 'IT'"/>
            </Nazione>
         </IndirizzoResa>
      </xsl:if>
   </xsl:template>
   <xsl:template match="cac:Delivery[1]">
      <xsl:param name="CN" select="."/>
      <xsl:param name="CNP" select="1"/>
      <xsl:if test="cac:Despatch or cbc:Quantity">
         <DatiTrasporto>
            <xsl:apply-templates select="cac:Despatch/cac:DespatchParty">
               <xsl:with-param name="CN" select="current()"/>
               <xsl:with-param name="CNP" select="position()"/>
            </xsl:apply-templates>
            <NumeroColli>
               <xsl:value-of select="cbc:Quantity"/>
            </NumeroColli>
            <xsl:if test="cac:Shipment/cbc:GrossWeightMeasure/@unitCode">
               <UnitaMisuraPeso>
                  <xsl:value-of select="document($xclUnitOfMeasureCode)//Value[@ColumnRef='xname']/SimpleValue[../../Value[@ColumnRef='code']/SimpleValue=current()/cac:Shipment/cbc:GrossWeightMeasure/@unitCode][1]"/>
               </UnitaMisuraPeso>
            </xsl:if>
            <xsl:if test="cac:Shipment/cbc:GrossWeightMeasure">
               <PesoLordo>
                  <xsl:value-of select="format-number(cac:Shipment/cbc:GrossWeightMeasure,'###0.00')"/>
               </PesoLordo>
            </xsl:if>
            <xsl:if test="cac:Shipment/cbc:NetWeightMeasure">
               <PesoNetto>
                  <xsl:value-of select="format-number(cac:Shipment/cbc:NetWeightMeasure,'###0.00')"/>
               </PesoNetto>
            </xsl:if>
            <xsl:if test="cbc:ActualDeliveryDate">
               <DataInizioTrasporto>
                  <xsl:value-of select="&#x9;substring(string(cbc:ActualDeliveryDate),1,10)"/>
               </DataInizioTrasporto>
            </xsl:if>
            <xsl:if test="../cac:DeliveryTerms/cbc:ID">
               <TipoResa>
                  <xsl:value-of select="../cac:DeliveryTerms/cbc:ID"/>
               </TipoResa>
            </xsl:if>
            <xsl:apply-templates select="cac:DeliveryLocation/cac:Address">
               <xsl:with-param name="CN" select="current()"/>
               <xsl:with-param name="CNP" select="position()"/>
            </xsl:apply-templates>
         </DatiTrasporto>
      </xsl:if>
   </xsl:template>
   <xsl:template match="cac:Despatch/cac:DespatchParty">
      <xsl:param name="CN" select="."/>
      <xsl:param name="CNP" select="1"/>
      <xsl:if test=".">
         <DatiAnagraficiVettore>
            <xsl:apply-templates select="cac:PartyTaxScheme[cac:TaxScheme/cbc:ID='VAT']/cbc:CompanyID[not(@schemeID = 'IT:CF')][1]"
                                 mode="Vettore_PIVA">
               <xsl:with-param name="CN" select="current()"/>
               <xsl:with-param name="CNP" select="position()"/>
            </xsl:apply-templates>
            <xsl:if test="cac:Person[1]/cbc:ID[@schemeID='IT:CF']">
               <CodiceFiscale>
                  <xsl:value-of select="cac:Person[1]/cbc:ID[@schemeID='IT:CF']"/>
               </CodiceFiscale>
            </xsl:if>
            <xsl:apply-templates select="cac:PartyTaxScheme[cac:TaxScheme/cbc:ID='VAT']/cbc:CompanyID[@schemeID = 'IT:CF']"
                                 mode="Vettore_CF">
               <xsl:with-param name="CN" select="current()"/>
               <xsl:with-param name="CNP" select="position()"/>
            </xsl:apply-templates>
            <Anagrafica>
               <xsl:if test="cac:PartyName/cbc:Name and not(cac:Person[cbc:ID[@schemeID='IT:CF']]/cbc:FamilyName)">
                  <Denominazione>
                     <xsl:value-of select="normalize-space(cac:PartyName[1]/cbc:Name)"/>
                  </Denominazione>
               </xsl:if>
               <xsl:if test="cac:Person/cbc:FirstName and cac:Person/cbc:FamilyName and cac:Person/cbc:ID[@schemeID='IT:CF']">
                  <Nome>
                     <xsl:value-of select="cac:Person[1]/cbc:FirstName"/>
                  </Nome>
               </xsl:if>
               <xsl:if test="cac:Person/cbc:FirstName and cac:Person/cbc:FamilyName and cac:Person/cbc:ID[@schemeID='IT:CF']">
                  <Cognome>
                     <xsl:value-of select="cac:Person[1]/cbc:FamilyName"/>
                  </Cognome>
               </xsl:if>
               <xsl:if test="cac:Person/cbc:ID[@schemeID='IT:CF'] and cac:Person/cbc:Title and cac:Person/cbc:FamilyName and not(cac:PartyName/cbc:Name)">
                  <Titolo>
                     <xsl:value-of select="cac:Person[1]/cbc:Title"/>
                  </Titolo>
               </xsl:if>
            </Anagrafica>
            <xsl:if test="cac:Person/cac:IdentityDocumentReference[cbc:DocumentType='LicenzaGuida']/cbc:ID">
               <NumeroLicenzaGuida>
                  <xsl:value-of select="cac:Person/cac:IdentityDocumentReference/cbc:ID"/>
               </NumeroLicenzaGuida>
            </xsl:if>
         </DatiAnagraficiVettore>
      </xsl:if>
   </xsl:template>
   <xsl:template match="cac:DespatchDocumentReference">
      <xsl:param name="CN" select="."/>
      <xsl:param name="CNP" select="1"/>
      <xsl:if test=". and count(/in:CreditNote/cac:CreditNoteLine/cac:DespatchLineReference) = 0">
         <DatiDDT>
            <NumeroDDT>
               <xsl:value-of select="cbc:ID"/>
            </NumeroDDT>
            <DataDDT>
               <xsl:value-of select="if (cbc:IssueDate) then substring(string(cbc:IssueDate),1,10) else '9999-01-01'"/>
            </DataDDT>
         </DatiDDT>
      </xsl:if>
   </xsl:template>
   <xsl:template match="cac:DespatchLineReference">
      <xsl:param name="CN" select="."/>
      <xsl:param name="CNP" select="1"/>
      <xsl:if test="cbc:LineID">
         <AltriDatiGestionali>
            <TipoDato>
               <xsl:text>DatiDDT</xsl:text>
            </TipoDato>
            <RiferimentoTesto>
               <xsl:value-of select="concat(cac:DocumentReference/cbc:ID, ':', cbc:LineID)"/>
            </RiferimentoTesto>
            <RiferimentoData>
               <xsl:value-of select="cac:DocumentReference/cbc:IssueDate"/>
            </RiferimentoData>
         </AltriDatiGestionali>
      </xsl:if>
   </xsl:template>
   <xsl:template match="cac:Item/cac:ClassifiedTaxCategory" mode="AliquotaIVA_Dettaglio">
      <xsl:param name="CN" select="."/>
      <xsl:param name="CNP" select="1"/>
      <AliquotaIVA>
         <xsl:value-of select="if (.[cac:TaxScheme/cbc:ID='VAT']/cbc:Percent ) then format-number(.[cac:TaxScheme/cbc:ID='VAT']/cbc:Percent ,'##0.00') else '0.00'"/>
      </AliquotaIVA>
   </xsl:template>
   <xsl:template match="cac:Item/cac:ClassifiedTaxCategory/cbc:ID">
      <xsl:param name="CN" select="."/>
      <xsl:param name="CNP" select="1"/>
      <AltriDatiGestionali>
         <TipoDato>
            <xsl:text>Natura</xsl:text>
         </TipoDato>
         <RiferimentoTesto>
            <xsl:value-of select="."/>
         </RiferimentoTesto>
      </AltriDatiGestionali>
   </xsl:template>
   <xsl:template match="cac:Item/cac:CommodityClassification/cbc:CommodityCode">
      <xsl:param name="CN" select="."/>
      <xsl:param name="CNP" select="1"/>
      <xsl:if test=".">
         <CodiceArticolo>
            <CodiceTipo>
               <xsl:value-of select="if (@listID) then @listID else 'CommodityCode'"/>
            </CodiceTipo>
            <CodiceValore>
               <xsl:value-of select="."/>
            </CodiceValore>
         </CodiceArticolo>
      </xsl:if>
   </xsl:template>
   <xsl:template match="cac:Item/cac:CommodityClassification/cbc:ItemClassificationCode">
      <xsl:param name="CN" select="."/>
      <xsl:param name="CNP" select="1"/>
      <xsl:if test=".">
         <CodiceArticolo>
            <CodiceTipo>
               <xsl:value-of select="if (@listID) then @listID else 'ItemClassificationCode'"/>
            </CodiceTipo>
            <CodiceValore>
               <xsl:value-of select="."/>
            </CodiceValore>
         </CodiceArticolo>
      </xsl:if>
   </xsl:template>
   <xsl:template match="cac:Item/cac:SellersItemIdentification/cbc:ID">
      <xsl:param name="CN" select="."/>
      <xsl:param name="CNP" select="1"/>
      <xsl:if test=".">
         <CodiceArticolo>
            <CodiceTipo>
               <xsl:value-of select="if (@schemeID) then @schemeID else 'SellerItemIdentification'"/>
            </CodiceTipo>
            <CodiceValore>
               <xsl:value-of select="."/>
            </CodiceValore>
         </CodiceArticolo>
      </xsl:if>
   </xsl:template>
   <xsl:template match="cac:Item/cac:StandardItemIdentification/cbc:ID">
      <xsl:param name="CN" select="."/>
      <xsl:param name="CNP" select="1"/>
      <xsl:if test=".">
         <CodiceArticolo>
            <CodiceTipo>
               <xsl:value-of select="if (@schemeID) then @schemeID else 'StandardItemIdentification'"/>
            </CodiceTipo>
            <CodiceValore>
               <xsl:value-of select="."/>
            </CodiceValore>
         </CodiceArticolo>
      </xsl:if>
   </xsl:template>
   <xsl:template match="cac:OrderReference">
      <xsl:param name="CN" select="."/>
      <xsl:param name="CNP" select="1"/>
      <xsl:if test="(cbc:ID or cbc:IssueDate) and count(/in:CreditNote/cac:CreditNoteLine/cac:OrderLineReference) = 0">
         <DatiOrdineAcquisto>
            <IdDocumento>
               <xsl:value-of select="cbc:ID"/>
            </IdDocumento>
            <xsl:if test="cbc:IssueDate">
               <Data>
                  <xsl:value-of select="&#x9;substring(string(cbc:IssueDate),1,10)"/>
               </Data>
            </xsl:if>
            <xsl:apply-templates select="/in:CreditNote/cac:AdditionalDocumentReference[cbc:DocumentType='CommessaConvenzione']/cbc:ID"
                                 mode="DatiOrdine_Commessa">
               <xsl:with-param name="CN" select="current()"/>
               <xsl:with-param name="CNP" select="position()"/>
            </xsl:apply-templates>
            <xsl:apply-templates select="/in:CreditNote/cac:AdditionalDocumentReference[cbc:DocumentType='CUP']/cbc:ID"
                                 mode="DatiOrdine_CUP">
               <xsl:with-param name="CN" select="current()"/>
               <xsl:with-param name="CNP" select="position()"/>
            </xsl:apply-templates>
            <xsl:apply-templates select="/in:CreditNote/cac:AdditionalDocumentReference[cbc:DocumentType='CIG']/cbc:ID"
                                 mode="DatiOrdine_CIG">
               <xsl:with-param name="CN" select="current()"/>
               <xsl:with-param name="CNP" select="position()"/>
            </xsl:apply-templates>
         </DatiOrdineAcquisto>
      </xsl:if>
   </xsl:template>
   <xsl:template match="cac:OriginatorDocumentReference">
      <xsl:param name="CN" select="."/>
      <xsl:param name="CNP" select="1"/>
      <xsl:if test="count(/in:CreditNote/cac:CreditNoteLine/cac:DocumentReference[cbc:DocumentType='ESTREMI_CONVENZIONE']) = 0">
         <DatiConvenzione>
            <IdDocumento>
               <xsl:value-of select="cbc:ID"/>
            </IdDocumento>
            <xsl:if test="cbc:IssueDate">
               <Data>
                  <xsl:value-of select="&#x9;substring(string(cbc:IssueDate),1,10)"/>
               </Data>
            </xsl:if>
            <xsl:apply-templates select="/in:CreditNote/cac:AdditionalDocumentReference[cbc:DocumentType='CommessaConvenzione_CONVENZIONE']/cbc:ID"
                                 mode="DatiConvenzione_CommessaConvenzione">
               <xsl:with-param name="CN" select="current()"/>
               <xsl:with-param name="CNP" select="position()"/>
            </xsl:apply-templates>
            <xsl:apply-templates select="/in:CreditNote/cac:AdditionalDocumentReference[cbc:DocumentType='CUP_CONVENZIONE']/cbc:ID"
                                 mode="DatiConvenzione_CUP">
               <xsl:with-param name="CN" select="current()"/>
               <xsl:with-param name="CNP" select="position()"/>
            </xsl:apply-templates>
            <xsl:apply-templates select="/in:CreditNote/cac:AdditionalDocumentReference[cbc:DocumentType='CIG_CONVENZIONE']/cbc:ID"
                                 mode="DatiConvenzione_CIG">
               <xsl:with-param name="CN" select="current()"/>
               <xsl:with-param name="CNP" select="position()"/>
            </xsl:apply-templates>
         </DatiConvenzione>
      </xsl:if>
   </xsl:template>
   <xsl:template match="cac:Party" mode="CedentePrestatore_DatiAnagrafici">
      <xsl:param name="CN" select="."/>
      <xsl:param name="CNP" select="1"/>
      <DatiAnagrafici>
         <xsl:apply-templates select="cac:PartyTaxScheme[cac:TaxScheme/cbc:ID='VAT']/cbc:CompanyID[not(@schemeID = 'IT:CF')][1]"
                              mode="CedentePrestatore_PIVA">
            <xsl:with-param name="CN" select="current()"/>
            <xsl:with-param name="CNP" select="position()"/>
         </xsl:apply-templates>
         <xsl:if test="cac:Person[1]/cbc:ID[@schemeID='IT:CF']">
            <CodiceFiscale>
               <xsl:value-of select="cac:Person[1]/cbc:ID[@schemeID='IT:CF']"/>
            </CodiceFiscale>
         </xsl:if>
         <xsl:apply-templates select="cac:PartyTaxScheme[cac:TaxScheme/cbc:ID='VAT']/cbc:CompanyID[@schemeID = 'IT:CF']"
                              mode="CedentePrestatore_CF">
            <xsl:with-param name="CN" select="current()"/>
            <xsl:with-param name="CNP" select="position()"/>
         </xsl:apply-templates>
         <Anagrafica>
            <xsl:if test="cac:PartyName/cbc:Name and not(cac:Person[cbc:ID[@schemeID='IT:CF']]/cbc:FamilyName)">
               <Denominazione>
                  <xsl:value-of select="normalize-space(cac:PartyName[1]/cbc:Name)"/>
               </Denominazione>
            </xsl:if>
            <xsl:if test="cac:Person/cbc:FirstName and cac:Person/cbc:FamilyName and cac:Person/cbc:ID[@schemeID='IT:CF']">
               <Nome>
                  <xsl:value-of select="cac:Person[1]/cbc:FirstName"/>
               </Nome>
            </xsl:if>
            <xsl:if test="cac:Person/cbc:FirstName and cac:Person/cbc:FamilyName and cac:Person/cbc:ID[@schemeID='IT:CF']">
               <Cognome>
                  <xsl:value-of select="cac:Person[1]/cbc:FamilyName"/>
               </Cognome>
            </xsl:if>
            <xsl:if test="cac:Person/cbc:ID[@schemeID='IT:CF'] and cac:Person/cbc:Title and cac:Person/cbc:FamilyName and not(cac:PartyName/cbc:Name)">
               <Titolo>
                  <xsl:value-of select="cac:Person[1]/cbc:Title"/>
               </Titolo>
            </xsl:if>
            <xsl:apply-templates select="/in:CreditNote/cac:AdditionalDocumentReference[cbc:DocumentType='EORI CedentePrestatore']/cbc:ID">
               <xsl:with-param name="CN" select="current()"/>
               <xsl:with-param name="CNP" select="position()"/>
            </xsl:apply-templates>
         </Anagrafica>
         <xsl:apply-templates select="cac:PartyLegalEntity[cac:CorporateRegistrationScheme/cbc:Name!='REA' and cbc:CompanyID[@schemeID='ZZZ']]"
                              mode="AlboProfessionale">
            <xsl:with-param name="CN" select="current()"/>
            <xsl:with-param name="CNP" select="position()"/>
         </xsl:apply-templates>
         <xsl:apply-templates select="cac:PartyLegalEntity[cac:CorporateRegistrationScheme/cbc:Name!='REA' and cbc:CompanyID/@schemeID='ZZZ' and cac:RegistrationAddress/cbc:CityName]"
                              mode="ProvinciaAlbo">
            <xsl:with-param name="CN" select="current()"/>
            <xsl:with-param name="CNP" select="position()"/>
         </xsl:apply-templates>
         <xsl:apply-templates select="cac:PartyLegalEntity[cbc:CompanyID[@schemeID='ZZZ'] and cbc:CompanyID and cac:CorporateRegistrationScheme/cbc:Name!='REA']"
                              mode="NumeroIscrizioneAlbo">
            <xsl:with-param name="CN" select="current()"/>
            <xsl:with-param name="CNP" select="position()"/>
         </xsl:apply-templates>
         <xsl:apply-templates select="cac:PartyLegalEntity[cbc:CompanyID[@schemeID='ZZZ'] and cbc:RegistrationDate and cac:CorporateRegistrationScheme/cbc:Name!='REA']"
                              mode="DataIscrizioneAlbo">
            <xsl:with-param name="CN" select="current()"/>
            <xsl:with-param name="CNP" select="position()"/>
         </xsl:apply-templates>
         <xsl:if test="not(cac:PartyTaxScheme/cac:TaxScheme/cbc:TaxTypeCode)">
            <RegimeFiscale>
               <xsl:text>RF01</xsl:text>
            </RegimeFiscale>
         </xsl:if>
         <xsl:if test="cac:PartyTaxScheme/cac:TaxScheme/cbc:TaxTypeCode">
            <RegimeFiscale>
               <xsl:value-of select="cac:PartyTaxScheme/cac:TaxScheme/cbc:TaxTypeCode"/>
            </RegimeFiscale>
         </xsl:if>
      </DatiAnagrafici>
   </xsl:template>
   <xsl:template match="cac:Party" mode="CessionarioCommittente_DatiAnagrafici">
      <xsl:param name="CN" select="."/>
      <xsl:param name="CNP" select="1"/>
      <DatiAnagrafici>
         <xsl:apply-templates select="cac:PartyTaxScheme[cac:TaxScheme/cbc:ID='VAT']/cbc:CompanyID[not(@schemeID = 'IT:CF')][1]"
                              mode="CessionarioCommittente_PIVA">
            <xsl:with-param name="CN" select="current()"/>
            <xsl:with-param name="CNP" select="position()"/>
         </xsl:apply-templates>
         <xsl:if test="cac:Person[1]/cbc:ID[@schemeID='IT:CF']">
            <CodiceFiscale>
               <xsl:value-of select="cac:Person[1]/cbc:ID[@schemeID='IT:CF']"/>
            </CodiceFiscale>
         </xsl:if>
         <xsl:apply-templates select="cac:PartyTaxScheme[cac:TaxScheme/cbc:ID='VAT']/cbc:CompanyID[@schemeID = 'IT:CF']"
                              mode="CessionarioCommittente_CF">
            <xsl:with-param name="CN" select="current()"/>
            <xsl:with-param name="CNP" select="position()"/>
         </xsl:apply-templates>
         <Anagrafica>
            <xsl:if test="cac:PartyName/cbc:Name and not(cac:Person[cbc:ID[@schemeID='IT:CF']]/cbc:FamilyName)">
               <Denominazione>
                  <xsl:value-of select="normalize-space(cac:PartyName[1]/cbc:Name)"/>
               </Denominazione>
            </xsl:if>
            <xsl:if test="cac:Person/cbc:FirstName and cac:Person/cbc:FamilyName and cac:Person/cbc:ID[@schemeID='IT:CF']">
               <Nome>
                  <xsl:value-of select="cac:Person[1]/cbc:FirstName"/>
               </Nome>
            </xsl:if>
            <xsl:if test="cac:Person/cbc:FirstName and cac:Person/cbc:FamilyName and cac:Person/cbc:ID[@schemeID='IT:CF']">
               <Cognome>
                  <xsl:value-of select="cac:Person[1]/cbc:FamilyName"/>
               </Cognome>
            </xsl:if>
            <xsl:if test="cac:Person/cbc:Title and cac:Person/cbc:FamilyName and not(cac:PartyName/cbc:Name)">
               <Titolo>
                  <xsl:value-of select="cac:Person[1]/cbc:Title"/>
               </Titolo>
            </xsl:if>
         </Anagrafica>
      </DatiAnagrafici>
   </xsl:template>
   <xsl:template match="cac:Party/cac:AgentParty/cac:PostalAddress"
                 mode="CedentePrestatore_StabileOrganizzazione">
      <xsl:param name="CN" select="."/>
      <xsl:param name="CNP" select="1"/>
      <xsl:if test=". and ./cac:Country/cbc:IdentificationCode='IT'">
         <StabileOrganizzazione>
            <Indirizzo>
               <xsl:value-of select="cbc:StreetName"/>
            </Indirizzo>
            <CAP>
               <xsl:value-of select="cbc:PostalZone"/>
            </CAP>
            <Comune>
               <xsl:value-of select="cbc:CityName"/>
            </Comune>
            <xsl:if test="cbc:CountrySubentity">
               <Provincia>
                  <xsl:value-of select="if (string-length(cbc:CountrySubentity)=2) then cbc:CountrySubentity else document($xclProvinceItaliane)//Value[@ColumnRef='code']/SimpleValue[contains(lower-case(translate(../../Value[@ColumnRef='name']/SimpleValue,'áàéèíìóòúù','aaeeiioouu')), lower-case(translate(current()/cbc:CountrySubentity,'áàéèíìóòúù','aaeeiioouu')))][1]"/>
               </Provincia>
            </xsl:if>
            <Nazione>
               <xsl:text>IT</xsl:text>
            </Nazione>
         </StabileOrganizzazione>
      </xsl:if>
   </xsl:template>
   <xsl:template match="cac:Party/cac:Contact" mode="CedentePrestatore_Contatti">
      <xsl:param name="CN" select="."/>
      <xsl:param name="CNP" select="1"/>
      <xsl:if test=". and *">
         <Contatti>
            <xsl:if test="cbc:Telephone">
               <Telefono>
                  <xsl:value-of select="cbc:Telephone"/>
               </Telefono>
            </xsl:if>
            <xsl:if test="cbc:Telefax">
               <Fax>
                  <xsl:value-of select="cbc:Telefax"/>
               </Fax>
            </xsl:if>
            <xsl:if test="cbc:ElectronicMail">
               <Email>
                  <xsl:value-of select="cbc:ElectronicMail"/>
               </Email>
            </xsl:if>
         </Contatti>
      </xsl:if>
   </xsl:template>
   <xsl:template match="cac:Party/cac:PartyLegalEntity" mode="IscrizioneREA">
      <xsl:param name="CN" select="."/>
      <xsl:param name="CNP" select="1"/>
      <xsl:if test="cbc:CompanyID[@schemeID='ZZZ'] and cac:CorporateRegistrationScheme/cbc:Name='REA'">
         <IscrizioneREA>
            <xsl:if test="cac:RegistrationAddress/cbc:CityName">
               <Ufficio>
                  <xsl:value-of select="if (string-length(cac:RegistrationAddress/cbc:CityName)=2) then cac:RegistrationAddress/cbc:CityName else document($xclProvinceItaliane)//Value[@ColumnRef='code']/SimpleValue[contains(lower-case(translate(../../Value[@ColumnRef='name']/SimpleValue,'áàéèíìóòúù','aaeeiioouu')), lower-case(translate(current()/cac:RegistrationAddress/cbc:CityName,'áàéèíìóòúù','aaeeiioouu')))][1]"/>
               </Ufficio>
            </xsl:if>
            <NumeroREA>
               <xsl:value-of select="cbc:CompanyID"/>
            </NumeroREA>
            <xsl:if test="cbc:CorporateStockAmount">
               <CapitaleSociale>
                  <xsl:value-of select="format-number(cbc:CorporateStockAmount,'###########0.00')"/>
               </CapitaleSociale>
            </xsl:if>
            <xsl:if test="boolean(cbc:SoleProprietorshipIndicator)">
               <SocioUnico>
                  <xsl:text>SU</xsl:text>
               </SocioUnico>
            </xsl:if>
            <StatoLiquidazione>
               <xsl:value-of select="cbc:CompanyLiquidationStatusCode"/>
            </StatoLiquidazione>
         </IscrizioneREA>
      </xsl:if>
   </xsl:template>
   <xsl:template match="cac:Party/cac:PostalAddress" mode="CedentePrestatore_Sede">
      <xsl:param name="CN" select="."/>
      <xsl:param name="CNP" select="1"/>
      <Sede>
         <Indirizzo>
            <xsl:value-of select="cbc:StreetName"/>
         </Indirizzo>
         <CAP>
            <xsl:value-of select="cbc:PostalZone"/>
         </CAP>
         <Comune>
            <xsl:value-of select="cbc:CityName"/>
         </Comune>
         <xsl:if test="cac:Country/cbc:IdentificationCode='IT' and cbc:CountrySubentity">
            <Provincia>
               <xsl:value-of select="if (string-length(cbc:CountrySubentity)=2) then cbc:CountrySubentity else document($xclProvinceItaliane)//Value[@ColumnRef='code']/SimpleValue[contains(lower-case(translate(../../Value[@ColumnRef='name']/SimpleValue,'áàéèíìóòúù','aaeeiioouu')), lower-case(translate(current()/cbc:CountrySubentity,'áàéèíìóòúù','aaeeiioouu')))][1]"/>
            </Provincia>
         </xsl:if>
         <Nazione>
            <xsl:value-of select="if (cac:Country/cbc:IdentificationCode) then cac:Country/cbc:IdentificationCode else 'IT'"/>
         </Nazione>
      </Sede>
   </xsl:template>
   <xsl:template match="cac:Party/cac:PostalAddress" mode="CessionarioCommittente_Sede">
      <xsl:param name="CN" select="."/>
      <xsl:param name="CNP" select="1"/>
      <xsl:if test=".">
         <Sede>
            <Indirizzo>
               <xsl:value-of select="cbc:StreetName"/>
            </Indirizzo>
            <CAP>
               <xsl:value-of select="cbc:PostalZone"/>
            </CAP>
            <Comune>
               <xsl:value-of select="cbc:CityName"/>
            </Comune>
            <xsl:if test="cac:Country/cbc:IdentificationCode='IT'">
               <Provincia>
                  <xsl:value-of select="if (string-length(cbc:CountrySubentity)=2) then upper-case(cbc:CountrySubentity) else document($xclProvinceItaliane)//Value[@ColumnRef='code']/SimpleValue[contains(lower-case(translate(../../Value[@ColumnRef='name']/SimpleValue,'áàéèíìóòúù','aaeeiioouu')), lower-case(translate(if (string-length(current()/cbc:CountrySubentity) &gt; 0) then current()/cbc:CountrySubentity else current()/cbc:CityName,'áàéèíìóòúù','aaeeiioouu')))][1]"/>
               </Provincia>
            </xsl:if>
            <Nazione>
               <xsl:value-of select="if (cac:Country/cbc:IdentificationCode) then cac:Country/cbc:IdentificationCode else 'IT'"/>
            </Nazione>
         </Sede>
      </xsl:if>
   </xsl:template>
   <xsl:template match="cac:PartyLegalEntity[cac:CorporateRegistrationScheme/cbc:Name!='REA' and cbc:CompanyID/@schemeID='ZZZ' and cac:RegistrationAddress/cbc:CityName]"
                 mode="ProvinciaAlbo">
      <xsl:param name="CN" select="."/>
      <xsl:param name="CNP" select="1"/>
      <ProvinciaAlbo>
         <xsl:value-of select="if (string-length(cac:RegistrationAddress/cbc:CityName)=2) then cac:RegistrationAddress/cbc:CityName else document($xclProvinceItaliane)//Value[@ColumnRef='code']/SimpleValue[contains(lower-case(translate(../../Value[@ColumnRef='name']/SimpleValue,'áàéèíìóòúù','aaeeiioouu')), lower-case(translate(current()/cac:RegistrationAddress/cbc:CityName,'áàéèíìóòúù','aaeeiioouu')))][1]"/>
      </ProvinciaAlbo>
   </xsl:template>
   <xsl:template match="cac:PartyLegalEntity[cac:CorporateRegistrationScheme/cbc:Name!='REA' and cbc:CompanyID[@schemeID='ZZZ']]"
                 mode="AlboProfessionale">
      <xsl:param name="CN" select="."/>
      <xsl:param name="CNP" select="1"/>
      <AlboProfessionale>
         <xsl:value-of select="normalize-space(cac:CorporateRegistrationScheme/cbc:Name)"/>
      </AlboProfessionale>
   </xsl:template>
   <xsl:template match="cac:PartyLegalEntity[cbc:CompanyID[@schemeID='ZZZ'] and cbc:CompanyID and cac:CorporateRegistrationScheme/cbc:Name!='REA']"
                 mode="NumeroIscrizioneAlbo">
      <xsl:param name="CN" select="."/>
      <xsl:param name="CNP" select="1"/>
      <NumeroIscrizioneAlbo>
         <xsl:value-of select="cbc:CompanyID"/>
      </NumeroIscrizioneAlbo>
   </xsl:template>
   <xsl:template match="cac:PartyLegalEntity[cbc:CompanyID[@schemeID='ZZZ'] and cbc:RegistrationDate and cac:CorporateRegistrationScheme/cbc:Name!='REA']"
                 mode="DataIscrizioneAlbo">
      <xsl:param name="CN" select="."/>
      <xsl:param name="CNP" select="1"/>
      <DataIscrizioneAlbo>
         <xsl:value-of select="&#x9;substring(string(cbc:RegistrationDate),1,10)"/>
      </DataIscrizioneAlbo>
   </xsl:template>
   <xsl:template match="cac:PartyTaxScheme[cac:TaxScheme/cbc:ID='VAT']/cbc:CompanyID[@schemeID = 'IT:CF']"
                 mode="CedentePrestatore_CF">
      <xsl:param name="CN" select="."/>
      <xsl:param name="CNP" select="1"/>
      <xsl:if test="not(../../cac:Person[1]/cbc:ID[@schemeID='IT:CF'])">
         <CodiceFiscale>
            <xsl:value-of select="if (string-length(.) = 13) then substring(., 3)  else ."/>
         </CodiceFiscale>
      </xsl:if>
   </xsl:template>
   <xsl:template match="cac:PartyTaxScheme[cac:TaxScheme/cbc:ID='VAT']/cbc:CompanyID[@schemeID = 'IT:CF']"
                 mode="RappresentanteFiscale_CF">
      <xsl:param name="CN" select="."/>
      <xsl:param name="CNP" select="1"/>
      <xsl:if test="not(../../cac:Person[1]/cbc:ID[@schemeID='IT:CF'])">
         <CodiceFiscale>
            <xsl:value-of select="if (string-length(.) = 13) then substring(., 3) else ."/>
         </CodiceFiscale>
      </xsl:if>
   </xsl:template>
   <xsl:template match="cac:PartyTaxScheme[cac:TaxScheme/cbc:ID='VAT']/cbc:CompanyID[@schemeID = 'IT:CF']"
                 mode="CessionarioCommittente_CF">
      <xsl:param name="CN" select="."/>
      <xsl:param name="CNP" select="1"/>
      <xsl:if test="not(../../cac:Person[1]/cbc:ID[@schemeID='IT:CF'])">
         <CodiceFiscale>
            <xsl:value-of select="if (string-length(.) = 13) then substring(., 3) else ."/>
         </CodiceFiscale>
      </xsl:if>
   </xsl:template>
   <xsl:template match="cac:PartyTaxScheme[cac:TaxScheme/cbc:ID='VAT']/cbc:CompanyID[@schemeID = 'IT:CF']"
                 mode="Vettore_CF">
      <xsl:param name="CN" select="."/>
      <xsl:param name="CNP" select="1"/>
      <xsl:if test="not(../../cac:Person[1]/cbc:ID[@schemeID='IT:CF'])">
         <CodiceFiscale>
            <xsl:value-of select="if (string-length(.) = 13) then substring(., 3) else ."/>
         </CodiceFiscale>
      </xsl:if>
   </xsl:template>
   <xsl:template match="cac:PartyTaxScheme[cac:TaxScheme/cbc:ID='VAT']/cbc:CompanyID[not(@schemeID = 'IT:CF')][1]"
                 mode="CedentePrestatore_PIVA">
      <xsl:param name="CN" select="."/>
      <xsl:param name="CNP" select="1"/>
      <IdFiscaleIVA>
         <IdPaese>
            <xsl:value-of select="upper-case(if (matches(.,'^[a-zA-Z]{2}')) then substring(.,1,2) else (if (matches(./@schemeID,'^[a-zA-Z]{2}:')) then substring-before(./@schemeID,':') else 'IT'))"/>
         </IdPaese>
         <IdCodice>
            <xsl:value-of select="if (upper-case(substring(.,1,2))=upper-case(substring-before(./@schemeID,':'))) then substring(.,3) else ."/>
         </IdCodice>
      </IdFiscaleIVA>
   </xsl:template>
   <xsl:template match="cac:PartyTaxScheme[cac:TaxScheme/cbc:ID='VAT']/cbc:CompanyID[not(@schemeID = 'IT:CF')][1]"
                 mode="RappresentanteFiscale_PIVA">
      <xsl:param name="CN" select="."/>
      <xsl:param name="CNP" select="1"/>
      <IdFiscaleIVA>
         <IdPaese>
            <xsl:text>IT</xsl:text>
         </IdPaese>
         <IdCodice>
            <xsl:value-of select="if (upper-case(substring(.,1,2))=upper-case(substring-before(./@schemeID,':'))) then substring(.,3) else ."/>
         </IdCodice>
      </IdFiscaleIVA>
   </xsl:template>
   <xsl:template match="cac:PartyTaxScheme[cac:TaxScheme/cbc:ID='VAT']/cbc:CompanyID[not(@schemeID = 'IT:CF')][1]"
                 mode="CessionarioCommittente_PIVA">
      <xsl:param name="CN" select="."/>
      <xsl:param name="CNP" select="1"/>
      <IdFiscaleIVA>
         <IdPaese>
            <xsl:value-of select="upper-case(if (matches(./@schemeID,'^[a-zA-Z]{2}:')) then substring-before(./@schemeID,':') else (if (matches(.,'^[a-zA-Z]{2}')) then substring(.,1,2) else 'IT'))"/>
         </IdPaese>
         <IdCodice>
            <xsl:value-of select="if (upper-case(substring(.,1,2))=upper-case(substring-before(./@schemeID,':'))) then substring(.,3) else ."/>
         </IdCodice>
      </IdFiscaleIVA>
   </xsl:template>
   <xsl:template match="cac:PartyTaxScheme[cac:TaxScheme/cbc:ID='VAT']/cbc:CompanyID[not(@schemeID = 'IT:CF')][1]"
                 mode="Vettore_PIVA">
      <xsl:param name="CN" select="."/>
      <xsl:param name="CNP" select="1"/>
      <IdFiscaleIVA>
         <IdPaese>
            <xsl:value-of select="upper-case(if (matches(./@schemeID,'^[a-zA-Z]{2}:')) then substring-before(./@schemeID,':') else (if (matches(.,'^[a-zA-Z]{2}')) then substring(.,1,2) else 'IT'))"/>
         </IdPaese>
         <IdCodice>
            <xsl:value-of select="if (upper-case(substring(.,1,2))=upper-case(substring-before(./@schemeID,':'))) then substring(.,3) else ."/>
         </IdCodice>
      </IdFiscaleIVA>
   </xsl:template>
   <xsl:template match="cac:PayeeFinancialAccount/cac:FinancialInstitutionBranch/cac:FinancialInstitution">
      <xsl:param name="CN" select="."/>
      <xsl:param name="CNP" select="1"/>
      <xsl:if test="cbc:Name">
         <IstitutoFinanziario>
            <xsl:value-of select="cbc:Name"/>
         </IstitutoFinanziario>
      </xsl:if>
   </xsl:template>
   <xsl:template match="cac:PaymentMeans">
      <xsl:param name="CN" select="."/>
      <xsl:param name="CNP" select="1"/>
      <DettaglioPagamento>
         <xsl:if test="/in:CreditNote/cac:PayeeParty/cac:PartyName">
            <Beneficiario>
               <xsl:value-of select="/in:CreditNote/cac:PayeeParty/cac:PartyName[1]/cbc:Name"/>
            </Beneficiario>
         </xsl:if>
         <ModalitaPagamento>
            <xsl:value-of select="if (cbc:PaymentMeansCode = '9' and&#xA;/in:CreditNote/ext:UBLExtensions/ext:UBLExtension[ext:ExtensionURI = 'urn:www.ubl-italia.org:spec:fatturapa:modalita_pagamento']/ext:ExtensionContent/cbc:TypeCode) then /in:CreditNote/ext:UBLExtensions/ext:UBLExtension[ext:ExtensionURI = 'urn:www.ubl-italia.org:spec:fatturapa:modalita_pagamento']/ext:ExtensionContent/cbc:TypeCode else (if (document($xclPaymentMeansCode)//Value[@ColumnRef='xcode']/SimpleValue[../../Value[@ColumnRef='code']/SimpleValue=current()/cbc:PaymentMeansCode]) then document($xclPaymentMeansCode)//Value[@ColumnRef='xcode']/SimpleValue[../../Value[@ColumnRef='code']/SimpleValue=current()/cbc:PaymentMeansCode][1] else 'MP05')"/>
         </ModalitaPagamento>
         <xsl:if test="/in:CreditNote/cac:PaymentTerms[1]/cac:SettlementPeriod/cbc:StartDate">
            <DataRiferimentoTerminiPagamento>
               <xsl:value-of select="substring(string(/in:CreditNote/cac:PaymentTerms[1]/cac:SettlementPeriod/cbc:StartDate),1,10)"/>
            </DataRiferimentoTerminiPagamento>
         </xsl:if>
         <xsl:if test="/in:CreditNote/cac:PaymentTerms[1]/cac:SettlementPeriod/cbc:DurationMeasure">
            <GiorniTerminiPagamento>
               <xsl:value-of select="/in:CreditNote/cac:PaymentTerms[1]/cac:SettlementPeriod/cbc:DurationMeasure"/>
            </GiorniTerminiPagamento>
         </xsl:if>
         <xsl:if test="cbc:PaymentDueDate">
            <DataScadenzaPagamento>
               <xsl:value-of select="substring(string(cbc:PaymentDueDate),1,10)"/>
            </DataScadenzaPagamento>
         </xsl:if>
         <ImportoPagamento>
            <xsl:value-of select="format-number(if (/in:CreditNote/cac:PaymentTerms[1]/cbc:Amount) then /in:CreditNote/cac:PaymentTerms[1]/cbc:Amount else (if (/in:CreditNote/cac:WithholdingTaxTotal/cbc:TaxAmount) then (/in:CreditNote/cac:LegalMonetaryTotal/cbc:PayableAmount - /in:CreditNote/cac:WithholdingTaxTotal/cbc:TaxAmount) else /in:CreditNote/cac:LegalMonetaryTotal/cbc:PayableAmount),'###########0.00')"/>
         </ImportoPagamento>
         <xsl:apply-templates select="cac:PayeeFinancialAccount/cac:FinancialInstitutionBranch/cac:FinancialInstitution">
            <xsl:with-param name="CN" select="current()"/>
            <xsl:with-param name="CNP" select="position()"/>
         </xsl:apply-templates>
         <xsl:if test="(not(cbc:PaymentChannelCode) or cbc:PaymentChannelCode='IBAN') and cac:PayeeFinancialAccount/cbc:ID[@schemeID='IBAN']">
            <IBAN>
               <xsl:value-of select="cac:PayeeFinancialAccount/cbc:ID"/>
            </IBAN>
         </xsl:if>
         <xsl:if test="cac:PayeeFinancialAccount/cac:FinancialInstitutionBranch/cac:FinancialInstitution/cbc:ID[@schemeID='ABI']">
            <ABI>
               <xsl:value-of select="cac:PayeeFinancialAccount/cac:FinancialInstitutionBranch/cac:FinancialInstitution/cbc:ID"/>
            </ABI>
         </xsl:if>
         <xsl:if test="cac:PayeeFinancialAccount/cac:FinancialInstitutionBranch/cbc:ID[@schemeID='CAB']">
            <CAB>
               <xsl:value-of select="&#x9;cac:PayeeFinancialAccount/cac:FinancialInstitutionBranch/cbc:ID"/>
            </CAB>
         </xsl:if>
         <xsl:if test="(not(cbc:PaymentChannelCode) or cbc:PaymentChannelCode='IBAN') and cac:PayeeFinancialAccount/cac:FinancialInstitutionBranch/cac:FinancialInstitution/cbc:ID[.!='XXXXITX0' and (not(@schemeID) or @schemeID='BIC')]">
            <BIC>
               <xsl:value-of select="cac:PayeeFinancialAccount/cac:FinancialInstitutionBranch/cac:FinancialInstitution/cbc:ID"/>
            </BIC>
         </xsl:if>
         <xsl:if test="/in:CreditNote/cac:PaymentTerms[1]/cbc:SettlementDiscountAmount">
            <ScontoPagamentoAnticipato>
               <xsl:value-of select="format-number(/in:CreditNote/cac:PaymentTerms[1]/cbc:SettlementDiscountAmount,'###########0.00')"/>
            </ScontoPagamentoAnticipato>
         </xsl:if>
         <xsl:if test="/in:CreditNote/cac:PaymentTerms[1]/cac:SettlementPeriod/cbc:EndDate">
            <DataLimitePagamentoAnticipato>
               <xsl:value-of select="substring(string(/in:CreditNote/cac:PaymentTerms[1]/cac:SettlementPeriod/cbc:EndDate),1,10)"/>
            </DataLimitePagamentoAnticipato>
         </xsl:if>
         <xsl:if test="/in:CreditNote/cac:PaymentTerms[1]/cbc:PenaltyAmount">
            <PenalitaPagamentiRitardati>
               <xsl:value-of select="format-number(/in:CreditNote/cac:PaymentTerms[1]/cbc:PenaltyAmount,'###########0.00')"/>
            </PenalitaPagamentiRitardati>
         </xsl:if>
         <xsl:if test="/in:CreditNote/cac:PaymentTerms[1]/cac:PenaltyPeriod/cbc:StartDate">
            <DataDecorrenzaPenale>
               <xsl:value-of select="substring(string(/in:CreditNote/cac:PaymentTerms[1]/cac:PenaltyPeriod/cbc:StartDate),1,10)"/>
            </DataDecorrenzaPenale>
         </xsl:if>
         <xsl:if test="cbc:PaymentID">
            <CodicePagamento>
               <xsl:value-of select="cbc:PaymentID"/>
            </CodicePagamento>
         </xsl:if>
      </DettaglioPagamento>
   </xsl:template>
   <xsl:template match="cac:ReceiptDocumentReference">
      <xsl:param name="CN" select="."/>
      <xsl:param name="CNP" select="1"/>
      <xsl:if test="count(/in:CreditNote/cac:CreditNoteLine/cac:ReceiptLineReference) = 0">
         <DatiRicezione>
            <IdDocumento>
               <xsl:value-of select="cbc:ID"/>
            </IdDocumento>
            <xsl:if test="cbc:IssueDate">
               <Data>
                  <xsl:value-of select="&#x9;substring(string(cbc:IssueDate),1,10)"/>
               </Data>
            </xsl:if>
            <xsl:apply-templates select="/in:CreditNote/cac:AdditionalDocumentReference[cbc:DocumentType='CommessaConvenzione_RICEZIONE']/cbc:ID"
                                 mode="DatiRicezione_CommessaConvenzione">
               <xsl:with-param name="CN" select="current()"/>
               <xsl:with-param name="CNP" select="position()"/>
            </xsl:apply-templates>
            <xsl:apply-templates select="/in:CreditNote/cac:AdditionalDocumentReference[cbc:DocumentType='CUP_RICEZIONE']/cbc:ID"
                                 mode="DatiRicezione_CUP">
               <xsl:with-param name="CN" select="current()"/>
               <xsl:with-param name="CNP" select="position()"/>
            </xsl:apply-templates>
            <xsl:apply-templates select="/in:CreditNote/cac:AdditionalDocumentReference[cbc:DocumentType='CIG_RICEZIONE']/cbc:ID"
                                 mode="DatiRicezione_CIG">
               <xsl:with-param name="CN" select="current()"/>
               <xsl:with-param name="CNP" select="position()"/>
            </xsl:apply-templates>
         </DatiRicezione>
      </xsl:if>
   </xsl:template>
   <xsl:template match="cac:TaxRepresentativeParty">
      <xsl:param name="CN" select="."/>
      <xsl:param name="CNP" select="1"/>
      <xsl:if test=".">
         <RappresentanteFiscale>
            <DatiAnagrafici>
               <xsl:apply-templates select="cac:PartyTaxScheme[cac:TaxScheme/cbc:ID='VAT']/cbc:CompanyID[not(@schemeID = 'IT:CF')][1]"
                                    mode="RappresentanteFiscale_PIVA">
                  <xsl:with-param name="CN" select="current()"/>
                  <xsl:with-param name="CNP" select="position()"/>
               </xsl:apply-templates>
               <xsl:if test="cac:Person[1]/cbc:ID[@schemeID='IT:CF']">
                  <CodiceFiscale>
                     <xsl:value-of select="cac:Person[1]/cbc:ID[@schemeID='IT:CF']"/>
                  </CodiceFiscale>
               </xsl:if>
               <xsl:apply-templates select="cac:PartyTaxScheme[cac:TaxScheme/cbc:ID='VAT']/cbc:CompanyID[@schemeID = 'IT:CF']"
                                    mode="RappresentanteFiscale_CF">
                  <xsl:with-param name="CN" select="current()"/>
                  <xsl:with-param name="CNP" select="position()"/>
               </xsl:apply-templates>
               <Anagrafica>
                  <xsl:if test="cac:PartyName/cbc:Name and not(cac:Person[cbc:ID[@schemeID='IT:CF']]/cbc:FamilyName)">
                     <Denominazione>
                        <xsl:value-of select="normalize-space(cac:PartyName[1]/cbc:Name)"/>
                     </Denominazione>
                  </xsl:if>
                  <xsl:if test="cac:Person/cbc:FirstName and cac:Person/cbc:FamilyName and cac:Person/cbc:ID[@schemeID='IT:CF']">
                     <Nome>
                        <xsl:value-of select="cac:Person[1]/cbc:FirstName"/>
                     </Nome>
                  </xsl:if>
                  <xsl:if test="cac:Person/cbc:FirstName and cac:Person/cbc:FamilyName and cac:Person/cbc:ID[@schemeID='IT:CF']">
                     <Cognome>
                        <xsl:value-of select="cac:Person[1]/cbc:FamilyName"/>
                     </Cognome>
                  </xsl:if>
                  <xsl:if test="cac:Person/cbc:Title and cac:Person/cbc:FamilyName and not(cac:PartyName/cbc:Name)">
                     <Titolo>
                        <xsl:value-of select="cac:Person[1]/cbc:Title"/>
                     </Titolo>
                  </xsl:if>
               </Anagrafica>
            </DatiAnagrafici>
         </RappresentanteFiscale>
      </xsl:if>
   </xsl:template>
   <xsl:template match="cac:TaxTotal/cac:TaxSubtotal" mode="DatiRiepilogo">
      <xsl:param name="CN" select="."/>
      <xsl:param name="CNP" select="1"/>
      <xsl:if test="cac:TaxCategory/cac:TaxScheme/cbc:ID='VAT'">
         <DatiRiepilogo>
            <AliquotaIVA>
               <xsl:value-of select="if (cac:TaxCategory/cbc:Percent &gt;= 0) then format-number(cac:TaxCategory/cbc:Percent,'##0.00') else '0.00'"/>
            </AliquotaIVA>
            <xsl:if test="cac:TaxCategory[cbc:ID and cbc:ID[not(contains(' S AA H ',concat(' ',normalize-space(.),' ')))] and cac:TaxScheme/cbc:ID='VAT']">
               <Natura>
                  <xsl:value-of select="if (/in:CreditNote/ext:UBLExtensions/ext:UBLExtension[ext:ExtensionURI = concat('urn:www.ubl-italia.org:spec:fatturapa:xref:natura_riepilogo::', 1 + count(current()/preceding-sibling::cac:TaxSubtotal))]) then /in:CreditNote/ext:UBLExtensions/ext:UBLExtension[ext:ExtensionURI = concat('urn:www.ubl-italia.org:spec:fatturapa:xref:natura_riepilogo::', 1 + count(current()/preceding-sibling::cac:TaxSubtotal))]/ext:ExtensionContent/cr:XCode else (if (/in:CreditNote/ext:UBLExtensions/ext:UBLExtension[ext:ExtensionURI=concat('urn:www.ubl-italia.org:spec:fatturapa:xref:natura::', current()/cac:TaxCategory/cbc:ID)]) then /in:CreditNote/ext:UBLExtensions/ext:UBLExtension[ext:ExtensionURI=concat('urn:www.ubl-italia.org:spec:fatturapa:xref:natura::', current()/cac:TaxCategory/cbc:ID)]/ext:ExtensionContent/cr:XCode else (document($xclCategoriaImposte)//Value[@ColumnRef='code']/SimpleValue[../../Value[@ColumnRef='xcode']/SimpleValue=current()/cac:TaxCategory/cbc:ID])[1])"/>
               </Natura>
            </xsl:if>
            <xsl:apply-templates select="//ext:UBLExtensions/ext:UBLExtension[ext:ExtensionURI=concat('urn:www.ubl-italia.org:spec:fatturapa:spese_accessorie_riepilogo::', 1 + count(current()/preceding-sibling::cac:TaxSubtotal))]/ext:ExtensionContent/cbc:Amount">
               <xsl:with-param name="CN" select="current()"/>
               <xsl:with-param name="CNP" select="position()"/>
            </xsl:apply-templates>
            <xsl:apply-templates select="//ext:UBLExtensions/ext:UBLExtension[ext:ExtensionURI=concat('urn:www.ubl-italia.org:spec:fatturapa:arrotondamento_riepilogo::',  1 + count(current()/preceding-sibling::cac:TaxSubtotal))]/ext:ExtensionContent/cbc:Amount">
               <xsl:with-param name="CN" select="current()"/>
               <xsl:with-param name="CNP" select="position()"/>
            </xsl:apply-templates>
            <ImponibileImporto>
               <xsl:value-of select="if (&#x9;cbc:TaxableAmount &gt;= 0) then format-number(floor(cbc:TaxableAmount * 100 + 0.5) div 100,'###########0.00') else '0.00'"/>
            </ImponibileImporto>
            <Imposta>
               <xsl:value-of select="if (cbc:TaxAmount &gt;= 0) then format-number(floor(cbc:TaxAmount * 100 + 0.5) div 100,'###########0.00') else '0.00'"/>
            </Imposta>
            <xsl:if test="cbc:TaxAmount &gt; 0">
               <EsigibilitaIVA>
                  <xsl:value-of select="if (/in:CreditNote/ext:UBLExtensions/ext:UBLExtension[ext:ExtensionURI='urn:www.ubl-italia.org:spec:fatturapa:esigibilita_iva']/ext:ExtensionContent/cbc:TaxTypeCode) then /in:CreditNote/ext:UBLExtensions/ext:UBLExtension[ext:ExtensionURI='urn:www.ubl-italia.org:spec:fatturapa:esigibilita_iva']/ext:ExtensionContent/cbc:TaxTypeCode else 'I'"/>
               </EsigibilitaIVA>
            </xsl:if>
            <xsl:if test="cac:TaxCategory/cbc:TaxExemptionReason">
               <RiferimentoNormativo>
                  <xsl:value-of select="cac:TaxCategory/cbc:TaxExemptionReason"/>
               </RiferimentoNormativo>
            </xsl:if>
         </DatiRiepilogo>
      </xsl:if>
   </xsl:template>
   <xsl:template match="cbc:ID" mode="TipoCessionePrestazione">
      <xsl:param name="CN" select="."/>
      <xsl:param name="CNP" select="1"/>
      <xsl:if test="@schemeID">
         <TipoCessionePrestazione>
            <xsl:value-of select="@schemeID"/>
         </TipoCessionePrestazione>
      </xsl:if>
   </xsl:template>
   <xsl:template match="cbc:Note">
      <xsl:param name="CN" select="."/>
      <xsl:param name="CNP" select="1"/>
      <Causale>
         <xsl:value-of select="normalize-space(.)"/>
      </Causale>
   </xsl:template>
   <xsl:template match="ext:UBLExtensions/ext:UBLExtension[ext:ExtensionURI='urn:www.ubl-italia.org:spec:fatturapa:bollo']/ext:ExtensionContent/cbc:TaxAmount"
                 mode="BOLLO">
      <xsl:param name="CN" select="."/>
      <xsl:param name="CNP" select="1"/>
      <xsl:if test=".">
         <DatiBollo>
            <BolloVirtuale>
               <xsl:text>SI</xsl:text>
            </BolloVirtuale>
            <ImportoBollo>
               <xsl:value-of select="format-number(.,'###########0.00')"/>
            </ImportoBollo>
         </DatiBollo>
      </xsl:if>
   </xsl:template>
   <xsl:template match="ext:UBLExtensions/ext:UBLExtension[ext:ExtensionURI='urn:www.ubl-italia.org:spec:fatturapa:contributo_cassa' or ext:ExtensionURI='urn:www.ubl-italia.org:spec:fatturapa:contributo_cassa::1']/ext:ExtensionContent/cac:TaxTotal[1]"
                 mode="CassaPrevidenziale">
      <xsl:param name="CN" select="."/>
      <xsl:param name="CNP" select="1"/>
      <xsl:if test="cac:TaxSubtotal/cac:TaxCategory/cac:TaxScheme[cbc:ID='SSS']">
         <DatiCassaPrevidenziale>
            <TipoCassa>
               <xsl:value-of select="cac:TaxSubtotal/cac:TaxCategory/cac:TaxScheme/cbc:TaxTypeCode"/>
            </TipoCassa>
            <AlCassa>
               <xsl:value-of select="format-number(cac:TaxSubtotal/cac:TaxCategory/cbc:Percent,'##0.00')"/>
            </AlCassa>
            <ImportoContributoCassa>
               <xsl:value-of select="format-number(floor(cbc:TaxAmount * 100 + 0.5) div 100,'###########0.00')"/>
            </ImportoContributoCassa>
            <xsl:if test="cac:TaxSubtotal/cbc:TaxableAmount">
               <ImponibileCassa>
                  <xsl:value-of select="format-number(floor(cac:TaxSubtotal/cbc:TaxableAmount * 100 + 0.5) div 100,'###########0.00')"/>
               </ImponibileCassa>
            </xsl:if>
            <AliquotaIVA>
               <xsl:value-of select="if (/in:CreditNote/ext:UBLExtensions/ext:UBLExtension[ext:ExtensionURI='urn:www.ubl-italia.org:spec:fatturapa:contributo_cassa:aliquota_iva' or ext:ExtensionURI='urn:www.ubl-italia.org:spec:fatturapa:contributo_cassa:aliquota_iva::1']/ext:ExtensionContent/cbc:Percent) then format-number(/in:CreditNote/ext:UBLExtensions/ext:UBLExtension[ext:ExtensionURI='urn:www.ubl-italia.org:spec:fatturapa:contributo_cassa:aliquota_iva' or ext:ExtensionURI='urn:www.ubl-italia.org:spec:fatturapa:contributo_cassa:aliquota_iva::1']/ext:ExtensionContent/cbc:Percent[1],'##0.00') else format-number(/in:CreditNote/cac:TaxTotal/cac:TaxSubTotal/cac:TaxCategory[cbc:ID='S' and cac:TaxScheme/cbc:ID='VAT']/cbc:Percent,'##0.00')"/>
            </AliquotaIVA>
            <xsl:apply-templates select="/in:CreditNote/ext:UBLExtensions/ext:UBLExtension[ext:ExtensionURI='urn:www.ubl-italia.org:spec:fatturapa:contributo_cassa:ritenuta' or ext:ExtensionURI='urn:www.ubl-italia.org:spec:fatturapa:contributo_cassa:ritenuta::1']/ext:ExtensionContent/cbc:TaxEvidenceIndicator[.=true()][1]">
               <xsl:with-param name="CN" select="current()"/>
               <xsl:with-param name="CNP" select="position()"/>
            </xsl:apply-templates>
            <xsl:if test="/in:CreditNote/ext:UBLExtensions/ext:UBLExtension[ext:ExtensionURI='urn:www.ubl-italia.org:spec:fatturapa:xref:contributo_cassa:natura_iva' or ext:ExtensionURI='urn:www.ubl-italia.org:spec:fatturapa:xref:contributo_cassa:natura_iva::1']/ext:ExtensionContent/cr:XCode[1]">
               <Natura>
                  <xsl:value-of select="/in:CreditNote/ext:UBLExtensions/ext:UBLExtension[ext:ExtensionURI='urn:www.ubl-italia.org:spec:fatturapa:xref:contributo_cassa:natura_iva' or ext:ExtensionURI='urn:www.ubl-italia.org:spec:fatturapa:xref:contributo_cassa:natura_iva::1']/ext:ExtensionContent/cr:XCode[1]"/>
               </Natura>
            </xsl:if>
         </DatiCassaPrevidenziale>
      </xsl:if>
   </xsl:template>
   <xsl:template match="ext:UBLExtensions/ext:UBLExtension[ext:ExtensionURI='urn:www.ubl-italia.org:spec:fatturapa:ritenuta']/ext:ExtensionContent/cac:WithholdingTaxTotal"
                 mode="RITENUTA">
      <xsl:param name="CN" select="."/>
      <xsl:param name="CNP" select="1"/>
      <DatiRitenuta>
         <xsl:apply-templates select="/in:CreditNote/cac:AccountingSupplierParty/cac:Party"
                              mode="RitenutaPersoneFisiche">
            <xsl:with-param name="CN" select="current()"/>
            <xsl:with-param name="CNP" select="position()"/>
         </xsl:apply-templates>
         <xsl:apply-templates select="/in:CreditNote/cac:AccountingSupplierParty/cac:Party"
                              mode="RitenutaPersoneGiuridiche">
            <xsl:with-param name="CN" select="current()"/>
            <xsl:with-param name="CNP" select="position()"/>
         </xsl:apply-templates>
         <ImportoRitenuta>
            <xsl:value-of select="format-number(floor(cbc:TaxAmount * 100 + 0.5) div 100,'###########0.00')"/>
         </ImportoRitenuta>
         <AliquotaRitenuta>
            <xsl:value-of select="format-number(cac:TaxSubtotal/cac:TaxCategory/cbc:Percent,'##0.00')"/>
         </AliquotaRitenuta>
         <CausalePagamento>
            <xsl:value-of select="cac:TaxSubtotal/cac:TaxCategory/cac:TaxScheme/cbc:TaxTypeCode"/>
         </CausalePagamento>
      </DatiRitenuta>
   </xsl:template>
   <xsl:template match="/in:CreditNote" name="root">
      <xsl:param name="CN" select="."/>
      <xsl:param name="CNP" select="1"/>
      <nx:FatturaElettronica versione="FPR12">
         <xsl:variable name="variable_d10e1a2759">
            <xsl:value-of select="if (starts-with(upper-case(cac:AccountingCustomerParty/cac:Party/cac:PartyIdentification/cbc:ID[1][@schemeID='IT:IPA']), 'CODDEST:')) then 'FPR12' else 'FPA12'"/>
         </xsl:variable>
         <xsl:if test="string($variable_d10e1a2759)">
            <xsl:attribute name="versione">
               <xsl:value-of select="string($variable_d10e1a2759)"/>
            </xsl:attribute>
         </xsl:if>
         <FatturaElettronicaHeader>
            <DatiTrasmissione>
               <xsl:apply-templates select="cac:AccountingSupplierParty/cac:Party">
                  <xsl:with-param name="CN" select="current()"/>
                  <xsl:with-param name="CNP" select="position()"/>
               </xsl:apply-templates>
               <ProgressivoInvio>
                  <xsl:value-of select="$progInvio"/>
               </ProgressivoInvio>
               <xsl:if test="cac:AccountingCustomerParty/cac:Party/cac:PartyIdentification/cbc:ID[@schemeID='IT:IPA']">
                  <FormatoTrasmissione>
                     <xsl:value-of select="if (starts-with(upper-case(cac:AccountingCustomerParty/cac:Party/cac:PartyIdentification/cbc:ID[@schemeID='IT:IPA']), 'CODDEST:')) then 'FPR12' else 'FPA12'"/>
                  </FormatoTrasmissione>
               </xsl:if>
               <xsl:if test="not(cac:AccountingCustomerParty/cac:Party/cac:PartyIdentification/cbc:ID[@schemeID='IT:IPA'])">
                  <FormatoTrasmissione>
                     <xsl:text>FPR12</xsl:text>
                  </FormatoTrasmissione>
               </xsl:if>
               <xsl:apply-templates select="cac:AccountingCustomerParty/cac:Party/cac:PartyIdentification/cbc:ID[1][@schemeID='IT:IPA']"
                                    mode="CodiceDestinatario">
                  <xsl:with-param name="CN" select="current()"/>
                  <xsl:with-param name="CNP" select="position()"/>
               </xsl:apply-templates>
               <xsl:apply-templates select="cac:AccountingCustomerParty/cac:Party/cac:Contact/cbc:ElectronicMail">
                  <xsl:with-param name="CN" select="current()"/>
                  <xsl:with-param name="CNP" select="position()"/>
               </xsl:apply-templates>
            </DatiTrasmissione>
            <xsl:apply-templates select="cac:AccountingSupplierParty">
               <xsl:with-param name="CN" select="current()"/>
               <xsl:with-param name="CNP" select="position()"/>
            </xsl:apply-templates>
            <xsl:apply-templates select="cac:TaxRepresentativeParty">
               <xsl:with-param name="CN" select="current()"/>
               <xsl:with-param name="CNP" select="position()"/>
            </xsl:apply-templates>
            <xsl:apply-templates select="cac:AccountingCustomerParty">
               <xsl:with-param name="CN" select="current()"/>
               <xsl:with-param name="CNP" select="position()"/>
            </xsl:apply-templates>
            <TerzoIntermediarioOSoggettoEmittente>
               <DatiAnagrafici>
                  <IdFiscaleIVA>
                     <IdPaese>
                        <xsl:text>IT</xsl:text>
                     </IdPaese>
                     <IdCodice>
                        <xsl:text>02792731206</xsl:text>
                     </IdCodice>
                  </IdFiscaleIVA>
                  <CodiceFiscale>
                     <xsl:text>91252510374</xsl:text>
                  </CodiceFiscale>
                  <Anagrafica>
                     <Denominazione>
                        <xsl:text>Intercent-ER, Agenzia regionale per lo sviluppo dei mercati telematici</xsl:text>
                     </Denominazione>
                  </Anagrafica>
               </DatiAnagrafici>
            </TerzoIntermediarioOSoggettoEmittente>
            <SoggettoEmittente>
               <xsl:text>TZ</xsl:text>
            </SoggettoEmittente>
         </FatturaElettronicaHeader>
         <FatturaElettronicaBody>
            <DatiGenerali>
               <DatiGeneraliDocumento>
                  <TipoDocumento>
                     <xsl:text>TD04</xsl:text>
                  </TipoDocumento>
                  <Divisa>
                     <xsl:value-of select="if (cbc:DocumentCurrencyCode) then cbc:DocumentCurrencyCode else 'EUR'"/>
                  </Divisa>
                  <Data>
                     <xsl:value-of select="&#x9;substring(string(cbc:IssueDate),1,10)"/>
                  </Data>
                  <Numero>
                     <xsl:value-of select="cbc:ID"/>
                  </Numero>
                  <xsl:apply-templates select="ext:UBLExtensions/ext:UBLExtension[ext:ExtensionURI='urn:www.ubl-italia.org:spec:fatturapa:ritenuta']/ext:ExtensionContent/cac:WithholdingTaxTotal"
                                       mode="RITENUTA">
                     <xsl:with-param name="CN" select="current()"/>
                     <xsl:with-param name="CNP" select="position()"/>
                  </xsl:apply-templates>
                  <xsl:apply-templates select="ext:UBLExtensions/ext:UBLExtension[ext:ExtensionURI='urn:www.ubl-italia.org:spec:fatturapa:bollo']/ext:ExtensionContent/cbc:TaxAmount"
                                       mode="BOLLO">
                     <xsl:with-param name="CN" select="current()"/>
                     <xsl:with-param name="CNP" select="position()"/>
                  </xsl:apply-templates>
                  <xsl:apply-templates select="ext:UBLExtensions/ext:UBLExtension[ext:ExtensionURI='urn:www.ubl-italia.org:spec:fatturapa:contributo_cassa' or ext:ExtensionURI='urn:www.ubl-italia.org:spec:fatturapa:contributo_cassa::1']/ext:ExtensionContent/cac:TaxTotal[1]"
                                       mode="CassaPrevidenziale">
                     <xsl:with-param name="CN" select="current()"/>
                     <xsl:with-param name="CNP" select="position()"/>
                  </xsl:apply-templates>
                  <xsl:apply-templates select="/in:CreditNote/ext:UBLExtensions/ext:UBLExtension[ext:ExtensionURI='urn:www.ubl-italia.org:spec:fatturapa:contributo_cassa::2']/ext:ExtensionContent/cac:TaxTotal"
                                       mode="CassaPrevidenziale2">
                     <xsl:with-param name="CN" select="current()"/>
                     <xsl:with-param name="CNP" select="position()"/>
                  </xsl:apply-templates>
                  <xsl:apply-templates select="cac:AllowanceCharge">
                     <xsl:with-param name="CN" select="current()"/>
                     <xsl:with-param name="CNP" select="position()"/>
                  </xsl:apply-templates>
                  <xsl:if test="cac:LegalMonetaryTotal/cbc:TaxInclusiveAmount">
                     <ImportoTotaleDocumento>
                        <xsl:value-of select="format-number(cac:LegalMonetaryTotal/cbc:TaxInclusiveAmount,'###########0.00')"/>
                     </ImportoTotaleDocumento>
                  </xsl:if>
                  <xsl:if test="cac:LegalMonetaryTotal/cbc:PayableRoundingAmount">
                     <Arrotondamento>
                        <xsl:value-of select="format-number(cac:LegalMonetaryTotal/cbc:PayableRoundingAmount,'###########0.00')"/>
                     </Arrotondamento>
                  </xsl:if>
                  <xsl:apply-templates select="cbc:Note">
                     <xsl:with-param name="CN" select="current()"/>
                     <xsl:with-param name="CNP" select="position()"/>
                  </xsl:apply-templates>
                  <xsl:if test="lower-case(replace(cbc:ID/@schemeID,'\s',''))='art73dpr633/72'">
                     <Art73>
                        <xsl:text>SI</xsl:text>
                     </Art73>
                  </xsl:if>
               </DatiGeneraliDocumento>
               <xsl:apply-templates select="cac:OrderReference">
                  <xsl:with-param name="CN" select="current()"/>
                  <xsl:with-param name="CNP" select="position()"/>
               </xsl:apply-templates>
               <xsl:apply-templates select="cac:CreditNoteLine/cac:OrderLineReference"
                                    mode="DatiOrdineAcquisto_Riga">
                  <xsl:with-param name="CN" select="current()"/>
                  <xsl:with-param name="CNP" select="position()"/>
               </xsl:apply-templates>
               <xsl:apply-templates select="cac:ContractDocumentReference">
                  <xsl:with-param name="CN" select="current()"/>
                  <xsl:with-param name="CNP" select="position()"/>
               </xsl:apply-templates>
               <xsl:apply-templates select="cac:CreditNoteLine/cac:DocumentReference[cbc:DocumentType='ESTREMI_CONTRATTO']"
                                    mode="DatiContratto_Riga">
                  <xsl:with-param name="CN" select="current()"/>
                  <xsl:with-param name="CNP" select="position()"/>
               </xsl:apply-templates>
               <xsl:apply-templates select="cac:OriginatorDocumentReference">
                  <xsl:with-param name="CN" select="current()"/>
                  <xsl:with-param name="CNP" select="position()"/>
               </xsl:apply-templates>
               <xsl:apply-templates select="cac:CreditNoteLine/cac:DocumentReference[cbc:DocumentType='ESTREMI_CONVENZIONE']"
                                    mode="Estremi_Convenzione_Riga">
                  <xsl:with-param name="CN" select="current()"/>
                  <xsl:with-param name="CNP" select="position()"/>
               </xsl:apply-templates>
               <xsl:apply-templates select="cac:ReceiptDocumentReference">
                  <xsl:with-param name="CN" select="current()"/>
                  <xsl:with-param name="CNP" select="position()"/>
               </xsl:apply-templates>
               <xsl:apply-templates select="cac:CreditNoteLine/cac:ReceiptLineReference" mode="DatiRicezione_Riga">
                  <xsl:with-param name="CN" select="current()"/>
                  <xsl:with-param name="CNP" select="position()"/>
               </xsl:apply-templates>
               <xsl:apply-templates select="cac:BillingReference/cac:InvoiceDocumentReference"
                                    mode="FatturaCollegata">
                  <xsl:with-param name="CN" select="current()"/>
                  <xsl:with-param name="CNP" select="position()"/>
               </xsl:apply-templates>
               <xsl:apply-templates select="cac:CreditNoteLine/cac:BillingReference"
                                    mode="DatiFattureCollegate_Riga">
                  <xsl:with-param name="CN" select="current()"/>
                  <xsl:with-param name="CNP" select="position()"/>
               </xsl:apply-templates>
               <xsl:apply-templates select="cac:AdditionalDocumentReference" mode="SAL">
                  <xsl:with-param name="CN" select="current()"/>
                  <xsl:with-param name="CNP" select="position()"/>
               </xsl:apply-templates>
               <xsl:apply-templates select="cac:DespatchDocumentReference">
                  <xsl:with-param name="CN" select="current()"/>
                  <xsl:with-param name="CNP" select="position()"/>
               </xsl:apply-templates>
               <xsl:apply-templates select="cac:CreditNoteLine/cac:DespatchLineReference" mode="DatiDDT">
                  <xsl:with-param name="CN" select="current()"/>
                  <xsl:with-param name="CNP" select="position()"/>
               </xsl:apply-templates>
               <xsl:apply-templates select="cac:Delivery[1]">
                  <xsl:with-param name="CN" select="current()"/>
                  <xsl:with-param name="CNP" select="position()"/>
               </xsl:apply-templates>
               <xsl:apply-templates select="cac:BillingReference/cac:AdditionalDocumentReference"
                                    mode="FatturaPrincipale">
                  <xsl:with-param name="CN" select="current()"/>
                  <xsl:with-param name="CNP" select="position()"/>
               </xsl:apply-templates>
            </DatiGenerali>
            <DatiBeniServizi>
               <xsl:apply-templates select="cac:CreditNoteLine">
                  <xsl:with-param name="CN" select="current()"/>
                  <xsl:with-param name="CNP" select="position()"/>
               </xsl:apply-templates>
               <xsl:apply-templates select="cac:TaxTotal/cac:TaxSubtotal" mode="DatiRiepilogo">
                  <xsl:with-param name="CN" select="current()"/>
                  <xsl:with-param name="CNP" select="position()"/>
               </xsl:apply-templates>
            </DatiBeniServizi>
            <xsl:if test="cac:PaymentMeans or cac:PaymentTerms or cac:PayeeParty/cac:PartyName">
               <DatiPagamento>
                  <CondizioniPagamento>
                     <xsl:text>TP02</xsl:text>
                  </CondizioniPagamento>
                  <xsl:apply-templates select="cac:PaymentMeans">
                     <xsl:with-param name="CN" select="current()"/>
                     <xsl:with-param name="CNP" select="position()"/>
                  </xsl:apply-templates>
                  <xsl:if test="not(cac:PaymentMeans) and not(cac:PaymentTerms) and cac:PayeeParty/cac:PartyName">
                     <DettaglioPagamento>
                        <xsl:if test="cac:PayeeParty/cac:PartyName">
                           <Beneficiario>
                              <xsl:value-of select="cac:PayeeParty/cac:PartyName[1]/cbc:Name"/>
                           </Beneficiario>
                        </xsl:if>
                        <ModalitaPagamento>
                           <xsl:text>MP05</xsl:text>
                        </ModalitaPagamento>
                        <ImportoPagamento>
                           <xsl:value-of select="format-number(if (/in:CreditNote/cac:WithholdingTaxTotal/cbc:TaxAmount) then (/in:CreditNote/cac:LegalMonetaryTotal/cbc:PayableAmount - /in:CreditNote/cac:WithholdingTaxTotal/cbc:TaxAmount) else /in:CreditNote/cac:LegalMonetaryTotal/cbc:PayableAmount,'###########0.00')"/>
                        </ImportoPagamento>
                     </DettaglioPagamento>
                  </xsl:if>
                  <xsl:if test="not(cac:PaymentMeans) and cac:PaymentTerms">
                     <DettaglioPagamento>
                        <xsl:if test="cac:PayeeParty/cac:PartyName">
                           <Beneficiario>
                              <xsl:value-of select="cac:PayeeParty/cac:PartyName[1]/cbc:Name"/>
                           </Beneficiario>
                        </xsl:if>
                        <ModalitaPagamento>
                           <xsl:text>MP05</xsl:text>
                        </ModalitaPagamento>
                        <xsl:if test="/in:CreditNote/cac:PaymentTerms[1]/cac:SettlementPeriod/cbc:StartDate">
                           <DataRiferimentoTerminiPagamento>
                              <xsl:value-of select="substring(string(/in:CreditNote/cac:PaymentTerms[1]/cac:SettlementPeriod/cbc:StartDate),1,10)"/>
                           </DataRiferimentoTerminiPagamento>
                        </xsl:if>
                        <xsl:if test="/in:CreditNote/cac:PaymentTerms[1]/cac:SettlementPeriod/cbc:DurationMeasure">
                           <GiorniTerminiPagamento>
                              <xsl:value-of select="/in:CreditNote/cac:PaymentTerms[1]/cac:SettlementPeriod/cbc:DurationMeasure"/>
                           </GiorniTerminiPagamento>
                        </xsl:if>
                        <ImportoPagamento>
                           <xsl:value-of select="format-number(if (/in:CreditNote/cac:WithholdingTaxTotal/cbc:TaxAmount) then (/in:CreditNote/cac:LegalMonetaryTotal/cbc:PayableAmount - /in:CreditNote/cac:WithholdingTaxTotal/cbc:TaxAmount) else /in:CreditNote/cac:LegalMonetaryTotal/cbc:PayableAmount,'###########0.00')"/>
                        </ImportoPagamento>
                        <xsl:if test="/in:CreditNote/cac:PaymentTerms[1]/cbc:SettlementDiscountAmount">
                           <ScontoPagamentoAnticipato>
                              <xsl:value-of select="format-number(/in:CreditNote/cac:PaymentTerms[1]/cbc:SettlementDiscountAmount,'###########0.00')"/>
                           </ScontoPagamentoAnticipato>
                        </xsl:if>
                        <xsl:if test="/in:CreditNote/cac:PaymentTerms[1]/cac:SettlementPeriod/cbc:EndDate">
                           <DataLimitePagamentoAnticipato>
                              <xsl:value-of select="substring(string(/in:CreditNote/cac:PaymentTerms[1]/cac:SettlementPeriod/cbc:EndDate),1,10)"/>
                           </DataLimitePagamentoAnticipato>
                        </xsl:if>
                        <xsl:if test="/in:CreditNote/cac:PaymentTerms[1]/cbc:PenaltyAmount">
                           <PenalitaPagamentiRitardati>
                              <xsl:value-of select="format-number(/in:CreditNote/cac:PaymentTerms[1]/cbc:PenaltyAmount,'###########0.00')"/>
                           </PenalitaPagamentiRitardati>
                        </xsl:if>
                        <xsl:if test="/in:CreditNote/cac:PaymentTerms[1]/cac:PenaltyPeriod/cbc:StartDate">
                           <DataDecorrenzaPenale>
                              <xsl:value-of select="substring(string(/in:CreditNote/cac:PaymentTerms[1]/cac:PenaltyPeriod/cbc:StartDate),1,10)"/>
                           </DataDecorrenzaPenale>
                        </xsl:if>
                     </DettaglioPagamento>
                  </xsl:if>
               </DatiPagamento>
            </xsl:if>
            <xsl:apply-templates select="cac:AdditionalDocumentReference" mode="Allegati">
               <xsl:with-param name="CN" select="current()"/>
               <xsl:with-param name="CNP" select="position()"/>
            </xsl:apply-templates>
         </FatturaElettronicaBody>
      </nx:FatturaElettronica>
   </xsl:template>

   <xsl:template match="/">
      <xsl:apply-templates select="/in:CreditNote"/>
   </xsl:template>
</xsl:stylesheet>