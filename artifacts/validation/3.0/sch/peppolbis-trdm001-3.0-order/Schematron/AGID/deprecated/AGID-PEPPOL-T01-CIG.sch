<?xml version="1.0" encoding="utf-8"?>
<pattern id="CIG" xmlns="http://purl.oclc.org/dsdl/schematron">
	<title>Regole per validazione CIG e SmartCIG</title>

	<rule context="/*/cac:OriginatorDocumentReference/cbc:ID | /*/cac:OrderLine/cac:LineItem/cac:Item/cac:ItemSpecificationDocumentReference/cbc:ID[starts-with(., 'CIG:')]">
		<let name="CIG" value="if (starts-with(., 'CIG:')) then substring(.,5) else ."/>
		<assert id="INT-T01-R037a"
                 test="matches($CIG, 'ES[0-2][0-9]') or matches(substring($CIG,1,1), '[XYZ]') or not( matches(substring($CIG,1,7), '0000000') )"
                 flag="fatal">INT-T01-R037(a) - E' stato fornito un codice CIG invalido (NNNNNNN errato).
		</assert>
		<assert id="INT-T01-R037b"
                 test="matches($CIG, 'ES[0-2][0-9]') or matches(substring($CIG,1,1), '[XYZ]') or (substring($CIG,1,7) castable as xs:integer and not( if( u:hexToDec(0,0,0,substring($CIG,8,3) ) = xs:integer((xs:integer(substring($CIG,1,7)) * 211 ) mod 4091) ) then 0 else 1 ))"
                 flag="fatal">INT-T01-R037(b) - E' stato fornito un codice CIG invalido (KKK errato).
		</assert>
		<assert id="INT-T01-R037c"
                 test="not(matches(substring($CIG,1,1), '[XYZ]')) or not( matches(substring($CIG,4,7), '0000000') )"
                 flag="fatal">INT-T01-R036(c) - E' stato fornito un codice SmartCIG invalido (CCCCCCC errato).
		</assert>
		<assert id="INT-T01-R037d"
                 test="not(matches(substring($CIG,1,1), '[XYZ]')) or not( if( u:hexToDec(0,0,0,substring($CIG,2,2) ) = xs:integer((u:hexToDec(0,0,0,substring($CIG,4,7)) * 211 ) mod 251) ) then 0 else 1 )"
                 flag="fatal">INT-T01-R037(d) - E' stato fornito un codice SmartCIG invalido (KK errato).
		</assert>
		<assert id="INT-T01-R037e"
                 test="matches($CIG, 'ES[0-2][0-9]') or substring($CIG,1,2) != 'ES'"
                 flag="fatal">INT-T01-R037(e) - E' stato fornito un codice di esclusione CIG invalido (ES## non è fra ES01-ES27).
		</assert>
	</rule>

</pattern>
