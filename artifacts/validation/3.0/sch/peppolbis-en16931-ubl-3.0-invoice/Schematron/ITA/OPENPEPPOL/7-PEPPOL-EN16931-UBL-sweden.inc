<pattern id="UBL-sweden" xmlns="http://purl.oclc.org/dsdl/schematron">
   <rule context="//cac:AccountingSupplierParty/cac:Party[cac:PostalAddress/cac:Country/cbc:IdentificationCode = 'SE' and cac:PartyTaxScheme[cac:TaxScheme/cbc:ID = 'VAT']/substring(cbc:CompanyID, 1, 2) = 'SE']">
      <assert id="SE-R-001" test="string-length(normalize-space(cac:PartyTaxScheme[cac:TaxScheme/cbc:ID = 'VAT']/cbc:CompanyID)) = 14" flag="fatal">For Swedish suppliers, Swedish VAT-numbers must consist of 14 characters.</assert>
      <assert id="SE-R-002" test="string(number(substring(cac:PartyTaxScheme[cac:TaxScheme/cbc:ID = 'VAT']/cbc:CompanyID, 3, 12))) != 'NaN'" flag="fatal">For Swedish suppliers, the Swedish VAT-numbers must have the trailing 12 characters in numeric form</assert>
    </rule>
    <rule context="//cac:AccountingSupplierParty/cac:Party/cac:PartyLegalEntity[../cac:PostalAddress/cac:Country/cbc:IdentificationCode = 'SE' and cbc:CompanyID]">
			<assert id="SE-R-003" test="string(number(cbc:CompanyID)) != 'NaN'" flag="fatal">Swedish organisation numbers should be numeric.</assert>
			<assert id="SE-R-004" test="string-length(normalize-space(cbc:CompanyID)) = 10" flag="fatal">Swedish organisation numbers consist of 10 characters.</assert>
			<assert id="SE-R-013" test="u:checkSEOrgnr(normalize-space(cbc:CompanyID))" flag="fatal">The last digit of a Swedish organization number must be valid according to the Luhn algorithm.</assert>
		</rule>
		<rule context="//cac:AccountingSupplierParty/cac:Party[cac:PostalAddress/cac:Country/cbc:IdentificationCode = 'SE' and exists(cac:PartyLegalEntity/cbc:CompanyID)]/cac:PartyTaxScheme[normalize-space(upper-case(cac:TaxScheme/cbc:ID)) != 'VAT']/cbc:CompanyID">
			<assert id="SE-R-005" test="normalize-space(upper-case(.)) = 'GODKÄND FÖR F-SKATT'" flag="fatal">For Swedish suppliers, when using Seller tax registration identifier, 'Godkänd för F-skatt' must be stated</assert>
		</rule>
		<rule context="//cac:TaxCategory[//cac:AccountingSupplierParty/cac:Party[cac:PostalAddress/cac:Country/cbc:IdentificationCode = 'SE' and cac:PartyTaxScheme[cac:TaxScheme/cbc:ID = 'VAT']/substring(cbc:CompanyID, 1, 2) = 'SE'] and cbc:ID = 'S'] | //cac:ClassifiedTaxCategory[//cac:AccountingSupplierParty/cac:Party[cac:PostalAddress/cac:Country/cbc:IdentificationCode = 'SE' and cac:PartyTaxScheme[cac:TaxScheme/cbc:ID = 'VAT']/substring(cbc:CompanyID, 1, 2) = 'SE'] and cbc:ID = 'S']">
			<assert id="SE-R-006" test="number(cbc:Percent) = 25 or number(cbc:Percent) = 12 or number(cbc:Percent) = 6" flag="fatal">For Swedish suppliers, only standard VAT rate of 6, 12 or 25 are used</assert>
		</rule>
		<rule context="//cac:PaymentMeans[//cac:AccountingSupplierParty/cac:Party[cac:PostalAddress/cac:Country/cbc:IdentificationCode = 'SE'] and normalize-space(cbc:PaymentMeansCode) = '30' and normalize-space(cac:PayeeFinancialAccount/cac:FinancialInstitutionBranch/cbc:ID) = 'SE:PLUSGIRO']/cac:PayeeFinancialAccount/cbc:ID">
			<assert id="SE-R-007" test="string(number(normalize-space(.))) != 'NaN'" flag="warning">For Swedish suppliers using Plusgiro, the Account ID must be numeric </assert>
			<assert id="SE-R-010" test="string-length(normalize-space(.)) &gt;= 2 and string-length(normalize-space(.)) &lt;= 8" flag="warning">For Swedish suppliers using Plusgiro, the Account ID must have 2-8 characters</assert>
		</rule>
		<rule context="//cac:PaymentMeans[//cac:AccountingSupplierParty/cac:Party[cac:PostalAddress/cac:Country/cbc:IdentificationCode = 'SE'] and normalize-space(cbc:PaymentMeansCode) = '30' and normalize-space(cac:PayeeFinancialAccount/cac:FinancialInstitutionBranch/cbc:ID) = 'SE:BANKGIRO']/cac:PayeeFinancialAccount/cbc:ID">
			<assert id="SE-R-008" test="string(number(normalize-space(.))) != 'NaN'" flag="warning">For Swedish suppliers using Bankgiro, the Account ID must be numeric </assert>
			<assert id="SE-R-009" test="string-length(normalize-space(.)) = 7 or string-length(normalize-space(.)) = 8" flag="warning">For Swedish suppliers using Bankgiro, the Account ID must have 7-8 characters</assert>
		</rule>
		<rule context="//cac:PaymentMeans[//cac:AccountingSupplierParty/cac:Party[cac:PostalAddress/cac:Country/cbc:IdentificationCode = 'SE'] and (cbc:PaymentMeansCode = normalize-space('50') or cbc:PaymentMeansCode = normalize-space('56'))]">
			<assert id="SE-R-011" test="false()" flag="warning">For Swedish suppliers using Swedish Bankgiro or Plusgiro, the proper way to indicate this is to use Code 30 for PaymentMeans and FinancialInstitutionBranch ID with code SE:BANKGIRO or SE:PLUSGIRO</assert>
		</rule>
		<rule context="//cac:PaymentMeans[//cac:AccountingSupplierParty/cac:Party[cac:PostalAddress/cac:Country/cbc:IdentificationCode = 'SE']  and //cac:AccountingCustomerParty/cac:Party[cac:PostalAddress/cac:Country/cbc:IdentificationCode = 'SE'] and (cbc:PaymentMeansCode = normalize-space('31'))]">
			<assert id="SE-R-012" test="false()" flag="warning">For domestic transactions between Swedish trading partners, credit transfer should be indicated by PaymentMeansCode="30"</assert>
		</rule>
	</pattern>
	<!-- GREECE -->
	<!-- General variable for Greek Rules -->
	<let name="isGreekSender" value="($supplierCountry ='GR') or ($supplierCountry ='EL')"/>
	<let name="isGreekReceiver" value="($customerCountry ='GR') or ($customerCountry ='EL')"/>
	<let name="isGreekSenderandReceiver" value="$isGreekSender and $isGreekReceiver"/>
	<!-- Test only accounting Supplier Country -->
	<let name="accountingSupplierCountry" value="
    if (/*/cac:AccountingSupplierParty/cac:Party/cac:PartyTaxScheme[cac:TaxScheme/cbc:ID = 'VAT']/substring(cbc:CompanyID, 1, 2)) then
    upper-case(normalize-space(/*/cac:AccountingSupplierParty/cac:Party/cac:PartyTaxScheme[cac:TaxScheme/cbc:ID = 'VAT']/substring(cbc:CompanyID, 1, 2)))
    else
    if (/*/cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode) then
    upper-case(normalize-space(/*/cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode))
    else
    'XX'"/>
	<!-- Sender Rules -->
	<pattern>
		<let name="dateRegExp" value="'^(0?[1-9]|[12][0-9]|3[01])[-\\/ ]?(0?[1-9]|1[0-2])[-\\/ ]?(19|20)[0-9]{2}'"/>
		<let name="greekDocumentType" value="tokenize('1.1 1.6 2.1 2.4 5.1 5.2 ','\s')"/>
		<let name="tokenizedUblIssueDate" value="tokenize(/*/cbc:IssueDate,'-')"/>
		<!-- Invoice ID -->
		<rule context="/ubl-invoice:Invoice/cbc:ID[$isGreekSender] | /ubl-creditnote:CreditNote/cbc:ID[$isGreekSender]">
			<let name="IdSegments" value="tokenize(.,'\|')"/>
			<assert id="GR-R-001-1" test="count($IdSegments) = 6" flag="fatal"> When the Supplier is Greek, the Invoice Id should consist of 6 segments</assert>
			<assert id="GR-R-001-2" test="string-length(normalize-space($IdSegments[1])) = 9 
			                              and u:TinVerification($IdSegments[1])
			                              and ($IdSegments[1] = /*/cac:AccountingSupplierParty/cac:Party/cac:PartyTaxScheme[cac:TaxScheme/cbc:ID = 'VAT']/substring(cbc:CompanyID, 3, 9)
			                              or $IdSegments[1] = /*/cac:TaxRepresentativeParty/cac:PartyTaxScheme[cac:TaxScheme/cbc:ID = 'VAT']/substring(cbc:CompanyID, 3, 9) )" flag="fatal">When the Supplier is Greek, the Invoice Id first segment must be a valid TIN Number and match either the Supplier's or the Tax Representative's Tin Number</assert>
			<let name="tokenizedIdDate" value="tokenize($IdSegments[2],'/')"/>
			<assert id="GR-R-001-3" test="string-length(normalize-space($IdSegments[2]))>0 
			                              and matches($IdSegments[2],$dateRegExp)
			                              and ($tokenizedIdDate[1] = $tokenizedUblIssueDate[3] 
			                                and $tokenizedIdDate[2] = $tokenizedUblIssueDate[2]
			                                and $tokenizedIdDate[3] = $tokenizedUblIssueDate[1])" flag="fatal">When the Supplier is Greek, the Invoice Id second segment must be a valid Date that matches the invoice Issue Date</assert>
			<assert id="GR-R-001-4" test="string-length(normalize-space($IdSegments[3]))>0 and string(number($IdSegments[3])) != 'NaN' and xs:integer($IdSegments[3]) >= 0" flag="fatal">When Supplier is Greek, the Invoice Id third segment must be a positive integer</assert>
			<assert id="GR-R-001-5" test="string-length(normalize-space($IdSegments[4]))>0 and (some $c in $greekDocumentType satisfies $IdSegments[4] = $c)" flag="fatal">When Supplier is Greek, the Invoice Id in the fourth segment must be a valid greek document type</assert>
			<assert id="GR-R-001-6" test="string-length($IdSegments[5]) > 0 " flag="fatal">When Supplier is Greek, the Invoice Id fifth segment must not be empty</assert>
			<assert id="GR-R-001-7" test="string-length($IdSegments[6]) > 0 " flag="fatal">When Supplier is Greek, the Invoice Id sixth segment must not be empty</assert>
		</rule>
		<rule context="cac:AccountingSupplierParty[$isGreekSender]/cac:Party">
			<!-- Supplier Name Mandatory -->
			<assert id="GR-R-002" test="string-length(./cac:PartyName/cbc:Name)>0" flag="fatal">Greek Suppliers must provide their full name as they are registered in the Greek Business Registry (G.E.MH.) as a legal entity or in the Tax Registry as a natural person </assert>
			<!-- Supplier VAT Mandatory -->
			<assert id="GR-S-011" test="count(cac:PartyTaxScheme[normalize-space(cac:TaxScheme/cbc:ID) = 'VAT']/cbc:CompanyID)=1 and
				                        substring(cac:PartyTaxScheme[normalize-space(cac:TaxScheme/cbc:ID) = 'VAT']/cbc:CompanyID,1,2) = 'EL' and
				                        u:TinVerification(substring(cac:PartyTaxScheme[normalize-space(cac:TaxScheme/cbc:ID) = 'VAT']/cbc:CompanyID,3))" flag="warning">Greek suppliers must provide their Seller Tax Registration Number, prefixed by the country code</assert>
		</rule>
		<!-- VAT Number Rules -->
		<rule context="cac:AccountingSupplierParty[$isGreekSender]/cac:Party/cac:PartyTaxScheme[normalize-space(cac:TaxScheme/cbc:ID) = 'VAT']/cbc:CompanyID">
			<assert id="GR-R-003" test="substring(.,1,2) = 'EL' and u:TinVerification(substring(.,3))" flag="fatal">For the Greek Suppliers, the VAT must start with 'EL' and must be a valid TIN number</assert>
		</rule>
		<!-- Document Reference Rules (existence of MARK and Invoice Verification URL) -->
		<rule context="/ubl-invoice:Invoice[$isGreekSender and ( /*/cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode = 'GR')] | /ubl-creditnote:CreditNote[$isGreekSender and ( /*/cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode = 'GR')]">
			<!-- ΜARK Rules -->
			<assert id="GR-R-004-1" test="count(cac:AdditionalDocumentReference[cbc:DocumentDescription = '##M.AR.K##'])=1" flag="fatal"> When Supplier is Greek, there must be one MARK Number</assert>
			<assert id="GR-S-008-1" flag="warning" test="count(cac:AdditionalDocumentReference[cbc:DocumentDescription = '##INVOICE|URL##'])=1">When Supplier is Greek, there should be one invoice url</assert>
			<assert id="GR-R-008-2" test="(count(cac:AdditionalDocumentReference[cbc:DocumentDescription = '##INVOICE|URL##']) = 0 ) or (count(cac:AdditionalDocumentReference[cbc:DocumentDescription = '##INVOICE|URL##']) = 1 )" flag="fatal">When Supplier is Greek, there should be no more than one invoice url</assert>
		</rule>
		<!-- MARK Rules -->
		<rule context="cac:AdditionalDocumentReference[$isGreekSender and ( /*/cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode = 'GR') and cbc:DocumentDescription = '##M.AR.K##']/cbc:ID">
			<assert id="GR-R-004-2" test="matches(.,'^[1-9]([0-9]*)')" flag="fatal">When Supplier is Greek, the MARK Number must be a positive integer</assert>
		</rule>
		<!-- Invoice Verification URL Rules -->
		<rule context="cac:AdditionalDocumentReference[$isGreekSender and cbc:DocumentDescription = '##INVOICE|URL##']">
			<assert id="GR-R-008-3" test="string-length(normalize-space(cac:Attachment/cac:ExternalReference/cbc:URI))>0" flag="fatal">When Supplier is Greek and the INVOICE URL Document reference exists, the External Reference URI should be present</assert>
		</rule>
		<!-- Customer Name Mandatory -->
		<rule context="cac:AccountingCustomerParty[$isGreekSender]/cac:Party">
			<assert id="GR-R-005" test="string-length(./cac:PartyName/cbc:Name)>0" flag="fatal">Greek Suppliers must provide the full name of the buyer</assert>
		</rule>
		<!-- Endpoint Rules -->
		<rule context="cac:AccountingSupplierParty/cac:Party[$accountingSupplierCountry='GR' or $accountingSupplierCountry='EL']/cbc:EndpointID">
			<assert id="GR-R-009" test="./@schemeID='9933' and u:TinVerification(.)" flag="fatal">Greek suppliers that send an invoice through the PEPPOL network must use a correct TIN number as an electronic address according to PEPPOL Electronic Address Identifier scheme (schemeID 9933).</assert>
		</rule>
	</pattern>
	<!-- Greek Sender and Greek Receiver rules -->
	<pattern>
		<!-- VAT Number Rules -->
		<rule context="cac:AccountingCustomerParty[$isGreekSenderandReceiver]/cac:Party">
			<assert id="GR-R-006" test="count(cac:PartyTaxScheme[normalize-space(cac:TaxScheme/cbc:ID) = 'VAT']/cbc:CompanyID)=1 and
				                        substring(cac:PartyTaxScheme[normalize-space(cac:TaxScheme/cbc:ID) = 'VAT']/cbc:CompanyID,1,2) = 'EL' and
				                        u:TinVerification(substring(cac:PartyTaxScheme[normalize-space(cac:TaxScheme/cbc:ID) = 'VAT']/cbc:CompanyID,3))" flag="fatal">Greek Suppliers must provide the VAT number of the buyer, if the buyer is Greek </assert>
		</rule>
		<!-- Endpoint Rules -->
		<rule context="cac:AccountingCustomerParty[$isGreekSenderandReceiver]/cac:Party/cbc:EndpointID">
			<assert id="GR-R-010" test="./@schemeID='9933' and u:TinVerification(.)" flag="fatal">Greek Suppliers that send an invoice through the PEPPOL network to a greek buyer must use a correct TIN number as an electronic address according to PEPPOL Electronic Address Identifier scheme (SchemeID 9933)</assert>
		</rule>
	</pattern>
	<!-- ICELAND -->
	<pattern>
		<let name="SupplierCountry" value="concat(ubl-creditnote:CreditNote/cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode, ubl-invoice:Invoice/cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode)"/>
		<let name="CustomerCountry" value="concat(ubl-creditnote:CreditNote/cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode, ubl-invoice:Invoice/cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode)"/>
		<rule context="ubl-creditnote:CreditNote[$SupplierCountry = 'IS'] | ubl-invoice:Invoice[$SupplierCountry = 'IS']">
			<assert id="IS-R-001" test="( ( not(contains(normalize-space(cbc:InvoiceTypeCode),' ')) and contains( ' 380 381 ',concat(' ',normalize-space(cbc:InvoiceTypeCode),' ') ) ) ) or ( ( not(contains(normalize-space(cbc:CreditNoteTypeCode),' ')) and contains( ' 380 381 ',concat(' ',normalize-space(cbc:CreditNoteTypeCode),' ') ) ) )" flag="warning">[IS-R-001]-If seller is icelandic then invoice type should be 380 or 381 — Ef seljandi er íslenskur þá ætti gerð reiknings (BT-3) að vera sölureikningur (380) eða kreditreikningur (381).</assert>
			<assert id="IS-R-002" test="exists(cac:AccountingSupplierParty/cac:Party/cac:PartyLegalEntity/cbc:CompanyID) and cac:AccountingSupplierParty/cac:Party/cac:PartyLegalEntity/cbc:CompanyID/@schemeID = '0196'" flag="fatal">[IS-R-002]-If seller is icelandic then it shall contain sellers legal id — Ef seljandi er íslenskur þá skal reikningur innihalda íslenska kennitölu seljanda (BT-30).</assert>
			<assert id="IS-R-003" test="exists(cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cbc:StreetName) and exists(cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cbc:PostalZone)" flag="fatal">[IS-R-003]-If seller is icelandic then it shall contain his address with street name and zip code — Ef seljandi er íslenskur þá skal heimilisfang seljanda innihalda götuheiti og póstnúmer (BT-35 og BT-38).</assert>
			<assert id="IS-R-006" test="exists(cac:PaymentMeans[cbc:PaymentMeansCode = '9']/cac:PayeeFinancialAccount/cbc:ID) 
					  and string-length(normalize-space(cac:PaymentMeans[cbc:PaymentMeansCode = '9']/cac:PayeeFinancialAccount/cbc:ID)) = 12
					  or not(exists(cac:PaymentMeans[cbc:PaymentMeansCode = '9']))" flag="fatal">[IS-R-006]-If seller is icelandic and payment means code is 9 then a 12 digit account id must exist — Ef seljandi er íslenskur og greiðslumáti (BT-81) er krafa (kóti 9) þá skal koma fram 12 stafa númer (bankanúmer, höfuðbók 66 og reikningsnúmer) (BT-84)</assert>
			<assert id="IS-R-007" test="exists(cac:PaymentMeans[cbc:PaymentMeansCode = '42']/cac:PayeeFinancialAccount/cbc:ID) 
					  and string-length(normalize-space(cac:PaymentMeans[cbc:PaymentMeansCode = '42']/cac:PayeeFinancialAccount/cbc:ID)) = 12
					  or not(exists(cac:PaymentMeans[cbc:PaymentMeansCode = '42']))" flag="fatal">[IS-R-007]-If seller is icelandic and payment means code is 42 then a 12 digit account id must exist — Ef seljandi er íslenskur og greiðslumáti (BT-81) er millifærsla (kóti 42) þá skal koma fram 12 stafa reikningnúmer (BT-84)</assert>
			<assert id="IS-R-008" test="(exists(cac:AdditionalDocumentReference[cbc:DocumentDescription = 'EINDAGI']) and string-length(cac:AdditionalDocumentReference[cbc:DocumentDescription = 'EINDAGI']/cbc:ID) = 10 and (string(cac:AdditionalDocumentReference[cbc:DocumentDescription = 'EINDAGI']/cbc:ID) castable as xs:date)) or not(exists(cac:AdditionalDocumentReference[cbc:DocumentDescription = 'EINDAGI']))" flag="fatal">[IS-R-008]-If seller is icelandic and invoice contains supporting description EINDAGI then the id form must be YYYY-MM-DD — Ef seljandi er íslenskur þá skal eindagi (BT-122, DocumentDescription = EINDAGI) vera á forminu YYYY-MM-DD.</assert>
			<assert id="IS-R-009" test="(exists(cac:AdditionalDocumentReference[cbc:DocumentDescription = 'EINDAGI']) and exists(cbc:DueDate)) or not(exists(cac:AdditionalDocumentReference[cbc:DocumentDescription = 'EINDAGI']))" flag="fatal">[IS-R-009]-If seller is icelandic and invoice contains supporting description EINDAGI invoice must have due date — Ef seljandi er íslenskur þá skal reikningur sem inniheldur eindaga (BT-122, DocumentDescription = EINDAGI) einnig hafa gjalddaga (BT-9).</assert>
			<assert id="IS-R-010" test="(exists(cac:AdditionalDocumentReference[cbc:DocumentDescription = 'EINDAGI']) and (cbc:DueDate) &lt;= (cac:AdditionalDocumentReference[cbc:DocumentDescription = 'EINDAGI']/cbc:ID)) or not(exists(cac:AdditionalDocumentReference[cbc:DocumentDescription = 'EINDAGI']))" flag="fatal">[IS-R-010]-If seller is icelandic and invoice contains supporting description EINDAGI the id date must be same or later than due date — Ef seljandi er íslenskur þá skal eindagi (BT-122, DocumentDescription = EINDAGI) skal vera sami eða síðar en gjalddagi (BT-9) ef eindagi er til staðar.</assert>
		</rule>
		<rule context="ubl-creditnote:CreditNote[$SupplierCountry = 'IS' and $CustomerCountry = 'IS']/cac:AccountingCustomerParty | ubl-invoice:Invoice[$SupplierCountry = 'IS' and $CustomerCountry = 'IS']/cac:AccountingCustomerParty">
			<assert id="IS-R-004" test="exists(cac:Party/cac:PartyLegalEntity/cbc:CompanyID) and cac:Party/cac:PartyLegalEntity/cbc:CompanyID/@schemeID = '0196'" flag="fatal">[IS-R-004]-If seller and buyer are icelandic then the invoice shall contain the buyers icelandic legal identifier — Ef seljandi og kaupandi eru íslenskir þá skal reikningurinn innihalda íslenska kennitölu kaupanda (BT-47).</assert>
			<assert id="IS-R-005" test="exists(cac:Party/cac:PostalAddress/cbc:StreetName) and exists(cac:Party/cac:PostalAddress/cbc:PostalZone)" flag="fatal">[IS-R-005]-If seller and buyer are icelandic then the invoice shall contain the buyers address with street name and zip code — Ef seljandi og kaupandi eru íslenskir þá skal heimilisfang kaupanda innihalda götuheiti og póstnúmer (BT-50 og BT-53)</assert>
		</rule>
	</pattern>
	<!-- NETHERLANDS -->
	<pattern>
		<let name="supplierCountryIsNL" value="(upper-case(normalize-space(/*/cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode)) = 'NL')"/>
		<let name="customerCountryIsNL" value="(upper-case(normalize-space(/*/cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode)) = 'NL')"/>
		<let name="taxRepresentativeCountryIsNL" value="(upper-case(normalize-space(/*/cac:TaxRepresentativeParty/cac:PostalAddress/cac:Country/cbc:IdentificationCode)) = 'NL')"/>
		<rule context="cbc:CreditNoteTypeCode[$supplierCountryIsNL]">
			<!-- Original rule in NLCIUS: BR-NL-9
       This rule has changed: since 384 is not an allowed invoice type code in PEPPOL BIS,
       this rule now only applies to credit notes
      -->
			<assert id="NL-R-001" test="/*/cac:BillingReference/cac:InvoiceDocumentReference/cbc:ID" flag="fatal">[NL-R-001] For suppliers in the Netherlands, if the document is a creditnote, the document MUST contain an invoice reference (cac:BillingReference/cac:InvoiceDocumentReference/cbc:ID)</assert>
		</rule>
		<rule context="cac:AccountingSupplierParty/cac:Party/cac:PostalAddress[$supplierCountryIsNL]">
			<!-- Original rule in NLCIUS: BR-NL-3 -->
			<assert id="NL-R-002" test="cbc:StreetName and cbc:CityName and cbc:PostalZone" flag="fatal">[NL-R-002] For suppliers in the Netherlands the supplier's address (cac:AccountingSupplierParty/cac:Party/cac:PostalAddress) MUST contain street name (cbc:StreetName), city (cbc:CityName) and post code (cbc:PostalZone)</assert>
		</rule>
		<rule context="cac:AccountingSupplierParty/cac:Party/cac:PartyLegalEntity/cbc:CompanyID[$supplierCountryIsNL]">
			<!-- Original rule in NLCIUS: BR-NL-1 -->
			<assert id="NL-R-003" test="(contains(concat(' ', string-join(@schemeID, ' '), ' '), ' 0106 ') or contains(concat(' ', string-join(@schemeID, ' '), ' '), ' 0190 ')) and (normalize-space(.) != '')" flag="fatal">[NL-R-003] For suppliers in the Netherlands, the legal entity identifier MUST be either a KVK or OIN number (schemeID 0106 or 0190)</assert>
		</rule>
		<rule context="cac:AccountingCustomerParty/cac:Party/cac:PostalAddress[$supplierCountryIsNL and $customerCountryIsNL]">
			<!-- Original rule in NLCIUS: BR-NL-4 -->
			<assert id="NL-R-004" test="cbc:StreetName and cbc:CityName and cbc:PostalZone" flag="fatal">[NL-R-004] For suppliers in the Netherlands, if the customer is in the Netherlands, the customer address (cac:AccountingCustomerParty/cac:Party/cac:PostalAddress) MUST contain the street name (cbc:StreetName), the city (cbc:CityName) and post code (cbc:PostalZone)</assert>
		</rule>
		<rule context="cac:AccountingCustomerParty/cac:Party/cac:PartyLegalEntity/cbc:CompanyID[$supplierCountryIsNL and $customerCountryIsNL]">
			<!-- Original rule in NLCIUS: BR-NL-10 -->
			<assert id="NL-R-005" test="(contains(concat(' ', string-join(@schemeID, ' '), ' '), ' 0106 ') or contains(concat(' ', string-join(@schemeID, ' '), ' '), ' 0190 ')) and (normalize-space(.) != '')" flag="fatal">[NL-R-005] For suppliers in the Netherlands, if the customer is in the Netherlands, the customer's legal entity identifier MUST be either a KVK or OIN number (schemeID 0106 or 0190)</assert>
		</rule>
		<rule context="cac:TaxRepresentativeParty/cac:PostalAddress[$supplierCountryIsNL and $taxRepresentativeCountryIsNL]">
			<!-- Original rule in NLCIUS: BR-NL-5 -->
			<assert id="NL-R-006" test="cbc:StreetName and cbc:CityName and cbc:PostalZone" flag="fatal">[NL-R-006] For suppliers in the Netherlands, if the fiscal representative is in the Netherlands, the representative's address (cac:TaxRepresentativeParty/cac:PostalAddress) MUST contain street name (cbc:StreetName), city (cbc:CityName) and post code (cbc:PostalZone)</assert>
		</rule>
		<rule context="cac:LegalMonetaryTotal[$supplierCountryIsNL]">
			<!-- Original rule in NLCIUS: BR-NL-11 -->
			<assert id="NL-R-007" test="(/ubl-invoice:Invoice and xs:decimal(cbc:PayableAmount) &lt;= 0.0) or (/ubl-creditnote:CreditNote and xs:decimal(cbc:PayableAmount) &gt;= 0.0) or (//cac:PaymentMeans)" flag="fatal">[NL-R-007] For suppliers in the Netherlands, the supplier MUST provide a means of payment (cac:PaymentMeans) if the payment is from customer to supplier</assert>
		</rule>
		<rule context="cac:PaymentMeans[$supplierCountryIsNL and $customerCountryIsNL]">
			<!-- Original rule in NLCIUS: BR-NL-12 -->
			<assert id="NL-R-008" test="normalize-space(cbc:PaymentMeansCode) = '30' or
        normalize-space(cbc:PaymentMeansCode) = '48' or
        normalize-space(cbc:PaymentMeansCode) = '49' or
        normalize-space(cbc:PaymentMeansCode) = '57' or
        normalize-space(cbc:PaymentMeansCode) = '58' or
        normalize-space(cbc:PaymentMeansCode) = '59'" flag="fatal">[NL-R-008] For suppliers in the Netherlands, if the customer is in the Netherlands, the payment means code (cac:PaymentMeans/cbc:PaymentMeansCode) MUST be one of 30, 48, 49, 57, 58 or 59</assert>
		</rule>
		<rule context="cac:OrderLineReference/cbc:LineID[$supplierCountryIsNL]">
			<!-- Original rule in NLCIUS: BR-NL-13 -->
			<assert id="NL-R-009" test="exists(/*/cac:OrderReference/cbc:ID)" flag="fatal">[NL-R-009] For suppliers in the Netherlands, if an order line reference (cac:OrderLineReference/cbc:LineID) is used, there must be an order reference on the document level (cac:OrderReference/cbc:ID)</assert>
		</rule>
	</pattern>
	<!-- German rules -->
	<pattern id="german-rules">
		<let name="XR-SKONTO-REGEX" value="'#(SKONTO)#TAGE=([0-9]+#PROZENT=[0-9]+\.[0-9]{2})(#BASISBETRAG=-?[0-9]+\.[0-9]{2})?#$'"/>
		<let name="XR-EMAIL-REGEX" value="'^[a-zA-Z0-9!#\$%&amp;&#34;*+/=?^_`{|}~-]+(\.[a-zA-Z0-9!#\$%&amp;&#34;*+/=?^_`{|}~-]+)*@([a-zA-Z0-9]([a-zA-Z0-9-]*[a-zA-Z0-9])?\.)+[a-zA-Z0-9]([a-zA-Z0-9-]*[a-zA-Z0-9])?$'"/>
		<let name="XR-TELEPHONE-REGEX" value="'.*([0-9].*){3,}.*'"/>
		<rule context="(/ubl-invoice:Invoice | /ubl-creditnote:CreditNote)[$supplierCountryIsDE and $customerCountryIsDE]">
			<assert test="cac:PaymentMeans" flag="fatal" id="DE-R-001">An invoice shall contain information on "PAYMENT INSTRUCTIONS" (BG-16).</assert>
			<assert test="cbc:BuyerReference[boolean(normalize-space(.))]" flag="fatal" id="DE-R-015">The element "Buyer reference" (BT-10) shall be provided.</assert>
			<let name="supportedVATCodes" value="('S', 'Z', 'E', 'AE', 'K', 'G', 'L', 'M')"/>
			<let name="BT-31orBT-32Path" value="cac:AccountingSupplierParty/cac:Party/cac:PartyTaxScheme/cbc:CompanyID[boolean(normalize-space(.))]"/>
			<let name="BT-95-UBL-Inv" value="cac:AllowanceCharge/cac:TaxCategory/cbc:ID[ancestor::cac:AllowanceCharge/cbc:ChargeIndicator = 'false' and         following-sibling::cac:TaxScheme/cbc:ID = 'VAT']"/>
			<let name="BT-95-UBL-CN" value="cac:AllowanceCharge/cac:TaxCategory/cbc:ID[ancestor::cac:AllowanceCharge/cbc:ChargeIndicator = 'false']"/>
			<let name="BT-102" value="cac:AllowanceCharge/cac:TaxCategory/cbc:ID[ancestor::cac:AllowanceCharge/cbc:ChargeIndicator = 'true']"/>
			<let name="BT-151" value="(cac:InvoiceLine | cac:CreditNoteLine)/cac:Item/cac:ClassifiedTaxCategory/cbc:ID"/>
			<!-- If one of BT-95, BT-102, BT-151 is in List of supportedVATCodes then either
      BG-11=cac:TaxRepresentativeParty or $BT-31orBT-32Path has to exist -->
			<assert test="         (not(           ($BT-95-UBL-Inv = $supportedVATCodes or $BT-95-UBL-CN = $supportedVATCodes) or           ($BT-102 = $supportedVATCodes) or           ($BT-151 = $supportedVATCodes)         ) or         (cac:TaxRepresentativeParty, $BT-31orBT-32Path))         " flag="fatal" id="DE-R-016">If one of the VAT codes S, Z, E, AE, K, G, L, or M is used, an invoice shall contain at least one of the following elements: "Seller VAT identifier" (BT-31) or "Seller tax registration identifier" (BT-32) or "SELLER TAX REPRESENTATIVE PARTY" (BG-11).</assert>
			<let name="supportedInvAndCNTypeCodes" value="('326', '380', '384', '389', '381', '875', '876', '877')"/>
			<assert test="cbc:InvoiceTypeCode = $supportedInvAndCNTypeCodes         or cbc:CreditNoteTypeCode = $supportedInvAndCNTypeCodes" flag="warning" id="DE-R-017">The element "Invoice type code" (BT-3) should only contain the following values from code list UNTDID 1001: 326 (Partial invoice), 380 (Commercial invoice), 384 (Corrected invoice), 389 (Self-billed invoice), 381 (Credit note), 875 (Partial construction invoice), 876 (Partial final construction invoice), 877 (Final construction invoice).</assert>
			<assert test="every $line in             cac:PaymentTerms/cbc:Note[1]/tokenize(. , '(\r?\n)')[starts-with( normalize-space(.) , '#')]              satisfies matches ( normalize-space ($line), $XR-SKONTO-REGEX)                                  and                                 matches( cac:PaymentTerms/cbc:Note[1]/tokenize(. ,  '#.+#')[last()], '^\s*\n' )" flag="fatal" id="DE-R-018">Information on cash discounts for prompt payment (Skonto) shall be provided within the element "Payment terms" BT-20 in the following way: First segment "SKONTO", second segment amount of days ("TAGE=N"), third segment percentage ("PROZENT=N"). Percentage must be separated by dot with two decimal places. In case the base value of the invoiced amount is not provided in BT-115 but as a partial amount, the base value shall be provided as fourth segment "BASISBETRAG=N" as semantic data type amount. Each entry shall start with a #, the segments must be separated by # and a row shall end with a #. A complete statement on cash discount for prompt payment shall end with a XML-conformant line break. All statements on cash discount for prompt payment shall be given in capital letters. Additional whitespaces (blanks, tabulators or line breaks) are not allowed. Other characters or texts than defined above are not allowed.</assert>
			<assert test="count(cac:AdditionalDocumentReference) =                      count(cac:AdditionalDocumentReference[not(./cac:Attachment/cbc:EmbeddedDocumentBinaryObject/@filename = preceding-sibling::cac:AdditionalDocumentReference/cac:Attachment/cbc:EmbeddedDocumentBinaryObject/@filename)])" flag="fatal" id="DE-R-022">Attached documents provided with an invoice in "ADDITIONAL SUPPORTING DOCUMENTS" (BG-24) shall have a unique filename (non case-sensitive) within the element ″Attached document″ (BT-125).</assert>
			<assert test="((not(cbc:InvoiceTypeCode = 384 or cbc:CreditNoteTypeCode = 384) or                     (cac:BillingReference/cac:InvoiceDocumentReference)))" flag="warning" id="DE-R-026">If "Invoice type code" (BT-3) contains the code 384 (Corrected invoice), "PRECEDING INVOICE REFERENCE" (BG-3) should be provided at least once.</assert>
			<assert test="not(cac:PaymentMeans/cac:PaymentMandate)                        or (cac:AccountingSupplierParty/cac:Party/cac:PartyIdentification/cbc:ID[@schemeID='SEPA']                          | cac:PayeeParty/cac:PartyIdentification/cbc:ID[@schemeID='SEPA'])" flag="fatal" id="DE-R-030">If the group "DIRECT DEBIT" (BG-19) is delivered, the element "Bank assigned creditor identifier" (BT-90) shall be provided.</assert>
			<assert test="not(cac:PaymentMeans/cac:PaymentMandate) or (cac:PaymentMeans/cac:PaymentMandate/cac:PayerFinancialAccount/cbc:ID)" flag="fatal" id="DE-R-031">If the group "DIRECT DEBIT" (BG-19) is delivered, the element "Debited account identifier" (BT-91) shall be provided.</assert>
		</rule>
		<rule context="(/ubl-invoice:Invoice/cac:AccountingSupplierParty | /ubl-creditnote:CreditNote/cac:AccountingSupplierParty)[$supplierCountryIsDE and $customerCountryIsDE]">
			<assert test="cac:Party/cac:Contact" flag="fatal" id="DE-R-002">The group "SELLER CONTACT" (BG-6) shall be provided.</assert>
		</rule>
		<rule context="(/ubl-invoice:Invoice/cac:AccountingSupplierParty/cac:Party/cac:PostalAddress | /ubl-creditnote:CreditNote/cac:AccountingSupplierParty/cac:Party/cac:PostalAddress)[$supplierCountryIsDE and $customerCountryIsDE]">
			<assert test="cbc:CityName[boolean(normalize-space(.))]" flag="fatal" id="DE-R-003">The element "Seller city" (BT-37) shall be provided.</assert>
			<assert test="cbc:PostalZone[boolean(normalize-space(.))]" flag="fatal" id="DE-R-004">The element "Seller post code" (BT-38) shall be provided.</assert>
		</rule>
		<rule context="(/ubl-invoice:Invoice/cac:AccountingSupplierParty/cac:Party/cac:Contact | /ubl-creditnote:CreditNote/cac:AccountingSupplierParty/cac:Party/cac:Contact)[$supplierCountryIsDE and $customerCountryIsDE]">
			<assert test="cbc:Name[boolean(normalize-space(.))]" flag="fatal" id="DE-R-005">The element "Seller contact point" (BT-41) shall be provided.</assert>
			<assert test="cbc:Telephone[boolean(normalize-space(.))]" flag="fatal" id="DE-R-006">The element "Seller contact telephone number" (BT-42) shall be provided.</assert>
			<assert test="cbc:ElectronicMail[boolean(normalize-space(.))]" flag="fatal" id="DE-R-007">The element "Seller contact email address" (BT-43) shall be provided.</assert>
			<assert test="matches(normalize-space(cbc:Telephone), $XR-TELEPHONE-REGEX)" flag="warning" id="DE-R-027">"Seller contact telephone number" (BT-42) should contain a valid telephone number. A valid telephone should consist of 3 digits minimum.</assert>
			<assert test="matches(normalize-space(cbc:ElectronicMail), $XR-EMAIL-REGEX)" flag="warning" id="DE-R-028">"Seller contact email address" (BT-43) should contain exactly one @-sign, which should not be framed by a whitespace or a dot but by at least two characters on each side. A dot should not be the first or last character.</assert>
		</rule>
		<rule context="(/ubl-invoice:Invoice/cac:AccountingCustomerParty/cac:Party/cac:PostalAddress | /ubl-creditnote:CreditNote/cac:AccountingCustomerParty/cac:Party/cac:PostalAddress)[$supplierCountryIsDE and $customerCountryIsDE]">
			<assert test="cbc:CityName[boolean(normalize-space(.))]" flag="fatal" id="DE-R-008">The element "Buyer city" (BT-52) shall be provided.</assert>
			<assert test="cbc:PostalZone[boolean(normalize-space(.))]" flag="fatal" id="DE-R-009">The element "Buyer post code" (BT-53) shall be provided.</assert>
		</rule>
		<rule context="(/ubl-invoice:Invoice/cac:Delivery/cac:DeliveryLocation/cac:Address | /ubl-creditnote:CreditNote/cac:Delivery/cac:DeliveryLocation/cac:Address)[$supplierCountryIsDE and $customerCountryIsDE]">
			<assert test="cbc:CityName[boolean(normalize-space(.))]" flag="fatal" id="DE-R-010">The element "Deliver to city" (BT-77) shall be provided if the group "DELIVER TO ADDRESS" (BG-15) is delivered.</assert>
			<assert test="cbc:PostalZone[boolean(normalize-space(.))]" flag="fatal" id="DE-R-011">The element "Deliver to post code" (BT-78) shall be provided if the group "DELIVER TO ADDRESS" (BG-15) is delivered.</assert>
		</rule>
		<rule context="(/ubl-invoice:Invoice/cac:PaymentMeans[cbc:PaymentMeansCode = (30,58)] | /ubl-creditnote:CreditNote/cac:PaymentMeans[cbc:PaymentMeansCode = (30,58)])[$supplierCountryIsDE and $customerCountryIsDE]">
			<!-- check for PaymentMeansCode 30 was not added by purpose in 2.1.1. -->
			<assert test="not(cbc:PaymentMeansCode = '58') or                     matches(normalize-space(replace(cac:PayeeFinancialAccount/cbc:ID, '([ \n\r\t\s])', '')), '^[A-Z]{2}[0-9]{2}[a-zA-Z0-9]{0,30}$') and                     xs:integer(string-join(for $cp in string-to-codepoints(concat(substring(normalize-space(replace(cac:PayeeFinancialAccount/cbc:ID, '([ \n\r\t\s])', '')),5),upper-case(substring(normalize-space(replace(cac:PayeeFinancialAccount/cbc:ID, '([ \n\r\t\s])', '')),1,2)),substring(normalize-space(replace(cac:PayeeFinancialAccount/cbc:ID, '([ \n\r\t\s])', '')),3,2))) return  (if($cp &gt; 64) then string($cp - 55) else  string($cp - 48)),'')) mod 97 = 1" flag="warning" id="DE-R-019">The element "Payment account identifier" (BT-84) should contain a valid IBAN if code 58 SEPA is provided in "Payment means type code" (BT-81).</assert>
			<assert test="cac:PayeeFinancialAccount" flag="fatal" id="DE-R-023-1">If "Payment means type code" (BT-81) contains a code for credit transfer (30, 58), "CREDIT TRANSFER" (BG-17) shall
        be provided.</assert>
			<assert test="not(cac:CardAccount) and                     not(cac:PaymentMandate)" flag="fatal" id="DE-R-023-2">If "Payment means type code" (BT-81) contains a code for credit transfer (30, 58), BG-18 and BG-19 shall not be provided.</assert>
		</rule>
		<rule context="(/ubl-invoice:Invoice/cac:PaymentMeans[cbc:PaymentMeansCode = (48,54,55)] |/ubl-creditnote:CreditNote/cac:PaymentMeans[cbc:PaymentMeansCode = (48,54,55)])[$supplierCountryIsDE and $customerCountryIsDE]">
			<assert test="cac:CardAccount" flag="fatal" id="DE-R-024-1">If "Payment means type code" (BT-81) contains a code for payment card (48, 54, 55), "PAYMENT CARD INFORMATION" (BG-18) shall be provided.</assert>
			<assert test="not(cac:PayeeFinancialAccount) and                     not(cac:PaymentMandate)" flag="fatal" id="DE-R-024-2">If "Payment means type code" (BT-81) contains a code for payment card (48, 54, 55), BG-17 and BG-19 shall not be provided.</assert>
		</rule>
		<rule context="(/ubl-invoice:Invoice/cac:PaymentMeans[cbc:PaymentMeansCode = 59] | /ubl-creditnote:CreditNote/cac:PaymentMeans[cbc:PaymentMeansCode = 59])[$supplierCountryIsDE and $customerCountryIsDE]">
			<assert test="not(cbc:PaymentMeansCode = '59') or                     matches(normalize-space(replace(cac:PaymentMandate/cac:PayerFinancialAccount/cbc:ID, '([ \n\r\t\s])', '')), '^[A-Z]{2}[0-9]{2}[a-zA-Z0-9]{0,30}$') and                     xs:decimal(string-join(for $cp in string-to-codepoints(concat(substring(normalize-space(replace(cac:PaymentMandate/cac:PayerFinancialAccount/cbc:ID, '([ \n\r\t\s])', '')),5),upper-case(substring(normalize-space(replace(cac:PaymentMandate/cac:PayerFinancialAccount/cbc:ID, '([ \n\r\t\s])', '')),1,2)),substring(normalize-space(replace(cac:PaymentMandate/cac:PayerFinancialAccount/cbc:ID, '([ \n\r\t\s])', '')),3,2))) return  (if($cp &gt; 64) then string($cp - 55) else  string($cp - 48)),'')) mod 97 = 1" flag="warning" id="DE-R-020">The element "Debited account identifier" (BT-91) should contain a valid IBAN if code 59 SEPA is provided in "Payment means type code" (BT-81). </assert>
			<assert test="cac:PaymentMandate" flag="fatal" id="DE-R-025-1">If "Payment means type code" (BT-81) contains a code for direct debit (59), "DIRECT DEBIT" (BG-19) shall be provided.</assert>
			<assert test="not(cac:PayeeFinancialAccount) and                     not(cac:CardAccount)" flag="fatal" id="DE-R-025-2">If "Payment means type code" (BT-81) contains a code for direct debit (59), BG-17 and BG-18 shall not be provided.</assert>
		</rule>
		<rule context="(/ubl-invoice:Invoice/cac:TaxTotal/cac:TaxSubtotal | /ubl-creditnote:CreditNote/cac:TaxTotal/cac:TaxSubtotal)[$supplierCountryIsDE and $customerCountryIsDE]">
			<assert test="cac:TaxCategory/cbc:Percent[boolean(normalize-space(.))]" flag="fatal" id="DE-R-014">The element "VAT category rate" (BT-119) shall be provided.</assert>
		</rule>
	</pattern>
	<!-- Restricted code lists and formatting -->
	<pattern>
		<let name="ISO3166" value="tokenize('AD AE AF AG AI AL AM AO AQ AR AS AT AU AW AX AZ BA BB BD BE BF BG BH BI BJ BL BM BN BO BQ BR BS BT BV BW BY BZ CA CC CD CF CG CH CI CK CL CM CN CO CR CU CV CW CX CY CZ DE DJ DK DM DO DZ EC EE EG EH ER ES ET FI FJ FK FM FO FR GA GB GD GE GF GG GH GI GL GM GN GP GQ GR GS GT GU GW GY HK HM HN HR HT HU ID IE IL IM IN IO IQ IR IS IT JE JM JO JP KE KG KH KI KM KN KP KR KW KY KZ LA LB LC LI LK LR LS LT LU LV LY MA MC MD ME MF MG MH MK ML MM MN MO MP MQ MR MS MT MU MV MW MX MY MZ NA NC NE NF NG NI NL NO NP NR NU NZ OM PA PE PF PG PH PK PL PM PN PR PS PT PW PY QA RE RO RS RU RW SA SB SC SD SE SG SH SI SJ SK SL SM SN SO SR SS ST SV SX SY SZ TC TD TF TG TH TJ TK TL TM TN TO TR TT TV TW TZ UA UG UM US UY UZ VA VC VE VG VI VN VU WF WS YE YT ZA ZM ZW 1A XI', '\s')"/>
		<let name="ISO4217" value="tokenize('AFN EUR ALL DZD USD AOA XCD XCD ARS AMD AWG AUD AZN BSD BHD BDT BBD BYN BZD XOF BMD INR BTN BOB BOV USD BAM BWP NOK BRL USD BND BGN XOF BIF CVE KHR XAF CAD KYD XAF XAF CLP CLF CNY AUD AUD COP COU KMF CDF XAF NZD CRC XOF CUP CUC ANG CZK DKK DJF XCD DOP USD EGP SVC USD XAF ERN ETB FKP DKK FJD XPF XAF GMD GEL GHS GIP DKK XCD USD GTQ GBP GNF XOF GYD HTG USD AUD HNL HKD HUF ISK INR IDR XDR IRR IQD GBP ILS JMD JPY GBP JOD KZT KES AUD KPW KRW KWD KGS LAK LBP LSL ZAR LRD LYD CHF MOP MKD MGA MWK MYR MVR XOF USD MRO MUR XUA MXN MXV USD MDL MNT XCD MAD MZN MMK NAD ZAR AUD NPR XPF NZD NIO XOF NGN NZD AUD USD NOK OMR PKR USD PAB USD PGK PYG PEN PHP NZD PLN USD QAR RON RUB RWF SHP XCD XCD XCD WST STD SAR XOF RSD SCR SLE SGD ANG XSU SBD SOS ZAR SSP LKR SDG SRD NOK SZL SEK CHF CHE CHW SYP TWD TJS TZS THB USD XOF NZD TOP TTD TND TRY TMT USD AUD UGX UAH AED GBP USD USD USN UYU UYI UZS VUV VND USD USD XPF MAD YER ZMW ZWL XBA XBB XBC XBD XTS XXX XAU XPD XPT XAG VES VED ZWG ', '\s')"/>
		<let name="MIMECODE" value="tokenize('application/pdf image/png image/jpeg text/csv application/vnd.openxmlformats-officedocument.spreadsheetml.sheet application/vnd.oasis.opendocument.spreadsheet', '\s')"/>
		<let name="UNCL2005" value="tokenize('3 35 432', '\s')"/>
		<let name="UNCL5189" value="tokenize('41 42 60 62 63 64 65 66 67 68 70 71 88 95 100 102 103 104 105', '\s')"/>
		<let name="UNCL7161" value="tokenize('AA AAA AAC AAD AAE AAF AAH AAI AAS AAT AAV AAY AAZ ABA ABB ABC ABD ABF ABK ABL ABN ABR ABS ABT ABU ACF ACG ACH ACI ACJ ACK ACL ACM ACS ADC ADE ADJ ADK ADL ADM ADN ADO ADP ADQ ADR ADT ADW ADY ADZ AEA AEB AEC AED AEF AEH AEI AEJ AEK AEL AEM AEN AEO AEP AES AET AEU AEV AEW AEX AEY AEZ AJ AU CA CAB CAD CAE CAF CAI CAJ CAK CAL CAM CAN CAO CAP CAQ CAR CAS CAT CAU CAV CAW CAX CAY CAZ CD CG CS CT DAB DAC DAD DAF DAG DAH DAI DAJ DAK DAL DAM DAN DAO DAP DAQ DL EG EP ER FAA FAB FAC FC FH FI GAA HAA HD HH IAA IAB ID IF IR IS KO L1 LA LAA LAB LF MAE MI ML NAA OA PA PAA PC PL RAB RAC RAD RAF RE RF RH RV SA SAA SAD SAE SAI SG SH SM SU TAB TAC TT TV V1 V2 WH XAA YY ZZZ', '\s')"/>
		<let name="UNCL5305" value="tokenize('AE E S Z G O K L M', '\s')"/>
		<let name="eaid" value="tokenize('0002 0007 0009 0037 0060 0088 0096 0097 0106 0130 0135 0142 0147 0151 0170 0177 0183 0184 0188 0190 0191 0192 0193 0195 0196 0198 0199 0200 0201 0202 0204 0208 0209 0210 0211 0212 0213 0215 0216 0218 0221 0230 0235 9901 9906 9907 9910 9913 9914 9915 9918 9919 9920 9922 9923 9924 9925 9926 9927 9928 9929 9930 9931 9932 9933 9934 9935 9936 9937 9938 9939 9940 9941 9942 9943 9944 9945 9946 9947 9948 9949 9950 9951 9952 9953 9957 9959', '\s')"/>
		<rule context="cbc:EmbeddedDocumentBinaryObject[@mimeCode]">
			<assert id="PEPPOL-EN16931-CL001" test="
          some $code in $MIMECODE
            satisfies @mimeCode = $code" flag="fatal">Mime code must be according to subset of IANA code list.</assert>
		</rule>
		<rule context="cac:AllowanceCharge[cbc:ChargeIndicator = 'false']/cbc:AllowanceChargeReasonCode">
			<assert id="PEPPOL-EN16931-CL002" test="
          some $code in $UNCL5189
            satisfies normalize-space(text()) = $code" flag="fatal">Reason code MUST be according to subset of UNCL 5189 D.16B.</assert>
		</rule>
		<rule context="cac:AllowanceCharge[cbc:ChargeIndicator = 'true']/cbc:AllowanceChargeReasonCode">
			<assert id="PEPPOL-EN16931-CL003" test="
          some $code in $UNCL7161
            satisfies normalize-space(text()) = $code" flag="fatal">Reason code MUST be according to UNCL 7161 D.16B.</assert>
		</rule>
		<rule context="cac:InvoicePeriod/cbc:DescriptionCode">
			<assert id="PEPPOL-EN16931-CL006" test="
          some $code in $UNCL2005
            satisfies normalize-space(text()) = $code" flag="fatal">Invoice period description code must be according to UNCL 2005 D.16B.</assert>
		</rule>
		<rule context="cbc:Amount | cbc:BaseAmount | cbc:PriceAmount | cbc:TaxAmount | cbc:TaxableAmount | cbc:LineExtensionAmount | cbc:TaxExclusiveAmount | cbc:TaxInclusiveAmount | cbc:AllowanceTotalAmount | cbc:ChargeTotalAmount | cbc:PrepaidAmount | cbc:PayableRoundingAmount | cbc:PayableAmount">
			<assert id="PEPPOL-EN16931-CL007" test="
          some $code in $ISO4217
            satisfies @currencyID = $code" flag="fatal">Currency code must be according to ISO 4217:2005</assert>
		</rule>
		<rule context="cbc:InvoiceTypeCode">
			<assert id="PEPPOL-EN16931-P0100" test="
          $profile != '01' or (some $code in tokenize('71 80 82 84 102 218 219 326 331 380 382 383 384 386 388 393 395 553 575 623 780 817 870 875 876 877', '\s')
            satisfies normalize-space(text()) = $code)" flag="fatal">Invoice type code MUST be set according to the profile.</assert>
			<assert id="PEPPOL-EN16931-P0112" test="not(normalize-space(.) = '326' or normalize-space(.) = '384') or ($supplierCountryIsDE and $customerCountryIsDE)" flag="fatal">Invoice type code 326 or 384 are only allowed when both buyer and seller are German organizations </assert>
		</rule>
		<rule context="cbc:CreditNoteTypeCode">
			<assert id="PEPPOL-EN16931-P0101" test="
          $profile != '01' or (some $code in tokenize('381 396 81 83 532', '\s')
            satisfies normalize-space(text()) = $code)" flag="fatal">Credit note type code MUST be set according to the profile.</assert>
		</rule>
		<rule context="cbc:IssueDate | cbc:DueDate | cbc:TaxPointDate | cbc:StartDate | cbc:EndDate | cbc:ActualDeliveryDate">
			<assert id="PEPPOL-EN16931-F001" test="string-length(text()) = 10 and (string(.) castable as xs:date)" flag="fatal">A date MUST be formatted YYYY-MM-DD.</assert>
		</rule>
		<rule context="cbc:EndpointID[@schemeID]">
			<assert id="PEPPOL-EN16931-CL008" test="
        some $code in $eaid
        satisfies @schemeID = $code" flag="fatal">Electronic address identifier scheme must be from the codelist "Electronic Address Identifier Scheme"</assert>
		</rule>
		<rule context="cac:TaxCategory[upper-case(cbc:TaxExemptionReasonCode)='VATEX-EU-G']">
			<assert id="PEPPOL-EN16931-P0104" test="normalize-space(cbc:ID)='G'" flag="fatal">Tax Category G MUST be used when exemption reason code is VATEX-EU-G</assert>
		</rule>
		<rule context="cac:TaxCategory[upper-case(cbc:TaxExemptionReasonCode)='VATEX-EU-O']">
			<assert id="PEPPOL-EN16931-P0105" test="normalize-space(cbc:ID)='O'" flag="fatal">Tax Category O MUST be used when exemption reason code is VATEX-EU-O</assert>
		</rule>
		<rule context="cac:TaxCategory[upper-case(cbc:TaxExemptionReasonCode)='VATEX-EU-IC']">
			<assert id="PEPPOL-EN16931-P0106" test="normalize-space(cbc:ID)='K'" flag="fatal">Tax Category K MUST be used when exemption reason code is VATEX-EU-IC</assert>
		</rule>
		<rule context="cac:TaxCategory[upper-case(cbc:TaxExemptionReasonCode)='VATEX-EU-AE']">
			<assert id="PEPPOL-EN16931-P0107" test="normalize-space(cbc:ID)='AE'" flag="fatal">Tax Category AE MUST be used when exemption reason code is VATEX-EU-AE</assert>
		</rule>
		<rule context="cac:TaxCategory[upper-case(cbc:TaxExemptionReasonCode)='VATEX-EU-D']">
			<assert id="PEPPOL-EN16931-P0108" test="normalize-space(cbc:ID)='E'" flag="fatal">Tax Category E MUST be used when exemption reason code is VATEX-EU-D</assert>
		</rule>
		<rule context="cac:TaxCategory[upper-case(cbc:TaxExemptionReasonCode)='VATEX-EU-F']">
			<assert id="PEPPOL-EN16931-P0109" test="normalize-space(cbc:ID)='E'" flag="fatal">Tax Category E MUST be used when exemption reason code is VATEX-EU-F</assert>
		</rule>
		<rule context="cac:TaxCategory[upper-case(cbc:TaxExemptionReasonCode)='VATEX-EU-I']">
			<assert id="PEPPOL-EN16931-P0110" test="normalize-space(cbc:ID)='E'" flag="fatal">Tax Category E MUST be used when exemption reason code is VATEX-EU-I</assert>
		</rule>
		<rule context="cac:TaxCategory[upper-case(cbc:TaxExemptionReasonCode)='VATEX-EU-J']">
			<assert id="PEPPOL-EN16931-P0111" test="normalize-space(cbc:ID)='E'" flag="fatal">Tax Category E MUST be used when exemption reason code is VATEX-EU-J</assert>
		</rule>
	</pattern>
</schema>