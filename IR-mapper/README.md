# Invoice Response Mapper

The Invoice Response Mapper is an output of the E-eISI project (INEA Action n. 2017-IT-IA-0150); it contains all the templates needed for the translation of all SDI notifications that are supposed to be delivered over the Peppol Network, from the FatturaPA XML standard to the Peppol 3.0 Invoice Response Business Interoperability Specifications

The file adapter.xslt is an XSLT transformation written according to the XSLT specifications on version 2.0 

The mapper can be used as standalone using an xslt transformation engine as the ones available as opensource software, or from any application able to manipulate xml and xslt files (as an example, from a JAVA application using the Saxon library).

The transformation needs some additional information that's supposed to be submitted in the form of parameters, to create a Peppol 3.0 Invoice Response compliant file; these parameters are not contained in the original FatturaPA XML files, and are therefore supposed to be retrieved by other means:

- receiverPartySchemeId. The scheme identifier of the receiver party, according to the Electronic Address Scheme (EAS) Codelist (i.e. 9906)
- receiverPartyId. The identifier identifier of the receiver party, according to the scheme identifier specified in the previous parameter (i.e IT12345678901)
- receiverPartyRegistrationName. The business identification name of the receiving party (i.e. Prova S.P.A.)
- invoiceId. The identifier of the invoice to which this notification is referring (i.e 01ABC-2019)
- invoiceIssueDate. The issue date of the invoice to which this notification is referring (i.e 2019/12/31)
