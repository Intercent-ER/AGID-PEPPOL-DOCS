<?xml version="1.0" encoding="UTF-8"?>  
<pattern id="INT-UBL-T16" xmlns="http://purl.oclc.org/dsdl/schematron">
	
	<rule context="//cbc:EndpointID" flag="fatal">
		<assert test="(@schemeID='IT:IPA' and matches(.,'^[a-zA-Z0-9]{6,7}$')) or @schemeID!='IT:IPA'" flag="fatal" id="INT-T16-R026">[INT-T16-R026] - Se l'identificatore di endpoint si basa sullo schema di identificatori IT:IPA, questo dovrà seguire la sintassi [A-Z0-9]{6,7}.</assert>
		<assert test="(@schemeID='IT:VAT' and matches(.,'^(IT)?[0-9]{11}$')) or @schemeID!='IT:VAT'" flag="fatal" id="INT-T16-R027">[INT-T16-R027] - Se l'identificatore di endpoint si basa sullo schema di identificatori IT:VAT, questo dovrà seguire la sintassi (IT)?[0-9]{11}.</assert>
		<assert test="(@schemeID='IT:CF' and matches(.,'^[0-9]{11}$|^[A-Z]{6}\d{2}[ABCDEHLMPRST]{1}\d{2}[A-Z]{1}\d{3}[A-Z]{1}$')) or @schemeID!='IT:CF'" flag="fatal" id="INT-T16-R028">[INT-T16-R028] - Se l'identificatore di endpoint si basa sullo schema di identificatori IT:CF, questo dovrà seguire la sintassi [0-9]{11} per le persone giuridiche e la sintassi [A-Z]{6}\d{2}[ABCDEHLMPRST]{1}\d{2}[A-Z]{1}\d{3}[A-Z]{1} per quelle fisiche.</assert>
	</rule>
	
	<rule context="//cac:DespatchLine" flag="fatal"> 
		<assert test="cac:Item/cbc:Name and (cac:Item/cac:SellersItemIdentification/cbc:ID or cac:Item/cac:StandardItemIdentification/cbc:ID) and cbc:DeliveredQuantity" flag="fatal" id="INT-T16-R003">[INT-T16-R003] - Le righe del DDT DEVONO contenere le informazioni minime previste dall’Art. 21, comma 4 del DPR n. 633/1972 (Nome articolo merce, identificativo articolo e quantità consegnata).</assert>
	</rule>  
	
	<rule context="/ubl:DespatchAdvice" flag="fatal"> 
		<assert test="cbc:UBLVersionID = '2.1' and cbc:CustomizationID = 'urn:www.cenbii.eu:transaction:biitrns016:ver1.0:extended:urn:www.peppol.eu:bis:peppol30a:ver1.0:extended:urn:www.ubl-italia.org:spec:ddt:ver2.1' and cbc:ProfileID = 'urn:www.cenbii.eu:profile:bii30:ver2.0'" flag="fatal" id="INT-T16-R004">[INT-T16-R004] - La versione del DespatchAdvice (DDT) DEVE corrispondere alle seguenti 3 dimensioni: 

UBLVersionID = '2.1', 

CustomizationID = 'urn:www.cenbii.eu:transaction:biitrns016:ver1.0:extended:urn:www.peppol.eu:bis:peppol30a:ver1.0:extended:urn:www.ubl-italia.org:spec:ddt:ver2.1', 

