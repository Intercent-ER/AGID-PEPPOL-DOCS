<?xml version="1.0" encoding="UTF-8"?>  
<pattern id="INT-UBL-T01" xmlns="http://purl.oclc.org/dsdl/schematron">
      <let name="clUNECERec20IT"
		   value="tokenize('C62 PR DZP XPK KT XBX XOB MMT CMT MTR CMK MTK MMQ CMQ MTQ MLT LTR MC MGM GRM HGM KGM HUR DAY MON ANN E49 KWH BQL 4N GBQ MCU CUR', '\s')"/>
		   
	<rule context="//cbc:EndpointID" flag="fatal">
		<assert test="((@schemeID='9921' or @schemeID='0201') and matches(.,'^[a-zA-Z0-9]{6,8}$')) or (@schemeID!='9921' and @schemeID!='0201')" flag="fatal" id="INT-T01-R026">[INT-T01-R026] - Se l'identificatore di endpoint si basa sullo schema di identificatori IT:IPA (ICD: 0201 ex 9921), questo dovrà seguire la sintassi [A-Z0-9]{6,8}.</assert>
		<assert test="(@schemeID='9906' and matches(.,'^(IT)?[0-9]{11}$')) or @schemeID!='9906'" flag="fatal" id="INT-T01-R027">[INT-T01-R027] - Se l'identificatore di endpoint si basa sullo schema di identificatori IT:VAT (ICD: 9906), questo dovrà seguire la sintassi (IT)?[0-9]{11}.</assert>
		<assert test="(@schemeID='9907' and matches(.,'^[0-9]{11}$|^[A-Z]{6}\d{2}[ABCDEHLMPRST]{1}\d{2}[A-Z]{1}\d{3}[A-Z]{1}$')) or @schemeID!='9907'" flag="fatal" id="INT-T01-R028">[INT-T01-R028] - Se l'identificatore di endpoint si basa sullo schema di identificatori IT:CF (ICD: 9907), questo dovrà seguire la sintassi [0-9]{11} per le persone giuridiche e la sintassi [A-Z]{6}\d{2}[ABCDEHLMPRST]{1}\d{2}[A-Z]{1}\d{3}[A-Z]{1} per quelle fisiche.</assert>
	</rule>
	
	<!--rule context="//cac:OrderLine/cac:LineItem" flag="fatal"> 
		<assert test="(not(cac:Price/cbc:PriceAmount) or not(cbc:LineExtensionAmount)) or (cac:Price/cbc:PriceAmount and not(cac:Price/cbc:BaseQuantity) and cbc:LineExtensionAmount and cac:AllowanceCharge[cbc:ChargeIndicator='false']/cbc:Amount and xs:decimal(cbc:LineExtensionAmount) = round(((xs:decimal(cac:Price/cbc:PriceAmount) * xs:decimal(cbc:Quantity)) - xs:decimal(cac:AllowanceCharge/cbc:Amount)) * 100) div 100) or (cac:Price/cbc:PriceAmount and not(cac:Price/cbc:BaseQuantity) and cbc:LineExtensionAmount and cac:AllowanceCharge[cbc:ChargeIndicator='true']/cbc:Amount and xs:decimal(cbc:LineExtensionAmount) = round(((xs:decimal(cac:Price/cbc:PriceAmount) * xs:decimal(cbc:Quantity)) + xs:decimal(cac:AllowanceCharge/cbc:Amount)) * 100) div 100) or (cac:Price/cbc:PriceAmount and not(cac:Price/cbc:BaseQuantity) and cbc:LineExtensionAmount and not(cac:AllowanceCharge/cbc:Amount) and xs:decimal(cbc:LineExtensionAmount) = round(xs:decimal(cac:Price/cbc:PriceAmount) * xs:decimal(cbc:Quantity) * 100) div 100) or (cac:Price/cbc:PriceAmount and cac:Price/cbc:BaseQuantity and cbc:LineExtensionAmount and cac:AllowanceCharge[cbc:ChargeIndicator='false']/cbc:Amount and xs:decimal(cbc:LineExtensionAmount) = round(((xs:decimal(cac:Price/cbc:PriceAmount) * xs:decimal(cbc:Quantity) div xs:decimal(cac:Price/cbc:BaseQuantity)) - xs:decimal(cac:AllowanceCharge/cbc:Amount)) * 100) div 100) or (cac:Price/cbc:PriceAmount and cac:Price/cbc:BaseQuantity and cbc:LineExtensionAmount and cac:AllowanceCharge[cbc:ChargeIndicator='true']/cbc:Amount and xs:decimal(cbc:LineExtensionAmount) = round(((xs:decimal(cac:Price/cbc:PriceAmount) * xs:decimal(cbc:Quantity) div xs:decimal(cac:Price/cbc:BaseQuantity)) + xs:decimal(cac:AllowanceCharge/cbc:Amount)) * 100) div 100) or (cac:Price/cbc:PriceAmount and cac:Price/cbc:BaseQuantity and cbc:LineExtensionAmount and not(cac:AllowanceCharge/cbc:Amount) and xs:decimal(cbc:LineExtensionAmount) = round(xs:decimal(cac:Price/cbc:PriceAmount) * xs:decimal(cbc:Quantity) div xs:decimal(cac:Price/cbc:BaseQuantity) * 100) div 100)" flag="fatal" id="INT-T01-R004">[INT-T01-R004] - Se il prezzo e il totale riga d'ordine sono presenti, il totale riga DEVE essere ottenuto moltiplicando il prezzo per la quantità diviso la quantità base a cui si riferisce il prezzo e includendo l'eventuale sconto o maggiorazione indicati.</assert>
	</rule-->
	
	<rule context="/ubl:Order"> 
		<!--assert test="cbc:CustomizationID = 'urn:fdc:peppol.eu:poacc:trns:order:3:extended:urn:www.ubl-italia.org:spec:ordine:ver3.1' and cbc:ProfileID = 'urn:fdc:peppol.eu:poacc:bis:ordering:3'" flag="fatal" id="INT-T01-R003">[INT-T01-R003] - La transazione dell'Ordine DEVE essere identificata dai seguenti identificativi: 

