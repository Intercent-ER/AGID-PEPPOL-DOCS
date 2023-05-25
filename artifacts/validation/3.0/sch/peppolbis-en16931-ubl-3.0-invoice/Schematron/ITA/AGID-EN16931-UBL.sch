<?xml version="1.0" encoding="UTF-8"?>
<!--

    Licensed under European Union Public Licence (EUPL) version 1.2.
	This schematron uses business terms defined the CEN/EN16931-1 and is reproduced with permission from CEN. CEN bears no liability from the use of the content and implementation of this schematron and gives no warranties expressed or implied for any purpose.
	
	Peppol BIS Billing 3.0.14
-->
<schema xmlns="http://purl.oclc.org/dsdl/schematron" xmlns:u="utils" schemaVersion="iso" queryBinding="xslt2">
	<title>EN16931 model bound to UBL</title>
	<ns prefix="ext" uri="urn:oasis:names:specification:ubl:schema:xsd:CommonExtensionComponents-2"/>
	<ns prefix="cbc" uri="urn:oasis:names:specification:ubl:schema:xsd:CommonBasicComponents-2"/>
	<ns prefix="cac" uri="urn:oasis:names:specification:ubl:schema:xsd:CommonAggregateComponents-2"/>
	<ns prefix="qdt" uri="urn:oasis:names:specification:ubl:schema:xsd:QualifiedDataTypes-2"/>
	<ns prefix="udt" uri="urn:oasis:names:specification:ubl:schema:xsd:UnqualifiedDataTypes-2"/>
	<ns prefix="cn" uri="urn:oasis:names:specification:ubl:schema:xsd:CreditNote-2"/>
	<ns prefix="ubl" uri="urn:oasis:names:specification:ubl:schema:xsd:Invoice-2"/>
	<ns prefix="xs" uri="http://www.w3.org/2001/XMLSchema"/>
	<ns prefix="ubl-creditnote" uri="urn:oasis:names:specification:ubl:schema:xsd:CreditNote-2"/>
	<ns prefix="ubl-invoice" uri="urn:oasis:names:specification:ubl:schema:xsd:Invoice-2"/>
	<ns uri="utils" prefix="u"/>
	<phase id="EN16931model_phase">
		<active pattern="UBL-model"/>
	</phase>
	<phase id="codelist_phase">
		<active pattern="Codesmodel"/>
	</phase>
	<!--OpenPEPPOL phases-->
	<phase id="OP_empty_check_phase">
		<active pattern="OP-empty-elements"/>
	</phase>
	<phase id="OP_transaction_phase">
		<active pattern="OP-transaction-rules"/>
	</phase>
	<phase id="OP_Norway_phase">
		<active pattern="OP-Norway-rules"/>
	</phase>
	<phase id="OP_Denmark_phase">
		<active pattern="OP-Denmark-rules"/>
	</phase>
	<phase id="OP_Italy_phase">
		<active pattern="OP-Italy-rules"/>
	</phase>
	<phase id="OP_Sweden_phase">
		<active pattern="OP-Sweden-rules"/>
	</phase>
	<phase id="OP_Greece_phase">
		<active pattern="OP-Greece-sender-rules"/>
		<active pattern="OP-Greece-sender-receiver-rules"/>
	</phase>
	<phase id="OP_Iceland_phase">
		<active pattern="OP-Iceland-rules"/>
	</phase>
	<phase id="OP_Netherlands_phase">
		<active pattern="OP-Netherlands-rules"/>
	</phase>
	<phase id="OP_codelist_phase">
		<active pattern="OP-cl-formatting-rules"/>
	</phase>
	<!--AGID phases-->
	<phase id="Italy_phase">
		<active pattern="Italy-CIUS-rules"/>
		<active pattern="Italy-EXTENSION-rules"/>
	</phase>

	<!-- CEN -->

	<include href="CEN/1-CEN-EN16931-UBL.inc"/>

	<!-- OpenPEPPOL  -->

	<include href="OPENPEPPOL/2-PEPPOL-EN16931-UBL.inc"/>

	<!-- Italian rules -->
	<include href="AGID/3-AGID-EN16931-CIUS-UBL.inc"/>
	<include href="AGID/4-AGID-EN16931-EXT-UBL.inc"/>

</schema>