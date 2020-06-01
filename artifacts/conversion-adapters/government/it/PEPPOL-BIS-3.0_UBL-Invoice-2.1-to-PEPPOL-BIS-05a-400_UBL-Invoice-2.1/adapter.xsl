<?xml version="1.0" encoding="UTF-8"?>
<!--Stylesheet synthesized using Javest A2A Mapper environment.-->

<xsl:stylesheet xmlns="urn:oasis:names:specification:ubl:schema:xsd:Invoice-2"
                xmlns:in="urn:oasis:names:specification:ubl:schema:xsd:Invoice-2"
                xmlns:xsmap="http://www.javest.com/ns/mapper/snippet"
                xmlns:asmap="http://www.javest.com/ns/mapper/snippet/attribute"
                xmlns:cac="urn:oasis:names:specification:ubl:schema:xsd:CommonAggregateComponents-2"
                xmlns:cbc="urn:oasis:names:specification:ubl:schema:xsd:CommonBasicComponents-2"
                xmlns:xsd="http://www.w3.org/2001/XMLSchema"
                xmlns:ccts="urn:un:unece:uncefact:documentation:2"
                xmlns:ext="urn:oasis:names:specification:ubl:schema:xsd:CommonExtensionComponents-2"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                exclude-result-prefixes="xsmap asmap in ccts ext"
                version="2.0">
   <xsl:output indent="no"/>
   <xsl:param name="xclEAID" as="xsd:string">xcl/CEF-EAS.xml</xsl:param>
   <xsl:param name="xclVATEX" as="xsd:string">xcl/CEF-VATEX.xml</xsl:param>
   <!--
