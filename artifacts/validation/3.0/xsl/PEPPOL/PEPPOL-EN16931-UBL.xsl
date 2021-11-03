<?xml version="1.0" encoding="utf-8" standalone="yes"?>
<axsl:stylesheet xmlns:axsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:saxon="http://saxon.sf.net/" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:schold="http://www.ascc.net/xml/schematron" xmlns:iso="http://purl.oclc.org/dsdl/schematron" xmlns:xhtml="http://www.w3.org/1999/xhtml" xmlns:cbc="urn:oasis:names:specification:ubl:schema:xsd:CommonBasicComponents-2" xmlns:cac="urn:oasis:names:specification:ubl:schema:xsd:CommonAggregateComponents-2" xmlns:ubl-creditnote="urn:oasis:names:specification:ubl:schema:xsd:CreditNote-2" xmlns:ubl-invoice="urn:oasis:names:specification:ubl:schema:xsd:Invoice-2" xmlns:u="utils" version="2.0"><!--Implementers: please note that overriding process-prolog or process-root is 
    the preferred method for meta-stylesheets to use where possible. -->

   <axsl:param name="archiveDirParameter"/>
   <axsl:param name="archiveNameParameter"/>
   <axsl:param name="fileNameParameter"/>
   <axsl:param name="fileDirParameter"/>
   <axsl:variable name="document-uri">
      <axsl:value-of select="document-uri(/)"/>
   </axsl:variable>

<!--PHASES-->


<!--PROLOG-->

   <axsl:output xmlns:svrl="http://purl.oclc.org/dsdl/svrl" method="xml" omit-xml-declaration="no" standalone="yes" indent="yes"/>

<!--XSD TYPES FOR XSLT2-->


<!--KEYS AND FUNCTIONS-->

   <function xmlns="http://www.w3.org/1999/XSL/Transform" name="u:gln" as="xs:boolean">
    
      <param name="val"/>
    
      <variable name="length" select="string-length($val) - 1"/>
    
      <variable name="digits" select="reverse(for $i in string-to-codepoints(substring($val, 0, $length + 1)) return $i - 48)"/>
    
      <variable name="weightedSum" select="sum(for $i in (0 to $length - 1) return $digits[$i + 1] * (1 + ((($i + 1) mod 2) * 2)))"/>
    
      <value-of select="(10 - ($weightedSum mod 10)) mod 10 = number(substring($val, $length + 1, 1))"/>
  
   </function>
   <function xmlns="http://www.w3.org/1999/XSL/Transform" name="u:slack" as="xs:boolean">
    
      <param name="exp" as="xs:decimal"/>
    
      <param name="val" as="xs:decimal"/>
    
      <param name="slack" as="xs:decimal"/>
    
      <value-of select="xs:decimal($exp + $slack) &gt;= $val and xs:decimal($exp - $slack) &lt;= $val"/>
  
   </function>
   <function xmlns="http://www.w3.org/1999/XSL/Transform" name="u:mod11" as="xs:boolean">
    
      <param name="val"/>
    
      <variable name="length" select="string-length($val) - 1"/>
    
      <variable name="digits" select="reverse(for $i in string-to-codepoints(substring($val, 0, $length + 1)) return $i - 48)"/>
    
      <variable name="weightedSum" select="sum(for $i in (0 to $length - 1) return $digits[$i + 1] * (($i mod 6) + 2))"/>
    
      <value-of select="number($val) &gt; 0 and (11 - ($weightedSum mod 11)) mod 11 = number(substring($val, $length + 1, 1))"/>
  
   </function>
   <function xmlns="http://www.w3.org/1999/XSL/Transform" name="u:mod97-0208" as="xs:boolean">
    
      <param name="val"/>
    
      <variable name="checkdigits" select="substring($val,9,2)"/>
    
      <variable name="calculated_digits" select="xs:string(97 - (xs:integer(substring($val,1,8)) mod 97))"/>
    
      <value-of select="number($checkdigits) = number($calculated_digits)"/>
  
   </function>
   <function xmlns="http://www.w3.org/1999/XSL/Transform" name="u:checkCodiceIPA" as="xs:boolean">
    
      <param name="arg" as="xs:string?"/>
    
      <variable name="allowed-characters">ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789</variable>
    
      <sequence select="if ( (string-length(translate($arg, $allowed-characters, '')) = 0) and (string-length($arg) = 6) ) then true() else false()"/>
  
   </function>
   <function xmlns="http://www.w3.org/1999/XSL/Transform" name="u:checkCF" as="xs:boolean">
    
      <param name="arg" as="xs:string?"/>
    
      <sequence select="   if ( (string-length($arg) = 16) or (string-length($arg) = 11) )      then    (    if ((string-length($arg) = 16))     then    (     if (u:checkCF16($arg))      then     (      true()     )     else     (      false()     )    )    else    (     if(($arg castable as xsd:integer)) then true() else false()       )   )   else   (    false()   )   "/>
  
   </function>
   <function xmlns="http://www.w3.org/1999/XSL/Transform" name="u:checkCF16" as="xs:boolean">
    
      <param name="arg" as="xs:string?"/>
    
      <variable name="allowed-characters">ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz</variable>
    
      <sequence select="     if (  (string-length(translate(substring($arg,1,6), $allowed-characters, '')) = 0) and         (substring($arg,7,2) castable as xsd:integer) and        (string-length(translate(substring($arg,9,1), $allowed-characters, '')) = 0) and        (substring($arg,10,2) castable as xsd:integer) and         (substring($arg,12,3) castable as xsd:string) and        (substring($arg,15,1) castable as xsd:integer) and         (string-length(translate(substring($arg,16,1), $allowed-characters, '')) = 0)      )      then true()     else false()     "/>
  
   </function>
   <function xmlns="http://www.w3.org/1999/XSL/Transform" name="u:checkPIVAseIT" as="xs:boolean">
    
      <param name="arg" as="xs:string"/>
    
      <variable name="paese" select="substring($arg,1,2)"/>
    
      <variable name="codice" select="substring($arg,3)"/>
    
      <sequence select="       if ( $paese = 'IT' or $paese = 'it' )    then    (     if ( ( string-length($codice) = 11 ) and ( if (u:checkPIVA($codice)!=0) then false() else true() ))     then      (      true()     )     else     (      false()     )    )    else    (     true()    )      "/>
  
   </function>
   <function xmlns="http://www.w3.org/1999/XSL/Transform" name="u:checkPIVA" as="xs:integer">
    
      <param name="arg" as="xs:string?"/>
    
      <sequence select="     if (not($arg castable as xsd:integer))       then 1      else ( u:addPIVA($arg,xs:integer(0)) mod 10 )"/>
  
   </function>
   <function xmlns="http://www.w3.org/1999/XSL/Transform" name="u:addPIVA" as="xs:integer">
    
      <param name="arg" as="xs:string"/>
    
      <param name="pari" as="xs:integer"/>
    
      <variable name="tappo" select="if (not($arg castable as xsd:integer)) then 0 else 1"/>
    
      <variable name="mapper" select="if ($tappo = 0) then 0 else                    ( if ($pari = 1)                     then ( xs:integer(substring('0246813579', ( xs:integer(substring($arg,1,1)) +1 ) ,1)) )                     else ( xs:integer(substring($arg,1,1) ) )                   )"/>
    
      <sequence select="if ($tappo = 0) then $mapper else ( xs:integer($mapper) + u:addPIVA(substring(xs:string($arg),2), (if($pari=0) then 1 else 0) ) )"/>
  
   </function>
   <function xmlns="http://www.w3.org/1999/XSL/Transform" name="u:TinVerification" as="xs:boolean">
    
      <param name="val" as="xs:string"/>
    
      <variable name="digits" select="    for $ch in string-to-codepoints($val)    return codepoints-to-string($ch)"/>
    
      <variable name="checksum" select="    (number($digits[8])*2) +    (number($digits[7])*4) +    (number($digits[6])*8) +    (number($digits[5])*16) +    (number($digits[4])*32) +    (number($digits[3])*64) +    (number($digits[2])*128) +    (number($digits[1])*256) "/>
    
      <value-of select="($checksum  mod 11) mod 10 = number($digits[9])"/>
  
   </function>

<!--DEFAULT RULES-->


<!--MODE: SCHEMATRON-SELECT-FULL-PATH-->
<!--This mode can be used to generate an ugly though full XPath for locators-->

   <axsl:template match="*" mode="schematron-select-full-path">
      <axsl:apply-templates select="." mode="schematron-get-full-path"/>
   </axsl:template>

