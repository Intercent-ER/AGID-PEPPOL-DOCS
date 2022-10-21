<?xml version="1.0" encoding="UTF-8"?>
<!--Stylesheet synthesized using Javest A2A Mapper environment.-->
<xsl:stylesheet xmlns:ds="http://www.w3.org/2000/09/xmldsig#" xmlns:ext="urn:oasis:names:specification:ubl:schema:xsd:CommonExtensionComponents-2" xmlns="urn:oasis:names:specification:ubl:schema:xsd:CreditNote-2" xmlns:in="http://ivaservizi.agenziaentrate.gov.it/docs/xsd/fatture/v1.2" xmlns:xsmap="http://www.javest.com/ns/mapper/snippet" xmlns:asmap="http://www.javest.com/ns/mapper/snippet/attribute" xmlns:cac="urn:oasis:names:specification:ubl:schema:xsd:CommonAggregateComponents-2" xmlns:cbc="urn:oasis:names:specification:ubl:schema:xsd:CommonBasicComponents-2" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:ccts="urn:un:unece:uncefact:documentation:2" xmlns:cr="http://www.ubl-italia.org/ns/CrossReference" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:gc="urn:fdc:difi.no:2017:vefa:structure:CodeList-1" xmlns:doc="http://docs.oasis-open.org/codelist/ns/genericode/1.0/" xmlns:vs="urn:www.ubl-italia.org:spec:fatturapa:codelist:gc:VATSchemes" exclude-result-prefixes="xsmap asmap in ds" version="2.0">
	<xsl:output indent="no"/>
	<xsl:param name="UNECE" as="xsd:string">xcl/UNECERec20-11e.xml</xsl:param>
	<xsl:param name="TIPODOC" as="xsd:string">xcl/TipoDocumento.xml</xsl:param>
	<xsl:param name="ALLEGATO" as="xsd:string">xcl/FormatoAttachment.xml</xsl:param>
	<xsl:param name="VATSchemes" as="xsd:string">xcl/VATSchemes.xml</xsl:param>
	<xsl:param name="UNCL4461" as="xsd:string">xcl/UNCL4461.xml</xsl:param>
	<xsl:param name="NATURA" as="xsd:string">xcl/Natura_VATCategory_VATEX.xml</xsl:param>
	<!--
