<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet xmlns:ds="http://www.w3.org/2000/09/xmldsig#"
                xmlns:ext="urn:oasis:names:specification:ubl:schema:xsd:CommonExtensionComponents-2"
                xmlns:in="http://ivaservizi.agenziaentrate.gov.it/docs/xsd/fattura/messaggi/v1.0"
                xmlns="urn:oasis:names:specification:ubl:schema:xsd:ApplicationResponse-2"
                xmlns:cac="urn:oasis:names:specification:ubl:schema:xsd:CommonAggregateComponents-2"
                xmlns:cbc="urn:oasis:names:specification:ubl:schema:xsd:CommonBasicComponents-2"
                xmlns:xsd="http://www.w3.org/2001/XMLSchema"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                exclude-result-prefixes="in ds"
                xmlns:types="http://www.fatturapa.gov.it/sdi/messaggi/v1.0"
                version="2.0">
	<xsl:output indent="yes"/>
	<xsl:param name="receiverPartyId"/>
	<xsl:param name="receiverPartyRegistrationName"/>
	<xsl:param name="invoiceId"/>
	<xsl:param name="invoiceIssueDate"/>
    <xsl:param name="receiverPartySchemeId"/>

	<xsl:template name="sender-party">
		<cac:SenderParty>
			<cbc:EndpointID schemeID="0202">sdi01@pec.fatturapa.it</cbc:EndpointID>
			<cac:PartyLegalEntity>
				<cbc:RegistrationName>Agenzia delle Entrate</cbc:RegistrationName>
			</cac:PartyLegalEntity>
		</cac:SenderParty>
	</xsl:template>
	<xsl:template name="testata">
		<xsl:param name="dataOraConsegna"/>
		<xsl:param name="identificativoSdI"/>
		<cbc:CustomizationID>urn:fdc:peppol.eu:poacc:trns:invoice_response:3</cbc:CustomizationID>
		<cbc:ProfileID>urn:fdc:peppol.eu:poacc:bis:invoice_response:3</cbc:ProfileID>
		<cbc:ID>
			<xsl:value-of select="$identificativoSdI"/>
		</cbc:ID>
		<cbc:IssueDate>
			<xsl:value-of select="format-dateTime($dataOraConsegna,'[Y0001]-[M01]-[D01]')"/>
		</cbc:IssueDate>
		<cbc:IssueTime>
			<xsl:value-of select="format-dateTime($dataOraConsegna,'[h01]:[m01]:[s01]')"/>
		</cbc:IssueTime>
	</xsl:template>
	<xsl:template name="receiver-party">
		<cac:ReceiverParty>
            <cbc:EndpointID schemeID="{$receiverPartySchemeId}"><xsl:value-of select="$receiverPartyId"/></cbc:EndpointID>
			<cac:PartyLegalEntity>
				<cbc:RegistrationName>
					<xsl:value-of select="$receiverPartyRegistrationName"/>
				</cbc:RegistrationName>
			</cac:PartyLegalEntity>
		</cac:ReceiverParty>
	</xsl:template>
	<xsl:template name="document-reference">
		<cac:DocumentReference>
			<cbc:ID>
				<xsl:value-of select="$invoiceId"/>
			</cbc:ID>
			<cbc:IssueDate>
				<xsl:value-of select="$invoiceIssueDate"/>
			</cbc:IssueDate>
			<cbc:DocumentTypeCode>380</cbc:DocumentTypeCode>
			<!-- commercial invoice -->
		</cac:DocumentReference>
	</xsl:template>

	<!-- RICEVUTA DI CONSEGNA (FPR) -->
	<xsl:template match="//*[local-name()='RicevutaConsegna']" name="ricevutaConsegna">
		<ApplicationResponse>
			<xsl:call-template name="testata">
				<xsl:with-param name="dataOraConsegna">
					<xsl:value-of select="./DataOraConsegna"/>
				</xsl:with-param>
				<xsl:with-param name="identificativoSdI">
					<xsl:value-of select="./IdentificativoSdI"/>
				</xsl:with-param>
			</xsl:call-template>
			<xsl:if test="./Note">
				<cbc:Note>
					<xsl:value-of select="./Note"/>
				</cbc:Note>
			</xsl:if>
			<xsl:call-template name="sender-party"/>
			<xsl:call-template name="receiver-party"/>
			<cac:DocumentResponse>
				<cac:Response>
					<cbc:ResponseCode>AB</cbc:ResponseCode>
					<!--<cac:Status>
						<cbc:StatusReasonCode listID="OPStatusAction">REF</cbc:StatusReasonCode>
						<cbc:StatusReason>VAT Reference not found</cbc:StatusReason>
						<cac:Condition>
							<cbc:AttributeID>BT-48</cbc:AttributeID>
							<cbc:Description>EU123456789</cbc:Description>
						</cac:Condition>
					</cac:Status>-->
				</cac:Response>
				<xsl:call-template name="document-reference"/>
			</cac:DocumentResponse>

		</ApplicationResponse>
	</xsl:template>


	<!-- NOTIFICA DI SCARTO-->
	<xsl:template match="//*[local-name()='RicevutaScarto']" name="ricevutaScarto">
		<ApplicationResponse>
			<xsl:call-template name="testata">
				<xsl:with-param name="dataOraConsegna">
					<xsl:value-of select="./DataOraRicezione"/>
				</xsl:with-param>
				<xsl:with-param name="identificativoSdI">
					<xsl:value-of select="./IdentificativoSdI"/>
				</xsl:with-param>
			</xsl:call-template>
			<xsl:if test="./Note">
				<cbc:Note>
					<xsl:value-of select="./Note"/>
				</cbc:Note>
			</xsl:if>
			<xsl:call-template name="sender-party"/>
			<xsl:call-template name="receiver-party"/>
			<cac:DocumentResponse>
				<cac:Response>
					<cbc:ResponseCode>RE</cbc:ResponseCode>

					<xsl:for-each select="./ListaErrori/Errore">
						<cac:Status>
							<cbc:StatusReasonCode listID="OPStatusReason">OTH</cbc:StatusReasonCode>
							<cbc:StatusReason>
								<xsl:value-of select="./Codice"/> - <xsl:value-of select="./Descrizione"/>
							</cbc:StatusReason>
							<cac:Condition>
								<cbc:AttributeID>SDI</cbc:AttributeID>
								<cbc:Description>
									<xsl:value-of select="./Suggerimento"/>
								</cbc:Description>
							</cac:Condition>
						</cac:Status>
					</xsl:for-each>


				</cac:Response>
				<xsl:call-template name="document-reference"/>
			</cac:DocumentResponse>

		</ApplicationResponse>
	</xsl:template>

	<!-- NOTIFICA DI SCARTO-->
	<xsl:template match="//*[local-name()='NotificaScarto']" name="notificaScarto">
		<ApplicationResponse>
			<xsl:call-template name="testata">
				<xsl:with-param name="dataOraConsegna">
					<xsl:value-of select="./DataOraRicezione"/>
				</xsl:with-param>
				<xsl:with-param name="identificativoSdI">
					<xsl:value-of select="./IdentificativoSdI"/>
				</xsl:with-param>
			</xsl:call-template>
			<xsl:if test="./Note">
				<cbc:Note>
					<xsl:value-of select="./Note"/>
				</cbc:Note>
			</xsl:if>
			<xsl:call-template name="sender-party"/>
			<xsl:call-template name="receiver-party"/>
			<cac:DocumentResponse>
				<cac:Response>
					<cbc:ResponseCode>RE</cbc:ResponseCode>

					<xsl:for-each select="./ListaErrori/Errore">
						<cac:Status>
							<cbc:StatusReasonCode listID="OPStatusReason">OTH</cbc:StatusReasonCode>
							<cbc:StatusReason>
								<xsl:value-of select="./Codice"/> - <xsl:value-of select="./Descrizione"/>
							</cbc:StatusReason>
							<cac:Condition>
								<cbc:AttributeID>SDI</cbc:AttributeID>
								<cbc:Description>
									<xsl:value-of select="./Suggerimento"/>
								</cbc:Description>
							</cac:Condition>
						</cac:Status>
					</xsl:for-each>


				</cac:Response>
				<xsl:call-template name="document-reference"/>
			</cac:DocumentResponse>

		</ApplicationResponse>
	</xsl:template>

	<!-- MANCATA CONSEGNA-->
	<xsl:template match="//*[local-name()='RicevutaImpossibilitaRecapito']" name="mancataConsegna">
		<ApplicationResponse>
			<xsl:call-template name="testata">
				<xsl:with-param name="dataOraConsegna">
					<xsl:value-of select="./DataOraRicezione"/>
				</xsl:with-param>
				<xsl:with-param name="identificativoSdI">
					<xsl:value-of select="./IdentificativoSdI"/>
				</xsl:with-param>
			</xsl:call-template>
			<xsl:if test="./Note">
				<cbc:Note>
					<xsl:value-of select="./Note"/>
				</cbc:Note>
			</xsl:if>
			<xsl:call-template name="sender-party"/>
			<xsl:call-template name="receiver-party"/>
			<cac:DocumentResponse>
				<cac:Response>
					<cbc:ResponseCode>IP</cbc:ResponseCode>

					<cac:Status>
						<cbc:StatusReasonCode listID="OPStatusReason">OTH</cbc:StatusReasonCode>
						<cbc:StatusReason>
							<xsl:value-of select="./Descrizione"/>
						</cbc:StatusReason>
					</cac:Status>


				</cac:Response>
				<xsl:call-template name="document-reference"/>
			</cac:DocumentResponse>

		</ApplicationResponse>
	</xsl:template>

	<!-- NOTIFICA DI ESITO CEDENTE-->
	<xsl:template match="//*[local-name()='NotificaEsito']" name="notificaEsito">
		<ApplicationResponse>
			<xsl:call-template name="testata">
				<xsl:with-param name="dataOraConsegna">
					<xsl:value-of select="current-dateTime()"/>
				</xsl:with-param>
				<xsl:with-param name="identificativoSdI">
					<xsl:value-of select="./IdentificativoSdI"/>
				</xsl:with-param>
			</xsl:call-template>
			<xsl:if test="./Note">
				<cbc:Note>
					<xsl:value-of select="./Note"/>
				</cbc:Note>
			</xsl:if>
			<xsl:call-template name="sender-party"/>
			<xsl:call-template name="receiver-party"/>
			<cac:DocumentResponse>
				<cac:Response>

					<xsl:if test="./EsitoCommittente/Esito = 'EC01'">
						<!--Accettazione-->
						<cbc:ResponseCode>AP</cbc:ResponseCode>
					</xsl:if>
					<xsl:if test="./EsitoCommittente/Esito = 'EC02'">
						<!--Rifiuto-->
						<cbc:ResponseCode>RE</cbc:ResponseCode>

						<cac:Status>
							<cbc:StatusReasonCode listID="OPStatusAction">NIN</cbc:StatusReasonCode>
							<cbc:StatusReason>
								<xsl:value-of select="./EsitoCommittente/Esito/Descrizione"/>
							</cbc:StatusReason>
						</cac:Status>
					</xsl:if>

				</cac:Response>
				<xsl:call-template name="document-reference"/>
			</cac:DocumentResponse>

		</ApplicationResponse>
	</xsl:template>

	<!-- NOTIFICA DI DECORRENZA TERMINI-->
	<xsl:template match="//*[local-name()='NotificaDecorrenzaTermini']" name="notificaDecorrenzaTermini">
		<ApplicationResponse>
			<xsl:call-template name="testata">
				<xsl:with-param name="dataOraConsegna">
					<xsl:value-of select="current-dateTime()"/>
				</xsl:with-param>
				<xsl:with-param name="identificativoSdI">
					<xsl:value-of select="./IdentificativoSdI"/>
				</xsl:with-param>
			</xsl:call-template>
			<xsl:if test="./Note">
				<cbc:Note>
					<xsl:value-of select="./Note"/>
				</cbc:Note>
			</xsl:if>
			<xsl:call-template name="sender-party"/>
			<xsl:call-template name="receiver-party"/>
			<cac:DocumentResponse>
				<cac:Response>
					<cbc:ResponseCode>AP</cbc:ResponseCode>
					<cac:Status>
						<cbc:StatusReasonCode listID="OPStatusAction">NOA</cbc:StatusReasonCode>
						<cbc:StatusReason>
							<xsl:value-of select="./Descrizione"/>
						</cbc:StatusReason>
					</cac:Status>

				</cac:Response>
				<xsl:call-template name="document-reference"/>
			</cac:DocumentResponse>

		</ApplicationResponse>
	</xsl:template>

	<!-- Attestazione avvenuta trasmissione con impossibilità di recapito-->
	<xsl:template match="//*[local-name()='AttestazioneTrasmissioneFattura']" name="attestazioneTrasmissione">
		<ApplicationResponse>
			<xsl:call-template name="testata">
				<xsl:with-param name="dataOraConsegna">
					<xsl:value-of select="./DataOraRicezione"/>
				</xsl:with-param>
				<xsl:with-param name="identificativoSdI">
					<xsl:value-of select="./IdentificativoSdI"/>
				</xsl:with-param>
			</xsl:call-template>
			<xsl:if test="./Note">
				<cbc:Note>
					<xsl:value-of select="./Note"/>
				</cbc:Note>
			</xsl:if>
			<xsl:call-template name="sender-party"/>
			<xsl:call-template name="receiver-party"/>
			<cac:DocumentResponse>
				<cac:Response>
					<cbc:ResponseCode>AP</cbc:ResponseCode>
					<cac:Status>
						<cbc:StatusReasonCode listID="OPStatusReason">OTH</cbc:StatusReasonCode>
						<cbc:StatusReason>Avvenuta trasmissione con impossibilità di recapito</cbc:StatusReason>
					</cac:Status>
				</cac:Response>
				<xsl:call-template name="document-reference"/>
			</cac:DocumentResponse>

		</ApplicationResponse>
	</xsl:template>

</xsl:stylesheet>