<!--MODE: SCHEMATRON-FULL-PATH-->
<!--This mode can be used to generate an ugly though full XPath for locators-->

   <axsl:template match="*" mode="schematron-get-full-path">
      <axsl:apply-templates select="parent::*" mode="schematron-get-full-path"/>
      <axsl:text>/</axsl:text>
      <axsl:choose>
         <axsl:when test="namespace-uri()=''">
            <axsl:value-of select="name()"/>
         </axsl:when>
         <axsl:otherwise>
            <axsl:text>*:</axsl:text>
            <axsl:value-of select="local-name()"/>
            <axsl:text>[namespace-uri()='</axsl:text>
            <axsl:value-of select="namespace-uri()"/>
            <axsl:text>']</axsl:text>
         </axsl:otherwise>
      </axsl:choose>
      <axsl:variable name="preceding" select="count(preceding-sibling::*[local-name()=local-name(current())                                   and namespace-uri() = namespace-uri(current())])"/>
      <axsl:text>[</axsl:text>
      <axsl:value-of select="1+ $preceding"/>
      <axsl:text>]</axsl:text>
   </axsl:template>
   <axsl:template match="@*" mode="schematron-get-full-path">
      <axsl:apply-templates select="parent::*" mode="schematron-get-full-path"/>
      <axsl:text>/</axsl:text>
      <axsl:choose>
         <axsl:when test="namespace-uri()=''">@<axsl:value-of select="name()"/>
         </axsl:when>
         <axsl:otherwise>
            <axsl:text>@*[local-name()='</axsl:text>
            <axsl:value-of select="local-name()"/>
            <axsl:text>' and namespace-uri()='</axsl:text>
            <axsl:value-of select="namespace-uri()"/>
            <axsl:text>']</axsl:text>
         </axsl:otherwise>
      </axsl:choose>
   </axsl:template>

<!--MODE: SCHEMATRON-FULL-PATH-2-->
<!--This mode can be used to generate prefixed XPath for humans-->

   <axsl:template match="node() | @*" mode="schematron-get-full-path-2">
      <axsl:for-each select="ancestor-or-self::*">
         <axsl:text>/</axsl:text>
         <axsl:value-of select="name(.)"/>
         <axsl:if test="preceding-sibling::*[name(.)=name(current())]">
            <axsl:text>[</axsl:text>
            <axsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1"/>
            <axsl:text>]</axsl:text>
         </axsl:if>
      </axsl:for-each>
      <axsl:if test="not(self::*)">
         <axsl:text/>/@<axsl:value-of select="name(.)"/>
      </axsl:if>
   </axsl:template><!--MODE: SCHEMATRON-FULL-PATH-3-->
<!--This mode can be used to generate prefixed XPath for humans 
	(Top-level element has index)-->

   <axsl:template match="node() | @*" mode="schematron-get-full-path-3">
      <axsl:for-each select="ancestor-or-self::*">
         <axsl:text>/</axsl:text>
         <axsl:value-of select="name(.)"/>
         <axsl:if test="parent::*">
            <axsl:text>[</axsl:text>
            <axsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1"/>
            <axsl:text>]</axsl:text>
         </axsl:if>
      </axsl:for-each>
      <axsl:if test="not(self::*)">
         <axsl:text/>/@<axsl:value-of select="name(.)"/>
      </axsl:if>
   </axsl:template>

<!--MODE: GENERATE-ID-FROM-PATH -->

   <axsl:template match="/" mode="generate-id-from-path"/>
   <axsl:template match="text()" mode="generate-id-from-path">
      <axsl:apply-templates select="parent::*" mode="generate-id-from-path"/>
      <axsl:value-of select="concat('.text-', 1+count(preceding-sibling::text()), '-')"/>
   </axsl:template>
   <axsl:template match="comment()" mode="generate-id-from-path">
      <axsl:apply-templates select="parent::*" mode="generate-id-from-path"/>
      <axsl:value-of select="concat('.comment-', 1+count(preceding-sibling::comment()), '-')"/>
   </axsl:template>
   <axsl:template match="processing-instruction()" mode="generate-id-from-path">
      <axsl:apply-templates select="parent::*" mode="generate-id-from-path"/>
      <axsl:value-of select="concat('.processing-instruction-', 1+count(preceding-sibling::processing-instruction()), '-')"/>
   </axsl:template>
   <axsl:template match="@*" mode="generate-id-from-path">
      <axsl:apply-templates select="parent::*" mode="generate-id-from-path"/>
      <axsl:value-of select="concat('.@', name())"/>
   </axsl:template>
   <axsl:template match="*" mode="generate-id-from-path" priority="-0.5">
      <axsl:apply-templates select="parent::*" mode="generate-id-from-path"/>
      <axsl:text>.</axsl:text>
      <axsl:value-of select="concat('.',name(),'-',1+count(preceding-sibling::*[name()=name(current())]),'-')"/>
   </axsl:template>

<!--MODE: GENERATE-ID-2 -->

   <axsl:template match="/" mode="generate-id-2">U</axsl:template>
   <axsl:template match="*" mode="generate-id-2" priority="2">
      <axsl:text>U</axsl:text>
      <axsl:number level="multiple" count="*"/>
   </axsl:template>
   <axsl:template match="node()" mode="generate-id-2">
      <axsl:text>U.</axsl:text>
      <axsl:number level="multiple" count="*"/>
      <axsl:text>n</axsl:text>
      <axsl:number count="node()"/>
   </axsl:template>
   <axsl:template match="@*" mode="generate-id-2">
      <axsl:text>U.</axsl:text>
      <axsl:number level="multiple" count="*"/>
      <axsl:text>_</axsl:text>
      <axsl:value-of select="string-length(local-name(.))"/>
      <axsl:text>_</axsl:text>
      <axsl:value-of select="translate(name(),':','.')"/>
   </axsl:template><!--Strip characters-->
   <axsl:template match="text()" priority="-1"/>

<!--SCHEMA SETUP-->

   <axsl:template match="/">
      <svrl:schematron-output xmlns:svrl="http://purl.oclc.org/dsdl/svrl" title="Rules for PEPPOL BIS 3.0 Billing" schemaVersion="iso">
         <axsl:comment>
            <axsl:value-of select="$archiveDirParameter"/>   
		 <axsl:value-of select="$archiveNameParameter"/>  
		 <axsl:value-of select="$fileNameParameter"/>  
		 <axsl:value-of select="$fileDirParameter"/>
         </axsl:comment>
         <svrl:ns-prefix-in-attribute-values uri="urn:oasis:names:specification:ubl:schema:xsd:CommonBasicComponents-2" prefix="cbc"/>
         <svrl:ns-prefix-in-attribute-values uri="urn:oasis:names:specification:ubl:schema:xsd:CommonAggregateComponents-2" prefix="cac"/>
         <svrl:ns-prefix-in-attribute-values uri="urn:oasis:names:specification:ubl:schema:xsd:CreditNote-2" prefix="ubl-creditnote"/>
         <svrl:ns-prefix-in-attribute-values uri="urn:oasis:names:specification:ubl:schema:xsd:Invoice-2" prefix="ubl-invoice"/>
         <svrl:ns-prefix-in-attribute-values uri="http://www.w3.org/2001/XMLSchema" prefix="xs"/>
         <svrl:ns-prefix-in-attribute-values uri="utils" prefix="u"/>
         <svrl:active-pattern>
            <axsl:attribute name="document">
               <axsl:value-of select="document-uri(/)"/>
            </axsl:attribute>
            <axsl:apply-templates/>
         </svrl:active-pattern>
         <axsl:apply-templates select="/" mode="M21"/>
         <svrl:active-pattern>
            <axsl:attribute name="document">
               <axsl:value-of select="document-uri(/)"/>
            </axsl:attribute>
            <axsl:apply-templates/>
         </svrl:active-pattern>
         <axsl:apply-templates select="/" mode="M22"/>
         <svrl:active-pattern>
            <axsl:attribute name="document">
               <axsl:value-of select="document-uri(/)"/>
            </axsl:attribute>
            <axsl:apply-templates/>
         </svrl:active-pattern>
         <axsl:apply-templates select="/" mode="M23"/>
         <svrl:active-pattern>
            <axsl:attribute name="document">
               <axsl:value-of select="document-uri(/)"/>
            </axsl:attribute>
            <axsl:apply-templates/>
         </svrl:active-pattern>
         <axsl:apply-templates select="/" mode="M24"/>
         <svrl:active-pattern>
            <axsl:attribute name="document">
               <axsl:value-of select="document-uri(/)"/>
            </axsl:attribute>
            <axsl:apply-templates/>
         </svrl:active-pattern>
         <axsl:apply-templates select="/" mode="M25"/>
         <svrl:active-pattern>
            <axsl:attribute name="document">
               <axsl:value-of select="document-uri(/)"/>
            </axsl:attribute>
            <axsl:apply-templates/>
         </svrl:active-pattern>
         <axsl:apply-templates select="/" mode="M26"/>
         <svrl:active-pattern>
            <axsl:attribute name="document">
               <axsl:value-of select="document-uri(/)"/>
            </axsl:attribute>
            <axsl:apply-templates/>
         </svrl:active-pattern>
         <axsl:apply-templates select="/" mode="M32"/>
         <svrl:active-pattern>
            <axsl:attribute name="document">
               <axsl:value-of select="document-uri(/)"/>
            </axsl:attribute>
            <axsl:apply-templates/>
         </svrl:active-pattern>
         <axsl:apply-templates select="/" mode="M33"/>
         <svrl:active-pattern>
            <axsl:attribute name="document">
               <axsl:value-of select="document-uri(/)"/>
            </axsl:attribute>
            <axsl:apply-templates/>
         </svrl:active-pattern>
         <axsl:apply-templates select="/" mode="M34"/>
         <svrl:active-pattern>
            <axsl:attribute name="document">
               <axsl:value-of select="document-uri(/)"/>
            </axsl:attribute>
            <axsl:apply-templates/>
         </svrl:active-pattern>
         <axsl:apply-templates select="/" mode="M35"/>
         <svrl:active-pattern>
            <axsl:attribute name="document">
               <axsl:value-of select="document-uri(/)"/>
            </axsl:attribute>
            <axsl:apply-templates/>
         </svrl:active-pattern>
         <axsl:apply-templates select="/" mode="M36"/>
      </svrl:schematron-output>
   </axsl:template>

<!--SCHEMATRON PATTERNS-->

   <svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">Rules for PEPPOL BIS 3.0 Billing</svrl:text>
   <axsl:param name="profile" select="       if (/*/cbc:ProfileID and matches(normalize-space(/*/cbc:ProfileID), 'urn:fdc:peppol.eu:2017:poacc:billing:([0-9]{2}):1.0')) then         tokenize(normalize-space(/*/cbc:ProfileID), ':')[7]       else         'Unknown'"/>
   <axsl:param name="supplierCountry" select="       if (/*/cac:AccountingSupplierParty/cac:Party/cac:PartyTaxScheme[cac:TaxScheme/cbc:ID = 'VAT']/substring(cbc:CompanyID, 1, 2)) then         upper-case(normalize-space(/*/cac:AccountingSupplierParty/cac:Party/cac:PartyTaxScheme[cac:TaxScheme/cbc:ID = 'VAT']/substring(cbc:CompanyID, 1, 2)))       else         if (/*/cac:TaxRepresentativeParty/cac:PartyTaxScheme[cac:TaxScheme/cbc:ID = 'VAT']/substring(cbc:CompanyID, 1, 2)) then           upper-case(normalize-space(/*/cac:TaxRepresentativeParty/cac:PartyTaxScheme[cac:TaxScheme/cbc:ID = 'VAT']/substring(cbc:CompanyID, 1, 2)))         else           if (/*/cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode) then             upper-case(normalize-space(/*/cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode))           else             'XX'"/>
   <axsl:param name="customerCountry" select="   if (/*/cac:AccountingCustomerParty/cac:Party/cac:PartyTaxScheme[cac:TaxScheme/cbc:ID = 'VAT']/substring(cbc:CompanyID, 1, 2)) then   upper-case(normalize-space(/*/cac:AccountingCustomerParty/cac:Party/cac:PartyTaxScheme[cac:TaxScheme/cbc:ID = 'VAT']/substring(cbc:CompanyID, 1, 2)))   else   if (/*/cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode) then   upper-case(normalize-space(/*/cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode))   else   'XX'"/>
   <axsl:param name="documentCurrencyCode" select="/*/cbc:DocumentCurrencyCode"/>

<!--PATTERN -->


	<!--RULE -->

   <axsl:template match="//*[not(*) and not(normalize-space())]" priority="1000" mode="M21">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="//*[not(*) and not(normalize-space())]"/>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="false()"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="false()">
               <axsl:attribute name="id">PEPPOL-EN16931-R008</axsl:attribute>
               <axsl:attribute name="flag">fatal</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-select-full-path"/>
               </axsl:attribute>
               <svrl:text>Document MUST not contain empty elements.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>
      <axsl:apply-templates select="@*|*" mode="M21"/>
   </axsl:template>
   <axsl:template match="text()" priority="-1" mode="M21"/>
   <axsl:template match="@*|node()" priority="-2" mode="M21">
      <axsl:apply-templates select="@*|*" mode="M21"/>
   </axsl:template>

<!--PATTERN -->


	<!--RULE -->

   <axsl:template match="ubl-creditnote:CreditNote | ubl-invoice:Invoice" priority="1022" mode="M22">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="ubl-creditnote:CreditNote | ubl-invoice:Invoice"/>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="cbc:ProfileID"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="cbc:ProfileID">
               <axsl:attribute name="id">PEPPOL-EN16931-R001</axsl:attribute>
               <axsl:attribute name="flag">fatal</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-select-full-path"/>
               </axsl:attribute>
               <svrl:text>Business process MUST be provided.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="$profile != 'Unknown'"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="$profile != 'Unknown'">
               <axsl:attribute name="id">PEPPOL-EN16931-R007</axsl:attribute>
               <axsl:attribute name="flag">fatal</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-select-full-path"/>
               </axsl:attribute>
               <svrl:text>Business process MUST be in the format 'urn:fdc:peppol.eu:2017:poacc:billing:NN:1.0' where NN indicates the process number.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="count(cbc:Note) &lt;= 1"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="count(cbc:Note) &lt;= 1">
               <axsl:attribute name="id">PEPPOL-EN16931-R002</axsl:attribute>
               <axsl:attribute name="flag">fatal</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-select-full-path"/>
               </axsl:attribute>
               <svrl:text>No more than one note is allowed on document level.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="cbc:BuyerReference or cac:OrderReference/cbc:ID"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="cbc:BuyerReference or cac:OrderReference/cbc:ID">
               <axsl:attribute name="id">PEPPOL-EN16931-R003</axsl:attribute>
               <axsl:attribute name="flag">fatal</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-select-full-path"/>
               </axsl:attribute>
               <svrl:text>A buyer reference or purchase order reference MUST be provided.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="starts-with(normalize-space(cbc:CustomizationID/text()), 'urn:cen.eu:en16931:2017#compliant#urn:fdc:peppol.eu:2017:poacc:billing:3.0')"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="starts-with(normalize-space(cbc:CustomizationID/text()), 'urn:cen.eu:en16931:2017#compliant#urn:fdc:peppol.eu:2017:poacc:billing:3.0')">
               <axsl:attribute name="id">PEPPOL-EN16931-R004</axsl:attribute>
               <axsl:attribute name="flag">fatal</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-select-full-path"/>
               </axsl:attribute>
               <svrl:text>Specification identifier MUST have the value 'urn:cen.eu:en16931:2017#compliant#urn:fdc:peppol.eu:2017:poacc:billing:3.0'.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="count(cac:TaxTotal[cac:TaxSubtotal]) = 1"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="count(cac:TaxTotal[cac:TaxSubtotal]) = 1">
               <axsl:attribute name="id">PEPPOL-EN16931-R053</axsl:attribute>
               <axsl:attribute name="flag">fatal</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-select-full-path"/>
               </axsl:attribute>
               <svrl:text>Only one tax total with tax subtotals MUST be provided.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="count(cac:TaxTotal[not(cac:TaxSubtotal)]) = (if (cbc:TaxCurrencyCode) then 1 else 0)"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="count(cac:TaxTotal[not(cac:TaxSubtotal)]) = (if (cbc:TaxCurrencyCode) then 1 else 0)">
               <axsl:attribute name="id">PEPPOL-EN16931-R054</axsl:attribute>
               <axsl:attribute name="flag">fatal</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-select-full-path"/>
               </axsl:attribute>
               <svrl:text>Only one tax total without tax subtotals MUST be provided when tax currency code is provided.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cbc:TaxCurrencyCode) or (cac:TaxTotal/cbc:TaxAmount[@currencyID=normalize-space(../../cbc:TaxCurrencyCode)] &lt;= 0 and cac:TaxTotal/cbc:TaxAmount[@currencyID=normalize-space(../../cbc:DocumentCurrencyCode)] &lt;= 0) or (cac:TaxTotal/cbc:TaxAmount[@currencyID=normalize-space(../../cbc:TaxCurrencyCode)] &gt;= 0 and cac:TaxTotal/cbc:TaxAmount[@currencyID=normalize-space(../../cbc:DocumentCurrencyCode)] &gt;= 0) "/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cbc:TaxCurrencyCode) or (cac:TaxTotal/cbc:TaxAmount[@currencyID=normalize-space(../../cbc:TaxCurrencyCode)] &lt;= 0 and cac:TaxTotal/cbc:TaxAmount[@currencyID=normalize-space(../../cbc:DocumentCurrencyCode)] &lt;= 0) or (cac:TaxTotal/cbc:TaxAmount[@currencyID=normalize-space(../../cbc:TaxCurrencyCode)] &gt;= 0 and cac:TaxTotal/cbc:TaxAmount[@currencyID=normalize-space(../../cbc:DocumentCurrencyCode)] &gt;= 0)">
               <axsl:attribute name="id">PEPPOL-EN16931-R055</axsl:attribute>
               <axsl:attribute name="flag">fatal</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-select-full-path"/>
               </axsl:attribute>
               <svrl:text>Invoice total VAT amount and Invoice total VAT amount in accounting currency MUST have the same operational sign</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="(count(cac:AdditionalDocumentReference[cbc:DocumentTypeCode='130']) &lt;= 1)"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="(count(cac:AdditionalDocumentReference[cbc:DocumentTypeCode='130']) &lt;= 1)">
               <axsl:attribute name="id">PEPPOL-EN16931-R006</axsl:attribute>
               <axsl:attribute name="flag">fatal</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-select-full-path"/>
               </axsl:attribute>
               <svrl:text>Only one invoiced object is allowed on document level</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="(count(cac:AdditionalDocumentReference[cbc:DocumentTypeCode='50']) &lt;= 1)"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="(count(cac:AdditionalDocumentReference[cbc:DocumentTypeCode='50']) &lt;= 1)">
               <axsl:attribute name="id">PEPPOL-EN16931-R080</axsl:attribute>
               <axsl:attribute name="flag">fatal</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-select-full-path"/>
               </axsl:attribute>
               <svrl:text>Only one project reference is allowed on document level</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>
      <axsl:apply-templates select="@*|*" mode="M22"/>
   </axsl:template>

	<!--RULE -->

   <axsl:template match="cbc:TaxCurrencyCode" priority="1021" mode="M22">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="cbc:TaxCurrencyCode"/>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(normalize-space(text()) = normalize-space(../cbc:DocumentCurrencyCode/text()))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(normalize-space(text()) = normalize-space(../cbc:DocumentCurrencyCode/text()))">
               <axsl:attribute name="id">PEPPOL-EN16931-R005</axsl:attribute>
               <axsl:attribute name="flag">fatal</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-select-full-path"/>
               </axsl:attribute>
               <svrl:text>VAT accounting currency code MUST be different from invoice currency code when provided.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>
      <axsl:apply-templates select="@*|*" mode="M22"/>
   </axsl:template>

	<!--RULE -->

   <axsl:template match="cac:AccountingCustomerParty/cac:Party" priority="1020" mode="M22">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="cac:AccountingCustomerParty/cac:Party"/>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="cbc:EndpointID"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="cbc:EndpointID">
               <axsl:attribute name="id">PEPPOL-EN16931-R010</axsl:attribute>
               <axsl:attribute name="flag">fatal</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-select-full-path"/>
               </axsl:attribute>
               <svrl:text>Buyer electronic address MUST be provided</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>
      <axsl:apply-templates select="@*|*" mode="M22"/>
   </axsl:template>

	<!--RULE -->

   <axsl:template match="cac:AccountingSupplierParty/cac:Party" priority="1019" mode="M22">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="cac:AccountingSupplierParty/cac:Party"/>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="cbc:EndpointID"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="cbc:EndpointID">
               <axsl:attribute name="id">PEPPOL-EN16931-R020</axsl:attribute>
               <axsl:attribute name="flag">fatal</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-select-full-path"/>
               </axsl:attribute>
               <svrl:text>Seller electronic address MUST be provided</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>
      <axsl:apply-templates select="@*|*" mode="M22"/>
   </axsl:template>

	<!--RULE -->

   <axsl:template match="ubl-invoice:Invoice/cac:AllowanceCharge[cbc:MultiplierFactorNumeric and not(cbc:BaseAmount)] | ubl-invoice:Invoice/cac:InvoiceLine/cac:AllowanceCharge[cbc:MultiplierFactorNumeric and not(cbc:BaseAmount)] | ubl-creditnote:CreditNote/cac:AllowanceCharge[cbc:MultiplierFactorNumeric and not(cbc:BaseAmount)] | ubl-creditnote:CreditNote/cac:CreditNoteLine/cac:AllowanceCharge[cbc:MultiplierFactorNumeric and not(cbc:BaseAmount)]" priority="1018" mode="M22">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="ubl-invoice:Invoice/cac:AllowanceCharge[cbc:MultiplierFactorNumeric and not(cbc:BaseAmount)] | ubl-invoice:Invoice/cac:InvoiceLine/cac:AllowanceCharge[cbc:MultiplierFactorNumeric and not(cbc:BaseAmount)] | ubl-creditnote:CreditNote/cac:AllowanceCharge[cbc:MultiplierFactorNumeric and not(cbc:BaseAmount)] | ubl-creditnote:CreditNote/cac:CreditNoteLine/cac:AllowanceCharge[cbc:MultiplierFactorNumeric and not(cbc:BaseAmount)]"/>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="false()"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="false()">
               <axsl:attribute name="id">PEPPOL-EN16931-R041</axsl:attribute>
               <axsl:attribute name="flag">fatal</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-select-full-path"/>
               </axsl:attribute>
               <svrl:text>Allowance/charge base amount MUST be provided when allowance/charge percentage is provided.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>
      <axsl:apply-templates select="@*|*" mode="M22"/>
   </axsl:template>

	<!--RULE -->

   <axsl:template match="ubl-invoice:Invoice/cac:AllowanceCharge[not(cbc:MultiplierFactorNumeric) and cbc:BaseAmount] | ubl-invoice:Invoice/cac:InvoiceLine/cac:AllowanceCharge[not(cbc:MultiplierFactorNumeric) and cbc:BaseAmount] | ubl-creditnote:CreditNote/cac:AllowanceCharge[not(cbc:MultiplierFactorNumeric) and cbc:BaseAmount] | ubl-creditnote:CreditNote/cac:CreditNoteLine/cac:AllowanceCharge[not(cbc:MultiplierFactorNumeric) and cbc:BaseAmount]" priority="1017" mode="M22">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="ubl-invoice:Invoice/cac:AllowanceCharge[not(cbc:MultiplierFactorNumeric) and cbc:BaseAmount] | ubl-invoice:Invoice/cac:InvoiceLine/cac:AllowanceCharge[not(cbc:MultiplierFactorNumeric) and cbc:BaseAmount] | ubl-creditnote:CreditNote/cac:AllowanceCharge[not(cbc:MultiplierFactorNumeric) and cbc:BaseAmount] | ubl-creditnote:CreditNote/cac:CreditNoteLine/cac:AllowanceCharge[not(cbc:MultiplierFactorNumeric) and cbc:BaseAmount]"/>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="false()"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="false()">
               <axsl:attribute name="id">PEPPOL-EN16931-R042</axsl:attribute>
               <axsl:attribute name="flag">fatal</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-select-full-path"/>
               </axsl:attribute>
               <svrl:text>Allowance/charge percentage MUST be provided when allowance/charge base amount is provided.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>
      <axsl:apply-templates select="@*|*" mode="M22"/>
   </axsl:template>

	<!--RULE -->

   <axsl:template match="ubl-invoice:Invoice/cac:AllowanceCharge | ubl-invoice:Invoice/cac:InvoiceLine/cac:AllowanceCharge | ubl-creditnote:CreditNote/cac:AllowanceCharge | ubl-creditnote:CreditNote/cac:CreditNoteLine/cac:AllowanceCharge" priority="1016" mode="M22">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="ubl-invoice:Invoice/cac:AllowanceCharge | ubl-invoice:Invoice/cac:InvoiceLine/cac:AllowanceCharge | ubl-creditnote:CreditNote/cac:AllowanceCharge | ubl-creditnote:CreditNote/cac:CreditNoteLine/cac:AllowanceCharge"/>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="           not(cbc:MultiplierFactorNumeric and cbc:BaseAmount) or u:slack(if (cbc:Amount) then             cbc:Amount           else             0, (xs:decimal(cbc:BaseAmount) * xs:decimal(cbc:MultiplierFactorNumeric)) div 100, 0.02)"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cbc:MultiplierFactorNumeric and cbc:BaseAmount) or u:slack(if (cbc:Amount) then cbc:Amount else 0, (xs:decimal(cbc:BaseAmount) * xs:decimal(cbc:MultiplierFactorNumeric)) div 100, 0.02)">
               <axsl:attribute name="id">PEPPOL-EN16931-R040</axsl:attribute>
               <axsl:attribute name="flag">fatal</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-select-full-path"/>
               </axsl:attribute>
               <svrl:text>Allowance/charge amount must equal base amount * percentage/100 if base amount and percentage exists</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="normalize-space(cbc:ChargeIndicator/text()) = 'true' or normalize-space(cbc:ChargeIndicator/text()) = 'false'"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="normalize-space(cbc:ChargeIndicator/text()) = 'true' or normalize-space(cbc:ChargeIndicator/text()) = 'false'">
               <axsl:attribute name="id">PEPPOL-EN16931-R043</axsl:attribute>
               <axsl:attribute name="flag">fatal</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-select-full-path"/>
               </axsl:attribute>
               <svrl:text>Allowance/charge ChargeIndicator value MUST equal 'true' or 'false'</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>
      <axsl:apply-templates select="@*|*" mode="M22"/>
   </axsl:template>

	<!--RULE -->

   <axsl:template match="         cac:PaymentMeans[some $code in tokenize('49 59', '\s')           satisfies normalize-space(cbc:PaymentMeansCode) = $code]" priority="1015" mode="M22">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="         cac:PaymentMeans[some $code in tokenize('49 59', '\s')           satisfies normalize-space(cbc:PaymentMeansCode) = $code]"/>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="cac:PaymentMandate/cbc:ID"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="cac:PaymentMandate/cbc:ID">
               <axsl:attribute name="id">PEPPOL-EN16931-R061</axsl:attribute>
               <axsl:attribute name="flag">fatal</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-select-full-path"/>
               </axsl:attribute>
               <svrl:text>Mandate reference MUST be provided for direct debit.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>
      <axsl:apply-templates select="@*|*" mode="M22"/>
   </axsl:template>

	<!--RULE -->

   <axsl:template match="cbc:Amount | cbc:BaseAmount | cbc:PriceAmount | cac:TaxTotal[cac:TaxSubtotal]/cbc:TaxAmount | cbc:TaxableAmount | cbc:LineExtensionAmount | cbc:TaxExclusiveAmount | cbc:TaxInclusiveAmount | cbc:AllowanceTotalAmount | cbc:ChargeTotalAmount | cbc:PrepaidAmount | cbc:PayableRoundingAmount | cbc:PayableAmount" priority="1014" mode="M22">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="cbc:Amount | cbc:BaseAmount | cbc:PriceAmount | cac:TaxTotal[cac:TaxSubtotal]/cbc:TaxAmount | cbc:TaxableAmount | cbc:LineExtensionAmount | cbc:TaxExclusiveAmount | cbc:TaxInclusiveAmount | cbc:AllowanceTotalAmount | cbc:ChargeTotalAmount | cbc:PrepaidAmount | cbc:PayableRoundingAmount | cbc:PayableAmount"/>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="@currencyID = $documentCurrencyCode"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="@currencyID = $documentCurrencyCode">
               <axsl:attribute name="id">PEPPOL-EN16931-R051</axsl:attribute>
               <axsl:attribute name="flag">fatal</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-select-full-path"/>
               </axsl:attribute>
               <svrl:text>All currencyID attributes must have the same value as the invoice currency code (BT-5), except for the invoice total VAT amount in accounting currency (BT-111).</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>
      <axsl:apply-templates select="@*|*" mode="M22"/>
   </axsl:template>

	<!--RULE -->

   <axsl:template match="ubl-invoice:Invoice[cac:InvoicePeriod/cbc:StartDate]/cac:InvoiceLine/cac:InvoicePeriod/cbc:StartDate | ubl-creditnote:CreditNote[cac:InvoicePeriod/cbc:StartDate]/cac:CreditNoteLine/cac:InvoicePeriod/cbc:StartDate" priority="1013" mode="M22">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="ubl-invoice:Invoice[cac:InvoicePeriod/cbc:StartDate]/cac:InvoiceLine/cac:InvoicePeriod/cbc:StartDate | ubl-creditnote:CreditNote[cac:InvoicePeriod/cbc:StartDate]/cac:CreditNoteLine/cac:InvoicePeriod/cbc:StartDate"/>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="xs:date(text()) &gt;= xs:date(../../../cac:InvoicePeriod/cbc:StartDate)"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="xs:date(text()) &gt;= xs:date(../../../cac:InvoicePeriod/cbc:StartDate)">
               <axsl:attribute name="id">PEPPOL-EN16931-R110</axsl:attribute>
               <axsl:attribute name="flag">fatal</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-select-full-path"/>
               </axsl:attribute>
               <svrl:text>Start date of line period MUST be within invoice period.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>
      <axsl:apply-templates select="@*|*" mode="M22"/>
   </axsl:template>

	<!--RULE -->

   <axsl:template match="ubl-invoice:Invoice[cac:InvoicePeriod/cbc:EndDate]/cac:InvoiceLine/cac:InvoicePeriod/cbc:EndDate | ubl-creditnote:CreditNote[cac:InvoicePeriod/cbc:EndDate]/cac:CreditNoteLine/cac:InvoicePeriod/cbc:EndDate" priority="1012" mode="M22">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="ubl-invoice:Invoice[cac:InvoicePeriod/cbc:EndDate]/cac:InvoiceLine/cac:InvoicePeriod/cbc:EndDate | ubl-creditnote:CreditNote[cac:InvoicePeriod/cbc:EndDate]/cac:CreditNoteLine/cac:InvoicePeriod/cbc:EndDate"/>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="xs:date(text()) &lt;= xs:date(../../../cac:InvoicePeriod/cbc:EndDate)"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="xs:date(text()) &lt;= xs:date(../../../cac:InvoicePeriod/cbc:EndDate)">
               <axsl:attribute name="id">PEPPOL-EN16931-R111</axsl:attribute>
               <axsl:attribute name="flag">fatal</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-select-full-path"/>
               </axsl:attribute>
               <svrl:text>End date of line period MUST be within invoice period.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>
      <axsl:apply-templates select="@*|*" mode="M22"/>
   </axsl:template>

	<!--RULE -->

   <axsl:template match="cac:InvoiceLine | cac:CreditNoteLine" priority="1011" mode="M22">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="cac:InvoiceLine | cac:CreditNoteLine"/>
      <axsl:variable name="lineExtensionAmount" select="           if (cbc:LineExtensionAmount) then             xs:decimal(cbc:LineExtensionAmount)           else             0"/>
      <axsl:variable name="quantity" select="           if (/ubl-invoice:Invoice) then             (if (cbc:InvoicedQuantity) then               xs:decimal(cbc:InvoicedQuantity)             else               1)           else             (if (cbc:CreditedQuantity) then               xs:decimal(cbc:CreditedQuantity)             else               1)"/>
      <axsl:variable name="priceAmount" select="           if (cac:Price/cbc:PriceAmount) then             xs:decimal(cac:Price/cbc:PriceAmount)           else             0"/>
      <axsl:variable name="baseQuantity" select="           if (cac:Price/cbc:BaseQuantity and xs:decimal(cac:Price/cbc:BaseQuantity) != 0) then             xs:decimal(cac:Price/cbc:BaseQuantity)           else             1"/>
      <axsl:variable name="allowancesTotal" select="           if (cac:AllowanceCharge[normalize-space(cbc:ChargeIndicator) = 'false']) then             round(sum(cac:AllowanceCharge[normalize-space(cbc:ChargeIndicator) = 'false']/cbc:Amount/xs:decimal(.)) * 10 * 10) div 100           else             0"/>
      <axsl:variable name="chargesTotal" select="           if (cac:AllowanceCharge[normalize-space(cbc:ChargeIndicator) = 'true']) then             round(sum(cac:AllowanceCharge[normalize-space(cbc:ChargeIndicator) = 'true']/cbc:Amount/xs:decimal(.)) * 10 * 10) div 100           else             0"/>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="u:slack($lineExtensionAmount, ($quantity * ($priceAmount div $baseQuantity)) + $chargesTotal - $allowancesTotal, 0.02)"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="u:slack($lineExtensionAmount, ($quantity * ($priceAmount div $baseQuantity)) + $chargesTotal - $allowancesTotal, 0.02)">
               <axsl:attribute name="id">PEPPOL-EN16931-R120</axsl:attribute>
               <axsl:attribute name="flag">fatal</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-select-full-path"/>
               </axsl:attribute>
               <svrl:text>Invoice line net amount MUST equal (Invoiced quantity * (Item net price/item price base quantity) + Sum of invoice line charge amount - sum of invoice line allowance amount</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:Price/cbc:BaseQuantity) or xs:decimal(cac:Price/cbc:BaseQuantity) &gt; 0"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:Price/cbc:BaseQuantity) or xs:decimal(cac:Price/cbc:BaseQuantity) &gt; 0">
               <axsl:attribute name="id">PEPPOL-EN16931-R121</axsl:attribute>
               <axsl:attribute name="flag">fatal</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-select-full-path"/>
               </axsl:attribute>
               <svrl:text>Base quantity MUST be a positive number above zero.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="(count(cac:DocumentReference) &lt;= 1)"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="(count(cac:DocumentReference) &lt;= 1)">
               <axsl:attribute name="id">PEPPOL-EN16931-R100</axsl:attribute>
               <axsl:attribute name="flag">fatal</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-select-full-path"/>
               </axsl:attribute>
               <svrl:text>Only one invoiced object is allowed pr line</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="(not(cac:DocumentReference) or (cac:DocumentReference/cbc:DocumentTypeCode='130'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="(not(cac:DocumentReference) or (cac:DocumentReference/cbc:DocumentTypeCode='130'))">
               <axsl:attribute name="id">PEPPOL-EN16931-R101</axsl:attribute>
               <axsl:attribute name="flag">fatal</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-select-full-path"/>
               </axsl:attribute>
               <svrl:text>Element Document reference can only be used for Invoice line object</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>
      <axsl:apply-templates select="@*|*" mode="M22"/>
   </axsl:template>

	<!--RULE -->

   <axsl:template match="cac:Price/cac:AllowanceCharge" priority="1010" mode="M22">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="cac:Price/cac:AllowanceCharge"/>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="normalize-space(cbc:ChargeIndicator) = 'false'"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="normalize-space(cbc:ChargeIndicator) = 'false'">
               <axsl:attribute name="id">PEPPOL-EN16931-R044</axsl:attribute>
               <axsl:attribute name="flag">fatal</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-select-full-path"/>
               </axsl:attribute>
               <svrl:text>Charge on price level is NOT allowed. Only value 'false' allowed.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cbc:BaseAmount) or xs:decimal(../cbc:PriceAmount) = xs:decimal(cbc:BaseAmount) - xs:decimal(cbc:Amount)"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cbc:BaseAmount) or xs:decimal(../cbc:PriceAmount) = xs:decimal(cbc:BaseAmount) - xs:decimal(cbc:Amount)">
               <axsl:attribute name="id">PEPPOL-EN16931-R046</axsl:attribute>
               <axsl:attribute name="flag">fatal</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-select-full-path"/>
               </axsl:attribute>
               <svrl:text>Item net price MUST equal (Gross price - Allowance amount) when gross price is provided.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>
      <axsl:apply-templates select="@*|*" mode="M22"/>
   </axsl:template>

	<!--RULE -->

   <axsl:template match="cac:Price/cbc:BaseQuantity[@unitCode]" priority="1009" mode="M22">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="cac:Price/cbc:BaseQuantity[@unitCode]"/>
      <axsl:variable name="hasQuantity" select="../../cbc:InvoicedQuantity or ../../cbc:CreditedQuantity"/>
      <axsl:variable name="quantity" select="           if (/ubl-invoice:Invoice) then             ../../cbc:InvoicedQuantity           else             ../../cbc:CreditedQuantity"/>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not($hasQuantity) or @unitCode = $quantity/@unitCode"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not($hasQuantity) or @unitCode = $quantity/@unitCode">
               <axsl:attribute name="id">PEPPOL-EN16931-R130</axsl:attribute>
               <axsl:attribute name="flag">fatal</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-select-full-path"/>
               </axsl:attribute>
               <svrl:text>Unit code of price base quantity MUST be same as invoiced quantity.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>
      <axsl:apply-templates select="@*|*" mode="M22"/>
   </axsl:template>

	<!--RULE -->

   <axsl:template match="cbc:EndpointID[@schemeID = '0088'] | cac:PartyIdentification/cbc:ID[@schemeID = '0088'] | cbc:CompanyID[@schemeID = '0088']" priority="1008" mode="M22">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="cbc:EndpointID[@schemeID = '0088'] | cac:PartyIdentification/cbc:ID[@schemeID = '0088'] | cbc:CompanyID[@schemeID = '0088']"/>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="matches(normalize-space(), '^[0-9]+$') and u:gln(normalize-space())"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="matches(normalize-space(), '^[0-9]+$') and u:gln(normalize-space())">
               <axsl:attribute name="id">PEPPOL-COMMON-R040</axsl:attribute>
               <axsl:attribute name="flag">fatal</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-select-full-path"/>
               </axsl:attribute>
               <svrl:text>GLN must have a valid format according to GS1 rules.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>
      <axsl:apply-templates select="@*|*" mode="M22"/>
   </axsl:template>

	<!--RULE -->

   <axsl:template match="cbc:EndpointID[@schemeID = '0192'] | cac:PartyIdentification/cbc:ID[@schemeID = '0192'] | cbc:CompanyID[@schemeID = '0192']" priority="1007" mode="M22">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="cbc:EndpointID[@schemeID = '0192'] | cac:PartyIdentification/cbc:ID[@schemeID = '0192'] | cbc:CompanyID[@schemeID = '0192']"/>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="matches(normalize-space(), '^[0-9]{9}$') and u:mod11(normalize-space())"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="matches(normalize-space(), '^[0-9]{9}$') and u:mod11(normalize-space())">
               <axsl:attribute name="id">PEPPOL-COMMON-R041</axsl:attribute>
               <axsl:attribute name="flag">fatal</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-select-full-path"/>
               </axsl:attribute>
               <svrl:text>Norwegian organization number MUST be stated in the correct format.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>
      <axsl:apply-templates select="@*|*" mode="M22"/>
   </axsl:template>

	<!--RULE -->

   <axsl:template match="cbc:EndpointID[@schemeID = '0184'] | cac:PartyIdentification/cbc:ID[@schemeID = '0184'] | cbc:CompanyID[@schemeID = '0184']" priority="1006" mode="M22">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="cbc:EndpointID[@schemeID = '0184'] | cac:PartyIdentification/cbc:ID[@schemeID = '0184'] | cbc:CompanyID[@schemeID = '0184']"/>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="(string-length(text()) = 10) and (substring(text(), 1, 2) = 'DK') and (string-length(translate(substring(text(), 3, 8), '1234567890', '')) = 0)"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="(string-length(text()) = 10) and (substring(text(), 1, 2) = 'DK') and (string-length(translate(substring(text(), 3, 8), '1234567890', '')) = 0)">
               <axsl:attribute name="id">PEPPOL-COMMON-R042</axsl:attribute>
               <axsl:attribute name="flag">fatal</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-select-full-path"/>
               </axsl:attribute>
               <svrl:text>Danish organization number (CVR) MUST be stated in the correct format.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>
      <axsl:apply-templates select="@*|*" mode="M22"/>
   </axsl:template>

	<!--RULE -->

   <axsl:template match="cbc:EndpointID[@schemeID = '0208'] | cac:PartyIdentification/cbc:ID[@schemeID = '0208'] | cbc:CompanyID[@schemeID = '0208']" priority="1005" mode="M22">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="cbc:EndpointID[@schemeID = '0208'] | cac:PartyIdentification/cbc:ID[@schemeID = '0208'] | cbc:CompanyID[@schemeID = '0208']"/>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="matches(normalize-space(), '^[0-9]{10}$') and u:mod97-0208(normalize-space())"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="matches(normalize-space(), '^[0-9]{10}$') and u:mod97-0208(normalize-space())">
               <axsl:attribute name="id">PEPPOL-COMMON-R043</axsl:attribute>
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-select-full-path"/>
               </axsl:attribute>
               <svrl:text>Belgian enterprise number MUST be stated in the correct format.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>
      <axsl:apply-templates select="@*|*" mode="M22"/>
   </axsl:template>

	<!--RULE -->

   <axsl:template match="cbc:EndpointID[@schemeID = '0201'] | cac:PartyIdentification/cbc:ID[@schemeID = '0201'] | cbc:CompanyID[@schemeID = '0201']" priority="1004" mode="M22">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="cbc:EndpointID[@schemeID = '0201'] | cac:PartyIdentification/cbc:ID[@schemeID = '0201'] | cbc:CompanyID[@schemeID = '0201']"/>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="u:checkCodiceIPA(normalize-space())"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="u:checkCodiceIPA(normalize-space())">
               <axsl:attribute name="id">PEPPOL-COMMON-R044</axsl:attribute>
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-select-full-path"/>
               </axsl:attribute>
               <svrl:text>IPA Code (Codice Univoco Unità Organizzativa) must be stated in the correct format</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>
      <axsl:apply-templates select="@*|*" mode="M22"/>
   </axsl:template>

	<!--RULE -->

   <axsl:template match="cbc:EndpointID[@schemeID = '0210'] | cac:PartyIdentification/cbc:ID[@schemeID = '0210'] | cbc:CompanyID[@schemeID = '0210']" priority="1003" mode="M22">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="cbc:EndpointID[@schemeID = '0210'] | cac:PartyIdentification/cbc:ID[@schemeID = '0210'] | cbc:CompanyID[@schemeID = '0210']"/>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="u:checkCF(normalize-space())"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="u:checkCF(normalize-space())">
               <axsl:attribute name="id">PEPPOL-COMMON-R045</axsl:attribute>
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-select-full-path"/>
               </axsl:attribute>
               <svrl:text>Tax Code (Codice Fiscale) must be stated in the correct format</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>
      <axsl:apply-templates select="@*|*" mode="M22"/>
   </axsl:template>

	<!--RULE -->

   <axsl:template match="cbc:EndpointID[@schemeID = '9907']" priority="1002" mode="M22">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="cbc:EndpointID[@schemeID = '9907']"/>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="u:checkCF(normalize-space())"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="u:checkCF(normalize-space())">
               <axsl:attribute name="id">PEPPOL-COMMON-R046</axsl:attribute>
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-select-full-path"/>
               </axsl:attribute>
               <svrl:text>Tax Code (Codice Fiscale) must be stated in the correct format</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>
      <axsl:apply-templates select="@*|*" mode="M22"/>
   </axsl:template>

	<!--RULE -->

   <axsl:template match="cbc:EndpointID[@schemeID = '0211'] | cac:PartyIdentification/cbc:ID[@schemeID = '0211'] | cbc:CompanyID[@schemeID = '0211']" priority="1001" mode="M22">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="cbc:EndpointID[@schemeID = '0211'] | cac:PartyIdentification/cbc:ID[@schemeID = '0211'] | cbc:CompanyID[@schemeID = '0211']"/>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="u:checkPIVAseIT(normalize-space())"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="u:checkPIVAseIT(normalize-space())">
               <axsl:attribute name="id">PEPPOL-COMMON-R047</axsl:attribute>
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-select-full-path"/>
               </axsl:attribute>
               <svrl:text>Italian VAT Code (Partita Iva) must be stated in the correct format</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>
      <axsl:apply-templates select="@*|*" mode="M22"/>
   </axsl:template>

	<!--RULE -->

   <axsl:template match="cbc:EndpointID[@schemeID = '9906']" priority="1000" mode="M22">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="cbc:EndpointID[@schemeID = '9906']"/>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="u:checkPIVAseIT(normalize-space())"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="u:checkPIVAseIT(normalize-space())">
               <axsl:attribute name="id">PEPPOL-COMMON-R048</axsl:attribute>
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-select-full-path"/>
               </axsl:attribute>
               <svrl:text>Italian VAT Code (Partita Iva) must be stated in the correct format</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>
      <axsl:apply-templates select="@*|*" mode="M22"/>
   </axsl:template>
   <axsl:template match="text()" priority="-1" mode="M22"/>
   <axsl:template match="@*|node()" priority="-2" mode="M22">
      <axsl:apply-templates select="@*|*" mode="M22"/>
   </axsl:template>

