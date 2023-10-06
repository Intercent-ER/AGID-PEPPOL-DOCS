<?xml version="1.0" encoding="UTF-8"?>
<!--Stylesheet synthesized using Javest A2A Mapper environment.-->
<xsl:stylesheet xmlns:cac="urn:oasis:names:specification:ubl:schema:xsd:CommonAggregateComponents-2" xmlns:cbc="urn:oasis:names:specification:ubl:schema:xsd:CommonBasicComponents-2" xmlns:ccts="urn:un:unece:uncefact:documentation:2" xmlns:saxon="http://saxon.sf.net/" xmlns:cr="http://www.ubl-italia.org/ns/CrossReference" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:ds="http://www.w3.org/2000/09/xmldsig#" xmlns:ext="urn:oasis:names:specification:ubl:schema:xsd:CommonExtensionComponents-2" xmlns:in="urn:oasis:names:specification:ubl:schema:xsd:CreditNote-2" xmlns:nx="http://ivaservizi.agenziaentrate.gov.it/docs/xsd/fatture/v1.2" xmlns:qdt="urn:oasis:names:specification:ubl:schema:xsd:QualifiedDatatypes-2" xmlns:udt="urn:un:unece:uncefact:data:specification:UnqualifiedDataTypesSchemaModule:2" xmlns:asmap="http://www.javest.com/ns/mapper/snippet/attribute" xmlns:xsmap="http://www.javest.com/ns/mapper/snippet" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:gc="urn:fdc:difi.no:2017:vefa:structure:CodeList-1" xmlns:doc="http://docs.oasis-open.org/codelist/ns/genericode/1.0/" xmlns:vs="urn:www.ubl-italia.org:spec:fatturapa:codelist:gc:VATSchemes" exclude-result-prefixes="xsmap asmap in cac cbc ccts ext saxon qdt udt ds cr" version="2.0">
	<xsl:output indent="no"/>
	<xsl:param name="progInvio" as="xs:string">1</xsl:param>
	<xsl:param name="UNECE" as="xs:string">xcl/UNECERec20-11e.xml</xsl:param>
	<xsl:param name="UNCL4461" as="xs:string">xcl/UNCL4461.xml</xsl:param>
	<xsl:param name="ALLEGATO" as="xs:string">xcl/FormatoAttachment.xml</xsl:param>
	<xsl:template match="/*/ext:UBLExtensions/ext:UBLExtension" mode="ProvaRitenuta">
		<xsl:param name="CN" select="."/>
		<xsl:param name="CNP" select="1"/>
		<xsl:if test="contains(ext:ExtensionURI,'urn:fdc:agid.gov.it:fatturapa:Ritenuta')">
			<xsl:for-each select="ext:ExtensionContent/cac:WithholdingTaxTotal/cac:TaxSubtotal">
				<xsl:variable name="var" select="position()"/>
				<DatiRitenuta>
					<xsl:choose>
						<xsl:when test="/in:CreditNote/cac:AccountingSupplierParty/cac:Party/cac:Person and not(/*/ext:UBLExtensions/ext:UBLExtension[starts-with(ext:ExtensionURI,'urn:www.ubl-italia.org:spec:fatturapa:xref:tipo_ritenuta')])">
							<TipoRitenuta>
								<xsl:text>RT01</xsl:text>
							</TipoRitenuta>
						</xsl:when>
						<xsl:when test="cac:PartyName/cbc:Name and not(cac:Person) and not(/*/ext:UBLExtensions/ext:UBLExtension[starts-with(ext:ExtensionURI,'urn:www.ubl-italia.org:spec:fatturapa:xref:tipo_ritenuta')])">
							<TipoRitenuta>
								<xsl:text>RT02</xsl:text>
							</TipoRitenuta>
						</xsl:when>
						<xsl:when test="/*/ext:UBLExtensions/ext:UBLExtension[ext:ExtensionURI=concat('urn:fdc:agid.gov.it:fatturapa:TipoRitenuta::',position())]">
							<xsl:for-each select="/*/ext:UBLExtensions/ext:UBLExtension">
								<xsl:if test="ext:ExtensionURI=concat('urn:fdc:agid.gov.it:fatturapa:TipoRitenuta::',$var)">
									<TipoRitenuta>
										<xsl:value-of select="ext:ExtensionContent/cbc:TypeCode"/>
									</TipoRitenuta>
								</xsl:if>
							</xsl:for-each>
						</xsl:when>
						<xsl:when test="/*/ext:UBLExtensions/ext:UBLExtension[ext:ExtensionURI='urn:fdc:agid.gov.it:fatturapa:TipoRitenuta']">
							<xsl:for-each select="/*/ext:UBLExtensions/ext:UBLExtension">
								<TipoRitenuta>
									<xsl:value-of select="ext:ExtensionContent/cbc:TypeCode"/>
								</TipoRitenuta>
							</xsl:for-each>
						</xsl:when>
					</xsl:choose>
					<ImportoRitenuta>
						<xsl:value-of select="format-number(cbc:TaxAmount,'###########0.00')"/>
					</ImportoRitenuta>
					<AliquotaRitenuta>
						<xsl:value-of select="format-number(cac:TaxCategory/cbc:Percent,'###########0.00')"/>
					</AliquotaRitenuta>
					<CausalePagamento>
						<xsl:value-of select="cac:TaxCategory/cac:TaxScheme/cbc:TaxTypeCode"/>
					</CausalePagamento>
				</DatiRitenuta>
			</xsl:for-each>
		</xsl:if>
	</xsl:template>
	<xsl:template match="/*/ext:UBLExtensions/ext:UBLExtension" mode="RiepilogoArrotondamento">
		<xsl:param name="CN" select="."/>
		<xsl:param name="CNP" select="1"/>
		<xsl:if test=".[ext:ExtensionURI = concat('urn:fdc:agid.gov.it:fatturapa:RiepilogoIVA:Arrotondamento::',$CNP)]">
			<Arrotondamento>
				<xsl:value-of select="format-number(ext:ExtensionContent/cbc:Amount,'###########0.00')"/>
			</Arrotondamento>
		</xsl:if>
	</xsl:template>
	<xsl:template match="/in:CreditNote/cac:AccountingSupplierParty/cac:Party" mode="RitenutaPersoneFisiche">
		<xsl:param name="CN" select="."/>
		<xsl:param name="CNP" select="1"/>
		<xsl:if test="cac:Person and not(/*/ext:UBLExtensions/ext:UBLExtension[starts-with(ext:ExtensionURI,'urn:www.ubl-italia.org:spec:fatturapa:xref:tipo_ritenuta')])">
			<TipoRitenuta>
				<xsl:text>RT01</xsl:text>
			</TipoRitenuta>
		</xsl:if>
	</xsl:template>
	<xsl:template match="/in:CreditNote/cac:AccountingSupplierParty/cac:Party" mode="RitenutaPersoneGiuridiche">
		<xsl:param name="CN" select="."/>
		<xsl:param name="CNP" select="1"/>
		<xsl:if test="cac:PartyName/cbc:Name and not(cac:Person) and not(/*/ext:UBLExtensions/ext:UBLExtension[starts-with(ext:ExtensionURI,'urn:www.ubl-italia.org:spec:fatturapa:xref:tipo_ritenuta')])">
			<TipoRitenuta>
				<xsl:text>RT02</xsl:text>
			</TipoRitenuta>
		</xsl:if>
	</xsl:template>
	<xsl:template match="/in:CreditNote/cac:AccountingSupplierParty/cac:Party/cac:PartyIdentification">
		<xsl:param name="CN" select="."/>
		<xsl:param name="CNP" select="1"/>
		<xsl:if test="contains(./cbc:ID[contains(., 'EORI:')],'EORI:')">
			<CodEORI>
				<xsl:value-of select="substring-after(./cbc:ID,'EORI:')"/>
			</CodEORI>
		</xsl:if>
	</xsl:template>
	<xsl:template match="cac:AllowanceCharge" mode="BOLLO">
		<xsl:param name="CN" select="."/>
		<xsl:param name="CNP" select="1"/>
		<xsl:if test="./cbc:AllowanceChargeReasonCode = 'SAE'">
			<DatiBollo>
				<BolloVirtuale>
					<xsl:text>SI</xsl:text>
				</BolloVirtuale>
				<!-- <ImportoBollo>
					<xsl:value-of select="format-number(cbc:Amount,'###########0.00')"/>
				</ImportoBollo> -->
			</DatiBollo>
		</xsl:if>
	</xsl:template>
	<xsl:template match="/in:CreditNote/cac:AllowanceCharge" mode="ProvaCassaPrevidenziale">
		<xsl:param name="CN" select="."/>
		<xsl:param name="CNP" select="1"/>
		<xsl:if test="cbc:AllowanceChargeReasonCode='ZZZ'">
			<DatiCassaPrevidenziale>
				<TipoCassa>
					<xsl:value-of select="substring-before(cbc:AllowanceChargeReason,'#')"/>
				</TipoCassa>
				<AlCassa>
					<xsl:value-of select="format-number(cbc:MultiplierFactorNumeric,'###########0.00')"/>
				</AlCassa>
				<ImportoContributoCassa>
					<xsl:value-of select="format-number(floor(cbc:Amount * 100 + 0.5) div 100,'###########0.00')"/>
				</ImportoContributoCassa>
				<xsl:if test="cbc:BaseAmount">
					<ImponibileCassa>
						<xsl:value-of select="format-number(floor(cbc:BaseAmount * 100 + 0.5) div 100,'###########0.00')"/>
					</ImponibileCassa>
				</xsl:if>
				<xsl:if test="cac:TaxCategory/cbc:Percent">
					<AliquotaIVA>
						<xsl:value-of select="format-number(cac:TaxCategory/cbc:Percent,'###########0.00')"/>
					</AliquotaIVA>
				</xsl:if>
				<Ritenuta>
					<xsl:value-of select="substring-before(substring-after(cbc:AllowanceChargeReason,'#'),'#')"/>
				</Ritenuta>
				<xsl:if test="substring-after(substring-after(cbc:AllowanceChargeReason,'#'),'#')!=''">
					<Natura>
						<xsl:value-of select="substring-after(substring-after(cbc:AllowanceChargeReason,'#'),'#')"/>
					</Natura>
				</xsl:if>
			</DatiCassaPrevidenziale>
		</xsl:if>
	</xsl:template>
	<xsl:template match="/in:CreditNote/ext:UBLExtensions/ext:UBLExtension[ext:ExtensionURI='urn:www.ubl-italia.org:spec:fatturapa:contributo_cassa::2']/ext:ExtensionContent/cac:TaxTotal" mode="CassaPrevidenziale2">
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
			<xsl:apply-templates select="cac:Party/cac:AgentParty/cac:PostalAddress" mode="CedentePrestatore_StabileOrganizzazione">
				<xsl:with-param name="CN" select="current()"/>
				<xsl:with-param name="CNP" select="position()"/>
			</xsl:apply-templates>
			<xsl:apply-templates select="cac:Party/cac:PartyIdentification" mode="IscrizioneREA">
				<xsl:with-param name="CN" select="current()"/>
				<xsl:with-param name="CNP" select="position()"/>
			</xsl:apply-templates>
			<xsl:apply-templates select="cac:Party/cac:Contact" mode="CedentePrestatore_Contatti">
				<xsl:with-param name="CN" select="current()"/>
				<xsl:with-param name="CNP" select="position()"/>
			</xsl:apply-templates>
			<xsl:if test="/in:CreditNote/cbc:AccountingCost">
				<RiferimentoAmministrazione>
					<xsl:value-of select="/in:CreditNote/cbc:AccountingCost"/>
				</RiferimentoAmministrazione>
			</xsl:if>
		</CedentePrestatore>
	</xsl:template>
	<xsl:template match="cac:AdditionalDocumentReference" mode="SAL">
		<xsl:param name="CN" select="."/>
		<xsl:param name="CNP" select="1"/>
		<xsl:if test="cbc:ID[@schemeID='AOR']">
			<DatiSAL>
				<RiferimentoFase>
					<xsl:value-of select="cbc:ID"/>
				</RiferimentoFase>
			</DatiSAL>
		</xsl:if>
	</xsl:template>
	<xsl:template match="cac:AdditionalDocumentReference" mode="AllegatiBinari">
		<xsl:param name="CN" select="."/>
		<xsl:param name="CNP" select="1"/>
		<xsl:if test="cac:Attachment/cbc:EmbeddedDocumentBinaryObject">
			<Allegati>
				<NomeAttachment>
					<xsl:value-of select="cbc:ID"/>
				</NomeAttachment>
				<FormatoAttachment>
					<xsl:value-of select="if (document($ALLEGATO)//doc:Code[doc:Id=current()/cac:Attachment/cbc:EmbeddedDocumentBinaryObject/@mimeCode]/doc:LocalId[1]) then document($ALLEGATO)//doc:Code[doc:Id=current()/cac:Attachment/cbc:EmbeddedDocumentBinaryObject/@mimeCode]/doc:LocalId[1] else if (matches(cbc:DocumentType,'\.[a-zA-Z]{3,4}$')) then tokenize(cbc:DocumentType, '\.')[last()] else 'binary'"/>
				</FormatoAttachment>
				<xsl:if test="cbc:DocumentDescription">
					<DescrizioneAttachment>
						<xsl:value-of select="cbc:DocumentDescription"/>
					</DescrizioneAttachment>
				</xsl:if>
				<xsl:if test="cac:Attachment/cbc:EmbeddedDocumentBinaryObject">
					<Attachment>
						<xsl:value-of select="cac:Attachment/cbc:EmbeddedDocumentBinaryObject"/>
					</Attachment>
				</xsl:if>
			</Allegati>
		</xsl:if>
	</xsl:template>
	<xsl:template match="cac:AllowanceCharge" mode="SCONTOMAGGIORAZIONE">
		<xsl:param name="CN" select="."/>
		<xsl:param name="CNP" select="1"/>
		<xsl:if test="not(cbc:AllowanceChargeReason='BOLLO') and (cbc:AllowanceChargeReasonCode!='ZZZ')">
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
					<xsl:value-of select="cbc:Amount"/>
				</Importo>
			</ScontoMaggiorazione>
			<xsl:if test="/in:CreditNote/ext:UBLExtensions/ext:UBLExtension[ext:ExtensionURI='urn:fdc:agid.gov.it:fatturapa:ScontoMaggiorazione']">
				<ScontoMaggiorazione>
					<xsl:if test="lower-case(/in:CreditNote/ext:UBLExtensions/ext:UBLExtension[ext:ExtensionURI='urn:fdc:agid.gov.it:fatturapa:ScontoMaggiorazione']/ext:ExtensionContent/cac:AllowanceCharge/cbc:ChargeIndicator)='false'">
						<Tipo>
							<xsl:text>SC</xsl:text>
						</Tipo>
					</xsl:if>
					<xsl:if test="lower-case(/in:CreditNote/ext:UBLExtensions/ext:UBLExtension[ext:ExtensionURI='urn:fdc:agid.gov.it:fatturapa:ScontoMaggiorazione']/ext:ExtensionContent/cac:AllowanceCharge/cbc:ChargeIndicator)='true'">
						<Tipo>
							<xsl:text>MG</xsl:text>
						</Tipo>
					</xsl:if>
					<Importo>
						<xsl:value-of select="/in:CreditNote/ext:UBLExtensions/ext:UBLExtension[ext:ExtensionURI='urn:fdc:agid.gov.it:fatturapa:ScontoMaggiorazione']/ext:ExtensionContent/cac:AllowanceCharge/cbc:Amount"/>
					</Importo>
				</ScontoMaggiorazione>
			</xsl:if>
		</xsl:if>
	</xsl:template>
	<xsl:template match="cac:Price/cac:AllowanceCharge" mode="ScontoMaggiorazione_Riga">
		<xsl:param name="CN" select="."/>
		<xsl:param name="CNP" select="1"/>
		<xsl:if test=". and cbc:Amount != 0.00">
			<ScontoMaggiorazione>
				<xsl:choose>
					<xsl:when test="(number(cbc:Amount) > 0.00)">
						<Tipo>
							<xsl:text>SC</xsl:text>
						</Tipo>
					</xsl:when>
					<xsl:when test="(0.00 > number(cbc:Amount))">
						<Tipo>
							<xsl:text>MG</xsl:text>
						</Tipo>
					</xsl:when>
				</xsl:choose>
				<xsl:choose>
					<xsl:when test="(number(cbc:Amount) > 0.00)">
						<Importo>
							<xsl:value-of select="cbc:Amount"/>
						</Importo>
					</xsl:when>
					<xsl:when test="(0.00 > number(cbc:Amount))">
						<Importo>
							<xsl:value-of select="format-number( 0 - number(cbc:Amount),'###########0.00')"/>
						</Importo>
					</xsl:when>
					<xsl:otherwise>
						<Importo>
							<xsl:value-of select="cbc:Amount"/>
						</Importo>
					</xsl:otherwise>
				</xsl:choose>
			</ScontoMaggiorazione>
		</xsl:if>
	</xsl:template>
	<xsl:template match="cac:BillingReference/cac:AdditionalDocumentReference" mode="FatturaPrincipale">
		<xsl:param name="CN" select="."/>
		<xsl:param name="CNP" select="1"/>
		<xsl:if test=".">
			<FatturaPrincipale>
				<NumeroFatturaPrincipale>
					<xsl:value-of select="cbc:ID"/>
				</NumeroFatturaPrincipale>
				<DataFatturaPrincipale>
					<xsl:value-of select="cbc:IssueDate"/>
				</DataFatturaPrincipale>
			</FatturaPrincipale>
		</xsl:if>
	</xsl:template>
	<xsl:template match="cac:BillingReference/cac:InvoiceDocumentReference" mode="FatturaCollegata">
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
			</DatiFattureCollegate>
		</xsl:if>
	</xsl:template>
	<xsl:template match="/in:CreditNote/cac:Delivery/cac:DeliveryLocation/cac:Address">
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
				<xsl:if test="cac:Country/cbc:IdentificationCode = 'IT'">
					<Provincia>
						<xsl:value-of select="cbc:CountrySubentity"/>
					</Provincia>
				</xsl:if>
				<Nazione>
					<xsl:value-of select="cac:Country/cbc:IdentificationCode"/>
				</Nazione>
			</IndirizzoResa>
		</xsl:if>
	</xsl:template>
	<xsl:template match="/in:CreditNote/cac:Delivery" mode='delivery'>
		<xsl:param name="CN" select="."/>
		<xsl:param name="CNP" select="1"/>
		<xsl:if test="/in:CreditNote/cac:Delivery">
			<DatiTrasporto>
				<xsl:apply-templates select="/in:CreditNote/cac:Delivery/cac:CarrierParty" mode='transport-data'>
					<xsl:with-param name="CN" select="current()"/>
					<xsl:with-param name="CNP" select="position()"/>
				</xsl:apply-templates>
				<xsl:if test="cac:Shipment/cac:ShipmentStage">
					<MezzoTrasporto>
						<xsl:value-of select="cac:Shipment/cac:ShipmentStage/cbc:TransportMeansTypeCode"/>
					</MezzoTrasporto>
				</xsl:if>
				<xsl:if test="cac:Despatch/cbc:Instructions">
					<CausaleTrasporto>
						<xsl:value-of select="cac:Despatch/cbc:Instructions"/>
					</CausaleTrasporto>
				</xsl:if>
				<xsl:if test="cac:Shipment/cbc:TotalTransportHandlingUnitQuantity">
					<NumeroColli>
						<xsl:value-of select="cac:Shipment/cbc:TotalTransportHandlingUnitQuantity"/>
					</NumeroColli>
				</xsl:if>
				<xsl:if test="cac:Shipment/cac:GoodsItem/cbc:Description">
					<Descrizione>
						<xsl:value-of select="cac:Shipment/cac:GoodsItem/cbc:Description"/>
					</Descrizione>
				</xsl:if>
				<xsl:if test="cac:Shipment/cbc:GrossWeightMeasure/@unitCode">
					<UnitaMisuraPeso>
						<xsl:value-of select="document($UNECE)//gc:Code[gc:Id=current()/cac:Shipment/cbc:GrossWeightMeasure/@unitCode]/gc:LocalIds/gc:LocalId[1]"/>
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
				<xsl:if test="cac:Despatch/cbc:RequestedDespatchDate">
					<xsl:variable name="date" select="cac:Despatch/cbc:RequestedDespatchDate"/>
					<xsl:variable name="time" select="cac:Despatch/cbc:RequestedDespatchTime"/>
					<DataOraRitiro>
						<xsl:value-of select="concat($date,'T',$time)"/>
					</DataOraRitiro>
				</xsl:if>
				<xsl:if test="cac:Despatch/cbc:ActualDespatchDate">
					<DataInizioTrasporto>
						<xsl:value-of select="cac:Despatch/cbc:ActualDespatchDate"/>
					</DataInizioTrasporto>
				</xsl:if>
				<xsl:if test="/in:CreditNote/cac:DeliveryTerms/cbc:ID">
					<TipoResa>
						<xsl:value-of select="/in:CreditNote/cac:DeliveryTerms/cbc:ID"/>
					</TipoResa>
				</xsl:if>
				<xsl:apply-templates select="/in:CreditNote/cac:Delivery/cac:DeliveryLocation/cac:Address">
					<xsl:with-param name="CN" select="current()"/>
					<xsl:with-param name="CNP" select="position()"/>
				</xsl:apply-templates>
				<xsl:if test="/in:CreditNote/cac:Delivery/cbc:ActualDeliveryDate">
					<xsl:variable name="date" select="/in:CreditNote/cac:Delivery/cbc:ActualDeliveryDate"/>
					<DataOraConsegna>
						<xsl:value-of select="concat($date,'T','00:00:00')"/>
					</DataOraConsegna>
				</xsl:if>
			</DatiTrasporto>
		</xsl:if>
	</xsl:template>
	<xsl:template match="/in:CreditNote/cac:Delivery/cac:CarrierParty" mode='transport-data'>
		<xsl:param name="CN" select="."/>
		<xsl:param name="CNP" select="1"/>
		<xsl:if test=".">
			<DatiAnagraficiVettore>
				<IdFiscaleIVA>
					<IdPaese>
						<xsl:value-of select="substring(cac:PartyTaxScheme/cbc:CompanyID,1,2)"/>
					</IdPaese>
					<IdCodice>
						<xsl:value-of select="substring(cac:PartyTaxScheme/cbc:CompanyID,3,string-length(cac:PartyTaxScheme/cbc:CompanyID)-2)"/>
					</IdCodice>
				</IdFiscaleIVA>
				<xsl:if test="cac:PartyIdentification">
					<CodiceFiscale>
						<xsl:value-of select="cac:PartyIdentification/cbc:ID"/>
					</CodiceFiscale>
				</xsl:if>
				<Anagrafica>
					<xsl:choose>
						<xsl:when test="cac:PartyName">
							<Denominazione>
								<xsl:value-of select="normalize-space(cac:PartyName)"/>
							</Denominazione>
						</xsl:when>
						<xsl:when test="cac:Person">
							<Nome>
								<xsl:value-of select="cac:Person/cbc:FirstName"/>
							</Nome>
							<Cognome>
								<xsl:value-of select="cac:Person/cbc:FamilyName"/>
							</Cognome>
						</xsl:when>
					</xsl:choose>
				</Anagrafica>
				<xsl:if test="cac:Person/cac:IdentityDocumentReference/cbc:ID">
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
	<xsl:template match="cac:CreditNoteLine">
		<xsl:param name="CN" select="."/>
		<xsl:param name="CNP" select="1"/>
		<DettaglioLinee>
			<NumeroLinea>
				<xsl:value-of select="if (number(cbc:ID) &gt; 0) then number(cbc:ID) else position()"/>
			</NumeroLinea>
			<xsl:apply-templates select="cac:Item/cac:AdditionalItemProperty" mode="TipoCessionePrestazione">
				<xsl:with-param name="CN" select="current()"/>
				<xsl:with-param name="CNP" select="position()"/>
			</xsl:apply-templates>
			<xsl:if test="cac:Item/cac:SellersItemIdentification or cac:Item/cac:CommodityClassification">
				<xsl:apply-templates select="cac:Item" mode="codiceArticolo">
					<xsl:with-param name="CN" select="current()"/>
					<xsl:with-param name="CNP" select="position()"/>
				</xsl:apply-templates>
			</xsl:if>
			<xsl:apply-templates select="cac:Item/cac:StandardItemIdentification/cbc:ID">
				<xsl:with-param name="CN" select="current()"/>
				<xsl:with-param name="CNP" select="position()"/>
			</xsl:apply-templates>
			<xsl:choose>
				<xsl:when test="cac:Item/cbc:Description and cac:Item/cbc:Name">
					<Descrizione>
						<xsl:value-of select="concat(normalize-space(cac:Item/cbc:Name),' - ',normalize-space(cac:Item/cbc:Description))"/>
					</Descrizione>
				</xsl:when>
				<xsl:when test="cac:Item/cbc:Description and not(cac:Item/cbc:Name)">
					<Descrizione>
						<xsl:value-of select="normalize-space(cac:Item/cbc:Description)"/>
					</Descrizione>
				</xsl:when>
				<xsl:when test="cac:Item/cbc:Name and not(cac:Item/cbc:Description)">
					<Descrizione>
						<xsl:value-of select="normalize-space(cac:Item/cbc:Name)"/>
					</Descrizione>
				</xsl:when>
			</xsl:choose>
			<xsl:if test="cbc:CreditedQuantity and not(cac:Price/cbc:BaseQuantity)">
				<Quantita>
					<xsl:value-of select="if (contains(cbc:CreditedQuantity, '-')) then format-number(number(substring-after(cbc:CreditedQuantity, '-')),'###########0.00000000') else format-number(cbc:CreditedQuantity,'###########0.00000000')"/>
				</Quantita>
			</xsl:if>
			<xsl:if test="cbc:CreditedQuantity and cac:Price/cbc:BaseQuantity">
				<Quantita>
					<xsl:value-of select="if (contains(cbc:CreditedQuantity, '-')) then format-number(number(substring-after(cbc:CreditedQuantity, '-')) div number(cac:Price/cbc:BaseQuantity),'###########0.00000000') else format-number(number(cbc:CreditedQuantity) div number(cac:Price/cbc:BaseQuantity),'###########0.00000000')"/>
				</Quantita>
			</xsl:if>
			<xsl:if test="not(cbc:CreditedQuantity)">
				<Quantita>
					<xsl:text>1.00</xsl:text>
				</Quantita>
			</xsl:if>
			<xsl:choose>
				<xsl:when test="cac:Price/cbc:BaseQuantity">
					<UnitaMisura>
						<xsl:value-of select="substring(concat(format-number(cac:Price/cbc:BaseQuantity,'###########0.00'),' ',document($UNECE)//gc:Code[gc:Id=current()/cbc:CreditedQuantity/@unitCode]/gc:LocalIds/gc:LocalId[1]),1,10)"/>
					</UnitaMisura>
				</xsl:when>
				<xsl:when test="not(cac:Price/cbc:BaseQuantity)">
					<UnitaMisura>
						<xsl:value-of select="substring(concat('1.00',' ',document($UNECE)//gc:Code[gc:Id=current()/cbc:CreditedQuantity/@unitCode]/gc:LocalIds/gc:LocalId[1]),1,10)"/>
					</UnitaMisura>
				</xsl:when>
			</xsl:choose>
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
				<xsl:value-of select="if (contains(cbc:CreditedQuantity, '-')) then concat('-',format-number(cac:Price/cac:AllowanceCharge/cbc:BaseAmount,'###########0.00000000')) else format-number(cac:Price/cac:AllowanceCharge/cbc:BaseAmount,'###########0.00000000')"/>
			</PrezzoUnitario>
			<xsl:apply-templates select="cac:Price/cac:AllowanceCharge" mode="ScontoMaggiorazione_Riga">
				<xsl:with-param name="CN" select="current()"/>
				<xsl:with-param name="CNP" select="position()"/>
			</xsl:apply-templates>
			<PrezzoTotale>
				<xsl:value-of select="format-number(cbc:LineExtensionAmount,'###########0.00')"/>
			</PrezzoTotale>
			<xsl:apply-templates select="cac:Item/cac:ClassifiedTaxCategory" mode="AliquotaIVA_Dettaglio">
				<xsl:with-param name="CN" select="current()"/>
				<xsl:with-param name="CNP" select="position()"/>
			</xsl:apply-templates>
			<xsl:for-each select="cac:Item/cac:AdditionalItemProperty">
				<xsl:if test="lower-case(cbc:Name)='ritenuta'">
					<Ritenuta>
						<xsl:text>SI</xsl:text>
					</Ritenuta>
				</xsl:if>
			</xsl:for-each>
			<!-- Conversione Natura cross-border-->
			<xsl:if test="cac:Item/cac:ClassifiedTaxCategory/cbc:ID and ((/in:CreditNote/cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode !='IT') or (/in:CreditNote/cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode !='IT'))">
				<xsl:choose>
					<xsl:when test="cac:Item/cac:ClassifiedTaxCategory/cbc:ID ='Z'">
						<Natura>
							<xsl:text>N1</xsl:text>
						</Natura>
					</xsl:when>
					<xsl:when test="cac:Item/cac:ClassifiedTaxCategory/cbc:ID ='E'">
						<Natura>
							<xsl:text>N2.2</xsl:text>
						</Natura>
					</xsl:when>
					<xsl:when test="cac:Item/cac:ClassifiedTaxCategory/cbc:ID ='G'">
						<Natura>
							<xsl:text>N3.1</xsl:text>
						</Natura>
					</xsl:when>
					<xsl:when test="cac:Item/cac:ClassifiedTaxCategory/cbc:ID ='K'">
						<Natura>
							<xsl:text>N3.2</xsl:text>
						</Natura>
					</xsl:when>
					<xsl:when test="cac:Item/cac:ClassifiedTaxCategory/cbc:ID ='AE'">
						<Natura>
							<xsl:text>N6.9</xsl:text>
						</Natura>
					</xsl:when>
				</xsl:choose>
			</xsl:if>
			<!-- Conversione Natura domestica-->
			<xsl:if test="cac:Item/cac:ClassifiedTaxCategory/cbc:ID and (/in:CreditNote/cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode ='IT') and (/in:CreditNote/cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode ='IT')">
				<xsl:for-each select="cac:Item/cac:AdditionalItemProperty">
					<xsl:if test="lower-case(cbc:Name)='natura'">
						<Natura>
							<xsl:value-of select="cbc:Value"/>
						</Natura>
					</xsl:if>
				</xsl:for-each>
			</xsl:if>
			<xsl:if test="cbc:AccountingCost">
				<RiferimentoAmministrazione>
					<xsl:value-of select="cbc:AccountingCost"/>
				</RiferimentoAmministrazione>
			</xsl:if>
			<xsl:for-each select="cac:Item/cac:AdditionalItemProperty">
				<xsl:if test="lower-case(cbc:Name)='testo' or lower-case(cbc:Name)='data' or  lower-case(cbc:Name)='numero'">
					<xsl:choose>
						<xsl:when test="lower-case(cbc:Name)='testo'">
							<AltriDatiGestionali>
								<TipoDato>
									<xsl:value-of select="cbc:Name"/>
								</TipoDato>
								<RiferimentoTesto>
									<xsl:value-of select="cbc:Value"/>
								</RiferimentoTesto>
							</AltriDatiGestionali>
						</xsl:when>
						<xsl:when test="lower-case(cbc:Name)='numero'">
							<AltriDatiGestionali>
								<TipoDato>
									<xsl:value-of select="cbc:Name"/>
								</TipoDato>
								<RiferimentoTesto>
									<xsl:value-of select="cbc:Value"/>
								</RiferimentoTesto>
							</AltriDatiGestionali>
						</xsl:when>
						<xsl:when test="lower-case(cbc:Name)='data'">
							<AltriDatiGestionali>
								<TipoDato>
									<xsl:value-of select="cbc:Name"/>
								</TipoDato>
								<RiferimentoData>
									<xsl:value-of select="cbc:Value"/>
								</RiferimentoData>
							</AltriDatiGestionali>
						</xsl:when>
					</xsl:choose>
				</xsl:if>
			</xsl:for-each>
		</DettaglioLinee>
	</xsl:template>
	<xsl:template match="cac:CreditNoteLine/cac:BillingReference" mode="DatiFattureCollegate_Riga">
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
	<xsl:template match="/in:CreditNote/cac:CreditNoteLine" mode="DatiOrdine_Commessa_Prova">
		<xsl:param name="CN" select="."/>
		<xsl:param name="CNP" select="1"/>
		<xsl:if test="./cac:DocumentReference/cbc:ID[@schemeID='AVV']">
			<DatiConvenzione>
				<RiferimentoNumeroLinea>
					<xsl:value-of select="cbc:ID"/>
				</RiferimentoNumeroLinea>
				<IdDocumento>
					<xsl:value-of select="./cac:DocumentReference/cbc:ID[@schemeID='AVV']"/>
				</IdDocumento>
			</DatiConvenzione>
		</xsl:if>
	</xsl:template>
	<xsl:template match="/in:CreditNote/cac:CreditNoteLine" mode="DatiContratto_Cius">
		<xsl:param name="CN" select="."/>
		<xsl:param name="CNP" select="1"/>
		<xsl:variable name="ct-b">
			<xsl:if test="not(cac:DocumentReference/cbc:ID[@schemeID='CT'])">
				<xsl:text>false</xsl:text>
			</xsl:if>
			<xsl:if test="cac:DocumentReference/cbc:ID[@schemeID='CT']">
				<xsl:text>true</xsl:text>
			</xsl:if>
		</xsl:variable>
		<xsl:if test="$ct-b = 'true' or cac:DocumentReference/cbc:ID[@schemeID='AEP'] or cac:DocumentReference/cbc:ID[@schemeID='AGB']">
			<DatiContratto>
				<xsl:choose>
					<xsl:when test="$ct-b = 'true' and not (cac:DocumentReference/cbc:ID[@schemeID='AEP']) and not (cac:DocumentReference/cbc:ID[@schemeID='AGB'])">
						<RiferimentoNumeroLinea>
							<xsl:value-of select="cbc:ID"/>
						</RiferimentoNumeroLinea>
						<IdDocumento>
							<xsl:value-of select="cac:DocumentReference/cbc:ID[@schemeID='CT']"/>
						</IdDocumento>
						<xsl:if test="/in:CreditNote/cac:ProjectReference/cbc:ID">
							<CodiceCUP>
								<xsl:value-of select="/in:CreditNote/cac:ProjectReference/cbc:ID"/>
							</CodiceCUP>
						</xsl:if>
						<xsl:if test="/in:CreditNote/cac:OriginatorDocumentReference/cbc:ID">
							<CodiceCIG>
								<xsl:value-of select="/in:CreditNote/cac:OriginatorDocumentReference/cbc:ID"/>
							</CodiceCIG>
						</xsl:if>
					</xsl:when>
					<xsl:when test="$ct-b = 'true' and ((cac:DocumentReference/cbc:ID[@schemeID='AEP']) or (cac:DocumentReference/cbc:ID[@schemeID='AGB']))">
						<xsl:if test="cac:DocumentReference/cbc:ID[@schemeID='CT']">
							<IdDocumento>
								<xsl:value-of select="cac:DocumentReference/cbc:ID[@schemeID='CT']"/>
							</IdDocumento>
						</xsl:if>
						<xsl:if test="/in:CreditNote/cac:ContractDocumentReference and not(cac:DocumentReference/cbc:ID[@schemeID='CT'])">
							<IdDocumento>
								<xsl:value-of select="/in:CreditNote/cac:ContractDocumentReference/cbc:ID"/>
							</IdDocumento>
						</xsl:if>
						<xsl:if test="cac:DocumentReference/cbc:ID[@schemeID='AEP']">
							<CodiceCUP>
								<xsl:value-of select="cac:DocumentReference/cbc:ID[@schemeID='AEP']"/>
							</CodiceCUP>
						</xsl:if>
						<xsl:if test="cac:DocumentReference/cbc:ID[@schemeID='AGB']">
							<CodiceCIG>
								<xsl:value-of select="cac:DocumentReference/cbc:ID[@schemeID='AGB']"/>
							</CodiceCIG>
						</xsl:if>
					</xsl:when>
					<xsl:when test="$ct-b = 'false' and ((cac:DocumentReference/cbc:ID[@schemeID='AEP'] or cac:DocumentReference/cbc:ID[@schemeID='AGB']))">
						<RiferimentoNumeroLinea>
							<xsl:value-of select="./cbc:ID"/>
						</RiferimentoNumeroLinea>
						<xsl:if test="/in:CreditNote/cac:ContractDocumentReference">
							<IdDocumento>
								<xsl:value-of select="/in:CreditNote/cac:ContractDocumentReference/cbc:ID"/>
							</IdDocumento>
						</xsl:if>
						<xsl:if test="not(/in:CreditNote/cac:ContractDocumentReference)">
							<IdDocumento>
								<xsl:text>N/A</xsl:text>
							</IdDocumento>
						</xsl:if>
						<xsl:if test="cac:DocumentReference/cbc:ID[@schemeID='AEP']">
							<CodiceCUP>
								<xsl:value-of select="cac:DocumentReference/cbc:ID[@schemeID='AEP']"/>
							</CodiceCUP>
						</xsl:if>
						<xsl:if test="cac:DocumentReference/cbc:ID[@schemeID='AGB']">
							<CodiceCIG>
								<xsl:value-of select="cac:DocumentReference/cbc:ID[@schemeID='AGB']"/>
							</CodiceCIG>
						</xsl:if>
					</xsl:when>
				</xsl:choose>
			</DatiContratto>
		</xsl:if>
	</xsl:template>
	<xsl:template match="cac:CreditNoteLine/cac:OrderLineReference" mode="DatiOrdineAcquisto_Riga2">
		<xsl:param name="CN" select="."/>
		<xsl:param name="CNP" select="1"/>
		<xsl:if test="/cac:OrderReference or /in:CreditNote/cac:OrderReference/cbc:ID">
			<DatiOrdineAcquisto>
				<RiferimentoNumeroLinea>
					<xsl:value-of select="../cbc:ID"/>
				</RiferimentoNumeroLinea>
				<IdDocumento>
					<xsl:value-of select="if (cac:OrderReference) then cac:OrderReference/cbc:ID else /in:CreditNote/cac:OrderReference/cbc:ID"/>
				</IdDocumento>
				<xsl:if test="cac:OrderReference/cbc:IssueDate or /in:CreditNote/cac:OrderReference/cbc:IssueDate">
					<xsl:choose>
						<xsl:when test="cac:OrderReference/cbc:IssueDate">
							<Data>
								<xsl:value-of select="&#x9;substring(string(cac:OrderReference/cbc:IssueDate),1,10)"/>
							</Data>
						</xsl:when>
						<xsl:when test="not (cac:OrderReference) and /in:CreditNote/cac:OrderReference/cbc:IssueDate">
							<Data>
								<xsl:value-of select="&#x9;substring(string(/in:CreditNote/cac:OrderReference/cbc:IssueDate),1,10)"/>
							</Data>
						</xsl:when>
					</xsl:choose>
				</xsl:if>
				<xsl:if test="cbc:LineID != '0'">
					<NumItem>
						<xsl:value-of select="cbc:LineID"/>
					</NumItem>
				</xsl:if>
				<xsl:choose>
					<xsl:when test="../cac:DocumentReference/cbc:ID[@schemeID='ON']">
						<CodiceCommessaConvenzione>
							<xsl:value-of select="/in:CreditNote/cac:CreditNoteLine/cac:DocumentReference/cbc:ID"/>
						</CodiceCommessaConvenzione>
					</xsl:when>
					<xsl:when test="/in:CreditNote/cbc:BuyerReference and not(../cac:DocumentReference/cbc:ID[@schemeID='ON'])">
						<CodiceCommessaConvenzione>
							<xsl:value-of select="/in:CreditNote/cbc:BuyerReference"/>
						</CodiceCommessaConvenzione>
					</xsl:when>
				</xsl:choose>
				<xsl:choose>
					<xsl:when test="../cac:DocumentReference/cbc:ID[@schemeID='ON']">
						<CodiceCommessaConvenzione>
							<xsl:value-of select="../cac:DocumentReference/cbc:ID"/>
						</CodiceCommessaConvenzione>
					</xsl:when>
					<xsl:when test="/in:CreditNote/cbc:BuyerReference and not(../cac:DocumentReference/cbc:ID[@schemeID='ON'])">
						<CodiceCommessaConvenzione>
							<xsl:value-of select="/in:CreditNote/cbc:BuyerReference"/>
						</CodiceCommessaConvenzione>
					</xsl:when>
				</xsl:choose>
			</DatiOrdineAcquisto>
		</xsl:if>
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
			<xsl:apply-templates select="/in:CreditNote/cac:CreditNoteLine/cac:DocumentReference[cbc:DocumentType='CommessaConvenzione_RICEZIONE']/cbc:ID" mode="DatiRicezione_Commessa_Riga">
				<xsl:with-param name="CN" select="current()"/>
				<xsl:with-param name="CNP" select="position()"/>
			</xsl:apply-templates>
			<xsl:apply-templates select="/in:CreditNote/cac:CreditNoteLine/cac:DocumentReference[cbc:DocumentType='CUP_RICEZIONE']/cbc:ID" mode="DatiRicezione_CUP_Riga">
				<xsl:with-param name="CN" select="current()"/>
				<xsl:with-param name="CNP" select="position()"/>
			</xsl:apply-templates>
			<xsl:apply-templates select="/in:CreditNote/cac:CreditNoteLine/cac:DocumentReference[cbc:DocumentType='CIG_RICEZIONE']/cbc:ID" mode="DatiRicezione_CIG_Riga">
				<xsl:with-param name="CN" select="current()"/>
				<xsl:with-param name="CNP" select="position()"/>
			</xsl:apply-templates>
		</DatiRicezione>
	</xsl:template>
	<xsl:template match="cac:Item/cac:ClassifiedTaxCategory" mode="AliquotaIVA_Dettaglio">
		<xsl:param name="CN" select="."/>
		<xsl:param name="CNP" select="1"/>
		<AliquotaIVA>
			<xsl:value-of select="if (.[cac:TaxScheme/cbc:ID='VAT']/cbc:Percent ) then format-number(.[cac:TaxScheme/cbc:ID='VAT']/cbc:Percent ,'##0.00') else '0.00'"/>
		</AliquotaIVA>
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
	<xsl:template match="cac:Item" mode="codiceArticolo">
		<xsl:param name="CN" select="."/>
		<xsl:param name="CNP" select="1"/>
		<xsl:if test="not(contains(./cac:SellersItemIdentification/cbc:ID,':'))">
			<CodiceArticolo>
				<CodiceTipo>
					<xsl:value-of select="if (@schemeID) then @schemeID else 'SellerItemIdentification'"/>
				</CodiceTipo>
				<CodiceValore>
					<xsl:value-of select="cac:SellersItemIdentification/cbc:ID"/>
				</CodiceValore>
			</CodiceArticolo>
		</xsl:if>
		<xsl:if test="substring-before(./cac:SellersItemIdentification/cbc:ID,':')='CARB'">
			<CodiceArticolo>
				<CodiceTipo>
					<xsl:text>CARB</xsl:text>
				</CodiceTipo>
				<CodiceValore>
					<xsl:value-of select="substring-after(./cac:SellersItemIdentification/cbc:ID,':')"/>
				</CodiceValore>
			</CodiceArticolo>
		</xsl:if>
		<xsl:if test="substring-before(./cac:SellersItemIdentification/cbc:ID,':')='AICFARMACO'">
			<CodiceArticolo>
				<CodiceTipo>
					<xsl:text>AICFARMACO</xsl:text>
				</CodiceTipo>
				<CodiceValore>
					<xsl:value-of select="substring-after(./cac:SellersItemIdentification/cbc:ID,':')"/>
				</CodiceValore>
			</CodiceArticolo>
		</xsl:if>
		<xsl:if test="./cac:CommodityClassification">
			<CodiceArticolo>
				<CodiceTipo>
					<xsl:value-of select="if (cac:CommodityClassification/cbc:ItemClassificationCode/@listID) then cac:CommodityClassification/cbc:ItemClassificationCode/@listID else ./cac:CommodityClassification/cbc:ItemClassificationCode">
					</xsl:value-of>
				</CodiceTipo>
				<CodiceValore>
					<xsl:value-of select="./cac:CommodityClassification/cbc:ItemClassificationCode"/>
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
		<xsl:if test="cbc:ID != '#MULTI#'">
			<DatiOrdineAcquisto>
				<IdDocumento>
					<xsl:value-of select="cbc:ID"/>
				</IdDocumento>
				<xsl:if test="cbc:IssueDate">
					<Data>
						<xsl:value-of select="&#x9;substring(string(cbc:IssueDate),1,10)"/>
					</Data>
				</xsl:if>
				<xsl:if test="/in:CreditNote/cbc:BuyerReference">
					<CodiceCommessaConvenzione>
						<xsl:choose>
							<xsl:when test="string-length(/in:CreditNote/cbc:BuyerReference)-string-length(translate(/in:CreditNote/cbc:BuyerReference,'#','')) = 2">
								<xsl:value-of select="concat('#', substring-after(substring-after(/in:CreditNote/cbc:BuyerReference, '#'), '#'), '#')"/>
							</xsl:when>
							<xsl:when test="string-length(/in:CreditNote/cbc:BuyerReference)-string-length(translate(/in:CreditNote/cbc:BuyerReference,'#','')) = 3">
								<xsl:value-of select="concat('#', substring-before(substring-after(substring-after(/in:CreditNote/cbc:BuyerReference, '#'), '#'), '#'), '#')"/>
							</xsl:when>
							<xsl:when test="(string-length(/in:CreditNote/cbc:BuyerReference)-string-length(translate(/in:CreditNote/cbc:BuyerReference,'#','')) &gt; 3) and (contains(/in:CreditNote/cbc:BuyerReference, '##')) ">
								<xsl:value-of select="concat('#', substring-before(substring-after(/in:CreditNote/cbc:BuyerReference, '##'), '#'), '#')"/>
							</xsl:when>
							<xsl:otherwise>						
								<xsl:value-of select="/in:CreditNote/cbc:BuyerReference"/>
							</xsl:otherwise>
						</xsl:choose>
					</CodiceCommessaConvenzione>
				</xsl:if>
			</DatiOrdineAcquisto>
		</xsl:if>
	</xsl:template>
	<xsl:template match="cac:PartyTaxScheme" mode="CedentePrestatore_PIVA">
		<xsl:param name="CN" select="."/>
		<xsl:param name="CNP" select="1"/>
		<IdFiscaleIVA>
			<IdPaese>
				<xsl:value-of select="substring(cbc:CompanyID,1,2)"/>
			</IdPaese>
			<IdCodice>
				<xsl:value-of select="substring(cbc:CompanyID,3,string-length(cbc:CompanyID)-2)"/>
			</IdCodice>
		</IdFiscaleIVA>
	</xsl:template>
	<xsl:template match="/in:CreditNote/cac:AccountingSupplierParty/cac:Party/cac:PartyIdentification" mode="AlboProfessionale">
		<xsl:param name="CN" select="."/>
		<xsl:param name="CNP" select="1"/>
		<xsl:if test="contains(./cbc:ID[contains(., 'ALBO:')],'ALBO:')">
			<AlboProfessionale>
				<xsl:value-of select="substring-after(substring-before(./cbc:ID[contains(., 'ALBO:')],'#'),':')"/>
			</AlboProfessionale>
			<NumeroIscrizioneAlbo>
				<xsl:value-of select="substring-before(substring-after(./cbc:ID[contains(., 'ALBO:')], '#'), '#')"/>
			</NumeroIscrizioneAlbo>
			<DataIscrizioneAlbo>
				<xsl:value-of select="substring-after(substring-after(./cbc:ID[contains(., 'ALBO:')], '#'),'#')"/>
			</DataIscrizioneAlbo>
		</xsl:if>
	</xsl:template>
	<xsl:template match="cac:Party" mode="CedentePrestatore_DatiAnagrafici">
		<xsl:param name="CN" select="."/>
		<xsl:param name="CNP" select="1"/>
		<DatiAnagrafici>
			<xsl:apply-templates select="./cac:PartyTaxScheme" mode="CedentePrestatore_PIVA">
				<xsl:with-param name="CN" select="current()"/>
				<xsl:with-param name="CNP" select="position()"/>
			</xsl:apply-templates>
			<xsl:if test="./cac:PartyLegalEntity/cbc:CompanyID">
				<CodiceFiscale>
					<xsl:value-of select="./cac:PartyLegalEntity/cbc:CompanyID"/>
				</CodiceFiscale>
			</xsl:if>
			<Anagrafica>
				<xsl:choose>
					<xsl:when test="contains(cac:PartyLegalEntity/cbc:RegistrationName,'Denominazione:')">
						<Denominazione>
							<xsl:value-of select="substring-after(cac:PartyLegalEntity/cbc:RegistrationName,'Denominazione:')"/>
						</Denominazione>
					</xsl:when>
					<xsl:when test="contains(cac:PartyLegalEntity/cbc:RegistrationName,'Nome#Cognome')">
						<Nome>
							<xsl:value-of select="substring-before(substring-after(cac:PartyLegalEntity/cbc:RegistrationName,':'),'#')"/>
						</Nome>
						<Cognome>
							<xsl:value-of select="substring-after(substring-after(cac:PartyLegalEntity/cbc:RegistrationName,':'),'#')"/>
						</Cognome>
					</xsl:when>
					<xsl:when test="contains(cac:PartyLegalEntity/cbc:RegistrationName,'NomeCognome')">
						<Nome>
							<xsl:value-of select="substring-after(cac:PartyLegalEntity/cbc:RegistrationName,':')"/>
						</Nome>
						<Cognome>
							<xsl:value-of select="substring-after(cac:PartyLegalEntity/cbc:RegistrationName,':')"/>
						</Cognome>
					</xsl:when>
					<xsl:otherwise>
						<Denominazione>
							<xsl:value-of select="cac:PartyLegalEntity/cbc:RegistrationName"/>
						</Denominazione>
					</xsl:otherwise>
				</xsl:choose>
				<xsl:apply-templates select="/in:CreditNote/cac:AccountingSupplierParty/cac:Party/cac:PartyIdentification">
					<xsl:with-param name="CN" select="current()"/>
					<xsl:with-param name="CNP" select="position()"/>
				</xsl:apply-templates>
			</Anagrafica>
			<xsl:apply-templates select="/in:CreditNote/cac:AccountingSupplierParty/cac:Party/cac:PartyIdentification" mode="AlboProfessionale">
				<xsl:with-param name="CN" select="current()"/>
				<xsl:with-param name="CNP" select="position()"/>
			</xsl:apply-templates>
			<xsl:if test="not(cac:PartyTaxScheme/cbc:TaxLevelCode)">
				<RegimeFiscale>
					<xsl:text>RF01</xsl:text>
				</RegimeFiscale>
			</xsl:if>
			<xsl:if test="cac:PartyTaxScheme/cbc:TaxLevelCode">
				<RegimeFiscale>
					<xsl:value-of select="cac:PartyTaxScheme/cbc:TaxLevelCode"/>
				</RegimeFiscale>
			</xsl:if>
		</DatiAnagrafici>
	</xsl:template>
	<xsl:template match="cac:Party" mode="CessionarioCommittente_DatiAnagrafici">
		<xsl:param name="CN" select="."/>
		<xsl:param name="CNP" select="1"/>
		<DatiAnagrafici>
			<xsl:apply-templates select="cac:PartyTaxScheme/cbc:CompanyID" mode="CessionarioCommittente_PIVA">
				<xsl:with-param name="CN" select="current()"/>
				<xsl:with-param name="CNP" select="position()"/>
			</xsl:apply-templates>
			<xsl:if test="./cac:PartyLegalEntity/cbc:CompanyID">
				<CodiceFiscale>
					<xsl:value-of select="./cac:PartyLegalEntity/cbc:CompanyID"/>
				</CodiceFiscale>
			</xsl:if>
			<Anagrafica>
				<xsl:if test="cac:PartyLegalEntity">
					<xsl:choose>
						<xsl:when test="contains(cac:PartyLegalEntity/cbc:RegistrationName,'Denominazione:')">
							<Denominazione>
								<xsl:value-of select="substring-after(cac:PartyLegalEntity/cbc:RegistrationName,'Denominazione:')"/>
							</Denominazione>
						</xsl:when>
						<xsl:when test="contains(cac:PartyLegalEntity/cbc:RegistrationName,'Nome#Cognome')">
							<Nome>
								<xsl:value-of select="substring-before(substring-after(cac:PartyLegalEntity/cbc:RegistrationName,':'),'#')"/>
							</Nome>
							<Cognome>
								<xsl:value-of select="substring-after(substring-after(cac:PartyLegalEntity/cbc:RegistrationName,':'),'#')"/>
							</Cognome>
						</xsl:when>
						<xsl:when test="contains(cac:PartyLegalEntity/cbc:RegistrationName,'NomeCognome')">
							<Nome>
								<xsl:value-of select="substring-after(cac:PartyLegalEntity/cbc:RegistrationName,':')"/>
							</Nome>
							<Cognome>
								<xsl:value-of select="substring-after(cac:PartyLegalEntity/cbc:RegistrationName,':')"/>
							</Cognome>
						</xsl:when>
						<xsl:otherwise>
							<Denominazione>
								<xsl:value-of select="cac:PartyLegalEntity/cbc:RegistrationName"/>
							</Denominazione>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:if>
				<xsl:if test="contains(./cac:PartyIdentification/cbc:ID[contains(., 'EORI:')],'EORI:')">
					<CodEORI>
						<xsl:value-of select="substring-after(./cac:PartyIdentification/cbc:ID[contains(., 'EORI:')],'EORI:')"/>
					</CodEORI>
				</xsl:if>
			</Anagrafica>
		</DatiAnagrafici>
	</xsl:template>
	<xsl:template match="cac:Party/cac:AgentParty/cac:PostalAddress" mode="CedentePrestatore_StabileOrganizzazione">
		<xsl:param name="CN" select="."/>
		<xsl:param name="CNP" select="1"/>
		<xsl:if test=".">
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
				<xsl:if test="cac:Country/cbc:IdentificationCode = 'IT'">
					<Provincia>
						<xsl:value-of select="cbc:CountrySubentity"/>
					</Provincia>
				</xsl:if>
				<Nazione>
					<xsl:value-of select="cac:Country/cbc:IdentificationCode"/>
				</Nazione>
			</StabileOrganizzazione>
		</xsl:if>
	</xsl:template>
	<xsl:template match="cac:Party/cac:Contact" mode="CedentePrestatore_Contatti">
		<xsl:param name="CN" select="."/>
		<xsl:param name="CNP" select="1"/>
		<xsl:if test=".">
			<Contatti>
				<xsl:if test="cbc:Telephone">
					<Telefono>
						<xsl:value-of select="cbc:Telephone"/>
					</Telefono>
				</xsl:if>
				<xsl:if test="cbc:ElectronicMail">
					<Email>
						<xsl:value-of select="cbc:ElectronicMail"/>
					</Email>
				</xsl:if>
			</Contatti>
		</xsl:if>
	</xsl:template>
	<xsl:template match="cac:Party/cac:PartyIdentification" mode="IscrizioneREA">
		<xsl:param name="CN" select="."/>
		<xsl:param name="CNP" select="1"/>
		<xsl:if test="contains(cbc:ID[contains(., 'REA:')],'REA:')">
			<IscrizioneREA>
				<Ufficio>
					<xsl:value-of select="substring-after(substring-before(./cbc:ID[contains(., 'REA:')],'#'),':')"/>
				</Ufficio>
				<NumeroREA>
					<xsl:value-of select="substring-after(./cbc:ID[contains(., 'REA:')],'#')"/>
				</NumeroREA>
				<xsl:if test="/in:CreditNote/cac:AccountingSupplierParty/cac:Party/cac:PartyLegalEntity">
					<CapitaleSociale>
						<xsl:value-of select="format-number(number(substring-before(/in:CreditNote/cac:AccountingSupplierParty/cac:Party/cac:PartyLegalEntity/cbc:CompanyLegalForm,'#')),'###########0.00')"/>
					</CapitaleSociale>
					<SocioUnico>
						<xsl:text>SU</xsl:text>
					</SocioUnico>
					<StatoLiquidazione>
						<xsl:value-of select="substring-after(substring-after(/in:CreditNote/cac:AccountingSupplierParty/cac:Party/cac:PartyLegalEntity/cbc:CompanyLegalForm,'#'),'#')"/>
					</StatoLiquidazione>
				</xsl:if>
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
			<xsl:if test="string(number(cbc:AdditionalStreetName)) != 'NaN'">
				<NumeroCivico>
					<xsl:value-of select="cbc:AdditionalStreetName"/>
				</NumeroCivico>
			</xsl:if>
			<xsl:if test="cbc:PostalZone">
				<CAP>
					<xsl:value-of select="cbc:PostalZone"/>
				</CAP>
			</xsl:if>
			<xsl:if test="cbc:CityName">
				<Comune>
					<xsl:value-of select="cbc:CityName"/>
				</Comune>
			</xsl:if>
			<xsl:if test="cac:Country/cbc:IdentificationCode = 'IT'">
				<Provincia>
					<xsl:value-of select="cbc:CountrySubentity"/>
				</Provincia>
			</xsl:if>
			<Nazione>
				<xsl:value-of select="cac:Country/cbc:IdentificationCode"/>
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
				<xsl:if test="string(number(cbc:AdditionalStreetName)) != 'NaN'">
					<NumeroCivico>
						<xsl:value-of select="cbc:AdditionalStreetName"/>
					</NumeroCivico>
				</xsl:if>
				<xsl:if test="cbc:PostalZone">
					<CAP>
						<xsl:value-of select="cbc:PostalZone"/>
					</CAP>
				</xsl:if>
				<xsl:if test="cbc:CityName">
					<Comune>
						<xsl:value-of select="cbc:CityName"/>
					</Comune>
				</xsl:if>
				<xsl:if test="cac:Country/cbc:IdentificationCode = 'IT'">
					<Provincia>
						<xsl:value-of select="cbc:CountrySubentity"/>
					</Provincia>
				</xsl:if>
				<Nazione>
					<xsl:value-of select="cac:Country/cbc:IdentificationCode"/>
				</Nazione>
			</Sede>
		</xsl:if>
	</xsl:template>
	<xsl:template match="cac:PartyLegalEntity[cac:CorporateRegistrationScheme/cbc:Name!='REA' and cbc:CompanyID/@schemeID='ZZZ' and cac:RegistrationAddress/cbc:CityName]" mode="ProvinciaAlbo">
		<xsl:param name="CN" select="."/>
		<xsl:param name="CNP" select="1"/>
		<ProvinciaAlbo>
			<xsl:value-of select="cac:RegistrationAddress/cbc:CityName"/>
		</ProvinciaAlbo>
	</xsl:template>
	<xsl:template match="cac:PartyLegalEntity[cbc:CompanyID[@schemeID='ZZZ'] and cbc:RegistrationDate and cac:CorporateRegistrationScheme/cbc:Name!='REA']" mode="DataIscrizioneAlbo">
		<xsl:param name="CN" select="."/>
		<xsl:param name="CNP" select="1"/>
		<DataIscrizioneAlbo>
			<xsl:value-of select="&#x9;substring(string(cbc:RegistrationDate),1,10)"/>
		</DataIscrizioneAlbo>
	</xsl:template>
	<xsl:template match="cac:PartyTaxScheme[cac:TaxScheme/cbc:ID='VAT']/cbc:CompanyID[@schemeID = 'IT:CF']" mode="RappresentanteFiscale_CF">
		<xsl:param name="CN" select="."/>
		<xsl:param name="CNP" select="1"/>
		<xsl:if test="not(../../cac:Person[1]/cbc:ID[@schemeID='IT:CF'])">
			<CodiceFiscale>
				<xsl:value-of select="if (string-length(.) = 13) then substring(., 3) else ."/>
			</CodiceFiscale>
		</xsl:if>
	</xsl:template>
	<xsl:template match="cac:PartyTaxScheme[cac:TaxScheme/cbc:ID='VAT']/cbc:CompanyID[@schemeID = 'IT:CF']" mode="CessionarioCommittente_CF">
		<xsl:param name="CN" select="."/>
		<xsl:param name="CNP" select="1"/>
		<xsl:if test="not(../../cac:Person[1]/cbc:ID[@schemeID='IT:CF'])">
			<CodiceFiscale>
				<xsl:value-of select="if (string-length(.) = 13) then substring(., 3) else ."/>
			</CodiceFiscale>
		</xsl:if>
	</xsl:template>
	<xsl:template match="cac:PartyTaxScheme[cac:TaxScheme/cbc:ID='VAT']/cbc:CompanyID[@schemeID = 'IT:CF']" mode="Vettore_CF">
		<xsl:param name="CN" select="."/>
		<xsl:param name="CNP" select="1"/>
		<xsl:if test="not(../../cac:Person[1]/cbc:ID[@schemeID='IT:CF'])">
			<CodiceFiscale>
				<xsl:value-of select="if (string-length(.) = 13) then substring(., 3) else ."/>
			</CodiceFiscale>
		</xsl:if>
	</xsl:template>
	<xsl:template match="cac:PartyTaxScheme/cbc:CompanyID" mode="RappresentanteFiscale_PIVA">
		<xsl:param name="CN" select="."/>
		<xsl:param name="CNP" select="1"/>
		<IdFiscaleIVA>
			<IdPaese>
				<xsl:value-of select="substring(.,1,2)"/>
			</IdPaese>
			<IdCodice>
				<xsl:value-of select="substring(.,3,string-length(.)-2)"/>
			</IdCodice>
		</IdFiscaleIVA>
	</xsl:template>
	<xsl:template match="cac:PartyTaxScheme/cbc:CompanyID" mode="CessionarioCommittente_PIVA">
		<xsl:param name="CN" select="."/>
		<xsl:param name="CNP" select="1"/>
		<IdFiscaleIVA>
			<IdPaese>
				<xsl:value-of select="substring(.,1,2)"/>
			</IdPaese>
			<IdCodice>
				<xsl:value-of select="substring(.,3,string-length(.)-2)"/>
			</IdCodice>
		</IdFiscaleIVA>
	</xsl:template>
	<xsl:template match="cac:PartyTaxScheme[cac:TaxScheme/cbc:ID='VAT']/cbc:CompanyID[not(@schemeID = 'IT:CF')][1]" mode="Vettore_PIVA">
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
				<xsl:value-of select="(if (document($UNCL4461)//gc:Code[gc:Id=current()/cbc:PaymentMeansCode]/gc:LocalId[1]) then document($UNCL4461)//gc:Code[gc:Id=current()/cbc:PaymentMeansCode]/gc:LocalId[1] else 'MP05')"/>
			</ModalitaPagamento>
			<xsl:if test=" contains (/in:CreditNote/cac:PaymentTerms[1]/cbc:Note,'#')">
				<GiorniTerminiPagamento>
					<xsl:value-of select="substring-after(/in:CreditNote/cac:PaymentTerms[1]/cbc:Note,'#')"/>
				</GiorniTerminiPagamento>
			</xsl:if>
			<xsl:if test="/in:CreditNote/cbc:DueDate">
				<DataScadenzaPagamento>
					<xsl:value-of select="substring(string(/in:CreditNote/cbc:DueDate),1,10)"/>
				</DataScadenzaPagamento>
			</xsl:if>
			<ImportoPagamento>
				<xsl:value-of select="format-number(/in:CreditNote/cac:LegalMonetaryTotal/cbc:PayableAmount,'###########0.00')"/>
			</ImportoPagamento>
			<xsl:if test="cbc:PaymentMeansCode = 'ZZZ'">
				<xsl:if test="/in:CreditNote/cac:PayeeParty/cac:PartyIdentification">
					<CognomeQuietanzante>
						<xsl:value-of select="substring-after(/in:CreditNote/cac:PayeeParty/cac:PartyIdentification/cbc:ID,'#')"/>
					</CognomeQuietanzante>
					<NomeQuietanzante>
						<xsl:value-of select="substring-before(/in:CreditNote/cac:PayeeParty/cac:PartyIdentification/cbc:ID,'#')"/>
					</NomeQuietanzante>
					<CFQuietanzante>
						<xsl:value-of select="/in:CreditNote/cac:PayeeParty/cac:PartyLegalEntity/cbc:CompanyID"/>
					</CFQuietanzante>
				</xsl:if>
			</xsl:if>
			<xsl:if test="cac:PayeeFinancialAccount">
				<IBAN>
					<xsl:value-of select="cac:PayeeFinancialAccount/cbc:ID"/>
				</IBAN>
			</xsl:if>
			<xsl:if test="cac:PayeeFinancialAccount/cac:FinancialInstitutionBranch">
				<BIC>
					<xsl:value-of select="cac:PayeeFinancialAccount/cac:FinancialInstitutionBranch/cbc:ID"/>
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
				<xsl:apply-templates select="/in:CreditNote/cac:AdditionalDocumentReference[cbc:DocumentType='CommessaConvenzione_RICEZIONE']/cbc:ID" mode="DatiRicezione_CommessaConvenzione">
					<xsl:with-param name="CN" select="current()"/>
					<xsl:with-param name="CNP" select="position()"/>
				</xsl:apply-templates>
				<xsl:apply-templates select="/in:CreditNote/cac:AdditionalDocumentReference[cbc:DocumentType='CUP_RICEZIONE']/cbc:ID" mode="DatiRicezione_CUP">
					<xsl:with-param name="CN" select="current()"/>
					<xsl:with-param name="CNP" select="position()"/>
				</xsl:apply-templates>
				<xsl:apply-templates select="/in:CreditNote/cac:AdditionalDocumentReference[cbc:DocumentType='CIG_RICEZIONE']/cbc:ID" mode="DatiRicezione_CIG">
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
					<xsl:apply-templates select="cac:PartyTaxScheme/cbc:CompanyID" mode="RappresentanteFiscale_PIVA">
						<xsl:with-param name="CN" select="current()"/>
						<xsl:with-param name="CNP" select="position()"/>
					</xsl:apply-templates>
					<xsl:choose>
						<xsl:when test="contains(lower-case(cac:PartyIdentification/cbc:ID[contains(., 'CF:')]),'cf:')">
							<CodiceFiscale>
								<xsl:value-of select="substring-after(lower-case(cac:PartyIdentification/cbc:ID[contains(.,'CF:')]),'cf:')"/>
							</CodiceFiscale>
						</xsl:when>
						<xsl:when test="cac:PartyIdentification/cbc:ID[@schemeID='0210']">
							<CodiceFiscale>
								<xsl:value-of select="cac:PartyIdentification/cbc:ID[@schemeID='0210']"/>
							</CodiceFiscale>
						</xsl:when>
					</xsl:choose>
					<Anagrafica>
						<xsl:if test="cac:PartyName">
							<xsl:choose>
								<xsl:when test="contains(cac:PartyName/cbc:Name,'Denominazione:')">
									<Denominazione>
										<xsl:value-of select="substring-after(cac:PartyName/cbc:Name,'Denominazione:')"/>
									</Denominazione>
								</xsl:when>
								<xsl:when test="contains(cac:PartyName/cbc:Name,'Nome') and contains(cac:PartyName/cbc:Name,'Cognome')">
									<Nome>
										<xsl:value-of select="substring-before(substring-after(cac:PartyName/cbc:Name,':'),'#')"/>
									</Nome>
									<Cognome>
										<xsl:value-of select="substring-after(substring-after(cac:PartyName/cbc:Name,':'),'#')"/>
									</Cognome>
								</xsl:when>
								<xsl:otherwise>
									<Denominazione>
										<xsl:value-of select="cac:PartyName/cbc:Name"/>
									</Denominazione>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:if>
						<xsl:if test="contains(cac:PartyIdentification/cbc:ID[contains(., 'EORI:')],'EORI:')">
							<CodEORI>
								<xsl:value-of select="substring-after(cac:PartyIdentification/cbc:ID[contains(., 'EORI:')],'EORI:')"/>
							</CodEORI>
						</xsl:if>
					</Anagrafica>
				</DatiAnagrafici>
			</RappresentanteFiscale>
		</xsl:if>
	</xsl:template>
	<xsl:template match="cac:TaxTotal/cac:TaxSubtotal" mode="DatiRiepilogo">
		<xsl:param name="CN" select="."/>
		<xsl:param name="CNP" select="1"/>
			<xsl:if test="cac:TaxCategory/cbc:ID !='Z'">
			<DatiRiepilogo>
				<AliquotaIVA>
					<xsl:value-of select="if (cac:TaxCategory/cbc:Percent &gt;= 0) then format-number(cac:TaxCategory/cbc:Percent,'##0.00') else '0.00'"/>
				</AliquotaIVA>
				<!-- Conversione Natura domestica-->
				<xsl:if test="cac:TaxCategory/cbc:ID and (/in:CreditNote/cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode ='IT') and (/in:CreditNote/cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode ='IT')">
					<xsl:choose>
						<xsl:when test="cac:TaxCategory/cbc:ID !='Z' and cac:TaxCategory/cbc:ID !='B' and cac:TaxCategory/cbc:ID !='S'">
							<xsl:if test="contains(cac:TaxCategory/cbc:TaxExemptionReason,'#')">
								<Natura>
									<xsl:value-of select="substring-before(cac:TaxCategory/cbc:TaxExemptionReason,'#')"/>
								</Natura>
							</xsl:if>
							<xsl:if test="not(contains(cac:TaxCategory/cbc:TaxExemptionReason,'#'))">
								<Natura>
									<xsl:value-of select="cac:TaxCategory/cbc:TaxExemptionReason"/>
								</Natura>
							</xsl:if>
						</xsl:when>
						<xsl:when test="cac:TaxCategory/cbc:ID ='Z'">
							<Natura>
								<xsl:text>N1</xsl:text>
							</Natura>
						</xsl:when>
					</xsl:choose>
				</xsl:if>
				<!-- Conversione Natura cross-border-->
				<xsl:if test="cac:TaxCategory/cbc:ID and ((/in:CreditNote/cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode !='IT') or (/in:CreditNote/cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode !='IT'))">
					<xsl:choose>
						<xsl:when test="cac:TaxCategory/cbc:ID ='Z'">
							<Natura>
								<xsl:text>N1</xsl:text>
							</Natura>
						</xsl:when>
						<xsl:when test="cac:TaxCategory/cbc:ID ='E'">
							<Natura>
								<xsl:text>N2.2</xsl:text>
							</Natura>
						</xsl:when>
						<xsl:when test="cac:TaxCategory/cbc:ID ='G'">
							<Natura>
								<xsl:text>N3.1</xsl:text>
							</Natura>
						</xsl:when>
						<xsl:when test="cac:TaxCategory/cbc:ID ='K'">
							<Natura>
								<xsl:text>N3.2</xsl:text>
							</Natura>
						</xsl:when>
						<xsl:when test="cac:TaxCategory/cbc:ID ='AE'">
							<Natura>
								<xsl:text>N6.9</xsl:text>
							</Natura>
						</xsl:when>
					</xsl:choose>
				</xsl:if>
				<xsl:choose>
					<xsl:when test="/*/ext:UBLExtensions/ext:UBLExtension[ExtensionURI='urn:fdc:agid.gov.it:fatturapa:RiepilogoIVA:Arrotondamento']">
						<xsl:apply-templates select="/*/ext:UBLExtensions/ext:UBLExtension" mode="RiepilogoArrotondamento">
							<xsl:with-param name="CN" select="current()"/>
							<xsl:with-param name="CNP" select="position()"/>
						</xsl:apply-templates>
					</xsl:when>
					<xsl:when test=" format-number(cbc:TaxAmount,'###########0.00000000') != format-number(cbc:TaxableAmount * cac:TaxCategory/cbc:Percent div 100.00,'###########0.00000000')">
						<Arrotondamento>
							<xsl:value-of select="format-number((cbc:TaxAmount - (cbc:TaxableAmount * cac:TaxCategory/cbc:Percent div 100.00)),'###########0.00000000')"/>
						</Arrotondamento>
					</xsl:when>
				</xsl:choose>
				<ImponibileImporto>
					<xsl:value-of select="format-number(floor(cbc:TaxableAmount * 100 + 0.5) div 100,'###########0.00')"/>
				</ImponibileImporto>
				<Imposta>
					<xsl:value-of select="format-number(floor(cbc:TaxAmount * 100 + 0.5) div 100,'###########0.00')"/>
				</Imposta>
				<xsl:if test="cac:TaxCategory/cbc:ID ='B'">
					<EsigibilitaIVA>
						<xsl:text>S</xsl:text>
					</EsigibilitaIVA>
				</xsl:if>
				<xsl:if test="/in:CreditNote/cac:InvoicePeriod/cbc:DescriptionCode='3'">
					<EsigibilitaIVA>
						<xsl:text>I</xsl:text>
					</EsigibilitaIVA>
				</xsl:if>
				<xsl:if test="/in:CreditNote/cac:InvoicePeriod/cbc:DescriptionCode='35'">
					<EsigibilitaIVA>
						<xsl:text>I</xsl:text>
					</EsigibilitaIVA>
				</xsl:if>
				<xsl:if test="/in:CreditNote/cac:InvoicePeriod/cbc:DescriptionCode='432'">
					<EsigibilitaIVA>
						<xsl:text>D</xsl:text>
					</EsigibilitaIVA>
				</xsl:if>
				<xsl:if test="cac:TaxCategory/cbc:ID ='Z'">
					<RiferimentoNormativo>
						<xsl:text>Operazione esclusa ex. art. 15</xsl:text>
					</RiferimentoNormativo>
				</xsl:if>
				<xsl:if test="cac:TaxCategory/cbc:ID !='Z' and contains(cac:TaxCategory/cbc:TaxExemptionReason,'#')">
					<RiferimentoNormativo>
						<xsl:value-of select="substring-after(cac:TaxCategory/cbc:TaxExemptionReason,'#')"/>
					</RiferimentoNormativo>
				</xsl:if>
			</DatiRiepilogo>
			</xsl:if>
	</xsl:template>
	<xsl:template match="/in:CreditNote/cac:AccountingSupplierParty/cac:Party" mode="RitenutaPersoneFisiche2">
		<xsl:param name="CN" select="."/>
		<xsl:param name="CNP" select="1"/>
		<xsl:if test="cac:Person and not(/*/ext:UBLExtensions/ext:UBLExtension[starts-with(ext:ExtensionURI,'urn:www.ubl-italia.org:spec:fatturapa:xref:tipo_ritenuta')])">
			<TipoRitenuta>
				<xsl:text>RT01</xsl:text>
			</TipoRitenuta>
		</xsl:if>
	</xsl:template>
	<xsl:template match="cac:Item/cac:AdditionalItemProperty" mode="TipoCessionePrestazione">
		<xsl:param name="CN" select="."/>
		<xsl:param name="CNP" select="1"/>
		<xsl:if test="contains(./cbc:Name,'TipoCessionePrestazione')">
			<TipoCessionePrestazione>
				<xsl:value-of select="./cbc:Value"/>
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
	<xsl:template match="/in:CreditNote/cac:AccountingSupplierParty" mode="IdService">
		<xsl:param name="CN" select="."/>
		<xsl:param name="CNP" select="1"/>
		<xsl:if test=" ./cac:Party/cac:ServiceProviderParty and substring(./cac:Party/cac:ServiceProviderParty/cac:Party/cac:PartyTaxScheme/cbc:CompanyID,1,2)='IT'">
			<xsl:choose>
				<xsl:when test="./cac:Party/cac:ServiceProviderParty/cac:Party/cac:PartyIdentification/cbc:ID[@schemeID='0210']">
					<IdPaese>
						<xsl:text>IT</xsl:text>
					</IdPaese>
					<IdCodice>
						<xsl:value-of select="./cac:Party/cac:ServiceProviderParty/cac:Party/cac:PartyIdentification/cbc:ID[@schemeID='0210']"/>
					</IdCodice>
				</xsl:when>
				<xsl:when test="starts-with(./cac:Party/cac:ServiceProviderParty/cac:Party/cac:PartyIdentification/cbc:ID[contains(., 'CF:')],'CF:')">
					<IdPaese>
						<xsl:text>IT</xsl:text>
					</IdPaese>
					<IdCodice>
						<xsl:value-of select="substring-after(./cac:Party/cac:ServiceProviderParty/cac:Party/cac:PartyIdentification/cbc:ID[contains(., 'CF:')],'CF:')"/>
					</IdCodice>
				</xsl:when>
			</xsl:choose>
		</xsl:if>
		<xsl:if test=" ./cac:Party/cac:ServiceProviderParty and substring(./cac:Party/cac:ServiceProviderParty/cac:Party/cac:PartyTaxScheme/cbc:CompanyID,1,2) !='IT'">
			<IdPaese>
				<xsl:value-of select="substring(./cac:Party/cac:ServiceProviderParty/cac:Party/cac:PartyTaxScheme/cbc:CompanyID,1,2)"/>
			</IdPaese>
			<IdCodice>
				<xsl:value-of select="substring(./cac:Party/cac:ServiceProviderParty/cac:Party/cac:PartyTaxScheme/cbc:CompanyID,3,string-length(./cac:Party/cac:ServiceProviderParty/cac:Party/cac:PartyTaxScheme/cbc:CompanyID)-2)"/>
			</IdCodice>
		</xsl:if>
		<xsl:if test="./cac:Party/cac:PartyTaxScheme/cbc:CompanyID and not(./cac:Party/cac:ServiceProviderParty) and (./cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode != 'IT')">
			<IdPaese>
				<xsl:value-of select="substring(./cac:Party/cac:PartyTaxScheme/cbc:CompanyID,1,2)"/>
			</IdPaese>
			<IdCodice>
				<xsl:value-of select="substring(./cac:Party/cac:PartyTaxScheme/cbc:CompanyID,3,string-length(./cac:Party/cac:PartyTaxScheme/cbc:CompanyID)-2)"/>
			</IdCodice>
		</xsl:if>
		<xsl:if test="./cac:Party/cac:PartyTaxScheme/cbc:CompanyID and not(./cac:Party/cac:ServiceProviderParty) and ./cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode = 'IT'">
			<xsl:if test="./cac:Party/cac:PartyLegalEntity/cbc:CompanyID[@schemeID='0210']">
				<IdPaese>
					<xsl:text>IT</xsl:text>
				</IdPaese>
			</xsl:if>
			<xsl:if test="not(./cac:Party/cac:PartyLegalEntity/cbc:CompanyID[@schemeID='0210'])">
				<IdPaese>
					<xsl:value-of select="./cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode"/>
				</IdPaese>
			</xsl:if>
			<IdCodice>
				<xsl:value-of select="./cac:Party/cac:PartyLegalEntity/cbc:CompanyID"/>
			</IdCodice>
		</xsl:if>
	</xsl:template>
	<xsl:template match="cac:AccountingSupplierParty/cac:Party/cac:ServiceProviderParty" mode="ServiceProviderParty_info">
		<xsl:param name="CN" select="."/>
		<xsl:param name="CNP" select="1"/>
		<TerzoIntermediarioOSoggettoEmittente>
			<DatiAnagrafici>
				<IdFiscaleIVA>
					<IdPaese>
						<xsl:value-of select="substring(./cac:Party/cac:PartyTaxScheme/cbc:CompanyID,1,2)"/>
					</IdPaese>
					<IdCodice>
						<xsl:value-of select="substring(./cac:Party/cac:PartyTaxScheme/cbc:CompanyID,3,string-length(./cac:Party/cac:PartyTaxScheme/cbc:CompanyID)-2)"/>
					</IdCodice>
				</IdFiscaleIVA>
				<xsl:choose>
					<xsl:when test="./cac:Party/cac:PartyIdentification/cbc:ID[@schemeID='0210']">
						<CodiceFiscale>
							<xsl:value-of select="./cac:Party/cac:PartyIdentification/cbc:ID[@schemeID='0210']"/>
						</CodiceFiscale>
					</xsl:when>
					<xsl:when test="contains(lower-case(./cac:Party/cac:PartyIdentification/cbc:ID[contains(., 'CF:')]),'cf:')">
						<CodiceFiscale>
							<xsl:value-of select="substring-after(lower-case(./cac:Party/cac:PartyIdentification/cbc:ID[contains(., 'CF:')]),'cf:')"/>
						</CodiceFiscale>
					</xsl:when>
				</xsl:choose>
				<xsl:choose>
					<xsl:when test="./cac:Party/cac:PartyName/cbc:Name">
						<Anagrafica>
							<Denominazione>
								<xsl:value-of select="./cac:Party/cac:PartyName/cbc:Name"/>
							</Denominazione>
							<xsl:if test="contains(./cac:Party/cac:PartyIdentification/cbc:ID[contains(., 'EORI:')],'EORI:')">
								<CodEORI>
									<xsl:value-of select="substring-after(./cac:Party/cac:PartyIdentification/cbc:ID[contains(., 'EORI:')],'EORI:')"/>
								</CodEORI>
							</xsl:if>
						</Anagrafica>
					</xsl:when>
					<xsl:when test="./cac:Party/cac:Person">
						<Anagrafica>
							<Nome>
								<xsl:value-of select="./cac:Party/cac:Person/cbc:FirstName"/>
							</Nome>
							<Cognome>
								<xsl:value-of select="./cac:Party/cac:Person/cbc:FamilyName"/>
							</Cognome>
							<xsl:if test="contains(./cac:Party/cac:PartyIdentification/cbc:ID[contains(., 'EORI:')],'EORI:')">
								<CodEORI>
									<xsl:value-of select="substring-after(./cac:Party/cac:PartyIdentification/cbc:ID[contains(., 'EORI:')],'EORI:')"/>
								</CodEORI>
							</xsl:if>
						</Anagrafica>
					</xsl:when>
				</xsl:choose>
			</DatiAnagrafici>
		</TerzoIntermediarioOSoggettoEmittente>
	</xsl:template>
	<xsl:template match="/in:CreditNote" name="root">
		<xsl:param name="CN" select="."/>
		<xsl:param name="CNP" select="1"/>
		<nx:FatturaElettronica>
			<xsl:variable name="variable_d1e1a1049877">
				<xsl:value-of select="normalize-space(ext:UBLExtensions/ext:UBLExtension[ext:ExtensionURI='urn:fdc:agid.gov.it:fatturapa:SistemaEmittente']/ext:ExtensionContent/cbc:Description)"/>
			</xsl:variable>
			<xsl:if test="string($variable_d1e1a1049877)">
				<xsl:attribute name="SistemaEmittente">
					<xsl:value-of select="string($variable_d1e1a1049877)"/>
				</xsl:attribute>
			</xsl:if>
			<xsl:variable name="variable_d1e1a1050311">
				<xsl:value-of select="if (cac:AccountingCustomerParty/cac:Party/cbc:EndpointID[@schemeID='0201']) then 'FPA12' else 'FPR12'"/>
			</xsl:variable>
			<xsl:if test="string($variable_d1e1a1050311)">
				<xsl:attribute name="versione">
					<xsl:value-of select="string($variable_d1e1a1050311)"/>
				</xsl:attribute>
			</xsl:if>
			<FatturaElettronicaHeader>
				<DatiTrasmissione>
					<IdTrasmittente>
						<xsl:apply-templates select="/in:CreditNote/cac:AccountingSupplierParty" mode="IdService">
							<xsl:with-param name="CN" select="current()"/>
							<xsl:with-param name="CNP" select="position()"/>
						</xsl:apply-templates>
					</IdTrasmittente>
					<ProgressivoInvio>
						<xsl:value-of select="$progInvio"/>
					</ProgressivoInvio>
					<xsl:if test="cac:AccountingCustomerParty/cac:Party/cbc:EndpointID[@schemeID='0201']">
						<FormatoTrasmissione>
							<xsl:text>FPA12</xsl:text>
						</FormatoTrasmissione>
					</xsl:if>
					<xsl:if test="not(cac:AccountingCustomerParty/cac:Party/cbc:EndpointID[@schemeID='0201'])">
						<FormatoTrasmissione>
							<xsl:text>FPR12</xsl:text>
						</FormatoTrasmissione>
					</xsl:if>
					<xsl:choose>
						<xsl:when test="cac:AccountingCustomerParty/cac:Party/cbc:EndpointID[@schemeID='0201']">
							<CodiceDestinatario>
								<xsl:value-of select="cac:AccountingCustomerParty/cac:Party/cbc:EndpointID"/>
							</CodiceDestinatario>
						</xsl:when>
						<xsl:when test="cac:AccountingCustomerParty/cac:Party/cbc:EndpointID[@schemeID='0205']">
							<CodiceDestinatario>
								<xsl:value-of select="cac:AccountingCustomerParty/cac:Party/cbc:EndpointID"/>
							</CodiceDestinatario>
						</xsl:when>
						<xsl:when test="cac:AccountingCustomerParty/cac:Party/cbc:EndpointID[@schemeID='0202']">
							<CodiceDestinatario>
								<xsl:text>0000000</xsl:text>
							</CodiceDestinatario>
							<PECDestinatario>
								<xsl:value-of select="cac:AccountingCustomerParty/cac:Party/cbc:EndpointID"/>
							</PECDestinatario>
						</xsl:when>
						<xsl:otherwise>
							<CodiceDestinatario>
								<xsl:text>XXXXXXX</xsl:text>
							</CodiceDestinatario>
						</xsl:otherwise>
					</xsl:choose>
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
				<xsl:apply-templates select="cac:AccountingSupplierParty/cac:Party/cac:ServiceProviderParty" mode="ServiceProviderParty_info">
					<xsl:with-param name="CN" select="current()"/>
					<xsl:with-param name="CNP" select="position()"/>
				</xsl:apply-templates>
				<xsl:if test="cac:AccountingSupplierParty/cac:Party/cac:ServiceProviderParty">
					<SoggettoEmittente>
						<xsl:text>TZ</xsl:text>
					</SoggettoEmittente>
				</xsl:if>
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
						<xsl:apply-templates select="/*/ext:UBLExtensions/ext:UBLExtension" mode="ProvaRitenuta">
							<xsl:with-param name="CN" select="current()"/>
							<xsl:with-param name="CNP" select="position()"/>
						</xsl:apply-templates>
						<xsl:apply-templates select="cac:AllowanceCharge" mode="BOLLO">
							<xsl:with-param name="CN" select="current()"/>
							<xsl:with-param name="CNP" select="position()"/>
						</xsl:apply-templates>
						<xsl:apply-templates select="/in:CreditNote/cac:AllowanceCharge" mode="ProvaCassaPrevidenziale">
							<xsl:with-param name="CN" select="current()"/>
							<xsl:with-param name="CNP" select="position()"/>
						</xsl:apply-templates>
						<xsl:apply-templates select="cac:AllowanceCharge" mode="SCONTOMAGGIORAZIONE">
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
						<xsl:if test="ext:UBLExtensions/ext:UBLExtension/ext:ExtensionURI='urn:fdc:agid.gov.it:fatturapa:Art73'">
							<Art73>
								<xsl:text>SI</xsl:text>
							</Art73>
						</xsl:if>
					</DatiGeneraliDocumento>
					<xsl:apply-templates select="cac:OrderReference">
						<xsl:with-param name="CN" select="current()"/>
						<xsl:with-param name="CNP" select="position()"/>
					</xsl:apply-templates>
					<xsl:apply-templates select="cac:InvoiceLine/cac:OrderLineReference" mode="DatiOrdineAcquisto_Riga2">
						<xsl:with-param name="CN" select="current()"/>
						<xsl:with-param name="CNP" select="position()"/>
					</xsl:apply-templates>
					<xsl:if test="not(cac:InvoiceLine/cac:OrderLineReference) and in:Invoice/cac:OrderReference">
						<DatiOrdineAcquisto>
							<IdDocumento>
								<xsl:value-of select="/in:Invoice/cac:OrderReference/cbc:ID"/>
							</IdDocumento>
							<xsl:if test="/in:Invoice/cbc:BuyerReference">
								<CodiceCommessaConvenzione>
									<xsl:value-of select="/in:Invoice/cbc:BuyerReference"/>
								</CodiceCommessaConvenzione>
							</xsl:if>
						</DatiOrdineAcquisto>
					</xsl:if>
					<xsl:apply-templates select="/in:CreditNote/cac:CreditNoteLine" mode="DatiContratto_Cius">
						<xsl:with-param name="CN" select="current()"/>
						<xsl:with-param name="CNP" select="position()"/>
					</xsl:apply-templates>
					<xsl:if test="/in:CreditNote/cac:ContractDocumentReference or /in:CreditNote/cac:OriginatorDocumentReference or /in:CreditNote/cac:ProjectReference ">
						<DatiContratto>
							<xsl:if test="/in:CreditNote/cac:ContractDocumentReference">
								<IdDocumento>
									<xsl:value-of select="/in:CreditNote/cac:ContractDocumentReference/cbc:ID"/>
								</IdDocumento>
							</xsl:if>
							<xsl:if test="not(/in:CreditNote/cac:ContractDocumentReference) and /in:CreditNote/cac:CreditNoteLine/cac:DocumentReference/cbc:ID[@schemeID='CT']">
								<IdDocumento>
									<xsl:value-of select="/in:CreditNote/cac:CreditNoteLine/cac:DocumentReference/cbc:ID[@schemeID='CT']"/>
								</IdDocumento>
							</xsl:if>
							<xsl:if test="not(/in:Invoice/cac:ContractDocumentReference) and not(/in:Invoice/cac:InvoiceLine/cac:DocumentReference/cbc:ID[@schemeID='CT'])">
								<IdDocumento>
									<xsl:text>NAN</xsl:text>
								</IdDocumento>
							</xsl:if>
							<xsl:if test="/in:CreditNote/cac:ProjectReference/cbc:ID">
								<CodiceCUP>
									<xsl:value-of select="/in:CreditNote/cac:ProjectReference/cbc:ID"/>
								</CodiceCUP>
							</xsl:if>
							<xsl:if test="/in:CreditNote/cac:OriginatorDocumentReference/cbc:ID">
								<CodiceCIG>
									<xsl:value-of select="/in:CreditNote/cac:OriginatorDocumentReference/cbc:ID"/>
								</CodiceCIG>
							</xsl:if>
						</DatiContratto>
					</xsl:if>
					<xsl:apply-templates select="/in:CreditNote/cac:CreditNoteLine" mode="DatiOrdine_Commessa_Prova">
						<xsl:with-param name="CN" select="current()"/>
						<xsl:with-param name="CNP" select="position()"/>
					</xsl:apply-templates>
					<xsl:if test=" /in:CreditNote/cac:AdditionalDocumentReference/cbc:ID[@schemeID='AVV']">
						<DatiConvenzione>
							<IdDocumento>
								<xsl:value-of select="/in:CreditNote/cac:AdditionalDocumentReference/cbc:ID[@schemeID='AVV']"/>
							</IdDocumento>
						</DatiConvenzione>
					</xsl:if>
					<xsl:apply-templates select="cac:ReceiptDocumentReference">
						<xsl:with-param name="CN" select="current()"/>
						<xsl:with-param name="CNP" select="position()"/>
					</xsl:apply-templates>
					<xsl:apply-templates select="cac:CreditNoteLine/cac:ReceiptLineReference" mode="DatiRicezione_Riga">
						<xsl:with-param name="CN" select="current()"/>
						<xsl:with-param name="CNP" select="position()"/>
					</xsl:apply-templates>
					<xsl:apply-templates select="cac:BillingReference/cac:InvoiceDocumentReference" mode="FatturaCollegata">
						<xsl:with-param name="CN" select="current()"/>
						<xsl:with-param name="CNP" select="position()"/>
					</xsl:apply-templates>
					<xsl:apply-templates select="cac:CreditNoteLine/cac:BillingReference" mode="DatiFattureCollegate_Riga">
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
					<xsl:apply-templates select="/in:CreditNote/cac:Delivery" mode='delivery'>
						<xsl:with-param name="CN" select="current()"/>
						<xsl:with-param name="CNP" select="position()"/>
					</xsl:apply-templates>
					<xsl:apply-templates select="cac:BillingReference/cac:AdditionalDocumentReference" mode="FatturaPrincipale">
						<xsl:with-param name="CN" select="current()"/>
						<xsl:with-param name="CNP" select="position()"/>
					</xsl:apply-templates>
				</DatiGenerali>
				<DatiBeniServizi>
					<xsl:apply-templates select="cac:CreditNoteLine">
						<xsl:with-param name="CN" select="current()"/>
						<xsl:with-param name="CNP" select="position()"/>
					</xsl:apply-templates>
					<xsl:for-each select="cac:AllowanceCharge">
						<xsl:if test="not (lower-case(cbc:AllowanceChargeReason)='bollo') and not(lower-case(cbc:AllowanceChargeReasonCode)='zzz')">
							<DettaglioLinee>
								<NumeroLinea>
									<xsl:text>9998</xsl:text>
								</NumeroLinea>
								<TipoCessionePrestazione>
									<xsl:text>SC</xsl:text>
								</TipoCessionePrestazione>
								<Descrizione>
									<xsl:value-of select="cbc:AllowanceChargeReason"/>
								</Descrizione>
								<Quantita>
									<xsl:text>1.00000000</xsl:text>
								</Quantita>
								<xsl:if test="cbc:ChargeIndicator='true'">
									<PrezzoUnitario>
										<xsl:value-of select="cbc:Amount"/>
									</PrezzoUnitario>
									<PrezzoTotale>
										<xsl:value-of select="cbc:Amount"/>
									</PrezzoTotale>
								</xsl:if>
								<xsl:if test="cbc:ChargeIndicator='false'">
									<PrezzoUnitario>
										<xsl:text>-</xsl:text>
										<xsl:value-of select="cbc:Amount"/>
									</PrezzoUnitario>
									<PrezzoTotale>
										<xsl:text>-</xsl:text>
										<xsl:value-of select="cbc:Amount"/>
									</PrezzoTotale>
								</xsl:if>
								<AliquotaIVA>
									<xsl:value-of select="if (cac:TaxCategory/cbc:Percent &gt;= 0) then format-number(cac:TaxCategory/cbc:Percent,'##0.00') else '0.00'"/>
								</AliquotaIVA>
								<Natura>N4</Natura>
							</DettaglioLinee>
						</xsl:if>
					</xsl:for-each>
					<xsl:apply-templates select="cac:TaxTotal/cac:TaxSubtotal" mode="DatiRiepilogo">
						<xsl:with-param name="CN" select="current()"/>
						<xsl:with-param name="CNP" select="position()"/>
					</xsl:apply-templates>
				</DatiBeniServizi>
				<xsl:if test="cac:PaymentMeans or cac:PaymentTerms or cac:PayeeParty/cac:PartyName">
					<DatiPagamento>
						<xsl:if test="contains(cac:PaymentTerms/cbc:Note,'#')">
							<CondizioniPagamento>
								<xsl:value-of select="substring-before(cac:PaymentTerms/cbc:Note,'#')"/>
							</CondizioniPagamento>
						</xsl:if>
						<xsl:if test="not(contains(cac:PaymentTerms/cbc:Note,'#'))">
							<CondizioniPagamento>
								<xsl:value-of select="cac:PaymentTerms/cbc:Note"/>
							</CondizioniPagamento>
						</xsl:if>
						<xsl:apply-templates select="cac:PaymentMeans">
							<xsl:with-param name="CN" select="current()"/>
							<xsl:with-param name="CNP" select="position()"/>
						</xsl:apply-templates>
					</DatiPagamento>
				</xsl:if>
				<xsl:apply-templates select="cac:AdditionalDocumentReference" mode="AllegatiBinari">
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
