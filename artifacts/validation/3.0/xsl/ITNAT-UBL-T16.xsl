<?xml version="1.0" encoding="utf-8" standalone="yes"?>
<axsl:stylesheet xmlns:axsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:saxon="http://saxon.sf.net/" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:schold="http://www.ascc.net/xml/schematron" xmlns:iso="http://purl.oclc.org/dsdl/schematron" xmlns:xhtml="http://www.w3.org/1999/xhtml" xmlns:cbc="urn:oasis:names:specification:ubl:schema:xsd:CommonBasicComponents-2" xmlns:cac="urn:oasis:names:specification:ubl:schema:xsd:CommonAggregateComponents-2" xmlns:ubl="urn:oasis:names:specification:ubl:schema:xsd:DespatchAdvice-2" xmlns:u="utils" version="2.0"><!--Implementers: please note that overriding process-prolog or process-root is 
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

   <function xmlns="http://www.w3.org/1999/XSL/Transform" xmlns:xi="http://www.w3.org/2001/XInclude" name="u:gln" as="xs:boolean">
      
      <param name="val"/>
      
      <variable name="length" select="string-length($val) - 1"/>
      
      <variable name="digits" select="reverse(for $i in string-to-codepoints(substring($val, 0, $length + 1)) return $i - 48)"/>
      
      <variable name="weightedSum" select="sum(for $i in (0 to $length - 1) return $digits[$i + 1] * (1 + ((($i + 1) mod 2) * 2)))"/>
      
      <value-of select="10 - ($weightedSum mod 10) = number(substring($val, $length + 1, 1))"/>
   
   </function>
   <function xmlns="http://www.w3.org/1999/XSL/Transform" xmlns:xi="http://www.w3.org/2001/XInclude" name="u:mod11" as="xs:boolean">
      
      <param name="val"/>
      
      <variable name="length" select="string-length($val) - 1"/>
      
      <variable name="digits" select="reverse(for $i in string-to-codepoints(substring($val, 0, $length + 1)) return $i - 48)"/>
      
      <variable name="weightedSum" select="sum(for $i in (0 to $length - 1) return $digits[$i + 1] * (($i mod 6) + 2))"/>
      
      <value-of select="number($val) &gt; 0 and (11 - ($weightedSum mod 11)) mod 11 = number(substring($val, $length + 1, 1))"/>
   
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
      <svrl:schematron-output xmlns:svrl="http://purl.oclc.org/dsdl/svrl" title="Rules for PEPPOL Despatch Advice transaction 3.0" schemaVersion="iso">
         <axsl:comment>
            <axsl:value-of select="$archiveDirParameter"/>   
		 <axsl:value-of select="$archiveNameParameter"/>  
		 <axsl:value-of select="$fileNameParameter"/>  
		 <axsl:value-of select="$fileDirParameter"/>
         </axsl:comment>
         <svrl:ns-prefix-in-attribute-values uri="urn:oasis:names:specification:ubl:schema:xsd:CommonBasicComponents-2" prefix="cbc"/>
         <svrl:ns-prefix-in-attribute-values uri="urn:oasis:names:specification:ubl:schema:xsd:CommonAggregateComponents-2" prefix="cac"/>
         <svrl:ns-prefix-in-attribute-values uri="urn:oasis:names:specification:ubl:schema:xsd:DespatchAdvice-2" prefix="ubl"/>
         <svrl:ns-prefix-in-attribute-values uri="http://www.w3.org/2001/XMLSchema" prefix="xs"/>
         <svrl:ns-prefix-in-attribute-values uri="utils" prefix="u"/>
         <svrl:active-pattern>
            <axsl:attribute name="document">
               <axsl:value-of select="document-uri(/)"/>
            </axsl:attribute>
            <axsl:apply-templates/>
         </svrl:active-pattern>
         <axsl:apply-templates select="/" mode="M8"/>
         <svrl:active-pattern>
            <axsl:attribute name="document">
               <axsl:value-of select="document-uri(/)"/>
            </axsl:attribute>
            <axsl:apply-templates/>
         </svrl:active-pattern>
         <axsl:apply-templates select="/" mode="M9"/>
         <svrl:active-pattern>
            <axsl:attribute name="document">
               <axsl:value-of select="document-uri(/)"/>
            </axsl:attribute>
            <axsl:apply-templates/>
         </svrl:active-pattern>
         <axsl:apply-templates select="/" mode="M10"/>
         <svrl:active-pattern>
            <axsl:attribute name="document">
               <axsl:value-of select="document-uri(/)"/>
            </axsl:attribute>
            <axsl:apply-templates/>
         </svrl:active-pattern>
         <axsl:apply-templates select="/" mode="M11"/>
         <svrl:active-pattern>
            <axsl:attribute name="document">
               <axsl:value-of select="document-uri(/)"/>
            </axsl:attribute>
            <axsl:attribute name="id">INT-UBL-T16</axsl:attribute>
            <axsl:attribute name="name">INT-UBL-T16</axsl:attribute>
            <axsl:apply-templates/>
         </svrl:active-pattern>
         <axsl:apply-templates select="/" mode="M12"/>
      </svrl:schematron-output>
   </axsl:template>

<!--SCHEMATRON PATTERNS-->

   <svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">Rules for PEPPOL Despatch Advice transaction 3.0</svrl:text>

<!--PATTERN -->


	<!--RULE -->

   <axsl:template match="cbc:*" priority="1001" mode="M8">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="cbc:*"/>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test=". != ''"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test=". != ''">
               <axsl:attribute name="id">PEPPOL-COMMON-R001</axsl:attribute>
               <axsl:attribute name="flag">fatal</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-select-full-path"/>
               </axsl:attribute>
               <svrl:text>Document MUST not contain empty elements.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>
      <axsl:apply-templates select="@*|*" mode="M8"/>
   </axsl:template>

	<!--RULE -->

   <axsl:template match="cac:*" priority="1000" mode="M8">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="cac:*"/>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="count(*) != 0"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="count(*) != 0">
               <axsl:attribute name="id">PEPPOL-COMMON-R002</axsl:attribute>
               <axsl:attribute name="flag">fatal</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-select-full-path"/>
               </axsl:attribute>
               <svrl:text>Document MUST not contain empty elements.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>
      <axsl:apply-templates select="@*|*" mode="M8"/>
   </axsl:template>
   <axsl:template match="text()" priority="-1" mode="M8"/>
   <axsl:template match="@*|node()" priority="-2" mode="M8">
      <axsl:apply-templates select="@*|*" mode="M8"/>
   </axsl:template>

<!--PATTERN -->


	<!--RULE -->

   <axsl:template match="/*" priority="1003" mode="M9">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="/*"/>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(@*:schemaLocation)"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(@*:schemaLocation)">
               <axsl:attribute name="id">PEPPOL-COMMON-R003</axsl:attribute>
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-select-full-path"/>
               </axsl:attribute>
               <svrl:text>Document SHOULD not contain schema location.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>
      <axsl:apply-templates select="@*|*" mode="M9"/>
   </axsl:template>

	<!--RULE -->

   <axsl:template match="cbc:IssueDate | cbc:DueDate | cbc:TaxPointDate | cbc:StartDate | cbc:EndDate | cbc:ActualDeliveryDate" priority="1002" mode="M9">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="cbc:IssueDate | cbc:DueDate | cbc:TaxPointDate | cbc:StartDate | cbc:EndDate | cbc:ActualDeliveryDate"/>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="(string(.) castable as xs:date) and (string-length(.) = 10)"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="(string(.) castable as xs:date) and (string-length(.) = 10)">
               <axsl:attribute name="id">PEPPOL-COMMON-R030</axsl:attribute>
               <axsl:attribute name="flag">fatal</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-select-full-path"/>
               </axsl:attribute>
               <svrl:text>A date must be formatted YYYY-MM-DD.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>
      <axsl:apply-templates select="@*|*" mode="M9"/>
   </axsl:template>

	<!--RULE -->

   <axsl:template match="cbc:EndpointID[@schemeID = '0088'] | cac:PartyIdentification/cbc:ID[@schemeID = '0088'] | cbc:CompanyID[@schemeID = '0088']" priority="1001" mode="M9">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="cbc:EndpointID[@schemeID = '0088'] | cac:PartyIdentification/cbc:ID[@schemeID = '0088'] | cbc:CompanyID[@schemeID = '0088']"/>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="matches(normalize-space(), '^[0-9]+$') and u:gln(normalize-space())"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="matches(normalize-space(), '^[0-9]+$') and u:gln(normalize-space())">
               <axsl:attribute name="id">PEPPOL-COMMON-R040</axsl:attribute>
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-select-full-path"/>
               </axsl:attribute>
               <svrl:text>Invalid GLN number provided.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>
      <axsl:apply-templates select="@*|*" mode="M9"/>
   </axsl:template>

	<!--RULE -->

   <axsl:template match="cbc:EndpointID[@schemeID = '0192'] | cac:PartyIdentification/cbc:ID[@schemeID = '0192'] | cbc:CompanyID[@schemeID = '0192']" priority="1000" mode="M9">
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
               <svrl:text>Invalid Norwegian organization number provided.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>
      <axsl:apply-templates select="@*|*" mode="M9"/>
   </axsl:template>
   <axsl:template match="text()" priority="-1" mode="M9"/>
   <axsl:template match="@*|node()" priority="-2" mode="M9">
      <axsl:apply-templates select="@*|*" mode="M9"/>
   </axsl:template>