<!--PATTERN -->


	<!--RULE -->

   <axsl:template match="cac:AccountingSupplierParty/cac:Party[$supplierCountry = 'NO']" priority="1000" mode="M23">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="cac:AccountingSupplierParty/cac:Party[$supplierCountry = 'NO']"/>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="normalize-space(cac:PartyTaxScheme[normalize-space(cac:TaxScheme/cbc:ID) = 'TAX']/cbc:CompanyID) = 'Foretaksregisteret'"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="normalize-space(cac:PartyTaxScheme[normalize-space(cac:TaxScheme/cbc:ID) = 'TAX']/cbc:CompanyID) = 'Foretaksregisteret'">
               <axsl:attribute name="id">NO-R-002</axsl:attribute>
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-select-full-path"/>
               </axsl:attribute>
               <svrl:text>For Norwegian suppliers, most invoice issuers are required to append "Foretaksregisteret" to their
        invoice. "Dersom selger er aksjeselskap, allmennaksjeselskap eller filial av utenlandsk
        selskap skal også ordet «Foretaksregisteret» fremgå av salgsdokumentet, jf.
        foretaksregisterloven § 10-2."</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="cac:PartyTaxScheme[normalize-space(cac:TaxScheme/cbc:ID) = 'VAT']/substring(cbc:CompanyID, 1, 2)='NO' and matches(cac:PartyTaxScheme[normalize-space(cac:TaxScheme/cbc:ID) = 'VAT']/substring(cbc:CompanyID,3), '^[0-9]{9}MVA$')           and u:mod11(substring(cac:PartyTaxScheme[normalize-space(cac:TaxScheme/cbc:ID) = 'VAT']/cbc:CompanyID, 3, 9)) or not(cac:PartyTaxScheme[normalize-space(cac:TaxScheme/cbc:ID) = 'VAT']/substring(cbc:CompanyID, 1, 2)='NO')"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="cac:PartyTaxScheme[normalize-space(cac:TaxScheme/cbc:ID) = 'VAT']/substring(cbc:CompanyID, 1, 2)='NO' and matches(cac:PartyTaxScheme[normalize-space(cac:TaxScheme/cbc:ID) = 'VAT']/substring(cbc:CompanyID,3), '^[0-9]{9}MVA$') and u:mod11(substring(cac:PartyTaxScheme[normalize-space(cac:TaxScheme/cbc:ID) = 'VAT']/cbc:CompanyID, 3, 9)) or not(cac:PartyTaxScheme[normalize-space(cac:TaxScheme/cbc:ID) = 'VAT']/substring(cbc:CompanyID, 1, 2)='NO')">
               <axsl:attribute name="id">NO-R-001</axsl:attribute>
               <axsl:attribute name="flag">fatal</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-select-full-path"/>
               </axsl:attribute>
               <svrl:text>For Norwegian suppliers, a VAT number MUST be the country code prefix NO followed by a valid Norwegian organization number (nine numbers) followed by the letters MVA.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>
      <axsl:apply-templates select="@*|*" mode="M23"/>
   </axsl:template>
   <axsl:template match="text()" priority="-1" mode="M23"/>
   <axsl:template match="@*|node()" priority="-2" mode="M23">
      <axsl:apply-templates select="@*|*" mode="M23"/>
   </axsl:template>

