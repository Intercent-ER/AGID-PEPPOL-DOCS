<?xml version="1.0" encoding="UTF-8"?>

<pattern id="Italy-SDI-rules" xmlns="http://purl.oclc.org/dsdl/schematron">
	<!--<let name="vUpper" value="ABCDEFGHIJKLMNOPQRSTUVWXYZ"/>
	<let name="vLower" value="abcdefghijklmnopqrstuvwxyz"/>
	<let name="vOtherAscii" value="da_sostituire_vOtherAscii"/>--><!--ATTENZIONE: regola perfezionata dal replace di maven causa impossibilità di compilare direttamente la stringa di interesse--><!--
	<let name="vAlpha" value="concat($vUpper, $vLower)"/>-->
	<let name="vDigits" value="0123456789"/>
	<!--<let name="vAlphaNumeric" value="concat($vAlpha, $vDigits)"/>
	<let name="vBasicLatin" value="concat($vAlphaNumeric, $vOtherAscii)"/>
	<let name="vLatin1Supplement" value="da_sostituire_vLatin1Supplement"/>--><!--ATTENZIONE: regola perfezionata dal replace di maven causa impossibilità di compilare direttamente la stringa di interesse--><!--
	<let name="vBasicLatinWithSupplement" value="concat($vBasicLatin, $vLatin1Supplement)"/>-->

</pattern>