CustomizationID = 'urn:fdc:peppol.eu:poacc:trns:order:3:extended:urn:www.ubl-italia.org:spec:ordine:ver3.1', 

		ProfileID = 'urn:fdc:peppol.eu:poacc:bis:ordering:3'.</assert-->
		<assert test="cac:OriginatorDocumentReference/cbc:ID or cac:OrderLine/cac:LineItem/cac:Item/cac:ItemSpecificationDocumentReference[not(contains(cbc:ID, ':'))] or cac:OrderLine/cac:LineItem/cac:Item/cac:ItemSpecificationDocumentReference[starts-with(cbc:ID, 'CIG:')]" flag="fatal" id="INT-T01-R029">[INT-T01-R029] - Il Codice Identificativo Gara (CIG) DEVE essere sempre indicato in testata all'Ordine o a livello di riga.</assert>
		<assert test="not(cac:OrderDocumentReference) or count(cac:OrderDocumentReference)!=count(cac:OrderDocumentReference[cbc:DocumentStatusCode='Cancelled']) or (count(cac:OrderLine)=1 and cac:OrderLine/cac:LineItem/cbc:ID='NA' and cac:OrderLine/cac:LineItem/cac:Item/cbc:Name='NA' and cac:OrderLine/cac:LineItem/cbc:Quantity=0 and not(cac:TaxTotal) and not(cac:AnticipatedMonetaryTotal))" flag="fatal" id="INT-T01-R034">INT-T01-R034 - Nel caso in cui l'ordine contenga il riferimento ad un solo ordine per comunicarne la sola cancellazione, è obbligatorio fornire una sola riga d'ordine con identificativo e nome articolo valorizzati con 'NA' e quantità posta a zero.</assert>
		<assert test="not(cac:OrderDocumentReference) or count(cac:OrderDocumentReference[cbc:DocumentStatusCode='Revised'])=0 or cac:OrderLine/cac:LineItem/cbc:ID!='NA'" flag="fatal" id="INT-T01-R035">INT-T01-R035 - Nel caso in cui l'ordine contenga il riferimento ad un solo ordine per comunicarne la revisione è obbligatorio fornire una o più righe d'ordine con identificativo diverso da 'NA'.</assert>	
	</rule>
	
	<!--rule context="//cac:OrderDocumentReference" flag="fatal"> 
		<assert test="cac:IssuerParty/cbc:EndpointID or not(contains( ' Cancelled Disputed Revised NotConfirmed Rejected ',concat(' ',normalize-space(cbc:DocumentStatusCode),' ') ))" flag="fatal" id="INT-T01-R030">INT-T01-R030 - Se si intende revocare o modificare un ordine l'endpoint del Buyer è obbligatorio all’interno della sezione che contiene i riferimenti al documento collegato (OrderDocumentReference).</assert>
		<assert test="cbc:IssueDate or not(contains( ' Cancelled Disputed Revised NotConfirmed Rejected ',concat(' ',normalize-space(cbc:DocumentStatusCode),' ') ))" flag="fatal" id="INT-T01-R031">INT-T01-R031 - Se si intende revocare o modificare un ordine la data è obbligatoria all’interno della sezione che contiene i riferimenti al documento collegato (OrderDocumentReference).</assert>
	</rule-->
	
	<rule context="//cac:BuyerCustomerParty/cac:Party" flag="fatal"> 
		<assert test="cac:PartyName/cbc:Name and cac:PostalAddress/cac:Country/cbc:IdentificationCode and cac:PartyTaxScheme/cbc:CompanyID" flag="fatal" id="INT-T01-R002">[INT-T01-R002] - L'ordine DEVE contenere il nome, il paese e l'identificativo fiscale della parte ordinane (Acquirente).</assert>
		<assert test="not(cac:PartyIdentification/cbc:ID) or cac:PartyIdentification/cbc:ID/@schemeID='9921' or cac:PartyIdentification/cbc:ID/@schemeID='0201'" flag="fatal" id="INT-T01-R032">INT-T01-R032 - Un ordine deve riportare obbligatoriamente un solo identificatore della parte di business (party identification) del Buyer. Nel caso di Buyer di tipo PA deve riportare lo schema IPA.</assert>
		<assert test="cac:PartyIdentification/cbc:ID[@schemeID='9921' or @schemeID='0201'][matches(.,'^[A-Z0-9]{6}$')] or cbc:EndpointID[@schemeID='9921' or @schemeID='0201'][string-length() = 6]" flag="fatal" id="INT-T01-R033">INT-T01-R033 - Un ordine DEVE contenere Il codice UFE IPA dell'ufficio della PA che lo ha emesso, composto da 6 caratteri ASCII alfanumerici maiuscoli.</assert>
	</rule>
	
	<rule context="//cac:SellerSupplierParty/cac:Party" flag="fatal"> 
		<assert test="(cac:PostalAddress/cac:Country/cbc:IdentificationCode = 'IT' and (cbc:EndpointID[@schemeID='9921' or @schemeID='0201' or @schemeID='9906' or @schemeID='9907'] or cbc:EndpointID[@schemeID='0202' and matches(.,'.+@.+[.]+.+')])) or cac:PostalAddress/cac:Country/cbc:IdentificationCode != 'IT'" flag="fatal" id="INT-T01-R036">INT-T01-R036 - Un ordine DEVE riportare nell’EndpointID del fornitore italiano: il Participant ID PEPPOL oppure il codice destinatario (CODDEST) composto da 8 caratteri ASCII alfanumerici maiuscoli oppure la PEC.</assert>
	</rule>
	
	<rule context="//cbc:*" flag="fatal"> 
		<assert test="normalize-space()" flag="fatal" id="INT-T01-R001">[INT-T01-R001] - Un elemento informativo base, se istanziato, non può essere vuoto.</assert>
	</rule>
	
</pattern>