<!--PATTERN -->

   <axsl:variable name="DKSupplierCountry" select="concat(ubl-creditnote:CreditNote/cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode, ubl-invoice:Invoice/cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode)"/>
   <axsl:variable name="DKCustomerCountry" select="concat(ubl-creditnote:CreditNote/cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode, ubl-invoice:Invoice/cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode)"/>

	<!--RULE -->

   <axsl:template match="ubl-creditnote:CreditNote[$DKSupplierCountry = 'DK'] | ubl-invoice:Invoice[$DKSupplierCountry = 'DK']" priority="1004" mode="M24">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="ubl-creditnote:CreditNote[$DKSupplierCountry = 'DK'] | ubl-invoice:Invoice[$DKSupplierCountry = 'DK']"/>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="(normalize-space(cac:AccountingSupplierParty/cac:Party/cac:PartyLegalEntity/cbc:CompanyID/text()) != '')"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="(normalize-space(cac:AccountingSupplierParty/cac:Party/cac:PartyLegalEntity/cbc:CompanyID/text()) != '')">
               <axsl:attribute name="id">DK-R-002</axsl:attribute>
               <axsl:attribute name="flag">fatal</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-select-full-path"/>
               </axsl:attribute>
               <svrl:text>Danish suppliers MUST provide legal entity (CVR-number)</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(((boolean(cac:AccountingSupplierParty/cac:Party/cac:PartyLegalEntity/cbc:CompanyID))           and (normalize-space(cac:AccountingSupplierParty/cac:Party/cac:PartyLegalEntity/cbc:CompanyID/@schemeID) != '0184'))       )"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(((boolean(cac:AccountingSupplierParty/cac:Party/cac:PartyLegalEntity/cbc:CompanyID)) and (normalize-space(cac:AccountingSupplierParty/cac:Party/cac:PartyLegalEntity/cbc:CompanyID/@schemeID) != '0184')) )">
               <axsl:attribute name="id">DK-R-014</axsl:attribute>
               <axsl:attribute name="flag">fatal</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-select-full-path"/>
               </axsl:attribute>
               <svrl:text>For Danish Suppliers it is mandatory to specify schemeID as "0184" (DK CVR-number) when PartyLegalEntity/CompanyID is used for AccountingSupplierParty</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not((normalize-space(cac:AccountingSupplierParty/cac:Party/cac:PartyTaxScheme[1]/cac:TaxScheme/cbc:ID/text()) = 'VAT')       and not ((string-length(cac:AccountingSupplierParty/cac:Party/cac:PartyTaxScheme[1]/cbc:CompanyID/text()) = 10)          and (substring(cac:AccountingSupplierParty/cac:Party/cac:PartyTaxScheme[1]/cbc:CompanyID/text(), 1, 2) = 'DK')          and (string-length(translate(substring(cac:AccountingSupplierParty/cac:Party/cac:PartyTaxScheme[1]/cbc:CompanyID/text(), 3, 8), '1234567890', '')) = 0))       or       (normalize-space(cac:AccountingSupplierParty/cac:Party/cac:PartyTaxScheme[2]/cac:TaxScheme/cbc:ID/text()) = 'VAT')       and not ((string-length(cac:AccountingSupplierParty/cac:Party/cac:PartyTaxScheme[2]/cbc:CompanyID/text()) = 10)          and (substring(cac:AccountingSupplierParty/cac:Party/cac:PartyTaxScheme[2]/cbc:CompanyID/text(), 1, 2) = 'DK')          and (string-length(translate(substring(cac:AccountingSupplierParty/cac:Party/cac:PartyTaxScheme[2]/cbc:CompanyID/text(), 3, 8), '1234567890', '')) = 0))       )"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not((normalize-space(cac:AccountingSupplierParty/cac:Party/cac:PartyTaxScheme[1]/cac:TaxScheme/cbc:ID/text()) = 'VAT') and not ((string-length(cac:AccountingSupplierParty/cac:Party/cac:PartyTaxScheme[1]/cbc:CompanyID/text()) = 10) and (substring(cac:AccountingSupplierParty/cac:Party/cac:PartyTaxScheme[1]/cbc:CompanyID/text(), 1, 2) = 'DK') and (string-length(translate(substring(cac:AccountingSupplierParty/cac:Party/cac:PartyTaxScheme[1]/cbc:CompanyID/text(), 3, 8), '1234567890', '')) = 0)) or (normalize-space(cac:AccountingSupplierParty/cac:Party/cac:PartyTaxScheme[2]/cac:TaxScheme/cbc:ID/text()) = 'VAT') and not ((string-length(cac:AccountingSupplierParty/cac:Party/cac:PartyTaxScheme[2]/cbc:CompanyID/text()) = 10) and (substring(cac:AccountingSupplierParty/cac:Party/cac:PartyTaxScheme[2]/cbc:CompanyID/text(), 1, 2) = 'DK') and (string-length(translate(substring(cac:AccountingSupplierParty/cac:Party/cac:PartyTaxScheme[2]/cbc:CompanyID/text(), 3, 8), '1234567890', '')) = 0)) )">
               <axsl:attribute name="id">DK-R-015</axsl:attribute>
               <axsl:attribute name="flag">fatal</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-select-full-path"/>
               </axsl:attribute>
               <svrl:text>For Danish Suppliers, if specified, AccountingSupplierParty/PartyTaxScheme/CompanyID (DK VAT number) must start with DK followed by 8 digits</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not((boolean(/ubl-creditnote:CreditNote) and ($DKCustomerCountry = 'DK'))       and (number(cac:LegalMonetaryTotal/cbc:PayableAmount/text()) &lt; 0)       )"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not((boolean(/ubl-creditnote:CreditNote) and ($DKCustomerCountry = 'DK')) and (number(cac:LegalMonetaryTotal/cbc:PayableAmount/text()) &lt; 0) )">
               <axsl:attribute name="id">DK-R-016</axsl:attribute>
               <axsl:attribute name="flag">fatal</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-select-full-path"/>
               </axsl:attribute>
               <svrl:text>For Danish Suppliers, a Credit note cannot have a negative total (PayableAmount)</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>
      <axsl:apply-templates select="@*|*" mode="M24"/>
   </axsl:template>

	<!--RULE -->

   <axsl:template match="ubl-creditnote:CreditNote[$DKSupplierCountry = 'DK' and $DKCustomerCountry = 'DK']/cac:AccountingSupplierParty/cac:Party/cac:PartyIdentification | ubl-creditnote:CreditNote[$DKSupplierCountry = 'DK' and $DKCustomerCountry = 'DK']/cac:AccountingCustomerParty/cac:Party/cac:PartyIdentification | ubl-invoice:Invoice[$DKSupplierCountry = 'DK' and $DKCustomerCountry = 'DK']/cac:AccountingSupplierParty/cac:Party/cac:PartyIdentification | ubl-invoice:Invoice[$DKSupplierCountry = 'DK' and $DKCustomerCountry = 'DK']/cac:AccountingCustomerParty/cac:Party/cac:PartyIdentification" priority="1003" mode="M24">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="ubl-creditnote:CreditNote[$DKSupplierCountry = 'DK' and $DKCustomerCountry = 'DK']/cac:AccountingSupplierParty/cac:Party/cac:PartyIdentification | ubl-creditnote:CreditNote[$DKSupplierCountry = 'DK' and $DKCustomerCountry = 'DK']/cac:AccountingCustomerParty/cac:Party/cac:PartyIdentification | ubl-invoice:Invoice[$DKSupplierCountry = 'DK' and $DKCustomerCountry = 'DK']/cac:AccountingSupplierParty/cac:Party/cac:PartyIdentification | ubl-invoice:Invoice[$DKSupplierCountry = 'DK' and $DKCustomerCountry = 'DK']/cac:AccountingCustomerParty/cac:Party/cac:PartyIdentification"/>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not((boolean(cbc:ID))        and (normalize-space(cbc:ID/@schemeID) = '')       )"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not((boolean(cbc:ID)) and (normalize-space(cbc:ID/@schemeID) = '') )">
               <axsl:attribute name="id">DK-R-013</axsl:attribute>
               <axsl:attribute name="flag">fatal</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-select-full-path"/>
               </axsl:attribute>
               <svrl:text>For Danish Suppliers it is mandatory to use schemeID when PartyIdentification/ID is used for AccountingCustomerParty or AccountingSupplierParty</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>
      <axsl:apply-templates select="@*|*" mode="M24"/>
   </axsl:template>

	<!--RULE -->

   <axsl:template match="ubl-invoice:Invoice[$DKSupplierCountry = 'DK' and $DKCustomerCountry = 'DK']/cac:PaymentMeans" priority="1002" mode="M24">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="ubl-invoice:Invoice[$DKSupplierCountry = 'DK' and $DKCustomerCountry = 'DK']/cac:PaymentMeans"/>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="contains(' 1 10 31 42 48 49 50 58 59 93 97 ', concat(' ', cbc:PaymentMeansCode, ' '))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="contains(' 1 10 31 42 48 49 50 58 59 93 97 ', concat(' ', cbc:PaymentMeansCode, ' '))">
               <axsl:attribute name="id">DK-R-005</axsl:attribute>
               <axsl:attribute name="flag">fatal</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-select-full-path"/>
               </axsl:attribute>
               <svrl:text>For Danish suppliers the following Payment means codes are allowed: 1, 10, 31, 42, 48, 49, 50, 58, 59, 93 and 97</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(((cbc:PaymentMeansCode = '31') or (cbc:PaymentMeansCode = '42'))       and not((normalize-space(cac:PayeeFinancialAccount/cbc:ID/text()) != '') and (normalize-space(cac:PayeeFinancialAccount/cac:FinancialInstitutionBranch/cbc:ID/text()) != ''))       )"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(((cbc:PaymentMeansCode = '31') or (cbc:PaymentMeansCode = '42')) and not((normalize-space(cac:PayeeFinancialAccount/cbc:ID/text()) != '') and (normalize-space(cac:PayeeFinancialAccount/cac:FinancialInstitutionBranch/cbc:ID/text()) != '')) )">
               <axsl:attribute name="id">DK-R-006</axsl:attribute>
               <axsl:attribute name="flag">fatal</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-select-full-path"/>
               </axsl:attribute>
               <svrl:text>For Danish suppliers bank account and registration account is mandatory if payment means is 31 or 42</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not((cbc:PaymentMeansCode = '49')       and not((normalize-space(cac:PaymentMandate/cbc:ID/text()) != '')           and (normalize-space(cac:PaymentMandate/cac:PayerFinancialAccount/cbc:ID/text()) != ''))       )"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not((cbc:PaymentMeansCode = '49') and not((normalize-space(cac:PaymentMandate/cbc:ID/text()) != '') and (normalize-space(cac:PaymentMandate/cac:PayerFinancialAccount/cbc:ID/text()) != '')) )">
               <axsl:attribute name="id">DK-R-007</axsl:attribute>
               <axsl:attribute name="flag">fatal</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-select-full-path"/>
               </axsl:attribute>
               <svrl:text>For Danish suppliers PaymentMandate/ID and PayerFinancialAccount/ID are mandatory when payment means is 49</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not((cbc:PaymentMeansCode = '50')       and not(((substring(cbc:PaymentID, 1, 3) = '01#')           or (substring(cbc:PaymentID, 1, 3) = '04#')           or (substring(cbc:PaymentID, 1, 3) = '15#'))         and (string-length(cac:PayeeFinancialAccount/cbc:ID/text()) = 7)         )       )"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not((cbc:PaymentMeansCode = '50') and not(((substring(cbc:PaymentID, 1, 3) = '01#') or (substring(cbc:PaymentID, 1, 3) = '04#') or (substring(cbc:PaymentID, 1, 3) = '15#')) and (string-length(cac:PayeeFinancialAccount/cbc:ID/text()) = 7) ) )">
               <axsl:attribute name="id">DK-R-008</axsl:attribute>
               <axsl:attribute name="flag">fatal</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-select-full-path"/>
               </axsl:attribute>
               <svrl:text>For Danish Suppliers PaymentID is mandatory and MUST start with 01#, 04# or 15# (kortartkode), and PayeeFinancialAccount/ID (Giro kontonummer) is mandatory and must be 7 characters long, when payment means equals 50 (Giro)</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not((cbc:PaymentMeansCode = '50')       and ((substring(cbc:PaymentID, 1, 3) = '04#')          or (substring(cbc:PaymentID, 1, 3)  = '15#'))       and not(string-length(cbc:PaymentID) = 19)       )"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not((cbc:PaymentMeansCode = '50') and ((substring(cbc:PaymentID, 1, 3) = '04#') or (substring(cbc:PaymentID, 1, 3) = '15#')) and not(string-length(cbc:PaymentID) = 19) )">
               <axsl:attribute name="id">DK-R-009</axsl:attribute>
               <axsl:attribute name="flag">fatal</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-select-full-path"/>
               </axsl:attribute>
               <svrl:text>For Danish Suppliers if the PaymentID is prefixed with 04# or 15# the 16 digits instruction Id must be added to the PaymentID eg. "04#1234567890123456" when Payment means equals 50 (Giro)</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not((cbc:PaymentMeansCode = '93')       and not(((substring(cbc:PaymentID, 1, 3) = '71#')           or (substring(cbc:PaymentID, 1, 3) = '73#')           or (substring(cbc:PaymentID, 1, 3) = '75#'))         and (string-length(cac:PayeeFinancialAccount/cbc:ID/text()) = 8)         )       )"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not((cbc:PaymentMeansCode = '93') and not(((substring(cbc:PaymentID, 1, 3) = '71#') or (substring(cbc:PaymentID, 1, 3) = '73#') or (substring(cbc:PaymentID, 1, 3) = '75#')) and (string-length(cac:PayeeFinancialAccount/cbc:ID/text()) = 8) ) )">
               <axsl:attribute name="id">DK-R-010</axsl:attribute>
               <axsl:attribute name="flag">fatal</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-select-full-path"/>
               </axsl:attribute>
               <svrl:text>For Danish Suppliers the PaymentID is mandatory and MUST start with 71#, 73# or 75# (kortartkode) and PayeeFinancialAccount/ID (Kreditornummer) is mandatory and must be exactly 8 characters long, when Payment means equals 93 (FIK)</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not((cbc:PaymentMeansCode = '93')       and ((substring(cbc:PaymentID, 1, 3) = '71#')          or (substring(cbc:PaymentID, 1, 3)  = '75#'))       and not((string-length(cbc:PaymentID) = 18)          or (string-length(cbc:PaymentID) = 19))       )"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not((cbc:PaymentMeansCode = '93') and ((substring(cbc:PaymentID, 1, 3) = '71#') or (substring(cbc:PaymentID, 1, 3) = '75#')) and not((string-length(cbc:PaymentID) = 18) or (string-length(cbc:PaymentID) = 19)) )">
               <axsl:attribute name="id">DK-R-011</axsl:attribute>
               <axsl:attribute name="flag">fatal</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-select-full-path"/>
               </axsl:attribute>
               <svrl:text>For Danish Suppliers if the PaymentID is prefixed with 71# or 75# the 15-16 digits instruction Id must be added to the PaymentID eg. "71#1234567890123456" when payment Method equals 93 (FIK)</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>
      <axsl:apply-templates select="@*|*" mode="M24"/>
   </axsl:template>

	<!--RULE -->

   <axsl:template match="ubl-creditnote:CreditNote[$DKSupplierCountry = 'DK' and $DKCustomerCountry = 'DK']/cac:CreditNoteLine | ubl-invoice:Invoice[$DKSupplierCountry = 'DK' and $DKCustomerCountry = 'DK']/cac:InvoiceLine" priority="1001" mode="M24">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="ubl-creditnote:CreditNote[$DKSupplierCountry = 'DK' and $DKCustomerCountry = 'DK']/cac:CreditNoteLine | ubl-invoice:Invoice[$DKSupplierCountry = 'DK' and $DKCustomerCountry = 'DK']/cac:InvoiceLine"/>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not((cac:Item/cac:CommodityClassification/cbc:ItemClassificationCode/@listID = 'TST')       and not((cac:Item/cac:CommodityClassification/cbc:ItemClassificationCode/@listVersionID = '19.05.01')           or (cac:Item/cac:CommodityClassification/cbc:ItemClassificationCode/@listVersionID = '19.0501')           )       )"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not((cac:Item/cac:CommodityClassification/cbc:ItemClassificationCode/@listID = 'TST') and not((cac:Item/cac:CommodityClassification/cbc:ItemClassificationCode/@listVersionID = '19.05.01') or (cac:Item/cac:CommodityClassification/cbc:ItemClassificationCode/@listVersionID = '19.0501') ) )">
               <axsl:attribute name="id">DK-R-003</axsl:attribute>
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-select-full-path"/>
               </axsl:attribute>
               <svrl:text>If ItemClassification is provided from Danish suppliers, UNSPSC version 19.0501 should be used.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>
      <axsl:apply-templates select="@*|*" mode="M24"/>
   </axsl:template>

	<!--RULE -->

   <axsl:template match="cac:AllowanceCharge[$DKSupplierCountry = 'DK' and $DKCustomerCountry = 'DK']" priority="1000" mode="M24">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="cac:AllowanceCharge[$DKSupplierCountry = 'DK' and $DKCustomerCountry = 'DK']"/>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not((cbc:AllowanceChargeReasonCode = 'ZZZ')       and not((string-length(normalize-space(cbc:AllowanceChargeReason/text())) = 4)         and (number(cbc:AllowanceChargeReason) &gt;= 0)         and (number(cbc:AllowanceChargeReason) &lt;= 9999))       )"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not((cbc:AllowanceChargeReasonCode = 'ZZZ') and not((string-length(normalize-space(cbc:AllowanceChargeReason/text())) = 4) and (number(cbc:AllowanceChargeReason) &gt;= 0) and (number(cbc:AllowanceChargeReason) &lt;= 9999)) )">
               <axsl:attribute name="id">DK-R-004</axsl:attribute>
               <axsl:attribute name="flag">fatal</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-select-full-path"/>
               </axsl:attribute>
               <svrl:text>When specifying non-VAT Taxes, Danish suppliers MUST use the AllowanceChargeReasonCode="ZZZ" and the 4-digit Tax category MUST be specified in 'AllowanceChargeReason'</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>
      <axsl:apply-templates select="@*|*" mode="M24"/>
   </axsl:template>
   <axsl:template match="text()" priority="-1" mode="M24"/>
   <axsl:template match="@*|node()" priority="-2" mode="M24">
      <axsl:apply-templates select="@*|*" mode="M24"/>
   </axsl:template>

