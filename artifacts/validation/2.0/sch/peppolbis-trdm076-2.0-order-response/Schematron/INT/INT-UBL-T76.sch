<?xml version="1.0" encoding="UTF-8"?>  
<pattern id="INT-UBL-T76" xmlns="http://purl.oclc.org/dsdl/schematron">

	<rule context="/ubl:OrderResponse"> 
		<assert test="cbc:UBLVersionID = '2.1' and cbc:CustomizationID = 'urn:www.cenbii.eu:transaction:biitrns076:ver2.0:extended:urn:www.peppol.eu:bis:peppol28a:ver1.0:extended:urn:www.ubl-italia.org:spec:ordine:ver2.1' and cbc:ProfileID = 'urn:www.cenbii.eu:profile:bii28:ver2.0'" flag="fatal" id="INT-T76-R003">[INT-T76-R003] - La versione della Risposta d'Ordine DEVE corrispondere alle seguenti 3 dimensioni: 

UBLVersionID = '2.1', 

CustomizationID = 'urn:www.cenbii.eu:transaction:biitrns076:ver2.0:extended:urn:www.peppol.eu:bis:peppol28a:ver1.0:extended:urn:www.ubl-italia.org:spec:ordine:ver2.1', 

ProfileID = 'urn:www.cenbii.eu:profile:bii28:ver2.0'.</assert>
	</rule>
	
	<rule context="//cbc:OrderResponseCode[@listID='UNCL1225']" flag="fatal">
		<assert test="not(contains( ' 1 2 3 4 5 17 20 21 27 28 29 30 33 34 36 40 ',concat(' ',normalize-space(.),' ') )) or /*/cac:SellerSupplierParty/cac:Party/cac:Contact" flag="fatal" id="INT-T76-R002">INT-T76-R002 - Le informazioni di contatto del fornitore sono obbligatorie in caso di rigetto o modifica dell’Ordine.</assert>
		<assert test="not(contains( ' 1 2 3 4 5 17 20 21 27 28 29 30 33 34 36 40 ',concat(' ',normalize-space(.),' ') )) or /*/cbc:Note" flag="fatal" id="INT-T76-R010">INT-T76-R010 - La risposta d’ordine in caso di rigetto o modifica DEVE specificarne il motivo.</assert>
		<assert test="normalize-space(.)!='27' or count(/*/cac:OrderLine) = 0" flag="fatal" id="INT-T76-R004">INT-T76-R004 - Se il codice di risposta in testata è 27 (rifiutato) non deve essere fornita alcuna riga di dettaglio.</assert>
		<assert test="normalize-space(.)!='29' or count(/*/cac:OrderLine) = 0" flag="fatal" id="INT-T76-R005">INT-T76-R005 - Se il codice di risposta in testata è 29 (accettato) non deve essere fornita alcuna riga di dettaglio.</assert>
		<assert test="normalize-space(.)!='30' or count(/*/cac:OrderLine) &gt; 0" flag="fatal" id="INT-T76-R006">INT-T76-R006 - Se il codice di risposta in testata è 30 (accettato con modifiche) e necessario fornire tutte le righe dell'ordine con il loro stato.</assert>
	</rule>

	<rule context="//cac:BuyerCustomerParty/cac:Party" flag="fatal"> 
		<assert test="cac:PartyIdentification/cbc:ID[@schemeID='IT:IPA'][string-length(translate(.,'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789','')) = 0 and string-length() &gt;= 6 and string-length() &lt;= 7]" flag="fatal" id="INT-T76-R007">INT-T76-R007 - Una risposta d'ordine DEVE contenere Il codice UFE IPA dell'ufficio della PA che ha emesso l'ordine, composto da 6 a 7 caratteri ASCII alfanumerici maiuscoli.</assert>
	</rule>

	<rule context="//cac:OrderReference" flag="fatal"> 
		<assert test="cbc:ID and cbc:IssueDate and cac:DocumentReference/cbc:ID and cac:DocumentReference/cac:IssuerParty/cac:PartyIdentification/cbc:ID" flag="fatal" id="INT-T76-R008">INT-T76-R008 - Nel riferimento all'ordine a cui si risponde (OrderReference) devono essere forniti sia gli estremi ID e IssueDate che l'identificatore della parte di business che lo ha emesso originariamente (Buyer).</assert>
		<assert test="cbc:ID and cac:DocumentReference/cbc:ID and cbc:ID = cac:DocumentReference/cbc:ID" flag="fatal" id="INT-T76-R011">INT-T76-R011 - Nel riferimento all'ordine a cui si risponde (OrderReference) l'ID deve corrispondere al DocumentReference/ID.</assert>
		<assert test="xs:date(cbc:IssueDate) &gt;= xs:date(/*/cbc:IssueDate)" flag="fatal" id="INT-T76-R013">INT-T76-R013 - Nel riferimento all'ordine a cui si risponde (OrderReference) la data di emissione indicata DEVE essere minore o uguale a quella della risposta d'ordine.</assert>
	</rule>

	<rule context="//cac:OrderReference/cac:DocumentReference/cac:IssuerParty" flag="fatal"> 
		<assert test="cac:PartyIdentification/cbc:ID[@schemeID='IT:IPA'][string-length(translate(.,'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789','')) = 0 and string-length() &gt;= 6 and string-length() &lt;= 7]" flag="fatal" id="INT-T76-R009">INT-T76-R009 - Nel riferimento all'ordine a cui si risponde (OrderReference), l'identificatore della parte di business DEVE contenere Il codice UFE IPA dell'ufficio della PA che ha emesso l'ordine originariamente, composto da 6 a 7 caratteri ASCII alfanumerici maiuscoli.</assert>
	</rule>
	
	<rule context="//cac:Delivery" flag="fatal"> 
		<assert test="cac:PromisedDeliveryPeriod and xs:date(cac:PromisedDeliveryPeriod/cbc:StartDate) &lt;= xs:date(cac:PromisedDeliveryPeriod/cbc:EndDate)" flag="fatal" id="INT-T76-R012">INT-T76-R012 - Nelle informazioni di Delivery in testata o dettaglio il PromisedDeliveryPeriod DEVE essere valorizzato e la data di inizio deve essere inferiore o uguale quella di fine periodo.</assert>
	</rule>
	
	<rule context="//cbc:*" flag="fatal"> 
		<assert test="normalize-space()" flag="fatal" id="INT-T76-R001">[INT-T76-R001] - Un elemento informativo base, se istanziato, non può essere vuoto.</assert>
	</rule>
	
</pattern>