<!--PATTERN -->

   <axsl:variable name="cleas" select="tokenize('0002 0007 0009 0037 0060 0088 0096 0097 0106 0135 0142 0151 0183 0184 0190 0191 0192 0193 0195 0196 0198 0199 0200 0201 0202 9901 9902 9904 9905 9906 9907 9910 9913 9914 9915 9917 9918 9919 9920 9921 9922 9923 9924 9925 9926 9927 9928 9929 9930 9931 9932 9933 9934 9935 9936 9937 9938 9939 9940 9941 9942 9943 9944 9945 9946 9947 9948 9949 9950 9951 9952 9953 9955 9956 9957 9958', '\s')"/>
   <axsl:variable name="clUNCL8273" select="tokenize('ADR ADS ADT ADU ADV ADW ADX AGS ANR ARD CFR COM GVE GVS ICA IMD RGE RID UI ZZZ', '\s')"/>
   <axsl:variable name="clUNECERec20" select="tokenize('10 11 13 14 15 20 21 22 23 24 25 27 28 33 34 35 37 38 40 41 56 57 58 59 60 61 74 77 80 81 85 87 89 91 1I 2A 2B 2C 2G 2H 2I 2J 2K 2L 2M 2N 2P 2Q 2R 2U 2X 2Y 2Z 3B 3C 4C 4G 4H 4K 4L 4M 4N 4O 4P 4Q 4R 4T 4U 4W 4X 5A 5B 5E 5J A10 A11 A12 A13 A14 A15 A16 A17 A18 A19 A2 A20 A21 A22 A23 A24 A26 A27 A28 A29 A3 A30 A31 A32 A33 A34 A35 A36 A37 A38 A39 A4 A40 A41 A42 A43 A44 A45 A47 A48 A49 A5 A53 A54 A55 A56 A59 A6 A68 A69 A7 A70 A71 A73 A74 A75 A76 A8 A84 A85 A86 A87 A88 A89 A9 A90 A91 A93 A94 A95 A96 A97 A98 A99 AA AB ACR ACT AD AE AH AI AK AL AMH AMP ANN APZ AQ AS ASM ASU ATM AWG AY AZ B1 B10 B11 B12 B13 B14 B15 B16 B17 B18 B19 B20 B21 B22 B23 B24 B25 B26 B27 B28 B29 B3 B30 B31 B32 B33 B34 B35 B4 B41 B42 B43 B44 B45 B46 B47 B48 B49 B50 B52 B53 B54 B55 B56 B57 B58 B59 B60 B61 B62 B63 B64 B66 B67 B68 B69 B7 B70 B71 B72 B73 B74 B75 B76 B77 B78 B79 B8 B80 B81 B82 B83 B84 B85 B86 B87 B88 B89 B90 B91 B92 B93 B94 B95 B96 B97 B98 B99 BAR BB BFT BHP BIL BLD BLL BP BPM BQL BTU BUA BUI C0 C10 C11 C12 C13 C14 C15 C16 C17 C18 C19 C20 C21 C22 C23 C24 C25 C26 C27 C28 C29 C3 C30 C31 C32 C33 C34 C35 C36 C37 C38 C39 C40 C41 C42 C43 C44 C45 C46 C47 C48 C49 C50 C51 C52 C53 C54 C55 C56 C57 C58 C59 C60 C61 C62 C63 C64 C65 C66 C67 C68 C69 C7 C70 C71 C72 C73 C74 C75 C76 C78 C79 C8 C80 C81 C82 C83 C84 C85 C86 C87 C88 C89 C9 C90 C91 C92 C93 C94 C95 C96 C97 C99 CCT CDL CEL CEN CG CGM CKG CLF CLT CMK CMQ CMT CNP CNT COU CTG CTM CTN CUR CWA CWI D03 D04 D1 D10 D11 D12 D13 D15 D16 D17 D18 D19 D2 D20 D21 D22 D23 D24 D25 D26 D27 D29 D30 D31 D32 D33 D34 D36 D41 D42 D43 D44 D45 D46 D47 D48 D49 D5 D50 D51 D52 D53 D54 D55 D56 D57 D58 D59 D6 D60 D61 D62 D63 D65 D68 D69 D73 D74 D77 D78 D80 D81 D82 D83 D85 D86 D87 D88 D89 D91 D93 D94 D95 DAA DAD DAY DB DD DEC DG DJ DLT DMA DMK DMO DMQ DMT DN DPC DPR DPT DRA DRI DRL DT DTN DWT DZN DZP E01 E07 E08 E09 E10 E12 E14 E15 E16 E17 E18 E19 E20 E21 E22 E23 E25 E27 E28 E30 E31 E32 E33 E34 E35 E36 E37 E38 E39 E4 E40 E41 E42 E43 E44 E45 E46 E47 E48 E49 E50 E51 E52 E53 E54 E55 E56 E57 E58 E59 E60 E61 E62 E63 E64 E65 E66 E67 E68 E69 E70 E71 E72 E73 E74 E75 E76 E77 E78 E79 E80 E81 E82 E83 E84 E85 E86 E87 E88 E89 E90 E91 E92 E93 E94 E95 E96 E97 E98 E99 EA EB EQ F01 F02 F03 F04 F05 F06 F07 F08 F10 F11 F12 F13 F14 F15 F16 F17 F18 F19 F20 F21 F22 F23 F24 F25 F26 F27 F28 F29 F30 F31 F32 F33 F34 F35 F36 F37 F38 F39 F40 F41 F42 F43 F44 F45 F46 F47 F48 F49 F50 F51 F52 F53 F54 F55 F56 F57 F58 F59 F60 F61 F62 F63 F64 F65 F66 F67 F68 F69 F70 F71 F72 F73 F74 F75 F76 F77 F78 F79 F80 F81 F82 F83 F84 F85 F86 F87 F88 F89 F90 F91 F92 F93 F94 F95 F96 F97 F98 F99 FAH FAR FBM FC FF FH FIT FL FOT FP FR FS FTK FTQ G01 G04 G05 G06 G08 G09 G10 G11 G12 G13 G14 G15 G16 G17 G18 G19 G2 G20 G21 G23 G24 G25 G26 G27 G28 G29 G3 G30 G31 G32 G33 G34 G35 G36 G37 G38 G39 G40 G41 G42 G43 G44 G45 G46 G47 G48 G49 G50 G51 G52 G53 G54 G55 G56 G57 G58 G59 G60 G61 G62 G63 G64 G65 G66 G67 G68 G69 G70 G71 G72 G73 G74 G75 G76 G77 G78 G79 G80 G81 G82 G83 G84 G85 G86 G87 G88 G89 G90 G91 G92 G93 G94 G95 G96 G97 G98 G99 GB GBQ GDW GE GF GFI GGR GIA GIC GII GIP GJ GL GLD GLI GLL GM GO GP GQ GRM GRN GRO GV GWH H03 H04 H05 H06 H07 H08 H09 H10 H11 H12 H13 H14 H15 H16 H18 H19 H20 H21 H22 H23 H24 H25 H26 H27 H28 H29 H30 H31 H32 H33 H34 H35 H36 H37 H38 H39 H40 H41 H42 H43 H44 H45 H46 H47 H48 H49 H50 H51 H52 H53 H54 H55 H56 H57 H58 H59 H60 H61 H62 H63 H64 H65 H66 H67 H68 H69 H70 H71 H72 H73 H74 H75 H76 H77 H79 H80 H81 H82 H83 H84 H85 H87 H88 H89 H90 H91 H92 H93 H94 H95 H96 H98 H99 HA HBA HBX HC HDW HEA HGM HH HIU HKM HLT HM HMQ HMT HPA HTZ HUR IA IE INH INK INQ ISD IU IV J10 J12 J13 J14 J15 J16 J17 J18 J19 J2 J20 J21 J22 J23 J24 J25 J26 J27 J28 J29 J30 J31 J32 J33 J34 J35 J36 J38 J39 J40 J41 J42 J43 J44 J45 J46 J47 J48 J49 J50 J51 J52 J53 J54 J55 J56 J57 J58 J59 J60 J61 J62 J63 J64 J65 J66 J67 J68 J69 J70 J71 J72 J73 J74 J75 J76 J78 J79 J81 J82 J83 J84 J85 J87 J90 J91 J92 J93 J95 J96 J97 J98 J99 JE JK JM JNT JOU JPS JWL K1 K10 K11 K12 K13 K14 K15 K16 K17 K18 K19 K2 K20 K21 K22 K23 K26 K27 K28 K3 K30 K31 K32 K33 K34 K35 K36 K37 K38 K39 K40 K41 K42 K43 K45 K46 K47 K48 K49 K50 K51 K52 K53 K54 K55 K58 K59 K6 K60 K61 K62 K63 K64 K65 K66 K67 K68 K69 K70 K71 K73 K74 K75 K76 K77 K78 K79 K80 K81 K82 K83 K84 K85 K86 K87 K88 K89 K90 K91 K92 K93 K94 K95 K96 K97 K98 K99 KA KAT KB KBA KCC KDW KEL KGM KGS KHY KHZ KI KIC KIP KJ KJO KL KLK KLX KMA KMH KMK KMQ KMT KNI KNM KNS KNT KO KPA KPH KPO KPP KR KSD KSH KT KTN KUR KVA KVR KVT KW KWH KWO KWT KX L10 L11 L12 L13 L14 L15 L16 L17 L18 L19 L2 L20 L21 L23 L24 L25 L26 L27 L28 L29 L30 L31 L32 L33 L34 L35 L36 L37 L38 L39 L40 L41 L42 L43 L44 L45 L46 L47 L48 L49 L50 L51 L52 L53 L54 L55 L56 L57 L58 L59 L60 L63 L64 L65 L66 L67 L68 L69 L70 L71 L72 L73 L74 L75 L76 L77 L78 L79 L80 L81 L82 L83 L84 L85 L86 L87 L88 L89 L90 L91 L92 L93 L94 L95 L96 L98 L99 LA LAC LBR LBT LD LEF LF LH LK LM LN LO LP LPA LR LS LTN LTR LUB LUM LUX LY M1 M10 M11 M12 M13 M14 M15 M16 M17 M18 M19 M20 M21 M22 M23 M24 M25 M26 M27 M29 M30 M31 M32 M33 M34 M35 M36 M37 M38 M39 M4 M40 M41 M42 M43 M44 M45 M46 M47 M48 M49 M5 M50 M51 M52 M53 M55 M56 M57 M58 M59 M60 M61 M62 M63 M64 M65 M66 M67 M68 M69 M7 M70 M71 M72 M73 M74 M75 M76 M77 M78 M79 M80 M81 M82 M83 M84 M85 M86 M87 M88 M89 M9 M90 M91 M92 M93 M94 M95 M96 M97 M98 M99 MAH MAL MAM MAR MAW MBE MBF MBR MC MCU MD MGM MHZ MIK MIL MIN MIO MIU MLD MLT MMK MMQ MMT MND MON MPA MQH MQS MSK MTK MTQ MTR MTS MVA MWH N1 N10 N11 N12 N13 N14 N15 N16 N17 N18 N19 N20 N21 N22 N23 N24 N25 N26 N27 N28 N29 N3 N30 N31 N32 N33 N34 N35 N36 N37 N38 N39 N40 N41 N42 N43 N44 N45 N46 N47 N48 N49 N50 N51 N52 N53 N54 N55 N56 N57 N58 N59 N60 N61 N62 N63 N64 N65 N66 N67 N68 N69 N70 N71 N72 N73 N74 N75 N76 N77 N78 N79 N80 N81 N82 N83 N84 N85 N86 N87 N88 N89 N90 N91 N92 N93 N94 N95 N96 N97 N98 N99 NA NAR NCL NEW NF NIL NIU NL NM3 NMI NMP NPT NT NU NX OA ODE OHM ON ONZ OPM OT OZA OZI P1 P10 P11 P12 P13 P14 P15 P16 P17 P18 P19 P2 P20 P21 P22 P23 P24 P25 P26 P27 P28 P29 P30 P31 P32 P33 P34 P35 P36 P37 P38 P39 P40 P41 P42 P43 P44 P45 P46 P47 P48 P49 P5 P50 P51 P52 P53 P54 P55 P56 P57 P58 P59 P60 P61 P62 P63 P64 P65 P66 P67 P68 P69 P70 P71 P72 P73 P74 P75 P76 P77 P78 P79 P80 P81 P82 P83 P84 P85 P86 P87 P88 P89 P90 P91 P92 P93 P94 P95 P96 P97 P98 P99 PAL PD PFL PGL PI PLA PO PQ PR PS PTD PTI PTL PTN Q10 Q11 Q12 Q13 Q14 Q15 Q16 Q17 Q18 Q19 Q20 Q21 Q22 Q23 Q24 Q25 Q26 Q27 Q28 Q29 Q30 Q31 Q32 Q33 Q34 Q35 Q36 Q37 Q38 Q39 Q40 Q3 QA QAN QB QR QTD QTI QTL QTR R1 R9 RH RM ROM RP RPM RPS RT S3 S4 SAN SCO SCR SEC SET SG SIE SM3 SMI SQ SQR SR STC STI STK STL STN STW SW SX SYR T0 T3 TAH TAN TI TIC TIP TKM TMS TNE TP TPI TPR TQD TRL TST TTS U1 U2 UB UC VA VLT VP W2 WA WB WCD WE WEB WEE WG WHR WM WSD WTT X1 YDK YDQ YRD Z11 ZP ZZ X1A X1B X1D X1F X1G X1W X2C X3A X3H X43 X44 X4A X4B X4C X4D X4F X4G X4H X5H X5L X5M X6H X6P X7A X7B X8A X8B X8C XAA XAB XAC XAD XAE XAF XAG XAH XAI XAJ XAL XAM XAP XAT XAV XB4 XBA XBB XBC XBD XBE XBF XBG XBH XBI XBJ XBK XBL XBM XBN XBO XBP XBQ XBR XBS XBT XBU XBV XBW XBX XBY XBZ XCA XCB XCC XCD XCE XCF XCG XCH XCI XCJ XCK XCL XCM XCN XCO XCP XCQ XCR XCS XCT XCU XCV XCW XCX XCY XCZ XDA XDB XDC XDG XDH XDI XDJ XDK XDL XDM XDN XDP XDR XDS XDT XDU XDV XDW XDX XDY XEC XED XEE XEF XEG XEH XEI XEN XFB XFC XFD XFE XFI XFL XFO XFP XFR XFT XFW XFX XGB XGI XGL XGR XGU XGY XGZ XHA XHB XHC XHG XHN XHR XIA XIB XIC XID XIE XIF XIG XIH XIK XIL XIN XIZ XJB XJC XJG XJR XJT XJY XKG XKI XLE XLG XLT XLU XLV XLZ XMA XMB XMC XME XMR XMS XMT XMW XMX XNA XNE XNF XNG XNS XNT XNU XNV XOA XOB XOC XOD XOE XOF XOK XOT XOU XP2 XPA XPB XPC XPD XPE XPF XPG XPH XPI XPJ XPK XPL XPN XPO XPP XPR XPT XPU XPV XPX XPY XPZ XQA XQB XQC XQD XQF XQG XQH XQJ XQK XQL XQM XQN XQP XQQ XQR XQS XRD XRG XRJ XRK XRL XRO XRT XRZ XSA XSB XSC XSD XSE XSH XSI XSK XSL XSM XSO XSP XSS XST XSU XSV XSW XSY XSZ XT1 XTB XTC XTD XTE XTG XTI XTK XTL XTN XTO XTR XTS XTT XTU XTV XTW XTY XTZ XUC XUN XVA XVG XVI XVK XVL XVO XVP XVQ XVN XVR XVS XVY XWA XWB XWC XWD XWF XWG XWH XWJ XWK XWL XWM XWN XWP XWQ XWR XWS XWT XWU XWV XWW XWX XWY XWZ XXA XXB XXC XXD XXF XXG XXH XXJ XXK XYA XYB XYC XYD XYF XYG XYH XYJ XYK XYL XYM XYN XYP XYQ XYR XYS XYT XYV XYW XYX XYY XYZ XZA XZB XZC XZD XZF XZG XZH XZJ XZK XZL XZM XZN XZP XZQ XZR XZS XZT XZU XZV XZW XZX XZY', '\s')"/>
   <axsl:variable name="clISO3166" select="tokenize('AD AE AF AG AI AL AM AO AQ AR AS AT AU AW AX AZ BA BB BD BE BF BG BH BI BJ BL BM BN BO BQ BR BS BT BV BW BY BZ CA CC CD CF CG CH CI CK CL CM CN CO CR CU CV CW CX CY CZ DE DJ DK DM DO DZ EC EE EG EH ER ES ET FI FJ FK FM FO FR GA GB GD GE GF GG GH GI GL GM GN GP GQ GR GS GT GU GW GY HK HM HN HR HT HU ID IE IL IM IN IO IQ IR IS IT JE JM JO JP KE KG KH KI KM KN KP KR KW KY KZ LA LB LC LI LK LR LS LT LU LV LY MA MC MD ME MF MG MH MK ML MM MN MO MP MQ MR MS MT MU MV MW MX MY MZ NA NC NE NF NG NI NL NO NP NR NU NZ OM PA PE PF PG PH PK PL PM PN PR PS PT PW PY QA RE RO RS RU RW SA SB SC SD SE SG SH SI SJ SK SL SM SN SO SR SS ST SV SX SY SZ TC TD TF TG TH TJ TK TL TM TN TO TR TT TV TW TZ UA UG UM US UY UZ VA VC VE VG VI VN VU WF WS YE YT ZA ZM ZW', '\s')"/>
   <axsl:variable name="clUNCL6313-T16" select="tokenize('AAB AAW', '\s')"/>
   <axsl:variable name="clICD" select="tokenize('0002 0003 0004 0005 0006 0007 0008 0009 0010 0011 0012 0013 0014 0015 0016 0017 0018 0019 0020 0021 0022 0023 0024 0025 0026 0027 0028 0029 0030 0031 0032 0033 0034 0035 0036 0037 0038 0039 0040 0041 0042 0043 0044 0045 0046 0047 0048 0049 0050 0051 0052 0053 0054 0055 0056 0057 0058 0059 0060 0061 0062 0063 0064 0065 0066 0067 0068 0069 0070 0071 0072 0073 0074 0075 0076 0077 0078 0079 0080 0081 0082 0083 0084 0085 0086 0087 0088 0089 0090 0091 0093 0094 0095 0096 0097 0098 0099 0100 0101 0102 0104 0105 0106 0107 0108 0109 0110 0111 0112 0113 0114 0115 0116 0117 0118 0119 0120 0121 0122 0123 0124 0125 0126 0127 0128 0129 0130 0131 0132 0133 0134 0135 0136 0137 0138 0139 0140 0141 0142 0143 0144 0145 0146 0147 0148 0149 0150 0151 0152 0153 0154 0155 0156 0157 0158 0159 0160 0161 0162 0163 0164 0165 0166 0167 0168 0169 0170 0171 0172 0173 0174 0175 0176 0177 0178 0179 0180 0183 0184 0185 0186 0187 0188 0189 0190 0191 0192 0193 0195 0196 0199 0200 0201 0202', '\s')"/>
   <axsl:variable name="clUNECERec21" select="tokenize('1A 1B 1D 1F 1G 1W 2C 3A 3H 43 44 4A 4B 4C 4D 4F 4G 4H 5H 5L 5M 6H 6P 7A 7B 8A 8B 8C AA AB AC AD AE AF AG AH AI AJ AL AM AP AT AV B4 BA BB BC BD BE BF BG BH BI BJ BK BL BM BN BO BP BQ BR BS BT BU BV BW BX BY BZ CA CB CC CD CE CF CG CH CI CJ CK CL CM CN CO CP CQ CR CS CT CU CV CW CX CY CZ DA DB DC DG DH DI DJ DK DL DM DN DP DR DS DT DU DV DW DX DY EC ED EE EF EG EH EI EN FB FC FD FE FI FL FO FP FR FT FW FX GB GI GL GR GU GY GZ HA HB HC HG HN HR IA IB IC ID IE IF IG IH IK IL IN IZ JB JC JG JR JT JY KG KI LE LG LT LU LV LZ MA MB MC ME MR MS MT MW MX NA NE NF NG NS NT NU NV OA OB OC OD OE OF OK OT OU P2 PA PB PC PD PE PF PG PH PI PJ PK PL PN PO PP PR PT PU PV PX PY PZ QA QB QC QD QF QG QH QJ QK QL QM QN QP QQ QR QS RD RG RJ RK RL RO RT RZ SA SB SC SD SE SH SI SK SL SM SO SP SS ST SU SV SW SY SZ T1 TB TC TD TE TG TI TK TL TN TO TR TS TT TU TV TW TY TZ UC UN VA VG VI VK VL VO VP VQ VN VR VS VY WA WB WC WD WF WG WH WJ WK WL WM WN WP WQ WR WS WT WU WV WW WX WY WZ XA XB XC XD XF XG XH XJ XK YA YB YC YD YF YG YH YJ YK YL YM YN YP YQ YR YS YT YV YW YX YY YZ ZA ZB ZC ZD ZF ZG ZH ZJ ZK ZL ZM ZN ZP ZQ ZR ZS ZT ZU ZV ZW ZX ZY ZZ ', '\s')"/>

	<!--RULE -->

   <axsl:template match="/ubl:DespatchAdvice" priority="1231" mode="M10">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="/ubl:DespatchAdvice"/>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="cbc:CustomizationID"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="cbc:CustomizationID">
               <axsl:attribute name="id">PEPPOL-T16-B00101</axsl:attribute>
               <axsl:attribute name="flag">fatal</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-select-full-path"/>
               </axsl:attribute>
               <svrl:text>Element 'cbc:CustomizationID' MUST be provided.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="cbc:ProfileID"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="cbc:ProfileID">
               <axsl:attribute name="id">PEPPOL-T16-B00102</axsl:attribute>
               <axsl:attribute name="flag">fatal</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-select-full-path"/>
               </axsl:attribute>
               <svrl:text>Element 'cbc:ProfileID' MUST be provided.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="cbc:ID"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="cbc:ID">
               <axsl:attribute name="id">PEPPOL-T16-B00103</axsl:attribute>
               <axsl:attribute name="flag">fatal</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-select-full-path"/>
               </axsl:attribute>
               <svrl:text>Element 'cbc:ID' MUST be provided.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="cbc:IssueDate"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="cbc:IssueDate">
               <axsl:attribute name="id">PEPPOL-T16-B00104</axsl:attribute>
               <axsl:attribute name="flag">fatal</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-select-full-path"/>
               </axsl:attribute>
               <svrl:text>Element 'cbc:IssueDate' MUST be provided.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="cac:DespatchSupplierParty"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="cac:DespatchSupplierParty">
               <axsl:attribute name="id">PEPPOL-T16-B00105</axsl:attribute>
               <axsl:attribute name="flag">fatal</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-select-full-path"/>
               </axsl:attribute>
               <svrl:text>Element 'cac:DespatchSupplierParty' MUST be provided.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="cac:DeliveryCustomerParty"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="cac:DeliveryCustomerParty">
               <axsl:attribute name="id">PEPPOL-T16-B00106</axsl:attribute>
               <axsl:attribute name="flag">fatal</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-select-full-path"/>
               </axsl:attribute>
               <svrl:text>Element 'cac:DeliveryCustomerParty' MUST be provided.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="cac:DespatchLine"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="cac:DespatchLine">
               <axsl:attribute name="id">PEPPOL-T16-B00107</axsl:attribute>
               <axsl:attribute name="flag">fatal</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-select-full-path"/>
               </axsl:attribute>
               <svrl:text>Element 'cac:DespatchLine' MUST be provided.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(@*:schemaLocation)"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(@*:schemaLocation)">
               <axsl:attribute name="id">PEPPOL-T16-B00108</axsl:attribute>
               <axsl:attribute name="flag">fatal</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-select-full-path"/>
               </axsl:attribute>
               <svrl:text>Document MUST not contain schema location.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>
      <axsl:apply-templates select="@*|*" mode="M10"/>
   </axsl:template>

	<!--RULE -->

   <axsl:template match="/ubl:DespatchAdvice/cbc:CustomizationID" priority="1230" mode="M10">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="/ubl:DespatchAdvice/cbc:CustomizationID"/>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="normalize-space(text()) = 'urn:fdc:peppol.eu:poacc:trns:despatch_advice:3'"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="normalize-space(text()) = 'urn:fdc:peppol.eu:poacc:trns:despatch_advice:3'">
               <axsl:attribute name="id">PEPPOL-T16-B00201</axsl:attribute>
               <axsl:attribute name="flag">fatal</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-select-full-path"/>
               </axsl:attribute>
               <svrl:text>Element 'cbc:CustomizationID' MUST contain value 'urn:fdc:peppol.eu:poacc:trns:despatch_advice:3'.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>
      <axsl:apply-templates select="@*|*" mode="M10"/>
   </axsl:template>

	<!--RULE -->

   <axsl:template match="/ubl:DespatchAdvice/cbc:ProfileID" priority="1229" mode="M10">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="/ubl:DespatchAdvice/cbc:ProfileID"/>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="normalize-space(text()) = 'urn:fdc:peppol.eu:poacc:bis:despatch_advice:3'"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="normalize-space(text()) = 'urn:fdc:peppol.eu:poacc:bis:despatch_advice:3'">
               <axsl:attribute name="id">PEPPOL-T16-B00301</axsl:attribute>
               <axsl:attribute name="flag">fatal</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-select-full-path"/>
               </axsl:attribute>
               <svrl:text>Element 'cbc:ProfileID' MUST contain value 'urn:fdc:peppol.eu:poacc:bis:despatch_advice:3'.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>
      <axsl:apply-templates select="@*|*" mode="M10"/>
   </axsl:template>

	<!--RULE -->

   <axsl:template match="/ubl:DespatchAdvice/cbc:ID" priority="1228" mode="M10">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="/ubl:DespatchAdvice/cbc:ID"/>
      <axsl:apply-templates select="@*|*" mode="M10"/>
   </axsl:template>

	<!--RULE -->

   <axsl:template match="/ubl:DespatchAdvice/cbc:IssueDate" priority="1227" mode="M10">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="/ubl:DespatchAdvice/cbc:IssueDate"/>
      <axsl:apply-templates select="@*|*" mode="M10"/>
   </axsl:template>

	<!--RULE -->

   <axsl:template match="/ubl:DespatchAdvice/cbc:IssueTime" priority="1226" mode="M10">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="/ubl:DespatchAdvice/cbc:IssueTime"/>
      <axsl:apply-templates select="@*|*" mode="M10"/>
   </axsl:template>

	<!--RULE -->

   <axsl:template match="/ubl:DespatchAdvice/cbc:Note" priority="1225" mode="M10">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="/ubl:DespatchAdvice/cbc:Note"/>
      <axsl:apply-templates select="@*|*" mode="M10"/>
   </axsl:template>

	<!--RULE -->

   <axsl:template match="/ubl:DespatchAdvice/cac:OrderReference" priority="1224" mode="M10">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="/ubl:DespatchAdvice/cac:OrderReference"/>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="cbc:ID"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="cbc:ID">
               <axsl:attribute name="id">PEPPOL-T16-B00801</axsl:attribute>
               <axsl:attribute name="flag">fatal</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-select-full-path"/>
               </axsl:attribute>
               <svrl:text>Element 'cbc:ID' MUST be provided.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>
      <axsl:apply-templates select="@*|*" mode="M10"/>
   </axsl:template>

	<!--RULE -->

   <axsl:template match="/ubl:DespatchAdvice/cac:OrderReference/cbc:ID" priority="1223" mode="M10">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="/ubl:DespatchAdvice/cac:OrderReference/cbc:ID"/>
      <axsl:apply-templates select="@*|*" mode="M10"/>
   </axsl:template>

	<!--RULE -->

   <axsl:template match="/ubl:DespatchAdvice/cac:OrderReference/*" priority="1222" mode="M10">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="/ubl:DespatchAdvice/cac:OrderReference/*"/>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="false()"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="false()">
               <axsl:attribute name="id">PEPPOL-T16-B00802</axsl:attribute>
               <axsl:attribute name="flag">fatal</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-select-full-path"/>
               </axsl:attribute>
               <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>
      <axsl:apply-templates select="@*|*" mode="M10"/>
   </axsl:template>

	<!--RULE -->

   <axsl:template match="/ubl:DespatchAdvice/cac:DespatchSupplierParty" priority="1221" mode="M10">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="/ubl:DespatchAdvice/cac:DespatchSupplierParty"/>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="cac:Party"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="cac:Party">
               <axsl:attribute name="id">PEPPOL-T16-B01001</axsl:attribute>
               <axsl:attribute name="flag">fatal</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-select-full-path"/>
               </axsl:attribute>
               <svrl:text>Element 'cac:Party' MUST be provided.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>
      <axsl:apply-templates select="@*|*" mode="M10"/>
   </axsl:template>

	<!--RULE -->

   <axsl:template match="/ubl:DespatchAdvice/cac:DespatchSupplierParty/cac:Party" priority="1220" mode="M10">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="/ubl:DespatchAdvice/cac:DespatchSupplierParty/cac:Party"/>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="cbc:EndpointID"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="cbc:EndpointID">
               <axsl:attribute name="id">PEPPOL-T16-B01101</axsl:attribute>
               <axsl:attribute name="flag">fatal</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-select-full-path"/>
               </axsl:attribute>
               <svrl:text>Element 'cbc:EndpointID' MUST be provided.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="cac:PartyLegalEntity"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="cac:PartyLegalEntity">
               <axsl:attribute name="id">PEPPOL-T16-B01102</axsl:attribute>
               <axsl:attribute name="flag">fatal</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-select-full-path"/>
               </axsl:attribute>
               <svrl:text>Element 'cac:PartyLegalEntity' MUST be provided.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>
      <axsl:apply-templates select="@*|*" mode="M10"/>
   </axsl:template>

	<!--RULE -->

   <axsl:template match="/ubl:DespatchAdvice/cac:DespatchSupplierParty/cac:Party/cbc:EndpointID" priority="1219" mode="M10">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="/ubl:DespatchAdvice/cac:DespatchSupplierParty/cac:Party/cbc:EndpointID"/>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="@schemeID"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="@schemeID">
               <axsl:attribute name="id">PEPPOL-T16-B01201</axsl:attribute>
               <axsl:attribute name="flag">fatal</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-select-full-path"/>
               </axsl:attribute>
               <svrl:text>Attribute 'schemeID' MUST be present.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(@schemeID) or (some $code in $cleas satisfies $code = @schemeID)"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(@schemeID) or (some $code in $cleas satisfies $code = @schemeID)">
               <axsl:attribute name="id">PEPPOL-T16-B01202</axsl:attribute>
               <axsl:attribute name="flag">fatal</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-select-full-path"/>
               </axsl:attribute>
               <svrl:text>Value MUST be part of code list 'Electronic Address Scheme (EAS)'.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>
      <axsl:apply-templates select="@*|*" mode="M10"/>
   </axsl:template>

	<!--RULE -->

   <axsl:template match="/ubl:DespatchAdvice/cac:DespatchSupplierParty/cac:Party/cac:PartyIdentification" priority="1218" mode="M10">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="/ubl:DespatchAdvice/cac:DespatchSupplierParty/cac:Party/cac:PartyIdentification"/>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="cbc:ID"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="cbc:ID">
               <axsl:attribute name="id">PEPPOL-T16-B01401</axsl:attribute>
               <axsl:attribute name="flag">fatal</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-select-full-path"/>
               </axsl:attribute>
               <svrl:text>Element 'cbc:ID' MUST be provided.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>
      <axsl:apply-templates select="@*|*" mode="M10"/>
   </axsl:template>

	<!--RULE -->

   <axsl:template match="/ubl:DespatchAdvice/cac:DespatchSupplierParty/cac:Party/cac:PartyIdentification/cbc:ID" priority="1217" mode="M10">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="/ubl:DespatchAdvice/cac:DespatchSupplierParty/cac:Party/cac:PartyIdentification/cbc:ID"/>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(@schemeID) or (some $code in $clICD satisfies $code = @schemeID)"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(@schemeID) or (some $code in $clICD satisfies $code = @schemeID)">
               <axsl:attribute name="id">PEPPOL-T16-B01501</axsl:attribute>
               <axsl:attribute name="flag">fatal</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-select-full-path"/>
               </axsl:attribute>
               <svrl:text>Value MUST be part of code list 'ISO 6523 ICD list'.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>
      <axsl:apply-templates select="@*|*" mode="M10"/>
   </axsl:template>

	<!--RULE -->

   <axsl:template match="/ubl:DespatchAdvice/cac:DespatchSupplierParty/cac:Party/cac:PostalAddress" priority="1216" mode="M10">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="/ubl:DespatchAdvice/cac:DespatchSupplierParty/cac:Party/cac:PostalAddress"/>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="cac:Country"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="cac:Country">
               <axsl:attribute name="id">PEPPOL-T16-B01701</axsl:attribute>
               <axsl:attribute name="flag">fatal</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-select-full-path"/>
               </axsl:attribute>
               <svrl:text>Element 'cac:Country' MUST be provided.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>
      <axsl:apply-templates select="@*|*" mode="M10"/>
   </axsl:template>

	<!--RULE -->

   <axsl:template match="/ubl:DespatchAdvice/cac:DespatchSupplierParty/cac:Party/cac:PostalAddress/cbc:StreetName" priority="1215" mode="M10">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="/ubl:DespatchAdvice/cac:DespatchSupplierParty/cac:Party/cac:PostalAddress/cbc:StreetName"/>
      <axsl:apply-templates select="@*|*" mode="M10"/>
   </axsl:template>

	<!--RULE -->

   <axsl:template match="/ubl:DespatchAdvice/cac:DespatchSupplierParty/cac:Party/cac:PostalAddress/cbc:AdditionalStreetName" priority="1214" mode="M10">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="/ubl:DespatchAdvice/cac:DespatchSupplierParty/cac:Party/cac:PostalAddress/cbc:AdditionalStreetName"/>
      <axsl:apply-templates select="@*|*" mode="M10"/>
   </axsl:template>

	<!--RULE -->

   <axsl:template match="/ubl:DespatchAdvice/cac:DespatchSupplierParty/cac:Party/cac:PostalAddress/cbc:CityName" priority="1213" mode="M10">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="/ubl:DespatchAdvice/cac:DespatchSupplierParty/cac:Party/cac:PostalAddress/cbc:CityName"/>
      <axsl:apply-templates select="@*|*" mode="M10"/>
   </axsl:template>

	<!--RULE -->

   <axsl:template match="/ubl:DespatchAdvice/cac:DespatchSupplierParty/cac:Party/cac:PostalAddress/cbc:PostalZone" priority="1212" mode="M10">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="/ubl:DespatchAdvice/cac:DespatchSupplierParty/cac:Party/cac:PostalAddress/cbc:PostalZone"/>
      <axsl:apply-templates select="@*|*" mode="M10"/>
   </axsl:template>

	<!--RULE -->

   <axsl:template match="/ubl:DespatchAdvice/cac:DespatchSupplierParty/cac:Party/cac:PostalAddress/cbc:CountrySubentity" priority="1211" mode="M10">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="/ubl:DespatchAdvice/cac:DespatchSupplierParty/cac:Party/cac:PostalAddress/cbc:CountrySubentity"/>
      <axsl:apply-templates select="@*|*" mode="M10"/>
   </axsl:template>

	<!--RULE -->

   <axsl:template match="/ubl:DespatchAdvice/cac:DespatchSupplierParty/cac:Party/cac:PostalAddress/cac:AddressLine" priority="1210" mode="M10">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="/ubl:DespatchAdvice/cac:DespatchSupplierParty/cac:Party/cac:PostalAddress/cac:AddressLine"/>
      <axsl:apply-templates select="@*|*" mode="M10"/>
   </axsl:template>

	<!--RULE -->

   <axsl:template match="/ubl:DespatchAdvice/cac:DespatchSupplierParty/cac:Party/cac:PostalAddress/cac:AddressLine/cbc:Line" priority="1209" mode="M10">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="/ubl:DespatchAdvice/cac:DespatchSupplierParty/cac:Party/cac:PostalAddress/cac:AddressLine/cbc:Line"/>
      <axsl:apply-templates select="@*|*" mode="M10"/>
   </axsl:template>

	<!--RULE -->

   <axsl:template match="/ubl:DespatchAdvice/cac:DespatchSupplierParty/cac:Party/cac:PostalAddress/cac:Country" priority="1208" mode="M10">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="/ubl:DespatchAdvice/cac:DespatchSupplierParty/cac:Party/cac:PostalAddress/cac:Country"/>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="cbc:IdentificationCode"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="cbc:IdentificationCode">
               <axsl:attribute name="id">PEPPOL-T16-B02501</axsl:attribute>
               <axsl:attribute name="flag">fatal</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-select-full-path"/>
               </axsl:attribute>
               <svrl:text>Element 'cbc:IdentificationCode' MUST be provided.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>
      <axsl:apply-templates select="@*|*" mode="M10"/>
   </axsl:template>

	<!--RULE -->

   <axsl:template match="/ubl:DespatchAdvice/cac:DespatchSupplierParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode" priority="1207" mode="M10">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="/ubl:DespatchAdvice/cac:DespatchSupplierParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode"/>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="(some $code in $clISO3166 satisfies $code = normalize-space(text()))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="(some $code in $clISO3166 satisfies $code = normalize-space(text()))">
               <axsl:attribute name="id">PEPPOL-T16-B02601</axsl:attribute>
               <axsl:attribute name="flag">fatal</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-select-full-path"/>
               </axsl:attribute>
               <svrl:text>Value MUST be part of code list 'Country codes (ISO 3166-1:Alpha2)'.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>
      <axsl:apply-templates select="@*|*" mode="M10"/>
   </axsl:template>

	<!--RULE -->

   <axsl:template match="/ubl:DespatchAdvice/cac:DespatchSupplierParty/cac:Party/cac:PostalAddress/cac:Country/*" priority="1206" mode="M10">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="/ubl:DespatchAdvice/cac:DespatchSupplierParty/cac:Party/cac:PostalAddress/cac:Country/*"/>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="false()"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="false()">
               <axsl:attribute name="id">PEPPOL-T16-B02502</axsl:attribute>
               <axsl:attribute name="flag">fatal</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-select-full-path"/>
               </axsl:attribute>
               <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>
      <axsl:apply-templates select="@*|*" mode="M10"/>
   </axsl:template>

	<!--RULE -->

   <axsl:template match="/ubl:DespatchAdvice/cac:DespatchSupplierParty/cac:Party/cac:PostalAddress/*" priority="1205" mode="M10">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="/ubl:DespatchAdvice/cac:DespatchSupplierParty/cac:Party/cac:PostalAddress/*"/>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="false()"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="false()">
               <axsl:attribute name="id">PEPPOL-T16-B01702</axsl:attribute>
               <axsl:attribute name="flag">fatal</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-select-full-path"/>
               </axsl:attribute>
               <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>
      <axsl:apply-templates select="@*|*" mode="M10"/>
   </axsl:template>

	<!--RULE -->

   <axsl:template match="/ubl:DespatchAdvice/cac:DespatchSupplierParty/cac:Party/cac:PartyLegalEntity" priority="1204" mode="M10">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="/ubl:DespatchAdvice/cac:DespatchSupplierParty/cac:Party/cac:PartyLegalEntity"/>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="cbc:RegistrationName"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="cbc:RegistrationName">
               <axsl:attribute name="id">PEPPOL-T16-B02701</axsl:attribute>
               <axsl:attribute name="flag">fatal</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-select-full-path"/>
               </axsl:attribute>
               <svrl:text>Element 'cbc:RegistrationName' MUST be provided.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>
      <axsl:apply-templates select="@*|*" mode="M10"/>
   </axsl:template>

	<!--RULE -->

   <axsl:template match="/ubl:DespatchAdvice/cac:DespatchSupplierParty/cac:Party/cac:PartyLegalEntity/cbc:RegistrationName" priority="1203" mode="M10">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="/ubl:DespatchAdvice/cac:DespatchSupplierParty/cac:Party/cac:PartyLegalEntity/cbc:RegistrationName"/>
      <axsl:apply-templates select="@*|*" mode="M10"/>
   </axsl:template>

	<!--RULE -->

   <axsl:template match="/ubl:DespatchAdvice/cac:DespatchSupplierParty/cac:Party/cac:PartyLegalEntity/*" priority="1202" mode="M10">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="/ubl:DespatchAdvice/cac:DespatchSupplierParty/cac:Party/cac:PartyLegalEntity/*"/>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="false()"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="false()">
               <axsl:attribute name="id">PEPPOL-T16-B02702</axsl:attribute>
               <axsl:attribute name="flag">fatal</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-select-full-path"/>
               </axsl:attribute>
               <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>
      <axsl:apply-templates select="@*|*" mode="M10"/>
   </axsl:template>

	<!--RULE -->

   <axsl:template match="/ubl:DespatchAdvice/cac:DespatchSupplierParty/cac:Party/cac:Contact" priority="1201" mode="M10">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="/ubl:DespatchAdvice/cac:DespatchSupplierParty/cac:Party/cac:Contact"/>
      <axsl:apply-templates select="@*|*" mode="M10"/>
   </axsl:template>

	<!--RULE -->

   <axsl:template match="/ubl:DespatchAdvice/cac:DespatchSupplierParty/cac:Party/cac:Contact/cbc:Name" priority="1200" mode="M10">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="/ubl:DespatchAdvice/cac:DespatchSupplierParty/cac:Party/cac:Contact/cbc:Name"/>
      <axsl:apply-templates select="@*|*" mode="M10"/>
   </axsl:template>

	<!--RULE -->

   <axsl:template match="/ubl:DespatchAdvice/cac:DespatchSupplierParty/cac:Party/cac:Contact/cbc:Telephone" priority="1199" mode="M10">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="/ubl:DespatchAdvice/cac:DespatchSupplierParty/cac:Party/cac:Contact/cbc:Telephone"/>
      <axsl:apply-templates select="@*|*" mode="M10"/>
   </axsl:template>

	<!--RULE -->

   <axsl:template match="/ubl:DespatchAdvice/cac:DespatchSupplierParty/cac:Party/cac:Contact/cbc:ElectronicMail" priority="1198" mode="M10">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="/ubl:DespatchAdvice/cac:DespatchSupplierParty/cac:Party/cac:Contact/cbc:ElectronicMail"/>
      <axsl:apply-templates select="@*|*" mode="M10"/>
   </axsl:template>

	<!--RULE -->

   <axsl:template match="/ubl:DespatchAdvice/cac:DespatchSupplierParty/cac:Party/cac:Contact/*" priority="1197" mode="M10">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="/ubl:DespatchAdvice/cac:DespatchSupplierParty/cac:Party/cac:Contact/*"/>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="false()"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="false()">
               <axsl:attribute name="id">PEPPOL-T16-B02901</axsl:attribute>
               <axsl:attribute name="flag">fatal</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-select-full-path"/>
               </axsl:attribute>
               <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>
      <axsl:apply-templates select="@*|*" mode="M10"/>
   </axsl:template>

	<!--RULE -->

   <axsl:template match="/ubl:DespatchAdvice/cac:DespatchSupplierParty/cac:Party/*" priority="1196" mode="M10">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="/ubl:DespatchAdvice/cac:DespatchSupplierParty/cac:Party/*"/>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="false()"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="false()">
               <axsl:attribute name="id">PEPPOL-T16-B01103</axsl:attribute>
               <axsl:attribute name="flag">fatal</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-select-full-path"/>
               </axsl:attribute>
               <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>
      <axsl:apply-templates select="@*|*" mode="M10"/>
   </axsl:template>

	<!--RULE -->

   <axsl:template match="/ubl:DespatchAdvice/cac:DespatchSupplierParty/*" priority="1195" mode="M10">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="/ubl:DespatchAdvice/cac:DespatchSupplierParty/*"/>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="false()"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="false()">
               <axsl:attribute name="id">PEPPOL-T16-B01002</axsl:attribute>
               <axsl:attribute name="flag">fatal</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-select-full-path"/>
               </axsl:attribute>
               <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>
      <axsl:apply-templates select="@*|*" mode="M10"/>
   </axsl:template>

	<!--RULE -->

   <axsl:template match="/ubl:DespatchAdvice/cac:DeliveryCustomerParty" priority="1194" mode="M10">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="/ubl:DespatchAdvice/cac:DeliveryCustomerParty"/>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="cac:Party"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="cac:Party">
               <axsl:attribute name="id">PEPPOL-T16-B03301</axsl:attribute>
               <axsl:attribute name="flag">fatal</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-select-full-path"/>
               </axsl:attribute>
               <svrl:text>Element 'cac:Party' MUST be provided.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>
      <axsl:apply-templates select="@*|*" mode="M10"/>
   </axsl:template>

	<!--RULE -->

   <axsl:template match="/ubl:DespatchAdvice/cac:DeliveryCustomerParty/cac:Party" priority="1193" mode="M10">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="/ubl:DespatchAdvice/cac:DeliveryCustomerParty/cac:Party"/>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="cbc:EndpointID"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="cbc:EndpointID">
               <axsl:attribute name="id">PEPPOL-T16-B03401</axsl:attribute>
               <axsl:attribute name="flag">fatal</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-select-full-path"/>
               </axsl:attribute>
               <svrl:text>Element 'cbc:EndpointID' MUST be provided.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="cac:PartyLegalEntity"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="cac:PartyLegalEntity">
               <axsl:attribute name="id">PEPPOL-T16-B03402</axsl:attribute>
               <axsl:attribute name="flag">fatal</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-select-full-path"/>
               </axsl:attribute>
               <svrl:text>Element 'cac:PartyLegalEntity' MUST be provided.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>
      <axsl:apply-templates select="@*|*" mode="M10"/>
   </axsl:template>

	<!--RULE -->

   <axsl:template match="/ubl:DespatchAdvice/cac:DeliveryCustomerParty/cac:Party/cbc:EndpointID" priority="1192" mode="M10">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="/ubl:DespatchAdvice/cac:DeliveryCustomerParty/cac:Party/cbc:EndpointID"/>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="@schemeID"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="@schemeID">
               <axsl:attribute name="id">PEPPOL-T16-B03501</axsl:attribute>
               <axsl:attribute name="flag">fatal</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-select-full-path"/>
               </axsl:attribute>
               <svrl:text>Attribute 'schemeID' MUST be present.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(@schemeID) or (some $code in $cleas satisfies $code = @schemeID)"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(@schemeID) or (some $code in $cleas satisfies $code = @schemeID)">
               <axsl:attribute name="id">PEPPOL-T16-B03502</axsl:attribute>
               <axsl:attribute name="flag">fatal</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-select-full-path"/>
               </axsl:attribute>
               <svrl:text>Value MUST be part of code list 'Electronic Address Scheme (EAS)'.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>
      <axsl:apply-templates select="@*|*" mode="M10"/>
   </axsl:template>

	<!--RULE -->

   <axsl:template match="/ubl:DespatchAdvice/cac:DeliveryCustomerParty/cac:Party/cac:PartyIdentification" priority="1191" mode="M10">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="/ubl:DespatchAdvice/cac:DeliveryCustomerParty/cac:Party/cac:PartyIdentification"/>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="cbc:ID"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="cbc:ID">
               <axsl:attribute name="id">PEPPOL-T16-B03701</axsl:attribute>
               <axsl:attribute name="flag">fatal</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-select-full-path"/>
               </axsl:attribute>
               <svrl:text>Element 'cbc:ID' MUST be provided.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>
      <axsl:apply-templates select="@*|*" mode="M10"/>
   </axsl:template>

	<!--RULE -->

   <axsl:template match="/ubl:DespatchAdvice/cac:DeliveryCustomerParty/cac:Party/cac:PartyIdentification/cbc:ID" priority="1190" mode="M10">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="/ubl:DespatchAdvice/cac:DeliveryCustomerParty/cac:Party/cac:PartyIdentification/cbc:ID"/>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(@schemeID) or (some $code in $clICD satisfies $code = @schemeID)"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(@schemeID) or (some $code in $clICD satisfies $code = @schemeID)">
               <axsl:attribute name="id">PEPPOL-T16-B03801</axsl:attribute>
               <axsl:attribute name="flag">fatal</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-select-full-path"/>
               </axsl:attribute>
               <svrl:text>Value MUST be part of code list 'ISO 6523 ICD list'.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>
      <axsl:apply-templates select="@*|*" mode="M10"/>
   </axsl:template>

	<!--RULE -->

   <axsl:template match="/ubl:DespatchAdvice/cac:DeliveryCustomerParty/cac:Party/cac:PostalAddress" priority="1189" mode="M10">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="/ubl:DespatchAdvice/cac:DeliveryCustomerParty/cac:Party/cac:PostalAddress"/>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="cac:Country"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="cac:Country">
               <axsl:attribute name="id">PEPPOL-T16-B04001</axsl:attribute>
               <axsl:attribute name="flag">fatal</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-select-full-path"/>
               </axsl:attribute>
               <svrl:text>Element 'cac:Country' MUST be provided.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>
      <axsl:apply-templates select="@*|*" mode="M10"/>
   </axsl:template>

	<!--RULE -->

   <axsl:template match="/ubl:DespatchAdvice/cac:DeliveryCustomerParty/cac:Party/cac:PostalAddress/cbc:StreetName" priority="1188" mode="M10">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="/ubl:DespatchAdvice/cac:DeliveryCustomerParty/cac:Party/cac:PostalAddress/cbc:StreetName"/>
      <axsl:apply-templates select="@*|*" mode="M10"/>
   </axsl:template>

	<!--RULE -->

   <axsl:template match="/ubl:DespatchAdvice/cac:DeliveryCustomerParty/cac:Party/cac:PostalAddress/cbc:AdditionalStreetName" priority="1187" mode="M10">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="/ubl:DespatchAdvice/cac:DeliveryCustomerParty/cac:Party/cac:PostalAddress/cbc:AdditionalStreetName"/>
      <axsl:apply-templates select="@*|*" mode="M10"/>
   </axsl:template>

	<!--RULE -->

   <axsl:template match="/ubl:DespatchAdvice/cac:DeliveryCustomerParty/cac:Party/cac:PostalAddress/cbc:CityName" priority="1186" mode="M10">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="/ubl:DespatchAdvice/cac:DeliveryCustomerParty/cac:Party/cac:PostalAddress/cbc:CityName"/>
      <axsl:apply-templates select="@*|*" mode="M10"/>
   </axsl:template>

	<!--RULE -->

   <axsl:template match="/ubl:DespatchAdvice/cac:DeliveryCustomerParty/cac:Party/cac:PostalAddress/cbc:PostalZone" priority="1185" mode="M10">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="/ubl:DespatchAdvice/cac:DeliveryCustomerParty/cac:Party/cac:PostalAddress/cbc:PostalZone"/>
      <axsl:apply-templates select="@*|*" mode="M10"/>
   </axsl:template>

	<!--RULE -->

   <axsl:template match="/ubl:DespatchAdvice/cac:DeliveryCustomerParty/cac:Party/cac:PostalAddress/cbc:CountrySubentity" priority="1184" mode="M10">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="/ubl:DespatchAdvice/cac:DeliveryCustomerParty/cac:Party/cac:PostalAddress/cbc:CountrySubentity"/>
      <axsl:apply-templates select="@*|*" mode="M10"/>
   </axsl:template>

	<!--RULE -->

   <axsl:template match="/ubl:DespatchAdvice/cac:DeliveryCustomerParty/cac:Party/cac:PostalAddress/cac:AddressLine" priority="1183" mode="M10">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="/ubl:DespatchAdvice/cac:DeliveryCustomerParty/cac:Party/cac:PostalAddress/cac:AddressLine"/>
      <axsl:apply-templates select="@*|*" mode="M10"/>
   </axsl:template>

	<!--RULE -->

   <axsl:template match="/ubl:DespatchAdvice/cac:DeliveryCustomerParty/cac:Party/cac:PostalAddress/cac:AddressLine/cbc:Line" priority="1182" mode="M10">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="/ubl:DespatchAdvice/cac:DeliveryCustomerParty/cac:Party/cac:PostalAddress/cac:AddressLine/cbc:Line"/>
      <axsl:apply-templates select="@*|*" mode="M10"/>
   </axsl:template>

	<!--RULE -->

   <axsl:template match="/ubl:DespatchAdvice/cac:DeliveryCustomerParty/cac:Party/cac:PostalAddress/cac:Country" priority="1181" mode="M10">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="/ubl:DespatchAdvice/cac:DeliveryCustomerParty/cac:Party/cac:PostalAddress/cac:Country"/>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="cbc:IdentificationCode"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="cbc:IdentificationCode">
               <axsl:attribute name="id">PEPPOL-T16-B04801</axsl:attribute>
               <axsl:attribute name="flag">fatal</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-select-full-path"/>
               </axsl:attribute>
               <svrl:text>Element 'cbc:IdentificationCode' MUST be provided.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>
      <axsl:apply-templates select="@*|*" mode="M10"/>
   </axsl:template>

	<!--RULE -->

   <axsl:template match="/ubl:DespatchAdvice/cac:DeliveryCustomerParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode" priority="1180" mode="M10">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="/ubl:DespatchAdvice/cac:DeliveryCustomerParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode"/>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="(some $code in $clISO3166 satisfies $code = normalize-space(text()))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="(some $code in $clISO3166 satisfies $code = normalize-space(text()))">
               <axsl:attribute name="id">PEPPOL-T16-B04901</axsl:attribute>
               <axsl:attribute name="flag">fatal</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-select-full-path"/>
               </axsl:attribute>
               <svrl:text>Value MUST be part of code list 'Country codes (ISO 3166-1:Alpha2)'.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>
      <axsl:apply-templates select="@*|*" mode="M10"/>
   </axsl:template>

	<!--RULE -->

   <axsl:template match="/ubl:DespatchAdvice/cac:DeliveryCustomerParty/cac:Party/cac:PostalAddress/cac:Country/*" priority="1179" mode="M10">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="/ubl:DespatchAdvice/cac:DeliveryCustomerParty/cac:Party/cac:PostalAddress/cac:Country/*"/>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="false()"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="false()">
               <axsl:attribute name="id">PEPPOL-T16-B04802</axsl:attribute>
               <axsl:attribute name="flag">fatal</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-select-full-path"/>
               </axsl:attribute>
               <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>
      <axsl:apply-templates select="@*|*" mode="M10"/>
   </axsl:template>

	<!--RULE -->

   <axsl:template match="/ubl:DespatchAdvice/cac:DeliveryCustomerParty/cac:Party/cac:PostalAddress/*" priority="1178" mode="M10">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="/ubl:DespatchAdvice/cac:DeliveryCustomerParty/cac:Party/cac:PostalAddress/*"/>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="false()"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="false()">
               <axsl:attribute name="id">PEPPOL-T16-B04002</axsl:attribute>
               <axsl:attribute name="flag">fatal</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-select-full-path"/>
               </axsl:attribute>
               <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>
      <axsl:apply-templates select="@*|*" mode="M10"/>
   </axsl:template>

	<!--RULE -->

   <axsl:template match="/ubl:DespatchAdvice/cac:DeliveryCustomerParty/cac:Party/cac:PartyLegalEntity" priority="1177" mode="M10">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="/ubl:DespatchAdvice/cac:DeliveryCustomerParty/cac:Party/cac:PartyLegalEntity"/>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="cbc:RegistrationName"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="cbc:RegistrationName">
               <axsl:attribute name="id">PEPPOL-T16-B05001</axsl:attribute>
               <axsl:attribute name="flag">fatal</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-select-full-path"/>
               </axsl:attribute>
               <svrl:text>Element 'cbc:RegistrationName' MUST be provided.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>
      <axsl:apply-templates select="@*|*" mode="M10"/>
   </axsl:template>

	<!--RULE -->

   <axsl:template match="/ubl:DespatchAdvice/cac:DeliveryCustomerParty/cac:Party/cac:PartyLegalEntity/cbc:RegistrationName" priority="1176" mode="M10">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="/ubl:DespatchAdvice/cac:DeliveryCustomerParty/cac:Party/cac:PartyLegalEntity/cbc:RegistrationName"/>
      <axsl:apply-templates select="@*|*" mode="M10"/>
   </axsl:template>

	<!--RULE -->

   <axsl:template match="/ubl:DespatchAdvice/cac:DeliveryCustomerParty/cac:Party/cac:PartyLegalEntity/*" priority="1175" mode="M10">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="/ubl:DespatchAdvice/cac:DeliveryCustomerParty/cac:Party/cac:PartyLegalEntity/*"/>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="false()"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="false()">
               <axsl:attribute name="id">PEPPOL-T16-B05002</axsl:attribute>
               <axsl:attribute name="flag">fatal</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-select-full-path"/>
               </axsl:attribute>
               <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>
      <axsl:apply-templates select="@*|*" mode="M10"/>
   </axsl:template>

	<!--RULE -->

   <axsl:template match="/ubl:DespatchAdvice/cac:DeliveryCustomerParty/cac:Party/*" priority="1174" mode="M10">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="/ubl:DespatchAdvice/cac:DeliveryCustomerParty/cac:Party/*"/>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="false()"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="false()">
               <axsl:attribute name="id">PEPPOL-T16-B03403</axsl:attribute>
               <axsl:attribute name="flag">fatal</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-select-full-path"/>
               </axsl:attribute>
               <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>
      <axsl:apply-templates select="@*|*" mode="M10"/>
   </axsl:template>

	<!--RULE -->

   <axsl:template match="/ubl:DespatchAdvice/cac:DeliveryCustomerParty/cac:DeliveryContact" priority="1173" mode="M10">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="/ubl:DespatchAdvice/cac:DeliveryCustomerParty/cac:DeliveryContact"/>
      <axsl:apply-templates select="@*|*" mode="M10"/>
   </axsl:template>

	<!--RULE -->

   <axsl:template match="/ubl:DespatchAdvice/cac:DeliveryCustomerParty/cac:DeliveryContact/cbc:Name" priority="1172" mode="M10">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="/ubl:DespatchAdvice/cac:DeliveryCustomerParty/cac:DeliveryContact/cbc:Name"/>
      <axsl:apply-templates select="@*|*" mode="M10"/>
   </axsl:template>

	<!--RULE -->

   <axsl:template match="/ubl:DespatchAdvice/cac:DeliveryCustomerParty/cac:DeliveryContact/cbc:Telephone" priority="1171" mode="M10">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="/ubl:DespatchAdvice/cac:DeliveryCustomerParty/cac:DeliveryContact/cbc:Telephone"/>
      <axsl:apply-templates select="@*|*" mode="M10"/>
   </axsl:template>

	<!--RULE -->

   <axsl:template match="/ubl:DespatchAdvice/cac:DeliveryCustomerParty/cac:DeliveryContact/cbc:ElectronicMail" priority="1170" mode="M10">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="/ubl:DespatchAdvice/cac:DeliveryCustomerParty/cac:DeliveryContact/cbc:ElectronicMail"/>
      <axsl:apply-templates select="@*|*" mode="M10"/>
   </axsl:template>

	<!--RULE -->

   <axsl:template match="/ubl:DespatchAdvice/cac:DeliveryCustomerParty/cac:DeliveryContact/*" priority="1169" mode="M10">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="/ubl:DespatchAdvice/cac:DeliveryCustomerParty/cac:DeliveryContact/*"/>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="false()"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="false()">
               <axsl:attribute name="id">PEPPOL-T16-B05201</axsl:attribute>
               <axsl:attribute name="flag">fatal</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-select-full-path"/>
               </axsl:attribute>
               <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>
      <axsl:apply-templates select="@*|*" mode="M10"/>
   </axsl:template>

	<!--RULE -->

   <axsl:template match="/ubl:DespatchAdvice/cac:DeliveryCustomerParty/*" priority="1168" mode="M10">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="/ubl:DespatchAdvice/cac:DeliveryCustomerParty/*"/>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="false()"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="false()">
               <axsl:attribute name="id">PEPPOL-T16-B03302</axsl:attribute>
               <axsl:attribute name="flag">fatal</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-select-full-path"/>
               </axsl:attribute>
               <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>
      <axsl:apply-templates select="@*|*" mode="M10"/>
   </axsl:template>

	<!--RULE -->

   <axsl:template match="/ubl:DespatchAdvice/cac:BuyerCustomerParty" priority="1167" mode="M10">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="/ubl:DespatchAdvice/cac:BuyerCustomerParty"/>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="cac:Party"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="cac:Party">
               <axsl:attribute name="id">PEPPOL-T16-B05601</axsl:attribute>
               <axsl:attribute name="flag">fatal</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-select-full-path"/>
               </axsl:attribute>
               <svrl:text>Element 'cac:Party' MUST be provided.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>
      <axsl:apply-templates select="@*|*" mode="M10"/>
   </axsl:template>

	<!--RULE -->

   <axsl:template match="/ubl:DespatchAdvice/cac:BuyerCustomerParty/cac:Party" priority="1166" mode="M10">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="/ubl:DespatchAdvice/cac:BuyerCustomerParty/cac:Party"/>
      <axsl:apply-templates select="@*|*" mode="M10"/>
   </axsl:template>

	<!--RULE -->

   <axsl:template match="/ubl:DespatchAdvice/cac:BuyerCustomerParty/cac:Party/cac:PartyIdentification" priority="1165" mode="M10">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="/ubl:DespatchAdvice/cac:BuyerCustomerParty/cac:Party/cac:PartyIdentification"/>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="cbc:ID"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="cbc:ID">
               <axsl:attribute name="id">PEPPOL-T16-B05801</axsl:attribute>
               <axsl:attribute name="flag">fatal</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-select-full-path"/>
               </axsl:attribute>
               <svrl:text>Element 'cbc:ID' MUST be provided.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>
      <axsl:apply-templates select="@*|*" mode="M10"/>
   </axsl:template>

	<!--RULE -->

   <axsl:template match="/ubl:DespatchAdvice/cac:BuyerCustomerParty/cac:Party/cac:PartyIdentification/cbc:ID" priority="1164" mode="M10">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="/ubl:DespatchAdvice/cac:BuyerCustomerParty/cac:Party/cac:PartyIdentification/cbc:ID"/>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(@schemeID) or (some $code in $clICD satisfies $code = @schemeID)"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(@schemeID) or (some $code in $clICD satisfies $code = @schemeID)">
               <axsl:attribute name="id">PEPPOL-T16-B05901</axsl:attribute>
               <axsl:attribute name="flag">fatal</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-select-full-path"/>
               </axsl:attribute>
               <svrl:text>Value MUST be part of code list 'ISO 6523 ICD list'.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>
      <axsl:apply-templates select="@*|*" mode="M10"/>
   </axsl:template>

	<!--RULE -->

   <axsl:template match="/ubl:DespatchAdvice/cac:BuyerCustomerParty/cac:Party/cac:PartyName" priority="1163" mode="M10">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="/ubl:DespatchAdvice/cac:BuyerCustomerParty/cac:Party/cac:PartyName"/>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="cbc:Name"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="cbc:Name">
               <axsl:attribute name="id">PEPPOL-T16-B06101</axsl:attribute>
               <axsl:attribute name="flag">fatal</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-select-full-path"/>
               </axsl:attribute>
               <svrl:text>Element 'cbc:Name' MUST be provided.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>
      <axsl:apply-templates select="@*|*" mode="M10"/>
   </axsl:template>

	<!--RULE -->

   <axsl:template match="/ubl:DespatchAdvice/cac:BuyerCustomerParty/cac:Party/cac:PartyName/cbc:Name" priority="1162" mode="M10">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="/ubl:DespatchAdvice/cac:BuyerCustomerParty/cac:Party/cac:PartyName/cbc:Name"/>
      <axsl:apply-templates select="@*|*" mode="M10"/>
   </axsl:template>

	<!--RULE -->

   <axsl:template match="/ubl:DespatchAdvice/cac:BuyerCustomerParty/cac:Party/cac:PostalAddress" priority="1161" mode="M10">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="/ubl:DespatchAdvice/cac:BuyerCustomerParty/cac:Party/cac:PostalAddress"/>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="cac:Country"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="cac:Country">
               <axsl:attribute name="id">PEPPOL-T16-B06301</axsl:attribute>
               <axsl:attribute name="flag">fatal</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-select-full-path"/>
               </axsl:attribute>
               <svrl:text>Element 'cac:Country' MUST be provided.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>
      <axsl:apply-templates select="@*|*" mode="M10"/>
   </axsl:template>

	<!--RULE -->

   <axsl:template match="/ubl:DespatchAdvice/cac:BuyerCustomerParty/cac:Party/cac:PostalAddress/cbc:StreetName" priority="1160" mode="M10">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="/ubl:DespatchAdvice/cac:BuyerCustomerParty/cac:Party/cac:PostalAddress/cbc:StreetName"/>
      <axsl:apply-templates select="@*|*" mode="M10"/>
   </axsl:template>

	<!--RULE -->

   <axsl:template match="/ubl:DespatchAdvice/cac:BuyerCustomerParty/cac:Party/cac:PostalAddress/cbc:AdditionalStreetName" priority="1159" mode="M10">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="/ubl:DespatchAdvice/cac:BuyerCustomerParty/cac:Party/cac:PostalAddress/cbc:AdditionalStreetName"/>
      <axsl:apply-templates select="@*|*" mode="M10"/>
   </axsl:template>

	<!--RULE -->

   <axsl:template match="/ubl:DespatchAdvice/cac:BuyerCustomerParty/cac:Party/cac:PostalAddress/cbc:CityName" priority="1158" mode="M10">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="/ubl:DespatchAdvice/cac:BuyerCustomerParty/cac:Party/cac:PostalAddress/cbc:CityName"/>
      <axsl:apply-templates select="@*|*" mode="M10"/>
   </axsl:template>

	<!--RULE -->

   <axsl:template match="/ubl:DespatchAdvice/cac:BuyerCustomerParty/cac:Party/cac:PostalAddress/cbc:PostalZone" priority="1157" mode="M10">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="/ubl:DespatchAdvice/cac:BuyerCustomerParty/cac:Party/cac:PostalAddress/cbc:PostalZone"/>
      <axsl:apply-templates select="@*|*" mode="M10"/>
   </axsl:template>

	<!--RULE -->

   <axsl:template match="/ubl:DespatchAdvice/cac:BuyerCustomerParty/cac:Party/cac:PostalAddress/cbc:CountrySubentity" priority="1156" mode="M10">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="/ubl:DespatchAdvice/cac:BuyerCustomerParty/cac:Party/cac:PostalAddress/cbc:CountrySubentity"/>
      <axsl:apply-templates select="@*|*" mode="M10"/>
   </axsl:template>

	<!--RULE -->

   <axsl:template match="/ubl:DespatchAdvice/cac:BuyerCustomerParty/cac:Party/cac:PostalAddress/cac:AddressLine" priority="1155" mode="M10">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="/ubl:DespatchAdvice/cac:BuyerCustomerParty/cac:Party/cac:PostalAddress/cac:AddressLine"/>
      <axsl:apply-templates select="@*|*" mode="M10"/>
   </axsl:template>

	<!--RULE -->

   <axsl:template match="/ubl:DespatchAdvice/cac:BuyerCustomerParty/cac:Party/cac:PostalAddress/cac:AddressLine/cbc:Line" priority="1154" mode="M10">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="/ubl:DespatchAdvice/cac:BuyerCustomerParty/cac:Party/cac:PostalAddress/cac:AddressLine/cbc:Line"/>
      <axsl:apply-templates select="@*|*" mode="M10"/>
   </axsl:template>

	<!--RULE -->

   <axsl:template match="/ubl:DespatchAdvice/cac:BuyerCustomerParty/cac:Party/cac:PostalAddress/cac:Country" priority="1153" mode="M10">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="/ubl:DespatchAdvice/cac:BuyerCustomerParty/cac:Party/cac:PostalAddress/cac:Country"/>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="cbc:IdentificationCode"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="cbc:IdentificationCode">
               <axsl:attribute name="id">PEPPOL-T16-B07101</axsl:attribute>
               <axsl:attribute name="flag">fatal</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-select-full-path"/>
               </axsl:attribute>
               <svrl:text>Element 'cbc:IdentificationCode' MUST be provided.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>
      <axsl:apply-templates select="@*|*" mode="M10"/>
   </axsl:template>

	<!--RULE -->

   <axsl:template match="/ubl:DespatchAdvice/cac:BuyerCustomerParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode" priority="1152" mode="M10">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="/ubl:DespatchAdvice/cac:BuyerCustomerParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode"/>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="(some $code in $clISO3166 satisfies $code = normalize-space(text()))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="(some $code in $clISO3166 satisfies $code = normalize-space(text()))">
               <axsl:attribute name="id">PEPPOL-T16-B07201</axsl:attribute>
               <axsl:attribute name="flag">fatal</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-select-full-path"/>
               </axsl:attribute>
               <svrl:text>Value MUST be part of code list 'Country codes (ISO 3166-1:Alpha2)'.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>
      <axsl:apply-templates select="@*|*" mode="M10"/>
   </axsl:template>

	<!--RULE -->

   <axsl:template match="/ubl:DespatchAdvice/cac:BuyerCustomerParty/cac:Party/cac:PostalAddress/cac:Country/*" priority="1151" mode="M10">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="/ubl:DespatchAdvice/cac:BuyerCustomerParty/cac:Party/cac:PostalAddress/cac:Country/*"/>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="false()"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="false()">
               <axsl:attribute name="id">PEPPOL-T16-B07102</axsl:attribute>
               <axsl:attribute name="flag">fatal</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-select-full-path"/>
               </axsl:attribute>
               <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>
      <axsl:apply-templates select="@*|*" mode="M10"/>
   </axsl:template>

	<!--RULE -->

   <axsl:template match="/ubl:DespatchAdvice/cac:BuyerCustomerParty/cac:Party/cac:PostalAddress/*" priority="1150" mode="M10">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="/ubl:DespatchAdvice/cac:BuyerCustomerParty/cac:Party/cac:PostalAddress/*"/>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="false()"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="false()">
               <axsl:attribute name="id">PEPPOL-T16-B06302</axsl:attribute>
               <axsl:attribute name="flag">fatal</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-select-full-path"/>
               </axsl:attribute>
               <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>
      <axsl:apply-templates select="@*|*" mode="M10"/>
   </axsl:template>

	<!--RULE -->

   <axsl:template match="/ubl:DespatchAdvice/cac:BuyerCustomerParty/cac:Party/*" priority="1149" mode="M10">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="/ubl:DespatchAdvice/cac:BuyerCustomerParty/cac:Party/*"/>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="false()"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="false()">
               <axsl:attribute name="id">PEPPOL-T16-B05701</axsl:attribute>
               <axsl:attribute name="flag">fatal</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-select-full-path"/>
               </axsl:attribute>
               <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>
      <axsl:apply-templates select="@*|*" mode="M10"/>
   </axsl:template>

	<!--RULE -->

   <axsl:template match="/ubl:DespatchAdvice/cac:BuyerCustomerParty/*" priority="1148" mode="M10">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="/ubl:DespatchAdvice/cac:BuyerCustomerParty/*"/>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="false()"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="false()">
               <axsl:attribute name="id">PEPPOL-T16-B05602</axsl:attribute>
               <axsl:attribute name="flag">fatal</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-select-full-path"/>
               </axsl:attribute>
               <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>
      <axsl:apply-templates select="@*|*" mode="M10"/>
   </axsl:template>

	<!--RULE -->

   <axsl:template match="/ubl:DespatchAdvice/cac:SellerSupplierParty" priority="1147" mode="M10">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="/ubl:DespatchAdvice/cac:SellerSupplierParty"/>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="cac:Party"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="cac:Party">
               <axsl:attribute name="id">PEPPOL-T16-B07301</axsl:attribute>
               <axsl:attribute name="flag">fatal</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-select-full-path"/>
               </axsl:attribute>
               <svrl:text>Element 'cac:Party' MUST be provided.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>
      <axsl:apply-templates select="@*|*" mode="M10"/>
   </axsl:template>

	<!--RULE -->

   <axsl:template match="/ubl:DespatchAdvice/cac:SellerSupplierParty/cac:Party" priority="1146" mode="M10">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="/ubl:DespatchAdvice/cac:SellerSupplierParty/cac:Party"/>
      <axsl:apply-templates select="@*|*" mode="M10"/>
   </axsl:template>

	<!--RULE -->

   <axsl:template match="/ubl:DespatchAdvice/cac:SellerSupplierParty/cac:Party/cac:PartyIdentification" priority="1145" mode="M10">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="/ubl:DespatchAdvice/cac:SellerSupplierParty/cac:Party/cac:PartyIdentification"/>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="cbc:ID"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="cbc:ID">
               <axsl:attribute name="id">PEPPOL-T16-B07501</axsl:attribute>
               <axsl:attribute name="flag">fatal</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-select-full-path"/>
               </axsl:attribute>
               <svrl:text>Element 'cbc:ID' MUST be provided.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>
      <axsl:apply-templates select="@*|*" mode="M10"/>
   </axsl:template>

	<!--RULE -->

   <axsl:template match="/ubl:DespatchAdvice/cac:SellerSupplierParty/cac:Party/cac:PartyIdentification/cbc:ID" priority="1144" mode="M10">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="/ubl:DespatchAdvice/cac:SellerSupplierParty/cac:Party/cac:PartyIdentification/cbc:ID"/>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(@schemeID) or (some $code in $clICD satisfies $code = @schemeID)"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(@schemeID) or (some $code in $clICD satisfies $code = @schemeID)">
               <axsl:attribute name="id">PEPPOL-T16-B07601</axsl:attribute>
               <axsl:attribute name="flag">fatal</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-select-full-path"/>
               </axsl:attribute>
               <svrl:text>Value MUST be part of code list 'ISO 6523 ICD list'.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>
      <axsl:apply-templates select="@*|*" mode="M10"/>
   </axsl:template>

	<!--RULE -->

   <axsl:template match="/ubl:DespatchAdvice/cac:SellerSupplierParty/cac:Party/cac:PartyName" priority="1143" mode="M10">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="/ubl:DespatchAdvice/cac:SellerSupplierParty/cac:Party/cac:PartyName"/>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="cbc:Name"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="cbc:Name">
               <axsl:attribute name="id">PEPPOL-T16-B07801</axsl:attribute>
               <axsl:attribute name="flag">fatal</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-select-full-path"/>
               </axsl:attribute>
               <svrl:text>Element 'cbc:Name' MUST be provided.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>
      <axsl:apply-templates select="@*|*" mode="M10"/>
   </axsl:template>

	<!--RULE -->

   <axsl:template match="/ubl:DespatchAdvice/cac:SellerSupplierParty/cac:Party/cac:PartyName/cbc:Name" priority="1142" mode="M10">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="/ubl:DespatchAdvice/cac:SellerSupplierParty/cac:Party/cac:PartyName/cbc:Name"/>
      <axsl:apply-templates select="@*|*" mode="M10"/>
   </axsl:template>

	<!--RULE -->

   <axsl:template match="/ubl:DespatchAdvice/cac:SellerSupplierParty/cac:Party/cac:PostalAddress" priority="1141" mode="M10">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="/ubl:DespatchAdvice/cac:SellerSupplierParty/cac:Party/cac:PostalAddress"/>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="cac:Country"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="cac:Country">
               <axsl:attribute name="id">PEPPOL-T16-B08001</axsl:attribute>
               <axsl:attribute name="flag">fatal</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-select-full-path"/>
               </axsl:attribute>
               <svrl:text>Element 'cac:Country' MUST be provided.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>
      <axsl:apply-templates select="@*|*" mode="M10"/>
   </axsl:template>

	<!--RULE -->

   <axsl:template match="/ubl:DespatchAdvice/cac:SellerSupplierParty/cac:Party/cac:PostalAddress/cbc:StreetName" priority="1140" mode="M10">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="/ubl:DespatchAdvice/cac:SellerSupplierParty/cac:Party/cac:PostalAddress/cbc:StreetName"/>
      <axsl:apply-templates select="@*|*" mode="M10"/>
   </axsl:template>

	<!--RULE -->

   <axsl:template match="/ubl:DespatchAdvice/cac:SellerSupplierParty/cac:Party/cac:PostalAddress/cbc:AdditionalStreetName" priority="1139" mode="M10">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="/ubl:DespatchAdvice/cac:SellerSupplierParty/cac:Party/cac:PostalAddress/cbc:AdditionalStreetName"/>
      <axsl:apply-templates select="@*|*" mode="M10"/>
   </axsl:template>

	<!--RULE -->

   <axsl:template match="/ubl:DespatchAdvice/cac:SellerSupplierParty/cac:Party/cac:PostalAddress/cbc:CityName" priority="1138" mode="M10">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="/ubl:DespatchAdvice/cac:SellerSupplierParty/cac:Party/cac:PostalAddress/cbc:CityName"/>
      <axsl:apply-templates select="@*|*" mode="M10"/>
   </axsl:template>

	<!--RULE -->

   <axsl:template match="/ubl:DespatchAdvice/cac:SellerSupplierParty/cac:Party/cac:PostalAddress/cbc:PostalZone" priority="1137" mode="M10">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="/ubl:DespatchAdvice/cac:SellerSupplierParty/cac:Party/cac:PostalAddress/cbc:PostalZone"/>
      <axsl:apply-templates select="@*|*" mode="M10"/>
   </axsl:template>

	<!--RULE -->

   <axsl:template match="/ubl:DespatchAdvice/cac:SellerSupplierParty/cac:Party/cac:PostalAddress/cbc:CountrySubentity" priority="1136" mode="M10">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="/ubl:DespatchAdvice/cac:SellerSupplierParty/cac:Party/cac:PostalAddress/cbc:CountrySubentity"/>
      <axsl:apply-templates select="@*|*" mode="M10"/>
   </axsl:template>

	<!--RULE -->

   <axsl:template match="/ubl:DespatchAdvice/cac:SellerSupplierParty/cac:Party/cac:PostalAddress/cac:AddressLine" priority="1135" mode="M10">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="/ubl:DespatchAdvice/cac:SellerSupplierParty/cac:Party/cac:PostalAddress/cac:AddressLine"/>
      <axsl:apply-templates select="@*|*" mode="M10"/>
   </axsl:template>

	<!--RULE -->

   <axsl:template match="/ubl:DespatchAdvice/cac:SellerSupplierParty/cac:Party/cac:PostalAddress/cac:AddressLine/cbc:Line" priority="1134" mode="M10">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="/ubl:DespatchAdvice/cac:SellerSupplierParty/cac:Party/cac:PostalAddress/cac:AddressLine/cbc:Line"/>
      <axsl:apply-templates select="@*|*" mode="M10"/>
   </axsl:template>

	<!--RULE -->

   <axsl:template match="/ubl:DespatchAdvice/cac:SellerSupplierParty/cac:Party/cac:PostalAddress/cac:Country" priority="1133" mode="M10">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="/ubl:DespatchAdvice/cac:SellerSupplierParty/cac:Party/cac:PostalAddress/cac:Country"/>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="cbc:IdentificationCode"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="cbc:IdentificationCode">
               <axsl:attribute name="id">PEPPOL-T16-B08801</axsl:attribute>
               <axsl:attribute name="flag">fatal</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-select-full-path"/>
               </axsl:attribute>
               <svrl:text>Element 'cbc:IdentificationCode' MUST be provided.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>
      <axsl:apply-templates select="@*|*" mode="M10"/>
   </axsl:template>

	<!--RULE -->

   <axsl:template match="/ubl:DespatchAdvice/cac:SellerSupplierParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode" priority="1132" mode="M10">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="/ubl:DespatchAdvice/cac:SellerSupplierParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode"/>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="(some $code in $clISO3166 satisfies $code = normalize-space(text()))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="(some $code in $clISO3166 satisfies $code = normalize-space(text()))">
               <axsl:attribute name="id">PEPPOL-T16-B08901</axsl:attribute>
               <axsl:attribute name="flag">fatal</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-select-full-path"/>
               </axsl:attribute>
               <svrl:text>Value MUST be part of code list 'Country codes (ISO 3166-1:Alpha2)'.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>
      <axsl:apply-templates select="@*|*" mode="M10"/>
   </axsl:template>

	<!--RULE -->

   <axsl:template match="/ubl:DespatchAdvice/cac:SellerSupplierParty/cac:Party/cac:PostalAddress/cac:Country/*" priority="1131" mode="M10">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="/ubl:DespatchAdvice/cac:SellerSupplierParty/cac:Party/cac:PostalAddress/cac:Country/*"/>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="false()"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="false()">
               <axsl:attribute name="id">PEPPOL-T16-B08802</axsl:attribute>
               <axsl:attribute name="flag">fatal</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-select-full-path"/>
               </axsl:attribute>
               <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>
      <axsl:apply-templates select="@*|*" mode="M10"/>
   </axsl:template>

	<!--RULE -->

   <axsl:template match="/ubl:DespatchAdvice/cac:SellerSupplierParty/cac:Party/cac:PostalAddress/*" priority="1130" mode="M10">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="/ubl:DespatchAdvice/cac:SellerSupplierParty/cac:Party/cac:PostalAddress/*"/>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="false()"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="false()">
               <axsl:attribute name="id">PEPPOL-T16-B08002</axsl:attribute>
               <axsl:attribute name="flag">fatal</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-select-full-path"/>
               </axsl:attribute>
               <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>
      <axsl:apply-templates select="@*|*" mode="M10"/>
   </axsl:template>

	<!--RULE -->

   <axsl:template match="/ubl:DespatchAdvice/cac:SellerSupplierParty/cac:Party/*" priority="1129" mode="M10">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="/ubl:DespatchAdvice/cac:SellerSupplierParty/cac:Party/*"/>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="false()"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="false()">
               <axsl:attribute name="id">PEPPOL-T16-B07401</axsl:attribute>
               <axsl:attribute name="flag">fatal</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-select-full-path"/>
               </axsl:attribute>
               <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>
      <axsl:apply-templates select="@*|*" mode="M10"/>
   </axsl:template>

	<!--RULE -->

   <axsl:template match="/ubl:DespatchAdvice/cac:SellerSupplierParty/*" priority="1128" mode="M10">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="/ubl:DespatchAdvice/cac:SellerSupplierParty/*"/>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="false()"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="false()">
               <axsl:attribute name="id">PEPPOL-T16-B07302</axsl:attribute>
               <axsl:attribute name="flag">fatal</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-select-full-path"/>
               </axsl:attribute>
               <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>
      <axsl:apply-templates select="@*|*" mode="M10"/>
   </axsl:template>

	<!--RULE -->

   <axsl:template match="/ubl:DespatchAdvice/cac:OriginatorCustomerParty" priority="1127" mode="M10">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="/ubl:DespatchAdvice/cac:OriginatorCustomerParty"/>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="cac:Party"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="cac:Party">
               <axsl:attribute name="id">PEPPOL-T16-B09001</axsl:attribute>
               <axsl:attribute name="flag">fatal</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-select-full-path"/>
               </axsl:attribute>
               <svrl:text>Element 'cac:Party' MUST be provided.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>
      <axsl:apply-templates select="@*|*" mode="M10"/>
   </axsl:template>

	<!--RULE -->

   <axsl:template match="/ubl:DespatchAdvice/cac:OriginatorCustomerParty/cac:Party" priority="1126" mode="M10">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="/ubl:DespatchAdvice/cac:OriginatorCustomerParty/cac:Party"/>
      <axsl:apply-templates select="@*|*" mode="M10"/>
   </axsl:template>

	<!--RULE -->

   <axsl:template match="/ubl:DespatchAdvice/cac:OriginatorCustomerParty/cac:Party/cac:PartyIdentification" priority="1125" mode="M10">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="/ubl:DespatchAdvice/cac:OriginatorCustomerParty/cac:Party/cac:PartyIdentification"/>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="cbc:ID"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="cbc:ID">
               <axsl:attribute name="id">PEPPOL-T16-B09201</axsl:attribute>
               <axsl:attribute name="flag">fatal</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-select-full-path"/>
               </axsl:attribute>
               <svrl:text>Element 'cbc:ID' MUST be provided.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>
      <axsl:apply-templates select="@*|*" mode="M10"/>
   </axsl:template>

	<!--RULE -->

   <axsl:template match="/ubl:DespatchAdvice/cac:OriginatorCustomerParty/cac:Party/cac:PartyIdentification/cbc:ID" priority="1124" mode="M10">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="/ubl:DespatchAdvice/cac:OriginatorCustomerParty/cac:Party/cac:PartyIdentification/cbc:ID"/>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(@schemeID) or (some $code in $clICD satisfies $code = @schemeID)"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(@schemeID) or (some $code in $clICD satisfies $code = @schemeID)">
               <axsl:attribute name="id">PEPPOL-T16-B09301</axsl:attribute>
               <axsl:attribute name="flag">fatal</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-select-full-path"/>
               </axsl:attribute>
               <svrl:text>Value MUST be part of code list 'ISO 6523 ICD list'.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>
      <axsl:apply-templates select="@*|*" mode="M10"/>
   </axsl:template>

	<!--RULE -->

   <axsl:template match="/ubl:DespatchAdvice/cac:OriginatorCustomerParty/cac:Party/cac:PartyName" priority="1123" mode="M10">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="/ubl:DespatchAdvice/cac:OriginatorCustomerParty/cac:Party/cac:PartyName"/>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="cbc:Name"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="cbc:Name">
               <axsl:attribute name="id">PEPPOL-T16-B09501</axsl:attribute>
               <axsl:attribute name="flag">fatal</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-select-full-path"/>
               </axsl:attribute>
               <svrl:text>Element 'cbc:Name' MUST be provided.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>
      <axsl:apply-templates select="@*|*" mode="M10"/>
   </axsl:template>

	<!--RULE -->

   <axsl:template match="/ubl:DespatchAdvice/cac:OriginatorCustomerParty/cac:Party/cac:PartyName/cbc:Name" priority="1122" mode="M10">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="/ubl:DespatchAdvice/cac:OriginatorCustomerParty/cac:Party/cac:PartyName/cbc:Name"/>
      <axsl:apply-templates select="@*|*" mode="M10"/>
   </axsl:template>

	<!--RULE -->

   <axsl:template match="/ubl:DespatchAdvice/cac:OriginatorCustomerParty/cac:Party/cac:PostalAddress" priority="1121" mode="M10">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="/ubl:DespatchAdvice/cac:OriginatorCustomerParty/cac:Party/cac:PostalAddress"/>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="cac:Country"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="cac:Country">
               <axsl:attribute name="id">PEPPOL-T16-B09701</axsl:attribute>
               <axsl:attribute name="flag">fatal</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-select-full-path"/>
               </axsl:attribute>
               <svrl:text>Element 'cac:Country' MUST be provided.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>
      <axsl:apply-templates select="@*|*" mode="M10"/>
   </axsl:template>

	<!--RULE -->

   <axsl:template match="/ubl:DespatchAdvice/cac:OriginatorCustomerParty/cac:Party/cac:PostalAddress/cbc:StreetName" priority="1120" mode="M10">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="/ubl:DespatchAdvice/cac:OriginatorCustomerParty/cac:Party/cac:PostalAddress/cbc:StreetName"/>
      <axsl:apply-templates select="@*|*" mode="M10"/>
   </axsl:template>

	<!--RULE -->

   <axsl:template match="/ubl:DespatchAdvice/cac:OriginatorCustomerParty/cac:Party/cac:PostalAddress/cbc:AdditionalStreetName" priority="1119" mode="M10">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="/ubl:DespatchAdvice/cac:OriginatorCustomerParty/cac:Party/cac:PostalAddress/cbc:AdditionalStreetName"/>
      <axsl:apply-templates select="@*|*" mode="M10"/>
   </axsl:template>

	<!--RULE -->

   <axsl:template match="/ubl:DespatchAdvice/cac:OriginatorCustomerParty/cac:Party/cac:PostalAddress/cbc:CityName" priority="1118" mode="M10">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="/ubl:DespatchAdvice/cac:OriginatorCustomerParty/cac:Party/cac:PostalAddress/cbc:CityName"/>
      <axsl:apply-templates select="@*|*" mode="M10"/>
   </axsl:template>

	<!--RULE -->

   <axsl:template match="/ubl:DespatchAdvice/cac:OriginatorCustomerParty/cac:Party/cac:PostalAddress/cbc:PostalZone" priority="1117" mode="M10">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="/ubl:DespatchAdvice/cac:OriginatorCustomerParty/cac:Party/cac:PostalAddress/cbc:PostalZone"/>
      <axsl:apply-templates select="@*|*" mode="M10"/>
   </axsl:template>

	<!--RULE -->

   <axsl:template match="/ubl:DespatchAdvice/cac:OriginatorCustomerParty/cac:Party/cac:PostalAddress/cbc:CountrySubentity" priority="1116" mode="M10">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="/ubl:DespatchAdvice/cac:OriginatorCustomerParty/cac:Party/cac:PostalAddress/cbc:CountrySubentity"/>
      <axsl:apply-templates select="@*|*" mode="M10"/>
   </axsl:template>

	<!--RULE -->

   <axsl:template match="/ubl:DespatchAdvice/cac:OriginatorCustomerParty/cac:Party/cac:PostalAddress/cac:AddressLine" priority="1115" mode="M10">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="/ubl:DespatchAdvice/cac:OriginatorCustomerParty/cac:Party/cac:PostalAddress/cac:AddressLine"/>
      <axsl:apply-templates select="@*|*" mode="M10"/>
   </axsl:template>

	<!--RULE -->

   <axsl:template match="/ubl:DespatchAdvice/cac:OriginatorCustomerParty/cac:Party/cac:PostalAddress/cac:AddressLine/cbc:Line" priority="1114" mode="M10">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="/ubl:DespatchAdvice/cac:OriginatorCustomerParty/cac:Party/cac:PostalAddress/cac:AddressLine/cbc:Line"/>
      <axsl:apply-templates select="@*|*" mode="M10"/>
   </axsl:template>

	<!--RULE -->

   <axsl:template match="/ubl:DespatchAdvice/cac:OriginatorCustomerParty/cac:Party/cac:PostalAddress/cac:Country" priority="1113" mode="M10">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="/ubl:DespatchAdvice/cac:OriginatorCustomerParty/cac:Party/cac:PostalAddress/cac:Country"/>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="cbc:IdentificationCode"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="cbc:IdentificationCode">
               <axsl:attribute name="id">PEPPOL-T16-B10501</axsl:attribute>
               <axsl:attribute name="flag">fatal</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-select-full-path"/>
               </axsl:attribute>
               <svrl:text>Element 'cbc:IdentificationCode' MUST be provided.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>
      <axsl:apply-templates select="@*|*" mode="M10"/>
   </axsl:template>

	<!--RULE -->

   <axsl:template match="/ubl:DespatchAdvice/cac:OriginatorCustomerParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode" priority="1112" mode="M10">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="/ubl:DespatchAdvice/cac:OriginatorCustomerParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode"/>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="(some $code in $clISO3166 satisfies $code = normalize-space(text()))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="(some $code in $clISO3166 satisfies $code = normalize-space(text()))">
               <axsl:attribute name="id">PEPPOL-T16-B10601</axsl:attribute>
               <axsl:attribute name="flag">fatal</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-select-full-path"/>
               </axsl:attribute>
               <svrl:text>Value MUST be part of code list 'Country codes (ISO 3166-1:Alpha2)'.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>
      <axsl:apply-templates select="@*|*" mode="M10"/>
   </axsl:template>

	<!--RULE -->

   <axsl:template match="/ubl:DespatchAdvice/cac:OriginatorCustomerParty/cac:Party/cac:PostalAddress/cac:Country/*" priority="1111" mode="M10">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="/ubl:DespatchAdvice/cac:OriginatorCustomerParty/cac:Party/cac:PostalAddress/cac:Country/*"/>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="false()"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="false()">
               <axsl:attribute name="id">PEPPOL-T16-B10502</axsl:attribute>
               <axsl:attribute name="flag">fatal</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-select-full-path"/>
               </axsl:attribute>
               <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>
      <axsl:apply-templates select="@*|*" mode="M10"/>
   </axsl:template>

	<!--RULE -->

   <axsl:template match="/ubl:DespatchAdvice/cac:OriginatorCustomerParty/cac:Party/cac:PostalAddress/*" priority="1110" mode="M10">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="/ubl:DespatchAdvice/cac:OriginatorCustomerParty/cac:Party/cac:PostalAddress/*"/>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="false()"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="false()">
               <axsl:attribute name="id">PEPPOL-T16-B09702</axsl:attribute>
               <axsl:attribute name="flag">fatal</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-select-full-path"/>
               </axsl:attribute>
               <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>
      <axsl:apply-templates select="@*|*" mode="M10"/>
   </axsl:template>

	<!--RULE -->

   <axsl:template match="/ubl:DespatchAdvice/cac:OriginatorCustomerParty/cac:Party/*" priority="1109" mode="M10">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="/ubl:DespatchAdvice/cac:OriginatorCustomerParty/cac:Party/*"/>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="false()"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="false()">
               <axsl:attribute name="id">PEPPOL-T16-B09101</axsl:attribute>
               <axsl:attribute name="flag">fatal</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-select-full-path"/>
               </axsl:attribute>
               <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>
      <axsl:apply-templates select="@*|*" mode="M10"/>
   </axsl:template>

	<!--RULE -->

   <axsl:template match="/ubl:DespatchAdvice/cac:OriginatorCustomerParty/*" priority="1108" mode="M10">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="/ubl:DespatchAdvice/cac:OriginatorCustomerParty/*"/>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="false()"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="false()">
               <axsl:attribute name="id">PEPPOL-T16-B09002</axsl:attribute>
               <axsl:attribute name="flag">fatal</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-select-full-path"/>
               </axsl:attribute>
               <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>
      <axsl:apply-templates select="@*|*" mode="M10"/>
   </axsl:template>

	<!--RULE -->

   <axsl:template match="/ubl:DespatchAdvice/cac:Shipment" priority="1107" mode="M10">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="/ubl:DespatchAdvice/cac:Shipment"/>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="cbc:ID"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="cbc:ID">
               <axsl:attribute name="id">PEPPOL-T16-B10701</axsl:attribute>
               <axsl:attribute name="flag">fatal</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-select-full-path"/>
               </axsl:attribute>
               <svrl:text>Element 'cbc:ID' MUST be provided.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>
      <axsl:apply-templates select="@*|*" mode="M10"/>
   </axsl:template>

	<!--RULE -->

   <axsl:template match="/ubl:DespatchAdvice/cac:Shipment/cbc:ID" priority="1106" mode="M10">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="/ubl:DespatchAdvice/cac:Shipment/cbc:ID"/>
      <axsl:apply-templates select="@*|*" mode="M10"/>
   </axsl:template>

	<!--RULE -->

   <axsl:template match="/ubl:DespatchAdvice/cac:Shipment/cbc:Information" priority="1105" mode="M10">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="/ubl:DespatchAdvice/cac:Shipment/cbc:Information"/>
      <axsl:apply-templates select="@*|*" mode="M10"/>
   </axsl:template>

	<!--RULE -->

   <axsl:template match="/ubl:DespatchAdvice/cac:Shipment/cbc:GrossWeightMeasure" priority="1104" mode="M10">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="/ubl:DespatchAdvice/cac:Shipment/cbc:GrossWeightMeasure"/>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="@unitCode"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="@unitCode">
               <axsl:attribute name="id">PEPPOL-T16-B11001</axsl:attribute>
               <axsl:attribute name="flag">fatal</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-select-full-path"/>
               </axsl:attribute>
               <svrl:text>Attribute 'unitCode' MUST be present.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(@unitCode) or (some $code in $clUNECERec20 satisfies $code = @unitCode)"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(@unitCode) or (some $code in $clUNECERec20 satisfies $code = @unitCode)">
               <axsl:attribute name="id">PEPPOL-T16-B11002</axsl:attribute>
               <axsl:attribute name="flag">fatal</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-select-full-path"/>
               </axsl:attribute>
               <svrl:text>Value MUST be part of code list 'Recommandation 20, including Recommondation 21 codes - prefixed with X (UN/ECE)'.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>
      <axsl:apply-templates select="@*|*" mode="M10"/>
   </axsl:template>

	<!--RULE -->

   <axsl:template match="/ubl:DespatchAdvice/cac:Shipment/cbc:GrossVolumeMeasure" priority="1103" mode="M10">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="/ubl:DespatchAdvice/cac:Shipment/cbc:GrossVolumeMeasure"/>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="@unitCode"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="@unitCode">
               <axsl:attribute name="id">PEPPOL-T16-B11201</axsl:attribute>
               <axsl:attribute name="flag">fatal</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-select-full-path"/>
               </axsl:attribute>
               <svrl:text>Attribute 'unitCode' MUST be present.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(@unitCode) or (some $code in $clUNECERec20 satisfies $code = @unitCode)"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(@unitCode) or (some $code in $clUNECERec20 satisfies $code = @unitCode)">
               <axsl:attribute name="id">PEPPOL-T16-B11202</axsl:attribute>
               <axsl:attribute name="flag">fatal</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-select-full-path"/>
               </axsl:attribute>
               <svrl:text>Value MUST be part of code list 'Recommandation 20, including Recommondation 21 codes - prefixed with X (UN/ECE)'.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>
      <axsl:apply-templates select="@*|*" mode="M10"/>
   </axsl:template>

	<!--RULE -->

   <axsl:template match="/ubl:DespatchAdvice/cac:Shipment/cbc:TotalTransportHandlingUnitQuantity" priority="1102" mode="M10">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="/ubl:DespatchAdvice/cac:Shipment/cbc:TotalTransportHandlingUnitQuantity"/>
      <axsl:apply-templates select="@*|*" mode="M10"/>
   </axsl:template>

	<!--RULE -->

   <axsl:template match="/ubl:DespatchAdvice/cac:Shipment/cac:Consignment" priority="1101" mode="M10">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="/ubl:DespatchAdvice/cac:Shipment/cac:Consignment"/>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="cbc:ID"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="cbc:ID">
               <axsl:attribute name="id">PEPPOL-T16-B11501</axsl:attribute>
               <axsl:attribute name="flag">fatal</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-select-full-path"/>
               </axsl:attribute>
               <svrl:text>Element 'cbc:ID' MUST be provided.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>
      <axsl:apply-templates select="@*|*" mode="M10"/>
   </axsl:template>

	<!--RULE -->

   <axsl:template match="/ubl:DespatchAdvice/cac:Shipment/cac:Consignment/cbc:ID" priority="1100" mode="M10">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="/ubl:DespatchAdvice/cac:Shipment/cac:Consignment/cbc:ID"/>
      <axsl:apply-templates select="@*|*" mode="M10"/>
   </axsl:template>

	<!--RULE -->

   <axsl:template match="/ubl:DespatchAdvice/cac:Shipment/cac:Consignment/cbc:Information" priority="1099" mode="M10">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="/ubl:DespatchAdvice/cac:Shipment/cac:Consignment/cbc:Information"/>
      <axsl:apply-templates select="@*|*" mode="M10"/>
   </axsl:template>

	<!--RULE -->

   <axsl:template match="/ubl:DespatchAdvice/cac:Shipment/cac:Consignment/cac:CarrierParty" priority="1098" mode="M10">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="/ubl:DespatchAdvice/cac:Shipment/cac:Consignment/cac:CarrierParty"/>
      <axsl:apply-templates select="@*|*" mode="M10"/>
   </axsl:template>

	<!--RULE -->

   <axsl:template match="/ubl:DespatchAdvice/cac:Shipment/cac:Consignment/cac:CarrierParty/cac:PartyName" priority="1097" mode="M10">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="/ubl:DespatchAdvice/cac:Shipment/cac:Consignment/cac:CarrierParty/cac:PartyName"/>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="cbc:Name"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="cbc:Name">
               <axsl:attribute name="id">PEPPOL-T16-B11901</axsl:attribute>
               <axsl:attribute name="flag">fatal</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-select-full-path"/>
               </axsl:attribute>
               <svrl:text>Element 'cbc:Name' MUST be provided.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>
      <axsl:apply-templates select="@*|*" mode="M10"/>
   </axsl:template>

	<!--RULE -->

   <axsl:template match="/ubl:DespatchAdvice/cac:Shipment/cac:Consignment/cac:CarrierParty/cac:PartyName/cbc:Name" priority="1096" mode="M10">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="/ubl:DespatchAdvice/cac:Shipment/cac:Consignment/cac:CarrierParty/cac:PartyName/cbc:Name"/>
      <axsl:apply-templates select="@*|*" mode="M10"/>
   </axsl:template>

	<!--RULE -->

   <axsl:template match="/ubl:DespatchAdvice/cac:Shipment/cac:Consignment/cac:CarrierParty/cac:Person" priority="1095" mode="M10">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="/ubl:DespatchAdvice/cac:Shipment/cac:Consignment/cac:CarrierParty/cac:Person"/>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="cac:IdentityDocumentReference"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="cac:IdentityDocumentReference">
               <axsl:attribute name="id">PEPPOL-T16-B12101</axsl:attribute>
               <axsl:attribute name="flag">fatal</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-select-full-path"/>
               </axsl:attribute>
               <svrl:text>Element 'cac:IdentityDocumentReference' MUST be provided.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>
      <axsl:apply-templates select="@*|*" mode="M10"/>
   </axsl:template>

	<!--RULE -->

   <axsl:template match="/ubl:DespatchAdvice/cac:Shipment/cac:Consignment/cac:CarrierParty/cac:Person/cac:IdentityDocumentReference" priority="1094" mode="M10">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="/ubl:DespatchAdvice/cac:Shipment/cac:Consignment/cac:CarrierParty/cac:Person/cac:IdentityDocumentReference"/>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="cbc:ID"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="cbc:ID">
               <axsl:attribute name="id">PEPPOL-T16-B12201</axsl:attribute>
               <axsl:attribute name="flag">fatal</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-select-full-path"/>
               </axsl:attribute>
               <svrl:text>Element 'cbc:ID' MUST be provided.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>
      <axsl:apply-templates select="@*|*" mode="M10"/>
   </axsl:template>

	<!--RULE -->

   <axsl:template match="/ubl:DespatchAdvice/cac:Shipment/cac:Consignment/cac:CarrierParty/cac:Person/cac:IdentityDocumentReference/cbc:ID" priority="1093" mode="M10">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="/ubl:DespatchAdvice/cac:Shipment/cac:Consignment/cac:CarrierParty/cac:Person/cac:IdentityDocumentReference/cbc:ID"/>
      <axsl:apply-templates select="@*|*" mode="M10"/>
   </axsl:template>

	<!--RULE -->

   <axsl:template match="/ubl:DespatchAdvice/cac:Shipment/cac:Consignment/cac:CarrierParty/cac:Person/cac:IdentityDocumentReference/cbc:DocumentType" priority="1092" mode="M10">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="/ubl:DespatchAdvice/cac:Shipment/cac:Consignment/cac:CarrierParty/cac:Person/cac:IdentityDocumentReference/cbc:DocumentType"/>
      <axsl:apply-templates select="@*|*" mode="M10"/>
   </axsl:template>

	<!--RULE -->

   <axsl:template match="/ubl:DespatchAdvice/cac:Shipment/cac:Consignment/cac:CarrierParty/cac:Person/cac:IdentityDocumentReference/*" priority="1091" mode="M10">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="/ubl:DespatchAdvice/cac:Shipment/cac:Consignment/cac:CarrierParty/cac:Person/cac:IdentityDocumentReference/*"/>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="false()"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="false()">
               <axsl:attribute name="id">PEPPOL-T16-B12202</axsl:attribute>
               <axsl:attribute name="flag">fatal</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-select-full-path"/>
               </axsl:attribute>
               <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>
      <axsl:apply-templates select="@*|*" mode="M10"/>
   </axsl:template>

	<!--RULE -->

   <axsl:template match="/ubl:DespatchAdvice/cac:Shipment/cac:Consignment/cac:CarrierParty/cac:Person/*" priority="1090" mode="M10">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="/ubl:DespatchAdvice/cac:Shipment/cac:Consignment/cac:CarrierParty/cac:Person/*"/>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="false()"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="false()">
               <axsl:attribute name="id">PEPPOL-T16-B12102</axsl:attribute>
               <axsl:attribute name="flag">fatal</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-select-full-path"/>
               </axsl:attribute>
               <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>
      <axsl:apply-templates select="@*|*" mode="M10"/>
   </axsl:template>

	<!--RULE -->

   <axsl:template match="/ubl:DespatchAdvice/cac:Shipment/cac:Consignment/cac:CarrierParty/*" priority="1089" mode="M10">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="/ubl:DespatchAdvice/cac:Shipment/cac:Consignment/cac:CarrierParty/*"/>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="false()"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="false()">
               <axsl:attribute name="id">PEPPOL-T16-B11801</axsl:attribute>
               <axsl:attribute name="flag">fatal</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-select-full-path"/>
               </axsl:attribute>
               <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>
      <axsl:apply-templates select="@*|*" mode="M10"/>
   </axsl:template>

	<!--RULE -->

   <axsl:template match="/ubl:DespatchAdvice/cac:Shipment/cac:Consignment/*" priority="1088" mode="M10">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="/ubl:DespatchAdvice/cac:Shipment/cac:Consignment/*"/>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="false()"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="false()">
               <axsl:attribute name="id">PEPPOL-T16-B11502</axsl:attribute>
               <axsl:attribute name="flag">fatal</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-select-full-path"/>
               </axsl:attribute>
               <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>
      <axsl:apply-templates select="@*|*" mode="M10"/>
   </axsl:template>

	<!--RULE -->

   <axsl:template match="/ubl:DespatchAdvice/cac:Shipment/cac:Delivery" priority="1087" mode="M10">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="/ubl:DespatchAdvice/cac:Shipment/cac:Delivery"/>
      <axsl:apply-templates select="@*|*" mode="M10"/>
   </axsl:template>

	<!--RULE -->

   <axsl:template match="/ubl:DespatchAdvice/cac:Shipment/cac:Delivery/cbc:TrackingID" priority="1086" mode="M10">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="/ubl:DespatchAdvice/cac:Shipment/cac:Delivery/cbc:TrackingID"/>
      <axsl:apply-templates select="@*|*" mode="M10"/>
   </axsl:template>

	<!--RULE -->

   <axsl:template match="/ubl:DespatchAdvice/cac:Shipment/cac:Delivery/cac:EstimatedDeliveryPeriod" priority="1085" mode="M10">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="/ubl:DespatchAdvice/cac:Shipment/cac:Delivery/cac:EstimatedDeliveryPeriod"/>
      <axsl:apply-templates select="@*|*" mode="M10"/>
   </axsl:template>

	<!--RULE -->

   <axsl:template match="/ubl:DespatchAdvice/cac:Shipment/cac:Delivery/cac:EstimatedDeliveryPeriod/cbc:StartDate" priority="1084" mode="M10">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="/ubl:DespatchAdvice/cac:Shipment/cac:Delivery/cac:EstimatedDeliveryPeriod/cbc:StartDate"/>
      <axsl:apply-templates select="@*|*" mode="M10"/>
   </axsl:template>

	<!--RULE -->

   <axsl:template match="/ubl:DespatchAdvice/cac:Shipment/cac:Delivery/cac:EstimatedDeliveryPeriod/cbc:StartTime" priority="1083" mode="M10">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="/ubl:DespatchAdvice/cac:Shipment/cac:Delivery/cac:EstimatedDeliveryPeriod/cbc:StartTime"/>
      <axsl:apply-templates select="@*|*" mode="M10"/>
   </axsl:template>

	<!--RULE -->

   <axsl:template match="/ubl:DespatchAdvice/cac:Shipment/cac:Delivery/cac:EstimatedDeliveryPeriod/cbc:EndDate" priority="1082" mode="M10">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="/ubl:DespatchAdvice/cac:Shipment/cac:Delivery/cac:EstimatedDeliveryPeriod/cbc:EndDate"/>
      <axsl:apply-templates select="@*|*" mode="M10"/>
   </axsl:template>

	<!--RULE -->

   <axsl:template match="/ubl:DespatchAdvice/cac:Shipment/cac:Delivery/cac:EstimatedDeliveryPeriod/cbc:EndTime" priority="1081" mode="M10">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="/ubl:DespatchAdvice/cac:Shipment/cac:Delivery/cac:EstimatedDeliveryPeriod/cbc:EndTime"/>
      <axsl:apply-templates select="@*|*" mode="M10"/>
   </axsl:template>

	<!--RULE -->

   <axsl:template match="/ubl:DespatchAdvice/cac:Shipment/cac:Delivery/cac:EstimatedDeliveryPeriod/*" priority="1080" mode="M10">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="/ubl:DespatchAdvice/cac:Shipment/cac:Delivery/cac:EstimatedDeliveryPeriod/*"/>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="false()"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="false()">
               <axsl:attribute name="id">PEPPOL-T16-B12701</axsl:attribute>
               <axsl:attribute name="flag">fatal</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-select-full-path"/>
               </axsl:attribute>
               <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>
      <axsl:apply-templates select="@*|*" mode="M10"/>
   </axsl:template>

	<!--RULE -->

   <axsl:template match="/ubl:DespatchAdvice/cac:Shipment/cac:Delivery/cac:Despatch" priority="1079" mode="M10">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="/ubl:DespatchAdvice/cac:Shipment/cac:Delivery/cac:Despatch"/>
      <axsl:apply-templates select="@*|*" mode="M10"/>
   </axsl:template>

	<!--RULE -->

   <axsl:template match="/ubl:DespatchAdvice/cac:Shipment/cac:Delivery/cac:Despatch/cbc:ActualDespatchDate" priority="1078" mode="M10">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="/ubl:DespatchAdvice/cac:Shipment/cac:Delivery/cac:Despatch/cbc:ActualDespatchDate"/>
      <axsl:apply-templates select="@*|*" mode="M10"/>
   </axsl:template>

	<!--RULE -->

   <axsl:template match="/ubl:DespatchAdvice/cac:Shipment/cac:Delivery/cac:Despatch/cbc:ActualDespatchTime" priority="1077" mode="M10">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="/ubl:DespatchAdvice/cac:Shipment/cac:Delivery/cac:Despatch/cbc:ActualDespatchTime"/>
      <axsl:apply-templates select="@*|*" mode="M10"/>
   </axsl:template>

	<!--RULE -->

   <axsl:template match="/ubl:DespatchAdvice/cac:Shipment/cac:Delivery/cac:Despatch/cac:DespatchAddress" priority="1076" mode="M10">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="/ubl:DespatchAdvice/cac:Shipment/cac:Delivery/cac:Despatch/cac:DespatchAddress"/>
      <axsl:apply-templates select="@*|*" mode="M10"/>
   </axsl:template>

	<!--RULE -->

   <axsl:template match="/ubl:DespatchAdvice/cac:Shipment/cac:Delivery/cac:Despatch/cac:DespatchAddress/cbc:ID" priority="1075" mode="M10">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="/ubl:DespatchAdvice/cac:Shipment/cac:Delivery/cac:Despatch/cac:DespatchAddress/cbc:ID"/>
      <axsl:apply-templates select="@*|*" mode="M10"/>
   </axsl:template>

	<!--RULE -->

   <axsl:template match="/ubl:DespatchAdvice/cac:Shipment/cac:Delivery/cac:Despatch/cac:DespatchAddress/cbc:StreetName" priority="1074" mode="M10">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="/ubl:DespatchAdvice/cac:Shipment/cac:Delivery/cac:Despatch/cac:DespatchAddress/cbc:StreetName"/>
      <axsl:apply-templates select="@*|*" mode="M10"/>
   </axsl:template>

	<!--RULE -->

   <axsl:template match="/ubl:DespatchAdvice/cac:Shipment/cac:Delivery/cac:Despatch/cac:DespatchAddress/cbc:AdditionalStreetName" priority="1073" mode="M10">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="/ubl:DespatchAdvice/cac:Shipment/cac:Delivery/cac:Despatch/cac:DespatchAddress/cbc:AdditionalStreetName"/>
      <axsl:apply-templates select="@*|*" mode="M10"/>
   </axsl:template>

	<!--RULE -->

   <axsl:template match="/ubl:DespatchAdvice/cac:Shipment/cac:Delivery/cac:Despatch/cac:DespatchAddress/cbc:CityName" priority="1072" mode="M10">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="/ubl:DespatchAdvice/cac:Shipment/cac:Delivery/cac:Despatch/cac:DespatchAddress/cbc:CityName"/>
      <axsl:apply-templates select="@*|*" mode="M10"/>
   </axsl:template>

	<!--RULE -->

   <axsl:template match="/ubl:DespatchAdvice/cac:Shipment/cac:Delivery/cac:Despatch/cac:DespatchAddress/cbc:PostalZone" priority="1071" mode="M10">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="/ubl:DespatchAdvice/cac:Shipment/cac:Delivery/cac:Despatch/cac:DespatchAddress/cbc:PostalZone"/>
      <axsl:apply-templates select="@*|*" mode="M10"/>
   </axsl:template>

	<!--RULE -->

   <axsl:template match="/ubl:DespatchAdvice/cac:Shipment/cac:Delivery/cac:Despatch/cac:DespatchAddress/cbc:CountrySubentity" priority="1070" mode="M10">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="/ubl:DespatchAdvice/cac:Shipment/cac:Delivery/cac:Despatch/cac:DespatchAddress/cbc:CountrySubentity"/>
      <axsl:apply-templates select="@*|*" mode="M10"/>
   </axsl:template>

	<!--RULE -->

   <axsl:template match="/ubl:DespatchAdvice/cac:Shipment/cac:Delivery/cac:Despatch/cac:DespatchAddress/cac:AddressLine" priority="1069" mode="M10">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="/ubl:DespatchAdvice/cac:Shipment/cac:Delivery/cac:Despatch/cac:DespatchAddress/cac:AddressLine"/>
      <axsl:apply-templates select="@*|*" mode="M10"/>
   </axsl:template>

	<!--RULE -->

   <axsl:template match="/ubl:DespatchAdvice/cac:Shipment/cac:Delivery/cac:Despatch/cac:DespatchAddress/cac:AddressLine/cbc:Line" priority="1068" mode="M10">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="/ubl:DespatchAdvice/cac:Shipment/cac:Delivery/cac:Despatch/cac:DespatchAddress/cac:AddressLine/cbc:Line"/>
      <axsl:apply-templates select="@*|*" mode="M10"/>
   </axsl:template>

	<!--RULE -->

   <axsl:template match="/ubl:DespatchAdvice/cac:Shipment/cac:Delivery/cac:Despatch/cac:DespatchAddress/cac:Country" priority="1067" mode="M10">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="/ubl:DespatchAdvice/cac:Shipment/cac:Delivery/cac:Despatch/cac:DespatchAddress/cac:Country"/>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="cbc:IdentificationCode"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="cbc:IdentificationCode">
               <axsl:attribute name="id">PEPPOL-T16-B14401</axsl:attribute>
               <axsl:attribute name="flag">fatal</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-select-full-path"/>
               </axsl:attribute>
               <svrl:text>Element 'cbc:IdentificationCode' MUST be provided.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>
      <axsl:apply-templates select="@*|*" mode="M10"/>
   </axsl:template>

	<!--RULE -->

   <axsl:template match="/ubl:DespatchAdvice/cac:Shipment/cac:Delivery/cac:Despatch/cac:DespatchAddress/cac:Country/cbc:IdentificationCode" priority="1066" mode="M10">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="/ubl:DespatchAdvice/cac:Shipment/cac:Delivery/cac:Despatch/cac:DespatchAddress/cac:Country/cbc:IdentificationCode"/>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="(some $code in $clISO3166 satisfies $code = normalize-space(text()))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="(some $code in $clISO3166 satisfies $code = normalize-space(text()))">
               <axsl:attribute name="id">PEPPOL-T16-B14501</axsl:attribute>
               <axsl:attribute name="flag">fatal</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-select-full-path"/>
               </axsl:attribute>
               <svrl:text>Value MUST be part of code list 'Country codes (ISO 3166-1:Alpha2)'.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>
      <axsl:apply-templates select="@*|*" mode="M10"/>
   </axsl:template>

	<!--RULE -->

   <axsl:template match="/ubl:DespatchAdvice/cac:Shipment/cac:Delivery/cac:Despatch/cac:DespatchAddress/cac:Country/*" priority="1065" mode="M10">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="/ubl:DespatchAdvice/cac:Shipment/cac:Delivery/cac:Despatch/cac:DespatchAddress/cac:Country/*"/>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="false()"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="false()">
               <axsl:attribute name="id">PEPPOL-T16-B14402</axsl:attribute>
               <axsl:attribute name="flag">fatal</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-select-full-path"/>
               </axsl:attribute>
               <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>
      <axsl:apply-templates select="@*|*" mode="M10"/>
   </axsl:template>

	<!--RULE -->

   <axsl:template match="/ubl:DespatchAdvice/cac:Shipment/cac:Delivery/cac:Despatch/cac:DespatchAddress/*" priority="1064" mode="M10">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="/ubl:DespatchAdvice/cac:Shipment/cac:Delivery/cac:Despatch/cac:DespatchAddress/*"/>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="false()"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="false()">
               <axsl:attribute name="id">PEPPOL-T16-B13501</axsl:attribute>
               <axsl:attribute name="flag">fatal</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-select-full-path"/>
               </axsl:attribute>
               <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>
      <axsl:apply-templates select="@*|*" mode="M10"/>
   </axsl:template>

	<!--RULE -->

   <axsl:template match="/ubl:DespatchAdvice/cac:Shipment/cac:Delivery/cac:Despatch/*" priority="1063" mode="M10">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="/ubl:DespatchAdvice/cac:Shipment/cac:Delivery/cac:Despatch/*"/>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="false()"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="false()">
               <axsl:attribute name="id">PEPPOL-T16-B13201</axsl:attribute>
               <axsl:attribute name="flag">fatal</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-select-full-path"/>
               </axsl:attribute>
               <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>
      <axsl:apply-templates select="@*|*" mode="M10"/>
   </axsl:template>

	<!--RULE -->

   <axsl:template match="/ubl:DespatchAdvice/cac:Shipment/cac:Delivery/*" priority="1062" mode="M10">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="/ubl:DespatchAdvice/cac:Shipment/cac:Delivery/*"/>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="false()"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="false()">
               <axsl:attribute name="id">PEPPOL-T16-B12501</axsl:attribute>
               <axsl:attribute name="flag">fatal</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-select-full-path"/>
               </axsl:attribute>
               <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>
      <axsl:apply-templates select="@*|*" mode="M10"/>
   </axsl:template>

	<!--RULE -->

   <axsl:template match="/ubl:DespatchAdvice/cac:Shipment/*" priority="1061" mode="M10">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="/ubl:DespatchAdvice/cac:Shipment/*"/>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="false()"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="false()">
               <axsl:attribute name="id">PEPPOL-T16-B10702</axsl:attribute>
               <axsl:attribute name="flag">fatal</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-select-full-path"/>
               </axsl:attribute>
               <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>
      <axsl:apply-templates select="@*|*" mode="M10"/>
   </axsl:template>

	<!--RULE -->

   <axsl:template match="/ubl:DespatchAdvice/cac:DespatchLine" priority="1060" mode="M10">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="/ubl:DespatchAdvice/cac:DespatchLine"/>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="cbc:ID"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="cbc:ID">
               <axsl:attribute name="id">PEPPOL-T16-B14601</axsl:attribute>
               <axsl:attribute name="flag">fatal</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-select-full-path"/>
               </axsl:attribute>
               <svrl:text>Element 'cbc:ID' MUST be provided.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="cac:OrderLineReference"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="cac:OrderLineReference">
               <axsl:attribute name="id">PEPPOL-T16-B14602</axsl:attribute>
               <axsl:attribute name="flag">fatal</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-select-full-path"/>
               </axsl:attribute>
               <svrl:text>Element 'cac:OrderLineReference' MUST be provided.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="cac:Item"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="cac:Item">
               <axsl:attribute name="id">PEPPOL-T16-B14603</axsl:attribute>
               <axsl:attribute name="flag">fatal</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-select-full-path"/>
               </axsl:attribute>
               <svrl:text>Element 'cac:Item' MUST be provided.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>
      <axsl:apply-templates select="@*|*" mode="M10"/>
   </axsl:template>

	<!--RULE -->

   <axsl:template match="/ubl:DespatchAdvice/cac:DespatchLine/cbc:ID" priority="1059" mode="M10">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="/ubl:DespatchAdvice/cac:DespatchLine/cbc:ID"/>
      <axsl:apply-templates select="@*|*" mode="M10"/>
   </axsl:template>

	<!--RULE -->

   <axsl:template match="/ubl:DespatchAdvice/cac:DespatchLine/cbc:Note" priority="1058" mode="M10">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="/ubl:DespatchAdvice/cac:DespatchLine/cbc:Note"/>
      <axsl:apply-templates select="@*|*" mode="M10"/>
   </axsl:template>

	<!--RULE -->

   <axsl:template match="/ubl:DespatchAdvice/cac:DespatchLine/cbc:DeliveredQuantity" priority="1057" mode="M10">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="/ubl:DespatchAdvice/cac:DespatchLine/cbc:DeliveredQuantity"/>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="@unitCode"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="@unitCode">
               <axsl:attribute name="id">PEPPOL-T16-B14901</axsl:attribute>
               <axsl:attribute name="flag">fatal</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-select-full-path"/>
               </axsl:attribute>
               <svrl:text>Attribute 'unitCode' MUST be present.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(@unitCode) or (some $code in $clUNECERec20 satisfies $code = @unitCode)"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(@unitCode) or (some $code in $clUNECERec20 satisfies $code = @unitCode)">
               <axsl:attribute name="id">PEPPOL-T16-B14902</axsl:attribute>
               <axsl:attribute name="flag">fatal</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-select-full-path"/>
               </axsl:attribute>
               <svrl:text>Value MUST be part of code list 'Recommandation 20, including Recommondation 21 codes - prefixed with X (UN/ECE)'.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>
      <axsl:apply-templates select="@*|*" mode="M10"/>
   </axsl:template>

	<!--RULE -->

   <axsl:template match="/ubl:DespatchAdvice/cac:DespatchLine/cbc:OutstandingQuantity" priority="1056" mode="M10">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="/ubl:DespatchAdvice/cac:DespatchLine/cbc:OutstandingQuantity"/>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="@unitCode"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="@unitCode">
               <axsl:attribute name="id">PEPPOL-T16-B15101</axsl:attribute>
               <axsl:attribute name="flag">fatal</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-select-full-path"/>
               </axsl:attribute>
               <svrl:text>Attribute 'unitCode' MUST be present.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(@unitCode) or (some $code in $clUNECERec20 satisfies $code = @unitCode)"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(@unitCode) or (some $code in $clUNECERec20 satisfies $code = @unitCode)">
               <axsl:attribute name="id">PEPPOL-T16-B15102</axsl:attribute>
               <axsl:attribute name="flag">fatal</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-select-full-path"/>
               </axsl:attribute>
               <svrl:text>Value MUST be part of code list 'Recommandation 20, including Recommondation 21 codes - prefixed with X (UN/ECE)'.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>
      <axsl:apply-templates select="@*|*" mode="M10"/>
   </axsl:template>

	<!--RULE -->

   <axsl:template match="/ubl:DespatchAdvice/cac:DespatchLine/cbc:OutstandingReason" priority="1055" mode="M10">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="/ubl:DespatchAdvice/cac:DespatchLine/cbc:OutstandingReason"/>
      <axsl:apply-templates select="@*|*" mode="M10"/>
   </axsl:template>

	<!--RULE -->

   <axsl:template match="/ubl:DespatchAdvice/cac:DespatchLine/cac:OrderLineReference" priority="1054" mode="M10">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="/ubl:DespatchAdvice/cac:DespatchLine/cac:OrderLineReference"/>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="cbc:LineID"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="cbc:LineID">
               <axsl:attribute name="id">PEPPOL-T16-B15401</axsl:attribute>
               <axsl:attribute name="flag">fatal</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-select-full-path"/>
               </axsl:attribute>
               <svrl:text>Element 'cbc:LineID' MUST be provided.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="cac:OrderReference"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="cac:OrderReference">
               <axsl:attribute name="id">PEPPOL-T16-B15402</axsl:attribute>
               <axsl:attribute name="flag">fatal</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-select-full-path"/>
               </axsl:attribute>
               <svrl:text>Element 'cac:OrderReference' MUST be provided.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>
      <axsl:apply-templates select="@*|*" mode="M10"/>
   </axsl:template>

	<!--RULE -->

   <axsl:template match="/ubl:DespatchAdvice/cac:DespatchLine/cac:OrderLineReference/cbc:LineID" priority="1053" mode="M10">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="/ubl:DespatchAdvice/cac:DespatchLine/cac:OrderLineReference/cbc:LineID"/>
      <axsl:apply-templates select="@*|*" mode="M10"/>
   </axsl:template>

	<!--RULE -->

   <axsl:template match="/ubl:DespatchAdvice/cac:DespatchLine/cac:OrderLineReference/cac:OrderReference" priority="1052" mode="M10">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="/ubl:DespatchAdvice/cac:DespatchLine/cac:OrderLineReference/cac:OrderReference"/>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="cbc:ID"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="cbc:ID">
               <axsl:attribute name="id">PEPPOL-T16-B15601</axsl:attribute>
               <axsl:attribute name="flag">fatal</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-select-full-path"/>
               </axsl:attribute>
               <svrl:text>Element 'cbc:ID' MUST be provided.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>
      <axsl:apply-templates select="@*|*" mode="M10"/>
   </axsl:template>

	<!--RULE -->

   <axsl:template match="/ubl:DespatchAdvice/cac:DespatchLine/cac:OrderLineReference/cac:OrderReference/cbc:ID" priority="1051" mode="M10">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="/ubl:DespatchAdvice/cac:DespatchLine/cac:OrderLineReference/cac:OrderReference/cbc:ID"/>
      <axsl:apply-templates select="@*|*" mode="M10"/>
   </axsl:template>

	<!--RULE -->

   <axsl:template match="/ubl:DespatchAdvice/cac:DespatchLine/cac:OrderLineReference/cac:OrderReference/*" priority="1050" mode="M10">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="/ubl:DespatchAdvice/cac:DespatchLine/cac:OrderLineReference/cac:OrderReference/*"/>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="false()"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="false()">
               <axsl:attribute name="id">PEPPOL-T16-B15602</axsl:attribute>
               <axsl:attribute name="flag">fatal</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-select-full-path"/>
               </axsl:attribute>
               <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>
      <axsl:apply-templates select="@*|*" mode="M10"/>
   </axsl:template>

	<!--RULE -->

   <axsl:template match="/ubl:DespatchAdvice/cac:DespatchLine/cac:OrderLineReference/*" priority="1049" mode="M10">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="/ubl:DespatchAdvice/cac:DespatchLine/cac:OrderLineReference/*"/>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="false()"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="false()">
               <axsl:attribute name="id">PEPPOL-T16-B15403</axsl:attribute>
               <axsl:attribute name="flag">fatal</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-select-full-path"/>
               </axsl:attribute>
               <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>
      <axsl:apply-templates select="@*|*" mode="M10"/>
   </axsl:template>

	<!--RULE -->

   <axsl:template match="/ubl:DespatchAdvice/cac:DespatchLine/cac:Item" priority="1048" mode="M10">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="/ubl:DespatchAdvice/cac:DespatchLine/cac:Item"/>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="cbc:Name"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="cbc:Name">
               <axsl:attribute name="id">PEPPOL-T16-B15801</axsl:attribute>
               <axsl:attribute name="flag">fatal</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-select-full-path"/>
               </axsl:attribute>
               <svrl:text>Element 'cbc:Name' MUST be provided.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>
      <axsl:apply-templates select="@*|*" mode="M10"/>
   </axsl:template>

	<!--RULE -->

   <axsl:template match="/ubl:DespatchAdvice/cac:DespatchLine/cac:Item/cbc:Name" priority="1047" mode="M10">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="/ubl:DespatchAdvice/cac:DespatchLine/cac:Item/cbc:Name"/>
      <axsl:apply-templates select="@*|*" mode="M10"/>
   </axsl:template>

	<!--RULE -->

   <axsl:template match="/ubl:DespatchAdvice/cac:DespatchLine/cac:Item/cac:BuyersItemIdentification" priority="1046" mode="M10">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="/ubl:DespatchAdvice/cac:DespatchLine/cac:Item/cac:BuyersItemIdentification"/>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="cbc:ID"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="cbc:ID">
               <axsl:attribute name="id">PEPPOL-T16-B16001</axsl:attribute>
               <axsl:attribute name="flag">fatal</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-select-full-path"/>
               </axsl:attribute>
               <svrl:text>Element 'cbc:ID' MUST be provided.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>
      <axsl:apply-templates select="@*|*" mode="M10"/>
   </axsl:template>

	<!--RULE -->

   <axsl:template match="/ubl:DespatchAdvice/cac:DespatchLine/cac:Item/cac:BuyersItemIdentification/cbc:ID" priority="1045" mode="M10">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="/ubl:DespatchAdvice/cac:DespatchLine/cac:Item/cac:BuyersItemIdentification/cbc:ID"/>
      <axsl:apply-templates select="@*|*" mode="M10"/>
   </axsl:template>

	<!--RULE -->

   <axsl:template match="/ubl:DespatchAdvice/cac:DespatchLine/cac:Item/cac:BuyersItemIdentification/*" priority="1044" mode="M10">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="/ubl:DespatchAdvice/cac:DespatchLine/cac:Item/cac:BuyersItemIdentification/*"/>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="false()"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="false()">
               <axsl:attribute name="id">PEPPOL-T16-B16002</axsl:attribute>
               <axsl:attribute name="flag">fatal</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-select-full-path"/>
               </axsl:attribute>
               <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>
      <axsl:apply-templates select="@*|*" mode="M10"/>
   </axsl:template>

	<!--RULE -->

   <axsl:template match="/ubl:DespatchAdvice/cac:DespatchLine/cac:Item/cac:SellersItemIdentification" priority="1043" mode="M10">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="/ubl:DespatchAdvice/cac:DespatchLine/cac:Item/cac:SellersItemIdentification"/>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="cbc:ID"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="cbc:ID">
               <axsl:attribute name="id">PEPPOL-T16-B16201</axsl:attribute>
               <axsl:attribute name="flag">fatal</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-select-full-path"/>
               </axsl:attribute>
               <svrl:text>Element 'cbc:ID' MUST be provided.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>
      <axsl:apply-templates select="@*|*" mode="M10"/>
   </axsl:template>

	<!--RULE -->

   <axsl:template match="/ubl:DespatchAdvice/cac:DespatchLine/cac:Item/cac:SellersItemIdentification/cbc:ID" priority="1042" mode="M10">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="/ubl:DespatchAdvice/cac:DespatchLine/cac:Item/cac:SellersItemIdentification/cbc:ID"/>
      <axsl:apply-templates select="@*|*" mode="M10"/>
   </axsl:template>

	<!--RULE -->

   <axsl:template match="/ubl:DespatchAdvice/cac:DespatchLine/cac:Item/cac:SellersItemIdentification/cbc:ExtendedID" priority="1041" mode="M10">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="/ubl:DespatchAdvice/cac:DespatchLine/cac:Item/cac:SellersItemIdentification/cbc:ExtendedID"/>
      <axsl:apply-templates select="@*|*" mode="M10"/>
   </axsl:template>

	<!--RULE -->

   <axsl:template match="/ubl:DespatchAdvice/cac:DespatchLine/cac:Item/cac:SellersItemIdentification/*" priority="1040" mode="M10">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="/ubl:DespatchAdvice/cac:DespatchLine/cac:Item/cac:SellersItemIdentification/*"/>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="false()"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="false()">
               <axsl:attribute name="id">PEPPOL-T16-B16202</axsl:attribute>
               <axsl:attribute name="flag">fatal</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-select-full-path"/>
               </axsl:attribute>
               <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>
      <axsl:apply-templates select="@*|*" mode="M10"/>
   </axsl:template>

	<!--RULE -->

   <axsl:template match="/ubl:DespatchAdvice/cac:DespatchLine/cac:Item/cac:StandardItemIdentification" priority="1039" mode="M10">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="/ubl:DespatchAdvice/cac:DespatchLine/cac:Item/cac:StandardItemIdentification"/>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="cbc:ID"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="cbc:ID">
               <axsl:attribute name="id">PEPPOL-T16-B16501</axsl:attribute>
               <axsl:attribute name="flag">fatal</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-select-full-path"/>
               </axsl:attribute>
               <svrl:text>Element 'cbc:ID' MUST be provided.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>
      <axsl:apply-templates select="@*|*" mode="M10"/>
   </axsl:template>

	<!--RULE -->

   <axsl:template match="/ubl:DespatchAdvice/cac:DespatchLine/cac:Item/cac:StandardItemIdentification/cbc:ID" priority="1038" mode="M10">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="/ubl:DespatchAdvice/cac:DespatchLine/cac:Item/cac:StandardItemIdentification/cbc:ID"/>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="@schemeID"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="@schemeID">
               <axsl:attribute name="id">PEPPOL-T16-B16601</axsl:attribute>
               <axsl:attribute name="flag">fatal</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-select-full-path"/>
               </axsl:attribute>
               <svrl:text>Attribute 'schemeID' MUST be present.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(@schemeID) or (some $code in $clICD satisfies $code = @schemeID)"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(@schemeID) or (some $code in $clICD satisfies $code = @schemeID)">
               <axsl:attribute name="id">PEPPOL-T16-B16602</axsl:attribute>
               <axsl:attribute name="flag">fatal</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-select-full-path"/>
               </axsl:attribute>
               <svrl:text>Value MUST be part of code list 'ISO 6523 ICD list'.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>
      <axsl:apply-templates select="@*|*" mode="M10"/>
   </axsl:template>

	<!--RULE -->

   <axsl:template match="/ubl:DespatchAdvice/cac:DespatchLine/cac:Item/cac:StandardItemIdentification/cbc:ExtendedID" priority="1037" mode="M10">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="/ubl:DespatchAdvice/cac:DespatchLine/cac:Item/cac:StandardItemIdentification/cbc:ExtendedID"/>
      <axsl:apply-templates select="@*|*" mode="M10"/>
   </axsl:template>

	<!--RULE -->

   <axsl:template match="/ubl:DespatchAdvice/cac:DespatchLine/cac:Item/cac:StandardItemIdentification/*" priority="1036" mode="M10">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="/ubl:DespatchAdvice/cac:DespatchLine/cac:Item/cac:StandardItemIdentification/*"/>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="false()"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="false()">
               <axsl:attribute name="id">PEPPOL-T16-B16502</axsl:attribute>
               <axsl:attribute name="flag">fatal</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-select-full-path"/>
               </axsl:attribute>
               <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>
      <axsl:apply-templates select="@*|*" mode="M10"/>
   </axsl:template>

	<!--RULE -->

   <axsl:template match="/ubl:DespatchAdvice/cac:DespatchLine/cac:Item/cac:HazardousItem" priority="1035" mode="M10">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="/ubl:DespatchAdvice/cac:DespatchLine/cac:Item/cac:HazardousItem"/>
      <axsl:apply-templates select="@*|*" mode="M10"/>
   </axsl:template>

	<!--RULE -->

   <axsl:template match="/ubl:DespatchAdvice/cac:DespatchLine/cac:Item/cac:HazardousItem/cbc:UNDGCode" priority="1034" mode="M10">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="/ubl:DespatchAdvice/cac:DespatchLine/cac:Item/cac:HazardousItem/cbc:UNDGCode"/>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="(some $code in $clUNCL8273 satisfies $code = normalize-space(text()))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="(some $code in $clUNCL8273 satisfies $code = normalize-space(text()))">
               <axsl:attribute name="id">PEPPOL-T16-B17001</axsl:attribute>
               <axsl:attribute name="flag">fatal</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-select-full-path"/>
               </axsl:attribute>
               <svrl:text>Value MUST be part of code list 'Dangerous goods regulations code (UNCL8273)'.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>
      <axsl:apply-templates select="@*|*" mode="M10"/>
   </axsl:template>

	<!--RULE -->

   <axsl:template match="/ubl:DespatchAdvice/cac:DespatchLine/cac:Item/cac:HazardousItem/cbc:HazardClassID" priority="1033" mode="M10">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="/ubl:DespatchAdvice/cac:DespatchLine/cac:Item/cac:HazardousItem/cbc:HazardClassID"/>
      <axsl:apply-templates select="@*|*" mode="M10"/>
   </axsl:template>

	<!--RULE -->

   <axsl:template match="/ubl:DespatchAdvice/cac:DespatchLine/cac:Item/cac:HazardousItem/*" priority="1032" mode="M10">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="/ubl:DespatchAdvice/cac:DespatchLine/cac:Item/cac:HazardousItem/*"/>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="false()"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="false()">
               <axsl:attribute name="id">PEPPOL-T16-B16901</axsl:attribute>
               <axsl:attribute name="flag">fatal</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-select-full-path"/>
               </axsl:attribute>
               <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>
      <axsl:apply-templates select="@*|*" mode="M10"/>
   </axsl:template>

	<!--RULE -->

   <axsl:template match="/ubl:DespatchAdvice/cac:DespatchLine/cac:Item/cac:AdditionalItemProperty" priority="1031" mode="M10">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="/ubl:DespatchAdvice/cac:DespatchLine/cac:Item/cac:AdditionalItemProperty"/>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="cbc:Name"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="cbc:Name">
               <axsl:attribute name="id">PEPPOL-T16-B17201</axsl:attribute>
               <axsl:attribute name="flag">fatal</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-select-full-path"/>
               </axsl:attribute>
               <svrl:text>Element 'cbc:Name' MUST be provided.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="cbc:Value"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="cbc:Value">
               <axsl:attribute name="id">PEPPOL-T16-B17202</axsl:attribute>
               <axsl:attribute name="flag">fatal</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-select-full-path"/>
               </axsl:attribute>
               <svrl:text>Element 'cbc:Value' MUST be provided.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>
      <axsl:apply-templates select="@*|*" mode="M10"/>
   </axsl:template>

	<!--RULE -->

   <axsl:template match="/ubl:DespatchAdvice/cac:DespatchLine/cac:Item/cac:AdditionalItemProperty/cbc:Name" priority="1030" mode="M10">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="/ubl:DespatchAdvice/cac:DespatchLine/cac:Item/cac:AdditionalItemProperty/cbc:Name"/>
      <axsl:apply-templates select="@*|*" mode="M10"/>
   </axsl:template>

	<!--RULE -->

   <axsl:template match="/ubl:DespatchAdvice/cac:DespatchLine/cac:Item/cac:AdditionalItemProperty/cbc:NameCode" priority="1029" mode="M10">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="/ubl:DespatchAdvice/cac:DespatchLine/cac:Item/cac:AdditionalItemProperty/cbc:NameCode"/>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="@listID"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="@listID">
               <axsl:attribute name="id">PEPPOL-T16-B17401</axsl:attribute>
               <axsl:attribute name="flag">fatal</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-select-full-path"/>
               </axsl:attribute>
               <svrl:text>Attribute 'listID' MUST be present.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>
      <axsl:apply-templates select="@*|*" mode="M10"/>
   </axsl:template>

	<!--RULE -->

   <axsl:template match="/ubl:DespatchAdvice/cac:DespatchLine/cac:Item/cac:AdditionalItemProperty/cbc:Value" priority="1028" mode="M10">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="/ubl:DespatchAdvice/cac:DespatchLine/cac:Item/cac:AdditionalItemProperty/cbc:Value"/>
      <axsl:apply-templates select="@*|*" mode="M10"/>
   </axsl:template>

	<!--RULE -->

   <axsl:template match="/ubl:DespatchAdvice/cac:DespatchLine/cac:Item/cac:AdditionalItemProperty/cbc:ValueQuantity" priority="1027" mode="M10">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="/ubl:DespatchAdvice/cac:DespatchLine/cac:Item/cac:AdditionalItemProperty/cbc:ValueQuantity"/>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="@unitCode"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="@unitCode">
               <axsl:attribute name="id">PEPPOL-T16-B17701</axsl:attribute>
               <axsl:attribute name="flag">fatal</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-select-full-path"/>
               </axsl:attribute>
               <svrl:text>Attribute 'unitCode' MUST be present.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(@unitCode) or (some $code in $clUNECERec20 satisfies $code = @unitCode)"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(@unitCode) or (some $code in $clUNECERec20 satisfies $code = @unitCode)">
               <axsl:attribute name="id">PEPPOL-T16-B17702</axsl:attribute>
               <axsl:attribute name="flag">fatal</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-select-full-path"/>
               </axsl:attribute>
               <svrl:text>Value MUST be part of code list 'Recommandation 20, including Recommondation 21 codes - prefixed with X (UN/ECE)'.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>
      <axsl:apply-templates select="@*|*" mode="M10"/>
   </axsl:template>

	<!--RULE -->

   <axsl:template match="/ubl:DespatchAdvice/cac:DespatchLine/cac:Item/cac:AdditionalItemProperty/cbc:ValueQualifier" priority="1026" mode="M10">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="/ubl:DespatchAdvice/cac:DespatchLine/cac:Item/cac:AdditionalItemProperty/cbc:ValueQualifier"/>
      <axsl:apply-templates select="@*|*" mode="M10"/>
   </axsl:template>

	<!--RULE -->

   <axsl:template match="/ubl:DespatchAdvice/cac:DespatchLine/cac:Item/cac:AdditionalItemProperty/*" priority="1025" mode="M10">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="/ubl:DespatchAdvice/cac:DespatchLine/cac:Item/cac:AdditionalItemProperty/*"/>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="false()"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="false()">
               <axsl:attribute name="id">PEPPOL-T16-B17203</axsl:attribute>
               <axsl:attribute name="flag">fatal</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-select-full-path"/>
               </axsl:attribute>
               <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>
      <axsl:apply-templates select="@*|*" mode="M10"/>
   </axsl:template>

	<!--RULE -->

   <axsl:template match="/ubl:DespatchAdvice/cac:DespatchLine/cac:Item/cac:ItemInstance" priority="1024" mode="M10">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="/ubl:DespatchAdvice/cac:DespatchLine/cac:Item/cac:ItemInstance"/>
      <axsl:apply-templates select="@*|*" mode="M10"/>
   </axsl:template>

	<!--RULE -->

   <axsl:template match="/ubl:DespatchAdvice/cac:DespatchLine/cac:Item/cac:ItemInstance/cbc:ManufactureDate" priority="1023" mode="M10">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="/ubl:DespatchAdvice/cac:DespatchLine/cac:Item/cac:ItemInstance/cbc:ManufactureDate"/>
      <axsl:apply-templates select="@*|*" mode="M10"/>
   </axsl:template>

	<!--RULE -->

   <axsl:template match="/ubl:DespatchAdvice/cac:DespatchLine/cac:Item/cac:ItemInstance/cbc:BestBeforeDate" priority="1022" mode="M10">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="/ubl:DespatchAdvice/cac:DespatchLine/cac:Item/cac:ItemInstance/cbc:BestBeforeDate"/>
      <axsl:apply-templates select="@*|*" mode="M10"/>
   </axsl:template>

	<!--RULE -->

   <axsl:template match="/ubl:DespatchAdvice/cac:DespatchLine/cac:Item/cac:ItemInstance/cbc:SerialID" priority="1021" mode="M10">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="/ubl:DespatchAdvice/cac:DespatchLine/cac:Item/cac:ItemInstance/cbc:SerialID"/>
      <axsl:apply-templates select="@*|*" mode="M10"/>
   </axsl:template>

	<!--RULE -->

   <axsl:template match="/ubl:DespatchAdvice/cac:DespatchLine/cac:Item/cac:ItemInstance/cac:LotIdentification" priority="1020" mode="M10">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="/ubl:DespatchAdvice/cac:DespatchLine/cac:Item/cac:ItemInstance/cac:LotIdentification"/>
      <axsl:apply-templates select="@*|*" mode="M10"/>
   </axsl:template>

	<!--RULE -->

   <axsl:template match="/ubl:DespatchAdvice/cac:DespatchLine/cac:Item/cac:ItemInstance/cac:LotIdentification/cbc:LotNumberID" priority="1019" mode="M10">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="/ubl:DespatchAdvice/cac:DespatchLine/cac:Item/cac:ItemInstance/cac:LotIdentification/cbc:LotNumberID"/>
      <axsl:apply-templates select="@*|*" mode="M10"/>
   </axsl:template>

	<!--RULE -->

   <axsl:template match="/ubl:DespatchAdvice/cac:DespatchLine/cac:Item/cac:ItemInstance/cac:LotIdentification/cbc:ExpiryDate" priority="1018" mode="M10">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="/ubl:DespatchAdvice/cac:DespatchLine/cac:Item/cac:ItemInstance/cac:LotIdentification/cbc:ExpiryDate"/>
      <axsl:apply-templates select="@*|*" mode="M10"/>
   </axsl:template>

	<!--RULE -->

   <axsl:template match="/ubl:DespatchAdvice/cac:DespatchLine/cac:Item/cac:ItemInstance/cac:LotIdentification/*" priority="1017" mode="M10">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="/ubl:DespatchAdvice/cac:DespatchLine/cac:Item/cac:ItemInstance/cac:LotIdentification/*"/>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="false()"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="false()">
               <axsl:attribute name="id">PEPPOL-T16-B18401</axsl:attribute>
               <axsl:attribute name="flag">fatal</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-select-full-path"/>
               </axsl:attribute>
               <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>
      <axsl:apply-templates select="@*|*" mode="M10"/>
   </axsl:template>

	<!--RULE -->

   <axsl:template match="/ubl:DespatchAdvice/cac:DespatchLine/cac:Item/cac:ItemInstance/*" priority="1016" mode="M10">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="/ubl:DespatchAdvice/cac:DespatchLine/cac:Item/cac:ItemInstance/*"/>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="false()"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="false()">
               <axsl:attribute name="id">PEPPOL-T16-B18001</axsl:attribute>
               <axsl:attribute name="flag">fatal</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-select-full-path"/>
               </axsl:attribute>
               <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>
      <axsl:apply-templates select="@*|*" mode="M10"/>
   </axsl:template>

	<!--RULE -->

   <axsl:template match="/ubl:DespatchAdvice/cac:DespatchLine/cac:Item/*" priority="1015" mode="M10">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="/ubl:DespatchAdvice/cac:DespatchLine/cac:Item/*"/>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="false()"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="false()">
               <axsl:attribute name="id">PEPPOL-T16-B15802</axsl:attribute>
               <axsl:attribute name="flag">fatal</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-select-full-path"/>
               </axsl:attribute>
               <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>
      <axsl:apply-templates select="@*|*" mode="M10"/>
   </axsl:template>

	<!--RULE -->

   <axsl:template match="/ubl:DespatchAdvice/cac:DespatchLine/cac:Shipment" priority="1014" mode="M10">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="/ubl:DespatchAdvice/cac:DespatchLine/cac:Shipment"/>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="cbc:ID"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="cbc:ID">
               <axsl:attribute name="id">PEPPOL-T16-B18701</axsl:attribute>
               <axsl:attribute name="flag">fatal</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-select-full-path"/>
               </axsl:attribute>
               <svrl:text>Element 'cbc:ID' MUST be provided.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>
      <axsl:apply-templates select="@*|*" mode="M10"/>
   </axsl:template>

	<!--RULE -->

   <axsl:template match="/ubl:DespatchAdvice/cac:DespatchLine/cac:Shipment/cbc:ID" priority="1013" mode="M10">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="/ubl:DespatchAdvice/cac:DespatchLine/cac:Shipment/cbc:ID"/>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="normalize-space(text()) = 'NA'"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="normalize-space(text()) = 'NA'">
               <axsl:attribute name="id">PEPPOL-T16-B18801</axsl:attribute>
               <axsl:attribute name="flag">fatal</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-select-full-path"/>
               </axsl:attribute>
               <svrl:text>Element 'cbc:ID' MUST contain value 'NA'.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>
      <axsl:apply-templates select="@*|*" mode="M10"/>
   </axsl:template>

	<!--RULE -->

   <axsl:template match="/ubl:DespatchAdvice/cac:DespatchLine/cac:Shipment/cac:TransportHandlingUnit" priority="1012" mode="M10">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="/ubl:DespatchAdvice/cac:DespatchLine/cac:Shipment/cac:TransportHandlingUnit"/>
      <axsl:apply-templates select="@*|*" mode="M10"/>
   </axsl:template>

	<!--RULE -->

   <axsl:template match="/ubl:DespatchAdvice/cac:DespatchLine/cac:Shipment/cac:TransportHandlingUnit/cbc:ID" priority="1011" mode="M10">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="/ubl:DespatchAdvice/cac:DespatchLine/cac:Shipment/cac:TransportHandlingUnit/cbc:ID"/>
      <axsl:apply-templates select="@*|*" mode="M10"/>
   </axsl:template>

	<!--RULE -->

   <axsl:template match="/ubl:DespatchAdvice/cac:DespatchLine/cac:Shipment/cac:TransportHandlingUnit/cbc:TransportHandlingUnitTypeCode" priority="1010" mode="M10">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="/ubl:DespatchAdvice/cac:DespatchLine/cac:Shipment/cac:TransportHandlingUnit/cbc:TransportHandlingUnitTypeCode"/>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="(some $code in $clUNECERec21 satisfies $code = normalize-space(text()))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="(some $code in $clUNECERec21 satisfies $code = normalize-space(text()))">
               <axsl:attribute name="id">PEPPOL-T16-B19101</axsl:attribute>
               <axsl:attribute name="flag">fatal</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-select-full-path"/>
               </axsl:attribute>
               <svrl:text>Value MUST be part of code list 'Recommandation 21 (UN/ECE)'.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>
      <axsl:apply-templates select="@*|*" mode="M10"/>
   </axsl:template>

	<!--RULE -->

   <axsl:template match="/ubl:DespatchAdvice/cac:DespatchLine/cac:Shipment/cac:TransportHandlingUnit/cbc:HazardousRiskIndicator" priority="1009" mode="M10">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="/ubl:DespatchAdvice/cac:DespatchLine/cac:Shipment/cac:TransportHandlingUnit/cbc:HazardousRiskIndicator"/>
      <axsl:apply-templates select="@*|*" mode="M10"/>
   </axsl:template>

	<!--RULE -->

   <axsl:template match="/ubl:DespatchAdvice/cac:DespatchLine/cac:Shipment/cac:TransportHandlingUnit/cbc:ShippingMarks" priority="1008" mode="M10">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="/ubl:DespatchAdvice/cac:DespatchLine/cac:Shipment/cac:TransportHandlingUnit/cbc:ShippingMarks"/>
      <axsl:apply-templates select="@*|*" mode="M10"/>
   </axsl:template>

	<!--RULE -->

   <axsl:template match="/ubl:DespatchAdvice/cac:DespatchLine/cac:Shipment/cac:TransportHandlingUnit/cac:MeasurementDimension" priority="1007" mode="M10">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="/ubl:DespatchAdvice/cac:DespatchLine/cac:Shipment/cac:TransportHandlingUnit/cac:MeasurementDimension"/>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="cbc:AttributeID"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="cbc:AttributeID">
               <axsl:attribute name="id">PEPPOL-T16-B19401</axsl:attribute>
               <axsl:attribute name="flag">fatal</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-select-full-path"/>
               </axsl:attribute>
               <svrl:text>Element 'cbc:AttributeID' MUST be provided.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>
      <axsl:apply-templates select="@*|*" mode="M10"/>
   </axsl:template>

	<!--RULE -->

   <axsl:template match="/ubl:DespatchAdvice/cac:DespatchLine/cac:Shipment/cac:TransportHandlingUnit/cac:MeasurementDimension/cbc:AttributeID" priority="1006" mode="M10">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="/ubl:DespatchAdvice/cac:DespatchLine/cac:Shipment/cac:TransportHandlingUnit/cac:MeasurementDimension/cbc:AttributeID"/>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="(some $code in $clUNCL6313-T16 satisfies $code = normalize-space(text()))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="(some $code in $clUNCL6313-T16 satisfies $code = normalize-space(text()))">
               <axsl:attribute name="id">PEPPOL-T16-B19501</axsl:attribute>
               <axsl:attribute name="flag">fatal</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-select-full-path"/>
               </axsl:attribute>
               <svrl:text>Value MUST be part of code list 'Measured attribute code for despatch advice (UNCL6313 Subset)'.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>
      <axsl:apply-templates select="@*|*" mode="M10"/>
   </axsl:template>

	<!--RULE -->

   <axsl:template match="/ubl:DespatchAdvice/cac:DespatchLine/cac:Shipment/cac:TransportHandlingUnit/cac:MeasurementDimension/cbc:Measure" priority="1005" mode="M10">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="/ubl:DespatchAdvice/cac:DespatchLine/cac:Shipment/cac:TransportHandlingUnit/cac:MeasurementDimension/cbc:Measure"/>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="@unitCode"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="@unitCode">
               <axsl:attribute name="id">PEPPOL-T16-B19601</axsl:attribute>
               <axsl:attribute name="flag">fatal</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-select-full-path"/>
               </axsl:attribute>
               <svrl:text>Attribute 'unitCode' MUST be present.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(@unitCode) or (some $code in $clUNECERec20 satisfies $code = @unitCode)"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(@unitCode) or (some $code in $clUNECERec20 satisfies $code = @unitCode)">
               <axsl:attribute name="id">PEPPOL-T16-B19602</axsl:attribute>
               <axsl:attribute name="flag">fatal</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-select-full-path"/>
               </axsl:attribute>
               <svrl:text>Value MUST be part of code list 'Recommandation 20, including Recommondation 21 codes - prefixed with X (UN/ECE)'.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>
      <axsl:apply-templates select="@*|*" mode="M10"/>
   </axsl:template>

	<!--RULE -->

   <axsl:template match="/ubl:DespatchAdvice/cac:DespatchLine/cac:Shipment/cac:TransportHandlingUnit/cac:MeasurementDimension/*" priority="1004" mode="M10">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="/ubl:DespatchAdvice/cac:DespatchLine/cac:Shipment/cac:TransportHandlingUnit/cac:MeasurementDimension/*"/>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="false()"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="false()">
               <axsl:attribute name="id">PEPPOL-T16-B19402</axsl:attribute>
               <axsl:attribute name="flag">fatal</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-select-full-path"/>
               </axsl:attribute>
               <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>
      <axsl:apply-templates select="@*|*" mode="M10"/>
   </axsl:template>

	<!--RULE -->

   <axsl:template match="/ubl:DespatchAdvice/cac:DespatchLine/cac:Shipment/cac:TransportHandlingUnit/*" priority="1003" mode="M10">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="/ubl:DespatchAdvice/cac:DespatchLine/cac:Shipment/cac:TransportHandlingUnit/*"/>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="false()"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="false()">
               <axsl:attribute name="id">PEPPOL-T16-B18901</axsl:attribute>
               <axsl:attribute name="flag">fatal</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-select-full-path"/>
               </axsl:attribute>
               <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>
      <axsl:apply-templates select="@*|*" mode="M10"/>
   </axsl:template>

	<!--RULE -->

   <axsl:template match="/ubl:DespatchAdvice/cac:DespatchLine/cac:Shipment/*" priority="1002" mode="M10">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="/ubl:DespatchAdvice/cac:DespatchLine/cac:Shipment/*"/>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="false()"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="false()">
               <axsl:attribute name="id">PEPPOL-T16-B18702</axsl:attribute>
               <axsl:attribute name="flag">fatal</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-select-full-path"/>
               </axsl:attribute>
               <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>
      <axsl:apply-templates select="@*|*" mode="M10"/>
   </axsl:template>

	<!--RULE -->

   <axsl:template match="/ubl:DespatchAdvice/cac:DespatchLine/*" priority="1001" mode="M10">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="/ubl:DespatchAdvice/cac:DespatchLine/*"/>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="false()"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="false()">
               <axsl:attribute name="id">PEPPOL-T16-B14604</axsl:attribute>
               <axsl:attribute name="flag">fatal</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-select-full-path"/>
               </axsl:attribute>
               <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>
      <axsl:apply-templates select="@*|*" mode="M10"/>
   </axsl:template>

	<!--RULE -->

   <axsl:template match="/ubl:DespatchAdvice/*" priority="1000" mode="M10">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="/ubl:DespatchAdvice/*"/>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="false()"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="false()">
               <axsl:attribute name="id">PEPPOL-T16-B00109</axsl:attribute>
               <axsl:attribute name="flag">fatal</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-select-full-path"/>
               </axsl:attribute>
               <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>
      <axsl:apply-templates select="@*|*" mode="M10"/>
   </axsl:template>
   <axsl:template match="text()" priority="-1" mode="M10"/>
   <axsl:template match="@*|node()" priority="-2" mode="M10">
      <axsl:apply-templates select="@*|*" mode="M10"/>
   </axsl:template>