<!--PATTERN -->


	<!--RULE -->

   <axsl:template match="cac:AccountingSupplierParty/cac:Party[$supplierCountry = 'IT']/cac:PartyTaxScheme[normalize-space(cac:TaxScheme/cbc:ID) != 'VAT']" priority="1001" mode="M25">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="cac:AccountingSupplierParty/cac:Party[$supplierCountry = 'IT']/cac:PartyTaxScheme[normalize-space(cac:TaxScheme/cbc:ID) != 'VAT']"/>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="matches(normalize-space(cbc:CompanyID),'^[A-Z0-9]{11,16}$')"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="matches(normalize-space(cbc:CompanyID),'^[A-Z0-9]{11,16}$')">
               <axsl:attribute name="id">IT-R-001</axsl:attribute>
               <axsl:attribute name="flag">fatal</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-select-full-path"/>
               </axsl:attribute>
               <svrl:text>[IT-R-001] BT-32 (Seller tax registration identifier) - For Italian suppliers BT-32 minimum length 11 and maximum length shall be 16.  Per i fornitori italiani il BT-32 deve avere una lunghezza tra 11 e 16 caratteri</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>
      <axsl:apply-templates select="@*|*" mode="M25"/>
   </axsl:template>

	<!--RULE -->

   <axsl:template match="cac:AccountingSupplierParty/cac:Party[$supplierCountry = 'IT']" priority="1000" mode="M25">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="cac:AccountingSupplierParty/cac:Party[$supplierCountry = 'IT']"/>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="cac:PostalAddress/cbc:StreetName"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="cac:PostalAddress/cbc:StreetName">
               <axsl:attribute name="id">IT-R-002</axsl:attribute>
               <axsl:attribute name="flag">fatal</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-select-full-path"/>
               </axsl:attribute>
               <svrl:text>[IT-R-002] BT-35 (Seller address line 1) - Italian suppliers MUST provide the postal address line 1 - I fornitori italiani devono indicare l'indirizzo postale.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="cac:PostalAddress/cbc:CityName"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="cac:PostalAddress/cbc:CityName">
               <axsl:attribute name="id">IT-R-003</axsl:attribute>
               <axsl:attribute name="flag">fatal</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-select-full-path"/>
               </axsl:attribute>
               <svrl:text>[IT-R-003] BT-37 (Seller city) - Italian suppliers MUST provide the postal address city - I fornitori italiani devono indicare la città di residenza.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="cac:PostalAddress/cbc:PostalZone"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="cac:PostalAddress/cbc:PostalZone">
               <axsl:attribute name="id">IT-R-004</axsl:attribute>
               <axsl:attribute name="flag">fatal</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-select-full-path"/>
               </axsl:attribute>
               <svrl:text>"&gt;[IT-R-004] BT-38 (Seller post code) - Italian suppliers MUST provide the postal address post code - I fornitori italiani devono indicare il CAP di residenza.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>
      <axsl:apply-templates select="@*|*" mode="M25"/>
   </axsl:template>
   <axsl:template match="text()" priority="-1" mode="M25"/>
   <axsl:template match="@*|node()" priority="-2" mode="M25">
      <axsl:apply-templates select="@*|*" mode="M25"/>
   </axsl:template>

<!--PATTERN -->


	<!--RULE -->

   <axsl:template match="//cac:AccountingSupplierParty/cac:Party[cac:PostalAddress/cac:Country/cbc:IdentificationCode = 'SE' and cac:PartyTaxScheme[cac:TaxScheme/cbc:ID = 'VAT']/substring(cbc:CompanyID, 1, 2) = 'SE']" priority="1007" mode="M26">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="//cac:AccountingSupplierParty/cac:Party[cac:PostalAddress/cac:Country/cbc:IdentificationCode = 'SE' and cac:PartyTaxScheme[cac:TaxScheme/cbc:ID = 'VAT']/substring(cbc:CompanyID, 1, 2) = 'SE']"/>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="string-length(normalize-space(cac:PartyTaxScheme[cac:TaxScheme/cbc:ID = 'VAT']/cbc:CompanyID)) = 14"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="string-length(normalize-space(cac:PartyTaxScheme[cac:TaxScheme/cbc:ID = 'VAT']/cbc:CompanyID)) = 14">
               <axsl:attribute name="id">SE-R-001</axsl:attribute>
               <axsl:attribute name="flag">fatal</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-select-full-path"/>
               </axsl:attribute>
               <svrl:text>For Swedish suppliers, Swedish VAT-numbers must consist of 14 characters.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="string(number(substring(cac:PartyTaxScheme[cac:TaxScheme/cbc:ID = 'VAT']/cbc:CompanyID, 3, 12))) != 'NaN'"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="string(number(substring(cac:PartyTaxScheme[cac:TaxScheme/cbc:ID = 'VAT']/cbc:CompanyID, 3, 12))) != 'NaN'">
               <axsl:attribute name="id">SE-R-002</axsl:attribute>
               <axsl:attribute name="flag">fatal</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-select-full-path"/>
               </axsl:attribute>
               <svrl:text>For Swedish suppliers, the Swedish VAT-numbers must have the trailing 12 characters in numeric form</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>
      <axsl:apply-templates select="@*|*" mode="M26"/>
   </axsl:template>

	<!--RULE -->

   <axsl:template match="//cac:AccountingSupplierParty/cac:Party/cac:PartyLegalEntity[../cac:PostalAddress/cac:Country/cbc:IdentificationCode = 'SE' and cbc:CompanyID]" priority="1006" mode="M26">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="//cac:AccountingSupplierParty/cac:Party/cac:PartyLegalEntity[../cac:PostalAddress/cac:Country/cbc:IdentificationCode = 'SE' and cbc:CompanyID]"/>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="string(number(cbc:CompanyID)) != 'NaN'"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="string(number(cbc:CompanyID)) != 'NaN'">
               <axsl:attribute name="id">SE-R-003</axsl:attribute>
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-select-full-path"/>
               </axsl:attribute>
               <svrl:text>Swedish organisation numbers should be numeric.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="string-length(normalize-space(cbc:CompanyID)) = 10"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="string-length(normalize-space(cbc:CompanyID)) = 10">
               <axsl:attribute name="id">SE-R-004</axsl:attribute>
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-select-full-path"/>
               </axsl:attribute>
               <svrl:text>Swedish organisation numbers consist of 10 characters.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>
      <axsl:apply-templates select="@*|*" mode="M26"/>
   </axsl:template>

	<!--RULE -->

   <axsl:template match="//cac:AccountingSupplierParty/cac:Party[cac:PostalAddress/cac:Country/cbc:IdentificationCode = 'SE' and exists(cac:PartyLegalEntity/cbc:CompanyID)]/cac:PartyTaxScheme[normalize-space(upper-case(cac:TaxScheme/cbc:ID)) != 'VAT']/cbc:CompanyID" priority="1005" mode="M26">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="//cac:AccountingSupplierParty/cac:Party[cac:PostalAddress/cac:Country/cbc:IdentificationCode = 'SE' and exists(cac:PartyLegalEntity/cbc:CompanyID)]/cac:PartyTaxScheme[normalize-space(upper-case(cac:TaxScheme/cbc:ID)) != 'VAT']/cbc:CompanyID"/>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="normalize-space(upper-case(.)) = 'GODKÄND FÖR F-SKATT'"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="normalize-space(upper-case(.)) = 'GODKÄND FÖR F-SKATT'">
               <axsl:attribute name="id">SE-R-005</axsl:attribute>
               <axsl:attribute name="flag">fatal</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-select-full-path"/>
               </axsl:attribute>
               <svrl:text>For Swedish suppliers, when using Seller tax registration identifier, 'Godkänd för F-skatt' must be stated</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>
      <axsl:apply-templates select="@*|*" mode="M26"/>
   </axsl:template>

	<!--RULE -->

   <axsl:template match="//cac:TaxCategory[//cac:AccountingSupplierParty/cac:Party[cac:PostalAddress/cac:Country/cbc:IdentificationCode = 'SE' and cac:PartyTaxScheme[cac:TaxScheme/cbc:ID = 'VAT']/substring(cbc:CompanyID, 1, 2) = 'SE'] and cbc:ID = 'S'] | //cac:ClassifiedTaxCategory[//cac:AccountingSupplierParty/cac:Party[cac:PostalAddress/cac:Country/cbc:IdentificationCode = 'SE' and cac:PartyTaxScheme[cac:TaxScheme/cbc:ID = 'VAT']/substring(cbc:CompanyID, 1, 2) = 'SE'] and cbc:ID = 'S']" priority="1004" mode="M26">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="//cac:TaxCategory[//cac:AccountingSupplierParty/cac:Party[cac:PostalAddress/cac:Country/cbc:IdentificationCode = 'SE' and cac:PartyTaxScheme[cac:TaxScheme/cbc:ID = 'VAT']/substring(cbc:CompanyID, 1, 2) = 'SE'] and cbc:ID = 'S'] | //cac:ClassifiedTaxCategory[//cac:AccountingSupplierParty/cac:Party[cac:PostalAddress/cac:Country/cbc:IdentificationCode = 'SE' and cac:PartyTaxScheme[cac:TaxScheme/cbc:ID = 'VAT']/substring(cbc:CompanyID, 1, 2) = 'SE'] and cbc:ID = 'S']"/>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="number(cbc:Percent) = 25 or number(cbc:Percent) = 12 or number(cbc:Percent) = 6"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="number(cbc:Percent) = 25 or number(cbc:Percent) = 12 or number(cbc:Percent) = 6">
               <axsl:attribute name="id">SE-R-006</axsl:attribute>
               <axsl:attribute name="flag">fatal</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-select-full-path"/>
               </axsl:attribute>
               <svrl:text>For Swedish suppliers, only standard VAT rate of 6, 12 or 25 are used</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>
      <axsl:apply-templates select="@*|*" mode="M26"/>
   </axsl:template>

	<!--RULE -->

   <axsl:template match="//cac:PaymentMeans[//cac:AccountingSupplierParty/cac:Party[cac:PostalAddress/cac:Country/cbc:IdentificationCode = 'SE'] and normalize-space(cbc:PaymentMeansCode) = '30' and normalize-space(cac:PayeeFinancialAccount/cac:FinancialInstitutionBranch/cbc:ID) = 'SE:PLUSGIRO']/cac:PayeeFinancialAccount/cbc:ID" priority="1003" mode="M26">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="//cac:PaymentMeans[//cac:AccountingSupplierParty/cac:Party[cac:PostalAddress/cac:Country/cbc:IdentificationCode = 'SE'] and normalize-space(cbc:PaymentMeansCode) = '30' and normalize-space(cac:PayeeFinancialAccount/cac:FinancialInstitutionBranch/cbc:ID) = 'SE:PLUSGIRO']/cac:PayeeFinancialAccount/cbc:ID"/>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="string(number(normalize-space(.))) != 'NaN'"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="string(number(normalize-space(.))) != 'NaN'">
               <axsl:attribute name="id">SE-R-007</axsl:attribute>
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-select-full-path"/>
               </axsl:attribute>
               <svrl:text>For Swedish suppliers using Plusgiro, the Account ID must be numeric </svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="string-length(normalize-space(.)) &gt;= 2 and string-length(normalize-space(.)) &lt;= 8"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="string-length(normalize-space(.)) &gt;= 2 and string-length(normalize-space(.)) &lt;= 8">
               <axsl:attribute name="id">SE-R-010</axsl:attribute>
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-select-full-path"/>
               </axsl:attribute>
               <svrl:text>For Swedish suppliers using Plusgiro, the Account ID must have 2-8 characters</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>
      <axsl:apply-templates select="@*|*" mode="M26"/>
   </axsl:template>

	<!--RULE -->

   <axsl:template match="//cac:PaymentMeans[//cac:AccountingSupplierParty/cac:Party[cac:PostalAddress/cac:Country/cbc:IdentificationCode = 'SE'] and normalize-space(cbc:PaymentMeansCode) = '30' and normalize-space(cac:PayeeFinancialAccount/cac:FinancialInstitutionBranch/cbc:ID) = 'SE:BANKGIRO']/cac:PayeeFinancialAccount/cbc:ID" priority="1002" mode="M26">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="//cac:PaymentMeans[//cac:AccountingSupplierParty/cac:Party[cac:PostalAddress/cac:Country/cbc:IdentificationCode = 'SE'] and normalize-space(cbc:PaymentMeansCode) = '30' and normalize-space(cac:PayeeFinancialAccount/cac:FinancialInstitutionBranch/cbc:ID) = 'SE:BANKGIRO']/cac:PayeeFinancialAccount/cbc:ID"/>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="string(number(normalize-space(.))) != 'NaN'"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="string(number(normalize-space(.))) != 'NaN'">
               <axsl:attribute name="id">SE-R-008</axsl:attribute>
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-select-full-path"/>
               </axsl:attribute>
               <svrl:text>For Swedish suppliers using Bankgiro, the Account ID must be numeric </svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="string-length(normalize-space(.)) = 7 or string-length(normalize-space(.)) = 8"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="string-length(normalize-space(.)) = 7 or string-length(normalize-space(.)) = 8">
               <axsl:attribute name="id">SE-R-009</axsl:attribute>
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-select-full-path"/>
               </axsl:attribute>
               <svrl:text>For Swedish suppliers using Bankgiro, the Account ID must have 7-8 characters</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>
      <axsl:apply-templates select="@*|*" mode="M26"/>
   </axsl:template>

	<!--RULE -->

   <axsl:template match="//cac:PaymentMeans[//cac:AccountingSupplierParty/cac:Party[cac:PostalAddress/cac:Country/cbc:IdentificationCode = 'SE'] and (cbc:PaymentMeansCode = normalize-space('50') or cbc:PaymentMeansCode = normalize-space('56'))]" priority="1001" mode="M26">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="//cac:PaymentMeans[//cac:AccountingSupplierParty/cac:Party[cac:PostalAddress/cac:Country/cbc:IdentificationCode = 'SE'] and (cbc:PaymentMeansCode = normalize-space('50') or cbc:PaymentMeansCode = normalize-space('56'))]"/>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="false()"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="false()">
               <axsl:attribute name="id">SE-R-011</axsl:attribute>
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-select-full-path"/>
               </axsl:attribute>
               <svrl:text>For Swedish suppliers using Swedish Bankgiro or Plusgiro, the proper way to indicate this is to use Code 30 for PaymentMeans and FinancialInstitutionBranch ID with code SE:BANKGIRO or SE:PLUSGIRO</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>
      <axsl:apply-templates select="@*|*" mode="M26"/>
   </axsl:template>

	<!--RULE -->

   <axsl:template match="//cac:PaymentMeans[//cac:AccountingSupplierParty/cac:Party[cac:PostalAddress/cac:Country/cbc:IdentificationCode = 'SE']  and //cac:AccountingCustomerParty/cac:Party[cac:PostalAddress/cac:Country/cbc:IdentificationCode = 'SE'] and (cbc:PaymentMeansCode = normalize-space('31'))]" priority="1000" mode="M26">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="//cac:PaymentMeans[//cac:AccountingSupplierParty/cac:Party[cac:PostalAddress/cac:Country/cbc:IdentificationCode = 'SE']  and //cac:AccountingCustomerParty/cac:Party[cac:PostalAddress/cac:Country/cbc:IdentificationCode = 'SE'] and (cbc:PaymentMeansCode = normalize-space('31'))]"/>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="false()"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="false()">
               <axsl:attribute name="id">SE-R-012</axsl:attribute>
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-select-full-path"/>
               </axsl:attribute>
               <svrl:text>For domestic transactions between Swedish trading partners, credit transfer should be indicated by PaymentMeansCode="30"</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>
      <axsl:apply-templates select="@*|*" mode="M26"/>
   </axsl:template>
   <axsl:template match="text()" priority="-1" mode="M26"/>
   <axsl:template match="@*|node()" priority="-2" mode="M26">
      <axsl:apply-templates select="@*|*" mode="M26"/>
   </axsl:template>
   <axsl:param name="isGreekSender" select="($supplierCountry ='GR') or ($supplierCountry ='EL')"/>
   <axsl:param name="isGreekReceiver" select="($customerCountry ='GR') or ($customerCountry ='EL')"/>
   <axsl:param name="isGreekSenderandReceiver" select="$isGreekSender and $isGreekReceiver"/>
   <axsl:param name="accountingSupplierCountry" select="     if (/*/cac:AccountingSupplierParty/cac:Party/cac:PartyTaxScheme[cac:TaxScheme/cbc:ID = 'VAT']/substring(cbc:CompanyID, 1, 2)) then     upper-case(normalize-space(/*/cac:AccountingSupplierParty/cac:Party/cac:PartyTaxScheme[cac:TaxScheme/cbc:ID = 'VAT']/substring(cbc:CompanyID, 1, 2)))     else     if (/*/cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode) then     upper-case(normalize-space(/*/cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode))     else     'XX'"/>

