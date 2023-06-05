	<let name="vUpper" value="ABCDEFGHIJKLMNOPQRSTUVWXYZ"/>
	<let name="vLower" value="abcdefghijklmnopqrstuvwxyz"/>
	<let name="vOtherAscii" value="&lt;![CDATA[!&quot;#$%&amp;'()*+,-./:;&lt;=>?@[\]^_`{|}~]]&gt;"/>
	<let name="vAlpha" value="concat($vUpper, $vLower)"/>
	<let name="vDigits" value="0123456789"/>
	<let name="AlphaNumeric" value="concat($vAlpha, $vDigits)"/>
	<let name="vBasicLatin" value="concat($vAlphaNumeric, $vOtherAscii)"/>
	<let name="vLatin1Supplement" value="&lt;![CDATA[¡¢£¤¥¦§¨©ª«¬®¯°±²³´µ¶·¸¹º»¼½¾¿ÀÁÂÃÄÅÆÇÈÉÊËÌÍÎÏÐÑÒÓÔÕÖ×ØÙÚÛÜÝÞßàáâãäåæçèéêëìíîïðñòóôõö÷øùúûüýþÿ]]&gt;"/>
	<let name="vBasicLatinWithSupplement" value="concat($vBasicLatin, $vLatin1Supplement)"/>

<pattern id="Italy-SDI-rules" xmlns="http://purl.oclc.org/dsdl/schematron">

	<rule context="//cac:AccountingSupplierParty/cac:Party/cac:PostalAddress[cac:Country/cbc:IdentificationCode = 'IT']" flag="fatal">
		<assert test="(cbc:BuildingNumber) or string-length(cbc:StreetName) &gt; string-length(normalize-space(translate(cbc:StreetName, '0123456789', ' '))) or contains(cbc:StreetName, 's.n.c.')" flag="fatal" id="SDI-T10-R001">[SDI-T10-R001] - Se il cedente/prestatore è italiano, l'indirizzo del cedente/prestatore DEVE contenere il numero civico o l'acronimo s.n.c. (senza numero civico)</assert>
	</rule>

</pattern>