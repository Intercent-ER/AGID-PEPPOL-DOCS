#!/usr/bin/env bash

echo 'https://peppol-docs.agid.gov.it/docs/my_index_fatt-ENG.jsp[Link to main site of documentation]' |
sed -n 's#\(https://peppol-docs\.agid\.gov\.it/docs\)\([^[]*\)\(\[[^]]*\]\)#Gruppo1: \1\nGruppo2: \2\nGruppo3: \3#p'

echo
echo

echo 'https://peppol-docs.agid.gov.it/docs/my_index_fatt-ENG.jsp[Link to main site of documentation]'
echo 'https://peppol-docs.agid.gov.it/docs/my_index_fatt-ENG.jsp[Link to main site of documentation]' |
sed -n 's#\(https://peppol-docs\.agid\.gov\.it/docs\)\([^[]*\)\(\[[^]]*\]\)# link:pass:[${peppoldocs.root.url}\2]\3 #p'

echo
echo

echo 'https://peppol-docs.agid.gov.it/docs[Link to main site of documentation]'
echo 'https://peppol-docs.agid.gov.it/docs[Link to main site of documentation]' |
sed -n 's#\(https://peppol-docs\.agid\.gov\.it/docs\)\([^[]*\)\(\[[^]]*\]\)# link:pass:[${peppoldocs.root.url}\2]\3 #p'

echo
echo

echo 'https://peppol-docs.agid.gov.it/docs/[Link to main site of documentation]'
echo 'https://peppol-docs.agid.gov.it/docs/[Link to main site of documentation]' |
sed -n 's#\(https://peppol-docs\.agid\.gov\.it/docs\)\([^[]*\)\(\[[^]]*\]\)# link:pass:[${peppoldocs.root.url}\2]\3 #p'

