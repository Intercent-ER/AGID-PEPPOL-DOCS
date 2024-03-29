<pattern id="Italy-CIUS-rules" xmlns="http://purl.oclc.org/dsdl/schematron">

	<!-- Document Level -->

	<rule context="/*" flag="fatal">
		<assert test="cac:PaymentMeans" flag="fatal" id="BR-IT-260">[BR-IT-260][FPA 2.4 DatiPagamento] - The group element BG-16 (Payment instructions) is mandatory - Il gruppo di elementi BG-16 (Payment instructions) deve essere obbligatorio.</assert>
		<assert test="cac:PaymentTerms/cbc:Note" flag="fatal" id="BR-IT-261">[BR-IT-261][FPA 2.4.1 CondizioniPagamento, 2.4.2.4 GiorniTerminiPagamento] - BT-20 (Payment Terms) is mandatory - L'elemento BT-20 Payment Terms deve essere obbligatoriamente valorizzato.</assert>
	</rule>
	
	<!-- BOLLO -->

	<rule context="/*/cac:AllowanceCharge[cbc:AllowanceChargeReasonCode = 'SAE' and ../cac:AccountingSupplierParty/cac:Party[cac:PostalAddress/cac:Country/cbc:IdentificationCode='IT']]" flag="fatal">
	<assert test="(cbc:AllowanceChargeReason = 'BOLLO' and cac:TaxCategory[cbc:ID = 'Z' and cbc:Percent = 0] and cbc:Amount=0)" 
			  flag="fatal" id="BR-IT-DC-480">[BR-IT-DC-480] - Se l’elemento BT-40 (Seller country code) ha valore "IT", la fattura è soggetta alla marca da bollo e l'importo della fattura è superiore a 77,47 euro, allora il BT-105 (Document level charge reason code) deve essere posto a “SAE”; il BT-104 (Document level charge reason) deve essere posto a “BOLLO”; il BT-99 (Document level charge amount) deve essere posto a 0; il BT-95 (Document level charge VAT category code) deve essere posto a "Z" (zero).</assert>
	</rule>
	
	<rule context="/*[cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode!='IT']" flag="fatal">
		<assert test="cbc:ProfileID = 'urn:fdc:peppol.eu:2017:poacc:billing:01:1.0' and cbc:CustomizationID = 'urn:cen.eu:en16931:2017#compliant#urn:fdc:peppol.eu:2017:poacc:billing:3.0#compliant#urn:www.agid.gov.it:trns:fattura:3'" flag="fatal" id="BR-IT-001">[BR-IT-001] - If BT-40 (Seller country code) is valued differently from "IT", BT-24 must be valued as follows: urn:cen.eu:en16931:2017#compliant#urn:fdc:peppol.eu:2017:poacc:billing:3.0#compliant#urn:www.agid.gov.it:trns:fattura:3 - Se il valore dell’elemento BT-40 (Seller country code) è diverso da "IT", il BT-24 deve essere valorizzato come segue: urn:cen.eu:en16931:2017#compliant#urn:fdc:peppol.eu:2017:poacc:billing:3.0#compliant#urn:www.agid.gov.it:trns:fattura:3</assert>
	</rule>
	
	<rule context="/*/cbc:ID" flag="fatal">
		<assert test="matches(.,'^(\p{IsBasicLatin})*[0-9]+(\p{IsBasicLatin})*$') and string-length(.) &gt;= 1 and string-length(.) &lt;= 20" flag="fatal" id="BR-IT-010">[BR-IT-010][FPA 2.1.1.4 Numero] - BT-1 (Invoice number) maximum lenght shall be 20 chars with at least one digit - La lunghezza dell'elemento non può superare i 20 caratteri e deve includere almeno una cifra.</assert>
	</rule>

	<rule context="/*/cac:ProjectReference/cbc:ID" flag="fatal">
		<assert test="matches(.,'^(\p{IsBasicLatin}){0,15}$')" flag="fatal" id="BR-IT-020">[BR-IT-020][FPA 2.1.3.6 CodiceCUP] - BT-11 (Project reference) maximum lenght shall be 15 chars - La lunghezza dell'elemento non può superare i 15 caratteri.</assert>
	</rule>
	
	<rule context="/*/cac:ContractDocumentReference/cbc:ID" flag="fatal">
		<assert test="matches(.,'^(\p{IsBasicLatin}){0,20}$')" flag="fatal" id="BR-IT-030">[BR-IT-030][FPA 2.1.3.2 IdDocumento] - BT-12 (Contract reference) maximum lenght shall be 20 chars - La lunghezza dell'elemento non può superare i 20 caratteri.</assert>
	</rule>

	<rule context="/*/cac:OrderReference/cbc:ID" flag="fatal">
		<assert test="matches(.,'^(\p{IsBasicLatin}){0,20}$')" flag="fatal" id="BR-IT-040">[BR-IT-040][FPA 2.1.2.2. IdDocumento] - BT-13 (Purchase order reference) maximum lenght shall be 20 chars - La lunghezza dell'elemento non può superare i 20 caratteri.</assert>
	</rule>

	<rule context="/*/cac:ReceiptDocumentReference/cbc:ID" flag="fatal">
		<assert test="matches(.,'^(\p{IsBasicLatin}){0,20}$')" flag="fatal" id="BR-IT-050">[BR-IT-050][FPA 2.1.5.2 IdDocumento] - BT-15 (Receiving advice reference) maximum lenght shall be 20 chars - La lunghezza dell'elemento non può superare i 20 caratteri.</assert>
	</rule>
	
	<rule context="/*/cac:DespatchDocumentReference" flag="fatal">
		<assert test="matches(cbc:ID,'^(\p{IsBasicLatin}){0,20}$')" flag="fatal" id="BR-IT-060">[BR-IT-060][FPA 2.1.8.1 NumeroDDT] - BT-16 (Despatch advice reference) maximum lenght shall be 20 chars - La lunghezza dell'elemento non può superare i 20 caratteri.</assert>
	</rule>
	
	<rule context="/*/cac:OriginatorDocumentReference/cbc:ID" flag="fatal">
		<assert test="matches(.,'^(\p{IsBasicLatin}){0,15}$')" flag="fatal" id="BR-IT-070">[BR-IT-070][FPA 2.1.3.7 CodiceCIG] - BT-17 (Tender or lot reference) maximum lenght shall be 15 chars - La lunghezza dell'elemento non può superare i 15 caratteri.</assert>
	</rule>
	
	<rule context="/*/cbc:AccountingCost" flag="fatal">
		<assert test="matches(.,'^(\p{IsBasicLatin}){0,20}$')" flag="fatal" id="BR-IT-080">[BR-IT-080][FPA 1.2.6 RiferimentoAmministrazione] - BT-19 (Buyer accounting reference) maximum lenght shall be 20 chars - La lunghezza dell'elemento non può superare i 20 caratteri.</assert>
	</rule>

	<rule context="/*/cac:BillingReference/cac:InvoiceDocumentReference/cbc:ID" flag="fatal">
		<assert test="matches(.,'^(\p{IsBasicLatin}){0,20}$')" flag="fatal" id="BR-IT-090">[BR-IT-090][FPA 2.1.6.2 IdDocumento] - BT-25 (Preceding Invoice number) maximum lenght shall be 20 chars - La lunghezza dell'elemento non può superare i 20 caratteri.</assert>
	</rule>

	<rule context="/*/cac:AccountingSupplierParty/cac:Party[cac:PostalAddress/cac:Country/cbc:IdentificationCode='IT']/cac:PartyIdentification/cbc:ID[starts-with(., 'EORI:')]" flag="fatal">
		<assert test="matches(.,'^EORI:[A-Z0-9]{18,22}$')" flag="fatal" id="BR-IT-DC-100A">[BR-IT-DC-100A][FPA 1.2.1.3.5 CodEORI] - Se il valore dell’elemento BT-40 (Seller country code) è "IT", se il valore dell'elemento BT29 (Seller identifier) comincia con "EORI:", la sua lunghezza deve essere compresa fra 18 e 22 caratteri.</assert>
	</rule>
	
	<rule context="/*/cac:AccountingSupplierParty/cac:Party[cac:PostalAddress/cac:Country/cbc:IdentificationCode='IT']/cac:PartyIdentification/cbc:ID[starts-with(., 'ALBO:')]" flag="fatal">
		<assert test="matches(.,'^ALBO:[a-zA-Z]+(#[A-Z0-9\-]+)*$') and string-length(.) &gt;= 1 and string-length(.) &lt;= 137" flag="fatal" id="BR-IT-DC-100B">[BR-IT-DC-100B][FPA 1.2.1.4 AlboProfessionale, 1.2.1.6 NumeroIscrizioneAlbo, 1.2.1.7 DataIscrizioneAlbo] - Se il valore dell’elemento BT-40 (Seller country code) è "IT", se il valore dell'elemento BT-29 (Seller identifier) comincia con "ALBO:", la sua lunghezza non può superare i 137 caratteri e può essere indicato come "ALBO:AlboProfessionale#NumeroIscrizioneAlbo#DataIscrizione" (con Data nel formato AAAA-MM-GG).</assert>
	</rule>

	<rule context="/*/cac:AccountingSupplierParty/cac:Party[cac:PostalAddress/cac:Country/cbc:IdentificationCode='IT']/cac:PartyIdentification/cbc:ID[starts-with(., 'REA:')]" flag="fatal">
		<assert test="matches(.,'^REA:[a-zA-Z0-9]+#[A-Z0-9]+$') and string-length(.) &gt;= 8 and string-length(.) &lt;= 27" flag="fatal" id="BR-IT-DC-100C">[BR-IT-DC-100C][FPA 1.2.4.1 Ufficio, 1.2.4.2 NumeroREA] - Se il valore dell’elemento BT-40 (Seller country code) è "IT", se il valore dell'elemento BT-29 (Seller identifier) comincia con "REA:", la sua lunghezza deve essere compresa fra 8 e 27 caratteri e deve essere indicato come "REA:Ufficio#NumeroREA".</assert>
	</rule>

	<rule context="/*/cac:AccountingSupplierParty/cac:Party[cac:PostalAddress/cac:Country/cbc:IdentificationCode='IT']/cac:PartyLegalEntity" flag="fatal">
		<assert test="cbc:CompanyID[@schemeID='0210']" flag="fatal" id="BR-IT-DC-110A">[BR-IT-DC-110A][FPA 1.2.1.2 CodiceFiscale] - Se il valore dell’elemento BT-40 Seller country code è “IT”, gli elementi devono essere obbligatoriamente valorizzati.</assert>
		<assert test="matches(cbc:CompanyID,'^[A-Z0-9]{11,16}$')" flag="fatal" id="BR-IT-DC-110B">[BR-IT-DC-110B][FPA 1.2.1.2 CodiceFiscale] - Se il valore dell’elemento BT-40 (Seller country code) è "IT", se l'elemento BT-30-1 (Seller legal registration identifier scheme identifier) contiene il valore "0210", l'elemento BT-30 (Seller legal registration identifier) deve contenere un Codice Fiscale con lunghezza compresa fra 11 e 16 caratteri.</assert>
	</rule>

	<rule context="/*/cac:AccountingSupplierParty/cac:Party/cac:PartyTaxScheme/cbc:CompanyID" flag="fatal">
		<assert test="matches(.,'^[a-zA-Z0-9]{0,30}$')" flag="fatal" id="BR-IT-120">[BR-IT-120][FPA 1.2.1.1.1 IdPaese, 1.2.1.1.2 IdCodice] - BT-31 (Seller VAT identifier) maximum lenght shall be 30 chars and must begin with two alphabetic chars - La lunghezza dell'elemento non può superare i 30 caratteri e deve iniziare con due caratteri alfabetici.</assert>
	</rule>

	<rule context="/*/cac:AccountingSupplierParty/cac:Party/cac:PartyLegalEntity/cbc:CompanyLegalForm" flag="fatal">
		<assert test="string-length(.) &lt;= 21 and matches(.,'^([0-9]+\d{0,2}(\.\d{2})*|([0-9]+\d*))?(#(SU|SM))?(#(LS|LN))?$')" flag="fatal" id="BR-IT-DC-122">[BR-IT-DC-122][FPA 1.2.4.3 CapitaleSociale, 1.2.4.4 SocioUnico, 1.2.4.5 StatoLiquidazione] - La lunghezza dell'elemento non può superare i 21 caratteri.</assert>
	</rule>	

	<rule context="/*[cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode='IT']" flag="fatal">
		<assert test="cbc:ProfileID = 'urn:fdc:peppol.eu:2017:poacc:billing:01:1.0' and cbc:CustomizationID = 'urn:cen.eu:en16931:2017#compliant#urn:fdc:peppol.eu:2017:poacc:billing:3.0#conformant#urn:www.agid.gov.it:trns:fattura:3'" flag="fatal" id="BR-IT-DC-002">[BR-IT-DC-002] - Se il valore dell’elemento BT-40 (Seller country code) è uguale a "IT", il BT-24 deve essere valorizzato come segue: urn:cen.eu:en16931:2017#compliant#urn:fdc:peppol.eu:2017:poacc:billing:3.0#conformant#urn:www.agid.gov.it:trns:fattura:3</assert>
	</rule>

	<rule context="/*/cac:AccountingSupplierParty/cac:Party/cac:PostalAddress[cac:Country/cbc:IdentificationCode='IT']" flag="fatal">
		<assert test="cbc:StreetName and cbc:CityName and cbc:PostalZone" flag="fatal" id="BR-IT-DC-140">[BR-IT-DC-140][FPA 1.2.2.1 Indirizzo, 1.2.2.4 Comune, 1.2.2.3 CAP] - Se il valore dell’elemento BT-40 Seller country code è “IT”, gli elementi devono essere obbligatoriamente valorizzati.</assert>
		<assert test="((not(contains(normalize-space(cbc:CountrySubentity),' ')) and contains(' AG AL AN AO AP AQ AR AT AV BA BG BI BL BN BO BR BS BT BZ CA CB CE CH CI CL CN CO CR CS CT CZ EN FC FE FG FI FM FR FU GE GO GR IM IS KR LC LE LI LO LT LU MB MC ME MI MN MO MS MT NA NO NU OG OR OT PA PC PD PE PG PI PL PN PO PR PT PU PV PZ RA RC RE RG RI RM RN RO SA SI SO SP SR SS SU SV TA TE TN TO TP TR TS TV UD VA VB VC VE VI VR VS VT VV ZA ',concat(' ',normalize-space(cbc:CountrySubentity),' '))))" flag="fatal" id="BR-IT-DC-150">[BR-IT-DC-150][FPA 1.2.2.5 Provincia] - Se l'elemento BT-40 (Seller country code) ha valore "IT", per l'elemento BT-39 Seller country subdivision deve essere utilizzato uno dei valori della lista delle province italiane. Altrimenti l'informazione è riportata in allegato.</assert>
	</rule>
	
	<rule context="/*/cac:AccountingCustomerParty/cac:Party/cac:PartyTaxScheme/cbc:CompanyID" flag="fatal">
		<assert test="matches(.,'^[A-Z0-9]{0,30}$')" flag="fatal" id="BR-IT-180">[BR-IT-180][FPA 1.4.1.1.1 IdPaese, 1.4.1.1.2 IdCodice] - BT-48 (Buyer VAT identifier) maximum lenght shall be 30 chars and must begin with two alphabetic chars - La lunghezza dell'elemento non può superare i 30 caratteri e deve iniziare con due caratteri alfabetici.</assert>
	</rule>

	<rule context="/*/cac:AccountingCustomerParty/cac:Party/cbc:EndpointID[@schemeID='0201']" flag="fatal">
		<assert test="matches(.,'^[a-zA-Z0-9]{6}$')" flag="fatal" id="BR-IT-200">[BR-IT-200][FPA 1.1.4  CodiceDestinatario] - If BT-49-1 (Buyer electronic address identification scheme identifier) contained the value "0201", BT-49 (Buyer electronic address) must contain an IPA code with maximum length equal to 6 chars - Se l'elemento BT-49-1 (Buyer electronic address identification scheme identifier) contiene il valore "0201", l'elemento BT-49 (Buyer electronic address) deve contenere un codice IPA con lunghezza pari a 6 caratteri.</assert>
	</rule>
	
	<rule context="/*/cac:AccountingCustomerParty/cac:Party/cbc:EndpointID[@schemeID='0205']" flag="fatal">
		<assert test="matches(.,'^[a-zA-Z0-9]{7}$')" flag="fatal" id="BR-IT-DC-202">[BR-IT-DC-202][FPA 1.1.4  CodiceDestinatario] - Se l'elemento BT-49-1 (Buyer electronic address identification scheme identifier) contiene il valore "0205", l'elemento BT-49 (Buyer electronic address) deve contenere un codice Codice Destinatario con lunghezza pari a 7 caratteri.</assert>
	</rule>
	
	<rule context="/*/cac:AccountingCustomerParty/cac:Party/cbc:EndpointID[@schemeID='0202']" flag="fatal">
		<assert test="matches(.,'^\w+([-_+.]\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*$') and matches(.,'^.{7,256}$')" flag="fatal" id="BR-IT-DC-203">[BR-IT-DC-203][FPA 1.1.6 PECDestinatario] - Se l'elemento BT-49-1 (Buyer electronic address identification scheme identifier) contiene il valore "0202", l'elemento BT-49 deve contenere un indirizzo PEC di lunghezza compresa fra 7 e 256.</assert>
	</rule>

	<rule context="/*/cac:AccountingCustomerParty/cac:Party/cac:PostalAddress[cac:Country/cbc:IdentificationCode='IT']" flag="fatal">
		<assert test="cbc:StreetName and cbc:CityName and cbc:PostalZone" flag="fatal" id="BR-IT-210">[BR-IT-210][FPA 1.4.2.1 Indirizzo, 1.4.2.2 NumeroCivico, 1.4.2.4 Comune, 1.4.2.3 CAP] - If Buyer country code (BT-55) = IT, all the elements BT-50 (Buyer address line 1), BT-51 (Buyer address line 2), BT-52 (Buyer city), BT-53 (Buyer post code) are mandatory except for House Number (Numero Civico) - Se Buyer country code (BT-55) =IT, tutti gli elementi sono obbligatori, a meno del Numero Civico.</assert>
		<assert test="((not(contains(normalize-space(cbc:CountrySubentity),' ')) and contains(' AG AL AN AO AP AQ AR AT AV BA BG BI BL BN BO BR BS BT BZ CA CB CE CH CI CL CN CO CR CS CT CZ EN FC FE FG FI FM FR FU GE GO GR IM IS KR LC LE LI LO LT LU MB MC ME MI MN MO MS MT NA NO NU OG OR OT PA PC PD PE PG PI PL PN PO PR PT PU PV PZ RA RC RE RG RI RM RN RO SA SI SO SP SR SS SU SV TA TE TN TO TP TR TS TV UD VA VB VC VE VI VR VS VT VV ZA ',concat(' ',normalize-space(cbc:CountrySubentity),' '))))" flag="fatal" id="BR-IT-220">[BR-IT-220][FPA 1.4.2.5 Provincia] - If Buyer country code (BT-55) = IT, is mandatory to use one of the values of the Italian province for BT-54 (Buyer country subdivision) - Se Buyer country code (BT-55) =IT, Per l'elemento BT-54 (Buyer country subdivision) deve essere utilizzato uno dei valori della lista delle province italiane. Altrimenti l'informazione è riportata in allegato.</assert>
	</rule>

	<rule context="/*/cac:TaxRepresentativeParty/cac:PartyTaxScheme/cbc:CompanyID" flag="fatal">
		<assert test="matches(.,'^[A-Z0-9]{0,30}$')" flag="fatal" id="BR-IT-230">[BR-IT-230][FPA 1.3.1.1.1 IdPaese, 1.3.1.1.2 IdCodice] - BT-63 (Seller tax representative VAT identifier) maximum lenght shall be 30 chars and must begin with two alphabetic chars - La lunghezza dell'elemento non può superare i 30 caratteri e deve iniziare con due caratteri alfabetici.</assert>
	</rule>
	
	<rule context="/*/cac:Delivery/cac:DeliveryLocation/cac:Address[cac:Country/cbc:IdentificationCode='IT']" flag="fatal">
		<assert test="cbc:StreetName and cbc:CityName and cbc:PostalZone" flag="fatal" id="BR-IT-240">[BR-IT-240][FPA 2.1.9.12.1 Indirizzo, 2.1.9.12.4 Comune, 2.1.9.12.3 CAP] - If BT-80 Deliver to country code is valued with "IT", all the elements BT-75 (Deliver to address line 1), BT-77 (Deliver to city), BT-78 (Deliver to post code) must be valued - Se il valore dell’elemento BT-80 Deliver to country code è ”IT”, gli elementi devono essere obbligatoriamente valorizzati.</assert>
		<assert test="((not(contains(normalize-space(cbc:CountrySubentity),' ')) and contains(' AG AL AN AO AP AQ AR AT AV BA BG BI BL BN BO BR BS BT BZ CA CB CE CH CI CL CN CO CR CS CT CZ EN FC FE FG FI FM FR FU GE GO GR IM IS KR LC LE LI LO LT LU MB MC ME MI MN MO MS MT NA NO NU OG OR OT PA PC PD PE PG PI PL PN PO PR PT PU PV PZ RA RC RE RG RI RM RN RO SA SI SO SP SR SS SU SV TA TE TN TO TP TR TS TV UD VA VB VC VE VI VR VS VT VV ZA ',concat(' ',normalize-space(cbc:CountrySubentity),' '))))" flag="fatal" id="BR-IT-250">[BR-IT-250][FPA 2.1.9.12.5 Provincia] - If BT-80 Deliver to country code is "IT", is mandatory to use one of the values of the Italian province for BT-79 (Deliver to country subdivision) - Se l'elemento BT-80 Deliver to country code ha valore "IT", per l'elemento BT-79 Deliver to country subdivision deve essere utilizzato uno dei valori della lista delle province italiane. Altrimenti l'informazione deve essere riportata in allegato.</assert>
	</rule>
	
	<rule context="/*/cac:PaymentMeans" flag="fatal">
		<assert test="not(contains(' 15 16 30 45 51 56 58 68 93 94 95 ',concat(' ',normalize-space(cbc:PaymentMeansCode),' '))) or matches(cac:PayeeFinancialAccount/cbc:ID, '^[a-zA-Z]{2}[0-9]{2}[a-zA-Z0-9]{11,30}$')" flag="fatal" id="BR-IT-270">[BR-IT-270][FPA 2.4.2.13 IBAN] - BT-84 (Payment account identifier) must be a IBAN code - L'identificativo del pagamento BT-84 (Payment account identifier) deve essere un codice IBAN.</assert>
		<assert test="matches(cac:PayeeFinancialAccount/cac:FinancialInstitutionBranch/cbc:ID, '^[A-Z]{6}[A-Z2-9][A-NP-Z0-9]([A-Z0-9]{3}){0,1}$') or not(cac:PayeeFinancialAccount/cac:FinancialInstitutionBranch)" flag="fatal" id="BR-IT-280">[BR-IT-280][FPA 2.4.2.16 BIC] - BT-86 (Payment service provider identifier) length shall be between 8 and 11 chars (BIC) - La lunghezza dell'elemento deve essere compresa fra 8 e 11 caratteri (BIC).</assert>
	</rule>

	<rule context="/*/cac:AllowanceCharge/cbc:Amount" flag="fatal">
		<assert test="matches(.,'^[\-]?\d{1,11}\.\d{2}$')" flag="fatal" id="BR-IT-290">[BR-IT-290][FPA 2.2.1.9 PrezzoUnitario, 2.2.1.11 PrezzoTotale] - BT-92 (Document level allowance amount) or BT-99 (Document level charge amount) maximum length shall be 15, including two fraction digits - La lunghezza dell'elemento non può superare i 15 caratteri incluso 2 cifre decimali.</assert>
	</rule>
	
	<rule context="/*/cac:LegalMonetaryTotal/cbc:TaxInclusiveAmount" flag="fatal">
		<assert test="matches(.,'^[\-]?\d{1,11}\.\d{2}$')" flag="fatal" id="BR-IT-300">[BR-IT-300][FPA 2.1.1.9 ImportoTotaleDocumento] - BT-112 (Invoice total amount with VAT) maximum length shall be 15, including two fraction digits - La lunghezza dell'elemento non può superare i 15 caratteri incluso 2 cifre decimali.</assert>
	</rule>
	
	<rule context="/*/cac:LegalMonetaryTotal/cbc:PayableRoundingAmount" flag="fatal">
		<assert test="matches(.,'^[\-]?\d{1,11}\.\d{2}$')" flag="fatal" id="BR-IT-310">[BR-IT-310][FPA 2.1.1.10 Arrotondamento] - BT-114 (Rounding amount) maximum length shall be 15, including two fraction digits - La lunghezza dell'elemento non può superare i 15 caratteri incluso 2 cifre decimali.</assert>
	</rule>
	
	<rule context="/*/cac:LegalMonetaryTotal/cbc:PayableAmount" flag="fatal">
		<assert test="matches(.,'^[\-]?\d{1,11}\.\d{2}$')" flag="fatal" id="BR-IT-320">[BR-IT-320][FPA 2.4.2.6 ImportoPagamento] - BT-115 (Amount due for payment) maximum length shall be 15, including two fraction digits - La lunghezza dell'elemento non può superare i 15 caratteri incluso 2 cifre decimali.</assert>
	</rule>
	
	<rule context="/*/cac:TaxTotal/cac:TaxSubtotal/cbc:TaxableAmount" flag="fatal">
		<assert test="matches(.,'^[\-]?\d{1,11}\.\d{2}$')" flag="fatal" id="BR-IT-330">[BR-IT-330][FPA 2.2.2.5 ImponibileImporto] - BT-116 (VAT category taxable amount) maximum length shall be 15, including two fraction digits - La lunghezza dell'elemento non può superare i 15 caratteri incluso 2 cifre decimali.</assert>
	</rule>
	
	<rule context="/*/cac:TaxTotal/cac:TaxSubtotal/cbc:TaxAmount" flag="fatal">
		<assert test="matches(.,'^[\-]?\d{1,11}\.\d{2}$')" flag="fatal" id="BR-IT-340">[BR-IT-340][FPA 2.2.2.6 Imposta] - BT-117 (VAT category tax amount) maximum length shall be 15, including two fraction digits - La lunghezza dell'elemento non può superare i 15 caratteri incluso 2 cifre decimali.</assert>
	</rule>
	
	<rule context="//cac:TaxCategory/cbc:ID | //cac:ClassifiedTaxCategory/cbc:ID" flag="fatal">
		<assert test="contains(' AE E S G K Z B ', concat(' ',normalize-space(.),' '))" flag="fatal" id="BR-IT-350">[BR-IT-350] - BT-118 (VAT category code), BT-95 (Document level allowence VAT category code), BT-102 (Document level charge VAT category code), BT-151 (invoiced item VAT category code) For VAT category code only values AE E S G K Z B shall be allowed - I valori accettati sono esclusivamente AE E S G K Z B.</assert>
	</rule>
	
	<rule context="//cac:AdditionalDocumentReference[cbc:ID and not(cbc:DocumentTypeCode)]" flag="fatal">
		<assert test="cac:Attachment/cac:ExternalReference/cbc:URI or cac:Attachment/cbc:EmbeddedDocumentBinaryObject" flag="fatal" id="BR-IT-360">[BR-IT-360][FPA 2.5.5 Attachment] - If BT-122 (Supporting document reference) is not empty, then BT-124 (External document location) or BT-125 (Attached document) shall be mandatory - Se l'elemento BT-122 Supporting document reference è valorizzato, è obbligatorio valorizzare almeno uno degli elementi BT-124 External document location e BT-125 Attached document.</assert>
	</rule>

	
	
	<rule context="/*/cac:AccountingCustomerParty/cac:Party" flag="fatal">
		<assert test="cbc:EndpointID[@schemeID='0201' or @schemeID='0202' or @schemeID='0205'] or cac:PostalAddress[cac:Country/cbc:IdentificationCode!='IT']" flag="fatal" id="BR-IT-190A">[BR-IT-190A][FPA 1.1.6 PECDestinatario, 1.1.4  CodiceDestinatario] - If Buyer country code (BT-55) = IT, BT-49 (Buyer electronic address) must contain the IPA Code, the PEC of the recipient of the invoice or the Recipient Code. Therefore, for BT-49-1 (Buyer electronic address identification scheme identifier) can be used respectively the values 0201, 0202 or 0205 - Se Buyer country code (BT-55) = IT, l'elemento BT-49 (Buyer electronic address) deve contenere il Codice IPA, la PEC del destinatario della fattura oppure il Codice Destinatario. Di conseguenza, per l'elemento BT-49-1 (Buyer electronic address identification scheme identifier) sono previsti rispettivamente i valori 0201, 0202 oppure 0205.</assert>
		<assert test="cac:PartyTaxScheme/cbc:CompanyID or cac:PartyLegalEntity/cbc:CompanyID or cac:PostalAddress[cac:Country/cbc:IdentificationCode!='IT']" flag="fatal" id="BR-IT-520A">[BR-IT-520A][FPA 1.4.1.2 Codice Fiscale, 1.4.1.1 Id Paese] - If Buyer country code (BT-55) = IT, at least one of the elements BT-48 (Buyer VAT identifier) or BT-47 (Buyer legal registration identifier) must be valued - Se Buyer country code (BT-55) = IT, almeno uno degli elementi BT-48 (Buyer VAT identifier) o BT-47 (Buyer legal registration identifier) deve essere valorizzato.</assert>
	</rule>
	
	<rule context="/*/cac:AccountingCustomerParty/cac:Party/cac:PartyLegalEntity/cbc:CompanyID[@schemeID='0210']" flag="fatal">
		<assert test="matches(.,'^[A-Z0-9]{11,16}$') or ../../cac:PostalAddress[cac:Country/cbc:IdentificationCode!='IT']" flag="fatal" id="BR-IT-520B">[BR-IT-520B][FPA 1.4.1.2 - Codice Fiscale] - If Buyer country code (BT-55)= IT, BT-47 (Buyer legal registration identifier) length shall be between 11 and 16 chars - Se Buyer country code (BT-55) = IT, la lunghezza dell'elemento BT-47 (Buyer legal registration identifier) deve essere compresa fra 11 e 16 caratteri.</assert>
	</rule>

	<rule context="/*/cac:AccountingCustomerParty/cac:Party/cac:PartyLegalEntity" flag="fatal">
		<assert test="cbc:CompanyID[@schemeID='0210'] or not(cbc:CompanyID) or ../cac:PostalAddress[cac:Country/cbc:IdentificationCode!='IT']" flag="fatal" id="BR-IT-520C">[BR-IT-520C][FPA 1.4.1.2 - Codice Fiscale] - If Buyer country code (BT-55) = IT and Buyer legal registration identifier (BT-47) exists, the element Buyer legal registration identifier (BT-47-1) is mandatory and must be valued with "0210" - Se Buyer country code (BT-55) = IT, l'elemento BT-47-1 (Buyer legal registration identifier scheme identifier) è obbligatorio e contiene il valore "0210".</assert>
	</rule>
	
	<rule context="/*/cac:AccountingCustomerParty/cac:PartyIdentification/cbc:ID[starts-with(., 'EORI:')]" flag="fatal">
		<assert test="matches(.,'^EORI:[A-Z0-9]{13,17}$') or ../../cac:Party[cac:PostalAddress/cac:Country/cbc:IdentificationCode!='IT']" flag="fatal" id="BR-IT-521">[BR-IT-521][FPA 1.4.1.3.5 - Codice EORI] - If Buyer country code (BT-55) = IT, the EORI Code (BT-46 Buyer identifier) must be preceded by 'EORI:' and it length shall be between 13 e 17 alphanumerical chars - Se Buyer country code (BT-55) = IT, il Codice EORI (BT-46 Buyer identifier) deve essere preceduto dal prefisso 'EORI:' ed avere la lunghezza del codice compresa fra 13 e 17 caratteri alfanumerici.</assert>
	</rule>

