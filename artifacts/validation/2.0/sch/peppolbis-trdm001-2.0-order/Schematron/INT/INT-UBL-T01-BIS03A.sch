<?xml version="1.0" encoding="UTF-8"?>  
<pattern id="INT-UBL-T01" xmlns="http://purl.oclc.org/dsdl/schematron">
	
	<rule context="//cbc:EndpointID" flag="fatal">
		<assert test="(@schemeID='IT:IPA' and matches(.,'^[a-zA-Z0-9]{6,7}$')) or @schemeID!='IT:IPA'" flag="fatal" id="INT-T01-R026">[INT-T01-R026] - Se l'identificatore di endpoint si basa sullo schema di identificatori IT:IPA, questo dovrà seguire la sintassi [A-Z0-9]{6,7}.</assert>
		<assert test="(@schemeID='IT:VAT' and matches(.,'^(IT)?[0-9]{11}$')) or @schemeID!='IT:VAT'" flag="fatal" id="INT-T01-R027">[INT-T01-R027] - Se l'identificatore di endpoint si basa sullo schema di identificatori IT:VAT, questo dovrà seguire la sintassi (IT)?[0-9]{11}.</assert>
		<assert test="(@schemeID='IT:CF' and matches(.,'^[0-9]{11}$|^[A-Z]{6}\d{2}[ABCDEHLMPRST]{1}\d{2}[A-Z]{1}\d{3}[A-Z]{1}$')) or @schemeID!='IT:CF'" flag="fatal" id="INT-T01-R028">[INT-T01-R028] - Se l'identificatore di endpoint si basa sullo schema di identificatori IT:CF, questo dovrà seguire la sintassi [0-9]{11} per le persone giuridiche e la sintassi [A-Z]{6}\d{2}[ABCDEHLMPRST]{1}\d{2}[A-Z]{1}\d{3}[A-Z]{1} per quelle fisiche.</assert>
	</rule>
	
	<rule context="//cac:OrderLine/cac:LineItem" flag="fatal"> 
		<assert test="(not(cac:Price/cbc:PriceAmount) or not(cbc:LineExtensionAmount)) or (cac:Price/cbc:PriceAmount and not(cac:Price/cbc:BaseQuantity) and cbc:LineExtensionAmount and cac:AllowanceCharge[cbc:ChargeIndicator='false']/cbc:Amount and xs:decimal(cbc:LineExtensionAmount) = round(((xs:decimal(cac:Price/cbc:PriceAmount) * xs:decimal(cbc:Quantity)) - xs:decimal(cac:AllowanceCharge/cbc:Amount)) * 100) div 100) or (cac:Price/cbc:PriceAmount and not(cac:Price/cbc:BaseQuantity) and cbc:LineExtensionAmount and cac:AllowanceCharge[cbc:ChargeIndicator='true']/cbc:Amount and xs:decimal(cbc:LineExtensionAmount) = round(((xs:decimal(cac:Price/cbc:PriceAmount) * xs:decimal(cbc:Quantity)) + xs:decimal(cac:AllowanceCharge/cbc:Amount)) * 100) div 100) or (cac:Price/cbc:PriceAmount and not(cac:Price/cbc:BaseQuantity) and cbc:LineExtensionAmount and not(cac:AllowanceCharge/cbc:Amount) and xs:decimal(cbc:LineExtensionAmount) = round(xs:decimal(cac:Price/cbc:PriceAmount) * xs:decimal(cbc:Quantity) * 100) div 100) or (cac:Price/cbc:PriceAmount and cac:Price/cbc:BaseQuantity and cbc:LineExtensionAmount and cac:AllowanceCharge[cbc:ChargeIndicator='false']/cbc:Amount and xs:decimal(cbc:LineExtensionAmount) = round(((xs:decimal(cac:Price/cbc:PriceAmount) * xs:decimal(cbc:Quantity) div xs:decimal(cac:Price/cbc:BaseQuantity)) - xs:decimal(cac:AllowanceCharge/cbc:Amount)) * 100) div 100) or (cac:Price/cbc:PriceAmount and cac:Price/cbc:BaseQuantity and cbc:LineExtensionAmount and cac:AllowanceCharge[cbc:ChargeIndicator='true']/cbc:Amount and xs:decimal(cbc:LineExtensionAmount) = round(((xs:decimal(cac:Price/cbc:PriceAmount) * xs:decimal(cbc:Quantity) div xs:decimal(cac:Price/cbc:BaseQuantity)) + xs:decimal(cac:AllowanceCharge/cbc:Amount)) * 100) div 100) or (cac:Price/cbc:PriceAmount and cac:Price/cbc:BaseQuantity and cbc:LineExtensionAmount and not(cac:AllowanceCharge/cbc:Amount) and xs:decimal(cbc:LineExtensionAmount) = round(xs:decimal(cac:Price/cbc:PriceAmount) * xs:decimal(cbc:Quantity) div xs:decimal(cac:Price/cbc:BaseQuantity) * 100) div 100)" flag="fatal" id="INT-T01-R004">[INT-T01-R004] - Se il prezzo e il totale riga d'ordine sono presenti, il totale riga DEVE essere ottenuto moltiplicando il prezzo per la quantità diviso la quantità base a cui si riferisce il prezzo e includendo l'eventuale sconto o maggiorazione indicati.</assert>
	</rule>  
	
	<rule context="/ubl:Order"> 
		<assert test="cbc:UBLVersionID = '2.1' and cbc:CustomizationID = 'urn:www.cenbii.eu:transaction:biitrns001:ver2.0:extended:urn:www.peppol.eu:bis:peppol3a:ver2.0:extended:urn:www.ubl-italia.org:spec:ordine:ver2.1' and cbc:ProfileID = 'urn:www.cenbii.eu:profile:bii03:ver2.0'" flag="fatal" id="INT-T01-R003">[INT-T01-R003] - La versione dell'Ordine DEVE corrispondere alle seguenti 3 dimensioni: 