ProfileID = 'urn:www.cenbii.eu:profile:bii30:ver2.0'.</assert>
		<assert test="cac:DespatchSupplierParty/cac:Party/cac:PartyIdentification/cbc:ID and cac:DespatchSupplierParty/cac:Party/cac:PartyName/cbc:Name and cac:DespatchSupplierParty/cac:Party/cac:PostalAddress/cbc:StreetName and cac:DespatchSupplierParty/cac:Party/cac:PostalAddress/cbc:CityName and cac:DespatchSupplierParty/cac:Party/cac:PostalAddress/cbc:PostalZone and cac:DespatchSupplierParty/cac:Party/cac:PostalAddress/cbc:CountrySubentity and cac:DeliveryCustomerParty/cac:Party/cac:PartyName/cbc:Name and cac:DeliveryCustomerParty/cac:Party/cac:PostalAddress/cbc:StreetName and cac:DeliveryCustomerParty/cac:Party/cac:PostalAddress/cbc:CityName and cac:DeliveryCustomerParty/cac:Party/cac:PostalAddress/cbc:PostalZone and cac:DeliveryCustomerParty/cac:Party/cac:PostalAddress/cbc:CountrySubentity and (not(cac:BuyerCustomerParty) or (cac:BuyerCustomerParty/cac:Party/cac:PartyName/cbc:Name and cac:BuyerCustomerParty/cac:Party/cac:PostalAddress/cbc:StreetName and cac:BuyerCustomerParty/cac:Party/cac:PostalAddress/cbc:CityName and cac:BuyerCustomerParty/cac:Party/cac:PostalAddress/cbc:PostalZone and cac:BuyerCustomerParty/cac:Party/cac:PostalAddress/cbc:CountrySubentity)) and (not(cac:SellerSupplierParty) or (cac:SellerSupplierParty/cac:Party/cac:PartyName/cbc:Name and cac:SellerSupplierParty/cac:Party/cac:PostalAddress/cbc:StreetName and cac:SellerSupplierParty/cac:Party/cac:PostalAddress/cbc:CityName and cac:SellerSupplierParty/cac:Party/cac:PostalAddress/cbc:PostalZone and cac:SellerSupplierParty/cac:Party/cac:PostalAddress/cbc:CountrySubentity)) and cac:Shipment/cbc:GrossWeightMeasure and cac:Shipment/cbc:TotalTransportHandlingUnitQuantity and cac:Shipment/cac:Consignment/cac:CarrierParty/cac:PartyName/cbc:Name and cac:Shipment/cac:Consignment/cac:CarrierParty/cac:PostalAddress/cbc:StreetName and cac:Shipment/cac:Consignment/cac:CarrierParty/cac:PostalAddress/cbc:CityName and cac:Shipment/cac:Consignment/cac:CarrierParty/cac:PostalAddress/cbc:PostalZone and cac:Shipment/cac:Consignment/cac:CarrierParty/cac:PostalAddress/cbc:CountrySubentity" flag="fatal" id="INT-T16-R002">[INT-T16-R002] - La testata del DDT DEVE contenere le informazioni minime previste dall’Art. 21, comma 4 del DPR n. 633/1972 (Identificativo, nome e indirizzo dello Speditore / Cedente, nome e indirizzo del Consegnatario / Cessionario, peso lordo e numero colli della spedizione, generalità del Trasportatore e indirizzo).</assert>
		<assert test="cac:Shipment/cbc:TotalTransportHandlingUnitQuantity and (string(cac:Shipment/cbc:TotalTransportHandlingUnitQuantity) castable as xs:integer or cac:Shipment/cbc:TotalTransportHandlingUnitQuantity - floor(cac:Shipment/cbc:TotalTransportHandlingUnitQuantity) = 0)" flag="fatal" id="INT-T16-R005">[INT-T16-R005] - Il numero dei colli deve essere un intero.</assert>
	</rule>
	
	<rule context="//cac:Person" flag="fatal"> 
		<assert test="(cbc:FirstName and cbc:FamilyName) or cac:IdentityDocumentReference" id="INT-T16-R006">[INT-T16-R006] - Se viene usato l'elemento informativo cac:Person per indicare una persona fisica (es. se non è già fornito nella denominazione della ditta) è necessario specificarne sia il nome che il cognome.</assert>
	</rule>    
	
	<rule context="//cbc:*" flag="fatal"> 
		<assert test="normalize-space()" flag="fatal" id="INT-T16-R001">[INT-T16-R001] - Un elemento informativo base, se istanziato, non può essere vuoto.</assert>
	</rule>
	
</pattern>