<!--PATTERN -->

   <axsl:variable name="dateRegExp" select="'^(0?[1-9]|[12][0-9]|3[01])[-\\/ ]?(0?[1-9]|1[0-2])[-\\/ ]?(19|20)[0-9]{2}'"/>
   <axsl:variable name="greekDocumentType" select="tokenize('1.1 1.2 1.3 1.4 1.5 1.6 2.1 2.2 2.3 2.4 3.1 3.2 4 5.1 5.2 6.1 6.2 7.1 8.1 8.2 11.1 11.2 11.3 11.4 11.5','\s')"/>
   <axsl:variable name="tokenizedUblIssueDate" select="tokenize(/*/cbc:IssueDate,'-')"/>

	<!--RULE -->

   <axsl:template match="/ubl-invoice:Invoice/cbc:ID[$isGreekSender] | /ubl-creditnote:CreditNote/cbc:ID[$isGreekSender]" priority="1008" mode="M32">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="/ubl-invoice:Invoice/cbc:ID[$isGreekSender] | /ubl-creditnote:CreditNote/cbc:ID[$isGreekSender]"/>
      <axsl:variable name="IdSegments" select="tokenize(.,'\|')"/>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="count($IdSegments) = 6"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="count($IdSegments) = 6">
               <axsl:attribute name="id">GR-R-001-1</axsl:attribute>
               <axsl:attribute name="flag">fatal</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-select-full-path"/>
               </axsl:attribute>
               <svrl:text> When the Supplier is Greek, the Invoice Id should consist of 6 segments</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="string-length(normalize-space($IdSegments[1])) = 9                                   and u:TinVerification($IdSegments[1])                                  and ($IdSegments[1] = /*/cac:AccountingSupplierParty/cac:Party/cac:PartyTaxScheme[cac:TaxScheme/cbc:ID = 'VAT']/substring(cbc:CompanyID, 3, 9)                                  or $IdSegments[1] = /*/cac:TaxRepresentativeParty/cac:PartyTaxScheme[cac:TaxScheme/cbc:ID = 'VAT']/substring(cbc:CompanyID, 3, 9) )"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="string-length(normalize-space($IdSegments[1])) = 9 and u:TinVerification($IdSegments[1]) and ($IdSegments[1] = /*/cac:AccountingSupplierParty/cac:Party/cac:PartyTaxScheme[cac:TaxScheme/cbc:ID = 'VAT']/substring(cbc:CompanyID, 3, 9) or $IdSegments[1] = /*/cac:TaxRepresentativeParty/cac:PartyTaxScheme[cac:TaxScheme/cbc:ID = 'VAT']/substring(cbc:CompanyID, 3, 9) )">
               <axsl:attribute name="id">GR-R-001-2</axsl:attribute>
               <axsl:attribute name="flag">fatal</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-select-full-path"/>
               </axsl:attribute>
               <svrl:text>When the Supplier is Greek, the Invoice Id first segment must be a valid TIN Number and match either the Supplier's or the Tax Representative's Tin Number</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>
      <axsl:variable name="tokenizedIdDate" select="tokenize($IdSegments[2],'/')"/>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="string-length(normalize-space($IdSegments[2]))&gt;0                                   and matches($IdSegments[2],$dateRegExp)                                  and ($tokenizedIdDate[1] = $tokenizedUblIssueDate[3]                                     and $tokenizedIdDate[2] = $tokenizedUblIssueDate[2]                                    and $tokenizedIdDate[3] = $tokenizedUblIssueDate[1])"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="string-length(normalize-space($IdSegments[2]))&gt;0 and matches($IdSegments[2],$dateRegExp) and ($tokenizedIdDate[1] = $tokenizedUblIssueDate[3] and $tokenizedIdDate[2] = $tokenizedUblIssueDate[2] and $tokenizedIdDate[3] = $tokenizedUblIssueDate[1])">
               <axsl:attribute name="id">GR-R-001-3</axsl:attribute>
               <axsl:attribute name="flag">fatal</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-select-full-path"/>
               </axsl:attribute>
               <svrl:text>When the Supplier is Greek, the Invoice Id second segment must be a valid Date that matches the invoice Issue Date</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="string-length(normalize-space($IdSegments[3]))&gt;0 and string(number($IdSegments[3])) != 'NaN' and xs:integer($IdSegments[3]) &gt;= 0"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="string-length(normalize-space($IdSegments[3]))&gt;0 and string(number($IdSegments[3])) != 'NaN' and xs:integer($IdSegments[3]) &gt;= 0">
               <axsl:attribute name="id">GR-R-001-4</axsl:attribute>
               <axsl:attribute name="flag">fatal</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-select-full-path"/>
               </axsl:attribute>
               <svrl:text>When Supplier is Greek, the Invoice Id third segment must be a positive integer</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="string-length(normalize-space($IdSegments[4]))&gt;0 and (some $c in $greekDocumentType satisfies $IdSegments[4] = $c)"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="string-length(normalize-space($IdSegments[4]))&gt;0 and (some $c in $greekDocumentType satisfies $IdSegments[4] = $c)">
               <axsl:attribute name="id">GR-R-001-5</axsl:attribute>
               <axsl:attribute name="flag">fatal</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-select-full-path"/>
               </axsl:attribute>
               <svrl:text>When Supplier is Greek, the Invoice Id in the fourth segment must be a valid greek document type</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="string-length($IdSegments[5]) &gt; 0 "/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="string-length($IdSegments[5]) &gt; 0">
               <axsl:attribute name="id">GR-R-001-6</axsl:attribute>
               <axsl:attribute name="flag">fatal</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-select-full-path"/>
               </axsl:attribute>
               <svrl:text>When Supplier is Greek, the Invoice Id fifth segment must not be empty</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="string-length($IdSegments[6]) &gt; 0 "/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="string-length($IdSegments[6]) &gt; 0">
               <axsl:attribute name="id">GR-R-001-7</axsl:attribute>
               <axsl:attribute name="flag">fatal</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-select-full-path"/>
               </axsl:attribute>
               <svrl:text>When Supplier is Greek, the Invoice Id sixth segment must not be empty</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>
      <axsl:apply-templates select="@*|*" mode="M32"/>
   </axsl:template>

	<!--RULE -->

   <axsl:template match="cac:AccountingSupplierParty[$isGreekSender]/cac:Party" priority="1007" mode="M32">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="cac:AccountingSupplierParty[$isGreekSender]/cac:Party"/>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="string-length(./cac:PartyName/cbc:Name)&gt;0"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="string-length(./cac:PartyName/cbc:Name)&gt;0">
               <axsl:attribute name="id">GR-R-002</axsl:attribute>
               <axsl:attribute name="flag">fatal</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-select-full-path"/>
               </axsl:attribute>
               <svrl:text>Greek Suppliers must provide their full name as they are registered in the  Greek Business Registry (G.E.MH.) as a legal entity or in the Tax Registry as a natural person </svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="     count(cac:PartyTaxScheme[normalize-space(cac:TaxScheme/cbc:ID) = 'VAT']/cbc:CompanyID) = 1 or     count(/ubl-invoice:Invoice/cac:TaxRepresentativeParty) = 1"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="count(cac:PartyTaxScheme[normalize-space(cac:TaxScheme/cbc:ID) = 'VAT']/cbc:CompanyID) = 1 or count(/ubl-invoice:Invoice/cac:TaxRepresentativeParty) = 1">
               <axsl:attribute name="id">GR-R-007-1</axsl:attribute>
               <axsl:attribute name="flag">fatal</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-select-full-path"/>
               </axsl:attribute>
               <svrl:text>When greek supplier does not have a VAT number, the tax representative must be present</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>
      <axsl:apply-templates select="@*|*" mode="M32"/>
   </axsl:template>

	<!--RULE -->

   <axsl:template match="cac:TaxRepresentativeParty[$isGreekSender]" priority="1006" mode="M32">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="cac:TaxRepresentativeParty[$isGreekSender]"/>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="string-length(normalize-space(cac:PartyName/cbc:Name))&gt;0"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="string-length(normalize-space(cac:PartyName/cbc:Name))&gt;0">
               <axsl:attribute name="id">GR-R-007-2</axsl:attribute>
               <axsl:attribute name="flag">fatal</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-select-full-path"/>
               </axsl:attribute>
               <svrl:text>If the Greek Suppliers do not have Greek VAT they must provide the full name of their tax representative in Greece</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="count(cac:PartyTaxScheme[normalize-space(cac:TaxScheme/cbc:ID) = 'VAT']/cbc:CompanyID)=1 and     substring(cac:PartyTaxScheme[normalize-space(cac:TaxScheme/cbc:ID) = 'VAT']/cbc:CompanyID,1,2) = 'EL' and     u:TinVerification(substring(cac:PartyTaxScheme[normalize-space(cac:TaxScheme/cbc:ID) = 'VAT']/cbc:CompanyID,3))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="count(cac:PartyTaxScheme[normalize-space(cac:TaxScheme/cbc:ID) = 'VAT']/cbc:CompanyID)=1 and substring(cac:PartyTaxScheme[normalize-space(cac:TaxScheme/cbc:ID) = 'VAT']/cbc:CompanyID,1,2) = 'EL' and u:TinVerification(substring(cac:PartyTaxScheme[normalize-space(cac:TaxScheme/cbc:ID) = 'VAT']/cbc:CompanyID,3))">
               <axsl:attribute name="id">GR-R-007-3</axsl:attribute>
               <axsl:attribute name="flag">fatal</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-select-full-path"/>
               </axsl:attribute>
               <svrl:text>If the Greek Suppliers do not have Greek VAT, they must provide the VAT number of their tax representative</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>
      <axsl:apply-templates select="@*|*" mode="M32"/>
   </axsl:template>

	<!--RULE -->

   <axsl:template match="cac:AccountingSupplierParty[$isGreekSender]/cac:Party/cac:PartyTaxScheme[normalize-space(cac:TaxScheme/cbc:ID) = 'VAT']/cbc:CompanyID" priority="1005" mode="M32">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="cac:AccountingSupplierParty[$isGreekSender]/cac:Party/cac:PartyTaxScheme[normalize-space(cac:TaxScheme/cbc:ID) = 'VAT']/cbc:CompanyID"/>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="substring(.,1,2) = 'EL' and u:TinVerification(substring(.,3))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="substring(.,1,2) = 'EL' and u:TinVerification(substring(.,3))">
               <axsl:attribute name="id">GR-R-003</axsl:attribute>
               <axsl:attribute name="flag">fatal</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-select-full-path"/>
               </axsl:attribute>
               <svrl:text>For the Greek Suppliers, the VAT must start with 'EL' and must be a valid TIN number</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>
      <axsl:apply-templates select="@*|*" mode="M32"/>
   </axsl:template>

	<!--RULE -->

   <axsl:template match="/ubl-invoice:Invoice[$isGreekSender] | /ubl-creditnote:CreditNote[$isGreekSender]" priority="1004" mode="M32">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="/ubl-invoice:Invoice[$isGreekSender] | /ubl-creditnote:CreditNote[$isGreekSender]"/>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="count(cac:AdditionalDocumentReference[cbc:DocumentDescription = '##M.AR.K##'])=1"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="count(cac:AdditionalDocumentReference[cbc:DocumentDescription = '##M.AR.K##'])=1">
               <axsl:attribute name="id">GR-R-004-1</axsl:attribute>
               <axsl:attribute name="flag">fatal</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-select-full-path"/>
               </axsl:attribute>
               <svrl:text> When Supplier is Greek, there must be one MARK Number</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="count(cac:AdditionalDocumentReference[cbc:DocumentDescription = '##INVOICE-URL##'])=1"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="count(cac:AdditionalDocumentReference[cbc:DocumentDescription = '##INVOICE-URL##'])=1">
               <axsl:attribute name="id">GR-S-008-1</axsl:attribute>
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-select-full-path"/>
               </axsl:attribute>
               <svrl:text> When Supplier is Greek, there should be one invoice url</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="(count(cac:AdditionalDocumentReference[cbc:DocumentDescription = '##INVOICE-URL##']) = 0 ) or (count(cac:AdditionalDocumentReference[cbc:DocumentDescription = '##INVOICE-URL##']) = 1 )"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="(count(cac:AdditionalDocumentReference[cbc:DocumentDescription = '##INVOICE-URL##']) = 0 ) or (count(cac:AdditionalDocumentReference[cbc:DocumentDescription = '##INVOICE-URL##']) = 1 )">
               <axsl:attribute name="id">GR-R-008-2</axsl:attribute>
               <axsl:attribute name="flag">fatal</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-select-full-path"/>
               </axsl:attribute>
               <svrl:text> When Supplier is Greek, there should be no more than one invoice url</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>
      <axsl:apply-templates select="@*|*" mode="M32"/>
   </axsl:template>

	<!--RULE -->

   <axsl:template match="cac:AdditionalDocumentReference[$isGreekSender and cbc:DocumentDescription = '##M.AR.K##']/cbc:ID" priority="1003" mode="M32">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="cac:AdditionalDocumentReference[$isGreekSender and cbc:DocumentDescription = '##M.AR.K##']/cbc:ID"/>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="matches(.,'^[1-9]([0-9]*)')"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="matches(.,'^[1-9]([0-9]*)')">
               <axsl:attribute name="id">GR-R-004-2</axsl:attribute>
               <axsl:attribute name="flag">fatal</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-select-full-path"/>
               </axsl:attribute>
               <svrl:text> When Supplier is Greek, the MARK Number must be a positive integer</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>
      <axsl:apply-templates select="@*|*" mode="M32"/>
   </axsl:template>

	<!--RULE -->

   <axsl:template match="cac:AdditionalDocumentReference[$isGreekSender and cbc:DocumentDescription = '##INVOICE-URL##']" priority="1002" mode="M32">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="cac:AdditionalDocumentReference[$isGreekSender and cbc:DocumentDescription = '##INVOICE-URL##']"/>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="string-length(normalize-space(cac:Attachment/cac:ExternalReference/cbc:URI))&gt;0"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="string-length(normalize-space(cac:Attachment/cac:ExternalReference/cbc:URI))&gt;0">
               <axsl:attribute name="id">GR-R-008-3</axsl:attribute>
               <axsl:attribute name="flag">fatal</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-select-full-path"/>
               </axsl:attribute>
               <svrl:text>When Supplier is Greek and the INVOICE URL Document reference exists, the External Reference URI should be present</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>
      <axsl:apply-templates select="@*|*" mode="M32"/>
   </axsl:template>

	<!--RULE -->

   <axsl:template match="cac:AccountingCustomerParty[$isGreekSender]/cac:Party" priority="1001" mode="M32">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="cac:AccountingCustomerParty[$isGreekSender]/cac:Party"/>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="string-length(./cac:PartyName/cbc:Name)&gt;0"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="string-length(./cac:PartyName/cbc:Name)&gt;0">
               <axsl:attribute name="id">GR-R-005</axsl:attribute>
               <axsl:attribute name="flag">fatal</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-select-full-path"/>
               </axsl:attribute>
               <svrl:text>Greek Suppliers must provide the full name of the buyer</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>
      <axsl:apply-templates select="@*|*" mode="M32"/>
   </axsl:template>

	<!--RULE -->

   <axsl:template match="cac:AccountingSupplierParty/cac:Party[$accountingSupplierCountry='GR' or $accountingSupplierCountry='EL']/cbc:EndpointID" priority="1000" mode="M32">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="cac:AccountingSupplierParty/cac:Party[$accountingSupplierCountry='GR' or $accountingSupplierCountry='EL']/cbc:EndpointID"/>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="./@schemeID='9933' and u:TinVerification(.)"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="./@schemeID='9933' and u:TinVerification(.)">
               <axsl:attribute name="id">GR-R-009</axsl:attribute>
               <axsl:attribute name="flag">fatal</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-select-full-path"/>
               </axsl:attribute>
               <svrl:text>Greek suppliers that send an invoice through the PEPPOL network must use a correct TIN number as an electronic address according to PEPPOL Electronic Address Identifier scheme (schemeID 9933).</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>
      <axsl:apply-templates select="@*|*" mode="M32"/>
   </axsl:template>
   <axsl:template match="text()" priority="-1" mode="M32"/>
   <axsl:template match="@*|node()" priority="-2" mode="M32">
      <axsl:apply-templates select="@*|*" mode="M32"/>
   </axsl:template>

<!--PATTERN -->


	<!--RULE -->

   <axsl:template match="cac:AccountingCustomerParty[$isGreekSenderandReceiver]/cac:Party" priority="1001" mode="M33">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="cac:AccountingCustomerParty[$isGreekSenderandReceiver]/cac:Party"/>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="count(cac:PartyTaxScheme[normalize-space(cac:TaxScheme/cbc:ID) = 'VAT']/cbc:CompanyID)=1 and                             substring(cac:PartyTaxScheme[normalize-space(cac:TaxScheme/cbc:ID) = 'VAT']/cbc:CompanyID,1,2) = 'EL' and                             u:TinVerification(substring(cac:PartyTaxScheme[normalize-space(cac:TaxScheme/cbc:ID) = 'VAT']/cbc:CompanyID,3))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="count(cac:PartyTaxScheme[normalize-space(cac:TaxScheme/cbc:ID) = 'VAT']/cbc:CompanyID)=1 and substring(cac:PartyTaxScheme[normalize-space(cac:TaxScheme/cbc:ID) = 'VAT']/cbc:CompanyID,1,2) = 'EL' and u:TinVerification(substring(cac:PartyTaxScheme[normalize-space(cac:TaxScheme/cbc:ID) = 'VAT']/cbc:CompanyID,3))">
               <axsl:attribute name="id">GR-R-006</axsl:attribute>
               <axsl:attribute name="flag">fatal</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-select-full-path"/>
               </axsl:attribute>
               <svrl:text>Greek Suppliers must provide the VAT number of the buyer, if the buyer is Greek </svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>
      <axsl:apply-templates select="@*|*" mode="M33"/>
   </axsl:template>

	<!--RULE -->

   <axsl:template match="cac:AccountingCustomerParty[$isGreekSenderandReceiver]/cac:Party/cbc:EndpointID" priority="1000" mode="M33">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="cac:AccountingCustomerParty[$isGreekSenderandReceiver]/cac:Party/cbc:EndpointID"/>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="./@schemeID='9933' and u:TinVerification(.)"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="./@schemeID='9933' and u:TinVerification(.)">
               <axsl:attribute name="id">GR-R-010</axsl:attribute>
               <axsl:attribute name="flag">fatal</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-select-full-path"/>
               </axsl:attribute>
               <svrl:text>Greek Suppliers that send an invoice through the PEPPOL network to a greek buyer must use a correct TIN number as an electronic address according to PEPPOL Electronic Address Identifier scheme (SchemeID 9933)</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>
      <axsl:apply-templates select="@*|*" mode="M33"/>
   </axsl:template>
   <axsl:template match="text()" priority="-1" mode="M33"/>
   <axsl:template match="@*|node()" priority="-2" mode="M33">
      <axsl:apply-templates select="@*|*" mode="M33"/>
   </axsl:template>

