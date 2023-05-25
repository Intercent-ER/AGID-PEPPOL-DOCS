<?xml version="1.0" encoding="UTF-8"?>
<!--
This schematron uses business terms defined the CEN/EN16931-1 and is reproduced with permission from CEN. CEN bears no liability from the use of the content and implementation of this schematron and gives no warranties expressed or implied for any purpose.

Last update: 2022 November release 3.0.14.
 -->
<schema xmlns="http://purl.oclc.org/dsdl/schematron" xmlns:u="utils" schemaVersion="iso" queryBinding="xslt2">
	<title>Rules for Peppol BIS 3.0 Billing</title>
	<ns uri="urn:oasis:names:specification:ubl:schema:xsd:CommonBasicComponents-2" prefix="cbc"/>
	<ns uri="urn:oasis:names:specification:ubl:schema:xsd:CommonAggregateComponents-2" prefix="cac"/>
	<ns uri="urn:oasis:names:specification:ubl:schema:xsd:CreditNote-2" prefix="ubl-creditnote"/>
	<ns uri="urn:oasis:names:specification:ubl:schema:xsd:Invoice-2" prefix="ubl-invoice"/>
	<ns uri="http://www.w3.org/2001/XMLSchema" prefix="xs"/>
	<ns uri="utils" prefix="u"/>
	<include href="../CEN/1-CEN-EN16931-UBL.inc"/>
	<include href="./2-PEPPOL-EN16931-UBL.inc"/>
</schema>
