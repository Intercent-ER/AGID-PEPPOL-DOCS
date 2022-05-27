<?xml version="1.0" encoding="UTF-8"?>
<!--
	LEGAL INFORMATION
	
	Copyright (c) 2019 JAVEST by Roberto Cisternino, La Spezia, Italy
	
	This software is provided 'as-is', without any express or implied warranty. 
	In no event will the authors be held liable for any damages arising from 
	the use of this software.
	
	Permission is granted to anyone to use this software for any purpose, 
	including commercial applications, and to alter it and redistribute it freely,
	subject to the following restrictions:
	
	1. The origin of this software must not be misrepresented; you must not claim
	that you wrote the original software. If you use this software in a product, 
	an acknowledgment in the product documentation would be appreciated but is 
	not required.
	
	2. Altered source versions must be plainly marked as such, and must not be 
	misrepresented as being the original software.
	
	3. This notice may not be removed or altered from any source distribution.
-->
<xsl:stylesheet version="2.0"
xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
xmlns:xs="http://www.w3.org/2001/XMLSchema"
xmlns:sch="http://purl.oclc.org/dsdl/schematron"
exclude-result-prefixes="sch xs">
	<xsl:output method="text"/>
	<xs:import namespace="http://purl.oclc.org/dsdl/schematron" schemaLocation="../xsd/iso/schematron/iso-schematron.xsd"/>
	<xsl:param name="tableMode" select="'full'"/>
	<xsl:variable name="transaction" select="/sch:schema/sch:title"/>
	
	<xsl:template match="/">
		<xsl:text>.</xsl:text><xsl:value-of select="$transaction"/><xsl:text>&#x0D;&#x0A;</xsl:text>
		<xsl:text>[cols="1,4", options="header"]&#x0D;&#x0A;</xsl:text>
		<xsl:text>|====&#x0D;&#x0A;</xsl:text>
		<xsl:text>|Regola&#x0D;&#x0A;</xsl:text>
		<xsl:choose>
			<xsl:when test="$tableMode='compact'">
				<xsl:text>|Messaggio&#x0D;&#x0A;</xsl:text>
			</xsl:when>
			<xsl:otherwise>
				<xsl:text>|Messaggio/Contesto/Test&#x0D;&#x0A;</xsl:text>
			</xsl:otherwise>
		</xsl:choose>
		
		<xsl:apply-templates select="//sch:rule/sch:assert">
			<xsl:sort select="@id"/>
		</xsl:apply-templates>
		
		<xsl:text>|====&#x0D;&#x0A;</xsl:text>
	</xsl:template>
	
	<xsl:template match="sch:assert" priority="1">
		<xsl:param name="ruleCtx" select="../@context"/>
		<xsl:variable name="ruleTest" select="@test"/>
		<xsl:variable name="ruleID" select="@id"/>
		<xsl:variable name="ruleFlag" select="@flag"/>
		<xsl:variable name="ruleText" select="text()"/>
		<xsl:if test="$tableMode='full'">
			<xsl:text>.3+</xsl:text>
		</xsl:if>
		<xsl:text>| </xsl:text><xsl:value-of select="$ruleID"/><xsl:text> *(</xsl:text><xsl:value-of select="$ruleFlag"/><xsl:text>)*&#x0D;&#x0A;</xsl:text>
		<xsl:text>| </xsl:text><xsl:value-of select="$ruleText"/><xsl:text>&#x0D;&#x0A;</xsl:text>
		<xsl:if test="$tableMode='full'">
			<xsl:text>| </xsl:text><xsl:value-of select="replace($ruleCtx,'\|','\\&#124;')"/><xsl:text>&#x0D;&#x0A;</xsl:text>
			<xsl:text>| </xsl:text><xsl:value-of select="replace($ruleTest,'\|','\\&#124;')"/><xsl:text>&#x0D;&#x0A;</xsl:text>
		</xsl:if>
	</xsl:template>
	
</xsl:stylesheet>