<!--PATTERN -->

   <axsl:variable name="SupplierCountry" select="concat(ubl-creditnote:CreditNote/cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode, ubl-invoice:Invoice/cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode)"/>
   <axsl:variable name="CustomerCountry" select="concat(ubl-creditnote:CreditNote/cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode, ubl-invoice:Invoice/cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode)"/>

	<!--RULE -->

   <axsl:template match="ubl-creditnote:CreditNote[$SupplierCountry = 'IS'] | ubl-invoice:Invoice[$SupplierCountry = 'IS']" priority="1001" mode="M34">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="ubl-creditnote:CreditNote[$SupplierCountry = 'IS'] | ubl-invoice:Invoice[$SupplierCountry = 'IS']"/>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="( ( not(contains(normalize-space(cbc:InvoiceTypeCode),' ')) and contains( ' 380 381 ',concat(' ',normalize-space(cbc:InvoiceTypeCode),' ') ) ) ) or ( ( not(contains(normalize-space(cbc:CreditNoteTypeCode),' ')) and contains( ' 380 381 ',concat(' ',normalize-space(cbc:CreditNoteTypeCode),' ') ) ) )"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="( ( not(contains(normalize-space(cbc:InvoiceTypeCode),' ')) and contains( ' 380 381 ',concat(' ',normalize-space(cbc:InvoiceTypeCode),' ') ) ) ) or ( ( not(contains(normalize-space(cbc:CreditNoteTypeCode),' ')) and contains( ' 380 381 ',concat(' ',normalize-space(cbc:CreditNoteTypeCode),' ') ) ) )">
               <axsl:attribute name="id">IS-R-001</axsl:attribute>
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-select-full-path"/>
               </axsl:attribute>
               <svrl:text>[IS-R-001]-If seller is icelandic then invoice type should be 380 or 381 — Ef seljandi er íslenskur þá ætti gerð reiknings (BT-3) að vera sölureikningur (380) eða kreditreikningur (381).</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="exists(cac:AccountingSupplierParty/cac:Party/cac:PartyLegalEntity/cbc:CompanyID) and cac:AccountingSupplierParty/cac:Party/cac:PartyLegalEntity/cbc:CompanyID/@schemeID = '0196'"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="exists(cac:AccountingSupplierParty/cac:Party/cac:PartyLegalEntity/cbc:CompanyID) and cac:AccountingSupplierParty/cac:Party/cac:PartyLegalEntity/cbc:CompanyID/@schemeID = '0196'">
               <axsl:attribute name="id">IS-R-002</axsl:attribute>
               <axsl:attribute name="flag">fatal</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-select-full-path"/>
               </axsl:attribute>
               <svrl:text>[IS-R-002]-If seller is icelandic then it shall contain sellers legal id — Ef seljandi er íslenskur þá skal reikningur innihalda íslenska kennitölu seljanda (BT-30).</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="exists(cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cbc:StreetName) and exists(cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cbc:PostalZone)"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="exists(cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cbc:StreetName) and exists(cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cbc:PostalZone)">
               <axsl:attribute name="id">IS-R-003</axsl:attribute>
               <axsl:attribute name="flag">fatal</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-select-full-path"/>
               </axsl:attribute>
               <svrl:text>[IS-R-003]-If seller is icelandic then it shall contain his address with street name and zip code — Ef seljandi er íslenskur þá skal heimilisfang seljanda innihalda götuheiti og póstnúmer (BT-35 og BT-38).</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="exists(cac:PaymentMeans[cbc:PaymentMeansCode = '9']/cac:PayeeFinancialAccount/cbc:ID)         and string-length(normalize-space(cac:PaymentMeans[cbc:PaymentMeansCode = '9']/cac:PayeeFinancialAccount/cbc:ID)) = 12        or not(exists(cac:PaymentMeans[cbc:PaymentMeansCode = '9']))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="exists(cac:PaymentMeans[cbc:PaymentMeansCode = '9']/cac:PayeeFinancialAccount/cbc:ID) and string-length(normalize-space(cac:PaymentMeans[cbc:PaymentMeansCode = '9']/cac:PayeeFinancialAccount/cbc:ID)) = 12 or not(exists(cac:PaymentMeans[cbc:PaymentMeansCode = '9']))">
               <axsl:attribute name="id">IS-R-006</axsl:attribute>
               <axsl:attribute name="flag">fatal</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-select-full-path"/>
               </axsl:attribute>
               <svrl:text>[IS-R-006]-If seller is icelandic and payment means code is 9 then a 12 digit account id must exist — Ef seljandi er íslenskur og greiðslumáti (BT-81) er krafa (kóti 9) þá skal koma fram 12 stafa númer (bankanúmer, höfuðbók 66 og reikningsnúmer) (BT-84)</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="exists(cac:PaymentMeans[cbc:PaymentMeansCode = '42']/cac:PayeeFinancialAccount/cbc:ID)         and string-length(normalize-space(cac:PaymentMeans[cbc:PaymentMeansCode = '42']/cac:PayeeFinancialAccount/cbc:ID)) = 12        or not(exists(cac:PaymentMeans[cbc:PaymentMeansCode = '42']))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="exists(cac:PaymentMeans[cbc:PaymentMeansCode = '42']/cac:PayeeFinancialAccount/cbc:ID) and string-length(normalize-space(cac:PaymentMeans[cbc:PaymentMeansCode = '42']/cac:PayeeFinancialAccount/cbc:ID)) = 12 or not(exists(cac:PaymentMeans[cbc:PaymentMeansCode = '42']))">
               <axsl:attribute name="id">IS-R-007</axsl:attribute>
               <axsl:attribute name="flag">fatal</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-select-full-path"/>
               </axsl:attribute>
               <svrl:text>[IS-R-007]-If seller is icelandic and payment means code is 42 then a 12 digit account id must exist  — Ef seljandi er íslenskur og greiðslumáti (BT-81) er millifærsla (kóti 42) þá skal koma fram 12 stafa reikningnúmer (BT-84)</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="(exists(cac:AdditionalDocumentReference[cbc:DocumentDescription = 'EINDAGI']) and string-length(cac:AdditionalDocumentReference[cbc:DocumentDescription = 'EINDAGI']/cbc:ID) = 10 and (string(cac:AdditionalDocumentReference[cbc:DocumentDescription = 'EINDAGI']/cbc:ID) castable as xs:date)) or not(exists(cac:AdditionalDocumentReference[cbc:DocumentDescription = 'EINDAGI']))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="(exists(cac:AdditionalDocumentReference[cbc:DocumentDescription = 'EINDAGI']) and string-length(cac:AdditionalDocumentReference[cbc:DocumentDescription = 'EINDAGI']/cbc:ID) = 10 and (string(cac:AdditionalDocumentReference[cbc:DocumentDescription = 'EINDAGI']/cbc:ID) castable as xs:date)) or not(exists(cac:AdditionalDocumentReference[cbc:DocumentDescription = 'EINDAGI']))">
               <axsl:attribute name="id">IS-R-008</axsl:attribute>
               <axsl:attribute name="flag">fatal</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-select-full-path"/>
               </axsl:attribute>
               <svrl:text>[IS-R-008]-If seller is icelandic and invoice contains supporting description EINDAGI then the id form must be YYYY-MM-DD — Ef seljandi er íslenskur þá skal eindagi (BT-122, DocumentDescription = EINDAGI) vera á forminu YYYY-MM-DD.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="(exists(cac:AdditionalDocumentReference[cbc:DocumentDescription = 'EINDAGI']) and exists(cbc:DueDate)) or not(exists(cac:AdditionalDocumentReference[cbc:DocumentDescription = 'EINDAGI']))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="(exists(cac:AdditionalDocumentReference[cbc:DocumentDescription = 'EINDAGI']) and exists(cbc:DueDate)) or not(exists(cac:AdditionalDocumentReference[cbc:DocumentDescription = 'EINDAGI']))">
               <axsl:attribute name="id">IS-R-009</axsl:attribute>
               <axsl:attribute name="flag">fatal</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-select-full-path"/>
               </axsl:attribute>
               <svrl:text>[IS-R-009]-If seller is icelandic and invoice contains supporting description EINDAGI invoice must have due date — Ef seljandi er íslenskur þá skal reikningur sem inniheldur eindaga (BT-122, DocumentDescription = EINDAGI) einnig hafa gjalddaga (BT-9).</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="(exists(cac:AdditionalDocumentReference[cbc:DocumentDescription = 'EINDAGI']) and (cbc:DueDate) &lt;= (cac:AdditionalDocumentReference[cbc:DocumentDescription = 'EINDAGI']/cbc:ID)) or not(exists(cac:AdditionalDocumentReference[cbc:DocumentDescription = 'EINDAGI']))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="(exists(cac:AdditionalDocumentReference[cbc:DocumentDescription = 'EINDAGI']) and (cbc:DueDate) &lt;= (cac:AdditionalDocumentReference[cbc:DocumentDescription = 'EINDAGI']/cbc:ID)) or not(exists(cac:AdditionalDocumentReference[cbc:DocumentDescription = 'EINDAGI']))">
               <axsl:attribute name="id">IS-R-010</axsl:attribute>
               <axsl:attribute name="flag">fatal</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-select-full-path"/>
               </axsl:attribute>
               <svrl:text>[IS-R-010]-If seller is icelandic and invoice contains supporting description EINDAGI the id date must be same or later than due date — Ef seljandi er íslenskur þá skal eindagi (BT-122, DocumentDescription = EINDAGI) skal vera sami eða síðar en gjalddagi (BT-9) ef eindagi er til staðar.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>
      <axsl:apply-templates select="@*|*" mode="M34"/>
   </axsl:template>

	<!--RULE -->

   <axsl:template match="ubl-creditnote:CreditNote[$SupplierCountry = 'IS' and $CustomerCountry = 'IS']/cac:AccountingCustomerParty | ubl-invoice:Invoice[$SupplierCountry = 'IS' and $CustomerCountry = 'IS']/cac:AccountingCustomerParty" priority="1000" mode="M34">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="ubl-creditnote:CreditNote[$SupplierCountry = 'IS' and $CustomerCountry = 'IS']/cac:AccountingCustomerParty | ubl-invoice:Invoice[$SupplierCountry = 'IS' and $CustomerCountry = 'IS']/cac:AccountingCustomerParty"/>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="exists(cac:Party/cac:PartyLegalEntity/cbc:CompanyID) and cac:Party/cac:PartyLegalEntity/cbc:CompanyID/@schemeID = '0196'"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="exists(cac:Party/cac:PartyLegalEntity/cbc:CompanyID) and cac:Party/cac:PartyLegalEntity/cbc:CompanyID/@schemeID = '0196'">
               <axsl:attribute name="id">IS-R-004</axsl:attribute>
               <axsl:attribute name="flag">fatal</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-select-full-path"/>
               </axsl:attribute>
               <svrl:text>[IS-R-004]-If seller and buyer are icelandic then the invoice shall contain the buyers icelandic legal identifier — Ef seljandi og kaupandi eru íslenskir þá skal reikningurinn innihalda íslenska kennitölu kaupanda (BT-47).</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="exists(cac:Party/cac:PostalAddress/cbc:StreetName) and exists(cac:Party/cac:PostalAddress/cbc:PostalZone)"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="exists(cac:Party/cac:PostalAddress/cbc:StreetName) and exists(cac:Party/cac:PostalAddress/cbc:PostalZone)">
               <axsl:attribute name="id">IS-R-005</axsl:attribute>
               <axsl:attribute name="flag">fatal</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-select-full-path"/>
               </axsl:attribute>
               <svrl:text>[IS-R-005]-If seller and buyer are icelandic then the invoice shall contain the buyers address with street name and zip code  — Ef seljandi og kaupandi eru íslenskir þá skal heimilisfang kaupanda innihalda götuheiti og póstnúmer (BT-50 og BT-53)</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>
      <axsl:apply-templates select="@*|*" mode="M34"/>
   </axsl:template>
   <axsl:template match="text()" priority="-1" mode="M34"/>
   <axsl:template match="@*|node()" priority="-2" mode="M34">
      <axsl:apply-templates select="@*|*" mode="M34"/>
   </axsl:template>

<!--PATTERN -->

   <axsl:variable name="supplierCountryIsNL" select="(upper-case(normalize-space(/*/cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode)) = 'NL')"/>
   <axsl:variable name="customerCountryIsNL" select="(upper-case(normalize-space(/*/cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode)) = 'NL')"/>
   <axsl:variable name="taxRepresentativeCountryIsNL" select="(upper-case(normalize-space(/*/cac:TaxRepresentativeParty/cac:PostalAddress/cac:Country/cbc:IdentificationCode)) = 'NL')"/>

	<!--RULE -->

   <axsl:template match="cbc:CreditNoteTypeCode[$supplierCountryIsNL]" priority="1008" mode="M35">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="cbc:CreditNoteTypeCode[$supplierCountryIsNL]"/>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="/*/cac:BillingReference/cac:InvoiceDocumentReference/cbc:ID"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="/*/cac:BillingReference/cac:InvoiceDocumentReference/cbc:ID">
               <axsl:attribute name="id">NL-R-001</axsl:attribute>
               <axsl:attribute name="flag">fatal</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-select-full-path"/>
               </axsl:attribute>
               <svrl:text>[NL-R-001] For suppliers in the Netherlands, if the document is a creditnote, the document MUST contain an invoice reference (cac:BillingReference/cac:InvoiceDocumentReference/cbc:ID)</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>
      <axsl:apply-templates select="@*|*" mode="M35"/>
   </axsl:template>

	<!--RULE -->

   <axsl:template match="cac:AccountingSupplierParty/cac:Party/cac:PostalAddress[$supplierCountryIsNL]" priority="1007" mode="M35">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="cac:AccountingSupplierParty/cac:Party/cac:PostalAddress[$supplierCountryIsNL]"/>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="cbc:StreetName and cbc:CityName and cbc:PostalZone"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="cbc:StreetName and cbc:CityName and cbc:PostalZone">
               <axsl:attribute name="id">NL-R-002</axsl:attribute>
               <axsl:attribute name="flag">fatal</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-select-full-path"/>
               </axsl:attribute>
               <svrl:text>[NL-R-002] For suppliers in the Netherlands the supplier's address (cac:AccountingSupplierParty/cac:Party/cac:PostalAddress) MUST contain street name (cbc:StreetName), city (cbc:CityName) and post code (cbc:PostalZone)</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>
      <axsl:apply-templates select="@*|*" mode="M35"/>
   </axsl:template>

	<!--RULE -->

   <axsl:template match="cac:AccountingSupplierParty/cac:Party/cac:PartyLegalEntity/cbc:CompanyID[$supplierCountryIsNL]" priority="1006" mode="M35">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="cac:AccountingSupplierParty/cac:Party/cac:PartyLegalEntity/cbc:CompanyID[$supplierCountryIsNL]"/>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="(contains(concat(' ', string-join(@schemeID, ' '), ' '), ' 0106 ') or contains(concat(' ', string-join(@schemeID, ' '), ' '), ' 0190 ')) and (normalize-space(.) != '')"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="(contains(concat(' ', string-join(@schemeID, ' '), ' '), ' 0106 ') or contains(concat(' ', string-join(@schemeID, ' '), ' '), ' 0190 ')) and (normalize-space(.) != '')">
               <axsl:attribute name="id">NL-R-003</axsl:attribute>
               <axsl:attribute name="flag">fatal</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-select-full-path"/>
               </axsl:attribute>
               <svrl:text>[NL-R-003] For suppliers in the Netherlands, the legal entity identifier MUST be either a KVK or OIN number (schemeID 0106 or 0190)</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>
      <axsl:apply-templates select="@*|*" mode="M35"/>
   </axsl:template>

	<!--RULE -->

   <axsl:template match="cac:AccountingCustomerParty/cac:Party/cac:PostalAddress[$supplierCountryIsNL and $customerCountryIsNL]" priority="1005" mode="M35">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="cac:AccountingCustomerParty/cac:Party/cac:PostalAddress[$supplierCountryIsNL and $customerCountryIsNL]"/>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="cbc:StreetName and cbc:CityName and cbc:PostalZone"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="cbc:StreetName and cbc:CityName and cbc:PostalZone">
               <axsl:attribute name="id">NL-R-004</axsl:attribute>
               <axsl:attribute name="flag">fatal</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-select-full-path"/>
               </axsl:attribute>
               <svrl:text>[NL-R-004] For suppliers in the Netherlands, if the customer is in the Netherlands, the customer address (cac:AccountingCustomerParty/cac:Party/cac:PostalAddress) MUST contain the street name (cbc:StreetName), the city (cbc:CityName) and post code (cbc:PostalZone)</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>
      <axsl:apply-templates select="@*|*" mode="M35"/>
   </axsl:template>

	<!--RULE -->

   <axsl:template match="cac:AccountingCustomerParty/cac:Party/cac:PartyLegalEntity/cbc:CompanyID[$supplierCountryIsNL and $customerCountryIsNL]" priority="1004" mode="M35">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="cac:AccountingCustomerParty/cac:Party/cac:PartyLegalEntity/cbc:CompanyID[$supplierCountryIsNL and $customerCountryIsNL]"/>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="(contains(concat(' ', string-join(@schemeID, ' '), ' '), ' 0106 ') or contains(concat(' ', string-join(@schemeID, ' '), ' '), ' 0190 ')) and (normalize-space(.) != '')"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="(contains(concat(' ', string-join(@schemeID, ' '), ' '), ' 0106 ') or contains(concat(' ', string-join(@schemeID, ' '), ' '), ' 0190 ')) and (normalize-space(.) != '')">
               <axsl:attribute name="id">NL-R-005</axsl:attribute>
               <axsl:attribute name="flag">fatal</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-select-full-path"/>
               </axsl:attribute>
               <svrl:text>[NL-R-005] For suppliers in the Netherlands, if the customer is in the Netherlands, the customer's legal entity identifier MUST be either a KVK or OIN number (schemeID 0106 or 0190)</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>
      <axsl:apply-templates select="@*|*" mode="M35"/>
   </axsl:template>

	<!--RULE -->

   <axsl:template match="cac:TaxRepresentativeParty/cac:PostalAddress[$supplierCountryIsNL and $taxRepresentativeCountryIsNL]" priority="1003" mode="M35">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="cac:TaxRepresentativeParty/cac:PostalAddress[$supplierCountryIsNL and $taxRepresentativeCountryIsNL]"/>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="cbc:StreetName and cbc:CityName and cbc:PostalZone"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="cbc:StreetName and cbc:CityName and cbc:PostalZone">
               <axsl:attribute name="id">NL-R-006</axsl:attribute>
               <axsl:attribute name="flag">fatal</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-select-full-path"/>
               </axsl:attribute>
               <svrl:text>[NL-R-006] For suppliers in the Netherlands, if the fiscal representative is in the Netherlands, the representative's address (cac:TaxRepresentativeParty/cac:PostalAddress) MUST contain street name (cbc:StreetName), city (cbc:CityName) and post code (cbc:PostalZone)</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>
      <axsl:apply-templates select="@*|*" mode="M35"/>
   </axsl:template>

	<!--RULE -->

   <axsl:template match="cac:LegalMonetaryTotal[$supplierCountryIsNL]" priority="1002" mode="M35">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="cac:LegalMonetaryTotal[$supplierCountryIsNL]"/>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="xs:decimal(cbc:PayableAmount) &lt;= 0.0 or (//cac:PaymentMeans)"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="xs:decimal(cbc:PayableAmount) &lt;= 0.0 or (//cac:PaymentMeans)">
               <axsl:attribute name="id">NL-R-007</axsl:attribute>
               <axsl:attribute name="flag">fatal</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-select-full-path"/>
               </axsl:attribute>
               <svrl:text>[NL-R-007] For suppliers in the Netherlands, the supplier MUST provide a means of payment (cac:PaymentMeans) if the payment is from customer to supplier</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>
      <axsl:apply-templates select="@*|*" mode="M35"/>
   </axsl:template>

	<!--RULE -->

   <axsl:template match="cac:PaymentMeans[$supplierCountryIsNL]" priority="1001" mode="M35">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="cac:PaymentMeans[$supplierCountryIsNL]"/>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="normalize-space(cbc:PaymentMeansCode) = '30' or         normalize-space(cbc:PaymentMeansCode) = '48' or         normalize-space(cbc:PaymentMeansCode) = '49' or         normalize-space(cbc:PaymentMeansCode) = '57' or         normalize-space(cbc:PaymentMeansCode) = '58' or         normalize-space(cbc:PaymentMeansCode) = '59'"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="normalize-space(cbc:PaymentMeansCode) = '30' or normalize-space(cbc:PaymentMeansCode) = '48' or normalize-space(cbc:PaymentMeansCode) = '49' or normalize-space(cbc:PaymentMeansCode) = '57' or normalize-space(cbc:PaymentMeansCode) = '58' or normalize-space(cbc:PaymentMeansCode) = '59'">
               <axsl:attribute name="id">NL-R-008</axsl:attribute>
               <axsl:attribute name="flag">fatal</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-select-full-path"/>
               </axsl:attribute>
               <svrl:text>[NL-R-008] For suppliers in the Netherlands, the payment means code (cac:PaymentMeans/cbc:PaymentMeansCode) MUST be one of 30, 48, 49, 57, 58 or 59</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>
      <axsl:apply-templates select="@*|*" mode="M35"/>
   </axsl:template>

	<!--RULE -->

   <axsl:template match="cac:OrderLineReference/cbc:LineID[$supplierCountryIsNL]" priority="1000" mode="M35">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="cac:OrderLineReference/cbc:LineID[$supplierCountryIsNL]"/>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="exists(/*/cac:OrderReference/cbc:ID)"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="exists(/*/cac:OrderReference/cbc:ID)">
               <axsl:attribute name="id">NL-R-009</axsl:attribute>
               <axsl:attribute name="flag">fatal</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-select-full-path"/>
               </axsl:attribute>
               <svrl:text>[NL-R-009] For suppliers in the Netherlands, if an order line reference (cac:OrderLineReference/cbc:LineID) is used, there must be an order reference on the document level (cac:OrderReference/cbc:ID)</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>
      <axsl:apply-templates select="@*|*" mode="M35"/>
   </axsl:template>
   <axsl:template match="text()" priority="-1" mode="M35"/>
   <axsl:template match="@*|node()" priority="-2" mode="M35">
      <axsl:apply-templates select="@*|*" mode="M35"/>
   </axsl:template>