UBLVersionID = '2.1', 

CustomizationID = 'urn:www.cenbii.eu:transaction:biitrns001:ver2.0:extended:urn:www.peppol.eu:bis:peppol3a:ver2.0:extended:urn:www.ubl-italia.org:spec:ordine:ver2.1', 

ProfileID = 'urn:www.cenbii.eu:profile:bii03:ver2.0'.</assert>
		<assert test="cac:AdditionalDocumentReference[cbc:DocumentType='CIG'] or cac:OrderLine/cac:DocumentReference[cbc:DocumentType='CIG']" flag="warning" id="INT-T01-R029">[INT-T01-R029] - Il Codice Identificativo Gara (CIG) dovrebbe essere sempre indicato in testata all'Ordine o a livello di riga.</assert>
		<assert test="not(cac:OrderDocumentReference) or count(cac:OrderDocumentReference)!=count(cac:OrderDocumentReference[cbc:DocumentStatusCode='Cancelled']) or (count(cac:OrderLine)=1 and cac:OrderLine/cac:LineItem/cbc:ID='NA' and cac:OrderLine/cac:LineItem/cac:Item/cbc:Name='NA' and cac:OrderLine/cac:LineItem/cbc:Quantity=0 and not(cac:TaxTotal) and not(cac:AnticipatedMonetaryTotal))" flag="fatal" id="INT-T01-R034">INT-T01-R034 - Nel caso in cui l'ordine contenga il riferimento ad uno o più ordini per comunicarne la sola cancellazione, è obbligatorio fornire una sola riga d'ordine con identificativo e nome articolo valorizzati con 'NA' e quantità posta a zero.</assert>
		<assert test="not(cac:OrderDocumentReference) or count(cac:OrderDocumentReference[cbc:DocumentStatusCode='Revised'])=0 or cac:OrderLine/cac:LineItem/cbc:ID!='NA'" flag="fatal" id="INT-T01-R035">INT-T01-R035 - Nel caso in cui l'ordine contenga il riferimento ad uno o più ordini per comunicarne la revisione o una condizione mista di ordini cancellati e revisionati, è obbligatorio fornire una o più righe d'ordine con identificativo diverso da 'NA'.</assert>	
	</rule>
	
	<rule context="//cac:OrderDocumentReference" flag="fatal"> 
		<assert test="cac:IssuerParty/cac:PartyIdentification/cbc:ID or not(contains( ' Cancelled Disputed Revised NotConfirmed Rejected ',concat(' ',normalize-space(cbc:DocumentStatusCode),' ') ))" flag="fatal" id="INT-T01-R030">INT-T01-R030 - Se si intende revocare o modificare un ordine l'identificatore della parte di business del Buyer è obbligatorio all’interno della sezione che contiene i riferimenti al documento collegato (OrderDocumentReference).</assert>
		<assert test="cbc:IssueDate or not(contains( ' Cancelled Disputed Revised NotConfirmed Rejected ',concat(' ',normalize-space(cbc:DocumentStatusCode),' ') ))" flag="fatal" id="INT-T01-R031">INT-T01-R031 - Se si intende revocare o modificare un ordine la data è obbligatoria all’interno della sezione che contiene i riferimenti al documento collegato (OrderDocumentReference).</assert>
	</rule>
	
	<rule context="//cac:BuyerCustomerParty/cac:Party" flag="fatal"> 
		<assert test="cac:PartyName/cbc:Name and cac:PostalAddress/cac:Country/cbc:IdentificationCode and cac:PartyTaxScheme/cbc:CompanyID" id="INT-T01-R002">[INT-T01-R002] - L'ordine DEVE contenere il nome, il paese e l'identificativo fiscale della parte ordinane (Acquirente).</assert>
		<assert test="count(cac:PartyIdentification/cbc:ID)=1 and cac:PartyIdentification/cbc:ID/@schemeID='IT:IPA'" flag="fatal" id="INT-T01-R032">INT-T01-R032 - Un ordine deve riportare obbligatoriamente un solo identificatore della parte di business (party identification) del Buyer. Nel caso di Buyer di tipo PA deve riportare lo schema IPA.</assert>
		<assert test="cac:PartyIdentification/cbc:ID[@schemeID='IT:IPA'][string-length(translate(.,'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789','')) = 0 and string-length() &gt;= 6 and string-length() &lt;= 7]" flag="fatal" id="INT-T01-R033">INT-T01-R033 - Un ordine DEVE contenere Il codice UFE IPA dell'ufficio della PA che lo ha emesso, composto da 6 a 7 caratteri ASCII alfanumerici maiuscoli.</assert>
	</rule>
	
	<rule context="//cbc:*" flag="fatal"> 
		<assert test="normalize-space()" flag="fatal" id="INT-T01-R001">[INT-T01-R001] - Un elemento informativo base, se istanziato, non può essere vuoto.</assert>
	</rule>
	
</pattern>