<!--PATTERN -->


	<!--RULE -->

   <axsl:template match="ubl:DespatchAdvice" priority="1004" mode="M11">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="ubl:DespatchAdvice"/>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="(cac:OrderReference/cbc:ID)"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="(cac:OrderReference/cbc:ID)">
               <axsl:attribute name="id">PEPPOL-T16-R002</axsl:attribute>
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-select-full-path"/>
               </axsl:attribute>
               <svrl:text>A despatch advice SHOULD have an order identifier</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>
      <axsl:apply-templates select="@*|*" mode="M11"/>
   </axsl:template>

	<!--RULE -->

   <axsl:template match="cac:BuyerCustomerParty" priority="1003" mode="M11">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="cac:BuyerCustomerParty"/>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="(cac:Party/cac:PartyName/cbc:Name) or (cac:Party/cac:PartyIdentification/cbc:ID)"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="(cac:Party/cac:PartyName/cbc:Name) or (cac:Party/cac:PartyIdentification/cbc:ID)">
               <axsl:attribute name="id">PEPPOL-T16-R008</axsl:attribute>
               <axsl:attribute name="flag">fatal</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-select-full-path"/>
               </axsl:attribute>
               <svrl:text>A despatch advice buyer party SHALL contain the name or an identifier</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>
      <axsl:apply-templates select="@*|*" mode="M11"/>
   </axsl:template>

	<!--RULE -->

   <axsl:template match="cac:SellerSupplierParty" priority="1002" mode="M11">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="cac:SellerSupplierParty"/>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="(cac:Party/cac:PartyName/cbc:Name) or (cac:Party/cac:PartyIdentification/cbc:ID)"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="(cac:Party/cac:PartyName/cbc:Name) or (cac:Party/cac:PartyIdentification/cbc:ID)">
               <axsl:attribute name="id">PEPPOL-T16-R009</axsl:attribute>
               <axsl:attribute name="flag">fatal</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-select-full-path"/>
               </axsl:attribute>
               <svrl:text>A despatch advice buyer party SHALL contain the name or an identifier</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>
      <axsl:apply-templates select="@*|*" mode="M11"/>
   </axsl:template>

	<!--RULE -->

   <axsl:template match="cac:OriginatorCustomerParty" priority="1001" mode="M11">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="cac:OriginatorCustomerParty"/>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="(cac:Party/cac:PartyName/cbc:Name) or (cac:Party/cac:PartyIdentification/cbc:ID)"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="(cac:Party/cac:PartyName/cbc:Name) or (cac:Party/cac:PartyIdentification/cbc:ID)">
               <axsl:attribute name="id">PEPPOL-T16-R010</axsl:attribute>
               <axsl:attribute name="flag">fatal</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-select-full-path"/>
               </axsl:attribute>
               <svrl:text>A despatch advice buyer party SHALL contain the name or an identifier</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>
      <axsl:apply-templates select="@*|*" mode="M11"/>
   </axsl:template>

	<!--RULE -->

   <axsl:template match="cac:DespatchLine" priority="1000" mode="M11">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="cac:DespatchLine"/>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="(cac:Item/cac:StandardItemIdentification/cbc:ID) or  (cac:Item/cac:SellersItemIdentification/cbc:ID)"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="(cac:Item/cac:StandardItemIdentification/cbc:ID) or (cac:Item/cac:SellersItemIdentification/cbc:ID)">
               <axsl:attribute name="id">PEPPOL-T16-R003</axsl:attribute>
               <axsl:attribute name="flag">fatal</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-select-full-path"/>
               </axsl:attribute>
               <svrl:text>Each item in a Despatch Advice line SHALL be identifiable by either “item sellers identifier” or “item standard identifier”</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="(cac:Item/cbc:Name)"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="(cac:Item/cbc:Name)">
               <axsl:attribute name="id">PEPPOL-T16-R004</axsl:attribute>
               <axsl:attribute name="flag">fatal</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-select-full-path"/>
               </axsl:attribute>
               <svrl:text>Each Despatch Advice SHALL contain the item name</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="(cbc:DeliveredQuantity)"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="(cbc:DeliveredQuantity)">
               <axsl:attribute name="id">PEPPOL-T16-R005</axsl:attribute>
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-select-full-path"/>
               </axsl:attribute>
               <svrl:text>Each despatch advice line SHOULD have a delivered quantity</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="number(cbc:DeliveredQuantity) &gt;= 0"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="number(cbc:DeliveredQuantity) &gt;= 0">
               <axsl:attribute name="id">PEPPOL-T16-R006</axsl:attribute>
               <axsl:attribute name="flag">fatal</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-select-full-path"/>
               </axsl:attribute>
               <svrl:text>Each despatch advice line delivered quantity SHALL not be negative</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="((cbc:OutstandingQuantity) and (cbc:OutstandingReason)) or not(cbc:OutstandingQuantity)"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="((cbc:OutstandingQuantity) and (cbc:OutstandingReason)) or not(cbc:OutstandingQuantity)">
               <axsl:attribute name="id">PEPPOL-T16-R007</axsl:attribute>
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-select-full-path"/>
               </axsl:attribute>
               <svrl:text>An outstanding quantity reason SHOULD be provided if the despatch line contains an outstanding quantity</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>
      <axsl:apply-templates select="@*|*" mode="M11"/>
   </axsl:template>
   <axsl:template match="text()" priority="-1" mode="M11"/>
   <axsl:template match="@*|node()" priority="-2" mode="M11">
      <axsl:apply-templates select="@*|*" mode="M11"/>
   </axsl:template>

