<?xml version="1.0" encoding="UTF-8"?>    
<pattern xmlns="http://purl.oclc.org/dsdl/schematron">


	<rule context="ubl:DespatchAdvice">
		<assert id="PEPPOL-T16-R002"
				test="(cac:OrderReference/cbc:ID)"
				flag="warning">A despatch advice SHOULD have an order identifier</assert>
	</rule>
	
	<rule context="cac:BuyerCustomerParty">
		<assert id="PEPPOL-T16-R008"
			test="(cac:Party/cac:PartyName/cbc:Name) or (cac:Party/cac:PartyIdentification/cbc:ID)"
			flag="fatal">A despatch advice buyer party SHALL contain the name or an identifier</assert>
	</rule>
	
	<rule context="cac:SellerSupplierParty">
		<assert id="PEPPOL-T16-R009"
			test="(cac:Party/cac:PartyName/cbc:Name) or (cac:Party/cac:PartyIdentification/cbc:ID)"
			flag="fatal">A despatch advice buyer party SHALL contain the name or an identifier</assert>
	</rule>
	<rule context="cac:OriginatorCustomerParty">
		<assert id="PEPPOL-T16-R010"
			test="(cac:Party/cac:PartyName/cbc:Name) or (cac:Party/cac:PartyIdentification/cbc:ID)"
			flag="fatal">A despatch advice buyer party SHALL contain the name or an identifier</assert>
	</rule>
	
	<rule context="cac:DespatchLine">
		<assert id="PEPPOL-T16-R003"
				test="(cac:Item/cac:StandardItemIdentification/cbc:ID) or  (cac:Item/cac:SellersItemIdentification/cbc:ID)"
				flag="fatal" >Each item in a Despatch Advice line SHALL be identifiable by either “item sellers identifier” or “item standard identifier”</assert>
		<assert id="PEPPOL-T16-R004"
				test="(cac:Item/cbc:Name)"
				flag="fatal" >Each Despatch Advice SHALL contain the item name</assert>
		<assert id="PEPPOL-T16-R005"
				test="(cbc:DeliveredQuantity)"
				flag="warning" >Each despatch advice line SHOULD have a delivered quantity</assert>
		<assert id="PEPPOL-T16-R006"
				test="number(cbc:DeliveredQuantity) &gt;= 0"
				flag="fatal">Each despatch advice line delivered quantity SHALL not be negative</assert>
		<assert id="PEPPOL-T16-R007"
				test="((cbc:OutstandingQuantity) and (cbc:OutstandingReason)) or not(cbc:OutstandingQuantity)"
				flag="warning">An outstanding quantity reason SHOULD be provided if the despatch line contains an outstanding quantity</assert>
	</rule>


</pattern>