Processing starts at node: /in:Invoice
See the template rule at end of stylesheet for the default processing of 
the root node.
-->
<xsl:template match="cac:AccountingCustomerParty">
      <xsl:param name="CN" select="."/>
      <xsl:param name="CNP" select="1"/>
      <cac:AccountingCustomerParty>
         <xsl:apply-templates select="cac:Party" mode="AccountingCustomerParty">
            <xsl:with-param name="CN" select="current()"/>
            <xsl:with-param name="CNP" select="position()"/>
         </xsl:apply-templates>
      </cac:AccountingCustomerParty>
   </xsl:template>
   <xsl:template match="cac:AccountingSupplierParty">
      <xsl:param name="CN" select="."/>
      <xsl:param name="CNP" select="1"/>
      <cac:AccountingSupplierParty>
         <xsl:apply-templates select="cac:Party" mode="AccountingSupplierParty">
            <xsl:with-param name="CN" select="current()"/>
            <xsl:with-param name="CNP" select="position()"/>
         </xsl:apply-templates>
      </cac:AccountingSupplierParty>
   </xsl:template>
   <xsl:template match="cac:AdditionalDocumentReference" mode="AdditionalDocumentReferences">
      <xsl:param name="CN" select="."/>
      <xsl:param name="CNP" select="1"/>
      <xsl:if test="cbc:ID">
         <cac:AdditionalDocumentReference>
            <cbc:ID>
               <xsl:variable name="variable_d7e47a1049986">
                  <xsl:value-of select="cbc:ID/@schemeID"/>
               </xsl:variable>
               <xsl:if test="string($variable_d7e47a1049986)">
                  <xsl:attribute name="schemeID">
                     <xsl:value-of select="string($variable_d7e47a1049986)"/>
                  </xsl:attribute>
               </xsl:if>
               <xsl:value-of select="cbc:ID"/>
            </cbc:ID>
            <cbc:DocumentType>
               <xsl:value-of select="cbc:DocumentDescription"/>
            </cbc:DocumentType>
            <cbc:DocumentDescription>
               <xsl:value-of select="cbc:DocumentDescription"/>
            </cbc:DocumentDescription>
            <xsl:apply-templates select="cac:Attachment">
               <xsl:with-param name="CN" select="current()"/>
               <xsl:with-param name="CNP" select="position()"/>
            </xsl:apply-templates>
         </cac:AdditionalDocumentReference>
      </xsl:if>
   </xsl:template>
   <xsl:template match="cac:AdditionalItemProperty">
      <xsl:param name="CN" select="."/>
      <xsl:param name="CNP" select="1"/>
      <xsl:if test="cbc:Name">
         <cac:AdditionalItemProperty>
            <cbc:Name>
               <xsl:value-of select="cbc:Name"/>
            </cbc:Name>
            <cbc:Value>
               <xsl:value-of select="cbc:Value"/>
            </cbc:Value>
         </cac:AdditionalItemProperty>
      </xsl:if>
   </xsl:template>
   <xsl:template match="cac:Address">
      <xsl:param name="CN" select="."/>
      <xsl:param name="CNP" select="1"/>
      <xsl:if test="cbc:CityName">
         <cac:Address>
            <xsl:if test="cbc:StreetName">
               <cbc:StreetName>
                  <xsl:value-of select="cbc:StreetName"/>
               </cbc:StreetName>
            </xsl:if>
            <xsl:if test="cbc:AdditionalStreetName">
               <cbc:AdditionalStreetName>
                  <xsl:value-of select="cbc:AdditionalStreetName"/>
               </cbc:AdditionalStreetName>
            </xsl:if>
            <xsl:if test="cbc:CityName">
               <cbc:CityName>
                  <xsl:value-of select="cbc:CityName"/>
               </cbc:CityName>
            </xsl:if>
            <xsl:if test="cbc:PostalZone">
               <cbc:PostalZone>
                  <xsl:value-of select="cbc:PostalZone"/>
               </cbc:PostalZone>
            </xsl:if>
            <xsl:if test="cbc:CountrySubentity">
               <cbc:CountrySubentity>
                  <xsl:value-of select="cbc:CountrySubentity"/>
               </cbc:CountrySubentity>
            </xsl:if>
            <xsl:apply-templates select="cac:AddressLine" mode="DeliveryLocationAddressLine">
               <xsl:with-param name="CN" select="current()"/>
               <xsl:with-param name="CNP" select="position()"/>
            </xsl:apply-templates>
            <xsl:apply-templates select="cac:Country" mode="DeliveryLocationCountry">
               <xsl:with-param name="CN" select="current()"/>
               <xsl:with-param name="CNP" select="position()"/>
            </xsl:apply-templates>
         </cac:Address>
      </xsl:if>
   </xsl:template>
   <xsl:template match="cac:AddressLine" mode="AccountingSupplierPartyAddressLine">
      <xsl:param name="CN" select="."/>
      <xsl:param name="CNP" select="1"/>
      <xsl:if test="cbc:Line">
         <cac:AddressLine>
            <cbc:Line>
               <xsl:value-of select="cbc:Line"/>
            </cbc:Line>
         </cac:AddressLine>
      </xsl:if>
   </xsl:template>
   <xsl:template match="cac:AddressLine" mode="AccountingCustomerPartyAddressLine">
      <xsl:param name="CN" select="."/>
      <xsl:param name="CNP" select="1"/>
      <xsl:if test="cbc:Line">
         <cac:AddressLine>
            <cbc:Line>
               <xsl:value-of select="cbc:Line"/>
            </cbc:Line>
         </cac:AddressLine>
      </xsl:if>
   </xsl:template>
   <xsl:template match="cac:AddressLine">
      <xsl:param name="CN" select="."/>
      <xsl:param name="CNP" select="1"/>
      <xsl:if test="cbc:Line">
         <cac:AddressLine>
            <cbc:Line>
               <xsl:value-of select="cbc:Line"/>
            </cbc:Line>
         </cac:AddressLine>
      </xsl:if>
   </xsl:template>
   <xsl:template match="cac:AddressLine" mode="DeliveryLocationAddressLine">
      <xsl:param name="CN" select="."/>
      <xsl:param name="CNP" select="1"/>
      <xsl:if test="cbc:Line">
         <cac:AddressLine>
            <cbc:Line>
               <xsl:value-of select="cbc:Line"/>
            </cbc:Line>
         </cac:AddressLine>
      </xsl:if>
   </xsl:template>
   <xsl:template match="cac:AllowanceCharge">
      <xsl:param name="CN" select="."/>
      <xsl:param name="CNP" select="1"/>
      <xsl:if test="cbc:ChargeIndicator">
         <cac:AllowanceCharge>
            <cbc:ChargeIndicator>
               <xsl:value-of select="cbc:ChargeIndicator"/>
            </cbc:ChargeIndicator>
            <xsl:if test="cbc:AllowanceChargeReasonCode">
               <cbc:AllowanceChargeReasonCode>
                  <xsl:value-of select="cbc:AllowanceChargeReasonCode"/>
               </cbc:AllowanceChargeReasonCode>
            </xsl:if>
            <xsl:if test="cbc:AllowanceChargeReason">
               <cbc:AllowanceChargeReason>
                  <xsl:value-of select="cbc:AllowanceChargeReason"/>
               </cbc:AllowanceChargeReason>
            </xsl:if>
            <xsl:if test="cbc:MultiplierFactorNumeric">
               <cbc:MultiplierFactorNumeric>
                  <xsl:value-of select="cbc:MultiplierFactorNumeric"/>
               </cbc:MultiplierFactorNumeric>
            </xsl:if>
            <cbc:Amount>
               <xsl:variable name="variable_d7e191a1050860">
                  <xsl:value-of select="cbc:Amount/@currencyID"/>
               </xsl:variable>
               <xsl:if test="string($variable_d7e191a1050860)">
                  <xsl:attribute name="currencyID">
                     <xsl:value-of select="string($variable_d7e191a1050860)"/>
                  </xsl:attribute>
               </xsl:if>
               <xsl:value-of select="cbc:Amount"/>
            </cbc:Amount>
            <xsl:if test="cbc:BaseAmount">
               <cbc:BaseAmount>
                  <xsl:variable name="variable_d7e192a1050860">
                     <xsl:value-of select="cbc:BaseAmount/@currencyID"/>
                  </xsl:variable>
                  <xsl:if test="string($variable_d7e192a1050860)">
                     <xsl:attribute name="currencyID">
                        <xsl:value-of select="string($variable_d7e192a1050860)"/>
                     </xsl:attribute>
                  </xsl:if>
                  <xsl:value-of select="cbc:BaseAmount"/>
               </cbc:BaseAmount>
            </xsl:if>
            <xsl:apply-templates select="cac:TaxCategory">
               <xsl:with-param name="CN" select="current()"/>
               <xsl:with-param name="CNP" select="position()"/>
            </xsl:apply-templates>
         </cac:AllowanceCharge>
      </xsl:if>
   </xsl:template>
   <xsl:template match="cac:AllowanceCharge">
      <xsl:param name="CN" select="."/>
      <xsl:param name="CNP" select="1"/>
      <xsl:if test="cbc:ChargeIndicator">
         <cac:AllowanceCharge>
            <cbc:ChargeIndicator>
               <xsl:value-of select="cbc:ChargeIndicator"/>
            </cbc:ChargeIndicator>
            <xsl:if test="cbc:AllowanceChargeReasonCode">
               <cbc:AllowanceChargeReasonCode>
                  <xsl:value-of select="cbc:AllowanceChargeReasonCode"/>
               </cbc:AllowanceChargeReasonCode>
            </xsl:if>
            <xsl:if test="cbc:AllowanceChargeReason">
               <cbc:AllowanceChargeReason>
                  <xsl:value-of select="cbc:AllowanceChargeReason"/>
               </cbc:AllowanceChargeReason>
            </xsl:if>
            <xsl:if test="cbc:MultiplierFactorNumeric">
               <cbc:MultiplierFactorNumeric>
                  <xsl:value-of select="cbc:MultiplierFactorNumeric"/>
               </cbc:MultiplierFactorNumeric>
            </xsl:if>
            <cbc:Amount>
               <xsl:variable name="variable_d7e237a1050860">
                  <xsl:value-of select="cbc:Amount/@currencyID"/>
               </xsl:variable>
               <xsl:if test="string($variable_d7e237a1050860)">
                  <xsl:attribute name="currencyID">
                     <xsl:value-of select="string($variable_d7e237a1050860)"/>
                  </xsl:attribute>
               </xsl:if>
               <xsl:value-of select="cbc:Amount"/>
            </cbc:Amount>
            <xsl:if test="cbc:BaseAmount">
               <cbc:BaseAmount>
                  <xsl:variable name="variable_d7e238a1050860">
                     <xsl:value-of select="cbc:BaseAmount/@currencyID"/>
                  </xsl:variable>
                  <xsl:if test="string($variable_d7e238a1050860)">
                     <xsl:attribute name="currencyID">
                        <xsl:value-of select="string($variable_d7e238a1050860)"/>
                     </xsl:attribute>
                  </xsl:if>
                  <xsl:value-of select="cbc:BaseAmount"/>
               </cbc:BaseAmount>
            </xsl:if>
         </cac:AllowanceCharge>
      </xsl:if>
   </xsl:template>
   <xsl:template match="cac:AllowanceCharge">
      <xsl:param name="CN" select="."/>
      <xsl:param name="CNP" select="1"/>
      <xsl:if test="cbc:ChargeIndicator">
         <cac:AllowanceCharge>
            <cbc:ChargeIndicator>
               <xsl:value-of select="cbc:ChargeIndicator"/>
            </cbc:ChargeIndicator>
            <cbc:Amount>
               <xsl:variable name="variable_d7e265a1050860">
                  <xsl:value-of select="cbc:Amount/@currencyID"/>
               </xsl:variable>
               <xsl:if test="string($variable_d7e265a1050860)">
                  <xsl:attribute name="currencyID">
                     <xsl:value-of select="string($variable_d7e265a1050860)"/>
                  </xsl:attribute>
               </xsl:if>
               <xsl:value-of select="cbc:Amount"/>
            </cbc:Amount>
            <xsl:if test="cbc:BaseAmount">
               <cbc:BaseAmount>
                  <xsl:variable name="variable_d7e266a1050860">
                     <xsl:value-of select="cbc:BaseAmount/@currencyID"/>
                  </xsl:variable>
                  <xsl:if test="string($variable_d7e266a1050860)">
                     <xsl:attribute name="currencyID">
                        <xsl:value-of select="string($variable_d7e266a1050860)"/>
                     </xsl:attribute>
                  </xsl:if>
                  <xsl:value-of select="cbc:BaseAmount"/>
               </cbc:BaseAmount>
            </xsl:if>
         </cac:AllowanceCharge>
      </xsl:if>
   </xsl:template>
   <xsl:template match="cac:Attachment">
      <xsl:param name="CN" select="."/>
      <xsl:param name="CNP" select="1"/>
      <xsl:if test="cbc:EmbeddedDocumentBinaryObject or cac:ExternalReference">
         <cac:Attachment>
            <cbc:EmbeddedDocumentBinaryObject>
               <xsl:variable name="variable_d7e51a1050720">
                  <xsl:value-of select="cbc:EmbeddedDocumentBinaryObject/@filename"/>
               </xsl:variable>
               <xsl:if test="string($variable_d7e51a1050720)">
                  <xsl:attribute name="filename">
                     <xsl:value-of select="string($variable_d7e51a1050720)"/>
                  </xsl:attribute>
               </xsl:if>
               <xsl:variable name="variable_d7e51a1050260">
                  <xsl:value-of select="cbc:EmbeddedDocumentBinaryObject/@mimeCode"/>
               </xsl:variable>
               <xsl:if test="string($variable_d7e51a1050260)">
                  <xsl:attribute name="mimeCode">
                     <xsl:value-of select="string($variable_d7e51a1050260)"/>
                  </xsl:attribute>
               </xsl:if>
               <xsl:value-of select="cbc:EmbeddedDocumentBinaryObject"/>
            </cbc:EmbeddedDocumentBinaryObject>
            <xsl:apply-templates select="cac:ExternalReference">
               <xsl:with-param name="CN" select="current()"/>
               <xsl:with-param name="CNP" select="position()"/>
            </xsl:apply-templates>
         </cac:Attachment>
      </xsl:if>
   </xsl:template>
   <xsl:template match="cac:BillingReference">
      <xsl:param name="CN" select="."/>
      <xsl:param name="CNP" select="1"/>
      <xsl:if test="cac:InvoiceDocumentReference">
         <cac:BillingReference>
            <xsl:apply-templates select="cac:InvoiceDocumentReference">
               <xsl:with-param name="CN" select="current()"/>
               <xsl:with-param name="CNP" select="position()"/>
            </xsl:apply-templates>
         </cac:BillingReference>
      </xsl:if>
   </xsl:template>
   <xsl:template match="cac:BuyersItemIdentification">
      <xsl:param name="CN" select="."/>
      <xsl:param name="CNP" select="1"/>
      <xsl:if test="cbc:ID">
         <cac:BuyersItemIdentification>
            <cbc:ID>
               <xsl:value-of select="cbc:ID"/>
            </cbc:ID>
         </cac:BuyersItemIdentification>
      </xsl:if>
   </xsl:template>
   <xsl:template match="cac:CardAccount">
      <xsl:param name="CN" select="."/>
      <xsl:param name="CNP" select="1"/>
      <xsl:if test="cbc:PrimaryAccountNumberID">
         <cac:CardAccount>
            <cbc:PrimaryAccountNumberID>
               <xsl:value-of select="cbc:PrimaryAccountNumberID"/>
            </cbc:PrimaryAccountNumberID>
            <cbc:NetworkID>
               <xsl:value-of select="cbc:NetworkID"/>
            </cbc:NetworkID>
            <xsl:if test="cbc:HolderName">
               <cbc:HolderName>
                  <xsl:value-of select="cbc:HolderName"/>
               </cbc:HolderName>
            </xsl:if>
         </cac:CardAccount>
      </xsl:if>
   </xsl:template>
   <xsl:template match="cac:ClassifiedTaxCategory">
      <xsl:param name="CN" select="."/>
      <xsl:param name="CNP" select="1"/>
      <xsl:if test="cbc:ID">
         <cac:ClassifiedTaxCategory>
            <cbc:ID>
               <xsl:value-of select="cbc:ID"/>
            </cbc:ID>
            <cbc:Percent>
               <xsl:value-of select="cbc:Percent"/>
            </cbc:Percent>
            <cac:TaxScheme>
               <cbc:ID>
                  <xsl:value-of select="cac:TaxScheme/cbc:ID"/>
               </cbc:ID>
            </cac:TaxScheme>
         </cac:ClassifiedTaxCategory>
      </xsl:if>
   </xsl:template>
   <xsl:template match="cac:CommodityClassification">
      <xsl:param name="CN" select="."/>
      <xsl:param name="CNP" select="1"/>
      <xsl:if test="cbc:IdentificationCode">
         <cac:CommodityClassification>
            <cbc:ItemClassificationCode>
               <xsl:variable name="variable_d7e251a1050721">
                  <xsl:value-of select="cbc:ItemClassificationCode/@listID"/>
               </xsl:variable>
               <xsl:if test="string($variable_d7e251a1050721)">
                  <xsl:attribute name="listID">
                     <xsl:value-of select="string($variable_d7e251a1050721)"/>
                  </xsl:attribute>
               </xsl:if>
               <xsl:variable name="variable_d7e251a1050502">
                  <xsl:value-of select="cbc:ItemClassificationCode/@listVersionID"/>
               </xsl:variable>
               <xsl:if test="string($variable_d7e251a1050502)">
                  <xsl:attribute name="listVersionID">
                     <xsl:value-of select="string($variable_d7e251a1050502)"/>
                  </xsl:attribute>
               </xsl:if>
               <xsl:value-of select="cbc:ItemClassificationCode"/>
            </cbc:ItemClassificationCode>
         </cac:CommodityClassification>
      </xsl:if>
   </xsl:template>
   <xsl:template match="cac:Contact" mode="AccountingSupplierPartyContact">
      <xsl:param name="CN" select="."/>
      <xsl:param name="CNP" select="1"/>
      <xsl:if test="cbc:Name">
         <cac:Contact>
            <xsl:if test="cbc:Name">
               <cbc:Name>
                  <xsl:value-of select="cbc:Name"/>
               </cbc:Name>
            </xsl:if>
            <xsl:if test="cbc:Telephone">
               <cbc:Telephone>
                  <xsl:value-of select="cbc:Telephone"/>
               </cbc:Telephone>
            </xsl:if>
            <xsl:if test="cbc:ElectronicMail">
               <cbc:ElectronicMail>
                  <xsl:value-of select="cbc:ElectronicMail"/>
               </cbc:ElectronicMail>
            </xsl:if>
         </cac:Contact>
      </xsl:if>
   </xsl:template>
   <xsl:template match="cac:Contact" mode="AccountingCustomerPartyContact">
      <xsl:param name="CN" select="."/>
      <xsl:param name="CNP" select="1"/>
      <xsl:if test="cbc:Name">
         <cac:Contact>
            <xsl:if test="cbc:Name">
               <cbc:Name>
                  <xsl:value-of select="cbc:Name"/>
               </cbc:Name>
            </xsl:if>
            <xsl:if test="cbc:Telephone">
               <cbc:Telephone>
                  <xsl:value-of select="cbc:Telephone"/>
               </cbc:Telephone>
            </xsl:if>
            <xsl:if test="cbc:ElectronicMail">
               <cbc:ElectronicMail>
                  <xsl:value-of select="cbc:ElectronicMail"/>
               </cbc:ElectronicMail>
            </xsl:if>
         </cac:Contact>
      </xsl:if>
   </xsl:template>
   <xsl:template match="cac:ContractDocumentReference">
      <xsl:param name="CN" select="."/>
      <xsl:param name="CNP" select="1"/>
      <xsl:if test="cbc:ID">
         <cac:ContractDocumentReference>
            <cbc:ID>
               <xsl:value-of select="cbc:ID"/>
            </cbc:ID>
         </cac:ContractDocumentReference>
      </xsl:if>
   </xsl:template>
   <xsl:template match="cac:Country" mode="AccountingSupplierPartyCountry">
      <xsl:param name="CN" select="."/>
      <xsl:param name="CNP" select="1"/>
      <xsl:if test="cbc:IdentificationCode">
         <cac:Country>
            <cbc:IdentificationCode listID="ISO3166-1:Alpha2">
               <xsl:value-of select="cbc:IdentificationCode"/>
            </cbc:IdentificationCode>
         </cac:Country>
      </xsl:if>
   </xsl:template>
   <xsl:template match="cac:Country" mode="AccountingCustomerPartyCountry">
      <xsl:param name="CN" select="."/>
      <xsl:param name="CNP" select="1"/>
      <xsl:if test="cbc:IdentificationCode">
         <cac:Country>
            <cbc:IdentificationCode listID="ISO3166-1:Alpha2">
               <xsl:value-of select="cbc:IdentificationCode"/>
            </cbc:IdentificationCode>
         </cac:Country>
      </xsl:if>
   </xsl:template>
   <xsl:template match="cac:Country">
      <xsl:param name="CN" select="."/>
      <xsl:param name="CNP" select="1"/>
      <xsl:if test="cbc:IdentificationCode">
         <cac:Country>
            <cbc:IdentificationCode>
               <xsl:value-of select="cbc:IdentificationCode"/>
            </cbc:IdentificationCode>
         </cac:Country>
      </xsl:if>
   </xsl:template>
   <xsl:template match="cac:Country" mode="DeliveryLocationCountry">
      <xsl:param name="CN" select="."/>
      <xsl:param name="CNP" select="1"/>
      <xsl:if test="cbc:IdentificationCode">
         <cac:Country>
            <cbc:IdentificationCode listID="ISO3166-1:Alpha2">
               <xsl:value-of select="cbc:IdentificationCode"/>
            </cbc:IdentificationCode>
         </cac:Country>
      </xsl:if>
   </xsl:template>
   <xsl:template match="cac:Delivery">
      <xsl:param name="CN" select="."/>
      <xsl:param name="CNP" select="1"/>
      <xsl:if test="cbc:ActualDeliveryDate or cac:DeliveryLocation">
         <cac:Delivery>
            <xsl:if test="cbc:ActualDeliveryDate">
               <cbc:ActualDeliveryDate>
                  <xsl:value-of select="cbc:ActualDeliveryDate"/>
               </cbc:ActualDeliveryDate>
            </xsl:if>
            <xsl:apply-templates select="cac:DeliveryLocation">
               <xsl:with-param name="CN" select="current()"/>
               <xsl:with-param name="CNP" select="position()"/>
            </xsl:apply-templates>
            <cac:Despatch>
               <xsl:apply-templates select="cac:DeliveryParty">
                  <xsl:with-param name="CN" select="current()"/>
                  <xsl:with-param name="CNP" select="position()"/>
               </xsl:apply-templates>
            </cac:Despatch>
         </cac:Delivery>
      </xsl:if>
   </xsl:template>
   <xsl:template match="cac:DeliveryLocation">
      <xsl:param name="CN" select="."/>
      <xsl:param name="CNP" select="1"/>
      <xsl:if test="cbc:ID or cac:Address">
         <cac:DeliveryLocation>
            <xsl:if test="cbc:ID">
               <cbc:ID>
                  <xsl:variable name="variable_d7e149a1049986">
                     <xsl:value-of select="cbc:ID/@schemeID"/>
                  </xsl:variable>
                  <xsl:if test="string($variable_d7e149a1049986)">
                     <xsl:attribute name="schemeID">
                        <xsl:value-of select="string($variable_d7e149a1049986)"/>
                     </xsl:attribute>
                  </xsl:if>
                  <xsl:value-of select="cbc:ID"/>
               </cbc:ID>
            </xsl:if>
            <xsl:apply-templates select="cac:Address">
               <xsl:with-param name="CN" select="current()"/>
               <xsl:with-param name="CNP" select="position()"/>
            </xsl:apply-templates>
         </cac:DeliveryLocation>
      </xsl:if>
   </xsl:template>
   <xsl:template match="cac:DeliveryParty">
      <xsl:param name="CN" select="."/>
      <xsl:param name="CNP" select="1"/>
      <xsl:if test="cac:PartyName">
         <cac:DespatchParty>
            <xsl:apply-templates select="cac:PartyName" mode="DeliveryPartyName">
               <xsl:with-param name="CN" select="current()"/>
               <xsl:with-param name="CNP" select="position()"/>
            </xsl:apply-templates>
         </cac:DespatchParty>
      </xsl:if>
   </xsl:template>
   <xsl:template match="cac:DespatchDocumentReference">
      <xsl:param name="CN" select="."/>
      <xsl:param name="CNP" select="1"/>
      <xsl:if test="cbc:ID">
         <cac:DespatchDocumentReference>
            <cbc:ID>
               <xsl:value-of select="cbc:ID"/>
            </cbc:ID>
            <cbc:IssueDate>
               <xsl:text>2000-01-01</xsl:text>
            </cbc:IssueDate>
            <cbc:DocumentType>
               <xsl:text>DDT</xsl:text>
            </cbc:DocumentType>
         </cac:DespatchDocumentReference>
      </xsl:if>
   </xsl:template>
   <xsl:template match="cac:DocumentReference">
      <xsl:param name="CN" select="."/>
      <xsl:param name="CNP" select="1"/>
      <xsl:if test="cbc:ID">
         <cac:DocumentReference>
            <cbc:ID>
               <xsl:variable name="variable_d7e231a1049986">
                  <xsl:value-of select="cbc:ID/@schemeID"/>
               </xsl:variable>
               <xsl:if test="string($variable_d7e231a1049986)">
                  <xsl:attribute name="schemeID">
                     <xsl:value-of select="string($variable_d7e231a1049986)"/>
                  </xsl:attribute>
               </xsl:if>
               <xsl:value-of select="cbc:ID"/>
            </cbc:ID>
         </cac:DocumentReference>
      </xsl:if>
   </xsl:template>
   <xsl:template match="cac:ExternalReference">
      <xsl:param name="CN" select="."/>
      <xsl:param name="CNP" select="1"/>
      <xsl:if test="cbc:URI">
         <cac:ExternalReference>
            <cbc:URI>
               <xsl:value-of select="cbc:URI"/>
            </cbc:URI>
         </cac:ExternalReference>
      </xsl:if>
   </xsl:template>
   <xsl:template match="cac:FinancialInstitutionBranch" mode="BICPresent">
      <xsl:param name="CN" select="."/>
      <xsl:param name="CNP" select="1"/>
      <xsl:if test="cbc:ID">
         <cac:FinancialInstitution>
            <cbc:ID schemeID="BIC">
               <xsl:value-of select="cbc:ID"/>
            </cbc:ID>
         </cac:FinancialInstitution>
      </xsl:if>
   </xsl:template>
   <xsl:template match="cac:InvoiceDocumentReference">
      <xsl:param name="CN" select="."/>
      <xsl:param name="CNP" select="1"/>
      <xsl:if test="cbc:ID">
         <cac:InvoiceDocumentReference>
            <cbc:ID>
               <xsl:value-of select="cbc:ID"/>
            </cbc:ID>
            <cbc:IssueDate>
               <xsl:value-of select="cbc:IssueDate"/>
            </cbc:IssueDate>
         </cac:InvoiceDocumentReference>
      </xsl:if>
   </xsl:template>
   <xsl:template match="cac:InvoiceLine">
      <xsl:param name="CN" select="."/>
      <xsl:param name="CNP" select="1"/>
      <cac:InvoiceLine>
         <cbc:ID>
            <xsl:value-of select="cbc:ID"/>
         </cbc:ID>
         <xsl:if test="cbc:Note">
            <cbc:Note>
               <xsl:value-of select="cbc:Note"/>
            </cbc:Note>
         </xsl:if>
         <xsl:if test="cbc:InvoicedQuantity">
            <cbc:InvoicedQuantity unitCodeListID="UNECERec20">
               <xsl:variable name="variable_d7e222a1050145">
                  <xsl:value-of select="cbc:InvoicedQuantity/@unitCode"/>
               </xsl:variable>
               <xsl:if test="string($variable_d7e222a1050145)">
                  <xsl:attribute name="unitCode">
                     <xsl:value-of select="string($variable_d7e222a1050145)"/>
                  </xsl:attribute>
               </xsl:if>
               <xsl:value-of select="cbc:InvoicedQuantity"/>
            </cbc:InvoicedQuantity>
         </xsl:if>
         <cbc:LineExtensionAmount>
            <xsl:variable name="variable_d7e223a1050860">
               <xsl:value-of select="cbc:LineExtensionAmount/@currencyID"/>
            </xsl:variable>
            <xsl:if test="string($variable_d7e223a1050860)">
               <xsl:attribute name="currencyID">
                  <xsl:value-of select="string($variable_d7e223a1050860)"/>
               </xsl:attribute>
            </xsl:if>
            <xsl:value-of select="cbc:LineExtensionAmount"/>
         </cbc:LineExtensionAmount>
         <xsl:if test="cbc:AccountingCost">
            <cbc:AccountingCost>
               <xsl:value-of select="cbc:AccountingCost"/>
            </cbc:AccountingCost>
         </xsl:if>
         <xsl:apply-templates select="cac:InvoicePeriod" mode="LineInvoicePeriod">
            <xsl:with-param name="CN" select="current()"/>
            <xsl:with-param name="CNP" select="position()"/>
         </xsl:apply-templates>
         <xsl:apply-templates select="cac:OrderLineReference">
            <xsl:with-param name="CN" select="current()"/>
            <xsl:with-param name="CNP" select="position()"/>
         </xsl:apply-templates>
         <xsl:apply-templates select="cac:DocumentReference">
            <xsl:with-param name="CN" select="current()"/>
            <xsl:with-param name="CNP" select="position()"/>
         </xsl:apply-templates>
         <xsl:apply-templates select="cac:AllowanceCharge">
            <xsl:with-param name="CN" select="current()"/>
            <xsl:with-param name="CNP" select="position()"/>
         </xsl:apply-templates>
         <xsl:apply-templates select="cac:Item">
            <xsl:with-param name="CN" select="current()"/>
            <xsl:with-param name="CNP" select="position()"/>
         </xsl:apply-templates>
         <xsl:apply-templates select="cac:Price">
            <xsl:with-param name="CN" select="current()"/>
            <xsl:with-param name="CNP" select="position()"/>
         </xsl:apply-templates>
      </cac:InvoiceLine>
   </xsl:template>
   <xsl:template match="cac:InvoicePeriod">
      <xsl:param name="CN" select="."/>
      <xsl:param name="CNP" select="1"/>
      <xsl:if test="cbc:StartDate or cbc:EndDate">
         <cac:InvoicePeriod>
            <xsl:if test="cbc:StartDate">
               <cbc:StartDate>
                  <xsl:value-of select="cbc:StartDate"/>
               </cbc:StartDate>
            </xsl:if>
            <xsl:if test="cbc:EndDate">
               <cbc:EndDate>
                  <xsl:value-of select="cbc:EndDate"/>
               </cbc:EndDate>
            </xsl:if>
            <xsl:if test="cbc:DescriptionCode">
               <cbc:DescriptionCode>
                  <xsl:value-of select="cbc:DescriptionCode"/>
               </cbc:DescriptionCode>
            </xsl:if>
         </cac:InvoicePeriod>
      </xsl:if>
   </xsl:template>
   <xsl:template match="cac:InvoicePeriod" mode="LineInvoicePeriod">
      <xsl:param name="CN" select="."/>
      <xsl:param name="CNP" select="1"/>
      <xsl:if test="cbc:StartDate or cbc:EndDate">
         <cac:InvoicePeriod>
            <xsl:if test="cbc:StartDate">
               <cbc:StartDate>
                  <xsl:value-of select="cbc:StartDate"/>
               </cbc:StartDate>
            </xsl:if>
            <xsl:if test="cbc:EndDate">
               <cbc:EndDate>
                  <xsl:value-of select="cbc:EndDate"/>
               </cbc:EndDate>
            </xsl:if>
         </cac:InvoicePeriod>
      </xsl:if>
   </xsl:template>
   <xsl:template match="cac:Item">
      <xsl:param name="CN" select="."/>
      <xsl:param name="CNP" select="1"/>
      <cac:Item>
         <xsl:if test="cbc:Description">
            <cbc:Description>
               <xsl:value-of select="cbc:Description"/>
            </cbc:Description>
         </xsl:if>
         <xsl:if test="cbc:Name">
            <cbc:Name>
               <xsl:value-of select="cbc:Name"/>
            </cbc:Name>
         </xsl:if>
         <xsl:apply-templates select="cac:BuyersItemIdentification">
            <xsl:with-param name="CN" select="current()"/>
            <xsl:with-param name="CNP" select="position()"/>
         </xsl:apply-templates>
         <xsl:apply-templates select="cac:SellersItemIdentification">
            <xsl:with-param name="CN" select="current()"/>
            <xsl:with-param name="CNP" select="position()"/>
         </xsl:apply-templates>
         <xsl:apply-templates select="cac:StandardItemIdentification">
            <xsl:with-param name="CN" select="current()"/>
            <xsl:with-param name="CNP" select="position()"/>
         </xsl:apply-templates>
         <xsl:apply-templates select="cac:OriginCountry">
            <xsl:with-param name="CN" select="current()"/>
            <xsl:with-param name="CNP" select="position()"/>
         </xsl:apply-templates>
         <xsl:apply-templates select="cac:CommodityClassification">
            <xsl:with-param name="CN" select="current()"/>
            <xsl:with-param name="CNP" select="position()"/>
         </xsl:apply-templates>
         <xsl:apply-templates select="cac:ClassifiedTaxCategory">
            <xsl:with-param name="CN" select="current()"/>
            <xsl:with-param name="CNP" select="position()"/>
         </xsl:apply-templates>
         <xsl:apply-templates select="cac:AdditionalItemProperty">
            <xsl:with-param name="CN" select="current()"/>
            <xsl:with-param name="CNP" select="position()"/>
         </xsl:apply-templates>
      </cac:Item>
   </xsl:template>
   <xsl:template match="cac:LegalMonetaryTotal">
      <xsl:param name="CN" select="."/>
      <xsl:param name="CNP" select="1"/>
      <cac:LegalMonetaryTotal>
         <xsl:if test="cbc:LineExtensionAmount">
            <cbc:LineExtensionAmount>
               <xsl:variable name="variable_d7e210a1050860">
                  <xsl:value-of select="cbc:LineExtensionAmount/@currencyID"/>
               </xsl:variable>
               <xsl:if test="string($variable_d7e210a1050860)">
                  <xsl:attribute name="currencyID">
                     <xsl:value-of select="string($variable_d7e210a1050860)"/>
                  </xsl:attribute>
               </xsl:if>
               <xsl:value-of select="cbc:LineExtensionAmount"/>
            </cbc:LineExtensionAmount>
         </xsl:if>
         <xsl:if test="cbc:TaxExclusiveAmount">
            <cbc:TaxExclusiveAmount>
               <xsl:variable name="variable_d7e211a1050860">
                  <xsl:value-of select="cbc:TaxExclusiveAmount/@currencyID"/>
               </xsl:variable>
               <xsl:if test="string($variable_d7e211a1050860)">
                  <xsl:attribute name="currencyID">
                     <xsl:value-of select="string($variable_d7e211a1050860)"/>
                  </xsl:attribute>
               </xsl:if>
               <xsl:value-of select="cbc:TaxExclusiveAmount"/>
            </cbc:TaxExclusiveAmount>
         </xsl:if>
         <xsl:if test="cbc:TaxInclusiveAmount">
            <cbc:TaxInclusiveAmount>
               <xsl:variable name="variable_d7e212a1050860">
                  <xsl:value-of select="cbc:TaxInclusiveAmount/@currencyID"/>
               </xsl:variable>
               <xsl:if test="string($variable_d7e212a1050860)">
                  <xsl:attribute name="currencyID">
                     <xsl:value-of select="string($variable_d7e212a1050860)"/>
                  </xsl:attribute>
               </xsl:if>
               <xsl:value-of select="cbc:TaxInclusiveAmount"/>
            </cbc:TaxInclusiveAmount>
         </xsl:if>
         <xsl:if test="cbc:AllowanceTotalAmount">
            <cbc:AllowanceTotalAmount>
               <xsl:variable name="variable_d7e213a1050860">
                  <xsl:value-of select="cbc:AllowanceTotalAmount/@currencyID"/>
               </xsl:variable>
               <xsl:if test="string($variable_d7e213a1050860)">
                  <xsl:attribute name="currencyID">
                     <xsl:value-of select="string($variable_d7e213a1050860)"/>
                  </xsl:attribute>
               </xsl:if>
               <xsl:value-of select="cbc:AllowanceTotalAmount"/>
            </cbc:AllowanceTotalAmount>
         </xsl:if>
         <xsl:if test="cbc:ChargeTotalAmount">
            <cbc:ChargeTotalAmount>
               <xsl:variable name="variable_d7e214a1050860">
                  <xsl:value-of select="cbc:ChargeTotalAmount/@currencyID"/>
               </xsl:variable>
               <xsl:if test="string($variable_d7e214a1050860)">
                  <xsl:attribute name="currencyID">
                     <xsl:value-of select="string($variable_d7e214a1050860)"/>
                  </xsl:attribute>
               </xsl:if>
               <xsl:value-of select="cbc:ChargeTotalAmount"/>
            </cbc:ChargeTotalAmount>
         </xsl:if>
         <xsl:if test="cbc:PrepaidAmount">
            <cbc:PrepaidAmount>
               <xsl:variable name="variable_d7e215a1050860">
                  <xsl:value-of select="cbc:PrepaidAmount/@currencyID"/>
               </xsl:variable>
               <xsl:if test="string($variable_d7e215a1050860)">
                  <xsl:attribute name="currencyID">
                     <xsl:value-of select="string($variable_d7e215a1050860)"/>
                  </xsl:attribute>
               </xsl:if>
               <xsl:value-of select="cbc:PrepaidAmount"/>
            </cbc:PrepaidAmount>
         </xsl:if>
         <xsl:if test="cbc:PayableRoundingAmount">
            <cbc:PayableRoundingAmount>
               <xsl:variable name="variable_d7e216a1050860">
                  <xsl:value-of select="cbc:PayableRoundingAmount/@currencyID"/>
               </xsl:variable>
               <xsl:if test="string($variable_d7e216a1050860)">
                  <xsl:attribute name="currencyID">
                     <xsl:value-of select="string($variable_d7e216a1050860)"/>
                  </xsl:attribute>
               </xsl:if>
               <xsl:value-of select="cbc:PayableRoundingAmount"/>
            </cbc:PayableRoundingAmount>
         </xsl:if>
         <cbc:PayableAmount>
            <xsl:variable name="variable_d7e217a1050860">
               <xsl:value-of select="cbc:PayableAmount/@currencyID"/>
            </xsl:variable>
            <xsl:if test="string($variable_d7e217a1050860)">
               <xsl:attribute name="currencyID">
                  <xsl:value-of select="string($variable_d7e217a1050860)"/>
               </xsl:attribute>
            </xsl:if>
            <xsl:value-of select="cbc:PayableAmount"/>
         </cbc:PayableAmount>
      </cac:LegalMonetaryTotal>
   </xsl:template>
   <xsl:template match="cac:OrderLineReference">
      <xsl:param name="CN" select="."/>
      <xsl:param name="CNP" select="1"/>
      <xsl:if test="cbc:LineID">
         <cac:OrderLineReference>
            <cbc:LineID>
               <xsl:value-of select="cbc:LineID"/>
            </cbc:LineID>
         </cac:OrderLineReference>
      </xsl:if>
   </xsl:template>
   <xsl:template match="cac:OrderReference">
      <xsl:param name="CN" select="."/>
      <xsl:param name="CNP" select="1"/>
      <xsl:if test="cbc:ID">
         <cac:OrderReference>
            <cbc:ID>
               <xsl:value-of select="cbc:ID"/>
            </cbc:ID>
            <cbc:SalesOrderID>
               <xsl:value-of select="cbc:SalesOrderID"/>
            </cbc:SalesOrderID>
         </cac:OrderReference>
      </xsl:if>
   </xsl:template>
   <xsl:template match="cac:OriginCountry">
      <xsl:param name="CN" select="."/>
      <xsl:param name="CNP" select="1"/>
      <xsl:if test="cbc:IdentificationCode">
         <cac:OriginCountry>
            <cbc:IdentificationCode>
               <xsl:value-of select="cbc:IdentificationCode"/>
            </cbc:IdentificationCode>
         </cac:OriginCountry>
      </xsl:if>
   </xsl:template>
   <xsl:template match="cac:OriginatorDocumentReference" mode="CIG">
      <xsl:param name="CN" select="."/>
      <xsl:param name="CNP" select="1"/>
      <xsl:if test="cbc:ID">
         <cac:AdditionalDocumentReference>
            <cbc:ID>
               <xsl:variable name="variable_d7e55a1049986">
                  <xsl:value-of select="cbc:ID/@schemeID"/>
               </xsl:variable>
               <xsl:if test="string($variable_d7e55a1049986)">
                  <xsl:attribute name="schemeID">
                     <xsl:value-of select="string($variable_d7e55a1049986)"/>
                  </xsl:attribute>
               </xsl:if>
               <xsl:value-of select="cbc:ID"/>
            </cbc:ID>
            <cbc:DocumentType>
               <xsl:text>CIG</xsl:text>
            </cbc:DocumentType>
         </cac:AdditionalDocumentReference>
      </xsl:if>
   </xsl:template>
   <xsl:template match="cac:Party" mode="AccountingSupplierParty">
      <xsl:param name="CN" select="."/>
      <xsl:param name="CNP" select="1"/>
      <cac:Party>
         <xsl:if test="cbc:EndpointID">
            <cbc:EndpointID>
               <xsl:variable name="variable_d7e65a1049986">
                  <xsl:value-of select="document($xclEAID)//entry[@key=current()/cbc:EndpointID/@schemeID][1]"/>
               </xsl:variable>
               <xsl:if test="string($variable_d7e65a1049986)">
                  <xsl:attribute name="schemeID">
                     <xsl:value-of select="string($variable_d7e65a1049986)"/>
                  </xsl:attribute>
               </xsl:if>
               <xsl:value-of select="cbc:EndpointID"/>
            </cbc:EndpointID>
         </xsl:if>
         <xsl:apply-templates select="cac:PartyIdentification" mode="AccountingSupplierPartyIdentification">
            <xsl:with-param name="CN" select="current()"/>
            <xsl:with-param name="CNP" select="position()"/>
         </xsl:apply-templates>
         <xsl:apply-templates select="cac:PartyName" mode="AccountingSupplierPartyName">
            <xsl:with-param name="CN" select="current()"/>
            <xsl:with-param name="CNP" select="position()"/>
         </xsl:apply-templates>
         <xsl:apply-templates select="cac:PostalAddress" mode="AccountingSupplierPartyPostalAddress">
            <xsl:with-param name="CN" select="current()"/>
            <xsl:with-param name="CNP" select="position()"/>
         </xsl:apply-templates>
         <xsl:apply-templates select="cac:PartyTaxScheme" mode="AccountingSupplierPartyTaxScheme">
            <xsl:with-param name="CN" select="current()"/>
            <xsl:with-param name="CNP" select="position()"/>
         </xsl:apply-templates>
         <xsl:apply-templates select="cac:PartyLegalEntity" mode="AccountingSupplierPartyLegalEntity">
            <xsl:with-param name="CN" select="current()"/>
            <xsl:with-param name="CNP" select="position()"/>
         </xsl:apply-templates>
         <xsl:apply-templates select="cac:Contact" mode="AccountingSupplierPartyContact">
            <xsl:with-param name="CN" select="current()"/>
            <xsl:with-param name="CNP" select="position()"/>
         </xsl:apply-templates>
      </cac:Party>
   </xsl:template>
   <xsl:template match="cac:Party" mode="AccountingCustomerParty">
      <xsl:param name="CN" select="."/>
      <xsl:param name="CNP" select="1"/>
      <cac:Party>
         <xsl:if test="cbc:EndpointID">
            <cbc:EndpointID>
               <xsl:variable name="variable_d7e94a1049986">
                  <xsl:value-of select="document($xclEAID)//entry[@key=current()/cbc:EndpointID/@schemeID][1]"/>
               </xsl:variable>
               <xsl:if test="string($variable_d7e94a1049986)">
                  <xsl:attribute name="schemeID">
                     <xsl:value-of select="string($variable_d7e94a1049986)"/>
                  </xsl:attribute>
               </xsl:if>
               <xsl:value-of select="cbc:EndpointID"/>
            </cbc:EndpointID>
         </xsl:if>
         <xsl:apply-templates select="cac:PartyIdentification" mode="AccountingCustomerPartyIdentification">
            <xsl:with-param name="CN" select="current()"/>
            <xsl:with-param name="CNP" select="position()"/>
         </xsl:apply-templates>
         <xsl:apply-templates select="cbc:EndpointID[@schemeID='9921']"
                              mode="AccountingCustomerPartyIdentificationFromEndpoint">
            <xsl:with-param name="CN" select="current()"/>
            <xsl:with-param name="CNP" select="position()"/>
         </xsl:apply-templates>
         <xsl:apply-templates select="cac:PartyName" mode="AccountingCustomerPartyName">
            <xsl:with-param name="CN" select="current()"/>
            <xsl:with-param name="CNP" select="position()"/>
         </xsl:apply-templates>
         <xsl:apply-templates select="cac:PostalAddress" mode="AccountingCustomerPartyPostalAddress">
            <xsl:with-param name="CN" select="current()"/>
            <xsl:with-param name="CNP" select="position()"/>
         </xsl:apply-templates>
         <xsl:apply-templates select="cac:PartyTaxScheme" mode="AccountingCustomerPartyTaxScheme">
            <xsl:with-param name="CN" select="current()"/>
            <xsl:with-param name="CNP" select="position()"/>
         </xsl:apply-templates>
         <xsl:apply-templates select="cac:PartyLegalEntity" mode="AccountingCustomerPartyLegalEntity">
            <xsl:with-param name="CN" select="current()"/>
            <xsl:with-param name="CNP" select="position()"/>
         </xsl:apply-templates>
         <xsl:apply-templates select="cac:Contact" mode="AccountingCustomerPartyContact">
            <xsl:with-param name="CN" select="current()"/>
            <xsl:with-param name="CNP" select="position()"/>
         </xsl:apply-templates>
      </cac:Party>
   </xsl:template>
   <xsl:template match="cac:PartyIdentification" mode="AccountingSupplierPartyIdentification">
      <xsl:param name="CN" select="."/>
      <xsl:param name="CNP" select="1"/>
      <xsl:if test="cbc:ID">
         <cac:PartyIdentification>
            <cbc:ID>
               <xsl:variable name="variable_d7e67a1049986">
                  <xsl:value-of select="document($xclEAID)//entry[@key=current()/cbc:ID/@schemeID][1]"/>
               </xsl:variable>
               <xsl:if test="string($variable_d7e67a1049986)">
                  <xsl:attribute name="schemeID">
                     <xsl:value-of select="string($variable_d7e67a1049986)"/>
                  </xsl:attribute>
               </xsl:if>
               <xsl:value-of select="cbc:ID"/>
            </cbc:ID>
         </cac:PartyIdentification>
      </xsl:if>
   </xsl:template>
   <xsl:template match="cac:PartyIdentification" mode="AccountingCustomerPartyIdentification">
      <xsl:param name="CN" select="."/>
      <xsl:param name="CNP" select="1"/>
      <xsl:if test="cbc:ID">
         <cac:PartyIdentification>
            <cbc:ID>
               <xsl:variable name="variable_d7e96a1049986">
                  <xsl:value-of select="document($xclEAID)//entry[@key=current()/cbc:ID/@schemeID][1]"/>
               </xsl:variable>
               <xsl:if test="string($variable_d7e96a1049986)">
                  <xsl:attribute name="schemeID">
                     <xsl:value-of select="string($variable_d7e96a1049986)"/>
                  </xsl:attribute>
               </xsl:if>
               <xsl:value-of select="cbc:ID"/>
            </cbc:ID>
         </cac:PartyIdentification>
      </xsl:if>
   </xsl:template>
   <xsl:template match="cac:PartyIdentification">
      <xsl:param name="CN" select="."/>
      <xsl:param name="CNP" select="1"/>
      <xsl:if test="cbc:ID">
         <cac:PartyIdentification>
            <cbc:ID>
               <xsl:variable name="variable_d7e124a1049986">
                  <xsl:value-of select="document($xclEAID)//entry[@key=current()/cbc:ID/@schemeID][1]"/>
               </xsl:variable>
               <xsl:if test="string($variable_d7e124a1049986)">
                  <xsl:attribute name="schemeID">
                     <xsl:value-of select="string($variable_d7e124a1049986)"/>
                  </xsl:attribute>
               </xsl:if>
               <xsl:value-of select="cbc:ID"/>
            </cbc:ID>
         </cac:PartyIdentification>
      </xsl:if>
   </xsl:template>
   <xsl:template match="cac:PartyLegalEntity" mode="AccountingSupplierPartyLegalEntity">
      <xsl:param name="CN" select="."/>
      <xsl:param name="CNP" select="1"/>
      <xsl:if test="cbc:RegistrationName or cbc:CompanyID">
         <cac:PartyLegalEntity>
            <xsl:if test="cbc:RegistrationName">
               <cbc:RegistrationName>
                  <xsl:value-of select="cbc:RegistrationName"/>
               </cbc:RegistrationName>
            </xsl:if>
            <xsl:if test="cbc:CompanyID">
               <cbc:CompanyID>
                  <xsl:variable name="variable_d7e86a1049986">
                     <xsl:value-of select="document($xclEAID)//entry[@key=current()/cbc:CompanyID/@schemeID][1]"/>
                  </xsl:variable>
                  <xsl:if test="string($variable_d7e86a1049986)">
                     <xsl:attribute name="schemeID">
                        <xsl:value-of select="string($variable_d7e86a1049986)"/>
                     </xsl:attribute>
                  </xsl:if>
                  <xsl:value-of select="cbc:CompanyID"/>
               </cbc:CompanyID>
            </xsl:if>
            <xsl:if test="cbc:CompanyLegalForm">
               <cbc:CompanyLegalForm>
                  <xsl:value-of select="cbc:CompanyLegalForm"/>
               </cbc:CompanyLegalForm>
            </xsl:if>
         </cac:PartyLegalEntity>
      </xsl:if>
   </xsl:template>
   <xsl:template match="cac:PartyLegalEntity" mode="AccountingCustomerPartyLegalEntity">
      <xsl:param name="CN" select="."/>
      <xsl:param name="CNP" select="1"/>
      <xsl:if test="cbc:RegistrationName or cbc:CompanyID">
         <cac:PartyLegalEntity>
            <xsl:if test="cbc:RegistrationName">
               <cbc:RegistrationName>
                  <xsl:value-of select="cbc:RegistrationName"/>
               </cbc:RegistrationName>
            </xsl:if>
            <xsl:if test="cbc:CompanyID">
               <cbc:CompanyID>
                  <xsl:variable name="variable_d7e117a1049986">
                     <xsl:value-of select="document($xclEAID)//entry[@key=current()/cbc:CompanyID/@schemeID][1]"/>
                  </xsl:variable>
                  <xsl:if test="string($variable_d7e117a1049986)">
                     <xsl:attribute name="schemeID">
                        <xsl:value-of select="string($variable_d7e117a1049986)"/>
                     </xsl:attribute>
                  </xsl:if>
                  <xsl:value-of select="cbc:CompanyID"/>
               </cbc:CompanyID>
            </xsl:if>
         </cac:PartyLegalEntity>
      </xsl:if>
   </xsl:template>
   <xsl:template match="cac:PartyLegalEntity">
      <xsl:param name="CN" select="."/>
      <xsl:param name="CNP" select="1"/>
      <xsl:if test="cbc:CompanyID">
         <cac:PartyLegalEntity>
            <xsl:if test="cbc:CompanyID">
               <cbc:CompanyID>
                  <xsl:variable name="variable_d7e128a1049986">
                     <xsl:value-of select="document($xclEAID)//entry[@key=current()/cbc:CompanyID/@schemeID][1]"/>
                  </xsl:variable>
                  <xsl:if test="string($variable_d7e128a1049986)">
                     <xsl:attribute name="schemeID">
                        <xsl:value-of select="string($variable_d7e128a1049986)"/>
                     </xsl:attribute>
                  </xsl:if>
                  <xsl:value-of select="cbc:CompanyID"/>
               </cbc:CompanyID>
            </xsl:if>
         </cac:PartyLegalEntity>
      </xsl:if>
   </xsl:template>
   <xsl:template match="cac:PartyName" mode="AccountingSupplierPartyName">
      <xsl:param name="CN" select="."/>
      <xsl:param name="CNP" select="1"/>
      <xsl:if test="cbc:Name">
         <cac:PartyName>
            <cbc:Name>
               <xsl:value-of select="cbc:Name"/>
            </cbc:Name>
         </cac:PartyName>
      </xsl:if>
   </xsl:template>
   <xsl:template match="cac:PartyName" mode="AccountingCustomerPartyName">
      <xsl:param name="CN" select="."/>
      <xsl:param name="CNP" select="1"/>
      <xsl:if test="cbc:Name">
         <cac:PartyName>
            <cbc:Name>
               <xsl:value-of select="cbc:Name"/>
            </cbc:Name>
         </cac:PartyName>
      </xsl:if>
   </xsl:template>
   <xsl:template match="cac:PartyName">
      <xsl:param name="CN" select="."/>
      <xsl:param name="CNP" select="1"/>
      <xsl:if test="cbc:Name">
         <cac:PartyName>
            <cbc:Name>
               <xsl:value-of select="cbc:Name"/>
            </cbc:Name>
         </cac:PartyName>
      </xsl:if>
   </xsl:template>
   <xsl:template match="cac:PartyName">
      <xsl:param name="CN" select="."/>
      <xsl:param name="CNP" select="1"/>
      <xsl:if test="cbc:Name">
         <cac:PartyName>
            <cbc:Name>
               <xsl:value-of select="cbc:Name"/>
            </cbc:Name>
         </cac:PartyName>
      </xsl:if>
   </xsl:template>
   <xsl:template match="cac:PartyName" mode="DeliveryPartyName">
      <xsl:param name="CN" select="."/>
      <xsl:param name="CNP" select="1"/>
      <xsl:if test="cbc:Name">
         <cac:PartyName>
            <cbc:Name>
               <xsl:value-of select="cbc:Name"/>
            </cbc:Name>
         </cac:PartyName>
      </xsl:if>
   </xsl:template>
   <xsl:template match="cac:PartyTaxScheme" mode="AccountingSupplierPartyTaxScheme">
      <xsl:param name="CN" select="."/>
      <xsl:param name="CNP" select="1"/>
      <xsl:if test="cbc:CompanyID">
         <cac:PartyTaxScheme>
            <cbc:CompanyID>
               <xsl:variable name="variable_d7e81a1049986">
                  <xsl:value-of select="concat(substring(cbc:CompanyID,1,2),':VAT')"/>
               </xsl:variable>
               <xsl:if test="string($variable_d7e81a1049986)">
                  <xsl:attribute name="schemeID">
                     <xsl:value-of select="string($variable_d7e81a1049986)"/>
                  </xsl:attribute>
               </xsl:if>
               <xsl:value-of select="cbc:CompanyID"/>
            </cbc:CompanyID>
            <cac:TaxScheme>
               <cbc:ID>
                  <xsl:value-of select="cac:TaxScheme/cbc:ID"/>
               </cbc:ID>
            </cac:TaxScheme>
         </cac:PartyTaxScheme>
      </xsl:if>
   </xsl:template>
   <xsl:template match="cac:PartyTaxScheme" mode="AccountingCustomerPartyTaxScheme">
      <xsl:param name="CN" select="."/>
      <xsl:param name="CNP" select="1"/>
      <xsl:if test="cbc:CompanyID">
         <cac:PartyTaxScheme>
            <cbc:CompanyID>
               <xsl:variable name="variable_d7e112a1049986">
                  <xsl:value-of select="concat(substring(cbc:CompanyID,1,2),':VAT')"/>
               </xsl:variable>
               <xsl:if test="string($variable_d7e112a1049986)">
                  <xsl:attribute name="schemeID">
                     <xsl:value-of select="string($variable_d7e112a1049986)"/>
                  </xsl:attribute>
               </xsl:if>
               <xsl:value-of select="cbc:CompanyID"/>
            </cbc:CompanyID>
            <cac:TaxScheme>
               <cbc:ID>
                  <xsl:value-of select="cac:TaxScheme/cbc:ID"/>
               </cbc:ID>
            </cac:TaxScheme>
         </cac:PartyTaxScheme>
      </xsl:if>
   </xsl:template>
   <xsl:template match="cac:PartyTaxScheme">
      <xsl:param name="CN" select="."/>
      <xsl:param name="CNP" select="1"/>
      <xsl:if test="cbc:CompanyID">
         <cac:PartyTaxScheme>
            <cbc:CompanyID>
               <xsl:variable name="variable_d7e143a1049986">
                  <xsl:value-of select="concat(substring(cbc:CompanyID,1,2),':VAT')"/>
               </xsl:variable>
               <xsl:if test="string($variable_d7e143a1049986)">
                  <xsl:attribute name="schemeID">
                     <xsl:value-of select="string($variable_d7e143a1049986)"/>
                  </xsl:attribute>
               </xsl:if>
               <xsl:value-of select="cbc:CompanyID"/>
            </cbc:CompanyID>
            <xsl:apply-templates select="cac:TaxScheme">
               <xsl:with-param name="CN" select="current()"/>
               <xsl:with-param name="CNP" select="position()"/>
            </xsl:apply-templates>
         </cac:PartyTaxScheme>
      </xsl:if>
   </xsl:template>
   <xsl:template match="cac:PayeeFinancialAccount">
      <xsl:param name="CN" select="."/>
      <xsl:param name="CNP" select="1"/>
      <xsl:if test="cbc:ID">
         <cac:PayeeFinancialAccount>
            <cbc:ID schemeID="IBAN">
               <xsl:value-of select="cbc:ID"/>
            </cbc:ID>
            <xsl:if test="cbc:Name">
               <cbc:Name>
                  <xsl:value-of select="cbc:Name"/>
               </cbc:Name>
            </xsl:if>
            <cac:FinancialInstitutionBranch>
               <xsl:apply-templates select="cac:FinancialInstitutionBranch" mode="BICPresent">
                  <xsl:with-param name="CN" select="current()"/>
                  <xsl:with-param name="CNP" select="position()"/>
               </xsl:apply-templates>
               <xsl:if test="not(cac:FinancialInstitutionBranch/cbc:ID)">
                  <cac:FinancialInstitution>
                     <cbc:ID schemeID="BIC">
                        <xsl:text>XXXXITX0</xsl:text>
                     </cbc:ID>
                  </cac:FinancialInstitution>
               </xsl:if>
            </cac:FinancialInstitutionBranch>
         </cac:PayeeFinancialAccount>
      </xsl:if>
   </xsl:template>
   <xsl:template match="cac:PayeeParty">
      <xsl:param name="CN" select="."/>
      <xsl:param name="CNP" select="1"/>
      <xsl:if test="cac:PartyIdentification or cac:PartyName">
         <cac:PayeeParty>
            <xsl:apply-templates select="cac:PartyIdentification">
               <xsl:with-param name="CN" select="current()"/>
               <xsl:with-param name="CNP" select="position()"/>
            </xsl:apply-templates>
            <xsl:apply-templates select="cac:PartyName">
               <xsl:with-param name="CN" select="current()"/>
               <xsl:with-param name="CNP" select="position()"/>
            </xsl:apply-templates>
            <xsl:apply-templates select="cac:PartyLegalEntity">
               <xsl:with-param name="CN" select="current()"/>
               <xsl:with-param name="CNP" select="position()"/>
            </xsl:apply-templates>
         </cac:PayeeParty>
      </xsl:if>
   </xsl:template>
   <xsl:template match="cac:PayerFinancialAccount">
      <xsl:param name="CN" select="."/>
      <xsl:param name="CNP" select="1"/>
      <xsl:if test="cbc:ID">
         <cac:PayerFinancialAccount>
            <cbc:ID>
               <xsl:value-of select="cbc:ID"/>
            </cbc:ID>
         </cac:PayerFinancialAccount>
      </xsl:if>
   </xsl:template>
   <xsl:template match="cac:PaymentMandate">
      <xsl:param name="CN" select="."/>
      <xsl:param name="CNP" select="1"/>
      <xsl:if test="cbc:ID">
         <cac:PaymentMandate>
            <xsl:if test="cbc:ID">
               <cbc:ID>
                  <xsl:value-of select="cbc:ID"/>
               </cbc:ID>
            </xsl:if>
            <xsl:apply-templates select="cac:PayerFinancialAccount">
               <xsl:with-param name="CN" select="current()"/>
               <xsl:with-param name="CNP" select="position()"/>
            </xsl:apply-templates>
         </cac:PaymentMandate>
      </xsl:if>
   </xsl:template>
   <xsl:template match="cac:PaymentMeans">
      <xsl:param name="CN" select="."/>
      <xsl:param name="CNP" select="1"/>
      <xsl:if test="cbc:PaymentMeansCode">
         <cac:PaymentMeans>
            <cbc:PaymentMeansCode listID="UNCL4461">
               <xsl:variable name="variable_d7e165a1052524">
                  <xsl:value-of select="cbc:PaymentMeansCode/@name"/>
               </xsl:variable>
               <xsl:if test="string($variable_d7e165a1052524)">
                  <xsl:attribute name="name">
                     <xsl:value-of select="string($variable_d7e165a1052524)"/>
                  </xsl:attribute>
               </xsl:if>
               <xsl:value-of select="cbc:PaymentMeansCode"/>
            </cbc:PaymentMeansCode>
            <xsl:if test="cbc:PaymentID">
               <cbc:PaymentID>
                  <xsl:value-of select="cbc:PaymentID"/>
               </cbc:PaymentID>
            </xsl:if>
            <xsl:apply-templates select="cac:CardAccount">
               <xsl:with-param name="CN" select="current()"/>
               <xsl:with-param name="CNP" select="position()"/>
            </xsl:apply-templates>
            <xsl:apply-templates select="cac:PayeeFinancialAccount">
               <xsl:with-param name="CN" select="current()"/>
               <xsl:with-param name="CNP" select="position()"/>
            </xsl:apply-templates>
            <xsl:apply-templates select="cac:PaymentMandate">
               <xsl:with-param name="CN" select="current()"/>
               <xsl:with-param name="CNP" select="position()"/>
            </xsl:apply-templates>
         </cac:PaymentMeans>
      </xsl:if>
   </xsl:template>
   <xsl:template match="cac:PaymentTerms">
      <xsl:param name="CN" select="."/>
      <xsl:param name="CNP" select="1"/>
      <xsl:if test="cbc:Note">
         <cac:PaymentTerms>
            <cbc:Note>
               <xsl:value-of select="cbc:Note"/>
            </cbc:Note>
         </cac:PaymentTerms>
      </xsl:if>
   </xsl:template>
   <xsl:template match="cac:PostalAddress" mode="AccountingSupplierPartyPostalAddress">
      <xsl:param name="CN" select="."/>
      <xsl:param name="CNP" select="1"/>
      <cac:PostalAddress>
         <xsl:if test="cbc:StreetName">
            <cbc:StreetName>
               <xsl:value-of select="cbc:StreetName"/>
            </cbc:StreetName>
         </xsl:if>
         <xsl:if test="cbc:AdditionalStreetName">
            <cbc:AdditionalStreetName>
               <xsl:value-of select="cbc:AdditionalStreetName"/>
            </cbc:AdditionalStreetName>
         </xsl:if>
         <xsl:if test="cbc:CityName">
            <cbc:CityName>
               <xsl:value-of select="cbc:CityName"/>
            </cbc:CityName>
         </xsl:if>
         <xsl:if test="cbc:PostalZone">
            <cbc:PostalZone>
               <xsl:value-of select="cbc:PostalZone"/>
            </cbc:PostalZone>
         </xsl:if>
         <xsl:if test="cbc:CountrySubentity">
            <cbc:CountrySubentity>
               <xsl:value-of select="cbc:CountrySubentity"/>
            </cbc:CountrySubentity>
         </xsl:if>
         <xsl:apply-templates select="cac:AddressLine" mode="AccountingSupplierPartyAddressLine">
            <xsl:with-param name="CN" select="current()"/>
            <xsl:with-param name="CNP" select="position()"/>
         </xsl:apply-templates>
         <xsl:apply-templates select="cac:Country" mode="AccountingSupplierPartyCountry">
            <xsl:with-param name="CN" select="current()"/>
            <xsl:with-param name="CNP" select="position()"/>
         </xsl:apply-templates>
      </cac:PostalAddress>
   </xsl:template>
   <xsl:template match="cac:PostalAddress" mode="AccountingCustomerPartyPostalAddress">
      <xsl:param name="CN" select="."/>
      <xsl:param name="CNP" select="1"/>
      <cac:PostalAddress>
         <xsl:if test="cbc:StreetName">
            <cbc:StreetName>
               <xsl:value-of select="cbc:StreetName"/>
            </cbc:StreetName>
         </xsl:if>
         <xsl:if test="cbc:AdditionalStreetName">
            <cbc:AdditionalStreetName>
               <xsl:value-of select="cbc:AdditionalStreetName"/>
            </cbc:AdditionalStreetName>
         </xsl:if>
         <xsl:if test="cbc:CityName">
            <cbc:CityName>
               <xsl:value-of select="cbc:CityName"/>
            </cbc:CityName>
         </xsl:if>
         <xsl:if test="cbc:PostalZone">
            <cbc:PostalZone>
               <xsl:value-of select="cbc:PostalZone"/>
            </cbc:PostalZone>
         </xsl:if>
         <xsl:if test="cbc:CountrySubentity">
            <cbc:CountrySubentity>
               <xsl:value-of select="cbc:CountrySubentity"/>
            </cbc:CountrySubentity>
         </xsl:if>
         <xsl:apply-templates select="cac:AddressLine" mode="AccountingCustomerPartyAddressLine">
            <xsl:with-param name="CN" select="current()"/>
            <xsl:with-param name="CNP" select="position()"/>
         </xsl:apply-templates>
         <xsl:apply-templates select="cac:Country" mode="AccountingCustomerPartyCountry">
            <xsl:with-param name="CN" select="current()"/>
            <xsl:with-param name="CNP" select="position()"/>
         </xsl:apply-templates>
      </cac:PostalAddress>
   </xsl:template>
   <xsl:template match="cac:PostalAddress">
      <xsl:param name="CN" select="."/>
      <xsl:param name="CNP" select="1"/>
      <cac:PostalAddress>
         <xsl:if test="cbc:StreetName">
            <cbc:StreetName>
               <xsl:value-of select="cbc:StreetName"/>
            </cbc:StreetName>
         </xsl:if>
         <xsl:if test="cbc:AdditionalStreetName">
            <cbc:AdditionalStreetName>
               <xsl:value-of select="cbc:AdditionalStreetName"/>
            </cbc:AdditionalStreetName>
         </xsl:if>
         <xsl:if test="cbc:CityName">
            <cbc:CityName>
               <xsl:value-of select="cbc:CityName"/>
            </cbc:CityName>
         </xsl:if>
         <xsl:if test="cbc:PostalZone">
            <cbc:PostalZone>
               <xsl:value-of select="cbc:PostalZone"/>
            </cbc:PostalZone>
         </xsl:if>
         <xsl:if test="cbc:CountrySubentity">
            <cbc:CountrySubentity>
               <xsl:value-of select="cbc:CountrySubentity"/>
            </cbc:CountrySubentity>
         </xsl:if>
         <xsl:apply-templates select="cac:AddressLine">
            <xsl:with-param name="CN" select="current()"/>
            <xsl:with-param name="CNP" select="position()"/>
         </xsl:apply-templates>
         <xsl:apply-templates select="cac:Country">
            <xsl:with-param name="CN" select="current()"/>
            <xsl:with-param name="CNP" select="position()"/>
         </xsl:apply-templates>
      </cac:PostalAddress>
   </xsl:template>
   <xsl:template match="cac:Price">
      <xsl:param name="CN" select="."/>
      <xsl:param name="CNP" select="1"/>
      <xsl:if test="cbc:PriceAmount">
         <cac:Price>
            <cbc:PriceAmount>
               <xsl:variable name="variable_d7e261a1050860">
                  <xsl:value-of select="cbc:PriceAmount/@currencyID"/>
               </xsl:variable>
               <xsl:if test="string($variable_d7e261a1050860)">
                  <xsl:attribute name="currencyID">
                     <xsl:value-of select="string($variable_d7e261a1050860)"/>
                  </xsl:attribute>
               </xsl:if>
               <xsl:value-of select="cbc:PriceAmount"/>
            </cbc:PriceAmount>
            <xsl:if test="cbc:BaseQuantity">
               <cbc:BaseQuantity>
                  <xsl:variable name="variable_d7e262a1050145">
                     <xsl:value-of select="cbc:BaseQuantity/@unitCode"/>
                  </xsl:variable>
                  <xsl:if test="string($variable_d7e262a1050145)">
                     <xsl:attribute name="unitCode">
                        <xsl:value-of select="string($variable_d7e262a1050145)"/>
                     </xsl:attribute>
                  </xsl:if>
                  <xsl:value-of select="cbc:BaseQuantity"/>
               </cbc:BaseQuantity>
            </xsl:if>
            <xsl:apply-templates select="cac:AllowanceCharge">
               <xsl:with-param name="CN" select="current()"/>
               <xsl:with-param name="CNP" select="position()"/>
            </xsl:apply-templates>
         </cac:Price>
      </xsl:if>
   </xsl:template>
   <xsl:template match="cac:ProjectReference" mode="CUP">
      <xsl:param name="CN" select="."/>
      <xsl:param name="CNP" select="1"/>
      <xsl:if test="cbc:ID">
         <cac:AdditionalDocumentReference>
            <cbc:ID>
               <xsl:variable name="variable_d7e60a1049986">
                  <xsl:value-of select="cbc:ID/@schemeID"/>
               </xsl:variable>
               <xsl:if test="string($variable_d7e60a1049986)">
                  <xsl:attribute name="schemeID">
                     <xsl:value-of select="string($variable_d7e60a1049986)"/>
                  </xsl:attribute>
               </xsl:if>
               <xsl:value-of select="cbc:ID"/>
            </cbc:ID>
            <cbc:DocumentType>
               <xsl:text>CUP</xsl:text>
            </cbc:DocumentType>
         </cac:AdditionalDocumentReference>
      </xsl:if>
   </xsl:template>
   <xsl:template match="cac:ReceiptDocumentReference">
      <xsl:param name="CN" select="."/>
      <xsl:param name="CNP" select="1"/>
      <xsl:if test="cbc:ID">
         <cac:ReceiptDocumentReference>
            <cbc:ID>
               <xsl:value-of select="cbc:ID"/>
            </cbc:ID>
         </cac:ReceiptDocumentReference>
      </xsl:if>
   </xsl:template>
   <xsl:template match="cac:SellersItemIdentification">
      <xsl:param name="CN" select="."/>
      <xsl:param name="CNP" select="1"/>
      <xsl:if test="cbc:ID">
         <cac:SellersItemIdentification>
            <cbc:ID>
               <xsl:value-of select="cbc:ID"/>
            </cbc:ID>
         </cac:SellersItemIdentification>
      </xsl:if>
   </xsl:template>
   <xsl:template match="cac:StandardItemIdentification">
      <xsl:param name="CN" select="."/>
      <xsl:param name="CNP" select="1"/>
      <xsl:if test="cbc:ID">
         <cac:StandardItemIdentification>
            <cbc:ID>
               <xsl:variable name="variable_d7e247a1049986">
                  <xsl:value-of select="cbc:ID/@schemeID"/>
               </xsl:variable>
               <xsl:if test="string($variable_d7e247a1049986)">
                  <xsl:attribute name="schemeID">
                     <xsl:value-of select="string($variable_d7e247a1049986)"/>
                  </xsl:attribute>
               </xsl:if>
               <xsl:value-of select="cbc:ID"/>
            </cbc:ID>
         </cac:StandardItemIdentification>
      </xsl:if>
   </xsl:template>
   <xsl:template match="cac:TaxCategory">
      <xsl:param name="CN" select="."/>
      <xsl:param name="CNP" select="1"/>
      <xsl:if test="cbc:ID">
         <cac:TaxCategory>
            <cbc:ID>
               <xsl:value-of select="cbc:ID"/>
            </cbc:ID>
            <xsl:apply-templates select="cac:TaxScheme">
               <xsl:with-param name="CN" select="current()"/>
               <xsl:with-param name="CNP" select="position()"/>
            </xsl:apply-templates>
         </cac:TaxCategory>
      </xsl:if>
   </xsl:template>
   <xsl:template match="cac:TaxCategory" mode="TaxSubtotalTaxCategory">
      <xsl:param name="CN" select="."/>
      <xsl:param name="CNP" select="1"/>
      <cac:TaxCategory>
         <cbc:ID schemeID="UNCL5305">
            <xsl:value-of select="cbc:ID"/>
         </cbc:ID>
         <cbc:Percent>
            <xsl:value-of select="cbc:Percent"/>
         </cbc:Percent>
         <xsl:if test="cbc:TaxExemptionReasonCode">
            <cbc:TaxExemptionReasonCode>
               <xsl:value-of select="cbc:TaxExemptionReasonCode"/>
            </cbc:TaxExemptionReasonCode>
         </xsl:if>
         <xsl:if test="cbc:TaxExemptionReasonCode">
            <cbc:TaxExemptionReason>
               <xsl:value-of select="document($xclVATEX)//entry[@key=current()/cbc:TaxExemptionReasonCode][1]"/>
            </cbc:TaxExemptionReason>
         </xsl:if>
         <cac:TaxScheme>
            <cbc:ID>
               <xsl:value-of select="cac:TaxScheme/cbc:ID"/>
            </cbc:ID>
         </cac:TaxScheme>
      </cac:TaxCategory>
   </xsl:template>
   <xsl:template match="cac:TaxRepresentativeParty">
      <xsl:param name="CN" select="."/>
      <xsl:param name="CNP" select="1"/>
      <xsl:if test="cac:PartyName">
         <cac:TaxRepresentativeParty>
            <xsl:apply-templates select="cac:PartyName">
               <xsl:with-param name="CN" select="current()"/>
               <xsl:with-param name="CNP" select="position()"/>
            </xsl:apply-templates>
            <xsl:apply-templates select="cac:PostalAddress">
               <xsl:with-param name="CN" select="current()"/>
               <xsl:with-param name="CNP" select="position()"/>
            </xsl:apply-templates>
            <xsl:apply-templates select="cac:PartyTaxScheme">
               <xsl:with-param name="CN" select="current()"/>
               <xsl:with-param name="CNP" select="position()"/>
            </xsl:apply-templates>
         </cac:TaxRepresentativeParty>
      </xsl:if>
   </xsl:template>
   <xsl:template match="cac:TaxScheme">
      <xsl:param name="CN" select="."/>
      <xsl:param name="CNP" select="1"/>
      <cac:TaxScheme>
         <cbc:ID>
            <xsl:value-of select="cbc:ID"/>
         </cbc:ID>
      </cac:TaxScheme>
   </xsl:template>
   <xsl:template match="cac:TaxScheme">
      <xsl:param name="CN" select="."/>
      <xsl:param name="CNP" select="1"/>
      <cac:TaxScheme>
         <cbc:ID>
            <xsl:value-of select="cbc:ID"/>
         </cbc:ID>
      </cac:TaxScheme>
   </xsl:template>
   <xsl:template match="cac:TaxSubtotal">
      <xsl:param name="CN" select="."/>
      <xsl:param name="CNP" select="1"/>
      <cac:TaxSubtotal>
         <cbc:TaxableAmount>
            <xsl:variable name="variable_d7e200a1050860">
               <xsl:value-of select="cbc:TaxableAmount/@currencyID"/>
            </xsl:variable>
            <xsl:if test="string($variable_d7e200a1050860)">
               <xsl:attribute name="currencyID">
                  <xsl:value-of select="string($variable_d7e200a1050860)"/>
               </xsl:attribute>
            </xsl:if>
            <xsl:value-of select="cbc:TaxableAmount"/>
         </cbc:TaxableAmount>
         <cbc:TaxAmount>
            <xsl:variable name="variable_d7e201a1050860">
               <xsl:value-of select="cbc:TaxAmount/@currencyID"/>
            </xsl:variable>
            <xsl:if test="string($variable_d7e201a1050860)">
               <xsl:attribute name="currencyID">
                  <xsl:value-of select="string($variable_d7e201a1050860)"/>
               </xsl:attribute>
            </xsl:if>
            <xsl:value-of select="cbc:TaxAmount"/>
         </cbc:TaxAmount>
         <xsl:apply-templates select="cac:TaxCategory" mode="TaxSubtotalTaxCategory">
            <xsl:with-param name="CN" select="current()"/>
            <xsl:with-param name="CNP" select="position()"/>
         </xsl:apply-templates>
      </cac:TaxSubtotal>
   </xsl:template>
   <xsl:template match="cac:TaxTotal">
      <xsl:param name="CN" select="."/>
      <xsl:param name="CNP" select="1"/>
      <cac:TaxTotal>
         <cbc:TaxAmount>
            <xsl:variable name="variable_d7e198a1050860">
               <xsl:value-of select="cbc:TaxAmount/@currencyID"/>
            </xsl:variable>
            <xsl:if test="string($variable_d7e198a1050860)">
               <xsl:attribute name="currencyID">
                  <xsl:value-of select="string($variable_d7e198a1050860)"/>
               </xsl:attribute>
            </xsl:if>
            <xsl:value-of select="cbc:TaxAmount"/>
         </cbc:TaxAmount>
         <xsl:apply-templates select="cac:TaxSubtotal">
            <xsl:with-param name="CN" select="current()"/>
            <xsl:with-param name="CNP" select="position()"/>
         </xsl:apply-templates>
      </cac:TaxTotal>
   </xsl:template>
   <xsl:template match="cbc:EndpointID[@schemeID='9921']"
                 mode="AccountingCustomerPartyIdentificationFromEndpoint">
      <xsl:param name="CN" select="."/>
      <xsl:param name="CNP" select="1"/>
      <xsl:if test="not(../cac:PartyIdentification/cbc:ID)">
         <cac:PartyIdentification>
            <cbc:ID schemeID="IT:IPA">
               <xsl:value-of select="normalize-space(.)"/>
            </cbc:ID>
         </cac:PartyIdentification>
      </xsl:if>
   </xsl:template>
   <xsl:template match="/in:Invoice" name="root">
      <xsl:param name="CN" select="."/>
      <xsl:param name="CNP" select="1"/>
      <Invoice>
         <ext:UBLExtensions>
            <ext:UBLExtension>
               <ext:ExtensionURI>
                  <xsl:text>urn:www.ubl-italia.org:spec:fatturapa:esigibilita_iva</xsl:text>
               </ext:ExtensionURI>
               <ext:ExtensionContent>
                  <cbc:TaxTypeCode>
                     <xsl:value-of select="if ((cbc:IssueDate and cbc:TaxPointDate and cbc:IssueDate != cbc:TaxPointDate) or cac:InvoicePeriod/cbc:DescriptionCode='paid to date') then 'D' else 'I'"/>
                  </cbc:TaxTypeCode>
               </ext:ExtensionContent>
            </ext:UBLExtension>
         </ext:UBLExtensions>
         <cbc:UBLVersionID>
            <xsl:text>2.1</xsl:text>
         </cbc:UBLVersionID>
         <cbc:CustomizationID>
            <xsl:text>urn:www.cenbii.eu:transaction:biitrns010:ver2.0:extended:urn:www.peppol.eu:bis:peppol5a:ver2.0:extended:urn:www.ubl-italia.org:spec:fatturapa:ver2.0</xsl:text>
         </cbc:CustomizationID>
         <cbc:ProfileID>
            <xsl:text>urn:www.cenbii.eu:profile:bii05:ver2.0</xsl:text>
         </cbc:ProfileID>
         <cbc:ID>
            <xsl:value-of select="cbc:ID"/>
         </cbc:ID>
         <cbc:IssueDate>
            <xsl:value-of select="cbc:IssueDate"/>
         </cbc:IssueDate>
         <xsl:if test="cbc:DueDate">
            <cbc:DueDate>
               <xsl:value-of select="cbc:DueDate"/>
            </cbc:DueDate>
         </xsl:if>
         <xsl:if test="cbc:InvoiceTypeCode">
            <cbc:InvoiceTypeCode listID="UNCL1001">
               <xsl:value-of select="cbc:InvoiceTypeCode"/>
            </cbc:InvoiceTypeCode>
         </xsl:if>
         <xsl:if test="cbc:Note">
            <cbc:Note>
               <xsl:value-of select="cbc:Note"/>
            </cbc:Note>
         </xsl:if>
         <xsl:if test="cbc:TaxPointDate">
            <cbc:TaxPointDate>
               <xsl:value-of select="cbc:TaxPointDate"/>
            </cbc:TaxPointDate>
         </xsl:if>
         <xsl:if test="cbc:DocumentCurrencyCode">
            <cbc:DocumentCurrencyCode listID="ISO4217">
               <xsl:value-of select="cbc:DocumentCurrencyCode"/>
            </cbc:DocumentCurrencyCode>
         </xsl:if>
         <xsl:if test="cbc:TaxCurrencyCode">
            <cbc:TaxCurrencyCode>
               <xsl:value-of select="cbc:TaxCurrencyCode"/>
            </cbc:TaxCurrencyCode>
         </xsl:if>
         <xsl:if test="cbc:AccountingCost">
            <cbc:AccountingCost>
               <xsl:value-of select="cbc:AccountingCost"/>
            </cbc:AccountingCost>
         </xsl:if>
         <xsl:if test="cbc:BuyerReference">
            <cbc:BuyerReference>
               <xsl:value-of select="cbc:BuyerReference"/>
            </cbc:BuyerReference>
         </xsl:if>
         <xsl:apply-templates select="cac:InvoicePeriod">
            <xsl:with-param name="CN" select="current()"/>
            <xsl:with-param name="CNP" select="position()"/>
         </xsl:apply-templates>
         <xsl:apply-templates select="cac:OrderReference">
            <xsl:with-param name="CN" select="current()"/>
            <xsl:with-param name="CNP" select="position()"/>
         </xsl:apply-templates>
         <xsl:apply-templates select="cac:BillingReference">
            <xsl:with-param name="CN" select="current()"/>
            <xsl:with-param name="CNP" select="position()"/>
         </xsl:apply-templates>
         <xsl:apply-templates select="cac:DespatchDocumentReference">
            <xsl:with-param name="CN" select="current()"/>
            <xsl:with-param name="CNP" select="position()"/>
         </xsl:apply-templates>
         <xsl:apply-templates select="cac:ReceiptDocumentReference">
            <xsl:with-param name="CN" select="current()"/>
            <xsl:with-param name="CNP" select="position()"/>
         </xsl:apply-templates>
         <xsl:apply-templates select="cac:ContractDocumentReference">
            <xsl:with-param name="CN" select="current()"/>
            <xsl:with-param name="CNP" select="position()"/>
         </xsl:apply-templates>
         <xsl:apply-templates select="cac:AdditionalDocumentReference" mode="AdditionalDocumentReferences">
            <xsl:with-param name="CN" select="current()"/>
            <xsl:with-param name="CNP" select="position()"/>
         </xsl:apply-templates>
         <xsl:apply-templates select="cac:OriginatorDocumentReference" mode="CIG">
            <xsl:with-param name="CN" select="current()"/>
            <xsl:with-param name="CNP" select="position()"/>
         </xsl:apply-templates>
         <xsl:apply-templates select="cac:ProjectReference" mode="CUP">
            <xsl:with-param name="CN" select="current()"/>
            <xsl:with-param name="CNP" select="position()"/>
         </xsl:apply-templates>
         <xsl:apply-templates select="cac:AccountingSupplierParty">
            <xsl:with-param name="CN" select="current()"/>
            <xsl:with-param name="CNP" select="position()"/>
         </xsl:apply-templates>
         <xsl:apply-templates select="cac:AccountingCustomerParty">
            <xsl:with-param name="CN" select="current()"/>
            <xsl:with-param name="CNP" select="position()"/>
         </xsl:apply-templates>
         <xsl:apply-templates select="cac:PayeeParty">
            <xsl:with-param name="CN" select="current()"/>
            <xsl:with-param name="CNP" select="position()"/>
         </xsl:apply-templates>
         <xsl:apply-templates select="cac:TaxRepresentativeParty">
            <xsl:with-param name="CN" select="current()"/>
            <xsl:with-param name="CNP" select="position()"/>
         </xsl:apply-templates>
         <xsl:apply-templates select="cac:Delivery">
            <xsl:with-param name="CN" select="current()"/>
            <xsl:with-param name="CNP" select="position()"/>
         </xsl:apply-templates>
         <xsl:apply-templates select="cac:PaymentMeans">
            <xsl:with-param name="CN" select="current()"/>
            <xsl:with-param name="CNP" select="position()"/>
         </xsl:apply-templates>
         <xsl:apply-templates select="cac:PaymentTerms">
            <xsl:with-param name="CN" select="current()"/>
            <xsl:with-param name="CNP" select="position()"/>
         </xsl:apply-templates>
         <xsl:apply-templates select="cac:AllowanceCharge">
            <xsl:with-param name="CN" select="current()"/>
            <xsl:with-param name="CNP" select="position()"/>
         </xsl:apply-templates>
         <xsl:apply-templates select="cac:TaxTotal">
            <xsl:with-param name="CN" select="current()"/>
            <xsl:with-param name="CNP" select="position()"/>
         </xsl:apply-templates>
         <xsl:apply-templates select="cac:LegalMonetaryTotal">
            <xsl:with-param name="CN" select="current()"/>
            <xsl:with-param name="CNP" select="position()"/>
         </xsl:apply-templates>
         <xsl:apply-templates select="cac:InvoiceLine">
            <xsl:with-param name="CN" select="current()"/>
            <xsl:with-param name="CNP" select="position()"/>
         </xsl:apply-templates>
      </Invoice>
   </xsl:template>

   <xsl:template match="/">
      <xsl:apply-templates select="/in:Invoice"/>
   </xsl:template>
</xsl:stylesheet>