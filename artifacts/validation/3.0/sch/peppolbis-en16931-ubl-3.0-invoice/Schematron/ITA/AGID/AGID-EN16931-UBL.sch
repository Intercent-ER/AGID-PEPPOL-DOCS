<?xml version="1.0" encoding="UTF-8"?>  
<pattern id="Italian-CIUS-rules" xmlns="http://purl.oclc.org/dsdl/schematron">

	<!-- UBL Extensions -->
	<rule context="/*/ext:UBLExtensions/ext:UBLExtension[ext:ExtensionURI = 'urn:fdc:agid.gov.it:fatturapa:SoggettoEmittente']/ext:ExtensionContent" flag="fatal">
		<assert test="( ( not(contains(normalize-space(cbc:TypeCode),' ')) and contains( ' CC TZ ',concat(' ',normalize-space(cbc:TypeCode),' ') ) ) )" flag="fatal" id="BR-IT-E01">[BR-IT-E01][FPA 1.6 - Soggetto Emittente] - L'estensione deve contenere un elemento cbc:TypeCode valorizzato esclusivamente con i valori 'CC' o 'TZ'.</assert>
	</rule>

	<rule context="/*/ext:UBLExtensions/ext:UBLExtension[ext:ExtensionURI = 'urn:fdc:agid.gov.it:fatturapa:TipoDocumento']/ext:ExtensionContent" flag="fatal">
		<assert test="( ( not(contains(normalize-space(cbc:TypeCode),' ')) and contains( ' TD01 TD02 TD03 TD04 TD05 TD06 TD16 TD17 TD18 TD19 TD20 TD21 TD22 TD23 TD24 TD25 TD26 TD27 ',concat(' ',normalize-space(cbc:TypeCode),' ') ) ) )" flag="fatal" id="BR-IT-E02">[BR-IT-E02][FPA 2.1.1.1 - Tipo Documento] - L'estensione deve contenere un elemento cbc:TypeCode valorizzato esclusivamente con i valori del TipoDocumento, secondo la specifica FatturaPA 1.2.1.</assert>
	</rule>

	<rule context="/*/ext:UBLExtensions/ext:UBLExtension[starts-with(ext:ExtensionURI, 'urn:fdc:agid.gov.it:fatturapa:TipoRitenuta')]/ext:ExtensionContent" flag="fatal">
		<assert test="( ( not(contains(normalize-space(cbc:TypeCode),' ')) and contains( ' RT01 RT02 RT03 RT04 RT05 RT06 ',concat(' ',normalize-space(cbc:TypeCode),' ') ) ) )" flag="fatal" id="BR-IT-E03">[BR-IT-E03][FPA 2.1.1.5.1 - Tipo Ritenuta] - L'estensione deve contenere un elemento cbc:TypeCode valorizzato esclusivamente con i valori del TipoRitenuta, secondo la specifica FatturaPA 1.2.1.</assert>
	</rule>
	
	<rule context="/*/ext:UBLExtensions/ext:UBLExtension[ext:ExtensionURI = 'urn:fdc:agid.gov.it:fatturapa:Art73']/ext:ExtensionContent" flag="fatal">
		<assert test="cbc:TypeCode = 'SI'" flag="fatal" id="BR-IT-E04">[BR-IT-E04][FPA 2.1.1.12 - Art73] - L'estensione deve contenere un elemento cbc:TypeCode valorizzato esclusivamente con il valore 'SI' per applicare l'Articolo 73 del DPR 633/72.</assert>
	</rule>

	<rule context="/*/ext:UBLExtensions/ext:UBLExtension[starts-with(ext:ExtensionURI, 'urn:fdc:agid.gov.it:fatturapa:RiepilogoIVA:Arrotondamento')]/ext:ExtensionContent" flag="fatal">
		<assert test="matches(cbc:Amount,'^[\-]?\d{1,11}\.\d{2}$')" flag="fatal" id="BR-IT-E05">[BR-IT-E05][FPA 2.2.2.4 - Arrotondamento] - L'estensione deve contenere un elemento cbc:Amount la cui lunghezza non può superare i 15 caratteri incluso 2 cifre decimali.</assert>
	</rule>

	<rule context="/*/ext:UBLExtensions/ext:UBLExtension[ext:ExtensionURI = 'urn:fdc:agid.gov.it:fatturapa:ScontoMaggiorazione']/ext:ExtensionContent" flag="fatal">
		<assert test="cac:AllowanceCharge" flag="fatal" id="BR-IT-E06">[BR-IT-E06][FPA 2.1.1.8 - Sconto Maggiorazione] - L'estensione deve contenere uno o più elementi cac:AllowanceCharge.</assert>
	</rule>

	<rule context="/*/ext:UBLExtensions/ext:UBLExtension[ext:ExtensionURI = 'urn:fdc:agid.gov.it:fatturapa:ScontoMaggiorazione']/ext:ExtensionContent/cac:AllowanceCharge" flag="fatal">
		<assert test="matches(cbc:Amount,'^[\-]?\d{1,11}\.\d{2,8}$')" flag="fatal" id="BR-IT-E07">[BR-IT-E07][FPA 2.1.1.8 - Sconto Maggiorazione] - L'importo dello sconto o maggiorazione (cbc:Amount) deve contenere da 4 fino a 21 caratteri incluso 2 cifre decimali.</assert>
		<assert test="not(cbc:MultiplierFactorNumeric) or matches(cbc:MultiplierFactorNumeric,'^\d{1,3}\.\d{2}$')" flag="fatal" id="BR-IT-E08">[BR-IT-E08][FPA 2.1.1.8 - Sconto Maggiorazione] - L'importo dello sconto/maggiorazione in percentuale, se presente, (cbc:MultiplierFactorNumeric) deve contenere da 4 fino a 6 caratteri incluso 2 cifre decimali.</assert>
	</rule>

	<rule context="/*/ext:UBLExtensions/ext:UBLExtension[ext:ExtensionURI = 'urn:fdc:agid.gov.it:fatturapa:Ritenuta']/ext:ExtensionContent" flag="fatal">
		<assert test="cac:WithholdingTaxTotal" flag="fatal" id="BR-IT-E09">[BR-IT-E09][FPA 2.1.1.5 - Dati Ritenuta] - L'estensione deve contenere uno elemento cac:WithholdingTaxTotal.</assert>
	</rule>

	<rule context="//cac:WithholdingTaxTotal" flag="fatal">
		<assert test="matches(cbc:TaxAmount,'^[\-]?\d{1,11}\.\d{2}$')" flag="fatal" id="BR-IT-E10">[BR-IT-E10][FPA 2.1.1.5 - Dati Ritenuta] - L'importo totale delle ritenute (cbc:TaxAmount) deve contenere da 4 fino a 15 caratteri incluso 2 cifre decimali.</assert>
		<assert test="count(cac:TaxSubtotal) &gt;= 1 and count(cac:TaxSubtotal) &lt;= 2" flag="fatal" id="BR-IT-E11">[BR-IT-E11][FPA 2.1.1.5 - Dati Ritenuta] - Possono essere incluse da 1 a massimo 2 ritenute (cac:TaxSubtotal).</assert>
	</rule>

	<rule context="//cac:WithholdingTaxTotal/cac:TaxSubtotal" flag="fatal">
		<assert test="matches(cbc:TaxAmount,'^[\-]?\d{1,11}\.\d{2}$')" flag="fatal" id="BR-IT-E12">[BR-IT-E12][FPA 2.1.1.5 - Dati Ritenuta] - L'importo di ogni ritenuta (cbc:TaxAmount) deve contenere da 4 fino a 15 caratteri incluso 2 cifre decimali.</assert>
	</rule>

	<rule context="//cac:WithholdingTaxTotal/cac:TaxSubtotal/cac:TaxCategory" flag="fatal">
		<assert test="cbc:ID = 'S' and matches(cbc:Percent,'^\d{1,3}\.\d{2}$') and cac:TaxScheme/cbc:ID = 'SWT'" flag="fatal" id="BR-IT-E13">[BR-IT-E13][FPA 2.1.1.5 - Dati Ritenuta] - Ogni ritenuta deve contenere la categoria della ritenuta (cac:TaxCategory) con identificativo uguale a "S" (cbc:ID), percentuale della ritenuta (cbc:Percent) da 4 fino a 6 caratteri incluso 2 cifre decimali e schema della ritenuta valorizzato con cac:TaxScheme/cbc:ID = 'SWT'.</assert>
	</rule>
	
	<!-- Document Level -->

	<rule context="/ubl:Invoice/cbc:CustomizationID[cbc:ProfileID = 'urn:fdc:peppol.eu:2017:poacc:billing:01:1.0']" flag="fatal">
		<assert test="cbc:CustomizationID = 'urn:cen.eu:en16931:2017#compliant#urn:fdc:peppol.eu:2017:poacc:billing:3.0#conformant#urn:www.agid.gov.it:trns:fattura:3.0'" flag="fatal" id="BR-IT-001">[BR-IT-001] - La Fattura italiana che estende la EN attraverso la customizzazione del CIUS PEPPOL, deve valorizzare il cbc:CustomizationID con "urn:cen.eu:en16931:2017#compliant#urn:fdc:peppol.eu:2017:poacc:billing:3.0#conformant#urn:www.agid.gov.it:trns:fattura:3.0".</assert>
	</rule>

	<rule context="/cn:CreditNote/cbc:CustomizationID[cbc:ProfileID = 'urn:fdc:peppol.eu:2017:poacc:billing:01:1.0']" flag="fatal">
		<assert test="cbc:CustomizationID = 'urn:cen.eu:en16931:2017#compliant#urn:fdc:peppol.eu:2017:poacc:billing:3.0#conformant#urn:www.agid.gov.it:trns:nota_credito:3.0'" flag="fatal" id="BR-IT-002">[BR-IT-002] - La Nota di Credito italiana che estende la EN attraverso la customizzazione del CIUS PEPPOL, deve valorizzare il cbc:CustomizationID con "urn:cen.eu:en16931:2017#compliant#urn:fdc:peppol.eu:2017:poacc:billing:3.0#conformant#urn:www.agid.gov.it:trns:nota_credito:3.0".</assert>
	</rule>
	
	<rule context="/*/cbc:ID" flag="fatal">
		<assert test="matches(.,'^(\p{IsBasicLatin})*[0-9]+(\p{IsBasicLatin})*$') and string-length(.) &gt;= 1 and string-length(.) &lt;= 20" flag="fatal" id="BR-IT-010">[BR-IT-010] - BT-1 (Invoice number) maximum lenght shall be 20 chars with at least one digit - La lunghezza dell'elemento non può superare i 20 caratteri e deve includere almeno una cifra.</assert>
	</rule>

	<rule context="/*/cac:ProjectReference/cbc:ID" flag="fatal">
		<assert test="matches(.,'^(\p{IsBasicLatin}){0,15}$')" flag="fatal" id="BR-IT-020">[BR-IT-020] - BT-11 (Project reference) maximum lenght shall be 15 chars - La lunghezza dell'elemento non può superare i 15 caratteri.</assert>
	</rule>
	
	<rule context="/*/cac:ContractDocumentReference/cbc:ID" flag="fatal">
		<assert test="matches(.,'^(\p{IsBasicLatin}){0,20}$')" flag="fatal" id="BR-IT-030">[BR-IT-030] - BT-12 (Contract reference) maximum lenght shall be 20 chars - La lunghezza dell'elemento non può superare i 20 caratteri.</assert>
	</rule>

	<rule context="/*/cac:OrderReference/cbc:ID" flag="fatal">
		<assert test="matches(.,'^(\p{IsBasicLatin}){0,20}$')" flag="fatal" id="BR-IT-040">[BR-IT-040] - BT-13 (Purchase order reference) maximum lenght shall be 20 chars - La lunghezza dell'elemento non può superare i 20 caratteri.</assert>
	</rule>

	<rule context="/*/cac:BillingReference/cac:AdditionalDocumentReference" flag="fatal">
		<assert test="cbc:ID and cbc:IssueDate" flag="fatal" id="BR-IT-041">[BR-IT-041][FPA 2.1.10] - Se si vuole fare riferimento ad una fattura principale relativa al trasporto di beni devono essere obbligatoriamente valorizzati gli estremi della fattura con gli elementi ID e IssueDate.</assert>
		<assert test="matches(cbc:ID,'^(\p{IsBasicLatin}){0,20}$')" flag="fatal" id="BR-IT-042">[BR-IT-042][FPA 2.1.10.1] - L'identificativo della fattura principale non può superare i 20 caratteri.</assert>
	</rule>
	
	<rule context="/*/cac:ReceiptDocumentReference/cbc:ID" flag="fatal">
		<assert test="matches(.,'^(\p{IsBasicLatin}){0,20}$')" flag="fatal" id="BR-IT-050">[BR-IT-050] - BT-15 (Receiving advice reference) maximum lenght shall be 20 chars - La lunghezza dell'elemento non può superare i 20 caratteri.</assert>
	</rule>
	
	<rule context="/*/cac:DespatchDocumentReference" flag="fatal">
		<assert test="matches(cbc:ID,'^(\p{IsBasicLatin}){0,20}$')" flag="fatal" id="BR-IT-060">[BR-IT-060] - BT-16 (Despatch advice reference) maximum lenght shall be 20 chars - La lunghezza dell'elemento non può superare i 20 caratteri.</assert>
		<assert test="cbc:IssueDate" flag="fatal" id="BR-IT-061">[BR-IT-061][FPA 2.1.8.2] - La data del documento di trasporto deve essere obbligatoriamente valorizzata.</assert>
	</rule>
	
	<rule context="/*/cac:OriginatorDocumentReference/cbc:ID" flag="fatal">
		<assert test="matches(.,'^(\p{IsBasicLatin}){0,15}$')" flag="fatal" id="BR-IT-070">[BR-IT-070] - BT-17 (Tender or lot reference) maximum lenght shall be 15 chars - La lunghezza dell'elemento non può superare i 15 caratteri.</assert>
	</rule>
	
	<rule context="/*/cbc:AccountingCost" flag="fatal">
		<assert test="matches(.,'^(\p{IsBasicLatin}){0,20}$')" flag="fatal" id="BR-IT-080">[BR-IT-080] - BT-19 (Buyer accounting reference) maximum lenght shall be 20 chars - La lunghezza dell'elemento non può superare i 20 caratteri.</assert>
	</rule>

	<rule context="/*/cac:BillingReference/cac:InvoiceDocumentReference/cbc:ID" flag="fatal">
		<assert test="matches(.,'^(\p{IsBasicLatin}){0,20}$')" flag="fatal" id="BR-IT-090">[BR-IT-090] - BT-25 (Preceding Invoice number) maximum lenght shall be 20 chars - La lunghezza dell'elemento non può superare i 20 caratteri.</assert>
	</rule>

	<!--rule context="/*/cac:AccountingSupplierParty/cac:Party[cac:PostalAddress/cac:Country/cbc:IdentificationCode='IT' and sum(for $i in cac:PartyIdentification/cbc:ID return if (starts-with($i, 'EORI:')) then 1 else 0) &gt; 0]" flag="fatal">
		<assert test="sum(for $i in cac:PartyIdentification/cbc:ID return if (matches($i,'^EORI:[A-Z0-9]+$') and string-length($i) &gt;= 21 and string-length($i) &lt;= 25) then 1 else 0) &gt; 0" flag="fatal" id="BR-IT-100">[BR-IT-100] - BT-29 (Seller identifier) Se il valore dell’elemento BT-40 (Seller country code) è "IT", se il valore dell'elemento BT-29 Seller identifier comincia con "EORI:", la sua lunghezza deve essere compresa fra 21 e 25 caratteri.</assert>
	</rule>
	
	<rule context="/*/cac:AccountingSupplierParty/cac:Party[cac:PostalAddress/cac:Country/cbc:IdentificationCode='IT' and sum(for $i in cac:PartyIdentification/cbc:ID return if (starts-with($i, 'ALBO:')) then 1 else 0) &gt; 0]" flag="fatal">
		<assert test="sum(for $i in cac:PartyIdentification/cbc:ID return if (matches($i,'^ALBO:[a-zA-Z]+:[A-Z0-9]+$') and string-length($i) &gt;= 1 and string-length($i) &lt;= 129) then 1 else 0) &gt; 0" flag="fatal" id="BR-IT-100">[BR-IT-100] - BT-29 (Seller identifier) Se il valore dell’elemento BT-40 (Seller country code) è "IT", se il valore dell'elemento BT-29 Seller identifier comincia con "ALBO:", la sua lunghezza non può superare i 129 caratteri e deve essere indicato come "ALBO:AlboProfessionale:NumeroIscrizioneAlbo".</assert>
	</rule>

	<rule context="/*/cac:AccountingSupplierParty/cac:Party[cac:PostalAddress/cac:Country/cbc:IdentificationCode='IT' and sum(for $i in cac:PartyIdentification/cbc:ID return if (starts-with($i, 'CF:')) then 1 else 0) &gt; 0]" flag="fatal">
		<assert test="sum(for $i in cac:PartyIdentification/cbc:ID return if (matches($i,'^CF:[A-Z0-9]{11,16}$')) then 1 else 0) &gt; 0" flag="fatal" id="BR-IT-100">[BR-IT-100] - BT-29 (Seller identifier) Se il valore dell’elemento BT-40 (Seller country code) è "IT", se il valore dell'elemento BT-29 Seller identifier comincia con "CF:", la sua lunghezza deve essere compresa fra 14 e 19 caratteri.</assert>
	</rule>
	
	<rule context="/*/cac:AccountingSupplierParty/cac:Party[cac:PostalAddress/cac:Country/cbc:IdentificationCode='IT' and sum(for $i in cac:PartyIdentification/cbc:ID return if (starts-with($i, 'REA:')) then 1 else 0) &gt; 0]" flag="fatal">
		<assert test="sum(for $i in cac:PartyIdentification/cbc:ID return if (matches($i,'^REA:[a-zA-Z0-9]+:[A-Z0-9]+$') and string-length($i) &gt;= 10 and string-length($i) &lt;= 30) then 1 else 0) &gt; 0" flag="fatal" id="BR-IT-110">[BR-IT-110] - Se il valore dell’elemento BT-40 (Seller country code) è "IT", se il valore dell'elemento BT-30 Seller legal registration identifier comincia con "REA:", la sua lunghezza deve essere compresa fra 10 e 30 caratteri e deve essere indicato come "REA:Ufficio:NumeroREA".</assert>
	</rule-->
	
	<rule context="/*/cac:AccountingSupplierParty/cac:Party[cac:PostalAddress/cac:Country/cbc:IdentificationCode='IT']/cac:PartyIdentification/cbc:ID[starts-with(., 'EORI:')]" flag="fatal">
		<assert test="matches(.,'^EORI:[A-Z0-9]{16,20}$')" flag="fatal" id="BR-IT-100">[BR-IT-100] - BT-29 (Seller identifier) Se il valore dell’elemento BT-40 (Seller country code) è "IT", se il valore dell'elemento BT-29 Seller identifier comincia con "EORI:", la sua lunghezza deve essere compresa fra 21 e 25 caratteri.</assert>
	</rule>
	
	<rule context="/*/cac:AccountingSupplierParty/cac:Party[cac:PostalAddress/cac:Country/cbc:IdentificationCode='IT']/cac:PartyIdentification/cbc:ID[starts-with(., 'ALBO:')]" flag="fatal">
		<assert test="matches(.,'^ALBO:[a-zA-Z]+:[A-Z0-9]+$') and string-length(.) &gt;= 1 and string-length(.) &lt;= 129" flag="fatal" id="BR-IT-100">[BR-IT-100] - BT-29 (Seller identifier) Se il valore dell’elemento BT-40 (Seller country code) è "IT", se il valore dell'elemento BT-29 Seller identifier comincia con "ALBO:", la sua lunghezza non può superare i 129 caratteri e deve essere indicato come "ALBO:AlboProfessionale:NumeroIscrizioneAlbo".</assert>
	</rule>

	<rule context="/*/cac:AccountingSupplierParty/cac:Party[cac:PostalAddress/cac:Country/cbc:IdentificationCode='IT']/cac:PartyIdentification/cbc:ID[starts-with(., 'CF:')]" flag="fatal">
		<assert test="matches(.,'^CF:[A-Z0-9]{11,16}$')" flag="fatal" id="BR-IT-100">[BR-IT-100] - BT-29 (Seller identifier) Se il valore dell’elemento BT-40 (Seller country code) è "IT", se il valore dell'elemento BT-29 Seller identifier comincia con "CF:", la sua lunghezza deve essere compresa fra 14 e 19 caratteri.</assert>
	</rule>
	
	<rule context="/*/cac:AccountingSupplierParty/cac:Party[cac:PostalAddress/cac:Country/cbc:IdentificationCode='IT']/cac:PartyIdentification/cbc:ID[starts-with(., 'REA:')]" flag="fatal">
		<assert test="matches(.,'^REA:[a-zA-Z0-9]+:[A-Z0-9]+$') and string-length(.) &gt;= 10 and string-length(.) &lt;= 30" flag="fatal" id="BR-IT-110">[BR-IT-110] - Se il valore dell’elemento BT-40 (Seller country code) è "IT", se il valore dell'elemento BT-30 Seller legal registration identifier comincia con "REA:", la sua lunghezza deve essere compresa fra 10 e 30 caratteri e deve essere indicato come "REA:Ufficio:NumeroREA".</assert>
	</rule>

	<rule context="/*/cac:AccountingSupplierParty/cac:Party/cac:PartyTaxScheme/cbc:CompanyID" flag="fatal">
		<assert test="matches(.,'^[a-zA-Z0-9]{0,30}$')" flag="fatal" id="BR-IT-120">[BR-IT-120] - BT-31 (Seller VAT identifier) maximum lenght shall be 30 chars - La lunghezza dell'elemento non può superare i 30 caratteri.</assert>
	</rule>

	<rule context="/*/cac:AccountingSupplierParty/cac:Party/cac:PartyTaxScheme/cbc:TaxLevelCode" flag="fatal">
		<assert test="( ( not(contains(normalize-space(.),' ')) and contains( ' RF01 RF02 RF04 RF05 RF06 RF07 RF08 RF09 RF10 RF11 RF12 RF13 RF14 RF15 RF16 RF17 RF18 RF19 ',concat(' ',normalize-space(.),' ') ) ) )" flag="fatal" id="BR-IT-121">[BR-IT-121][FPA 1.2.1.8 - Regime Fiscale] - Il Regime Fiscale (cbc:TaxLevelCode) deve essere valorizzato esclusivamente con i valori della relativa codifica, secondo la specifica FatturaPA 1.2.1.</assert>
	</rule>

	<rule context="/*/cac:AccountingSupplierParty/cac:Party/cac:PartyLegalEntity/cbc:CompanyLegalForm" flag="fatal">
		<assert test="string-length(.) &lt;= 19" flag="fatal" id="BR-IT-122">[BR-IT-122][FPA 1.2.4.3 CapitaleSociale, 1.2.4.4 SocioUnico, 1.2.4.5 StatoLiquidazione] - La lunghezza dell'elemento non può superare i 19 caratteri.</assert>
	</rule>	
	
	<rule context="/*/cac:AccountingSupplierParty/cac:Party[cac:PostalAddress/cac:Country/cbc:IdentificationCode='IT']" flag="fatal">
		<!--assert test="cac:PartyTaxScheme/cac:TaxScheme/cbc:ID = 'VAT' or matches(cac:PartyTaxScheme/cbc:CompanyID,'^[a-zA-Z0-9]{17,22}$')" flag="fatal" id="BR-IT-130">[BR-IT-130] - Se il valore dell’elemento BT-40 Seller country code è "IT", la lunghezza dell'elemento BT-32 Seller tax registration identifier deve essere compresa fra 17 e 22 caratteri.</assert-->
		<assert test="((not(contains(normalize-space(cac:PostalAddress/cbc:CountrySubentity),' ')) and contains(' AG AL AN AO AP AQ AR AT AV BA BG BI BL BN BO BR BS BT BZ CA CB CE CH CI CL CN CO CR CS CT CZ EN FC FE FG FI FM FR FU GE GO GR IM IS KR LC LE LI LO LT LU MB MC ME MI MN MO MS MT NA NO NU OG OR OT PA PC PD PE PG PI PL PN PO PR PT PU PV PZ RA RC RE RG RI RM RN RO SA SI SO SP SR SS SU SV TA TE TN TO TP TR TS TV UD VA VB VC VE VI VR VS VT VV ZA ',concat(' ',normalize-space(cac:PostalAddress/cbc:CountrySubentity),' '))))" flag="fatal" id="BR-IT-150">[BR-IT-150] - Se l'elemento BT-40 (Seller country code) ha valore "IT", per l'elemento BT-39 Seller country subdivision deve essere utilizzato uno dei valori della lista delle province italiane. Altrimenti l'informazione è riportata in allegato.</assert>
	</rule>

	<rule context="/*/cac:AccountingSupplierParty/cac:Party/cac:AgentParty/cac:PostalAddress" flag="fatal">
		<assert test="cbc:StreetName and cbc:CityName and cbc:PostalZone and cbc:CountrySubentity and cac:Country/cbc:IdentificationCode" flag="fatal" id="BR-IT-151">[BR-IT-151][FPA 1.2.3 - Stabile Organizzazione] - La Stabile Organizzazione deve fornire l'indirizzo completo di via e numero civico, comune, cap, provincia e nazione.</assert>
		<assert test="matches(cbc:StreetName,'^(\p{IsBasicLatin}){0,60}$')" flag="fatal" id="BR-IT-152">[BR-IT-152][FPA 1.2.3.1 - Indirizzo e 1.2.3.2 - NumeroCivico] - La lunghezza dell'elemento non può superare i 60 caratteri.</assert>
		<assert test="matches(cbc:Cityname,'^(\p{IsBasicLatin}){0,60}$')" flag="fatal" id="BR-IT-153">[BR-IT-153][FPA 1.2.3.4 - Comune] - La lunghezza dell'elemento non può superare i 60 caratteri.</assert>
		<assert test="matches(cbc:PostalZone,'^(\p{IsBasicLatin}){0,8}$')" flag="fatal" id="BR-IT-154">[BR-IT-154][FPA 1.2.3.3 - CAP] - La lunghezza dell'elemento non può superare 8 caratteri.</assert>
		<assert test="matches(cbc:CountrySubentity,'^[A-Z]{0,2}$')" flag="fatal" id="BR-IT-155">[BR-IT-155][FPA 1.2.3.5 - Provincia] - La lunghezza dell'elemento non può superare 2 caratteri.</assert>
	</rule>
	
	<rule context="/*/cac:AccountingSupplierParty/cac:Party/cac:ServiceProviderParty/cac:Party" flag="fatal">
		<assert test="cac:PartyTaxScheme/cbc:CompanyID and cac:PartyTaxScheme/cac:TaxScheme/cbc:ID = 'VAT' and (cac:PartyName/cbc:Name or (cac:Person/cbc:FirstName and cac:Person/cbc:FamilyName))" flag="fatal" id="BR-IT-156">[BR-IT-156][FPA 1.5 - Terzo Intermediario] - Il Terzo Intermediario o Soggetto Emittente deve contenere la P.IVA, lo schema fiscale = 'VAT', la ragione sociale o una persona fisica (nome e cognome).</assert>
	</rule>
	
	<!--rule context="/*/cac:AccountingCustomerParty/cac:Party" flag="fatal">
		<assert test="cac:PartyTaxScheme/cbc:CompanyID or (cac:PartyIdentification/cbc:ID and matches(cac:PartyIdentification/cbc:ID,'^CF:[a-zA-Z0-9]{17,22}$'))" flag="fatal" id="BR-IT-160">[BR-IT-160] - Almeno uno degli elementi  BT-48 Buyer VAT identifier e BT-46 Buyer identifier deve essere valorizzato. BT-46 Buyer identifier, se presente, deve iniziare con "CF:" e la sua lunghezza deve essere compresa fra 17 e 22 caratteri.</assert>
	</rule-->

	<!--rule context="/*/cac:AccountingCustomerParty/cac:Party[starts-with(cac:PartyLegalEntity/cbc:CompanyID, 'EORI:')]" flag="fatal">
		<assert test="matches(cac:PartyLegalEntity/cbc:CompanyID,'^EORI:[A-Z0-9]+$') and string-length(cac:PartyLegalEntity/cbc:CompanyID) &gt;= 21 and string-length(cac:PartyLegalEntity/cbc:CompanyID) &lt;= 25" flag="fatal" id="BR-IT-170">[BR-IT-170] - Se l'elemento BT-47 Buyer legal registration identifier inizia con "EORI:", la lunghezza dell'elemento BT-47 Buyer legal registration identifier deve essere compresa fra 21 e 25 caratteri.</assert>
	</rule-->
	
	<rule context="/*/cac:AccountingCustomerParty/cac:Party/cac:PartyTaxScheme/cbc:CompanyID" flag="fatal">
		<assert test="matches(.,'^[A-Z0-9]{0,30}$')" flag="fatal" id="BR-IT-180">[BR-IT-180] - BT-48 (Buyer VAT identifier) maximum lenght shall be 30 chars - La lunghezza dell'elemento non può superare i 30 caratteri.</assert>
	</rule>
	
	<rule context="/*/cac:AccountingCustomerParty/cac:Party" flag="fatal">
		<assert test="cac:PartyTaxScheme/cbc:CompanyID or (cac:PartyLegalEntity/cbc:CompanyID and matches(cac:PartyLegalEntity/cbc:CompanyID,'^CF:[A-Z0-9]{11,16}$'))" flag="fatal" id="BR-IT-510">[BR-IT-510] - Almeno uno degli elementi  BT-48 (Buyer VAT identifier) o BT-47 (Buyer legal registration identifier) deve essere valorizzato.  BT-47 (Buyer legal registration identifier), se presente, deve iniziare con 'CF:' e la sua lunghezza deve essere compresa fra 14 e 19 caratteri.</assert>
	</rule>
	
	<rule context="/*/cac:AccountingCustomerParty/cac:PartyIdentification/cbc:ID" flag="fatal">
		<assert test="matches(.,'^EORI:[A-Z0-9]{13,17}$')" flag="fatal" id="BR-IT-520">[BR-IT-520][FPA 1.4.1.3.5 - Codice EORI] - Il Codice EORI (BT-46 Buyer identifier) deve essere preceduto dal prefisso 'EORI:' ed avere la lunghezza del codice compresa fra 13 e 17 caratteri alfanumerici.</assert>
	</rule>
		
	<rule context="/*/cac:AccountingCustomerParty/cac:Party/cbc:EndpointID" flag="fatal">
		<assert test="(@schemeID='0201' and matches(.,'^[a-zA-Z0-9]{6}$')) or (@schemeID='0202' and matches(.,'^(\w+([-+.]\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*)$') and matches(.,'^.{7,256}$')) or (@schemeID='0205' and matches(.,'^[a-zA-Z0-9]{7}$'))" flag="fatal" id="BR-IT-200">[BR-IT-200] - Se l'elemento BT-49-1 (Buyer electronic address identification scheme identifier) contiene il valore "0201", l'elemento BT-49 (Buyer electronic address) 
		deve contenere un codice IPA con lunghezza pari a 6 caratteri,
		se invece l'elemento BT-49-1 contiene il valore "0202", l'elemento BT-49 deve contenere un indirizzo PEC di lunghezza compresa fra 7 e 256 caratteri,
		se invece l'elemento BT-49-1 contiene il valore "0205", l'elemento BT-49 deve contenere un Codice Destinatario con lunghezza pari a 7 caratteri.</assert>
	</rule>
	
	<rule context="/*/cac:AccountingCustomerParty/cac:Party[cac:PostalAddress/cac:Country/cbc:IdentificationCode='IT']" flag="fatal">
		<assert test="((not(contains(normalize-space(cac:PostalAddress/cbc:CountrySubentity),' ')) and contains(' AG AL AN AO AP AQ AR AT AV BA BG BI BL BN BO BR BS BT BZ CA CB CE CH CI CL CN CO CR CS CT CZ EN FC FE FG FI FM FR FU GE GO GR IM IS KR LC LE LI LO LT LU MB MC ME MI MN MO MS MT NA NO NU OG OR OT PA PC PD PE PG PI PL PN PO PR PT PU PV PZ RA RC RE RG RI RM RN RO SA SI SO SP SR SS SU SV TA TE TN TO TP TR TS TV UD VA VB VC VE VI VR VS VT VV ZA ',concat(' ',normalize-space(cac:PostalAddress/cbc:CountrySubentity),' '))))" flag="fatal" id="BR-IT-220">[BR-IT-220] - Per l'elemento BT-54 (Buyer country subdivision) deve essere utilizzato uno dei valori della lista delle province italiane. Altrimenti l'informazione è riportata in allegato.</assert>
	</rule>
	
	<rule context="/*/cac:AccountingCustomerParty/cac:Party/cac:AgentParty/cac:PostalAddress" flag="fatal">
		<assert test="cbc:StreetName and cbc:CityName and cbc:PostalZone and cbc:CountrySubentity and cac:Country/cbc:IdentificationCode" flag="fatal" id="BR-IT-221">[BR-IT-221][FPA 1.2.3 - Stabile Organizzazione] - La Stabile Organizzazione deve fornire l'indirizzo completo di via e numero civico, comune, cap, provincia e nazione.</assert>
		<assert test="matches(cbc:StreetName,'^(\p{IsBasicLatin}){0,60}$')" flag="fatal" id="BR-IT-222">[BR-IT-222][FPA 1.2.3.1 - Indirizzo e 1.2.3.2 - NumeroCivico] - La lunghezza dell'elemento non può superare i 60 caratteri.</assert>
		<assert test="matches(cbc:Cityname,'^(\p{IsBasicLatin}){0,60}$')" flag="fatal" id="BR-IT-223">[BR-IT-223][FPA 1.2.3.4 - Comune] - La lunghezza dell'elemento non può superare i 60 caratteri.</assert>
		<assert test="matches(cbc:PostalZone,'^(\p{IsBasicLatin}){0,8}$')" flag="fatal" id="BR-IT-224">[BR-IT-224][FPA 1.2.3.3 - CAP] - La lunghezza dell'elemento non può superare 8 caratteri.</assert>
		<assert test="matches(cbc:CountrySubentity,'^[A-Z]{0,2}$')" flag="fatal" id="BR-IT-225">[BR-IT-225][FPA 1.2.3.5 - Provincia] - La lunghezza dell'elemento non può superare 2 caratteri.</assert>
	</rule>

	<rule context="/*/cac:AccountingCustomerParty/cac:Party/cac:PowerOfAttorney/cac:AgentParty" flag="fatal">
		<assert test="cac:PartyTaxScheme/cbc:CompanyID and cac:PartyTaxScheme/cac:TaxScheme/cbc:ID = 'VAT' and cac:PartyLegalEntity/cbc:RegistrationName and (not(cac:Person) or (cac:Person/cbc:FirstName and cac:Person/cbc:FamilyName))" flag="fatal" id="BR-IT-226">[BR-IT-226][FPA 1.4.4 - Rappresentante Fiscale del Cliente] - Il Rappresentante Fiscale del Cliente deve contenere la P.IVA, lo schema fiscale = 'VAT', la ragione sociale e se viene specificata una persona fisica, il nome e cognome.</assert>
	</rule>
	
	<rule context="/*/cac:TaxRepresentativeParty/cac:PartyIdentification/cbc:ID" flag="fatal">
		<assert test="matches(.,'^CF:[A-Z0-9]{11,16}$')" flag="fatal" id="BR-IT-228">[BR-IT-228][FPA 1.3.1.2 - Codice Fiscale] - Il Codice Fiscale deve essere preceduto dal prefisso 'CF:' ed avere la lunghezza del codice compresa fra 11 e 16 caratteri alfanumerici.</assert>
		<assert test="matches(.,'^EORI:[A-Z0-9]{13,17}$')" flag="fatal" id="BR-IT-229">[BR-IT-229][FPA 1.3.1.3.5 - Codice EORI] - Il Codice EORI deve essere preceduto dal prefisso 'EORI:' ed avere la lunghezza del codice compresa fra 13 e 17 caratteri alfanumerici.</assert>
	</rule>
	
	<rule context="/*/cac:TaxRepresentativeParty/cac:PartyTaxScheme/cbc:CompanyID" flag="fatal">
		<assert test="matches(.,'^[A-Z0-9]{0,30}$')" flag="fatal" id="BR-IT-230">[BR-IT-230] - BT-63 (Seller tax representative VAT identifier) maximum lenght shall be 30 chars - La lunghezza dell'elemento non può superare i 30 caratteri.</assert>
	</rule>
	
	<rule context="/*/cac:Delivery/cac:DeliveryLocation/cac:Address[cac:Country/cbc:IdentificationCode='IT']" flag="fatal">
		<assert test="cbc:StreetName and cbc:CityName and cbc:PostalZone" flag="fatal" id="BR-IT-240">[BR-IT-240] - Se il valore dell’elemento BT-80 Deliver to country code è ”IT”, gli elementi BT-75 (Deliver to address line 1), BT-77 (Deliver to city) and BT-78 (Deliver to post code) devono essere obbligatoriamente valorizzati.</assert>
		<assert test="((not(contains(normalize-space(cbc:CountrySubentity),' ')) and contains(' AG AL AN AO AP AQ AR AT AV BA BG BI BL BN BO BR BS BT BZ CA CB CE CH CI CL CN CO CR CS CT CZ EN FC FE FG FI FM FR FU GE GO GR IM IS KR LC LE LI LO LT LU MB MC ME MI MN MO MS MT NA NO NU OG OR OT PA PC PD PE PG PI PL PN PO PR PT PU PV PZ RA RC RE RG RI RM RN RO SA SI SO SP SR SS SU SV TA TE TN TO TP TR TS TV UD VA VB VC VE VI VR VS VT VV ZA ',concat(' ',normalize-space(cbc:CountrySubentity),' '))))" flag="fatal" id="BR-IT-250">[BR-IT-250] - Per l'elemento BT-79 (Deliver to country subdivision) deve essere utilizzato uno dei valori della lista delle province italiane. Altrimenti l'informazione è riportata in allegato.</assert>
	</rule>
	
	<rule context="/*/cac:Delivery/cac:CarrierParty" flag="fatal">
		<assert test="not(cac:PartyIdentification/cbc:ID) or matches(cac:PartyIdentification/cbc:ID,'^CF:[A-Z0-9]{11,16}$')" flag="fatal" id="BR-IT-251">[BR-IT-251][FPA 2.1.9.1.2 - Codice Fiscale] - Il Codice Fiscale deve essere preceduto dal prefisso 'CF:' ed avere la lunghezza del codice compresa fra 11 e 16 caratteri alfanumerici.</assert>
		<assert test="matches(cac:PartyName/cbc:Name,'^(\p{IsBasicLatin}){0,80}$') or (matches(cac:Person/cbc:FirstName,'^(\p{IsBasicLatin}){0,60}$') and matches(cac:Person/cbc:FamilyName,'^(\p{IsBasicLatin}){0,60}$'))" flag="fatal" id="BR-IT-252">[BR-IT-252][FPA 2.1.9.1.3 - Anagrafica] - Se la Denominazione del Vettore è valorizzata, la sua lunghezza non può superare 80 caratteri, alternativamente, se è invece valorizzato il Nome e il Cognome, la loro lunghezza non potrà superare 60 caratteri.</assert>
		<assert test="matches(cac:PartyTaxScheme/cbc:CompanyID,'^[a-zA-Z0-9]{0,30}$')" flag="fatal" id="BR-IT-253">[BR-IT-253][FPA 2.1.9.1.1 - Partita IVA] - La lunghezza dell'elemento non può superare i 30 caratteri.</assert>
		<assert test="cac:PartyTaxScheme/cac:TaxScheme/cbc:ID = 'VAT'" flag="fatal" id="BR-IT-254">[BR-IT-254] - L'identificativo del TaxScheme deve essere valorizzato con 'VAT'.</assert>
		<assert test="not(cac:Person/cac:IdentityDocumentReference) or (matches(cac:Person/cac:IdentityDocumentReference/cbc:ID,'^[A-Z0-9]{0,20}$') and cac:Person/cac:IdentityDocumentReference/cbc:DocumentTypeCode = '40')" flag="fatal" id="BR-IT-255">[BR-IT-255][FPA 2.1.9.1.4 - Numero Licenza Guida] - Se il Numero Licenza Guida è valorizzata, la sua lunghezza non può superare 20 caratteri e il tipo documento (cbc:DocumentTypeCode) deve essere '40'.</assert>
	</rule>

	<rule context="/*/cac:Delivery/cac:Despatch" flag="fatal">
		<assert test="not(cbc:Instructions) or matches(cbc:Instructions,'^(\p{IsBasicLatin}){0,100}$')" flag="fatal" id="BR-IT-261">[BR-IT-261][FPA 2.1.9.3 - Causale Trasporto] - La lunghezza dell'elemento non può superare i 100 caratteri.</assert>
	</rule>

	<rule context="/*/cac:Delivery/cac:Shipment" flag="fatal">
		<assert test="(not(cbc:GrossWeightMeasure) or matches(cbc:GrossWeightMeasure,'^[0-9]{1,4}\.[0-9]{1,2}$')) and (not(cbc:NetWeightMeasure) or matches(cbc:NetWeightMeasure,'^[0-9]{1,4}\.[0-9]{1,2}$'))" flag="fatal" id="BR-IT-256">[BR-IT-256][FPA 2.1.9.7 - Peso Lordo, FPA 2.1.9.8 - Peso Netto] - La lunghezza del Peso Lordo o Netto deve essere da 4 a 7 caratteri, incluse 1 o 2 cifre decimali.</assert>
		<assert test="not(cbc:TotalTransportHandlingUnitQuantity) or matches(cbc:TotalTransportHandlingUnitQuantity,'^[0-9]{1,9999}$')" flag="fatal" id="BR-IT-257">[BR-IT-257][FPA 2.1.9.4 - Numero Colli] - Il Numero di Colli può essere da 1 a 9999.</assert>
		<assert test="not(cac:GoodsItem/cbc:Description) or matches(cac:GoodsItem/cbc:Description,'^(\p{IsBasicLatin}){0,100}$')" flag="fatal" id="BR-IT-258">[BR-IT-258][FPA 2.1.9.5 - Descrizione Merce] - La lunghezza dell'elemento non può superare i 100 caratteri.</assert>
		<assert test="not(cac:ShipmentStage/cbc:TransportMeansTypeCode) or matches(cac:ShipmentStage/cbc:TransportMeansTypeCode,'^(\p{IsBasicLatin}){0,80}$')" flag="fatal" id="BR-IT-259">[BR-IT-259][FPA 2.1.9.2 - Mezzo di Trasporto] - La lunghezza dell'elemento non può superare gli 80 caratteri.</assert>
	</rule>
	
	<rule context="/*/cac:DeliveryTerms/cbc:ID" flag="fatal">
		<assert test="matches(.,'^[a-zA-Z0-9]{3,3}$')" flag="fatal" id="BR-IT-262">[BR-IT-262][FPA 2.1.9.11 - Tipo Resa Merce] - La lunghezza dell'elemento deve essere di 3 caratteri.</assert>
	</rule>
	
	<rule context="/*/cac:PaymentMeans" flag="fatal">
		<assert test="." flag="fatal" id="BR-IT-260">[BR-IT-260] - Il gruppo di elementi BG-16 (Payment instructions) deve essere obbligatorio.</assert>
		<assert test="matches(cac:PayeeFinancialAccount/cbc:ID, '^[a-zA-Z]{2}[0-9]{2}[a-zA-Z0-9]{11,30}$')" flag="fatal" id="BR-IT-270">[BR-IT-270] - L'identificativo del pagamento BT-84 (Payment account identifier) deve essere un codice IBAN.</assert>
		<assert test="matches(cac:PayeeFinancialAccount/cac:FinancialInstitutionBranch/cbc:ID, '^[A-Z]{6}[A-Z2-9][A-NP-Z0-9]([A-Z0-9]{3}){0,1}$') or not(cac:PayeeFinancialAccount/cac:FinancialInstitutionBranch)" flag="fatal" id="BR-IT-280">[BR-IT-280] - La lunghezza dell'elemento deve essere compresa fra 8 e 11 caratteri (BIC).</assert>
	</rule>
	
	<rule context="/*/cac:PaymentTerms/cbc:SettlementDiscountAmount" flag="fatal">
		<assert test="matches(.,'^[\-]?\d{1,11}\.\d{2}$')" flag="fatal" id="BR-IT-281">[BR-IT-281][FPA 2.4.2.17 - Sconto Pagamento Anticipato] - La lunghezza dell'elemento deve essere di almeno 4 caratteri e non può superare i 15 caratteri incluso 2 cifre decimali.</assert>
	</rule>

	<rule context="/*/cac:PaymentTerms/cbc:PenaltyAmount" flag="fatal">
		<assert test="matches(.,'^[\-]?\d{1,11}\.\d{2}$')" flag="fatal" id="BR-IT-282">[BR-IT-282][FPA 2.4.2.19 - Penalita Pagamenti Ritardati] - La lunghezza dell'elemento deve essere di almeno 4 caratteri e non può superare i 15 caratteri incluso 2 cifre decimali.</assert>
	</rule>
	
	<rule context="/*/cac:AllowanceCharge/cbc:Amount" flag="fatal">
		<assert test="matches(.,'^[\-]?\d{1,11}\.\d{2}$')" flag="fatal" id="BR-IT-290">[BR-IT-290] - La lunghezza dell'elemento non può superare i 15 caratteri incluso 2 cifre decimali.</assert>
	</rule>
	
	<rule context="/*/cac:LegalMonetaryTotal/cbc:TaxInclusiveAmount" flag="fatal">
		<assert test="matches(.,'^[\-]?\d{1,11}\.\d{2}$')" flag="fatal" id="BR-IT-300">[BR-IT-300] - BT-112 (Invoice total amount with VAT) maximum length shall be 15, including two fraction digits - La lunghezza dell'elemento non può superare i 15 caratteri incluso 2 cifre decimali.</assert>
	</rule>
	
	<rule context="/*/cac:LegalMonetaryTotal/cbc:PayableRoundingAmount" flag="fatal">
		<assert test="matches(.,'^[\-]?\d{1,11}\.\d{2}$')" flag="fatal" id="BR-IT-310">[BR-IT-310] - BT-114 (Rounding amount) maximum length shall be 15, including two fraction digits - La lunghezza dell'elemento non può superare i 15 caratteri incluso 2 cifre decimali.</assert>
	</rule>
	
	<rule context="/*/cac:LegalMonetaryTotal/cbc:PayableAmount" flag="fatal">
		<assert test="matches(.,'^[\-]?\d{1,11}\.\d{2}$')" flag="fatal" id="BR-IT-320">[BR-IT-320] - BT-115 (Amount due for payment) maximum length shall be 15, including two fraction digits - La lunghezza dell'elemento non può superare i 15 caratteri incluso 2 cifre decimali.</assert>
	</rule>
	
	<rule context="/*/cac:TaxTotal/cac:TaxSubtotal/cbc:TaxableAmount" flag="fatal">
		<assert test="matches(.,'^[\-]?\d{1,11}\.\d{2}$')" flag="fatal" id="BR-IT-330">[BR-IT-330] - BT-116 (VAT category taxable amount) maximum length shall be 15, including two fraction digits - La lunghezza dell'elemento non può superare i 15 caratteri incluso 2 cifre decimali.</assert>
	</rule>
	
	<rule context="/*/cac:TaxTotal/cac:TaxSubtotal/cbc:TaxAmount" flag="fatal">
		<assert test="matches(.,'^[\-]?\d{1,11}\.\d{2}$')" flag="fatal" id="BR-IT-340">[BR-IT-340] - BT-117 (VAT category tax amount) maximum length shall be 15, including two fraction digits - La lunghezza dell'elemento non può superare i 15 caratteri incluso 2 cifre decimali.</assert>
	</rule>
	
	<!-- Added "B" for split payment due to the A deviation -->
	<rule context="//cac:TaxCategory/cbc:ID | //cac:ClassifiedTaxCategory/cbc:ID" flag="fatal">
		<assert test="contains(' AE B E S G K Z ', concat(' ',normalize-space(.),' '))" flag="fatal" id="BR-IT-350">[BR-IT-350] - For VAT category code only values AE B E S G K Z shall be allowed - I valori accettati sono esclusivamente AE B E S G K Z secondo il provvedimento AdE n.99370 del 18-apr-2019 e succ.vi.</assert>
	</rule>
	
	<rule context="//cac:AdditionalDocumentReference[cbc:ID and not(cbc:DocumentTypeCode)]" flag="fatal">
		<assert test="cac:Attachment/cac:ExternalReference/cbc:URI or cac:Attachment/cbc:EmbeddedDocumentBinaryObject" flag="fatal" id="BR-IT-360">[BR-IT-360] - If BT-122 is not empty and the reference is not an invoice object, then BT-124 or BT-125 shall be mandatory - Se l'elemento BT-122 (Supporting document reference) è valorizzato e non è un riferimento all'oggetto della fattura, è obbligatorio valorizzare almeno uno degli elementi BT-124 (External document location) e BT-125 (Attached document).</assert>
	</rule>

	<!-- BOLLO -->
	<rule context="/*/cac:AllowanceCharge[cbc:AllowanceChargeReasonCode = 'SAE']" flag="fatal">
		<assert test="cbc:ChargeIndicator = true() and cbc:AllowanceChargeReason = 'BOLLO' and cac:TaxCategory[cbc:ID = 'Z' and cbc:Percent = 0] and ../cac:LegalMonetaryTotal/cbc:TaxExclusiveAmount &gt; 77.47 and not(../cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory[cbc:ID = 'S' or cbc:ID = 'B']) and ((cbc:Amount = 0.00 and ../cac:TaxTotal/cac:TaxSubtotal[cbc:TaxableAmount = 0.00]/cac:TaxCategory[cbc:ID = 'Z' and cbc:Percent = 0]) or (cbc:Amount = 2.00 and ../cac:TaxTotal/cac:TaxSubtotal[cbc:TaxableAmount = 2.00]/cac:TaxCategory[cbc:ID = 'Z' and cbc:Percent = 0]))" flag="fatal" id="BR-IT-480">[BR-IT-480] - Se la fattura è soggetta alla marca da bollo, il motivo della maggiorazione deve essere posto a "BOLLO", la fattura non deve contenere IVA e l'importo deve essere superiore a 77.47 EURO. Se l'importo del bollo viene rifatturato al cliente, il suo valore deve essere posto a 2.00 EUR come operazione non imponibile IVA (TaxCategory/ID = 'Z') e il relativo riepilogo IVA deve riportare un imponibile di 2.00 EUR".</assert>
	</rule>

	<!-- Esigibilità: Split Payment -->
	<rule context="/*/cac:TaxTotal[cac:TaxSubtotal/cac:TaxCategory/cbc:ID = 'B']" flag="fatal">
		<assert test="not(/*/cac:TaxTotal[cac:TaxSubtotal/cac:TaxCategory/cbc:ID = 'S']) and /*/cac:PaymentTerms/cbc:Note" flag="fatal" id="BR-IT-510">[BR-IT-510] - Se la fattura è soggetta allo Split Payment questa deve esclusivamente utilizzare il TaxCategory = 'B' e deve indicare nei termini di pagamento "The total is without the VAT amount due to Split payment (ex art.17-ter del DPR 633/1972)".</assert>
	</rule>

	<!-- Line Level -->
	
	<rule context="/*/cac:InvoiceLine/cac:DocumentReference/cbc:ID" flag="fatal">
		<assert test="matches(.,'^(\p{IsBasicLatin}){0,100}$')" flag="fatal" id="BR-IT-370">[BR-IT-370] - BT-128 (Invoice line object identifier) maximum lenght shall be 100 chars - La lunghezza dell'elemento non può superare i 100 caratteri.</assert>
	</rule>
	
	<rule context="/*/cac:InvoiceLine/cbc:InvoicedQuantity" flag="fatal">
		<assert test="matches(.,'^\d{1,12}\.\d{2,8}$')" flag="fatal" id="BR-IT-380">[BR-IT-380] - BT-129 (Invoiced quantity) maximum lenght shall be 21 chars and BT allowed fraction digits shall be 8 - La lunghezza dell'elemento non deve essere superiore a 21 caratteri e l'elemento dovrà avere 8 cifre decimali.</assert>
	</rule>
	
	<rule context="/*/cac:InvoiceLine/cbc:LineExtensionAmount" flag="fatal">
		<assert test="matches(.,'^\d*(\.\d{0,2})?$') and string-length(.) &gt;= 1 and string-length(.) &lt;= 15" flag="fatal" id="BR-IT-390">[BR-IT-390] - BT-131 (Invoice line net amount) BT maximum length shall be 15, including two fraction digits - La lunghezza dell'elemento non può superare i 15 caratteri incluso 2 cifre decimali.</assert>
	</rule>
	
	<rule context="/*/cac:InvoiceLine/cac:OrderLineReference/cbc:LineID" flag="fatal">
		<assert test="matches(.,'^(\p{IsBasicLatin}){0,20}$')" flag="fatal" id="BR-IT-400">[BR-IT-400] - BT-132 (Referenced purchase order line reference) maximum lenght shall be 20 chars - La lunghezza dell'elemento non può superare i 20 caratteri.</assert>
	</rule>
	
	<rule context="/*/cac:InvoiceLine/cac:OrderLineReference/cac:OrderReference/cbc:ID" flag="fatal">
		<assert test="matches(.,'^(\p{IsBasicLatin}){0,20}$')" flag="fatal" id="BR-IT-401">[BR-IT-401][FPA 2.1.2.2 - Numero Ordine] - La lunghezza dell'elemento non può superare i 20 caratteri.</assert>
	</rule>

	<rule context="/*/cac:InvoiceLine/cac:DespatchLineReference/cbc:LineID" flag="fatal">
		<assert test=".='NA'" flag="fatal" id="BR-IT-402">[BR-IT-402] - Il riferimento ad una riga DDT dalla riga fattura non supportato da SDI, valorizzarlo sempre con 'NA'.</assert>
	</rule>
	
	<rule context="/*/cac:InvoiceLine/cac:DespatchLineReference/cac:DocumentReference/cbc:ID" flag="fatal">
		<assert test="matches(.,'^(\p{IsBasicLatin}){0,20}$')" flag="fatal" id="BR-IT-403">[BR-IT-403][FPA 2.1.8.1 - Numero DDT] - La lunghezza dell'elemento non può superare i 20 caratteri.</assert>
	</rule>
	
	<rule context="/*/cac:InvoiceLine/cac:DespatchLineReference/cac:DocumentReference" flag="fatal">
		<assert test="cbc:IssueDate" flag="fatal" id="BR-IT-404">[BR-IT-404][FPA 2.1.8.2] - La data del documento di trasporto deve essere obbligatoriamente valorizzata.</assert>
	</rule>
	
	<rule context="/*/cac:InvoiceLine/cbc:AccountingCost" flag="fatal">
		<assert test="matches(.,'^(\p{IsBasicLatin}){0,20}$')" flag="fatal" id="BR-IT-410">[BR-IT-410] - BT-133 (Invoice line Buyer accounting reference) maximum lenght shall be 20 chars - La lunghezza dell'elemento non può superare i 20 caratteri.</assert>
	</rule>
	
	<rule context="/*/cac:InvoiceLine/cac:AllowanceCharge/cbc:Amount" flag="fatal">
		<assert test="matches(.,'^\d*(\.\d{0,2})?$') and string-length(.) &gt;= 1 and string-length(.) &lt;= 15" flag="fatal" id="BR-IT-420">[BR-IT-420][FPA 2.2.1.10.3 - Importo] - La lunghezza dell'elemento non può superare i 15 caratteri incluso 2 cifre decimali.</assert>
	</rule>
	
	<rule context="/*/cac:InvoiceLine/cac:Price/cbc:PriceAmount" flag="fatal">
		<assert test="matches(.,'^[\-]?\d{1,11}\.\d{2,8}$')" flag="fatal" id="BR-IT-430">[BR-IT-430] - BT-146 (Item net price) maximum length shall be 21 chars and BT allowed fraction digits shall be 8 - La lunghezza dell'elemento non deve essere superiore a 21 caratteri e l'elemento dovrà avere 8 cifre decimali.</assert>
	</rule>
	
	<rule context="/*/cac:InvoiceLine/cac:Item/cac:SellersItemIdentification/cbc:ID" flag="fatal">
		<assert test="matches(.,'^(\p{IsBasicLatin}){0,35}$')" flag="fatal" id="BR-IT-440">[BR-IT-440] - BT-155 (Item Seller's identifier) maximum lenght shall be 35 chars - La lunghezza dell'elemento non può superare i 35 caratteri.</assert>
	</rule>
	
	<!--rule context="/*/cac:InvoiceLine/cac:DocumentReference/cbc:ID" flag="fatal">
		<assert test="matches(.,'^(\p{IsBasicLatin}){0,35}$')" flag="fatal" id="BR-IT-450">[BR-IT-450] - BT-156 (Item Buyer's identifier) maximum lenght shall be 35 chars - La lunghezza dell'elemento non può superare i 35 caratteri.</assert>
	</rule-->
	
	<!--rule context="/*/cac:InvoiceLine/cac:DocumentReference/cbc:ID" flag="fatal">
		<assert test="matches(.,'^(\p{IsBasicLatin}){0,35}$')" flag="fatal" id="BR-IT-460">[BR-IT-460] - BT-157 (Item standard identifier) maximum lenght shall be 35 chars - La lunghezza dell'elemento non può superare i 35 caratteri.</assert>
	</rule-->
	
	<rule context="/*/cac:InvoiceLine/cac:Item/cac:CommodityClassification/cbc:ItemClassificationCode" flag="fatal">
		<assert test="matches(.,'^(\p{IsBasicLatin}){0,35}$')" flag="fatal" id="BR-IT-470">[BR-IT-470] - BT-158 (Item classification identifier) maximum lenght shall be 35 chars - La lunghezza dell'elemento non può superare i 35 caratteri.</assert>
	</rule>
	
</pattern>