<rule context="/*/cac:InvoiceLine/cac:Item | /*/cac:CreditNoteLine/cac:Item" flag="fatal">
		<assert test="(not(./cbc:Description) and not(./cbc:Name)) or matches(concat(./cbc:Description,./cbc:Name),'^[\p{IsBasicLatin}\p{IsLatin-1Supplement}]{0,1000}$')" flag="fatal" id="BR-IT-530">[BR-IT-530][FPA 2.2.1.4 - Descrizione] - The concatenation of BT-153 (Item Name) and BT-154 (Item Description) maximum lenght shall be 1000 chars from Unicode Basic Latin and/or Latin 1-Supplement blocks - La lunghezza della concatenazione degli elementi non può superare i 1000 caratteri riconducibili ai blocchi Unicode Basic Latin e/o Latin 1-Supplement</assert>
	</rule>
		
	<!-- Line Level -->
	
	<rule context="/*/cac:InvoiceLine/cac:DocumentReference/cbc:ID | /*/cac:CreditNoteLine/cac:DocumentReference/cbc:ID" flag="fatal">
		<assert test="matches(.,'^(\p{IsBasicLatin}){0,35}$')" flag="fatal" id="BR-IT-370">[BR-IT-370][FPA 2.2.1.3.2 CodiceValore] - BT-128 (Invoice line object identifier) maximum lenght shall be 35 chars - La lunghezza dell'elemento non può superare i 35 caratteri.</assert>
	</rule>
	
	<rule context="/*/cac:InvoiceLine/cbc:InvoicedQuantity | /*/cac:CreditNoteLine/cbc:CreditedQuantity" flag="fatal">
		<assert test="matches(.,'^\-{0,1}\d{1,12}\.\d{2,8}$')" flag="fatal" id="BR-IT-380">[BR-IT-380][FPA 2.2.1.5 Quantita] - BT-129 (Invoiced quantity) maximum lenght shall be 21 chars and BT allowed fraction digits shall be 8 - La lunghezza dell'elemento non deve essere superiore a 21 caratteri e l'elemento dovrà avere 8 cifre decimali.</assert>
	</rule>
	
	<rule context="/*/cac:InvoiceLine/cbc:LineExtensionAmount | /*/cac:CreditNoteLine/cbc:LineExtensionAmount" flag="fatal">
		<assert test="matches(.,'^\-{0,1}\d*(\.\d{0,2})?$') and string-length(.) &gt;= 1 and string-length(.) &lt;= 15" flag="fatal" id="BR-IT-390">[BR-IT-390][FPA 2.2.1.11 PrezzoTotale] - BT-131 (Invoice line net amount) BT maximum length shall be 15, including two fraction digits - La lunghezza dell'elemento non può superare i 15 caratteri incluso 2 cifre decimali.</assert>
	</rule>
	
	<rule context="/*/cac:InvoiceLine/cac:OrderLineReference/cbc:LineID | /*/cac:CreditNoteLine/cac:OrderLineReference/cbc:LineID" flag="fatal">
		<assert test="matches(.,'^(\p{IsBasicLatin}){0,20}$')" flag="fatal" id="BR-IT-400">[BR-IT-400][FPA 2.1.2.4 NumItem] - BT-132 (Referenced purchase order line reference) maximum lenght shall be 20 chars - La lunghezza dell'elemento non può superare i 20 caratteri.</assert>
	</rule>
	
	<rule context="/*/cac:InvoiceLine/cbc:AccountingCost | /*/cac:CreditNoteLine/cbc:AccountingCost" flag="fatal">
		<assert test="matches(.,'^(\p{IsBasicLatin}){0,20}$')" flag="fatal" id="BR-IT-410">[BR-IT-410][FPA 2.2.1.15 RiferimentoAmministrazione] - BT-133 (Invoice line Buyer accounting reference) maximum lenght shall be 20 chars - La lunghezza dell'elemento non può superare i 20 caratteri.</assert>
	</rule>
	
	<rule context="/*/cac:InvoiceLine/cac:AllowanceCharge/cbc:Amount | /*/cac:CreditNoteLine/cac:AllowanceCharge/cbc:Amount" flag="fatal">
		<assert test="matches(.,'^\d*(\.\d{0,2})?$') and string-length(.) &gt;= 1 and string-length(.) &lt;= 15" flag="fatal" id="BR-IT-421">[BR-IT-421][FPA 2.2.1.10.3 - Importo] - BT-147 (Item price discount) maximum length shall be 15, including two fraction digits - La lunghezza dell'elemento non può superare i 15 caratteri incluso 2 cifre decimali.</assert>
	</rule>
	
	<rule context="/*/cac:InvoiceLine/cac:Price/cbc:PriceAmount | /*/cac:CreditNoteLine/cac:Price/cbc:PriceAmount" flag="fatal">
		<assert test="matches(.,'^[\-]?\d{1,11}\.\d{2,8}$')" flag="fatal" id="BR-IT-430">[BR-IT-430] - BT-146 (Item net price) maximum length shall be 21 chars and BT allowed fraction digits shall be 8 - La lunghezza dell'elemento non deve essere superiore a 21 caratteri e l'elemento dovrà avere 8 cifre decimali.</assert>
	</rule>

	<rule context="/*/cac:InvoiceLine/cac:Price/cac:AllowanceCharge/cbc:Amount | /*/cac:CreditNoteLine/cac:Price/cac:AllowanceCharge/cbc:Amount" flag="fatal">
		<assert test="matches(.,'^[\-]?\d{1,11}\.\d{2,8}$')" flag="fatal" id="BR-IT-431">[BR-IT-431][FPA 2.2.1.10.3 Importo] - BT-147 (Item price discount) maximum length shall be 21 chars and BT allowed fraction digits shall be 8 - La lunghezza dell'elemento non deve essere superiore a 21 caratteri e l'elemento potrà avere fino a 8 cifre decimali.</assert>
	</rule>
	
	<rule context="/*/cac:InvoiceLine/cac:Price | /*/cac:CreditNoteLine/cac:Price" flag="fatal">
		<assert test="cac:AllowanceCharge/cbc:BaseAmount" flag="fatal" id="BR-IT-432">[BR-IT-432][FPA 2.2.1.9 PrezzoUnitario] - The BT-148 (Item gross price) is mandatory - Il BT-148 (Item gross price) deve essere obbligatoriamente valorizzato.</assert>
		<assert test="matches(cac:AllowanceCharge/cbc:BaseAmount,'^[\-]?\d{1,11}\.\d{2,8}$')" flag="fatal" id="BR-IT-433">[BR-IT-433][FPA 2.2.1.9 PrezzoUnitario] - BT-148 (Item gross price) maximum length shall be 21 chars and BT allowed fraction digits shall be 8 - La lunghezza dell'elemento non deve essere superiore a 21 caratteri e l'elemento potrà avere fino a 8 cifre decimali.</assert>
	</rule>	
	
	<rule context="/*/cac:InvoiceLine/cac:Item/cac:SellersItemIdentification/cbc:ID | /*/cac:CreditNoteLine/cac:Item/cac:SellersItemIdentification/cbc:ID" flag="fatal">
		<assert test="matches(.,'^(\p{IsBasicLatin}){0,35}$')" flag="fatal" id="BR-IT-440">[BR-IT-440][FPA 2.2.1.3.1 Codice Tipo, 2.2.1.3.2 CodiceValore] - BT-155 (Item Seller's identifier) maximum lenght shall be 35 chars - La lunghezza dell'elemento non può superare i 35 caratteri.</assert>
	</rule>
	
	<rule context="/*/cac:InvoiceLine/cac:Item/cac:CommodityClassification/cbc:ItemClassificationCode | /*/cac:CreditNoteLine/cac:Item/cac:CommodityClassification/cbc:ItemClassificationCode" flag="fatal">
		<assert test="matches(.,'^(\p{IsBasicLatin}){0,35}$')" flag="fatal" id="BR-IT-470">[BR-IT-470][FPA 2.2.1.3.1 Codice Tipo, 2.2.1.3.2 CodiceValore] - BT-158 (Item classification identifier) maximum lenght shall be 35 chars - La lunghezza dell'elemento non può superare i 35 caratteri.</assert>
	</rule>

</pattern>