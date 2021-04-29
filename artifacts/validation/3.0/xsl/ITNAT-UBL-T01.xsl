<?xml version="1.0" encoding="utf-8" standalone="yes"?>
<axsl:stylesheet xmlns:axsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema"
                 xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:saxon="http://saxon.sf.net/"
                 xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:schold="http://www.ascc.net/xml/schematron"
                 xmlns:iso="http://purl.oclc.org/dsdl/schematron" xmlns:xhtml="http://www.w3.org/1999/xhtml"
                 xmlns:cbc="urn:oasis:names:specification:ubl:schema:xsd:CommonBasicComponents-2"
                 xmlns:cac="urn:oasis:names:specification:ubl:schema:xsd:CommonAggregateComponents-2"
                 xmlns:ubl="urn:oasis:names:specification:ubl:schema:xsd:Order-2" xmlns:u="utils" version="2.0"><!--Implementers: please note that overriding process-prolog or process-root is
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

    <axsl:output xmlns:svrl="http://purl.oclc.org/dsdl/svrl" method="xml" omit-xml-declaration="no" standalone="yes"
                 indent="yes"/>

    <!--XSD TYPES FOR XSLT2-->


    <!--KEYS AND FUNCTIONS-->

    <axsl:key name="k_lineId" match="cac:LineItem" use="cbc:ID"/>
    <function xmlns="http://www.w3.org/1999/XSL/Transform" xmlns:xi="http://www.w3.org/2001/XInclude" name="u:gln"
              as="xs:boolean">

        <param name="val"/>

        <variable name="length" select="string-length($val) - 1"/>

        <variable name="digits"
                  select="reverse(for $i in string-to-codepoints(substring($val, 0, $length + 1)) return $i - 48)"/>

        <variable name="weightedSum"
                  select="sum(for $i in (0 to $length - 1) return $digits[$i + 1] * (1 + ((($i + 1) mod 2) * 2)))"/>

        <value-of select="(10 - ($weightedSum mod 10)) mod 10 = number(substring($val, $length + 1, 1))"/>

    </function>
    <function xmlns="http://www.w3.org/1999/XSL/Transform" xmlns:xi="http://www.w3.org/2001/XInclude" name="u:slack"
              as="xs:boolean">

        <param name="exp" as="xs:decimal"/>

        <param name="val" as="xs:decimal"/>

        <param name="slack" as="xs:decimal"/>

        <value-of select="xs:decimal($exp + $slack) &gt;= $val and xs:decimal($exp - $slack) &lt;= $val"/>

    </function>
    <function xmlns="http://www.w3.org/1999/XSL/Transform" xmlns:xi="http://www.w3.org/2001/XInclude" name="u:mod11"
              as="xs:boolean">

        <param name="val"/>

        <variable name="length" select="string-length($val) - 1"/>

        <variable name="digits"
                  select="reverse(for $i in string-to-codepoints(substring($val, 0, $length + 1)) return $i - 48)"/>

        <variable name="weightedSum"
                  select="sum(for $i in (0 to $length - 1) return $digits[$i + 1] * (($i mod 6) + 2))"/>

        <value-of
                select="number($val) &gt; 0 and (11 - ($weightedSum mod 11)) mod 11 = number(substring($val, $length + 1, 1))"/>

    </function>
    <function xmlns="http://www.w3.org/1999/XSL/Transform" xmlns:xi="http://www.w3.org/2001/XInclude"
              name="u:tipoOrdine" as="xs:string">

        <param name="arg" as="xs:string?"/>

        <variable name="tipo" select="if (u:countDelitited($arg) != 3) then 'NSO2' else u:getPartTokenizeID($arg,4)"/>

        <sequence
                select="if ($tipo eq 'Cancelled') then 'CANC' else        (if ($tipo eq 'Revised') then 'SOST' else          (if ($tipo eq 'Accepted') then 'CONF' else           (if ($tipo eq 'Connected') then 'CONN' else           (if ($tipo eq 'Invoice') then 'INVO' else            (if ($tipo eq 'NSO2') then 'ERRORE_NSO40' else 'ERRORE'                    )           )           )         )        )"/>

    </function>
    <function xmlns="http://www.w3.org/1999/XSL/Transform" xmlns:xi="http://www.w3.org/2001/XInclude"
              name="u:getPartTokenizeID" as="xs:string">

        <param name="reference" as="xs:string"/>

        <param name="arg" as="xs:integer"/>


        <variable name="listToken" select="tokenize($reference, '#')"/>


        <sequence select="$listToken[$arg]"/>


    </function>
    <function xmlns="http://www.w3.org/1999/XSL/Transform" xmlns:xi="http://www.w3.org/2001/XInclude"
              name="u:countDelitited" as="xs:integer">

        <param name="reference" as="xs:string"/>

        <variable name="stringList" select="tokenize($reference, '#')"/>


        <sequence select="count($stringList) - 1"/>


    </function>
    <function xmlns="http://www.w3.org/1999/XSL/Transform" xmlns:xi="http://www.w3.org/2001/XInclude" name="u:is"
              as="xs:boolean">

        <param name="arg" as="xs:boolean"/>


        <sequence select="xs:boolean($arg)"/>


    </function>
    <function xmlns="http://www.w3.org/1999/XSL/Transform" xmlns:xi="http://www.w3.org/2001/XInclude"
              name="u:validationDate" as="xs:boolean">


        <param name="arg" as="xs:string?"/>


        <sequence select="string(normalize-space($arg)) castable as xs:date"/>


    </function>
    <function xmlns="http://www.w3.org/1999/XSL/Transform" xmlns:xi="http://www.w3.org/2001/XInclude"
              name="u:verificaCIG" as="xs:boolean">


        <param name="arg" as="xs:string?"/>


        <variable name="argNor" select="u:normalizaCIG($arg)"/>


        <sequence
                select="   if (u:isCIG($argNor)) then   ( if ( string-length($argNor) != 4 and string-length($argNor) != 10 ) then true() else     ( if ( string-length($argNor) = 4 and not ( u:isEsclusioneValida($argNor) ) ) then true() else     ( if ( string-length($argNor) = 10 and contains('X Y Z', substring($argNor,1,1)) and not ( u:isSmartCIGValido($argNor) ) ) then true() else      ( if ( string-length($argNor) = 10 and not (contains('X Y Z', substring($argNor,1,1))) and not ( u:isCIGValido($argNor) ) ) then true() else       false()      )     )    )   ) else false()"/>


    </function>
    <function xmlns="http://www.w3.org/1999/XSL/Transform" xmlns:xi="http://www.w3.org/2001/XInclude"
              name="u:isEsclusioneValida" as="xs:boolean">


        <param name="arg" as="xs:string?"/>


        <sequence
                select="( contains( 'ES01 ES02 ES03 ES04 ES05 ES06 ES07 ES08 ES09 ES10                 ES11 ES12 ES13 ES14 ES15 ES16 ES17 ES18 ES19 ES20              ES21 ES22 ES23 ES24 ES25 ES26 ES27', $arg )          )"/>


    </function>
    <function xmlns="http://www.w3.org/1999/XSL/Transform" xmlns:xi="http://www.w3.org/2001/XInclude"
              name="u:isCIGValido" as="xs:boolean">


        <param name="arg" as="xs:string?"/>


        <sequence
                select=" (      ( matches (substring($arg,1,7), '0000000') )        or       not ( if(u:hexToDec(substring($arg,8,3)) = xs:integer((xs:integer(substring($arg,1,7)) * 211 ) mod 4091) ) then 0 else 1)           )"/>


    </function>
    <function xmlns="http://www.w3.org/1999/XSL/Transform" xmlns:xi="http://www.w3.org/2001/XInclude"
              name="u:isSmartCIGValido" as="xs:boolean">


        <param name="arg" as="xs:string?"/>


        <sequence
                select=" (      ( matches (substring($arg,4,7), '0000000') )        or       not ( if(u:hexToDec(substring($arg,2,2)) = xs:integer((xs:integer(u:hexToDec(substring($arg,4,7))) * 211 ) mod 251) ) then 0 else 1)           )"/>


    </function>
    <function xmlns="http://www.w3.org/1999/XSL/Transform" xmlns:xi="http://www.w3.org/2001/XInclude" name="u:isCIG"
              as="xs:boolean">


        <param name="arg" as="xs:string?"/>


        <variable name="stringList" select="tokenize($arg, ':')"/>


        <sequence select="if ((count($stringList) -1) &gt; 0) then false() else true()"/>


    </function>
    <function xmlns="http://www.w3.org/1999/XSL/Transform" xmlns:xi="http://www.w3.org/2001/XInclude"
              name="u:normalizaCIG" as="xs:string">


        <param name="arg" as="xs:string?"/>


        <sequence select="if ( matches (substring($arg,1,4), 'CIG:') ) then substring($arg,5,10) else $arg"/>


    </function>
    <function xmlns="http://www.w3.org/1999/XSL/Transform" xmlns:xi="http://www.w3.org/2001/XInclude" name="u:hexToDec"
              as="xs:double">


        <param name="hex" as="xs:string?"/>


        <variable name="dec" select="string-length(substring-before('0123456789ABCDEF', substring($hex,1,1)))"/>


        <choose>

            <when test="matches($hex, '([0-9]*|[A-F]*)' ) ">

                <sequence
                        select="if ($hex = '') then 0 else ( $dec * u:hexToDec2(16, string-length($hex) - 1) + u:hexToDec(substring($hex,2)) )"/>

            </when>

            <otherwise>

                <message>Provided value is not hexadecimal...</message>

                <sequence select="0"/>

            </otherwise>

        </choose>


    </function>
    <function xmlns="http://www.w3.org/1999/XSL/Transform" xmlns:xi="http://www.w3.org/2001/XInclude" name="u:hexToDec2"
              as="xs:double">


        <param name="base" as="xs:decimal"/>

        <param name="exp" as="xs:decimal"/>


        <sequence
                select="if ($exp lt 0) then u:hexToDec2(1.0 div $base, -$exp) else if ($exp eq 0) then 1e0 else $base * u:hexToDec2($base, $exp - 1)"/>


    </function>
    <function xmlns="http://www.w3.org/1999/XSL/Transform" xmlns:xi="http://www.w3.org/2001/XInclude"
              name="u:checkCIGLinea" as="xs:boolean">


        <param name="arg" as="item()*"/>


        <variable name="long" select="string-join(u:checkCIGLineaAlg($arg) ,'')"/>

        <variable name="short" select="string-join(distinct-values(u:checkCIGLineaAlg($arg)),'')"/>


        <value-of select="if ( xs:string($long) eq xs:string($short) ) then true() else false()"/>


    </function>
    <function xmlns="http://www.w3.org/1999/XSL/Transform" xmlns:xi="http://www.w3.org/2001/XInclude"
              name="u:divisoNumeroZeri" as="xs:string">


        <param name="arg" as="xs:string?"/>


        <value-of select="xs:string(xs:integer($arg) div 4)"/>


    </function>
    <function xmlns="http://www.w3.org/1999/XSL/Transform" xmlns:xi="http://www.w3.org/2001/XInclude"
              name="u:checkCIGLineaAlg" as="xs:string*">


        <param name="arg" as="item()*"/>


        <for-each select="$arg">


            <variable name="countRiga" select="position()"/>


            <for-each select="./cac:Item/cac:ItemSpecificationDocumentReference">


                <value-of
                        select="      if  (u:isCIG(u:normalizaCIG(./cbc:ID))) then (        format-number($countRiga, '0000')       ) else ''         "/>


            </for-each>


        </for-each>

    </function>
    <function xmlns="http://www.w3.org/1999/XSL/Transform" xmlns:xi="http://www.w3.org/2001/XInclude" name="u:checkPIVA"
              as="xs:integer">


        <param name="arg" as="xs:string?"/>


        <sequence
                select="     if (not($arg castable as xsd:integer))       then 1      else ( u:addPIVA($arg,xs:integer(0)) mod 10 )"/>


    </function>
    <function xmlns="http://www.w3.org/1999/XSL/Transform" xmlns:xi="http://www.w3.org/2001/XInclude" name="u:addPIVA"
              as="xs:integer">


        <param name="arg" as="xs:string"/>

        <param name="pari" as="xs:integer"/>


        <variable name="tappo" select="if (not($arg castable as xsd:integer)) then 0 else 1"/>


        <variable name="mapper"
                  select="if ($tappo = 0) then 0 else                    ( if ($pari = 1)                     then ( xs:integer(substring('0246813579', ( xs:integer(substring($arg,1,1)) +1 ) ,1)) )                     else ( xs:integer(substring($arg,1,1) ) )                   )"/>


        <sequence
                select="if ($tappo = 0) then $mapper else ( xs:integer($mapper) + u:addPIVA(substring(xs:string($arg),2), (if($pari=0) then 1 else 0) ) )"/>


    </function>
    <function xmlns="http://www.w3.org/1999/XSL/Transform" xmlns:xi="http://www.w3.org/2001/XInclude"
              name="u:checkPIVAseIT" as="xs:boolean">


        <param name="arg" as="xs:string"/>


        <variable name="paese" select="substring($arg,1,2)"/>

        <variable name="codice" select="substring($arg,3)"/>


        <sequence
                select="     if ( $paese = 'IT' or $paese = 'it' )    then    (     if ( ( string-length($codice) = 11 ) and ( if (u:checkPIVA($codice)!=0) then false() else true() ))     then      (      true()     )     else     (      false()     )    )    else    (     true()    )    "/>


    </function>
    <function xmlns="http://www.w3.org/1999/XSL/Transform" xmlns:xi="http://www.w3.org/2001/XInclude" name="u:checkCF"
              as="xs:boolean">


        <param name="arg" as="xs:string?"/>


        <sequence
                select="    if ( (string-length($arg) = 16) or (string-length($arg) = 11) )       then     (     if ((string-length($arg) = 16))      then     (      if (u:checkCF16($arg))       then      (       true()      )      else      (       false()      )     )     else     (      if(($arg castable as xsd:integer)) then true() else false()       )    )    else    (     false()    )    "/>


    </function>
    <function xmlns="http://www.w3.org/1999/XSL/Transform" xmlns:xi="http://www.w3.org/2001/XInclude" name="u:checkCF16"
              as="xs:boolean">


        <param name="arg" as="xs:string?"/>


        <variable name="allowed-characters">ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz</variable>


        <sequence
                select="      if (  (string-length(translate(substring($arg,1,6), $allowed-characters, '')) = 0) and                (substring($arg,7,2) castable as xsd:integer) and         (string-length(translate(substring($arg,9,1), $allowed-characters, '')) = 0) and         (substring($arg,10,2) castable as xsd:integer) and          (substring($arg,12,3) castable as xsd:string) and         (substring($arg,15,1) castable as xsd:integer) and          (string-length(translate(substring($arg,16,1), $allowed-characters, '')) = 0)       )       then true()      else false()      "/>


    </function>
    <function xmlns="http://www.w3.org/1999/XSL/Transform" xmlns:xi="http://www.w3.org/2001/XInclude" name="u:checkCF11"
              as="xs:boolean">


        <param name="arg" as="xs:string?"/>


        <sequence
                select="      if ( ($arg castable as xsd:integer) and (string-length($arg) = 11) )       then true()      else false()      "/>


    </function>
    <function xmlns="http://www.w3.org/1999/XSL/Transform" xmlns:xi="http://www.w3.org/2001/XInclude"
              name="u:checkCodiceIPA" as="xs:boolean">


        <param name="arg" as="xs:string?"/>


        <variable name="allowed-characters">ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789</variable>


        <sequence
                select="if ( (string-length(translate($arg, $allowed-characters, '')) = 0) and (string-length($arg) = 6) ) then true() else false()"/>


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
        <axsl:variable name="preceding"
                       select="count(preceding-sibling::*[local-name()=local-name(current())                                   and namespace-uri() = namespace-uri(current())])"/>
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
        <axsl:value-of
                select="concat('.processing-instruction-', 1+count(preceding-sibling::processing-instruction()), '-')"/>
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
        <svrl:schematron-output xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                title="Rules for PEPPOL Order transaction 3.0" schemaVersion="iso">
            <axsl:comment>
                <axsl:value-of select="$archiveDirParameter"/>  
                <axsl:value-of select="$archiveNameParameter"/>  
                <axsl:value-of select="$fileNameParameter"/>  
                <axsl:value-of select="$fileDirParameter"/>
            </axsl:comment>
            <svrl:ns-prefix-in-attribute-values
                    uri="urn:oasis:names:specification:ubl:schema:xsd:CommonBasicComponents-2" prefix="cbc"/>
            <svrl:ns-prefix-in-attribute-values
                    uri="urn:oasis:names:specification:ubl:schema:xsd:CommonAggregateComponents-2" prefix="cac"/>
            <svrl:ns-prefix-in-attribute-values uri="urn:oasis:names:specification:ubl:schema:xsd:Order-2"
                                                prefix="ubl"/>
            <svrl:ns-prefix-in-attribute-values uri="http://www.w3.org/2001/XMLSchema" prefix="xs"/>
            <svrl:ns-prefix-in-attribute-values uri="utils" prefix="u"/>
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
                <axsl:apply-templates/>
            </svrl:active-pattern>
            <axsl:apply-templates select="/" mode="M12"/>
            <svrl:active-pattern>
                <axsl:attribute name="document">
                    <axsl:value-of select="document-uri(/)"/>
                </axsl:attribute>
                <axsl:apply-templates/>
            </svrl:active-pattern>
            <axsl:apply-templates select="/" mode="M13"/>
            <svrl:active-pattern>
                <axsl:attribute name="document">
                    <axsl:value-of select="document-uri(/)"/>
                </axsl:attribute>
                <axsl:attribute name="id">getAbstractTipoOrdine</axsl:attribute>
                <axsl:attribute name="name">getAbstractTipoOrdine</axsl:attribute>
                <axsl:apply-templates/>
            </svrl:active-pattern>
            <axsl:apply-templates select="/" mode="M38"/>
            <svrl:active-pattern>
                <axsl:attribute name="document">
                    <axsl:value-of select="document-uri(/)"/>
                </axsl:attribute>
                <axsl:attribute name="id">verificaID</axsl:attribute>
                <axsl:attribute name="name">verificaID</axsl:attribute>
                <axsl:apply-templates/>
            </svrl:active-pattern>
            <axsl:apply-templates select="/" mode="M39"/>
            <svrl:active-pattern>
                <axsl:attribute name="document">
                    <axsl:value-of select="document-uri(/)"/>
                </axsl:attribute>
                <axsl:attribute name="id">verificaLineeOrdine</axsl:attribute>
                <axsl:attribute name="name">verificaLineeOrdine</axsl:attribute>
                <axsl:apply-templates/>
            </svrl:active-pattern>
            <axsl:apply-templates select="/" mode="M40"/>
            <svrl:active-pattern>
                <axsl:attribute name="document">
                    <axsl:value-of select="document-uri(/)"/>
                </axsl:attribute>
                <axsl:attribute name="id">verificaCIG</axsl:attribute>
                <axsl:attribute name="name">verificaCIG</axsl:attribute>
                <axsl:apply-templates/>
            </svrl:active-pattern>
            <axsl:apply-templates select="/" mode="M41"/>
            <svrl:active-pattern>
                <axsl:attribute name="document">
                    <axsl:value-of select="document-uri(/)"/>
                </axsl:attribute>
                <axsl:attribute name="id">verificaPIVA</axsl:attribute>
                <axsl:attribute name="name">verificaPIVA</axsl:attribute>
                <axsl:apply-templates/>
            </svrl:active-pattern>
            <axsl:apply-templates select="/" mode="M42"/>
            <svrl:active-pattern>
                <axsl:attribute name="document">
                    <axsl:value-of select="document-uri(/)"/>
                </axsl:attribute>
                <axsl:attribute name="id">verificaCodiceIPA</axsl:attribute>
                <axsl:attribute name="name">verificaCodiceIPA</axsl:attribute>
                <axsl:apply-templates/>
            </svrl:active-pattern>
            <axsl:apply-templates select="/" mode="M43"/>
            <svrl:active-pattern>
                <axsl:attribute name="document">
                    <axsl:value-of select="document-uri(/)"/>
                </axsl:attribute>
                <axsl:attribute name="id">verificaCF</axsl:attribute>
                <axsl:attribute name="name">verificaCF</axsl:attribute>
                <axsl:apply-templates/>
            </svrl:active-pattern>
            <axsl:apply-templates select="/" mode="M44"/>
            <svrl:active-pattern>
                <axsl:attribute name="document">
                    <axsl:value-of select="document-uri(/)"/>
                </axsl:attribute>
                <axsl:attribute name="id">verificaBuyer</axsl:attribute>
                <axsl:attribute name="name">verificaBuyer</axsl:attribute>
                <axsl:apply-templates/>
            </svrl:active-pattern>
            <axsl:apply-templates select="/" mode="M45"/>
            <svrl:active-pattern>
                <axsl:attribute name="document">
                    <axsl:value-of select="document-uri(/)"/>
                </axsl:attribute>
                <axsl:attribute name="id">IT-UBL-T01</axsl:attribute>
                <axsl:attribute name="name">IT-UBL-T01</axsl:attribute>
                <axsl:apply-templates/>
            </svrl:active-pattern>
            <axsl:apply-templates select="/" mode="M46"/>
        </svrl:schematron-output>
    </axsl:template>

    <!--SCHEMATRON PATTERNS-->

    <svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">Rules for PEPPOL Order transaction 3.0</svrl:text>

    <!--PATTERN -->


    <!--RULE -->

    <axsl:template match="//*[not(*) and not(normalize-space())]" priority="1000" mode="M10">
        <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="//*[not(*) and not(normalize-space())]"/>

        <!--ASSERT -->

        <axsl:choose>
            <axsl:when test="false()"/>
            <axsl:otherwise>
                <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="false()">
                    <axsl:attribute name="id">PEPPOL-COMMON-R001</axsl:attribute>
                    <axsl:attribute name="flag">fatal</axsl:attribute>
                    <axsl:attribute name="location">
                        <axsl:apply-templates select="." mode="schematron-select-full-path"/>
                    </axsl:attribute>
                    <svrl:text>Document MUST not contain empty elements.</svrl:text>
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

    <axsl:template match="/*" priority="1003" mode="M11">
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
        <axsl:apply-templates select="@*|*" mode="M11"/>
    </axsl:template>

    <!--RULE -->

    <axsl:template
            match="cbc:IssueDate | cbc:DueDate | cbc:TaxPointDate | cbc:StartDate | cbc:EndDate | cbc:ActualDeliveryDate"
            priority="1002" mode="M11">
        <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                         context="cbc:IssueDate | cbc:DueDate | cbc:TaxPointDate | cbc:StartDate | cbc:EndDate | cbc:ActualDeliveryDate"/>

        <!--ASSERT -->

        <axsl:choose>
            <axsl:when test="(string(.) castable as xs:date) and (string-length(.) = 10)"/>
            <axsl:otherwise>
                <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                    test="(string(.) castable as xs:date) and (string-length(.) = 10)">
                    <axsl:attribute name="id">PEPPOL-COMMON-R030</axsl:attribute>
                    <axsl:attribute name="flag">fatal</axsl:attribute>
                    <axsl:attribute name="location">
                        <axsl:apply-templates select="." mode="schematron-select-full-path"/>
                    </axsl:attribute>
                    <svrl:text>A date must be formatted YYYY-MM-DD.</svrl:text>
                </svrl:failed-assert>
            </axsl:otherwise>
        </axsl:choose>
        <axsl:apply-templates select="@*|*" mode="M11"/>
    </axsl:template>

    <!--RULE -->

    <axsl:template
            match="cbc:EndpointID[@schemeID = '0088'] | cac:PartyIdentification/cbc:ID[@schemeID = '0088'] | cbc:CompanyID[@schemeID = '0088']"
            priority="1001" mode="M11">
        <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                         context="cbc:EndpointID[@schemeID = '0088'] | cac:PartyIdentification/cbc:ID[@schemeID = '0088'] | cbc:CompanyID[@schemeID = '0088']"/>

        <!--ASSERT -->

        <axsl:choose>
            <axsl:when test="matches(normalize-space(), '^[0-9]+$') and u:gln(normalize-space())"/>
            <axsl:otherwise>
                <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                    test="matches(normalize-space(), '^[0-9]+$') and u:gln(normalize-space())">
                    <axsl:attribute name="id">PEPPOL-COMMON-R040</axsl:attribute>
                    <axsl:attribute name="flag">fatal</axsl:attribute>
                    <axsl:attribute name="location">
                        <axsl:apply-templates select="." mode="schematron-select-full-path"/>
                    </axsl:attribute>
                    <svrl:text>GLN must have a valid format according to GS1 rules.</svrl:text>
                </svrl:failed-assert>
            </axsl:otherwise>
        </axsl:choose>
        <axsl:apply-templates select="@*|*" mode="M11"/>
    </axsl:template>

    <!--RULE -->

    <axsl:template
            match="cbc:EndpointID[@schemeID = '0192'] | cac:PartyIdentification/cbc:ID[@schemeID = '0192'] | cbc:CompanyID[@schemeID = '0192']"
            priority="1000" mode="M11">
        <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                         context="cbc:EndpointID[@schemeID = '0192'] | cac:PartyIdentification/cbc:ID[@schemeID = '0192'] | cbc:CompanyID[@schemeID = '0192']"/>

        <!--ASSERT -->

        <axsl:choose>
            <axsl:when test="matches(normalize-space(), '^[0-9]{9}$') and u:mod11(normalize-space())"/>
            <axsl:otherwise>
                <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                    test="matches(normalize-space(), '^[0-9]{9}$') and u:mod11(normalize-space())">
                    <axsl:attribute name="id">PEPPOL-COMMON-R041</axsl:attribute>
                    <axsl:attribute name="flag">fatal</axsl:attribute>
                    <axsl:attribute name="location">
                        <axsl:apply-templates select="." mode="schematron-select-full-path"/>
                    </axsl:attribute>
                    <svrl:text>Norwegian organization number MUST be stated in the correct format.</svrl:text>
                </svrl:failed-assert>
            </axsl:otherwise>
        </axsl:choose>
        <axsl:apply-templates select="@*|*" mode="M11"/>
    </axsl:template>
    <axsl:template match="text()" priority="-1" mode="M11"/>
    <axsl:template match="@*|node()" priority="-2" mode="M11">
        <axsl:apply-templates select="@*|*" mode="M11"/>
    </axsl:template>

    <!--PATTERN -->

    <axsl:variable name="clUNCL1001_T01" select="tokenize('220 227', '\s')"/>
    <axsl:variable name="cleas"
                   select="tokenize('0002 0007 0009 0037 0060 0088 0096 0097 0106 0130 0135 0142 0151 0183 0184 0190 0191 0192 0193 0195 0196 0198 0199 0200 0201 0202 0204 0208 0209 0210 0211 0212 0213 9901 9906 9907 9910 9913 9914 9915 9918 9919 9920 9922 9923 9924 9925 9926 9927 9928 9929 9930 9931 9932 9933 9934 9935 9936 9937 9938 9939 9940 9941 9942 9943 9944 9945 9946 9947 9948 9949 9950 9951 9952 9953 9955 9957', '\s')"/>
    <axsl:variable name="clTrueFalse" select="tokenize('true false', '\s')"/>
    <axsl:variable name="clISO4217"
                   select="tokenize('AED AFN ALL AMD ANG AOA ARS AUD AWG AZN BAM BBD BDT BGN BHD BIF BMD BND BOB BOV BRL BSD BTN BWP BYN BZD CAD CDF CHE CHF CHW CLF CLP CNY COP COU CRC CUC CUP CVE CZK DJF DKK DOP DZD EGP ERN ETB EUR FJD FKP GBP GEL GHS GIP GMD GNF GTQ GYD HKD HNL HRK HTG HUF IDR ILS INR IQD IRR ISK JMD JOD JPY KES KGS KHR KMF KPW KRW KWD KYD KZT LAK LBP LKR LRD LSL LYD MAD MDL MGA MKD MMK MNT MOP MRU MUR MVR MWK MXN MXV MYR MZN NAD NGN NIO NOK NPR NZD OMR PAB PEN PGK PHP PKR PLN PYG QAR RON RSD RUB RWF SAR SBD SCR SDG SEK SGD SHP SLL SOS SRD SSP STN SVC SYP SZL THB TJS TMT TND TOP TRY TTD TWD TZS UAH UGX USD USN UYI UYU UZS VEF VND VUV WST XAF XAG XAU XBA XBB XBC XBD XCD XDR XOF XPD XPF XPT XSU XTS XUA YER ZAR ZMW ZWL', '\s')"/>
    <axsl:variable name="clUNCL5189"
                   select="tokenize('41 42 60 62 63 64 65 66 67 68 70 71 88 95 100 102 103 104 105', '\s')"/>
    <axsl:variable name="clUNCL5305" select="tokenize('AE E S Z G O K L M', '\s')"/>
    <axsl:variable name="clUNCL7143"
                   select="tokenize('AA AB AC AD AE AF AG AH AI AJ AK AL AM AN AO AP AQ AR AS AT AU AV AW AX AY AZ BA BB BC BD BE BF BG BH BI BJ BK BL BM BN BO BP BQ BR BS BT BU BV BW BX BY BZ CC CG CL CR CV DR DW EC EF EN FS GB GN GS HS IB IN IS IT IZ MA MF MN MP NB ON PD PL PO PV QS RC RN RU RY SA SG SK SN SRS SRT SRU SRV SRW SRX SRY SRZ SS SSA SSB SSC SSD SSE SSF SSG SSH SSI SSJ SSK SSL SSM SSN SSO SSP SSQ SSR SSS SST SSU SSV SSW SSX SSY SSZ ST STA STB STC STD STE STF STG STH STI STJ STK STL STM STN STO STP STQ STR STS STT STU STV STW STX STY STZ SUA SUB SUC SUD SUE SUF SUG SUH SUI SUJ SUK SUL SUM TG TSN TSO TSP TSP TSQ TSR TSS TST TSU UA UP VN VP VS VX ZZZ', '\s')"/>
    <axsl:variable name="clUNECERec20"
                   select="tokenize('10 11 13 14 15 20 21 22 23 24 25 27 28 33 34 35 37 38 40 41 56 57 58 59 60 61 74 77 80 81 85 87 89 91 1I 2A 2B 2C 2G 2H 2I 2J 2K 2L 2M 2N 2P 2Q 2R 2U 2X 2Y 2Z 3B 3C 4C 4G 4H 4K 4L 4M 4N 4O 4P 4Q 4R 4T 4U 4W 4X 5A 5B 5E 5J A10 A11 A12 A13 A14 A15 A16 A17 A18 A19 A2 A20 A21 A22 A23 A24 A26 A27 A28 A29 A3 A30 A31 A32 A33 A34 A35 A36 A37 A38 A39 A4 A40 A41 A42 A43 A44 A45 A47 A48 A49 A5 A53 A54 A55 A56 A59 A6 A68 A69 A7 A70 A71 A73 A74 A75 A76 A8 A84 A85 A86 A87 A88 A89 A9 A90 A91 A93 A94 A95 A96 A97 A98 A99 AA AB ACR ACT AD AE AH AI AK AL AMH AMP ANN APZ AQ AS ASM ASU ATM AWG AY AZ B1 B10 B11 B12 B13 B14 B15 B16 B17 B18 B19 B20 B21 B22 B23 B24 B25 B26 B27 B28 B29 B3 B30 B31 B32 B33 B34 B35 B4 B41 B42 B43 B44 B45 B46 B47 B48 B49 B50 B52 B53 B54 B55 B56 B57 B58 B59 B60 B61 B62 B63 B64 B66 B67 B68 B69 B7 B70 B71 B72 B73 B74 B75 B76 B77 B78 B79 B8 B80 B81 B82 B83 B84 B85 B86 B87 B88 B89 B90 B91 B92 B93 B94 B95 B96 B97 B98 B99 BAR BB BFT BHP BIL BLD BLL BP BPM BQL BTU BUA BUI C0 C10 C11 C12 C13 C14 C15 C16 C17 C18 C19 C20 C21 C22 C23 C24 C25 C26 C27 C28 C29 C3 C30 C31 C32 C33 C34 C35 C36 C37 C38 C39 C40 C41 C42 C43 C44 C45 C46 C47 C48 C49 C50 C51 C52 C53 C54 C55 C56 C57 C58 C59 C60 C61 C62 C63 C64 C65 C66 C67 C68 C69 C7 C70 C71 C72 C73 C74 C75 C76 C78 C79 C8 C80 C81 C82 C83 C84 C85 C86 C87 C88 C89 C9 C90 C91 C92 C93 C94 C95 C96 C97 C99 CCT CDL CEL CEN CG CGM CKG CLF CLT CMK CMQ CMT CNP CNT COU CTG CTM CTN CUR CWA CWI D03 D04 D1 D10 D11 D12 D13 D15 D16 D17 D18 D19 D2 D20 D21 D22 D23 D24 D25 D26 D27 D29 D30 D31 D32 D33 D34 D36 D41 D42 D43 D44 D45 D46 D47 D48 D49 D5 D50 D51 D52 D53 D54 D55 D56 D57 D58 D59 D6 D60 D61 D62 D63 D65 D68 D69 D73 D74 D77 D78 D80 D81 D82 D83 D85 D86 D87 D88 D89 D91 D93 D94 D95 DAA DAD DAY DB DBM DBW DD DEC DG DJ DLT DMA DMK DMO DMQ DMT DN DPC DPR DPT DRA DRI DRL DT DTN DWT DZN DZP E01 E07 E08 E09 E10 E12 E14 E15 E16 E17 E18 E19 E20 E21 E22 E23 E25 E27 E28 E30 E31 E32 E33 E34 E35 E36 E37 E38 E39 E4 E40 E41 E42 E43 E44 E45 E46 E47 E48 E49 E50 E51 E52 E53 E54 E55 E56 E57 E58 E59 E60 E61 E62 E63 E64 E65 E66 E67 E68 E69 E70 E71 E72 E73 E74 E75 E76 E77 E78 E79 E80 E81 E82 E83 E84 E85 E86 E87 E88 E89 E90 E91 E92 E93 E94 E95 E96 E97 E98 E99 EA EB EQ F01 F02 F03 F04 F05 F06 F07 F08 F10 F11 F12 F13 F14 F15 F16 F17 F18 F19 F20 F21 F22 F23 F24 F25 F26 F27 F28 F29 F30 F31 F32 F33 F34 F35 F36 F37 F38 F39 F40 F41 F42 F43 F44 F45 F46 F47 F48 F49 F50 F51 F52 F53 F54 F55 F56 F57 F58 F59 F60 F61 F62 F63 F64 F65 F66 F67 F68 F69 F70 F71 F72 F73 F74 F75 F76 F77 F78 F79 F80 F81 F82 F83 F84 F85 F86 F87 F88 F89 F90 F91 F92 F93 F94 F95 F96 F97 F98 F99 FAH FAR FBM FC FF FH FIT FL FNU FOT FP FR FS FTK FTQ G01 G04 G05 G06 G08 G09 G10 G11 G12 G13 G14 G15 G16 G17 G18 G19 G2 G20 G21 G23 G24 G25 G26 G27 G28 G29 G3 G30 G31 G32 G33 G34 G35 G36 G37 G38 G39 G40 G41 G42 G43 G44 G45 G46 G47 G48 G49 G50 G51 G52 G53 G54 G55 G56 G57 G58 G59 G60 G61 G62 G63 G64 G65 G66 G67 G68 G69 G70 G71 G72 G73 G74 G75 G76 G77 G78 G79 G80 G81 G82 G83 G84 G85 G86 G87 G88 G89 G90 G91 G92 G93 G94 G95 G96 G97 G98 G99 GB GBQ GDW GE GF GFI GGR GIA GIC GII GIP GJ GL GLD GLI GLL GM GO GP GQ GRM GRN GRO GV GWH H03 H04 H05 H06 H07 H08 H09 H10 H11 H12 H13 H14 H15 H16 H18 H19 H20 H21 H22 H23 H24 H25 H26 H27 H28 H29 H30 H31 H32 H33 H34 H35 H36 H37 H38 H39 H40 H41 H42 H43 H44 H45 H46 H47 H48 H49 H50 H51 H52 H53 H54 H55 H56 H57 H58 H59 H60 H61 H62 H63 H64 H65 H66 H67 H68 H69 H70 H71 H72 H73 H74 H75 H76 H77 H79 H80 H81 H82 H83 H84 H85 H87 H88 H89 H90 H91 H92 H93 H94 H95 H96 H98 H99 HA HAD HBA HBX HC HDW HEA HGM HH HIU HKM HLT HM HMO HMQ HMT HPA HTZ HUR IA IE INH INK INQ ISD IU IV J10 J12 J13 J14 J15 J16 J17 J18 J19 J2 J20 J21 J22 J23 J24 J25 J26 J27 J28 J29 J30 J31 J32 J33 J34 J35 J36 J38 J39 J40 J41 J42 J43 J44 J45 J46 J47 J48 J49 J50 J51 J52 J53 J54 J55 J56 J57 J58 J59 J60 J61 J62 J63 J64 J65 J66 J67 J68 J69 J70 J71 J72 J73 J74 J75 J76 J78 J79 J81 J82 J83 J84 J85 J87 J90 J91 J92 J93 J95 J96 J97 J98 J99 JE JK JM JNT JOU JPS JWL K1 K10 K11 K12 K13 K14 K15 K16 K17 K18 K19 K2 K20 K21 K22 K23 K26 K27 K28 K3 K30 K31 K32 K33 K34 K35 K36 K37 K38 K39 K40 K41 K42 K43 K45 K46 K47 K48 K49 K50 K51 K52 K53 K54 K55 K58 K59 K6 K60 K61 K62 K63 K64 K65 K66 K67 K68 K69 K70 K71 K73 K74 K75 K76 K77 K78 K79 K80 K81 K82 K83 K84 K85 K86 K87 K88 K89 K90 K91 K92 K93 K94 K95 K96 K97 K98 K99 KA KAT KB KBA KCC KDW KEL KGM KGS KHY KHZ KI KIC KIP KJ KJO KL KLK KLX KMA KMH KMK KMQ KMT KNI KNM KNS KNT KO KPA KPH KPO KPP KR KSD KSH KT KTN KUR KVA KVR KVT KW KWH KWO KWT KWY KX L10 L11 L12 L13 L14 L15 L16 L17 L18 L19 L2 L20 L21 L23 L24 L25 L26 L27 L28 L29 L30 L31 L32 L33 L34 L35 L36 L37 L38 L39 L40 L41 L42 L43 L44 L45 L46 L47 L48 L49 L50 L51 L52 L53 L54 L55 L56 L57 L58 L59 L60 L63 L64 L65 L66 L67 L68 L69 L70 L71 L72 L73 L74 L75 L76 L77 L78 L79 L80 L81 L82 L83 L84 L85 L86 L87 L88 L89 L90 L91 L92 L93 L94 L95 L96 L98 L99 LA LAC LBR LBT LD LEF LF LH LK LM LN LO LP LPA LR LS LTN LTR LUB LUM LUX LY M1 M10 M11 M12 M13 M14 M15 M16 M17 M18 M19 M20 M21 M22 M23 M24 M25 M26 M27 M29 M30 M31 M32 M33 M34 M35 M36 M37 M38 M39 M4 M40 M41 M42 M43 M44 M45 M46 M47 M48 M49 M5 M50 M51 M52 M53 M55 M56 M57 M58 M59 M60 M61 M62 M63 M64 M65 M66 M67 M68 M69 M7 M70 M71 M72 M73 M74 M75 M76 M77 M78 M79 M80 M81 M82 M83 M84 M85 M86 M87 M88 M89 M9 M90 M91 M92 M93 M94 M95 M96 M97 M98 M99 MAH MAL MAM MAR MAW MBE MBF MBR MC MCU MD MGM MHZ MIK MIL MIN MIO MIU MKD MKM MKW MLD MLT MMK MMQ MMT MND MNJ MON MPA MQD MQH MQM MQS MQW MRD MRM MRW MSK MTK MTQ MTR MTS MTZ MVA MWH N1 N10 N11 N12 N13 N14 N15 N16 N17 N18 N19 N20 N21 N22 N23 N24 N25 N26 N27 N28 N29 N3 N30 N31 N32 N33 N34 N35 N36 N37 N38 N39 N40 N41 N42 N43 N44 N45 N46 N47 N48 N49 N50 N51 N52 N53 N54 N55 N56 N57 N58 N59 N60 N61 N62 N63 N64 N65 N66 N67 N68 N69 N70 N71 N72 N73 N74 N75 N76 N77 N78 N79 N80 N81 N82 N83 N84 N85 N86 N87 N88 N89 N90 N91 N92 N93 N94 N95 N96 N97 N98 N99 NA NAR NCL NEW NF NIL NIU NL NM3 NMI NMP NPT NT NTU NU NX OA ODE OHM ON ONZ OPM OT OZA OZI P1 P10 P11 P12 P13 P14 P15 P16 P17 P18 P19 P2 P20 P21 P22 P23 P24 P25 P26 P27 P28 P29 P30 P31 P32 P33 P34 P35 P36 P37 P38 P39 P40 P41 P42 P43 P44 P45 P46 P47 P48 P49 P5 P50 P51 P52 P53 P54 P55 P56 P57 P58 P59 P60 P61 P62 P63 P64 P65 P66 P67 P68 P69 P70 P71 P72 P73 P74 P75 P76 P77 P78 P79 P80 P81 P82 P83 P84 P85 P86 P87 P88 P89 P90 P91 P92 P93 P94 P95 P96 P97 P98 P99 PAL PD PFL PGL PI PLA PO PQ PR PS PTD PTI PTL PTN Q10 Q11 Q12 Q13 Q14 Q15 Q16 Q17 Q18 Q19 Q20 Q21 Q22 Q23 Q24 Q25 Q26 Q27 Q28 Q29 Q30 Q31 Q32 Q33 Q34 Q35 Q36 Q37 Q38 Q39 Q40 Q3 QA QAN QB QR QTD QTI QTL QTR R1 R9 RH RM ROM RP RPM RPS RT S3 S4 SAN SCO SCR SEC SET SG SIE SM3 SMI SQ SQR SR STC STI STK STL STN STW SW SX SYR T0 T3 TAH TAN TI TIC TIP TKM TMS TNE TP TPI TPR TQD TRL TST TTS U1 U2 UB UC VA VLT VP W2 WA WB WCD WE WEB WEE WG WHR WM WSD WTT X1 YDK YDQ YRD Z11 Z9 ZP ZZ X1A X1B X1D X1F X1G X1W X2C X3A X3H X43 X44 X4A X4B X4C X4D X4F X4G X4H X5H X5L X5M X6H X6P X7A X7B X8A X8B X8C XAA XAB XAC XAD XAE XAF XAG XAH XAI XAJ XAL XAM XAP XAT XAV XB4 XBA XBB XBC XBD XBE XBF XBG XBH XBI XBJ XBK XBL XBM XBN XBO XBP XBQ XBR XBS XBT XBU XBV XBW XBX XBY XBZ XCA XCB XCC XCD XCE XCF XCG XCH XCI XCJ XCK XCL XCM XCN XCO XCP XCQ XCR XCS XCT XCU XCV XCW XCX XCY XCZ XDA XDB XDC XDG XDH XDI XDJ XDK XDL XDM XDN XDP XDR XDS XDT XDU XDV XDW XDX XDY XEC XED XEE XEF XEG XEH XEI XEN XFB XFC XFD XFE XFI XFL XFO XFP XFR XFT XFW XFX XGB XGI XGL XGR XGU XGY XGZ XHA XHB XHC XHG XHN XHR XIA XIB XIC XID XIE XIF XIG XIH XIK XIL XIN XIZ XJB XJC XJG XJR XJT XJY XKG XKI XLE XLG XLT XLU XLV XLZ XMA XMB XMC XME XMR XMS XMT XMW XMX XNA XNE XNF XNG XNS XNT XNU XNV XO1 XO2 XO3 XO4 XO5 XO6 XO7 XO8 XO9 XOA XOB XOC XOD XOE XOF XOG XOH XOI XOK XOJ XOL XOM XON XOP XOQ XOR XOS XOV XOW XOT XOU XOX XOY XOZ XP1 XP2 XP3 XP4 XPA XPB XPC XPD XPE XPF XPG XPH XPI XPJ XPK XPL XPN XPO XPP XPR XPT XPU XPV XPX XPY XPZ XQA XQB XQC XQD XQF XQG XQH XQJ XQK XQL XQM XQN XQP XQQ XQR XQS XRD XRG XRJ XRK XRL XRO XRT XRZ XSA XSB XSC XSD XSE XSH XSI XSK XSL XSM XSO XSP XSS XST XSU XSV XSW XSX XSY XSZ XT1 XTB XTC XTD XTE XTG XTI XTK XTL XTN XTO XTR XTS XTT XTU XTV XTW XTY XTZ XUC XUN XVA XVG XVI XVK XVL XVO XVP XVQ XVN XVR XVS XVY XWA XWB XWC XWD XWF XWG XWH XWJ XWK XWL XWM XWN XWP XWQ XWR XWS XWT XWU XWV XWW XWX XWY XWZ XXA XXB XXC XXD XXF XXG XXH XXJ XXK XYA XYB XYC XYD XYF XYG XYH XYJ XYK XYL XYM XYN XYP XYQ XYR XYS XYT XYV XYW XYX XYY XYZ XZA XZB XZC XZD XZF XZG XZH XZJ XZK XZL XZM XZN XZP XZQ XZR XZS XZT XZU XZV XZW XZX XZY', '\s')"/>
    <axsl:variable name="clISO3166"
                   select="tokenize('AD AE AF AG AI AL AM AO AQ AR AS AT AU AW AX AZ BA BB BD BE BF BG BH BI BJ BL BM BN BO BQ BR BS BT BV BW BY BZ CA CC CD CF CG CH CI CK CL CM CN CO CR CU CV CW CX CY CZ DE DJ DK DM DO DZ EC EE EG EH ER ES ET FI FJ FK FM FO FR GA GB GD GE GF GG GH GI GL GM GN GP GQ GR GS GT GU GW GY HK HM HN HR HT HU ID IE IL IM IN IO IQ IR IS IT JE JM JO JP KE KG KH KI KM KN KP KR KW KY KZ LA LB LC LI LK LR LS LT LU LV LY MA MC MD ME MF MG MH MK ML MM MN MO MP MQ MR MS MT MU MV MW MX MY MZ NA NC NE NF NG NI NL NO NP NR NU NZ OM PA PE PF PG PH PK PL PM PN PR PS PT PW PY QA RE RO RS RU RW SA SB SC SD SE SG SH SI SJ SK SL SM SN SO SR SS ST SV SX SY SZ TC TD TF TG TH TJ TK TL TM TN TO TR TT TV TW TZ UA UG UM US UY UZ VA VC VE VG VI VN VU WF WS YE YT ZA ZM ZW 1A XI', '\s')"/>
    <axsl:variable name="clICD"
                   select="tokenize('0002 0003 0004 0005 0006 0007 0008 0009 0010 0011 0012 0013 0014 0015 0016 0017 0018 0019 0020 0021 0022 0023 0024 0025 0026 0027 0028 0029 0030 0031 0032 0033 0034 0035 0036 0037 0038 0039 0040 0041 0042 0043 0044 0045 0046 0047 0048 0049 0050 0051 0052 0053 0054 0055 0056 0057 0058 0059 0060 0061 0062 0063 0064 0065 0066 0067 0068 0069 0070 0071 0072 0073 0074 0075 0076 0077 0078 0079 0080 0081 0082 0083 0084 0085 0086 0087 0088 0089 0090 0091 0093 0094 0095 0096 0097 0098 0099 0100 0101 0102 0104 0105 0106 0107 0108 0109 0110 0111 0112 0113 0114 0115 0116 0117 0118 0119 0120 0121 0122 0123 0124 0125 0126 0127 0128 0129 0130 0131 0132 0133 0134 0135 0136 0137 0138 0139 0140 0141 0142 0143 0144 0145 0146 0147 0148 0149 0150 0151 0152 0153 0154 0155 0156 0157 0158 0159 0160 0161 0162 0163 0164 0165 0166 0167 0168 0169 0170 0171 0172 0173 0174 0175 0176 0177 0178 0179 0180 0183 0184 0185 0186 0187 0188 0189 0190 0191 0192 0193 0194 0195 0196 0197 0198 0199 0200 0201 0202 0203 0204 0205 0206 0207 0208 0209 0210 0211 0212 0213', '\s')"/>
    <axsl:variable name="clMimeCode"
                   select="tokenize('application/pdf image/png image/jpeg image/tiff application/acad application/dwg drawing/dwg application/vnd.openxmlformats-officedocument.spreadsheetml.sheet application/vnd.oasis.opendocument.spreadsheet', '\s')"/>
    <axsl:variable name="clUNCL7161"
                   select="tokenize('AA AAA AAC AAD AAE AAF AAH AAI AAS AAT AAV AAY AAZ ABA ABB ABC ABD ABF ABK ABL ABN ABR ABS ABT ABU ACF ACG ACH ACI ACJ ACK ACL ACM ACS ADC ADE ADJ ADK ADL ADM ADN ADO ADP ADQ ADR ADT ADW ADY ADZ AEA AEB AEC AED AEF AEH AEI AEJ AEK AEL AEM AEN AEO AEP AES AET AEU AEV AEW AEX AEY AEZ AJ AU CA CAB CAD CAE CAF CAI CAJ CAK CAL CAM CAN CAO CAP CAQ CAR CAS CAT CAU CAV CAW CD CG CS CT DAB DAD DL EG EP ER FAA FAB FAC FC FH FI GAA HAA HD HH IAA IAB ID IF IR IS KO L1 LA LAA LAB LF MAE MI ML NAA OA PA PAA PC PL RAB RAC RAD RAF RE RF RH RV SA SAA SAD SAE SAI SG SH SM SU TAB TAC TT TV V1 V2 WH XAA YY ZZZ', '\s')"/>

    <!--RULE -->

    <axsl:template match="/ubl:Order" priority="1338" mode="M12">
        <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="/ubl:Order"/>

        <!--ASSERT -->

        <axsl:choose>
            <axsl:when test="cbc:CustomizationID"/>
            <axsl:otherwise>
                <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="cbc:CustomizationID">
                    <axsl:attribute name="id">PEPPOL-T01-B00101</axsl:attribute>
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
                    <axsl:attribute name="id">PEPPOL-T01-B00102</axsl:attribute>
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
                    <axsl:attribute name="id">PEPPOL-T01-B00103</axsl:attribute>
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
                    <axsl:attribute name="id">PEPPOL-T01-B00104</axsl:attribute>
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
            <axsl:when test="cbc:DocumentCurrencyCode"/>
            <axsl:otherwise>
                <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="cbc:DocumentCurrencyCode">
                    <axsl:attribute name="id">PEPPOL-T01-B00105</axsl:attribute>
                    <axsl:attribute name="flag">fatal</axsl:attribute>
                    <axsl:attribute name="location">
                        <axsl:apply-templates select="." mode="schematron-select-full-path"/>
                    </axsl:attribute>
                    <svrl:text>Element 'cbc:DocumentCurrencyCode' MUST be provided.</svrl:text>
                </svrl:failed-assert>
            </axsl:otherwise>
        </axsl:choose>

        <!--ASSERT -->

        <axsl:choose>
            <axsl:when test="cac:BuyerCustomerParty"/>
            <axsl:otherwise>
                <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="cac:BuyerCustomerParty">
                    <axsl:attribute name="id">PEPPOL-T01-B00106</axsl:attribute>
                    <axsl:attribute name="flag">fatal</axsl:attribute>
                    <axsl:attribute name="location">
                        <axsl:apply-templates select="." mode="schematron-select-full-path"/>
                    </axsl:attribute>
                    <svrl:text>Element 'cac:BuyerCustomerParty' MUST be provided.</svrl:text>
                </svrl:failed-assert>
            </axsl:otherwise>
        </axsl:choose>

        <!--ASSERT -->

        <axsl:choose>
            <axsl:when test="cac:SellerSupplierParty"/>
            <axsl:otherwise>
                <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="cac:SellerSupplierParty">
                    <axsl:attribute name="id">PEPPOL-T01-B00107</axsl:attribute>
                    <axsl:attribute name="flag">fatal</axsl:attribute>
                    <axsl:attribute name="location">
                        <axsl:apply-templates select="." mode="schematron-select-full-path"/>
                    </axsl:attribute>
                    <svrl:text>Element 'cac:SellerSupplierParty' MUST be provided.</svrl:text>
                </svrl:failed-assert>
            </axsl:otherwise>
        </axsl:choose>

        <!--ASSERT -->

        <axsl:choose>
            <axsl:when test="cac:OrderLine"/>
            <axsl:otherwise>
                <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="cac:OrderLine">
                    <axsl:attribute name="id">PEPPOL-T01-B00108</axsl:attribute>
                    <axsl:attribute name="flag">fatal</axsl:attribute>
                    <axsl:attribute name="location">
                        <axsl:apply-templates select="." mode="schematron-select-full-path"/>
                    </axsl:attribute>
                    <svrl:text>Element 'cac:OrderLine' MUST be provided.</svrl:text>
                </svrl:failed-assert>
            </axsl:otherwise>
        </axsl:choose>

        <!--ASSERT -->

        <axsl:choose>
            <axsl:when test="not(@*:schemaLocation)"/>
            <axsl:otherwise>
                <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(@*:schemaLocation)">
                    <axsl:attribute name="id">PEPPOL-T01-B00109</axsl:attribute>
                    <axsl:attribute name="flag">fatal</axsl:attribute>
                    <axsl:attribute name="location">
                        <axsl:apply-templates select="." mode="schematron-select-full-path"/>
                    </axsl:attribute>
                    <svrl:text>Document MUST not contain schema location.</svrl:text>
                </svrl:failed-assert>
            </axsl:otherwise>
        </axsl:choose>
        <axsl:apply-templates select="@*|*" mode="M12"/>
    </axsl:template>

    <!--RULE -->

    <axsl:template match="/ubl:Order/cbc:CustomizationID" priority="1337" mode="M12">
        <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="/ubl:Order/cbc:CustomizationID"/>
        <axsl:apply-templates select="@*|*" mode="M12"/>
    </axsl:template>

    <!--RULE -->

    <axsl:template match="/ubl:Order/cbc:ProfileID" priority="1336" mode="M12">
        <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="/ubl:Order/cbc:ProfileID"/>
        <axsl:apply-templates select="@*|*" mode="M12"/>
    </axsl:template>

    <!--RULE -->

    <axsl:template match="/ubl:Order/cbc:ID" priority="1335" mode="M12">
        <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="/ubl:Order/cbc:ID"/>
        <axsl:apply-templates select="@*|*" mode="M12"/>
    </axsl:template>

    <!--RULE -->

    <axsl:template match="/ubl:Order/cbc:SalesOrderID" priority="1334" mode="M12">
        <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="/ubl:Order/cbc:SalesOrderID"/>
        <axsl:apply-templates select="@*|*" mode="M12"/>
    </axsl:template>

    <!--RULE -->

    <axsl:template match="/ubl:Order/cbc:IssueDate" priority="1333" mode="M12">
        <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="/ubl:Order/cbc:IssueDate"/>
        <axsl:apply-templates select="@*|*" mode="M12"/>
    </axsl:template>

    <!--RULE -->

    <axsl:template match="/ubl:Order/cbc:IssueTime" priority="1332" mode="M12">
        <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="/ubl:Order/cbc:IssueTime"/>
        <axsl:apply-templates select="@*|*" mode="M12"/>
    </axsl:template>

    <!--RULE -->

    <axsl:template match="/ubl:Order/cbc:OrderTypeCode" priority="1331" mode="M12">
        <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="/ubl:Order/cbc:OrderTypeCode"/>

        <!--ASSERT -->

        <axsl:choose>
            <axsl:when test="(some $code in $clUNCL1001_T01 satisfies $code = normalize-space(text()))"/>
            <axsl:otherwise>
                <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                    test="(some $code in $clUNCL1001_T01 satisfies $code = normalize-space(text()))">
                    <axsl:attribute name="id">PEPPOL-T01-B00801</axsl:attribute>
                    <axsl:attribute name="flag">fatal</axsl:attribute>
                    <axsl:attribute name="location">
                        <axsl:apply-templates select="." mode="schematron-select-full-path"/>
                    </axsl:attribute>
                    <svrl:text>Value MUST be part of code list 'Order type code (UNCL1001 subset)'.</svrl:text>
                </svrl:failed-assert>
            </axsl:otherwise>
        </axsl:choose>
        <axsl:apply-templates select="@*|*" mode="M12"/>
    </axsl:template>

    <!--RULE -->

    <axsl:template match="/ubl:Order/cbc:Note" priority="1330" mode="M12">
        <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="/ubl:Order/cbc:Note"/>
        <axsl:apply-templates select="@*|*" mode="M12"/>
    </axsl:template>

    <!--RULE -->

    <axsl:template match="/ubl:Order/cbc:DocumentCurrencyCode" priority="1329" mode="M12">
        <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="/ubl:Order/cbc:DocumentCurrencyCode"/>

        <!--ASSERT -->

        <axsl:choose>
            <axsl:when test="(some $code in $clISO4217 satisfies $code = normalize-space(text()))"/>
            <axsl:otherwise>
                <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                    test="(some $code in $clISO4217 satisfies $code = normalize-space(text()))">
                    <axsl:attribute name="id">PEPPOL-T01-B01001</axsl:attribute>
                    <axsl:attribute name="flag">fatal</axsl:attribute>
                    <axsl:attribute name="location">
                        <axsl:apply-templates select="." mode="schematron-select-full-path"/>
                    </axsl:attribute>
                    <svrl:text>Value MUST be part of code list 'Currency codes (ISO 4217)'.</svrl:text>
                </svrl:failed-assert>
            </axsl:otherwise>
        </axsl:choose>
        <axsl:apply-templates select="@*|*" mode="M12"/>
    </axsl:template>

    <!--RULE -->

    <axsl:template match="/ubl:Order/cbc:CustomerReference" priority="1328" mode="M12">
        <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="/ubl:Order/cbc:CustomerReference"/>
        <axsl:apply-templates select="@*|*" mode="M12"/>
    </axsl:template>

    <!--RULE -->

    <axsl:template match="/ubl:Order/cbc:AccountingCost" priority="1327" mode="M12">
        <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="/ubl:Order/cbc:AccountingCost"/>
        <axsl:apply-templates select="@*|*" mode="M12"/>
    </axsl:template>

    <!--RULE -->

    <axsl:template match="/ubl:Order/cac:ValidityPeriod" priority="1326" mode="M12">
        <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="/ubl:Order/cac:ValidityPeriod"/>

        <!--ASSERT -->

        <axsl:choose>
            <axsl:when test="cbc:EndDate"/>
            <axsl:otherwise>
                <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="cbc:EndDate">
                    <axsl:attribute name="id">PEPPOL-T01-B01301</axsl:attribute>
                    <axsl:attribute name="flag">fatal</axsl:attribute>
                    <axsl:attribute name="location">
                        <axsl:apply-templates select="." mode="schematron-select-full-path"/>
                    </axsl:attribute>
                    <svrl:text>Element 'cbc:EndDate' MUST be provided.</svrl:text>
                </svrl:failed-assert>
            </axsl:otherwise>
        </axsl:choose>
        <axsl:apply-templates select="@*|*" mode="M12"/>
    </axsl:template>

    <!--RULE -->

    <axsl:template match="/ubl:Order/cac:ValidityPeriod/cbc:EndDate" priority="1325" mode="M12">
        <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                         context="/ubl:Order/cac:ValidityPeriod/cbc:EndDate"/>
        <axsl:apply-templates select="@*|*" mode="M12"/>
    </axsl:template>

    <!--RULE -->

    <axsl:template match="/ubl:Order/cac:ValidityPeriod/*" priority="1324" mode="M12">
        <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="/ubl:Order/cac:ValidityPeriod/*"/>

        <!--ASSERT -->

        <axsl:choose>
            <axsl:when test="false()"/>
            <axsl:otherwise>
                <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="false()">
                    <axsl:attribute name="id">PEPPOL-T01-B01302</axsl:attribute>
                    <axsl:attribute name="flag">fatal</axsl:attribute>
                    <axsl:attribute name="location">
                        <axsl:apply-templates select="." mode="schematron-select-full-path"/>
                    </axsl:attribute>
                    <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
                </svrl:failed-assert>
            </axsl:otherwise>
        </axsl:choose>
        <axsl:apply-templates select="@*|*" mode="M12"/>
    </axsl:template>

    <!--RULE -->

    <axsl:template match="/ubl:Order/cac:QuotationDocumentReference" priority="1323" mode="M12">
        <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                         context="/ubl:Order/cac:QuotationDocumentReference"/>

        <!--ASSERT -->

        <axsl:choose>
            <axsl:when test="cbc:ID"/>
            <axsl:otherwise>
                <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="cbc:ID">
                    <axsl:attribute name="id">PEPPOL-T01-B01501</axsl:attribute>
                    <axsl:attribute name="flag">fatal</axsl:attribute>
                    <axsl:attribute name="location">
                        <axsl:apply-templates select="." mode="schematron-select-full-path"/>
                    </axsl:attribute>
                    <svrl:text>Element 'cbc:ID' MUST be provided.</svrl:text>
                </svrl:failed-assert>
            </axsl:otherwise>
        </axsl:choose>
        <axsl:apply-templates select="@*|*" mode="M12"/>
    </axsl:template>

    <!--RULE -->

    <axsl:template match="/ubl:Order/cac:QuotationDocumentReference/cbc:ID" priority="1322" mode="M12">
        <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                         context="/ubl:Order/cac:QuotationDocumentReference/cbc:ID"/>
        <axsl:apply-templates select="@*|*" mode="M12"/>
    </axsl:template>

    <!--RULE -->

    <axsl:template match="/ubl:Order/cac:QuotationDocumentReference/*" priority="1321" mode="M12">
        <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                         context="/ubl:Order/cac:QuotationDocumentReference/*"/>

        <!--ASSERT -->

        <axsl:choose>
            <axsl:when test="false()"/>
            <axsl:otherwise>
                <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="false()">
                    <axsl:attribute name="id">PEPPOL-T01-B01502</axsl:attribute>
                    <axsl:attribute name="flag">fatal</axsl:attribute>
                    <axsl:attribute name="location">
                        <axsl:apply-templates select="." mode="schematron-select-full-path"/>
                    </axsl:attribute>
                    <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
                </svrl:failed-assert>
            </axsl:otherwise>
        </axsl:choose>
        <axsl:apply-templates select="@*|*" mode="M12"/>
    </axsl:template>

    <!--RULE -->

    <axsl:template match="/ubl:Order/cac:OrderDocumentReference" priority="1320" mode="M12">
        <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="/ubl:Order/cac:OrderDocumentReference"/>

        <!--ASSERT -->

        <axsl:choose>
            <axsl:when test="cbc:ID"/>
            <axsl:otherwise>
                <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="cbc:ID">
                    <axsl:attribute name="id">PEPPOL-T01-B01701</axsl:attribute>
                    <axsl:attribute name="flag">fatal</axsl:attribute>
                    <axsl:attribute name="location">
                        <axsl:apply-templates select="." mode="schematron-select-full-path"/>
                    </axsl:attribute>
                    <svrl:text>Element 'cbc:ID' MUST be provided.</svrl:text>
                </svrl:failed-assert>
            </axsl:otherwise>
        </axsl:choose>
        <axsl:apply-templates select="@*|*" mode="M12"/>
    </axsl:template>

    <!--RULE -->

    <axsl:template match="/ubl:Order/cac:OrderDocumentReference/cbc:ID" priority="1319" mode="M12">
        <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                         context="/ubl:Order/cac:OrderDocumentReference/cbc:ID"/>
        <axsl:apply-templates select="@*|*" mode="M12"/>
    </axsl:template>

    <!--RULE -->

    <axsl:template match="/ubl:Order/cac:OrderDocumentReference/*" priority="1318" mode="M12">
        <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="/ubl:Order/cac:OrderDocumentReference/*"/>

        <!--ASSERT -->

        <axsl:choose>
            <axsl:when test="false()"/>
            <axsl:otherwise>
                <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="false()">
                    <axsl:attribute name="id">PEPPOL-T01-B01702</axsl:attribute>
                    <axsl:attribute name="flag">fatal</axsl:attribute>
                    <axsl:attribute name="location">
                        <axsl:apply-templates select="." mode="schematron-select-full-path"/>
                    </axsl:attribute>
                    <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
                </svrl:failed-assert>
            </axsl:otherwise>
        </axsl:choose>
        <axsl:apply-templates select="@*|*" mode="M12"/>
    </axsl:template>

    <!--RULE -->

    <axsl:template match="/ubl:Order/cac:OriginatorDocumentReference" priority="1317" mode="M12">
        <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                         context="/ubl:Order/cac:OriginatorDocumentReference"/>

        <!--ASSERT -->

        <axsl:choose>
            <axsl:when test="cbc:ID"/>
            <axsl:otherwise>
                <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="cbc:ID">
                    <axsl:attribute name="id">PEPPOL-T01-B01901</axsl:attribute>
                    <axsl:attribute name="flag">fatal</axsl:attribute>
                    <axsl:attribute name="location">
                        <axsl:apply-templates select="." mode="schematron-select-full-path"/>
                    </axsl:attribute>
                    <svrl:text>Element 'cbc:ID' MUST be provided.</svrl:text>
                </svrl:failed-assert>
            </axsl:otherwise>
        </axsl:choose>
        <axsl:apply-templates select="@*|*" mode="M12"/>
    </axsl:template>

    <!--RULE -->

    <axsl:template match="/ubl:Order/cac:OriginatorDocumentReference/cbc:ID" priority="1316" mode="M12">
        <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                         context="/ubl:Order/cac:OriginatorDocumentReference/cbc:ID"/>
        <axsl:apply-templates select="@*|*" mode="M12"/>
    </axsl:template>

    <!--RULE -->

    <axsl:template match="/ubl:Order/cac:OriginatorDocumentReference/*" priority="1315" mode="M12">
        <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                         context="/ubl:Order/cac:OriginatorDocumentReference/*"/>

        <!--ASSERT -->

        <axsl:choose>
            <axsl:when test="false()"/>
            <axsl:otherwise>
                <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="false()">
                    <axsl:attribute name="id">PEPPOL-T01-B01902</axsl:attribute>
                    <axsl:attribute name="flag">fatal</axsl:attribute>
                    <axsl:attribute name="location">
                        <axsl:apply-templates select="." mode="schematron-select-full-path"/>
                    </axsl:attribute>
                    <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
                </svrl:failed-assert>
            </axsl:otherwise>
        </axsl:choose>
        <axsl:apply-templates select="@*|*" mode="M12"/>
    </axsl:template>

    <!--RULE -->

    <axsl:template match="/ubl:Order/cac:AdditionalDocumentReference" priority="1314" mode="M12">
        <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                         context="/ubl:Order/cac:AdditionalDocumentReference"/>

        <!--ASSERT -->

        <axsl:choose>
            <axsl:when test="cbc:ID"/>
            <axsl:otherwise>
                <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="cbc:ID">
                    <axsl:attribute name="id">PEPPOL-T01-B02101</axsl:attribute>
                    <axsl:attribute name="flag">fatal</axsl:attribute>
                    <axsl:attribute name="location">
                        <axsl:apply-templates select="." mode="schematron-select-full-path"/>
                    </axsl:attribute>
                    <svrl:text>Element 'cbc:ID' MUST be provided.</svrl:text>
                </svrl:failed-assert>
            </axsl:otherwise>
        </axsl:choose>
        <axsl:apply-templates select="@*|*" mode="M12"/>
    </axsl:template>

    <!--RULE -->

    <axsl:template match="/ubl:Order/cac:AdditionalDocumentReference/cbc:ID" priority="1313" mode="M12">
        <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                         context="/ubl:Order/cac:AdditionalDocumentReference/cbc:ID"/>
        <axsl:apply-templates select="@*|*" mode="M12"/>
    </axsl:template>

    <!--RULE -->

    <axsl:template match="/ubl:Order/cac:AdditionalDocumentReference/cbc:DocumentType" priority="1312" mode="M12">
        <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                         context="/ubl:Order/cac:AdditionalDocumentReference/cbc:DocumentType"/>
        <axsl:apply-templates select="@*|*" mode="M12"/>
    </axsl:template>

    <!--RULE -->

    <axsl:template match="/ubl:Order/cac:AdditionalDocumentReference/cac:Attachment" priority="1311" mode="M12">
        <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                         context="/ubl:Order/cac:AdditionalDocumentReference/cac:Attachment"/>
        <axsl:apply-templates select="@*|*" mode="M12"/>
    </axsl:template>

    <!--RULE -->

    <axsl:template match="/ubl:Order/cac:AdditionalDocumentReference/cac:Attachment/cbc:EmbeddedDocumentBinaryObject"
                   priority="1310" mode="M12">
        <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                         context="/ubl:Order/cac:AdditionalDocumentReference/cac:Attachment/cbc:EmbeddedDocumentBinaryObject"/>

        <!--ASSERT -->

        <axsl:choose>
            <axsl:when test="@mimeCode"/>
            <axsl:otherwise>
                <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="@mimeCode">
                    <axsl:attribute name="id">PEPPOL-T01-B02501</axsl:attribute>
                    <axsl:attribute name="flag">fatal</axsl:attribute>
                    <axsl:attribute name="location">
                        <axsl:apply-templates select="." mode="schematron-select-full-path"/>
                    </axsl:attribute>
                    <svrl:text>Attribute 'mimeCode' MUST be present.</svrl:text>
                </svrl:failed-assert>
            </axsl:otherwise>
        </axsl:choose>

        <!--ASSERT -->

        <axsl:choose>
            <axsl:when test="not(@mimeCode) or (some $code in $clMimeCode satisfies $code = @mimeCode)"/>
            <axsl:otherwise>
                <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                    test="not(@mimeCode) or (some $code in $clMimeCode satisfies $code = @mimeCode)">
                    <axsl:attribute name="id">PEPPOL-T01-B02502</axsl:attribute>
                    <axsl:attribute name="flag">fatal</axsl:attribute>
                    <axsl:attribute name="location">
                        <axsl:apply-templates select="." mode="schematron-select-full-path"/>
                    </axsl:attribute>
                    <svrl:text>Value MUST be part of code list 'Mime code (IANA Subset)'.</svrl:text>
                </svrl:failed-assert>
            </axsl:otherwise>
        </axsl:choose>

        <!--ASSERT -->

        <axsl:choose>
            <axsl:when test="@filename"/>
            <axsl:otherwise>
                <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="@filename">
                    <axsl:attribute name="id">PEPPOL-T01-B02503</axsl:attribute>
                    <axsl:attribute name="flag">fatal</axsl:attribute>
                    <axsl:attribute name="location">
                        <axsl:apply-templates select="." mode="schematron-select-full-path"/>
                    </axsl:attribute>
                    <svrl:text>Attribute 'filename' MUST be present.</svrl:text>
                </svrl:failed-assert>
            </axsl:otherwise>
        </axsl:choose>
        <axsl:apply-templates select="@*|*" mode="M12"/>
    </axsl:template>

    <!--RULE -->

    <axsl:template match="/ubl:Order/cac:AdditionalDocumentReference/cac:Attachment/cac:ExternalReference"
                   priority="1309" mode="M12">
        <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                         context="/ubl:Order/cac:AdditionalDocumentReference/cac:Attachment/cac:ExternalReference"/>

        <!--ASSERT -->

        <axsl:choose>
            <axsl:when test="cbc:URI"/>
            <axsl:otherwise>
                <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="cbc:URI">
                    <axsl:attribute name="id">PEPPOL-T01-B02801</axsl:attribute>
                    <axsl:attribute name="flag">fatal</axsl:attribute>
                    <axsl:attribute name="location">
                        <axsl:apply-templates select="." mode="schematron-select-full-path"/>
                    </axsl:attribute>
                    <svrl:text>Element 'cbc:URI' MUST be provided.</svrl:text>
                </svrl:failed-assert>
            </axsl:otherwise>
        </axsl:choose>
        <axsl:apply-templates select="@*|*" mode="M12"/>
    </axsl:template>

    <!--RULE -->

    <axsl:template match="/ubl:Order/cac:AdditionalDocumentReference/cac:Attachment/cac:ExternalReference/cbc:URI"
                   priority="1308" mode="M12">
        <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                         context="/ubl:Order/cac:AdditionalDocumentReference/cac:Attachment/cac:ExternalReference/cbc:URI"/>
        <axsl:apply-templates select="@*|*" mode="M12"/>
    </axsl:template>

    <!--RULE -->

    <axsl:template match="/ubl:Order/cac:AdditionalDocumentReference/cac:Attachment/cac:ExternalReference/*"
                   priority="1307" mode="M12">
        <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                         context="/ubl:Order/cac:AdditionalDocumentReference/cac:Attachment/cac:ExternalReference/*"/>

        <!--ASSERT -->

        <axsl:choose>
            <axsl:when test="false()"/>
            <axsl:otherwise>
                <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="false()">
                    <axsl:attribute name="id">PEPPOL-T01-B02802</axsl:attribute>
                    <axsl:attribute name="flag">fatal</axsl:attribute>
                    <axsl:attribute name="location">
                        <axsl:apply-templates select="." mode="schematron-select-full-path"/>
                    </axsl:attribute>
                    <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
                </svrl:failed-assert>
            </axsl:otherwise>
        </axsl:choose>
        <axsl:apply-templates select="@*|*" mode="M12"/>
    </axsl:template>

    <!--RULE -->

    <axsl:template match="/ubl:Order/cac:AdditionalDocumentReference/cac:Attachment/*" priority="1306" mode="M12">
        <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                         context="/ubl:Order/cac:AdditionalDocumentReference/cac:Attachment/*"/>

        <!--ASSERT -->

        <axsl:choose>
            <axsl:when test="false()"/>
            <axsl:otherwise>
                <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="false()">
                    <axsl:attribute name="id">PEPPOL-T01-B02401</axsl:attribute>
                    <axsl:attribute name="flag">fatal</axsl:attribute>
                    <axsl:attribute name="location">
                        <axsl:apply-templates select="." mode="schematron-select-full-path"/>
                    </axsl:attribute>
                    <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
                </svrl:failed-assert>
            </axsl:otherwise>
        </axsl:choose>
        <axsl:apply-templates select="@*|*" mode="M12"/>
    </axsl:template>

    <!--RULE -->

    <axsl:template match="/ubl:Order/cac:AdditionalDocumentReference/*" priority="1305" mode="M12">
        <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                         context="/ubl:Order/cac:AdditionalDocumentReference/*"/>

        <!--ASSERT -->

        <axsl:choose>
            <axsl:when test="false()"/>
            <axsl:otherwise>
                <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="false()">
                    <axsl:attribute name="id">PEPPOL-T01-B02102</axsl:attribute>
                    <axsl:attribute name="flag">fatal</axsl:attribute>
                    <axsl:attribute name="location">
                        <axsl:apply-templates select="." mode="schematron-select-full-path"/>
                    </axsl:attribute>
                    <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
                </svrl:failed-assert>
            </axsl:otherwise>
        </axsl:choose>
        <axsl:apply-templates select="@*|*" mode="M12"/>
    </axsl:template>

    <!--RULE -->

    <axsl:template match="/ubl:Order/cac:Contract" priority="1304" mode="M12">
        <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="/ubl:Order/cac:Contract"/>

        <!--ASSERT -->

        <axsl:choose>
            <axsl:when test="cbc:ID"/>
            <axsl:otherwise>
                <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="cbc:ID">
                    <axsl:attribute name="id">PEPPOL-T01-B03001</axsl:attribute>
                    <axsl:attribute name="flag">fatal</axsl:attribute>
                    <axsl:attribute name="location">
                        <axsl:apply-templates select="." mode="schematron-select-full-path"/>
                    </axsl:attribute>
                    <svrl:text>Element 'cbc:ID' MUST be provided.</svrl:text>
                </svrl:failed-assert>
            </axsl:otherwise>
        </axsl:choose>
        <axsl:apply-templates select="@*|*" mode="M12"/>
    </axsl:template>

    <!--RULE -->

    <axsl:template match="/ubl:Order/cac:Contract/cbc:ID" priority="1303" mode="M12">
        <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="/ubl:Order/cac:Contract/cbc:ID"/>
        <axsl:apply-templates select="@*|*" mode="M12"/>
    </axsl:template>

    <!--RULE -->

    <axsl:template match="/ubl:Order/cac:Contract/*" priority="1302" mode="M12">
        <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="/ubl:Order/cac:Contract/*"/>

        <!--ASSERT -->

        <axsl:choose>
            <axsl:when test="false()"/>
            <axsl:otherwise>
                <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="false()">
                    <axsl:attribute name="id">PEPPOL-T01-B03002</axsl:attribute>
                    <axsl:attribute name="flag">fatal</axsl:attribute>
                    <axsl:attribute name="location">
                        <axsl:apply-templates select="." mode="schematron-select-full-path"/>
                    </axsl:attribute>
                    <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
                </svrl:failed-assert>
            </axsl:otherwise>
        </axsl:choose>
        <axsl:apply-templates select="@*|*" mode="M12"/>
    </axsl:template>

    <!--RULE -->

    <axsl:template match="/ubl:Order/cac:BuyerCustomerParty" priority="1301" mode="M12">
        <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="/ubl:Order/cac:BuyerCustomerParty"/>

        <!--ASSERT -->

        <axsl:choose>
            <axsl:when test="cac:Party"/>
            <axsl:otherwise>
                <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="cac:Party">
                    <axsl:attribute name="id">PEPPOL-T01-B03201</axsl:attribute>
                    <axsl:attribute name="flag">fatal</axsl:attribute>
                    <axsl:attribute name="location">
                        <axsl:apply-templates select="." mode="schematron-select-full-path"/>
                    </axsl:attribute>
                    <svrl:text>Element 'cac:Party' MUST be provided.</svrl:text>
                </svrl:failed-assert>
            </axsl:otherwise>
        </axsl:choose>
        <axsl:apply-templates select="@*|*" mode="M12"/>
    </axsl:template>

    <!--RULE -->

    <axsl:template match="/ubl:Order/cac:BuyerCustomerParty/cac:Party" priority="1300" mode="M12">
        <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                         context="/ubl:Order/cac:BuyerCustomerParty/cac:Party"/>

        <!--ASSERT -->

        <axsl:choose>
            <axsl:when test="cbc:EndpointID"/>
            <axsl:otherwise>
                <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="cbc:EndpointID">
                    <axsl:attribute name="id">PEPPOL-T01-B03301</axsl:attribute>
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
                    <axsl:attribute name="id">PEPPOL-T01-B03302</axsl:attribute>
                    <axsl:attribute name="flag">fatal</axsl:attribute>
                    <axsl:attribute name="location">
                        <axsl:apply-templates select="." mode="schematron-select-full-path"/>
                    </axsl:attribute>
                    <svrl:text>Element 'cac:PartyLegalEntity' MUST be provided.</svrl:text>
                </svrl:failed-assert>
            </axsl:otherwise>
        </axsl:choose>
        <axsl:apply-templates select="@*|*" mode="M12"/>
    </axsl:template>

    <!--RULE -->

    <axsl:template match="/ubl:Order/cac:BuyerCustomerParty/cac:Party/cbc:EndpointID" priority="1299" mode="M12">
        <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                         context="/ubl:Order/cac:BuyerCustomerParty/cac:Party/cbc:EndpointID"/>

        <!--ASSERT -->

        <axsl:choose>
            <axsl:when test="@schemeID"/>
            <axsl:otherwise>
                <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="@schemeID">
                    <axsl:attribute name="id">PEPPOL-T01-B03401</axsl:attribute>
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
                <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                    test="not(@schemeID) or (some $code in $cleas satisfies $code = @schemeID)">
                    <axsl:attribute name="id">PEPPOL-T01-B03402</axsl:attribute>
                    <axsl:attribute name="flag">fatal</axsl:attribute>
                    <axsl:attribute name="location">
                        <axsl:apply-templates select="." mode="schematron-select-full-path"/>
                    </axsl:attribute>
                    <svrl:text>Value MUST be part of code list 'Electronic Address Scheme (EAS)'.</svrl:text>
                </svrl:failed-assert>
            </axsl:otherwise>
        </axsl:choose>
        <axsl:apply-templates select="@*|*" mode="M12"/>
    </axsl:template>

    <!--RULE -->

    <axsl:template match="/ubl:Order/cac:BuyerCustomerParty/cac:Party/cac:PartyIdentification" priority="1298"
                   mode="M12">
        <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                         context="/ubl:Order/cac:BuyerCustomerParty/cac:Party/cac:PartyIdentification"/>

        <!--ASSERT -->

        <axsl:choose>
            <axsl:when test="cbc:ID"/>
            <axsl:otherwise>
                <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="cbc:ID">
                    <axsl:attribute name="id">PEPPOL-T01-B03601</axsl:attribute>
                    <axsl:attribute name="flag">fatal</axsl:attribute>
                    <axsl:attribute name="location">
                        <axsl:apply-templates select="." mode="schematron-select-full-path"/>
                    </axsl:attribute>
                    <svrl:text>Element 'cbc:ID' MUST be provided.</svrl:text>
                </svrl:failed-assert>
            </axsl:otherwise>
        </axsl:choose>
        <axsl:apply-templates select="@*|*" mode="M12"/>
    </axsl:template>

    <!--RULE -->

    <axsl:template match="/ubl:Order/cac:BuyerCustomerParty/cac:Party/cac:PartyIdentification/cbc:ID" priority="1297"
                   mode="M12">
        <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                         context="/ubl:Order/cac:BuyerCustomerParty/cac:Party/cac:PartyIdentification/cbc:ID"/>

        <!--ASSERT -->

        <axsl:choose>
            <axsl:when test="not(@schemeID) or (some $code in $clICD satisfies $code = @schemeID)"/>
            <axsl:otherwise>
                <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                    test="not(@schemeID) or (some $code in $clICD satisfies $code = @schemeID)">
                    <axsl:attribute name="id">PEPPOL-T01-B03701</axsl:attribute>
                    <axsl:attribute name="flag">fatal</axsl:attribute>
                    <axsl:attribute name="location">
                        <axsl:apply-templates select="." mode="schematron-select-full-path"/>
                    </axsl:attribute>
                    <svrl:text>Value MUST be part of code list 'ISO 6523 ICD list'.</svrl:text>
                </svrl:failed-assert>
            </axsl:otherwise>
        </axsl:choose>
        <axsl:apply-templates select="@*|*" mode="M12"/>
    </axsl:template>

    <!--RULE -->

    <axsl:template match="/ubl:Order/cac:BuyerCustomerParty/cac:Party/cac:PartyName" priority="1296" mode="M12">
        <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                         context="/ubl:Order/cac:BuyerCustomerParty/cac:Party/cac:PartyName"/>

        <!--ASSERT -->

        <axsl:choose>
            <axsl:when test="cbc:Name"/>
            <axsl:otherwise>
                <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="cbc:Name">
                    <axsl:attribute name="id">PEPPOL-T01-B03901</axsl:attribute>
                    <axsl:attribute name="flag">fatal</axsl:attribute>
                    <axsl:attribute name="location">
                        <axsl:apply-templates select="." mode="schematron-select-full-path"/>
                    </axsl:attribute>
                    <svrl:text>Element 'cbc:Name' MUST be provided.</svrl:text>
                </svrl:failed-assert>
            </axsl:otherwise>
        </axsl:choose>
        <axsl:apply-templates select="@*|*" mode="M12"/>
    </axsl:template>

    <!--RULE -->

    <axsl:template match="/ubl:Order/cac:BuyerCustomerParty/cac:Party/cac:PartyName/cbc:Name" priority="1295"
                   mode="M12">
        <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                         context="/ubl:Order/cac:BuyerCustomerParty/cac:Party/cac:PartyName/cbc:Name"/>
        <axsl:apply-templates select="@*|*" mode="M12"/>
    </axsl:template>

    <!--RULE -->

    <axsl:template match="/ubl:Order/cac:BuyerCustomerParty/cac:Party/cac:PostalAddress" priority="1294" mode="M12">
        <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                         context="/ubl:Order/cac:BuyerCustomerParty/cac:Party/cac:PostalAddress"/>

        <!--ASSERT -->

        <axsl:choose>
            <axsl:when test="cac:Country"/>
            <axsl:otherwise>
                <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="cac:Country">
                    <axsl:attribute name="id">PEPPOL-T01-B04101</axsl:attribute>
                    <axsl:attribute name="flag">fatal</axsl:attribute>
                    <axsl:attribute name="location">
                        <axsl:apply-templates select="." mode="schematron-select-full-path"/>
                    </axsl:attribute>
                    <svrl:text>Element 'cac:Country' MUST be provided.</svrl:text>
                </svrl:failed-assert>
            </axsl:otherwise>
        </axsl:choose>
        <axsl:apply-templates select="@*|*" mode="M12"/>
    </axsl:template>

    <!--RULE -->

    <axsl:template match="/ubl:Order/cac:BuyerCustomerParty/cac:Party/cac:PostalAddress/cbc:StreetName" priority="1293"
                   mode="M12">
        <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                         context="/ubl:Order/cac:BuyerCustomerParty/cac:Party/cac:PostalAddress/cbc:StreetName"/>
        <axsl:apply-templates select="@*|*" mode="M12"/>
    </axsl:template>

    <!--RULE -->

    <axsl:template match="/ubl:Order/cac:BuyerCustomerParty/cac:Party/cac:PostalAddress/cbc:AdditionalStreetName"
                   priority="1292" mode="M12">
        <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                         context="/ubl:Order/cac:BuyerCustomerParty/cac:Party/cac:PostalAddress/cbc:AdditionalStreetName"/>
        <axsl:apply-templates select="@*|*" mode="M12"/>
    </axsl:template>

    <!--RULE -->

    <axsl:template match="/ubl:Order/cac:BuyerCustomerParty/cac:Party/cac:PostalAddress/cbc:CityName" priority="1291"
                   mode="M12">
        <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                         context="/ubl:Order/cac:BuyerCustomerParty/cac:Party/cac:PostalAddress/cbc:CityName"/>
        <axsl:apply-templates select="@*|*" mode="M12"/>
    </axsl:template>

    <!--RULE -->

    <axsl:template match="/ubl:Order/cac:BuyerCustomerParty/cac:Party/cac:PostalAddress/cbc:PostalZone" priority="1290"
                   mode="M12">
        <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                         context="/ubl:Order/cac:BuyerCustomerParty/cac:Party/cac:PostalAddress/cbc:PostalZone"/>
        <axsl:apply-templates select="@*|*" mode="M12"/>
    </axsl:template>

    <!--RULE -->

    <axsl:template match="/ubl:Order/cac:BuyerCustomerParty/cac:Party/cac:PostalAddress/cbc:CountrySubentity"
                   priority="1289" mode="M12">
        <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                         context="/ubl:Order/cac:BuyerCustomerParty/cac:Party/cac:PostalAddress/cbc:CountrySubentity"/>
        <axsl:apply-templates select="@*|*" mode="M12"/>
    </axsl:template>

    <!--RULE -->

    <axsl:template match="/ubl:Order/cac:BuyerCustomerParty/cac:Party/cac:PostalAddress/cac:AddressLine" priority="1288"
                   mode="M12">
        <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                         context="/ubl:Order/cac:BuyerCustomerParty/cac:Party/cac:PostalAddress/cac:AddressLine"/>
        <axsl:apply-templates select="@*|*" mode="M12"/>
    </axsl:template>

    <!--RULE -->

    <axsl:template match="/ubl:Order/cac:BuyerCustomerParty/cac:Party/cac:PostalAddress/cac:AddressLine/cbc:Line"
                   priority="1287" mode="M12">
        <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                         context="/ubl:Order/cac:BuyerCustomerParty/cac:Party/cac:PostalAddress/cac:AddressLine/cbc:Line"/>
        <axsl:apply-templates select="@*|*" mode="M12"/>
    </axsl:template>

    <!--RULE -->

    <axsl:template match="/ubl:Order/cac:BuyerCustomerParty/cac:Party/cac:PostalAddress/cac:Country" priority="1286"
                   mode="M12">
        <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                         context="/ubl:Order/cac:BuyerCustomerParty/cac:Party/cac:PostalAddress/cac:Country"/>

        <!--ASSERT -->

        <axsl:choose>
            <axsl:when test="cbc:IdentificationCode"/>
            <axsl:otherwise>
                <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="cbc:IdentificationCode">
                    <axsl:attribute name="id">PEPPOL-T01-B04901</axsl:attribute>
                    <axsl:attribute name="flag">fatal</axsl:attribute>
                    <axsl:attribute name="location">
                        <axsl:apply-templates select="." mode="schematron-select-full-path"/>
                    </axsl:attribute>
                    <svrl:text>Element 'cbc:IdentificationCode' MUST be provided.</svrl:text>
                </svrl:failed-assert>
            </axsl:otherwise>
        </axsl:choose>
        <axsl:apply-templates select="@*|*" mode="M12"/>
    </axsl:template>

    <!--RULE -->

    <axsl:template
            match="/ubl:Order/cac:BuyerCustomerParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode"
            priority="1285" mode="M12">
        <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                         context="/ubl:Order/cac:BuyerCustomerParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode"/>

        <!--ASSERT -->

        <axsl:choose>
            <axsl:when test="(some $code in $clISO3166 satisfies $code = normalize-space(text()))"/>
            <axsl:otherwise>
                <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                    test="(some $code in $clISO3166 satisfies $code = normalize-space(text()))">
                    <axsl:attribute name="id">PEPPOL-T01-B05001</axsl:attribute>
                    <axsl:attribute name="flag">fatal</axsl:attribute>
                    <axsl:attribute name="location">
                        <axsl:apply-templates select="." mode="schematron-select-full-path"/>
                    </axsl:attribute>
                    <svrl:text>Value MUST be part of code list 'Country codes (ISO 3166-1:Alpha2)'.</svrl:text>
                </svrl:failed-assert>
            </axsl:otherwise>
        </axsl:choose>
        <axsl:apply-templates select="@*|*" mode="M12"/>
    </axsl:template>

    <!--RULE -->

    <axsl:template match="/ubl:Order/cac:BuyerCustomerParty/cac:Party/cac:PostalAddress/cac:Country/*" priority="1284"
                   mode="M12">
        <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                         context="/ubl:Order/cac:BuyerCustomerParty/cac:Party/cac:PostalAddress/cac:Country/*"/>

        <!--ASSERT -->

        <axsl:choose>
            <axsl:when test="false()"/>
            <axsl:otherwise>
                <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="false()">
                    <axsl:attribute name="id">PEPPOL-T01-B04902</axsl:attribute>
                    <axsl:attribute name="flag">fatal</axsl:attribute>
                    <axsl:attribute name="location">
                        <axsl:apply-templates select="." mode="schematron-select-full-path"/>
                    </axsl:attribute>
                    <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
                </svrl:failed-assert>
            </axsl:otherwise>
        </axsl:choose>
        <axsl:apply-templates select="@*|*" mode="M12"/>
    </axsl:template>

    <!--RULE -->

    <axsl:template match="/ubl:Order/cac:BuyerCustomerParty/cac:Party/cac:PostalAddress/*" priority="1283" mode="M12">
        <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                         context="/ubl:Order/cac:BuyerCustomerParty/cac:Party/cac:PostalAddress/*"/>

        <!--ASSERT -->

        <axsl:choose>
            <axsl:when test="false()"/>
            <axsl:otherwise>
                <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="false()">
                    <axsl:attribute name="id">PEPPOL-T01-B04102</axsl:attribute>
                    <axsl:attribute name="flag">fatal</axsl:attribute>
                    <axsl:attribute name="location">
                        <axsl:apply-templates select="." mode="schematron-select-full-path"/>
                    </axsl:attribute>
                    <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
                </svrl:failed-assert>
            </axsl:otherwise>
        </axsl:choose>
        <axsl:apply-templates select="@*|*" mode="M12"/>
    </axsl:template>

    <!--RULE -->

    <axsl:template match="/ubl:Order/cac:BuyerCustomerParty/cac:Party/cac:PartyTaxScheme" priority="1282" mode="M12">
        <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                         context="/ubl:Order/cac:BuyerCustomerParty/cac:Party/cac:PartyTaxScheme"/>

        <!--ASSERT -->

        <axsl:choose>
            <axsl:when test="cbc:CompanyID"/>
            <axsl:otherwise>
                <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="cbc:CompanyID">
                    <axsl:attribute name="id">PEPPOL-T01-B05101</axsl:attribute>
                    <axsl:attribute name="flag">fatal</axsl:attribute>
                    <axsl:attribute name="location">
                        <axsl:apply-templates select="." mode="schematron-select-full-path"/>
                    </axsl:attribute>
                    <svrl:text>Element 'cbc:CompanyID' MUST be provided.</svrl:text>
                </svrl:failed-assert>
            </axsl:otherwise>
        </axsl:choose>

        <!--ASSERT -->

        <axsl:choose>
            <axsl:when test="cac:TaxScheme"/>
            <axsl:otherwise>
                <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="cac:TaxScheme">
                    <axsl:attribute name="id">PEPPOL-T01-B05102</axsl:attribute>
                    <axsl:attribute name="flag">fatal</axsl:attribute>
                    <axsl:attribute name="location">
                        <axsl:apply-templates select="." mode="schematron-select-full-path"/>
                    </axsl:attribute>
                    <svrl:text>Element 'cac:TaxScheme' MUST be provided.</svrl:text>
                </svrl:failed-assert>
            </axsl:otherwise>
        </axsl:choose>
        <axsl:apply-templates select="@*|*" mode="M12"/>
    </axsl:template>

    <!--RULE -->

    <axsl:template match="/ubl:Order/cac:BuyerCustomerParty/cac:Party/cac:PartyTaxScheme/cbc:CompanyID" priority="1281"
                   mode="M12">
        <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                         context="/ubl:Order/cac:BuyerCustomerParty/cac:Party/cac:PartyTaxScheme/cbc:CompanyID"/>
        <axsl:apply-templates select="@*|*" mode="M12"/>
    </axsl:template>

    <!--RULE -->

    <axsl:template match="/ubl:Order/cac:BuyerCustomerParty/cac:Party/cac:PartyTaxScheme/cac:TaxScheme" priority="1280"
                   mode="M12">
        <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                         context="/ubl:Order/cac:BuyerCustomerParty/cac:Party/cac:PartyTaxScheme/cac:TaxScheme"/>

        <!--ASSERT -->

        <axsl:choose>
            <axsl:when test="cbc:ID"/>
            <axsl:otherwise>
                <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="cbc:ID">
                    <axsl:attribute name="id">PEPPOL-T01-B05301</axsl:attribute>
                    <axsl:attribute name="flag">fatal</axsl:attribute>
                    <axsl:attribute name="location">
                        <axsl:apply-templates select="." mode="schematron-select-full-path"/>
                    </axsl:attribute>
                    <svrl:text>Element 'cbc:ID' MUST be provided.</svrl:text>
                </svrl:failed-assert>
            </axsl:otherwise>
        </axsl:choose>
        <axsl:apply-templates select="@*|*" mode="M12"/>
    </axsl:template>

    <!--RULE -->

    <axsl:template match="/ubl:Order/cac:BuyerCustomerParty/cac:Party/cac:PartyTaxScheme/cac:TaxScheme/cbc:ID"
                   priority="1279" mode="M12">
        <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                         context="/ubl:Order/cac:BuyerCustomerParty/cac:Party/cac:PartyTaxScheme/cac:TaxScheme/cbc:ID"/>
        <axsl:apply-templates select="@*|*" mode="M12"/>
    </axsl:template>

    <!--RULE -->

    <axsl:template match="/ubl:Order/cac:BuyerCustomerParty/cac:Party/cac:PartyTaxScheme/cac:TaxScheme/*"
                   priority="1278" mode="M12">
        <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                         context="/ubl:Order/cac:BuyerCustomerParty/cac:Party/cac:PartyTaxScheme/cac:TaxScheme/*"/>

        <!--ASSERT -->

        <axsl:choose>
            <axsl:when test="false()"/>
            <axsl:otherwise>
                <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="false()">
                    <axsl:attribute name="id">PEPPOL-T01-B05302</axsl:attribute>
                    <axsl:attribute name="flag">fatal</axsl:attribute>
                    <axsl:attribute name="location">
                        <axsl:apply-templates select="." mode="schematron-select-full-path"/>
                    </axsl:attribute>
                    <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
                </svrl:failed-assert>
            </axsl:otherwise>
        </axsl:choose>
        <axsl:apply-templates select="@*|*" mode="M12"/>
    </axsl:template>

    <!--RULE -->

    <axsl:template match="/ubl:Order/cac:BuyerCustomerParty/cac:Party/cac:PartyTaxScheme/*" priority="1277" mode="M12">
        <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                         context="/ubl:Order/cac:BuyerCustomerParty/cac:Party/cac:PartyTaxScheme/*"/>

        <!--ASSERT -->

        <axsl:choose>
            <axsl:when test="false()"/>
            <axsl:otherwise>
                <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="false()">
                    <axsl:attribute name="id">PEPPOL-T01-B05103</axsl:attribute>
                    <axsl:attribute name="flag">fatal</axsl:attribute>
                    <axsl:attribute name="location">
                        <axsl:apply-templates select="." mode="schematron-select-full-path"/>
                    </axsl:attribute>
                    <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
                </svrl:failed-assert>
            </axsl:otherwise>
        </axsl:choose>
        <axsl:apply-templates select="@*|*" mode="M12"/>
    </axsl:template>

    <!--RULE -->

    <axsl:template match="/ubl:Order/cac:BuyerCustomerParty/cac:Party/cac:PartyLegalEntity" priority="1276" mode="M12">
        <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                         context="/ubl:Order/cac:BuyerCustomerParty/cac:Party/cac:PartyLegalEntity"/>

        <!--ASSERT -->

        <axsl:choose>
            <axsl:when test="cbc:RegistrationName"/>
            <axsl:otherwise>
                <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="cbc:RegistrationName">
                    <axsl:attribute name="id">PEPPOL-T01-B05501</axsl:attribute>
                    <axsl:attribute name="flag">fatal</axsl:attribute>
                    <axsl:attribute name="location">
                        <axsl:apply-templates select="." mode="schematron-select-full-path"/>
                    </axsl:attribute>
                    <svrl:text>Element 'cbc:RegistrationName' MUST be provided.</svrl:text>
                </svrl:failed-assert>
            </axsl:otherwise>
        </axsl:choose>
        <axsl:apply-templates select="@*|*" mode="M12"/>
    </axsl:template>

    <!--RULE -->

    <axsl:template match="/ubl:Order/cac:BuyerCustomerParty/cac:Party/cac:PartyLegalEntity/cbc:RegistrationName"
                   priority="1275" mode="M12">
        <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                         context="/ubl:Order/cac:BuyerCustomerParty/cac:Party/cac:PartyLegalEntity/cbc:RegistrationName"/>
        <axsl:apply-templates select="@*|*" mode="M12"/>
    </axsl:template>

    <!--RULE -->

    <axsl:template match="/ubl:Order/cac:BuyerCustomerParty/cac:Party/cac:PartyLegalEntity/cbc:CompanyID"
                   priority="1274" mode="M12">
        <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                         context="/ubl:Order/cac:BuyerCustomerParty/cac:Party/cac:PartyLegalEntity/cbc:CompanyID"/>

        <!--ASSERT -->

        <axsl:choose>
            <axsl:when test="not(@schemeID) or (some $code in $clICD satisfies $code = @schemeID)"/>
            <axsl:otherwise>
                <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                    test="not(@schemeID) or (some $code in $clICD satisfies $code = @schemeID)">
                    <axsl:attribute name="id">PEPPOL-T01-B05701</axsl:attribute>
                    <axsl:attribute name="flag">fatal</axsl:attribute>
                    <axsl:attribute name="location">
                        <axsl:apply-templates select="." mode="schematron-select-full-path"/>
                    </axsl:attribute>
                    <svrl:text>Value MUST be part of code list 'ISO 6523 ICD list'.</svrl:text>
                </svrl:failed-assert>
            </axsl:otherwise>
        </axsl:choose>
        <axsl:apply-templates select="@*|*" mode="M12"/>
    </axsl:template>

    <!--RULE -->

    <axsl:template match="/ubl:Order/cac:BuyerCustomerParty/cac:Party/cac:PartyLegalEntity/cac:RegistrationAddress"
                   priority="1273" mode="M12">
        <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                         context="/ubl:Order/cac:BuyerCustomerParty/cac:Party/cac:PartyLegalEntity/cac:RegistrationAddress"/>

        <!--ASSERT -->

        <axsl:choose>
            <axsl:when test="cac:Country"/>
            <axsl:otherwise>
                <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="cac:Country">
                    <axsl:attribute name="id">PEPPOL-T01-B05901</axsl:attribute>
                    <axsl:attribute name="flag">fatal</axsl:attribute>
                    <axsl:attribute name="location">
                        <axsl:apply-templates select="." mode="schematron-select-full-path"/>
                    </axsl:attribute>
                    <svrl:text>Element 'cac:Country' MUST be provided.</svrl:text>
                </svrl:failed-assert>
            </axsl:otherwise>
        </axsl:choose>
        <axsl:apply-templates select="@*|*" mode="M12"/>
    </axsl:template>

    <!--RULE -->

    <axsl:template
            match="/ubl:Order/cac:BuyerCustomerParty/cac:Party/cac:PartyLegalEntity/cac:RegistrationAddress/cbc:CityName"
            priority="1272" mode="M12">
        <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                         context="/ubl:Order/cac:BuyerCustomerParty/cac:Party/cac:PartyLegalEntity/cac:RegistrationAddress/cbc:CityName"/>
        <axsl:apply-templates select="@*|*" mode="M12"/>
    </axsl:template>

    <!--RULE -->

    <axsl:template
            match="/ubl:Order/cac:BuyerCustomerParty/cac:Party/cac:PartyLegalEntity/cac:RegistrationAddress/cac:Country"
            priority="1271" mode="M12">
        <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                         context="/ubl:Order/cac:BuyerCustomerParty/cac:Party/cac:PartyLegalEntity/cac:RegistrationAddress/cac:Country"/>

        <!--ASSERT -->

        <axsl:choose>
            <axsl:when test="cbc:IdentificationCode"/>
            <axsl:otherwise>
                <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="cbc:IdentificationCode">
                    <axsl:attribute name="id">PEPPOL-T01-B06101</axsl:attribute>
                    <axsl:attribute name="flag">fatal</axsl:attribute>
                    <axsl:attribute name="location">
                        <axsl:apply-templates select="." mode="schematron-select-full-path"/>
                    </axsl:attribute>
                    <svrl:text>Element 'cbc:IdentificationCode' MUST be provided.</svrl:text>
                </svrl:failed-assert>
            </axsl:otherwise>
        </axsl:choose>
        <axsl:apply-templates select="@*|*" mode="M12"/>
    </axsl:template>

    <!--RULE -->

    <axsl:template
            match="/ubl:Order/cac:BuyerCustomerParty/cac:Party/cac:PartyLegalEntity/cac:RegistrationAddress/cac:Country/cbc:IdentificationCode"
            priority="1270" mode="M12">
        <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                         context="/ubl:Order/cac:BuyerCustomerParty/cac:Party/cac:PartyLegalEntity/cac:RegistrationAddress/cac:Country/cbc:IdentificationCode"/>

        <!--ASSERT -->

        <axsl:choose>
            <axsl:when test="(some $code in $clISO3166 satisfies $code = normalize-space(text()))"/>
            <axsl:otherwise>
                <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                    test="(some $code in $clISO3166 satisfies $code = normalize-space(text()))">
                    <axsl:attribute name="id">PEPPOL-T01-B06201</axsl:attribute>
                    <axsl:attribute name="flag">fatal</axsl:attribute>
                    <axsl:attribute name="location">
                        <axsl:apply-templates select="." mode="schematron-select-full-path"/>
                    </axsl:attribute>
                    <svrl:text>Value MUST be part of code list 'Country codes (ISO 3166-1:Alpha2)'.</svrl:text>
                </svrl:failed-assert>
            </axsl:otherwise>
        </axsl:choose>
        <axsl:apply-templates select="@*|*" mode="M12"/>
    </axsl:template>

    <!--RULE -->

    <axsl:template
            match="/ubl:Order/cac:BuyerCustomerParty/cac:Party/cac:PartyLegalEntity/cac:RegistrationAddress/cac:Country/*"
            priority="1269" mode="M12">
        <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                         context="/ubl:Order/cac:BuyerCustomerParty/cac:Party/cac:PartyLegalEntity/cac:RegistrationAddress/cac:Country/*"/>

        <!--ASSERT -->

        <axsl:choose>
            <axsl:when test="false()"/>
            <axsl:otherwise>
                <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="false()">
                    <axsl:attribute name="id">PEPPOL-T01-B06102</axsl:attribute>
                    <axsl:attribute name="flag">fatal</axsl:attribute>
                    <axsl:attribute name="location">
                        <axsl:apply-templates select="." mode="schematron-select-full-path"/>
                    </axsl:attribute>
                    <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
                </svrl:failed-assert>
            </axsl:otherwise>
        </axsl:choose>
        <axsl:apply-templates select="@*|*" mode="M12"/>
    </axsl:template>

    <!--RULE -->

    <axsl:template match="/ubl:Order/cac:BuyerCustomerParty/cac:Party/cac:PartyLegalEntity/cac:RegistrationAddress/*"
                   priority="1268" mode="M12">
        <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                         context="/ubl:Order/cac:BuyerCustomerParty/cac:Party/cac:PartyLegalEntity/cac:RegistrationAddress/*"/>

        <!--ASSERT -->

        <axsl:choose>
            <axsl:when test="false()"/>
            <axsl:otherwise>
                <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="false()">
                    <axsl:attribute name="id">PEPPOL-T01-B05902</axsl:attribute>
                    <axsl:attribute name="flag">fatal</axsl:attribute>
                    <axsl:attribute name="location">
                        <axsl:apply-templates select="." mode="schematron-select-full-path"/>
                    </axsl:attribute>
                    <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
                </svrl:failed-assert>
            </axsl:otherwise>
        </axsl:choose>
        <axsl:apply-templates select="@*|*" mode="M12"/>
    </axsl:template>

    <!--RULE -->

    <axsl:template match="/ubl:Order/cac:BuyerCustomerParty/cac:Party/cac:PartyLegalEntity/*" priority="1267"
                   mode="M12">
        <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                         context="/ubl:Order/cac:BuyerCustomerParty/cac:Party/cac:PartyLegalEntity/*"/>

        <!--ASSERT -->

        <axsl:choose>
            <axsl:when test="false()"/>
            <axsl:otherwise>
                <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="false()">
                    <axsl:attribute name="id">PEPPOL-T01-B05502</axsl:attribute>
                    <axsl:attribute name="flag">fatal</axsl:attribute>
                    <axsl:attribute name="location">
                        <axsl:apply-templates select="." mode="schematron-select-full-path"/>
                    </axsl:attribute>
                    <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
                </svrl:failed-assert>
            </axsl:otherwise>
        </axsl:choose>
        <axsl:apply-templates select="@*|*" mode="M12"/>
    </axsl:template>

    <!--RULE -->

    <axsl:template match="/ubl:Order/cac:BuyerCustomerParty/cac:Party/cac:Contact" priority="1266" mode="M12">
        <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                         context="/ubl:Order/cac:BuyerCustomerParty/cac:Party/cac:Contact"/>
        <axsl:apply-templates select="@*|*" mode="M12"/>
    </axsl:template>

    <!--RULE -->

    <axsl:template match="/ubl:Order/cac:BuyerCustomerParty/cac:Party/cac:Contact/cbc:Name" priority="1265" mode="M12">
        <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                         context="/ubl:Order/cac:BuyerCustomerParty/cac:Party/cac:Contact/cbc:Name"/>
        <axsl:apply-templates select="@*|*" mode="M12"/>
    </axsl:template>

    <!--RULE -->

    <axsl:template match="/ubl:Order/cac:BuyerCustomerParty/cac:Party/cac:Contact/cbc:Telephone" priority="1264"
                   mode="M12">
        <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                         context="/ubl:Order/cac:BuyerCustomerParty/cac:Party/cac:Contact/cbc:Telephone"/>
        <axsl:apply-templates select="@*|*" mode="M12"/>
    </axsl:template>

    <!--RULE -->

    <axsl:template match="/ubl:Order/cac:BuyerCustomerParty/cac:Party/cac:Contact/cbc:ElectronicMail" priority="1263"
                   mode="M12">
        <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                         context="/ubl:Order/cac:BuyerCustomerParty/cac:Party/cac:Contact/cbc:ElectronicMail"/>
        <axsl:apply-templates select="@*|*" mode="M12"/>
    </axsl:template>

    <!--RULE -->

    <axsl:template match="/ubl:Order/cac:BuyerCustomerParty/cac:Party/cac:Contact/*" priority="1262" mode="M12">
        <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                         context="/ubl:Order/cac:BuyerCustomerParty/cac:Party/cac:Contact/*"/>

        <!--ASSERT -->

        <axsl:choose>
            <axsl:when test="false()"/>
            <axsl:otherwise>
                <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="false()">
                    <axsl:attribute name="id">PEPPOL-T01-B06301</axsl:attribute>
                    <axsl:attribute name="flag">fatal</axsl:attribute>
                    <axsl:attribute name="location">
                        <axsl:apply-templates select="." mode="schematron-select-full-path"/>
                    </axsl:attribute>
                    <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
                </svrl:failed-assert>
            </axsl:otherwise>
        </axsl:choose>
        <axsl:apply-templates select="@*|*" mode="M12"/>
    </axsl:template>

    <!--RULE -->

    <axsl:template match="/ubl:Order/cac:BuyerCustomerParty/cac:Party/*" priority="1261" mode="M12">
        <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                         context="/ubl:Order/cac:BuyerCustomerParty/cac:Party/*"/>

        <!--ASSERT -->

        <axsl:choose>
            <axsl:when test="false()"/>
            <axsl:otherwise>
                <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="false()">
                    <axsl:attribute name="id">PEPPOL-T01-B03303</axsl:attribute>
                    <axsl:attribute name="flag">fatal</axsl:attribute>
                    <axsl:attribute name="location">
                        <axsl:apply-templates select="." mode="schematron-select-full-path"/>
                    </axsl:attribute>
                    <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
                </svrl:failed-assert>
            </axsl:otherwise>
        </axsl:choose>
        <axsl:apply-templates select="@*|*" mode="M12"/>
    </axsl:template>

    <!--RULE -->

    <axsl:template match="/ubl:Order/cac:BuyerCustomerParty/*" priority="1260" mode="M12">
        <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="/ubl:Order/cac:BuyerCustomerParty/*"/>

        <!--ASSERT -->

        <axsl:choose>
            <axsl:when test="false()"/>
            <axsl:otherwise>
                <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="false()">
                    <axsl:attribute name="id">PEPPOL-T01-B03202</axsl:attribute>
                    <axsl:attribute name="flag">fatal</axsl:attribute>
                    <axsl:attribute name="location">
                        <axsl:apply-templates select="." mode="schematron-select-full-path"/>
                    </axsl:attribute>
                    <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
                </svrl:failed-assert>
            </axsl:otherwise>
        </axsl:choose>
        <axsl:apply-templates select="@*|*" mode="M12"/>
    </axsl:template>

    <!--RULE -->

    <axsl:template match="/ubl:Order/cac:SellerSupplierParty" priority="1259" mode="M12">
        <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="/ubl:Order/cac:SellerSupplierParty"/>

        <!--ASSERT -->

        <axsl:choose>
            <axsl:when test="cac:Party"/>
            <axsl:otherwise>
                <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="cac:Party">
                    <axsl:attribute name="id">PEPPOL-T01-B06701</axsl:attribute>
                    <axsl:attribute name="flag">fatal</axsl:attribute>
                    <axsl:attribute name="location">
                        <axsl:apply-templates select="." mode="schematron-select-full-path"/>
                    </axsl:attribute>
                    <svrl:text>Element 'cac:Party' MUST be provided.</svrl:text>
                </svrl:failed-assert>
            </axsl:otherwise>
        </axsl:choose>
        <axsl:apply-templates select="@*|*" mode="M12"/>
    </axsl:template>

    <!--RULE -->

    <axsl:template match="/ubl:Order/cac:SellerSupplierParty/cac:Party" priority="1258" mode="M12">
        <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                         context="/ubl:Order/cac:SellerSupplierParty/cac:Party"/>

        <!--ASSERT -->

        <axsl:choose>
            <axsl:when test="cbc:EndpointID"/>
            <axsl:otherwise>
                <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="cbc:EndpointID">
                    <axsl:attribute name="id">PEPPOL-T01-B06801</axsl:attribute>
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
            <axsl:when test="cac:PostalAddress"/>
            <axsl:otherwise>
                <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="cac:PostalAddress">
                    <axsl:attribute name="id">PEPPOL-T01-B06802</axsl:attribute>
                    <axsl:attribute name="flag">fatal</axsl:attribute>
                    <axsl:attribute name="location">
                        <axsl:apply-templates select="." mode="schematron-select-full-path"/>
                    </axsl:attribute>
                    <svrl:text>Element 'cac:PostalAddress' MUST be provided.</svrl:text>
                </svrl:failed-assert>
            </axsl:otherwise>
        </axsl:choose>

        <!--ASSERT -->

        <axsl:choose>
            <axsl:when test="cac:PartyLegalEntity"/>
            <axsl:otherwise>
                <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="cac:PartyLegalEntity">
                    <axsl:attribute name="id">PEPPOL-T01-B06803</axsl:attribute>
                    <axsl:attribute name="flag">fatal</axsl:attribute>
                    <axsl:attribute name="location">
                        <axsl:apply-templates select="." mode="schematron-select-full-path"/>
                    </axsl:attribute>
                    <svrl:text>Element 'cac:PartyLegalEntity' MUST be provided.</svrl:text>
                </svrl:failed-assert>
            </axsl:otherwise>
        </axsl:choose>
        <axsl:apply-templates select="@*|*" mode="M12"/>
    </axsl:template>

    <!--RULE -->

    <axsl:template match="/ubl:Order/cac:SellerSupplierParty/cac:Party/cbc:EndpointID" priority="1257" mode="M12">
        <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                         context="/ubl:Order/cac:SellerSupplierParty/cac:Party/cbc:EndpointID"/>

        <!--ASSERT -->

        <axsl:choose>
            <axsl:when test="@schemeID"/>
            <axsl:otherwise>
                <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="@schemeID">
                    <axsl:attribute name="id">PEPPOL-T01-B06901</axsl:attribute>
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
                <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                    test="not(@schemeID) or (some $code in $cleas satisfies $code = @schemeID)">
                    <axsl:attribute name="id">PEPPOL-T01-B06902</axsl:attribute>
                    <axsl:attribute name="flag">fatal</axsl:attribute>
                    <axsl:attribute name="location">
                        <axsl:apply-templates select="." mode="schematron-select-full-path"/>
                    </axsl:attribute>
                    <svrl:text>Value MUST be part of code list 'Electronic Address Scheme (EAS)'.</svrl:text>
                </svrl:failed-assert>
            </axsl:otherwise>
        </axsl:choose>
        <axsl:apply-templates select="@*|*" mode="M12"/>
    </axsl:template>

    <!--RULE -->

    <axsl:template match="/ubl:Order/cac:SellerSupplierParty/cac:Party/cac:PartyIdentification" priority="1256"
                   mode="M12">
        <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                         context="/ubl:Order/cac:SellerSupplierParty/cac:Party/cac:PartyIdentification"/>

        <!--ASSERT -->

        <axsl:choose>
            <axsl:when test="cbc:ID"/>
            <axsl:otherwise>
                <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="cbc:ID">
                    <axsl:attribute name="id">PEPPOL-T01-B07101</axsl:attribute>
                    <axsl:attribute name="flag">fatal</axsl:attribute>
                    <axsl:attribute name="location">
                        <axsl:apply-templates select="." mode="schematron-select-full-path"/>
                    </axsl:attribute>
                    <svrl:text>Element 'cbc:ID' MUST be provided.</svrl:text>
                </svrl:failed-assert>
            </axsl:otherwise>
        </axsl:choose>
        <axsl:apply-templates select="@*|*" mode="M12"/>
    </axsl:template>

    <!--RULE -->

    <axsl:template match="/ubl:Order/cac:SellerSupplierParty/cac:Party/cac:PartyIdentification/cbc:ID" priority="1255"
                   mode="M12">
        <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                         context="/ubl:Order/cac:SellerSupplierParty/cac:Party/cac:PartyIdentification/cbc:ID"/>

        <!--ASSERT -->

        <axsl:choose>
            <axsl:when test="not(@schemeID) or (some $code in $clICD satisfies $code = @schemeID)"/>
            <axsl:otherwise>
                <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                    test="not(@schemeID) or (some $code in $clICD satisfies $code = @schemeID)">
                    <axsl:attribute name="id">PEPPOL-T01-B07201</axsl:attribute>
                    <axsl:attribute name="flag">fatal</axsl:attribute>
                    <axsl:attribute name="location">
                        <axsl:apply-templates select="." mode="schematron-select-full-path"/>
                    </axsl:attribute>
                    <svrl:text>Value MUST be part of code list 'ISO 6523 ICD list'.</svrl:text>
                </svrl:failed-assert>
            </axsl:otherwise>
        </axsl:choose>
        <axsl:apply-templates select="@*|*" mode="M12"/>
    </axsl:template>

    <!--RULE -->

    <axsl:template match="/ubl:Order/cac:SellerSupplierParty/cac:Party/cac:PartyName" priority="1254" mode="M12">
        <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                         context="/ubl:Order/cac:SellerSupplierParty/cac:Party/cac:PartyName"/>

        <!--ASSERT -->

        <axsl:choose>
            <axsl:when test="cbc:Name"/>
            <axsl:otherwise>
                <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="cbc:Name">
                    <axsl:attribute name="id">PEPPOL-T01-B07401</axsl:attribute>
                    <axsl:attribute name="flag">fatal</axsl:attribute>
                    <axsl:attribute name="location">
                        <axsl:apply-templates select="." mode="schematron-select-full-path"/>
                    </axsl:attribute>
                    <svrl:text>Element 'cbc:Name' MUST be provided.</svrl:text>
                </svrl:failed-assert>
            </axsl:otherwise>
        </axsl:choose>
        <axsl:apply-templates select="@*|*" mode="M12"/>
    </axsl:template>

    <!--RULE -->

    <axsl:template match="/ubl:Order/cac:SellerSupplierParty/cac:Party/cac:PartyName/cbc:Name" priority="1253"
                   mode="M12">
        <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                         context="/ubl:Order/cac:SellerSupplierParty/cac:Party/cac:PartyName/cbc:Name"/>
        <axsl:apply-templates select="@*|*" mode="M12"/>
    </axsl:template>

    <!--RULE -->

    <axsl:template match="/ubl:Order/cac:SellerSupplierParty/cac:Party/cac:PostalAddress" priority="1252" mode="M12">
        <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                         context="/ubl:Order/cac:SellerSupplierParty/cac:Party/cac:PostalAddress"/>

        <!--ASSERT -->

        <axsl:choose>
            <axsl:when test="cac:Country"/>
            <axsl:otherwise>
                <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="cac:Country">
                    <axsl:attribute name="id">PEPPOL-T01-B07601</axsl:attribute>
                    <axsl:attribute name="flag">fatal</axsl:attribute>
                    <axsl:attribute name="location">
                        <axsl:apply-templates select="." mode="schematron-select-full-path"/>
                    </axsl:attribute>
                    <svrl:text>Element 'cac:Country' MUST be provided.</svrl:text>
                </svrl:failed-assert>
            </axsl:otherwise>
        </axsl:choose>
        <axsl:apply-templates select="@*|*" mode="M12"/>
    </axsl:template>

    <!--RULE -->

    <axsl:template match="/ubl:Order/cac:SellerSupplierParty/cac:Party/cac:PostalAddress/cbc:StreetName" priority="1251"
                   mode="M12">
        <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                         context="/ubl:Order/cac:SellerSupplierParty/cac:Party/cac:PostalAddress/cbc:StreetName"/>
        <axsl:apply-templates select="@*|*" mode="M12"/>
    </axsl:template>

    <!--RULE -->

    <axsl:template match="/ubl:Order/cac:SellerSupplierParty/cac:Party/cac:PostalAddress/cbc:AdditionalStreetName"
                   priority="1250" mode="M12">
        <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                         context="/ubl:Order/cac:SellerSupplierParty/cac:Party/cac:PostalAddress/cbc:AdditionalStreetName"/>
        <axsl:apply-templates select="@*|*" mode="M12"/>
    </axsl:template>

    <!--RULE -->

    <axsl:template match="/ubl:Order/cac:SellerSupplierParty/cac:Party/cac:PostalAddress/cbc:CityName" priority="1249"
                   mode="M12">
        <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                         context="/ubl:Order/cac:SellerSupplierParty/cac:Party/cac:PostalAddress/cbc:CityName"/>
        <axsl:apply-templates select="@*|*" mode="M12"/>
    </axsl:template>

    <!--RULE -->

    <axsl:template match="/ubl:Order/cac:SellerSupplierParty/cac:Party/cac:PostalAddress/cbc:PostalZone" priority="1248"
                   mode="M12">
        <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                         context="/ubl:Order/cac:SellerSupplierParty/cac:Party/cac:PostalAddress/cbc:PostalZone"/>
        <axsl:apply-templates select="@*|*" mode="M12"/>
    </axsl:template>

    <!--RULE -->

    <axsl:template match="/ubl:Order/cac:SellerSupplierParty/cac:Party/cac:PostalAddress/cbc:CountrySubentity"
                   priority="1247" mode="M12">
        <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                         context="/ubl:Order/cac:SellerSupplierParty/cac:Party/cac:PostalAddress/cbc:CountrySubentity"/>
        <axsl:apply-templates select="@*|*" mode="M12"/>
    </axsl:template>

    <!--RULE -->

    <axsl:template match="/ubl:Order/cac:SellerSupplierParty/cac:Party/cac:PostalAddress/cac:AddressLine"
                   priority="1246" mode="M12">
        <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                         context="/ubl:Order/cac:SellerSupplierParty/cac:Party/cac:PostalAddress/cac:AddressLine"/>
        <axsl:apply-templates select="@*|*" mode="M12"/>
    </axsl:template>

    <!--RULE -->

    <axsl:template match="/ubl:Order/cac:SellerSupplierParty/cac:Party/cac:PostalAddress/cac:AddressLine/cbc:Line"
                   priority="1245" mode="M12">
        <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                         context="/ubl:Order/cac:SellerSupplierParty/cac:Party/cac:PostalAddress/cac:AddressLine/cbc:Line"/>
        <axsl:apply-templates select="@*|*" mode="M12"/>
    </axsl:template>

    <!--RULE -->

    <axsl:template match="/ubl:Order/cac:SellerSupplierParty/cac:Party/cac:PostalAddress/cac:Country" priority="1244"
                   mode="M12">
        <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                         context="/ubl:Order/cac:SellerSupplierParty/cac:Party/cac:PostalAddress/cac:Country"/>

        <!--ASSERT -->

        <axsl:choose>
            <axsl:when test="cbc:IdentificationCode"/>
            <axsl:otherwise>
                <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="cbc:IdentificationCode">
                    <axsl:attribute name="id">PEPPOL-T01-B08401</axsl:attribute>
                    <axsl:attribute name="flag">fatal</axsl:attribute>
                    <axsl:attribute name="location">
                        <axsl:apply-templates select="." mode="schematron-select-full-path"/>
                    </axsl:attribute>
                    <svrl:text>Element 'cbc:IdentificationCode' MUST be provided.</svrl:text>
                </svrl:failed-assert>
            </axsl:otherwise>
        </axsl:choose>
        <axsl:apply-templates select="@*|*" mode="M12"/>
    </axsl:template>

    <!--RULE -->

    <axsl:template
            match="/ubl:Order/cac:SellerSupplierParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode"
            priority="1243" mode="M12">
        <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                         context="/ubl:Order/cac:SellerSupplierParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode"/>

        <!--ASSERT -->

        <axsl:choose>
            <axsl:when test="(some $code in $clISO3166 satisfies $code = normalize-space(text()))"/>
            <axsl:otherwise>
                <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                    test="(some $code in $clISO3166 satisfies $code = normalize-space(text()))">
                    <axsl:attribute name="id">PEPPOL-T01-B08501</axsl:attribute>
                    <axsl:attribute name="flag">fatal</axsl:attribute>
                    <axsl:attribute name="location">
                        <axsl:apply-templates select="." mode="schematron-select-full-path"/>
                    </axsl:attribute>
                    <svrl:text>Value MUST be part of code list 'Country codes (ISO 3166-1:Alpha2)'.</svrl:text>
                </svrl:failed-assert>
            </axsl:otherwise>
        </axsl:choose>
        <axsl:apply-templates select="@*|*" mode="M12"/>
    </axsl:template>

    <!--RULE -->

    <axsl:template match="/ubl:Order/cac:SellerSupplierParty/cac:Party/cac:PostalAddress/cac:Country/*" priority="1242"
                   mode="M12">
        <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                         context="/ubl:Order/cac:SellerSupplierParty/cac:Party/cac:PostalAddress/cac:Country/*"/>

        <!--ASSERT -->

        <axsl:choose>
            <axsl:when test="false()"/>
            <axsl:otherwise>
                <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="false()">
                    <axsl:attribute name="id">PEPPOL-T01-B08402</axsl:attribute>
                    <axsl:attribute name="flag">fatal</axsl:attribute>
                    <axsl:attribute name="location">
                        <axsl:apply-templates select="." mode="schematron-select-full-path"/>
                    </axsl:attribute>
                    <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
                </svrl:failed-assert>
            </axsl:otherwise>
        </axsl:choose>
        <axsl:apply-templates select="@*|*" mode="M12"/>
    </axsl:template>

    <!--RULE -->

    <axsl:template match="/ubl:Order/cac:SellerSupplierParty/cac:Party/cac:PostalAddress/*" priority="1241" mode="M12">
        <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                         context="/ubl:Order/cac:SellerSupplierParty/cac:Party/cac:PostalAddress/*"/>

        <!--ASSERT -->

        <axsl:choose>
            <axsl:when test="false()"/>
            <axsl:otherwise>
                <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="false()">
                    <axsl:attribute name="id">PEPPOL-T01-B07602</axsl:attribute>
                    <axsl:attribute name="flag">fatal</axsl:attribute>
                    <axsl:attribute name="location">
                        <axsl:apply-templates select="." mode="schematron-select-full-path"/>
                    </axsl:attribute>
                    <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
                </svrl:failed-assert>
            </axsl:otherwise>
        </axsl:choose>
        <axsl:apply-templates select="@*|*" mode="M12"/>
    </axsl:template>

    <!--RULE -->

    <axsl:template match="/ubl:Order/cac:SellerSupplierParty/cac:Party/cac:PartyLegalEntity" priority="1240" mode="M12">
        <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                         context="/ubl:Order/cac:SellerSupplierParty/cac:Party/cac:PartyLegalEntity"/>

        <!--ASSERT -->

        <axsl:choose>
            <axsl:when test="cbc:RegistrationName"/>
            <axsl:otherwise>
                <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="cbc:RegistrationName">
                    <axsl:attribute name="id">PEPPOL-T01-B08601</axsl:attribute>
                    <axsl:attribute name="flag">fatal</axsl:attribute>
                    <axsl:attribute name="location">
                        <axsl:apply-templates select="." mode="schematron-select-full-path"/>
                    </axsl:attribute>
                    <svrl:text>Element 'cbc:RegistrationName' MUST be provided.</svrl:text>
                </svrl:failed-assert>
            </axsl:otherwise>
        </axsl:choose>
        <axsl:apply-templates select="@*|*" mode="M12"/>
    </axsl:template>

    <!--RULE -->

    <axsl:template match="/ubl:Order/cac:SellerSupplierParty/cac:Party/cac:PartyLegalEntity/cbc:RegistrationName"
                   priority="1239" mode="M12">
        <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                         context="/ubl:Order/cac:SellerSupplierParty/cac:Party/cac:PartyLegalEntity/cbc:RegistrationName"/>
        <axsl:apply-templates select="@*|*" mode="M12"/>
    </axsl:template>

    <!--RULE -->

    <axsl:template match="/ubl:Order/cac:SellerSupplierParty/cac:Party/cac:PartyLegalEntity/cbc:CompanyID"
                   priority="1238" mode="M12">
        <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                         context="/ubl:Order/cac:SellerSupplierParty/cac:Party/cac:PartyLegalEntity/cbc:CompanyID"/>

        <!--ASSERT -->

        <axsl:choose>
            <axsl:when test="not(@schemeID) or (some $code in $clICD satisfies $code = @schemeID)"/>
            <axsl:otherwise>
                <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                    test="not(@schemeID) or (some $code in $clICD satisfies $code = @schemeID)">
                    <axsl:attribute name="id">PEPPOL-T01-B08801</axsl:attribute>
                    <axsl:attribute name="flag">fatal</axsl:attribute>
                    <axsl:attribute name="location">
                        <axsl:apply-templates select="." mode="schematron-select-full-path"/>
                    </axsl:attribute>
                    <svrl:text>Value MUST be part of code list 'ISO 6523 ICD list'.</svrl:text>
                </svrl:failed-assert>
            </axsl:otherwise>
        </axsl:choose>
        <axsl:apply-templates select="@*|*" mode="M12"/>
    </axsl:template>

    <!--RULE -->

    <axsl:template match="/ubl:Order/cac:SellerSupplierParty/cac:Party/cac:PartyLegalEntity/cac:RegistrationAddress"
                   priority="1237" mode="M12">
        <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                         context="/ubl:Order/cac:SellerSupplierParty/cac:Party/cac:PartyLegalEntity/cac:RegistrationAddress"/>

        <!--ASSERT -->

        <axsl:choose>
            <axsl:when test="cac:Country"/>
            <axsl:otherwise>
                <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="cac:Country">
                    <axsl:attribute name="id">PEPPOL-T01-B09001</axsl:attribute>
                    <axsl:attribute name="flag">fatal</axsl:attribute>
                    <axsl:attribute name="location">
                        <axsl:apply-templates select="." mode="schematron-select-full-path"/>
                    </axsl:attribute>
                    <svrl:text>Element 'cac:Country' MUST be provided.</svrl:text>
                </svrl:failed-assert>
            </axsl:otherwise>
        </axsl:choose>
        <axsl:apply-templates select="@*|*" mode="M12"/>
    </axsl:template>

    <!--RULE -->

    <axsl:template
            match="/ubl:Order/cac:SellerSupplierParty/cac:Party/cac:PartyLegalEntity/cac:RegistrationAddress/cbc:CityName"
            priority="1236" mode="M12">
        <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                         context="/ubl:Order/cac:SellerSupplierParty/cac:Party/cac:PartyLegalEntity/cac:RegistrationAddress/cbc:CityName"/>
        <axsl:apply-templates select="@*|*" mode="M12"/>
    </axsl:template>

    <!--RULE -->

    <axsl:template
            match="/ubl:Order/cac:SellerSupplierParty/cac:Party/cac:PartyLegalEntity/cac:RegistrationAddress/cac:Country"
            priority="1235" mode="M12">
        <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                         context="/ubl:Order/cac:SellerSupplierParty/cac:Party/cac:PartyLegalEntity/cac:RegistrationAddress/cac:Country"/>

        <!--ASSERT -->

        <axsl:choose>
            <axsl:when test="cbc:IdentificationCode"/>
            <axsl:otherwise>
                <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="cbc:IdentificationCode">
                    <axsl:attribute name="id">PEPPOL-T01-B09201</axsl:attribute>
                    <axsl:attribute name="flag">fatal</axsl:attribute>
                    <axsl:attribute name="location">
                        <axsl:apply-templates select="." mode="schematron-select-full-path"/>
                    </axsl:attribute>
                    <svrl:text>Element 'cbc:IdentificationCode' MUST be provided.</svrl:text>
                </svrl:failed-assert>
            </axsl:otherwise>
        </axsl:choose>
        <axsl:apply-templates select="@*|*" mode="M12"/>
    </axsl:template>

    <!--RULE -->

    <axsl:template
            match="/ubl:Order/cac:SellerSupplierParty/cac:Party/cac:PartyLegalEntity/cac:RegistrationAddress/cac:Country/cbc:IdentificationCode"
            priority="1234" mode="M12">
        <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                         context="/ubl:Order/cac:SellerSupplierParty/cac:Party/cac:PartyLegalEntity/cac:RegistrationAddress/cac:Country/cbc:IdentificationCode"/>

        <!--ASSERT -->

        <axsl:choose>
            <axsl:when test="(some $code in $clISO3166 satisfies $code = normalize-space(text()))"/>
            <axsl:otherwise>
                <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                    test="(some $code in $clISO3166 satisfies $code = normalize-space(text()))">
                    <axsl:attribute name="id">PEPPOL-T01-B09301</axsl:attribute>
                    <axsl:attribute name="flag">fatal</axsl:attribute>
                    <axsl:attribute name="location">
                        <axsl:apply-templates select="." mode="schematron-select-full-path"/>
                    </axsl:attribute>
                    <svrl:text>Value MUST be part of code list 'Country codes (ISO 3166-1:Alpha2)'.</svrl:text>
                </svrl:failed-assert>
            </axsl:otherwise>
        </axsl:choose>
        <axsl:apply-templates select="@*|*" mode="M12"/>
    </axsl:template>

    <!--RULE -->

    <axsl:template
            match="/ubl:Order/cac:SellerSupplierParty/cac:Party/cac:PartyLegalEntity/cac:RegistrationAddress/cac:Country/*"
            priority="1233" mode="M12">
        <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                         context="/ubl:Order/cac:SellerSupplierParty/cac:Party/cac:PartyLegalEntity/cac:RegistrationAddress/cac:Country/*"/>

        <!--ASSERT -->

        <axsl:choose>
            <axsl:when test="false()"/>
            <axsl:otherwise>
                <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="false()">
                    <axsl:attribute name="id">PEPPOL-T01-B09202</axsl:attribute>
                    <axsl:attribute name="flag">fatal</axsl:attribute>
                    <axsl:attribute name="location">
                        <axsl:apply-templates select="." mode="schematron-select-full-path"/>
                    </axsl:attribute>
                    <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
                </svrl:failed-assert>
            </axsl:otherwise>
        </axsl:choose>
        <axsl:apply-templates select="@*|*" mode="M12"/>
    </axsl:template>

    <!--RULE -->

    <axsl:template match="/ubl:Order/cac:SellerSupplierParty/cac:Party/cac:PartyLegalEntity/cac:RegistrationAddress/*"
                   priority="1232" mode="M12">
        <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                         context="/ubl:Order/cac:SellerSupplierParty/cac:Party/cac:PartyLegalEntity/cac:RegistrationAddress/*"/>

        <!--ASSERT -->

        <axsl:choose>
            <axsl:when test="false()"/>
            <axsl:otherwise>
                <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="false()">
                    <axsl:attribute name="id">PEPPOL-T01-B09002</axsl:attribute>
                    <axsl:attribute name="flag">fatal</axsl:attribute>
                    <axsl:attribute name="location">
                        <axsl:apply-templates select="." mode="schematron-select-full-path"/>
                    </axsl:attribute>
                    <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
                </svrl:failed-assert>
            </axsl:otherwise>
        </axsl:choose>
        <axsl:apply-templates select="@*|*" mode="M12"/>
    </axsl:template>

    <!--RULE -->

    <axsl:template match="/ubl:Order/cac:SellerSupplierParty/cac:Party/cac:PartyLegalEntity/*" priority="1231"
                   mode="M12">
        <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                         context="/ubl:Order/cac:SellerSupplierParty/cac:Party/cac:PartyLegalEntity/*"/>

        <!--ASSERT -->

        <axsl:choose>
            <axsl:when test="false()"/>
            <axsl:otherwise>
                <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="false()">
                    <axsl:attribute name="id">PEPPOL-T01-B08602</axsl:attribute>
                    <axsl:attribute name="flag">fatal</axsl:attribute>
                    <axsl:attribute name="location">
                        <axsl:apply-templates select="." mode="schematron-select-full-path"/>
                    </axsl:attribute>
                    <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
                </svrl:failed-assert>
            </axsl:otherwise>
        </axsl:choose>
        <axsl:apply-templates select="@*|*" mode="M12"/>
    </axsl:template>

    <!--RULE -->

    <axsl:template match="/ubl:Order/cac:SellerSupplierParty/cac:Party/cac:Contact" priority="1230" mode="M12">
        <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                         context="/ubl:Order/cac:SellerSupplierParty/cac:Party/cac:Contact"/>
        <axsl:apply-templates select="@*|*" mode="M12"/>
    </axsl:template>

    <!--RULE -->

    <axsl:template match="/ubl:Order/cac:SellerSupplierParty/cac:Party/cac:Contact/cbc:Name" priority="1229" mode="M12">
        <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                         context="/ubl:Order/cac:SellerSupplierParty/cac:Party/cac:Contact/cbc:Name"/>
        <axsl:apply-templates select="@*|*" mode="M12"/>
    </axsl:template>

    <!--RULE -->

    <axsl:template match="/ubl:Order/cac:SellerSupplierParty/cac:Party/cac:Contact/cbc:Telephone" priority="1228"
                   mode="M12">
        <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                         context="/ubl:Order/cac:SellerSupplierParty/cac:Party/cac:Contact/cbc:Telephone"/>
        <axsl:apply-templates select="@*|*" mode="M12"/>
    </axsl:template>

    <!--RULE -->

    <axsl:template match="/ubl:Order/cac:SellerSupplierParty/cac:Party/cac:Contact/cbc:ElectronicMail" priority="1227"
                   mode="M12">
        <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                         context="/ubl:Order/cac:SellerSupplierParty/cac:Party/cac:Contact/cbc:ElectronicMail"/>
        <axsl:apply-templates select="@*|*" mode="M12"/>
    </axsl:template>

    <!--RULE -->

    <axsl:template match="/ubl:Order/cac:SellerSupplierParty/cac:Party/cac:Contact/*" priority="1226" mode="M12">
        <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                         context="/ubl:Order/cac:SellerSupplierParty/cac:Party/cac:Contact/*"/>

        <!--ASSERT -->

        <axsl:choose>
            <axsl:when test="false()"/>
            <axsl:otherwise>
                <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="false()">
                    <axsl:attribute name="id">PEPPOL-T01-B09401</axsl:attribute>
                    <axsl:attribute name="flag">fatal</axsl:attribute>
                    <axsl:attribute name="location">
                        <axsl:apply-templates select="." mode="schematron-select-full-path"/>
                    </axsl:attribute>
                    <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
                </svrl:failed-assert>
            </axsl:otherwise>
        </axsl:choose>
        <axsl:apply-templates select="@*|*" mode="M12"/>
    </axsl:template>

    <!--RULE -->

    <axsl:template match="/ubl:Order/cac:SellerSupplierParty/cac:Party/*" priority="1225" mode="M12">
        <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                         context="/ubl:Order/cac:SellerSupplierParty/cac:Party/*"/>

        <!--ASSERT -->

        <axsl:choose>
            <axsl:when test="false()"/>
            <axsl:otherwise>
                <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="false()">
                    <axsl:attribute name="id">PEPPOL-T01-B06804</axsl:attribute>
                    <axsl:attribute name="flag">fatal</axsl:attribute>
                    <axsl:attribute name="location">
                        <axsl:apply-templates select="." mode="schematron-select-full-path"/>
                    </axsl:attribute>
                    <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
                </svrl:failed-assert>
            </axsl:otherwise>
        </axsl:choose>
        <axsl:apply-templates select="@*|*" mode="M12"/>
    </axsl:template>

    <!--RULE -->

    <axsl:template match="/ubl:Order/cac:SellerSupplierParty/*" priority="1224" mode="M12">
        <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="/ubl:Order/cac:SellerSupplierParty/*"/>

        <!--ASSERT -->

        <axsl:choose>
            <axsl:when test="false()"/>
            <axsl:otherwise>
                <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="false()">
                    <axsl:attribute name="id">PEPPOL-T01-B06702</axsl:attribute>
                    <axsl:attribute name="flag">fatal</axsl:attribute>
                    <axsl:attribute name="location">
                        <axsl:apply-templates select="." mode="schematron-select-full-path"/>
                    </axsl:attribute>
                    <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
                </svrl:failed-assert>
            </axsl:otherwise>
        </axsl:choose>
        <axsl:apply-templates select="@*|*" mode="M12"/>
    </axsl:template>

    <!--RULE -->

    <axsl:template match="/ubl:Order/cac:OriginatorCustomerParty" priority="1223" mode="M12">
        <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="/ubl:Order/cac:OriginatorCustomerParty"/>

        <!--ASSERT -->

        <axsl:choose>
            <axsl:when test="cac:Party"/>
            <axsl:otherwise>
                <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="cac:Party">
                    <axsl:attribute name="id">PEPPOL-T01-B09801</axsl:attribute>
                    <axsl:attribute name="flag">fatal</axsl:attribute>
                    <axsl:attribute name="location">
                        <axsl:apply-templates select="." mode="schematron-select-full-path"/>
                    </axsl:attribute>
                    <svrl:text>Element 'cac:Party' MUST be provided.</svrl:text>
                </svrl:failed-assert>
            </axsl:otherwise>
        </axsl:choose>
        <axsl:apply-templates select="@*|*" mode="M12"/>
    </axsl:template>

    <!--RULE -->

    <axsl:template match="/ubl:Order/cac:OriginatorCustomerParty/cac:Party" priority="1222" mode="M12">
        <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                         context="/ubl:Order/cac:OriginatorCustomerParty/cac:Party"/>
        <axsl:apply-templates select="@*|*" mode="M12"/>
    </axsl:template>

    <!--RULE -->

    <axsl:template match="/ubl:Order/cac:OriginatorCustomerParty/cac:Party/cac:PartyIdentification" priority="1221"
                   mode="M12">
        <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                         context="/ubl:Order/cac:OriginatorCustomerParty/cac:Party/cac:PartyIdentification"/>

        <!--ASSERT -->

        <axsl:choose>
            <axsl:when test="cbc:ID"/>
            <axsl:otherwise>
                <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="cbc:ID">
                    <axsl:attribute name="id">PEPPOL-T01-B10001</axsl:attribute>
                    <axsl:attribute name="flag">fatal</axsl:attribute>
                    <axsl:attribute name="location">
                        <axsl:apply-templates select="." mode="schematron-select-full-path"/>
                    </axsl:attribute>
                    <svrl:text>Element 'cbc:ID' MUST be provided.</svrl:text>
                </svrl:failed-assert>
            </axsl:otherwise>
        </axsl:choose>
        <axsl:apply-templates select="@*|*" mode="M12"/>
    </axsl:template>

    <!--RULE -->

    <axsl:template match="/ubl:Order/cac:OriginatorCustomerParty/cac:Party/cac:PartyIdentification/cbc:ID"
                   priority="1220" mode="M12">
        <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                         context="/ubl:Order/cac:OriginatorCustomerParty/cac:Party/cac:PartyIdentification/cbc:ID"/>

        <!--ASSERT -->

        <axsl:choose>
            <axsl:when test="not(@schemeID) or (some $code in $clICD satisfies $code = @schemeID)"/>
            <axsl:otherwise>
                <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                    test="not(@schemeID) or (some $code in $clICD satisfies $code = @schemeID)">
                    <axsl:attribute name="id">PEPPOL-T01-B10101</axsl:attribute>
                    <axsl:attribute name="flag">fatal</axsl:attribute>
                    <axsl:attribute name="location">
                        <axsl:apply-templates select="." mode="schematron-select-full-path"/>
                    </axsl:attribute>
                    <svrl:text>Value MUST be part of code list 'ISO 6523 ICD list'.</svrl:text>
                </svrl:failed-assert>
            </axsl:otherwise>
        </axsl:choose>
        <axsl:apply-templates select="@*|*" mode="M12"/>
    </axsl:template>

    <!--RULE -->

    <axsl:template match="/ubl:Order/cac:OriginatorCustomerParty/cac:Party/cac:PartyName" priority="1219" mode="M12">
        <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                         context="/ubl:Order/cac:OriginatorCustomerParty/cac:Party/cac:PartyName"/>

        <!--ASSERT -->

        <axsl:choose>
            <axsl:when test="cbc:Name"/>
            <axsl:otherwise>
                <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="cbc:Name">
                    <axsl:attribute name="id">PEPPOL-T01-B10301</axsl:attribute>
                    <axsl:attribute name="flag">fatal</axsl:attribute>
                    <axsl:attribute name="location">
                        <axsl:apply-templates select="." mode="schematron-select-full-path"/>
                    </axsl:attribute>
                    <svrl:text>Element 'cbc:Name' MUST be provided.</svrl:text>
                </svrl:failed-assert>
            </axsl:otherwise>
        </axsl:choose>
        <axsl:apply-templates select="@*|*" mode="M12"/>
    </axsl:template>

    <!--RULE -->

    <axsl:template match="/ubl:Order/cac:OriginatorCustomerParty/cac:Party/cac:PartyName/cbc:Name" priority="1218"
                   mode="M12">
        <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                         context="/ubl:Order/cac:OriginatorCustomerParty/cac:Party/cac:PartyName/cbc:Name"/>
        <axsl:apply-templates select="@*|*" mode="M12"/>
    </axsl:template>

    <!--RULE -->

    <axsl:template match="/ubl:Order/cac:OriginatorCustomerParty/cac:Party/cac:Contact" priority="1217" mode="M12">
        <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                         context="/ubl:Order/cac:OriginatorCustomerParty/cac:Party/cac:Contact"/>
        <axsl:apply-templates select="@*|*" mode="M12"/>
    </axsl:template>

    <!--RULE -->

    <axsl:template match="/ubl:Order/cac:OriginatorCustomerParty/cac:Party/cac:Contact/cbc:Name" priority="1216"
                   mode="M12">
        <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                         context="/ubl:Order/cac:OriginatorCustomerParty/cac:Party/cac:Contact/cbc:Name"/>
        <axsl:apply-templates select="@*|*" mode="M12"/>
    </axsl:template>

    <!--RULE -->

    <axsl:template match="/ubl:Order/cac:OriginatorCustomerParty/cac:Party/cac:Contact/cbc:Telephone" priority="1215"
                   mode="M12">
        <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                         context="/ubl:Order/cac:OriginatorCustomerParty/cac:Party/cac:Contact/cbc:Telephone"/>
        <axsl:apply-templates select="@*|*" mode="M12"/>
    </axsl:template>

    <!--RULE -->

    <axsl:template match="/ubl:Order/cac:OriginatorCustomerParty/cac:Party/cac:Contact/cbc:ElectronicMail"
                   priority="1214" mode="M12">
        <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                         context="/ubl:Order/cac:OriginatorCustomerParty/cac:Party/cac:Contact/cbc:ElectronicMail"/>
        <axsl:apply-templates select="@*|*" mode="M12"/>
    </axsl:template>

    <!--RULE -->

    <axsl:template match="/ubl:Order/cac:OriginatorCustomerParty/cac:Party/cac:Contact/*" priority="1213" mode="M12">
        <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                         context="/ubl:Order/cac:OriginatorCustomerParty/cac:Party/cac:Contact/*"/>

        <!--ASSERT -->

        <axsl:choose>
            <axsl:when test="false()"/>
            <axsl:otherwise>
                <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="false()">
                    <axsl:attribute name="id">PEPPOL-T01-B10501</axsl:attribute>
                    <axsl:attribute name="flag">fatal</axsl:attribute>
                    <axsl:attribute name="location">
                        <axsl:apply-templates select="." mode="schematron-select-full-path"/>
                    </axsl:attribute>
                    <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
                </svrl:failed-assert>
            </axsl:otherwise>
        </axsl:choose>
        <axsl:apply-templates select="@*|*" mode="M12"/>
    </axsl:template>

    <!--RULE -->

    <axsl:template match="/ubl:Order/cac:OriginatorCustomerParty/cac:Party/*" priority="1212" mode="M12">
        <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                         context="/ubl:Order/cac:OriginatorCustomerParty/cac:Party/*"/>

        <!--ASSERT -->

        <axsl:choose>
            <axsl:when test="false()"/>
            <axsl:otherwise>
                <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="false()">
                    <axsl:attribute name="id">PEPPOL-T01-B09901</axsl:attribute>
                    <axsl:attribute name="flag">fatal</axsl:attribute>
                    <axsl:attribute name="location">
                        <axsl:apply-templates select="." mode="schematron-select-full-path"/>
                    </axsl:attribute>
                    <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
                </svrl:failed-assert>
            </axsl:otherwise>
        </axsl:choose>
        <axsl:apply-templates select="@*|*" mode="M12"/>
    </axsl:template>

    <!--RULE -->

    <axsl:template match="/ubl:Order/cac:OriginatorCustomerParty/*" priority="1211" mode="M12">
        <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                         context="/ubl:Order/cac:OriginatorCustomerParty/*"/>

        <!--ASSERT -->

        <axsl:choose>
            <axsl:when test="false()"/>
            <axsl:otherwise>
                <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="false()">
                    <axsl:attribute name="id">PEPPOL-T01-B09802</axsl:attribute>
                    <axsl:attribute name="flag">fatal</axsl:attribute>
                    <axsl:attribute name="location">
                        <axsl:apply-templates select="." mode="schematron-select-full-path"/>
                    </axsl:attribute>
                    <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
                </svrl:failed-assert>
            </axsl:otherwise>
        </axsl:choose>
        <axsl:apply-templates select="@*|*" mode="M12"/>
    </axsl:template>

    <!--RULE -->

    <axsl:template match="/ubl:Order/cac:AccountingCustomerParty" priority="1210" mode="M12">
        <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="/ubl:Order/cac:AccountingCustomerParty"/>

        <!--ASSERT -->

        <axsl:choose>
            <axsl:when test="cac:Party"/>
            <axsl:otherwise>
                <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="cac:Party">
                    <axsl:attribute name="id">PEPPOL-T01-B10901</axsl:attribute>
                    <axsl:attribute name="flag">fatal</axsl:attribute>
                    <axsl:attribute name="location">
                        <axsl:apply-templates select="." mode="schematron-select-full-path"/>
                    </axsl:attribute>
                    <svrl:text>Element 'cac:Party' MUST be provided.</svrl:text>
                </svrl:failed-assert>
            </axsl:otherwise>
        </axsl:choose>
        <axsl:apply-templates select="@*|*" mode="M12"/>
    </axsl:template>

    <!--RULE -->

    <axsl:template match="/ubl:Order/cac:AccountingCustomerParty/cac:Party" priority="1209" mode="M12">
        <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                         context="/ubl:Order/cac:AccountingCustomerParty/cac:Party"/>

        <!--ASSERT -->

        <axsl:choose>
            <axsl:when test="cac:PostalAddress"/>
            <axsl:otherwise>
                <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="cac:PostalAddress">
                    <axsl:attribute name="id">PEPPOL-T01-B11001</axsl:attribute>
                    <axsl:attribute name="flag">fatal</axsl:attribute>
                    <axsl:attribute name="location">
                        <axsl:apply-templates select="." mode="schematron-select-full-path"/>
                    </axsl:attribute>
                    <svrl:text>Element 'cac:PostalAddress' MUST be provided.</svrl:text>
                </svrl:failed-assert>
            </axsl:otherwise>
        </axsl:choose>

        <!--ASSERT -->

        <axsl:choose>
            <axsl:when test="cac:PartyLegalEntity"/>
            <axsl:otherwise>
                <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="cac:PartyLegalEntity">
                    <axsl:attribute name="id">PEPPOL-T01-B11002</axsl:attribute>
                    <axsl:attribute name="flag">fatal</axsl:attribute>
                    <axsl:attribute name="location">
                        <axsl:apply-templates select="." mode="schematron-select-full-path"/>
                    </axsl:attribute>
                    <svrl:text>Element 'cac:PartyLegalEntity' MUST be provided.</svrl:text>
                </svrl:failed-assert>
            </axsl:otherwise>
        </axsl:choose>
        <axsl:apply-templates select="@*|*" mode="M12"/>
    </axsl:template>

    <!--RULE -->

    <axsl:template match="/ubl:Order/cac:AccountingCustomerParty/cac:Party/cbc:EndpointID" priority="1208" mode="M12">
        <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                         context="/ubl:Order/cac:AccountingCustomerParty/cac:Party/cbc:EndpointID"/>

        <!--ASSERT -->

        <axsl:choose>
            <axsl:when test="@schemeID"/>
            <axsl:otherwise>
                <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="@schemeID">
                    <axsl:attribute name="id">PEPPOL-T01-B11101</axsl:attribute>
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
                <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                    test="not(@schemeID) or (some $code in $cleas satisfies $code = @schemeID)">
                    <axsl:attribute name="id">PEPPOL-T01-B11102</axsl:attribute>
                    <axsl:attribute name="flag">fatal</axsl:attribute>
                    <axsl:attribute name="location">
                        <axsl:apply-templates select="." mode="schematron-select-full-path"/>
                    </axsl:attribute>
                    <svrl:text>Value MUST be part of code list 'Electronic Address Scheme (EAS)'.</svrl:text>
                </svrl:failed-assert>
            </axsl:otherwise>
        </axsl:choose>
        <axsl:apply-templates select="@*|*" mode="M12"/>
    </axsl:template>

    <!--RULE -->

    <axsl:template match="/ubl:Order/cac:AccountingCustomerParty/cac:Party/cac:PartyIdentification" priority="1207"
                   mode="M12">
        <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                         context="/ubl:Order/cac:AccountingCustomerParty/cac:Party/cac:PartyIdentification"/>

        <!--ASSERT -->

        <axsl:choose>
            <axsl:when test="cbc:ID"/>
            <axsl:otherwise>
                <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="cbc:ID">
                    <axsl:attribute name="id">PEPPOL-T01-B11301</axsl:attribute>
                    <axsl:attribute name="flag">fatal</axsl:attribute>
                    <axsl:attribute name="location">
                        <axsl:apply-templates select="." mode="schematron-select-full-path"/>
                    </axsl:attribute>
                    <svrl:text>Element 'cbc:ID' MUST be provided.</svrl:text>
                </svrl:failed-assert>
            </axsl:otherwise>
        </axsl:choose>
        <axsl:apply-templates select="@*|*" mode="M12"/>
    </axsl:template>

    <!--RULE -->

    <axsl:template match="/ubl:Order/cac:AccountingCustomerParty/cac:Party/cac:PartyIdentification/cbc:ID"
                   priority="1206" mode="M12">
        <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                         context="/ubl:Order/cac:AccountingCustomerParty/cac:Party/cac:PartyIdentification/cbc:ID"/>

        <!--ASSERT -->

        <axsl:choose>
            <axsl:when test="not(@schemeID) or (some $code in $clICD satisfies $code = @schemeID)"/>
            <axsl:otherwise>
                <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                    test="not(@schemeID) or (some $code in $clICD satisfies $code = @schemeID)">
                    <axsl:attribute name="id">PEPPOL-T01-B11401</axsl:attribute>
                    <axsl:attribute name="flag">fatal</axsl:attribute>
                    <axsl:attribute name="location">
                        <axsl:apply-templates select="." mode="schematron-select-full-path"/>
                    </axsl:attribute>
                    <svrl:text>Value MUST be part of code list 'ISO 6523 ICD list'.</svrl:text>
                </svrl:failed-assert>
            </axsl:otherwise>
        </axsl:choose>
        <axsl:apply-templates select="@*|*" mode="M12"/>
    </axsl:template>

    <!--RULE -->

    <axsl:template match="/ubl:Order/cac:AccountingCustomerParty/cac:Party/cac:PartyName" priority="1205" mode="M12">
        <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                         context="/ubl:Order/cac:AccountingCustomerParty/cac:Party/cac:PartyName"/>

        <!--ASSERT -->

        <axsl:choose>
            <axsl:when test="cbc:Name"/>
            <axsl:otherwise>
                <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="cbc:Name">
                    <axsl:attribute name="id">PEPPOL-T01-B11601</axsl:attribute>
                    <axsl:attribute name="flag">fatal</axsl:attribute>
                    <axsl:attribute name="location">
                        <axsl:apply-templates select="." mode="schematron-select-full-path"/>
                    </axsl:attribute>
                    <svrl:text>Element 'cbc:Name' MUST be provided.</svrl:text>
                </svrl:failed-assert>
            </axsl:otherwise>
        </axsl:choose>
        <axsl:apply-templates select="@*|*" mode="M12"/>
    </axsl:template>

    <!--RULE -->

    <axsl:template match="/ubl:Order/cac:AccountingCustomerParty/cac:Party/cac:PartyName/cbc:Name" priority="1204"
                   mode="M12">
        <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                         context="/ubl:Order/cac:AccountingCustomerParty/cac:Party/cac:PartyName/cbc:Name"/>
        <axsl:apply-templates select="@*|*" mode="M12"/>
    </axsl:template>

    <!--RULE -->

    <axsl:template match="/ubl:Order/cac:AccountingCustomerParty/cac:Party/cac:PostalAddress" priority="1203"
                   mode="M12">
        <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                         context="/ubl:Order/cac:AccountingCustomerParty/cac:Party/cac:PostalAddress"/>

        <!--ASSERT -->

        <axsl:choose>
            <axsl:when test="cac:Country"/>
            <axsl:otherwise>
                <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="cac:Country">
                    <axsl:attribute name="id">PEPPOL-T01-B11801</axsl:attribute>
                    <axsl:attribute name="flag">fatal</axsl:attribute>
                    <axsl:attribute name="location">
                        <axsl:apply-templates select="." mode="schematron-select-full-path"/>
                    </axsl:attribute>
                    <svrl:text>Element 'cac:Country' MUST be provided.</svrl:text>
                </svrl:failed-assert>
            </axsl:otherwise>
        </axsl:choose>
        <axsl:apply-templates select="@*|*" mode="M12"/>
    </axsl:template>

    <!--RULE -->

    <axsl:template match="/ubl:Order/cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cbc:StreetName"
                   priority="1202" mode="M12">
        <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                         context="/ubl:Order/cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cbc:StreetName"/>
        <axsl:apply-templates select="@*|*" mode="M12"/>
    </axsl:template>

    <!--RULE -->

    <axsl:template match="/ubl:Order/cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cbc:AdditionalStreetName"
                   priority="1201" mode="M12">
        <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                         context="/ubl:Order/cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cbc:AdditionalStreetName"/>
        <axsl:apply-templates select="@*|*" mode="M12"/>
    </axsl:template>

    <!--RULE -->

    <axsl:template match="/ubl:Order/cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cbc:CityName"
                   priority="1200" mode="M12">
        <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                         context="/ubl:Order/cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cbc:CityName"/>
        <axsl:apply-templates select="@*|*" mode="M12"/>
    </axsl:template>

    <!--RULE -->

    <axsl:template match="/ubl:Order/cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cbc:PostalZone"
                   priority="1199" mode="M12">
        <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                         context="/ubl:Order/cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cbc:PostalZone"/>
        <axsl:apply-templates select="@*|*" mode="M12"/>
    </axsl:template>

    <!--RULE -->

    <axsl:template match="/ubl:Order/cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cbc:CountrySubentity"
                   priority="1198" mode="M12">
        <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                         context="/ubl:Order/cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cbc:CountrySubentity"/>
        <axsl:apply-templates select="@*|*" mode="M12"/>
    </axsl:template>

    <!--RULE -->

    <axsl:template match="/ubl:Order/cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cac:AddressLine"
                   priority="1197" mode="M12">
        <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                         context="/ubl:Order/cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cac:AddressLine"/>
        <axsl:apply-templates select="@*|*" mode="M12"/>
    </axsl:template>

    <!--RULE -->

    <axsl:template match="/ubl:Order/cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cac:AddressLine/cbc:Line"
                   priority="1196" mode="M12">
        <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                         context="/ubl:Order/cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cac:AddressLine/cbc:Line"/>
        <axsl:apply-templates select="@*|*" mode="M12"/>
    </axsl:template>

    <!--RULE -->

    <axsl:template match="/ubl:Order/cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cac:Country"
                   priority="1195" mode="M12">
        <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                         context="/ubl:Order/cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cac:Country"/>

        <!--ASSERT -->

        <axsl:choose>
            <axsl:when test="cbc:IdentificationCode"/>
            <axsl:otherwise>
                <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="cbc:IdentificationCode">
                    <axsl:attribute name="id">PEPPOL-T01-B12601</axsl:attribute>
                    <axsl:attribute name="flag">fatal</axsl:attribute>
                    <axsl:attribute name="location">
                        <axsl:apply-templates select="." mode="schematron-select-full-path"/>
                    </axsl:attribute>
                    <svrl:text>Element 'cbc:IdentificationCode' MUST be provided.</svrl:text>
                </svrl:failed-assert>
            </axsl:otherwise>
        </axsl:choose>
        <axsl:apply-templates select="@*|*" mode="M12"/>
    </axsl:template>

    <!--RULE -->

    <axsl:template
            match="/ubl:Order/cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode"
            priority="1194" mode="M12">
        <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                         context="/ubl:Order/cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode"/>

        <!--ASSERT -->

        <axsl:choose>
            <axsl:when test="(some $code in $clISO3166 satisfies $code = normalize-space(text()))"/>
            <axsl:otherwise>
                <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                    test="(some $code in $clISO3166 satisfies $code = normalize-space(text()))">
                    <axsl:attribute name="id">PEPPOL-T01-B12701</axsl:attribute>
                    <axsl:attribute name="flag">fatal</axsl:attribute>
                    <axsl:attribute name="location">
                        <axsl:apply-templates select="." mode="schematron-select-full-path"/>
                    </axsl:attribute>
                    <svrl:text>Value MUST be part of code list 'Country codes (ISO 3166-1:Alpha2)'.</svrl:text>
                </svrl:failed-assert>
            </axsl:otherwise>
        </axsl:choose>
        <axsl:apply-templates select="@*|*" mode="M12"/>
    </axsl:template>

    <!--RULE -->

    <axsl:template match="/ubl:Order/cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cac:Country/*"
                   priority="1193" mode="M12">
        <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                         context="/ubl:Order/cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cac:Country/*"/>

        <!--ASSERT -->

        <axsl:choose>
            <axsl:when test="false()"/>
            <axsl:otherwise>
                <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="false()">
                    <axsl:attribute name="id">PEPPOL-T01-B12602</axsl:attribute>
                    <axsl:attribute name="flag">fatal</axsl:attribute>
                    <axsl:attribute name="location">
                        <axsl:apply-templates select="." mode="schematron-select-full-path"/>
                    </axsl:attribute>
                    <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
                </svrl:failed-assert>
            </axsl:otherwise>
        </axsl:choose>
        <axsl:apply-templates select="@*|*" mode="M12"/>
    </axsl:template>

    <!--RULE -->

    <axsl:template match="/ubl:Order/cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/*" priority="1192"
                   mode="M12">
        <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                         context="/ubl:Order/cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/*"/>

        <!--ASSERT -->

        <axsl:choose>
            <axsl:when test="false()"/>
            <axsl:otherwise>
                <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="false()">
                    <axsl:attribute name="id">PEPPOL-T01-B11802</axsl:attribute>
                    <axsl:attribute name="flag">fatal</axsl:attribute>
                    <axsl:attribute name="location">
                        <axsl:apply-templates select="." mode="schematron-select-full-path"/>
                    </axsl:attribute>
                    <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
                </svrl:failed-assert>
            </axsl:otherwise>
        </axsl:choose>
        <axsl:apply-templates select="@*|*" mode="M12"/>
    </axsl:template>

    <!--RULE -->

    <axsl:template match="/ubl:Order/cac:AccountingCustomerParty/cac:Party/cac:PartyTaxScheme" priority="1191"
                   mode="M12">
        <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                         context="/ubl:Order/cac:AccountingCustomerParty/cac:Party/cac:PartyTaxScheme"/>

        <!--ASSERT -->

        <axsl:choose>
            <axsl:when test="cbc:CompanyID"/>
            <axsl:otherwise>
                <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="cbc:CompanyID">
                    <axsl:attribute name="id">PEPPOL-T01-B12801</axsl:attribute>
                    <axsl:attribute name="flag">fatal</axsl:attribute>
                    <axsl:attribute name="location">
                        <axsl:apply-templates select="." mode="schematron-select-full-path"/>
                    </axsl:attribute>
                    <svrl:text>Element 'cbc:CompanyID' MUST be provided.</svrl:text>
                </svrl:failed-assert>
            </axsl:otherwise>
        </axsl:choose>

        <!--ASSERT -->

        <axsl:choose>
            <axsl:when test="cac:TaxScheme"/>
            <axsl:otherwise>
                <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="cac:TaxScheme">
                    <axsl:attribute name="id">PEPPOL-T01-B12802</axsl:attribute>
                    <axsl:attribute name="flag">fatal</axsl:attribute>
                    <axsl:attribute name="location">
                        <axsl:apply-templates select="." mode="schematron-select-full-path"/>
                    </axsl:attribute>
                    <svrl:text>Element 'cac:TaxScheme' MUST be provided.</svrl:text>
                </svrl:failed-assert>
            </axsl:otherwise>
        </axsl:choose>
        <axsl:apply-templates select="@*|*" mode="M12"/>
    </axsl:template>

    <!--RULE -->

    <axsl:template match="/ubl:Order/cac:AccountingCustomerParty/cac:Party/cac:PartyTaxScheme/cbc:CompanyID"
                   priority="1190" mode="M12">
        <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                         context="/ubl:Order/cac:AccountingCustomerParty/cac:Party/cac:PartyTaxScheme/cbc:CompanyID"/>
        <axsl:apply-templates select="@*|*" mode="M12"/>
    </axsl:template>

    <!--RULE -->

    <axsl:template match="/ubl:Order/cac:AccountingCustomerParty/cac:Party/cac:PartyTaxScheme/cac:TaxScheme"
                   priority="1189" mode="M12">
        <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                         context="/ubl:Order/cac:AccountingCustomerParty/cac:Party/cac:PartyTaxScheme/cac:TaxScheme"/>

        <!--ASSERT -->

        <axsl:choose>
            <axsl:when test="cbc:ID"/>
            <axsl:otherwise>
                <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="cbc:ID">
                    <axsl:attribute name="id">PEPPOL-T01-B13001</axsl:attribute>
                    <axsl:attribute name="flag">fatal</axsl:attribute>
                    <axsl:attribute name="location">
                        <axsl:apply-templates select="." mode="schematron-select-full-path"/>
                    </axsl:attribute>
                    <svrl:text>Element 'cbc:ID' MUST be provided.</svrl:text>
                </svrl:failed-assert>
            </axsl:otherwise>
        </axsl:choose>
        <axsl:apply-templates select="@*|*" mode="M12"/>
    </axsl:template>

    <!--RULE -->

    <axsl:template match="/ubl:Order/cac:AccountingCustomerParty/cac:Party/cac:PartyTaxScheme/cac:TaxScheme/cbc:ID"
                   priority="1188" mode="M12">
        <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                         context="/ubl:Order/cac:AccountingCustomerParty/cac:Party/cac:PartyTaxScheme/cac:TaxScheme/cbc:ID"/>
        <axsl:apply-templates select="@*|*" mode="M12"/>
    </axsl:template>

    <!--RULE -->

    <axsl:template match="/ubl:Order/cac:AccountingCustomerParty/cac:Party/cac:PartyTaxScheme/cac:TaxScheme/*"
                   priority="1187" mode="M12">
        <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                         context="/ubl:Order/cac:AccountingCustomerParty/cac:Party/cac:PartyTaxScheme/cac:TaxScheme/*"/>

        <!--ASSERT -->

        <axsl:choose>
            <axsl:when test="false()"/>
            <axsl:otherwise>
                <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="false()">
                    <axsl:attribute name="id">PEPPOL-T01-B13002</axsl:attribute>
                    <axsl:attribute name="flag">fatal</axsl:attribute>
                    <axsl:attribute name="location">
                        <axsl:apply-templates select="." mode="schematron-select-full-path"/>
                    </axsl:attribute>
                    <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
                </svrl:failed-assert>
            </axsl:otherwise>
        </axsl:choose>
        <axsl:apply-templates select="@*|*" mode="M12"/>
    </axsl:template>

    <!--RULE -->

    <axsl:template match="/ubl:Order/cac:AccountingCustomerParty/cac:Party/cac:PartyTaxScheme/*" priority="1186"
                   mode="M12">
        <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                         context="/ubl:Order/cac:AccountingCustomerParty/cac:Party/cac:PartyTaxScheme/*"/>

        <!--ASSERT -->

        <axsl:choose>
            <axsl:when test="false()"/>
            <axsl:otherwise>
                <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="false()">
                    <axsl:attribute name="id">PEPPOL-T01-B12803</axsl:attribute>
                    <axsl:attribute name="flag">fatal</axsl:attribute>
                    <axsl:attribute name="location">
                        <axsl:apply-templates select="." mode="schematron-select-full-path"/>
                    </axsl:attribute>
                    <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
                </svrl:failed-assert>
            </axsl:otherwise>
        </axsl:choose>
        <axsl:apply-templates select="@*|*" mode="M12"/>
    </axsl:template>

    <!--RULE -->

    <axsl:template match="/ubl:Order/cac:AccountingCustomerParty/cac:Party/cac:PartyLegalEntity" priority="1185"
                   mode="M12">
        <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                         context="/ubl:Order/cac:AccountingCustomerParty/cac:Party/cac:PartyLegalEntity"/>

        <!--ASSERT -->

        <axsl:choose>
            <axsl:when test="cbc:RegistrationName"/>
            <axsl:otherwise>
                <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="cbc:RegistrationName">
                    <axsl:attribute name="id">PEPPOL-T01-B13201</axsl:attribute>
                    <axsl:attribute name="flag">fatal</axsl:attribute>
                    <axsl:attribute name="location">
                        <axsl:apply-templates select="." mode="schematron-select-full-path"/>
                    </axsl:attribute>
                    <svrl:text>Element 'cbc:RegistrationName' MUST be provided.</svrl:text>
                </svrl:failed-assert>
            </axsl:otherwise>
        </axsl:choose>
        <axsl:apply-templates select="@*|*" mode="M12"/>
    </axsl:template>

    <!--RULE -->

    <axsl:template match="/ubl:Order/cac:AccountingCustomerParty/cac:Party/cac:PartyLegalEntity/cbc:RegistrationName"
                   priority="1184" mode="M12">
        <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                         context="/ubl:Order/cac:AccountingCustomerParty/cac:Party/cac:PartyLegalEntity/cbc:RegistrationName"/>
        <axsl:apply-templates select="@*|*" mode="M12"/>
    </axsl:template>

    <!--RULE -->

    <axsl:template match="/ubl:Order/cac:AccountingCustomerParty/cac:Party/cac:PartyLegalEntity/cbc:CompanyID"
                   priority="1183" mode="M12">
        <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                         context="/ubl:Order/cac:AccountingCustomerParty/cac:Party/cac:PartyLegalEntity/cbc:CompanyID"/>

        <!--ASSERT -->

        <axsl:choose>
            <axsl:when test="not(@schemeID) or (some $code in $clICD satisfies $code = @schemeID)"/>
            <axsl:otherwise>
                <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                    test="not(@schemeID) or (some $code in $clICD satisfies $code = @schemeID)">
                    <axsl:attribute name="id">PEPPOL-T01-B13401</axsl:attribute>
                    <axsl:attribute name="flag">fatal</axsl:attribute>
                    <axsl:attribute name="location">
                        <axsl:apply-templates select="." mode="schematron-select-full-path"/>
                    </axsl:attribute>
                    <svrl:text>Value MUST be part of code list 'ISO 6523 ICD list'.</svrl:text>
                </svrl:failed-assert>
            </axsl:otherwise>
        </axsl:choose>
        <axsl:apply-templates select="@*|*" mode="M12"/>
    </axsl:template>

    <!--RULE -->

    <axsl:template match="/ubl:Order/cac:AccountingCustomerParty/cac:Party/cac:PartyLegalEntity/cac:RegistrationAddress"
                   priority="1182" mode="M12">
        <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                         context="/ubl:Order/cac:AccountingCustomerParty/cac:Party/cac:PartyLegalEntity/cac:RegistrationAddress"/>

        <!--ASSERT -->

        <axsl:choose>
            <axsl:when test="cac:Country"/>
            <axsl:otherwise>
                <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="cac:Country">
                    <axsl:attribute name="id">PEPPOL-T01-B13601</axsl:attribute>
                    <axsl:attribute name="flag">fatal</axsl:attribute>
                    <axsl:attribute name="location">
                        <axsl:apply-templates select="." mode="schematron-select-full-path"/>
                    </axsl:attribute>
                    <svrl:text>Element 'cac:Country' MUST be provided.</svrl:text>
                </svrl:failed-assert>
            </axsl:otherwise>
        </axsl:choose>
        <axsl:apply-templates select="@*|*" mode="M12"/>
    </axsl:template>

    <!--RULE -->

    <axsl:template
            match="/ubl:Order/cac:AccountingCustomerParty/cac:Party/cac:PartyLegalEntity/cac:RegistrationAddress/cbc:CityName"
            priority="1181" mode="M12">
        <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                         context="/ubl:Order/cac:AccountingCustomerParty/cac:Party/cac:PartyLegalEntity/cac:RegistrationAddress/cbc:CityName"/>
        <axsl:apply-templates select="@*|*" mode="M12"/>
    </axsl:template>

    <!--RULE -->

    <axsl:template
            match="/ubl:Order/cac:AccountingCustomerParty/cac:Party/cac:PartyLegalEntity/cac:RegistrationAddress/cac:Country"
            priority="1180" mode="M12">
        <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                         context="/ubl:Order/cac:AccountingCustomerParty/cac:Party/cac:PartyLegalEntity/cac:RegistrationAddress/cac:Country"/>

        <!--ASSERT -->

        <axsl:choose>
            <axsl:when test="cbc:IdentificationCode"/>
            <axsl:otherwise>
                <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="cbc:IdentificationCode">
                    <axsl:attribute name="id">PEPPOL-T01-B13801</axsl:attribute>
                    <axsl:attribute name="flag">fatal</axsl:attribute>
                    <axsl:attribute name="location">
                        <axsl:apply-templates select="." mode="schematron-select-full-path"/>
                    </axsl:attribute>
                    <svrl:text>Element 'cbc:IdentificationCode' MUST be provided.</svrl:text>
                </svrl:failed-assert>
            </axsl:otherwise>
        </axsl:choose>
        <axsl:apply-templates select="@*|*" mode="M12"/>
    </axsl:template>

    <!--RULE -->

    <axsl:template
            match="/ubl:Order/cac:AccountingCustomerParty/cac:Party/cac:PartyLegalEntity/cac:RegistrationAddress/cac:Country/cbc:IdentificationCode"
            priority="1179" mode="M12">
        <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                         context="/ubl:Order/cac:AccountingCustomerParty/cac:Party/cac:PartyLegalEntity/cac:RegistrationAddress/cac:Country/cbc:IdentificationCode"/>

        <!--ASSERT -->

        <axsl:choose>
            <axsl:when test="(some $code in $clISO3166 satisfies $code = normalize-space(text()))"/>
            <axsl:otherwise>
                <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                    test="(some $code in $clISO3166 satisfies $code = normalize-space(text()))">
                    <axsl:attribute name="id">PEPPOL-T01-B13901</axsl:attribute>
                    <axsl:attribute name="flag">fatal</axsl:attribute>
                    <axsl:attribute name="location">
                        <axsl:apply-templates select="." mode="schematron-select-full-path"/>
                    </axsl:attribute>
                    <svrl:text>Value MUST be part of code list 'Country codes (ISO 3166-1:Alpha2)'.</svrl:text>
                </svrl:failed-assert>
            </axsl:otherwise>
        </axsl:choose>
        <axsl:apply-templates select="@*|*" mode="M12"/>
    </axsl:template>

    <!--RULE -->

    <axsl:template
            match="/ubl:Order/cac:AccountingCustomerParty/cac:Party/cac:PartyLegalEntity/cac:RegistrationAddress/cac:Country/*"
            priority="1178" mode="M12">
        <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                         context="/ubl:Order/cac:AccountingCustomerParty/cac:Party/cac:PartyLegalEntity/cac:RegistrationAddress/cac:Country/*"/>

        <!--ASSERT -->

        <axsl:choose>
            <axsl:when test="false()"/>
            <axsl:otherwise>
                <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="false()">
                    <axsl:attribute name="id">PEPPOL-T01-B13802</axsl:attribute>
                    <axsl:attribute name="flag">fatal</axsl:attribute>
                    <axsl:attribute name="location">
                        <axsl:apply-templates select="." mode="schematron-select-full-path"/>
                    </axsl:attribute>
                    <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
                </svrl:failed-assert>
            </axsl:otherwise>
        </axsl:choose>
        <axsl:apply-templates select="@*|*" mode="M12"/>
    </axsl:template>

    <!--RULE -->

    <axsl:template
            match="/ubl:Order/cac:AccountingCustomerParty/cac:Party/cac:PartyLegalEntity/cac:RegistrationAddress/*"
            priority="1177" mode="M12">
        <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                         context="/ubl:Order/cac:AccountingCustomerParty/cac:Party/cac:PartyLegalEntity/cac:RegistrationAddress/*"/>

        <!--ASSERT -->

        <axsl:choose>
            <axsl:when test="false()"/>
            <axsl:otherwise>
                <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="false()">
                    <axsl:attribute name="id">PEPPOL-T01-B13602</axsl:attribute>
                    <axsl:attribute name="flag">fatal</axsl:attribute>
                    <axsl:attribute name="location">
                        <axsl:apply-templates select="." mode="schematron-select-full-path"/>
                    </axsl:attribute>
                    <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
                </svrl:failed-assert>
            </axsl:otherwise>
        </axsl:choose>
        <axsl:apply-templates select="@*|*" mode="M12"/>
    </axsl:template>

    <!--RULE -->

    <axsl:template match="/ubl:Order/cac:AccountingCustomerParty/cac:Party/cac:PartyLegalEntity/*" priority="1176"
                   mode="M12">
        <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                         context="/ubl:Order/cac:AccountingCustomerParty/cac:Party/cac:PartyLegalEntity/*"/>

        <!--ASSERT -->

        <axsl:choose>
            <axsl:when test="false()"/>
            <axsl:otherwise>
                <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="false()">
                    <axsl:attribute name="id">PEPPOL-T01-B13202</axsl:attribute>
                    <axsl:attribute name="flag">fatal</axsl:attribute>
                    <axsl:attribute name="location">
                        <axsl:apply-templates select="." mode="schematron-select-full-path"/>
                    </axsl:attribute>
                    <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
                </svrl:failed-assert>
            </axsl:otherwise>
        </axsl:choose>
        <axsl:apply-templates select="@*|*" mode="M12"/>
    </axsl:template>

    <!--RULE -->

    <axsl:template match="/ubl:Order/cac:AccountingCustomerParty/cac:Party/cac:Contact" priority="1175" mode="M12">
        <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                         context="/ubl:Order/cac:AccountingCustomerParty/cac:Party/cac:Contact"/>
        <axsl:apply-templates select="@*|*" mode="M12"/>
    </axsl:template>

    <!--RULE -->

    <axsl:template match="/ubl:Order/cac:AccountingCustomerParty/cac:Party/cac:Contact/cbc:Name" priority="1174"
                   mode="M12">
        <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                         context="/ubl:Order/cac:AccountingCustomerParty/cac:Party/cac:Contact/cbc:Name"/>
        <axsl:apply-templates select="@*|*" mode="M12"/>
    </axsl:template>

    <!--RULE -->

    <axsl:template match="/ubl:Order/cac:AccountingCustomerParty/cac:Party/cac:Contact/cbc:Telephone" priority="1173"
                   mode="M12">
        <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                         context="/ubl:Order/cac:AccountingCustomerParty/cac:Party/cac:Contact/cbc:Telephone"/>
        <axsl:apply-templates select="@*|*" mode="M12"/>
    </axsl:template>

    <!--RULE -->

    <axsl:template match="/ubl:Order/cac:AccountingCustomerParty/cac:Party/cac:Contact/cbc:ElectronicMail"
                   priority="1172" mode="M12">
        <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                         context="/ubl:Order/cac:AccountingCustomerParty/cac:Party/cac:Contact/cbc:ElectronicMail"/>
        <axsl:apply-templates select="@*|*" mode="M12"/>
    </axsl:template>

    <!--RULE -->

    <axsl:template match="/ubl:Order/cac:AccountingCustomerParty/cac:Party/cac:Contact/*" priority="1171" mode="M12">
        <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                         context="/ubl:Order/cac:AccountingCustomerParty/cac:Party/cac:Contact/*"/>

        <!--ASSERT -->

        <axsl:choose>
            <axsl:when test="false()"/>
            <axsl:otherwise>
                <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="false()">
                    <axsl:attribute name="id">PEPPOL-T01-B14001</axsl:attribute>
                    <axsl:attribute name="flag">fatal</axsl:attribute>
                    <axsl:attribute name="location">
                        <axsl:apply-templates select="." mode="schematron-select-full-path"/>
                    </axsl:attribute>
                    <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
                </svrl:failed-assert>
            </axsl:otherwise>
        </axsl:choose>
        <axsl:apply-templates select="@*|*" mode="M12"/>
    </axsl:template>

    <!--RULE -->

    <axsl:template match="/ubl:Order/cac:AccountingCustomerParty/cac:Party/*" priority="1170" mode="M12">
        <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                         context="/ubl:Order/cac:AccountingCustomerParty/cac:Party/*"/>

        <!--ASSERT -->

        <axsl:choose>
            <axsl:when test="false()"/>
            <axsl:otherwise>
                <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="false()">
                    <axsl:attribute name="id">PEPPOL-T01-B11003</axsl:attribute>
                    <axsl:attribute name="flag">fatal</axsl:attribute>
                    <axsl:attribute name="location">
                        <axsl:apply-templates select="." mode="schematron-select-full-path"/>
                    </axsl:attribute>
                    <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
                </svrl:failed-assert>
            </axsl:otherwise>
        </axsl:choose>
        <axsl:apply-templates select="@*|*" mode="M12"/>
    </axsl:template>

    <!--RULE -->

    <axsl:template match="/ubl:Order/cac:AccountingCustomerParty/*" priority="1169" mode="M12">
        <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                         context="/ubl:Order/cac:AccountingCustomerParty/*"/>

        <!--ASSERT -->

        <axsl:choose>
            <axsl:when test="false()"/>
            <axsl:otherwise>
                <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="false()">
                    <axsl:attribute name="id">PEPPOL-T01-B10902</axsl:attribute>
                    <axsl:attribute name="flag">fatal</axsl:attribute>
                    <axsl:attribute name="location">
                        <axsl:apply-templates select="." mode="schematron-select-full-path"/>
                    </axsl:attribute>
                    <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
                </svrl:failed-assert>
            </axsl:otherwise>
        </axsl:choose>
        <axsl:apply-templates select="@*|*" mode="M12"/>
    </axsl:template>

    <!--RULE -->

    <axsl:template match="/ubl:Order/cac:Delivery" priority="1168" mode="M12">
        <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="/ubl:Order/cac:Delivery"/>
        <axsl:apply-templates select="@*|*" mode="M12"/>
    </axsl:template>

    <!--RULE -->

    <axsl:template match="/ubl:Order/cac:Delivery/cac:DeliveryLocation" priority="1167" mode="M12">
        <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                         context="/ubl:Order/cac:Delivery/cac:DeliveryLocation"/>

        <!--ASSERT -->

        <axsl:choose>
            <axsl:when test="cac:Address"/>
            <axsl:otherwise>
                <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="cac:Address">
                    <axsl:attribute name="id">PEPPOL-T01-B14501</axsl:attribute>
                    <axsl:attribute name="flag">fatal</axsl:attribute>
                    <axsl:attribute name="location">
                        <axsl:apply-templates select="." mode="schematron-select-full-path"/>
                    </axsl:attribute>
                    <svrl:text>Element 'cac:Address' MUST be provided.</svrl:text>
                </svrl:failed-assert>
            </axsl:otherwise>
        </axsl:choose>
        <axsl:apply-templates select="@*|*" mode="M12"/>
    </axsl:template>

    <!--RULE -->

    <axsl:template match="/ubl:Order/cac:Delivery/cac:DeliveryLocation/cbc:ID" priority="1166" mode="M12">
        <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                         context="/ubl:Order/cac:Delivery/cac:DeliveryLocation/cbc:ID"/>

        <!--ASSERT -->

        <axsl:choose>
            <axsl:when test="not(@schemeID) or (some $code in $clICD satisfies $code = @schemeID)"/>
            <axsl:otherwise>
                <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                    test="not(@schemeID) or (some $code in $clICD satisfies $code = @schemeID)">
                    <axsl:attribute name="id">PEPPOL-T01-B14601</axsl:attribute>
                    <axsl:attribute name="flag">fatal</axsl:attribute>
                    <axsl:attribute name="location">
                        <axsl:apply-templates select="." mode="schematron-select-full-path"/>
                    </axsl:attribute>
                    <svrl:text>Value MUST be part of code list 'ISO 6523 ICD list'.</svrl:text>
                </svrl:failed-assert>
            </axsl:otherwise>
        </axsl:choose>
        <axsl:apply-templates select="@*|*" mode="M12"/>
    </axsl:template>

    <!--RULE -->

    <axsl:template match="/ubl:Order/cac:Delivery/cac:DeliveryLocation/cbc:Name" priority="1165" mode="M12">
        <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                         context="/ubl:Order/cac:Delivery/cac:DeliveryLocation/cbc:Name"/>
        <axsl:apply-templates select="@*|*" mode="M12"/>
    </axsl:template>

    <!--RULE -->

    <axsl:template match="/ubl:Order/cac:Delivery/cac:DeliveryLocation/cac:Address" priority="1164" mode="M12">
        <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                         context="/ubl:Order/cac:Delivery/cac:DeliveryLocation/cac:Address"/>

        <!--ASSERT -->

        <axsl:choose>
            <axsl:when test="cac:Country"/>
            <axsl:otherwise>
                <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="cac:Country">
                    <axsl:attribute name="id">PEPPOL-T01-B14901</axsl:attribute>
                    <axsl:attribute name="flag">fatal</axsl:attribute>
                    <axsl:attribute name="location">
                        <axsl:apply-templates select="." mode="schematron-select-full-path"/>
                    </axsl:attribute>
                    <svrl:text>Element 'cac:Country' MUST be provided.</svrl:text>
                </svrl:failed-assert>
            </axsl:otherwise>
        </axsl:choose>
        <axsl:apply-templates select="@*|*" mode="M12"/>
    </axsl:template>

    <!--RULE -->

    <axsl:template match="/ubl:Order/cac:Delivery/cac:DeliveryLocation/cac:Address/cbc:StreetName" priority="1163"
                   mode="M12">
        <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                         context="/ubl:Order/cac:Delivery/cac:DeliveryLocation/cac:Address/cbc:StreetName"/>
        <axsl:apply-templates select="@*|*" mode="M12"/>
    </axsl:template>

    <!--RULE -->

    <axsl:template match="/ubl:Order/cac:Delivery/cac:DeliveryLocation/cac:Address/cbc:AdditionalStreetName"
                   priority="1162" mode="M12">
        <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                         context="/ubl:Order/cac:Delivery/cac:DeliveryLocation/cac:Address/cbc:AdditionalStreetName"/>
        <axsl:apply-templates select="@*|*" mode="M12"/>
    </axsl:template>

    <!--RULE -->

    <axsl:template match="/ubl:Order/cac:Delivery/cac:DeliveryLocation/cac:Address/cbc:CityName" priority="1161"
                   mode="M12">
        <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                         context="/ubl:Order/cac:Delivery/cac:DeliveryLocation/cac:Address/cbc:CityName"/>
        <axsl:apply-templates select="@*|*" mode="M12"/>
    </axsl:template>

    <!--RULE -->

    <axsl:template match="/ubl:Order/cac:Delivery/cac:DeliveryLocation/cac:Address/cbc:PostalZone" priority="1160"
                   mode="M12">
        <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                         context="/ubl:Order/cac:Delivery/cac:DeliveryLocation/cac:Address/cbc:PostalZone"/>
        <axsl:apply-templates select="@*|*" mode="M12"/>
    </axsl:template>

    <!--RULE -->

    <axsl:template match="/ubl:Order/cac:Delivery/cac:DeliveryLocation/cac:Address/cbc:CountrySubentity" priority="1159"
                   mode="M12">
        <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                         context="/ubl:Order/cac:Delivery/cac:DeliveryLocation/cac:Address/cbc:CountrySubentity"/>
        <axsl:apply-templates select="@*|*" mode="M12"/>
    </axsl:template>

    <!--RULE -->

    <axsl:template match="/ubl:Order/cac:Delivery/cac:DeliveryLocation/cac:Address/cac:AddressLine" priority="1158"
                   mode="M12">
        <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                         context="/ubl:Order/cac:Delivery/cac:DeliveryLocation/cac:Address/cac:AddressLine"/>

        <!--ASSERT -->

        <axsl:choose>
            <axsl:when test="cbc:Line"/>
            <axsl:otherwise>
                <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="cbc:Line">
                    <axsl:attribute name="id">PEPPOL-T01-B15501</axsl:attribute>
                    <axsl:attribute name="flag">fatal</axsl:attribute>
                    <axsl:attribute name="location">
                        <axsl:apply-templates select="." mode="schematron-select-full-path"/>
                    </axsl:attribute>
                    <svrl:text>Element 'cbc:Line' MUST be provided.</svrl:text>
                </svrl:failed-assert>
            </axsl:otherwise>
        </axsl:choose>
        <axsl:apply-templates select="@*|*" mode="M12"/>
    </axsl:template>

    <!--RULE -->

    <axsl:template match="/ubl:Order/cac:Delivery/cac:DeliveryLocation/cac:Address/cac:AddressLine/cbc:Line"
                   priority="1157" mode="M12">
        <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                         context="/ubl:Order/cac:Delivery/cac:DeliveryLocation/cac:Address/cac:AddressLine/cbc:Line"/>
        <axsl:apply-templates select="@*|*" mode="M12"/>
    </axsl:template>

    <!--RULE -->

    <axsl:template match="/ubl:Order/cac:Delivery/cac:DeliveryLocation/cac:Address/cac:Country" priority="1156"
                   mode="M12">
        <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                         context="/ubl:Order/cac:Delivery/cac:DeliveryLocation/cac:Address/cac:Country"/>

        <!--ASSERT -->

        <axsl:choose>
            <axsl:when test="cbc:IdentificationCode"/>
            <axsl:otherwise>
                <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="cbc:IdentificationCode">
                    <axsl:attribute name="id">PEPPOL-T01-B15701</axsl:attribute>
                    <axsl:attribute name="flag">fatal</axsl:attribute>
                    <axsl:attribute name="location">
                        <axsl:apply-templates select="." mode="schematron-select-full-path"/>
                    </axsl:attribute>
                    <svrl:text>Element 'cbc:IdentificationCode' MUST be provided.</svrl:text>
                </svrl:failed-assert>
            </axsl:otherwise>
        </axsl:choose>
        <axsl:apply-templates select="@*|*" mode="M12"/>
    </axsl:template>

    <!--RULE -->

    <axsl:template match="/ubl:Order/cac:Delivery/cac:DeliveryLocation/cac:Address/cac:Country/cbc:IdentificationCode"
                   priority="1155" mode="M12">
        <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                         context="/ubl:Order/cac:Delivery/cac:DeliveryLocation/cac:Address/cac:Country/cbc:IdentificationCode"/>

        <!--ASSERT -->

        <axsl:choose>
            <axsl:when test="(some $code in $clISO3166 satisfies $code = normalize-space(text()))"/>
            <axsl:otherwise>
                <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                    test="(some $code in $clISO3166 satisfies $code = normalize-space(text()))">
                    <axsl:attribute name="id">PEPPOL-T01-B15801</axsl:attribute>
                    <axsl:attribute name="flag">fatal</axsl:attribute>
                    <axsl:attribute name="location">
                        <axsl:apply-templates select="." mode="schematron-select-full-path"/>
                    </axsl:attribute>
                    <svrl:text>Value MUST be part of code list 'Country codes (ISO 3166-1:Alpha2)'.</svrl:text>
                </svrl:failed-assert>
            </axsl:otherwise>
        </axsl:choose>
        <axsl:apply-templates select="@*|*" mode="M12"/>
    </axsl:template>

    <!--RULE -->

    <axsl:template match="/ubl:Order/cac:Delivery/cac:DeliveryLocation/cac:Address/cac:Country/*" priority="1154"
                   mode="M12">
        <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                         context="/ubl:Order/cac:Delivery/cac:DeliveryLocation/cac:Address/cac:Country/*"/>

        <!--ASSERT -->

        <axsl:choose>
            <axsl:when test="false()"/>
            <axsl:otherwise>
                <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="false()">
                    <axsl:attribute name="id">PEPPOL-T01-B15702</axsl:attribute>
                    <axsl:attribute name="flag">fatal</axsl:attribute>
                    <axsl:attribute name="location">
                        <axsl:apply-templates select="." mode="schematron-select-full-path"/>
                    </axsl:attribute>
                    <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
                </svrl:failed-assert>
            </axsl:otherwise>
        </axsl:choose>
        <axsl:apply-templates select="@*|*" mode="M12"/>
    </axsl:template>

    <!--RULE -->

    <axsl:template match="/ubl:Order/cac:Delivery/cac:DeliveryLocation/cac:Address/*" priority="1153" mode="M12">
        <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                         context="/ubl:Order/cac:Delivery/cac:DeliveryLocation/cac:Address/*"/>

        <!--ASSERT -->

        <axsl:choose>
            <axsl:when test="false()"/>
            <axsl:otherwise>
                <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="false()">
                    <axsl:attribute name="id">PEPPOL-T01-B14902</axsl:attribute>
                    <axsl:attribute name="flag">fatal</axsl:attribute>
                    <axsl:attribute name="location">
                        <axsl:apply-templates select="." mode="schematron-select-full-path"/>
                    </axsl:attribute>
                    <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
                </svrl:failed-assert>
            </axsl:otherwise>
        </axsl:choose>
        <axsl:apply-templates select="@*|*" mode="M12"/>
    </axsl:template>

    <!--RULE -->

    <axsl:template match="/ubl:Order/cac:Delivery/cac:DeliveryLocation/*" priority="1152" mode="M12">
        <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                         context="/ubl:Order/cac:Delivery/cac:DeliveryLocation/*"/>

        <!--ASSERT -->

        <axsl:choose>
            <axsl:when test="false()"/>
            <axsl:otherwise>
                <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="false()">
                    <axsl:attribute name="id">PEPPOL-T01-B14502</axsl:attribute>
                    <axsl:attribute name="flag">fatal</axsl:attribute>
                    <axsl:attribute name="location">
                        <axsl:apply-templates select="." mode="schematron-select-full-path"/>
                    </axsl:attribute>
                    <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
                </svrl:failed-assert>
            </axsl:otherwise>
        </axsl:choose>
        <axsl:apply-templates select="@*|*" mode="M12"/>
    </axsl:template>

    <!--RULE -->

    <axsl:template match="/ubl:Order/cac:Delivery/cac:RequestedDeliveryPeriod" priority="1151" mode="M12">
        <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                         context="/ubl:Order/cac:Delivery/cac:RequestedDeliveryPeriod"/>
        <axsl:apply-templates select="@*|*" mode="M12"/>
    </axsl:template>

    <!--RULE -->

    <axsl:template match="/ubl:Order/cac:Delivery/cac:RequestedDeliveryPeriod/cbc:StartDate" priority="1150" mode="M12">
        <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                         context="/ubl:Order/cac:Delivery/cac:RequestedDeliveryPeriod/cbc:StartDate"/>
        <axsl:apply-templates select="@*|*" mode="M12"/>
    </axsl:template>

    <!--RULE -->

    <axsl:template match="/ubl:Order/cac:Delivery/cac:RequestedDeliveryPeriod/cbc:EndDate" priority="1149" mode="M12">
        <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                         context="/ubl:Order/cac:Delivery/cac:RequestedDeliveryPeriod/cbc:EndDate"/>
        <axsl:apply-templates select="@*|*" mode="M12"/>
    </axsl:template>

    <!--RULE -->

    <axsl:template match="/ubl:Order/cac:Delivery/cac:RequestedDeliveryPeriod/*" priority="1148" mode="M12">
        <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                         context="/ubl:Order/cac:Delivery/cac:RequestedDeliveryPeriod/*"/>

        <!--ASSERT -->

        <axsl:choose>
            <axsl:when test="false()"/>
            <axsl:otherwise>
                <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="false()">
                    <axsl:attribute name="id">PEPPOL-T01-B15901</axsl:attribute>
                    <axsl:attribute name="flag">fatal</axsl:attribute>
                    <axsl:attribute name="location">
                        <axsl:apply-templates select="." mode="schematron-select-full-path"/>
                    </axsl:attribute>
                    <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
                </svrl:failed-assert>
            </axsl:otherwise>
        </axsl:choose>
        <axsl:apply-templates select="@*|*" mode="M12"/>
    </axsl:template>

    <!--RULE -->

    <axsl:template match="/ubl:Order/cac:Delivery/cac:DeliveryParty" priority="1147" mode="M12">
        <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                         context="/ubl:Order/cac:Delivery/cac:DeliveryParty"/>

        <!--ASSERT -->

        <axsl:choose>
            <axsl:when test="cac:PartyName"/>
            <axsl:otherwise>
                <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="cac:PartyName">
                    <axsl:attribute name="id">PEPPOL-T01-B16201</axsl:attribute>
                    <axsl:attribute name="flag">fatal</axsl:attribute>
                    <axsl:attribute name="location">
                        <axsl:apply-templates select="." mode="schematron-select-full-path"/>
                    </axsl:attribute>
                    <svrl:text>Element 'cac:PartyName' MUST be provided.</svrl:text>
                </svrl:failed-assert>
            </axsl:otherwise>
        </axsl:choose>
        <axsl:apply-templates select="@*|*" mode="M12"/>
    </axsl:template>

    <!--RULE -->

    <axsl:template match="/ubl:Order/cac:Delivery/cac:DeliveryParty/cac:PartyIdentification" priority="1146" mode="M12">
        <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                         context="/ubl:Order/cac:Delivery/cac:DeliveryParty/cac:PartyIdentification"/>

        <!--ASSERT -->

        <axsl:choose>
            <axsl:when test="cbc:ID"/>
            <axsl:otherwise>
                <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="cbc:ID">
                    <axsl:attribute name="id">PEPPOL-T01-B16301</axsl:attribute>
                    <axsl:attribute name="flag">fatal</axsl:attribute>
                    <axsl:attribute name="location">
                        <axsl:apply-templates select="." mode="schematron-select-full-path"/>
                    </axsl:attribute>
                    <svrl:text>Element 'cbc:ID' MUST be provided.</svrl:text>
                </svrl:failed-assert>
            </axsl:otherwise>
        </axsl:choose>
        <axsl:apply-templates select="@*|*" mode="M12"/>
    </axsl:template>

    <!--RULE -->

    <axsl:template match="/ubl:Order/cac:Delivery/cac:DeliveryParty/cac:PartyIdentification/cbc:ID" priority="1145"
                   mode="M12">
        <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                         context="/ubl:Order/cac:Delivery/cac:DeliveryParty/cac:PartyIdentification/cbc:ID"/>

        <!--ASSERT -->

        <axsl:choose>
            <axsl:when test="not(@schemeID) or (some $code in $clICD satisfies $code = @schemeID)"/>
            <axsl:otherwise>
                <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                    test="not(@schemeID) or (some $code in $clICD satisfies $code = @schemeID)">
                    <axsl:attribute name="id">PEPPOL-T01-B16401</axsl:attribute>
                    <axsl:attribute name="flag">fatal</axsl:attribute>
                    <axsl:attribute name="location">
                        <axsl:apply-templates select="." mode="schematron-select-full-path"/>
                    </axsl:attribute>
                    <svrl:text>Value MUST be part of code list 'ISO 6523 ICD list'.</svrl:text>
                </svrl:failed-assert>
            </axsl:otherwise>
        </axsl:choose>
        <axsl:apply-templates select="@*|*" mode="M12"/>
    </axsl:template>

    <!--RULE -->

    <axsl:template match="/ubl:Order/cac:Delivery/cac:DeliveryParty/cac:PartyName" priority="1144" mode="M12">
        <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                         context="/ubl:Order/cac:Delivery/cac:DeliveryParty/cac:PartyName"/>

        <!--ASSERT -->

        <axsl:choose>
            <axsl:when test="cbc:Name"/>
            <axsl:otherwise>
                <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="cbc:Name">
                    <axsl:attribute name="id">PEPPOL-T01-B16601</axsl:attribute>
                    <axsl:attribute name="flag">fatal</axsl:attribute>
                    <axsl:attribute name="location">
                        <axsl:apply-templates select="." mode="schematron-select-full-path"/>
                    </axsl:attribute>
                    <svrl:text>Element 'cbc:Name' MUST be provided.</svrl:text>
                </svrl:failed-assert>
            </axsl:otherwise>
        </axsl:choose>
        <axsl:apply-templates select="@*|*" mode="M12"/>
    </axsl:template>

    <!--RULE -->

    <axsl:template match="/ubl:Order/cac:Delivery/cac:DeliveryParty/cac:PartyName/cbc:Name" priority="1143" mode="M12">
        <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                         context="/ubl:Order/cac:Delivery/cac:DeliveryParty/cac:PartyName/cbc:Name"/>
        <axsl:apply-templates select="@*|*" mode="M12"/>
    </axsl:template>

    <!--RULE -->

    <axsl:template match="/ubl:Order/cac:Delivery/cac:DeliveryParty/cac:PostalAddress" priority="1142" mode="M12">
        <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                         context="/ubl:Order/cac:Delivery/cac:DeliveryParty/cac:PostalAddress"/>

        <!--ASSERT -->

        <axsl:choose>
            <axsl:when test="cac:Country"/>
            <axsl:otherwise>
                <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="cac:Country">
                    <axsl:attribute name="id">PEPPOL-T01-B16801</axsl:attribute>
                    <axsl:attribute name="flag">fatal</axsl:attribute>
                    <axsl:attribute name="location">
                        <axsl:apply-templates select="." mode="schematron-select-full-path"/>
                    </axsl:attribute>
                    <svrl:text>Element 'cac:Country' MUST be provided.</svrl:text>
                </svrl:failed-assert>
            </axsl:otherwise>
        </axsl:choose>
        <axsl:apply-templates select="@*|*" mode="M12"/>
    </axsl:template>

    <!--RULE -->

    <axsl:template match="/ubl:Order/cac:Delivery/cac:DeliveryParty/cac:PostalAddress/cbc:StreetName" priority="1141"
                   mode="M12">
        <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                         context="/ubl:Order/cac:Delivery/cac:DeliveryParty/cac:PostalAddress/cbc:StreetName"/>
        <axsl:apply-templates select="@*|*" mode="M12"/>
    </axsl:template>

    <!--RULE -->

    <axsl:template match="/ubl:Order/cac:Delivery/cac:DeliveryParty/cac:PostalAddress/cbc:AdditionalStreetName"
                   priority="1140" mode="M12">
        <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                         context="/ubl:Order/cac:Delivery/cac:DeliveryParty/cac:PostalAddress/cbc:AdditionalStreetName"/>
        <axsl:apply-templates select="@*|*" mode="M12"/>
    </axsl:template>

    <!--RULE -->

    <axsl:template match="/ubl:Order/cac:Delivery/cac:DeliveryParty/cac:PostalAddress/cbc:CityName" priority="1139"
                   mode="M12">
        <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                         context="/ubl:Order/cac:Delivery/cac:DeliveryParty/cac:PostalAddress/cbc:CityName"/>
        <axsl:apply-templates select="@*|*" mode="M12"/>
    </axsl:template>

    <!--RULE -->

    <axsl:template match="/ubl:Order/cac:Delivery/cac:DeliveryParty/cac:PostalAddress/cbc:PostalZone" priority="1138"
                   mode="M12">
        <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                         context="/ubl:Order/cac:Delivery/cac:DeliveryParty/cac:PostalAddress/cbc:PostalZone"/>
        <axsl:apply-templates select="@*|*" mode="M12"/>
    </axsl:template>

    <!--RULE -->

    <axsl:template match="/ubl:Order/cac:Delivery/cac:DeliveryParty/cac:PostalAddress/cbc:CountrySubentity"
                   priority="1137" mode="M12">
        <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                         context="/ubl:Order/cac:Delivery/cac:DeliveryParty/cac:PostalAddress/cbc:CountrySubentity"/>
        <axsl:apply-templates select="@*|*" mode="M12"/>
    </axsl:template>

    <!--RULE -->

    <axsl:template match="/ubl:Order/cac:Delivery/cac:DeliveryParty/cac:PostalAddress/cac:AddressLine" priority="1136"
                   mode="M12">
        <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                         context="/ubl:Order/cac:Delivery/cac:DeliveryParty/cac:PostalAddress/cac:AddressLine"/>

        <!--ASSERT -->

        <axsl:choose>
            <axsl:when test="cbc:Line"/>
            <axsl:otherwise>
                <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="cbc:Line">
                    <axsl:attribute name="id">PEPPOL-T01-B17401</axsl:attribute>
                    <axsl:attribute name="flag">fatal</axsl:attribute>
                    <axsl:attribute name="location">
                        <axsl:apply-templates select="." mode="schematron-select-full-path"/>
                    </axsl:attribute>
                    <svrl:text>Element 'cbc:Line' MUST be provided.</svrl:text>
                </svrl:failed-assert>
            </axsl:otherwise>
        </axsl:choose>
        <axsl:apply-templates select="@*|*" mode="M12"/>
    </axsl:template>

    <!--RULE -->

    <axsl:template match="/ubl:Order/cac:Delivery/cac:DeliveryParty/cac:PostalAddress/cac:AddressLine/cbc:Line"
                   priority="1135" mode="M12">
        <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                         context="/ubl:Order/cac:Delivery/cac:DeliveryParty/cac:PostalAddress/cac:AddressLine/cbc:Line"/>
        <axsl:apply-templates select="@*|*" mode="M12"/>
    </axsl:template>

    <!--RULE -->

    <axsl:template match="/ubl:Order/cac:Delivery/cac:DeliveryParty/cac:PostalAddress/cac:Country" priority="1134"
                   mode="M12">
        <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                         context="/ubl:Order/cac:Delivery/cac:DeliveryParty/cac:PostalAddress/cac:Country"/>

        <!--ASSERT -->

        <axsl:choose>
            <axsl:when test="cbc:IdentificationCode"/>
            <axsl:otherwise>
                <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="cbc:IdentificationCode">
                    <axsl:attribute name="id">PEPPOL-T01-B17601</axsl:attribute>
                    <axsl:attribute name="flag">fatal</axsl:attribute>
                    <axsl:attribute name="location">
                        <axsl:apply-templates select="." mode="schematron-select-full-path"/>
                    </axsl:attribute>
                    <svrl:text>Element 'cbc:IdentificationCode' MUST be provided.</svrl:text>
                </svrl:failed-assert>
            </axsl:otherwise>
        </axsl:choose>
        <axsl:apply-templates select="@*|*" mode="M12"/>
    </axsl:template>

    <!--RULE -->

    <axsl:template
            match="/ubl:Order/cac:Delivery/cac:DeliveryParty/cac:PostalAddress/cac:Country/cbc:IdentificationCode"
            priority="1133" mode="M12">
        <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                         context="/ubl:Order/cac:Delivery/cac:DeliveryParty/cac:PostalAddress/cac:Country/cbc:IdentificationCode"/>

        <!--ASSERT -->

        <axsl:choose>
            <axsl:when test="(some $code in $clISO3166 satisfies $code = normalize-space(text()))"/>
            <axsl:otherwise>
                <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                    test="(some $code in $clISO3166 satisfies $code = normalize-space(text()))">
                    <axsl:attribute name="id">PEPPOL-T01-B17701</axsl:attribute>
                    <axsl:attribute name="flag">fatal</axsl:attribute>
                    <axsl:attribute name="location">
                        <axsl:apply-templates select="." mode="schematron-select-full-path"/>
                    </axsl:attribute>
                    <svrl:text>Value MUST be part of code list 'Country codes (ISO 3166-1:Alpha2)'.</svrl:text>
                </svrl:failed-assert>
            </axsl:otherwise>
        </axsl:choose>
        <axsl:apply-templates select="@*|*" mode="M12"/>
    </axsl:template>

    <!--RULE -->

    <axsl:template match="/ubl:Order/cac:Delivery/cac:DeliveryParty/cac:PostalAddress/cac:Country/*" priority="1132"
                   mode="M12">
        <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                         context="/ubl:Order/cac:Delivery/cac:DeliveryParty/cac:PostalAddress/cac:Country/*"/>

        <!--ASSERT -->

        <axsl:choose>
            <axsl:when test="false()"/>
            <axsl:otherwise>
                <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="false()">
                    <axsl:attribute name="id">PEPPOL-T01-B17602</axsl:attribute>
                    <axsl:attribute name="flag">fatal</axsl:attribute>
                    <axsl:attribute name="location">
                        <axsl:apply-templates select="." mode="schematron-select-full-path"/>
                    </axsl:attribute>
                    <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
                </svrl:failed-assert>
            </axsl:otherwise>
        </axsl:choose>
        <axsl:apply-templates select="@*|*" mode="M12"/>
    </axsl:template>

    <!--RULE -->

    <axsl:template match="/ubl:Order/cac:Delivery/cac:DeliveryParty/cac:PostalAddress/*" priority="1131" mode="M12">
        <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                         context="/ubl:Order/cac:Delivery/cac:DeliveryParty/cac:PostalAddress/*"/>

        <!--ASSERT -->

        <axsl:choose>
            <axsl:when test="false()"/>
            <axsl:otherwise>
                <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="false()">
                    <axsl:attribute name="id">PEPPOL-T01-B16802</axsl:attribute>
                    <axsl:attribute name="flag">fatal</axsl:attribute>
                    <axsl:attribute name="location">
                        <axsl:apply-templates select="." mode="schematron-select-full-path"/>
                    </axsl:attribute>
                    <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
                </svrl:failed-assert>
            </axsl:otherwise>
        </axsl:choose>
        <axsl:apply-templates select="@*|*" mode="M12"/>
    </axsl:template>

    <!--RULE -->

    <axsl:template match="/ubl:Order/cac:Delivery/cac:DeliveryParty/cac:Contact" priority="1130" mode="M12">
        <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                         context="/ubl:Order/cac:Delivery/cac:DeliveryParty/cac:Contact"/>
        <axsl:apply-templates select="@*|*" mode="M12"/>
    </axsl:template>

    <!--RULE -->

    <axsl:template match="/ubl:Order/cac:Delivery/cac:DeliveryParty/cac:Contact/cbc:Name" priority="1129" mode="M12">
        <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                         context="/ubl:Order/cac:Delivery/cac:DeliveryParty/cac:Contact/cbc:Name"/>
        <axsl:apply-templates select="@*|*" mode="M12"/>
    </axsl:template>

    <!--RULE -->

    <axsl:template match="/ubl:Order/cac:Delivery/cac:DeliveryParty/cac:Contact/cbc:Telephone" priority="1128"
                   mode="M12">
        <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                         context="/ubl:Order/cac:Delivery/cac:DeliveryParty/cac:Contact/cbc:Telephone"/>
        <axsl:apply-templates select="@*|*" mode="M12"/>
    </axsl:template>

    <!--RULE -->

    <axsl:template match="/ubl:Order/cac:Delivery/cac:DeliveryParty/cac:Contact/cbc:ElectronicMail" priority="1127"
                   mode="M12">
        <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                         context="/ubl:Order/cac:Delivery/cac:DeliveryParty/cac:Contact/cbc:ElectronicMail"/>
        <axsl:apply-templates select="@*|*" mode="M12"/>
    </axsl:template>

    <!--RULE -->

    <axsl:template match="/ubl:Order/cac:Delivery/cac:DeliveryParty/cac:Contact/*" priority="1126" mode="M12">
        <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                         context="/ubl:Order/cac:Delivery/cac:DeliveryParty/cac:Contact/*"/>

        <!--ASSERT -->

        <axsl:choose>
            <axsl:when test="false()"/>
            <axsl:otherwise>
                <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="false()">
                    <axsl:attribute name="id">PEPPOL-T01-B17801</axsl:attribute>
                    <axsl:attribute name="flag">fatal</axsl:attribute>
                    <axsl:attribute name="location">
                        <axsl:apply-templates select="." mode="schematron-select-full-path"/>
                    </axsl:attribute>
                    <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
                </svrl:failed-assert>
            </axsl:otherwise>
        </axsl:choose>
        <axsl:apply-templates select="@*|*" mode="M12"/>
    </axsl:template>

    <!--RULE -->

    <axsl:template match="/ubl:Order/cac:Delivery/cac:DeliveryParty/*" priority="1125" mode="M12">
        <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                         context="/ubl:Order/cac:Delivery/cac:DeliveryParty/*"/>

        <!--ASSERT -->

        <axsl:choose>
            <axsl:when test="false()"/>
            <axsl:otherwise>
                <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="false()">
                    <axsl:attribute name="id">PEPPOL-T01-B16202</axsl:attribute>
                    <axsl:attribute name="flag">fatal</axsl:attribute>
                    <axsl:attribute name="location">
                        <axsl:apply-templates select="." mode="schematron-select-full-path"/>
                    </axsl:attribute>
                    <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
                </svrl:failed-assert>
            </axsl:otherwise>
        </axsl:choose>
        <axsl:apply-templates select="@*|*" mode="M12"/>
    </axsl:template>

    <!--RULE -->

    <axsl:template match="/ubl:Order/cac:Delivery/cac:Shipment" priority="1124" mode="M12">
        <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="/ubl:Order/cac:Delivery/cac:Shipment"/>

        <!--ASSERT -->

        <axsl:choose>
            <axsl:when test="cbc:ID"/>
            <axsl:otherwise>
                <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="cbc:ID">
                    <axsl:attribute name="id">PEPPOL-T01-B18201</axsl:attribute>
                    <axsl:attribute name="flag">fatal</axsl:attribute>
                    <axsl:attribute name="location">
                        <axsl:apply-templates select="." mode="schematron-select-full-path"/>
                    </axsl:attribute>
                    <svrl:text>Element 'cbc:ID' MUST be provided.</svrl:text>
                </svrl:failed-assert>
            </axsl:otherwise>
        </axsl:choose>
        <axsl:apply-templates select="@*|*" mode="M12"/>
    </axsl:template>

    <!--RULE -->

    <axsl:template match="/ubl:Order/cac:Delivery/cac:Shipment/cbc:ID" priority="1123" mode="M12">
        <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                         context="/ubl:Order/cac:Delivery/cac:Shipment/cbc:ID"/>
        <axsl:apply-templates select="@*|*" mode="M12"/>
    </axsl:template>

    <!--RULE -->

    <axsl:template match="/ubl:Order/cac:Delivery/cac:Shipment/cac:TransportHandlingUnit" priority="1122" mode="M12">
        <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                         context="/ubl:Order/cac:Delivery/cac:Shipment/cac:TransportHandlingUnit"/>
        <axsl:apply-templates select="@*|*" mode="M12"/>
    </axsl:template>

    <!--RULE -->

    <axsl:template match="/ubl:Order/cac:Delivery/cac:Shipment/cac:TransportHandlingUnit/cbc:ShippingMarks"
                   priority="1121" mode="M12">
        <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                         context="/ubl:Order/cac:Delivery/cac:Shipment/cac:TransportHandlingUnit/cbc:ShippingMarks"/>
        <axsl:apply-templates select="@*|*" mode="M12"/>
    </axsl:template>

    <!--RULE -->

    <axsl:template match="/ubl:Order/cac:Delivery/cac:Shipment/cac:TransportHandlingUnit/*" priority="1120" mode="M12">
        <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                         context="/ubl:Order/cac:Delivery/cac:Shipment/cac:TransportHandlingUnit/*"/>

        <!--ASSERT -->

        <axsl:choose>
            <axsl:when test="false()"/>
            <axsl:otherwise>
                <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="false()">
                    <axsl:attribute name="id">PEPPOL-T01-B18401</axsl:attribute>
                    <axsl:attribute name="flag">fatal</axsl:attribute>
                    <axsl:attribute name="location">
                        <axsl:apply-templates select="." mode="schematron-select-full-path"/>
                    </axsl:attribute>
                    <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
                </svrl:failed-assert>
            </axsl:otherwise>
        </axsl:choose>
        <axsl:apply-templates select="@*|*" mode="M12"/>
    </axsl:template>

    <!--RULE -->

    <axsl:template match="/ubl:Order/cac:Delivery/cac:Shipment/*" priority="1119" mode="M12">
        <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="/ubl:Order/cac:Delivery/cac:Shipment/*"/>

        <!--ASSERT -->

        <axsl:choose>
            <axsl:when test="false()"/>
            <axsl:otherwise>
                <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="false()">
                    <axsl:attribute name="id">PEPPOL-T01-B18202</axsl:attribute>
                    <axsl:attribute name="flag">fatal</axsl:attribute>
                    <axsl:attribute name="location">
                        <axsl:apply-templates select="." mode="schematron-select-full-path"/>
                    </axsl:attribute>
                    <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
                </svrl:failed-assert>
            </axsl:otherwise>
        </axsl:choose>
        <axsl:apply-templates select="@*|*" mode="M12"/>
    </axsl:template>

    <!--RULE -->

    <axsl:template match="/ubl:Order/cac:Delivery/*" priority="1118" mode="M12">
        <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="/ubl:Order/cac:Delivery/*"/>

        <!--ASSERT -->

        <axsl:choose>
            <axsl:when test="false()"/>
            <axsl:otherwise>
                <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="false()">
                    <axsl:attribute name="id">PEPPOL-T01-B14401</axsl:attribute>
                    <axsl:attribute name="flag">fatal</axsl:attribute>
                    <axsl:attribute name="location">
                        <axsl:apply-templates select="." mode="schematron-select-full-path"/>
                    </axsl:attribute>
                    <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
                </svrl:failed-assert>
            </axsl:otherwise>
        </axsl:choose>
        <axsl:apply-templates select="@*|*" mode="M12"/>
    </axsl:template>

    <!--RULE -->

    <axsl:template match="/ubl:Order/cac:DeliveryTerms" priority="1117" mode="M12">
        <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="/ubl:Order/cac:DeliveryTerms"/>
        <axsl:apply-templates select="@*|*" mode="M12"/>
    </axsl:template>

    <!--RULE -->

    <axsl:template match="/ubl:Order/cac:DeliveryTerms/cbc:ID" priority="1116" mode="M12">
        <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="/ubl:Order/cac:DeliveryTerms/cbc:ID"/>
        <axsl:apply-templates select="@*|*" mode="M12"/>
    </axsl:template>

    <!--RULE -->

    <axsl:template match="/ubl:Order/cac:DeliveryTerms/cbc:SpecialTerms" priority="1115" mode="M12">
        <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                         context="/ubl:Order/cac:DeliveryTerms/cbc:SpecialTerms"/>
        <axsl:apply-templates select="@*|*" mode="M12"/>
    </axsl:template>

    <!--RULE -->

    <axsl:template match="/ubl:Order/cac:DeliveryTerms/cac:DeliveryLocation" priority="1114" mode="M12">
        <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                         context="/ubl:Order/cac:DeliveryTerms/cac:DeliveryLocation"/>

        <!--ASSERT -->

        <axsl:choose>
            <axsl:when test="cbc:ID"/>
            <axsl:otherwise>
                <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="cbc:ID">
                    <axsl:attribute name="id">PEPPOL-T01-B18901</axsl:attribute>
                    <axsl:attribute name="flag">fatal</axsl:attribute>
                    <axsl:attribute name="location">
                        <axsl:apply-templates select="." mode="schematron-select-full-path"/>
                    </axsl:attribute>
                    <svrl:text>Element 'cbc:ID' MUST be provided.</svrl:text>
                </svrl:failed-assert>
            </axsl:otherwise>
        </axsl:choose>
        <axsl:apply-templates select="@*|*" mode="M12"/>
    </axsl:template>

    <!--RULE -->

    <axsl:template match="/ubl:Order/cac:DeliveryTerms/cac:DeliveryLocation/cbc:ID" priority="1113" mode="M12">
        <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                         context="/ubl:Order/cac:DeliveryTerms/cac:DeliveryLocation/cbc:ID"/>
        <axsl:apply-templates select="@*|*" mode="M12"/>
    </axsl:template>

    <!--RULE -->

    <axsl:template match="/ubl:Order/cac:DeliveryTerms/cac:DeliveryLocation/*" priority="1112" mode="M12">
        <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                         context="/ubl:Order/cac:DeliveryTerms/cac:DeliveryLocation/*"/>

        <!--ASSERT -->

        <axsl:choose>
            <axsl:when test="false()"/>
            <axsl:otherwise>
                <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="false()">
                    <axsl:attribute name="id">PEPPOL-T01-B18902</axsl:attribute>
                    <axsl:attribute name="flag">fatal</axsl:attribute>
                    <axsl:attribute name="location">
                        <axsl:apply-templates select="." mode="schematron-select-full-path"/>
                    </axsl:attribute>
                    <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
                </svrl:failed-assert>
            </axsl:otherwise>
        </axsl:choose>
        <axsl:apply-templates select="@*|*" mode="M12"/>
    </axsl:template>

    <!--RULE -->

    <axsl:template match="/ubl:Order/cac:DeliveryTerms/*" priority="1111" mode="M12">
        <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="/ubl:Order/cac:DeliveryTerms/*"/>

        <!--ASSERT -->

        <axsl:choose>
            <axsl:when test="false()"/>
            <axsl:otherwise>
                <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="false()">
                    <axsl:attribute name="id">PEPPOL-T01-B18601</axsl:attribute>
                    <axsl:attribute name="flag">fatal</axsl:attribute>
                    <axsl:attribute name="location">
                        <axsl:apply-templates select="." mode="schematron-select-full-path"/>
                    </axsl:attribute>
                    <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
                </svrl:failed-assert>
            </axsl:otherwise>
        </axsl:choose>
        <axsl:apply-templates select="@*|*" mode="M12"/>
    </axsl:template>

    <!--RULE -->

    <axsl:template match="/ubl:Order/cac:PaymentTerms" priority="1110" mode="M12">
        <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="/ubl:Order/cac:PaymentTerms"/>

        <!--ASSERT -->

        <axsl:choose>
            <axsl:when test="cbc:Note"/>
            <axsl:otherwise>
                <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="cbc:Note">
                    <axsl:attribute name="id">PEPPOL-T01-B19101</axsl:attribute>
                    <axsl:attribute name="flag">fatal</axsl:attribute>
                    <axsl:attribute name="location">
                        <axsl:apply-templates select="." mode="schematron-select-full-path"/>
                    </axsl:attribute>
                    <svrl:text>Element 'cbc:Note' MUST be provided.</svrl:text>
                </svrl:failed-assert>
            </axsl:otherwise>
        </axsl:choose>
        <axsl:apply-templates select="@*|*" mode="M12"/>
    </axsl:template>

    <!--RULE -->

    <axsl:template match="/ubl:Order/cac:PaymentTerms/cbc:Note" priority="1109" mode="M12">
        <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="/ubl:Order/cac:PaymentTerms/cbc:Note"/>
        <axsl:apply-templates select="@*|*" mode="M12"/>
    </axsl:template>

    <!--RULE -->

    <axsl:template match="/ubl:Order/cac:PaymentTerms/*" priority="1108" mode="M12">
        <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="/ubl:Order/cac:PaymentTerms/*"/>

        <!--ASSERT -->

        <axsl:choose>
            <axsl:when test="false()"/>
            <axsl:otherwise>
                <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="false()">
                    <axsl:attribute name="id">PEPPOL-T01-B19102</axsl:attribute>
                    <axsl:attribute name="flag">fatal</axsl:attribute>
                    <axsl:attribute name="location">
                        <axsl:apply-templates select="." mode="schematron-select-full-path"/>
                    </axsl:attribute>
                    <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
                </svrl:failed-assert>
            </axsl:otherwise>
        </axsl:choose>
        <axsl:apply-templates select="@*|*" mode="M12"/>
    </axsl:template>

    <!--RULE -->

    <axsl:template match="/ubl:Order/cac:AllowanceCharge" priority="1107" mode="M12">
        <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="/ubl:Order/cac:AllowanceCharge"/>

        <!--ASSERT -->

        <axsl:choose>
            <axsl:when test="cbc:ChargeIndicator"/>
            <axsl:otherwise>
                <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="cbc:ChargeIndicator">
                    <axsl:attribute name="id">PEPPOL-T01-B19301</axsl:attribute>
                    <axsl:attribute name="flag">fatal</axsl:attribute>
                    <axsl:attribute name="location">
                        <axsl:apply-templates select="." mode="schematron-select-full-path"/>
                    </axsl:attribute>
                    <svrl:text>Element 'cbc:ChargeIndicator' MUST be provided.</svrl:text>
                </svrl:failed-assert>
            </axsl:otherwise>
        </axsl:choose>

        <!--ASSERT -->

        <axsl:choose>
            <axsl:when test="cbc:AllowanceChargeReason"/>
            <axsl:otherwise>
                <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="cbc:AllowanceChargeReason">
                    <axsl:attribute name="id">PEPPOL-T01-B19302</axsl:attribute>
                    <axsl:attribute name="flag">fatal</axsl:attribute>
                    <axsl:attribute name="location">
                        <axsl:apply-templates select="." mode="schematron-select-full-path"/>
                    </axsl:attribute>
                    <svrl:text>Element 'cbc:AllowanceChargeReason' MUST be provided.</svrl:text>
                </svrl:failed-assert>
            </axsl:otherwise>
        </axsl:choose>

        <!--ASSERT -->

        <axsl:choose>
            <axsl:when test="cbc:Amount"/>
            <axsl:otherwise>
                <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="cbc:Amount">
                    <axsl:attribute name="id">PEPPOL-T01-B19303</axsl:attribute>
                    <axsl:attribute name="flag">fatal</axsl:attribute>
                    <axsl:attribute name="location">
                        <axsl:apply-templates select="." mode="schematron-select-full-path"/>
                    </axsl:attribute>
                    <svrl:text>Element 'cbc:Amount' MUST be provided.</svrl:text>
                </svrl:failed-assert>
            </axsl:otherwise>
        </axsl:choose>
        <axsl:apply-templates select="@*|*" mode="M12"/>
    </axsl:template>

    <!--RULE -->

    <axsl:template match="/ubl:Order/cac:AllowanceCharge/cbc:ChargeIndicator" priority="1106" mode="M12">
        <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                         context="/ubl:Order/cac:AllowanceCharge/cbc:ChargeIndicator"/>

        <!--ASSERT -->

        <axsl:choose>
            <axsl:when test="(some $code in $clTrueFalse satisfies $code = normalize-space(text()))"/>
            <axsl:otherwise>
                <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                    test="(some $code in $clTrueFalse satisfies $code = normalize-space(text()))">
                    <axsl:attribute name="id">PEPPOL-T01-B19401</axsl:attribute>
                    <axsl:attribute name="flag">fatal</axsl:attribute>
                    <axsl:attribute name="location">
                        <axsl:apply-templates select="." mode="schematron-select-full-path"/>
                    </axsl:attribute>
                    <svrl:text>Value MUST be part of code list 'Boolean indicator (openPEPPOL)'.</svrl:text>
                </svrl:failed-assert>
            </axsl:otherwise>
        </axsl:choose>
        <axsl:apply-templates select="@*|*" mode="M12"/>
    </axsl:template>

    <!--RULE -->

    <axsl:template match="/ubl:Order/cac:AllowanceCharge/cbc:AllowanceChargeReasonCode" priority="1105" mode="M12">
        <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                         context="/ubl:Order/cac:AllowanceCharge/cbc:AllowanceChargeReasonCode"/>

        <!--ASSERT -->

        <axsl:choose>
            <axsl:when
                    test="(some $code in $clUNCL5189 satisfies $code = normalize-space(text())) or (some $code in $clUNCL7161 satisfies $code = normalize-space(text()))"/>
            <axsl:otherwise>
                <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                    test="(some $code in $clUNCL5189 satisfies $code = normalize-space(text())) or (some $code in $clUNCL7161 satisfies $code = normalize-space(text()))">
                    <axsl:attribute name="id">PEPPOL-T01-B19501</axsl:attribute>
                    <axsl:attribute name="flag">fatal</axsl:attribute>
                    <axsl:attribute name="location">
                        <axsl:apply-templates select="." mode="schematron-select-full-path"/>
                    </axsl:attribute>
                    <svrl:text>Value MUST be part of code list 'Allowance reason codes (UNCL5189 subset)' or 'Charge
                        reason code (UNCL7161)'.
                    </svrl:text>
                </svrl:failed-assert>
            </axsl:otherwise>
        </axsl:choose>
        <axsl:apply-templates select="@*|*" mode="M12"/>
    </axsl:template>

    <!--RULE -->

    <axsl:template match="/ubl:Order/cac:AllowanceCharge/cbc:AllowanceChargeReason" priority="1104" mode="M12">
        <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                         context="/ubl:Order/cac:AllowanceCharge/cbc:AllowanceChargeReason"/>
        <axsl:apply-templates select="@*|*" mode="M12"/>
    </axsl:template>

    <!--RULE -->

    <axsl:template match="/ubl:Order/cac:AllowanceCharge/cbc:MultiplierFactorNumeric" priority="1103" mode="M12">
        <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                         context="/ubl:Order/cac:AllowanceCharge/cbc:MultiplierFactorNumeric"/>
        <axsl:apply-templates select="@*|*" mode="M12"/>
    </axsl:template>

    <!--RULE -->

    <axsl:template match="/ubl:Order/cac:AllowanceCharge/cbc:Amount" priority="1102" mode="M12">
        <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                         context="/ubl:Order/cac:AllowanceCharge/cbc:Amount"/>

        <!--ASSERT -->

        <axsl:choose>
            <axsl:when test="@currencyID"/>
            <axsl:otherwise>
                <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="@currencyID">
                    <axsl:attribute name="id">PEPPOL-T01-B19801</axsl:attribute>
                    <axsl:attribute name="flag">fatal</axsl:attribute>
                    <axsl:attribute name="location">
                        <axsl:apply-templates select="." mode="schematron-select-full-path"/>
                    </axsl:attribute>
                    <svrl:text>Attribute 'currencyID' MUST be present.</svrl:text>
                </svrl:failed-assert>
            </axsl:otherwise>
        </axsl:choose>

        <!--ASSERT -->

        <axsl:choose>
            <axsl:when test="not(@currencyID) or (some $code in $clISO4217 satisfies $code = @currencyID)"/>
            <axsl:otherwise>
                <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                    test="not(@currencyID) or (some $code in $clISO4217 satisfies $code = @currencyID)">
                    <axsl:attribute name="id">PEPPOL-T01-B19802</axsl:attribute>
                    <axsl:attribute name="flag">fatal</axsl:attribute>
                    <axsl:attribute name="location">
                        <axsl:apply-templates select="." mode="schematron-select-full-path"/>
                    </axsl:attribute>
                    <svrl:text>Value MUST be part of code list 'Currency codes (ISO 4217)'.</svrl:text>
                </svrl:failed-assert>
            </axsl:otherwise>
        </axsl:choose>
        <axsl:apply-templates select="@*|*" mode="M12"/>
    </axsl:template>

    <!--RULE -->

    <axsl:template match="/ubl:Order/cac:AllowanceCharge/cbc:BaseAmount" priority="1101" mode="M12">
        <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                         context="/ubl:Order/cac:AllowanceCharge/cbc:BaseAmount"/>

        <!--ASSERT -->

        <axsl:choose>
            <axsl:when test="@currencyID"/>
            <axsl:otherwise>
                <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="@currencyID">
                    <axsl:attribute name="id">PEPPOL-T01-B20001</axsl:attribute>
                    <axsl:attribute name="flag">fatal</axsl:attribute>
                    <axsl:attribute name="location">
                        <axsl:apply-templates select="." mode="schematron-select-full-path"/>
                    </axsl:attribute>
                    <svrl:text>Attribute 'currencyID' MUST be present.</svrl:text>
                </svrl:failed-assert>
            </axsl:otherwise>
        </axsl:choose>

        <!--ASSERT -->

        <axsl:choose>
            <axsl:when test="not(@currencyID) or (some $code in $clISO4217 satisfies $code = @currencyID)"/>
            <axsl:otherwise>
                <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                    test="not(@currencyID) or (some $code in $clISO4217 satisfies $code = @currencyID)">
                    <axsl:attribute name="id">PEPPOL-T01-B20002</axsl:attribute>
                    <axsl:attribute name="flag">fatal</axsl:attribute>
                    <axsl:attribute name="location">
                        <axsl:apply-templates select="." mode="schematron-select-full-path"/>
                    </axsl:attribute>
                    <svrl:text>Value MUST be part of code list 'Currency codes (ISO 4217)'.</svrl:text>
                </svrl:failed-assert>
            </axsl:otherwise>
        </axsl:choose>
        <axsl:apply-templates select="@*|*" mode="M12"/>
    </axsl:template>

    <!--RULE -->

    <axsl:template match="/ubl:Order/cac:AllowanceCharge/cac:TaxCategory" priority="1100" mode="M12">
        <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                         context="/ubl:Order/cac:AllowanceCharge/cac:TaxCategory"/>

        <!--ASSERT -->

        <axsl:choose>
            <axsl:when test="cbc:ID"/>
            <axsl:otherwise>
                <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="cbc:ID">
                    <axsl:attribute name="id">PEPPOL-T01-B20201</axsl:attribute>
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
            <axsl:when test="cac:TaxScheme"/>
            <axsl:otherwise>
                <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="cac:TaxScheme">
                    <axsl:attribute name="id">PEPPOL-T01-B20202</axsl:attribute>
                    <axsl:attribute name="flag">fatal</axsl:attribute>
                    <axsl:attribute name="location">
                        <axsl:apply-templates select="." mode="schematron-select-full-path"/>
                    </axsl:attribute>
                    <svrl:text>Element 'cac:TaxScheme' MUST be provided.</svrl:text>
                </svrl:failed-assert>
            </axsl:otherwise>
        </axsl:choose>
        <axsl:apply-templates select="@*|*" mode="M12"/>
    </axsl:template>

    <!--RULE -->

    <axsl:template match="/ubl:Order/cac:AllowanceCharge/cac:TaxCategory/cbc:ID" priority="1099" mode="M12">
        <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                         context="/ubl:Order/cac:AllowanceCharge/cac:TaxCategory/cbc:ID"/>

        <!--ASSERT -->

        <axsl:choose>
            <axsl:when test="(some $code in $clUNCL5305 satisfies $code = normalize-space(text()))"/>
            <axsl:otherwise>
                <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                    test="(some $code in $clUNCL5305 satisfies $code = normalize-space(text()))">
                    <axsl:attribute name="id">PEPPOL-T01-B20301</axsl:attribute>
                    <axsl:attribute name="flag">fatal</axsl:attribute>
                    <axsl:attribute name="location">
                        <axsl:apply-templates select="." mode="schematron-select-full-path"/>
                    </axsl:attribute>
                    <svrl:text>Value MUST be part of code list 'Duty or tax or fee category code (UNCL5305)'.
                    </svrl:text>
                </svrl:failed-assert>
            </axsl:otherwise>
        </axsl:choose>
        <axsl:apply-templates select="@*|*" mode="M12"/>
    </axsl:template>

    <!--RULE -->

    <axsl:template match="/ubl:Order/cac:AllowanceCharge/cac:TaxCategory/cbc:Percent" priority="1098" mode="M12">
        <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                         context="/ubl:Order/cac:AllowanceCharge/cac:TaxCategory/cbc:Percent"/>
        <axsl:apply-templates select="@*|*" mode="M12"/>
    </axsl:template>

    <!--RULE -->

    <axsl:template match="/ubl:Order/cac:AllowanceCharge/cac:TaxCategory/cac:TaxScheme" priority="1097" mode="M12">
        <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                         context="/ubl:Order/cac:AllowanceCharge/cac:TaxCategory/cac:TaxScheme"/>

        <!--ASSERT -->

        <axsl:choose>
            <axsl:when test="cbc:ID"/>
            <axsl:otherwise>
                <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="cbc:ID">
                    <axsl:attribute name="id">PEPPOL-T01-B20501</axsl:attribute>
                    <axsl:attribute name="flag">fatal</axsl:attribute>
                    <axsl:attribute name="location">
                        <axsl:apply-templates select="." mode="schematron-select-full-path"/>
                    </axsl:attribute>
                    <svrl:text>Element 'cbc:ID' MUST be provided.</svrl:text>
                </svrl:failed-assert>
            </axsl:otherwise>
        </axsl:choose>
        <axsl:apply-templates select="@*|*" mode="M12"/>
    </axsl:template>

    <!--RULE -->

    <axsl:template match="/ubl:Order/cac:AllowanceCharge/cac:TaxCategory/cac:TaxScheme/cbc:ID" priority="1096"
                   mode="M12">
        <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                         context="/ubl:Order/cac:AllowanceCharge/cac:TaxCategory/cac:TaxScheme/cbc:ID"/>
        <axsl:apply-templates select="@*|*" mode="M12"/>
    </axsl:template>

    <!--RULE -->

    <axsl:template match="/ubl:Order/cac:AllowanceCharge/cac:TaxCategory/cac:TaxScheme/*" priority="1095" mode="M12">
        <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                         context="/ubl:Order/cac:AllowanceCharge/cac:TaxCategory/cac:TaxScheme/*"/>

        <!--ASSERT -->

        <axsl:choose>
            <axsl:when test="false()"/>
            <axsl:otherwise>
                <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="false()">
                    <axsl:attribute name="id">PEPPOL-T01-B20502</axsl:attribute>
                    <axsl:attribute name="flag">fatal</axsl:attribute>
                    <axsl:attribute name="location">
                        <axsl:apply-templates select="." mode="schematron-select-full-path"/>
                    </axsl:attribute>
                    <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
                </svrl:failed-assert>
            </axsl:otherwise>
        </axsl:choose>
        <axsl:apply-templates select="@*|*" mode="M12"/>
    </axsl:template>

    <!--RULE -->

    <axsl:template match="/ubl:Order/cac:AllowanceCharge/cac:TaxCategory/*" priority="1094" mode="M12">
        <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                         context="/ubl:Order/cac:AllowanceCharge/cac:TaxCategory/*"/>

        <!--ASSERT -->

        <axsl:choose>
            <axsl:when test="false()"/>
            <axsl:otherwise>
                <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="false()">
                    <axsl:attribute name="id">PEPPOL-T01-B20203</axsl:attribute>
                    <axsl:attribute name="flag">fatal</axsl:attribute>
                    <axsl:attribute name="location">
                        <axsl:apply-templates select="." mode="schematron-select-full-path"/>
                    </axsl:attribute>
                    <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
                </svrl:failed-assert>
            </axsl:otherwise>
        </axsl:choose>
        <axsl:apply-templates select="@*|*" mode="M12"/>
    </axsl:template>

    <!--RULE -->

    <axsl:template match="/ubl:Order/cac:AllowanceCharge/*" priority="1093" mode="M12">
        <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="/ubl:Order/cac:AllowanceCharge/*"/>

        <!--ASSERT -->

        <axsl:choose>
            <axsl:when test="false()"/>
            <axsl:otherwise>
                <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="false()">
                    <axsl:attribute name="id">PEPPOL-T01-B19304</axsl:attribute>
                    <axsl:attribute name="flag">fatal</axsl:attribute>
                    <axsl:attribute name="location">
                        <axsl:apply-templates select="." mode="schematron-select-full-path"/>
                    </axsl:attribute>
                    <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
                </svrl:failed-assert>
            </axsl:otherwise>
        </axsl:choose>
        <axsl:apply-templates select="@*|*" mode="M12"/>
    </axsl:template>

    <!--RULE -->

    <axsl:template match="/ubl:Order/cac:TaxTotal" priority="1092" mode="M12">
        <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="/ubl:Order/cac:TaxTotal"/>

        <!--ASSERT -->

        <axsl:choose>
            <axsl:when test="cbc:TaxAmount"/>
            <axsl:otherwise>
                <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="cbc:TaxAmount">
                    <axsl:attribute name="id">PEPPOL-T01-B20701</axsl:attribute>
                    <axsl:attribute name="flag">fatal</axsl:attribute>
                    <axsl:attribute name="location">
                        <axsl:apply-templates select="." mode="schematron-select-full-path"/>
                    </axsl:attribute>
                    <svrl:text>Element 'cbc:TaxAmount' MUST be provided.</svrl:text>
                </svrl:failed-assert>
            </axsl:otherwise>
        </axsl:choose>
        <axsl:apply-templates select="@*|*" mode="M12"/>
    </axsl:template>

    <!--RULE -->

    <axsl:template match="/ubl:Order/cac:TaxTotal/cbc:TaxAmount" priority="1091" mode="M12">
        <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="/ubl:Order/cac:TaxTotal/cbc:TaxAmount"/>

        <!--ASSERT -->

        <axsl:choose>
            <axsl:when test="@currencyID"/>
            <axsl:otherwise>
                <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="@currencyID">
                    <axsl:attribute name="id">PEPPOL-T01-B20801</axsl:attribute>
                    <axsl:attribute name="flag">fatal</axsl:attribute>
                    <axsl:attribute name="location">
                        <axsl:apply-templates select="." mode="schematron-select-full-path"/>
                    </axsl:attribute>
                    <svrl:text>Attribute 'currencyID' MUST be present.</svrl:text>
                </svrl:failed-assert>
            </axsl:otherwise>
        </axsl:choose>

        <!--ASSERT -->

        <axsl:choose>
            <axsl:when test="not(@currencyID) or (some $code in $clISO4217 satisfies $code = @currencyID)"/>
            <axsl:otherwise>
                <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                    test="not(@currencyID) or (some $code in $clISO4217 satisfies $code = @currencyID)">
                    <axsl:attribute name="id">PEPPOL-T01-B20802</axsl:attribute>
                    <axsl:attribute name="flag">fatal</axsl:attribute>
                    <axsl:attribute name="location">
                        <axsl:apply-templates select="." mode="schematron-select-full-path"/>
                    </axsl:attribute>
                    <svrl:text>Value MUST be part of code list 'Currency codes (ISO 4217)'.</svrl:text>
                </svrl:failed-assert>
            </axsl:otherwise>
        </axsl:choose>
        <axsl:apply-templates select="@*|*" mode="M12"/>
    </axsl:template>

    <!--RULE -->

    <axsl:template match="/ubl:Order/cac:TaxTotal/*" priority="1090" mode="M12">
        <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="/ubl:Order/cac:TaxTotal/*"/>

        <!--ASSERT -->

        <axsl:choose>
            <axsl:when test="false()"/>
            <axsl:otherwise>
                <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="false()">
                    <axsl:attribute name="id">PEPPOL-T01-B20702</axsl:attribute>
                    <axsl:attribute name="flag">fatal</axsl:attribute>
                    <axsl:attribute name="location">
                        <axsl:apply-templates select="." mode="schematron-select-full-path"/>
                    </axsl:attribute>
                    <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
                </svrl:failed-assert>
            </axsl:otherwise>
        </axsl:choose>
        <axsl:apply-templates select="@*|*" mode="M12"/>
    </axsl:template>

    <!--RULE -->

    <axsl:template match="/ubl:Order/cac:AnticipatedMonetaryTotal" priority="1089" mode="M12">
        <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="/ubl:Order/cac:AnticipatedMonetaryTotal"/>

        <!--ASSERT -->

        <axsl:choose>
            <axsl:when test="cbc:LineExtensionAmount"/>
            <axsl:otherwise>
                <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="cbc:LineExtensionAmount">
                    <axsl:attribute name="id">PEPPOL-T01-B21001</axsl:attribute>
                    <axsl:attribute name="flag">fatal</axsl:attribute>
                    <axsl:attribute name="location">
                        <axsl:apply-templates select="." mode="schematron-select-full-path"/>
                    </axsl:attribute>
                    <svrl:text>Element 'cbc:LineExtensionAmount' MUST be provided.</svrl:text>
                </svrl:failed-assert>
            </axsl:otherwise>
        </axsl:choose>

        <!--ASSERT -->

        <axsl:choose>
            <axsl:when test="cbc:PayableAmount"/>
            <axsl:otherwise>
                <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="cbc:PayableAmount">
                    <axsl:attribute name="id">PEPPOL-T01-B21002</axsl:attribute>
                    <axsl:attribute name="flag">fatal</axsl:attribute>
                    <axsl:attribute name="location">
                        <axsl:apply-templates select="." mode="schematron-select-full-path"/>
                    </axsl:attribute>
                    <svrl:text>Element 'cbc:PayableAmount' MUST be provided.</svrl:text>
                </svrl:failed-assert>
            </axsl:otherwise>
        </axsl:choose>
        <axsl:apply-templates select="@*|*" mode="M12"/>
    </axsl:template>

    <!--RULE -->

    <axsl:template match="/ubl:Order/cac:AnticipatedMonetaryTotal/cbc:LineExtensionAmount" priority="1088" mode="M12">
        <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                         context="/ubl:Order/cac:AnticipatedMonetaryTotal/cbc:LineExtensionAmount"/>

        <!--ASSERT -->

        <axsl:choose>
            <axsl:when test="@currencyID"/>
            <axsl:otherwise>
                <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="@currencyID">
                    <axsl:attribute name="id">PEPPOL-T01-B21101</axsl:attribute>
                    <axsl:attribute name="flag">fatal</axsl:attribute>
                    <axsl:attribute name="location">
                        <axsl:apply-templates select="." mode="schematron-select-full-path"/>
                    </axsl:attribute>
                    <svrl:text>Attribute 'currencyID' MUST be present.</svrl:text>
                </svrl:failed-assert>
            </axsl:otherwise>
        </axsl:choose>

        <!--ASSERT -->

        <axsl:choose>
            <axsl:when test="not(@currencyID) or (some $code in $clISO4217 satisfies $code = @currencyID)"/>
            <axsl:otherwise>
                <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                    test="not(@currencyID) or (some $code in $clISO4217 satisfies $code = @currencyID)">
                    <axsl:attribute name="id">PEPPOL-T01-B21102</axsl:attribute>
                    <axsl:attribute name="flag">fatal</axsl:attribute>
                    <axsl:attribute name="location">
                        <axsl:apply-templates select="." mode="schematron-select-full-path"/>
                    </axsl:attribute>
                    <svrl:text>Value MUST be part of code list 'Currency codes (ISO 4217)'.</svrl:text>
                </svrl:failed-assert>
            </axsl:otherwise>
        </axsl:choose>
        <axsl:apply-templates select="@*|*" mode="M12"/>
    </axsl:template>

    <!--RULE -->

    <axsl:template match="/ubl:Order/cac:AnticipatedMonetaryTotal/cbc:TaxExclusiveAmount" priority="1087" mode="M12">
        <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                         context="/ubl:Order/cac:AnticipatedMonetaryTotal/cbc:TaxExclusiveAmount"/>

        <!--ASSERT -->

        <axsl:choose>
            <axsl:when test="@currencyID"/>
            <axsl:otherwise>
                <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="@currencyID">
                    <axsl:attribute name="id">PEPPOL-T01-B21301</axsl:attribute>
                    <axsl:attribute name="flag">fatal</axsl:attribute>
                    <axsl:attribute name="location">
                        <axsl:apply-templates select="." mode="schematron-select-full-path"/>
                    </axsl:attribute>
                    <svrl:text>Attribute 'currencyID' MUST be present.</svrl:text>
                </svrl:failed-assert>
            </axsl:otherwise>
        </axsl:choose>

        <!--ASSERT -->

        <axsl:choose>
            <axsl:when test="not(@currencyID) or (some $code in $clISO4217 satisfies $code = @currencyID)"/>
            <axsl:otherwise>
                <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                    test="not(@currencyID) or (some $code in $clISO4217 satisfies $code = @currencyID)">
                    <axsl:attribute name="id">PEPPOL-T01-B21302</axsl:attribute>
                    <axsl:attribute name="flag">fatal</axsl:attribute>
                    <axsl:attribute name="location">
                        <axsl:apply-templates select="." mode="schematron-select-full-path"/>
                    </axsl:attribute>
                    <svrl:text>Value MUST be part of code list 'Currency codes (ISO 4217)'.</svrl:text>
                </svrl:failed-assert>
            </axsl:otherwise>
        </axsl:choose>
        <axsl:apply-templates select="@*|*" mode="M12"/>
    </axsl:template>

    <!--RULE -->

    <axsl:template match="/ubl:Order/cac:AnticipatedMonetaryTotal/cbc:TaxInclusiveAmount" priority="1086" mode="M12">
        <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                         context="/ubl:Order/cac:AnticipatedMonetaryTotal/cbc:TaxInclusiveAmount"/>

        <!--ASSERT -->

        <axsl:choose>
            <axsl:when test="@currencyID"/>
            <axsl:otherwise>
                <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="@currencyID">
                    <axsl:attribute name="id">PEPPOL-T01-B21501</axsl:attribute>
                    <axsl:attribute name="flag">fatal</axsl:attribute>
                    <axsl:attribute name="location">
                        <axsl:apply-templates select="." mode="schematron-select-full-path"/>
                    </axsl:attribute>
                    <svrl:text>Attribute 'currencyID' MUST be present.</svrl:text>
                </svrl:failed-assert>
            </axsl:otherwise>
        </axsl:choose>

        <!--ASSERT -->

        <axsl:choose>
            <axsl:when test="not(@currencyID) or (some $code in $clISO4217 satisfies $code = @currencyID)"/>
            <axsl:otherwise>
                <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                    test="not(@currencyID) or (some $code in $clISO4217 satisfies $code = @currencyID)">
                    <axsl:attribute name="id">PEPPOL-T01-B21502</axsl:attribute>
                    <axsl:attribute name="flag">fatal</axsl:attribute>
                    <axsl:attribute name="location">
                        <axsl:apply-templates select="." mode="schematron-select-full-path"/>
                    </axsl:attribute>
                    <svrl:text>Value MUST be part of code list 'Currency codes (ISO 4217)'.</svrl:text>
                </svrl:failed-assert>
            </axsl:otherwise>
        </axsl:choose>
        <axsl:apply-templates select="@*|*" mode="M12"/>
    </axsl:template>

    <!--RULE -->

    <axsl:template match="/ubl:Order/cac:AnticipatedMonetaryTotal/cbc:AllowanceTotalAmount" priority="1085" mode="M12">
        <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                         context="/ubl:Order/cac:AnticipatedMonetaryTotal/cbc:AllowanceTotalAmount"/>

        <!--ASSERT -->

        <axsl:choose>
            <axsl:when test="@currencyID"/>
            <axsl:otherwise>
                <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="@currencyID">
                    <axsl:attribute name="id">PEPPOL-T01-B21701</axsl:attribute>
                    <axsl:attribute name="flag">fatal</axsl:attribute>
                    <axsl:attribute name="location">
                        <axsl:apply-templates select="." mode="schematron-select-full-path"/>
                    </axsl:attribute>
                    <svrl:text>Attribute 'currencyID' MUST be present.</svrl:text>
                </svrl:failed-assert>
            </axsl:otherwise>
        </axsl:choose>

        <!--ASSERT -->

        <axsl:choose>
            <axsl:when test="not(@currencyID) or (some $code in $clISO4217 satisfies $code = @currencyID)"/>
            <axsl:otherwise>
                <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                    test="not(@currencyID) or (some $code in $clISO4217 satisfies $code = @currencyID)">
                    <axsl:attribute name="id">PEPPOL-T01-B21702</axsl:attribute>
                    <axsl:attribute name="flag">fatal</axsl:attribute>
                    <axsl:attribute name="location">
                        <axsl:apply-templates select="." mode="schematron-select-full-path"/>
                    </axsl:attribute>
                    <svrl:text>Value MUST be part of code list 'Currency codes (ISO 4217)'.</svrl:text>
                </svrl:failed-assert>
            </axsl:otherwise>
        </axsl:choose>
        <axsl:apply-templates select="@*|*" mode="M12"/>
    </axsl:template>

    <!--RULE -->

    <axsl:template match="/ubl:Order/cac:AnticipatedMonetaryTotal/cbc:ChargeTotalAmount" priority="1084" mode="M12">
        <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                         context="/ubl:Order/cac:AnticipatedMonetaryTotal/cbc:ChargeTotalAmount"/>

        <!--ASSERT -->

        <axsl:choose>
            <axsl:when test="@currencyID"/>
            <axsl:otherwise>
                <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="@currencyID">
                    <axsl:attribute name="id">PEPPOL-T01-B21901</axsl:attribute>
                    <axsl:attribute name="flag">fatal</axsl:attribute>
                    <axsl:attribute name="location">
                        <axsl:apply-templates select="." mode="schematron-select-full-path"/>
                    </axsl:attribute>
                    <svrl:text>Attribute 'currencyID' MUST be present.</svrl:text>
                </svrl:failed-assert>
            </axsl:otherwise>
        </axsl:choose>

        <!--ASSERT -->

        <axsl:choose>
            <axsl:when test="not(@currencyID) or (some $code in $clISO4217 satisfies $code = @currencyID)"/>
            <axsl:otherwise>
                <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                    test="not(@currencyID) or (some $code in $clISO4217 satisfies $code = @currencyID)">
                    <axsl:attribute name="id">PEPPOL-T01-B21902</axsl:attribute>
                    <axsl:attribute name="flag">fatal</axsl:attribute>
                    <axsl:attribute name="location">
                        <axsl:apply-templates select="." mode="schematron-select-full-path"/>
                    </axsl:attribute>
                    <svrl:text>Value MUST be part of code list 'Currency codes (ISO 4217)'.</svrl:text>
                </svrl:failed-assert>
            </axsl:otherwise>
        </axsl:choose>
        <axsl:apply-templates select="@*|*" mode="M12"/>
    </axsl:template>

    <!--RULE -->

    <axsl:template match="/ubl:Order/cac:AnticipatedMonetaryTotal/cbc:PrepaidAmount" priority="1083" mode="M12">
        <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                         context="/ubl:Order/cac:AnticipatedMonetaryTotal/cbc:PrepaidAmount"/>

        <!--ASSERT -->

        <axsl:choose>
            <axsl:when test="@currencyID"/>
            <axsl:otherwise>
                <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="@currencyID">
                    <axsl:attribute name="id">PEPPOL-T01-B22101</axsl:attribute>
                    <axsl:attribute name="flag">fatal</axsl:attribute>
                    <axsl:attribute name="location">
                        <axsl:apply-templates select="." mode="schematron-select-full-path"/>
                    </axsl:attribute>
                    <svrl:text>Attribute 'currencyID' MUST be present.</svrl:text>
                </svrl:failed-assert>
            </axsl:otherwise>
        </axsl:choose>

        <!--ASSERT -->

        <axsl:choose>
            <axsl:when test="not(@currencyID) or (some $code in $clISO4217 satisfies $code = @currencyID)"/>
            <axsl:otherwise>
                <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                    test="not(@currencyID) or (some $code in $clISO4217 satisfies $code = @currencyID)">
                    <axsl:attribute name="id">PEPPOL-T01-B22102</axsl:attribute>
                    <axsl:attribute name="flag">fatal</axsl:attribute>
                    <axsl:attribute name="location">
                        <axsl:apply-templates select="." mode="schematron-select-full-path"/>
                    </axsl:attribute>
                    <svrl:text>Value MUST be part of code list 'Currency codes (ISO 4217)'.</svrl:text>
                </svrl:failed-assert>
            </axsl:otherwise>
        </axsl:choose>
        <axsl:apply-templates select="@*|*" mode="M12"/>
    </axsl:template>

    <!--RULE -->

    <axsl:template match="/ubl:Order/cac:AnticipatedMonetaryTotal/cbc:PayableRoundingAmount" priority="1082" mode="M12">
        <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                         context="/ubl:Order/cac:AnticipatedMonetaryTotal/cbc:PayableRoundingAmount"/>

        <!--ASSERT -->

        <axsl:choose>
            <axsl:when test="@currencyID"/>
            <axsl:otherwise>
                <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="@currencyID">
                    <axsl:attribute name="id">PEPPOL-T01-B22301</axsl:attribute>
                    <axsl:attribute name="flag">fatal</axsl:attribute>
                    <axsl:attribute name="location">
                        <axsl:apply-templates select="." mode="schematron-select-full-path"/>
                    </axsl:attribute>
                    <svrl:text>Attribute 'currencyID' MUST be present.</svrl:text>
                </svrl:failed-assert>
            </axsl:otherwise>
        </axsl:choose>

        <!--ASSERT -->

        <axsl:choose>
            <axsl:when test="not(@currencyID) or (some $code in $clISO4217 satisfies $code = @currencyID)"/>
            <axsl:otherwise>
                <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                    test="not(@currencyID) or (some $code in $clISO4217 satisfies $code = @currencyID)">
                    <axsl:attribute name="id">PEPPOL-T01-B22302</axsl:attribute>
                    <axsl:attribute name="flag">fatal</axsl:attribute>
                    <axsl:attribute name="location">
                        <axsl:apply-templates select="." mode="schematron-select-full-path"/>
                    </axsl:attribute>
                    <svrl:text>Value MUST be part of code list 'Currency codes (ISO 4217)'.</svrl:text>
                </svrl:failed-assert>
            </axsl:otherwise>
        </axsl:choose>
        <axsl:apply-templates select="@*|*" mode="M12"/>
    </axsl:template>

    <!--RULE -->

    <axsl:template match="/ubl:Order/cac:AnticipatedMonetaryTotal/cbc:PayableAmount" priority="1081" mode="M12">
        <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                         context="/ubl:Order/cac:AnticipatedMonetaryTotal/cbc:PayableAmount"/>

        <!--ASSERT -->

        <axsl:choose>
            <axsl:when test="@currencyID"/>
            <axsl:otherwise>
                <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="@currencyID">
                    <axsl:attribute name="id">PEPPOL-T01-B22501</axsl:attribute>
                    <axsl:attribute name="flag">fatal</axsl:attribute>
                    <axsl:attribute name="location">
                        <axsl:apply-templates select="." mode="schematron-select-full-path"/>
                    </axsl:attribute>
                    <svrl:text>Attribute 'currencyID' MUST be present.</svrl:text>
                </svrl:failed-assert>
            </axsl:otherwise>
        </axsl:choose>

        <!--ASSERT -->

        <axsl:choose>
            <axsl:when test="not(@currencyID) or (some $code in $clISO4217 satisfies $code = @currencyID)"/>
            <axsl:otherwise>
                <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                    test="not(@currencyID) or (some $code in $clISO4217 satisfies $code = @currencyID)">
                    <axsl:attribute name="id">PEPPOL-T01-B22502</axsl:attribute>
                    <axsl:attribute name="flag">fatal</axsl:attribute>
                    <axsl:attribute name="location">
                        <axsl:apply-templates select="." mode="schematron-select-full-path"/>
                    </axsl:attribute>
                    <svrl:text>Value MUST be part of code list 'Currency codes (ISO 4217)'.</svrl:text>
                </svrl:failed-assert>
            </axsl:otherwise>
        </axsl:choose>
        <axsl:apply-templates select="@*|*" mode="M12"/>
    </axsl:template>

    <!--RULE -->

    <axsl:template match="/ubl:Order/cac:AnticipatedMonetaryTotal/*" priority="1080" mode="M12">
        <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                         context="/ubl:Order/cac:AnticipatedMonetaryTotal/*"/>

        <!--ASSERT -->

        <axsl:choose>
            <axsl:when test="false()"/>
            <axsl:otherwise>
                <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="false()">
                    <axsl:attribute name="id">PEPPOL-T01-B21003</axsl:attribute>
                    <axsl:attribute name="flag">fatal</axsl:attribute>
                    <axsl:attribute name="location">
                        <axsl:apply-templates select="." mode="schematron-select-full-path"/>
                    </axsl:attribute>
                    <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
                </svrl:failed-assert>
            </axsl:otherwise>
        </axsl:choose>
        <axsl:apply-templates select="@*|*" mode="M12"/>
    </axsl:template>

    <!--RULE -->

    <axsl:template match="/ubl:Order/cac:OrderLine" priority="1079" mode="M12">
        <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="/ubl:Order/cac:OrderLine"/>

        <!--ASSERT -->

        <axsl:choose>
            <axsl:when test="cac:LineItem"/>
            <axsl:otherwise>
                <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="cac:LineItem">
                    <axsl:attribute name="id">PEPPOL-T01-B22701</axsl:attribute>
                    <axsl:attribute name="flag">fatal</axsl:attribute>
                    <axsl:attribute name="location">
                        <axsl:apply-templates select="." mode="schematron-select-full-path"/>
                    </axsl:attribute>
                    <svrl:text>Element 'cac:LineItem' MUST be provided.</svrl:text>
                </svrl:failed-assert>
            </axsl:otherwise>
        </axsl:choose>
        <axsl:apply-templates select="@*|*" mode="M12"/>
    </axsl:template>

    <!--RULE -->

    <axsl:template match="/ubl:Order/cac:OrderLine/cbc:Note" priority="1078" mode="M12">
        <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="/ubl:Order/cac:OrderLine/cbc:Note"/>
        <axsl:apply-templates select="@*|*" mode="M12"/>
    </axsl:template>

    <!--RULE -->

    <axsl:template match="/ubl:Order/cac:OrderLine/cac:LineItem" priority="1077" mode="M12">
        <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="/ubl:Order/cac:OrderLine/cac:LineItem"/>

        <!--ASSERT -->

        <axsl:choose>
            <axsl:when test="cbc:ID"/>
            <axsl:otherwise>
                <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="cbc:ID">
                    <axsl:attribute name="id">PEPPOL-T01-B22901</axsl:attribute>
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
            <axsl:when test="cbc:Quantity"/>
            <axsl:otherwise>
                <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="cbc:Quantity">
                    <axsl:attribute name="id">PEPPOL-T01-B22902</axsl:attribute>
                    <axsl:attribute name="flag">fatal</axsl:attribute>
                    <axsl:attribute name="location">
                        <axsl:apply-templates select="." mode="schematron-select-full-path"/>
                    </axsl:attribute>
                    <svrl:text>Element 'cbc:Quantity' MUST be provided.</svrl:text>
                </svrl:failed-assert>
            </axsl:otherwise>
        </axsl:choose>

        <!--ASSERT -->

        <axsl:choose>
            <axsl:when test="cac:Item"/>
            <axsl:otherwise>
                <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="cac:Item">
                    <axsl:attribute name="id">PEPPOL-T01-B22903</axsl:attribute>
                    <axsl:attribute name="flag">fatal</axsl:attribute>
                    <axsl:attribute name="location">
                        <axsl:apply-templates select="." mode="schematron-select-full-path"/>
                    </axsl:attribute>
                    <svrl:text>Element 'cac:Item' MUST be provided.</svrl:text>
                </svrl:failed-assert>
            </axsl:otherwise>
        </axsl:choose>
        <axsl:apply-templates select="@*|*" mode="M12"/>
    </axsl:template>

    <!--RULE -->

    <axsl:template match="/ubl:Order/cac:OrderLine/cac:LineItem/cbc:ID" priority="1076" mode="M12">
        <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                         context="/ubl:Order/cac:OrderLine/cac:LineItem/cbc:ID"/>
        <axsl:apply-templates select="@*|*" mode="M12"/>
    </axsl:template>

    <!--RULE -->

    <axsl:template match="/ubl:Order/cac:OrderLine/cac:LineItem/cbc:Quantity" priority="1075" mode="M12">
        <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                         context="/ubl:Order/cac:OrderLine/cac:LineItem/cbc:Quantity"/>

        <!--ASSERT -->

        <axsl:choose>
            <axsl:when test="@unitCode"/>
            <axsl:otherwise>
                <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="@unitCode">
                    <axsl:attribute name="id">PEPPOL-T01-B23101</axsl:attribute>
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
                <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                    test="not(@unitCode) or (some $code in $clUNECERec20 satisfies $code = @unitCode)">
                    <axsl:attribute name="id">PEPPOL-T01-B23102</axsl:attribute>
                    <axsl:attribute name="flag">fatal</axsl:attribute>
                    <axsl:attribute name="location">
                        <axsl:apply-templates select="." mode="schematron-select-full-path"/>
                    </axsl:attribute>
                    <svrl:text>Value MUST be part of code list 'Recommandation 20, including Recommondation 21 codes -
                        prefixed with X (UN/ECE)'.
                    </svrl:text>
                </svrl:failed-assert>
            </axsl:otherwise>
        </axsl:choose>
        <axsl:apply-templates select="@*|*" mode="M12"/>
    </axsl:template>

    <!--RULE -->

    <axsl:template match="/ubl:Order/cac:OrderLine/cac:LineItem/cbc:LineExtensionAmount" priority="1074" mode="M12">
        <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                         context="/ubl:Order/cac:OrderLine/cac:LineItem/cbc:LineExtensionAmount"/>

        <!--ASSERT -->

        <axsl:choose>
            <axsl:when test="@currencyID"/>
            <axsl:otherwise>
                <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="@currencyID">
                    <axsl:attribute name="id">PEPPOL-T01-B23301</axsl:attribute>
                    <axsl:attribute name="flag">fatal</axsl:attribute>
                    <axsl:attribute name="location">
                        <axsl:apply-templates select="." mode="schematron-select-full-path"/>
                    </axsl:attribute>
                    <svrl:text>Attribute 'currencyID' MUST be present.</svrl:text>
                </svrl:failed-assert>
            </axsl:otherwise>
        </axsl:choose>

        <!--ASSERT -->

        <axsl:choose>
            <axsl:when test="not(@currencyID) or (some $code in $clISO4217 satisfies $code = @currencyID)"/>
            <axsl:otherwise>
                <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                    test="not(@currencyID) or (some $code in $clISO4217 satisfies $code = @currencyID)">
                    <axsl:attribute name="id">PEPPOL-T01-B23302</axsl:attribute>
                    <axsl:attribute name="flag">fatal</axsl:attribute>
                    <axsl:attribute name="location">
                        <axsl:apply-templates select="." mode="schematron-select-full-path"/>
                    </axsl:attribute>
                    <svrl:text>Value MUST be part of code list 'Currency codes (ISO 4217)'.</svrl:text>
                </svrl:failed-assert>
            </axsl:otherwise>
        </axsl:choose>
        <axsl:apply-templates select="@*|*" mode="M12"/>
    </axsl:template>

    <!--RULE -->

    <axsl:template match="/ubl:Order/cac:OrderLine/cac:LineItem/cbc:PartialDeliveryIndicator" priority="1073"
                   mode="M12">
        <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                         context="/ubl:Order/cac:OrderLine/cac:LineItem/cbc:PartialDeliveryIndicator"/>

        <!--ASSERT -->

        <axsl:choose>
            <axsl:when test="(some $code in $clTrueFalse satisfies $code = normalize-space(text()))"/>
            <axsl:otherwise>
                <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                    test="(some $code in $clTrueFalse satisfies $code = normalize-space(text()))">
                    <axsl:attribute name="id">PEPPOL-T01-B23501</axsl:attribute>
                    <axsl:attribute name="flag">fatal</axsl:attribute>
                    <axsl:attribute name="location">
                        <axsl:apply-templates select="." mode="schematron-select-full-path"/>
                    </axsl:attribute>
                    <svrl:text>Value MUST be part of code list 'Boolean indicator (openPEPPOL)'.</svrl:text>
                </svrl:failed-assert>
            </axsl:otherwise>
        </axsl:choose>
        <axsl:apply-templates select="@*|*" mode="M12"/>
    </axsl:template>

    <!--RULE -->

    <axsl:template match="/ubl:Order/cac:OrderLine/cac:LineItem/cbc:AccountingCost" priority="1072" mode="M12">
        <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                         context="/ubl:Order/cac:OrderLine/cac:LineItem/cbc:AccountingCost"/>
        <axsl:apply-templates select="@*|*" mode="M12"/>
    </axsl:template>

    <!--RULE -->

    <axsl:template match="/ubl:Order/cac:OrderLine/cac:LineItem/cac:Delivery" priority="1071" mode="M12">
        <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                         context="/ubl:Order/cac:OrderLine/cac:LineItem/cac:Delivery"/>

        <!--ASSERT -->

        <axsl:choose>
            <axsl:when test="cac:RequestedDeliveryPeriod"/>
            <axsl:otherwise>
                <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="cac:RequestedDeliveryPeriod">
                    <axsl:attribute name="id">PEPPOL-T01-B23701</axsl:attribute>
                    <axsl:attribute name="flag">fatal</axsl:attribute>
                    <axsl:attribute name="location">
                        <axsl:apply-templates select="." mode="schematron-select-full-path"/>
                    </axsl:attribute>
                    <svrl:text>Element 'cac:RequestedDeliveryPeriod' MUST be provided.</svrl:text>
                </svrl:failed-assert>
            </axsl:otherwise>
        </axsl:choose>
        <axsl:apply-templates select="@*|*" mode="M12"/>
    </axsl:template>

    <!--RULE -->

    <axsl:template match="/ubl:Order/cac:OrderLine/cac:LineItem/cac:Delivery/cbc:ID" priority="1070" mode="M12">
        <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                         context="/ubl:Order/cac:OrderLine/cac:LineItem/cac:Delivery/cbc:ID"/>

        <!--ASSERT -->

        <axsl:choose>
            <axsl:when test="not(@schemeID) or (some $code in $clICD satisfies $code = @schemeID)"/>
            <axsl:otherwise>
                <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                    test="not(@schemeID) or (some $code in $clICD satisfies $code = @schemeID)">
                    <axsl:attribute name="id">PEPPOL-T01-B23801</axsl:attribute>
                    <axsl:attribute name="flag">fatal</axsl:attribute>
                    <axsl:attribute name="location">
                        <axsl:apply-templates select="." mode="schematron-select-full-path"/>
                    </axsl:attribute>
                    <svrl:text>Value MUST be part of code list 'ISO 6523 ICD list'.</svrl:text>
                </svrl:failed-assert>
            </axsl:otherwise>
        </axsl:choose>
        <axsl:apply-templates select="@*|*" mode="M12"/>
    </axsl:template>

    <!--RULE -->

    <axsl:template match="/ubl:Order/cac:OrderLine/cac:LineItem/cac:Delivery/cac:RequestedDeliveryPeriod"
                   priority="1069" mode="M12">
        <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                         context="/ubl:Order/cac:OrderLine/cac:LineItem/cac:Delivery/cac:RequestedDeliveryPeriod"/>
        <axsl:apply-templates select="@*|*" mode="M12"/>
    </axsl:template>

    <!--RULE -->

    <axsl:template match="/ubl:Order/cac:OrderLine/cac:LineItem/cac:Delivery/cac:RequestedDeliveryPeriod/cbc:StartDate"
                   priority="1068" mode="M12">
        <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                         context="/ubl:Order/cac:OrderLine/cac:LineItem/cac:Delivery/cac:RequestedDeliveryPeriod/cbc:StartDate"/>
        <axsl:apply-templates select="@*|*" mode="M12"/>
    </axsl:template>

    <!--RULE -->

    <axsl:template match="/ubl:Order/cac:OrderLine/cac:LineItem/cac:Delivery/cac:RequestedDeliveryPeriod/cbc:EndDate"
                   priority="1067" mode="M12">
        <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                         context="/ubl:Order/cac:OrderLine/cac:LineItem/cac:Delivery/cac:RequestedDeliveryPeriod/cbc:EndDate"/>
        <axsl:apply-templates select="@*|*" mode="M12"/>
    </axsl:template>

    <!--RULE -->

    <axsl:template match="/ubl:Order/cac:OrderLine/cac:LineItem/cac:Delivery/cac:RequestedDeliveryPeriod/*"
                   priority="1066" mode="M12">
        <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                         context="/ubl:Order/cac:OrderLine/cac:LineItem/cac:Delivery/cac:RequestedDeliveryPeriod/*"/>

        <!--ASSERT -->

        <axsl:choose>
            <axsl:when test="false()"/>
            <axsl:otherwise>
                <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="false()">
                    <axsl:attribute name="id">PEPPOL-T01-B24001</axsl:attribute>
                    <axsl:attribute name="flag">fatal</axsl:attribute>
                    <axsl:attribute name="location">
                        <axsl:apply-templates select="." mode="schematron-select-full-path"/>
                    </axsl:attribute>
                    <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
                </svrl:failed-assert>
            </axsl:otherwise>
        </axsl:choose>
        <axsl:apply-templates select="@*|*" mode="M12"/>
    </axsl:template>

    <!--RULE -->

    <axsl:template match="/ubl:Order/cac:OrderLine/cac:LineItem/cac:Delivery/*" priority="1065" mode="M12">
        <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                         context="/ubl:Order/cac:OrderLine/cac:LineItem/cac:Delivery/*"/>

        <!--ASSERT -->

        <axsl:choose>
            <axsl:when test="false()"/>
            <axsl:otherwise>
                <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="false()">
                    <axsl:attribute name="id">PEPPOL-T01-B23702</axsl:attribute>
                    <axsl:attribute name="flag">fatal</axsl:attribute>
                    <axsl:attribute name="location">
                        <axsl:apply-templates select="." mode="schematron-select-full-path"/>
                    </axsl:attribute>
                    <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
                </svrl:failed-assert>
            </axsl:otherwise>
        </axsl:choose>
        <axsl:apply-templates select="@*|*" mode="M12"/>
    </axsl:template>

    <!--RULE -->

    <axsl:template match="/ubl:Order/cac:OrderLine/cac:LineItem/cac:OriginatorParty" priority="1064" mode="M12">
        <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                         context="/ubl:Order/cac:OrderLine/cac:LineItem/cac:OriginatorParty"/>
        <axsl:apply-templates select="@*|*" mode="M12"/>
    </axsl:template>

    <!--RULE -->

    <axsl:template match="/ubl:Order/cac:OrderLine/cac:LineItem/cac:OriginatorParty/cac:PartyIdentification"
                   priority="1063" mode="M12">
        <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                         context="/ubl:Order/cac:OrderLine/cac:LineItem/cac:OriginatorParty/cac:PartyIdentification"/>

        <!--ASSERT -->

        <axsl:choose>
            <axsl:when test="cbc:ID"/>
            <axsl:otherwise>
                <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="cbc:ID">
                    <axsl:attribute name="id">PEPPOL-T01-B24401</axsl:attribute>
                    <axsl:attribute name="flag">fatal</axsl:attribute>
                    <axsl:attribute name="location">
                        <axsl:apply-templates select="." mode="schematron-select-full-path"/>
                    </axsl:attribute>
                    <svrl:text>Element 'cbc:ID' MUST be provided.</svrl:text>
                </svrl:failed-assert>
            </axsl:otherwise>
        </axsl:choose>
        <axsl:apply-templates select="@*|*" mode="M12"/>
    </axsl:template>

    <!--RULE -->

    <axsl:template match="/ubl:Order/cac:OrderLine/cac:LineItem/cac:OriginatorParty/cac:PartyIdentification/cbc:ID"
                   priority="1062" mode="M12">
        <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                         context="/ubl:Order/cac:OrderLine/cac:LineItem/cac:OriginatorParty/cac:PartyIdentification/cbc:ID"/>

        <!--ASSERT -->

        <axsl:choose>
            <axsl:when test="not(@schemeID) or (some $code in $clICD satisfies $code = @schemeID)"/>
            <axsl:otherwise>
                <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                    test="not(@schemeID) or (some $code in $clICD satisfies $code = @schemeID)">
                    <axsl:attribute name="id">PEPPOL-T01-B24501</axsl:attribute>
                    <axsl:attribute name="flag">fatal</axsl:attribute>
                    <axsl:attribute name="location">
                        <axsl:apply-templates select="." mode="schematron-select-full-path"/>
                    </axsl:attribute>
                    <svrl:text>Value MUST be part of code list 'ISO 6523 ICD list'.</svrl:text>
                </svrl:failed-assert>
            </axsl:otherwise>
        </axsl:choose>
        <axsl:apply-templates select="@*|*" mode="M12"/>
    </axsl:template>

    <!--RULE -->

    <axsl:template match="/ubl:Order/cac:OrderLine/cac:LineItem/cac:OriginatorParty/cac:PartyName" priority="1061"
                   mode="M12">
        <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                         context="/ubl:Order/cac:OrderLine/cac:LineItem/cac:OriginatorParty/cac:PartyName"/>

        <!--ASSERT -->

        <axsl:choose>
            <axsl:when test="cbc:Name"/>
            <axsl:otherwise>
                <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="cbc:Name">
                    <axsl:attribute name="id">PEPPOL-T01-B24701</axsl:attribute>
                    <axsl:attribute name="flag">fatal</axsl:attribute>
                    <axsl:attribute name="location">
                        <axsl:apply-templates select="." mode="schematron-select-full-path"/>
                    </axsl:attribute>
                    <svrl:text>Element 'cbc:Name' MUST be provided.</svrl:text>
                </svrl:failed-assert>
            </axsl:otherwise>
        </axsl:choose>
        <axsl:apply-templates select="@*|*" mode="M12"/>
    </axsl:template>

    <!--RULE -->

    <axsl:template match="/ubl:Order/cac:OrderLine/cac:LineItem/cac:OriginatorParty/cac:PartyName/cbc:Name"
                   priority="1060" mode="M12">
        <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                         context="/ubl:Order/cac:OrderLine/cac:LineItem/cac:OriginatorParty/cac:PartyName/cbc:Name"/>
        <axsl:apply-templates select="@*|*" mode="M12"/>
    </axsl:template>

    <!--RULE -->

    <axsl:template match="/ubl:Order/cac:OrderLine/cac:LineItem/cac:OriginatorParty/*" priority="1059" mode="M12">
        <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                         context="/ubl:Order/cac:OrderLine/cac:LineItem/cac:OriginatorParty/*"/>

        <!--ASSERT -->

        <axsl:choose>
            <axsl:when test="false()"/>
            <axsl:otherwise>
                <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="false()">
                    <axsl:attribute name="id">PEPPOL-T01-B24301</axsl:attribute>
                    <axsl:attribute name="flag">fatal</axsl:attribute>
                    <axsl:attribute name="location">
                        <axsl:apply-templates select="." mode="schematron-select-full-path"/>
                    </axsl:attribute>
                    <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
                </svrl:failed-assert>
            </axsl:otherwise>
        </axsl:choose>
        <axsl:apply-templates select="@*|*" mode="M12"/>
    </axsl:template>

    <!--RULE -->

    <axsl:template match="/ubl:Order/cac:OrderLine/cac:LineItem/cac:AllowanceCharge" priority="1058" mode="M12">
        <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                         context="/ubl:Order/cac:OrderLine/cac:LineItem/cac:AllowanceCharge"/>

        <!--ASSERT -->

        <axsl:choose>
            <axsl:when test="cbc:ChargeIndicator"/>
            <axsl:otherwise>
                <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="cbc:ChargeIndicator">
                    <axsl:attribute name="id">PEPPOL-T01-B24901</axsl:attribute>
                    <axsl:attribute name="flag">fatal</axsl:attribute>
                    <axsl:attribute name="location">
                        <axsl:apply-templates select="." mode="schematron-select-full-path"/>
                    </axsl:attribute>
                    <svrl:text>Element 'cbc:ChargeIndicator' MUST be provided.</svrl:text>
                </svrl:failed-assert>
            </axsl:otherwise>
        </axsl:choose>

        <!--ASSERT -->

        <axsl:choose>
            <axsl:when test="cbc:Amount"/>
            <axsl:otherwise>
                <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="cbc:Amount">
                    <axsl:attribute name="id">PEPPOL-T01-B24902</axsl:attribute>
                    <axsl:attribute name="flag">fatal</axsl:attribute>
                    <axsl:attribute name="location">
                        <axsl:apply-templates select="." mode="schematron-select-full-path"/>
                    </axsl:attribute>
                    <svrl:text>Element 'cbc:Amount' MUST be provided.</svrl:text>
                </svrl:failed-assert>
            </axsl:otherwise>
        </axsl:choose>
        <axsl:apply-templates select="@*|*" mode="M12"/>
    </axsl:template>

    <!--RULE -->

    <axsl:template match="/ubl:Order/cac:OrderLine/cac:LineItem/cac:AllowanceCharge/cbc:ChargeIndicator" priority="1057"
                   mode="M12">
        <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                         context="/ubl:Order/cac:OrderLine/cac:LineItem/cac:AllowanceCharge/cbc:ChargeIndicator"/>
        <axsl:apply-templates select="@*|*" mode="M12"/>
    </axsl:template>

    <!--RULE -->

    <axsl:template match="/ubl:Order/cac:OrderLine/cac:LineItem/cac:AllowanceCharge/cbc:AllowanceChargeReasonCode"
                   priority="1056" mode="M12">
        <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                         context="/ubl:Order/cac:OrderLine/cac:LineItem/cac:AllowanceCharge/cbc:AllowanceChargeReasonCode"/>

        <!--ASSERT -->

        <axsl:choose>
            <axsl:when
                    test="(some $code in $clUNCL5189 satisfies $code = normalize-space(text())) or (some $code in $clUNCL7161 satisfies $code = normalize-space(text()))"/>
            <axsl:otherwise>
                <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                    test="(some $code in $clUNCL5189 satisfies $code = normalize-space(text())) or (some $code in $clUNCL7161 satisfies $code = normalize-space(text()))">
                    <axsl:attribute name="id">PEPPOL-T01-B25101</axsl:attribute>
                    <axsl:attribute name="flag">fatal</axsl:attribute>
                    <axsl:attribute name="location">
                        <axsl:apply-templates select="." mode="schematron-select-full-path"/>
                    </axsl:attribute>
                    <svrl:text>Value MUST be part of code list 'Allowance reason codes (UNCL5189 subset)' or 'Charge
                        reason code (UNCL7161)'.
                    </svrl:text>
                </svrl:failed-assert>
            </axsl:otherwise>
        </axsl:choose>
        <axsl:apply-templates select="@*|*" mode="M12"/>
    </axsl:template>

    <!--RULE -->

    <axsl:template match="/ubl:Order/cac:OrderLine/cac:LineItem/cac:AllowanceCharge/cbc:AllowanceChargeReason"
                   priority="1055" mode="M12">
        <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                         context="/ubl:Order/cac:OrderLine/cac:LineItem/cac:AllowanceCharge/cbc:AllowanceChargeReason"/>
        <axsl:apply-templates select="@*|*" mode="M12"/>
    </axsl:template>

    <!--RULE -->

    <axsl:template match="/ubl:Order/cac:OrderLine/cac:LineItem/cac:AllowanceCharge/cbc:MultiplierFactorNumeric"
                   priority="1054" mode="M12">
        <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                         context="/ubl:Order/cac:OrderLine/cac:LineItem/cac:AllowanceCharge/cbc:MultiplierFactorNumeric"/>
        <axsl:apply-templates select="@*|*" mode="M12"/>
    </axsl:template>

    <!--RULE -->

    <axsl:template match="/ubl:Order/cac:OrderLine/cac:LineItem/cac:AllowanceCharge/cbc:Amount" priority="1053"
                   mode="M12">
        <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                         context="/ubl:Order/cac:OrderLine/cac:LineItem/cac:AllowanceCharge/cbc:Amount"/>

        <!--ASSERT -->

        <axsl:choose>
            <axsl:when test="@currencyID"/>
            <axsl:otherwise>
                <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="@currencyID">
                    <axsl:attribute name="id">PEPPOL-T01-B25401</axsl:attribute>
                    <axsl:attribute name="flag">fatal</axsl:attribute>
                    <axsl:attribute name="location">
                        <axsl:apply-templates select="." mode="schematron-select-full-path"/>
                    </axsl:attribute>
                    <svrl:text>Attribute 'currencyID' MUST be present.</svrl:text>
                </svrl:failed-assert>
            </axsl:otherwise>
        </axsl:choose>

        <!--ASSERT -->

        <axsl:choose>
            <axsl:when test="not(@currencyID) or (some $code in $clISO4217 satisfies $code = @currencyID)"/>
            <axsl:otherwise>
                <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                    test="not(@currencyID) or (some $code in $clISO4217 satisfies $code = @currencyID)">
                    <axsl:attribute name="id">PEPPOL-T01-B25402</axsl:attribute>
                    <axsl:attribute name="flag">fatal</axsl:attribute>
                    <axsl:attribute name="location">
                        <axsl:apply-templates select="." mode="schematron-select-full-path"/>
                    </axsl:attribute>
                    <svrl:text>Value MUST be part of code list 'Currency codes (ISO 4217)'.</svrl:text>
                </svrl:failed-assert>
            </axsl:otherwise>
        </axsl:choose>
        <axsl:apply-templates select="@*|*" mode="M12"/>
    </axsl:template>

    <!--RULE -->

    <axsl:template match="/ubl:Order/cac:OrderLine/cac:LineItem/cac:AllowanceCharge/cbc:BaseAmount" priority="1052"
                   mode="M12">
        <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                         context="/ubl:Order/cac:OrderLine/cac:LineItem/cac:AllowanceCharge/cbc:BaseAmount"/>

        <!--ASSERT -->

        <axsl:choose>
            <axsl:when test="@currencyID"/>
            <axsl:otherwise>
                <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="@currencyID">
                    <axsl:attribute name="id">PEPPOL-T01-B25601</axsl:attribute>
                    <axsl:attribute name="flag">fatal</axsl:attribute>
                    <axsl:attribute name="location">
                        <axsl:apply-templates select="." mode="schematron-select-full-path"/>
                    </axsl:attribute>
                    <svrl:text>Attribute 'currencyID' MUST be present.</svrl:text>
                </svrl:failed-assert>
            </axsl:otherwise>
        </axsl:choose>

        <!--ASSERT -->

        <axsl:choose>
            <axsl:when test="not(@currencyID) or (some $code in $clISO4217 satisfies $code = @currencyID)"/>
            <axsl:otherwise>
                <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                    test="not(@currencyID) or (some $code in $clISO4217 satisfies $code = @currencyID)">
                    <axsl:attribute name="id">PEPPOL-T01-B25602</axsl:attribute>
                    <axsl:attribute name="flag">fatal</axsl:attribute>
                    <axsl:attribute name="location">
                        <axsl:apply-templates select="." mode="schematron-select-full-path"/>
                    </axsl:attribute>
                    <svrl:text>Value MUST be part of code list 'Currency codes (ISO 4217)'.</svrl:text>
                </svrl:failed-assert>
            </axsl:otherwise>
        </axsl:choose>
        <axsl:apply-templates select="@*|*" mode="M12"/>
    </axsl:template>

    <!--RULE -->

    <axsl:template match="/ubl:Order/cac:OrderLine/cac:LineItem/cac:AllowanceCharge/*" priority="1051" mode="M12">
        <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                         context="/ubl:Order/cac:OrderLine/cac:LineItem/cac:AllowanceCharge/*"/>

        <!--ASSERT -->

        <axsl:choose>
            <axsl:when test="false()"/>
            <axsl:otherwise>
                <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="false()">
                    <axsl:attribute name="id">PEPPOL-T01-B24903</axsl:attribute>
                    <axsl:attribute name="flag">fatal</axsl:attribute>
                    <axsl:attribute name="location">
                        <axsl:apply-templates select="." mode="schematron-select-full-path"/>
                    </axsl:attribute>
                    <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
                </svrl:failed-assert>
            </axsl:otherwise>
        </axsl:choose>
        <axsl:apply-templates select="@*|*" mode="M12"/>
    </axsl:template>

    <!--RULE -->

    <axsl:template match="/ubl:Order/cac:OrderLine/cac:LineItem/cac:Price" priority="1050" mode="M12">
        <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                         context="/ubl:Order/cac:OrderLine/cac:LineItem/cac:Price"/>

        <!--ASSERT -->

        <axsl:choose>
            <axsl:when test="cbc:PriceAmount"/>
            <axsl:otherwise>
                <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="cbc:PriceAmount">
                    <axsl:attribute name="id">PEPPOL-T01-B25801</axsl:attribute>
                    <axsl:attribute name="flag">fatal</axsl:attribute>
                    <axsl:attribute name="location">
                        <axsl:apply-templates select="." mode="schematron-select-full-path"/>
                    </axsl:attribute>
                    <svrl:text>Element 'cbc:PriceAmount' MUST be provided.</svrl:text>
                </svrl:failed-assert>
            </axsl:otherwise>
        </axsl:choose>
        <axsl:apply-templates select="@*|*" mode="M12"/>
    </axsl:template>

    <!--RULE -->

    <axsl:template match="/ubl:Order/cac:OrderLine/cac:LineItem/cac:Price/cbc:PriceAmount" priority="1049" mode="M12">
        <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                         context="/ubl:Order/cac:OrderLine/cac:LineItem/cac:Price/cbc:PriceAmount"/>

        <!--ASSERT -->

        <axsl:choose>
            <axsl:when test="@currencyID"/>
            <axsl:otherwise>
                <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="@currencyID">
                    <axsl:attribute name="id">PEPPOL-T01-B25901</axsl:attribute>
                    <axsl:attribute name="flag">fatal</axsl:attribute>
                    <axsl:attribute name="location">
                        <axsl:apply-templates select="." mode="schematron-select-full-path"/>
                    </axsl:attribute>
                    <svrl:text>Attribute 'currencyID' MUST be present.</svrl:text>
                </svrl:failed-assert>
            </axsl:otherwise>
        </axsl:choose>

        <!--ASSERT -->

        <axsl:choose>
            <axsl:when test="not(@currencyID) or (some $code in $clISO4217 satisfies $code = @currencyID)"/>
            <axsl:otherwise>
                <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                    test="not(@currencyID) or (some $code in $clISO4217 satisfies $code = @currencyID)">
                    <axsl:attribute name="id">PEPPOL-T01-B25902</axsl:attribute>
                    <axsl:attribute name="flag">fatal</axsl:attribute>
                    <axsl:attribute name="location">
                        <axsl:apply-templates select="." mode="schematron-select-full-path"/>
                    </axsl:attribute>
                    <svrl:text>Value MUST be part of code list 'Currency codes (ISO 4217)'.</svrl:text>
                </svrl:failed-assert>
            </axsl:otherwise>
        </axsl:choose>
        <axsl:apply-templates select="@*|*" mode="M12"/>
    </axsl:template>

    <!--RULE -->

    <axsl:template match="/ubl:Order/cac:OrderLine/cac:LineItem/cac:Price/cbc:BaseQuantity" priority="1048" mode="M12">
        <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                         context="/ubl:Order/cac:OrderLine/cac:LineItem/cac:Price/cbc:BaseQuantity"/>

        <!--ASSERT -->

        <axsl:choose>
            <axsl:when test="not(@unitCode) or (some $code in $clUNECERec20 satisfies $code = @unitCode)"/>
            <axsl:otherwise>
                <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                    test="not(@unitCode) or (some $code in $clUNECERec20 satisfies $code = @unitCode)">
                    <axsl:attribute name="id">PEPPOL-T01-B26101</axsl:attribute>
                    <axsl:attribute name="flag">fatal</axsl:attribute>
                    <axsl:attribute name="location">
                        <axsl:apply-templates select="." mode="schematron-select-full-path"/>
                    </axsl:attribute>
                    <svrl:text>Value MUST be part of code list 'Recommandation 20, including Recommondation 21 codes -
                        prefixed with X (UN/ECE)'.
                    </svrl:text>
                </svrl:failed-assert>
            </axsl:otherwise>
        </axsl:choose>
        <axsl:apply-templates select="@*|*" mode="M12"/>
    </axsl:template>

    <!--RULE -->

    <axsl:template match="/ubl:Order/cac:OrderLine/cac:LineItem/cac:Price/cac:AllowanceCharge" priority="1047"
                   mode="M12">
        <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                         context="/ubl:Order/cac:OrderLine/cac:LineItem/cac:Price/cac:AllowanceCharge"/>

        <!--ASSERT -->

        <axsl:choose>
            <axsl:when test="cbc:ChargeIndicator"/>
            <axsl:otherwise>
                <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="cbc:ChargeIndicator">
                    <axsl:attribute name="id">PEPPOL-T01-B26301</axsl:attribute>
                    <axsl:attribute name="flag">fatal</axsl:attribute>
                    <axsl:attribute name="location">
                        <axsl:apply-templates select="." mode="schematron-select-full-path"/>
                    </axsl:attribute>
                    <svrl:text>Element 'cbc:ChargeIndicator' MUST be provided.</svrl:text>
                </svrl:failed-assert>
            </axsl:otherwise>
        </axsl:choose>

        <!--ASSERT -->

        <axsl:choose>
            <axsl:when test="cbc:Amount"/>
            <axsl:otherwise>
                <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="cbc:Amount">
                    <axsl:attribute name="id">PEPPOL-T01-B26302</axsl:attribute>
                    <axsl:attribute name="flag">fatal</axsl:attribute>
                    <axsl:attribute name="location">
                        <axsl:apply-templates select="." mode="schematron-select-full-path"/>
                    </axsl:attribute>
                    <svrl:text>Element 'cbc:Amount' MUST be provided.</svrl:text>
                </svrl:failed-assert>
            </axsl:otherwise>
        </axsl:choose>
        <axsl:apply-templates select="@*|*" mode="M12"/>
    </axsl:template>

    <!--RULE -->

    <axsl:template match="/ubl:Order/cac:OrderLine/cac:LineItem/cac:Price/cac:AllowanceCharge/cbc:ChargeIndicator"
                   priority="1046" mode="M12">
        <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                         context="/ubl:Order/cac:OrderLine/cac:LineItem/cac:Price/cac:AllowanceCharge/cbc:ChargeIndicator"/>

        <!--ASSERT -->

        <axsl:choose>
            <axsl:when test="normalize-space(text()) = 'false'"/>
            <axsl:otherwise>
                <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                    test="normalize-space(text()) = 'false'">
                    <axsl:attribute name="id">PEPPOL-T01-B26401</axsl:attribute>
                    <axsl:attribute name="flag">fatal</axsl:attribute>
                    <axsl:attribute name="location">
                        <axsl:apply-templates select="." mode="schematron-select-full-path"/>
                    </axsl:attribute>
                    <svrl:text>Element 'cbc:ChargeIndicator' MUST contain value 'false'.</svrl:text>
                </svrl:failed-assert>
            </axsl:otherwise>
        </axsl:choose>
        <axsl:apply-templates select="@*|*" mode="M12"/>
    </axsl:template>

    <!--RULE -->

    <axsl:template match="/ubl:Order/cac:OrderLine/cac:LineItem/cac:Price/cac:AllowanceCharge/cbc:Amount"
                   priority="1045" mode="M12">
        <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                         context="/ubl:Order/cac:OrderLine/cac:LineItem/cac:Price/cac:AllowanceCharge/cbc:Amount"/>

        <!--ASSERT -->

        <axsl:choose>
            <axsl:when test="@currencyID"/>
            <axsl:otherwise>
                <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="@currencyID">
                    <axsl:attribute name="id">PEPPOL-T01-B26501</axsl:attribute>
                    <axsl:attribute name="flag">fatal</axsl:attribute>
                    <axsl:attribute name="location">
                        <axsl:apply-templates select="." mode="schematron-select-full-path"/>
                    </axsl:attribute>
                    <svrl:text>Attribute 'currencyID' MUST be present.</svrl:text>
                </svrl:failed-assert>
            </axsl:otherwise>
        </axsl:choose>

        <!--ASSERT -->

        <axsl:choose>
            <axsl:when test="not(@currencyID) or (some $code in $clISO4217 satisfies $code = @currencyID)"/>
            <axsl:otherwise>
                <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                    test="not(@currencyID) or (some $code in $clISO4217 satisfies $code = @currencyID)">
                    <axsl:attribute name="id">PEPPOL-T01-B26502</axsl:attribute>
                    <axsl:attribute name="flag">fatal</axsl:attribute>
                    <axsl:attribute name="location">
                        <axsl:apply-templates select="." mode="schematron-select-full-path"/>
                    </axsl:attribute>
                    <svrl:text>Value MUST be part of code list 'Currency codes (ISO 4217)'.</svrl:text>
                </svrl:failed-assert>
            </axsl:otherwise>
        </axsl:choose>
        <axsl:apply-templates select="@*|*" mode="M12"/>
    </axsl:template>

    <!--RULE -->

    <axsl:template match="/ubl:Order/cac:OrderLine/cac:LineItem/cac:Price/cac:AllowanceCharge/cbc:BaseAmount"
                   priority="1044" mode="M12">
        <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                         context="/ubl:Order/cac:OrderLine/cac:LineItem/cac:Price/cac:AllowanceCharge/cbc:BaseAmount"/>

        <!--ASSERT -->

        <axsl:choose>
            <axsl:when test="@currencyID"/>
            <axsl:otherwise>
                <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="@currencyID">
                    <axsl:attribute name="id">PEPPOL-T01-B26701</axsl:attribute>
                    <axsl:attribute name="flag">fatal</axsl:attribute>
                    <axsl:attribute name="location">
                        <axsl:apply-templates select="." mode="schematron-select-full-path"/>
                    </axsl:attribute>
                    <svrl:text>Attribute 'currencyID' MUST be present.</svrl:text>
                </svrl:failed-assert>
            </axsl:otherwise>
        </axsl:choose>

        <!--ASSERT -->

        <axsl:choose>
            <axsl:when test="not(@currencyID) or (some $code in $clISO4217 satisfies $code = @currencyID)"/>
            <axsl:otherwise>
                <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                    test="not(@currencyID) or (some $code in $clISO4217 satisfies $code = @currencyID)">
                    <axsl:attribute name="id">PEPPOL-T01-B26702</axsl:attribute>
                    <axsl:attribute name="flag">fatal</axsl:attribute>
                    <axsl:attribute name="location">
                        <axsl:apply-templates select="." mode="schematron-select-full-path"/>
                    </axsl:attribute>
                    <svrl:text>Value MUST be part of code list 'Currency codes (ISO 4217)'.</svrl:text>
                </svrl:failed-assert>
            </axsl:otherwise>
        </axsl:choose>
        <axsl:apply-templates select="@*|*" mode="M12"/>
    </axsl:template>

    <!--RULE -->

    <axsl:template match="/ubl:Order/cac:OrderLine/cac:LineItem/cac:Price/cac:AllowanceCharge/*" priority="1043"
                   mode="M12">
        <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                         context="/ubl:Order/cac:OrderLine/cac:LineItem/cac:Price/cac:AllowanceCharge/*"/>

        <!--ASSERT -->

        <axsl:choose>
            <axsl:when test="false()"/>
            <axsl:otherwise>
                <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="false()">
                    <axsl:attribute name="id">PEPPOL-T01-B26303</axsl:attribute>
                    <axsl:attribute name="flag">fatal</axsl:attribute>
                    <axsl:attribute name="location">
                        <axsl:apply-templates select="." mode="schematron-select-full-path"/>
                    </axsl:attribute>
                    <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
                </svrl:failed-assert>
            </axsl:otherwise>
        </axsl:choose>
        <axsl:apply-templates select="@*|*" mode="M12"/>
    </axsl:template>

    <!--RULE -->

    <axsl:template match="/ubl:Order/cac:OrderLine/cac:LineItem/cac:Price/*" priority="1042" mode="M12">
        <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                         context="/ubl:Order/cac:OrderLine/cac:LineItem/cac:Price/*"/>

        <!--ASSERT -->

        <axsl:choose>
            <axsl:when test="false()"/>
            <axsl:otherwise>
                <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="false()">
                    <axsl:attribute name="id">PEPPOL-T01-B25802</axsl:attribute>
                    <axsl:attribute name="flag">fatal</axsl:attribute>
                    <axsl:attribute name="location">
                        <axsl:apply-templates select="." mode="schematron-select-full-path"/>
                    </axsl:attribute>
                    <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
                </svrl:failed-assert>
            </axsl:otherwise>
        </axsl:choose>
        <axsl:apply-templates select="@*|*" mode="M12"/>
    </axsl:template>

    <!--RULE -->

    <axsl:template match="/ubl:Order/cac:OrderLine/cac:LineItem/cac:Item" priority="1041" mode="M12">
        <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                         context="/ubl:Order/cac:OrderLine/cac:LineItem/cac:Item"/>

        <!--ASSERT -->

        <axsl:choose>
            <axsl:when test="cbc:Name"/>
            <axsl:otherwise>
                <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="cbc:Name">
                    <axsl:attribute name="id">PEPPOL-T01-B26901</axsl:attribute>
                    <axsl:attribute name="flag">fatal</axsl:attribute>
                    <axsl:attribute name="location">
                        <axsl:apply-templates select="." mode="schematron-select-full-path"/>
                    </axsl:attribute>
                    <svrl:text>Element 'cbc:Name' MUST be provided.</svrl:text>
                </svrl:failed-assert>
            </axsl:otherwise>
        </axsl:choose>
        <axsl:apply-templates select="@*|*" mode="M12"/>
    </axsl:template>

    <!--RULE -->

    <axsl:template match="/ubl:Order/cac:OrderLine/cac:LineItem/cac:Item/cbc:Description" priority="1040" mode="M12">
        <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                         context="/ubl:Order/cac:OrderLine/cac:LineItem/cac:Item/cbc:Description"/>
        <axsl:apply-templates select="@*|*" mode="M12"/>
    </axsl:template>

    <!--RULE -->

    <axsl:template match="/ubl:Order/cac:OrderLine/cac:LineItem/cac:Item/cbc:Name" priority="1039" mode="M12">
        <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                         context="/ubl:Order/cac:OrderLine/cac:LineItem/cac:Item/cbc:Name"/>
        <axsl:apply-templates select="@*|*" mode="M12"/>
    </axsl:template>

    <!--RULE -->

    <axsl:template match="/ubl:Order/cac:OrderLine/cac:LineItem/cac:Item/cac:BuyersItemIdentification" priority="1038"
                   mode="M12">
        <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                         context="/ubl:Order/cac:OrderLine/cac:LineItem/cac:Item/cac:BuyersItemIdentification"/>

        <!--ASSERT -->

        <axsl:choose>
            <axsl:when test="cbc:ID"/>
            <axsl:otherwise>
                <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="cbc:ID">
                    <axsl:attribute name="id">PEPPOL-T01-B27201</axsl:attribute>
                    <axsl:attribute name="flag">fatal</axsl:attribute>
                    <axsl:attribute name="location">
                        <axsl:apply-templates select="." mode="schematron-select-full-path"/>
                    </axsl:attribute>
                    <svrl:text>Element 'cbc:ID' MUST be provided.</svrl:text>
                </svrl:failed-assert>
            </axsl:otherwise>
        </axsl:choose>
        <axsl:apply-templates select="@*|*" mode="M12"/>
    </axsl:template>

    <!--RULE -->

    <axsl:template match="/ubl:Order/cac:OrderLine/cac:LineItem/cac:Item/cac:BuyersItemIdentification/cbc:ID"
                   priority="1037" mode="M12">
        <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                         context="/ubl:Order/cac:OrderLine/cac:LineItem/cac:Item/cac:BuyersItemIdentification/cbc:ID"/>
        <axsl:apply-templates select="@*|*" mode="M12"/>
    </axsl:template>

    <!--RULE -->

    <axsl:template match="/ubl:Order/cac:OrderLine/cac:LineItem/cac:Item/cac:BuyersItemIdentification/*" priority="1036"
                   mode="M12">
        <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                         context="/ubl:Order/cac:OrderLine/cac:LineItem/cac:Item/cac:BuyersItemIdentification/*"/>

        <!--ASSERT -->

        <axsl:choose>
            <axsl:when test="false()"/>
            <axsl:otherwise>
                <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="false()">
                    <axsl:attribute name="id">PEPPOL-T01-B27202</axsl:attribute>
                    <axsl:attribute name="flag">fatal</axsl:attribute>
                    <axsl:attribute name="location">
                        <axsl:apply-templates select="." mode="schematron-select-full-path"/>
                    </axsl:attribute>
                    <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
                </svrl:failed-assert>
            </axsl:otherwise>
        </axsl:choose>
        <axsl:apply-templates select="@*|*" mode="M12"/>
    </axsl:template>

    <!--RULE -->

    <axsl:template match="/ubl:Order/cac:OrderLine/cac:LineItem/cac:Item/cac:SellersItemIdentification" priority="1035"
                   mode="M12">
        <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                         context="/ubl:Order/cac:OrderLine/cac:LineItem/cac:Item/cac:SellersItemIdentification"/>

        <!--ASSERT -->

        <axsl:choose>
            <axsl:when test="cbc:ID"/>
            <axsl:otherwise>
                <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="cbc:ID">
                    <axsl:attribute name="id">PEPPOL-T01-B27401</axsl:attribute>
                    <axsl:attribute name="flag">fatal</axsl:attribute>
                    <axsl:attribute name="location">
                        <axsl:apply-templates select="." mode="schematron-select-full-path"/>
                    </axsl:attribute>
                    <svrl:text>Element 'cbc:ID' MUST be provided.</svrl:text>
                </svrl:failed-assert>
            </axsl:otherwise>
        </axsl:choose>
        <axsl:apply-templates select="@*|*" mode="M12"/>
    </axsl:template>

    <!--RULE -->

    <axsl:template match="/ubl:Order/cac:OrderLine/cac:LineItem/cac:Item/cac:SellersItemIdentification/cbc:ID"
                   priority="1034" mode="M12">
        <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                         context="/ubl:Order/cac:OrderLine/cac:LineItem/cac:Item/cac:SellersItemIdentification/cbc:ID"/>
        <axsl:apply-templates select="@*|*" mode="M12"/>
    </axsl:template>

    <!--RULE -->

    <axsl:template match="/ubl:Order/cac:OrderLine/cac:LineItem/cac:Item/cac:SellersItemIdentification/*"
                   priority="1033" mode="M12">
        <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                         context="/ubl:Order/cac:OrderLine/cac:LineItem/cac:Item/cac:SellersItemIdentification/*"/>

        <!--ASSERT -->

        <axsl:choose>
            <axsl:when test="false()"/>
            <axsl:otherwise>
                <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="false()">
                    <axsl:attribute name="id">PEPPOL-T01-B27402</axsl:attribute>
                    <axsl:attribute name="flag">fatal</axsl:attribute>
                    <axsl:attribute name="location">
                        <axsl:apply-templates select="." mode="schematron-select-full-path"/>
                    </axsl:attribute>
                    <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
                </svrl:failed-assert>
            </axsl:otherwise>
        </axsl:choose>
        <axsl:apply-templates select="@*|*" mode="M12"/>
    </axsl:template>

    <!--RULE -->

    <axsl:template match="/ubl:Order/cac:OrderLine/cac:LineItem/cac:Item/cac:StandardItemIdentification" priority="1032"
                   mode="M12">
        <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                         context="/ubl:Order/cac:OrderLine/cac:LineItem/cac:Item/cac:StandardItemIdentification"/>

        <!--ASSERT -->

        <axsl:choose>
            <axsl:when test="cbc:ID"/>
            <axsl:otherwise>
                <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="cbc:ID">
                    <axsl:attribute name="id">PEPPOL-T01-B27601</axsl:attribute>
                    <axsl:attribute name="flag">fatal</axsl:attribute>
                    <axsl:attribute name="location">
                        <axsl:apply-templates select="." mode="schematron-select-full-path"/>
                    </axsl:attribute>
                    <svrl:text>Element 'cbc:ID' MUST be provided.</svrl:text>
                </svrl:failed-assert>
            </axsl:otherwise>
        </axsl:choose>
        <axsl:apply-templates select="@*|*" mode="M12"/>
    </axsl:template>

    <!--RULE -->

    <axsl:template match="/ubl:Order/cac:OrderLine/cac:LineItem/cac:Item/cac:StandardItemIdentification/cbc:ID"
                   priority="1031" mode="M12">
        <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                         context="/ubl:Order/cac:OrderLine/cac:LineItem/cac:Item/cac:StandardItemIdentification/cbc:ID"/>

        <!--ASSERT -->

        <axsl:choose>
            <axsl:when test="@schemeID"/>
            <axsl:otherwise>
                <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="@schemeID">
                    <axsl:attribute name="id">PEPPOL-T01-B27701</axsl:attribute>
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
                <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                    test="not(@schemeID) or (some $code in $clICD satisfies $code = @schemeID)">
                    <axsl:attribute name="id">PEPPOL-T01-B27702</axsl:attribute>
                    <axsl:attribute name="flag">fatal</axsl:attribute>
                    <axsl:attribute name="location">
                        <axsl:apply-templates select="." mode="schematron-select-full-path"/>
                    </axsl:attribute>
                    <svrl:text>Value MUST be part of code list 'ISO 6523 ICD list'.</svrl:text>
                </svrl:failed-assert>
            </axsl:otherwise>
        </axsl:choose>
        <axsl:apply-templates select="@*|*" mode="M12"/>
    </axsl:template>

    <!--RULE -->

    <axsl:template match="/ubl:Order/cac:OrderLine/cac:LineItem/cac:Item/cac:StandardItemIdentification/*"
                   priority="1030" mode="M12">
        <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                         context="/ubl:Order/cac:OrderLine/cac:LineItem/cac:Item/cac:StandardItemIdentification/*"/>

        <!--ASSERT -->

        <axsl:choose>
            <axsl:when test="false()"/>
            <axsl:otherwise>
                <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="false()">
                    <axsl:attribute name="id">PEPPOL-T01-B27602</axsl:attribute>
                    <axsl:attribute name="flag">fatal</axsl:attribute>
                    <axsl:attribute name="location">
                        <axsl:apply-templates select="." mode="schematron-select-full-path"/>
                    </axsl:attribute>
                    <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
                </svrl:failed-assert>
            </axsl:otherwise>
        </axsl:choose>
        <axsl:apply-templates select="@*|*" mode="M12"/>
    </axsl:template>

    <!--RULE -->

    <axsl:template match="/ubl:Order/cac:OrderLine/cac:LineItem/cac:Item/cac:ItemSpecificationDocumentReference"
                   priority="1029" mode="M12">
        <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                         context="/ubl:Order/cac:OrderLine/cac:LineItem/cac:Item/cac:ItemSpecificationDocumentReference"/>

        <!--ASSERT -->

        <axsl:choose>
            <axsl:when test="cbc:ID"/>
            <axsl:otherwise>
                <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="cbc:ID">
                    <axsl:attribute name="id">PEPPOL-T01-B27901</axsl:attribute>
                    <axsl:attribute name="flag">fatal</axsl:attribute>
                    <axsl:attribute name="location">
                        <axsl:apply-templates select="." mode="schematron-select-full-path"/>
                    </axsl:attribute>
                    <svrl:text>Element 'cbc:ID' MUST be provided.</svrl:text>
                </svrl:failed-assert>
            </axsl:otherwise>
        </axsl:choose>
        <axsl:apply-templates select="@*|*" mode="M12"/>
    </axsl:template>

    <!--RULE -->

    <axsl:template match="/ubl:Order/cac:OrderLine/cac:LineItem/cac:Item/cac:ItemSpecificationDocumentReference/cbc:ID"
                   priority="1028" mode="M12">
        <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                         context="/ubl:Order/cac:OrderLine/cac:LineItem/cac:Item/cac:ItemSpecificationDocumentReference/cbc:ID"/>
        <axsl:apply-templates select="@*|*" mode="M12"/>
    </axsl:template>

    <!--RULE -->

    <axsl:template match="/ubl:Order/cac:OrderLine/cac:LineItem/cac:Item/cac:ItemSpecificationDocumentReference/*"
                   priority="1027" mode="M12">
        <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                         context="/ubl:Order/cac:OrderLine/cac:LineItem/cac:Item/cac:ItemSpecificationDocumentReference/*"/>

        <!--ASSERT -->

        <axsl:choose>
            <axsl:when test="false()"/>
            <axsl:otherwise>
                <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="false()">
                    <axsl:attribute name="id">PEPPOL-T01-B27902</axsl:attribute>
                    <axsl:attribute name="flag">fatal</axsl:attribute>
                    <axsl:attribute name="location">
                        <axsl:apply-templates select="." mode="schematron-select-full-path"/>
                    </axsl:attribute>
                    <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
                </svrl:failed-assert>
            </axsl:otherwise>
        </axsl:choose>
        <axsl:apply-templates select="@*|*" mode="M12"/>
    </axsl:template>

    <!--RULE -->

    <axsl:template match="/ubl:Order/cac:OrderLine/cac:LineItem/cac:Item/cac:CommodityClassification" priority="1026"
                   mode="M12">
        <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                         context="/ubl:Order/cac:OrderLine/cac:LineItem/cac:Item/cac:CommodityClassification"/>
        <axsl:apply-templates select="@*|*" mode="M12"/>
    </axsl:template>

    <!--RULE -->

    <axsl:template
            match="/ubl:Order/cac:OrderLine/cac:LineItem/cac:Item/cac:CommodityClassification/cbc:ItemClassificationCode"
            priority="1025" mode="M12">
        <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                         context="/ubl:Order/cac:OrderLine/cac:LineItem/cac:Item/cac:CommodityClassification/cbc:ItemClassificationCode"/>

        <!--ASSERT -->

        <axsl:choose>
            <axsl:when test="@listID"/>
            <axsl:otherwise>
                <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="@listID">
                    <axsl:attribute name="id">PEPPOL-T01-B28201</axsl:attribute>
                    <axsl:attribute name="flag">fatal</axsl:attribute>
                    <axsl:attribute name="location">
                        <axsl:apply-templates select="." mode="schematron-select-full-path"/>
                    </axsl:attribute>
                    <svrl:text>Attribute 'listID' MUST be present.</svrl:text>
                </svrl:failed-assert>
            </axsl:otherwise>
        </axsl:choose>

        <!--ASSERT -->

        <axsl:choose>
            <axsl:when test="not(@listID) or (some $code in $clUNCL7143 satisfies $code = @listID)"/>
            <axsl:otherwise>
                <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                    test="not(@listID) or (some $code in $clUNCL7143 satisfies $code = @listID)">
                    <axsl:attribute name="id">PEPPOL-T01-B28202</axsl:attribute>
                    <axsl:attribute name="flag">fatal</axsl:attribute>
                    <axsl:attribute name="location">
                        <axsl:apply-templates select="." mode="schematron-select-full-path"/>
                    </axsl:attribute>
                    <svrl:text>Value MUST be part of code list 'Item type identification code (UNCL7143)'.</svrl:text>
                </svrl:failed-assert>
            </axsl:otherwise>
        </axsl:choose>
        <axsl:apply-templates select="@*|*" mode="M12"/>
    </axsl:template>

    <!--RULE -->

    <axsl:template match="/ubl:Order/cac:OrderLine/cac:LineItem/cac:Item/cac:CommodityClassification/*" priority="1024"
                   mode="M12">
        <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                         context="/ubl:Order/cac:OrderLine/cac:LineItem/cac:Item/cac:CommodityClassification/*"/>

        <!--ASSERT -->

        <axsl:choose>
            <axsl:when test="false()"/>
            <axsl:otherwise>
                <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="false()">
                    <axsl:attribute name="id">PEPPOL-T01-B28101</axsl:attribute>
                    <axsl:attribute name="flag">fatal</axsl:attribute>
                    <axsl:attribute name="location">
                        <axsl:apply-templates select="." mode="schematron-select-full-path"/>
                    </axsl:attribute>
                    <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
                </svrl:failed-assert>
            </axsl:otherwise>
        </axsl:choose>
        <axsl:apply-templates select="@*|*" mode="M12"/>
    </axsl:template>

    <!--RULE -->

    <axsl:template match="/ubl:Order/cac:OrderLine/cac:LineItem/cac:Item/cac:ClassifiedTaxCategory" priority="1023"
                   mode="M12">
        <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                         context="/ubl:Order/cac:OrderLine/cac:LineItem/cac:Item/cac:ClassifiedTaxCategory"/>

        <!--ASSERT -->

        <axsl:choose>
            <axsl:when test="cbc:ID"/>
            <axsl:otherwise>
                <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="cbc:ID">
                    <axsl:attribute name="id">PEPPOL-T01-B28601</axsl:attribute>
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
            <axsl:when test="cac:TaxScheme"/>
            <axsl:otherwise>
                <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="cac:TaxScheme">
                    <axsl:attribute name="id">PEPPOL-T01-B28602</axsl:attribute>
                    <axsl:attribute name="flag">fatal</axsl:attribute>
                    <axsl:attribute name="location">
                        <axsl:apply-templates select="." mode="schematron-select-full-path"/>
                    </axsl:attribute>
                    <svrl:text>Element 'cac:TaxScheme' MUST be provided.</svrl:text>
                </svrl:failed-assert>
            </axsl:otherwise>
        </axsl:choose>
        <axsl:apply-templates select="@*|*" mode="M12"/>
    </axsl:template>

    <!--RULE -->

    <axsl:template match="/ubl:Order/cac:OrderLine/cac:LineItem/cac:Item/cac:ClassifiedTaxCategory/cbc:ID"
                   priority="1022" mode="M12">
        <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                         context="/ubl:Order/cac:OrderLine/cac:LineItem/cac:Item/cac:ClassifiedTaxCategory/cbc:ID"/>

        <!--ASSERT -->

        <axsl:choose>
            <axsl:when test="(some $code in $clUNCL5305 satisfies $code = normalize-space(text()))"/>
            <axsl:otherwise>
                <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                    test="(some $code in $clUNCL5305 satisfies $code = normalize-space(text()))">
                    <axsl:attribute name="id">PEPPOL-T01-B28701</axsl:attribute>
                    <axsl:attribute name="flag">fatal</axsl:attribute>
                    <axsl:attribute name="location">
                        <axsl:apply-templates select="." mode="schematron-select-full-path"/>
                    </axsl:attribute>
                    <svrl:text>Value MUST be part of code list 'Duty or tax or fee category code (UNCL5305)'.
                    </svrl:text>
                </svrl:failed-assert>
            </axsl:otherwise>
        </axsl:choose>
        <axsl:apply-templates select="@*|*" mode="M12"/>
    </axsl:template>

    <!--RULE -->

    <axsl:template match="/ubl:Order/cac:OrderLine/cac:LineItem/cac:Item/cac:ClassifiedTaxCategory/cbc:Percent"
                   priority="1021" mode="M12">
        <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                         context="/ubl:Order/cac:OrderLine/cac:LineItem/cac:Item/cac:ClassifiedTaxCategory/cbc:Percent"/>
        <axsl:apply-templates select="@*|*" mode="M12"/>
    </axsl:template>

    <!--RULE -->

    <axsl:template match="/ubl:Order/cac:OrderLine/cac:LineItem/cac:Item/cac:ClassifiedTaxCategory/cac:TaxScheme"
                   priority="1020" mode="M12">
        <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                         context="/ubl:Order/cac:OrderLine/cac:LineItem/cac:Item/cac:ClassifiedTaxCategory/cac:TaxScheme"/>

        <!--ASSERT -->

        <axsl:choose>
            <axsl:when test="cbc:ID"/>
            <axsl:otherwise>
                <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="cbc:ID">
                    <axsl:attribute name="id">PEPPOL-T01-B28901</axsl:attribute>
                    <axsl:attribute name="flag">fatal</axsl:attribute>
                    <axsl:attribute name="location">
                        <axsl:apply-templates select="." mode="schematron-select-full-path"/>
                    </axsl:attribute>
                    <svrl:text>Element 'cbc:ID' MUST be provided.</svrl:text>
                </svrl:failed-assert>
            </axsl:otherwise>
        </axsl:choose>
        <axsl:apply-templates select="@*|*" mode="M12"/>
    </axsl:template>

    <!--RULE -->

    <axsl:template match="/ubl:Order/cac:OrderLine/cac:LineItem/cac:Item/cac:ClassifiedTaxCategory/cac:TaxScheme/cbc:ID"
                   priority="1019" mode="M12">
        <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                         context="/ubl:Order/cac:OrderLine/cac:LineItem/cac:Item/cac:ClassifiedTaxCategory/cac:TaxScheme/cbc:ID"/>
        <axsl:apply-templates select="@*|*" mode="M12"/>
    </axsl:template>

    <!--RULE -->

    <axsl:template match="/ubl:Order/cac:OrderLine/cac:LineItem/cac:Item/cac:ClassifiedTaxCategory/cac:TaxScheme/*"
                   priority="1018" mode="M12">
        <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                         context="/ubl:Order/cac:OrderLine/cac:LineItem/cac:Item/cac:ClassifiedTaxCategory/cac:TaxScheme/*"/>

        <!--ASSERT -->

        <axsl:choose>
            <axsl:when test="false()"/>
            <axsl:otherwise>
                <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="false()">
                    <axsl:attribute name="id">PEPPOL-T01-B28902</axsl:attribute>
                    <axsl:attribute name="flag">fatal</axsl:attribute>
                    <axsl:attribute name="location">
                        <axsl:apply-templates select="." mode="schematron-select-full-path"/>
                    </axsl:attribute>
                    <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
                </svrl:failed-assert>
            </axsl:otherwise>
        </axsl:choose>
        <axsl:apply-templates select="@*|*" mode="M12"/>
    </axsl:template>

    <!--RULE -->

    <axsl:template match="/ubl:Order/cac:OrderLine/cac:LineItem/cac:Item/cac:ClassifiedTaxCategory/*" priority="1017"
                   mode="M12">
        <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                         context="/ubl:Order/cac:OrderLine/cac:LineItem/cac:Item/cac:ClassifiedTaxCategory/*"/>

        <!--ASSERT -->

        <axsl:choose>
            <axsl:when test="false()"/>
            <axsl:otherwise>
                <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="false()">
                    <axsl:attribute name="id">PEPPOL-T01-B28603</axsl:attribute>
                    <axsl:attribute name="flag">fatal</axsl:attribute>
                    <axsl:attribute name="location">
                        <axsl:apply-templates select="." mode="schematron-select-full-path"/>
                    </axsl:attribute>
                    <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
                </svrl:failed-assert>
            </axsl:otherwise>
        </axsl:choose>
        <axsl:apply-templates select="@*|*" mode="M12"/>
    </axsl:template>

    <!--RULE -->

    <axsl:template match="/ubl:Order/cac:OrderLine/cac:LineItem/cac:Item/cac:AdditionalItemProperty" priority="1016"
                   mode="M12">
        <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                         context="/ubl:Order/cac:OrderLine/cac:LineItem/cac:Item/cac:AdditionalItemProperty"/>

        <!--ASSERT -->

        <axsl:choose>
            <axsl:when test="cbc:Name"/>
            <axsl:otherwise>
                <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="cbc:Name">
                    <axsl:attribute name="id">PEPPOL-T01-B29101</axsl:attribute>
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
                    <axsl:attribute name="id">PEPPOL-T01-B29102</axsl:attribute>
                    <axsl:attribute name="flag">fatal</axsl:attribute>
                    <axsl:attribute name="location">
                        <axsl:apply-templates select="." mode="schematron-select-full-path"/>
                    </axsl:attribute>
                    <svrl:text>Element 'cbc:Value' MUST be provided.</svrl:text>
                </svrl:failed-assert>
            </axsl:otherwise>
        </axsl:choose>
        <axsl:apply-templates select="@*|*" mode="M12"/>
    </axsl:template>

    <!--RULE -->

    <axsl:template match="/ubl:Order/cac:OrderLine/cac:LineItem/cac:Item/cac:AdditionalItemProperty/cbc:Name"
                   priority="1015" mode="M12">
        <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                         context="/ubl:Order/cac:OrderLine/cac:LineItem/cac:Item/cac:AdditionalItemProperty/cbc:Name"/>
        <axsl:apply-templates select="@*|*" mode="M12"/>
    </axsl:template>

    <!--RULE -->

    <axsl:template match="/ubl:Order/cac:OrderLine/cac:LineItem/cac:Item/cac:AdditionalItemProperty/cbc:NameCode"
                   priority="1014" mode="M12">
        <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                         context="/ubl:Order/cac:OrderLine/cac:LineItem/cac:Item/cac:AdditionalItemProperty/cbc:NameCode"/>

        <!--ASSERT -->

        <axsl:choose>
            <axsl:when test="@listID"/>
            <axsl:otherwise>
                <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="@listID">
                    <axsl:attribute name="id">PEPPOL-T01-B29301</axsl:attribute>
                    <axsl:attribute name="flag">fatal</axsl:attribute>
                    <axsl:attribute name="location">
                        <axsl:apply-templates select="." mode="schematron-select-full-path"/>
                    </axsl:attribute>
                    <svrl:text>Attribute 'listID' MUST be present.</svrl:text>
                </svrl:failed-assert>
            </axsl:otherwise>
        </axsl:choose>
        <axsl:apply-templates select="@*|*" mode="M12"/>
    </axsl:template>

    <!--RULE -->

    <axsl:template match="/ubl:Order/cac:OrderLine/cac:LineItem/cac:Item/cac:AdditionalItemProperty/cbc:Value"
                   priority="1013" mode="M12">
        <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                         context="/ubl:Order/cac:OrderLine/cac:LineItem/cac:Item/cac:AdditionalItemProperty/cbc:Value"/>
        <axsl:apply-templates select="@*|*" mode="M12"/>
    </axsl:template>

    <!--RULE -->

    <axsl:template match="/ubl:Order/cac:OrderLine/cac:LineItem/cac:Item/cac:AdditionalItemProperty/cbc:ValueQuantity"
                   priority="1012" mode="M12">
        <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                         context="/ubl:Order/cac:OrderLine/cac:LineItem/cac:Item/cac:AdditionalItemProperty/cbc:ValueQuantity"/>

        <!--ASSERT -->

        <axsl:choose>
            <axsl:when test="@unitCode"/>
            <axsl:otherwise>
                <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="@unitCode">
                    <axsl:attribute name="id">PEPPOL-T01-B29601</axsl:attribute>
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
                <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                    test="not(@unitCode) or (some $code in $clUNECERec20 satisfies $code = @unitCode)">
                    <axsl:attribute name="id">PEPPOL-T01-B29602</axsl:attribute>
                    <axsl:attribute name="flag">fatal</axsl:attribute>
                    <axsl:attribute name="location">
                        <axsl:apply-templates select="." mode="schematron-select-full-path"/>
                    </axsl:attribute>
                    <svrl:text>Value MUST be part of code list 'Recommandation 20, including Recommondation 21 codes -
                        prefixed with X (UN/ECE)'.
                    </svrl:text>
                </svrl:failed-assert>
            </axsl:otherwise>
        </axsl:choose>
        <axsl:apply-templates select="@*|*" mode="M12"/>
    </axsl:template>

    <!--RULE -->

    <axsl:template match="/ubl:Order/cac:OrderLine/cac:LineItem/cac:Item/cac:AdditionalItemProperty/cbc:ValueQualifier"
                   priority="1011" mode="M12">
        <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                         context="/ubl:Order/cac:OrderLine/cac:LineItem/cac:Item/cac:AdditionalItemProperty/cbc:ValueQualifier"/>
        <axsl:apply-templates select="@*|*" mode="M12"/>
    </axsl:template>

    <!--RULE -->

    <axsl:template match="/ubl:Order/cac:OrderLine/cac:LineItem/cac:Item/cac:AdditionalItemProperty/*" priority="1010"
                   mode="M12">
        <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                         context="/ubl:Order/cac:OrderLine/cac:LineItem/cac:Item/cac:AdditionalItemProperty/*"/>

        <!--ASSERT -->

        <axsl:choose>
            <axsl:when test="false()"/>
            <axsl:otherwise>
                <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="false()">
                    <axsl:attribute name="id">PEPPOL-T01-B29103</axsl:attribute>
                    <axsl:attribute name="flag">fatal</axsl:attribute>
                    <axsl:attribute name="location">
                        <axsl:apply-templates select="." mode="schematron-select-full-path"/>
                    </axsl:attribute>
                    <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
                </svrl:failed-assert>
            </axsl:otherwise>
        </axsl:choose>
        <axsl:apply-templates select="@*|*" mode="M12"/>
    </axsl:template>

    <!--RULE -->

    <axsl:template match="/ubl:Order/cac:OrderLine/cac:LineItem/cac:Item/cac:ItemInstance" priority="1009" mode="M12">
        <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                         context="/ubl:Order/cac:OrderLine/cac:LineItem/cac:Item/cac:ItemInstance"/>
        <axsl:apply-templates select="@*|*" mode="M12"/>
    </axsl:template>

    <!--RULE -->

    <axsl:template match="/ubl:Order/cac:OrderLine/cac:LineItem/cac:Item/cac:ItemInstance/cbc:SerialID" priority="1008"
                   mode="M12">
        <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                         context="/ubl:Order/cac:OrderLine/cac:LineItem/cac:Item/cac:ItemInstance/cbc:SerialID"/>
        <axsl:apply-templates select="@*|*" mode="M12"/>
    </axsl:template>

    <!--RULE -->

    <axsl:template match="/ubl:Order/cac:OrderLine/cac:LineItem/cac:Item/cac:ItemInstance/cac:LotIdentification"
                   priority="1007" mode="M12">
        <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                         context="/ubl:Order/cac:OrderLine/cac:LineItem/cac:Item/cac:ItemInstance/cac:LotIdentification"/>
        <axsl:apply-templates select="@*|*" mode="M12"/>
    </axsl:template>

    <!--RULE -->

    <axsl:template
            match="/ubl:Order/cac:OrderLine/cac:LineItem/cac:Item/cac:ItemInstance/cac:LotIdentification/cbc:LotNumberID"
            priority="1006" mode="M12">
        <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                         context="/ubl:Order/cac:OrderLine/cac:LineItem/cac:Item/cac:ItemInstance/cac:LotIdentification/cbc:LotNumberID"/>
        <axsl:apply-templates select="@*|*" mode="M12"/>
    </axsl:template>

    <!--RULE -->

    <axsl:template match="/ubl:Order/cac:OrderLine/cac:LineItem/cac:Item/cac:ItemInstance/cac:LotIdentification/*"
                   priority="1005" mode="M12">
        <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                         context="/ubl:Order/cac:OrderLine/cac:LineItem/cac:Item/cac:ItemInstance/cac:LotIdentification/*"/>

        <!--ASSERT -->

        <axsl:choose>
            <axsl:when test="false()"/>
            <axsl:otherwise>
                <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="false()">
                    <axsl:attribute name="id">PEPPOL-T01-B30101</axsl:attribute>
                    <axsl:attribute name="flag">fatal</axsl:attribute>
                    <axsl:attribute name="location">
                        <axsl:apply-templates select="." mode="schematron-select-full-path"/>
                    </axsl:attribute>
                    <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
                </svrl:failed-assert>
            </axsl:otherwise>
        </axsl:choose>
        <axsl:apply-templates select="@*|*" mode="M12"/>
    </axsl:template>

    <!--RULE -->

    <axsl:template match="/ubl:Order/cac:OrderLine/cac:LineItem/cac:Item/cac:ItemInstance/*" priority="1004" mode="M12">
        <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                         context="/ubl:Order/cac:OrderLine/cac:LineItem/cac:Item/cac:ItemInstance/*"/>

        <!--ASSERT -->

        <axsl:choose>
            <axsl:when test="false()"/>
            <axsl:otherwise>
                <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="false()">
                    <axsl:attribute name="id">PEPPOL-T01-B29901</axsl:attribute>
                    <axsl:attribute name="flag">fatal</axsl:attribute>
                    <axsl:attribute name="location">
                        <axsl:apply-templates select="." mode="schematron-select-full-path"/>
                    </axsl:attribute>
                    <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
                </svrl:failed-assert>
            </axsl:otherwise>
        </axsl:choose>
        <axsl:apply-templates select="@*|*" mode="M12"/>
    </axsl:template>

    <!--RULE -->

    <axsl:template match="/ubl:Order/cac:OrderLine/cac:LineItem/cac:Item/*" priority="1003" mode="M12">
        <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                         context="/ubl:Order/cac:OrderLine/cac:LineItem/cac:Item/*"/>

        <!--ASSERT -->

        <axsl:choose>
            <axsl:when test="false()"/>
            <axsl:otherwise>
                <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="false()">
                    <axsl:attribute name="id">PEPPOL-T01-B26902</axsl:attribute>
                    <axsl:attribute name="flag">fatal</axsl:attribute>
                    <axsl:attribute name="location">
                        <axsl:apply-templates select="." mode="schematron-select-full-path"/>
                    </axsl:attribute>
                    <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
                </svrl:failed-assert>
            </axsl:otherwise>
        </axsl:choose>
        <axsl:apply-templates select="@*|*" mode="M12"/>
    </axsl:template>

    <!--RULE -->

    <axsl:template match="/ubl:Order/cac:OrderLine/cac:LineItem/*" priority="1002" mode="M12">
        <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="/ubl:Order/cac:OrderLine/cac:LineItem/*"/>

        <!--ASSERT -->

        <axsl:choose>
            <axsl:when test="false()"/>
            <axsl:otherwise>
                <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="false()">
                    <axsl:attribute name="id">PEPPOL-T01-B22904</axsl:attribute>
                    <axsl:attribute name="flag">fatal</axsl:attribute>
                    <axsl:attribute name="location">
                        <axsl:apply-templates select="." mode="schematron-select-full-path"/>
                    </axsl:attribute>
                    <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
                </svrl:failed-assert>
            </axsl:otherwise>
        </axsl:choose>
        <axsl:apply-templates select="@*|*" mode="M12"/>
    </axsl:template>

    <!--RULE -->

    <axsl:template match="/ubl:Order/cac:OrderLine/*" priority="1001" mode="M12">
        <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="/ubl:Order/cac:OrderLine/*"/>

        <!--ASSERT -->

        <axsl:choose>
            <axsl:when test="false()"/>
            <axsl:otherwise>
                <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="false()">
                    <axsl:attribute name="id">PEPPOL-T01-B22702</axsl:attribute>
                    <axsl:attribute name="flag">fatal</axsl:attribute>
                    <axsl:attribute name="location">
                        <axsl:apply-templates select="." mode="schematron-select-full-path"/>
                    </axsl:attribute>
                    <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
                </svrl:failed-assert>
            </axsl:otherwise>
        </axsl:choose>
        <axsl:apply-templates select="@*|*" mode="M12"/>
    </axsl:template>

    <!--RULE -->

    <axsl:template match="/ubl:Order/*" priority="1000" mode="M12">
        <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="/ubl:Order/*"/>

        <!--ASSERT -->

        <axsl:choose>
            <axsl:when test="false()"/>
            <axsl:otherwise>
                <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="false()">
                    <axsl:attribute name="id">PEPPOL-T01-B00110</axsl:attribute>
                    <axsl:attribute name="flag">fatal</axsl:attribute>
                    <axsl:attribute name="location">
                        <axsl:apply-templates select="." mode="schematron-select-full-path"/>
                    </axsl:attribute>
                    <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
                </svrl:failed-assert>
            </axsl:otherwise>
        </axsl:choose>
        <axsl:apply-templates select="@*|*" mode="M12"/>
    </axsl:template>
    <axsl:template match="text()" priority="-1" mode="M12"/>
    <axsl:template match="@*|node()" priority="-2" mode="M12">
        <axsl:apply-templates select="@*|*" mode="M12"/>
    </axsl:template>

    <!--PATTERN -->

    <axsl:variable name="documentCurrencyCode" select="/ubl:Order/cbc:DocumentCurrencyCode"/>
    <axsl:variable name="sumLineExtensionAmount"
                   select="if (/ubl:Order/cac:OrderLine/cac:LineItem/cbc:LineExtensionAmount) then round(sum(/ubl:Order/cac:OrderLine/cac:LineItem/cbc:LineExtensionAmount/xs:decimal(.)) * 10 * 10) div 100 else 0"/>
    <axsl:variable name="sumAllowance"
                   select="if (/ubl:Order/cac:AllowanceCharge[normalize-space(cbc:ChargeIndicator) = 'false']) then round(sum(/ubl:Order/cac:AllowanceCharge[normalize-space(cbc:ChargeIndicator) = 'false']/cbc:Amount/xs:decimal(.)) * 10 * 10) div 100 else 0"/>
    <axsl:variable name="sumCharge"
                   select="if (/ubl:Order/cac:AllowanceCharge[normalize-space(cbc:ChargeIndicator) = 'true']) then round(sum(/ubl:Order/cac:AllowanceCharge[normalize-space(cbc:ChargeIndicator) = 'true']/cbc:Amount/xs:decimal(.)) * 10 * 10) div 100 else 0"/>
    <axsl:variable name="TAXamount"
                   select="if(/ubl:Order/cac:TaxTotal/cbc:TaxAmount) then xs:decimal(/ubl:Order/cac:TaxTotal/cbc:TaxAmount) else 0"/>

    <!--RULE -->

    <axsl:template match="cbc:ProfileID" priority="1015" mode="M13">
        <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="cbc:ProfileID"/>

        <!--ASSERT -->

        <axsl:choose>
            <axsl:when
                    test="some $p in tokenize('urn:fdc:peppol.eu:poacc:bis:order_only:3 urn:fdc:peppol.eu:poacc:bis:ordering:3', '\s') satisfies $p = normalize-space(.)"/>
            <axsl:otherwise>
                <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                    test="some $p in tokenize('urn:fdc:peppol.eu:poacc:bis:order_only:3 urn:fdc:peppol.eu:poacc:bis:ordering:3', '\s') satisfies $p = normalize-space(.)">
                    <axsl:attribute name="id">PEPPOL-T01-R031</axsl:attribute>
                    <axsl:attribute name="flag">fatal</axsl:attribute>
                    <axsl:attribute name="location">
                        <axsl:apply-templates select="." mode="schematron-select-full-path"/>
                    </axsl:attribute>
                    <svrl:text>An order transaction SHALL use profile order only or ordering.</svrl:text>
                </svrl:failed-assert>
            </axsl:otherwise>
        </axsl:choose>
        <axsl:apply-templates select="@*|*" mode="M13"/>
    </axsl:template>

    <!--RULE -->

    <axsl:template match="cbc:CustomizationID" priority="1014" mode="M13">
        <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="cbc:CustomizationID"/>

        <!--ASSERT -->

        <axsl:choose>
            <axsl:when test="starts-with(normalize-space(.), 'urn:fdc:peppol.eu:poacc:trns:order:3')"/>
            <axsl:otherwise>
                <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                    test="starts-with(normalize-space(.), 'urn:fdc:peppol.eu:poacc:trns:order:3')">
                    <axsl:attribute name="id">PEPPOL-T01-R034</axsl:attribute>
                    <axsl:attribute name="flag">fatal</axsl:attribute>
                    <axsl:attribute name="location">
                        <axsl:apply-templates select="." mode="schematron-select-full-path"/>
                    </axsl:attribute>
                    <svrl:text>Specification identifier SHALL start with the value
                        'urn:fdc:peppol.eu:poacc:trns:order:3'.
                    </svrl:text>
                </svrl:failed-assert>
            </axsl:otherwise>
        </axsl:choose>
        <axsl:apply-templates select="@*|*" mode="M13"/>
    </axsl:template>

    <!--RULE -->

    <axsl:template
            match="cbc:Amount | cbc:TaxAmount | cbc:LineExtensionAmount | cbc:PriceAmount | cbc:BaseAmount | cac:AnticipatedMonetaryTotal/cbc:*"
            priority="1013" mode="M13">
        <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                         context="cbc:Amount | cbc:TaxAmount | cbc:LineExtensionAmount | cbc:PriceAmount | cbc:BaseAmount | cac:AnticipatedMonetaryTotal/cbc:*"/>

        <!--ASSERT -->

        <axsl:choose>
            <axsl:when test="not(@currencyID) or @currencyID = $documentCurrencyCode"/>
            <axsl:otherwise>
                <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                    test="not(@currencyID) or @currencyID = $documentCurrencyCode">
                    <axsl:attribute name="id">PEPPOL-T01-R003</axsl:attribute>
                    <axsl:attribute name="flag">fatal</axsl:attribute>
                    <axsl:attribute name="location">
                        <axsl:apply-templates select="." mode="schematron-select-full-path"/>
                    </axsl:attribute>
                    <svrl:text>An order SHALL be stated in a single currency</svrl:text>
                </svrl:failed-assert>
            </axsl:otherwise>
        </axsl:choose>

        <!--ASSERT -->

        <axsl:choose>
            <axsl:when
                    test="ancestor::node()/local-name() = 'Price' or string-length(substring-after(., '.')) &lt;= 2"/>
            <axsl:otherwise>
                <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                    test="ancestor::node()/local-name() = 'Price' or string-length(substring-after(., '.')) &lt;= 2">
                    <axsl:attribute name="id">PEPPOL-T01-R028</axsl:attribute>
                    <axsl:attribute name="flag">fatal</axsl:attribute>
                    <axsl:attribute name="location">
                        <axsl:apply-templates select="." mode="schematron-select-full-path"/>
                    </axsl:attribute>
                    <svrl:text>Elements of data type amount cannot have more than 2 decimals (I.e. all amounts except
                        unit price amounts)
                    </svrl:text>
                </svrl:failed-assert>
            </axsl:otherwise>
        </axsl:choose>
        <axsl:apply-templates select="@*|*" mode="M13"/>
    </axsl:template>

    <!--RULE -->

    <axsl:template match="ubl:Order" priority="1012" mode="M13">
        <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="ubl:Order"/>

        <!--ASSERT -->

        <axsl:choose>
            <axsl:when test="cac:ValidityPeriod/cbc:EndDate"/>
            <axsl:otherwise>
                <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="cac:ValidityPeriod/cbc:EndDate">
                    <axsl:attribute name="id">PEPPOL-T01-R002</axsl:attribute>
                    <axsl:attribute name="flag">warning</axsl:attribute>
                    <axsl:attribute name="location">
                        <axsl:apply-templates select="." mode="schematron-select-full-path"/>
                    </axsl:attribute>
                    <svrl:text>An order SHOULD provide information about its validity end date.</svrl:text>
                </svrl:failed-assert>
            </axsl:otherwise>
        </axsl:choose>
        <axsl:apply-templates select="@*|*" mode="M13"/>
    </axsl:template>

    <!--RULE -->

    <axsl:template match="cac:OriginatorCustomerParty" priority="1011" mode="M13">
        <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="cac:OriginatorCustomerParty"/>

        <!--ASSERT -->

        <axsl:choose>
            <axsl:when test="cac:Party/cac:PartyName/cbc:Name or cac:Party/cac:PartyIdentification/cbc:ID"/>
            <axsl:otherwise>
                <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                    test="cac:Party/cac:PartyName/cbc:Name or cac:Party/cac:PartyIdentification/cbc:ID">
                    <axsl:attribute name="id">PEPPOL-T01-R014</axsl:attribute>
                    <axsl:attribute name="flag">fatal</axsl:attribute>
                    <axsl:attribute name="location">
                        <axsl:apply-templates select="." mode="schematron-select-full-path"/>
                    </axsl:attribute>
                    <svrl:text>An order SHALL have the originator party name or an identifier</svrl:text>
                </svrl:failed-assert>
            </axsl:otherwise>
        </axsl:choose>
        <axsl:apply-templates select="@*|*" mode="M13"/>
    </axsl:template>

    <!--RULE -->

    <axsl:template match="cac:PartyTaxScheme[cac:TaxScheme/cbc:ID='VAT']" priority="1010" mode="M13">
        <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                         context="cac:PartyTaxScheme[cac:TaxScheme/cbc:ID='VAT']"/>

        <!--ASSERT -->

        <axsl:choose>
            <axsl:when
                    test="( contains( 'AD AE AF AG AI AL AM AN AO AQ AR AS AT AU AW AX AZ BA BB BD BE BF BG BH BI BL BJ BM BN BO BR BS BT BV BW BY BZ CA CC CD CF CG CH CI CK CL CM CN CO CR CU CV CX CY CZ DE DJ DK DM DO DZ EC EE EG EH EL ER ES ET FI FJ FK FM FO FR GA GB GD GE GF GG GH GI GL GM GN GP GQ GR GS GT GU GW GY HK HM HN HR HT HU ID IE IL IM IN IO IQ IR IS IT JE JM JO JP KE KG KH KI KM KN KP KR KW KY KZ LA LB LC LI LK LR LS LT LU LV LY MA MC MD ME MF MG MH MK ML MM MN MO MP MQ MR MS MT MU MV MW MX MY MZ NA NC NE NF NG NI NL NO NP NR NU NZ OM PA PE PF PG PH PK PL PM PN PR PS PT PW PY QA RO RS RU RW SA SB SC SD SE SG SH SI SJ SK SL SM SN SO SR ST SV SY SZ TC TD TF TG TH TJ TK TL TM TN TO TR TT TV TW TZ UA UG UM US UY UZ VA VC VE VG VI VN VU WF WS YE YT ZA ZM ZW',substring(cbc:CompanyID,1,2) ) )"/>
            <axsl:otherwise>
                <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                    test="( contains( 'AD AE AF AG AI AL AM AN AO AQ AR AS AT AU AW AX AZ BA BB BD BE BF BG BH BI BL BJ BM BN BO BR BS BT BV BW BY BZ CA CC CD CF CG CH CI CK CL CM CN CO CR CU CV CX CY CZ DE DJ DK DM DO DZ EC EE EG EH EL ER ES ET FI FJ FK FM FO FR GA GB GD GE GF GG GH GI GL GM GN GP GQ GR GS GT GU GW GY HK HM HN HR HT HU ID IE IL IM IN IO IQ IR IS IT JE JM JO JP KE KG KH KI KM KN KP KR KW KY KZ LA LB LC LI LK LR LS LT LU LV LY MA MC MD ME MF MG MH MK ML MM MN MO MP MQ MR MS MT MU MV MW MX MY MZ NA NC NE NF NG NI NL NO NP NR NU NZ OM PA PE PF PG PH PK PL PM PN PR PS PT PW PY QA RO RS RU RW SA SB SC SD SE SG SH SI SJ SK SL SM SN SO SR ST SV SY SZ TC TD TF TG TH TJ TK TL TM TN TO TR TT TV TW TZ UA UG UM US UY UZ VA VC VE VG VI VN VU WF WS YE YT ZA ZM ZW',substring(cbc:CompanyID,1,2) ) )">
                    <axsl:attribute name="id">PEPPOL-T01-R026</axsl:attribute>
                    <axsl:attribute name="flag">fatal</axsl:attribute>
                    <axsl:attribute name="location">
                        <axsl:apply-templates select="." mode="schematron-select-full-path"/>
                    </axsl:attribute>
                    <svrl:text>When TAX is VAT then Party VAT identifiers SHALL have a prefix in accordance with ISO
                        code ISO 3166-1 alpha-2 by which the country of issue may be identified. Nevertheless, Greece
                        may use the prefix ‘EL’.
                    </svrl:text>
                </svrl:failed-assert>
            </axsl:otherwise>
        </axsl:choose>
        <axsl:apply-templates select="@*|*" mode="M13"/>
    </axsl:template>

    <!--RULE -->

    <axsl:template match="cac:AnticipatedMonetaryTotal" priority="1009" mode="M13">
        <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="cac:AnticipatedMonetaryTotal"/>
        <axsl:variable name="payableAmount" select="xs:decimal(cbc:PayableAmount)"/>
        <axsl:variable name="lineEtensionAmount" select="xs:decimal(cbc:LineExtensionAmount)"/>
        <axsl:variable name="prepaidAmount" select="if (cbc:PrepaidAmount) then xs:decimal(cbc:PrepaidAmount) else 0"/>
        <axsl:variable name="roundingAmount"
                       select="if (cbc:PayableRoundingAmount) then xs:decimal(cbc:PayableRoundingAmount) else 0"/>
        <axsl:variable name="taxinclusiveAmount" select="xs:decimal(cbc:TaxInclusiveAmount)"/>
        <axsl:variable name="allowanceTotalAmount"
                       select="if (cbc:AllowanceTotalAmount) then xs:decimal(cbc:AllowanceTotalAmount) else 0"/>
        <axsl:variable name="chargeTotalAmount"
                       select="if (cbc:ChargeTotalAmount) then xs:decimal(cbc:ChargeTotalAmount) else 0"/>
        <axsl:variable name="taxexclusiveAmount"
                       select="if(cbc:TaxExclusiveAmount) then xs:decimal(cbc:TaxExclusiveAmount) else ($lineEtensionAmount - $allowanceTotalAmount + $chargeTotalAmount)"/>

        <!--ASSERT -->

        <axsl:choose>
            <axsl:when test="$payableAmount &gt;=0"/>
            <axsl:otherwise>
                <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="$payableAmount &gt;=0">
                    <axsl:attribute name="id">PEPPOL-T01-R006</axsl:attribute>
                    <axsl:attribute name="flag">fatal</axsl:attribute>
                    <axsl:attribute name="location">
                        <axsl:apply-templates select="." mode="schematron-select-full-path"/>
                    </axsl:attribute>
                    <svrl:text>Expected total amount for payment SHALL NOT be negative</svrl:text>
                </svrl:failed-assert>
            </axsl:otherwise>
        </axsl:choose>

        <!--ASSERT -->

        <axsl:choose>
            <axsl:when test="$lineEtensionAmount &gt;=0"/>
            <axsl:otherwise>
                <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="$lineEtensionAmount &gt;=0">
                    <axsl:attribute name="id">PEPPOL-T01-R007</axsl:attribute>
                    <axsl:attribute name="flag">fatal</axsl:attribute>
                    <axsl:attribute name="location">
                        <axsl:apply-templates select="." mode="schematron-select-full-path"/>
                    </axsl:attribute>
                    <svrl:text>Expected total sum of line amounts SHALL NOT be negative</svrl:text>
                </svrl:failed-assert>
            </axsl:otherwise>
        </axsl:choose>

        <!--ASSERT -->

        <axsl:choose>
            <axsl:when test="$lineEtensionAmount = $sumLineExtensionAmount"/>
            <axsl:otherwise>
                <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                    test="$lineEtensionAmount = $sumLineExtensionAmount">
                    <axsl:attribute name="id">PEPPOL-T01-R008</axsl:attribute>
                    <axsl:attribute name="flag">fatal</axsl:attribute>
                    <axsl:attribute name="location">
                        <axsl:apply-templates select="." mode="schematron-select-full-path"/>
                    </axsl:attribute>
                    <svrl:text>Expected total sum of line amounts SHALL equal the sum of the order line amounts at order
                        line level
                    </svrl:text>
                </svrl:failed-assert>
            </axsl:otherwise>
        </axsl:choose>

        <!--ASSERT -->

        <axsl:choose>
            <axsl:when test="$allowanceTotalAmount = $sumAllowance"/>
            <axsl:otherwise>
                <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                    test="$allowanceTotalAmount = $sumAllowance">
                    <axsl:attribute name="id">PEPPOL-T01-R009</axsl:attribute>
                    <axsl:attribute name="flag">fatal</axsl:attribute>
                    <axsl:attribute name="location">
                        <axsl:apply-templates select="." mode="schematron-select-full-path"/>
                    </axsl:attribute>
                    <svrl:text>Expected total sum of allowance at document level SHALL be equal to the sum of allowance
                        amounts at document level
                    </svrl:text>
                </svrl:failed-assert>
            </axsl:otherwise>
        </axsl:choose>

        <!--ASSERT -->

        <axsl:choose>
            <axsl:when test="$chargeTotalAmount= $sumCharge"/>
            <axsl:otherwise>
                <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="$chargeTotalAmount= $sumCharge">
                    <axsl:attribute name="id">PEPPOL-T01-R010</axsl:attribute>
                    <axsl:attribute name="flag">fatal</axsl:attribute>
                    <axsl:attribute name="location">
                        <axsl:apply-templates select="." mode="schematron-select-full-path"/>
                    </axsl:attribute>
                    <svrl:text>Expected total sum of charges at document level SHALL be equal to the sum of charge
                        amounts at document level
                    </svrl:text>
                </svrl:failed-assert>
            </axsl:otherwise>
        </axsl:choose>

        <!--ASSERT -->

        <axsl:choose>
            <axsl:when test="$taxexclusiveAmount = $lineEtensionAmount - $allowanceTotalAmount + $chargeTotalAmount"/>
            <axsl:otherwise>
                <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                    test="$taxexclusiveAmount = $lineEtensionAmount - $allowanceTotalAmount + $chargeTotalAmount">
                    <axsl:attribute name="id">PEPPOL-T01-R011</axsl:attribute>
                    <axsl:attribute name="flag">fatal</axsl:attribute>
                    <axsl:attribute name="location">
                        <axsl:apply-templates select="." mode="schematron-select-full-path"/>
                    </axsl:attribute>
                    <svrl:text>Expected total amount without TAX = Expected total sum of line amounts - Sum of
                        allowances on document level + Sum of charges on document level
                    </svrl:text>
                </svrl:failed-assert>
            </axsl:otherwise>
        </axsl:choose>

        <!--ASSERT -->

        <axsl:choose>
            <axsl:when
                    test="if ($taxinclusiveAmount) then ($payableAmount = $taxinclusiveAmount - $prepaidAmount + $roundingAmount) else 1"/>
            <axsl:otherwise>
                <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                    test="if ($taxinclusiveAmount) then ($payableAmount = $taxinclusiveAmount - $prepaidAmount + $roundingAmount) else 1">
                    <axsl:attribute name="id">PEPPOL-T01-R016</axsl:attribute>
                    <axsl:attribute name="flag">fatal</axsl:attribute>
                    <axsl:attribute name="location">
                        <axsl:apply-templates select="." mode="schematron-select-full-path"/>
                    </axsl:attribute>
                    <svrl:text>Amount due for payment = Invoice total amount with TAX - Paid amount + Rounding amount.
                    </svrl:text>
                </svrl:failed-assert>
            </axsl:otherwise>
        </axsl:choose>

        <!--ASSERT -->

        <axsl:choose>
            <axsl:when
                    test="if($taxinclusiveAmount and /ubl:Order/cac:TaxTotal) then ($taxinclusiveAmount = $taxexclusiveAmount + $TAXamount) else 1"/>
            <axsl:otherwise>
                <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                    test="if($taxinclusiveAmount and /ubl:Order/cac:TaxTotal) then ($taxinclusiveAmount = $taxexclusiveAmount + $TAXamount) else 1">
                    <axsl:attribute name="id">PEPPOL-T01-R017</axsl:attribute>
                    <axsl:attribute name="flag">fatal</axsl:attribute>
                    <axsl:attribute name="location">
                        <axsl:apply-templates select="." mode="schematron-select-full-path"/>
                    </axsl:attribute>
                    <svrl:text>Expected total amount with TAX = Expected total amount without TAX + Order total TAX
                        amount.
                    </svrl:text>
                </svrl:failed-assert>
            </axsl:otherwise>
        </axsl:choose>
        <axsl:apply-templates select="@*|*" mode="M13"/>
    </axsl:template>

    <!--RULE -->

    <axsl:template
            match="cac:AllowanceCharge[cbc:MultiplierFactorNumeric and not(cbc:BaseAmount)] | /ubl:Order/cac:OrderLine/cac:LineItem/cac:AllowanceCharge[cbc:MultiplierFactorNumeric and not(cbc:BaseAmount)]"
            priority="1008" mode="M13">
        <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                         context="cac:AllowanceCharge[cbc:MultiplierFactorNumeric and not(cbc:BaseAmount)] | /ubl:Order/cac:OrderLine/cac:LineItem/cac:AllowanceCharge[cbc:MultiplierFactorNumeric and not(cbc:BaseAmount)]"/>

        <!--ASSERT -->

        <axsl:choose>
            <axsl:when test="false()"/>
            <axsl:otherwise>
                <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="false()">
                    <axsl:attribute name="id">PEPPOL-T01-R020</axsl:attribute>
                    <axsl:attribute name="flag">fatal</axsl:attribute>
                    <axsl:attribute name="location">
                        <axsl:apply-templates select="." mode="schematron-select-full-path"/>
                    </axsl:attribute>
                    <svrl:text>Allowance/charge base amount SHALL be provided when allowance/charge percentage is
                        provided.
                    </svrl:text>
                </svrl:failed-assert>
            </axsl:otherwise>
        </axsl:choose>
        <axsl:apply-templates select="@*|*" mode="M13"/>
    </axsl:template>

    <!--RULE -->

    <axsl:template
            match="/ubl:Order/cac:AllowanceCharge[not(cbc:MultiplierFactorNumeric) and cbc:BaseAmount] | /ubl:Order/cac:OrderLine/cac:LineItem/cac:AllowanceCharge[not(cbc:MultiplierFactorNumeric) and cbc:BaseAmount]"
            priority="1007" mode="M13">
        <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                         context="/ubl:Order/cac:AllowanceCharge[not(cbc:MultiplierFactorNumeric) and cbc:BaseAmount] | /ubl:Order/cac:OrderLine/cac:LineItem/cac:AllowanceCharge[not(cbc:MultiplierFactorNumeric) and cbc:BaseAmount]"/>

        <!--ASSERT -->

        <axsl:choose>
            <axsl:when test="false()"/>
            <axsl:otherwise>
                <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="false()">
                    <axsl:attribute name="id">PEPPOL-T01-R021</axsl:attribute>
                    <axsl:attribute name="flag">fatal</axsl:attribute>
                    <axsl:attribute name="location">
                        <axsl:apply-templates select="." mode="schematron-select-full-path"/>
                    </axsl:attribute>
                    <svrl:text>Allowance/charge percentage SHALL be provided when allowance/charge base amount is
                        provided.
                    </svrl:text>
                </svrl:failed-assert>
            </axsl:otherwise>
        </axsl:choose>
        <axsl:apply-templates select="@*|*" mode="M13"/>
    </axsl:template>

    <!--RULE -->

    <axsl:template match="/ubl:Order/cac:AllowanceCharge |/ubl:Order/cac:OrderLine/cac:LineItem/cac:AllowanceCharge"
                   priority="1006" mode="M13">
        <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                         context="/ubl:Order/cac:AllowanceCharge |/ubl:Order/cac:OrderLine/cac:LineItem/cac:AllowanceCharge"/>

        <!--ASSERT -->

        <axsl:choose>
            <axsl:when
                    test="not(cbc:MultiplierFactorNumeric and cbc:BaseAmount) or u:slack(if (cbc:Amount) then cbc:Amount else 0, (xs:decimal(cbc:BaseAmount) * xs:decimal(cbc:MultiplierFactorNumeric)) div 100, 0.02)"/>
            <axsl:otherwise>
                <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                    test="not(cbc:MultiplierFactorNumeric and cbc:BaseAmount) or u:slack(if (cbc:Amount) then cbc:Amount else 0, (xs:decimal(cbc:BaseAmount) * xs:decimal(cbc:MultiplierFactorNumeric)) div 100, 0.02)">
                    <axsl:attribute name="id">PEPPOL-T01-R022</axsl:attribute>
                    <axsl:attribute name="flag">fatal</axsl:attribute>
                    <axsl:attribute name="location">
                        <axsl:apply-templates select="." mode="schematron-select-full-path"/>
                    </axsl:attribute>
                    <svrl:text>Allowance/charge amount SHALL equal base amount * percentage/100 if base amount and
                        percentage exists
                    </svrl:text>
                </svrl:failed-assert>
            </axsl:otherwise>
        </axsl:choose>

        <!--ASSERT -->

        <axsl:choose>
            <axsl:when test="exists(cbc:AllowanceChargeReason) or exists(cbc:AllowanceChargeReasonCode)"/>
            <axsl:otherwise>
                <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                    test="exists(cbc:AllowanceChargeReason) or exists(cbc:AllowanceChargeReasonCode)">
                    <axsl:attribute name="id">PEPPOL-T01-R023</axsl:attribute>
                    <axsl:attribute name="flag">fatal</axsl:attribute>
                    <axsl:attribute name="location">
                        <axsl:apply-templates select="." mode="schematron-select-full-path"/>
                    </axsl:attribute>
                    <svrl:text>Each document or line level allowance SHALL have an allowance reason text or an allowance
                        reason code.
                    </svrl:text>
                </svrl:failed-assert>
            </axsl:otherwise>
        </axsl:choose>

        <!--ASSERT -->

        <axsl:choose>
            <axsl:when test="number(cbc:Amount) &gt;= 0"/>
            <axsl:otherwise>
                <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="number(cbc:Amount) &gt;= 0">
                    <axsl:attribute name="id">PEPPOL-T01-R032</axsl:attribute>
                    <axsl:attribute name="flag">fatal</axsl:attribute>
                    <axsl:attribute name="location">
                        <axsl:apply-templates select="." mode="schematron-select-full-path"/>
                    </axsl:attribute>
                    <svrl:text>Allowance or charge amounts SHALL NOT be negative.</svrl:text>
                </svrl:failed-assert>
            </axsl:otherwise>
        </axsl:choose>
        <axsl:apply-templates select="@*|*" mode="M13"/>
    </axsl:template>

    <!--RULE -->

    <axsl:template match="cac:TaxCategory | cac:ClassifiedTaxCategory" priority="1005" mode="M13">
        <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                         context="cac:TaxCategory | cac:ClassifiedTaxCategory"/>

        <!--ASSERT -->

        <axsl:choose>
            <axsl:when test="cbc:Percent or (normalize-space(cbc:ID)='O')"/>
            <axsl:otherwise>
                <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                    test="cbc:Percent or (normalize-space(cbc:ID)='O')">
                    <axsl:attribute name="id">PEPPOL-T01-R029</axsl:attribute>
                    <axsl:attribute name="flag">fatal</axsl:attribute>
                    <axsl:attribute name="location">
                        <axsl:apply-templates select="." mode="schematron-select-full-path"/>
                    </axsl:attribute>
                    <svrl:text>Each Tax Category SHALL have a TAX category rate, except if the order is not subject to
                        TAX.
                    </svrl:text>
                </svrl:failed-assert>
            </axsl:otherwise>
        </axsl:choose>

        <!--ASSERT -->

        <axsl:choose>
            <axsl:when test="not(normalize-space(cbc:ID)='S') or (cbc:Percent) &gt; 0"/>
            <axsl:otherwise>
                <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                    test="not(normalize-space(cbc:ID)='S') or (cbc:Percent) &gt; 0">
                    <axsl:attribute name="id">PEPPOL-T01-R030</axsl:attribute>
                    <axsl:attribute name="flag">fatal</axsl:attribute>
                    <axsl:attribute name="location">
                        <axsl:apply-templates select="." mode="schematron-select-full-path"/>
                    </axsl:attribute>
                    <svrl:text>When TAX category code is "Standard rated" (S) the TAX rate SHALL be greater than zero.
                    </svrl:text>
                </svrl:failed-assert>
            </axsl:otherwise>
        </axsl:choose>
        <axsl:apply-templates select="@*|*" mode="M13"/>
    </axsl:template>

    <!--RULE -->

    <axsl:template match="cac:OrderLine/cac:LineItem" priority="1004" mode="M13">
        <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="cac:OrderLine/cac:LineItem"/>
        <axsl:variable name="lineExtensionAmount"
                       select="if (cbc:LineExtensionAmount) then xs:decimal(cbc:LineExtensionAmount) else 0"/>
        <axsl:variable name="quantity" select="if (cbc:Quantity) then xs:decimal(cbc:Quantity) else 1"/>
        <axsl:variable name="priceAmount"
                       select="if (cac:Price/cbc:PriceAmount) then xs:decimal(cac:Price/cbc:PriceAmount) else 0"/>
        <axsl:variable name="baseQuantity"
                       select="if (cac:Price/cbc:BaseQuantity and xs:decimal(cac:Price/cbc:BaseQuantity) != 0) then xs:decimal(cac:Price/cbc:BaseQuantity) else 1"/>
        <axsl:variable name="allowancesTotal"
                       select="if (cac:AllowanceCharge[normalize-space(cbc:ChargeIndicator) = 'false']) then round(sum(cac:AllowanceCharge[normalize-space(cbc:ChargeIndicator) = 'false']/cbc:Amount/xs:decimal(.)) * 10 * 10) div 100 else 0"/>
        <axsl:variable name="chargesTotal"
                       select="if (cac:AllowanceCharge[normalize-space(cbc:ChargeIndicator) = 'true']) then round(sum(cac:AllowanceCharge[normalize-space(cbc:ChargeIndicator) = 'true']/cbc:Amount/xs:decimal(.)) * 10 * 10) div 100 else 0"/>

        <!--ASSERT -->

        <axsl:choose>
            <axsl:when
                    test="u:slack($lineExtensionAmount, ($quantity * ($priceAmount div $baseQuantity)) + $chargesTotal - $allowancesTotal, 0.02)"/>
            <axsl:otherwise>
                <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                    test="u:slack($lineExtensionAmount, ($quantity * ($priceAmount div $baseQuantity)) + $chargesTotal - $allowancesTotal, 0.02)">
                    <axsl:attribute name="id">PEPPOL-T01-R024</axsl:attribute>
                    <axsl:attribute name="flag">fatal</axsl:attribute>
                    <axsl:attribute name="location">
                        <axsl:apply-templates select="." mode="schematron-select-full-path"/>
                    </axsl:attribute>
                    <svrl:text>Order line net amount SHALL equal (Ordered quantity * (Item net price/item price base
                        quantity) + Order line charge amount - Order line allowance amount
                    </svrl:text>
                </svrl:failed-assert>
            </axsl:otherwise>
        </axsl:choose>

        <!--ASSERT -->

        <axsl:choose>
            <axsl:when test="not(cac:Price/cbc:BaseQuantity) or xs:decimal(cac:Price/cbc:BaseQuantity) &gt; 0"/>
            <axsl:otherwise>
                <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                    test="not(cac:Price/cbc:BaseQuantity) or xs:decimal(cac:Price/cbc:BaseQuantity) &gt; 0">
                    <axsl:attribute name="id">PEPPOL-T01-R025</axsl:attribute>
                    <axsl:attribute name="flag">fatal</axsl:attribute>
                    <axsl:attribute name="location">
                        <axsl:apply-templates select="." mode="schematron-select-full-path"/>
                    </axsl:attribute>
                    <svrl:text>Base quantity SHALL be a positive number above zero.</svrl:text>
                </svrl:failed-assert>
            </axsl:otherwise>
        </axsl:choose>

        <!--ASSERT -->

        <axsl:choose>
            <axsl:when test="count(key('k_lineId',cbc:ID)) = 1"/>
            <axsl:otherwise>
                <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                    test="count(key('k_lineId',cbc:ID)) = 1">
                    <axsl:attribute name="id">PEPPOL-T01-R001</axsl:attribute>
                    <axsl:attribute name="flag">fatal</axsl:attribute>
                    <axsl:attribute name="location">
                        <axsl:apply-templates select="." mode="schematron-select-full-path"/>
                    </axsl:attribute>
                    <svrl:text>Each order line SHALL have a document line identifier that is unique within the order.
                    </svrl:text>
                </svrl:failed-assert>
            </axsl:otherwise>
        </axsl:choose>

        <!--ASSERT -->

        <axsl:choose>
            <axsl:when test="number(cbc:Quantity) &gt;=0"/>
            <axsl:otherwise>
                <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="number(cbc:Quantity) &gt;=0">
                    <axsl:attribute name="id">PEPPOL-T01-R004</axsl:attribute>
                    <axsl:attribute name="flag">fatal</axsl:attribute>
                    <axsl:attribute name="location">
                        <axsl:apply-templates select="." mode="schematron-select-full-path"/>
                    </axsl:attribute>
                    <svrl:text>Each order line ordered quantity SHALL not be negative</svrl:text>
                </svrl:failed-assert>
            </axsl:otherwise>
        </axsl:choose>

        <!--ASSERT -->

        <axsl:choose>
            <axsl:when test="cbc:Quantity"/>
            <axsl:otherwise>
                <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="cbc:Quantity">
                    <axsl:attribute name="id">PEPPOL-T01-R013</axsl:attribute>
                    <axsl:attribute name="flag">warning</axsl:attribute>
                    <axsl:attribute name="location">
                        <axsl:apply-templates select="." mode="schematron-select-full-path"/>
                    </axsl:attribute>
                    <svrl:text>Each order line SHOULD have an ordered quantity</svrl:text>
                </svrl:failed-assert>
            </axsl:otherwise>
        </axsl:choose>
        <axsl:apply-templates select="@*|*" mode="M13"/>
    </axsl:template>

    <!--RULE -->

    <axsl:template match="cac:Price/cac:AllowanceCharge" priority="1003" mode="M13">
        <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="cac:Price/cac:AllowanceCharge"/>

        <!--ASSERT -->

        <axsl:choose>
            <axsl:when
                    test="not(cbc:BaseAmount) or xs:decimal(../cbc:PriceAmount) = xs:decimal(cbc:BaseAmount) - xs:decimal(cbc:Amount)"/>
            <axsl:otherwise>
                <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                    test="not(cbc:BaseAmount) or xs:decimal(../cbc:PriceAmount) = xs:decimal(cbc:BaseAmount) - xs:decimal(cbc:Amount)">
                    <axsl:attribute name="id">PEPPOL-T01-R019</axsl:attribute>
                    <axsl:attribute name="flag">fatal</axsl:attribute>
                    <axsl:attribute name="location">
                        <axsl:apply-templates select="." mode="schematron-select-full-path"/>
                    </axsl:attribute>
                    <svrl:text>Item net price SHALL equal (Gross price - Allowance amount) when gross price is
                        provided.
                    </svrl:text>
                </svrl:failed-assert>
            </axsl:otherwise>
        </axsl:choose>
        <axsl:apply-templates select="@*|*" mode="M13"/>
    </axsl:template>

    <!--RULE -->

    <axsl:template match="cac:Price" priority="1002" mode="M13">
        <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="cac:Price"/>

        <!--ASSERT -->

        <axsl:choose>
            <axsl:when test="number(cbc:PriceAmount) &gt;=0"/>
            <axsl:otherwise>
                <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="number(cbc:PriceAmount) &gt;=0">
                    <axsl:attribute name="id">PEPPOL-T01-R005</axsl:attribute>
                    <axsl:attribute name="flag">fatal</axsl:attribute>
                    <axsl:attribute name="location">
                        <axsl:apply-templates select="." mode="schematron-select-full-path"/>
                    </axsl:attribute>
                    <svrl:text>Each order line item net price SHALL not be negative
                    </svrl:text>
                </svrl:failed-assert>
            </axsl:otherwise>
        </axsl:choose>

        <!--ASSERT -->

        <axsl:choose>
            <axsl:when
                    test="(cac:AllowanceCharge/cbc:BaseAmount) &gt;= 0 or not(exists(cac:AllowanceCharge/cbc:BaseAmount))"/>
            <axsl:otherwise>
                <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                    test="(cac:AllowanceCharge/cbc:BaseAmount) &gt;= 0 or not(exists(cac:AllowanceCharge/cbc:BaseAmount))">
                    <axsl:attribute name="id">PEPPOL-T01-R027</axsl:attribute>
                    <axsl:attribute name="flag">fatal</axsl:attribute>
                    <axsl:attribute name="location">
                        <axsl:apply-templates select="." mode="schematron-select-full-path"/>
                    </axsl:attribute>
                    <svrl:text>The Item gross price SHALL NOT be negative.</svrl:text>
                </svrl:failed-assert>
            </axsl:otherwise>
        </axsl:choose>

        <!--ASSERT -->

        <axsl:choose>
            <axsl:when
                    test="number(cac:AllowanceCharge/cbc:Amount) &gt;= 0 or not(exists(cac:AllowanceCharge/cbc:Amount))"/>
            <axsl:otherwise>
                <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                    test="number(cac:AllowanceCharge/cbc:Amount) &gt;= 0 or not(exists(cac:AllowanceCharge/cbc:Amount))">
                    <axsl:attribute name="id">PEPPOL-T01-R033</axsl:attribute>
                    <axsl:attribute name="flag">fatal</axsl:attribute>
                    <axsl:attribute name="location">
                        <axsl:apply-templates select="." mode="schematron-select-full-path"/>
                    </axsl:attribute>
                    <svrl:text>Allowance or charge amounts SHALL NOT be negative.</svrl:text>
                </svrl:failed-assert>
            </axsl:otherwise>
        </axsl:choose>
        <axsl:apply-templates select="@*|*" mode="M13"/>
    </axsl:template>

    <!--RULE -->

    <axsl:template match="cac:AllowanceCharge[cbc:ChargeIndicator = 'false']/cbc:AllowanceChargeReasonCode"
                   priority="1001" mode="M13">
        <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                         context="cac:AllowanceCharge[cbc:ChargeIndicator = 'false']/cbc:AllowanceChargeReasonCode"/>

        <!--ASSERT -->

        <axsl:choose>
            <axsl:when
                    test="                         some $code in $clUNCL5189                         satisfies normalize-space(text()) = $code"/>
            <axsl:otherwise>
                <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                    test="some $code in $clUNCL5189 satisfies normalize-space(text()) = $code">
                    <axsl:attribute name="id">PEPPOL-T01-CL001</axsl:attribute>
                    <axsl:attribute name="flag">fatal</axsl:attribute>
                    <axsl:attribute name="location">
                        <axsl:apply-templates select="." mode="schematron-select-full-path"/>
                    </axsl:attribute>
                    <svrl:text>Reason code MUST be according to subset of UNCL 5189 D.16B.</svrl:text>
                </svrl:failed-assert>
            </axsl:otherwise>
        </axsl:choose>
        <axsl:apply-templates select="@*|*" mode="M13"/>
    </axsl:template>

    <!--RULE -->

    <axsl:template match="cac:AllowanceCharge[cbc:ChargeIndicator = 'true']/cbc:AllowanceChargeReasonCode"
                   priority="1000" mode="M13">
        <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                         context="cac:AllowanceCharge[cbc:ChargeIndicator = 'true']/cbc:AllowanceChargeReasonCode"/>

        <!--ASSERT -->

        <axsl:choose>
            <axsl:when
                    test="                         some $code in $clUNCL7161                         satisfies normalize-space(text()) = $code"/>
            <axsl:otherwise>
                <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                    test="some $code in $clUNCL7161 satisfies normalize-space(text()) = $code">
                    <axsl:attribute name="id">PEPPOL-T01-CL002</axsl:attribute>
                    <axsl:attribute name="flag">fatal</axsl:attribute>
                    <axsl:attribute name="location">
                        <axsl:apply-templates select="." mode="schematron-select-full-path"/>
                    </axsl:attribute>
                    <svrl:text>Reason code MUST be according to UNCL 7161 D.16B.</svrl:text>
                </svrl:failed-assert>
            </axsl:otherwise>
        </axsl:choose>
        <axsl:apply-templates select="@*|*" mode="M13"/>
    </axsl:template>
    <axsl:template match="text()" priority="-1" mode="M13"/>
    <axsl:template match="@*|node()" priority="-2" mode="M13">
        <axsl:apply-templates select="@*|*" mode="M13"/>
    </axsl:template>

    <!--PATTERN getAbstractTipoOrdine-->

    <axsl:template match="text()" priority="-1" mode="M38"/>
    <axsl:template match="@*|node()" priority="-2" mode="M38">
        <axsl:apply-templates select="@*|*" mode="M38"/>
    </axsl:template>

    <!--PATTERN verificaID-->


    <!--RULE -->

    <axsl:template match="/ubl:Order" priority="1001" mode="M39">
        <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="/ubl:Order"/>
        <axsl:variable name="tipologia_ordine_ristretta"
                       select="         if (/ubl:Order/cac:OrderDocumentReference)      then     (         if (count(/ubl:Order/cac:OrderDocumentReference) = 1)       then        (        u:tipoOrdine(/ubl:Order/cac:OrderDocumentReference/cbc:ID)       )       else        (        'ERRORE_NSO45'       )     )     else     (       'INIZ'     )         "/>

        <!--ASSERT -->

        <axsl:choose>
            <axsl:when test="if ($tipologia_ordine_ristretta = 'ERRORE_NSO40') then false() else true()"/>
            <axsl:otherwise>
                <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                    test="if ($tipologia_ordine_ristretta = 'ERRORE_NSO40') then false() else true()">
                    <axsl:attribute name="id">NSO_040</axsl:attribute>
                    <axsl:attribute name="flag">fatal</axsl:attribute>
                    <axsl:attribute name="location">
                        <axsl:apply-templates select="." mode="schematron-select-full-path"/>
                    </axsl:attribute>
                    <svrl:text>
                        NSO_040 - The format of the element "cac:OrderDocumentReference/cbc:ID" is invalid (correct
                        format example: "110#2018-01-30#aaaaaa#Revised").
                    </svrl:text>
                </svrl:failed-assert>
            </axsl:otherwise>
        </axsl:choose>

        <!--ASSERT -->

        <axsl:choose>
            <axsl:when test="if ($tipologia_ordine_ristretta = 'ERRORE') then false() else true()"/>
            <axsl:otherwise>
                <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                    test="if ($tipologia_ordine_ristretta = 'ERRORE') then false() else true()">
                    <axsl:attribute name="id">NSO_044</axsl:attribute>
                    <axsl:attribute name="flag">fatal</axsl:attribute>
                    <axsl:attribute name="location">
                        <axsl:apply-templates select="." mode="schematron-select-full-path"/>
                    </axsl:attribute>
                    <svrl:text>
                        NSO_044 - In the element "cac:OrderDocumentReference/cbc:ID" the ReferenceType is invalid (the
                        allowed values are: "Connected", "Accepted", "Cancelled", "Revised", "Invoice").
                    </svrl:text>
                </svrl:failed-assert>
            </axsl:otherwise>
        </axsl:choose>

        <!--ASSERT -->

        <axsl:choose>
            <axsl:when test="if ($tipologia_ordine_ristretta = 'ERRORE_NSO45') then false() else true()"/>
            <axsl:otherwise>
                <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                    test="if ($tipologia_ordine_ristretta = 'ERRORE_NSO45') then false() else true()">
                    <axsl:attribute name="id">NSO_045</axsl:attribute>
                    <axsl:attribute name="flag">fatal</axsl:attribute>
                    <axsl:attribute name="location">
                        <axsl:apply-templates select="." mode="schematron-select-full-path"/>
                    </axsl:attribute>
                    <svrl:text>
                        NSO_045 – The Document contains more than one "cac:OrderDocumentReference" element.
                    </svrl:text>
                </svrl:failed-assert>
            </axsl:otherwise>
        </axsl:choose>
        <axsl:variable name="INIZ" select="if ($tipologia_ordine_ristretta = 'INIZ') then true() else false()"/>
        <axsl:variable name="CONN" select="if ($tipologia_ordine_ristretta = 'CONN') then true() else false()"/>
        <axsl:variable name="SOST" select="if ($tipologia_ordine_ristretta = 'SOST') then true() else false()"/>
        <axsl:variable name="CANC" select="if ($tipologia_ordine_ristretta = 'CANC') then true() else false()"/>
        <axsl:variable name="CONF" select="if ($tipologia_ordine_ristretta = 'CONF') then true() else false()"/>
        <axsl:variable name="INVO" select="if ($tipologia_ordine_ristretta = 'INVO') then true() else false()"/>
        <axsl:apply-templates select="@*|*" mode="M39"/>
    </axsl:template>

    <!--RULE -->

    <axsl:template match="cac:OrderDocumentReference/cbc:ID" priority="1000" mode="M39">
        <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="cac:OrderDocumentReference/cbc:ID"/>
        <axsl:variable name="tipologia_ordine_ristretta"
                       select="         if (/ubl:Order/cac:OrderDocumentReference)      then     (         if (count(/ubl:Order/cac:OrderDocumentReference) = 1)       then        (        u:tipoOrdine(/ubl:Order/cac:OrderDocumentReference/cbc:ID)       )       else        (        'ERRORE_NSO45'       )     )     else     (       'INIZ'     )         "/>

        <!--ASSERT -->

        <axsl:choose>
            <axsl:when test="if ($tipologia_ordine_ristretta = 'ERRORE_NSO40') then false() else true()"/>
            <axsl:otherwise>
                <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                    test="if ($tipologia_ordine_ristretta = 'ERRORE_NSO40') then false() else true()">
                    <axsl:attribute name="id">NSO_040</axsl:attribute>
                    <axsl:attribute name="flag">fatal</axsl:attribute>
                    <axsl:attribute name="location">
                        <axsl:apply-templates select="." mode="schematron-select-full-path"/>
                    </axsl:attribute>
                    <svrl:text>
                        NSO_040 - The format of the element "cac:OrderDocumentReference/cbc:ID" is invalid (correct
                        format example: "110#2018-01-30#aaaaaa#Revised").
                    </svrl:text>
                </svrl:failed-assert>
            </axsl:otherwise>
        </axsl:choose>

        <!--ASSERT -->

        <axsl:choose>
            <axsl:when test="if ($tipologia_ordine_ristretta = 'ERRORE') then false() else true()"/>
            <axsl:otherwise>
                <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                    test="if ($tipologia_ordine_ristretta = 'ERRORE') then false() else true()">
                    <axsl:attribute name="id">NSO_044</axsl:attribute>
                    <axsl:attribute name="flag">fatal</axsl:attribute>
                    <axsl:attribute name="location">
                        <axsl:apply-templates select="." mode="schematron-select-full-path"/>
                    </axsl:attribute>
                    <svrl:text>
                        NSO_044 - In the element "cac:OrderDocumentReference/cbc:ID" the ReferenceType is invalid (the
                        allowed values are: "Connected", "Accepted", "Cancelled", "Revised", "Invoice").
                    </svrl:text>
                </svrl:failed-assert>
            </axsl:otherwise>
        </axsl:choose>

        <!--ASSERT -->

        <axsl:choose>
            <axsl:when test="if ($tipologia_ordine_ristretta = 'ERRORE_NSO45') then false() else true()"/>
            <axsl:otherwise>
                <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                    test="if ($tipologia_ordine_ristretta = 'ERRORE_NSO45') then false() else true()">
                    <axsl:attribute name="id">NSO_045</axsl:attribute>
                    <axsl:attribute name="flag">fatal</axsl:attribute>
                    <axsl:attribute name="location">
                        <axsl:apply-templates select="." mode="schematron-select-full-path"/>
                    </axsl:attribute>
                    <svrl:text>
                        NSO_045 – The Document contains more than one "cac:OrderDocumentReference" element.
                    </svrl:text>
                </svrl:failed-assert>
            </axsl:otherwise>
        </axsl:choose>
        <axsl:variable name="INIZ" select="if ($tipologia_ordine_ristretta = 'INIZ') then true() else false()"/>
        <axsl:variable name="CONN" select="if ($tipologia_ordine_ristretta = 'CONN') then true() else false()"/>
        <axsl:variable name="SOST" select="if ($tipologia_ordine_ristretta = 'SOST') then true() else false()"/>
        <axsl:variable name="CANC" select="if ($tipologia_ordine_ristretta = 'CANC') then true() else false()"/>
        <axsl:variable name="CONF" select="if ($tipologia_ordine_ristretta = 'CONF') then true() else false()"/>
        <axsl:variable name="INVO" select="if ($tipologia_ordine_ristretta = 'INVO') then true() else false()"/>

        <!--ASSERT -->

        <axsl:choose>
            <axsl:when
                    test="not( (u:is($CONF) or u:is($SOST) or u:is($CANC) or u:is($CONN) or u:is($INVO)) and not (u:validationDate(u:getPartTokenizeID(.,2))) )"/>
            <axsl:otherwise>
                <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                    test="not( (u:is($CONF) or u:is($SOST) or u:is($CANC) or u:is($CONN) or u:is($INVO)) and not (u:validationDate(u:getPartTokenizeID(.,2))) )">
                    <axsl:attribute name="id">NSO_042</axsl:attribute>
                    <axsl:attribute name="flag">fatal</axsl:attribute>
                    <axsl:attribute name="location">
                        <axsl:apply-templates select="." mode="schematron-select-full-path"/>
                    </axsl:attribute>
                    <svrl:text>NSO_042 – The format of the date in the element is incorrect (correct format example:
                        "2020-01-31").
                    </svrl:text>
                </svrl:failed-assert>
            </axsl:otherwise>
        </axsl:choose>

        <!--ASSERT -->

        <axsl:choose>
            <axsl:when
                    test="not( (u:is($CONF) or u:is($SOST) or u:is($CANC) or u:is($CONN) or u:is($INVO)) and ( not ( u:checkPIVAseIT(u:getPartTokenizeID(.,3)) ) ) )"/>
            <axsl:otherwise>
                <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                    test="not( (u:is($CONF) or u:is($SOST) or u:is($CANC) or u:is($CONN) or u:is($INVO)) and ( not ( u:checkPIVAseIT(u:getPartTokenizeID(.,3)) ) ) )">
                    <axsl:attribute name="id">NSO_043</axsl:attribute>
                    <axsl:attribute name="flag">fatal</axsl:attribute>
                    <axsl:attribute name="location">
                        <axsl:apply-templates select="." mode="schematron-select-full-path"/>
                    </axsl:attribute>
                    <svrl:text>NSO_043 - The EndpointID specified in the element is not a valid value (correct value
                        example: "IT01043931003").
                    </svrl:text>
                </svrl:failed-assert>
            </axsl:otherwise>
        </axsl:choose>

        <!--ASSERT -->

        <axsl:choose>
            <axsl:when
                    test="not( (u:is($CONF) or u:is($SOST) or u:is($CANC) or u:is($CONN) or u:is($INVO)) and ( (u:getPartTokenizeID(.,1)='') ) )"/>
            <axsl:otherwise>
                <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                    test="not( (u:is($CONF) or u:is($SOST) or u:is($CANC) or u:is($CONN) or u:is($INVO)) and ( (u:getPartTokenizeID(.,1)='') ) )">
                    <axsl:attribute name="id">NSO_041</axsl:attribute>
                    <axsl:attribute name="flag">fatal</axsl:attribute>
                    <axsl:attribute name="location">
                        <axsl:apply-templates select="." mode="schematron-select-full-path"/>
                    </axsl:attribute>
                    <svrl:text>NSO_041 - The ID in the element is not set.
                    </svrl:text>
                </svrl:failed-assert>
            </axsl:otherwise>
        </axsl:choose>
        <axsl:apply-templates select="@*|*" mode="M39"/>
    </axsl:template>
    <axsl:template match="text()" priority="-1" mode="M39"/>
    <axsl:template match="@*|node()" priority="-2" mode="M39">
        <axsl:apply-templates select="@*|*" mode="M39"/>
    </axsl:template>

    <!--PATTERN verificaLineeOrdine-->


    <!--RULE -->

    <axsl:template match="/ubl:Order" priority="1002" mode="M40">
        <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="/ubl:Order"/>
        <axsl:variable name="tipologia_ordine_ristretta"
                       select="         if (/ubl:Order/cac:OrderDocumentReference)      then     (         if (count(/ubl:Order/cac:OrderDocumentReference) = 1)       then        (        u:tipoOrdine(/ubl:Order/cac:OrderDocumentReference/cbc:ID)       )       else        (        'ERRORE_NSO45'       )     )     else     (       'INIZ'     )         "/>

        <!--ASSERT -->

        <axsl:choose>
            <axsl:when test="if ($tipologia_ordine_ristretta = 'ERRORE_NSO40') then false() else true()"/>
            <axsl:otherwise>
                <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                    test="if ($tipologia_ordine_ristretta = 'ERRORE_NSO40') then false() else true()">
                    <axsl:attribute name="id">NSO_040</axsl:attribute>
                    <axsl:attribute name="flag">fatal</axsl:attribute>
                    <axsl:attribute name="location">
                        <axsl:apply-templates select="." mode="schematron-select-full-path"/>
                    </axsl:attribute>
                    <svrl:text>
                        NSO_040 - The format of the element "cac:OrderDocumentReference/cbc:ID" is invalid (correct
                        format example: "110#2018-01-30#aaaaaa#Revised").
                    </svrl:text>
                </svrl:failed-assert>
            </axsl:otherwise>
        </axsl:choose>

        <!--ASSERT -->

        <axsl:choose>
            <axsl:when test="if ($tipologia_ordine_ristretta = 'ERRORE') then false() else true()"/>
            <axsl:otherwise>
                <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                    test="if ($tipologia_ordine_ristretta = 'ERRORE') then false() else true()">
                    <axsl:attribute name="id">NSO_044</axsl:attribute>
                    <axsl:attribute name="flag">fatal</axsl:attribute>
                    <axsl:attribute name="location">
                        <axsl:apply-templates select="." mode="schematron-select-full-path"/>
                    </axsl:attribute>
                    <svrl:text>
                        NSO_044 - In the element "cac:OrderDocumentReference/cbc:ID" the ReferenceType is invalid (the
                        allowed values are: "Connected", "Accepted", "Cancelled", "Revised", "Invoice").
                    </svrl:text>
                </svrl:failed-assert>
            </axsl:otherwise>
        </axsl:choose>

        <!--ASSERT -->

        <axsl:choose>
            <axsl:when test="if ($tipologia_ordine_ristretta = 'ERRORE_NSO45') then false() else true()"/>
            <axsl:otherwise>
                <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                    test="if ($tipologia_ordine_ristretta = 'ERRORE_NSO45') then false() else true()">
                    <axsl:attribute name="id">NSO_045</axsl:attribute>
                    <axsl:attribute name="flag">fatal</axsl:attribute>
                    <axsl:attribute name="location">
                        <axsl:apply-templates select="." mode="schematron-select-full-path"/>
                    </axsl:attribute>
                    <svrl:text>
                        NSO_045 – The Document contains more than one "cac:OrderDocumentReference" element.
                    </svrl:text>
                </svrl:failed-assert>
            </axsl:otherwise>
        </axsl:choose>
        <axsl:variable name="INIZ" select="if ($tipologia_ordine_ristretta = 'INIZ') then true() else false()"/>
        <axsl:variable name="CONN" select="if ($tipologia_ordine_ristretta = 'CONN') then true() else false()"/>
        <axsl:variable name="SOST" select="if ($tipologia_ordine_ristretta = 'SOST') then true() else false()"/>
        <axsl:variable name="CANC" select="if ($tipologia_ordine_ristretta = 'CANC') then true() else false()"/>
        <axsl:variable name="CONF" select="if ($tipologia_ordine_ristretta = 'CONF') then true() else false()"/>
        <axsl:variable name="INVO" select="if ($tipologia_ordine_ristretta = 'INVO') then true() else false()"/>

        <!--ASSERT -->

        <axsl:choose>
            <axsl:when test=" not( (u:is($CONF) or u:is($CANC)) and (count(cac:OrderLine) != 1)) "/>
            <axsl:otherwise>
                <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                    test="not( (u:is($CONF) or u:is($CANC)) and (count(cac:OrderLine) != 1))">
                    <axsl:attribute name="id">NSO_050</axsl:attribute>
                    <axsl:attribute name="flag">fatal</axsl:attribute>
                    <axsl:attribute name="location">
                        <axsl:apply-templates select="." mode="schematron-select-full-path"/>
                    </axsl:attribute>
                    <svrl:text>NSO_050 – The Document contains more than one "cac:OrderLine" element.
                    </svrl:text>
                </svrl:failed-assert>
            </axsl:otherwise>
        </axsl:choose>
        <axsl:apply-templates select="@*|*" mode="M40"/>
    </axsl:template>

    <!--RULE -->

    <axsl:template match="/ubl:Order/cac:OrderLine" priority="1001" mode="M40">
        <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="/ubl:Order/cac:OrderLine"/>
        <axsl:variable name="tipologia_ordine_ristretta"
                       select="         if (/ubl:Order/cac:OrderDocumentReference)      then     (         if (count(/ubl:Order/cac:OrderDocumentReference) = 1)       then        (        u:tipoOrdine(/ubl:Order/cac:OrderDocumentReference/cbc:ID)       )       else        (        'ERRORE_NSO45'       )     )     else     (       'INIZ'     )         "/>

        <!--ASSERT -->

        <axsl:choose>
            <axsl:when test="if ($tipologia_ordine_ristretta = 'ERRORE_NSO40') then false() else true()"/>
            <axsl:otherwise>
                <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                    test="if ($tipologia_ordine_ristretta = 'ERRORE_NSO40') then false() else true()">
                    <axsl:attribute name="id">NSO_040</axsl:attribute>
                    <axsl:attribute name="flag">fatal</axsl:attribute>
                    <axsl:attribute name="location">
                        <axsl:apply-templates select="." mode="schematron-select-full-path"/>
                    </axsl:attribute>
                    <svrl:text>
                        NSO_040 - The format of the element "cac:OrderDocumentReference/cbc:ID" is invalid (correct
                        format example: "110#2018-01-30#aaaaaa#Revised").
                    </svrl:text>
                </svrl:failed-assert>
            </axsl:otherwise>
        </axsl:choose>

        <!--ASSERT -->

        <axsl:choose>
            <axsl:when test="if ($tipologia_ordine_ristretta = 'ERRORE') then false() else true()"/>
            <axsl:otherwise>
                <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                    test="if ($tipologia_ordine_ristretta = 'ERRORE') then false() else true()">
                    <axsl:attribute name="id">NSO_044</axsl:attribute>
                    <axsl:attribute name="flag">fatal</axsl:attribute>
                    <axsl:attribute name="location">
                        <axsl:apply-templates select="." mode="schematron-select-full-path"/>
                    </axsl:attribute>
                    <svrl:text>
                        NSO_044 - In the element "cac:OrderDocumentReference/cbc:ID" the ReferenceType is invalid (the
                        allowed values are: "Connected", "Accepted", "Cancelled", "Revised", "Invoice").
                    </svrl:text>
                </svrl:failed-assert>
            </axsl:otherwise>
        </axsl:choose>

        <!--ASSERT -->

        <axsl:choose>
            <axsl:when test="if ($tipologia_ordine_ristretta = 'ERRORE_NSO45') then false() else true()"/>
            <axsl:otherwise>
                <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                    test="if ($tipologia_ordine_ristretta = 'ERRORE_NSO45') then false() else true()">
                    <axsl:attribute name="id">NSO_045</axsl:attribute>
                    <axsl:attribute name="flag">fatal</axsl:attribute>
                    <axsl:attribute name="location">
                        <axsl:apply-templates select="." mode="schematron-select-full-path"/>
                    </axsl:attribute>
                    <svrl:text>
                        NSO_045 – The Document contains more than one "cac:OrderDocumentReference" element.
                    </svrl:text>
                </svrl:failed-assert>
            </axsl:otherwise>
        </axsl:choose>
        <axsl:variable name="INIZ" select="if ($tipologia_ordine_ristretta = 'INIZ') then true() else false()"/>
        <axsl:variable name="CONN" select="if ($tipologia_ordine_ristretta = 'CONN') then true() else false()"/>
        <axsl:variable name="SOST" select="if ($tipologia_ordine_ristretta = 'SOST') then true() else false()"/>
        <axsl:variable name="CANC" select="if ($tipologia_ordine_ristretta = 'CANC') then true() else false()"/>
        <axsl:variable name="CONF" select="if ($tipologia_ordine_ristretta = 'CONF') then true() else false()"/>
        <axsl:variable name="INVO" select="if ($tipologia_ordine_ristretta = 'INVO') then true() else false()"/>

        <!--ASSERT -->

        <axsl:choose>
            <axsl:when test=" not( (u:is($CONF) or u:is($CANC)) and (count(cbc:Note) != 0)) "/>
            <axsl:otherwise>
                <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                    test="not( (u:is($CONF) or u:is($CANC)) and (count(cbc:Note) != 0))">
                    <axsl:attribute name="id">NSO_051</axsl:attribute>
                    <axsl:attribute name="flag">fatal</axsl:attribute>
                    <axsl:attribute name="location">
                        <axsl:apply-templates select="." mode="schematron-select-full-path"/>
                    </axsl:attribute>
                    <svrl:text>NSO_051 – The order line contains not allowed elements (the only element allowed is
                        "LineItem").
                    </svrl:text>
                </svrl:failed-assert>
            </axsl:otherwise>
        </axsl:choose>
        <axsl:apply-templates select="@*|*" mode="M40"/>
    </axsl:template>

    <!--RULE -->

    <axsl:template match="/ubl:Order/cac:OrderLine/cac:LineItem" priority="1000" mode="M40">
        <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="/ubl:Order/cac:OrderLine/cac:LineItem"/>
        <axsl:variable name="tipologia_ordine_ristretta"
                       select="         if (/ubl:Order/cac:OrderDocumentReference)      then     (         if (count(/ubl:Order/cac:OrderDocumentReference) = 1)       then        (        u:tipoOrdine(/ubl:Order/cac:OrderDocumentReference/cbc:ID)       )       else        (        'ERRORE_NSO45'       )     )     else     (       'INIZ'     )         "/>

        <!--ASSERT -->

        <axsl:choose>
            <axsl:when test="if ($tipologia_ordine_ristretta = 'ERRORE_NSO40') then false() else true()"/>
            <axsl:otherwise>
                <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                    test="if ($tipologia_ordine_ristretta = 'ERRORE_NSO40') then false() else true()">
                    <axsl:attribute name="id">NSO_040</axsl:attribute>
                    <axsl:attribute name="flag">fatal</axsl:attribute>
                    <axsl:attribute name="location">
                        <axsl:apply-templates select="." mode="schematron-select-full-path"/>
                    </axsl:attribute>
                    <svrl:text>
                        NSO_040 - The format of the element "cac:OrderDocumentReference/cbc:ID" is invalid (correct
                        format example: "110#2018-01-30#aaaaaa#Revised").
                    </svrl:text>
                </svrl:failed-assert>
            </axsl:otherwise>
        </axsl:choose>

        <!--ASSERT -->

        <axsl:choose>
            <axsl:when test="if ($tipologia_ordine_ristretta = 'ERRORE') then false() else true()"/>
            <axsl:otherwise>
                <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                    test="if ($tipologia_ordine_ristretta = 'ERRORE') then false() else true()">
                    <axsl:attribute name="id">NSO_044</axsl:attribute>
                    <axsl:attribute name="flag">fatal</axsl:attribute>
                    <axsl:attribute name="location">
                        <axsl:apply-templates select="." mode="schematron-select-full-path"/>
                    </axsl:attribute>
                    <svrl:text>
                        NSO_044 - In the element "cac:OrderDocumentReference/cbc:ID" the ReferenceType is invalid (the
                        allowed values are: "Connected", "Accepted", "Cancelled", "Revised", "Invoice").
                    </svrl:text>
                </svrl:failed-assert>
            </axsl:otherwise>
        </axsl:choose>

        <!--ASSERT -->

        <axsl:choose>
            <axsl:when test="if ($tipologia_ordine_ristretta = 'ERRORE_NSO45') then false() else true()"/>
            <axsl:otherwise>
                <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                    test="if ($tipologia_ordine_ristretta = 'ERRORE_NSO45') then false() else true()">
                    <axsl:attribute name="id">NSO_045</axsl:attribute>
                    <axsl:attribute name="flag">fatal</axsl:attribute>
                    <axsl:attribute name="location">
                        <axsl:apply-templates select="." mode="schematron-select-full-path"/>
                    </axsl:attribute>
                    <svrl:text>
                        NSO_045 – The Document contains more than one "cac:OrderDocumentReference" element.
                    </svrl:text>
                </svrl:failed-assert>
            </axsl:otherwise>
        </axsl:choose>
        <axsl:variable name="INIZ" select="if ($tipologia_ordine_ristretta = 'INIZ') then true() else false()"/>
        <axsl:variable name="CONN" select="if ($tipologia_ordine_ristretta = 'CONN') then true() else false()"/>
        <axsl:variable name="SOST" select="if ($tipologia_ordine_ristretta = 'SOST') then true() else false()"/>
        <axsl:variable name="CANC" select="if ($tipologia_ordine_ristretta = 'CANC') then true() else false()"/>
        <axsl:variable name="CONF" select="if ($tipologia_ordine_ristretta = 'CONF') then true() else false()"/>
        <axsl:variable name="INVO" select="if ($tipologia_ordine_ristretta = 'INVO') then true() else false()"/>

        <!--ASSERT -->

        <axsl:choose>
            <axsl:when test=" not( (u:is($CONF) or u:is($CANC)) and (cbc:ID != 'NA')) "/>
            <axsl:otherwise>
                <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                    test="not( (u:is($CONF) or u:is($CANC)) and (cbc:ID != 'NA'))">
                    <axsl:attribute name="id">NSO_053</axsl:attribute>
                    <axsl:attribute name="flag">fatal</axsl:attribute>
                    <axsl:attribute name="location">
                        <axsl:apply-templates select="." mode="schematron-select-full-path"/>
                    </axsl:attribute>
                    <svrl:text>NSO_053 - The value specified in the element is not allowed (the correct value is "NA").
                    </svrl:text>
                </svrl:failed-assert>
            </axsl:otherwise>
        </axsl:choose>

        <!--ASSERT -->

        <axsl:choose>
            <axsl:when test=" not( (u:is($CONF) or u:is($CANC)) and (cbc:Quantity != '0')) "/>
            <axsl:otherwise>
                <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                    test="not( (u:is($CONF) or u:is($CANC)) and (cbc:Quantity != '0'))">
                    <axsl:attribute name="id">NSO_054</axsl:attribute>
                    <axsl:attribute name="flag">fatal</axsl:attribute>
                    <axsl:attribute name="location">
                        <axsl:apply-templates select="." mode="schematron-select-full-path"/>
                    </axsl:attribute>
                    <svrl:text>NSO_054 - The value specified in the element is not allowed (the correct value is "0").
                    </svrl:text>
                </svrl:failed-assert>
            </axsl:otherwise>
        </axsl:choose>

        <!--ASSERT -->

        <axsl:choose>
            <axsl:when test=" not( (u:is($CONF) or u:is($CANC)) and (cac:Item/cbc:Name != 'NA')) "/>
            <axsl:otherwise>
                <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                    test="not( (u:is($CONF) or u:is($CANC)) and (cac:Item/cbc:Name != 'NA'))">
                    <axsl:attribute name="id">NSO_056</axsl:attribute>
                    <axsl:attribute name="flag">fatal</axsl:attribute>
                    <axsl:attribute name="location">
                        <axsl:apply-templates select="." mode="schematron-select-full-path"/>
                    </axsl:attribute>
                    <svrl:text>NSO_056 - The value specified in the element is not allowed (the correct value is "NA").
                    </svrl:text>
                </svrl:failed-assert>
            </axsl:otherwise>
        </axsl:choose>

        <!--ASSERT -->

        <axsl:choose>
            <axsl:when
                    test=" not( (u:is($CONF) or u:is($CANC)) and        (      cbc:LineExtensionAmount         or cbc:PartialDeliveryIndicator          or cbc:AccountingCost          or cac:Delivery          or cac:OriginatorParty          or cac:AllowanceCharge          or cac:Item/cbc:Description          or cac:Item/cac:BuyersItemIdentification          or cac:Item/cac:SellersItemIdentification          or cac:Item/cac:StandardItemIdentification          or cac:Item/cac:ItemSpecificationDocumentReference          or cac:Item/cac:CommodityClassification          or cac:Item/cac:ClassifiedTaxCategory          or cac:Item/cac:AdditionalItemProperty          or cac:Item/cac:ItemInstance         or cac:Price)        ) "/>
            <axsl:otherwise>
                <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                    test="not( (u:is($CONF) or u:is($CANC)) and ( cbc:LineExtensionAmount or cbc:PartialDeliveryIndicator or cbc:AccountingCost or cac:Delivery or cac:OriginatorParty or cac:AllowanceCharge or cac:Item/cbc:Description or cac:Item/cac:BuyersItemIdentification or cac:Item/cac:SellersItemIdentification or cac:Item/cac:StandardItemIdentification or cac:Item/cac:ItemSpecificationDocumentReference or cac:Item/cac:CommodityClassification or cac:Item/cac:ClassifiedTaxCategory or cac:Item/cac:AdditionalItemProperty or cac:Item/cac:ItemInstance or cac:Price) )">
                    <axsl:attribute name="id">NSO_052</axsl:attribute>
                    <axsl:attribute name="flag">fatal</axsl:attribute>
                    <axsl:attribute name="location">
                        <axsl:apply-templates select="." mode="schematron-select-full-path"/>
                    </axsl:attribute>
                    <svrl:text>NSO_052 - The order line contains elements that are not allowed within "LineItem" (the
                        allowed elements are: "ID", "Quantity", "Name").
                    </svrl:text>
                </svrl:failed-assert>
            </axsl:otherwise>
        </axsl:choose>
        <axsl:apply-templates select="@*|*" mode="M40"/>
    </axsl:template>
    <axsl:template match="text()" priority="-1" mode="M40"/>
    <axsl:template match="@*|node()" priority="-2" mode="M40">
        <axsl:apply-templates select="@*|*" mode="M40"/>
    </axsl:template>

    <!--PATTERN verificaCIG-->


    <!--RULE -->

    <axsl:template match="/ubl:Order" priority="1002" mode="M41">
        <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="/ubl:Order"/>
        <axsl:variable name="tipologia_ordine_ristretta"
                       select="         if (/ubl:Order/cac:OrderDocumentReference)      then     (         if (count(/ubl:Order/cac:OrderDocumentReference) = 1)       then        (        u:tipoOrdine(/ubl:Order/cac:OrderDocumentReference/cbc:ID)       )       else        (        'ERRORE_NSO45'       )     )     else     (       'INIZ'     )         "/>

        <!--ASSERT -->

        <axsl:choose>
            <axsl:when test="if ($tipologia_ordine_ristretta = 'ERRORE_NSO40') then false() else true()"/>
            <axsl:otherwise>
                <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                    test="if ($tipologia_ordine_ristretta = 'ERRORE_NSO40') then false() else true()">
                    <axsl:attribute name="id">NSO_040</axsl:attribute>
                    <axsl:attribute name="flag">fatal</axsl:attribute>
                    <axsl:attribute name="location">
                        <axsl:apply-templates select="." mode="schematron-select-full-path"/>
                    </axsl:attribute>
                    <svrl:text>
                        NSO_040 - The format of the element "cac:OrderDocumentReference/cbc:ID" is invalid (correct
                        format example: "110#2018-01-30#aaaaaa#Revised").
                    </svrl:text>
                </svrl:failed-assert>
            </axsl:otherwise>
        </axsl:choose>

        <!--ASSERT -->

        <axsl:choose>
            <axsl:when test="if ($tipologia_ordine_ristretta = 'ERRORE') then false() else true()"/>
            <axsl:otherwise>
                <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                    test="if ($tipologia_ordine_ristretta = 'ERRORE') then false() else true()">
                    <axsl:attribute name="id">NSO_044</axsl:attribute>
                    <axsl:attribute name="flag">fatal</axsl:attribute>
                    <axsl:attribute name="location">
                        <axsl:apply-templates select="." mode="schematron-select-full-path"/>
                    </axsl:attribute>
                    <svrl:text>
                        NSO_044 - In the element "cac:OrderDocumentReference/cbc:ID" the ReferenceType is invalid (the
                        allowed values are: "Connected", "Accepted", "Cancelled", "Revised", "Invoice").
                    </svrl:text>
                </svrl:failed-assert>
            </axsl:otherwise>
        </axsl:choose>

        <!--ASSERT -->

        <axsl:choose>
            <axsl:when test="if ($tipologia_ordine_ristretta = 'ERRORE_NSO45') then false() else true()"/>
            <axsl:otherwise>
                <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                    test="if ($tipologia_ordine_ristretta = 'ERRORE_NSO45') then false() else true()">
                    <axsl:attribute name="id">NSO_045</axsl:attribute>
                    <axsl:attribute name="flag">fatal</axsl:attribute>
                    <axsl:attribute name="location">
                        <axsl:apply-templates select="." mode="schematron-select-full-path"/>
                    </axsl:attribute>
                    <svrl:text>
                        NSO_045 – The Document contains more than one "cac:OrderDocumentReference" element.
                    </svrl:text>
                </svrl:failed-assert>
            </axsl:otherwise>
        </axsl:choose>
        <axsl:variable name="INIZ" select="if ($tipologia_ordine_ristretta = 'INIZ') then true() else false()"/>
        <axsl:variable name="CONN" select="if ($tipologia_ordine_ristretta = 'CONN') then true() else false()"/>
        <axsl:variable name="SOST" select="if ($tipologia_ordine_ristretta = 'SOST') then true() else false()"/>
        <axsl:variable name="CANC" select="if ($tipologia_ordine_ristretta = 'CANC') then true() else false()"/>
        <axsl:variable name="CONF" select="if ($tipologia_ordine_ristretta = 'CONF') then true() else false()"/>
        <axsl:variable name="INVO" select="if ($tipologia_ordine_ristretta = 'INVO') then true() else false()"/>

        <!--ASSERT -->

        <axsl:choose>
            <axsl:when
                    test="not( (u:is($INIZ) or u:is($CONN) or u:is($SOST) or u:is($INVO)) and ( if ( not (/ubl:Order/cac:OriginatorDocumentReference) and ( string-join(u:checkCIGLineaAlg(/ubl:Order/cac:OrderLine/cac:LineItem),'') eq '') ) then true() else false() ) )"/>
            <axsl:otherwise>
                <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                    test="not( (u:is($INIZ) or u:is($CONN) or u:is($SOST) or u:is($INVO)) and ( if ( not (/ubl:Order/cac:OriginatorDocumentReference) and ( string-join(u:checkCIGLineaAlg(/ubl:Order/cac:OrderLine/cac:LineItem),'') eq '') ) then true() else false() ) )">
                    <axsl:attribute name="id">NSO_061</axsl:attribute>
                    <axsl:attribute name="flag">fatal</axsl:attribute>
                    <axsl:attribute name="location">
                        <axsl:apply-templates select="." mode="schematron-select-full-path"/>
                    </axsl:attribute>
                    <svrl:text>NSO_061 - The Tender Identification Code (CIG) or the Exemption Code is not present at
                        the entire document level or in all order lines, or is present in both levels simultaneously.
                    </svrl:text>
                </svrl:failed-assert>
            </axsl:otherwise>
        </axsl:choose>

        <!--ASSERT -->

        <axsl:choose>
            <axsl:when
                    test="not( (u:is($INIZ) or u:is($CONN) or u:is($SOST) or u:is($INVO)) and ( if ( (/ubl:Order/cac:OriginatorDocumentReference) and  (string-length(string-join(distinct-values(u:checkCIGLineaAlg(/ubl:Order/cac:OrderLine/cac:LineItem)),'')) != 0 )) then true() else false() ) )"/>
            <axsl:otherwise>
                <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                    test="not( (u:is($INIZ) or u:is($CONN) or u:is($SOST) or u:is($INVO)) and ( if ( (/ubl:Order/cac:OriginatorDocumentReference) and (string-length(string-join(distinct-values(u:checkCIGLineaAlg(/ubl:Order/cac:OrderLine/cac:LineItem)),'')) != 0 )) then true() else false() ) )">
                    <axsl:attribute name="id">NSO_061</axsl:attribute>
                    <axsl:attribute name="flag">fatal</axsl:attribute>
                    <axsl:attribute name="location">
                        <axsl:apply-templates select="." mode="schematron-select-full-path"/>
                    </axsl:attribute>
                    <svrl:text>NSO_061 - The Tender Identification Code (CIG) or the Exemption Code is not present at
                        the entire document level or in all order lines, or is present in both levels simultaneously.
                    </svrl:text>
                </svrl:failed-assert>
            </axsl:otherwise>
        </axsl:choose>

        <!--ASSERT -->

        <axsl:choose>
            <axsl:when
                    test="not( (u:is($INIZ) or u:is($CONN) or u:is($SOST) or u:is($INVO)) and ( if ( not (/ubl:Order/cac:OriginatorDocumentReference) and not ( (count(/ubl:Order/cac:OrderLine)*4) = string-length(string-join(distinct-values(u:checkCIGLineaAlg(/ubl:Order/cac:OrderLine/cac:LineItem)),'')) )  )  then true() else false() ) )"/>
            <axsl:otherwise>
                <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                    test="not( (u:is($INIZ) or u:is($CONN) or u:is($SOST) or u:is($INVO)) and ( if ( not (/ubl:Order/cac:OriginatorDocumentReference) and not ( (count(/ubl:Order/cac:OrderLine)*4) = string-length(string-join(distinct-values(u:checkCIGLineaAlg(/ubl:Order/cac:OrderLine/cac:LineItem)),'')) ) ) then true() else false() ) )">
                    <axsl:attribute name="id">NSO_061</axsl:attribute>
                    <axsl:attribute name="flag">fatal</axsl:attribute>
                    <axsl:attribute name="location">
                        <axsl:apply-templates select="." mode="schematron-select-full-path"/>
                    </axsl:attribute>
                    <svrl:text>NSO_061 - The Tender Identification Code (CIG) or the Exemption Code is not present at
                        the entire document level or in all order lines, or is present in both levels simultaneously.
                    </svrl:text>
                </svrl:failed-assert>
            </axsl:otherwise>
        </axsl:choose>

        <!--ASSERT -->

        <axsl:choose>
            <axsl:when
                    test="not( (u:is($INIZ) or u:is($CONN) or u:is($SOST) or u:is($INVO)) and ( not (u:checkCIGLinea(/ubl:Order/cac:OrderLine/cac:LineItem)) ) )"/>
            <axsl:otherwise>
                <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                    test="not( (u:is($INIZ) or u:is($CONN) or u:is($SOST) or u:is($INVO)) and ( not (u:checkCIGLinea(/ubl:Order/cac:OrderLine/cac:LineItem)) ) )">
                    <axsl:attribute name="id">NSO_062</axsl:attribute>
                    <axsl:attribute name="flag">fatal</axsl:attribute>
                    <axsl:attribute name="location">
                        <axsl:apply-templates select="." mode="schematron-select-full-path"/>
                    </axsl:attribute>
                    <svrl:text>NSO_062 – One or more order lines contain more than one Tender Identification Code (CIG)
                        or Exemption Code.
                    </svrl:text>
                </svrl:failed-assert>
            </axsl:otherwise>
        </axsl:choose>
        <axsl:apply-templates select="@*|*" mode="M41"/>
    </axsl:template>

    <!--RULE -->

    <axsl:template match="/ubl:Order/cac:OriginatorDocumentReference" priority="1001" mode="M41">
        <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                         context="/ubl:Order/cac:OriginatorDocumentReference"/>
        <axsl:variable name="tipologia_ordine_ristretta"
                       select="         if (/ubl:Order/cac:OrderDocumentReference)      then     (         if (count(/ubl:Order/cac:OrderDocumentReference) = 1)       then        (        u:tipoOrdine(/ubl:Order/cac:OrderDocumentReference/cbc:ID)       )       else        (        'ERRORE_NSO45'       )     )     else     (       'INIZ'     )         "/>

        <!--ASSERT -->

        <axsl:choose>
            <axsl:when test="if ($tipologia_ordine_ristretta = 'ERRORE_NSO40') then false() else true()"/>
            <axsl:otherwise>
                <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                    test="if ($tipologia_ordine_ristretta = 'ERRORE_NSO40') then false() else true()">
                    <axsl:attribute name="id">NSO_040</axsl:attribute>
                    <axsl:attribute name="flag">fatal</axsl:attribute>
                    <axsl:attribute name="location">
                        <axsl:apply-templates select="." mode="schematron-select-full-path"/>
                    </axsl:attribute>
                    <svrl:text>
                        NSO_040 - The format of the element "cac:OrderDocumentReference/cbc:ID" is invalid (correct
                        format example: "110#2018-01-30#aaaaaa#Revised").
                    </svrl:text>
                </svrl:failed-assert>
            </axsl:otherwise>
        </axsl:choose>

        <!--ASSERT -->

        <axsl:choose>
            <axsl:when test="if ($tipologia_ordine_ristretta = 'ERRORE') then false() else true()"/>
            <axsl:otherwise>
                <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                    test="if ($tipologia_ordine_ristretta = 'ERRORE') then false() else true()">
                    <axsl:attribute name="id">NSO_044</axsl:attribute>
                    <axsl:attribute name="flag">fatal</axsl:attribute>
                    <axsl:attribute name="location">
                        <axsl:apply-templates select="." mode="schematron-select-full-path"/>
                    </axsl:attribute>
                    <svrl:text>
                        NSO_044 - In the element "cac:OrderDocumentReference/cbc:ID" the ReferenceType is invalid (the
                        allowed values are: "Connected", "Accepted", "Cancelled", "Revised", "Invoice").
                    </svrl:text>
                </svrl:failed-assert>
            </axsl:otherwise>
        </axsl:choose>

        <!--ASSERT -->

        <axsl:choose>
            <axsl:when test="if ($tipologia_ordine_ristretta = 'ERRORE_NSO45') then false() else true()"/>
            <axsl:otherwise>
                <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                    test="if ($tipologia_ordine_ristretta = 'ERRORE_NSO45') then false() else true()">
                    <axsl:attribute name="id">NSO_045</axsl:attribute>
                    <axsl:attribute name="flag">fatal</axsl:attribute>
                    <axsl:attribute name="location">
                        <axsl:apply-templates select="." mode="schematron-select-full-path"/>
                    </axsl:attribute>
                    <svrl:text>
                        NSO_045 – The Document contains more than one "cac:OrderDocumentReference" element.
                    </svrl:text>
                </svrl:failed-assert>
            </axsl:otherwise>
        </axsl:choose>
        <axsl:variable name="INIZ" select="if ($tipologia_ordine_ristretta = 'INIZ') then true() else false()"/>
        <axsl:variable name="CONN" select="if ($tipologia_ordine_ristretta = 'CONN') then true() else false()"/>
        <axsl:variable name="SOST" select="if ($tipologia_ordine_ristretta = 'SOST') then true() else false()"/>
        <axsl:variable name="CANC" select="if ($tipologia_ordine_ristretta = 'CANC') then true() else false()"/>
        <axsl:variable name="CONF" select="if ($tipologia_ordine_ristretta = 'CONF') then true() else false()"/>
        <axsl:variable name="INVO" select="if ($tipologia_ordine_ristretta = 'INVO') then true() else false()"/>

        <!--ASSERT -->

        <axsl:choose>
            <axsl:when
                    test="not( (u:is($INIZ) or u:is($CONN) or u:is($SOST) or u:is($CANC) or u:is($INVO)) and ( u:verificaCIG(cbc:ID) ) )"/>
            <axsl:otherwise>
                <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                    test="not( (u:is($INIZ) or u:is($CONN) or u:is($SOST) or u:is($CANC) or u:is($INVO)) and ( u:verificaCIG(cbc:ID) ) )">
                    <axsl:attribute name="id">NSO_060</axsl:attribute>
                    <axsl:attribute name="flag">fatal</axsl:attribute>
                    <axsl:attribute name="location">
                        <axsl:apply-templates select="." mode="schematron-select-full-path"/>
                    </axsl:attribute>
                    <svrl:text>NSO_060 - The Tender Identification Code (CIG or Smart CIG) or the Exemption Code
                        specified in the element is invalid.
                    </svrl:text>
                </svrl:failed-assert>
            </axsl:otherwise>
        </axsl:choose>
        <axsl:apply-templates select="@*|*" mode="M41"/>
    </axsl:template>

    <!--RULE -->

    <axsl:template match="/ubl:Order/cac:OrderLine/cac:LineItem/cac:Item/cac:ItemSpecificationDocumentReference"
                   priority="1000" mode="M41">
        <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                         context="/ubl:Order/cac:OrderLine/cac:LineItem/cac:Item/cac:ItemSpecificationDocumentReference"/>
        <axsl:variable name="tipologia_ordine_ristretta"
                       select="         if (/ubl:Order/cac:OrderDocumentReference)      then     (         if (count(/ubl:Order/cac:OrderDocumentReference) = 1)       then        (        u:tipoOrdine(/ubl:Order/cac:OrderDocumentReference/cbc:ID)       )       else        (        'ERRORE_NSO45'       )     )     else     (       'INIZ'     )         "/>

        <!--ASSERT -->

        <axsl:choose>
            <axsl:when test="if ($tipologia_ordine_ristretta = 'ERRORE_NSO40') then false() else true()"/>
            <axsl:otherwise>
                <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                    test="if ($tipologia_ordine_ristretta = 'ERRORE_NSO40') then false() else true()">
                    <axsl:attribute name="id">NSO_040</axsl:attribute>
                    <axsl:attribute name="flag">fatal</axsl:attribute>
                    <axsl:attribute name="location">
                        <axsl:apply-templates select="." mode="schematron-select-full-path"/>
                    </axsl:attribute>
                    <svrl:text>
                        NSO_040 - The format of the element "cac:OrderDocumentReference/cbc:ID" is invalid (correct
                        format example: "110#2018-01-30#aaaaaa#Revised").
                    </svrl:text>
                </svrl:failed-assert>
            </axsl:otherwise>
        </axsl:choose>

        <!--ASSERT -->

        <axsl:choose>
            <axsl:when test="if ($tipologia_ordine_ristretta = 'ERRORE') then false() else true()"/>
            <axsl:otherwise>
                <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                    test="if ($tipologia_ordine_ristretta = 'ERRORE') then false() else true()">
                    <axsl:attribute name="id">NSO_044</axsl:attribute>
                    <axsl:attribute name="flag">fatal</axsl:attribute>
                    <axsl:attribute name="location">
                        <axsl:apply-templates select="." mode="schematron-select-full-path"/>
                    </axsl:attribute>
                    <svrl:text>
                        NSO_044 - In the element "cac:OrderDocumentReference/cbc:ID" the ReferenceType is invalid (the
                        allowed values are: "Connected", "Accepted", "Cancelled", "Revised", "Invoice").
                    </svrl:text>
                </svrl:failed-assert>
            </axsl:otherwise>
        </axsl:choose>

        <!--ASSERT -->

        <axsl:choose>
            <axsl:when test="if ($tipologia_ordine_ristretta = 'ERRORE_NSO45') then false() else true()"/>
            <axsl:otherwise>
                <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                    test="if ($tipologia_ordine_ristretta = 'ERRORE_NSO45') then false() else true()">
                    <axsl:attribute name="id">NSO_045</axsl:attribute>
                    <axsl:attribute name="flag">fatal</axsl:attribute>
                    <axsl:attribute name="location">
                        <axsl:apply-templates select="." mode="schematron-select-full-path"/>
                    </axsl:attribute>
                    <svrl:text>
                        NSO_045 – The Document contains more than one "cac:OrderDocumentReference" element.
                    </svrl:text>
                </svrl:failed-assert>
            </axsl:otherwise>
        </axsl:choose>
        <axsl:variable name="INIZ" select="if ($tipologia_ordine_ristretta = 'INIZ') then true() else false()"/>
        <axsl:variable name="CONN" select="if ($tipologia_ordine_ristretta = 'CONN') then true() else false()"/>
        <axsl:variable name="SOST" select="if ($tipologia_ordine_ristretta = 'SOST') then true() else false()"/>
        <axsl:variable name="CANC" select="if ($tipologia_ordine_ristretta = 'CANC') then true() else false()"/>
        <axsl:variable name="CONF" select="if ($tipologia_ordine_ristretta = 'CONF') then true() else false()"/>
        <axsl:variable name="INVO" select="if ($tipologia_ordine_ristretta = 'INVO') then true() else false()"/>

        <!--ASSERT -->

        <axsl:choose>
            <axsl:when
                    test="not( (u:is($INIZ) or u:is($CONN) or u:is($SOST) or u:is($CANC) or u:is($INVO)) and ( u:verificaCIG(cbc:ID) ) )"/>
            <axsl:otherwise>
                <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                    test="not( (u:is($INIZ) or u:is($CONN) or u:is($SOST) or u:is($CANC) or u:is($INVO)) and ( u:verificaCIG(cbc:ID) ) )">
                    <axsl:attribute name="id">NSO_060</axsl:attribute>
                    <axsl:attribute name="flag">fatal</axsl:attribute>
                    <axsl:attribute name="location">
                        <axsl:apply-templates select="." mode="schematron-select-full-path"/>
                    </axsl:attribute>
                    <svrl:text>NSO_060 - The Tender Identification Code (CIG or Smart CIG) or the Exemption Code
                        specified in the element is invalid.
                    </svrl:text>
                </svrl:failed-assert>
            </axsl:otherwise>
        </axsl:choose>
        <axsl:apply-templates select="@*|*" mode="M41"/>
    </axsl:template>
    <axsl:template match="text()" priority="-1" mode="M41"/>
    <axsl:template match="@*|node()" priority="-2" mode="M41">
        <axsl:apply-templates select="@*|*" mode="M41"/>
    </axsl:template>

    <!--PATTERN verificaPIVA-->


    <!--RULE -->

    <axsl:template match="/ubl:Order/cac:SellerSupplierParty/cac:Party/cbc:EndpointID" priority="1003" mode="M42">
        <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                         context="/ubl:Order/cac:SellerSupplierParty/cac:Party/cbc:EndpointID"/>

        <!--ASSERT -->

        <axsl:choose>
            <axsl:when test="if(@schemeID='9906') then u:checkPIVAseIT(.) else true() "/>
            <axsl:otherwise>
                <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                    test="if(@schemeID='9906') then u:checkPIVAseIT(.) else true()">
                    <axsl:attribute name="id">NSO_030</axsl:attribute>
                    <axsl:attribute name="flag">fatal</axsl:attribute>
                    <axsl:attribute name="location">
                        <axsl:apply-templates select="." mode="schematron-select-full-path"/>
                    </axsl:attribute>
                    <svrl:text>NSO_030 - The VAT number specified in the element is invalid is not valid.
                    </svrl:text>
                </svrl:failed-assert>
            </axsl:otherwise>
        </axsl:choose>
        <axsl:apply-templates select="@*|*" mode="M42"/>
    </axsl:template>

    <!--RULE -->

    <axsl:template match="/ubl:Order/cac:BuyerCustomerParty/cac:Party/cac:PartyTaxScheme/cbc:CompanyID" priority="1002"
                   mode="M42">
        <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                         context="/ubl:Order/cac:BuyerCustomerParty/cac:Party/cac:PartyTaxScheme/cbc:CompanyID"/>

        <!--ASSERT -->

        <axsl:choose>
            <axsl:when
                    test="if(u:checkPIVAseIT(.)) then (if (upper-case(substring(.,1,2)) != 'IT') then u:checkCF11(.) else true()) else false()"/>
            <axsl:otherwise>
                <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                    test="if(u:checkPIVAseIT(.)) then (if (upper-case(substring(.,1,2)) != 'IT') then u:checkCF11(.) else true()) else false()">
                    <axsl:attribute name="id">NSO_030</axsl:attribute>
                    <axsl:attribute name="flag">fatal</axsl:attribute>
                    <axsl:attribute name="location">
                        <axsl:apply-templates select="." mode="schematron-select-full-path"/>
                    </axsl:attribute>
                    <svrl:text>NSO_030 - The VAT number specified in the element is invalid is not valid.
                    </svrl:text>
                </svrl:failed-assert>
            </axsl:otherwise>
        </axsl:choose>
        <axsl:apply-templates select="@*|*" mode="M42"/>
    </axsl:template>

    <!--RULE -->

    <axsl:template match="/ubl:Order/cac:AccountingCustomerParty/cac:Party/cbc:EndpointID" priority="1001" mode="M42">
        <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                         context="/ubl:Order/cac:AccountingCustomerParty/cac:Party/cbc:EndpointID"/>

        <!--ASSERT -->

        <axsl:choose>
            <axsl:when test="if(@schemeID='9906') then u:checkPIVAseIT(.) else true() "/>
            <axsl:otherwise>
                <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                    test="if(@schemeID='9906') then u:checkPIVAseIT(.) else true()">
                    <axsl:attribute name="id">NSO_030</axsl:attribute>
                    <axsl:attribute name="flag">fatal</axsl:attribute>
                    <axsl:attribute name="location">
                        <axsl:apply-templates select="." mode="schematron-select-full-path"/>
                    </axsl:attribute>
                    <svrl:text>NSO_030 - The VAT number specified in the element is invalid is not valid.
                    </svrl:text>
                </svrl:failed-assert>
            </axsl:otherwise>
        </axsl:choose>
        <axsl:apply-templates select="@*|*" mode="M42"/>
    </axsl:template>

    <!--RULE -->

    <axsl:template match="/ubl:Order/cac:AccountingCustomerParty/cac:Party/cac:PartyTaxScheme/cbc:CompanyID"
                   priority="1000" mode="M42">
        <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                         context="/ubl:Order/cac:AccountingCustomerParty/cac:Party/cac:PartyTaxScheme/cbc:CompanyID"/>

        <!--ASSERT -->

        <axsl:choose>
            <axsl:when
                    test="if(u:checkPIVAseIT(.)) then (if (upper-case(substring(.,1,2)) != 'IT') then u:checkCF11(.) else true()) else false()"/>
            <axsl:otherwise>
                <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                    test="if(u:checkPIVAseIT(.)) then (if (upper-case(substring(.,1,2)) != 'IT') then u:checkCF11(.) else true()) else false()">
                    <axsl:attribute name="id">NSO_030</axsl:attribute>
                    <axsl:attribute name="flag">fatal</axsl:attribute>
                    <axsl:attribute name="location">
                        <axsl:apply-templates select="." mode="schematron-select-full-path"/>
                    </axsl:attribute>
                    <svrl:text>NSO_030 - The VAT number specified in the element is invalid is not valid.
                    </svrl:text>
                </svrl:failed-assert>
            </axsl:otherwise>
        </axsl:choose>
        <axsl:apply-templates select="@*|*" mode="M42"/>
    </axsl:template>
    <axsl:template match="text()" priority="-1" mode="M42"/>
    <axsl:template match="@*|node()" priority="-2" mode="M42">
        <axsl:apply-templates select="@*|*" mode="M42"/>
    </axsl:template>

    <!--PATTERN verificaCodiceIPA-->


    <!--RULE -->

    <axsl:template match="/ubl:Order/cac:BuyerCustomerParty/cac:Party/cac:PartyIdentification/cbc:ID" priority="1013"
                   mode="M43">
        <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                         context="/ubl:Order/cac:BuyerCustomerParty/cac:Party/cac:PartyIdentification/cbc:ID"/>

        <!--ASSERT -->

        <axsl:choose>
            <axsl:when test="if(@schemeID='0201') then u:checkCodiceIPA(.) else true()"/>
            <axsl:otherwise>
                <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                    test="if(@schemeID='0201') then u:checkCodiceIPA(.) else true()">
                    <axsl:attribute name="id">NSO_010</axsl:attribute>
                    <axsl:attribute name="flag">fatal</axsl:attribute>
                    <axsl:attribute name="location">
                        <axsl:apply-templates select="." mode="schematron-select-full-path"/>
                    </axsl:attribute>
                    <svrl:text>NSO_010 – The IPA Code specified in the element is invalid.
                    </svrl:text>
                </svrl:failed-assert>
            </axsl:otherwise>
        </axsl:choose>
        <axsl:apply-templates select="@*|*" mode="M43"/>
    </axsl:template>

    <!--RULE -->

    <axsl:template match="/ubl:Order/cac:BuyerCustomerParty/cac:Party/cac:PartyLegalEntity/cbc:CompanyID"
                   priority="1012" mode="M43">
        <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                         context="/ubl:Order/cac:BuyerCustomerParty/cac:Party/cac:PartyLegalEntity/cbc:CompanyID"/>

        <!--ASSERT -->

        <axsl:choose>
            <axsl:when test="if(@schemeID='0201') then u:checkCodiceIPA(.) else true()"/>
            <axsl:otherwise>
                <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                    test="if(@schemeID='0201') then u:checkCodiceIPA(.) else true()">
                    <axsl:attribute name="id">NSO_010</axsl:attribute>
                    <axsl:attribute name="flag">fatal</axsl:attribute>
                    <axsl:attribute name="location">
                        <axsl:apply-templates select="." mode="schematron-select-full-path"/>
                    </axsl:attribute>
                    <svrl:text>NSO_010 – The IPA Code specified in the element is invalid.
                    </svrl:text>
                </svrl:failed-assert>
            </axsl:otherwise>
        </axsl:choose>
        <axsl:apply-templates select="@*|*" mode="M43"/>
    </axsl:template>

    <!--RULE -->

    <axsl:template match="/ubl:Order/cac:BuyerCustomerParty/cac:Party/cbc:EndpointID" priority="1011" mode="M43">
        <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                         context="/ubl:Order/cac:BuyerCustomerParty/cac:Party/cbc:EndpointID"/>

        <!--ASSERT -->

        <axsl:choose>
            <axsl:when test="if(@schemeID='0201') then u:checkCodiceIPA(.) else true()"/>
            <axsl:otherwise>
                <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                    test="if(@schemeID='0201') then u:checkCodiceIPA(.) else true()">
                    <axsl:attribute name="id">NSO_010</axsl:attribute>
                    <axsl:attribute name="flag">fatal</axsl:attribute>
                    <axsl:attribute name="location">
                        <axsl:apply-templates select="." mode="schematron-select-full-path"/>
                    </axsl:attribute>
                    <svrl:text>NSO_010 – The IPA Code specified in the element is invalid.
                    </svrl:text>
                </svrl:failed-assert>
            </axsl:otherwise>
        </axsl:choose>
        <axsl:apply-templates select="@*|*" mode="M43"/>
    </axsl:template>

    <!--RULE -->

    <axsl:template match="/ubl:Order/cac:SellerSupplierParty/cac:Party/cac:PartyIdentification/cbc:ID" priority="1010"
                   mode="M43">
        <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                         context="/ubl:Order/cac:SellerSupplierParty/cac:Party/cac:PartyIdentification/cbc:ID"/>

        <!--ASSERT -->

        <axsl:choose>
            <axsl:when test="if(@schemeID='0201') then u:checkCodiceIPA(.) else true()"/>
            <axsl:otherwise>
                <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                    test="if(@schemeID='0201') then u:checkCodiceIPA(.) else true()">
                    <axsl:attribute name="id">NSO_010</axsl:attribute>
                    <axsl:attribute name="flag">fatal</axsl:attribute>
                    <axsl:attribute name="location">
                        <axsl:apply-templates select="." mode="schematron-select-full-path"/>
                    </axsl:attribute>
                    <svrl:text>NSO_010 – The IPA Code specified in the element is invalid.
                    </svrl:text>
                </svrl:failed-assert>
            </axsl:otherwise>
        </axsl:choose>
        <axsl:apply-templates select="@*|*" mode="M43"/>
    </axsl:template>

    <!--RULE -->

    <axsl:template match="/ubl:Order/cac:SellerSupplierParty/cac:Party/cac:PartyLegalEntity/cbc:CompanyID"
                   priority="1009" mode="M43">
        <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                         context="/ubl:Order/cac:SellerSupplierParty/cac:Party/cac:PartyLegalEntity/cbc:CompanyID"/>

        <!--ASSERT -->

        <axsl:choose>
            <axsl:when test="if(@schemeID='0201') then u:checkCodiceIPA(.) else true()"/>
            <axsl:otherwise>
                <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                    test="if(@schemeID='0201') then u:checkCodiceIPA(.) else true()">
                    <axsl:attribute name="id">NSO_010</axsl:attribute>
                    <axsl:attribute name="flag">fatal</axsl:attribute>
                    <axsl:attribute name="location">
                        <axsl:apply-templates select="." mode="schematron-select-full-path"/>
                    </axsl:attribute>
                    <svrl:text>NSO_010 – The IPA Code specified in the element is invalid.
                    </svrl:text>
                </svrl:failed-assert>
            </axsl:otherwise>
        </axsl:choose>
        <axsl:apply-templates select="@*|*" mode="M43"/>
    </axsl:template>

    <!--RULE -->

    <axsl:template match="/ubl:Order/cac:SellerSupplierParty/cac:Party/cbc:EndpointID" priority="1008" mode="M43">
        <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                         context="/ubl:Order/cac:SellerSupplierParty/cac:Party/cbc:EndpointID"/>

        <!--ASSERT -->

        <axsl:choose>
            <axsl:when test="if(@schemeID='0201') then u:checkCodiceIPA(.) else true()"/>
            <axsl:otherwise>
                <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                    test="if(@schemeID='0201') then u:checkCodiceIPA(.) else true()">
                    <axsl:attribute name="id">NSO_010</axsl:attribute>
                    <axsl:attribute name="flag">fatal</axsl:attribute>
                    <axsl:attribute name="location">
                        <axsl:apply-templates select="." mode="schematron-select-full-path"/>
                    </axsl:attribute>
                    <svrl:text>NSO_010 – The IPA Code specified in the element is invalid.
                    </svrl:text>
                </svrl:failed-assert>
            </axsl:otherwise>
        </axsl:choose>
        <axsl:apply-templates select="@*|*" mode="M43"/>
    </axsl:template>

    <!--RULE -->

    <axsl:template match="/ubl:Order/cac:OriginatorCustomerParty/cac:Party/cac:PartyIdentification/cbc:ID"
                   priority="1007" mode="M43">
        <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                         context="/ubl:Order/cac:OriginatorCustomerParty/cac:Party/cac:PartyIdentification/cbc:ID"/>

        <!--ASSERT -->

        <axsl:choose>
            <axsl:when test="if(@schemeID='0201') then u:checkCodiceIPA(.) else true()"/>
            <axsl:otherwise>
                <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                    test="if(@schemeID='0201') then u:checkCodiceIPA(.) else true()">
                    <axsl:attribute name="id">NSO_010</axsl:attribute>
                    <axsl:attribute name="flag">fatal</axsl:attribute>
                    <axsl:attribute name="location">
                        <axsl:apply-templates select="." mode="schematron-select-full-path"/>
                    </axsl:attribute>
                    <svrl:text>NSO_010 – The IPA Code specified in the element is invalid.
                    </svrl:text>
                </svrl:failed-assert>
            </axsl:otherwise>
        </axsl:choose>
        <axsl:apply-templates select="@*|*" mode="M43"/>
    </axsl:template>

    <!--RULE -->

    <axsl:template match="/ubl:Order/cac:AccountingCustomerParty/cac:Party/cac:PartyIdentification/cbc:ID"
                   priority="1006" mode="M43">
        <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                         context="/ubl:Order/cac:AccountingCustomerParty/cac:Party/cac:PartyIdentification/cbc:ID"/>

        <!--ASSERT -->

        <axsl:choose>
            <axsl:when test="if(@schemeID='0201') then u:checkCodiceIPA(.) else true()"/>
            <axsl:otherwise>
                <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                    test="if(@schemeID='0201') then u:checkCodiceIPA(.) else true()">
                    <axsl:attribute name="id">NSO_010</axsl:attribute>
                    <axsl:attribute name="flag">fatal</axsl:attribute>
                    <axsl:attribute name="location">
                        <axsl:apply-templates select="." mode="schematron-select-full-path"/>
                    </axsl:attribute>
                    <svrl:text>NSO_010 – The IPA Code specified in the element is invalid.
                    </svrl:text>
                </svrl:failed-assert>
            </axsl:otherwise>
        </axsl:choose>
        <axsl:apply-templates select="@*|*" mode="M43"/>
    </axsl:template>

    <!--RULE -->

    <axsl:template match="/ubl:Order/cac:AccountingCustomerParty/cac:Party/cac:PartyLegalEntity/cbc:CompanyID"
                   priority="1005" mode="M43">
        <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                         context="/ubl:Order/cac:AccountingCustomerParty/cac:Party/cac:PartyLegalEntity/cbc:CompanyID"/>

        <!--ASSERT -->

        <axsl:choose>
            <axsl:when test="if(@schemeID='0201') then u:checkCodiceIPA(.) else true()"/>
            <axsl:otherwise>
                <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                    test="if(@schemeID='0201') then u:checkCodiceIPA(.) else true()">
                    <axsl:attribute name="id">NSO_010</axsl:attribute>
                    <axsl:attribute name="flag">fatal</axsl:attribute>
                    <axsl:attribute name="location">
                        <axsl:apply-templates select="." mode="schematron-select-full-path"/>
                    </axsl:attribute>
                    <svrl:text>NSO_010 – The IPA Code specified in the element is invalid.
                    </svrl:text>
                </svrl:failed-assert>
            </axsl:otherwise>
        </axsl:choose>
        <axsl:apply-templates select="@*|*" mode="M43"/>
    </axsl:template>

    <!--RULE -->

    <axsl:template match="/ubl:Order/cac:AccountingCustomerParty/cac:Party/cbc:EndpointID" priority="1004" mode="M43">
        <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                         context="/ubl:Order/cac:AccountingCustomerParty/cac:Party/cbc:EndpointID"/>

        <!--ASSERT -->

        <axsl:choose>
            <axsl:when test="if(@schemeID='0201') then u:checkCodiceIPA(.) else true()"/>
            <axsl:otherwise>
                <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                    test="if(@schemeID='0201') then u:checkCodiceIPA(.) else true()">
                    <axsl:attribute name="id">NSO_010</axsl:attribute>
                    <axsl:attribute name="flag">fatal</axsl:attribute>
                    <axsl:attribute name="location">
                        <axsl:apply-templates select="." mode="schematron-select-full-path"/>
                    </axsl:attribute>
                    <svrl:text>NSO_010 – The IPA Code specified in the element is invalid.
                    </svrl:text>
                </svrl:failed-assert>
            </axsl:otherwise>
        </axsl:choose>
        <axsl:apply-templates select="@*|*" mode="M43"/>
    </axsl:template>

    <!--RULE -->

    <axsl:template match="/ubl:Order/cac:Delivery/cac:DeliveryLocation/cbc:ID" priority="1003" mode="M43">
        <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                         context="/ubl:Order/cac:Delivery/cac:DeliveryLocation/cbc:ID"/>

        <!--ASSERT -->

        <axsl:choose>
            <axsl:when test="if(@schemeID='0201') then u:checkCodiceIPA(.) else true()"/>
            <axsl:otherwise>
                <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                    test="if(@schemeID='0201') then u:checkCodiceIPA(.) else true()">
                    <axsl:attribute name="id">NSO_010</axsl:attribute>
                    <axsl:attribute name="flag">fatal</axsl:attribute>
                    <axsl:attribute name="location">
                        <axsl:apply-templates select="." mode="schematron-select-full-path"/>
                    </axsl:attribute>
                    <svrl:text>NSO_010 – The IPA Code specified in the element is invalid.
                    </svrl:text>
                </svrl:failed-assert>
            </axsl:otherwise>
        </axsl:choose>
        <axsl:apply-templates select="@*|*" mode="M43"/>
    </axsl:template>

    <!--RULE -->

    <axsl:template match="/ubl:Order/cac:Delivery/cac:DeliveryParty/cac:PartyIdentification/cbc:ID" priority="1002"
                   mode="M43">
        <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                         context="/ubl:Order/cac:Delivery/cac:DeliveryParty/cac:PartyIdentification/cbc:ID"/>

        <!--ASSERT -->

        <axsl:choose>
            <axsl:when test="if(@schemeID='0201') then u:checkCodiceIPA(.) else true()"/>
            <axsl:otherwise>
                <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                    test="if(@schemeID='0201') then u:checkCodiceIPA(.) else true()">
                    <axsl:attribute name="id">NSO_010</axsl:attribute>
                    <axsl:attribute name="flag">fatal</axsl:attribute>
                    <axsl:attribute name="location">
                        <axsl:apply-templates select="." mode="schematron-select-full-path"/>
                    </axsl:attribute>
                    <svrl:text>NSO_010 – The IPA Code specified in the element is invalid.
                    </svrl:text>
                </svrl:failed-assert>
            </axsl:otherwise>
        </axsl:choose>
        <axsl:apply-templates select="@*|*" mode="M43"/>
    </axsl:template>

    <!--RULE -->

    <axsl:template match="/ubl:Order/cac:OrderLine/cac:LineItem/cac:OriginatorParty/cac:PartyIdentification/cbc:ID"
                   priority="1001" mode="M43">
        <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                         context="/ubl:Order/cac:OrderLine/cac:LineItem/cac:OriginatorParty/cac:PartyIdentification/cbc:ID"/>

        <!--ASSERT -->

        <axsl:choose>
            <axsl:when test="if(@schemeID='0201') then u:checkCodiceIPA(.) else true()"/>
            <axsl:otherwise>
                <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                    test="if(@schemeID='0201') then u:checkCodiceIPA(.) else true()">
                    <axsl:attribute name="id">NSO_010</axsl:attribute>
                    <axsl:attribute name="flag">fatal</axsl:attribute>
                    <axsl:attribute name="location">
                        <axsl:apply-templates select="." mode="schematron-select-full-path"/>
                    </axsl:attribute>
                    <svrl:text>NSO_010 – The IPA Code specified in the element is invalid.
                    </svrl:text>
                </svrl:failed-assert>
            </axsl:otherwise>
        </axsl:choose>
        <axsl:apply-templates select="@*|*" mode="M43"/>
    </axsl:template>

    <!--RULE -->

    <axsl:template match="/ubl:Order/cac:OrderLine/cac:LineItem/cac:Item/cac:StandardItemIdentification/cbc:ID"
                   priority="1000" mode="M43">
        <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                         context="/ubl:Order/cac:OrderLine/cac:LineItem/cac:Item/cac:StandardItemIdentification/cbc:ID"/>

        <!--ASSERT -->

        <axsl:choose>
            <axsl:when test="if(@schemeID='0201') then u:checkCodiceIPA(.) else true()"/>
            <axsl:otherwise>
                <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                    test="if(@schemeID='0201') then u:checkCodiceIPA(.) else true()">
                    <axsl:attribute name="id">NSO_010</axsl:attribute>
                    <axsl:attribute name="flag">fatal</axsl:attribute>
                    <axsl:attribute name="location">
                        <axsl:apply-templates select="." mode="schematron-select-full-path"/>
                    </axsl:attribute>
                    <svrl:text>NSO_010 – The IPA Code specified in the element is invalid.
                    </svrl:text>
                </svrl:failed-assert>
            </axsl:otherwise>
        </axsl:choose>
        <axsl:apply-templates select="@*|*" mode="M43"/>
    </axsl:template>
    <axsl:template match="text()" priority="-1" mode="M43"/>
    <axsl:template match="@*|node()" priority="-2" mode="M43">
        <axsl:apply-templates select="@*|*" mode="M43"/>
    </axsl:template>

    <!--PATTERN verificaCF-->


    <!--RULE -->

    <axsl:template match="/ubl:Order/cac:SellerSupplierParty/cac:Party/cbc:EndpointID" priority="1001" mode="M44">
        <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                         context="/ubl:Order/cac:SellerSupplierParty/cac:Party/cbc:EndpointID"/>

        <!--ASSERT -->

        <axsl:choose>
            <axsl:when test="if(@schemeID='9907' and not (.=string(9999999999999999))) then u:checkCF(.) else true()"/>
            <axsl:otherwise>
                <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                    test="if(@schemeID='9907' and not (.=string(9999999999999999))) then u:checkCF(.) else true()">
                    <axsl:attribute name="id">NSO_020</axsl:attribute>
                    <axsl:attribute name="flag">fatal</axsl:attribute>
                    <axsl:attribute name="location">
                        <axsl:apply-templates select="." mode="schematron-select-full-path"/>
                    </axsl:attribute>
                    <svrl:text>NSO_020 - The Tax Code specified in the element is invalid.
                    </svrl:text>
                </svrl:failed-assert>
            </axsl:otherwise>
        </axsl:choose>
        <axsl:apply-templates select="@*|*" mode="M44"/>
    </axsl:template>

    <!--RULE -->

    <axsl:template match="/ubl:Order/cac:AccountingCustomerParty/cac:Party/cbc:EndpointID" priority="1000" mode="M44">
        <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                         context="/ubl:Order/cac:AccountingCustomerParty/cac:Party/cbc:EndpointID"/>

        <!--ASSERT -->

        <axsl:choose>
            <axsl:when test="if(@schemeID='9907') then u:checkCF(.) else true()"/>
            <axsl:otherwise>
                <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                    test="if(@schemeID='9907') then u:checkCF(.) else true()">
                    <axsl:attribute name="id">NSO_020</axsl:attribute>
                    <axsl:attribute name="flag">fatal</axsl:attribute>
                    <axsl:attribute name="location">
                        <axsl:apply-templates select="." mode="schematron-select-full-path"/>
                    </axsl:attribute>
                    <svrl:text>NSO_020 – The Tax Code specified in the element is invalid.
                    </svrl:text>
                </svrl:failed-assert>
            </axsl:otherwise>
        </axsl:choose>
        <axsl:apply-templates select="@*|*" mode="M44"/>
    </axsl:template>
    <axsl:template match="text()" priority="-1" mode="M44"/>
    <axsl:template match="@*|node()" priority="-2" mode="M44">
        <axsl:apply-templates select="@*|*" mode="M44"/>
    </axsl:template>

    <!--PATTERN verificaBuyer-->


    <!--RULE -->

    <axsl:template match="/ubl:Order/cac:BuyerCustomerParty/cac:Party/cbc:EndpointID" priority="1000" mode="M45">
        <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                         context="/ubl:Order/cac:BuyerCustomerParty/cac:Party/cbc:EndpointID"/>

        <!--ASSERT -->

        <axsl:choose>
            <axsl:when test="if(@schemeID='0201') then true() else false()"/>
            <axsl:otherwise>
                <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                    test="if(@schemeID='0201') then true() else false()">
                    <axsl:attribute name="id">NSO_011</axsl:attribute>
                    <axsl:attribute name="flag">fatal</axsl:attribute>
                    <axsl:attribute name="location">
                        <axsl:apply-templates select="." mode="schematron-select-full-path"/>
                    </axsl:attribute>
                    <svrl:text>NSO_011 - The value of schemeID attribute of the element is incorrect (the correct value
                        is "0201").
                    </svrl:text>
                </svrl:failed-assert>
            </axsl:otherwise>
        </axsl:choose>
        <axsl:apply-templates select="@*|*" mode="M45"/>
    </axsl:template>
    <axsl:template match="text()" priority="-1" mode="M45"/>
    <axsl:template match="@*|node()" priority="-2" mode="M45">
        <axsl:apply-templates select="@*|*" mode="M45"/>
    </axsl:template>

    <!--PATTERN IT-UBL-T01-->


    <!--RULE -->

    <axsl:template match="/ubl:Order" priority="1000" mode="M46">
        <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="/ubl:Order"/>

        <!--ASSERT -->

        <axsl:choose>
            <axsl:when
                    test="normalize-space(cbc:CustomizationID) = 'urn:fdc:peppol.eu:poacc:trns:order:3:restrictive:urn:www.agid.gov.it:trns:ordine:3.1'"/>
            <axsl:otherwise>
                <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                    test="normalize-space(cbc:CustomizationID) = 'urn:fdc:peppol.eu:poacc:trns:order:3:restrictive:urn:www.agid.gov.it:trns:ordine:3.1'">
                    <axsl:attribute name="id">IT-T01-R001</axsl:attribute>
                    <axsl:attribute name="flag">fatal</axsl:attribute>
                    <axsl:attribute name="location">
                        <axsl:apply-templates select="." mode="schematron-select-full-path"/>
                    </axsl:attribute>
                    <svrl:text>[IT-T01-R001] - The CustomizationID of the Order MUST be filled in with the string
                        'urn:fdc:peppol.eu:poacc:trns:order:3:restrictive:urn:www.agid.gov.it:trns:ordine:3.1'.
                    </svrl:text>
                </svrl:failed-assert>
            </axsl:otherwise>
        </axsl:choose>
        <axsl:apply-templates select="@*|*" mode="M46"/>
    </axsl:template>
    <axsl:template match="text()" priority="-1" mode="M46"/>
    <axsl:template match="@*|node()" priority="-2" mode="M46">
        <axsl:apply-templates select="@*|*" mode="M46"/>
    </axsl:template>
</axsl:stylesheet>