<!--PATTERN INT-UBL-T16-->


	<!--RULE -->

   <axsl:template match="//cbc:EndpointID" priority="1004" mode="M12">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="//cbc:EndpointID"/>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="((@schemeID='9921' or @schemeID='0201') and matches(.,'^[a-zA-Z0-9]{6,7}$')) or (@schemeID!='9921' and @schemeID!='0201')"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="((@schemeID='9921' or @schemeID='0201') and matches(.,'^[a-zA-Z0-9]{6,7}$')) or (@schemeID!='9921' and @schemeID!='0201')">
               <axsl:attribute name="id">INT-T16-R026</axsl:attribute>
               <axsl:attribute name="flag">fatal</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-select-full-path"/>
               </axsl:attribute>
               <svrl:text>[INT-T16-R026] - Se l'identificatore di endpoint si basa sullo schema di identificatori IT:IPA (ICD: 0201 ex 9921), questo dovrà seguire la sintassi [A-Z0-9]{6,7}.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="(@schemeID='9906' and matches(.,'^(IT)?[0-9]{11}$')) or @schemeID!='9906'"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="(@schemeID='9906' and matches(.,'^(IT)?[0-9]{11}$')) or @schemeID!='9906'">
               <axsl:attribute name="id">INT-T16-R027</axsl:attribute>
               <axsl:attribute name="flag">fatal</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-select-full-path"/>
               </axsl:attribute>
               <svrl:text>[INT-T16-R027] - Se l'identificatore di endpoint si basa sullo schema di identificatori IT:VAT (ICD: 9906), questo dovrà seguire la sintassi (IT)?[0-9]{11}.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="(@schemeID='9907' and matches(.,'^[0-9]{11}$|^[A-Z]{6}\d{2}[ABCDEHLMPRST]{1}\d{2}[A-Z]{1}\d{3}[A-Z]{1}$')) or @schemeID!='9907'"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="(@schemeID='9907' and matches(.,'^[0-9]{11}$|^[A-Z]{6}\d{2}[ABCDEHLMPRST]{1}\d{2}[A-Z]{1}\d{3}[A-Z]{1}$')) or @schemeID!='9907'">
               <axsl:attribute name="id">INT-T16-R028</axsl:attribute>
               <axsl:attribute name="flag">fatal</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-select-full-path"/>
               </axsl:attribute>
               <svrl:text>[INT-T16-R028] - Se l'identificatore di endpoint si basa sullo schema di identificatori IT:CF (ICD: 9907), questo dovrà seguire la sintassi [0-9]{11} per le persone giuridiche e la sintassi [A-Z]{6}\d{2}[ABCDEHLMPRST]{1}\d{2}[A-Z]{1}\d{3}[A-Z]{1} per quelle fisiche.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>
      <axsl:apply-templates select="@*|*" mode="M12"/>
   </axsl:template>

	<!--RULE -->

   <axsl:template match="//cac:DespatchLine" priority="1003" mode="M12">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="//cac:DespatchLine"/>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="cac:Item/cbc:Name and (cac:Item/cac:SellersItemIdentification/cbc:ID or cac:Item/cac:StandardItemIdentification/cbc:ID) and cbc:DeliveredQuantity"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="cac:Item/cbc:Name and (cac:Item/cac:SellersItemIdentification/cbc:ID or cac:Item/cac:StandardItemIdentification/cbc:ID) and cbc:DeliveredQuantity">
               <axsl:attribute name="id">INT-T16-R003</axsl:attribute>
               <axsl:attribute name="flag">fatal</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-select-full-path"/>
               </axsl:attribute>
               <svrl:text>[INT-T16-R003] - Le righe del DDT DEVONO contenere le informazioni minime previste dall’Art. 21, comma 4 del DPR n. 633/1972 (Nome articolo merce, identificativo articolo e quantità consegnata).</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>
      <axsl:apply-templates select="@*|*" mode="M12"/>
   </axsl:template>

	<!--RULE -->

   <axsl:template match="/ubl:DespatchAdvice" priority="1002" mode="M12">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="/ubl:DespatchAdvice"/>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="cac:DespatchSupplierParty/cac:Party/cac:PartyIdentification/cbc:ID and cac:DespatchSupplierParty/cac:Party/cac:PartyName/cbc:Name and cac:DespatchSupplierParty/cac:Party/cac:PostalAddress/cbc:StreetName and cac:DespatchSupplierParty/cac:Party/cac:PostalAddress/cbc:CityName and cac:DespatchSupplierParty/cac:Party/cac:PostalAddress/cbc:PostalZone and cac:DespatchSupplierParty/cac:Party/cac:PostalAddress/cbc:CountrySubentity and cac:DeliveryCustomerParty/cac:Party/cac:PartyName/cbc:Name and cac:DeliveryCustomerParty/cac:Party/cac:PostalAddress/cbc:StreetName and cac:DeliveryCustomerParty/cac:Party/cac:PostalAddress/cbc:CityName and cac:DeliveryCustomerParty/cac:Party/cac:PostalAddress/cbc:PostalZone and cac:DeliveryCustomerParty/cac:Party/cac:PostalAddress/cbc:CountrySubentity and (not(cac:BuyerCustomerParty) or (cac:BuyerCustomerParty/cac:Party/cac:PartyName/cbc:Name and cac:BuyerCustomerParty/cac:Party/cac:PostalAddress/cbc:StreetName and cac:BuyerCustomerParty/cac:Party/cac:PostalAddress/cbc:CityName and cac:BuyerCustomerParty/cac:Party/cac:PostalAddress/cbc:PostalZone and cac:BuyerCustomerParty/cac:Party/cac:PostalAddress/cbc:CountrySubentity)) and (not(cac:SellerSupplierParty) or (cac:SellerSupplierParty/cac:Party/cac:PartyName/cbc:Name and cac:SellerSupplierParty/cac:Party/cac:PostalAddress/cbc:StreetName and cac:SellerSupplierParty/cac:Party/cac:PostalAddress/cbc:CityName and cac:SellerSupplierParty/cac:Party/cac:PostalAddress/cbc:PostalZone and cac:SellerSupplierParty/cac:Party/cac:PostalAddress/cbc:CountrySubentity)) and cac:Shipment/cbc:GrossWeightMeasure and cac:Shipment/cbc:TotalTransportHandlingUnitQuantity and cac:Shipment/cac:Consignment/cac:CarrierParty/cac:PartyName/cbc:Name and cac:Shipment/cac:Consignment/cac:CarrierParty/cac:PostalAddress/cbc:StreetName and cac:Shipment/cac:Consignment/cac:CarrierParty/cac:PostalAddress/cbc:CityName and cac:Shipment/cac:Consignment/cac:CarrierParty/cac:PostalAddress/cbc:PostalZone and cac:Shipment/cac:Consignment/cac:CarrierParty/cac:PostalAddress/cbc:CountrySubentity"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="cac:DespatchSupplierParty/cac:Party/cac:PartyIdentification/cbc:ID and cac:DespatchSupplierParty/cac:Party/cac:PartyName/cbc:Name and cac:DespatchSupplierParty/cac:Party/cac:PostalAddress/cbc:StreetName and cac:DespatchSupplierParty/cac:Party/cac:PostalAddress/cbc:CityName and cac:DespatchSupplierParty/cac:Party/cac:PostalAddress/cbc:PostalZone and cac:DespatchSupplierParty/cac:Party/cac:PostalAddress/cbc:CountrySubentity and cac:DeliveryCustomerParty/cac:Party/cac:PartyName/cbc:Name and cac:DeliveryCustomerParty/cac:Party/cac:PostalAddress/cbc:StreetName and cac:DeliveryCustomerParty/cac:Party/cac:PostalAddress/cbc:CityName and cac:DeliveryCustomerParty/cac:Party/cac:PostalAddress/cbc:PostalZone and cac:DeliveryCustomerParty/cac:Party/cac:PostalAddress/cbc:CountrySubentity and (not(cac:BuyerCustomerParty) or (cac:BuyerCustomerParty/cac:Party/cac:PartyName/cbc:Name and cac:BuyerCustomerParty/cac:Party/cac:PostalAddress/cbc:StreetName and cac:BuyerCustomerParty/cac:Party/cac:PostalAddress/cbc:CityName and cac:BuyerCustomerParty/cac:Party/cac:PostalAddress/cbc:PostalZone and cac:BuyerCustomerParty/cac:Party/cac:PostalAddress/cbc:CountrySubentity)) and (not(cac:SellerSupplierParty) or (cac:SellerSupplierParty/cac:Party/cac:PartyName/cbc:Name and cac:SellerSupplierParty/cac:Party/cac:PostalAddress/cbc:StreetName and cac:SellerSupplierParty/cac:Party/cac:PostalAddress/cbc:CityName and cac:SellerSupplierParty/cac:Party/cac:PostalAddress/cbc:PostalZone and cac:SellerSupplierParty/cac:Party/cac:PostalAddress/cbc:CountrySubentity)) and cac:Shipment/cbc:GrossWeightMeasure and cac:Shipment/cbc:TotalTransportHandlingUnitQuantity and cac:Shipment/cac:Consignment/cac:CarrierParty/cac:PartyName/cbc:Name and cac:Shipment/cac:Consignment/cac:CarrierParty/cac:PostalAddress/cbc:StreetName and cac:Shipment/cac:Consignment/cac:CarrierParty/cac:PostalAddress/cbc:CityName and cac:Shipment/cac:Consignment/cac:CarrierParty/cac:PostalAddress/cbc:PostalZone and cac:Shipment/cac:Consignment/cac:CarrierParty/cac:PostalAddress/cbc:CountrySubentity">
               <axsl:attribute name="id">INT-T16-R002</axsl:attribute>
               <axsl:attribute name="flag">fatal</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-select-full-path"/>
               </axsl:attribute>
               <svrl:text>[INT-T16-R002] - La testata del DDT DEVE contenere le informazioni minime previste dall’Art. 21, comma 4 del DPR n. 633/1972 (Identificativo, nome e indirizzo dello Speditore / Cedente, nome e indirizzo del Consegnatario / Cessionario, peso lordo e numero colli della spedizione, generalità del Trasportatore e indirizzo).</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="cac:Shipment/cbc:TotalTransportHandlingUnitQuantity and (string(cac:Shipment/cbc:TotalTransportHandlingUnitQuantity) castable as xs:integer or cac:Shipment/cbc:TotalTransportHandlingUnitQuantity - floor(cac:Shipment/cbc:TotalTransportHandlingUnitQuantity) = 0)"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="cac:Shipment/cbc:TotalTransportHandlingUnitQuantity and (string(cac:Shipment/cbc:TotalTransportHandlingUnitQuantity) castable as xs:integer or cac:Shipment/cbc:TotalTransportHandlingUnitQuantity - floor(cac:Shipment/cbc:TotalTransportHandlingUnitQuantity) = 0)">
               <axsl:attribute name="id">INT-T16-R005</axsl:attribute>
               <axsl:attribute name="flag">fatal</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-select-full-path"/>
               </axsl:attribute>
               <svrl:text>[INT-T16-R005] - Il numero dei colli deve essere un intero.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>
      <axsl:apply-templates select="@*|*" mode="M12"/>
   </axsl:template>

	<!--RULE -->

   <axsl:template match="//cac:Person" priority="1001" mode="M12">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="//cac:Person"/>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="(cbc:FirstName and cbc:FamilyName) or cac:IdentityDocumentReference"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="(cbc:FirstName and cbc:FamilyName) or cac:IdentityDocumentReference">
               <axsl:attribute name="id">INT-T16-R006</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-select-full-path"/>
               </axsl:attribute>
               <svrl:text>[INT-T16-R006] - Se viene usato l'elemento informativo cac:Person per indicare una persona fisica (es. se non è già fornito nella denominazione della ditta) è necessario specificarne sia il nome che il cognome.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>
      <axsl:apply-templates select="@*|*" mode="M12"/>
   </axsl:template>

	<!--RULE -->

   <axsl:template match="//cbc:*" priority="1000" mode="M12">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="//cbc:*"/>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="normalize-space()"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="normalize-space()">
               <axsl:attribute name="id">INT-T16-R001</axsl:attribute>
               <axsl:attribute name="flag">fatal</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-select-full-path"/>
               </axsl:attribute>
               <svrl:text>[INT-T16-R001] - Un elemento informativo base, se istanziato, non può essere vuoto.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>
      <axsl:apply-templates select="@*|*" mode="M12"/>
   </axsl:template>
   <axsl:template match="text()" priority="-1" mode="M12"/>
   <axsl:template match="@*|node()" priority="-2" mode="M12">
      <axsl:apply-templates select="@*|*" mode="M12"/>
   </axsl:template>
</axsl:stylesheet>