Processing starts at node: /in:FatturaElettronica
See the template rule at end of stylesheet for the default processing of 
the root node.
-->
	<xsl:template match="/in:FatturaElettronica/FatturaElettronicaHeader/SistemaEmittente" mode="SistemaEmittente">
		<xsl:param name="CN" select="."/>
		<xsl:param name="CNP" select="1"/>
		<xsl:if test=".">
			<ext:UBLExtension>
				<ext:ExtensionURI>
					<xsl:text>urn:fdc:agid.gov.it:fatturapa:SistemaEmittente</xsl:text>
				</ext:ExtensionURI>
				<ext:ExtensionContent>
					<cbc:Description>
						<xsl:value-of select="."/>
					</cbc:Description>
				</ext:ExtensionContent>
			</ext:UBLExtension>
		</xsl:if>
	</xsl:template>
	<xsl:template match="/in:FatturaElettronica/FatturaElettronicaHeader/SoggettoEmittente">
		<xsl:param name="CN" select="."/>
		<xsl:param name="CNP" select="1"/>
		<xsl:if test=".">
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
	<xsl:template match="/in:FatturaElettronica/FatturaElettronicaBody/DatiGenerali/DatiConvenzione/CodiceCIG" mode="CIG_Contratto_Riga">
		<xsl:param name="CN" select="."/>
		<xsl:param name="CNP" select="1"/>
		<xsl:if test="not(../../DatiContratto/CodiceCIG) and (../RiferimentoNumeroLinea[normalize-space()]=$CN/NumeroLinea[normalize-space()])">
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
	<xsl:template match="/in:FatturaElettronica/FatturaElettronicaBody/DatiGenerali/DatiOrdineAcquisto/CodiceCIG" mode="CIG_Contratto_Riga">
		<xsl:param name="CN" select="."/>
		<xsl:param name="CNP" select="1"/>
		<xsl:if test="not(../../DatiConvenzione/CodiceCIG) and not(../../DatiContratto/CodiceCIG) and (../RiferimentoNumeroLinea[normalize-space()]=$CN/NumeroLinea[normalize-space()])">
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
	<xsl:template match="/in:FatturaElettronica/FatturaElettronicaBody/DatiGenerali/DatiConvenzione/CodiceCUP" mode="CUP_Contratto_Riga">
		<xsl:param name="CN" select="."/>
		<xsl:param name="CNP" select="1"/>
		<xsl:if test="not(../../DatiContratto/CodiceCUP) and (../RiferimentoNumeroLinea[normalize-space()]=$CN/NumeroLinea[normalize-space()])">
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
	<xsl:template match="/in:FatturaElettronica/FatturaElettronicaBody/DatiGenerali/DatiOrdineAcquisto/CodiceCUP" mode="CUP_Contratto_Riga">
		<xsl:param name="CN" select="."/>
		<xsl:param name="CNP" select="1"/>
		<xsl:if test="not(../../DatiConvenzione/CodiceCUP) and not(../../DatiContratto/CodiceCUP) and (../RiferimentoNumeroLinea[normalize-space()]=$CN/NumeroLinea[normalize-space()])">
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
					<xsl:value-of select="if (NumItem) then NumItem else 'NA'"/>
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
	<xsl:template match="/in:FatturaElettronica/FatturaElettronicaBody/DatiGenerali/DatiConvenzione" mode="CodiceCommessaConvenzione_Convenzione_Riga">
		<xsl:param name="CN" select="."/>
		<xsl:param name="CNP" select="1"/>
		<xsl:if test="RiferimentoNumeroLinea[normalize-space()]=$CN/NumeroLinea[normalize-space()]">
			<cac:DocumentReference>
				<cbc:ID>
					<xsl:if test="CodiceCommessaConvenzione or IdDocumento">
						<xsl:attribute name="schemeID">
							<xsl:text>AVV</xsl:text>
						</xsl:attribute>
					</xsl:if>
					<xsl:choose>
						<xsl:when test="IdDocumento and not(IdDocumento = 'NA') and Data">
							<xsl:value-of select="IdDocumento"/> del <xsl:value-of select="Data"/>
						</xsl:when>
						<xsl:when test="IdDocumento and not(IdDocumento = 'NA') and not(Data)">
							<xsl:value-of select="IdDocumento"/>
						</xsl:when>
						<xsl:when test="CodiceCommessaConvenzione">
							<xsl:value-of select="CodiceCommessaConvenzione"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:text>NA</xsl:text>
						</xsl:otherwise>
					</xsl:choose>
				</cbc:ID>
				<cbc:DocumentTypeCode>
					<xsl:text>130</xsl:text>
				</cbc:DocumentTypeCode>
			</cac:DocumentReference>
		</xsl:if>
	</xsl:template>
	<xsl:template match="/in:FatturaElettronica/FatturaElettronicaBody/DatiGenerali/DatiOrdineAcquisto/CodiceCommessaConvenzione" mode="CodiceCommessaConvenzione_Riga">
		<xsl:param name="CN" select="."/>
		<xsl:param name="CNP" select="1"/>
		<xsl:if test="not(../../DatiConvenzione) and (. != '#NO#' and (../RiferimentoNumeroLinea[normalize-space()]=$CN/NumeroLinea[normalize-space()] or (../RiferimentoNumeroLinea and count(../../../DatiBeniServizi/DettaglioLinee)=1)))">
			<cac:DocumentReference>
				<cbc:ID>
					<xsl:if test=".">
						<xsl:attribute name="schemeID">
							<xsl:text>ON</xsl:text>
						</xsl:attribute>
					</xsl:if>
					<xsl:choose>
						<xsl:when test="string-length(.) - string-length(translate(., '#', '')) = 2 and not(starts-with(., '#')) and not(ends-with(., '#'))">
							<xsl:value-of select="."/>
						</xsl:when>
						<xsl:when test="starts-with(., '#') and ends-with(., '#')">
							<xsl:value-of select="concat(../IdDocumento, '#', ../Data, '#', substring(substring-after(., '#'), 1, string-length(.) - 2))"/>
						</xsl:when>
						<xsl:when test="starts-with(., '#')">
							<xsl:value-of select="concat(../IdDocumento, '#', ../Data, '#', substring-after(., '#'))"/>
						</xsl:when>
						<xsl:when test="ends-with(., '#')">
							<xsl:value-of select="concat(../IdDocumento, '#', ../Data, '#', substring(., 1, string-length(.) - 1))"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="concat(../IdDocumento, '#', ../Data, '#', .)"/>
						</xsl:otherwise>
					</xsl:choose>
				</cbc:ID>
				<cbc:DocumentTypeCode>
					<xsl:text>130</xsl:text>
				</cbc:DocumentTypeCode>
			</cac:DocumentReference>
		</xsl:if>
	</xsl:template>
	<xsl:template match="/in:FatturaElettronica/FatturaElettronicaBody/DatiGenerali/DatiContratto/CodiceCommessaConvenzione" mode="CodiceCommessaConvenzione_Contratto_Riga">
		<xsl:param name="CN" select="."/>
		<xsl:param name="CNP" select="1"/>
		<xsl:if test="not(../../DatiConvenzione) and not(../../DatiOrdineAcquisto/CodiceCommessaConvenzione) and (. != '#NO#' and (../RiferimentoNumeroLinea[normalize-space()]=$CN/NumeroLinea[normalize-space()] or (../RiferimentoNumeroLinea and count(../../../DatiBeniServizi/DettaglioLinee)=1)))">
			<cac:DocumentReference>
				<cbc:ID>
					<xsl:if test=".">
						<xsl:attribute name="schemeID">
							<xsl:text>ON</xsl:text>
						</xsl:attribute>
					</xsl:if>
					<xsl:choose>
						<xsl:when test="string-length(.) - string-length(translate(., '#', '')) = 2 and not(starts-with(., '#')) and not(ends-with(., '#'))">
							<xsl:value-of select="."/>
						</xsl:when>
						<xsl:when test="starts-with(., '#') and ends-with(., '#')">
							<xsl:value-of select="concat(../IdDocumento, '#', ../Data, '#', substring(substring-after(., '#'), 1, string-length(.) - 2))"/>
						</xsl:when>
						<xsl:when test="starts-with(., '#')">
							<xsl:value-of select="concat(../IdDocumento, '#', ../Data, '#', substring-after(., '#'))"/>
						</xsl:when>
						<xsl:when test="ends-with(., '#')">
							<xsl:value-of select="concat(../IdDocumento, '#', ../Data, '#', substring(., 1, string-length(.) - 1))"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="concat(../IdDocumento, '#', ../Data, '#', .)"/>
						</xsl:otherwise>
					</xsl:choose>
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
		<xsl:if test="DataOraConsegna or NumeroColli &gt; 0 or DataInizioTrasporto or IndirizzoResa or DatiAnagraficiVettore or PesoLordo &gt; 0.00 or PesoNetto &gt; 0.00">
			<cac:Delivery>
				<xsl:if test="DataOraConsegna">
					<cbc:ActualDeliveryDate>
						<xsl:if test="contains(DataOraConsegna, 'T')">
							<xsl:value-of select="substring-before(DataOraConsegna, 'T')"/>
						</xsl:if>
						<xsl:if test="not(contains(DataOraConsegna, 'T'))">
							<xsl:value-of select="DataOraConsegna"/>
						</xsl:if>
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
								<cbc:RequestedDespatchDate>
									<xsl:value-of select="substring-before(DataOraRitiro, 'T')"/>
								</cbc:RequestedDespatchDate>
								<cbc:RequestedDespatchTime>
									<xsl:value-of select="substring-after(DataOraRitiro, 'T')"/>
								</cbc:RequestedDespatchTime>
							</xsl:if>
							<xsl:if test="not(contains(DataOraRitiro, 'T'))">
								<cbc:RequestedDespatchDate>
									<xsl:value-of select="DataOraRitiro"/>
								</cbc:RequestedDespatchDate>
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
					<xsl:attribute name="schemeID">
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
	<xsl:template match="FatturaElettronicaBody/DatiGenerali/DatiOrdineAcquisto[not(RiferimentoNumeroLinea)][1]">
		<xsl:if test="not(RiferimentoNumeroLinea)">
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
	<xsl:template match="FatturaElettronicaBody/DatiGenerali/DatiFattureCollegate[not(RiferimentoNumeroLinea)]">
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
		</cac:BillingReference>
	</xsl:template>
	<xsl:template match="FatturaElettronicaBody/DatiGenerali/DatiDDT[not(RiferimentoNumeroLinea)][1]">
		<cac:DespatchDocumentReference>
			<cbc:ID>
				<xsl:value-of select="NumeroDDT"/>
			</cbc:ID>
			<cbc:IssueDate>
				<xsl:value-of select="DataDDT"/>
			</cbc:IssueDate>
		</cac:DespatchDocumentReference>
	</xsl:template>
	<xsl:template match="FatturaElettronicaBody/DatiGenerali/DatiRicezione[1]">
		<cac:ReceiptDocumentReference>
			<cbc:ID>
				<xsl:value-of select="IdDocumento"/>
			</cbc:ID>
		</cac:ReceiptDocumentReference>
	</xsl:template>
	<xsl:template match="FatturaElettronicaBody/DatiGenerali/DatiContratto[not(RiferimentoNumeroLinea)][1]" mode="ID_Contratto">
		<xsl:if test="not(IdDocumento = 'Nan') and not (IdDocumento = 'NoREFCOntr') and not(IdDocumento = 'N/A') and not(Data)">
			<cac:ContractDocumentReference>
				<cbc:ID>
					<xsl:value-of select="IdDocumento"/>
				</cbc:ID>
			</cac:ContractDocumentReference>
		</xsl:if>
		<xsl:if test="not(IdDocumento = 'Nan') and not (IdDocumento = 'NoREFCOntr') and not(IdDocumento = 'N/A') and Data">
			<cac:ContractDocumentReference>
				<cbc:ID>
					<xsl:value-of select="IdDocumento"/> del <xsl:value-of select="Data"/>
				</cbc:ID>
			</cac:ContractDocumentReference>
		</xsl:if>
	</xsl:template>
	<xsl:template match="FatturaElettronicaBody/DatiGenerali/DatiConvenzione[not(RiferimentoNumeroLinea)]" mode="Codice_Commessa">
		<cac:AdditionalDocumentReference>
			<cbc:ID>
				<xsl:if test="CodiceCommessaConvenzione or IdDocumento">
					<xsl:attribute name="schemeID">
						<xsl:text>AVV</xsl:text>
					</xsl:attribute>
				</xsl:if>
				<xsl:choose>
					<xsl:when test="IdDocumento and not(IdDocumento = 'NA') and Data">
						<xsl:value-of select="IdDocumento"/> del <xsl:value-of select="Data"/>
					</xsl:when>
					<xsl:when test="IdDocumento and not(IdDocumento = 'NA') and not(Data)">
						<xsl:value-of select="IdDocumento"/>
					</xsl:when>
					<xsl:when test="CodiceCommessaConvenzione">
						<xsl:value-of select="CodiceCommessaConvenzione"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:text>NA</xsl:text>
					</xsl:otherwise>
				</xsl:choose>
			</cbc:ID>
			<cbc:DocumentTypeCode>
				<xsl:text>130</xsl:text>
			</cbc:DocumentTypeCode>
		</cac:AdditionalDocumentReference>
	</xsl:template>
	<xsl:template match="FatturaElettronicaBody/DatiGenerali/DatiContratto[not(RiferimentoNumeroLinea)]/CodiceCommessaConvenzione" mode="Codice_Commessa">
		<xsl:if test="not(../../DatiConvenzione)">
			<cac:AdditionalDocumentReference>
				<cbc:ID>
					<xsl:attribute name="schemeID">
						<xsl:text>AVV</xsl:text>
					</xsl:attribute>
					<xsl:value-of select="."/>
				</cbc:ID>
				<cbc:DocumentTypeCode>
					<xsl:text>130</xsl:text>
				</cbc:DocumentTypeCode>
			</cac:AdditionalDocumentReference>
		</xsl:if>
	</xsl:template>
	<xsl:template match="FatturaElettronicaBody/DatiGenerali/DatiOrdineAcquisto[not(RiferimentoNumeroLinea)]/CodiceCommessaConvenzione" mode="Codice_Commessa">
		<xsl:if test="not(../../DatiContratto/CodiceCommessaConvenzione) and not(../../DatiConvenzione)">
			<cac:AdditionalDocumentReference>
				<cbc:ID>
					<xsl:attribute name="schemeID">
						<xsl:text>AVV</xsl:text>
					</xsl:attribute>
					<xsl:value-of select="."/>
				</cbc:ID>
				<cbc:DocumentTypeCode>
					<xsl:text>130</xsl:text>
				</cbc:DocumentTypeCode>
			</cac:AdditionalDocumentReference>
		</xsl:if>
	</xsl:template>
	<xsl:template match="FatturaElettronicaBody/DatiGenerali/DatiContratto[not(RiferimentoNumeroLinea)][1]/CodiceCUP">
		<cac:AdditionalDocumentReference>
			<cbc:ID>
				<xsl:if test=".">
					<xsl:value-of select="."/>
				</xsl:if>
			</cbc:ID>
			<cbc:DocumentTypeCode>
				<xsl:text>50</xsl:text>
			</cbc:DocumentTypeCode>
		</cac:AdditionalDocumentReference>
	</xsl:template>
	<xsl:template match="FatturaElettronicaBody/DatiGenerali/DatiConvenzione[not(RiferimentoNumeroLinea)][1]/CodiceCUP">
		<xsl:if test="not(../../DatiContratto/CodiceCUP)">
			<cac:AdditionalDocumentReference>
				<cbc:ID>
					<xsl:if test=".">
						<xsl:value-of select="../CodiceCUP"/>
					</xsl:if>
				</cbc:ID>
				<cbc:DocumentTypeCode>
					<xsl:text>50</xsl:text>
				</cbc:DocumentTypeCode>
			</cac:AdditionalDocumentReference>
		</xsl:if>
	</xsl:template>
	<xsl:template match="FatturaElettronicaBody/DatiGenerali/DatiOrdineAcquisto[not(RiferimentoNumeroLinea)][1]/CodiceCUP">
		<xsl:if test="not(../../DatiContratto/CodiceCUP) and not(../../DatiConvenzione/CodiceCUP)">
			<cac:AdditionalDocumentReference>
				<cbc:ID>
					<xsl:if test=".">
						<xsl:value-of select="../CodiceCUP"/>
					</xsl:if>
				</cbc:ID>
				<cbc:DocumentTypeCode>
					<xsl:text>50</xsl:text>
				</cbc:DocumentTypeCode>
			</cac:AdditionalDocumentReference>
		</xsl:if>
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
			<cbc:DocumentTypeCode>
				<xsl:text>130</xsl:text>
			</cbc:DocumentTypeCode>
		</cac:AdditionalDocumentReference>
	</xsl:template>
	<xsl:template match="FatturaElettronicaBody/Allegati">
		<xsl:if test="not(NomeAttachment = 'not-mapped-values.txt') and not(NomeAttachment = 'fattura_originale') and not(NomeAttachment = 'trimmed_fields.csv')">
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
						<xsl:variable name="mimecode_value">
							<xsl:value-of select="if (document($ALLEGATO)//doc:Code[doc:LocalId=current()/upper-case(if (FormatoAttachment) then FormatoAttachment else (if (matches(NomeAttachment, '\.[a-zA-Z]{3,4}$')) then tokenize(NomeAttachment, '\.')[last()] else 'BIN'))][1]/doc:Id) then (document($ALLEGATO)//doc:Code[doc:LocalId=current()/upper-case(if (FormatoAttachment) then FormatoAttachment else (if (matches(NomeAttachment, '\.[a-zA-Z]{3,4}$')) then tokenize(NomeAttachment, '\.')[last()] else 'BIN'))][1]/doc:Id) else 'application/octet-stream'"/>
						</xsl:variable>
						<xsl:attribute name="mimeCode">
							<xsl:choose>
								<xsl:when test="FormatoAttachment = 'TXT'">
									<xsl:text>text/csv</xsl:text>
								</xsl:when>
								<xsl:when test="$mimecode_value">
									<xsl:value-of select="$mimecode_value"/>
								</xsl:when>
								<xsl:otherwise>
									<xsl:attribute name="mimeCode">
										<xsl:text>x</xsl:text>
									</xsl:attribute>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:attribute>
						<xsl:if test=".">
							<xsl:attribute name="filename">
								<xsl:value-of select="NomeAttachment"/>
							</xsl:attribute>
						</xsl:if>
						<xsl:value-of select="Attachment"/>
					</cbc:EmbeddedDocumentBinaryObject>
				</cac:Attachment>
			</cac:AdditionalDocumentReference>
		</xsl:if>
	</xsl:template>
	<xsl:template match="FatturaElettronicaBody/DatiGenerali/DatiContratto[not(RiferimentoNumeroLinea)][1]" mode="Codice_CIG">
		<xsl:if test="CodiceCIG">
			<cac:OriginatorDocumentReference>
				<cbc:ID>
					<xsl:value-of select="CodiceCIG"/>
				</cbc:ID>
			</cac:OriginatorDocumentReference>
		</xsl:if>
	</xsl:template>
	<xsl:template match="FatturaElettronicaBody/DatiGenerali/DatiConvenzione[not(RiferimentoNumeroLinea)][1]/CodiceCIG">
		<xsl:if test="not(../../DatiContratto/CodiceCIG)">
			<cac:OriginatorDocumentReference>
				<cbc:ID>
					<xsl:value-of select="../CodiceCIG"/>
				</cbc:ID>
			</cac:OriginatorDocumentReference>
		</xsl:if>
	</xsl:template>
	<xsl:template match="FatturaElettronicaBody/DatiGenerali/DatiOrdineAcquisto[not(RiferimentoNumeroLinea)][1]/CodiceCIG">
		<xsl:if test="not(../../DatiContratto/CodiceCIG) and not(../../DatiConvenzione/CodiceCIG)">
			<cac:OriginatorDocumentReference>
				<cbc:ID>
					<xsl:value-of select="../CodiceCIG"/>
				</cbc:ID>
			</cac:OriginatorDocumentReference>
		</xsl:if>
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
							<xsl:when test="not(RiferimentoTesto) and not(RiferimentoNumero) and not(RiferimentoData)">NA</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="concat(RiferimentoTesto, RiferimentoNumero, RiferimentoData)"/>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:otherwise>
				</xsl:choose>
			</cbc:Value>
		</cac:AdditionalItemProperty>
	</xsl:template>
	<xsl:template match="AltriDatiGestionali[upper-case(TipoDato)='NOTA']" mode="Nota_AltriDatiGestionali">
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
				<xsl:value-of select="(document($VATSchemes)//vs:Code[vs:LocalId=current()/upper-case(IdPaese)[1]]/vs:Id)"/>
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
					<xsl:value-of select="(document($VATSchemes)//vs:Code[vs:LocalId=current()/upper-case(IdPaese)[1]]/vs:Id)"/>
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
						<xsl:value-of select="format-number(Arrotondamento, '###########0.00')"/>
					</cbc:Amount>
				</ext:ExtensionContent>
			</ext:UBLExtension>
		</xsl:if>
	</xsl:template>
	<xsl:template match="FatturaElettronicaBody/DatiGenerali/DatiGeneraliDocumento/DatiRitenuta">
		<xsl:param name="CN" select="."/>
		<xsl:param name="CNP" select="1"/>
		<ext:UBLExtension>
			<ext:ExtensionURI>
				<xsl:text>urn:fdc:agid.gov.it:fatturapa:Ritenuta</xsl:text>
			</ext:ExtensionURI>
			<ext:ExtensionContent>
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
						<xsl:value-of select="format-number(sum(/in:FatturaElettronica/FatturaElettronicaBody/DatiGenerali/DatiGeneraliDocumento/DatiRitenuta/ImportoRitenuta),'###########0.00')"/>
					</cbc:TaxAmount>
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
				</cac:WithholdingTaxTotal>
			</ext:ExtensionContent>
		</ext:UBLExtension>
	</xsl:template>
	<xsl:template match="DatiGenerali/DatiGeneraliDocumento/ScontoMaggiorazione">
		<xsl:param name="CN" select="."/>
		<xsl:param name="CNP" select="1"/>
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
						<xsl:if test="Tipo = 'SC'">
							<xsl:text>false</xsl:text>
						</xsl:if>
						<xsl:if test="Tipo = 'MG'">
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
						<xsl:if test="Importo">
							<xsl:value-of select="format-number(Importo, '###########0.00')"/>
						</xsl:if>
						<xsl:if test="not(Importo)">
							<xsl:choose>
								<xsl:when test="../../DatiPagamento[1]/DettaglioPagamento/ImportoPagamento">
									<xsl:value-of select="format-number((sum(../../DatiPagamento[1]/DettaglioPagamento/ImportoPagamento)) div 100 * Percentuale,'###########0.00')"/>
								</xsl:when>
								<xsl:when test="not(../../DatiPagamento[1]/DettaglioPagamento/ImportoPagamento) and ImponibileImporto">
									<xsl:value-of select="format-number((ImportoTotaleDocumento+Arrotondamento) div 100 * Percentuale,'###########0.00')"/>
								</xsl:when>
								<xsl:otherwise>
									<xsl:variable name="taxInclusiveAmount">
										<xsl:if test="ImportoTotaleDocumento">
											<xsl:value-of select="format-number(ImportoTotaleDocumento,'###########0.00')"/>
										</xsl:if>
										<xsl:if test="not(ImportoTotaleDocumento)">
											<xsl:variable name="lineExtensionAmount" select="format-number(sum(../../DatiBeniServizi/DettaglioLinee[not(Descrizione = 'BOLLO') and not(Descrizione = 'SCONTO') and not(Descrizione = 'MAGGIORAZIONE')]/PrezzoTotale),'###########0.00')"/>
											<xsl:value-of select="format-number($lineExtensionAmount+sum(../../DatiBeniServizi/DatiRiepilogo/Imposta)+sum(DatiCassaPrevidenziale/ImportoContributoCassa)+sum(../../DatiBeniServizi/DettaglioLinee[Descrizione = 'BOLLO']/PrezzoTotale),'###########0.00')"/>
										</xsl:if>
									</xsl:variable>
									<xsl:value-of select="format-number(($taxInclusiveAmount+Arrotondamento) div 100 * Percentuale,'###########0.00')"/>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:if>
					</cbc:Amount>
				</cac:AllowanceCharge>
			</ext:ExtensionContent>
		</ext:UBLExtension>
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
		<xsl:if test="/in:FatturaElettronica/FatturaElettronicaHeader/SoggettoEmittente 
      or DatiGenerali/DatiGeneraliDocumento/DatiRitenuta 
      or DatiGenerali/DatiGeneraliDocumento/Art73
      or FatturaElettronicaBody/DatiGenerali/DatiGeneraliDocumento/DatiRitenuta
      or DatiGenerali/DatigeneraliDocumento/ScontoMaggiorazione">
			<ext:UBLExtensions>
				<xsl:apply-templates select="/in:FatturaElettronica/FatturaElettronicaHeader/SistemaEmittente" mode="SistemaEmittente">
					<xsl:with-param name="CN" select="current()"/>
					<xsl:with-param name="CNP" select="position()"/>
				</xsl:apply-templates>
				<xsl:apply-templates select="/in:FatturaElettronica/FatturaElettronicaHeader/SoggettoEmittente">
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
				<xsl:apply-templates select="FatturaElettronicaBody/DatiGenerali/DatiGeneraliDocumento/DatiRitenuta">
					<xsl:with-param name="CN" select="current()"/>
					<xsl:with-param name="CNP" select="position()"/>
				</xsl:apply-templates>
				<xsl:apply-templates select="DatiGenerali/DatiGeneraliDocumento/ScontoMaggiorazione">
					<xsl:with-param name="CN" select="current()"/>
					<xsl:with-param name="CNP" select="position()"/>
				</xsl:apply-templates>
			</ext:UBLExtensions>
		</xsl:if>
	</xsl:template>
	<xsl:template match="FatturaElettronicaBody/DatiBeniServizi/DatiRiepilogo">
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
						<xsl:when test="/in:FatturaElettronica/FatturaElettronicaBody/DatiBeniServizi/DatiRiepilogo[position()]/EsigibilitaIVA = 'S'">
							<xsl:text>B</xsl:text>
						</xsl:when>
						<xsl:when test="Natura and not(/in:FatturaElettronica/FatturaElettronicaBody/DatiBeniServizi/DatiRiepilogo[position()]/EsigibilitaIVA = 'S')">
							<xsl:value-of select="if(document($NATURA)//gc:Code[gc:Id=current()/Natura]/gc:VATCategoryCode) then document($NATURA)//gc:Code[gc:Id=current()/Natura]/gc:VATCategoryCode else ( if (ImponibileImporto = '2' or ImponibileImporto = '2.00' or ImponibileImporto = '0' or ImponibileImporto = '0.00') then 'Z' else 'E')"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:text>S</xsl:text>
						</xsl:otherwise>
					</xsl:choose>
				</cbc:ID>
				<cbc:Percent>
					<xsl:value-of select="AliquotaIVA"/>
				</cbc:Percent>
				<xsl:if test="Natura and not(Natura = 'N1')">
					<cbc:TaxExemptionReasonCode>
						<xsl:value-of select="if (document($NATURA)//gc:Code[gc:Id=current()/Natura]/gc:VATExemReasonCode) then document($NATURA)//gc:Code[gc:Id=current()/Natura]/gc:VATExemReasonCode else 'vatex-eu-132'"/>
					</cbc:TaxExemptionReasonCode>
					<cbc:TaxExemptionReason>
						<xsl:choose>
							<xsl:when test="not(document($NATURA)//gc:Code[gc:Id=current()/Natura]/gc:VATExemReasonCode)">
								<xsl:value-of select="concat('N4', '#', 'Esenti')"/>
							</xsl:when>
							<xsl:when test="RiferimentoNormativo">
								<xsl:value-of select="concat(Natura, '#', RiferimentoNormativo)"/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="concat(Natura, '#', document($NATURA)//gc:Code[gc:Id=current()/Natura]/gc:Description)"/>
							</xsl:otherwise>
						</xsl:choose>
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
		<xsl:if test="not(upper-case(normalize-space(Descrizione)) = 'BOLLO')">
			<cac:CreditNoteLine>
				<cbc:ID>
					<xsl:value-of select="normalize-space(NumeroLinea)"/>
				</cbc:ID>
				<xsl:apply-templates select="AltriDatiGestionali[upper-case(TipoDato)='NOTA']" mode="Nota_AltriDatiGestionali">
					<xsl:with-param name="CN" select="current()"/>
					<xsl:with-param name="CNP" select="position()"/>
				</xsl:apply-templates>
				<cbc:CreditedQuantity>
					<xsl:variable name="unitCode">
						<xsl:if test="UnitaMisura">
							<xsl:value-of select="if (document($UNECE)//gc:Code[substring(lower-case(gc:LocalId),0,8)=substring(lower-case(current()/UnitaMisura),0,8)]/gc:Id) then document($UNECE)//gc:Code[substring(lower-case(gc:LocalId),0,8)=substring(lower-case(current()/UnitaMisura),0,8)]/gc:Id else 'C62'"/>
						</xsl:if>
						<xsl:if test="not(UnitaMisura)">
							<xsl:value-of select="'C62'"/>
						</xsl:if>
					</xsl:variable>
					<xsl:if test="string($unitCode)">
						<xsl:attribute name="unitCode">
							<xsl:value-of select="string($unitCode)"/>
						</xsl:attribute>
					</xsl:if>
					<xsl:if test="Quantita and UnitaMisura and contains(UnitaMisura, ' ')">
						<xsl:value-of select="format-number(Quantita * number(substring-before(UnitaMisura, ' ')),'###########0.00000000')"/>
					</xsl:if>
					<xsl:if test="(not(UnitaMisura) or not(contains(UnitaMisura, ' '))) and Quantita">
						<xsl:value-of select="format-number(Quantita, '###########0.00000000')"/>
					</xsl:if>
					<xsl:if test="not(UnitaMisura) and not(Quantita)">
						<xsl:text>1.00</xsl:text>
					</xsl:if>
				</cbc:CreditedQuantity>
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
				<xsl:apply-templates select="/in:FatturaElettronica/FatturaElettronicaBody/DatiGenerali/DatiConvenzione" mode="CodiceCommessaConvenzione_Convenzione_Riga">
					<xsl:with-param name="CN" select="current()"/>
					<xsl:with-param name="CNP" select="position()"/>
				</xsl:apply-templates>
				<xsl:apply-templates select="/in:FatturaElettronica/FatturaElettronicaBody/DatiGenerali/DatiContratto/CodiceCommessaConvenzione" mode="CodiceCommessaConvenzione_Contratto_Riga">
					<xsl:with-param name="CN" select="current()"/>
					<xsl:with-param name="CNP" select="position()"/>
				</xsl:apply-templates>
				<xsl:apply-templates select="/in:FatturaElettronica/FatturaElettronicaBody/DatiGenerali/DatiContratto/CodiceCUP" mode="CUP_Contratto_Riga">
					<xsl:with-param name="CN" select="current()"/>
					<xsl:with-param name="CNP" select="position()"/>
				</xsl:apply-templates>
				<xsl:apply-templates select="/in:FatturaElettronica/FatturaElettronicaBody/DatiGenerali/DatiConvenzione/CodiceCUP" mode="CUP_Contratto_Riga">
					<xsl:with-param name="CN" select="current()"/>
					<xsl:with-param name="CNP" select="position()"/>
				</xsl:apply-templates>
				<xsl:apply-templates select="/in:FatturaElettronica/FatturaElettronicaBody/DatiGenerali/DatiOrdineAcquisto/CodiceCUP" mode="CUP_Contratto_Riga">
					<xsl:with-param name="CN" select="current()"/>
					<xsl:with-param name="CNP" select="position()"/>
				</xsl:apply-templates>
				<xsl:apply-templates select="/in:FatturaElettronica/FatturaElettronicaBody/DatiGenerali/DatiContratto/CodiceCIG" mode="CIG_Contratto_Riga">
					<xsl:with-param name="CN" select="current()"/>
					<xsl:with-param name="CNP" select="position()"/>
				</xsl:apply-templates>
				<xsl:apply-templates select="/in:FatturaElettronica/FatturaElettronicaBody/DatiGenerali/DatiConvenzione/CodiceCIG" mode="CIG_Contratto_Riga">
					<xsl:with-param name="CN" select="current()"/>
					<xsl:with-param name="CNP" select="position()"/>
				</xsl:apply-templates>
				<xsl:apply-templates select="/in:FatturaElettronica/FatturaElettronicaBody/DatiGenerali/DatiOrdineAcquisto/CodiceCIG" mode="CIG_Contratto_Riga">
					<xsl:with-param name="CN" select="current()"/>
					<xsl:with-param name="CNP" select="position()"/>
				</xsl:apply-templates>
				<cac:Item>
					<cbc:Name>
						<xsl:value-of select="normalize-space(Descrizione)"/>
					</cbc:Name>
					<xsl:variable name="standardItemIdentificationCodelist">
						<xsl:text>0002 0003 0004 0005 0006 0007 0008 0009 0010 0011 0012 0013 0014 0015 0016 0017 0018 0019 0020 0021 0022 0023 0024 0025 0026 0027 0028 0029 0030 0031 0032 0033 0034 0035 0036 0037 0038 0039 0040 0041 0042 0043 0044 0045 0046 0047 0048 0049 0050 0051 0052 0053 0054 0055 0056 0057 0058 0059 0060 0061 0062 0063 0064 0065 0066 0067 0068 0069 0070 0071 0072 0073 0074 0075 0076 0077 0078 0079 0080 0081 0082 0083 0084 0085 0086 0087 0088 0089 0090 0091 0093 0094 0095 0096 0097 0098 0099 0100 0101 0102 0104 0105 0106 0107 0108 0109 0110 0111 0112 0113 0114 0115 0116 0117 0118 0119 0120 0121 0122 0123 0124 0125 0126 0127 0128 0129 0130 0131 0132 0133 0134 0135 0136 0137 0138 0139 0140 0141 0142 0143 0144 0145 0146 0147 0148 0149 0150 0151 0152 0153 0154 0155 0156 0157 0158 0159 0160 0161 0162 0163 0164 0165 0166 0167 0168 0169 0170 0171 0172 0173 0174 0175 0176 0177 0178 0179 0180 0183 0184 0185 0186 0187 0188 0189 0190 0191 0192 0193 0194 0195 0196 0197 0198 0199 0200 0201 0202 0203 0204 0205 0206 0207 0208 0209 0210 0211 0212 0213</xsl:text>
					</xsl:variable>
					<xsl:variable name="commodityClassificationCodelist">
						<xsl:text>AA AB AC AD AE AF AG AH AI AJ AK AL AM AN AO AP AQ AR AS AT AU AV AW AX AY AZ BA BB BC BD BE BF BG BH BI BJ BK BL BM BN BO BP BQ BR BS BT BU BV BW BX BY BZ CC CG CL CR CV DR DW EC EF EN FS GB GN GS HS IB IN IS IT IZ MA MF MN MP NB ON PD PL PO PV QS RC RN RU RY SA SG SK SN SRS SRT SRU SRV SRW SRX SRY SRZ SS SSA SSB SSC SSD SSE SSF SSG SSH SSI SSJ SSK SSL SSM SSN SSO SSP SSQ SSR SSS SST SSU SSV SSW SSX SSY SSZ ST STA STB STC STD STE STF STG STH STI STJ STK STL STM STN STO STP STQ STR STS STT STU STV STW STX STY STZ SUA SUB SUC SUD SUE SUF SUG SUH SUI SUJ SUK SUL SUM TG TSN TSO TSP TSQ TSR TSS TST TSU UA UP VN VP VS VX ZZZ</xsl:text>
					</xsl:variable>
					<xsl:variable name="carbOrAicFarmacoExist">
						<xsl:for-each select="CodiceArticolo">
							<xsl:if test="upper-case(CodiceTipo) = 'CARB' or upper-case(CodiceTipo) = 'AICFARMACO'">
								<xsl:text>y</xsl:text>
							</xsl:if>
						</xsl:for-each>
						<xsl:text>n</xsl:text>
					</xsl:variable>
					<xsl:variable name="firstUnkwonCode">
						<xsl:for-each select="CodiceArticolo">
							<xsl:if test="not(upper-case(CodiceTipo) = 'CARB' or upper-case(CodiceTipo) = 'AICFARMACO') and not(contains($standardItemIdentificationCodelist, CodiceTipo)) and not(contains($commodityClassificationCodelist, CodiceTipo))">
								<xsl:value-of select="position()"/>
							</xsl:if>
						</xsl:for-each>
						<xsl:text>u</xsl:text>
					</xsl:variable>
					<xsl:if test="substring($carbOrAicFarmacoExist, 1, 1) = 'y'">
						<cac:SellersItemIdentification>
							<cbc:ID>
								<xsl:value-of select="upper-case(CodiceArticolo[upper-case(CodiceTipo) = 'CARB' or upper-case(CodiceTipo) = 'AICFARMACO']/CodiceTipo)"/>
								<xsl:text>:</xsl:text>
								<xsl:value-of select="CodiceArticolo[upper-case(CodiceTipo) = 'CARB' or upper-case(CodiceTipo) = 'AICFARMACO']/CodiceValore"/>
							</cbc:ID>
						</cac:SellersItemIdentification>
					</xsl:if>
					<xsl:if test="substring($carbOrAicFarmacoExist, 1, 1) = 'n' and not(substring($firstUnkwonCode, 1, 1) = 'u')">
						<cac:SellersItemIdentification>
							<cbc:ID>
								<xsl:value-of select="CodiceArticolo[number(substring($firstUnkwonCode, 1, 1))]/CodiceTipo"/>
								<xsl:text>:</xsl:text>
								<xsl:value-of select="CodiceArticolo[number(substring($firstUnkwonCode, 1, 1))]/CodiceValore"/>
							</cbc:ID>
						</cac:SellersItemIdentification>
					</xsl:if>
					<xsl:for-each select="CodiceArticolo">
						<xsl:if test="contains($standardItemIdentificationCodelist, CodiceTipo)">
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
						<xsl:if test="contains($commodityClassificationCodelist, CodiceTipo)">
							<cac:CommodityClassification>
								<cbc:ItemClassificationCode>
									<xsl:if test="CodiceTipo">
										<xsl:attribute name="listID">
											<xsl:value-of select="CodiceTipo"/>
										</xsl:attribute>
									</xsl:if>
									<xsl:value-of select="CodiceValore"/>
								</cbc:ItemClassificationCode>
							</cac:CommodityClassification>
						</xsl:if>
					</xsl:for-each>
					<xsl:if test="string-length($firstUnkwonCode) &gt; 1">
						<xsl:for-each select="CodiceArticolo">
							<xsl:choose>
								<xsl:when test="substring($carbOrAicFarmacoExist, 1, 1) = 'y'">
									<xsl:if test="contains($firstUnkwonCode, string(position()))">
										<xsl:call-template name="CommodityClassification">
											<xsl:with-param name="CodiceArticolo" select="."/>
										</xsl:call-template>
									</xsl:if>
								</xsl:when>
								<xsl:when test="string-length($firstUnkwonCode) &gt; 2 and substring($carbOrAicFarmacoExist, 1, 1) = 'n'">
									<xsl:if test="not(string(position()) = substring($firstUnkwonCode, 1, 1)) and contains($firstUnkwonCode, string(position()))">
										<xsl:call-template name="CommodityClassification">
											<xsl:with-param name="CodiceArticolo" select="."/>
										</xsl:call-template>
									</xsl:if>
								</xsl:when>
							</xsl:choose>
						</xsl:for-each>
					</xsl:if>
					<cac:ClassifiedTaxCategory>
						<xsl:apply-templates select="AltriDatiGestionali" mode="NaturaOriginale">
							<xsl:with-param name="CN" select="current()"/>
							<xsl:with-param name="CNP" select="position()"/>
						</xsl:apply-templates>
						<cbc:ID>
							<xsl:choose>
								<xsl:when test="/in:FatturaElettronica/FatturaElettronicaBody/DatiBeniServizi/DatiRiepilogo[position()]/EsigibilitaIVA = 'S'">
									<xsl:text>B</xsl:text>
								</xsl:when>
								<xsl:when test="Natura and not(/in:FatturaElettronica/FatturaElettronicaBody/DatiBeniServizi/DatiRiepilogo[position()]/EsigibilitaIVA = 'S')">
									<xsl:value-of select="if (document($NATURA)//gc:Code[gc:Id=current()/Natura]/gc:VATCategoryCode) then document($NATURA)//gc:Code[gc:Id=current()/Natura]/gc:VATCategoryCode else 'E'"/>
								</xsl:when>
								<xsl:otherwise>
									<xsl:text>S</xsl:text>
								</xsl:otherwise>
							</xsl:choose>
						</cbc:ID>
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
					<xsl:apply-templates select="AltriDatiGestionali[upper-case(TipoDato)!='NOTA' and TipoDato!='DatiDDT' and TipoDato!='Base Qty.' and TipoDato!='Base Unit' and not(starts-with(TipoDato, 'BT-'))]" mode="AltriDatiGestionali_Item">
						<xsl:with-param name="CN" select="current()"/>
						<xsl:with-param name="CNP" select="position()"/>
					</xsl:apply-templates>
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
							<xsl:when test="AltriDatiGestionali[TipoDato = 'BT-147']">
								<xsl:value-of select="AltriDatiGestionali[TipoDato = 'BT-147'][1]/RiferimentoNumero"/>
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
						<xsl:choose>
							<xsl:when test="ScontoMaggiorazione/Tipo = 'MG' or ScontoMaggiorazione/Tipo = 'SC'">
								<xsl:value-of select="format-number(PrezzoUnitario - $amount,'###########0.00000000')"/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="format-number(PrezzoUnitario,'###########0.00000000')"/>
							</xsl:otherwise>
						</xsl:choose>
					</cbc:PriceAmount>
					<xsl:if test="AltriDatiGestionali[TipoDato = 'Base Qty.']">
						<cbc:BaseQuantity>
							<xsl:variable name="unitCode">
								<xsl:value-of select="if (document($UNECE)//gc:Code[gc:LocalIds/gc:LocalId=current()/UnitaMisura]/gc:Id) then document($UNECE)//gc:Code[gc:LocalIds/gc:LocalId=current()/UnitaMisura]/gc:Id else 'C62'"/>
							</xsl:variable>
							<xsl:if test="string($unitCode)">
								<xsl:attribute name="unitCode">
									<xsl:value-of select="string($unitCode)"/>
								</xsl:attribute>
							</xsl:if>
							<xsl:value-of select="format-number(AltriDatiGestionali[TipoDato = 'Base Qty.'][1],'###########0.00')"/>
						</cbc:BaseQuantity>
					</xsl:if>
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
							<xsl:if test="ScontoMaggiorazione">
								<xsl:value-of select="format-number(PrezzoUnitario,'###########0.00000000')"/>
							</xsl:if>
							<xsl:if test="not(ScontoMaggiorazione)">
								<xsl:value-of select="format-number(PrezzoUnitario + $amount,'###########0.00000000')"/>
							</xsl:if>
						</cbc:BaseAmount>
					</cac:AllowanceCharge>
				</cac:Price>
			</cac:CreditNoteLine>
		</xsl:if>
	</xsl:template>
	<xsl:template match="FatturaElettronicaBody/DatiGenerali/DatiGeneraliDocumento" mode="LegalMonetaryTotal">
		<xsl:param name="CN" select="."/>
		<xsl:param name="CNP" select="1"/>
		<cac:LegalMonetaryTotal>
			<xsl:variable name="lineExtensionAmount" select="format-number(sum(../../DatiBeniServizi/DettaglioLinee[not(Descrizione = 'BOLLO') and not(Descrizione = 'SCONTO') and not(Descrizione = 'MAGGIORAZIONE')]/PrezzoTotale),'###########0.00')"/>
			<xsl:variable name="variable_d1e449a1049836">
				<xsl:value-of select="Divisa"/>
			</xsl:variable>
			<xsl:variable name="taxInclusiveAmount">
				<xsl:if test="ImportoTotaleDocumento">
					<xsl:value-of select="format-number(ImportoTotaleDocumento,'###########0.00')"/>
				</xsl:if>
				<xsl:if test="not(ImportoTotaleDocumento)">
					<xsl:value-of select="format-number($lineExtensionAmount+sum(../../DatiBeniServizi/DatiRiepilogo/Imposta)+sum(DatiCassaPrevidenziale/ImportoContributoCassa)+sum(../../DatiBeniServizi/DettaglioLinee[Descrizione = 'BOLLO']/PrezzoTotale),'###########0.00')"/>
				</xsl:if>
			</xsl:variable>
			<xsl:variable name="chargeTotalAmount" select="format-number(sum(DatiCassaPrevidenziale/ImportoContributoCassa),'###########0.00')"/>
			<xsl:variable name="allowanceTotalAmount" select="format-number(abs(sum(../../DatiBeniServizi/DettaglioLinee[Descrizione = 'BOLLO']/PrezzoTotale)),'###########0.00')"/>
			<xsl:variable name="payableAmountWithoutAllowanceCharge">
				<xsl:choose>
					<xsl:when test="../../DatiPagamento[1]/DettaglioPagamento/ImportoPagamento">
						<xsl:value-of select="format-number(sum(../../DatiPagamento[1]/DettaglioPagamento/ImportoPagamento),'###########0.00')"/>
					</xsl:when>
					<xsl:when test="not(../../DatiPagamento[1]/DettaglioPagamento/ImportoPagamento) and ImportoTotaleDocumento and Arrotondamento">
						<xsl:value-of select="format-number(ImportoTotaleDocumento+Arrotondamento,'###########0.00')"/>
					</xsl:when>
					<xsl:when test="not(../../DatiPagamento[1]/DettaglioPagamento/ImportoPagamento) and ImportoTotaleDocumento and not(Arrotondamento)">
						<xsl:value-of select="format-number(ImportoTotaleDocumento,'###########0.00')"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="format-number($taxInclusiveAmount+sum(ScontoMaggiorazione[Tipo='MG']/Importo)-sum(ScontoMaggiorazione[Tipo='SC']/Importo)+sum(Arrotondamento),'###########0.00')"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:variable>
			<xsl:variable name="payableAmount">
				<xsl:choose>
					<xsl:when test="ScontoMaggiorazione and ScontoMaggiorazione/Tipo = 'MG' and Importo">
						<xsl:value-of select="format-number($payableAmountWithoutAllowanceCharge + Importo,'###########0.00')"/>
					</xsl:when>
					<xsl:when test="ScontoMaggiorazione and ScontoMaggiorazione/Tipo = 'SC' and Importo">
						<xsl:value-of select="format-number($payableAmountWithoutAllowanceCharge - Importo,'###########0.00')"/>
					</xsl:when>
					<xsl:when test="ScontoMaggiorazione and ScontoMaggiorazione/Tipo = 'MG' and Percentuale">
						<xsl:value-of select="format-number($payableAmountWithoutAllowanceCharge + ($payableAmountWithoutAllowanceCharge div 100 * Percentuale),'###########0.00')"/>
					</xsl:when>
					<xsl:when test="ScontoMaggiorazione and ScontoMaggiorazione/Tipo = 'SC' and Percentuale">
						<xsl:value-of select="format-number($payableAmountWithoutAllowanceCharge - ($payableAmountWithoutAllowanceCharge div 100 * Percentuale),'###########0.00')"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="$payableAmountWithoutAllowanceCharge"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:variable>
			<cbc:LineExtensionAmount>
				<xsl:if test="string($variable_d1e449a1049836)">
					<xsl:attribute name="currencyID">
						<xsl:value-of select="string($variable_d1e449a1049836)"/>
					</xsl:attribute>
				</xsl:if>
				<xsl:value-of select="$lineExtensionAmount"/>
			</cbc:LineExtensionAmount>
			<cbc:TaxExclusiveAmount>
				<xsl:if test="string($variable_d1e449a1049836)">
					<xsl:attribute name="currencyID">
						<xsl:value-of select="string($variable_d1e449a1049836)"/>
					</xsl:attribute>
				</xsl:if>
				<xsl:value-of select="format-number(number($lineExtensionAmount)+sum(DatiCassaPrevidenziale/ImportoContributoCassa)+sum(../../DatiBeniServizi/DettaglioLinee[Descrizione = 'BOLLO']/PrezzoTotale),'###########0.00')"/>
			</cbc:TaxExclusiveAmount>
			<cbc:TaxInclusiveAmount>
				<xsl:if test="string($variable_d1e449a1049836)">
					<xsl:attribute name="currencyID">
						<xsl:value-of select="string($variable_d1e449a1049836)"/>
					</xsl:attribute>
				</xsl:if>
				<xsl:value-of select="$taxInclusiveAmount"/>
			</cbc:TaxInclusiveAmount>
			<xsl:if test="number($allowanceTotalAmount) &gt; number('0.00') ">
				<cbc:AllowanceTotalAmount>
					<xsl:if test="string($variable_d1e449a1049836)">
						<xsl:attribute name="currencyID">
							<xsl:value-of select="string($variable_d1e449a1049836)"/>
						</xsl:attribute>
					</xsl:if>
					<xsl:value-of select="$allowanceTotalAmount"/>
				</cbc:AllowanceTotalAmount>
			</xsl:if>
			<xsl:if test="(number($chargeTotalAmount) &gt; number('0.00')) or (../../DatiBeniServizi/DettaglioLinee[Descrizione = 'BOLLO'])">
				<cbc:ChargeTotalAmount>
					<xsl:if test="string($variable_d1e449a1049836)">
						<xsl:attribute name="currencyID">
							<xsl:value-of select="string($variable_d1e449a1049836)"/>
						</xsl:attribute>
					</xsl:if>
					<xsl:value-of select="$chargeTotalAmount"/>
				</cbc:ChargeTotalAmount>
			</xsl:if>
			<xsl:if test="number($taxInclusiveAmount) &gt; number($payableAmount)">
				<cbc:PrepaidAmount>
					<xsl:variable name="variable_d1e450a1049836">
						<xsl:value-of select="Divisa"/>
					</xsl:variable>
					<xsl:if test="string($variable_d1e450a1049836)">
						<xsl:attribute name="currencyID">
							<xsl:value-of select="string($variable_d1e450a1049836)"/>
						</xsl:attribute>
					</xsl:if>
					<xsl:value-of select="format-number(number($taxInclusiveAmount) - number($payableAmount), '###########0.00')"/>
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
				<xsl:value-of select="$payableAmount"/>
			</cbc:PayableAmount>
		</cac:LegalMonetaryTotal>
	</xsl:template>
	<xsl:template match="FatturaElettronicaBody/DatiGenerali/DatiGeneraliDocumento/DatiBollo">
		<xsl:param name="CN" select="."/>
		<xsl:param name="CNP" select="1"/>
		<cac:AllowanceCharge>
			<cbc:ChargeIndicator>
				<xsl:text>false</xsl:text>
			</cbc:ChargeIndicator>
			<cbc:AllowanceChargeReasonCode>
				<xsl:text>95</xsl:text>
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
				<xsl:choose>
					<xsl:when test="ImportoBollo">
						<xsl:value-of select="format-number(ImportoBollo,'###########0.00')"/>
					</xsl:when>
					<xsl:when test="../../../DatiBeniServizi/DettaglioLinee[Descrizione = 'BOLLO']">
						<xsl:value-of select="format-number(../../../DatiBeniServizi/DettaglioLinee[Descrizione = 'BOLLO'][1]/PrezzoTotale,'###########0.00')"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:text>0.00</xsl:text>
					</xsl:otherwise>
				</xsl:choose>
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
				<xsl:value-of select="concat(TipoCassa, '#', Ritenuta, '#', Natura)"/>
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
				<cbc:ID>
					<xsl:choose>
						<xsl:when test="Natura">
							<xsl:value-of select="document($NATURA)//gc:Code[gc:Id=current()/Natura]/gc:VATCategoryCode"/>
						</xsl:when>
						<xsl:when test="/in:FatturaElettronica/FatturaElettronicaBody/DatiBeniServizi/DatiRiepilogo[position()]/EsigibilitaIVA = 'S'">
							<xsl:text>B</xsl:text>
						</xsl:when>
						<xsl:otherwise>
							<xsl:text>S</xsl:text>
						</xsl:otherwise>
					</xsl:choose>
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
			<cbc:PaymentMeansCode>
				<xsl:if test="ModalitaPagamento = 'MP05'">
					<xsl:attribute name="name">
						<xsl:text>Credit transfer</xsl:text>
					</xsl:attribute>
				</xsl:if>
				<xsl:if test="(ModalitaPagamento != 'MP05') and (document($UNCL4461)//gc:Code[gc:LocalId=current()/ModalitaPagamento][1]/gc:Name)">
					<xsl:attribute name="name">
						<xsl:value-of select="document($UNCL4461)//gc:Code[gc:LocalId=current()/ModalitaPagamento][1]/gc:Name"/>
					</xsl:attribute>
				</xsl:if>
				<xsl:value-of select="if ((document($UNCL4461)//gc:Code[gc:LocalId=current()/ModalitaPagamento][1]/gc:Id) and ModalitaPagamento != 'MP05') then (document($UNCL4461)//gc:Code[gc:LocalId=current()/ModalitaPagamento][1]/gc:Id) else '30'"/>
			</cbc:PaymentMeansCode>
			<xsl:if test="DataScadenzaPagamento">
				<cbc:PaymentDueDate>
					<xsl:value-of select="DataScadenzaPagamento"/>
				</cbc:PaymentDueDate>
			</xsl:if>
			<xsl:if test="CodicePagamento">
				<cbc:PaymentID>
					<xsl:value-of select="CodicePagamento"/>
				</cbc:PaymentID>
			</xsl:if>
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
								<xsl:value-of select="normalize-space(concat('Nome#Cognome:', DatiAnagrafici/Anagrafica/Nome, '#', DatiAnagrafici/Anagrafica/Cognome))"/>
							</xsl:when>
						</xsl:choose>
					</cbc:RegistrationName>
					<xsl:if test="DatiAnagrafici/CodiceFiscale">
						<cbc:CompanyID schemeID="0210">
							<xsl:value-of select="DatiAnagrafici/CodiceFiscale"/>
						</cbc:CompanyID>
					</xsl:if>
					<xsl:if test="not(DatiAnagrafici/CodiceFiscale) and Sede/Nazione = 'IT'">
						<cbc:CompanyID schemeID="0210">
							<xsl:value-of select="DatiAnagrafici/IdFiscaleIVA/IdCodice"/>
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
								<xsl:value-of select="normalize-space(concat('Nome#Cognome:', DatiAnagrafici/Anagrafica/Nome, '#', DatiAnagrafici/Anagrafica/Cognome))"/>
							</xsl:when>
						</xsl:choose>
					</cbc:RegistrationName>
					<xsl:if test="DatiAnagrafici/CodiceFiscale">
						<cbc:CompanyID schemeID="0210">
							<xsl:value-of select="DatiAnagrafici/CodiceFiscale"/>
						</cbc:CompanyID>
					</xsl:if>
				</cac:PartyLegalEntity>
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
							<xsl:value-of select="concat('Nome#Cognome:', DatiAnagrafici/Anagrafica/Nome, '#', DatiAnagrafici/Anagrafica/Cognome)"/>
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
				<xsl:value-of select="(document($VATSchemes)//vs:Code[vs:LocalId=current()/upper-case(IdPaese)[1]]/vs:Id)"/>
			</xsl:variable>
			<xsl:value-of select="concat(IdPaese, IdCodice)"/>
		</cbc:CompanyID>
	</xsl:template>
	<xsl:template match="IdFiscaleIVA">
		<xsl:param name="CN" select="."/>
		<xsl:param name="CNP" select="1"/>
		<cbc:CompanyID>
			<xsl:variable name="variable_d1e376a1051010">
				<xsl:value-of select="(document($VATSchemes)//vs:Code[vs:LocalId=current()/upper-case(IdPaese)[1]]/vs:Id)"/>
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
				<xsl:if test="Provincia">
					<cbc:CountrySubentity>
						<xsl:value-of select="Provincia"/>
					</cbc:CountrySubentity>
				</xsl:if>
				<xsl:if test="not(Provincia) and Nazione = 'IT'">
					<cbc:CountrySubentity>
						<xsl:text>ZA</xsl:text>
					</cbc:CountrySubentity>
				</xsl:if>
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
			<xsl:if test="not(Provincia) and Nazione = 'IT'">
				<cbc:CountrySubentity>
					<xsl:text>ZA</xsl:text>
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
			<xsl:if test="not(Provincia)">
				<cbc:CountrySubentity>
					<xsl:text>ZA</xsl:text>
				</cbc:CountrySubentity>
			</xsl:if>
			<cac:Country>
				<cbc:IdentificationCode>
					<xsl:value-of select="Nazione"/>
				</cbc:IdentificationCode>
			</cac:Country>
		</cac:PostalAddress>
	</xsl:template>
	<xsl:template name="CommodityClassification">
		<xsl:param name="CodiceArticolo"/>
		<cac:CommodityClassification>
			<cbc:ItemClassificationCode>
				<xsl:if test="./CodiceTipo">
					<xsl:attribute name="listID">
						<xsl:text>ZZZ</xsl:text>
					</xsl:attribute>
				</xsl:if>
				<xsl:value-of select="./CodiceTipo"/>
				<xsl:text>:</xsl:text>
				<xsl:value-of select="./CodiceValore"/>
			</cbc:ItemClassificationCode>
		</cac:CommodityClassification>
	</xsl:template>
	<xsl:template match="/in:FatturaElettronica" name="root">
		<xsl:param name="CN" select="."/>
		<xsl:param name="CNP" select="1"/>
		<CreditNote>
			<xsl:apply-templates select="FatturaElettronicaBody">
				<xsl:with-param name="CN" select="current()"/>
				<xsl:with-param name="CNP" select="position()"/>
			</xsl:apply-templates>
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
			<cbc:CreditNoteTypeCode>
				<xsl:value-of select="if (document($TIPODOC)//doc:Code[doc:LocalId=current()/FatturaElettronicaBody/DatiGenerali/DatiGeneraliDocumento/TipoDocumento]/doc:Id) then document($TIPODOC)//doc:Code[doc:LocalId=current()/FatturaElettronicaBody/DatiGenerali/DatiGeneraliDocumento/TipoDocumento]/doc:Id else '381'"/>
			</cbc:CreditNoteTypeCode>
			<xsl:if test="FatturaElettronicaBody/DatiGenerali/DatiGeneraliDocumento/Causale">
				<xsl:variable name="totale_causale">
					<xsl:value-of select="count(FatturaElettronicaBody/DatiGenerali/DatiGeneraliDocumento/Causale)"/>
				</xsl:variable>
				<cbc:Note>
					<xsl:for-each select="FatturaElettronicaBody/DatiGenerali/DatiGeneraliDocumento/Causale">
						<xsl:value-of select="."/>
						<xsl:if test="position() &lt; $totale_causale">
							<xsl:text>#</xsl:text>
						</xsl:if>
					</xsl:for-each>
				</cbc:Note>
			</xsl:if>
			<cbc:DocumentCurrencyCode>
				<xsl:value-of select="FatturaElettronicaBody/DatiGenerali/DatiGeneraliDocumento/Divisa"/>
			</cbc:DocumentCurrencyCode>
			<xsl:if test="FatturaElettronicaHeader/CedentePrestatore/RiferimentoAmministrazione">
				<cbc:AccountingCost>
					<xsl:value-of select="FatturaElettronicaHeader/CedentePrestatore/RiferimentoAmministrazione"/>
				</cbc:AccountingCost>
			</xsl:if>
			<xsl:if test="FatturaElettronicaBody/DatiGenerali/DatiOrdineAcquisto[CodiceCommessaConvenzione and CodiceCommessaConvenzione != '#NO#' and not(RiferimentoNumeroLinea)]">
				<cbc:BuyerReference>
					<xsl:variable name="codiceCommessaConvenzione" select="FatturaElettronicaBody/DatiGenerali/DatiOrdineAcquisto[CodiceCommessaConvenzione and CodiceCommessaConvenzione != '#NO#' and not(RiferimentoNumeroLinea)][1]/CodiceCommessaConvenzione"/>
					<xsl:choose>
						<xsl:when test="string-length($codiceCommessaConvenzione) - string-length(translate($codiceCommessaConvenzione, '#', '')) = 2 and not(starts-with($codiceCommessaConvenzione, '#')) and not(ends-with($codiceCommessaConvenzione, '#'))">
							<xsl:value-of select="$codiceCommessaConvenzione"/>
						</xsl:when>
						<xsl:when test="starts-with($codiceCommessaConvenzione, '#') and ends-with($codiceCommessaConvenzione, '#')">
							<xsl:value-of select="concat(FatturaElettronicaBody/DatiGenerali/DatiOrdineAcquisto/IdDocumento, '#', FatturaElettronicaBody/DatiGenerali/DatiOrdineAcquisto/Data, '#', substring(substring-after($codiceCommessaConvenzione, '#'), 1, string-length($codiceCommessaConvenzione) - 2))"/>
						</xsl:when>
						<xsl:when test="starts-with($codiceCommessaConvenzione, '#')">
							<xsl:value-of select="concat(FatturaElettronicaBody/DatiGenerali/DatiOrdineAcquisto/IdDocumento, '#', FatturaElettronicaBody/DatiGenerali/DatiOrdineAcquisto/Data, '#', substring-after($codiceCommessaConvenzione, '#'))"/>
						</xsl:when>
						<xsl:when test="ends-with($codiceCommessaConvenzione, '#')">
							<xsl:value-of select="concat(FatturaElettronicaBody/DatiGenerali/DatiOrdineAcquisto/IdDocumento, '#', FatturaElettronicaBody/DatiGenerali/DatiOrdineAcquisto/Data, '#', substring($codiceCommessaConvenzione, 1, string-length($codiceCommessaConvenzione) - 1))"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="concat(FatturaElettronicaBody/DatiGenerali/DatiOrdineAcquisto/IdDocumento, '#', FatturaElettronicaBody/DatiGenerali/DatiOrdineAcquisto/Data, '#', $codiceCommessaConvenzione)"/>
						</xsl:otherwise>
					</xsl:choose>
				</cbc:BuyerReference>
			</xsl:if>
			<xsl:if test="not(FatturaElettronicaBody/DatiGenerali/DatiOrdineAcquisto[CodiceCommessaConvenzione and not(RiferimentoNumeroLinea)]) or FatturaElettronicaBody/DatiGenerali/DatiOrdineAcquisto[CodiceCommessaConvenzione = '#NO#']">
				<cbc:BuyerReference>
					<xsl:text>#NO#</xsl:text>
				</cbc:BuyerReference>
			</xsl:if>
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
			<xsl:apply-templates select="FatturaElettronicaBody/DatiGenerali/DatiOrdineAcquisto[not(RiferimentoNumeroLinea)][1]">
				<xsl:with-param name="CN" select="current()"/>
				<xsl:with-param name="CNP" select="position()"/>
			</xsl:apply-templates>
			<xsl:apply-templates select="FatturaElettronicaBody/DatiGenerali/DatiFattureCollegate[not(RiferimentoNumeroLinea)]">
				<xsl:with-param name="CN" select="current()"/>
				<xsl:with-param name="CNP" select="position()"/>
			</xsl:apply-templates>
			<xsl:apply-templates select="FatturaElettronicaBody/DatiGenerali/DatiDDT[not(RiferimentoNumeroLinea)][1]">
				<xsl:with-param name="CN" select="current()"/>
				<xsl:with-param name="CNP" select="position()"/>
			</xsl:apply-templates>
			<xsl:apply-templates select="FatturaElettronicaBody/DatiGenerali/DatiRicezione[1]">
				<xsl:with-param name="CN" select="current()"/>
				<xsl:with-param name="CNP" select="position()"/>
			</xsl:apply-templates>
			<xsl:apply-templates select="FatturaElettronicaBody/DatiGenerali/DatiContratto[not(RiferimentoNumeroLinea)][1]" mode="ID_Contratto">
				<xsl:with-param name="CN" select="current()"/>
				<xsl:with-param name="CNP" select="position()"/>
			</xsl:apply-templates>
			<xsl:apply-templates select="FatturaElettronicaBody/DatiGenerali/DatiContratto[not(RiferimentoNumeroLinea)][1]/CodiceCUP">
				<xsl:with-param name="CN" select="current()"/>
				<xsl:with-param name="CNP" select="position()"/>
			</xsl:apply-templates>
			<xsl:apply-templates select="FatturaElettronicaBody/DatiGenerali/DatiConvenzione[not(RiferimentoNumeroLinea)][1]/CodiceCUP">
				<xsl:with-param name="CN" select="current()"/>
				<xsl:with-param name="CNP" select="position()"/>
			</xsl:apply-templates>
			<xsl:apply-templates select="FatturaElettronicaBody/DatiGenerali/DatiOrdineAcquisto[not(RiferimentoNumeroLinea)][1]/CodiceCUP">
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
			<xsl:apply-templates select="FatturaElettronicaBody/DatiGenerali/DatiConvenzione[not(RiferimentoNumeroLinea)]" mode="Codice_Commessa">
				<xsl:with-param name="CN" select="current()"/>
				<xsl:with-param name="CNP" select="position()"/>
			</xsl:apply-templates>
			<xsl:apply-templates select="FatturaElettronicaBody/DatiGenerali/DatiContratto[not(RiferimentoNumeroLinea)]/CodiceCommessaConvenzione" mode="Codice_Commessa">
				<xsl:with-param name="CN" select="current()"/>
				<xsl:with-param name="CNP" select="position()"/>
			</xsl:apply-templates>
			<xsl:apply-templates select="FatturaElettronicaBody/DatiGenerali/DatiOrdineAcquisto[not(RiferimentoNumeroLinea)]/CodiceCommessaConvenzione" mode="Codice_Commessa">
				<xsl:with-param name="CN" select="current()"/>
				<xsl:with-param name="CNP" select="position()"/>
			</xsl:apply-templates>
			<xsl:apply-templates select="FatturaElettronicaBody/DatiGenerali/DatiContratto[not(RiferimentoNumeroLinea)][1]" mode="Codice_CIG">
				<xsl:with-param name="CN" select="current()"/>
				<xsl:with-param name="CNP" select="position()"/>
			</xsl:apply-templates>
			<xsl:apply-templates select="FatturaElettronicaBody/DatiGenerali/DatiConvenzione[not(RiferimentoNumeroLinea)][1]/CodiceCIG">
				<xsl:with-param name="CN" select="current()"/>
				<xsl:with-param name="CNP" select="position()"/>
			</xsl:apply-templates>
			<xsl:apply-templates select="FatturaElettronicaBody/DatiGenerali/DatiOrdineAcquisto[not(RiferimentoNumeroLinea)][1]/CodiceCIG">
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
					<xsl:value-of select="format-number(sum(FatturaElettronicaBody/DatiBeniServizi/DatiRiepilogo/Imposta),'###########0.00')"/>
				</cbc:TaxAmount>
				<xsl:apply-templates select="FatturaElettronicaBody/DatiBeniServizi/DatiRiepilogo">
					<xsl:with-param name="CN" select="current()"/>
					<xsl:with-param name="CNP" select="position()"/>
				</xsl:apply-templates>
			</cac:TaxTotal>
			<xsl:apply-templates select="FatturaElettronicaBody/DatiGenerali/DatiGeneraliDocumento" mode="LegalMonetaryTotal">
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