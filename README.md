# AgID :: PEPPOL Docs

_PEPPOL Documentation Repository (AgID)_.

## Struttura

Questo repository si divide in diversi moduli, ognuno dei quali assolve una specifica funzione:
1. __docs__ - modulo contenente il sorgente della Web Application che corrisponde al portale disponibile presso i link dedicati [prod](https://peppol-docs.agid.gov.it/docs) e [test](https://test-peppol-ap.regione.emilia-romagna.it/docs));
1. __tools__ - modulo contenente le regole che, gestite in fase di build Maven, consentono di produrre i tool di validazione e conversione;
1. __artifacts__ - modulo contenente i convertitori inerenti allo scenario della fatturazione (da FatturaPA verso UBL, standard PEPPOL, e viceversa).

## Build e deploy

Il build di questo repository richiede maven ed una versione di Java 11 e prevede 4 diversi profili per i diversi ambienti in cui verrà rilasciato;

la scelta del profilo dovrebbe essere legata al branch del repository git da cui si effettua il build stesso e determina

* il riferimento alla home page del sito da tutti link delle pagine HTML - tramite la macro `${peppoldocs.root.url}`
* il nome dell'archivio WAR di rilascio

|Profilo|Ambiente di rilascio - valore di `${peppoldocs.root.url}`|Branch preferenziale|Nome archivio WAR|Nota|
|---|---|---|---|---|
|`test`|https://test-peppol-ap.regione.emilia-romagna.it/docs|`develop`|TEST-_versione_-docs||
|`testnext`|https://test-peppol-ap.regione.emilia-romagna.it/docs-next-release|`next-release-develop`|TEST-_versione_-docs-next-release||
|`prod`|https://peppol-docs.agid.gov.it/docs|`master`|PROD-_versione_-docs|__Profilo di default__|
|`prodnext`|https://peppol-docs.agid.gov.it/docs-next-release|`next-release-master`|PROD-_versione_-docs-next-release||

### Procedura di build

per assemblare una dele quattro versioni del deliverable occorre dare il comando 

```shell
mvn clean install -P<nomeprofilo>

```

ad esempio, per il profilo di test:

```shell
mvn clean install -Ptest

```

__Nota bene__: se non viene indicato il profilo, viene usato per default il profilo `prod`, che produrrà un artifact del tutto analogo a quanto veniva generato prima dell'introduzione dei profili.

## Gestione dei link nei documenti

Per poter usare le funzionalità di sostituzione delle macro gestite da Maven, i link nei documenti AsciiDoc devono seguire una sintassi particolare, o non verranno adeguati in automatico ai vari ambienti di rilascio.

in pratica occorre definire i link usando la macro `${peppoldocs.root.url}` al posto della parte iniziale dell'URL, quella cioè che corrisponde alla root dell'applicazione nei vari ambienti di rilascio; inoltre, dal momento gli URL così scritti non sono identificati come tali in automatico da AsciiDoc, occorre usare la sintassi esplicita per i link.

Ad esempio, per un link che in formato semplificato viene scritto così

```asciidoc
https://peppol-docs.agid.gov.it/docs/my_index-ENG.jsp[Main site of documentation]
```

occorre usare la sintassi seguente:

```asciidoc
link:pass:[${peppoldocs.root.url}/my_index-ENG.jsp][Main site of documentation]
```
In pratica:

| | |
|--|--|
|`link:`|indica al parser di AsciiDoc di trattare quello che segue come un link anche se non appare come un URL valido|
|`pass:`|indica di ignorare il contenuto del link e copiarlo senza elaborazioni (modalità _passthrough_)|
|`${peppoldocs.root.url}`|la root del contesto, ad esempio https://peppol-docs.agid.gov.it/docs nel caso della produzione|
|`/my_index-ENG.jsp`|il path che segue la root, può non esistere, in questo caso il link punterà alla root del contesto|
