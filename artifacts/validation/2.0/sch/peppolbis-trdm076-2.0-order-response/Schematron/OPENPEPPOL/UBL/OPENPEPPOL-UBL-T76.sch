<!-- Schematron binding rules generated automatically. -->
<!-- Data binding to UBL syntax for T76 -->
<!-- (2009). Invinet Sistemes -->
<pattern xmlns="http://purl.oclc.org/dsdl/schematron" is-a="OPENPEPPOL-T76" id="OPENPEPPOL-UBL-T76">
  <param name="EUGEN-T76-R001" value="@schemeID"/>
  <param name="EUGEN-T76-R002" value="@schemeID"/>
  <param name="EUGEN-T76-R003" value="@listID='UNCL1225'"/>
  <param name="EUGEN-T76-R004" value="@listID='UNCL1225'"/>
  <param name="EUGEN-T76-R005" value="not(count(//*[not(node()[not(self::comment())])]) &gt; 0)"/>
  <param name="endpoint" value="//cbc:EndpointID"/>
  <param name="party_identifier" value="//cac:PartyIdentification/cbc:ID"/>
  <param name="response_code" value="//cbc:OrderResponseCode"/>
  <param name="line_status" value="//cac:LineItem/cbc:LineStatusCode"/>
  <param name="order_response" value="/ubl:OrderResponse"/>
</pattern>