<!--PATTERN -->

   <axsl:variable name="ISO3166" select="tokenize('AD AE AF AG AI AL AM AO AQ AR AS AT AU AW AX AZ BA BB BD BE BF BG BH BI BJ BL BM BN BO BQ BR BS BT BV BW BY BZ CA CC CD CF CG CH CI CK CL CM CN CO CR CU CV CW CX CY CZ DE DJ DK DM DO DZ EC EE EG EH ER ES ET FI FJ FK FM FO FR GA GB GD GE GF GG GH GI GL GM GN GP GQ GR GS GT GU GW GY HK HM HN HR HT HU ID IE IL IM IN IO IQ IR IS IT JE JM JO JP KE KG KH KI KM KN KP KR KW KY KZ LA LB LC LI LK LR LS LT LU LV LY MA MC MD ME MF MG MH MK ML MM MN MO MP MQ MR MS MT MU MV MW MX MY MZ NA NC NE NF NG NI NL NO NP NR NU NZ OM PA PE PF PG PH PK PL PM PN PR PS PT PW PY QA RE RO RS RU RW SA SB SC SD SE SG SH SI SJ SK SL SM SN SO SR SS ST SV SX SY SZ TC TD TF TG TH TJ TK TL TM TN TO TR TT TV TW TZ UA UG UM US UY UZ VA VC VE VG VI VN VU WF WS YE YT ZA ZM ZW 1A XI', '\s')"/>
   <axsl:variable name="ISO4217" select="tokenize('AED AFN ALL AMD ANG AOA ARS AUD AWG AZN BAM BBD BDT BGN BHD BIF BMD BND BOB BOV BRL BSD BTN BWP BYN BZD CAD CDF CHE CHF CHW CLF CLP CNY COP COU CRC CUC CUP CVE CZK DJF DKK DOP DZD EGP ERN ETB EUR FJD FKP GBP GEL GHS GIP GMD GNF GTQ GYD HKD HNL HRK HTG HUF IDR ILS INR IQD IRR ISK JMD JOD JPY KES KGS KHR KMF KPW KRW KWD KYD KZT LAK LBP LKR LRD LSL LYD MAD MDL MGA MKD MMK MNT MOP MRO MUR MVR MWK MXN MXV MYR MZN NAD NGN NIO NOK NPR NZD OMR PAB PEN PGK PHP PKR PLN PYG QAR RON RSD RUB RWF SAR SBD SCR SDG SEK SGD SHP SLL SOS SRD SSP STN SVC SYP SZL THB TJS TMT TND TOP TRY TTD TWD TZS UAH UGX USD USN UYI UYU UZS VEF VND VUV WST XAF XAG XAU XBA XBB XBC XBD XCD XDR XOF XPD XPF XPT XSU XTS XUA XXX YER ZAR ZMW ZWL', '\s')"/>
   <axsl:variable name="MIMECODE" select="tokenize('application/pdf image/png image/jpeg text/csv application/vnd.openxmlformats-officedocument.spreadsheetml.sheet application/vnd.oasis.opendocument.spreadsheet', '\s')"/>
   <axsl:variable name="UNCL2005" select="tokenize('3 35 432', '\s')"/>
   <axsl:variable name="UNCL5189" select="tokenize('41 42 60 62 63 64 65 66 67 68 70 71 88 95 100 102 103 104 105', '\s')"/>
   <axsl:variable name="UNCL7161" select="tokenize('AA AAA AAC AAD AAE AAF AAH AAI AAS AAT AAV AAY AAZ ABA ABB ABC ABD ABF ABK ABL ABN ABR ABS ABT ABU ACF ACG ACH ACI ACJ ACK ACL ACM ACS ADC ADE ADJ ADK ADL ADM ADN ADO ADP ADQ ADR ADT ADW ADY ADZ AEA AEB AEC AED AEF AEH AEI AEJ AEK AEL AEM AEN AEO AEP AES AET AEU AEV AEW AEX AEY AEZ AJ AU CA CAB CAD CAE CAF CAI CAJ CAK CAL CAM CAN CAO CAP CAQ CAR CAS CAT CAU CAV CAW CAX CAY CAZ CD CG CS CT DAB DAC DAD DAF DAG DAH DAI DAJ DAK DAL DAM DAN DAO DAP DAQ DL EG EP ER FAA FAB FAC FC FH FI GAA HAA HD HH IAA IAB ID IF IR IS KO L1 LA LAA LAB LF MAE MI ML NAA OA PA PAA PC PL RAB RAC RAD RAF RE RF RH RV SA SAA SAD SAE SAI SG SH SM SU TAB TAC TT TV V1 V2 WH XAA YY ZZZ', '\s')"/>
   <axsl:variable name="UNCL5305" select="tokenize('AE E S Z G O K L M', '\s')"/>
   <axsl:variable name="eaid" select="tokenize('0002 0007 0009 0037 0060 0088 0096 0097 0106 0130 0135 0142 0151 0183 0184 0190 0191 0192 0193 0195 0196 0198 0199 0200 0201 0202 0204 0208 0209 0210 0211 0212 0213 9901 9906 9907 9910 9913 9914 9915 9918 9919 9920 9922 9923 9924 9925 9926 9927 9928 9929 9930 9931 9932 9933 9934 9935 9936 9937 9938 9939 9940 9941 9942 9943 9944 9945 9946 9947 9948 9949 9950 9951 9952 9953 9955 9957', '\s')"/>

	<!--RULE -->

   <axsl:template match="cbc:EmbeddedDocumentBinaryObject[@mimeCode]" priority="1016" mode="M36">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="cbc:EmbeddedDocumentBinaryObject[@mimeCode]"/>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="           some $code in $MIMECODE             satisfies @mimeCode = $code"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="some $code in $MIMECODE satisfies @mimeCode = $code">
               <axsl:attribute name="id">PEPPOL-EN16931-CL001</axsl:attribute>
               <axsl:attribute name="flag">fatal</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-select-full-path"/>
               </axsl:attribute>
               <svrl:text>Mime code must be according to subset of IANA code list.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>
      <axsl:apply-templates select="@*|*" mode="M36"/>
   </axsl:template>

	<!--RULE -->

   <axsl:template match="cac:AllowanceCharge[cbc:ChargeIndicator = 'false']/cbc:AllowanceChargeReasonCode" priority="1015" mode="M36">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="cac:AllowanceCharge[cbc:ChargeIndicator = 'false']/cbc:AllowanceChargeReasonCode"/>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="           some $code in $UNCL5189             satisfies normalize-space(text()) = $code"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="some $code in $UNCL5189 satisfies normalize-space(text()) = $code">
               <axsl:attribute name="id">PEPPOL-EN16931-CL002</axsl:attribute>
               <axsl:attribute name="flag">fatal</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-select-full-path"/>
               </axsl:attribute>
               <svrl:text>Reason code MUST be according to subset of UNCL 5189 D.16B.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>
      <axsl:apply-templates select="@*|*" mode="M36"/>
   </axsl:template>

	<!--RULE -->

   <axsl:template match="cac:AllowanceCharge[cbc:ChargeIndicator = 'true']/cbc:AllowanceChargeReasonCode" priority="1014" mode="M36">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="cac:AllowanceCharge[cbc:ChargeIndicator = 'true']/cbc:AllowanceChargeReasonCode"/>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="           some $code in $UNCL7161             satisfies normalize-space(text()) = $code"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="some $code in $UNCL7161 satisfies normalize-space(text()) = $code">
               <axsl:attribute name="id">PEPPOL-EN16931-CL003</axsl:attribute>
               <axsl:attribute name="flag">fatal</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-select-full-path"/>
               </axsl:attribute>
               <svrl:text>Reason code MUST be according to UNCL 7161 D.16B.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>
      <axsl:apply-templates select="@*|*" mode="M36"/>
   </axsl:template>

	<!--RULE -->

   <axsl:template match="cac:InvoicePeriod/cbc:DescriptionCode" priority="1013" mode="M36">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="cac:InvoicePeriod/cbc:DescriptionCode"/>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="           some $code in $UNCL2005             satisfies normalize-space(text()) = $code"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="some $code in $UNCL2005 satisfies normalize-space(text()) = $code">
               <axsl:attribute name="id">PEPPOL-EN16931-CL006</axsl:attribute>
               <axsl:attribute name="flag">fatal</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-select-full-path"/>
               </axsl:attribute>
               <svrl:text>Invoice period description code must be according to UNCL 2005 D.16B.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>
      <axsl:apply-templates select="@*|*" mode="M36"/>
   </axsl:template>

	<!--RULE -->

   <axsl:template match="cbc:Amount | cbc:BaseAmount | cbc:PriceAmount | cbc:TaxAmount | cbc:TaxableAmount | cbc:LineExtensionAmount | cbc:TaxExclusiveAmount | cbc:TaxInclusiveAmount | cbc:AllowanceTotalAmount | cbc:ChargeTotalAmount | cbc:PrepaidAmount | cbc:PayableRoundingAmount | cbc:PayableAmount" priority="1012" mode="M36">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="cbc:Amount | cbc:BaseAmount | cbc:PriceAmount | cbc:TaxAmount | cbc:TaxableAmount | cbc:LineExtensionAmount | cbc:TaxExclusiveAmount | cbc:TaxInclusiveAmount | cbc:AllowanceTotalAmount | cbc:ChargeTotalAmount | cbc:PrepaidAmount | cbc:PayableRoundingAmount | cbc:PayableAmount"/>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="           some $code in $ISO4217             satisfies @currencyID = $code"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="some $code in $ISO4217 satisfies @currencyID = $code">
               <axsl:attribute name="id">PEPPOL-EN16931-CL007</axsl:attribute>
               <axsl:attribute name="flag">fatal</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-select-full-path"/>
               </axsl:attribute>
               <svrl:text>Currency code must be according to ISO 4217:2005</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>
      <axsl:apply-templates select="@*|*" mode="M36"/>
   </axsl:template>

	<!--RULE -->

   <axsl:template match="cbc:InvoiceTypeCode" priority="1011" mode="M36">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="cbc:InvoiceTypeCode"/>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="           $profile != '01' or (some $code in tokenize('380 383 386 393 82 80 84 395 575 623 780', '\s')             satisfies normalize-space(text()) = $code)"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="$profile != '01' or (some $code in tokenize('380 383 386 393 82 80 84 395 575 623 780', '\s') satisfies normalize-space(text()) = $code)">
               <axsl:attribute name="id">PEPPOL-EN16931-P0100</axsl:attribute>
               <axsl:attribute name="flag">fatal</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-select-full-path"/>
               </axsl:attribute>
               <svrl:text>Invoice type code MUST be set according to the profile.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>
      <axsl:apply-templates select="@*|*" mode="M36"/>
   </axsl:template>

	<!--RULE -->

   <axsl:template match="cbc:CreditNoteTypeCode" priority="1010" mode="M36">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="cbc:CreditNoteTypeCode"/>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="           $profile != '01' or (some $code in tokenize('381 396 81 83 532', '\s')             satisfies normalize-space(text()) = $code)"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="$profile != '01' or (some $code in tokenize('381 396 81 83 532', '\s') satisfies normalize-space(text()) = $code)">
               <axsl:attribute name="id">PEPPOL-EN16931-P0101</axsl:attribute>
               <axsl:attribute name="flag">fatal</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-select-full-path"/>
               </axsl:attribute>
               <svrl:text>Credit note type code MUST be set according to the profile.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>
      <axsl:apply-templates select="@*|*" mode="M36"/>
   </axsl:template>

	<!--RULE -->

   <axsl:template match="cbc:IssueDate | cbc:DueDate | cbc:TaxPointDate | cbc:StartDate | cbc:EndDate | cbc:ActualDeliveryDate" priority="1009" mode="M36">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="cbc:IssueDate | cbc:DueDate | cbc:TaxPointDate | cbc:StartDate | cbc:EndDate | cbc:ActualDeliveryDate"/>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="string-length(text()) = 10 and (string(.) castable as xs:date)"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="string-length(text()) = 10 and (string(.) castable as xs:date)">
               <axsl:attribute name="id">PEPPOL-EN16931-F001</axsl:attribute>
               <axsl:attribute name="flag">fatal</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-select-full-path"/>
               </axsl:attribute>
               <svrl:text>A date
        MUST be formatted YYYY-MM-DD.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>
      <axsl:apply-templates select="@*|*" mode="M36"/>
   </axsl:template>

	<!--RULE -->

   <axsl:template match="cbc:EndpointID[@schemeID]" priority="1008" mode="M36">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="cbc:EndpointID[@schemeID]"/>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="         some $code in $eaid         satisfies @schemeID = $code"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="some $code in $eaid satisfies @schemeID = $code">
               <axsl:attribute name="id">PEPPOL-EN16931-CL008</axsl:attribute>
               <axsl:attribute name="flag">fatal</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-select-full-path"/>
               </axsl:attribute>
               <svrl:text>Electronic address identifier scheme must be from the codelist "Electronic Address Identifier Scheme"</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>
      <axsl:apply-templates select="@*|*" mode="M36"/>
   </axsl:template>

	<!--RULE -->

   <axsl:template match="cac:TaxCategory[upper-case(cbc:TaxExemptionReasonCode)='VATEX-EU-G']" priority="1007" mode="M36">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="cac:TaxCategory[upper-case(cbc:TaxExemptionReasonCode)='VATEX-EU-G']"/>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="normalize-space(cbc:ID)='G'"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="normalize-space(cbc:ID)='G'">
               <axsl:attribute name="id">PEPPOL-EN16931-P0104</axsl:attribute>
               <axsl:attribute name="flag">fatal</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-select-full-path"/>
               </axsl:attribute>
               <svrl:text>Tax Category G MUST be used when exemption reason code is VATEX-EU-G</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>
      <axsl:apply-templates select="@*|*" mode="M36"/>
   </axsl:template>

	<!--RULE -->

   <axsl:template match="cac:TaxCategory[upper-case(cbc:TaxExemptionReasonCode)='VATEX-EU-O']" priority="1006" mode="M36">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="cac:TaxCategory[upper-case(cbc:TaxExemptionReasonCode)='VATEX-EU-O']"/>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="normalize-space(cbc:ID)='O'"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="normalize-space(cbc:ID)='O'">
               <axsl:attribute name="id">PEPPOL-EN16931-P0105</axsl:attribute>
               <axsl:attribute name="flag">fatal</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-select-full-path"/>
               </axsl:attribute>
               <svrl:text>Tax Category O MUST be used when exemption reason code is VATEX-EU-O</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>
      <axsl:apply-templates select="@*|*" mode="M36"/>
   </axsl:template>

	<!--RULE -->

   <axsl:template match="cac:TaxCategory[upper-case(cbc:TaxExemptionReasonCode)='VATEX-EU-IC']" priority="1005" mode="M36">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="cac:TaxCategory[upper-case(cbc:TaxExemptionReasonCode)='VATEX-EU-IC']"/>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="normalize-space(cbc:ID)='K'"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="normalize-space(cbc:ID)='K'">
               <axsl:attribute name="id">PEPPOL-EN16931-P0106</axsl:attribute>
               <axsl:attribute name="flag">fatal</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-select-full-path"/>
               </axsl:attribute>
               <svrl:text>Tax Category K MUST be used when exemption reason code is VATEX-EU-IC</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>
      <axsl:apply-templates select="@*|*" mode="M36"/>
   </axsl:template>

	<!--RULE -->

   <axsl:template match="cac:TaxCategory[upper-case(cbc:TaxExemptionReasonCode)='VATEX-EU-AE']" priority="1004" mode="M36">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="cac:TaxCategory[upper-case(cbc:TaxExemptionReasonCode)='VATEX-EU-AE']"/>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="normalize-space(cbc:ID)='AE'"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="normalize-space(cbc:ID)='AE'">
               <axsl:attribute name="id">PEPPOL-EN16931-P0107</axsl:attribute>
               <axsl:attribute name="flag">fatal</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-select-full-path"/>
               </axsl:attribute>
               <svrl:text>Tax Category AE MUST be used when exemption reason code is VATEX-EU-AE</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>
      <axsl:apply-templates select="@*|*" mode="M36"/>
   </axsl:template>

	<!--RULE -->

   <axsl:template match="cac:TaxCategory[upper-case(cbc:TaxExemptionReasonCode)='VATEX-EU-D']" priority="1003" mode="M36">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="cac:TaxCategory[upper-case(cbc:TaxExemptionReasonCode)='VATEX-EU-D']"/>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="normalize-space(cbc:ID)='E'"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="normalize-space(cbc:ID)='E'">
               <axsl:attribute name="id">PEPPOL-EN16931-P0108</axsl:attribute>
               <axsl:attribute name="flag">fatal</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-select-full-path"/>
               </axsl:attribute>
               <svrl:text>Tax Category E MUST be used when exemption reason code is VATEX-EU-D</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>
      <axsl:apply-templates select="@*|*" mode="M36"/>
   </axsl:template>

	<!--RULE -->

   <axsl:template match="cac:TaxCategory[upper-case(cbc:TaxExemptionReasonCode)='VATEX-EU-F']" priority="1002" mode="M36">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="cac:TaxCategory[upper-case(cbc:TaxExemptionReasonCode)='VATEX-EU-F']"/>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="normalize-space(cbc:ID)='E'"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="normalize-space(cbc:ID)='E'">
               <axsl:attribute name="id">PEPPOL-EN16931-P0109</axsl:attribute>
               <axsl:attribute name="flag">fatal</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-select-full-path"/>
               </axsl:attribute>
               <svrl:text>Tax Category E MUST be used when exemption reason code is VATEX-EU-F</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>
      <axsl:apply-templates select="@*|*" mode="M36"/>
   </axsl:template>

	<!--RULE -->

   <axsl:template match="cac:TaxCategory[upper-case(cbc:TaxExemptionReasonCode)='VATEX-EU-I']" priority="1001" mode="M36">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="cac:TaxCategory[upper-case(cbc:TaxExemptionReasonCode)='VATEX-EU-I']"/>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="normalize-space(cbc:ID)='E'"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="normalize-space(cbc:ID)='E'">
               <axsl:attribute name="id">PEPPOL-EN16931-P0110</axsl:attribute>
               <axsl:attribute name="flag">fatal</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-select-full-path"/>
               </axsl:attribute>
               <svrl:text>Tax Category E MUST be used when exemption reason code is VATEX-EU-I</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>
      <axsl:apply-templates select="@*|*" mode="M36"/>
   </axsl:template>

	<!--RULE -->

   <axsl:template match="cac:TaxCategory[upper-case(cbc:TaxExemptionReasonCode)='VATEX-EU-J']" priority="1000" mode="M36">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="cac:TaxCategory[upper-case(cbc:TaxExemptionReasonCode)='VATEX-EU-J']"/>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="normalize-space(cbc:ID)='E'"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="normalize-space(cbc:ID)='E'">
               <axsl:attribute name="id">PEPPOL-EN16931-P0111</axsl:attribute>
               <axsl:attribute name="flag">fatal</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-select-full-path"/>
               </axsl:attribute>
               <svrl:text>Tax Category E MUST be used when exemption reason code is VATEX-EU-J</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>
      <axsl:apply-templates select="@*|*" mode="M36"/>
   </axsl:template>
   <axsl:template match="text()" priority="-1" mode="M36"/>
   <axsl:template match="@*|node()" priority="-2" mode="M36">
      <axsl:apply-templates select="@*|*" mode="M36"/>
   </axsl:template>
</axsl:stylesheet>