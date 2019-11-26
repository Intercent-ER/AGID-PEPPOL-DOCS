<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<xsl:stylesheet xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:xsd="http://www.w3.org/2001/XMLSchema"
                xmlns:saxon="http://saxon.sf.net/"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:schold="http://www.ascc.net/xml/schematron"
                xmlns:iso="http://purl.oclc.org/dsdl/schematron"
                xmlns:xhtml="http://www.w3.org/1999/xhtml"
				xmlns:cr="http://www.ubl-italia.org/ns/CrossReference"
                xmlns:cbc="urn:oasis:names:specification:ubl:schema:xsd:CommonBasicComponents-2"
                xmlns:cac="urn:oasis:names:specification:ubl:schema:xsd:CommonAggregateComponents-2"
                xmlns:ext="urn:oasis:names:specification:ubl:schema:xsd:CommonExtensionComponents-2"
                xmlns:ubl="urn:oasis:names:specification:ubl:schema:xsd:Invoice-2"
                version="2.0"><!--Implementers: please note that overriding process-prolog or process-root is 
    the preferred method for meta-stylesheets to use where possible. -->
	<!--ITNAT-UBL-T10 V1.7.3 (estende ed include BIS2.0-VA-V3.5.0-->
   <xsl:param name="archiveDirParameter"/>
   <xsl:param name="archiveNameParameter"/>
   <xsl:param name="fileNameParameter"/>
   <xsl:param name="fileDirParameter"/>
   <xsl:variable name="document-uri">
      <xsl:value-of select="document-uri(/)"/>
   </xsl:variable>
   <xsl:variable name="vUpper" select="'ABCDEFGHIJKLMNOPQRSTUVWXYZ'"/>
   <xsl:variable name="vLower" select="'abcdefghijklmnopqrstuvwxyz'"/>
   <xsl:variable name="vOtherAscii"><![CDATA[ !"#$%&'()*+,-./:;<=>?@[\]^_`{|}~]]></xsl:variable>
   <xsl:variable name="vAlpha" select="concat($vUpper, $vLower)"/>
   <xsl:variable name="vDigits" select="'0123456789'"/>
   <xsl:variable name="vAlphaNumeric" select="concat($vAlpha, $vDigits)"/>
   <xsl:variable name="vBasicLatin" select="concat($vAlphaNumeric, $vOtherAscii)"/>
   <xsl:variable name="vLatin1Supplement"><![CDATA[ ¡¢£¤¥¦§¨©ª«¬®¯°±²³´µ¶·¸¹º»¼½¾¿ÀÁÂÃÄÅÆÇÈÉÊËÌÍÎÏÐÑÒÓÔÕÖ×ØÙÚÛÜÝÞßàáâãäåæçèéêëìíîïðñòóôõö÷øùúûüýþÿ]]></xsl:variable>
   <xsl:variable name="vBasicLatinWithSupplement" select="concat($vBasicLatin, $vLatin1Supplement)"/>
   <xsl:variable name="vCountryCodeList" select="' AF AX AL DZ AS AD AO AI AQ AG AR AM AW AU AT AZ BS BH BD BB BY BE BZ BJ BM BT BO BQ BA BW BV BR IO BN BG BF BI KH CM CA CV KY CF TD CL CN CX CC CO KM CG CD CK CR CI HR CU CW CY CZ DK DJ DM DO EC EG SV GQ ER EE ET FK FO FJ FI FR GF PF TF GA GM GE DE GH GI GR GL GD GP GU GT GG GN GW GY HT HM VA HN HK HU IS IN ID IR IQ IE IM IL IT JM JP JE JO KZ KE KI KP KR KW KG LA LV LB LS LR LY LI LT LU MO MK MG MW MY MV ML MT MH MQ MR MU YT MX FM MD MC MN ME MS MA MZ MM NA NR NP NL NC NZ NI NE NG NU NF MP NO OM PK PW PS PA PG PY PE PH PN PL PT PR QA RE RO RU RW BL SH KN LC MF PM VC WS SM ST SA SN RS SC SL SG SX SK SI SB SO ZA GS SS ES LK SD SR SJ SZ SE CH SY TW TJ TZ TH TL TG TK TO TT TN TR TM TC TV UG UA AE GB US UM UY UZ VU VE VN VG VI WF EH YE ZM ZW '"/>
   <xsl:variable name="vDocumentTypeCodeList" select="' 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35 36 37 38 39 40 41 42 43 44 45 46 47 48 49 50 51 52 53 54 55 56 57 58 59 60 61 62 63 64 65 66 67 68 69 70 71 72 73 74 75 76 77 78 79 80 81 82 83 84 85 86 87 88 89 90 91 92 93 94 95 96 97 98 99 100 101 102 103 104 105 106 107 108 109 110 111 112 113 114 115 116 117 118 119 120 121 122 123 124 125 126 127 128 129 130 131 132 133 134 135 136 137 138 139 140 141 142 143 144 145 146 147 148 149 150 151 152 153 154 155 156 157 158 159 160 161 162 163 164 165 166 167 168 169 170 171 172 173 174 175 176 177 178 179 180 181 182 183 184 185 186 187 188 189 190 191 192 193 194 195 196 197 198 199 200 201 202 203 204 205 206 207 208 209 210 211 212 213 214 215 216 217 218 219 220 221 222 223 224 225 226 227 228 229 230 231 232 233 234 235 236 237 238 239 240 241 242 243 244 245 246 247 248 249 250 251 252 253 254 255 256 257 258 259 260 261 262 263 264 265 266 267 268 269 270 271 272 273 274 275 276 277 278 279 280 281 282 283 284 285 286 287 288 289 290 291 292 293 294 295 296 297 298 299 300 301 302 303 304 305 306 307 308 309 310 311 312 313 314 315 316 317 318 319 320 321 322 323 324 325 326 327 328 329 330 331 332 333 334 335 336 337 338 339 340 341 342 343 344 345 346 347 348 349 350 351 352 353 354 355 356 357 358 359 360 361 362 363 364 365 366 367 368 369 370 371 372 373 374 375 376 377 378 379 380 381 382 383 384 385 386 387 388 389 390 391 392 393 394 395 396 397 398 399 400 401 402 403 404 405 406 407 408 409 410 411 412 413 414 415 416 417 418 419 420 421 422 423 424 425 426 427 428 429 430 431 432 433 434 435 436 437 438 439 440 441 442 443 444 445 446 447 448 449 450 451 452 453 454 455 456 457 458 459 460 461 462 463 464 465 466 467 468 469 470 481 482 483 484 485 486 487 488 489 490 491 493 494 495 496 497 498 499 520 521 522 523 524 525 526 527 528 529 530 531 532 533 534 535 536 537 538 550 575 580 610 621 622 623 624 630 631 632 633 635 640 650 655 700 701 702 703 704 705 706 707 708 709 710 711 712 713 714 715 716 720 722 723 724 730 740 741 743 744 745 746 750 760 761 763 764 765 766 770 775 780 781 782 783 784 785 786 787 788 789 790 791 792 793 794 795 796 797 798 799 810 811 812 820 821 822 823 824 825 830 833 840 841 850 851 852 853 855 856 860 861 862 863 864 865 870 890 895 896 901 910 911 913 914 915 916 917 925 926 927 929 930 931 932 933 934 935 936 937 938 940 941 950 951 952 953 954 955 960 961 962 963 964 965 966 970 971 972 974 975 976 977 978 979 990 991 995 996 998 '"/>
   <xsl:variable name="vPartySchemeIDList" select="' FR:SIRENE SE:ORGNR FR:SIRET FI:OVT DUNS GLN DK:P IT:FTI NL:KVK IT:SIA IT:SECETI DIGST DK:CPR DK:CVR DK:SE DK:VANS IT:VAT IT:CF NO:ORGNR NO:VAT HU:VAT EU:REID AT:VAT AT:GOV IS:KT IBAN AT:KUR ES:VAT IT:IPA AD:VAT AL:VAT BA:VAT BE:VAT BG:VAT CH:VAT CY:VAT CZ:VAT DE:VAT EE:VAT GB:VAT GR:VAT HR:VAT IE:VAT LI:VAT LT:VAT LU:VAT LV:VAT MC:VAT ME:VAT MK:VAT MT:VAT NL:VAT PL:VAT PT:VAT RO:VAT RS:VAT SI:VAT SK:VAT SM:VAT TR:VAT VA:VAT NL:ION NL:OIN SE:VAT BE:CBE FR:VAT ZZZ '"/>
   <xsl:variable name="vUnitOfMeasureCodeList" select="' 5 6 8 10 11 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35 36 37 38 40 41 43 44 45 46 47 48 53 54 56 57 58 59 60 61 62 63 64 66 69 71 72 73 74 76 77 78 80 81 84 85 87 89 90 91 92 93 94 95 96 97 98 1A 1B 1C 1D 1E 1F 1G 1H 1I 1J 1K 1L 1M 1X 2A 2B 2C 2G 2H 2I 2J 2K 2L 2M 2N 2P 2Q 2R 2U 2V 2W 2X 2Y 2Z 3B 3C 3E 3G 3H 3I 4A 4B 4C 4E 4G 4H 4K 4L 4M 4N 4O 4P 4Q 4R 4T 4U 4W 4X 5A 5B 5C 5E 5F 5G 5H 5I 5J 5K 5P 5Q A1 A10 A11 A12 A13 A14 A15 A16 A17 A18 A19 A2 A20 A21 A22 A23 A24 A25 A26 A27 A28 A29 A3 A30 A31 A32 A33 A34 A35 A36 A37 A38 A39 A4 A40 A41 A42 A43 A44 A45 A47 A48 A49 A5 A50 A51 A52 A53 A54 A55 A56 A57 A58 A59 A6 A60 A61 A62 A63 A64 A65 A66 A67 A68 A69 A7 A70 A71 A73 A74 A75 A76 A77 A78 A79 A8 A80 A81 A82 A83 A84 A85 A86 A87 A88 A89 A9 A90 A91 A93 A94 A95 A96 A97 A98 A99 AA AB ACR ACT AD AE AH AI AJ AK AL AM AMH AMP ANN AP APZ AQ AR ARE AS ASM ASU ATM ATT AV AW AY AZ B0 B1 B10 B11 B12 B13 B14 B15 B16 B17 B18 B19 B2 B20 B21 B22 B23 B24 B25 B26 B27 B28 B29 B3 B30 B31 B32 B33 B34 B35 B36 B37 B38 B39 B4 B40 B41 B42 B43 B44 B45 B46 B47 B48 B49 B5 B50 B51 B52 B53 B54 B55 B56 B57 B58 B59 B6 B60 B61 B62 B63 B64 B65 B66 B67 B68 B69 B7 B70 B71 B72 B73 B74 B75 B76 B77 B78 B79 B8 B80 B81  B82 B83 B84 B85 B86 B87 B88 B89 B9 B90 B91 B92 B93 B94 B95 B96 B97 B98 B99 BAR BB BD BE BFT BG BH BHP BIL BJ BK BL BLD BLL BO BP BQL BR BT BTU BUA BUI BW BX BZ C0 C1 C10 C11 C12 C13 C14 C15 C16 C17 C18 C19 C2 C20 C21 C22 C23 C24 C25 C26 C27 C28 C29 C3 C30 C31 C32 C33 C34 C35 C36 C37 C38 C39 C4 C40 C41 C42 C43 C44 C45 C46 C47 C48 C49 C5 C50 C51 C52 C53 C54 C55 C56 C57 C58 C59 C6 C60 C61 C62 C63 C64 C65 C66 C67 C68 C69 C7 C70 C71 C72 C73 C74 C75 C76 C77 C78 C79 C8 C80 C81 C82 C83 C84 C85 C86 C87 C88 C89 C9 C90 C91 C92 C93 C94 C95 C96 C97 C98 C99 CA CCT CDL CEL CEN CG CGM CH CJ CK CKG CL CLF CLT CMK CMQ CMT CNP CNT CO COU CQ CR CS CT CTG CTM CTN CU CUR CV CWA CWI CY CZ D03 D04 D1 D10 D11 D12 D13 D14 D15 D16 D17 D18 D19 D2 D20 D21 D22 D23 D24 D25 D26 D27 D28 D29 D30 D31 D32 D33 D34 D35 D36 D37 D38 D39 D40 D41 D42 D43 D44 D45 D46 D47 D48 D49 D5 D50 D51 D52 D53 D54 D55 D56 D57 D58 D59 D6 D60 D61 D62 D63 D64 D65 D66 D67 D68 D69 D7 D70 D71 D72 D73 D74 D75 D76 D77 D78 D79 D8 D80 D81 D82 D83 D85 D86 D87 D88 D89 D9 D90 D91 D92 D93 D94 D95 D96 D97 D98 D99 DAA DAD DAY DB DC DD DE DEC DG DI DJ DLT DMA DMK DMO DMQ DMT DN DPC DPR DPT DQ DR DRA DRI DRL DRM DS DT DTN DU DWT DX DY DZN DZP E01 E07 E08 E09 E10 E11 E12 E14 E15 E16 E17 E18 E19 E2 E20 E21 E22 E23 E25 E27 E28 E3 E30 E31 E32 E33 E34 E35 E36 E37 E38 E39 E4 E40 E41 E42 E43 E44 E45 E46 E47 E48 E49 E5 E50 E51 E52 E53 E54 E55 E56 E57 E58 E59 E60 E61 E62 E63 E64 E65 E66 E67 E68 E69 E70 E71 E72 E73 E74 E75 E76 E77 E78 E79 E80 E81 E82 E83 E84 E85 E86 E87 E88 E89 E90 E91 E92 E93 E94 E95 E96 E97 E98 E99 EA EB EC EP EQ EV F01 F02 F03 F04 F05 F06 F07 F08 F1 F10 F11 F12 F13 F14 F15 F16 F17 F18 F19 F20 F21 F22 F23 F24 F25 F26 F27 F28 F29 F30 F31 F32 F33 F34 F35 F36 F37 F38 F39 F40 F41 F42 F43 F44 F45 F46 F47 F48 F49 F50 F51 F52 F53 F54 F55 F56 F57 F58 F59 F60 F61 F62 F63 F64 F65 F66 F67 F68 F69 F70 F71 F72 F73 F74 F75 F76 F77 F78 F79 F80 F81 F82 F83 F84 F85 F86 F87 F88 F89 F9 F90 F91 F92 F93 F94 F95 F96 F97 F98 F99 FAH FAR FB FBM FC FD FE FF FG FH FIT FL FM FOT FP FR FS FTK FTQ G01 G04 G05 G06 G08 G09 G10 G11 G12 G13 G14 G15 G16 G17 G18 G19 G2 G20 G21 G23 G24 G25 G26 G27 G28 G29 G3 G30 G31 G32 G33 G34 G35 G36 G37 G38 G39 G40 G41 G42 G43 G44 G45 G46 G47 G48 G49 G50 G51 G52 G53 G54 G55 G56 G57 G58 G59 G60 G61 G62 G63 G64 G65 G66 G67 G68 G69 G7 G70 G71 G72 G73 G74 G75 G76 G77 G78 G79 G80 G81 G82 G83 G84 G85 G86 G87 G88 G89 G90 G91 G92 G93 G94 G95 G96 G97 G98 G99 GB GBQ GC GD GDW GE GF GFI GGR GH GIA GIC GII GIP GJ GK GL GLD GLI GLL GM GN GO GP GQ GRM GRN GRO GRT GT GV GW GWH GY GZ H03 H04 H05 H06 H07 H08 H09 H1 H10 H11 H12 H13 H14 H15 H16 H18 H19 H2 H20 H21 H22 H23 H24 H25 H26 H27 H28 H29 H30 H31 H32 H33 H34 H35 H36 H37 H38 H39 H40 H41 H42 H43 H44 H45 H46 H47 H48 H49 H50 H51 H52 H53 H54 H55 H56 H57 H58 H59 H60 H61 H62 H63 H64 H65 H66 H67 H68 H69 H70 H71 H72 H73 H74 H75 H76 H77 H78 H79 H80 H81 H82 H83 H84 H85 H87 H88 H89 H90 H91 H92 H93 H94 H95 H96 H98 H99 HA HAR HBA HBX HC HD HDW HE HEA HF HGM HH HI HIU HJ HK HKM HL HLT HM HMQ HMT HN HO HP HPA HS HT HTZ HUR HY IA IC IE IF II IL IM INH INK INQ IP ISD IT IU IV J10 J12 J13 J14 J15 J16 J17 J18 J19 J2 J20 J21 J22 J23 J24 J25 J26 J27 J28 J29 J30 J31 J32 J33 J34 J35 J36 J38 J39 J40 J41 J42 J43 J44 J45 J46 J47 J48 J49 J50 J51 J52 J53 J54 J55 J56 J57 J58 J59 J60 J61 J62 J63 J64 J65 J66 J67 J68 J69 J70 J71 J72 J73 J74 J75 J76 J78 J79 J81 J82 J83 J84 J85 J87 J89 J90 J91 J92 J93 J94 J95 J96 J97 J98 J99 JB JE JG JK JM JNT JO JOU JPS JR JWL K1 K10 K11 K12 K13 K14 K15 K16 K17 K18 K19 K2 K20 K21 K22 K23 K24 K25 K26 K27 K28 K3 K30 K31 K32 K33 K34 K35 K36 K37 K38 K39 K40 K41 K42 K43 K45 K46 K47 K48 K49 K5 K50 K51 K52 K53 K54 K55 K58 K59 K6 K60 K61 K62 K63 K64 K65 K66 K67 K68 K69 K70 K71 K73 K74 K75 K76 K77 K78 K79 K80 K81 K82 K83 K84 K85 K86 K87 K88 K89 K90 K91 K92 K93 K94 K95 K96 K97 K98 K99 KA KAT KB KBA KCC KD KDW KEL KF KG KGM KGS KHY KHZ KI KIC KIP KJ KJO KL KLK KLX KMA KMH KMK KMQ KMT KNI KNS KNT KO KPA KPH KPO KPP KR KS KSD KSH KT KTM KTN KUR KVA KVR KVT KW KWH KWO KWT KX L10 L11 L12 L13 L14 L15 L16 L17 L18 L19 L2 L20 L21 L23 L24 L25 L26 L27 L28 L29 L30 L31 L32 L33 L34 L35 L36 L37 L38 L39 L40 L41 L42 L43 L44 L45 L46 L47 L48 L49 L50 L51 L52 L53 L54 L55 L56 L57 L58 L59 L60 L61 L62 L63 L64 L65 L66 L67 L68 L69 L70 L71 L72 L73 L74 L75 L76 L77 L78 L79 L80 L81 L82 L83 L84 L85 L86 L87 L88 L89 L90 L91 L92 L93 L94 L95 L96 L98 L99 LA LAC LBR LBT LC LD LE LEF LF LH LI LJ LK LM LN LO LP LPA LR LS LTN LTR LUB LUM LUX LX LY M0 M1 M10 M11 M12 M13 M14 M15 M16 M17 M18 M19 M20 M21 M22 M23 M24 M25 M26 M27 M29 M30 M31 M32 M33 M34 M35 M36 M37 M38 M39 M4 M40 M41 M42 M43 M44 M45 M46 M47 M48 M49 M5 M50 M51 M52 M53 M55 M56 M57 M58 M59 M60 M61 M62 M63 M64 M65 M66 M67 M68 M69 M7 M70 M71 M72 M73 M74 M75 M76 M77 M78 M79 M80 M81 M82 M83 M84 M85 M86 M87 M88 M89 M9 M90 M91 M92 M93 M94 M95 M96 M97 M98 M99 MA MAH MAL MAM MAR MAW MBE MBF MBR MC MCU MD MF MGM MHZ MIK MIL MIN MIO MIU MK MLD MLT MMK MMQ MMT MND MON MPA MQ MQH MQS MSK MT MTK MTQ MTR MTS MV MVA MWH N1 N10 N11 N12 N13 N14 N15 N16 N17 N18 N19 N2 N20 N21 N22 N23 N24 N25 N26 N27 N28 N29 N3 N30 N31 N32 N33 N34 N35 N36 N37 N38 N39 N40 N41 N42 N43 N44 N45 N46 N47 N48 N49 N50 N51 N52 N53 N54 N55 N56 N57 N58 N59 N60 N61 N62 N63 N64 N65 N66 N67 N68 N69 N70 N71 N72 N73 N74 N75 N76 N77 N78 N79 N80 N81 N82 N83 N84 N85 N86 N87 N88 N89 N90 N91 N92 N93 N94 N95 N96 N97 N98 N99 NA NAR NB NBB NC NCL ND NE NEW NF NG NH NI NIL NIU NJ NL NMI NMP NN NPL NPR NPT NQ NR NRL NT NTT NU NV NX NY OA ODE OHM ON ONZ OP OT OZ OZA OZI P0 P1 P10 P11 P12 P13 P14 P15 P16 P17 P18 P19 P2 P20 P21 P22 P23 P24 P25 P26 P27 P28 P29 P3 P30 P31 P32 P33 P34 P35 P36 P37 P38 P39 P4 P40 P41 P42 P43 P44 P45 P46 P47 P48 P49 P5 P50 P51 P52 P53 P54 P55 P56 P57 P58 P59 P6 P60 P61 P62 P63 P64 P65 P66 P67 P68 P69 P7 P70 P71 P72 P73 P74 P75 P76 P77 P78 P79 P8 P80 P81 P82 P83 P84 P85 P86 P87 P88 P89 P9 P90 P91 P92 P93 P94 P95 P96 P97 P98 P99 PA PAL PB PD PE PF PFL PG PGL PI PK PL PLA PM PN PO PQ PR PS PT PTD PTI PTL PU PV PW PY PZ Q10 Q11 Q12 Q13 Q14 Q15 Q16 Q17 Q18 Q19 Q20 Q21 Q22 Q23 Q24 Q25 Q26 Q27 Q28 Q29 Q30 Q3 QA QAN QB QD QH QK QR QT QTD QTI QTL QTR R1 R4 R9 RA RD RG RH RK RL RM RN RO ROM RP RPM RPS RS RT RU S3 S4 S5 S6 S7 S8 SA SAN SCO SCR SD SE SEC SET SG SHT SIE SK SL SMI SN SO SP SQ SQR SR SS SST ST STC STI STK STL STN STW SV SW SX SYR T0 T1 T3 T4 T5 T6 T7 T8 TA TAH TAN TC TD TE TF TI TIC TIP TJ TK TKM TL TMS TN TNE TP TPR TQ TQD TR TRL TS TSD TSH TST TT TTS TU TV TW TY U1 U2 UA UB UC UD UE UF UH UM VA VI VLT VP VQ VS W2 W4 WA WB WCD WE WEB WEE WG WH WHR WI WM WR WSD WTT WW X1 YDK YDQ YL YRD YT Z1 Z11 Z2 Z3 Z4 Z5 Z6 Z8 ZP ZZ '"/>
   <xsl:variable name="vCurrencyCodeList" select="' AED AFN ALL AMD ANG AOA ARS AUD AWG AZN BAM BBD BDT BGN BHD BIF BMD BND BOB BOV BRL BSD BTN BWP BYR BZD CAD CDF CHE CHF CHW CLF CLP CNY COP COU CRC CUP CVE CZK DJF DKK DOP DZD EEK EGP ERN ETB EUR FJD FKP GBP GEL GHS GIP GMD GNF GTQ GWP GYD HKD HNL HRK HTG HUF IDR ILS INR IQD IRR ISK JMD JOD JPY KES KGS KHR KMF KPW KRW KWD KYD KZT LAK LBP LKR LRD LSL LTL LVL LYD MAD MDL MGA MKD MMK MNT MOP MRO MUR MVR MWK MXN MXV MYR MZN NAD NGN NIO NOK NPR NZD OMR PAB PEN PGK PHP PKR PLN PYG QAR RON RSD RUB RWF SAR SBD SCR SDG SEK SGD SHP SKK SLL SOS SRD STD SVC SYP SZL THB TJS TMM TND TOP TRY TTD TWD TZS UAH UGX USD USN USS UYI UYU UZS VEF VND VUV WST XAF XAG XAU XBA XBB XBC XBD XCD XDR XFU XOF XPD XPF XTS XXX YER ZAR ZMK ZWR ZWD '"/>
   <xsl:variable name="vFinancialAccountSchemeIDList" select="' IBAN LOCAL '"/>
   <xsl:variable name="vTaxSchemeIDList" select="' VAT SSS SWT '"/>
   <xsl:variable name="vTaxCategoryIDList" select="' AE E S Z H AA O '"/>
   <xsl:variable name="vPaymentMeansCodeList" select="' 1 9 10 15 20 21 22 23 25 30 46 48 49 50 60 70 91 92 '"/>
   <xsl:variable name="vCompanyLiquidationStatusCodeList" select="' LS LN '"/>
   <xsl:variable name="vInvoiceTypeCodeList" select="' 380 384 386 '"/>
   <xsl:variable name="vCausalePagamentoCodeList" select="' A B C D E G H I L M N O P Q R S T U V W X Y Z L1 M1 O1 V1 '"/>
   <xsl:variable name="vEsigibilitaIVACodeList" select="' I D S '"/>
   <xsl:variable name="vEsenzioniCIGCodeList" select="' ES01 ES02 ES03 ES04 ES05 ES06 ES07 ES08 ES09 ES10 ES11 ES12 ES13 ES14 ES15 ES16 ES17 ES18 ES19 ES20 ES21 ES22 ES23 ES24 ES25 ES26 ES27 '"/>

   <!--PHASES-->


   <!--PROLOG-->
   <xsl:output xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
               method="xml"
               omit-xml-declaration="no"
               standalone="yes"
               indent="yes"/>

   <!--XSD TYPES FOR XSLT2-->


   <!--KEYS AND FUNCTIONS-->


   <!--DEFAULT RULES-->


   <!--MODE: SCHEMATRON-SELECT-FULL-PATH-->
   <!--This mode can be used to generate an ugly though full XPath for locators-->
   <xsl:template match="*" mode="schematron-select-full-path">
      <xsl:apply-templates select="." mode="schematron-get-full-path"/>
   </xsl:template>

   <!--MODE: SCHEMATRON-FULL-PATH-->
   <!--This mode can be used to generate an ugly though full XPath for locators-->
   <xsl:template match="*" mode="schematron-get-full-path">
      <xsl:apply-templates select="parent::*" mode="schematron-get-full-path"/>
      <xsl:text>/</xsl:text>
      <xsl:choose>
         <xsl:when test="namespace-uri()=''">
            <xsl:value-of select="name()"/>
         </xsl:when>
         <xsl:otherwise>
            <xsl:text>*:</xsl:text>
            <xsl:value-of select="local-name()"/>
            <xsl:text>[namespace-uri()='</xsl:text>
            <xsl:value-of select="namespace-uri()"/>
            <xsl:text>']</xsl:text>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:variable name="preceding"
                    select="count(preceding-sibling::*[local-name()=local-name(current()) and namespace-uri() = namespace-uri(current())])"/>
      <xsl:text>[</xsl:text>
      <xsl:value-of select="1+ $preceding"/>
      <xsl:text>]</xsl:text>
   </xsl:template>
   <xsl:template match="@*" mode="schematron-get-full-path">
      <xsl:apply-templates select="parent::*" mode="schematron-get-full-path"/>
      <xsl:text>/</xsl:text>
      <xsl:choose>
         <xsl:when test="namespace-uri()=''">@<xsl:value-of select="name()"/>
         </xsl:when>
         <xsl:otherwise>
            <xsl:text>@*[local-name()='</xsl:text>
            <xsl:value-of select="local-name()"/>
            <xsl:text>' and namespace-uri()='</xsl:text>
            <xsl:value-of select="namespace-uri()"/>
            <xsl:text>']</xsl:text>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>

   <!--MODE: SCHEMATRON-FULL-PATH-2-->
   <!--This mode can be used to generate prefixed XPath for humans-->
   <xsl:template match="node() | @*" mode="schematron-get-full-path-2">
      <xsl:for-each select="ancestor-or-self::*">
         <xsl:text>/</xsl:text>
         <xsl:value-of select="name(.)"/>
         <xsl:if test="preceding-sibling::*[name(.)=name(current())]">
            <xsl:text>[</xsl:text>
            <xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1"/>
            <xsl:text>]</xsl:text>
         </xsl:if>
      </xsl:for-each>
      <xsl:if test="not(self::*)">
         <xsl:text/>/@<xsl:value-of select="name(.)"/>
      </xsl:if>
   </xsl:template>
   <!--MODE: SCHEMATRON-FULL-PATH-3-->
   <!--This mode can be used to generate prefixed XPath for humans 
	(Top-level element has index)-->
   <xsl:template match="node() | @*" mode="schematron-get-full-path-3">
      <xsl:for-each select="ancestor-or-self::*">
         <xsl:text>/</xsl:text>
         <xsl:value-of select="name(.)"/>
         <xsl:if test="parent::*">
            <xsl:text>[</xsl:text>
            <xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1"/>
            <xsl:text>]</xsl:text>
         </xsl:if>
      </xsl:for-each>
      <xsl:if test="not(self::*)">
         <xsl:text/>/@<xsl:value-of select="name(.)"/>
      </xsl:if>
   </xsl:template>

   <!--MODE: GENERATE-ID-FROM-PATH -->
   <xsl:template match="/" mode="generate-id-from-path"/>
   <xsl:template match="text()" mode="generate-id-from-path">
      <xsl:apply-templates select="parent::*" mode="generate-id-from-path"/>
      <xsl:value-of select="concat('.text-', 1+count(preceding-sibling::text()), '-')"/>
   </xsl:template>
   <xsl:template match="comment()" mode="generate-id-from-path">
      <xsl:apply-templates select="parent::*" mode="generate-id-from-path"/>
      <xsl:value-of select="concat('.comment-', 1+count(preceding-sibling::comment()), '-')"/>
   </xsl:template>
   <xsl:template match="processing-instruction()" mode="generate-id-from-path">
      <xsl:apply-templates select="parent::*" mode="generate-id-from-path"/>
      <xsl:value-of select="concat('.processing-instruction-', 1+count(preceding-sibling::processing-instruction()), '-')"/>
   </xsl:template>
   <xsl:template match="@*" mode="generate-id-from-path">
      <xsl:apply-templates select="parent::*" mode="generate-id-from-path"/>
      <xsl:value-of select="concat('.@', name())"/>
   </xsl:template>
   <xsl:template match="*" mode="generate-id-from-path" priority="-0.5">
      <xsl:apply-templates select="parent::*" mode="generate-id-from-path"/>
      <xsl:text>.</xsl:text>
      <xsl:value-of select="concat('.',name(),'-',1+count(preceding-sibling::*[name()=name(current())]),'-')"/>
   </xsl:template>

   <!--MODE: GENERATE-ID-2 -->
   <xsl:template match="/" mode="generate-id-2">U</xsl:template>
   <xsl:template match="*" mode="generate-id-2" priority="2">
      <xsl:text>U</xsl:text>
      <xsl:number level="multiple" count="*"/>
   </xsl:template>
   <xsl:template match="node()" mode="generate-id-2">
      <xsl:text>U.</xsl:text>
      <xsl:number level="multiple" count="*"/>
      <xsl:text>n</xsl:text>
      <xsl:number count="node()"/>
   </xsl:template>
   <xsl:template match="@*" mode="generate-id-2">
      <xsl:text>U.</xsl:text>
      <xsl:number level="multiple" count="*"/>
      <xsl:text>_</xsl:text>
      <xsl:value-of select="string-length(local-name(.))"/>
      <xsl:text>_</xsl:text>
      <xsl:value-of select="translate(name(),':','.')"/>
   </xsl:template>
   <!--Strip characters-->
   <xsl:template match="text()" priority="-1"/>

   <!--SCHEMA SETUP-->
   <xsl:template match="/">
      <svrl:schematron-output xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                              title="OPENPEPPOL  T10 bound to UBL"
                              schemaVersion="">
         <xsl:comment>
            <xsl:value-of select="$archiveDirParameter"/>   
		 <xsl:value-of select="$archiveNameParameter"/>  
		 <xsl:value-of select="$fileNameParameter"/>  
		 <xsl:value-of select="$fileDirParameter"/>
         </xsl:comment>
         <svrl:ns-prefix-in-attribute-values uri="urn:oasis:names:specification:ubl:schema:xsd:CommonBasicComponents-2"
                                             prefix="cbc"/>
         <svrl:ns-prefix-in-attribute-values uri="urn:oasis:names:specification:ubl:schema:xsd:CommonAggregateComponents-2"
                                             prefix="cac"/>
         <svrl:ns-prefix-in-attribute-values uri="urn:oasis:names:specification:ubl:schema:xsd:CommonExtensionComponents-2"
                                             prefix="ext"/>
         <svrl:ns-prefix-in-attribute-values uri="urn:oasis:names:specification:ubl:schema:xsd:Invoice-2"
                                             prefix="ubl"/>

         <svrl:ns-prefix-in-attribute-values uri="http://www.w3.org/2001/XMLSchema" prefix="xs"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">CodesT10</xsl:attribute>
            <xsl:attribute name="name">CodesT10</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M5"/>
		 <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">EUGEN-UBL-T10</xsl:attribute>
            <xsl:attribute name="name">EUGEN-UBL-T10</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M6"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">OP-CodesT10</xsl:attribute>
            <xsl:attribute name="name">OP-CodesT10</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M7"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">ITNAT-T10</xsl:attribute>
            <xsl:attribute name="name">ITNAT-T10</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M8"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">ITNAT-SDI-T10</xsl:attribute>
            <xsl:attribute name="name">ITNAT-SDI-T10</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M9"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">ITNAT-INT-T10</xsl:attribute>
            <xsl:attribute name="name">ITNAT-INT-T10</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M10"/>
      </svrl:schematron-output>
   </xsl:template>

   <!--SCHEMATRON PATTERNS-->
   <svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">Intercent-ER / OPENPEPPOL  T10 bound to UBL</svrl:text>

   <!--PATTERN CodesT10-->


	  <!--RULE -->
   <xsl:template match="cbc:InvoiceTypeCode" priority="1007" mode="M5">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="cbc:InvoiceTypeCode"/>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="( ( not(contains(normalize-space(.),' ')) and contains( ' 380 393 384 ',concat(' ',normalize-space(.),' ') ) ) )"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="( ( not(contains(normalize-space(.),' ')) and contains( ' 380 393 384 ',concat(' ',normalize-space(.),' ') ) ) )">
               <xsl:attribute name="id">CL-T10-R001</xsl:attribute>
               <xsl:attribute name="flag">fatal</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>[CL-T10-R001]-An Invoice MUST be coded with the InvoiceTypeCode code list UNCL D1001 BII2 subset</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="@*|*|comment()|processing-instruction()" mode="M5"/>
   </xsl:template>

	  <!--RULE -->
   <xsl:template match="cbc:DocumentCurrencyCode" priority="1006" mode="M5">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="cbc:DocumentCurrencyCode"/>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="( ( not(contains(normalize-space(.),' ')) and contains( ' AED AFN ALL AMD ANG AOA ARS AUD AWG AZN BAM BBD BDT BGN BHD BIF BMD BND BOB BOV BRL BSD BTN BWP BYR BZD CAD CDF CHE CHF CHW CLF CLP CNY COP COU CRC CUP CVE CZK DJF DKK DOP DZD EEK EGP ERN ETB EUR FJD FKP GBP GEL GHS GIP GMD GNF GTQ GWP GYD HKD HNL HRK HTG HUF IDR ILS INR IQD IRR ISK JMD JOD JPY KES KGS KHR KMF KPW KRW KWD KYD KZT LAK LBP LKR LRD LSL LTL LVL LYD MAD MDL MGA MKD MMK MNT MOP MRO MUR MVR MWK MXN MXV MYR MZN NAD NGN NIO NOK NPR NZD OMR PAB PEN PGK PHP PKR PLN PYG QAR RON RSD RUB RWF SAR SBD SCR SDG SEK SGD SHP SKK SLL SOS SRD STD SVC SYP SZL THB TJS TMM TND TOP TRY TTD TWD TZS UAH UGX USD USN USS UYI UYU UZS VEF VND VUV WST XAF XAG XAU XBA XBB XBC XBD XCD XDR XFU XOF XPD XPF XTS XXX YER ZAR ZMK ZWR ZWD ',concat(' ',normalize-space(.),' ') ) ) )"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="( ( not(contains(normalize-space(.),' ')) and contains( ' AED AFN ALL AMD ANG AOA ARS AUD AWG AZN BAM BBD BDT BGN BHD BIF BMD BND BOB BOV BRL BSD BTN BWP BYR BZD CAD CDF CHE CHF CHW CLF CLP CNY COP COU CRC CUP CVE CZK DJF DKK DOP DZD EEK EGP ERN ETB EUR FJD FKP GBP GEL GHS GIP GMD GNF GTQ GWP GYD HKD HNL HRK HTG HUF IDR ILS INR IQD IRR ISK JMD JOD JPY KES KGS KHR KMF KPW KRW KWD KYD KZT LAK LBP LKR LRD LSL LTL LVL LYD MAD MDL MGA MKD MMK MNT MOP MRO MUR MVR MWK MXN MXV MYR MZN NAD NGN NIO NOK NPR NZD OMR PAB PEN PGK PHP PKR PLN PYG QAR RON RSD RUB RWF SAR SBD SCR SDG SEK SGD SHP SKK SLL SOS SRD STD SVC SYP SZL THB TJS TMM TND TOP TRY TTD TWD TZS UAH UGX USD USN USS UYI UYU UZS VEF VND VUV WST XAF XAG XAU XBA XBB XBC XBD XCD XDR XFU XOF XPD XPF XTS XXX YER ZAR ZMK ZWR ZWD ',concat(' ',normalize-space(.),' ') ) ) )">
               <xsl:attribute name="id">CL-T10-R002</xsl:attribute>
               <xsl:attribute name="flag">fatal</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>[CL-T10-R002]-DocumentCurrencyCode MUST be coded using ISO code list 4217</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="@*|*|comment()|processing-instruction()" mode="M5"/>
   </xsl:template>

	  <!--RULE -->
   <xsl:template match="cbc:*/@currencyID" priority="1005" mode="M5">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="cbc:*/@currencyID"/>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="( ( not(contains(normalize-space(.),' ')) and contains( ' AED AFN ALL AMD ANG AOA ARS AUD AWG AZN BAM BBD BDT BGN BHD BIF BMD BND BOB BOV BRL BSD BTN BWP BYR BZD CAD CDF CHE CHF CHW CLF CLP CNY COP COU CRC CUP CVE CZK DJF DKK DOP DZD EEK EGP ERN ETB EUR FJD FKP GBP GEL GHS GIP GMD GNF GTQ GWP GYD HKD HNL HRK HTG HUF IDR ILS INR IQD IRR ISK JMD JOD JPY KES KGS KHR KMF KPW KRW KWD KYD KZT LAK LBP LKR LRD LSL LTL LVL LYD MAD MDL MGA MKD MMK MNT MOP MRO MUR MVR MWK MXN MXV MYR MZN NAD NGN NIO NOK NPR NZD OMR PAB PEN PGK PHP PKR PLN PYG QAR RON RSD RUB RWF SAR SBD SCR SDG SEK SGD SHP SKK SLL SOS SRD STD SVC SYP SZL THB TJS TMM TND TOP TRY TTD TWD TZS UAH UGX USD USN USS UYI UYU UZS VEF VND VUV WST XAF XAG XAU XBA XBB XBC XBD XCD XDR XFU XOF XPD XPF XTS XXX YER ZAR ZMK ZWR ZWD ',concat(' ',normalize-space(.),' ') ) ) )"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="( ( not(contains(normalize-space(.),' ')) and contains( ' AED AFN ALL AMD ANG AOA ARS AUD AWG AZN BAM BBD BDT BGN BHD BIF BMD BND BOB BOV BRL BSD BTN BWP BYR BZD CAD CDF CHE CHF CHW CLF CLP CNY COP COU CRC CUP CVE CZK DJF DKK DOP DZD EEK EGP ERN ETB EUR FJD FKP GBP GEL GHS GIP GMD GNF GTQ GWP GYD HKD HNL HRK HTG HUF IDR ILS INR IQD IRR ISK JMD JOD JPY KES KGS KHR KMF KPW KRW KWD KYD KZT LAK LBP LKR LRD LSL LTL LVL LYD MAD MDL MGA MKD MMK MNT MOP MRO MUR MVR MWK MXN MXV MYR MZN NAD NGN NIO NOK NPR NZD OMR PAB PEN PGK PHP PKR PLN PYG QAR RON RSD RUB RWF SAR SBD SCR SDG SEK SGD SHP SKK SLL SOS SRD STD SVC SYP SZL THB TJS TMM TND TOP TRY TTD TWD TZS UAH UGX USD USN USS UYI UYU UZS VEF VND VUV WST XAF XAG XAU XBA XBB XBC XBD XCD XDR XFU XOF XPD XPF XTS XXX YER ZAR ZMK ZWR ZWD ',concat(' ',normalize-space(.),' ') ) ) )">
               <xsl:attribute name="id">CL-T10-R003</xsl:attribute>
               <xsl:attribute name="flag">fatal</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>[CL-T10-R003]-currencyID MUST be coded using ISO code list 4217</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="@*|*|comment()|processing-instruction()" mode="M5"/>
   </xsl:template>

	  <!--RULE -->
   <xsl:template match="cac:Country//cbc:IdentificationCode"
                 priority="1004"
                 mode="M5">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="cac:Country//cbc:IdentificationCode"/>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="( ( not(contains(normalize-space(.),' ')) and contains( ' AD AE AF AG AI AL AM AN AO AQ AR AS AT AU AW AX AZ BA BB BD BE BF BG BH BI BL BJ BM BN BO BR BS BT BV BW BY BZ CA CC CD CF CG CH CI CK CL CM CN CO CR CU CV CX CY CZ DE DJ DK DM DO DZ EC EE EG EH ER ES ET FI FJ FK FM FO FR GA GB GD GE GF GG GH GI GL GM GN GP GQ GR GS GT GU GW GY HK HM HN HR HT HU ID IE IL IM IN IO IQ IR IS IT JE JM JO JP KE KG KH KI KM KN KP KR KW KY KZ LA LB LC LI LK LR LS LT LU LV LY MA MC MD ME MF MG MH MK ML MM MN MO MP MQ MR MS MT MU MV MW MX MY MZ NA NC NE NF NG NI NL NO NP NR NU NZ OM PA PE PF PG PH PK PL PM PN PR PS PT PW PY QA RO RS RU RW SA SB SC SD SE SG SH SI SJ SK SL SM SN SO SR ST SV SY SZ TC TD TF TG TH TJ TK TL TM TN TO TR TT TV TW TZ UA UG UM US UY UZ VA VC VE VG VI VN VU WF WS YE YT ZA ZM ZW ',concat(' ',normalize-space(.),' ') ) ) )"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="( ( not(contains(normalize-space(.),' ')) and contains( ' AD AE AF AG AI AL AM AN AO AQ AR AS AT AU AW AX AZ BA BB BD BE BF BG BH BI BL BJ BM BN BO BR BS BT BV BW BY BZ CA CC CD CF CG CH CI CK CL CM CN CO CR CU CV CX CY CZ DE DJ DK DM DO DZ EC EE EG EH ER ES ET FI FJ FK FM FO FR GA GB GD GE GF GG GH GI GL GM GN GP GQ GR GS GT GU GW GY HK HM HN HR HT HU ID IE IL IM IN IO IQ IR IS IT JE JM JO JP KE KG KH KI KM KN KP KR KW KY KZ LA LB LC LI LK LR LS LT LU LV LY MA MC MD ME MF MG MH MK ML MM MN MO MP MQ MR MS MT MU MV MW MX MY MZ NA NC NE NF NG NI NL NO NP NR NU NZ OM PA PE PF PG PH PK PL PM PN PR PS PT PW PY QA RO RS RU RW SA SB SC SD SE SG SH SI SJ SK SL SM SN SO SR ST SV SY SZ TC TD TF TG TH TJ TK TL TM TN TO TR TT TV TW TZ UA UG UM US UY UZ VA VC VE VG VI VN VU WF WS YE YT ZA ZM ZW ',concat(' ',normalize-space(.),' ') ) ) )">
               <xsl:attribute name="id">CL-T10-R004</xsl:attribute>
               <xsl:attribute name="flag">fatal</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>[CL-T10-R004]-Country codes in an invoice MUST be coded using ISO code list 3166-1</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="@*|*|comment()|processing-instruction()" mode="M5"/>
   </xsl:template>

	  <!--RULE -->
   <xsl:template match="cac:PaymentMeans//cbc:PaymentMeansCode"
                 priority="1003"
                 mode="M5">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="cac:PaymentMeans//cbc:PaymentMeansCode"/>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="( ( not(contains(normalize-space(.),' ')) and contains( ' 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35 36 37 38 39 40 41 42 43 44 45 46 47 48 49 50 51 52 53 60 61 62 63 64 65 66 67 70 74 75 76 77 78 91 92 93 94 95 96 97 ',concat(' ',normalize-space(.),' ') ) ) )"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="( ( not(contains(normalize-space(.),' ')) and contains( ' 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35 36 37 38 39 40 41 42 43 44 45 46 47 48 49 50 51 52 53 60 61 62 63 64 65 66 67 70 74 75 76 77 78 91 92 93 94 95 96 97 ',concat(' ',normalize-space(.),' ') ) ) )">
               <xsl:attribute name="id">CL-T10-R006</xsl:attribute>
               <xsl:attribute name="flag">fatal</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>[CL-T10-R006]-Payment means in an invoice MUST be coded using UNCL 4461 BII2 subset</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="@*|*|comment()|processing-instruction()" mode="M5"/>
   </xsl:template>

	  <!--RULE -->
   <xsl:template match="cac:TaxCategory/cbc:ID" priority="1002" mode="M5">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="cac:TaxCategory/cbc:ID"/>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="( ( not(contains(normalize-space(.),' ')) and contains( ' AE E S Z AA H O ',concat(' ',normalize-space(.),' ') ) ) )"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="( ( not(contains(normalize-space(.),' ')) and contains( ' AE E S Z AA H O ',concat(' ',normalize-space(.),' ') ) ) )">
               <xsl:attribute name="id">CL-T10-R007</xsl:attribute>
               <xsl:attribute name="flag">fatal</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>[CL-T10-R007]-Invoice tax categories MUST be coded using UNCL 5305 code list BII2 subset</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="@*|*|comment()|processing-instruction()" mode="M5"/>
   </xsl:template>

	  <!--RULE -->
   <xsl:template match="cbc:*/@mimeCode" priority="1001" mode="M5">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="cbc:*/@mimeCode"/>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="( ( . = 'application/activemessage' or . = 'application/andrew-inset' or . = 'application/applefile' or . = 'application/atom+xml' or . = 'application/atomicmail' or . = 'application/atomcat+xml' or . = 'application/atomsvc+xml' or . = 'application/auth-policy+xml' or . = 'application/batch-SMTP' or . = 'application/beep+xml' or . = 'application/cals-1840' or . = 'application/ccxml+xml' or . = 'application/cellml+xml' or . = 'application/cnrp+xml' or . = 'application/commonground' or . = 'application/conference-info+xml' or . = 'application/cpl+xml' or . = 'application/csta+xml' or . = 'application/CSTAdata+xml' or . = 'application/cybercash' or . = 'application/davmount+xml' or . = 'application/dca-rft' or . = 'application/dec-dx' or . = 'application/dialog-info+xml' or . = 'application/dicom' or . = 'application/dns' or . = 'application/dvcs' or . = 'application/ecmascript' or . = 'application/EDI-Consent' or . = 'application/EDIFACT' or . = 'application/EDI-X12' or . = 'application/epp+xml' or . = 'application/eshop' or . = 'application/example' or . = 'application/fastinfoset' or . = 'application/fastsoap' or . = 'application/fits' or . = 'application/font-tdpfr' or . = 'application/H224' or . = 'application/http' or . = 'application/hyperstudio' or . = 'application/iges' or . = 'application/im-iscomposing+xml' or . = 'application/index' or . = 'application/index.cmd' or . = 'application/index.obj' or . = 'application/index.response' or . = 'application/index.vnd' or . = 'application/iotp' or . = 'application/ipp' or . = 'application/isup' or . = 'application/javascript' or . = 'application/json' or . = 'application/kpml-request+xml' or . = 'application/kpml-response+xml' or . = 'application/mac-binhex40' or . = 'application/macwriteii' or . = 'application/marc' or . = 'application/mathematica' or . = 'application/mbms-associated-procedure-description+xml' or . = 'application/mbms-deregister+xml' or . = 'application/mbms-envelope+xml' or . = 'application/mbms-msk-response+xml' or . = 'application/mbms-msk+xml' or . = 'application/mbms-protection-description+xml' or . = 'application/mbms-reception-report+xml' or . = 'application/mbms-register-response+xml' or . = 'application/mbms-register+xml' or . = 'application/mbms-user-service-description+xml' or . = 'application/mbox' or . = 'application/media_control+xml' or . = 'application/mediaservercontrol+xml' or . = 'application/mikey' or . = 'application/moss-keys' or . = 'application/moss-signature' or . = 'application/mosskey-data' or . = 'application/mosskey-request' or . = 'application/mpeg4-generic' or . = 'application/mpeg4-iod' or . = 'application/mpeg4-iod-xmt' or . = 'application/mp4' or . = 'application/msword' or . = 'application/mxf' or . = 'application/nasdata' or . = 'application/news-message-id' or . = 'application/news-transmission' or . = 'application/nss' or . = 'application/ocsp-request' or . = 'application/ocsp-response' or . = 'application/octet-stream' or . = 'application/oda' or . = 'application/oebps-package+xml' or . = 'application/ogg' or . = 'application/parityfec' or . = 'application/pdf' or . = 'application/pgp-encrypted' or . = 'application/pgp-keys' or . = 'application/pgp-signature' or . = 'application/pidf+xml' or . = 'application/pkcs10' or . = 'application/pkcs7-mime' or . = 'application/pkcs7-signature' or . = 'application/pkix-cert' or . = 'application/pkixcmp' or . = 'application/pkix-crl' or . = 'application/pkix-pkipath' or . = 'application/pls+xml' or . = 'application/poc-settings+xml' or . = 'application/postscript' or . = 'application/prs.alvestrand.titrax-sheet' or . = 'application/prs.cww' or . = 'application/prs.nprend' or . = 'application/prs.plucker' or . = 'application/rdf+xml' or . = 'application/qsig' or . = 'application/reginfo+xml' or . = 'application/relax-ng-compact-syntax' or . = 'application/remote-printing' or . = 'application/resource-lists+xml' or . = 'application/riscos' or . = 'application/rlmi+xml' or . = 'application/rls-services+xml' or . = 'application/rtf' or . = 'application/rtx' or . = 'application/samlassertion+xml' or . = 'application/samlmetadata+xml' or . = 'application/sbml+xml' or . = 'application/scvp-cv-request' or . = 'application/scvp-cv-response' or . = 'application/scvp-vp-request' or . = 'application/scvp-vp-response' or . = 'application/sdp' or . = 'application/set-payment' or . = 'application/set-payment-initiation' or . = 'application/set-registration' or . = 'application/set-registration-initiation' or . = 'application/sgml' or . = 'application/sgml-open-catalog' or . = 'application/shf+xml' or . = 'application/sieve' or . = 'application/simple-filter+xml' or . = 'application/simple-message-summary' or . = 'application/simpleSymbolContainer' or . = 'application/slate' or . = 'application/smil (OBSOLETE)' or . = 'application/smil+xml' or . = 'application/soap+fastinfoset' or . = 'application/soap+xml' or . = 'application/sparql-query' or . = 'application/sparql-results+xml' or . = 'application/spirits-event+xml' or . = 'application/srgs' or . = 'application/srgs+xml' or . = 'application/ssml+xml' or . = 'application/timestamp-query' or . = 'application/timestamp-reply' or . = 'application/tve-trigger' or . = 'application/ulpfec' or . = 'application/vemmi' or . = 'application/vnd.3gpp.bsf+xml' or . = 'application/vnd.3gpp.pic-bw-large' or . = 'application/vnd.3gpp.pic-bw-small' or . = 'application/vnd.3gpp.pic-bw-var' or . = 'application/vnd.3gpp.sms' or . = 'application/vnd.3gpp2.bcmcsinfo+xml' or . = 'application/vnd.3gpp2.sms' or . = 'application/vnd.3gpp2.tcap' or . = 'application/vnd.3M.Post-it-Notes' or . = 'application/vnd.accpac.simply.aso' or . = 'application/vnd.accpac.simply.imp' or . = 'application/vnd.acucobol' or . = 'application/vnd.acucorp' or . = 'application/vnd.adobe.xdp+xml' or . = 'application/vnd.adobe.xfdf' or . = 'application/vnd.aether.imp' or . = 'application/vnd.americandynamics.acc' or . = 'application/vnd.amiga.ami' or . = 'application/vnd.anser-web-certificate-issue-initiation' or . = 'application/vnd.antix.game-component' or . = 'application/vnd.apple.installer+xml' or . = 'application/vnd.audiograph' or . = 'application/vnd.autopackage' or . = 'application/vnd.avistar+xml' or . = 'application/vnd.blueice.multipass' or . = 'application/vnd.bmi' or . = 'application/vnd.businessobjects' or . = 'application/vnd.cab-jscript' or . = 'application/vnd.canon-cpdl' or . = 'application/vnd.canon-lips' or . = 'application/vnd.cendio.thinlinc.clientconf' or . = 'application/vnd.chemdraw+xml' or . = 'application/vnd.chipnuts.karaoke-mmd' or . = 'application/vnd.cinderella' or . = 'application/vnd.cirpack.isdn-ext' or . = 'application/vnd.claymore' or . = 'application/vnd.clonk.c4group' or . = 'application/vnd.commerce-battelle' or . = 'application/vnd.commonspace' or . = 'application/vnd.cosmocaller' or . = 'application/vnd.contact.cmsg' or . = 'application/vnd.crick.clicker' or . = 'application/vnd.crick.clicker.keyboard' or . = 'application/vnd.crick.clicker.palette' or . = 'application/vnd.crick.clicker.template' or . = 'application/vnd.crick.clicker.wordbank' or . = 'application/vnd.criticaltools.wbs+xml' or . = 'application/vnd.ctc-posml' or . = 'application/vnd.ctct.ws+xml' or . = 'application/vnd.cups-pdf' or . = 'application/vnd.cups-postscript' or . = 'application/vnd.cups-ppd' or . = 'application/vnd.cups-raster' or . = 'application/vnd.cups-raw' or . = 'application/vnd.curl' or . = 'application/vnd.cybank' or . = 'application/vnd.data-vision.rdz' or . = 'application/vnd.denovo.fcselayout-link' or . = 'application/vnd.dna' or . = 'application/vnd.dpgraph' or . = 'application/vnd.dreamfactory' or . = 'application/vnd.dvb.esgcontainer' or . = 'application/vnd.dvb.ipdcesgaccess' or . = 'application/vnd.dxr' or . = 'application/vnd.ecdis-update' or . = 'application/vnd.ecowin.chart' or . = 'application/vnd.ecowin.filerequest' or . = 'application/vnd.ecowin.fileupdate' or . = 'application/vnd.ecowin.series' or . = 'application/vnd.ecowin.seriesrequest' or . = 'application/vnd.ecowin.seriesupdate' or . = 'application/vnd.enliven' or . = 'application/vnd.epson.esf' or . = 'application/vnd.epson.msf' or . = 'application/vnd.epson.quickanime' or . = 'application/vnd.epson.salt' or . = 'application/vnd.epson.ssf' or . = 'application/vnd.ericsson.quickcall' or . = 'application/vnd.eszigno3+xml' or . = 'application/vnd.eudora.data' or . = 'application/vnd.ezpix-album' or . = 'application/vnd.ezpix-package' or . = 'application/vnd.fdf' or . = 'application/vnd.ffsns' or . = 'application/vnd.fints' or . = 'application/vnd.FloGraphIt' or . = 'application/vnd.fluxtime.clip' or . = 'application/vnd.framemaker' or . = 'application/vnd.frogans.fnc' or . = 'application/vnd.frogans.ltf' or . = 'application/vnd.fsc.weblaunch' or . = 'application/vnd.fujitsu.oasys' or . = 'application/vnd.fujitsu.oasys2' or . = 'application/vnd.fujitsu.oasys3' or . = 'application/vnd.fujitsu.oasysgp' or . = 'application/vnd.fujitsu.oasysprs' or . = 'application/vnd.fujixerox.ART4' or . = 'application/vnd.fujixerox.ART-EX' or . = 'application/vnd.fujixerox.ddd' or . = 'application/vnd.fujixerox.docuworks' or . = 'application/vnd.fujixerox.docuworks.binder' or . = 'application/vnd.fujixerox.HBPL' or . = 'application/vnd.fut-misnet' or . = 'application/vnd.fuzzysheet' or . = 'application/vnd.genomatix.tuxedo' or . = 'application/vnd.google-earth.kml+xml' or . = 'application/vnd.google-earth.kmz' or . = 'application/vnd.grafeq' or . = 'application/vnd.gridmp' or . = 'application/vnd.groove-account' or . = 'application/vnd.groove-help' or . = 'application/vnd.groove-identity-message' or . = 'application/vnd.groove-injector' or . = 'application/vnd.groove-tool-message' or . = 'application/vnd.groove-tool-template' or . = 'application/vnd.groove-vcard' or . = 'application/vnd.HandHeld-Entertainment+xml' or . = 'application/vnd.hbci' or . = 'application/vnd.hcl-bireports' or . = 'application/vnd.hhe.lesson-player' or . = 'application/vnd.hp-HPGL' or . = 'application/vnd.hp-hpid' or . = 'application/vnd.hp-hps' or . = 'application/vnd.hp-jlyt' or . = 'application/vnd.hp-PCL' or . = 'application/vnd.hp-PCLXL' or . = 'application/vnd.httphone' or . = 'application/vnd.hzn-3d-crossword' or . = 'application/vnd.ibm.afplinedata' or . = 'application/vnd.ibm.electronic-media' or . = 'application/vnd.ibm.MiniPay' or . = 'application/vnd.ibm.modcap' or . = 'application/vnd.ibm.rights-management' or . = 'application/vnd.ibm.secure-container' or . = 'application/vnd.iccprofile' or . = 'application/vnd.igloader' or . = 'application/vnd.immervision-ivp' or . = 'application/vnd.immervision-ivu' or . = 'application/vnd.informedcontrol.rms+xml' or . = 'application/vnd.informix-visionary' or . = 'application/vnd.intercon.formnet' or . = 'application/vnd.intertrust.digibox' or . = 'application/vnd.intertrust.nncp' or . = 'application/vnd.intu.qbo' or . = 'application/vnd.intu.qfx' or . = 'application/vnd.ipunplugged.rcprofile' or . = 'application/vnd.irepository.package+xml' or . = 'application/vnd.is-xpr' or . = 'application/vnd.jam' or . = 'application/vnd.japannet-directory-service' or . = 'application/vnd.japannet-jpnstore-wakeup' or . = 'application/vnd.japannet-payment-wakeup' or . = 'application/vnd.japannet-registration' or . = 'application/vnd.japannet-registration-wakeup' or . = 'application/vnd.japannet-setstore-wakeup' or . = 'application/vnd.japannet-verification' or . = 'application/vnd.japannet-verification-wakeup' or . = 'application/vnd.jcp.javame.midlet-rms' or . = 'application/vnd.jisp' or . = 'application/vnd.joost.joda-archive' or . = 'application/vnd.kahootz' or . = 'application/vnd.kde.karbon' or . = 'application/vnd.kde.kchart' or . = 'application/vnd.kde.kformula' or . = 'application/vnd.kde.kivio' or . = 'application/vnd.kde.kontour' or . = 'application/vnd.kde.kpresenter' or . = 'application/vnd.kde.kspread' or . = 'application/vnd.kde.kword' or . = 'application/vnd.kenameaapp' or . = 'application/vnd.kidspiration' or . = 'application/vnd.Kinar' or . = 'application/vnd.koan' or . = 'application/vnd.kodak-descriptor' or . = 'application/vnd.liberty-request+xml' or . = 'application/vnd.llamagraphics.life-balance.desktop' or . = 'application/vnd.llamagraphics.life-balance.exchange+xml' or . = 'application/vnd.lotus-1-2-3' or . = 'application/vnd.lotus-approach' or . = 'application/vnd.lotus-freelance' or . = 'application/vnd.lotus-notes' or . = 'application/vnd.lotus-organizer' or . = 'application/vnd.lotus-screencam' or . = 'application/vnd.lotus-wordpro' or . = 'application/vnd.macports.portpkg' or . = 'application/vnd.marlin.drm.actiontoken+xml' or . = 'application/vnd.marlin.drm.conftoken+xml' or . = 'application/vnd.marlin.drm.mdcf' or . = 'application/vnd.mcd' or . = 'application/vnd.medcalcdata' or . = 'application/vnd.mediastation.cdkey' or . = 'application/vnd.meridian-slingshot' or . = 'application/vnd.MFER' or . = 'application/vnd.mfmp' or . = 'application/vnd.micrografx.flo' or . = 'application/vnd.micrografx.igx' or . = 'application/vnd.mif' or . = 'application/vnd.minisoft-hp3000-save' or . = 'application/vnd.mitsubishi.misty-guard.trustweb' or . = 'application/vnd.Mobius.DAF' or . = 'application/vnd.Mobius.DIS' or . = 'application/vnd.Mobius.MBK' or . = 'application/vnd.Mobius.MQY' or . = 'application/vnd.Mobius.MSL' or . = 'application/vnd.Mobius.PLC' or . = 'application/vnd.Mobius.TXF' or . = 'application/vnd.mophun.application' or . = 'application/vnd.mophun.certificate' or . = 'application/vnd.motorola.flexsuite' or . = 'application/vnd.motorola.flexsuite.adsi' or . = 'application/vnd.motorola.flexsuite.fis' or . = 'application/vnd.motorola.flexsuite.gotap' or . = 'application/vnd.motorola.flexsuite.kmr' or . = 'application/vnd.motorola.flexsuite.ttc' or . = 'application/vnd.motorola.flexsuite.wem' or . = 'application/vnd.mozilla.xul+xml' or . = 'application/vnd.ms-artgalry' or . = 'application/vnd.ms-asf' or . = 'application/vnd.ms-cab-compressed' or . = 'application/vnd.mseq' or . = 'application/vnd.ms-excel' or . = 'application/vnd.ms-fontobject' or . = 'application/vnd.ms-htmlhelp' or . = 'application/vnd.msign' or . = 'application/vnd.ms-ims' or . = 'application/vnd.ms-lrm' or . = 'application/vnd.ms-playready.initiator+xml' or . = 'application/vnd.ms-powerpoint' or . = 'application/vnd.ms-project' or . = 'application/vnd.ms-tnef' or . = 'application/vnd.ms-wmdrm.lic-chlg-req' or . = 'application/vnd.ms-wmdrm.lic-resp' or . = 'application/vnd.ms-wmdrm.meter-chlg-req' or . = 'application/vnd.ms-wmdrm.meter-resp' or . = 'application/vnd.ms-works' or . = 'application/vnd.ms-wpl' or . = 'application/vnd.ms-xpsdocument' or . = 'application/vnd.multiad.creator' or . = 'application/vnd.multiad.creator.cif' or . = 'application/vnd.musician' or . = 'application/vnd.music-niff' or . = 'application/vnd.muvee.style' or . = 'application/vnd.ncd.control' or . = 'application/vnd.ncd.reference' or . = 'application/vnd.nervana' or . = 'application/vnd.netfpx' or . = 'application/vnd.neurolanguage.nlu' or . = 'application/vnd.noblenet-directory' or . = 'application/vnd.noblenet-sealer' or . = 'application/vnd.noblenet-web' or . = 'application/vnd.nokia.catalogs' or . = 'application/vnd.nokia.conml+wbxml' or . = 'application/vnd.nokia.conml+xml' or . = 'application/vnd.nokia.iptv.config+xml' or . = 'application/vnd.nokia.iSDS-radio-presets' or . = 'application/vnd.nokia.landmark+wbxml' or . = 'application/vnd.nokia.landmark+xml' or . = 'application/vnd.nokia.landmarkcollection+xml' or . = 'application/vnd.nokia.ncd' or . = 'application/vnd.nokia.n-gage.ac+xml' or . = 'application/vnd.nokia.n-gage.data' or . = 'application/vnd.nokia.n-gage.symbian.install' or . = 'application/vnd.nokia.pcd+wbxml' or . = 'application/vnd.nokia.pcd+xml' or . = 'application/vnd.nokia.radio-preset' or . = 'application/vnd.nokia.radio-presets' or . = 'application/vnd.novadigm.EDM' or . = 'application/vnd.novadigm.EDX' or . = 'application/vnd.novadigm.EXT' or . = 'application/vnd.oasis.opendocument.chart' or . = 'application/vnd.oasis.opendocument.chart-template' or . = 'application/vnd.oasis.opendocument.formula' or . = 'application/vnd.oasis.opendocument.formula-template' or . = 'application/vnd.oasis.opendocument.graphics' or . = 'application/vnd.oasis.opendocument.graphics-template' or . = 'application/vnd.oasis.opendocument.image' or . = 'application/vnd.oasis.opendocument.image-template' or . = 'application/vnd.oasis.opendocument.presentation' or . = 'application/vnd.oasis.opendocument.presentation-template' or . = 'application/vnd.oasis.opendocument.spreadsheet' or . = 'application/vnd.oasis.opendocument.spreadsheet-template' or . = 'application/vnd.oasis.opendocument.text' or . = 'application/vnd.oasis.opendocument.text-master' or . = 'application/vnd.oasis.opendocument.text-template' or . = 'application/vnd.oasis.opendocument.text-web' or . = 'application/vnd.obn' or . = 'application/vnd.olpc-sugar' or . = 'application/vnd.oma.bcast.associated-procedure-parameter+xml' or . = 'application/vnd.oma.bcast.drm-trigger+xml' or . = 'application/vnd.oma.bcast.imd+xml' or . = 'application/vnd.oma.bcast.ltkm' or . = 'application/vnd.oma.bcast.notification+xml' or . = 'application/vnd.oma.bcast.sgboot' or . = 'application/vnd.oma.bcast.sgdd+xml' or . = 'application/vnd.oma.bcast.sgdu' or . = 'application/vnd.oma.bcast.simple-symbol-container' or . = 'application/vnd.oma.bcast.smartcard-trigger+xml' or . = 'application/vnd.oma.bcast.sprov+xml' or . = 'application/vnd.oma.bcast.stkm' or . = 'application/vnd.oma.dd2+xml' or . = 'application/vnd.oma.drm.risd+xml' or . = 'application/vnd.oma.group-usage-list+xml' or . = 'application/vnd.oma.poc.detailed-progress-report+xml' or . = 'application/vnd.oma.poc.final-report+xml' or . = 'application/vnd.oma.poc.groups+xml' or . = 'application/vnd.oma.poc.invocation-descriptor+xml' or . = 'application/vnd.oma.poc.optimized-progress-report+xml' or . = 'application/vnd.oma.xcap-directory+xml' or . = 'application/vnd.omads-email+xml' or . = 'application/vnd.omads-file+xml' or . = 'application/vnd.omads-folder+xml' or . = 'application/vnd.omaloc-supl-init' or . = 'application/vnd.oma-scws-config' or . = 'application/vnd.oma-scws-http-request' or . = 'application/vnd.oma-scws-http-response' or . = 'application/vnd.openofficeorg.extension' or . = 'application/vnd.osa.netdeploy' or . = 'application/vnd.osgi.bundle' or . = 'application/vnd.osgi.dp' or . = 'application/vnd.otps.ct-kip+xml' or . = 'application/vnd.palm' or . = 'application/vnd.paos.xml' or . = 'application/vnd.pg.format' or . = 'application/vnd.pg.osasli' or . = 'application/vnd.piaccess.application-licence' or . = 'application/vnd.picsel' or . = 'application/vnd.poc.group-advertisement+xml' or . = 'application/vnd.pocketlearn' or . = 'application/vnd.powerbuilder6' or . = 'application/vnd.powerbuilder6-s' or . = 'application/vnd.powerbuilder7' or . = 'application/vnd.powerbuilder75' or . = 'application/vnd.powerbuilder75-s' or . = 'application/vnd.powerbuilder7-s' or . = 'application/vnd.preminet' or . = 'application/vnd.previewsystems.box' or . = 'application/vnd.proteus.magazine' or . = 'application/vnd.publishare-delta-tree' or . = 'application/vnd.pvi.ptid1' or . = 'application/vnd.pwg-multiplexed' or . = 'application/vnd.pwg-xhtml-print+xml' or . = 'application/vnd.qualcomm.brew-app-res' or . = 'application/vnd.Quark.QuarkXPress' or . = 'application/vnd.rapid' or . = 'application/vnd.recordare.musicxml' or . = 'application/vnd.recordare.musicxml+xml' or . = 'application/vnd.RenLearn.rlprint' or . = 'application/vnd.ruckus.download' or . = 'application/vnd.s3sms' or . = 'application/vnd.sbm.mid2' or . = 'application/vnd.scribus' or . = 'application/vnd.sealed.3df' or . = 'application/vnd.sealed.csf' or . = 'application/vnd.sealed.doc' or . = 'application/vnd.sealed.eml' or . = 'application/vnd.sealed.mht' or . = 'application/vnd.sealed.net' or . = 'application/vnd.sealed.ppt' or . = 'application/vnd.sealed.tiff' or . = 'application/vnd.sealed.xls' or . = 'application/vnd.sealedmedia.softseal.html' or . = 'application/vnd.sealedmedia.softseal.pdf' or . = 'application/vnd.seemail' or . = 'application/vnd.sema' or . = 'application/vnd.semd' or . = 'application/vnd.semf' or . = 'application/vnd.shana.informed.formdata' or . = 'application/vnd.shana.informed.formtemplate' or . = 'application/vnd.shana.informed.interchange' or . = 'application/vnd.shana.informed.package' or . = 'application/vnd.SimTech-MindMapper' or . = 'application/vnd.smaf' or . = 'application/vnd.solent.sdkm+xml' or . = 'application/vnd.spotfire.dxp' or . = 'application/vnd.spotfire.sfs' or . = 'application/vnd.sss-cod' or . = 'application/vnd.sss-dtf' or . = 'application/vnd.sss-ntf' or . = 'application/vnd.street-stream' or . = 'application/vnd.sun.wadl+xml' or . = 'application/vnd.sus-calendar' or . = 'application/vnd.svd' or . = 'application/vnd.swiftview-ics' or . = 'application/vnd.syncml.dm+wbxml' or . = 'application/vnd.syncml.dm+xml' or . = 'application/vnd.syncml.ds.notification' or . = 'application/vnd.syncml+xml' or . = 'application/vnd.tao.intent-module-archive' or . = 'application/vnd.tmobile-livetv' or . = 'application/vnd.trid.tpt' or . = 'application/vnd.triscape.mxs' or . = 'application/vnd.trueapp' or . = 'application/vnd.truedoc' or . = 'application/vnd.ufdl' or . = 'application/vnd.uiq.theme' or . = 'application/vnd.umajin' or . = 'application/vnd.unity' or . = 'application/vnd.uoml+xml' or . = 'application/vnd.uplanet.alert' or . = 'application/vnd.uplanet.alert-wbxml' or . = 'application/vnd.uplanet.bearer-choice' or . = 'application/vnd.uplanet.bearer-choice-wbxml' or . = 'application/vnd.uplanet.cacheop' or . = 'application/vnd.uplanet.cacheop-wbxml' or . = 'application/vnd.uplanet.channel' or . = 'application/vnd.uplanet.channel-wbxml' or . = 'application/vnd.uplanet.list' or . = 'application/vnd.uplanet.listcmd' or . = 'application/vnd.uplanet.listcmd-wbxml' or . = 'application/vnd.uplanet.list-wbxml' or . = 'application/vnd.uplanet.signal' or . = 'application/vnd.vcx' or . = 'application/vnd.vectorworks' or . = 'application/vnd.vd-study' or . = 'application/vnd.vidsoft.vidconference' or . = 'application/vnd.visio' or . = 'application/vnd.visionary' or . = 'application/vnd.vividence.scriptfile' or . = 'application/vnd.vsf' or . = 'application/vnd.wap.sic' or . = 'application/vnd.wap.slc' or . = 'application/vnd.wap.wbxml' or . = 'application/vnd.wap.wmlc' or . = 'application/vnd.wap.wmlscriptc' or . = 'application/vnd.webturbo' or . = 'application/vnd.wfa.wsc' or . = 'application/vnd.wmc' or . = 'application/vnd.wmf.bootstrap' or . = 'application/vnd.wordperfect' or . = 'application/vnd.wqd' or . = 'application/vnd.wrq-hp3000-labelled' or . = 'application/vnd.wt.stf' or . = 'application/vnd.wv.csp+xml' or . = 'application/vnd.wv.csp+wbxml' or . = 'application/vnd.wv.ssp+xml' or . = 'application/vnd.xara' or . = 'application/vnd.xfdl' or . = 'application/vnd.xmpie.cpkg' or . = 'application/vnd.xmpie.dpkg' or . = 'application/vnd.xmpie.plan' or . = 'application/vnd.xmpie.ppkg' or . = 'application/vnd.xmpie.xlim' or . = 'application/vnd.yamaha.hv-dic' or . = 'application/vnd.yamaha.hv-script' or . = 'application/vnd.yamaha.hv-voice' or . = 'application/vnd.yamaha.smaf-audio' or . = 'application/vnd.yamaha.smaf-phrase' or . = 'application/vnd.yellowriver-custom-menu' or . = 'application/vnd.zzazz.deck+xml' or . = 'application/voicexml+xml' or . = 'application/watcherinfo+xml' or . = 'application/whoispp-query' or . = 'application/whoispp-response' or . = 'application/wita' or . = 'application/wordperfect5.1' or . = 'application/wsdl+xml' or . = 'application/wspolicy+xml' or . = 'application/x400-bp' or . = 'application/xcap-att+xml' or . = 'application/xcap-caps+xml' or . = 'application/xcap-el+xml' or . = 'application/xcap-error+xml' or . = 'application/xcap-ns+xml' or . = 'application/xenc+xml' or . = 'application/xhtml-voice+xml (Obsolete)' or . = 'application/xhtml+xml' or . = 'application/xml' or . = 'application/xml-dtd' or . = 'application/xml-external-parsed-entity' or . = 'application/xmpp+xml' or . = 'application/xop+xml' or . = 'application/xv+xml' or . = 'application/zip' or . = 'audio/32kadpcm' or . = 'audio/3gpp' or . = 'audio/3gpp2' or . = 'audio/ac3' or . = 'audio/AMR' or . = 'audio/AMR-WB' or . = 'audio/amr-wb+' or . = 'audio/asc' or . = 'audio/basic' or . = 'audio/BV16' or . = 'audio/BV32' or . = 'audio/clearmode' or . = 'audio/CN' or . = 'audio/DAT12' or . = 'audio/dls' or . = 'audio/dsr-es201108' or . = 'audio/dsr-es202050' or . = 'audio/dsr-es202211' or . = 'audio/dsr-es202212' or . = 'audio/eac3' or . = 'audio/DVI4' or . = 'audio/EVRC' or . = 'audio/EVRC0' or . = 'audio/EVRC1' or . = 'audio/EVRCB' or . = 'audio/EVRCB0' or . = 'audio/EVRCB1' or . = 'audio/EVRC-QCP' or . = 'audio/EVRCWB' or . = 'audio/EVRCWB0' or . = 'audio/EVRCWB1' or . = 'audio/example' or . = 'audio/G722' or . = 'audio/G7221' or . = 'audio/G723' or . = 'audio/G726-16' or . = 'audio/G726-24' or . = 'audio/G726-32' or . = 'audio/G726-40' or . = 'audio/G728' or . = 'audio/G729' or . = 'audio/G7291' or . = 'audio/G729D' or . = 'audio/G729E' or . = 'audio/GSM' or . = 'audio/GSM-EFR' or . = 'audio/iLBC' or . = 'audio/L8' or . = 'audio/L16' or . = 'audio/L20' or . = 'audio/L24' or . = 'audio/LPC' or . = 'audio/mobile-xmf' or . = 'audio/MPA' or . = 'audio/mp4' or . = 'audio/MP4A-LATM' or . = 'audio/mpa-robust' or . = 'audio/mpeg' or . = 'audio/mpeg4-generic' or . = 'audio/parityfec' or . = 'audio/PCMA' or . = 'audio/PCMU' or . = 'audio/prs.sid' or . = 'audio/QCELP' or . = 'audio/RED' or . = 'audio/rtp-enc-aescm128' or . = 'audio/rRFC2045tp-midi' or . = 'audio/rtx' or . = 'audio/SMV' or . = 'audio/SMV0' or . = 'audio/SMV-QCP' or . = 'audio/sp-midi' or . = 'audio/t140c' or . = 'audio/t38' or . = 'audio/telephone-event' or . = 'audio/tone' or . = 'audio/ulpfec' or . = 'audio/VDVI' or . = 'audio/VMR-WB' or . = 'audio/vnd.3gpp.iufp' or . = 'audio/vnd.4SB' or . = 'audio/vnd.audiokoz' or . = 'audio/vnd.CELP' or . = 'audio/vnd.cisco.nse' or . = 'audio/vnd.cmles.radio-events' or . = 'audio/vnd.cns.anp1' or . = 'audio/vnd.cns.inf1' or . = 'audio/vnd.digital-winds' or . = 'audio/vnd.dlna.adts' or . = 'audio/vnd.dolby.mlp' or . = 'audio/vnd.everad.plj' or . = 'audio/vnd.hns.audio' or . = 'audio/vnd.lucent.voice' or . = 'audio/vnd.nokia.mobile-xmf' or . = 'audio/vnd.nortel.vbk' or . = 'audio/vnd.nuera.ecelp4800' or . = 'audio/vnd.nuera.ecelp7470' or . = 'audio/vnd.nuera.ecelp9600' or . = 'audio/vnd.octel.sbc' or . = 'audio/vnd.qcelp - DEPRECATED - Please use audio/qcelp' or . = 'audio/vnd.rhetorex.32kadpcm' or . = 'audio/vnd.sealedmedia.softseal.mpeg' or . = 'audio/vnd.vmx.cvsd' or . = 'image/cgm' or . = 'image/example' or . = 'image/fits' or . = 'image/g3fax' or . = 'image/gif' or . = 'image/ief' or . = 'image/jp2' or . = 'image/jpeg' or . = 'image/jpm' or . = 'image/jpx' or . = 'image/naplps' or . = 'image/png' or . = 'image/prs.btif' or . = 'image/prs.pti' or . = 'image/t38' or . = 'image/tiff' or . = 'image/tiff-fx' or . = 'image/vnd.adobe.photoshop' or . = 'image/vnd.cns.inf2' or . = 'image/vnd.djvu' or . = 'image/vnd.dwg' or . = 'image/vnd.dxf' or . = 'image/vnd.fastbidsheet' or . = 'image/vnd.fpx' or . = 'image/vnd.fst' or . = 'image/vnd.fujixerox.edmics-mmr' or . = 'image/vnd.fujixerox.edmics-rlc' or . = 'image/vnd.globalgraphics.pgb' or . = 'image/vnd.microsoft.icon' or . = 'image/vnd.mix' or . = 'image/vnd.ms-modi' or . = 'image/vnd.net-fpx' or . = 'image/vnd.sealed.png' or . = 'image/vnd.sealedmedia.softseal.gif' or . = 'image/vnd.sealedmedia.softseal.jpg' or . = 'image/vnd.svf' or . = 'image/vnd.wap.wbmp' or . = 'image/vnd.xiff' or . = 'message/CPIM' or . = 'message/delivery-status' or . = 'message/disposition-notification' or . = 'message/example' or . = 'message/external-body' or . = 'message/http' or . = 'message/news' or . = 'message/partial' or . = 'message/rfc822' or . = 'message/s-http' or . = 'message/sip' or . = 'message/sipfrag' or . = 'message/tracking-status' or . = 'message/vnd.si.simp' or . = 'model/example' or . = 'model/iges' or . = 'model/mesh' or . = 'model/vnd.dwf' or . = 'model/vnd.flatland.3dml' or . = 'model/vnd.gdl' or . = 'model/vnd.gs-gdl' or . = 'model/vnd.gtw' or . = 'model/vnd.moml+xml' or . = 'model/vnd.mts' or . = 'model/vnd.parasolid.transmit.binary' or . = 'model/vnd.parasolid.transmit.text' or . = 'model/vnd.vtu' or . = 'model/vrml' or . = 'multipart/alternative' or . = 'multipart/appledouble' or . = 'multipart/byteranges' or . = 'multipart/digest' or . = 'multipart/encrypted' or . = 'multipart/example' or . = 'multipart/form-data' or . = 'multipart/header-set' or . = 'multipart/mixed' or . = 'multipart/parallel' or . = 'multipart/related' or . = 'multipart/report' or . = 'multipart/signed' or . = 'multipart/voice-message' or . = 'text/calendar' or . = 'text/css' or . = 'text/csv' or . = 'text/directory' or . = 'text/dns' or . = 'text/ecmascript (obsolete)' or . = 'text/enriched' or . = 'text/example' or . = 'text/html' or . = 'text/javascript (obsolete)' or . = 'text/parityfec' or . = 'text/plain' or . = 'text/prs.fallenstein.rst' or . = 'text/prs.lines.tag' or . = 'text/RED' or . = 'text/rfc822-headers' or . = 'text/richtext' or . = 'text/rtf' or . = 'text/rtp-enc-aescm128' or . = 'text/rtx' or . = 'text/sgml' or . = 'text/t140' or . = 'text/tab-separated-values' or . = 'text/troff' or . = 'text/ulpfec' or . = 'text/uri-list' or . = 'text/vnd.abc' or . = 'text/vnd.curl' or . = 'text/vnd.DMClientScript' or . = 'text/vnd.esmertec.theme-descriptor' or . = 'text/vnd.fly' or . = 'text/vnd.fmi.flexstor' or . = 'text/vnd.in3d.3dml' or . = 'text/vnd.in3d.spot' or . = 'text/vnd.IPTC.NewsML' or . = 'text/vnd.IPTC.NITF' or . = 'text/vnd.latex-z' or . = 'text/vnd.motorola.reflex' or . = 'text/vnd.ms-mediapackage' or . = 'text/vnd.net2phone.commcenter.command' or . = 'text/vnd.si.uricatalogue' or . = 'text/vnd.sun.j2me.app-descriptor' or . = 'text/vnd.trolltech.linguist' or . = 'text/vnd.wap.si' or . = 'text/vnd.wap.sl' or . = 'text/vnd.wap.wml' or . = 'text/vnd.wap.wmlscript' or . = 'text/xml' or . = 'text/xml-external-parsed-entity' or . = 'video/3gpp' or . = 'video/3gpp2' or . = 'video/3gpp-tt' or . = 'video/BMPEG' or . = 'video/BT656' or . = 'video/CelB' or . = 'video/DV' or . = 'video/example' or . = 'video/H261' or . = 'video/H263' or . = 'video/H263-1998' or . = 'video/H263-2000' or . = 'video/H264' or . = 'video/JPEG' or . = 'video/MJ2' or . = 'video/MP1S' or . = 'video/MP2P' or . = 'video/MP2T' or . = 'video/mp4' or . = 'video/MP4V-ES' or . = 'video/MPV' or . = 'video/mpeg' or . = 'video/mpeg4-generic' or . = 'video/nv' or . = 'video/parityfec' or . = 'video/pointer' or . = 'video/quicktime' or . = 'video/raw' or . = 'video/rtp-enc-aescm128' or . = 'video/rtx' or . = 'video/SMPTE292M' or . = 'video/ulpfec' or . = 'video/vc1' or . = 'video/vnd.dlna.mpeg-tts' or . = 'video/vnd.fvt' or . = 'video/vnd.hns.video' or . = 'video/vnd.iptvforum.1dparityfec-1010' or . = 'video/vnd.iptvforum.1dparityfec-2005' or . = 'video/vnd.iptvforum.2dparityfec-1010' or . = 'video/vnd.iptvforum.2dparityfec-2005' or . = 'video/vnd.iptvforum.ttsavc' or . = 'video/vnd.iptvforum.ttsmpeg2' or . = 'video/vnd.motorola.video' or . = 'video/vnd.motorola.videop' or . = 'video/vnd.mpegurl' or . = 'video/vnd.nokia.interleaved-multimedia' or . = 'video/vnd.nokia.videovoip' or . = 'video/vnd.objectvideo' or . = 'video/vnd.sealed.mpeg1' or . = 'video/vnd.sealed.mpeg4' or . = 'video/vnd.sealed.swf' or . = 'video/vnd.sealedmedia.softseal.mov' or . = 'video/vnd.vivo' ) )"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="( ( . = 'application/activemessage' or . = 'application/andrew-inset' or . = 'application/applefile' or . = 'application/atom+xml' or . = 'application/atomicmail' or . = 'application/atomcat+xml' or . = 'application/atomsvc+xml' or . = 'application/auth-policy+xml' or . = 'application/batch-SMTP' or . = 'application/beep+xml' or . = 'application/cals-1840' or . = 'application/ccxml+xml' or . = 'application/cellml+xml' or . = 'application/cnrp+xml' or . = 'application/commonground' or . = 'application/conference-info+xml' or . = 'application/cpl+xml' or . = 'application/csta+xml' or . = 'application/CSTAdata+xml' or . = 'application/cybercash' or . = 'application/davmount+xml' or . = 'application/dca-rft' or . = 'application/dec-dx' or . = 'application/dialog-info+xml' or . = 'application/dicom' or . = 'application/dns' or . = 'application/dvcs' or . = 'application/ecmascript' or . = 'application/EDI-Consent' or . = 'application/EDIFACT' or . = 'application/EDI-X12' or . = 'application/epp+xml' or . = 'application/eshop' or . = 'application/example' or . = 'application/fastinfoset' or . = 'application/fastsoap' or . = 'application/fits' or . = 'application/font-tdpfr' or . = 'application/H224' or . = 'application/http' or . = 'application/hyperstudio' or . = 'application/iges' or . = 'application/im-iscomposing+xml' or . = 'application/index' or . = 'application/index.cmd' or . = 'application/index.obj' or . = 'application/index.response' or . = 'application/index.vnd' or . = 'application/iotp' or . = 'application/ipp' or . = 'application/isup' or . = 'application/javascript' or . = 'application/json' or . = 'application/kpml-request+xml' or . = 'application/kpml-response+xml' or . = 'application/mac-binhex40' or . = 'application/macwriteii' or . = 'application/marc' or . = 'application/mathematica' or . = 'application/mbms-associated-procedure-description+xml' or . = 'application/mbms-deregister+xml' or . = 'application/mbms-envelope+xml' or . = 'application/mbms-msk-response+xml' or . = 'application/mbms-msk+xml' or . = 'application/mbms-protection-description+xml' or . = 'application/mbms-reception-report+xml' or . = 'application/mbms-register-response+xml' or . = 'application/mbms-register+xml' or . = 'application/mbms-user-service-description+xml' or . = 'application/mbox' or . = 'application/media_control+xml' or . = 'application/mediaservercontrol+xml' or . = 'application/mikey' or . = 'application/moss-keys' or . = 'application/moss-signature' or . = 'application/mosskey-data' or . = 'application/mosskey-request' or . = 'application/mpeg4-generic' or . = 'application/mpeg4-iod' or . = 'application/mpeg4-iod-xmt' or . = 'application/mp4' or . = 'application/msword' or . = 'application/mxf' or . = 'application/nasdata' or . = 'application/news-message-id' or . = 'application/news-transmission' or . = 'application/nss' or . = 'application/ocsp-request' or . = 'application/ocsp-response' or . = 'application/octet-stream' or . = 'application/oda' or . = 'application/oebps-package+xml' or . = 'application/ogg' or . = 'application/parityfec' or . = 'application/pdf' or . = 'application/pgp-encrypted' or . = 'application/pgp-keys' or . = 'application/pgp-signature' or . = 'application/pidf+xml' or . = 'application/pkcs10' or . = 'application/pkcs7-mime' or . = 'application/pkcs7-signature' or . = 'application/pkix-cert' or . = 'application/pkixcmp' or . = 'application/pkix-crl' or . = 'application/pkix-pkipath' or . = 'application/pls+xml' or . = 'application/poc-settings+xml' or . = 'application/postscript' or . = 'application/prs.alvestrand.titrax-sheet' or . = 'application/prs.cww' or . = 'application/prs.nprend' or . = 'application/prs.plucker' or . = 'application/rdf+xml' or . = 'application/qsig' or . = 'application/reginfo+xml' or . = 'application/relax-ng-compact-syntax' or . = 'application/remote-printing' or . = 'application/resource-lists+xml' or . = 'application/riscos' or . = 'application/rlmi+xml' or . = 'application/rls-services+xml' or . = 'application/rtf' or . = 'application/rtx' or . = 'application/samlassertion+xml' or . = 'application/samlmetadata+xml' or . = 'application/sbml+xml' or . = 'application/scvp-cv-request' or . = 'application/scvp-cv-response' or . = 'application/scvp-vp-request' or . = 'application/scvp-vp-response' or . = 'application/sdp' or . = 'application/set-payment' or . = 'application/set-payment-initiation' or . = 'application/set-registration' or . = 'application/set-registration-initiation' or . = 'application/sgml' or . = 'application/sgml-open-catalog' or . = 'application/shf+xml' or . = 'application/sieve' or . = 'application/simple-filter+xml' or . = 'application/simple-message-summary' or . = 'application/simpleSymbolContainer' or . = 'application/slate' or . = 'application/smil (OBSOLETE)' or . = 'application/smil+xml' or . = 'application/soap+fastinfoset' or . = 'application/soap+xml' or . = 'application/sparql-query' or . = 'application/sparql-results+xml' or . = 'application/spirits-event+xml' or . = 'application/srgs' or . = 'application/srgs+xml' or . = 'application/ssml+xml' or . = 'application/timestamp-query' or . = 'application/timestamp-reply' or . = 'application/tve-trigger' or . = 'application/ulpfec' or . = 'application/vemmi' or . = 'application/vnd.3gpp.bsf+xml' or . = 'application/vnd.3gpp.pic-bw-large' or . = 'application/vnd.3gpp.pic-bw-small' or . = 'application/vnd.3gpp.pic-bw-var' or . = 'application/vnd.3gpp.sms' or . = 'application/vnd.3gpp2.bcmcsinfo+xml' or . = 'application/vnd.3gpp2.sms' or . = 'application/vnd.3gpp2.tcap' or . = 'application/vnd.3M.Post-it-Notes' or . = 'application/vnd.accpac.simply.aso' or . = 'application/vnd.accpac.simply.imp' or . = 'application/vnd.acucobol' or . = 'application/vnd.acucorp' or . = 'application/vnd.adobe.xdp+xml' or . = 'application/vnd.adobe.xfdf' or . = 'application/vnd.aether.imp' or . = 'application/vnd.americandynamics.acc' or . = 'application/vnd.amiga.ami' or . = 'application/vnd.anser-web-certificate-issue-initiation' or . = 'application/vnd.antix.game-component' or . = 'application/vnd.apple.installer+xml' or . = 'application/vnd.audiograph' or . = 'application/vnd.autopackage' or . = 'application/vnd.avistar+xml' or . = 'application/vnd.blueice.multipass' or . = 'application/vnd.bmi' or . = 'application/vnd.businessobjects' or . = 'application/vnd.cab-jscript' or . = 'application/vnd.canon-cpdl' or . = 'application/vnd.canon-lips' or . = 'application/vnd.cendio.thinlinc.clientconf' or . = 'application/vnd.chemdraw+xml' or . = 'application/vnd.chipnuts.karaoke-mmd' or . = 'application/vnd.cinderella' or . = 'application/vnd.cirpack.isdn-ext' or . = 'application/vnd.claymore' or . = 'application/vnd.clonk.c4group' or . = 'application/vnd.commerce-battelle' or . = 'application/vnd.commonspace' or . = 'application/vnd.cosmocaller' or . = 'application/vnd.contact.cmsg' or . = 'application/vnd.crick.clicker' or . = 'application/vnd.crick.clicker.keyboard' or . = 'application/vnd.crick.clicker.palette' or . = 'application/vnd.crick.clicker.template' or . = 'application/vnd.crick.clicker.wordbank' or . = 'application/vnd.criticaltools.wbs+xml' or . = 'application/vnd.ctc-posml' or . = 'application/vnd.ctct.ws+xml' or . = 'application/vnd.cups-pdf' or . = 'application/vnd.cups-postscript' or . = 'application/vnd.cups-ppd' or . = 'application/vnd.cups-raster' or . = 'application/vnd.cups-raw' or . = 'application/vnd.curl' or . = 'application/vnd.cybank' or . = 'application/vnd.data-vision.rdz' or . = 'application/vnd.denovo.fcselayout-link' or . = 'application/vnd.dna' or . = 'application/vnd.dpgraph' or . = 'application/vnd.dreamfactory' or . = 'application/vnd.dvb.esgcontainer' or . = 'application/vnd.dvb.ipdcesgaccess' or . = 'application/vnd.dxr' or . = 'application/vnd.ecdis-update' or . = 'application/vnd.ecowin.chart' or . = 'application/vnd.ecowin.filerequest' or . = 'application/vnd.ecowin.fileupdate' or . = 'application/vnd.ecowin.series' or . = 'application/vnd.ecowin.seriesrequest' or . = 'application/vnd.ecowin.seriesupdate' or . = 'application/vnd.enliven' or . = 'application/vnd.epson.esf' or . = 'application/vnd.epson.msf' or . = 'application/vnd.epson.quickanime' or . = 'application/vnd.epson.salt' or . = 'application/vnd.epson.ssf' or . = 'application/vnd.ericsson.quickcall' or . = 'application/vnd.eszigno3+xml' or . = 'application/vnd.eudora.data' or . = 'application/vnd.ezpix-album' or . = 'application/vnd.ezpix-package' or . = 'application/vnd.fdf' or . = 'application/vnd.ffsns' or . = 'application/vnd.fints' or . = 'application/vnd.FloGraphIt' or . = 'application/vnd.fluxtime.clip' or . = 'application/vnd.framemaker' or . = 'application/vnd.frogans.fnc' or . = 'application/vnd.frogans.ltf' or . = 'application/vnd.fsc.weblaunch' or . = 'application/vnd.fujitsu.oasys' or . = 'application/vnd.fujitsu.oasys2' or . = 'application/vnd.fujitsu.oasys3' or . = 'application/vnd.fujitsu.oasysgp' or . = 'application/vnd.fujitsu.oasysprs' or . = 'application/vnd.fujixerox.ART4' or . = 'application/vnd.fujixerox.ART-EX' or . = 'application/vnd.fujixerox.ddd' or . = 'application/vnd.fujixerox.docuworks' or . = 'application/vnd.fujixerox.docuworks.binder' or . = 'application/vnd.fujixerox.HBPL' or . = 'application/vnd.fut-misnet' or . = 'application/vnd.fuzzysheet' or . = 'application/vnd.genomatix.tuxedo' or . = 'application/vnd.google-earth.kml+xml' or . = 'application/vnd.google-earth.kmz' or . = 'application/vnd.grafeq' or . = 'application/vnd.gridmp' or . = 'application/vnd.groove-account' or . = 'application/vnd.groove-help' or . = 'application/vnd.groove-identity-message' or . = 'application/vnd.groove-injector' or . = 'application/vnd.groove-tool-message' or . = 'application/vnd.groove-tool-template' or . = 'application/vnd.groove-vcard' or . = 'application/vnd.HandHeld-Entertainment+xml' or . = 'application/vnd.hbci' or . = 'application/vnd.hcl-bireports' or . = 'application/vnd.hhe.lesson-player' or . = 'application/vnd.hp-HPGL' or . = 'application/vnd.hp-hpid' or . = 'application/vnd.hp-hps' or . = 'application/vnd.hp-jlyt' or . = 'application/vnd.hp-PCL' or . = 'application/vnd.hp-PCLXL' or . = 'application/vnd.httphone' or . = 'application/vnd.hzn-3d-crossword' or . = 'application/vnd.ibm.afplinedata' or . = 'application/vnd.ibm.electronic-media' or . = 'application/vnd.ibm.MiniPay' or . = 'application/vnd.ibm.modcap' or . = 'application/vnd.ibm.rights-management' or . = 'application/vnd.ibm.secure-container' or . = 'application/vnd.iccprofile' or . = 'application/vnd.igloader' or . = 'application/vnd.immervision-ivp' or . = 'application/vnd.immervision-ivu' or . = 'application/vnd.informedcontrol.rms+xml' or . = 'application/vnd.informix-visionary' or . = 'application/vnd.intercon.formnet' or . = 'application/vnd.intertrust.digibox' or . = 'application/vnd.intertrust.nncp' or . = 'application/vnd.intu.qbo' or . = 'application/vnd.intu.qfx' or . = 'application/vnd.ipunplugged.rcprofile' or . = 'application/vnd.irepository.package+xml' or . = 'application/vnd.is-xpr' or . = 'application/vnd.jam' or . = 'application/vnd.japannet-directory-service' or . = 'application/vnd.japannet-jpnstore-wakeup' or . = 'application/vnd.japannet-payment-wakeup' or . = 'application/vnd.japannet-registration' or . = 'application/vnd.japannet-registration-wakeup' or . = 'application/vnd.japannet-setstore-wakeup' or . = 'application/vnd.japannet-verification' or . = 'application/vnd.japannet-verification-wakeup' or . = 'application/vnd.jcp.javame.midlet-rms' or . = 'application/vnd.jisp' or . = 'application/vnd.joost.joda-archive' or . = 'application/vnd.kahootz' or . = 'application/vnd.kde.karbon' or . = 'application/vnd.kde.kchart' or . = 'application/vnd.kde.kformula' or . = 'application/vnd.kde.kivio' or . = 'application/vnd.kde.kontour' or . = 'application/vnd.kde.kpresenter' or . = 'application/vnd.kde.kspread' or . = 'application/vnd.kde.kword' or . = 'application/vnd.kenameaapp' or . = 'application/vnd.kidspiration' or . = 'application/vnd.Kinar' or . = 'application/vnd.koan' or . = 'application/vnd.kodak-descriptor' or . = 'application/vnd.liberty-request+xml' or . = 'application/vnd.llamagraphics.life-balance.desktop' or . = 'application/vnd.llamagraphics.life-balance.exchange+xml' or . = 'application/vnd.lotus-1-2-3' or . = 'application/vnd.lotus-approach' or . = 'application/vnd.lotus-freelance' or . = 'application/vnd.lotus-notes' or . = 'application/vnd.lotus-organizer' or . = 'application/vnd.lotus-screencam' or . = 'application/vnd.lotus-wordpro' or . = 'application/vnd.macports.portpkg' or . = 'application/vnd.marlin.drm.actiontoken+xml' or . = 'application/vnd.marlin.drm.conftoken+xml' or . = 'application/vnd.marlin.drm.mdcf' or . = 'application/vnd.mcd' or . = 'application/vnd.medcalcdata' or . = 'application/vnd.mediastation.cdkey' or . = 'application/vnd.meridian-slingshot' or . = 'application/vnd.MFER' or . = 'application/vnd.mfmp' or . = 'application/vnd.micrografx.flo' or . = 'application/vnd.micrografx.igx' or . = 'application/vnd.mif' or . = 'application/vnd.minisoft-hp3000-save' or . = 'application/vnd.mitsubishi.misty-guard.trustweb' or . = 'application/vnd.Mobius.DAF' or . = 'application/vnd.Mobius.DIS' or . = 'application/vnd.Mobius.MBK' or . = 'application/vnd.Mobius.MQY' or . = 'application/vnd.Mobius.MSL' or . = 'application/vnd.Mobius.PLC' or . = 'application/vnd.Mobius.TXF' or . = 'application/vnd.mophun.application' or . = 'application/vnd.mophun.certificate' or . = 'application/vnd.motorola.flexsuite' or . = 'application/vnd.motorola.flexsuite.adsi' or . = 'application/vnd.motorola.flexsuite.fis' or . = 'application/vnd.motorola.flexsuite.gotap' or . = 'application/vnd.motorola.flexsuite.kmr' or . = 'application/vnd.motorola.flexsuite.ttc' or . = 'application/vnd.motorola.flexsuite.wem' or . = 'application/vnd.mozilla.xul+xml' or . = 'application/vnd.ms-artgalry' or . = 'application/vnd.ms-asf' or . = 'application/vnd.ms-cab-compressed' or . = 'application/vnd.mseq' or . = 'application/vnd.ms-excel' or . = 'application/vnd.ms-fontobject' or . = 'application/vnd.ms-htmlhelp' or . = 'application/vnd.msign' or . = 'application/vnd.ms-ims' or . = 'application/vnd.ms-lrm' or . = 'application/vnd.ms-playready.initiator+xml' or . = 'application/vnd.ms-powerpoint' or . = 'application/vnd.ms-project' or . = 'application/vnd.ms-tnef' or . = 'application/vnd.ms-wmdrm.lic-chlg-req' or . = 'application/vnd.ms-wmdrm.lic-resp' or . = 'application/vnd.ms-wmdrm.meter-chlg-req' or . = 'application/vnd.ms-wmdrm.meter-resp' or . = 'application/vnd.ms-works' or . = 'application/vnd.ms-wpl' or . = 'application/vnd.ms-xpsdocument' or . = 'application/vnd.multiad.creator' or . = 'application/vnd.multiad.creator.cif' or . = 'application/vnd.musician' or . = 'application/vnd.music-niff' or . = 'application/vnd.muvee.style' or . = 'application/vnd.ncd.control' or . = 'application/vnd.ncd.reference' or . = 'application/vnd.nervana' or . = 'application/vnd.netfpx' or . = 'application/vnd.neurolanguage.nlu' or . = 'application/vnd.noblenet-directory' or . = 'application/vnd.noblenet-sealer' or . = 'application/vnd.noblenet-web' or . = 'application/vnd.nokia.catalogs' or . = 'application/vnd.nokia.conml+wbxml' or . = 'application/vnd.nokia.conml+xml' or . = 'application/vnd.nokia.iptv.config+xml' or . = 'application/vnd.nokia.iSDS-radio-presets' or . = 'application/vnd.nokia.landmark+wbxml' or . = 'application/vnd.nokia.landmark+xml' or . = 'application/vnd.nokia.landmarkcollection+xml' or . = 'application/vnd.nokia.ncd' or . = 'application/vnd.nokia.n-gage.ac+xml' or . = 'application/vnd.nokia.n-gage.data' or . = 'application/vnd.nokia.n-gage.symbian.install' or . = 'application/vnd.nokia.pcd+wbxml' or . = 'application/vnd.nokia.pcd+xml' or . = 'application/vnd.nokia.radio-preset' or . = 'application/vnd.nokia.radio-presets' or . = 'application/vnd.novadigm.EDM' or . = 'application/vnd.novadigm.EDX' or . = 'application/vnd.novadigm.EXT' or . = 'application/vnd.oasis.opendocument.chart' or . = 'application/vnd.oasis.opendocument.chart-template' or . = 'application/vnd.oasis.opendocument.formula' or . = 'application/vnd.oasis.opendocument.formula-template' or . = 'application/vnd.oasis.opendocument.graphics' or . = 'application/vnd.oasis.opendocument.graphics-template' or . = 'application/vnd.oasis.opendocument.image' or . = 'application/vnd.oasis.opendocument.image-template' or . = 'application/vnd.oasis.opendocument.presentation' or . = 'application/vnd.oasis.opendocument.presentation-template' or . = 'application/vnd.oasis.opendocument.spreadsheet' or . = 'application/vnd.oasis.opendocument.spreadsheet-template' or . = 'application/vnd.oasis.opendocument.text' or . = 'application/vnd.oasis.opendocument.text-master' or . = 'application/vnd.oasis.opendocument.text-template' or . = 'application/vnd.oasis.opendocument.text-web' or . = 'application/vnd.obn' or . = 'application/vnd.olpc-sugar' or . = 'application/vnd.oma.bcast.associated-procedure-parameter+xml' or . = 'application/vnd.oma.bcast.drm-trigger+xml' or . = 'application/vnd.oma.bcast.imd+xml' or . = 'application/vnd.oma.bcast.ltkm' or . = 'application/vnd.oma.bcast.notification+xml' or . = 'application/vnd.oma.bcast.sgboot' or . = 'application/vnd.oma.bcast.sgdd+xml' or . = 'application/vnd.oma.bcast.sgdu' or . = 'application/vnd.oma.bcast.simple-symbol-container' or . = 'application/vnd.oma.bcast.smartcard-trigger+xml' or . = 'application/vnd.oma.bcast.sprov+xml' or . = 'application/vnd.oma.bcast.stkm' or . = 'application/vnd.oma.dd2+xml' or . = 'application/vnd.oma.drm.risd+xml' or . = 'application/vnd.oma.group-usage-list+xml' or . = 'application/vnd.oma.poc.detailed-progress-report+xml' or . = 'application/vnd.oma.poc.final-report+xml' or . = 'application/vnd.oma.poc.groups+xml' or . = 'application/vnd.oma.poc.invocation-descriptor+xml' or . = 'application/vnd.oma.poc.optimized-progress-report+xml' or . = 'application/vnd.oma.xcap-directory+xml' or . = 'application/vnd.omads-email+xml' or . = 'application/vnd.omads-file+xml' or . = 'application/vnd.omads-folder+xml' or . = 'application/vnd.omaloc-supl-init' or . = 'application/vnd.oma-scws-config' or . = 'application/vnd.oma-scws-http-request' or . = 'application/vnd.oma-scws-http-response' or . = 'application/vnd.openofficeorg.extension' or . = 'application/vnd.osa.netdeploy' or . = 'application/vnd.osgi.bundle' or . = 'application/vnd.osgi.dp' or . = 'application/vnd.otps.ct-kip+xml' or . = 'application/vnd.palm' or . = 'application/vnd.paos.xml' or . = 'application/vnd.pg.format' or . = 'application/vnd.pg.osasli' or . = 'application/vnd.piaccess.application-licence' or . = 'application/vnd.picsel' or . = 'application/vnd.poc.group-advertisement+xml' or . = 'application/vnd.pocketlearn' or . = 'application/vnd.powerbuilder6' or . = 'application/vnd.powerbuilder6-s' or . = 'application/vnd.powerbuilder7' or . = 'application/vnd.powerbuilder75' or . = 'application/vnd.powerbuilder75-s' or . = 'application/vnd.powerbuilder7-s' or . = 'application/vnd.preminet' or . = 'application/vnd.previewsystems.box' or . = 'application/vnd.proteus.magazine' or . = 'application/vnd.publishare-delta-tree' or . = 'application/vnd.pvi.ptid1' or . = 'application/vnd.pwg-multiplexed' or . = 'application/vnd.pwg-xhtml-print+xml' or . = 'application/vnd.qualcomm.brew-app-res' or . = 'application/vnd.Quark.QuarkXPress' or . = 'application/vnd.rapid' or . = 'application/vnd.recordare.musicxml' or . = 'application/vnd.recordare.musicxml+xml' or . = 'application/vnd.RenLearn.rlprint' or . = 'application/vnd.ruckus.download' or . = 'application/vnd.s3sms' or . = 'application/vnd.sbm.mid2' or . = 'application/vnd.scribus' or . = 'application/vnd.sealed.3df' or . = 'application/vnd.sealed.csf' or . = 'application/vnd.sealed.doc' or . = 'application/vnd.sealed.eml' or . = 'application/vnd.sealed.mht' or . = 'application/vnd.sealed.net' or . = 'application/vnd.sealed.ppt' or . = 'application/vnd.sealed.tiff' or . = 'application/vnd.sealed.xls' or . = 'application/vnd.sealedmedia.softseal.html' or . = 'application/vnd.sealedmedia.softseal.pdf' or . = 'application/vnd.seemail' or . = 'application/vnd.sema' or . = 'application/vnd.semd' or . = 'application/vnd.semf' or . = 'application/vnd.shana.informed.formdata' or . = 'application/vnd.shana.informed.formtemplate' or . = 'application/vnd.shana.informed.interchange' or . = 'application/vnd.shana.informed.package' or . = 'application/vnd.SimTech-MindMapper' or . = 'application/vnd.smaf' or . = 'application/vnd.solent.sdkm+xml' or . = 'application/vnd.spotfire.dxp' or . = 'application/vnd.spotfire.sfs' or . = 'application/vnd.sss-cod' or . = 'application/vnd.sss-dtf' or . = 'application/vnd.sss-ntf' or . = 'application/vnd.street-stream' or . = 'application/vnd.sun.wadl+xml' or . = 'application/vnd.sus-calendar' or . = 'application/vnd.svd' or . = 'application/vnd.swiftview-ics' or . = 'application/vnd.syncml.dm+wbxml' or . = 'application/vnd.syncml.dm+xml' or . = 'application/vnd.syncml.ds.notification' or . = 'application/vnd.syncml+xml' or . = 'application/vnd.tao.intent-module-archive' or . = 'application/vnd.tmobile-livetv' or . = 'application/vnd.trid.tpt' or . = 'application/vnd.triscape.mxs' or . = 'application/vnd.trueapp' or . = 'application/vnd.truedoc' or . = 'application/vnd.ufdl' or . = 'application/vnd.uiq.theme' or . = 'application/vnd.umajin' or . = 'application/vnd.unity' or . = 'application/vnd.uoml+xml' or . = 'application/vnd.uplanet.alert' or . = 'application/vnd.uplanet.alert-wbxml' or . = 'application/vnd.uplanet.bearer-choice' or . = 'application/vnd.uplanet.bearer-choice-wbxml' or . = 'application/vnd.uplanet.cacheop' or . = 'application/vnd.uplanet.cacheop-wbxml' or . = 'application/vnd.uplanet.channel' or . = 'application/vnd.uplanet.channel-wbxml' or . = 'application/vnd.uplanet.list' or . = 'application/vnd.uplanet.listcmd' or . = 'application/vnd.uplanet.listcmd-wbxml' or . = 'application/vnd.uplanet.list-wbxml' or . = 'application/vnd.uplanet.signal' or . = 'application/vnd.vcx' or . = 'application/vnd.vectorworks' or . = 'application/vnd.vd-study' or . = 'application/vnd.vidsoft.vidconference' or . = 'application/vnd.visio' or . = 'application/vnd.visionary' or . = 'application/vnd.vividence.scriptfile' or . = 'application/vnd.vsf' or . = 'application/vnd.wap.sic' or . = 'application/vnd.wap.slc' or . = 'application/vnd.wap.wbxml' or . = 'application/vnd.wap.wmlc' or . = 'application/vnd.wap.wmlscriptc' or . = 'application/vnd.webturbo' or . = 'application/vnd.wfa.wsc' or . = 'application/vnd.wmc' or . = 'application/vnd.wmf.bootstrap' or . = 'application/vnd.wordperfect' or . = 'application/vnd.wqd' or . = 'application/vnd.wrq-hp3000-labelled' or . = 'application/vnd.wt.stf' or . = 'application/vnd.wv.csp+xml' or . = 'application/vnd.wv.csp+wbxml' or . = 'application/vnd.wv.ssp+xml' or . = 'application/vnd.xara' or . = 'application/vnd.xfdl' or . = 'application/vnd.xmpie.cpkg' or . = 'application/vnd.xmpie.dpkg' or . = 'application/vnd.xmpie.plan' or . = 'application/vnd.xmpie.ppkg' or . = 'application/vnd.xmpie.xlim' or . = 'application/vnd.yamaha.hv-dic' or . = 'application/vnd.yamaha.hv-script' or . = 'application/vnd.yamaha.hv-voice' or . = 'application/vnd.yamaha.smaf-audio' or . = 'application/vnd.yamaha.smaf-phrase' or . = 'application/vnd.yellowriver-custom-menu' or . = 'application/vnd.zzazz.deck+xml' or . = 'application/voicexml+xml' or . = 'application/watcherinfo+xml' or . = 'application/whoispp-query' or . = 'application/whoispp-response' or . = 'application/wita' or . = 'application/wordperfect5.1' or . = 'application/wsdl+xml' or . = 'application/wspolicy+xml' or . = 'application/x400-bp' or . = 'application/xcap-att+xml' or . = 'application/xcap-caps+xml' or . = 'application/xcap-el+xml' or . = 'application/xcap-error+xml' or . = 'application/xcap-ns+xml' or . = 'application/xenc+xml' or . = 'application/xhtml-voice+xml (Obsolete)' or . = 'application/xhtml+xml' or . = 'application/xml' or . = 'application/xml-dtd' or . = 'application/xml-external-parsed-entity' or . = 'application/xmpp+xml' or . = 'application/xop+xml' or . = 'application/xv+xml' or . = 'application/zip' or . = 'audio/32kadpcm' or . = 'audio/3gpp' or . = 'audio/3gpp2' or . = 'audio/ac3' or . = 'audio/AMR' or . = 'audio/AMR-WB' or . = 'audio/amr-wb+' or . = 'audio/asc' or . = 'audio/basic' or . = 'audio/BV16' or . = 'audio/BV32' or . = 'audio/clearmode' or . = 'audio/CN' or . = 'audio/DAT12' or . = 'audio/dls' or . = 'audio/dsr-es201108' or . = 'audio/dsr-es202050' or . = 'audio/dsr-es202211' or . = 'audio/dsr-es202212' or . = 'audio/eac3' or . = 'audio/DVI4' or . = 'audio/EVRC' or . = 'audio/EVRC0' or . = 'audio/EVRC1' or . = 'audio/EVRCB' or . = 'audio/EVRCB0' or . = 'audio/EVRCB1' or . = 'audio/EVRC-QCP' or . = 'audio/EVRCWB' or . = 'audio/EVRCWB0' or . = 'audio/EVRCWB1' or . = 'audio/example' or . = 'audio/G722' or . = 'audio/G7221' or . = 'audio/G723' or . = 'audio/G726-16' or . = 'audio/G726-24' or . = 'audio/G726-32' or . = 'audio/G726-40' or . = 'audio/G728' or . = 'audio/G729' or . = 'audio/G7291' or . = 'audio/G729D' or . = 'audio/G729E' or . = 'audio/GSM' or . = 'audio/GSM-EFR' or . = 'audio/iLBC' or . = 'audio/L8' or . = 'audio/L16' or . = 'audio/L20' or . = 'audio/L24' or . = 'audio/LPC' or . = 'audio/mobile-xmf' or . = 'audio/MPA' or . = 'audio/mp4' or . = 'audio/MP4A-LATM' or . = 'audio/mpa-robust' or . = 'audio/mpeg' or . = 'audio/mpeg4-generic' or . = 'audio/parityfec' or . = 'audio/PCMA' or . = 'audio/PCMU' or . = 'audio/prs.sid' or . = 'audio/QCELP' or . = 'audio/RED' or . = 'audio/rtp-enc-aescm128' or . = 'audio/rRFC2045tp-midi' or . = 'audio/rtx' or . = 'audio/SMV' or . = 'audio/SMV0' or . = 'audio/SMV-QCP' or . = 'audio/sp-midi' or . = 'audio/t140c' or . = 'audio/t38' or . = 'audio/telephone-event' or . = 'audio/tone' or . = 'audio/ulpfec' or . = 'audio/VDVI' or . = 'audio/VMR-WB' or . = 'audio/vnd.3gpp.iufp' or . = 'audio/vnd.4SB' or . = 'audio/vnd.audiokoz' or . = 'audio/vnd.CELP' or . = 'audio/vnd.cisco.nse' or . = 'audio/vnd.cmles.radio-events' or . = 'audio/vnd.cns.anp1' or . = 'audio/vnd.cns.inf1' or . = 'audio/vnd.digital-winds' or . = 'audio/vnd.dlna.adts' or . = 'audio/vnd.dolby.mlp' or . = 'audio/vnd.everad.plj' or . = 'audio/vnd.hns.audio' or . = 'audio/vnd.lucent.voice' or . = 'audio/vnd.nokia.mobile-xmf' or . = 'audio/vnd.nortel.vbk' or . = 'audio/vnd.nuera.ecelp4800' or . = 'audio/vnd.nuera.ecelp7470' or . = 'audio/vnd.nuera.ecelp9600' or . = 'audio/vnd.octel.sbc' or . = 'audio/vnd.qcelp - DEPRECATED - Please use audio/qcelp' or . = 'audio/vnd.rhetorex.32kadpcm' or . = 'audio/vnd.sealedmedia.softseal.mpeg' or . = 'audio/vnd.vmx.cvsd' or . = 'image/cgm' or . = 'image/example' or . = 'image/fits' or . = 'image/g3fax' or . = 'image/gif' or . = 'image/ief' or . = 'image/jp2' or . = 'image/jpeg' or . = 'image/jpm' or . = 'image/jpx' or . = 'image/naplps' or . = 'image/png' or . = 'image/prs.btif' or . = 'image/prs.pti' or . = 'image/t38' or . = 'image/tiff' or . = 'image/tiff-fx' or . = 'image/vnd.adobe.photoshop' or . = 'image/vnd.cns.inf2' or . = 'image/vnd.djvu' or . = 'image/vnd.dwg' or . = 'image/vnd.dxf' or . = 'image/vnd.fastbidsheet' or . = 'image/vnd.fpx' or . = 'image/vnd.fst' or . = 'image/vnd.fujixerox.edmics-mmr' or . = 'image/vnd.fujixerox.edmics-rlc' or . = 'image/vnd.globalgraphics.pgb' or . = 'image/vnd.microsoft.icon' or . = 'image/vnd.mix' or . = 'image/vnd.ms-modi' or . = 'image/vnd.net-fpx' or . = 'image/vnd.sealed.png' or . = 'image/vnd.sealedmedia.softseal.gif' or . = 'image/vnd.sealedmedia.softseal.jpg' or . = 'image/vnd.svf' or . = 'image/vnd.wap.wbmp' or . = 'image/vnd.xiff' or . = 'message/CPIM' or . = 'message/delivery-status' or . = 'message/disposition-notification' or . = 'message/example' or . = 'message/external-body' or . = 'message/http' or . = 'message/news' or . = 'message/partial' or . = 'message/rfc822' or . = 'message/s-http' or . = 'message/sip' or . = 'message/sipfrag' or . = 'message/tracking-status' or . = 'message/vnd.si.simp' or . = 'model/example' or . = 'model/iges' or . = 'model/mesh' or . = 'model/vnd.dwf' or . = 'model/vnd.flatland.3dml' or . = 'model/vnd.gdl' or . = 'model/vnd.gs-gdl' or . = 'model/vnd.gtw' or . = 'model/vnd.moml+xml' or . = 'model/vnd.mts' or . = 'model/vnd.parasolid.transmit.binary' or . = 'model/vnd.parasolid.transmit.text' or . = 'model/vnd.vtu' or . = 'model/vrml' or . = 'multipart/alternative' or . = 'multipart/appledouble' or . = 'multipart/byteranges' or . = 'multipart/digest' or . = 'multipart/encrypted' or . = 'multipart/example' or . = 'multipart/form-data' or . = 'multipart/header-set' or . = 'multipart/mixed' or . = 'multipart/parallel' or . = 'multipart/related' or . = 'multipart/report' or . = 'multipart/signed' or . = 'multipart/voice-message' or . = 'text/calendar' or . = 'text/css' or . = 'text/csv' or . = 'text/directory' or . = 'text/dns' or . = 'text/ecmascript (obsolete)' or . = 'text/enriched' or . = 'text/example' or . = 'text/html' or . = 'text/javascript (obsolete)' or . = 'text/parityfec' or . = 'text/plain' or . = 'text/prs.fallenstein.rst' or . = 'text/prs.lines.tag' or . = 'text/RED' or . = 'text/rfc822-headers' or . = 'text/richtext' or . = 'text/rtf' or . = 'text/rtp-enc-aescm128' or . = 'text/rtx' or . = 'text/sgml' or . = 'text/t140' or . = 'text/tab-separated-values' or . = 'text/troff' or . = 'text/ulpfec' or . = 'text/uri-list' or . = 'text/vnd.abc' or . = 'text/vnd.curl' or . = 'text/vnd.DMClientScript' or . = 'text/vnd.esmertec.theme-descriptor' or . = 'text/vnd.fly' or . = 'text/vnd.fmi.flexstor' or . = 'text/vnd.in3d.3dml' or . = 'text/vnd.in3d.spot' or . = 'text/vnd.IPTC.NewsML' or . = 'text/vnd.IPTC.NITF' or . = 'text/vnd.latex-z' or . = 'text/vnd.motorola.reflex' or . = 'text/vnd.ms-mediapackage' or . = 'text/vnd.net2phone.commcenter.command' or . = 'text/vnd.si.uricatalogue' or . = 'text/vnd.sun.j2me.app-descriptor' or . = 'text/vnd.trolltech.linguist' or . = 'text/vnd.wap.si' or . = 'text/vnd.wap.sl' or . = 'text/vnd.wap.wml' or . = 'text/vnd.wap.wmlscript' or . = 'text/xml' or . = 'text/xml-external-parsed-entity' or . = 'video/3gpp' or . = 'video/3gpp2' or . = 'video/3gpp-tt' or . = 'video/BMPEG' or . = 'video/BT656' or . = 'video/CelB' or . = 'video/DV' or . = 'video/example' or . = 'video/H261' or . = 'video/H263' or . = 'video/H263-1998' or . = 'video/H263-2000' or . = 'video/H264' or . = 'video/JPEG' or . = 'video/MJ2' or . = 'video/MP1S' or . = 'video/MP2P' or . = 'video/MP2T' or . = 'video/mp4' or . = 'video/MP4V-ES' or . = 'video/MPV' or . = 'video/mpeg' or . = 'video/mpeg4-generic' or . = 'video/nv' or . = 'video/parityfec' or . = 'video/pointer' or . = 'video/quicktime' or . = 'video/raw' or . = 'video/rtp-enc-aescm128' or . = 'video/rtx' or . = 'video/SMPTE292M' or . = 'video/ulpfec' or . = 'video/vc1' or . = 'video/vnd.dlna.mpeg-tts' or . = 'video/vnd.fvt' or . = 'video/vnd.hns.video' or . = 'video/vnd.iptvforum.1dparityfec-1010' or . = 'video/vnd.iptvforum.1dparityfec-2005' or . = 'video/vnd.iptvforum.2dparityfec-1010' or . = 'video/vnd.iptvforum.2dparityfec-2005' or . = 'video/vnd.iptvforum.ttsavc' or . = 'video/vnd.iptvforum.ttsmpeg2' or . = 'video/vnd.motorola.video' or . = 'video/vnd.motorola.videop' or . = 'video/vnd.mpegurl' or . = 'video/vnd.nokia.interleaved-multimedia' or . = 'video/vnd.nokia.videovoip' or . = 'video/vnd.objectvideo' or . = 'video/vnd.sealed.mpeg1' or . = 'video/vnd.sealed.mpeg4' or . = 'video/vnd.sealed.swf' or . = 'video/vnd.sealedmedia.softseal.mov' or . = 'video/vnd.vivo' ) )">
               <xsl:attribute name="id">CL-T10-R008</xsl:attribute>
               <xsl:attribute name="flag">fatal</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>[CL-T10-R008]-For Mime code in attribute use MIMEMediaType.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="@*|*|comment()|processing-instruction()" mode="M5"/>
   </xsl:template>

	  <!--RULE -->
   <xsl:template match="cac:AllowanceCharge//cbc:AllowanceChargeReasonCode"
                 priority="1000"
                 mode="M5">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="cac:AllowanceCharge//cbc:AllowanceChargeReasonCode"/>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="( ( not(contains(normalize-space(.),' ')) and contains( ' 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35 36 37 38 39 40 41 42 43 44 45 46 47 48 49 50 51 52 53 54 55 56 57 58 59 60 61 62 63 64 65 66 67 68 69 70 71 72 73 74 75 76 77 78 79 80 81 82 83 84 85 86 87 88 89 90 91 92 93 94 95 96 97 ',concat(' ',normalize-space(.),' ') ) ) )"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="( ( not(contains(normalize-space(.),' ')) and contains( ' 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35 36 37 38 39 40 41 42 43 44 45 46 47 48 49 50 51 52 53 54 55 56 57 58 59 60 61 62 63 64 65 66 67 68 69 70 71 72 73 74 75 76 77 78 79 80 81 82 83 84 85 86 87 88 89 90 91 92 93 94 95 96 97 ',concat(' ',normalize-space(.),' ') ) ) )">
               <xsl:attribute name="id">CL-T10-R010</xsl:attribute>
               <xsl:attribute name="flag">warning</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>[CL-T10-R010]-Coded allowance and charge reasons SHOULD belong to the UNCL 4465 code list BII2 subset</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="@*|*|comment()|processing-instruction()" mode="M5"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M5"/>
   <xsl:template match="@*|node()" priority="-2" mode="M5">
      <xsl:apply-templates select="@*|*|comment()|processing-instruction()" mode="M5"/>
   </xsl:template>
   
   <!--PATTERN EUGEN-UBL-T10-->


	  <!--RULE -->
   <xsl:template match="/ubl:Invoice/cac:AllowanceCharge" priority="1023" mode="M6">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="/ubl:Invoice/cac:AllowanceCharge"/>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="not(cbc:MultiplierFactorNumeric) or number(cbc:MultiplierFactorNumeric) &gt;=0"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="not(cbc:MultiplierFactorNumeric) or number(cbc:MultiplierFactorNumeric) &gt;=0">
               <xsl:attribute name="id">EUGEN-T10-R012</xsl:attribute>
               <xsl:attribute name="flag">fatal</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>[EUGEN-T10-R012]-An allowance percentage MUST NOT be negative.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="number(cbc:Amount)&gt;=0"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="number(cbc:Amount)&gt;=0">
               <xsl:attribute name="id">EUGEN-T10-R022</xsl:attribute>
               <xsl:attribute name="flag">fatal</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>[EUGEN-T10-R022]-An allowance or charge amount MUST NOT be negative.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
	  
		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="string-length(substring-after(cbc:Amount, '.')) &lt;= 2"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="string-length(substring-after(cbc:Amount, '.')) &lt;= 2">
               <xsl:attribute name="id">EUGEN-T10-R052</xsl:attribute>
               <xsl:attribute name="flag">fatal</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>[EUGEN-T10-R052]-Document level amounts cannot have more than 2 decimals</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="@*|*" mode="M6"/>
   </xsl:template>

	  <!--RULE -->
   <xsl:template match="//cbc:AllowanceChargeReasonCode" priority="1022" mode="M6">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="//cbc:AllowanceChargeReasonCode"/>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="@listID = 'UNCL4465'"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="@listID = 'UNCL4465'">
               <xsl:attribute name="id">EUGEN-T10-R029</xsl:attribute>
               <xsl:attribute name="flag">fatal</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>[EUGEN-T10-R029]-An allowance charge reason code MUST have a list identifier attribute 'UNCL4465'.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="@*|*" mode="M6"/>
   </xsl:template>

	  <!--RULE -->
   <xsl:template match="//cac:Country/cbc:IdentificationCode"
                 priority="1021"
                 mode="M6">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="//cac:Country/cbc:IdentificationCode"/>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="@listID = 'ISO3166-1:Alpha2'"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="@listID = 'ISO3166-1:Alpha2'">
               <xsl:attribute name="id">EUGEN-T10-R027</xsl:attribute>
               <xsl:attribute name="flag">fatal</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>[EUGEN-T10-R027]-A country identification code MUST have a list identifier attribute 'ISO3166-1:Alpha2'.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="@*|*" mode="M6"/>
   </xsl:template>

	  <!--RULE -->
   <xsl:template match="//*[contains(name(),'CurrencyCode')]"
                 priority="1020"
                 mode="M6">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="//*[contains(name(),'CurrencyCode')]"/>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="@listID =  'ISO4217'"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="@listID = 'ISO4217'">
               <xsl:attribute name="id">EUGEN-T10-R026</xsl:attribute>
               <xsl:attribute name="flag">fatal</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>[EUGEN-T10-R026]-A currency code element MUST have a list identifier attribute 'ISO4217'.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="@*|*" mode="M6"/>
   </xsl:template>

	  <!--RULE -->
   <xsl:template match="//cac:AccountingCustomerParty" priority="1019" mode="M6">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="//cac:AccountingCustomerParty"/>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="(cac:Party/cac:PartyName/cbc:Name)"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="(cac:Party/cac:PartyName/cbc:Name)">
               <xsl:attribute name="id">EUGEN-T10-R036</xsl:attribute>
               <xsl:attribute name="flag">fatal</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>[EUGEN-T10-R036]-An invoice MUST have a buyer name</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="(cac:Party/cac:PostalAddress)"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="(cac:Party/cac:PostalAddress)">
               <xsl:attribute name="id">EUGEN-T10-R038</xsl:attribute>
               <xsl:attribute name="flag">fatal</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>[EUGEN-T10-R038]-An invoice MUST have a buyer postal address</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="(cac:Party/cac:PartyLegalEntity)"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="(cac:Party/cac:PartyLegalEntity)">
               <xsl:attribute name="id">EUGEN-T10-R040</xsl:attribute>
               <xsl:attribute name="flag">warning</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>[EUGEN-T10-R040]-A customer SHOULD provide information about its legal entity information</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="@*|*" mode="M6"/>
   </xsl:template>

	  <!--RULE -->
   <xsl:template match="//cac:DeliveryLocation/cbc:ID" priority="1018" mode="M6">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="//cac:DeliveryLocation/cbc:ID"/>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="@schemeID"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="@schemeID">
               <xsl:attribute name="id">EUGEN-T10-R034</xsl:attribute>
               <xsl:attribute name="flag">fatal</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>[EUGEN-T10-R034]-An delivery location identifier MUST have a scheme identifier attribute.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="@*|*" mode="M6"/>
   </xsl:template>

	  <!--RULE -->
   <xsl:template match="//cbc:DocumentTypeCode" priority="1017" mode="M6">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="//cbc:DocumentTypeCode"/>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="@listID = 'UNCL1001'"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="@listID = 'UNCL1001'">
               <xsl:attribute name="id">EUGEN-T10-R033</xsl:attribute>
               <xsl:attribute name="flag">fatal</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>[EUGEN-T10-R033]-A document type code MUST have a list identifier attribute 'UNCL1001'.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="@*|*" mode="M6"/>
   </xsl:template>

	  <!--RULE -->
   <xsl:template match="//cbc:EndpointID" priority="1016" mode="M6">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="//cbc:EndpointID"/>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="@schemeID"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="@schemeID">
               <xsl:attribute name="id">EUGEN-T10-R023</xsl:attribute>
               <xsl:attribute name="flag">fatal</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>[EUGEN-T10-R023]-An endpoint identifier MUST have a scheme identifier attribute.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="@*|*" mode="M6"/>
   </xsl:template>

	  <!--RULE -->
   <xsl:template match="//cac:PayeeFinancialAccount/cbc:ID"
                 priority="1015"
                 mode="M6">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="//cac:PayeeFinancialAccount/cbc:ID"/>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="@schemeID"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="@schemeID">
               <xsl:attribute name="id">EUGEN-T10-R031</xsl:attribute>
               <xsl:attribute name="flag">fatal</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>[EUGEN-T10-R031]-A financial account identifier MUST have a scheme identifier attribute.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="@*|*" mode="M6"/>
   </xsl:template>

	  <!--RULE -->
   <xsl:template match="/ubl:Invoice" priority="1014" mode="M6">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="/ubl:Invoice"/>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="not(//cbc:TaxCurrencyCode) or (//cac:TaxExchangeRate)"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="not(//cbc:TaxCurrencyCode) or (//cac:TaxExchangeRate)">
               <xsl:attribute name="id">EUGEN-T10-R044</xsl:attribute>
               <xsl:attribute name="flag">fatal</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>[EUGEN-T10-R044]-If the tax currency code is different from the document currency code, the tax exchange rate MUST be provided</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
	  
		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="not(count(//*[not(node()[not(self::comment())])]) &gt; 0)"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="not(count(//*[not(node()[not(self::comment())])]) &gt; 0)">
               <xsl:attribute name="id">EUGEN-T10-R047</xsl:attribute>
               <xsl:attribute name="flag">warning</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>[EUGEN-T10-R047]- An invoice should not contain empty elements</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="(cbc:InvoiceTypeCode)"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="(cbc:InvoiceTypeCode)">
               <xsl:attribute name="id">EUGEN-T10-R053</xsl:attribute>
               <xsl:attribute name="flag">fatal</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>[EUGEN-T10-R053]- An invoice must have an Invoice type code</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="@*|*" mode="M6"/>
   </xsl:template>

	  <!--RULE -->
   <xsl:template match="//cbc:InvoiceTypeCode" priority="1013" mode="M6">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="//cbc:InvoiceTypeCode"/>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="@listID = 'UNCL1001'"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="@listID = 'UNCL1001'">
               <xsl:attribute name="id">EUGEN-T10-R025</xsl:attribute>
               <xsl:attribute name="flag">fatal</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>[EUGEN-T10-R025]-An invoice type code MUST have a list identifier attribute 'UNCL1001'.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="@*|*" mode="M6"/>
   </xsl:template>

	  <!--RULE -->
   <xsl:template match="//cac:PartyLegalEntity/cbc:CompanyID"
                 priority="1012"
                 mode="M6">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="//cac:PartyLegalEntity/cbc:CompanyID"/>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="@schemeID"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="@schemeID">
               <xsl:attribute name="id">EUGEN-T10-R054</xsl:attribute>
               <xsl:attribute name="flag">warning</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>[EUGEN-T10-R054]-A party legal entity company identifier SHOULD have a scheme identifier attribute.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="@*|*" mode="M7"/>
   </xsl:template>

	  <!--RULE -->
   <xsl:template match="//cac:PartyIdentification/cbc:ID" priority="1011" mode="M6">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="//cac:PartyIdentification/cbc:ID"/>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="@schemeID"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="@schemeID">
               <xsl:attribute name="id">EUGEN-T10-R024</xsl:attribute>
               <xsl:attribute name="flag">fatal</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>[EUGEN-T10-R024]-A party identifier MUST have a scheme identifier attribute.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="@*|*" mode="M6"/>
   </xsl:template>

	  <!--RULE -->
   <xsl:template match="//cac:PaymentMeans" priority="1010" mode="M6">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="//cac:PaymentMeans"/>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="((cbc:PaymentMeansCode = '31') and (cac:PayeeFinancialAccount/cbc:ID/@schemeID and cac:PayeeFinancialAccount/cbc:ID/@schemeID = 'IBAN') and (cac:PayeeFinancialAccount/cac:FinancialInstitutionBranch/cac:FinancialInstitution/cbc:ID/@schemeID and cac:PayeeFinancialAccount/cac:FinancialInstitutionBranch/cac:FinancialInstitution/cbc:ID/@schemeID = 'BIC')) or (cbc:PaymentMeansCode != '31') or ((cbc:PaymentMeansCode = '31') and  (not(cac:PayeeFinancialAccount/cbc:ID/@schemeID) or (cac:PayeeFinancialAccount/cbc:ID/@schemeID != 'IBAN')))"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="((cbc:PaymentMeansCode = '31') and (cac:PayeeFinancialAccount/cbc:ID/@schemeID and cac:PayeeFinancialAccount/cbc:ID/@schemeID = 'IBAN') and (cac:PayeeFinancialAccount/cac:FinancialInstitutionBranch/cac:FinancialInstitution/cbc:ID/@schemeID and cac:PayeeFinancialAccount/cac:FinancialInstitutionBranch/cac:FinancialInstitution/cbc:ID/@schemeID = 'BIC')) or (cbc:PaymentMeansCode != '31') or ((cbc:PaymentMeansCode = '31') and (not(cac:PayeeFinancialAccount/cbc:ID/@schemeID) or (cac:PayeeFinancialAccount/cbc:ID/@schemeID != 'IBAN')))">
               <xsl:attribute name="id">EUGEN-T10-R004</xsl:attribute>
               <xsl:attribute name="flag">warning</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>[EUGEN-T10-R004]-If the payment means are international account transfer and the account id is IBAN then the financial institution should be identified by using the BIC id.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="@*|*" mode="M6"/>
   </xsl:template>

	  <!--RULE -->
   <xsl:template match="//cbc:PaymentMeansCode" priority="1009" mode="M6">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="//cbc:PaymentMeansCode"/>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="@listID = 'UNCL4461'"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="@listID = 'UNCL4461'">
               <xsl:attribute name="id">EUGEN-T10-R028</xsl:attribute>
               <xsl:attribute name="flag">fatal</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>[EUGEN-T10-R028]-A payment means code MUST have a list identifier attribute 'UNCL4461'.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="@*|*" mode="M6"/>
   </xsl:template>

	  <!--RULE -->
   <xsl:template match="//cac:AccountingSupplierParty" priority="1008" mode="M6">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="//cac:AccountingSupplierParty"/>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="(cac:Party/cac:PartyName/cbc:Name)"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="(cac:Party/cac:PartyName/cbc:Name)">
               <xsl:attribute name="id">EUGEN-T10-R035</xsl:attribute>
               <xsl:attribute name="flag">fatal</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>[EUGEN-T10-R035]-An invoice MUST have a seller name</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="(cac:Party/cac:PostalAddress)"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="(cac:Party/cac:PostalAddress)">
               <xsl:attribute name="id">EUGEN-T10-R037</xsl:attribute>
               <xsl:attribute name="flag">fatal</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>[EUGEN-T10-R037]-An invoice MUST have a seller postal address</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="(cac:Party/cac:PartyLegalEntity)"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="(cac:Party/cac:PartyLegalEntity)">
               <xsl:attribute name="id">EUGEN-T10-R039</xsl:attribute>
               <xsl:attribute name="flag">warning</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>[EUGEN-T10-R039]-A supplier SHOULD provide information about its legal entity information</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="not(/ubl:Invoice/cac:TaxTotal/*/*/*/cbc:ID = 'VAT') or (some $companyID in cac:Party/cac:PartyTaxScheme/cbc:CompanyID satisfies (starts-with($companyID,cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode)))"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="not(/ubl:Invoice/cac:TaxTotal/*/*/*/cbc:ID = 'VAT') or (some $companyID in cac:Party/cac:PartyTaxScheme/cbc:CompanyID satisfies (starts-with($companyID,cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode)))">
               <xsl:attribute name="id">EUGEN-T10-R041</xsl:attribute>
               <xsl:attribute name="flag">warning</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>[EUGEN-T10-R041]-The VAT identifier for the supplier SHOULD be prefixed with country code for companies with VAT registration in EU countries</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="@*|*" mode="M6"/>
   </xsl:template>

	  <!--RULE -->
   <xsl:template match="//cac:TaxCategory" priority="1007" mode="M6">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="//cac:TaxCategory"/>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="(parent::cac:AllowanceCharge) or (cbc:ID and cbc:Percent) or (cbc:ID = 'AE')"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="(parent::cac:AllowanceCharge) or (cbc:ID and cbc:Percent) or (cbc:ID = 'AE')">
               <xsl:attribute name="id">EUGEN-T10-R008</xsl:attribute>
               <xsl:attribute name="flag">fatal</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>[EUGEN-T10-R008]-For each tax subcategory the category ID and the applicable tax percentage MUST be provided.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="@*|*" mode="M6"/>
   </xsl:template>

	  <!--RULE -->
   <xsl:template match="//cac:TaxCategory/cbc:ID" priority="1006" mode="M6">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="//cac:TaxCategory/cbc:ID"/>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="@schemeID = 'UNCL5305'"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="@schemeID = 'UNCL5305'">
               <xsl:attribute name="id">EUGEN-T10-R032</xsl:attribute>
               <xsl:attribute name="flag">fatal</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>[EUGEN-T10-R032]-A tax category identifier MUST have a scheme identifier attribute 'UNCL5305'.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="@*|*" mode="M6"/>
   </xsl:template>

	  <!--RULE -->
   <xsl:template match="//cac:TaxExchangeRate" priority="1005" mode="M6">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="//cac:TaxExchangeRate"/>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="(cbc:CalculationRate) and (cbc:MathematicOperatorCode)"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="(cbc:CalculationRate) and (cbc:MathematicOperatorCode)">
               <xsl:attribute name="id">EUGEN-T10-R045</xsl:attribute>
               <xsl:attribute name="flag">fatal</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>[EUGEN-T10-R045]-Tax exchange rate MUST specify the calculation rate and the operator code.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="@*|*" mode="M6"/>
   </xsl:template>

	  <!--RULE -->
   <xsl:template match="/ubl:Invoice/cac:TaxTotal" priority="1004" mode="M6">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="/ubl:Invoice/cac:TaxTotal"/>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="(xs:decimal(child::cbc:TaxAmount)= round(number(xs:decimal(sum(cac:TaxSubtotal/cbc:TaxAmount)) * 10 * 10)) div 100) "/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="(xs:decimal(child::cbc:TaxAmount)= round(number(xs:decimal(sum(cac:TaxSubtotal/cbc:TaxAmount)) * 10 * 10)) div 100)">
               <xsl:attribute name="id">EUGEN-T10-R043</xsl:attribute>
               <xsl:attribute name="flag">fatal</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>[EUGEN-T10-R043]-The total tax amount MUST equal the sum of tax amounts per category.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
	  
		    <!--ASSERT -->
      <xsl:choose>

         <xsl:when test="string-length(substring-after(cbc:TaxAmount, '.')) &lt;= 2"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"


                                test="string-length(substring-after(cbc:TaxAmount, '.')) &lt;= 2">
               <xsl:attribute name="id">EUGEN-T10-R049</xsl:attribute>
               <xsl:attribute name="flag">fatal</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>

               <svrl:text>[EUGEN-T10-R049]- Total tax amount cannot have more than 2 decimals.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="@*|*" mode="M6"/>
   </xsl:template>

	  <!--RULE -->

   <xsl:template match="/ubl:Invoice/cac:TaxTotal/cac:TaxSubtotal"
                 priority="1003"
                 mode="M6">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"

                       context="/ubl:Invoice/cac:TaxTotal/cac:TaxSubtotal"/>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="string-length(substring-after(cbc:TaxableAmount, '.')) &lt;= 2"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="string-length(substring-after(cbc:TaxableAmount, '.')) &lt;= 2">
               <xsl:attribute name="id">EUGEN-T10-R050</xsl:attribute>
               <xsl:attribute name="flag">fatal</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>[EUGEN-T10-R050]- Tax subtotal amounts cannot have more than 2 decimals.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="string-length(substring-after(cbc:TaxAmount, '.')) &lt;= 2"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="string-length(substring-after(cbc:TaxAmount, '.')) &lt;= 2">
               <xsl:attribute name="id">EUGEN-T10-R051</xsl:attribute>
               <xsl:attribute name="flag">fatal</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>[EUGEN-T10-R051]-Document level amounts cannot have more than 2 decimals</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
	  
		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="((cbc:TaxableAmount) and (cac:TaxCategory/cbc:Percent) and (xs:decimal(cbc:TaxAmount - 1) &lt; xs:decimal(cbc:TaxableAmount * (xs:decimal(cac:TaxCategory/cbc:Percent) div 100))) and (xs:decimal(cbc:TaxAmount + 1) &gt; xs:decimal(cbc:TaxableAmount * (xs:decimal(cac:TaxCategory/cbc:Percent) div 100)))) or not(cac:TaxCategory/cbc:Percent) or not(cbc:TaxableAmount)"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="((cbc:TaxableAmount) and (cac:TaxCategory/cbc:Percent) and (xs:decimal(cbc:TaxAmount - 1) &lt; xs:decimal(cbc:TaxableAmount * (xs:decimal(cac:TaxCategory/cbc:Percent) div 100))) and (xs:decimal(cbc:TaxAmount + 1) &gt; xs:decimal(cbc:TaxableAmount * (xs:decimal(cac:TaxCategory/cbc:Percent) div 100)))) or not(cac:TaxCategory/cbc:Percent) or not(cbc:TaxableAmount)">
               <xsl:attribute name="id">EUGEN-T10-R042</xsl:attribute>
               <xsl:attribute name="flag">fatal</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>[EUGEN-T10-R042]-The tax amount per category MUST be the taxable amount multiplied by the category percentage.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="not(/ubl:Invoice/cbc:TaxCurrencyCode) or (cbc:TaxAmount and cbc:TransactionCurrencyTaxAmount)"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="not(/ubl:Invoice/cbc:TaxCurrencyCode) or (cbc:TaxAmount and cbc:TransactionCurrencyTaxAmount)">
               <xsl:attribute name="id">EUGEN-T10-R046</xsl:attribute>
               <xsl:attribute name="flag">fatal</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>[EUGEN-T10-R046]-If the tax currency code is different from the document currency code, each tax subtotal has to include the tax amount in both currencies</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="@*|*" mode="M6"/>
   </xsl:template>   

	  <!--RULE -->
   <xsl:template match="//*[contains(name(),'Quantity')]" priority="1002" mode="M6">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="//*[contains(name(),'Quantity')]"/>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="not(attribute::unitCode) or (attribute::unitCode and attribute::unitCodeListID = 'UNECERec20')"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="not(attribute::unitCode) or (attribute::unitCode and attribute::unitCodeListID = 'UNECERec20')">
               <xsl:attribute name="id">EUGEN-T10-R030</xsl:attribute>
               <xsl:attribute name="flag">fatal</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>[EUGEN-T10-R030]-A unit code attribute MUST have a unit code list identifier attribute 'UNECERec20'.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="@*|*" mode="M6"/>
   </xsl:template>

	  <!--RULE -->
   <xsl:template match="//cac:LegalMonetaryTotal/child::*" priority="1001" mode="M6">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="//cac:LegalMonetaryTotal/child::*"/>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="string-length(substring-after(., '.')) &lt;= 2"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="string-length(substring-after(., '.')) &lt;= 2">
               <xsl:attribute name="id">EUGEN-T10-R048</xsl:attribute>
               <xsl:attribute name="flag">fatal</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>[EUGEN-T10-R048]-Document level amounts cannot have more than 2 decimals</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="@*|*" mode="M6"/>
   </xsl:template>
   
	  <!--RULE -->
   <xsl:template match="//cac:InvoiceLine" priority="1000" mode="M6">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="//cac:InvoiceLine"/>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="cac:Item/cbc:Name"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="cac:Item/cbc:Name">
               <xsl:attribute name="id">EUGEN-T10-R055</xsl:attribute>
               <xsl:attribute name="flag">fatal</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>[EUGEN-T10-R055]-Each invoice line MUST have an invoice line item name</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="@*|*" mode="M6"/>
   </xsl:template>		  
   <xsl:template match="text()" priority="-1" mode="M6"/>
   <xsl:template match="@*|node()" priority="-2" mode="M6">
      <xsl:apply-templates select="@*|*" mode="M6"/>
   </xsl:template>

   <!--PATTERN OP-CodesT10-->


	  <!--RULE -->
   <xsl:template match="cac:ContractDocumentReference//cbc:DocumentTypeCode"
                 priority="1008"
                 mode="M7">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="cac:ContractDocumentReference//cbc:DocumentTypeCode"/>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="( ( not(contains(normalize-space(.),' ')) and contains( ' 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35 36 37 38 39 40 41 42 43 44 45 46 47 48 49 50 51 52 53 54 55 56 57 58 59 60 61 62 63 64 65 66 67 68 69 70 71 72 73 74 75 76 77 78 79 80 81 82 83 84 85 86 87 88 89 90 91 92 93 94 95 96 97 98 99 100 101 102 103 104 105 106 107 108 109 110 111 112 113 114 115 116 117 118 119 120 121 122 123 124 125 126 127 128 129 130 131 132 133 134 135 136 137 138 139 140 141 142 143 144 145 146 147 148 149 150 151 152 153 154 155 156 157 158 159 160 161 162 163 164 165 166 167 168 169 170 171 172 173 174 175 176 177 178 179 180 181 182 183 184 185 186 187 188 189 190 191 192 193 194 195 196 197 198 199 200 201 202 203 204 205 206 207 208 209 210 211 212 213 214 215 216 217 218 219 220 221 222 223 224 225 226 227 228 229 230 231 232 233 234 235 236 237 238 239 240 241 242 243 244 245 246 247 248 249 250 251 252 253 254 255 256 257 258 259 260 261 262 263 264 265 266 267 268 269 270 271 272 273 274 275 276 277 278 279 280 281 282 283 284 285 286 287 288 289 290 291 292 293 294 295 296 297 298 299 300 301 302 303 304 305 306 307 308 309 310 311 312 313 314 315 316 317 318 319 320 321 322 323 324 325 326 327 328 329 330 331 332 333 334 335 336 337 338 339 340 341 342 343 344 345 346 347 348 349 350 351 352 353 354 355 356 357 358 359 360 361 362 363 364 365 366 367 368 369 370 371 372 373 374 375 376 377 378 379 380 381 382 383 384 385 386 387 388 389 390 391 392 393 394 395 396 397 398 399 400 401 402 403 404 405 406 407 408 409 410 411 412 413 414 415 416 417 418 419 420 421 422 423 424 425 426 427 428 429 430 431 432 433 434 435 436 437 438 439 440 441 442 443 444 445 446 447 448 449 450 451 452 453 454 455 456 457 458 459 460 461 462 463 464 465 466 467 468 469 470 481 482 483 484 485 486 487 488 489 490 491 493 494 495 496 497 498 499 520 521 522 523 524 525 526 527 528 529 530 531 532 533 534 535 536 537 538 550 575 580 610 621 622 623 624 630 631 632 633 635 640 650 655 700 701 702 703 704 705 706 707 708 709 710 711 712 713 714 715 716 720 722 723 724 730 740 741 743 744 745 746 750 760 761 763 764 765 766 770 775 780 781 782 783 784 785 786 787 788 789 790 791 792 793 794 795 796 797 798 799 810 811 812 820 821 822 823 824 825 830 833 840 841 850 851 852 853 855 856 860 861 862 863 864 865 870 890 895 896 901 910 911 913 914 915 916 917 925 926 927 929 930 931 932 933 934 935 936 937 938 940 941 950 951 952 953 954 955 960 961 962 963 964 965 966 970 971 972 974 975 976 977 978 979 990 991 995 996 998 ',concat(' ',normalize-space(.),' ') ) ) )"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="( ( not(contains(normalize-space(.),' ')) and contains( ' 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35 36 37 38 39 40 41 42 43 44 45 46 47 48 49 50 51 52 53 54 55 56 57 58 59 60 61 62 63 64 65 66 67 68 69 70 71 72 73 74 75 76 77 78 79 80 81 82 83 84 85 86 87 88 89 90 91 92 93 94 95 96 97 98 99 100 101 102 103 104 105 106 107 108 109 110 111 112 113 114 115 116 117 118 119 120 121 122 123 124 125 126 127 128 129 130 131 132 133 134 135 136 137 138 139 140 141 142 143 144 145 146 147 148 149 150 151 152 153 154 155 156 157 158 159 160 161 162 163 164 165 166 167 168 169 170 171 172 173 174 175 176 177 178 179 180 181 182 183 184 185 186 187 188 189 190 191 192 193 194 195 196 197 198 199 200 201 202 203 204 205 206 207 208 209 210 211 212 213 214 215 216 217 218 219 220 221 222 223 224 225 226 227 228 229 230 231 232 233 234 235 236 237 238 239 240 241 242 243 244 245 246 247 248 249 250 251 252 253 254 255 256 257 258 259 260 261 262 263 264 265 266 267 268 269 270 271 272 273 274 275 276 277 278 279 280 281 282 283 284 285 286 287 288 289 290 291 292 293 294 295 296 297 298 299 300 301 302 303 304 305 306 307 308 309 310 311 312 313 314 315 316 317 318 319 320 321 322 323 324 325 326 327 328 329 330 331 332 333 334 335 336 337 338 339 340 341 342 343 344 345 346 347 348 349 350 351 352 353 354 355 356 357 358 359 360 361 362 363 364 365 366 367 368 369 370 371 372 373 374 375 376 377 378 379 380 381 382 383 384 385 386 387 388 389 390 391 392 393 394 395 396 397 398 399 400 401 402 403 404 405 406 407 408 409 410 411 412 413 414 415 416 417 418 419 420 421 422 423 424 425 426 427 428 429 430 431 432 433 434 435 436 437 438 439 440 441 442 443 444 445 446 447 448 449 450 451 452 453 454 455 456 457 458 459 460 461 462 463 464 465 466 467 468 469 470 481 482 483 484 485 486 487 488 489 490 491 493 494 495 496 497 498 499 520 521 522 523 524 525 526 527 528 529 530 531 532 533 534 535 536 537 538 550 575 580 610 621 622 623 624 630 631 632 633 635 640 650 655 700 701 702 703 704 705 706 707 708 709 710 711 712 713 714 715 716 720 722 723 724 730 740 741 743 744 745 746 750 760 761 763 764 765 766 770 775 780 781 782 783 784 785 786 787 788 789 790 791 792 793 794 795 796 797 798 799 810 811 812 820 821 822 823 824 825 830 833 840 841 850 851 852 853 855 856 860 861 862 863 864 865 870 890 895 896 901 910 911 913 914 915 916 917 925 926 927 929 930 931 932 933 934 935 936 937 938 940 941 950 951 952 953 954 955 960 961 962 963 964 965 966 970 971 972 974 975 976 977 978 979 990 991 995 996 998 ',concat(' ',normalize-space(.),' ') ) ) )">
               <xsl:attribute name="id">OP-T10-R001</xsl:attribute>
               <xsl:attribute name="flag">fatal</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>[OP-T10-R001]-Contract document type code MUST be coded using UNCL 1001 list BII2 subset.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="@*|*" mode="M7"/>
   </xsl:template>

	  <!--RULE -->
   <xsl:template match="cbc:EndpointID//@schemeID" priority="1007" mode="M7">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="cbc:EndpointID//@schemeID"/>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="( ( not(contains(normalize-space(.),' ')) and contains( ' FR:SIRENE SE:ORGNR FR:SIRET FI:OVT DUNS GLN DK:P IT:FTI NL:KVK IT:SIA IT:SECETI DIGST DK:CPR DK:CVR DK:SE DK:VANS IT:VAT IT:CF NO:ORGNR NO:VAT HU:VAT EU:REID AT:VAT AT:GOV IS:KT IBAN AT:KUR ES:VAT IT:IPA AD:VAT AL:VAT BA:VAT BE:VAT BG:VAT CH:VAT CY:VAT CZ:VAT DE:VAT EE:VAT GB:VAT GR:VAT HR:VAT IE:VAT LI:VAT LT:VAT LU:VAT LV:VAT MC:VAT ME:VAT MK:VAT MT:VAT NL:VAT PL:VAT PT:VAT RO:VAT RS:VAT SI:VAT SK:VAT SM:VAT TR:VAT VA:VAT NL:ION NL:OIN SE:VAT BE:CBE FR:VAT ZZZ ',concat(' ',normalize-space(.),' ') ) ) )"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="( ( not(contains(normalize-space(.),' ')) and contains( ' FR:SIRENE SE:ORGNR FR:SIRET FI:OVT DUNS GLN DK:P IT:FTI NL:KVK IT:SIA IT:SECETI DIGST DK:CPR DK:CVR DK:SE DK:VANS IT:VAT IT:CF NO:ORGNR NO:VAT HU:VAT EU:REID AT:VAT AT:GOV IS:KT IBAN AT:KUR ES:VAT IT:IPA AD:VAT AL:VAT BA:VAT BE:VAT BG:VAT CH:VAT CY:VAT CZ:VAT DE:VAT EE:VAT GB:VAT GR:VAT HR:VAT IE:VAT LI:VAT LT:VAT LU:VAT LV:VAT MC:VAT ME:VAT MK:VAT MT:VAT NL:VAT PL:VAT PT:VAT RO:VAT RS:VAT SI:VAT SK:VAT SM:VAT TR:VAT VA:VAT NL:ION NL:OIN SE:VAT BE:CBE FR:VAT ZZZ ',concat(' ',normalize-space(.),' ') ) ) )">
               <xsl:attribute name="id">OP-T10-R002</xsl:attribute>
               <xsl:attribute name="flag">fatal</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>[OP-T10-R002]-An Endpoint Identifier Scheme MUST be from the list of PEPPOL Party Identifiers described in the "PEPPOL Policy for using Identifiers".</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="@*|*" mode="M7"/>
   </xsl:template>

	  <!--RULE -->
   <xsl:template match="cac:PartyIdentification/cbc:ID//@schemeID"
                 priority="1006"
                 mode="M7">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="cac:PartyIdentification/cbc:ID//@schemeID"/>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="( ( not(contains(normalize-space(.),' ')) and contains( ' FR:SIRENE SE:ORGNR FR:SIRET FI:OVT DUNS GLN DK:P IT:FTI NL:KVK IT:SIA IT:SECETI DIGST DK:CPR DK:CVR DK:SE DK:VANS IT:VAT IT:CF NO:ORGNR NO:VAT HU:VAT EU:REID AT:VAT AT:GOV IS:KT IBAN AT:KUR ES:VAT IT:IPA AD:VAT AL:VAT BA:VAT BE:VAT BG:VAT CH:VAT CY:VAT CZ:VAT DE:VAT EE:VAT GB:VAT GR:VAT HR:VAT IE:VAT LI:VAT LT:VAT LU:VAT LV:VAT MC:VAT ME:VAT MK:VAT MT:VAT NL:VAT PL:VAT PT:VAT RO:VAT RS:VAT SI:VAT SK:VAT SM:VAT TR:VAT VA:VAT NL:ION NL:OIN SE:VAT BE:CBE FR:VAT ZZZ ',concat(' ',normalize-space(.),' ') ) ) )"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="( ( not(contains(normalize-space(.),' ')) and contains( ' FR:SIRENE SE:ORGNR FR:SIRET FI:OVT DUNS GLN DK:P IT:FTI NL:KVK IT:SIA IT:SECETI DIGST DK:CPR DK:CVR DK:SE DK:VANS IT:VAT IT:CF NO:ORGNR NO:VAT HU:VAT EU:REID AT:VAT AT:GOV IS:KT IBAN AT:KUR ES:VAT IT:IPA AD:VAT AL:VAT BA:VAT BE:VAT BG:VAT CH:VAT CY:VAT CZ:VAT DE:VAT EE:VAT GB:VAT GR:VAT HR:VAT IE:VAT LI:VAT LT:VAT LU:VAT LV:VAT MC:VAT ME:VAT MK:VAT MT:VAT NL:VAT PL:VAT PT:VAT RO:VAT RS:VAT SI:VAT SK:VAT SM:VAT TR:VAT VA:VAT NL:ION NL:OIN SE:VAT BE:CBE FR:VAT ZZZ ',concat(' ',normalize-space(.),' ') ) ) )">
               <xsl:attribute name="id">OP-T10-R003</xsl:attribute>
               <xsl:attribute name="flag">fatal</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>[OP-T10-R003]-An Party Identifier Scheme MUST be from the list of PEPPOL Party Identifiers described in the "PEPPOL Policy for using Identifiers".</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="@*|*" mode="M7"/>
   </xsl:template>

	  <!--RULE -->
   <xsl:template match="cac:PayeeFinancialAccount/cbc:ID//@schemeID"
                 priority="1005"
                 mode="M7">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="cac:PayeeFinancialAccount/cbc:ID//@schemeID"/>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="( ( not(contains(normalize-space(.),' ')) and contains( ' IBAN LOCAL ',concat(' ',normalize-space(.),' ') ) ) )"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="( ( not(contains(normalize-space(.),' ')) and contains( ' IBAN LOCAL ',concat(' ',normalize-space(.),' ') ) ) )">
               <xsl:attribute name="id">OP-T10-R004</xsl:attribute>
               <xsl:attribute name="flag">fatal</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>[OP-T10-R004]-A payee account identifier scheme MUST be from the Account ID PEPPOL code list</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="@*|*" mode="M7"/>
   </xsl:template>

	  <!--RULE -->
   <xsl:template match="cbc:*/@unitCode" priority="1004" mode="M7">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="cbc:*/@unitCode"/>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="( ( not(contains(normalize-space(.),' ')) and contains( ' 5 6 8 10 11 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35 36 37 38 40 41 43 44 45 46 47 48 53 54 56 57 58 59 60 61 62 63 64 66 69 71 72 73 74 76 77 78 80 81 84 85 87 89 90 91 92 93 94 95 96 97 98 1A 1B 1C 1D 1E 1F 1G 1H 1I 1J 1K 1L 1M 1X 2A 2B 2C 2G 2H 2I 2J 2K 2L 2M 2N 2P 2Q 2R 2U 2V 2W 2X 2Y 2Z 3B 3C 3E 3G 3H 3I 4A 4B 4C 4E 4G 4H 4K 4L 4M 4N 4O 4P 4Q 4R 4T 4U 4W 4X 5A 5B 5C 5E 5F 5G 5H 5I 5J 5K 5P 5Q A1 A10 A11 A12 A13 A14 A15 A16 A17 A18 A19 A2 A20 A21 A22 A23 A24 A25 A26 A27 A28 A29 A3 A30 A31 A32 A33 A34 A35 A36 A37 A38 A39 A4 A40 A41 A42 A43 A44 A45 A47 A48 A49 A5 A50 A51 A52 A53 A54 A55 A56 A57 A58 A59 A6 A60 A61 A62 A63 A64 A65 A66 A67 A68 A69 A7 A70 A71 A73 A74 A75 A76 A77 A78 A79 A8 A80 A81 A82 A83 A84 A85 A86 A87 A88 A89 A9 A90 A91 A93 A94 A95 A96 A97 A98 A99 AA AB ACR ACT AD AE AH AI AJ AK AL AM AMH AMP ANN AP APZ AQ AR ARE AS ASM ASU ATM ATT AV AW AY AZ B0 B1 B10 B11 B12 B13 B14 B15 B16 B17 B18 B19 B2 B20 B21 B22 B23 B24 B25 B26 B27 B28 B29 B3 B30 B31 B32 B33 B34 B35 B36 B37 B38 B39 B4 B40 B41 B42 B43 B44 B45 B46 B47 B48 B49 B5 B50 B51 B52 B53 B54 B55 B56 B57 B58 B59 B6 B60 B61 B62 B63 B64 B65 B66 B67 B68 B69 B7 B70 B71 B72 B73 B74 B75 B76 B77 B78 B79 B8 B80 B81  B82 B83 B84 B85 B86 B87 B88 B89 B9 B90 B91 B92 B93 B94 B95 B96 B97 B98 B99 BAR BB BD BE BFT BG BH BHP BIL BJ BK BL BLD BLL BO BP BQL BR BT BTU BUA BUI BW BX BZ C0 C1 C10 C11 C12 C13 C14 C15 C16 C17 C18 C19 C2 C20 C21 C22 C23 C24 C25 C26 C27 C28 C29 C3 C30 C31 C32 C33 C34 C35 C36 C37 C38 C39 C4 C40 C41 C42 C43 C44 C45 C46 C47 C48 C49 C5 C50 C51 C52 C53 C54 C55 C56 C57 C58 C59 C6 C60 C61 C62 C63 C64 C65 C66 C67 C68 C69 C7 C70 C71 C72 C73 C74 C75 C76 C77 C78 C79 C8 C80 C81 C82 C83 C84 C85 C86 C87 C88 C89 C9 C90 C91 C92 C93 C94 C95 C96 C97 C98 C99 CA CCT CDL CEL CEN CG CGM CH CJ CK CKG CL CLF CLT CMK CMQ CMT CNP CNT CO COU CQ CR CS CT CTG CTM CTN CU CUR CV CWA CWI CY CZ D03 D04 D1 D10 D11 D12 D13 D14 D15 D16 D17 D18 D19 D2 D20 D21 D22 D23 D24 D25 D26 D27 D28 D29 D30 D31 D32 D33 D34 D35 D36 D37 D38 D39 D40 D41 D42 D43 D44 D45 D46 D47 D48 D49 D5 D50 D51 D52 D53 D54 D55 D56 D57 D58 D59 D6 D60 D61 D62 D63 D64 D65 D66 D67 D68 D69 D7 D70 D71 D72 D73 D74 D75 D76 D77 D78 D79 D8 D80 D81 D82 D83 D85 D86 D87 D88 D89 D9 D90 D91 D92 D93 D94 D95 D96 D97 D98 D99 DAA DAD DAY DB DC DD DE DEC DG DI DJ DLT DMA DMK DMO DMQ DMT DN DPC DPR DPT DQ DR DRA DRI DRL DRM DS DT DTN DU DWT DX DY DZN DZP E01 E07 E08 E09 E10 E11 E12 E14 E15 E16 E17 E18 E19 E2 E20 E21 E22 E23 E25 E27 E28 E3 E30 E31 E32 E33 E34 E35 E36 E37 E38 E39 E4 E40 E41 E42 E43 E44 E45 E46 E47 E48 E49 E5 E50 E51 E52 E53 E54 E55 E56 E57 E58 E59 E60 E61 E62 E63 E64 E65 E66 E67 E68 E69 E70 E71 E72 E73 E74 E75 E76 E77 E78 E79 E80 E81 E82 E83 E84 E85 E86 E87 E88 E89 E90 E91 E92 E93 E94 E95 E96 E97 E98 E99 EA EB EC EP EQ EV F01 F02 F03 F04 F05 F06 F07 F08 F1 F10 F11 F12 F13 F14 F15 F16 F17 F18 F19 F20 F21 F22 F23 F24 F25 F26 F27 F28 F29 F30 F31 F32 F33 F34 F35 F36 F37 F38 F39 F40 F41 F42 F43 F44 F45 F46 F47 F48 F49 F50 F51 F52 F53 F54 F55 F56 F57 F58 F59 F60 F61 F62 F63 F64 F65 F66 F67 F68 F69 F70 F71 F72 F73 F74 F75 F76 F77 F78 F79 F80 F81 F82 F83 F84 F85 F86 F87 F88 F89 F9 F90 F91 F92 F93 F94 F95 F96 F97 F98 F99 FAH FAR FB FBM FC FD FE FF FG FH FIT FL FM FOT FP FR FS FTK FTQ G01 G04 G05 G06 G08 G09 G10 G11 G12 G13 G14 G15 G16 G17 G18 G19 G2 G20 G21 G23 G24 G25 G26 G27 G28 G29 G3 G30 G31 G32 G33 G34 G35 G36 G37 G38 G39 G40 G41 G42 G43 G44 G45 G46 G47 G48 G49 G50 G51 G52 G53 G54 G55 G56 G57 G58 G59 G60 G61 G62 G63 G64 G65 G66 G67 G68 G69 G7 G70 G71 G72 G73 G74 G75 G76 G77 G78 G79 G80 G81 G82 G83 G84 G85 G86 G87 G88 G89 G90 G91 G92 G93 G94 G95 G96 G97 G98 G99 GB GBQ GC GD GDW GE GF GFI GGR GH GIA GIC GII GIP GJ GK GL GLD GLI GLL GM GN GO GP GQ GRM GRN GRO GRT GT GV GW GWH GY GZ H03 H04 H05 H06 H07 H08 H09 H1 H10 H11 H12 H13 H14 H15 H16 H18 H19 H2 H20 H21 H22 H23 H24 H25 H26 H27 H28 H29 H30 H31 H32 H33 H34 H35 H36 H37 H38 H39 H40 H41 H42 H43 H44 H45 H46 H47 H48 H49 H50 H51 H52 H53 H54 H55 H56 H57 H58 H59 H60 H61 H62 H63 H64 H65 H66 H67 H68 H69 H70 H71 H72 H73 H74 H75 H76 H77 H78 H79 H80 H81 H82 H83 H84 H85 H87 H88 H89 H90 H91 H92 H93 H94 H95 H96 H98 H99 HA HAR HBA HBX HC HD HDW HE HEA HF HGM HH HI HIU HJ HK HKM HL HLT HM HMQ HMT HN HO HP HPA HS HT HTZ HUR HY IA IC IE IF II IL IM INH INK INQ IP ISD IT IU IV J10 J12 J13 J14 J15 J16 J17 J18 J19 J2 J20 J21 J22 J23 J24 J25 J26 J27 J28 J29 J30 J31 J32 J33 J34 J35 J36 J38 J39 J40 J41 J42 J43 J44 J45 J46 J47 J48 J49 J50 J51 J52 J53 J54 J55 J56 J57 J58 J59 J60 J61 J62 J63 J64 J65 J66 J67 J68 J69 J70 J71 J72 J73 J74 J75 J76 J78 J79 J81 J82 J83 J84 J85 J87 J89 J90 J91 J92 J93 J94 J95 J96 J97 J98 J99 JB JE JG JK JM JNT JO JOU JPS JR JWL K1 K10 K11 K12 K13 K14 K15 K16 K17 K18 K19 K2 K20 K21 K22 K23 K24 K25 K26 K27 K28 K3 K30 K31 K32 K33 K34 K35 K36 K37 K38 K39 K40 K41 K42 K43 K45 K46 K47 K48 K49 K5 K50 K51 K52 K53 K54 K55 K58 K59 K6 K60 K61 K62 K63 K64 K65 K66 K67 K68 K69 K70 K71 K73 K74 K75 K76 K77 K78 K79 K80 K81 K82 K83 K84 K85 K86 K87 K88 K89 K90 K91 K92 K93 K94 K95 K96 K97 K98 K99 KA KAT KB KBA KCC KD KDW KEL KF KG KGM KGS KHY KHZ KI KIC KIP KJ KJO KL KLK KLX KMA KMH KMK KMQ KMT KNI KNS KNT KO KPA KPH KPO KPP KR KS KSD KSH KT KTM KTN KUR KVA KVR KVT KW KWH KWO KWT KX L10 L11 L12 L13 L14 L15 L16 L17 L18 L19 L2 L20 L21 L23 L24 L25 L26 L27 L28 L29 L30 L31 L32 L33 L34 L35 L36 L37 L38 L39 L40 L41 L42 L43 L44 L45 L46 L47 L48 L49 L50 L51 L52 L53 L54 L55 L56 L57 L58 L59 L60 L61 L62 L63 L64 L65 L66 L67 L68 L69 L70 L71 L72 L73 L74 L75 L76 L77 L78 L79 L80 L81 L82 L83 L84 L85 L86 L87 L88 L89 L90 L91 L92 L93 L94 L95 L96 L98 L99 LA LAC LBR LBT LC LD LE LEF LF LH LI LJ LK LM LN LO LP LPA LR LS LTN LTR LUB LUM LUX LX LY M0 M1 M10 M11 M12 M13 M14 M15 M16 M17 M18 M19 M20 M21 M22 M23 M24 M25 M26 M27 M29 M30 M31 M32 M33 M34 M35 M36 M37 M38 M39 M4 M40 M41 M42 M43 M44 M45 M46 M47 M48 M49 M5 M50 M51 M52 M53 M55 M56 M57 M58 M59 M60 M61 M62 M63 M64 M65 M66 M67 M68 M69 M7 M70 M71 M72 M73 M74 M75 M76 M77 M78 M79 M80 M81 M82 M83 M84 M85 M86 M87 M88 M89 M9 M90 M91 M92 M93 M94 M95 M96 M97 M98 M99 MA MAH MAL MAM MAR MAW MBE MBF MBR MC MCU MD MF MGM MHZ MIK MIL MIN MIO MIU MK MLD MLT MMK MMQ MMT MND MON MPA MQ MQH MQS MSK MT MTK MTQ MTR MTS MV MVA MWH N1 N10 N11 N12 N13 N14 N15 N16 N17 N18 N19 N2 N20 N21 N22 N23 N24 N25 N26 N27 N28 N29 N3 N30 N31 N32 N33 N34 N35 N36 N37 N38 N39 N40 N41 N42 N43 N44 N45 N46 N47 N48 N49 N50 N51 N52 N53 N54 N55 N56 N57 N58 N59 N60 N61 N62 N63 N64 N65 N66 N67 N68 N69 N70 N71 N72 N73 N74 N75 N76 N77 N78 N79 N80 N81 N82 N83 N84 N85 N86 N87 N88 N89 N90 N91 N92 N93 N94 N95 N96 N97 N98 N99 NA NAR NB NBB NC NCL ND NE NEW NF NG NH NI NIL NIU NJ NL NMI NMP NN NPL NPR NPT NQ NR NRL NT NTT NU NV NX NY OA ODE OHM ON ONZ OP OT OZ OZA OZI P0 P1 P10 P11 P12 P13 P14 P15 P16 P17 P18 P19 P2 P20 P21 P22 P23 P24 P25 P26 P27 P28 P29 P3 P30 P31 P32 P33 P34 P35 P36 P37 P38 P39 P4 P40 P41 P42 P43 P44 P45 P46 P47 P48 P49 P5 P50 P51 P52 P53 P54 P55 P56 P57 P58 P59 P6 P60 P61 P62 P63 P64 P65 P66 P67 P68 P69 P7 P70 P71 P72 P73 P74 P75 P76 P77 P78 P79 P8 P80 P81 P82 P83 P84 P85 P86 P87 P88 P89 P9 P90 P91 P92 P93 P94 P95 P96 P97 P98 P99 PA PAL PB PD PE PF PFL PG PGL PI PK PL PLA PM PN PO PQ PR PS PT PTD PTI PTL PU PV PW PY PZ Q10 Q11 Q12 Q13 Q14 Q15 Q16 Q17 Q18 Q19 Q20 Q21 Q22 Q23 Q24 Q25 Q26 Q27 Q28 Q29 Q30 Q3 QA QAN QB QD QH QK QR QT QTD QTI QTL QTR R1 R4 R9 RA RD RG RH RK RL RM RN RO ROM RP RPM RPS RS RT RU S3 S4 S5 S6 S7 S8 SA SAN SCO SCR SD SE SEC SET SG SHT SIE SK SL SMI SN SO SP SQ SQR SR SS SST ST STC STI STK STL STN STW SV SW SX SYR T0 T1 T3 T4 T5 T6 T7 T8 TA TAH TAN TC TD TE TF TI TIC TIP TJ TK TKM TL TMS TN TNE TP TPR TQ TQD TR TRL TS TSD TSH TST TT TTS TU TV TW TY U1 U2 UA UB UC UD UE UF UH UM VA VI VLT VP VQ VS W2 W4 WA WB WCD WE WEB WEE WG WH WHR WI WM WR WSD WTT WW X1 YDK YDQ YL YRD YT Z1 Z11 Z2 Z3 Z4 Z5 Z6 Z8 ZP ZZ ',concat(' ',normalize-space(.),' ') ) ) )"/>		                                                                           
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="( ( not(contains(normalize-space(.),' ')) and contains( ' 5 6 8 10 11 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35 36 37 38 40 41 43 44 45 46 47 48 53 54 56 57 58 59 60 61 62 63 64 66 69 71 72 73 74 76 77 78 80 81 84 85 87 89 90 91 92 93 94 95 96 97 98 1A 1B 1C 1D 1E 1F 1G 1H 1I 1J 1K 1L 1M 1X 2A 2B 2C 2G 2H 2I 2J 2K 2L 2M 2N 2P 2Q 2R 2U 2V 2W 2X 2Y 2Z 3B 3C 3E 3G 3H 3I 4A 4B 4C 4E 4G 4H 4K 4L 4M 4N 4O 4P 4Q 4R 4T 4U 4W 4X 5A 5B 5C 5E 5F 5G 5H 5I 5J 5K 5P 5Q A1 A10 A11 A12 A13 A14 A15 A16 A17 A18 A19 A2 A20 A21 A22 A23 A24 A25 A26 A27 A28 A29 A3 A30 A31 A32 A33 A34 A35 A36 A37 A38 A39 A4 A40 A41 A42 A43 A44 A45 A47 A48 A49 A5 A50 A51 A52 A53 A54 A55 A56 A57 A58 A59 A6 A60 A61 A62 A63 A64 A65 A66 A67 A68 A69 A7 A70 A71 A73 A74 A75 A76 A77 A78 A79 A8 A80 A81 A82 A83 A84 A85 A86 A87 A88 A89 A9 A90 A91 A93 A94 A95 A96 A97 A98 A99 AA AB ACR ACT AD AE AH AI AJ AK AL AM AMH AMP ANN AP APZ AQ AR ARE AS ASM ASU ATM ATT AV AW AY AZ B0 B1 B10 B11 B12 B13 B14 B15 B16 B17 B18 B19 B2 B20 B21 B22 B23 B24 B25 B26 B27 B28 B29 B3 B30 B31 B32 B33 B34 B35 B36 B37 B38 B39 B4 B40 B41 B42 B43 B44 B45 B46 B47 B48 B49 B5 B50 B51 B52 B53 B54 B55 B56 B57 B58 B59 B6 B60 B61 B62 B63 B64 B65 B66 B67 B68 B69 B7 B70 B71 B72 B73 B74 B75 B76 B77 B78 B79 B8 B80 B81  B82 B83 B84 B85 B86 B87 B88 B89 B9 B90 B91 B92 B93 B94 B95 B96 B97 B98 B99 BAR BB BD BE BFT BG BH BHP BIL BJ BK BL BLD BLL BO BP BQL BR BT BTU BUA BUI BW BX BZ C0 C1 C10 C11 C12 C13 C14 C15 C16 C17 C18 C19 C2 C20 C21 C22 C23 C24 C25 C26 C27 C28 C29 C3 C30 C31 C32 C33 C34 C35 C36 C37 C38 C39 C4 C40 C41 C42 C43 C44 C45 C46 C47 C48 C49 C5 C50 C51 C52 C53 C54 C55 C56 C57 C58 C59 C6 C60 C61 C62 C63 C64 C65 C66 C67 C68 C69 C7 C70 C71 C72 C73 C74 C75 C76 C77 C78 C79 C8 C80 C81 C82 C83 C84 C85 C86 C87 C88 C89 C9 C90 C91 C92 C93 C94 C95 C96 C97 C98 C99 CA CCT CDL CEL CEN CG CGM CH CJ CK CKG CL CLF CLT CMK CMQ CMT CNP CNT CO COU CQ CR CS CT CTG CTM CTN CU CUR CV CWA CWI CY CZ D03 D04 D1 D10 D11 D12 D13 D14 D15 D16 D17 D18 D19 D2 D20 D21 D22 D23 D24 D25 D26 D27 D28 D29 D30 D31 D32 D33 D34 D35 D36 D37 D38 D39 D40 D41 D42 D43 D44 D45 D46 D47 D48 D49 D5 D50 D51 D52 D53 D54 D55 D56 D57 D58 D59 D6 D60 D61 D62 D63 D64 D65 D66 D67 D68 D69 D7 D70 D71 D72 D73 D74 D75 D76 D77 D78 D79 D8 D80 D81 D82 D83 D85 D86 D87 D88 D89 D9 D90 D91 D92 D93 D94 D95 D96 D97 D98 D99 DAA DAD DAY DB DC DD DE DEC DG DI DJ DLT DMA DMK DMO DMQ DMT DN DPC DPR DPT DQ DR DRA DRI DRL DRM DS DT DTN DU DWT DX DY DZN DZP E01 E07 E08 E09 E10 E11 E12 E14 E15 E16 E17 E18 E19 E2 E20 E21 E22 E23 E25 E27 E28 E3 E30 E31 E32 E33 E34 E35 E36 E37 E38 E39 E4 E40 E41 E42 E43 E44 E45 E46 E47 E48 E49 E5 E50 E51 E52 E53 E54 E55 E56 E57 E58 E59 E60 E61 E62 E63 E64 E65 E66 E67 E68 E69 E70 E71 E72 E73 E74 E75 E76 E77 E78 E79 E80 E81 E82 E83 E84 E85 E86 E87 E88 E89 E90 E91 E92 E93 E94 E95 E96 E97 E98 E99 EA EB EC EP EQ EV F01 F02 F03 F04 F05 F06 F07 F08 F1 F10 F11 F12 F13 F14 F15 F16 F17 F18 F19 F20 F21 F22 F23 F24 F25 F26 F27 F28 F29 F30 F31 F32 F33 F34 F35 F36 F37 F38 F39 F40 F41 F42 F43 F44 F45 F46 F47 F48 F49 F50 F51 F52 F53 F54 F55 F56 F57 F58 F59 F60 F61 F62 F63 F64 F65 F66 F67 F68 F69 F70 F71 F72 F73 F74 F75 F76 F77 F78 F79 F80 F81 F82 F83 F84 F85 F86 F87 F88 F89 F9 F90 F91 F92 F93 F94 F95 F96 F97 F98 F99 FAH FAR FB FBM FC FD FE FF FG FH FIT FL FM FOT FP FR FS FTK FTQ G01 G04 G05 G06 G08 G09 G10 G11 G12 G13 G14 G15 G16 G17 G18 G19 G2 G20 G21 G23 G24 G25 G26 G27 G28 G29 G3 G30 G31 G32 G33 G34 G35 G36 G37 G38 G39 G40 G41 G42 G43 G44 G45 G46 G47 G48 G49 G50 G51 G52 G53 G54 G55 G56 G57 G58 G59 G60 G61 G62 G63 G64 G65 G66 G67 G68 G69 G7 G70 G71 G72 G73 G74 G75 G76 G77 G78 G79 G80 G81 G82 G83 G84 G85 G86 G87 G88 G89 G90 G91 G92 G93 G94 G95 G96 G97 G98 G99 GB GBQ GC GD GDW GE GF GFI GGR GH GIA GIC GII GIP GJ GK GL GLD GLI GLL GM GN GO GP GQ GRM GRN GRO GRT GT GV GW GWH GY GZ H03 H04 H05 H06 H07 H08 H09 H1 H10 H11 H12 H13 H14 H15 H16 H18 H19 H2 H20 H21 H22 H23 H24 H25 H26 H27 H28 H29 H30 H31 H32 H33 H34 H35 H36 H37 H38 H39 H40 H41 H42 H43 H44 H45 H46 H47 H48 H49 H50 H51 H52 H53 H54 H55 H56 H57 H58 H59 H60 H61 H62 H63 H64 H65 H66 H67 H68 H69 H70 H71 H72 H73 H74 H75 H76 H77 H78 H79 H80 H81 H82 H83 H84 H85 H87 H88 H89 H90 H91 H92 H93 H94 H95 H96 H98 H99 HA HAR HBA HBX HC HD HDW HE HEA HF HGM HH HI HIU HJ HK HKM HL HLT HM HMQ HMT HN HO HP HPA HS HT HTZ HUR HY IA IC IE IF II IL IM INH INK INQ IP ISD IT IU IV J10 J12 J13 J14 J15 J16 J17 J18 J19 J2 J20 J21 J22 J23 J24 J25 J26 J27 J28 J29 J30 J31 J32 J33 J34 J35 J36 J38 J39 J40 J41 J42 J43 J44 J45 J46 J47 J48 J49 J50 J51 J52 J53 J54 J55 J56 J57 J58 J59 J60 J61 J62 J63 J64 J65 J66 J67 J68 J69 J70 J71 J72 J73 J74 J75 J76 J78 J79 J81 J82 J83 J84 J85 J87 J89 J90 J91 J92 J93 J94 J95 J96 J97 J98 J99 JB JE JG JK JM JNT JO JOU JPS JR JWL K1 K10 K11 K12 K13 K14 K15 K16 K17 K18 K19 K2 K20 K21 K22 K23 K24 K25 K26 K27 K28 K3 K30 K31 K32 K33 K34 K35 K36 K37 K38 K39 K40 K41 K42 K43 K45 K46 K47 K48 K49 K5 K50 K51 K52 K53 K54 K55 K58 K59 K6 K60 K61 K62 K63 K64 K65 K66 K67 K68 K69 K70 K71 K73 K74 K75 K76 K77 K78 K79 K80 K81 K82 K83 K84 K85 K86 K87 K88 K89 K90 K91 K92 K93 K94 K95 K96 K97 K98 K99 KA KAT KB KBA KCC KD KDW KEL KF KG KGM KGS KHY KHZ KI KIC KIP KJ KJO KL KLK KLX KMA KMH KMK KMQ KMT KNI KNS KNT KO KPA KPH KPO KPP KR KS KSD KSH KT KTM KTN KUR KVA KVR KVT KW KWH KWO KWT KX L10 L11 L12 L13 L14 L15 L16 L17 L18 L19 L2 L20 L21 L23 L24 L25 L26 L27 L28 L29 L30 L31 L32 L33 L34 L35 L36 L37 L38 L39 L40 L41 L42 L43 L44 L45 L46 L47 L48 L49 L50 L51 L52 L53 L54 L55 L56 L57 L58 L59 L60 L61 L62 L63 L64 L65 L66 L67 L68 L69 L70 L71 L72 L73 L74 L75 L76 L77 L78 L79 L80 L81 L82 L83 L84 L85 L86 L87 L88 L89 L90 L91 L92 L93 L94 L95 L96 L98 L99 LA LAC LBR LBT LC LD LE LEF LF LH LI LJ LK LM LN LO LP LPA LR LS LTN LTR LUB LUM LUX LX LY M0 M1 M10 M11 M12 M13 M14 M15 M16 M17 M18 M19 M20 M21 M22 M23 M24 M25 M26 M27 M29 M30 M31 M32 M33 M34 M35 M36 M37 M38 M39 M4 M40 M41 M42 M43 M44 M45 M46 M47 M48 M49 M5 M50 M51 M52 M53 M55 M56 M57 M58 M59 M60 M61 M62 M63 M64 M65 M66 M67 M68 M69 M7 M70 M71 M72 M73 M74 M75 M76 M77 M78 M79 M80 M81 M82 M83 M84 M85 M86 M87 M88 M89 M9 M90 M91 M92 M93 M94 M95 M96 M97 M98 M99 MA MAH MAL MAM MAR MAW MBE MBF MBR MC MCU MD MF MGM MHZ MIK MIL MIN MIO MIU MK MLD MLT MMK MMQ MMT MND MON MPA MQ MQH MQS MSK MT MTK MTQ MTR MTS MV MVA MWH N1 N10 N11 N12 N13 N14 N15 N16 N17 N18 N19 N2 N20 N21 N22 N23 N24 N25 N26 N27 N28 N29 N3 N30 N31 N32 N33 N34 N35 N36 N37 N38 N39 N40 N41 N42 N43 N44 N45 N46 N47 N48 N49 N50 N51 N52 N53 N54 N55 N56 N57 N58 N59 N60 N61 N62 N63 N64 N65 N66 N67 N68 N69 N70 N71 N72 N73 N74 N75 N76 N77 N78 N79 N80 N81 N82 N83 N84 N85 N86 N87 N88 N89 N90 N91 N92 N93 N94 N95 N96 N97 N98 N99 NA NAR NB NBB NC NCL ND NE NEW NF NG NH NI NIL NIU NJ NL NMI NMP NN NPL NPR NPT NQ NR NRL NT NTT NU NV NX NY OA ODE OHM ON ONZ OP OT OZ OZA OZI P0 P1 P10 P11 P12 P13 P14 P15 P16 P17 P18 P19 P2 P20 P21 P22 P23 P24 P25 P26 P27 P28 P29 P3 P30 P31 P32 P33 P34 P35 P36 P37 P38 P39 P4 P40 P41 P42 P43 P44 P45 P46 P47 P48 P49 P5 P50 P51 P52 P53 P54 P55 P56 P57 P58 P59 P6 P60 P61 P62 P63 P64 P65 P66 P67 P68 P69 P7 P70 P71 P72 P73 P74 P75 P76 P77 P78 P79 P8 P80 P81 P82 P83 P84 P85 P86 P87 P88 P89 P9 P90 P91 P92 P93 P94 P95 P96 P97 P98 P99 PA PAL PB PD PE PF PFL PG PGL PI PK PL PLA PM PN PO PQ PR PS PT PTD PTI PTL PU PV PW PY PZ Q10 Q11 Q12 Q13 Q14 Q15 Q16 Q17 Q18 Q19 Q20 Q21 Q22 Q23 Q24 Q25 Q26 Q27 Q28 Q29 Q30 Q3 QA QAN QB QD QH QK QR QT QTD QTI QTL QTR R1 R4 R9 RA RD RG RH RK RL RM RN RO ROM RP RPM RPS RS RT RU S3 S4 S5 S6 S7 S8 SA SAN SCO SCR SD SE SEC SET SG SHT SIE SK SL SMI SN SO SP SQ SQR SR SS SST ST STC STI STK STL STN STW SV SW SX SYR T0 T1 T3 T4 T5 T6 T7 T8 TA TAH TAN TC TD TE TF TI TIC TIP TJ TK TKM TL TMS TN TNE TP TPR TQ TQD TR TRL TS TSD TSH TST TT TTS TU TV TW TY U1 U2 UA UB UC UD UE UF UH UM VA VI VLT VP VQ VS W2 W4 WA WB WCD WE WEB WEE WG WH WHR WI WM WR WSD WTT WW X1 YDK YDQ YL YRD YT Z1 Z11 Z2 Z3 Z4 Z5 Z6 Z8 ZP ZZ ',concat(' ',normalize-space(.),' ') ) ) )">
               <xsl:attribute name="id">OP-T10-R006</xsl:attribute>
               <xsl:attribute name="flag">fatal</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>[OP-T10-R006]-Unit code MUST be coded according to the UN/ECE Recommendation 20</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
	  
		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="( ( not(contains(normalize-space(.),' ')) and not(contains( ' 5 6 8 16 17 18 19 26 29 30 31 32 36 45 46 47 48 53 54 62 63 69 71 72 73 90 92 93 94 95 96 97 98 1C 1E 1H 1J 1K 1L 1M 1X 2V 2W 3E 3G 3I 4E 5C 5F 5G 5I 5K 5P 5Q AR AW B0 B2 B5 B6 B9 BX C1 C2 C4 C5 C6 C77 C98 D14 D28 D40 D64 D66 D67 D7 D79 D8 D90 D92 D96 D97 D98 D99 DE DQ DRM E2 E3 E5 EP EV F1 F9 FG FM G7 GC GD GH GK GN GW H1 H2 HD HE HF HI HK HL HO HS HT HY II IM IP IT JO KD KF KS KTM L61 L62 LC LI LJ LX M0 MF MK MQ MV N2 NB NBB NC ND NH NI NJ NN NPL NRL NY OP P0 P3 P4 P6 P7 P8 P9 PM PW R4 RA RN RS RU S5 S6 S7 S8 SN SST T4 T5 T6 T7 T8 TA TF TJ TQ TSD TSH UD UE UF UH UM W4 WI Z1 Z2 Z3 Z4 Z5 Z6 Z8 43 44 1A 1B 1D 1F 1G 2C 3H 4A 4B 4C 4G 4H 5H AA AB AD AE AH AI AJ AL AM AP AV B4 BB BD BE BG BH BJ BK BL BO BP BR BT BW BZ CA CG CH CJ CK CL CO CQ CR CS CT CU CV CY CZ DB DC DG DI DJ DN DR DS DT DU DY EC FB FC FD FE FL FP FR GB GL GY GZ HA HC HN IA IC IE IF IL JB JG JR KG KI LE MA MC MT NA NE NF NG NT NU NV OA OT P2 PA PB PD PE PF PG PI PK PL PN PO PR PT PU PV PY PZ QA QB QD QH QK QR RD RG RK RL RO RT SA SD SE SK SL SO SP SS ST SV SW T1 TC TD TE TI TK TL TN TR TS TT TU TV TW TY UC VA VI VP VQ VS WA WB WG WH WM WR WW YL YT ZP ZZ ',concat(' ',normalize-space(.),' ') ) )) )"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="( ( not(contains(normalize-space(.),' ')) and not(contains( ' 5 6 8 16 17 18 19 26 29 30 31 32 36 45 46 47 48 53 54 62 63 69 71 72 73 90 92 93 94 95 96 97 98 1C 1E 1H 1J 1K 1L 1M 1X 2V 2W 3E 3G 3I 4E 5C 5F 5G 5I 5K 5P 5Q AR AW B0 B2 B5 B6 B9 BX C1 C2 C4 C5 C6 C77 C98 D14 D28 D40 D64 D66 D67 D7 D79 D8 D90 D92 D96 D97 D98 D99 DE DQ DRM E2 E3 E5 EP EV F1 F9 FG FM G7 GC GD GH GK GN GW H1 H2 HD HE HF HI HK HL HO HS HT HY II IM IP IT JO KD KF KS KTM L61 L62 LC LI LJ LX M0 MF MK MQ MV N2 NB NBB NC ND NH NI NJ NN NPL NRL NY OP P0 P3 P4 P6 P7 P8 P9 PM PW R4 RA RN RS RU S5 S6 S7 S8 SN SST T4 T5 T6 T7 T8 TA TF TJ TQ TSD TSH UD UE UF UH UM W4 WI Z1 Z2 Z3 Z4 Z5 Z6 Z8 43 44 1A 1B 1D 1F 1G 2C 3H 4A 4B 4C 4G 4H 5H AA AB AD AE AH AI AJ AL AM AP AV B4 BB BD BE BG BH BJ BK BL BO BP BR BT BW BZ CA CG CH CJ CK CL CO CQ CR CS CT CU CV CY CZ DB DC DG DI DJ DN DR DS DT DU DY EC FB FC FD FE FL FP FR GB GL GY GZ HA HC HN IA IC IE IF IL JB JG JR KG KI LE MA MC MT NA NE NF NG NT NU NV OA OT P2 PA PB PD PE PF PG PI PK PL PN PO PR PT PU PV PY PZ QA QB QD QH QK QR RD RG RK RL RO RT SA SD SE SK SL SO SP SS ST SV SW T1 TC TD TE TI TK TL TN TR TS TT TU TV TW TY UC VA VI VP VQ VS WA WB WG WH WM WR WW YL YT ZP ZZ ',concat(' ',normalize-space(.),' ') ) )) )">
               <xsl:attribute name="id">OP-T10-R056</xsl:attribute>
               <xsl:attribute name="flag">warning</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>[OP-T10-R056]-The unit code used has been marked as deprecated and will be removed in a future release.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="( ( not(contains(normalize-space(.),' ')) and not(contains( ' 43 44 1A 1B 1D 1F 1G 2C 3H 4A 4B 4C 4G 4H 5H AA AB AD AE AH AI AJ AL AM AP AV B4 BB BD BE BG BH BJ BK BL BO BP BR BT BW BZ CA CG CH CJ CK CL CO CQ CR CS CT CU CV CY CZ DB DC DG DI DJ DN DR DS DT DU DY EC FB FC FD FE FL FP FR GB GL GY GZ HA HC HN IA IC IE IF IL JB JG JR KG KI LE MA MC MT NA NE NF NG NT NU NV OA OT P2 PA PB PD PE PF PG PI PK PL PN PO PR PT PU PV PY PZ QA QB QD QH QK QR RD RG RK RL RO RT SA SD SE SK SL SO SP SS ST SV SW T1 TC TD TE TI TK TL TN TR TS TT TU TV TW TY UC VA VI VP VQ VS WA WB WG WH WM WR WW YL YT ZP ZZ ',concat(' ',normalize-space(.),' ') ) ) ) )"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="( ( not(contains(normalize-space(.),' ')) and not(contains( ' 43 44 1A 1B 1D 1F 1G 2C 3H 4A 4B 4C 4G 4H 5H AA AB AD AE AH AI AJ AL AM AP AV B4 BB BD BE BG BH BJ BK BL BO BP BR BT BW BZ CA CG CH CJ CK CL CO CQ CR CS CT CU CV CY CZ DB DC DG DI DJ DN DR DS DT DU DY EC FB FC FD FE FL FP FR GB GL GY GZ HA HC HN IA IC IE IF IL JB JG JR KG KI LE MA MC MT NA NE NF NG NT NU NV OA OT P2 PA PB PD PE PF PG PI PK PL PN PO PR PT PU PV PY PZ QA QB QD QH QK QR RD RG RK RL RO RT SA SD SE SK SL SO SP SS ST SV SW T1 TC TD TE TI TK TL TN TR TS TT TU TV TW TY UC VA VI VP VQ VS WA WB WG WH WM WR WW YL YT ZP ZZ ',concat(' ',normalize-space(.),' ') ) ) ) )">
               <xsl:attribute name="id">OP-T10-R057</xsl:attribute>
               <xsl:attribute name="flag">warning</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>[OP-T10-R057]-The unit code used has been marked for change in a future release so that will be prefixed with an X. As example code AE will become code XAE.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>			   
      <xsl:apply-templates select="@*|*" mode="M7"/>
   </xsl:template>

	  <!--RULE -->
   <xsl:template match="cbc:CompanyID//@schemeID" priority="1003" mode="M7">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="cbc:CompanyID//@schemeID"/>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="( ( not(contains(normalize-space(.),' ')) and contains( ' FR:SIRENE SE:ORGNR FR:SIRET FI:OVT DUNS GLN DK:P IT:FTI NL:KVK IT:SIA IT:SECETI DIGST DK:CPR DK:CVR DK:SE DK:VANS IT:VAT IT:CF NO:ORGNR NO:VAT HU:VAT EU:REID AT:VAT AT:GOV IS:KT IBAN AT:KUR ES:VAT IT:IPA AD:VAT AL:VAT BA:VAT BE:VAT BG:VAT CH:VAT CY:VAT CZ:VAT DE:VAT EE:VAT GB:VAT GR:VAT HR:VAT IE:VAT LI:VAT LT:VAT LU:VAT LV:VAT MC:VAT ME:VAT MK:VAT MT:VAT NL:VAT PL:VAT PT:VAT RO:VAT RS:VAT SI:VAT SK:VAT SM:VAT TR:VAT VA:VAT NL:ION NL:OIN SE:VAT BE:CBE FR:VAT ZZZ ',concat(' ',normalize-space(.),' ') ) ) )"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="( ( not(contains(normalize-space(.),' ')) and contains( ' FR:SIRENE SE:ORGNR FR:SIRET FI:OVT DUNS GLN DK:P IT:FTI NL:KVK IT:SIA IT:SECETI DIGST DK:CPR DK:CVR DK:SE DK:VANS IT:VAT IT:CF NO:ORGNR NO:VAT HU:VAT EU:REID AT:VAT AT:GOV IS:KT IBAN AT:KUR ES:VAT IT:IPA AD:VAT AL:VAT BA:VAT BE:VAT BG:VAT CH:VAT CY:VAT CZ:VAT DE:VAT EE:VAT GB:VAT GR:VAT HR:VAT IE:VAT LI:VAT LT:VAT LU:VAT LV:VAT MC:VAT ME:VAT MK:VAT MT:VAT NL:VAT PL:VAT PT:VAT RO:VAT RS:VAT SI:VAT SK:VAT SM:VAT TR:VAT VA:VAT NL:ION NL:OIN SE:VAT BE:CBE FR:VAT ZZZ ',concat(' ',normalize-space(.),' ') ) ) )">
               <xsl:attribute name="id">OP-T10-R008</xsl:attribute>
               <xsl:attribute name="flag">fatal</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>[OP-T10-R008]-A Party Company Identifier Scheme MUST be from the list of PEPPOL Party Identifiers described in the "PEPPOL Policy for using Identifiers".</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="@*|*" mode="M7"/>
   </xsl:template>

	  <!--RULE -->
   <xsl:template match="cbc:TaxCurrencyCode" priority="1002" mode="M7">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="cbc:TaxCurrencyCode"/>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="( ( not(contains(normalize-space(.),' ')) and contains( ' AED AFN ALL AMD ANG AOA ARS AUD AWG AZN BAM BBD BDT BGN BHD BIF BMD BND BOB BOV BRL BSD BTN BWP BYR BZD CAD CDF CHE CHF CHW CLF CLP CNY COP COU CRC CUP CVE CZK DJF DKK DOP DZD EEK EGP ERN ETB EUR FJD FKP GBP GEL GHS GIP GMD GNF GTQ GWP GYD HKD HNL HRK HTG HUF IDR ILS INR IQD IRR ISK JMD JOD JPY KES KGS KHR KMF KPW KRW KWD KYD KZT LAK LBP LKR LRD LSL LTL LVL LYD MAD MDL MGA MKD MMK MNT MOP MRO MUR MVR MWK MXN MXV MYR MZN NAD NGN NIO NOK NPR NZD OMR PAB PEN PGK PHP PKR PLN PYG QAR RON RSD RUB RWF SAR SBD SCR SDG SEK SGD SHP SKK SLL SOS SRD STD SVC SYP SZL THB TJS TMM TND TOP TRY TTD TWD TZS UAH UGX USD USN USS UYI UYU UZS VEF VND VUV WST XAF XAG XAU XBA XBB XBC XBD XCD XDR XFU XOF XPD XPF XTS XXX YER ZAR ZMK ZWR ZWD ',concat(' ',normalize-space(.),' ') ) ) )"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="( ( not(contains(normalize-space(.),' ')) and contains( ' AED AFN ALL AMD ANG AOA ARS AUD AWG AZN BAM BBD BDT BGN BHD BIF BMD BND BOB BOV BRL BSD BTN BWP BYR BZD CAD CDF CHE CHF CHW CLF CLP CNY COP COU CRC CUP CVE CZK DJF DKK DOP DZD EEK EGP ERN ETB EUR FJD FKP GBP GEL GHS GIP GMD GNF GTQ GWP GYD HKD HNL HRK HTG HUF IDR ILS INR IQD IRR ISK JMD JOD JPY KES KGS KHR KMF KPW KRW KWD KYD KZT LAK LBP LKR LRD LSL LTL LVL LYD MAD MDL MGA MKD MMK MNT MOP MRO MUR MVR MWK MXN MXV MYR MZN NAD NGN NIO NOK NPR NZD OMR PAB PEN PGK PHP PKR PLN PYG QAR RON RSD RUB RWF SAR SBD SCR SDG SEK SGD SHP SKK SLL SOS SRD STD SVC SYP SZL THB TJS TMM TND TOP TRY TTD TWD TZS UAH UGX USD USN USS UYI UYU UZS VEF VND VUV WST XAF XAG XAU XBA XBB XBC XBD XCD XDR XFU XOF XPD XPF XTS XXX YER ZAR ZMK ZWR ZWD ',concat(' ',normalize-space(.),' ') ) ) )">
               <xsl:attribute name="id">OP-T10-R009</xsl:attribute>
               <xsl:attribute name="flag">fatal</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>[OP-T10-R009]-TaxCurrencyCode MUST be coded using ISO code list 4217</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="@*|*" mode="M7"/>
   </xsl:template>

	  <!--RULE -->
   <xsl:template match="cbc:SourceCurrencyCode" priority="1001" mode="M7">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="cbc:SourceCurrencyCode"/>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="( ( not(contains(normalize-space(.),' ')) and contains( ' AED AFN ALL AMD ANG AOA ARS AUD AWG AZN BAM BBD BDT BGN BHD BIF BMD BND BOB BOV BRL BSD BTN BWP BYR BZD CAD CDF CHE CHF CHW CLF CLP CNY COP COU CRC CUP CVE CZK DJF DKK DOP DZD EEK EGP ERN ETB EUR FJD FKP GBP GEL GHS GIP GMD GNF GTQ GWP GYD HKD HNL HRK HTG HUF IDR ILS INR IQD IRR ISK JMD JOD JPY KES KGS KHR KMF KPW KRW KWD KYD KZT LAK LBP LKR LRD LSL LTL LVL LYD MAD MDL MGA MKD MMK MNT MOP MRO MUR MVR MWK MXN MXV MYR MZN NAD NGN NIO NOK NPR NZD OMR PAB PEN PGK PHP PKR PLN PYG QAR RON RSD RUB RWF SAR SBD SCR SDG SEK SGD SHP SKK SLL SOS SRD STD SVC SYP SZL THB TJS TMM TND TOP TRY TTD TWD TZS UAH UGX USD USN USS UYI UYU UZS VEF VND VUV WST XAF XAG XAU XBA XBB XBC XBD XCD XDR XFU XOF XPD XPF XTS XXX YER ZAR ZMK ZWR ZWD ',concat(' ',normalize-space(.),' ') ) ) )"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="( ( not(contains(normalize-space(.),' ')) and contains( ' AED AFN ALL AMD ANG AOA ARS AUD AWG AZN BAM BBD BDT BGN BHD BIF BMD BND BOB BOV BRL BSD BTN BWP BYR BZD CAD CDF CHE CHF CHW CLF CLP CNY COP COU CRC CUP CVE CZK DJF DKK DOP DZD EEK EGP ERN ETB EUR FJD FKP GBP GEL GHS GIP GMD GNF GTQ GWP GYD HKD HNL HRK HTG HUF IDR ILS INR IQD IRR ISK JMD JOD JPY KES KGS KHR KMF KPW KRW KWD KYD KZT LAK LBP LKR LRD LSL LTL LVL LYD MAD MDL MGA MKD MMK MNT MOP MRO MUR MVR MWK MXN MXV MYR MZN NAD NGN NIO NOK NPR NZD OMR PAB PEN PGK PHP PKR PLN PYG QAR RON RSD RUB RWF SAR SBD SCR SDG SEK SGD SHP SKK SLL SOS SRD STD SVC SYP SZL THB TJS TMM TND TOP TRY TTD TWD TZS UAH UGX USD USN USS UYI UYU UZS VEF VND VUV WST XAF XAG XAU XBA XBB XBC XBD XCD XDR XFU XOF XPD XPF XTS XXX YER ZAR ZMK ZWR ZWD ',concat(' ',normalize-space(.),' ') ) ) )">
               <xsl:attribute name="id">OP-T10-R010</xsl:attribute>
               <xsl:attribute name="flag">fatal</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>[OP-T10-R010]-SourceCurrencyCode MUST be coded using ISO code list 4217</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="@*|*" mode="M7"/>
   </xsl:template>

	  <!--RULE -->
   <xsl:template match="cbc:TargetCurrencyCode" priority="1000" mode="M7">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="cbc:TargetCurrencyCode"/>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="( ( not(contains(normalize-space(.),' ')) and contains( ' AED AFN ALL AMD ANG AOA ARS AUD AWG AZN BAM BBD BDT BGN BHD BIF BMD BND BOB BOV BRL BSD BTN BWP BYR BZD CAD CDF CHE CHF CHW CLF CLP CNY COP COU CRC CUP CVE CZK DJF DKK DOP DZD EEK EGP ERN ETB EUR FJD FKP GBP GEL GHS GIP GMD GNF GTQ GWP GYD HKD HNL HRK HTG HUF IDR ILS INR IQD IRR ISK JMD JOD JPY KES KGS KHR KMF KPW KRW KWD KYD KZT LAK LBP LKR LRD LSL LTL LVL LYD MAD MDL MGA MKD MMK MNT MOP MRO MUR MVR MWK MXN MXV MYR MZN NAD NGN NIO NOK NPR NZD OMR PAB PEN PGK PHP PKR PLN PYG QAR RON RSD RUB RWF SAR SBD SCR SDG SEK SGD SHP SKK SLL SOS SRD STD SVC SYP SZL THB TJS TMM TND TOP TRY TTD TWD TZS UAH UGX USD USN USS UYI UYU UZS VEF VND VUV WST XAF XAG XAU XBA XBB XBC XBD XCD XDR XFU XOF XPD XPF XTS XXX YER ZAR ZMK ZWR ZWD ',concat(' ',normalize-space(.),' ') ) ) )"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="( ( not(contains(normalize-space(.),' ')) and contains( ' AED AFN ALL AMD ANG AOA ARS AUD AWG AZN BAM BBD BDT BGN BHD BIF BMD BND BOB BOV BRL BSD BTN BWP BYR BZD CAD CDF CHE CHF CHW CLF CLP CNY COP COU CRC CUP CVE CZK DJF DKK DOP DZD EEK EGP ERN ETB EUR FJD FKP GBP GEL GHS GIP GMD GNF GTQ GWP GYD HKD HNL HRK HTG HUF IDR ILS INR IQD IRR ISK JMD JOD JPY KES KGS KHR KMF KPW KRW KWD KYD KZT LAK LBP LKR LRD LSL LTL LVL LYD MAD MDL MGA MKD MMK MNT MOP MRO MUR MVR MWK MXN MXV MYR MZN NAD NGN NIO NOK NPR NZD OMR PAB PEN PGK PHP PKR PLN PYG QAR RON RSD RUB RWF SAR SBD SCR SDG SEK SGD SHP SKK SLL SOS SRD STD SVC SYP SZL THB TJS TMM TND TOP TRY TTD TWD TZS UAH UGX USD USN USS UYI UYU UZS VEF VND VUV WST XAF XAG XAU XBA XBB XBC XBD XCD XDR XFU XOF XPD XPF XTS XXX YER ZAR ZMK ZWR ZWD ',concat(' ',normalize-space(.),' ') ) ) )">
               <xsl:attribute name="id">OP-T10-R011</xsl:attribute>
               <xsl:attribute name="flag">fatal</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>[OP-T10-R011]-TargetCurrencyCode MUST be coded using ISO code list 4217</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="@*|*" mode="M7"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M7"/>
   <xsl:template match="@*|node()" priority="-2" mode="M7">
      <xsl:apply-templates select="@*|*" mode="M7"/>
   </xsl:template>
   
<!--PATTERN ITNAT-T10-->

	<!--RULE -->

   <xsl:template match="//cac:TaxRepresentativeParty" priority="1008" mode="M8">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="//cac:TaxRepresentativeParty"/>

		<!--ASSERT -->

      <xsl:choose>
         <xsl:when test="(cac:PartyTaxScheme/cbc:CompanyID[@schemeID = 'IT:VAT'] and cac:PartyName/cbc:Name) and not(//cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode = 'IT')"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="(cac:PartyTaxScheme/cbc:CompanyID[@schemeID = 'IT:VAT'] and cac:PartyName/cbc:Name) and not(//cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode = 'IT')">
               <xsl:attribute name="flag">fatal</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-get-full-path"/>
               </xsl:attribute>
               <svrl:text>[IT-T10-R003] - Se il cedente/prestatore non è italiano e ha un rappresentante fiscale italiano, la fattura DEVE contenere il numero di partita IVA e il nome completo del rappresentante fiscale.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="@*|*" mode="M8"/>
   </xsl:template>

	<!--RULE -->

   <xsl:template match="//cac:AccountingSupplierParty/cac:Party[cac:PostalAddress/cac:Country/cbc:IdentificationCode = 'IT']/cac:PostalAddress" priority="1007" mode="M8">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="//cac:AccountingSupplierParty/cac:Party[cac:PostalAddress/cac:Country/cbc:IdentificationCode = 'IT']/cac:PostalAddress"/>

		<!--ASSERT -->

      <xsl:choose>
         <xsl:when test="cbc:StreetName and cbc:CityName and cbc:PostalZone and cac:Country/cbc:IdentificationCode"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="cbc:StreetName and cbc:CityName and cbc:PostalZone and cac:Country/cbc:IdentificationCode">
               <xsl:attribute name="flag">fatal</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-get-full-path"/>
               </xsl:attribute>
               <svrl:text>[IT-T10-R005] - Se il cedente/prestatore è italiano, l'indirizzo del cedente/prestatore DEVE contenere almeno via, città, codice d'avviamento postale e codice Paese.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="@*|*" mode="M8"/>
   </xsl:template>

	<!--RULE -->

   <xsl:template match="//cac:AccountingCustomerParty/cac:Party[cac:PostalAddress/cac:Country/cbc:IdentificationCode = 'IT']/cac:PostalAddress" priority="1006" mode="M8">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="//cac:AccountingCustomerParty/cac:Party[cac:PostalAddress/cac:Country/cbc:IdentificationCode = 'IT']/cac:PostalAddress"/>

		<!--ASSERT -->

      <xsl:choose>
         <xsl:when test="cbc:StreetName and cbc:CityName and cbc:PostalZone and cac:Country/cbc:IdentificationCode"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="cbc:StreetName and cbc:CityName and cbc:PostalZone and cac:Country/cbc:IdentificationCode">
               <xsl:attribute name="flag">fatal</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-get-full-path"/>
               </xsl:attribute>
               <svrl:text>[IT-T10-R008] - Se il cedente/prestatore è italiano, l'indirizzo del committente/cessionario DEVE contenere almeno via, città, codice d'avviamento postale e codice Paese.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="@*|*" mode="M8"/>
   </xsl:template>

	<!--RULE -->

   <xsl:template match="//cac:AccountingSupplierParty/cac:Party[cac:PostalAddress/cac:Country/cbc:IdentificationCode = 'IT']/cac:PartyLegalEntity[cbc:CompanyID/@schemeID = 'ZZZ' and cac:CorporateRegistrationScheme/cbc:Name='REA']" priority="1005" mode="M8">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="//cac:AccountingSupplierParty/cac:Party[cac:PostalAddress/cac:Country/cbc:IdentificationCode = 'IT']/cac:PartyLegalEntity[cbc:CompanyID/@schemeID = 'ZZZ' and cac:CorporateRegistrationScheme/cbc:Name='REA']"/>

		<!--ASSERT -->

      <xsl:choose>
         <xsl:when test="cbc:CompanyID and cac:RegistrationAddress/cbc:CityName and cbc:CompanyLiquidationStatusCode"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="cbc:CompanyID and cac:RegistrationAddress/cbc:CityName and cbc:CompanyLiquidationStatusCode">
               <xsl:attribute name="flag">fatal</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-get-full-path"/>
               </xsl:attribute>
               <svrl:text>[IT-T10-R013] - Se il cedente/prestatore è italiano ed è iscritto al registro delle imprese (REA), la fattura DEVE contenere la sigla della provincia dell’ufficio delle imprese presso il quale la società è registrata, il numero REA e lo stato di liquidazione. Nel caso di società di capitale (SpA, SApA, SRL) si DEVE includere il Capitale Sociale e l’indicazione se è a Socio Unico.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="@*|*" mode="M8"/>
   </xsl:template>

	<!--RULE -->

   <xsl:template match="/ubl:Invoice" priority="1004" mode="M8">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="/ubl:Invoice"/>

		<!--ASSERT -->

      <xsl:choose>
         <xsl:when test="(cbc:InvoiceTypeCode and (cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode = 'IT')) or not(cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode = 'IT')"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="(cbc:InvoiceTypeCode and (cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode = 'IT')) or not(cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode = 'IT')">
               <xsl:attribute name="flag">fatal</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-get-full-path"/>
               </xsl:attribute>
               <svrl:text>[IT-T10-R016] - Se il cedente/prestatore è italiano, la fattura DEVE contenere il tipo fattura.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>     
      <xsl:apply-templates select="@*|*" mode="M8"/>
   </xsl:template>

	<!--RULE -->

   <xsl:template match="//cac:DespatchDocumentReference" priority="1003" mode="M8">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="//cac:DespatchDocumentReference"/>

		<!--ASSERT -->

      <xsl:choose>
         <xsl:when test="((cbc:ID and cbc:IssueDate and cbc:DocumentType) and (//cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode = 'IT')) or not((//cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode = 'IT'))"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="((cbc:ID and cbc:IssueDate and cbc:DocumentType) and (//cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode = 'IT')) or not((//cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode = 'IT'))">
               <xsl:attribute name="flag">fatal</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-get-full-path"/>
               </xsl:attribute>
               <svrl:text>[IT-T10-R017] - Se il cedente/prestatore è italiano, il riferimento ad un documento di trasporto collegato alla fattura DEVE contenere il numero e la data di emissione del documento.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="@*|*" mode="M8"/>
   </xsl:template>

	<!--RULE -->

   <xsl:template match="//cac:InvoiceLine" priority="1002" mode="M8">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="//cac:InvoiceLine"/>

		<!--ASSERT -->

      <xsl:choose>
         <xsl:when test="((cbc:InvoicedQuantity) and (cbc:InvoicedQuantity/@unitCode) and (//cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode = 'IT')) or not((//cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode = 'IT'))"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="((cbc:InvoicedQuantity) and (cbc:InvoicedQuantity/@unitCode) and (//cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode = 'IT')) or not((//cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode = 'IT'))">
               <xsl:attribute name="flag">fatal</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-get-full-path"/>
               </xsl:attribute>
               <svrl:text>[IT-T10-R024] - Se il cedente/prestatore è italiano, ogni riga di fattura DEVE contenere la quantità e l'unità di misura.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      
		<!--ASSERT -->

      <xsl:choose>
         <xsl:when test="((cac:Price/cbc:PriceAmount) and (//cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode = 'IT')) or not((//cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode = 'IT'))"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="((cac:Price/cbc:PriceAmount) and (//cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode = 'IT')) or not((//cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode = 'IT'))">
               <xsl:attribute name="flag">fatal</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-get-full-path"/>
               </xsl:attribute>
               <svrl:text>[IT-T10-R031] - Se il cedente/prestatore è italiano, ogni riga di fattura DEVE contenere il prezzo unitario del bene/servizio.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="@*|*" mode="M8"/>
   </xsl:template>

	<!--RULE -->

   <xsl:template match="//cac:DespatchLineReference/cac:DocumentReference" priority="1001" mode="M8">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="//cac:DespatchLineReference/cac:DocumentReference"/>

		<!--ASSERT -->

      <xsl:choose>
         <xsl:when test="((cbc:ID and cbc:IssueDate and cbc:DocumentType) and (//cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode = 'IT')) or not((//cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode = 'IT'))"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="((cbc:ID and cbc:IssueDate and cbc:DocumentType) and (//cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode = 'IT')) or not((//cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode = 'IT'))">
               <xsl:attribute name="flag">fatal</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-get-full-path"/>
               </xsl:attribute>
               <svrl:text>[IT-T10-R032] - Se il cedente/prestatore è italiano, il riferimento ad un documento di trasporto collegato ad una riga di fattura DEVE contenere il numero e la data di emissione del documento.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="@*|*" mode="M8"/>
   </xsl:template>

	<!--RULE -->

   <xsl:template match="//cac:AccountingSupplierParty/cac:Party[cac:PostalAddress/cac:Country/cbc:IdentificationCode != 'IT']/cac:AgentParty/cac:PostalAddress" priority="1000" mode="M8">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="//cac:AccountingSupplierParty/cac:Party[cac:PostalAddress/cac:Country/cbc:IdentificationCode != 'IT']/cac:AgentParty/cac:PostalAddress"/>

		<!--ASSERT -->

      <xsl:choose>
         <xsl:when test="cbc:StreetName and cbc:CityName and cbc:PostalZone and cac:Country/cbc:IdentificationCode"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="cbc:StreetName and cbc:CityName and cbc:PostalZone and cac:Country/cbc:IdentificationCode">
               <xsl:attribute name="flag">fatal</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-get-full-path"/>
               </xsl:attribute>
               <svrl:text>[IT-T10-R040] - Se il cedente/prestatore non è residente, ma effettua la transazione oggetto della fattura mediante una stabile organizzazione residente in Italia, l'indirizzo della stabile organizzazione o agente del committente/cessionario DEVE contenere almeno via, città, codice d'avviamento postale e codice Paese.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="@*|*" mode="M8"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M8"/>
   <xsl:template match="@*|node()" priority="-2" mode="M8">
      <xsl:apply-templates select="@*|*" mode="M8"/>
   </xsl:template>

<!--PATTERN ITNAT-SDI-T10-->

	<!--RULE -->

   <xsl:template match="//cac:AccountingSupplierParty/cac:Party/cac:PostalAddress[cac:Country/cbc:IdentificationCode = 'IT']" priority="1033" mode="M9">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="//cac:AccountingSupplierParty/cac:Party/cac:PostalAddress[cac:Country/cbc:IdentificationCode = 'IT']"/>

		<!--ASSERT -->

      <xsl:choose>
         <xsl:when test="(cbc:BuildingNumber) or string-length(cbc:StreetName) &gt; string-length(normalize-space(translate(cbc:StreetName, '0123456789', ' '))) or contains(cbc:StreetName, 's.n.c.')"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="(cbc:BuildingNumber) or string-length(cbc:StreetName) &gt; string-length(normalize-space(translate(cbc:StreetName, '0123456789', ' '))) or contains(cbc:StreetName, 's.n.c.')">
               <xsl:attribute name="flag">fatal</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-get-full-path"/>
               </xsl:attribute>
               <svrl:text>[SDI-T10-R001] - Se il cedente/prestatore è italiano, l'indirizzo del cedente/prestatore DEVE contenere il numero civico o l'acronimo s.n.c. (senza numero civico)</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="@*|*" mode="M9"/>
   </xsl:template>

	<!--RULE -->

   <xsl:template match="//cac:AccountingCustomerParty/cac:Party" priority="1032" mode="M9">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="//cac:AccountingCustomerParty/cac:Party"/>

		<!--ASSERT -->

      <xsl:choose>
         <xsl:when test="((cac:PartyTaxScheme/cbc:CompanyID) and (//cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode = 'IT')) or
(not(//cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode = 'IT') or (cac:PartyIdentification/cbc:ID='CODDEST:0000000' and cac:Person/cbc:ID/@schemeID='IT:CF'))"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="((cac:PartyTaxScheme/cbc:CompanyID) and (//cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode = 'IT')) or
(not(//cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode = 'IT') or (cac:PartyIdentification/cbc:ID='CODDEST:0000000' and cac:Person/cbc:ID/@schemeID='IT:CF'))">
               <xsl:attribute name="flag">fatal</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-get-full-path"/>
               </xsl:attribute>
               <svrl:text>[SDI-T10-R002] - Se il cedente/prestatore è italiano, la fattura DEVE contenere l'identificativo fiscale del cessionario/committente (Operatore Economico).</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		<!--ASSERT -->

      <xsl:choose>
         <xsl:when test="cac:PartyIdentification/cbc:ID[@schemeID='IT:IPA'][(string-length(translate(.,concat($vUpper,$vDigits),'')) = 0 and string-length() &gt;= 6 and string-length() &lt;= 7) or (starts-with(upper-case(.),'CODDEST:') and string-length(translate(substring-after(., ':'),concat($vUpper,$vDigits),'')) = 0 and string-length() &gt;= 14 and string-length() &lt;= 15)]"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="cac:PartyIdentification/cbc:ID[@schemeID='IT:IPA'][(string-length(translate(.,concat($vUpper,$vDigits),'')) = 0 and string-length() &gt;= 6 and string-length() &lt;= 7) or (starts-with(upper-case(.),'CODDEST:') and string-length(translate(substring-after(., ':'),concat($vUpper,$vDigits),'')) = 0 and string-length() &gt;= 14 and string-length() &lt;= 15)]">
               <xsl:attribute name="flag">fatal</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-get-full-path"/>
               </xsl:attribute>
               <svrl:text>[SDI-T10-R010] - Una fattura DEVE contenere Il codice UFE IPA dell'ufficio della PA destinataria o del codice destinatario (CODDEST) del soggetto accreditato (B2B) destinatario della fattura, composto da 6 a 7 caratteri ASCII alfanumerici.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
	  
		<!--ASSERT -->

      <xsl:choose>
         <xsl:when test="cac:PartyIdentification/cbc:ID[@schemeID='IT:IPA']!='CODDEST:XXXXXXX' or (normalize-space(cac:PostalAddress/cac:Country/cbc:IdentificationCode) and cac:PostalAddress/cac:Country/cbc:IdentificationCode != 'IT')"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="cac:PartyIdentification/cbc:ID[@schemeID='IT:IPA']!='CODDEST:XXXXXXX' or (normalize-space(cac:PostalAddress/cac:Country/cbc:IdentificationCode) and cac:PostalAddress/cac:Country/cbc:IdentificationCode != 'IT')">
               <xsl:attribute name="flag">fatal</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-get-full-path"/>
               </xsl:attribute>
               <svrl:text>[SDI-T10-R043] - Se il soggetto destinatario (B2B) della fattura non è residente, nè stabilito o identificato in Italia, il codice paese dovrà essere specificato e diverso da IT.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="@*|*" mode="M9"/>
   </xsl:template>

   <xsl:template match="//cac:PartyTaxScheme/cbc:CompanyID[@schemeID='IT:CF' and ../../cac:PartyIdentification/cbc:ID='CODDEST:0000000']" priority="1031" mode="M9">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="//cac:PartyTaxScheme/cbc:CompanyID[@schemeID='IT:CF' and ../../cac:PartyIdentification/cbc:ID='CODDEST:0000000']"/>

		<!--ASSERT -->

      <xsl:choose>
         <xsl:when test="(string-length(translate(.,$vBasicLatin,'')) = 0 and string-length() = 16) or not(../../cac:Person[cbc:ID/@schemeID='IT:CF'])"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="(string-length(translate(.,$vBasicLatin,'')) = 0 and string-length() = 16) or not(../../cac:Person[cbc:ID/@schemeID='IT:CF'])">
               <xsl:attribute name="flag">fatal</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-get-full-path"/>
               </xsl:attribute>
               <svrl:text>[SDI-T10-R044] - Il codice fiscale di una persona fisica DEVE essere fornito sia nel PartyTaxScheme/CompanyID che nell'entità Person e deve essere composto da 16 caratteri alfanumerici.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="@*|*" mode="M9"/>
   </xsl:template>

	<!--RULE -->

   <xsl:template match="//cac:AccountingCustomerParty/cac:Party/cac:PostalAddress" priority="1030" mode="M9">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="//cac:AccountingCustomerParty/cac:Party/cac:PostalAddress"/>

		<!--ASSERT -->

      <xsl:choose>
         <xsl:when test="(((cbc:BuildingNumber) or string-length(cbc:StreetName) &gt; string-length(normalize-space(translate(cbc:StreetName, '0123456789', ' '))) or contains(cbc:StreetName, 's.n.c.')) and (//cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode = 'IT')) or (not(//cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode = 'IT'))"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="(((cbc:BuildingNumber) or string-length(cbc:StreetName) &gt; string-length(normalize-space(translate(cbc:StreetName, '0123456789', ' '))) or contains(cbc:StreetName, 's.n.c.')) and (//cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode = 'IT')) or (not(//cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode = 'IT'))">
               <xsl:attribute name="flag">fatal</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-get-full-path"/>
               </xsl:attribute>
               <svrl:text>[SDI-T10-R003] - Se il cedente/prestatore è italiano, l'indirizzo del cessionario/committente DEVE contenere il numero civico o l'acronimo s.n.c. (senza numero civico).</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="@*|*" mode="M9"/>
   </xsl:template>

	<!--RULE -->

   <xsl:template match="//cac:WithholdingTaxTotal/cac:TaxSubtotal[1]" priority="1029" mode="M9">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="//cac:WithholdingTaxTotal/cac:TaxSubtotal[1]"/>

		<!--ASSERT -->

      <xsl:choose>
         <xsl:when test="((cac:TaxCategory/cbc:Percent) and (cbc:TaxAmount) and (cac:TaxCategory/cac:TaxScheme/cbc:TaxTypeCode) and (//cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode = 'IT')) or (not(//cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode = 'IT'))"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="((cbc:TaxableAmount) and (cac:TaxCategory/cbc:Percent) and (cbc:TaxAmount) and (cac:TaxCategory/cac:TaxScheme/cbc:TaxTypeCode) and (//cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode = 'IT')) or (not(//cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode = 'IT'))">
               <xsl:attribute name="flag">fatal</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-get-full-path"/>
               </xsl:attribute>
               <svrl:text>[SDI-T10-R004] - Se il cedente/prestatore è italiano, nei casi in cui sia applicabile la ritenuta di acconto DEVONO essere indicati almeno l'importo, la tipologia, l'aliquota e la causale pagamento.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="@*|*" mode="M9"/>
   </xsl:template>

	<!--RULE -->

   <xsl:template match="//ext:UBLExtensions/ext:UBLExtension[ext:ExtensionURI='urn:www.ubl-italia.org:spec:fatturapa:bollo']/ext:ExtensionContent" priority="1028" mode="M9">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="//ext:UBLExtensions/ext:UBLExtension[ext:ExtensionURI='urn:www.ubl-italia.org:spec:fatturapa:bollo']/ext:ExtensionContent"/>

		<!--ASSERT -->

      <xsl:choose>
         <xsl:when test="(cbc:TaxAmount)"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="(cbc:TaxAmount)">
               <xsl:attribute name="flag">fatal</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-get-full-path"/>
               </xsl:attribute>
               <svrl:text>[SDI-T10-R005] - Se il cedente/prestatore è italiano, nei casi in cui sia prevista l'imposta di bollo, DEVONO essere indicati l'importo e gli estremi della relativa autorizzazione.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="@*|*" mode="M9"/>
   </xsl:template>

	<!--RULE -->

   <xsl:template match="//cac:TaxTotal/cac:TaxSubtotal[cac:TaxCategory/cbc:ID = 'AE']" priority="1027" mode="M9">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="//cac:TaxTotal/cac:TaxSubtotal[cac:TaxCategory/cbc:ID = 'AE']"/>

		<!--ASSERT -->

      <xsl:choose>
         <xsl:when test="((cac:TaxCategory/cbc:TaxExemptionReason) and (//cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode = 'IT')) or (not(//cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode = 'IT'))"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="((cac:TaxCategory/cbc:TaxExemptionReason) and (//cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode = 'IT')) or (not(//cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode = 'IT'))">
               <xsl:attribute name="flag">fatal</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-get-full-path"/>
               </xsl:attribute>
               <svrl:text>[SDI-T10-R006] - Se il cedente/prestatore è italiano ed il cessionario/committente è debitore di imposta in luogo del cedente/prestatore (reverse charge), la fattura DEVE contenere la norma di riferimento, comunitaria o nazionale.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="@*|*" mode="M9"/>
   </xsl:template>

	<!--RULE -->

   <xsl:template match="//cac:InvoiceLine/cac:OrderLineReference" priority="1026" mode="M9">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="//cac:InvoiceLine/cac:OrderLineReference"/>

		<!--ASSERT -->

      <xsl:choose>
         <xsl:when test="((cac:OrderReference/cbc:ID or /*/cac:OrderReference/cbc:ID) and //cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode = 'IT') or not(//cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode = 'IT')"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="((cac:OrderReference/cbc:ID or /*/cac:OrderReference/cbc:ID) and //cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode = 'IT') or not(//cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode = 'IT')">
               <xsl:attribute name="flag">fatal</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-get-full-path"/>
               </xsl:attribute>
               <svrl:text>[SDI-T10-R007] - Se il cedente/prestatore è italiano, ogni riferimento ad un documento collegato ad una riga di fattura DEVE contenere almeno il numero del documento.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="@*|*" mode="M9"/>
   </xsl:template>
   
	<!--RULE -->

   <xsl:template match="//cac:InvoiceLine/cac:InvoicePeriod" priority="1025" mode="M9">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="//cac:InvoiceLine/cac:InvoicePeriod"/>

		<!--ASSERT -->

      <xsl:choose>
         <xsl:when test="((cbc:StartDate) and (cbc:EndDate) and (//cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode = 'IT')) or (not(//cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode = 'IT'))"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="((cbc:StartDate) and (cbc:EndDate) and (//cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode = 'IT')) or (not(//cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode = 'IT'))">
               <xsl:attribute name="flag">fatal</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-get-full-path"/>
               </xsl:attribute>
               <svrl:text>[SDI-T10-R009] - Se il cedente/prestatore è italiano, ogni riga di fattura relativa a prestazione di servizio DEVE indicare la data di inizio e la data di fine del periodo cui si riferisce l'eventuale servizio prestato.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="@*|*" mode="M9"/>
   </xsl:template>

	<!--RULE -->

   <xsl:template match="//cac:AccountingSupplierParty/cac:Party[cac:PostalAddress/cac:Country/cbc:IdentificationCode = 'IT']" priority="1024" mode="M9">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="//cac:AccountingSupplierParty/cac:Party[cac:PostalAddress/cac:Country/cbc:IdentificationCode = 'IT']"/>

		<!--ASSERT -->

      <xsl:choose>
         <xsl:when test="cac:PartyTaxScheme/cbc:ExemptionReason"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="cac:PartyTaxScheme/cbc:ExemptionReason">
               <xsl:attribute name="flag">warning</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-get-full-path"/>
               </xsl:attribute>
               <svrl:text>[SDI-T10-R011] - Per i fornitori italiani Il regime fiscale è obbligatorio. Se non viene indicato, si assume il regime ordinario (RF01).</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="@*|*" mode="M9"/>
   </xsl:template>

	<!--RULE -->

   <xsl:template match="/ubl:Invoice" priority="1023" mode="M9">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="/ubl:Invoice"/>

		<!--ASSERT -->

      <xsl:choose>
         <xsl:when test="count(cbc:ID/@*) = 0 or cbc:ID/@schemeID='art73dpr633/72'"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="count(cbc:ID/@*) = 0 or cbc:ID/@schemeID='art73dpr633/72'">
               <xsl:attribute name="flag">fatal</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-get-full-path"/>
               </xsl:attribute>
               <svrl:text>[SDI-T10-R012] - Se il documento è stato emesso secondo modalità e termini stabiliti con D.M. ai sensi dell'art. 73 del DPR 633/72 (ciò consente al cedente/prestatore l'emissione nello stesso anno di più documenti aventi stesso numero), DEVE usare lo schemeID ‘art73dpr633/72’.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		<!--ASSERT -->

      <xsl:choose>
         <xsl:when test="matches(cbc:ID,'\d') and string-length(translate(cbc:ID,$vBasicLatin,'')) = 0 and string-length(cbc:ID) &gt;= 1 and string-length(cbc:ID) &lt;= 20"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="matches(cbc:ID,'\d') and string-length(translate(cbc:ID,$vBasicLatin,'')) = 0 and string-length(cbc:ID) &gt;= 1 and string-length(cbc:ID) &lt;= 20">
               <xsl:attribute name="flag">fatal</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-get-full-path"/>
               </xsl:attribute>
               <svrl:text>[SDI-T10-R031] - Il numero fattura DEVE essere composto da 1 fino ad un massimo di 20 caratteri ASCII alfanumerici e deve contenere almeno un carattere numerico.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      
		<!--ASSERT -->

      <xsl:choose>
         <xsl:when test="count(cac:InvoiceLine) &lt;= 9999 and count(cac:InvoiceLine/cbc:ID[string-length(translate(.,$vDigits,'')) &gt; 0]) = 0"/><!-- or string-length() &gt; 4-->
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="count(cac:InvoiceLine) &lt;= 9999 and count(cac:InvoiceLine/cbc:ID[string-length(translate(.,$vDigits,'')) &gt; 0]) = 0">
               <xsl:attribute name="flag">fatal</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-get-full-path"/>
               </xsl:attribute>
               <svrl:text>[SDI-T10-R030] - Il numero massimo di righe fattura ammesse è 9999 e il numero di riga DEVE essere composto da 1 fino ad un massimo di 4 caratteri numerici.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="@*|*" mode="M9"/>
   </xsl:template>
   
	<!--RULE -->

   <xsl:template match="//cac:InvoiceLine/cac:Item/cbc:Name" priority="1022" mode="M9">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="//cac:InvoiceLine/cac:Item/cbc:Name"/>

		<!--ASSERT -->

      <xsl:choose>
         <xsl:when test="string-length(translate(.,$vBasicLatinWithSupplement,'')) = 0 and string-length() &gt;= 1 and string-length() &lt;= 1000"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="string-length(translate(.,$vBasicLatinWithSupplement,'')) = 0 and string-length() &gt;= 1 and string-length() &lt;= 1000">
               <xsl:attribute name="flag">fatal</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-get-full-path"/>
               </xsl:attribute>
               <svrl:text>[SDI-T10-R013] - Il nome dell'articolo merce o servizio DEVE essere composto da 1 fino ad un massimo di 1000 caratteri latini.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="@*|*" mode="M9"/>
   </xsl:template>

	<!--RULE -->

   <xsl:template match="//cbc:Telephone | //cbc:Telefax" priority="1021" mode="M9">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="//cbc:Telephone | //cbc:Telefax"/>

		<!--ASSERT -->

      <xsl:choose>
         <xsl:when test="string-length(translate(.,$vBasicLatin,'')) = 0 and string-length() &gt;= 5 and string-length() &lt;= 12"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="string-length(translate(.,$vBasicLatin,'')) = 0 and string-length() &gt;= 5 and string-length() &lt;= 12">
               <xsl:attribute name="flag">fatal</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-get-full-path"/>
               </xsl:attribute>
               <svrl:text>[SDI-T10-R014] - Il numero di telefono o fax DEVE essere composto da 5 fino ad un massimo di  12 caratteri ASCII alfanumerici.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="@*|*" mode="M9"/>
   </xsl:template>

	<!--RULE -->

   <xsl:template match="//cbc:ElectronicMail" priority="1020" mode="M9">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="//cbc:ElectronicMail"/>

		<!--ASSERT -->

      <xsl:choose>
         <xsl:when test="string-length(translate(.,$vBasicLatin,'')) = 0 and string-length() &gt;= 7 and string-length() &lt;= 256"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="string-length(translate(.,$vBasicLatin,'')) = 0 and string-length() &gt;= 7 and string-length() &lt;= 256">
               <xsl:attribute name="flag">fatal</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-get-full-path"/>
               </xsl:attribute>
               <svrl:text>[SDI-T10-R015] - L'indirizzo e-mail DEVE essere composto da 7 fino ad un massimo di 256 caratteri ASCII alfanumerici.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="@*|*" mode="M9"/>
   </xsl:template>
   
	<!--RULE -->

   <xsl:template match="//cac:Person/cbc:ID[@schemeID='IT:CF']" priority="1019" mode="M9">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="//cac:Person/cbc:ID[@schemeID='IT:CF']"/>

		<!--ASSERT -->

      <xsl:choose>
         <xsl:when test="string-length(translate(.,$vBasicLatin,'')) = 0 and string-length() = 16"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="string-length(translate(.,$vBasicLatin,'')) = 0 and string-length() = 16">
               <xsl:attribute name="flag">fatal</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-get-full-path"/>
               </xsl:attribute>
               <svrl:text>[SDI-T10-R016] - Il codice fiscale di una persona fisica DEVE essere composto da 16 caratteri alfanumerici.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="@*|*" mode="M9"/>
   </xsl:template>

	<!--RULE -->

   <xsl:template match="//cac:Person/cbc:FirstName | //cac:Person/cbc:FamilyName" priority="1018" mode="M9">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="//cac:Person/cbc:FirstName | //cac:Person/cbc:FamilyName"/>

		<!--ASSERT -->

      <xsl:choose>
         <xsl:when test="string-length(translate(.,$vBasicLatinWithSupplement,'')) = 0 and string-length() &gt;= 1 and string-length() &lt;= 60"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="string-length(translate(.,$vBasicLatinWithSupplement,'')) = 0 and string-length() &gt;= 1 and string-length() &lt;= 60">
               <xsl:attribute name="flag">fatal</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-get-full-path"/>
               </xsl:attribute>
               <svrl:text>[SDI-T10-R017] - Il nome ed il cognome DEVONO essere composti ciascuno da 1 fino ad un massimo di 60 caratteri latini.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="@*|*" mode="M9"/>
   </xsl:template>
         
	<!--RULE -->

   <xsl:template match="//cac:Person/cbc:Title" priority="1017" mode="M9">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="//cac:Person/cbc:Title"/>

		<!--ASSERT -->

      <xsl:choose>
         <xsl:when test="string-length(translate(.,$vBasicLatin,'')) = 0 and string-length() &gt;= 2 and string-length() &lt;= 10"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="string-length(translate(.,$vBasicLatin,'')) = 0 and string-length() &gt;= 2 and string-length() &lt;= 10">
               <xsl:attribute name="flag">fatal</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-get-full-path"/>
               </xsl:attribute>
               <svrl:text>[SDI-T10-R018] - Il titolo onorifico DEVE essere composto da 2 fino ad un massimo di 10 caratteri ASCII alfanumerici.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="@*|*" mode="M9"/>
   </xsl:template>
   
	<!--RULE -->

   <xsl:template match="//cac:AccountingSupplierParty/cac:Party/cac:PartyName/cbc:Name | //cac:AccountingCustomerParty/cac:Party/cac:PartyName/cbc:Name | //cac:ServiceProviderParty/cac:Party/cac:PartyName/cbc:Name | //cac:TaxRepresentativeParty/cac:Party/cac:PartyName/cbc:Name" priority="1016" mode="M9">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="//cac:AccountingSupplierParty/cac:Party/cac:PartyName/cbc:Name | //cac:AccountingCustomerParty/cac:Party/cac:PartyName/cbc:Name | //cac:ServiceProviderParty/cac:Party/cac:PartyName/cbc:Name | //cac:TaxRepresentativeParty/cac:Party/cac:PartyName/cbc:Name"/>

		<!--ASSERT -->

      <xsl:choose>
         <xsl:when test="string-length(translate(.,$vBasicLatinWithSupplement,'')) = 0 and string-length() &gt;= 1 and string-length() &lt;= 80"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="string-length(translate(.,$vBasicLatinWithSupplement,'')) = 0 and string-length() &gt;= 1 and string-length() &lt;= 80">
               <xsl:attribute name="flag">fatal</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-get-full-path"/>
               </xsl:attribute>
               <svrl:text>[SDI-T10-R019] - La ditta, denominazione o ragione sociale DEVE essere composta da 1 fino ad un massimo di 80 caratteri latini.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="@*|*" mode="M9"/>
   </xsl:template>
   
	<!--RULE -->

   <xsl:template match="//cac:PartyIdentification/cbc:ID[@schemeID='EU:EORI']" priority="1015" mode="M9">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="//cac:PartyIdentification/cbc:ID[@schemeID='EU:EORI']"/>

		<!--ASSERT -->

      <xsl:choose>
         <xsl:when test="string-length(translate(.,$vBasicLatin,'')) = 0 and string-length() &gt;= 13 and string-length() &lt;= 17"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="string-length(translate(.,$vBasicLatin,'')) = 0 and string-length() &gt;= 13 and string-length() &lt;= 17">
               <xsl:attribute name="flag">fatal</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-get-full-path"/>
               </xsl:attribute>
               <svrl:text>[SDI-T10-R020] - Il codice EORI DEVE essere composto da 13 fino ad un massimo di 17 caratteri ASCII alfanumerici.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="@*|*" mode="M9"/>
   </xsl:template>
   
	<!--RULE -->

   <xsl:template match="//cac:PartyLegalEntity[cbc:CompanyID/@schemeID='ZZZ']/cac:CorporateRegistrationScheme/cbc:Name | //cac:PartyLegalEntity/cbc:CompanyID[@schemeID='ZZZ']" priority="1014" mode="M9">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="//cac:PartyLegalEntity[cbc:CompanyID/@schemeID='ZZZ']/cac:CorporateRegistrationScheme/cbc:Name | //cac:PartyLegalEntity/cbc:CompanyID[@schemeID='ZZZ']"/>

		<!--ASSERT -->

      <xsl:choose>
         <xsl:when test="string-length(translate(.,$vBasicLatinWithSupplement,'')) = 0 and string-length() &gt;= 1 and string-length() &lt;= 60"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="string-length(translate(.,$vBasicLatinWithSupplement,'')) = 0 and string-length() &gt;= 1 and string-length() &lt;= 60">
               <xsl:attribute name="flag">fatal</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-get-full-path"/>
               </xsl:attribute>
               <svrl:text>[SDI-T10-R021] - L'albo professionale ed il numero di iscrizione DEVONO essere composti ciascuno da 1 fino ad un massimo di 60 caratteri latini.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="@*|*" mode="M9"/>
   </xsl:template>
   
	<!--RULE -->

   <xsl:template match="//cac:PartyLegalEntity[cac:CorporateRegistrationScheme/cbc:Name='REA']/cbc:CompanyID[@schemeID='ZZZ']" priority="1013" mode="M9">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="//cac:PartyLegalEntity[cac:CorporateRegistrationScheme/cbc:Name='REA']/cbc:CompanyID[@schemeID='ZZZ']"/>

		<!--ASSERT -->

      <xsl:choose>
         <xsl:when test="string-length(translate(.,$vBasicLatin,'')) = 0 and string-length() &gt;= 1 and string-length() &lt;= 20"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="string-length(translate(.,$vBasicLatin,'')) = 0 and string-length() &gt;= 1 and string-length() &lt;= 20">
               <xsl:attribute name="flag">fatal</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-get-full-path"/>
               </xsl:attribute>
               <svrl:text>[SDI-T10-R022] - Il numero REA DEVE essere composto da 1 fino ad un massimo di 20 caratteri ASCII alfanumerici.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="@*|*" mode="M9"/>
   </xsl:template>
   
	<!--RULE -->

   <xsl:template match="//cac:PostalAddress/cbc:StreetName | //cac:PostalAddress/cbc:CityName" priority="1012" mode="M9">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="//cac:PostalAddress/cbc:StreetName | //cac:PostalAddress/cbc:CityName"/>

		<!--ASSERT -->

      <xsl:choose>
         <xsl:when test="string-length(translate(.,$vBasicLatinWithSupplement,'')) = 0 and string-length() &gt;= 1 and string-length() &lt;= 60"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="string-length(translate(.,$vBasicLatinWithSupplement,'')) = 0 and string-length() &gt;= 1 and string-length() &lt;= 60">
               <xsl:attribute name="flag">fatal</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-get-full-path"/>
               </xsl:attribute>
               <svrl:text>[SDI-T10-R023] - L'indirizzo postale ed il comune DEVONO essere composti ciascuno da 1 fino ad un massimo di 60 caratteri latini.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="@*|*" mode="M9"/>
   </xsl:template>
   
	<!--RULE -->

   <xsl:template match="//cac:AccountingSupplierParty/cbc:CustomerAssignedAccountID | //cac:InvoiceLine/cbc:AccountingCost" priority="1011" mode="M9">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="//cac:AccountingSupplierParty/cbc:CustomerAssignedAccountID | //cac:InvoiceLine/cbc:AccountingCost"/>

		<!--ASSERT -->

      <xsl:choose>
         <xsl:when test="string-length(translate(.,$vBasicLatin,'')) = 0 and string-length() &gt;= 1 and string-length() &lt;= 20"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="string-length(translate(.,$vBasicLatin,'')) = 0 and string-length() &gt;= 1 and string-length() &lt;= 20">
               <xsl:attribute name="flag">fatal</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-get-full-path"/>
               </xsl:attribute>
               <svrl:text>[SDI-T10-R024] - Il riferimento amministrazione DEVE essere composto da 1 fino ad un massimo di 20 caratteri ASCII alfanumerici.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="@*|*" mode="M9"/>
   </xsl:template>
   
	<!--RULE -->

   <xsl:template match="//cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory[cac:TaxScheme/cbc:ID='VAT']/cbc:TaxExemptionReason" priority="1010" mode="M9">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="//cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory[cac:TaxScheme/cbc:ID='VAT']/cbc:TaxExemptionReason"/>

		<!--ASSERT -->

      <xsl:choose>
         <xsl:when test="string-length(translate(.,$vBasicLatinWithSupplement,'')) = 0 and string-length() &gt;= 1 and string-length() &lt;= 100"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="string-length(translate(.,$vBasicLatinWithSupplement,'')) = 0 and string-length() &gt;= 1 and string-length() &lt;= 100">
               <xsl:attribute name="flag">fatal</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-get-full-path"/>
               </xsl:attribute>
               <svrl:text>[SDI-T10-R025] - La norma di riferimento DEVE essere composta da 1 fino ad un massimo di 100 caratteri latini.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="@*|*" mode="M9"/>
   </xsl:template>
   
	<!--RULE -->

   <xsl:template match="//cac:PayeeParty/cac:PartyName/cbc:Name" priority="1009" mode="M9">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="//cac:PayeeParty/cac:PartyName/cbc:Name"/>

		<!--ASSERT -->

      <xsl:choose>
         <xsl:when test="string-length(translate(.,$vBasicLatinWithSupplement,'')) = 0 and string-length() &gt;= 1 and string-length() &lt;= 200"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="string-length(translate(.,$vBasicLatinWithSupplement,'')) = 0 and string-length() &gt;= 1 and string-length() &lt;= 200">
               <xsl:attribute name="flag">fatal</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-get-full-path"/>
               </xsl:attribute>
               <svrl:text>[SDI-T10-R026] - Il beneficiario del pagamento DEVE essere composto da 1 fino ad un massimo di 200 caratteri latini.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="@*|*" mode="M9"/>
   </xsl:template>
   
	<!--RULE -->

   <xsl:template match="//cac:PaymentMeans/cbc:PaymentID" priority="1008" mode="M9">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="//cac:PaymentMeans/cbc:PaymentID"/>

		<!--ASSERT -->

      <xsl:choose>
         <xsl:when test="string-length(translate(.,$vBasicLatin,'')) = 0 and string-length() &gt;= 1 and string-length() &lt;= 60"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="string-length(translate(.,$vBasicLatin,'')) = 0 and string-length() &gt;= 1 and string-length() &lt;= 60">
               <xsl:attribute name="flag">fatal</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-get-full-path"/>
               </xsl:attribute>
               <svrl:text>[SDI-T10-R027] - Il codice pagamento DEVE essere composto da 1 fino ad un massimo di 60 caratteri ASCII alfanumerici.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="@*|*" mode="M9"/>
   </xsl:template>
   
	<!--RULE -->

   <xsl:template match="//ext:UBLExtensions/ext:UBLExtension[ext:ExtensionURI='urn:www.ubl-italia.org:spec:fatturapa:contributo_cassa']/ext:ExtensionContent/cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory/cac:TaxScheme/cbc:TaxTypeCode" priority="1007" mode="M9">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="//ext:UBLExtensions/ext:UBLExtension[ext:ExtensionURI='urn:www.ubl-italia.org:spec:fatturapa:contributo_cassa']/ext:ExtensionContent/cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory/cac:TaxScheme/cbc:TaxTypeCode"/>

		<!--ASSERT -->

      <xsl:choose>
         <xsl:when test="string-length(translate(.,concat('TC',$vDigits),'')) = 0 and string-length() = 4"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="string-length(translate(.,concat('TC',$vDigits),'')) = 0 and string-length() = 4">
               <xsl:attribute name="flag">fatal</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-get-full-path"/>
               </xsl:attribute>
               <svrl:text>[SDI-T10-R028] - Il tipo cassa professionale DEVE essere compresa fra i valori 'TC01' e 'TC22'.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="@*|*" mode="M9"/>
   </xsl:template>
   
	<!--RULE -->

   <xsl:template match="//cac:AccountingSupplierParty/cac:Party/cac:PartyTaxScheme[cbc:CompanyID/@schemeID='IT:VAT']/cac:TaxScheme/cbc:TaxTypeCode" priority="1006" mode="M9">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="//cac:AccountingSupplierParty/cac:Party/cac:PartyTaxScheme[cbc:CompanyID/@schemeID='IT:VAT']/cac:TaxScheme/cbc:TaxTypeCode"/>

		<!--ASSERT -->

      <xsl:choose>
         <xsl:when test="string-length(translate(.,concat('RF',$vDigits),'')) = 0 and string-length() = 4"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="string-length(translate(.,concat('RF',$vDigits),'')) = 0 and string-length() = 4">
               <xsl:attribute name="flag">fatal</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-get-full-path"/>
               </xsl:attribute>
               <svrl:text>[SDI-T10-R029] - Il regime fiscale DEVE essere compreso fra i valori 'RF01' e 'RF19'.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="@*|*" mode="M9"/>
   </xsl:template>

	<!--RULE -->

   <xsl:template match="//cac:PaymentMeans[not(cbc:PaymentChannelCode) or cbc:PaymentChannelCode='IBAN']/cac:PayeeFinancialAccount/cbc:ID[@schemeID='IBAN']" priority="1005" mode="M9">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="//cac:PaymentMeans[not(cbc:PaymentChannelCode) or cbc:PaymentChannelCode='IBAN']/cac:PayeeFinancialAccount/cbc:ID[@schemeID='IBAN']"/>

		<!--ASSERT -->

      <xsl:choose>
         <xsl:when test="string-length(translate(substring(.,1,2),$vAlpha,'')) = 0 and string-length(translate(substring(.,3,2),$vDigits,'')) = 0 and string-length(translate(substring(.,5),$vAlphaNumeric,'')) = 0 and (string-length() &gt;= 11 or string-length() &lt;= 30)"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="string-length(translate(substring(.,1,2),$vAlpha,'')) = 0 and string-length(translate(substring(.,3,2),$vDigits,'')) = 0 and string-length(translate(substring(.,5),$vAlphaNumeric,'')) = 0 and (string-length() &gt;= 11 or string-length() &lt;= 30)">
               <xsl:attribute name="flag">fatal</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-get-full-path"/>
               </xsl:attribute>
               <svrl:text>[SDI-T10-R032] - Il Codice IBAN deve rispettare la seguente sintassi '[a-zA-Z]{2}[0-9]{2}[a-zA-Z0-9]{11,30}'.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="@*|*" mode="M9"/>
   </xsl:template>
   
	<!--RULE -->

   <xsl:template match="//cac:PayeeFinancialAccount/cac:FinancialInstitutionBranch/cac:FinancialInstitution/cbc:ID[not(@schemeID) or @schemeID='BIC']" priority="1004" mode="M9">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="//cac:PayeeFinancialAccount/cac:FinancialInstitutionBranch/cac:FinancialInstitution/cbc:ID[not(@schemeID) or @schemeID='BIC']"/>

		<!--ASSERT -->

      <xsl:choose>
         <xsl:when test="string-length(translate(substring(.,1,6),$vUpper,'')) = 0 and string-length(translate(substring(.,7,2),concat($vUpper, $vDigits),'')) = 0 and (string-length() = 8 or string-length() = 11)"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="string-length(translate(substring(.,1,6),$vUpper,'')) = 0 and string-length(translate(substring(.,7,2),concat($vUpper, $vDigits),'')) = 0 and (string-length() = 8 or string-length() = 11)">
               <xsl:attribute name="flag">fatal</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-get-full-path"/>
               </xsl:attribute>
               <svrl:text>[SDI-T10-R033] - Il Codice BIC deve rispettare la seguente sintassi '[A-Z]{6}[A-Z2-9][A-NP-Z0-9]([A-Z0-9]{3}){0,1}'.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="@*|*" mode="M9"/>
   </xsl:template>
   
	<!--RULE -->

   <xsl:template match="//cac:PartyTaxScheme/cbc:CompanyID[@schemeID = 'IT:VAT'] | //cac:Party/cbc:EndpointID[@schemeID = 'IT:VAT']" priority="1003" mode="M9">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="//cac:PartyTaxScheme/cbc:CompanyID[@schemeID = 'IT:VAT'] | //cac:Party/cbc:EndpointID[@schemeID = 'IT:VAT']"/>

		<!--ASSERT -->

      <xsl:choose>
         <xsl:when test="string-length(translate(substring(.,1,2),$vAlpha,'')) = 0 and string-length(translate(substring(.,3),$vDigits,'')) = 0 and string-length() = 13"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="string-length(translate(substring(.,1,2),$vAlpha,'')) = 0 and string-length(translate(substring(.,3),$vDigits,'')) = 0 and string-length() = 13">
               <xsl:attribute name="flag">fatal</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-get-full-path"/>
               </xsl:attribute>
               <svrl:text>[SDI-T10-R034] - Il numero di Partita IVA deve essere composto dal codice paese 'IT' e 11 caratteri numerici.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="@*|*" mode="M9"/>
   </xsl:template>   

	<!--RULE -->

   <xsl:template match="//cac:PartyTaxScheme/cbc:CompanyID[@schemeID and @schemeID != 'IT:CF']" priority="1002" mode="M9">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="//cac:PartyTaxScheme/cbc:CompanyID[@schemeID and @schemeID != 'IT:CF']"/>

		<!--ASSERT -->

      <xsl:choose>
         <xsl:when test="string-length(translate(substring(.,1,2),$vAlpha,'')) = 0 and string-length(translate(substring(.,3),$vAlphaNumeric,'')) = 0 and string-length() &gt;= 3 and string-length() &lt;= 30"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="string-length(translate(substring(.,1,2),$vAlpha,'')) = 0 and string-length(translate(substring(.,3),$vAlphaNumeric,'')) = 0 and string-length() &gt;= 3 and string-length() &lt;= 30">
               <xsl:attribute name="flag">fatal</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-get-full-path"/>
               </xsl:attribute>
               <svrl:text>[SDI-T10-R035] - L'identificatore VAT deve iniziare con il codice paese ISO2 seguito da un massimo di 28 caratteri alfanumerici.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="@*|*" mode="M9"/>
   </xsl:template>
   
	<!--RULE -->

   <xsl:template match="//cac:WithholdingTaxTotal/cac:TaxSubtotal/cac:TaxCategory/cac:TaxScheme/cbc:TaxTypeCode" priority="1001" mode="M9">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="//cac:WithholdingTaxTotal/cac:TaxSubtotal/cac:TaxCategory/cac:TaxScheme/cbc:TaxTypeCode"/>

		<!--ASSERT -->

      <xsl:choose>
         <xsl:when test="not(contains(normalize-space(.),' ')) and contains($vCausalePagamentoCodeList, concat(' ',normalize-space(.),' '))"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(contains(normalize-space(.),' ')) and contains($vCausalePagamentoCodeList, concat(' ',normalize-space(.),' '))">
               <xsl:attribute name="flag">fatal</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-get-full-path"/>
               </xsl:attribute>
               <svrl:text>[SDI-T10-R036] - Il codice motivo della ritenuta DEVE essere valorizzato con le causali pagamento del modello 770S.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="@*|*" mode="M9"/>
   </xsl:template>  
   
	<!--RULE -->

   <xsl:template match="//cac:PartyTaxScheme/cbc:CompanyID[@schemeID='IT:CF' and ../../cac:PartyIdentification/cbc:ID!='CODDEST:0000000' and not(../../cac:Person[cbc:ID/@schemeID='IT:CF'])]" priority="1000" mode="M9">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="//cac:PartyTaxScheme/cbc:CompanyID[@schemeID='IT:CF' and ../../cac:PartyIdentification/cbc:ID!='CODDEST:0000000' and not(../../cac:Person[cbc:ID/@schemeID='IT:CF'])]"/>

		<!--ASSERT -->

      <xsl:choose>
         <xsl:when test="string-length(translate(.,$vBasicLatin,'')) = 0 and string-length() &gt;= 11 and string-length() &lt;= 13"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="string-length(translate(.,$vBasicLatin,'')) = 0 and string-length() &gt;= 11 and string-length() &lt;= 13">
               <xsl:attribute name="flag">fatal</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-get-full-path"/>
               </xsl:attribute>
               <svrl:text>[SDI-T10-R037] - Il codice fiscale di una persona giuridica DEVE essere composto da 13 caratteri alfanumerici o da 11 se si omette il codice paese ISO 3166-1 alpha-2 iniziale.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="@*|*" mode="M9"/>
   </xsl:template>   
   
	<!--RULE -->

   <xsl:template match="//cac:PaymentMeans[not(cbc:PaymentChannelCode) or cbc:PaymentChannelCode='LOCAL']/cac:PayeeFinancialAccount" priority="1033" mode="M9">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="//cac:PaymentMeans[not(cbc:PaymentChannelCode) or cbc:PaymentChannelCode='LOCAL']/cac:PayeeFinancialAccount"/>

		<!--ASSERT -->

      <xsl:choose>
         <xsl:when test="not(cbc:ID[@schemeID='LOCAL'])"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cbc:ID[@schemeID='LOCAL'])">
               <xsl:attribute name="flag">fatal</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-get-full-path"/>
               </xsl:attribute>
               <svrl:text>[SDI-T10-R038] - Nei pagamenti effettuati su canale LOCAL, e quindi con modalità di pagamento nazionali, non è al momento supportato specificare l'ID del conto relativo. Includere il numero di conto insieme alla denominazione della filiale o usare il canale IBAN ove possibile.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="@*|*" mode="M9"/>
   </xsl:template>
   
	<!--RULE -->

   <xsl:template match="/*/cbc:Note" priority="1034" mode="M9">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="/*/cbc:Note"/>

		<!--ASSERT -->

      <xsl:choose>
         <xsl:when test="string-length(translate(.,$vBasicLatinWithSupplement,'')) = 0 and string-length() &gt;= 1 and string-length() &lt;= 200"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="string-length(translate(.,$vBasicLatinWithSupplement,'')) = 0 and string-length() &gt;= 1 and string-length() &lt;= 200">
               <xsl:attribute name="flag">fatal</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-get-full-path"/>
               </xsl:attribute>
               <svrl:text>[SDI-T10-R039] - La causale DEVE essere composta da 1 fino ad un massimo di 200 caratteri latini.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="@*|*" mode="M9"/>
   </xsl:template>
   
	<!--RULE -->

   <xsl:template match="//cac:PayeeFinancialAccount/cac:FinancialInstitutionBranch/cac:FinancialInstitution/cbc:Name" priority="1035" mode="M9">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="//cac:PayeeFinancialAccount/cac:FinancialInstitutionBranch/cac:FinancialInstitution/cbc:Name"/>

		<!--ASSERT -->

      <xsl:choose>
         <xsl:when test="string-length(translate(.,$vBasicLatinWithSupplement,'')) = 0 and string-length() &gt;= 1 and string-length() &lt;= 80"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="string-length(translate(.,$vBasicLatinWithSupplement,'')) = 0 and string-length() &gt;= 1 and string-length() &lt;= 80">
               <xsl:attribute name="flag">fatal</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-get-full-path"/>
               </xsl:attribute>
               <svrl:text>[SDI-T10-R040] - La denominazione dell'istituto finanziario DEVE essere composta da 1 fino ad un massimo di 80 caratteri latini.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="@*|*" mode="M9"/>
   </xsl:template>
   
	<!--RULE -->

   <xsl:template match="//ext:UBLExtensions/ext:UBLExtension[ext:ExtensionURI='urn:www.ubl-italia.org:spec:fatturapa:esigibilita_iva']/ext:ExtensionContent/cbc:TaxTypeCode" priority="1036" mode="M9">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="//ext:UBLExtensions/ext:UBLExtension[ext:ExtensionURI='urn:www.ubl-italia.org:spec:fatturapa:esigibilita_iva']/ext:ExtensionContent/cbc:TaxTypeCode"/>

		<!--ASSERT -->

      <xsl:choose>
         <xsl:when test="not(contains(normalize-space(.),' ')) and contains($vEsigibilitaIVACodeList, concat(' ',normalize-space(.),' '))"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(contains(normalize-space(.),' ')) and contains($vEsigibilitaIVACodeList, concat(' ',normalize-space(.),' '))">
               <xsl:attribute name="flag">fatal</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-get-full-path"/>
               </xsl:attribute>
               <svrl:text>[SDI-T10-R041] - Il codice del tipo di esigibilità IVA DEVE esse valorizzato con uno dei seguenti valori: D (differita), I (Immediata), S (scissione dei pagamenti).</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="@*|*" mode="M9"/>
   </xsl:template>
   
	<!--RULE -->

   <xsl:template match="//cac:OrderReference | //cac:ContractDocumentReference | //cac:OriginatorDocumentReference | //cac:DespatchDocumentReference | //cac:ReceiptDocumentReference | //cac:InvoiceDocumentReference" priority="1037" mode="M9">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="//cac:OrderReference | //cac:ContractDocumentReference | //cac:OriginatorDocumentReference | //cac:DespatchDocumentReference | //cac:ReceiptDocumentReference | //cac:InvoiceDocumentReference"/>

		<!--ASSERT -->

      <xsl:choose>
         <xsl:when test="string-length(translate(cbc:ID,$vBasicLatin,'')) = 0 and string-length(cbc:ID) &gt;= 1 and string-length(cbc:ID) &lt;= 20"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="string-length(translate(cbc:ID,$vBasicLatin,'')) = 0 and string-length(cbc:ID) &gt;= 1 and string-length(cbc:ID) &lt;= 20">
               <xsl:attribute name="flag">fatal</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-get-full-path"/>
               </xsl:attribute>
               <svrl:text>[SDI-T10-R042] - L'identificativo dell'Ordine, Contratto, Convenzione, DDT, Ricezione e delle Fatture allegate DEVE essere composto da 1 fino ad un massimo di 20 caratteri ASCII alfanumerici.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="@*|*" mode="M9"/>
   </xsl:template>   
   <xsl:template match="text()" priority="-1" mode="M9"/>
   <xsl:template match="@*|node()" priority="-2" mode="M9">
      <xsl:apply-templates select="@*|*" mode="M9"/>
   </xsl:template>

<!--PATTERN ITNAT-INT-T10-->
   
   	  <!--RULE -->
   <xsl:template match="//cbc:EndpointID" priority="1020" mode="M10">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="//cbc:EndpointID"/>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="(@schemeID='IT:IPA' and matches(.,'^[a-zA-Z0-9]{6,7}$')) or @schemeID!='IT:IPA'"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="(@schemeID='IT:IPA' and matches(.,'^[a-zA-Z0-9]{6,7}$')) or @schemeID!='IT:IPA'">
               <xsl:attribute name="id">INT-T10-R026</xsl:attribute>
               <xsl:attribute name="flag">fatal</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>[INT-T10-R026] - Se l'identificatore di endpoint si basa sullo schema di identificatori IT:IPA, questo dovrà seguire la sintassi [A-Z0-9]{6,7}.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
	  
		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="(@schemeID='IT:VAT' and matches(.,'^(IT)?[0-9]{11}$')) or @schemeID!='IT:VAT'"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="(@schemeID='IT:VAT' and matches(.,'^(IT)?[0-9]{11}$')) or @schemeID!='IT:VAT'">
               <xsl:attribute name="id">INT-T10-R027</xsl:attribute>
               <xsl:attribute name="flag">fatal</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>[INT-T10-R027] - Se l'identificatore di endpoint si basa sullo schema di identificatori IT:VAT, questo dovrà seguire la sintassi (IT)?[0-9]{11}.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
	  
		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="(@schemeID='IT:CF' and matches(.,'^[0-9]{11}$|^[A-Z]{6}\d{2}[ABCDEHLMPRST]{1}\d{2}[A-Z]{1}\d{3}[A-Z]{1}$')) or @schemeID!='IT:CF'"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="(@schemeID='IT:CF' and matches(.,'^[0-9]{11}$|^[A-Z]{6}\d{2}[ABCDEHLMPRST]{1}\d{2}[A-Z]{1}\d{3}[A-Z]{1}$')) or @schemeID!='IT:CF'">
               <xsl:attribute name="id">INT-T10-R028</xsl:attribute>
               <xsl:attribute name="flag">fatal</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>[INT-T10-R028] - Se l'identificatore di endpoint si basa sullo schema di identificatori IT:CF, questo dovrà seguire la sintassi [0-9]{11} per le persone giuridiche e la sintassi [A-Z]{6}\d{2}[ABCDEHLMPRST]{1}\d{2}[A-Z]{1}\d{3}[A-Z]{1} per quelle fisiche.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="@*|*" mode="M10"/>
   </xsl:template>

	<!--RULE -->

   <xsl:template match="//cac:WithholdingTaxTotal/cac:TaxSubtotal[1]" priority="1019" mode="M10">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="//cac:WithholdingTaxTotal/cac:TaxSubtotal[1]"/>

		<!--ASSERT -->

      <xsl:choose>
         <xsl:when test="cac:TaxCategory/cac:TaxScheme/cbc:ID = 'SWT'"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="cac:TaxCategory/cac:TaxScheme/cbc:ID = 'SWT'">
               <xsl:attribute name="flag">fatal</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-get-full-path"/>
               </xsl:attribute>
               <svrl:text>[INT-T10-R001] - Se il cedente/prestatore è italiano, nei casi in cui sia prevista la ritenuta di acconto, il valore dell'identificatore dello schema di imposta deve essere 'SWT' (Shifted Wage Tax).</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="@*|*" mode="M10"/>
   </xsl:template>
   
	<!--RULE -->

   <xsl:template match="//ext:UBLExtensions/ext:UBLExtension[ext:ExtensionURI='urn:www.ubl-italia.org:spec:fatturapa:contributo_cassa']/ext:ExtensionContent/cac:TaxTotal/cac:TaxSubtotal[cac:TaxCategory/cac:TaxScheme/cbc:ID = 'SSS']" priority="1018" mode="M10">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="//ext:UBLExtensions/ext:UBLExtension[ext:ExtensionURI='urn:www.ubl-italia.org:spec:fatturapa:contributo_cassa']/ext:ExtensionContent/cac:TaxTotal/cac:TaxSubtotal[cac:TaxCategory/cac:TaxScheme/cbc:ID = 'SSS']"/>

		<!--ASSERT -->

      <xsl:choose>
         <xsl:when test="cbc:TaxableAmount and cac:TaxCategory/cbc:Percent and cbc:TaxAmount and cac:TaxCategory/cac:TaxScheme/cbc:TaxTypeCode[@listID='SDICLTC']"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="cbc:TaxableAmount and cac:TaxCategory/cbc:Percent and cbc:TaxAmount and cac:TaxCategory/cac:TaxScheme/cbc:TaxTypeCode[@listID='SDICLTC']">
               <xsl:attribute name="flag">fatal</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-get-full-path"/>
               </xsl:attribute>
               <svrl:text>[INT-T10-R002] - Se il cedente/prestatore è italiano, nei casi in cui sia iscritto ad una Cassa Previdenziale, DEVE essere specificato, l’imponibile, l’aliquota, l’importo e la tipologia del contributo, ponendo l'identificatore dello schema di imposta = 'SSS' (Shifted Social Securities).</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="@*|*" mode="M10"/>
   </xsl:template>

	<!--RULE -->

   <xsl:template match="//ext:UBLExtensions" priority="1017" mode="M10">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="//ext:UBLExtensions"/>

		<!--ASSERT -->

      <xsl:choose>
         <xsl:when test="count(ext:UBLExtension[not(ext:ExtensionURI)]) = 0"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="count(ext:UBLExtension[not(ext:ExtensionURI)]) = 0">
               <xsl:attribute name="flag">fatal</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-get-full-path"/>
               </xsl:attribute>
               <svrl:text>[INT-T10-R003] - Nelle estensioni speciali l'URI dell'estensione è obbligatorio.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
	  
		<!--ASSERT -->

      <xsl:choose>
         <xsl:when test="count(ext:UBLExtension[starts-with(ext:ExtensionURI ,'urn:www.ubl-italia.org:spec:fatturapa:')]) = count(ext:UBLExtension[starts-with(ext:ExtensionURI ,'urn:www.ubl-italia.org:spec:fatturapa:') and not(ext:ExtensionURI = preceding-sibling::ext:UBLExtension/ext:ExtensionURI)])">
            <xsl:apply-templates select="." mode="schematron-get-full-path"/>
         </xsl:when>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="count(ext:UBLExtension[starts-with(ext:ExtensionURI ,'urn:www.ubl-italia.org:spec:fatturapa:')]) = count(ext:UBLExtension[starts-with(ext:ExtensionURI ,'urn:www.ubl-italia.org:spec:fatturapa:') and not(ext:ExtensionURI = preceding-sibling::ext:UBLExtension/ext:ExtensionURI)])">
               <xsl:attribute name="flag">fatal</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-get-full-path"/>
               </xsl:attribute>
               <svrl:text>[INT-T10-R021] - Ogni estensione può essere usata solo una volta indicando un ExtensionURI univoco.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      
		<!--ASSERT -->

      <xsl:choose>
         <xsl:when test="ext:UBLExtension[not(starts-with(ext:ExtensionURI,'urn:www.ubl-italia.org:spec:fatturapa:')) or starts-with(ext:ExtensionURI,'urn:www.ubl-italia.org:spec:fatturapa:xref:') or (starts-with(ext:ExtensionURI, 'urn:www.ubl-italia.org:spec:fatturapa:bollo') and ext:ExtensionContent/cbc:TaxAmount) or (starts-with(ext:ExtensionURI, 'urn:www.ubl-italia.org:spec:fatturapa:contributo_cassa') and ext:ExtensionContent/cac:TaxTotal) or (starts-with(ext:ExtensionURI, 'urn:www.ubl-italia.org:spec:fatturapa:contributo_cassa:ritenuta') and ext:ExtensionContent/cbc:TaxEvidenceIndicator) or (starts-with(ext:ExtensionURI, 'urn:www.ubl-italia.org:spec:fatturapa:contributo_cassa:aliquota_iva') and ext:ExtensionContent/cbc:Percent) or (starts-with(ext:ExtensionURI, 'urn:www.ubl-italia.org:spec:fatturapa:esigibilita_iva') and ext:ExtensionContent/cbc:TaxTypeCode) or (starts-with(ext:ExtensionURI, 'urn:www.ubl-italia.org:spec:fatturapa:parcella') and ext:ExtensionContent/cbc:Description) or (starts-with(ext:ExtensionURI, 'urn:www.ubl-italia.org:spec:fatturapa:modalita_pagamento') and ext:ExtensionContent/cbc:TypeCode) or (starts-with(ext:ExtensionURI, 'urn:www.ubl-italia.org:spec:fatturapa:ritenuta') and ext:ExtensionContent/cac:WithholdingTaxTotal)]"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="ext:UBLExtension[not(starts-with(ext:ExtensionURI,'urn:www.ubl-italia.org:spec:fatturapa:')) or starts-with(ext:ExtensionURI,'urn:www.ubl-italia.org:spec:fatturapa:xref:') or (starts-with(ext:ExtensionURI, 'urn:www.ubl-italia.org:spec:fatturapa:bollo') and ext:ExtensionContent/cbc:TaxAmount) or (starts-with(ext:ExtensionURI, 'urn:www.ubl-italia.org:spec:fatturapa:contributo_cassa') and ext:ExtensionContent/cac:TaxTotal) or (starts-with(ext:ExtensionURI, 'urn:www.ubl-italia.org:spec:fatturapa:contributo_cassa:ritenuta') and ext:ExtensionContent/cbc:TaxEvidenceIndicator) or (starts-with(ext:ExtensionURI, 'urn:www.ubl-italia.org:spec:fatturapa:contributo_cassa:aliquota_iva') and ext:ExtensionContent/cbc:Percent) or (starts-with(ext:ExtensionURI, 'urn:www.ubl-italia.org:spec:fatturapa:esigibilita_iva') and ext:ExtensionContent/cbc:TaxTypeCode) or (starts-with(ext:ExtensionURI, 'urn:www.ubl-italia.org:spec:fatturapa:parcella') and ext:ExtensionContent/cbc:Description) or (starts-with(ext:ExtensionURI, 'urn:www.ubl-italia.org:spec:fatturapa:modalita_pagamento') and ext:ExtensionContent/cbc:TypeCode) or (starts-with(ext:ExtensionURI, 'urn:www.ubl-italia.org:spec:fatturapa:ritenuta') and ext:ExtensionContent/cac:WithholdingTaxTotal)]">
               <xsl:attribute name="flag">fatal</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-get-full-path"/>
               </xsl:attribute>
               <svrl:text>[INT-T10-R023] - In ogni estensione speciale l'URI DEVE corrispondere ad un contenuto predefinito come da specifica. Verificare il nome dell'elemento fornito come contenuto dell'estensione UBL.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>	  
      <xsl:apply-templates select="@*|*" mode="M10"/>
   </xsl:template>
   
	<!--RULE -->

   <xsl:template match="//cac:InvoiceLine" priority="1016" mode="M10">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="//cac:InvoiceLine"/>

		<!--ASSERT -->

      <xsl:choose>
         <xsl:when test="cac:Item/cac:ClassifiedTaxCategory/cbc:ID != 'O' or //ext:UBLExtensions/ext:UBLExtension[ext:ExtensionURI = 'urn:www.ubl-italia.org:spec:fatturapa:xref:natura::O']/ext:ExtensionContent/cr:XCode or //ext:UBLExtensions/ext:UBLExtension[ext:ExtensionURI = concat('urn:www.ubl-italia.org:spec:fatturapa:xref:natura::', 1 + count(current()/preceding-sibling::cac:InvoiceLine))]/ext:ExtensionContent/cr:XCode"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="cac:Item/cac:ClassifiedTaxCategory/cbc:ID != 'O' or //ext:UBLExtensions/ext:UBLExtension[ext:ExtensionURI = 'urn:www.ubl-italia.org:spec:fatturapa:xref:natura::O']/ext:ExtensionContent/cr:XCode or //ext:UBLExtensions/ext:UBLExtension[ext:ExtensionURI = concat('urn:www.ubl-italia.org:spec:fatturapa:xref:natura::', 1 + count(current()/preceding-sibling::cac:InvoiceLine))]/ext:ExtensionContent/cr:XCode">
               <xsl:attribute name="flag">fatal</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-get-full-path"/>
               </xsl:attribute>
               <svrl:text>[INT-T10-R004] - L'identificativo del ClassifiedTaxCategory (natura dell'imposta) a livello di riga, per i servizi fuori campo IVA indicati con il valore 'O' della codifica UN/ECE 5305, DEVE essere corredato dal codice Natura corrispondente nel formato FatturaPA mediante l'uso di una estensione UBL. L'estensione deve indicare il valore N1 (escluse ex art. 15) o N2 (non soggette).</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		<!--ASSERT -->

      <xsl:choose>
         <xsl:when test="cac:Item/cac:ClassifiedTaxCategory/cbc:ID != 'Z' or //ext:UBLExtensions/ext:UBLExtension[ext:ExtensionURI = 'urn:www.ubl-italia.org:spec:fatturapa:xref:natura::Z']/ext:ExtensionContent/cr:XCode or //ext:UBLExtensions/ext:UBLExtension[ext:ExtensionURI = concat('urn:www.ubl-italia.org:spec:fatturapa:xref:natura::', 1 + count(current()/preceding-sibling::cac:InvoiceLine))]/ext:ExtensionContent/cr:XCode"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="cac:Item/cac:ClassifiedTaxCategory/cbc:ID != 'Z' or //ext:UBLExtensions/ext:UBLExtension[ext:ExtensionURI = 'urn:www.ubl-italia.org:spec:fatturapa:xref:natura::Z']/ext:ExtensionContent/cr:XCode or //ext:UBLExtensions/ext:UBLExtension[ext:ExtensionURI = concat('urn:www.ubl-italia.org:spec:fatturapa:xref:natura::', 1 + count(current()/preceding-sibling::cac:InvoiceLine))]/ext:ExtensionContent/cr:XCode">
               <xsl:attribute name="flag">fatal</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-get-full-path"/>
               </xsl:attribute>
               <svrl:text>[INT-T10-R024] - L'identificativo del ClassifiedTaxCategory (natura dell'imposta) a livello di riga, per le operazioni Zero Rated indicate con il valore 'Z' della codifica UN/ECE 5305, DEVE essere corredato dal codice corrispondente nel formato FatturaPA mediante l'uso di una estensione UBL. L'estensione deve indicare il valore N3 (Non Imponibile) o N7 (IVA assolta in altro stato UE (vendite a distanza ex art. 40 commi 3 e 4 e art. 41 comma 1 lett. b, DL 331/93; prestazione di servizi di telecomunicazioni, tele-radiodiffusione ed elettronici ex art. 7-sexies lett. f, g, DPR 633/72 e art. 74-sexies, DPR 633/72)).</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
	  
		<!--ASSERT -->

      <xsl:choose>
         <xsl:when test="(cac:DocumentReference[cbc:DocumentType='CommessaConvenzione' or cbc:DocumentType='CIG' or cbc:DocumentType='CUP'] and (cac:OrderLineReference/cac:OrderReference/cbc:ID or /*/cac:OrderReference/cbc:ID or /*/cac:ContractDocumentReference/cbc:ID)) or not(cac:DocumentReference[cbc:DocumentType='CommessaConvenzione' or cbc:DocumentType='CIG' or cbc:DocumentType='CUP'])"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="(cac:DocumentReference[cbc:DocumentType='CommessaConvenzione' or cbc:DocumentType='CIG' or cbc:DocumentType='CUP'] and (cac:OrderLineReference/cac:OrderReference/cbc:ID or /*/cac:OrderReference/cbc:ID or /*/cac:ContractDocumentReference/cbc:ID)) or not(cac:DocumentReference[cbc:DocumentType='CommessaConvenzione' or cbc:DocumentType='CIG' or cbc:DocumentType='CUP'])">
               <xsl:attribute name="flag">fatal</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-get-full-path"/>
               </xsl:attribute>
               <svrl:text>[INT-T10-R019] - Per specificare CIG e CUP a livello di riga è necessario fornire anche il riferimento all'ordine sulla riga o all'ordine/contratto in testata.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
	  
		<!--ASSERT -->

      <xsl:choose>
         <xsl:when test="not(cac:Item/cbc:Description)"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:Item/cbc:Description)">
               <xsl:attribute name="flag">warning</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-get-full-path"/>
               </xsl:attribute>
               <svrl:text>[INT-T10-R022] - L'elemento cbc:Description non è più usato per fornire la descrizione completa dell'articolo / servizio. Al suo posto usare l'elemento cbc:Name per un massimo di 1000 caratteri latini.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="@*|*" mode="M10"/>
   </xsl:template>

	<!--RULE -->

   <xsl:template match="//cac:TaxTotal/cac:TaxSubtotal" priority="1015" mode="M10">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="//cac:TaxTotal/cac:TaxSubtotal"/>

		<!--ASSERT -->

      <xsl:choose>
         <xsl:when test="cac:TaxCategory/cbc:ID != 'O' or //ext:UBLExtensions/ext:UBLExtension[ext:ExtensionURI = 'urn:www.ubl-italia.org:spec:fatturapa:xref:natura::O']/ext:ExtensionContent/cr:XCode or //ext:UBLExtensions/ext:UBLExtension[ext:ExtensionURI = concat('urn:www.ubl-italia.org:spec:fatturapa:xref:natura_riepilogo::', 1 + count(current()/preceding-sibling::cac:TaxSubtotal))]/ext:ExtensionContent/cr:XCode"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="cac:TaxCategory/cbc:ID != 'O' or //ext:UBLExtensions/ext:UBLExtension[ext:ExtensionURI = 'urn:www.ubl-italia.org:spec:fatturapa:xref:natura::O']/ext:ExtensionContent/cr:XCode or //ext:UBLExtensions/ext:UBLExtension[ext:ExtensionURI = concat('urn:www.ubl-italia.org:spec:fatturapa:xref:natura_riepilogo::', 1 + count(current()/preceding-sibling::cac:TaxSubtotal))]/ext:ExtensionContent/cr:XCode">
               <xsl:attribute name="flag">fatal</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-get-full-path"/>
               </xsl:attribute>
               <svrl:text>[INT-T10-R005] - L'identificativo del TaxCategory (natura dell'imposta) nel riepilogo IVA, per i servizi fuori campo IVA indicati con il valore 'O' della codifica UN/ECE 5305, DEVE essere corredato dal  codice Natura corrispondente nel formato FatturaPA mediante l'uso di una estensione UBL. L'estensione deve indicare il valore N1 (escluse ex art. 15) o N2 (non soggette).</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		<!--ASSERT -->

      <xsl:choose>
         <xsl:when test="cac:TaxCategory/cbc:ID != 'Z' or //ext:UBLExtensions/ext:UBLExtension[ext:ExtensionURI = 'urn:www.ubl-italia.org:spec:fatturapa:xref:natura::Z']/ext:ExtensionContent/cr:XCode or //ext:UBLExtensions/ext:UBLExtension[ext:ExtensionURI = concat('urn:www.ubl-italia.org:spec:fatturapa:xref:natura_riepilogo::', 1 + count(current()/preceding-sibling::cac:TaxSubtotal))]/ext:ExtensionContent/cr:XCode"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="cac:TaxCategory/cbc:ID != 'Z' or //ext:UBLExtensions/ext:UBLExtension[ext:ExtensionURI = 'urn:www.ubl-italia.org:spec:fatturapa:xref:natura::Z']/ext:ExtensionContent/cr:XCode or //ext:UBLExtensions/ext:UBLExtension[ext:ExtensionURI = concat('urn:www.ubl-italia.org:spec:fatturapa:xref:natura_riepilogo::', 1 + count(current()/preceding-sibling::cac:TaxSubtotal))]/ext:ExtensionContent/cr:XCode">
               <xsl:attribute name="flag">fatal</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-get-full-path"/>
               </xsl:attribute>
               <svrl:text>[INT-T10-R025] - L'identificativo del TaxCategory (natura dell'imposta) nel riepilogo IVA, per le operazioni Zero Rated indicate con il valore 'Z' della codifica UN/ECE 5305, DEVE essere corredato dal codice corrispondente nel formato FatturaPA mediante l'uso di una estensione UBL. L'estensione deve indicare il valore N3 (Non Imponibile) o N7 (IVA assolta in altro stato UE (vendite a distanza ex art. 40 commi 3 e 4 e art. 41 comma 1 lett. b, DL 331/93; prestazione di servizi di telecomunicazioni, tele-radiodiffusione ed elettronici ex art. 7-sexies lett. f, g, DPR 633/72 e art. 74-sexies, DPR 633/72)).</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="@*|*" mode="M10"/>
   </xsl:template>

	<!--RULE -->

   <xsl:template match="cbc:InvoiceTypeCode" priority="1013" mode="M10">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="cbc:InvoiceTypeCode"/>

		<!--ASSERT -->

      <xsl:choose>
         <xsl:when test="( ( not(contains(normalize-space(.),' ')) and contains($vInvoiceTypeCodeList, concat(' ',normalize-space(.),' ') ) ) )"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="( ( not(contains(normalize-space(.),' ')) and contains($vInvoiceTypeCodeList, concat(' ',normalize-space(.),' ') ) ) )">
               <xsl:attribute name="flag">fatal</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-get-full-path"/>
               </xsl:attribute>
               <svrl:text>[INT-T10-R020] - Il codice del tipo di fattura inviata DEVE essere codificato in base alla lista UN/ECE 1001 Invoice Subset di UBL Italia.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>            
      <xsl:apply-templates select="@*|*" mode="M10"/>
   </xsl:template>

	<!--RULE -->

   <xsl:template match="/*/cac:AdditionalDocumentReference[cbc:DocumentType='CommessaConvenzione' or cbc:DocumentType='CIG' or cbc:DocumentType='CUP']" priority="1012" mode="M10">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="/*/cac:AdditionalDocumentReference[cbc:DocumentType='CommessaConvenzione' or cbc:DocumentType='CIG' or cbc:DocumentType='CUP']"/>

		<!--ASSERT -->

      <xsl:choose>
         <xsl:when test="/*/cac:OrderReference/cbc:ID or /*/cac:ContractDocumentReference/cbc:ID or //cac:OrderLineReference/cac:OrderReference/cbc:ID"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="/*/cac:OrderReference/cbc:ID or /*/cac:ContractDocumentReference/cbc:ID or //cac:OrderLineReference/cac:OrderReference/cbc:ID">
               <xsl:attribute name="flag">fatal</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-get-full-path"/>
               </xsl:attribute>
               <svrl:text>[INT-T10-R018] - Per specificare CIG e CUP a livello testata è necessario fornire anche il riferimento all'ordine o al contratto.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>            
      <xsl:apply-templates select="@*|*" mode="M10"/>
   </xsl:template>
    
	<!--RULE -->

   <xsl:template match="cac:AccountingSupplierParty/cac:Party/cac:PartyLegalEntity/cbc:CompanyLiquidationStatusCode" priority="1010" mode="M10">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="cac:AccountingSupplierParty/cac:Party/cac:PartyLegalEntity/cbc:CompanyLiquidationStatusCode"/>

		<!--ASSERT -->

      <xsl:choose>
         <xsl:when test="( ( not(contains(normalize-space(.),' ')) and contains($vCompanyLiquidationStatusCodeList, concat(' ',normalize-space(.),' ') ) ) )"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="( ( not(contains(normalize-space(.),' ')) and contains($vCompanyLiquidationStatusCodeList, concat(' ',normalize-space(.),' ') ) ) )">
               <xsl:attribute name="flag">fatal</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-get-full-path"/>
               </xsl:attribute>
               <svrl:text>[INT-T10-R016] - Il codice per indicare lo stato di liquidazione dell'azienda DEVE contenere LS o LN secondo la codifica dalla FatturaPA.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>            
      <xsl:apply-templates select="@*|*" mode="M10"/>
   </xsl:template>
   
	<!--RULE -->

   <xsl:template match="cac:Party/cac:PartyLegalEntity[cbc:CompanyID/@schemeID='ZZZ']" priority="1009" mode="M10">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="cac:Party/cac:PartyLegalEntity[cbc:CompanyID/@schemeID='ZZZ']"/>

		<!--ASSERT -->

      <xsl:choose>
         <xsl:when test="cac:CorporateRegistrationScheme/cbc:Name[normalize-space()]"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="cac:CorporateRegistrationScheme/cbc:Name[normalize-space()]">
               <xsl:attribute name="flag">fatal</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-get-full-path"/>
               </xsl:attribute>
               <svrl:text>[INT-T10-R015] - Il nome dell’Albo professionale o ‘REA’ per le imprese DEVE essere specificato se si fornisce il numero di registrazione dell'azienda con lo schema 'ZZZ'.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>            
      <xsl:apply-templates select="@*|*" mode="M10"/>
   </xsl:template>
   
	<!--RULE -->

   <xsl:template match="/ubl:Invoice/cac:TaxTotal" priority="1008" mode="M10">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="/ubl:Invoice/cac:TaxTotal"/>

		<!--ASSERT -->

      <xsl:choose>
         <xsl:when test="cac:TaxSubtotal[cac:TaxCategory/cac:TaxScheme/cbc:ID='VAT']"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="cac:TaxSubtotal[cac:TaxCategory/cac:TaxScheme/cbc:ID='VAT']">
               <xsl:attribute name="flag">fatal</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-get-full-path"/>
               </xsl:attribute>
               <svrl:text>[INT-T10-R014] - Una fattura IVA DEVE specificare almeno una riga del riepilogo IVA.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>            
      <xsl:apply-templates select="@*|*" mode="M10"/>
   </xsl:template>
   
	<!--RULE -->

   <xsl:template match="//cac:PaymentMeans/cbc:PaymentMeansCode" priority="1007" mode="M10">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="//cac:PaymentMeans/cbc:PaymentMeansCode"/>

		<!--ASSERT -->

      <xsl:choose>
         <xsl:when test="( ( not(contains(normalize-space(.),' ')) and contains($vPaymentMeansCodeList, concat(' ',normalize-space(.),' ') ) ) )"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="( ( not(contains(normalize-space(.),' ')) and contains($vPaymentMeansCodeList, concat(' ',normalize-space(.),' ') ) ) )">
               <xsl:attribute name="flag">fatal</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-get-full-path"/>
               </xsl:attribute>
               <svrl:text>[INT-T10-R013] - Il codice del tipo di pagamento DEVE essere codificato in base alla lista UNCL 4461 e DEVE corrispondere ad un codice pagamento supportato dalla FatturaPA (UBL Italia subset).</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>            
      <xsl:apply-templates select="@*|*" mode="M10"/>
   </xsl:template>

	<!--RULE -->

   <xsl:template match="//cac:TaxCategory[cac:TaxScheme/cbc:ID='VAT' and (not(cbc:Percent) or cbc:Percent = 0)]" priority="1006" mode="M10">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="//cac:TaxCategory[cac:TaxScheme/cbc:ID='VAT' and (not(cbc:Percent) or cbc:Percent = 0)]"/>

		<!--ASSERT -->

      <xsl:choose>
         <xsl:when test="normalize-space(cbc:TaxExemptionReason)"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="normalize-space(cbc:TaxExemptionReason)">
               <xsl:attribute name="flag">fatal</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-get-full-path"/>
               </xsl:attribute>
               <svrl:text>[INT-T10-R012] - Se l'aliquota IVA è uguale a zero la norma di riferimento che descrive l'esenzione IVA è obbligatoria.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="@*|*" mode="M10"/>
   </xsl:template>
   
	<!--RULE -->

   <xsl:template match="//cac:PartyTaxScheme/cbc:CompanyID" priority="1005" mode="M10">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="//cac:PartyTaxScheme/cbc:CompanyID"/>

		<!--ASSERT -->

      <xsl:choose>
         <xsl:when test="@schemeID"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="@schemeID">
               <xsl:attribute name="flag">fatal</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-get-full-path"/>
               </xsl:attribute>
               <svrl:text>[INT-T10-R011] - L'identificativo fiscale (VAT) dell'azienda DEVE avere un attributo che indica il tipo di imposta (es. schemeID="IT:VAT").</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="@*|*" mode="M10"/>
   </xsl:template>
   
	<!--RULE -->

   <xsl:template match="//ext:UBLExtensions/ext:UBLExtension[starts-with(ext:ExtensionURI, 'urn:www.ubl-italia.org:spec:fatturapa:xref:')]/ext:ExtensionContent" priority="1004" mode="M10">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="//ext:UBLExtensions/ext:UBLExtension[starts-with(ext:ExtensionURI, 'urn:www.ubl-italia.org:spec:fatturapa:xref:')]/ext:ExtensionContent"/>

		<!--ASSERT -->

      <xsl:choose>
         <xsl:when test="cr:XCode and cr:XCode[not(*)] and count(*) = 1"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="cr:XCode and cr:XCode[not(*)] and count(*) = 1">
               <xsl:attribute name="flag">fatal</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-get-full-path"/>
               </xsl:attribute>
               <svrl:text>[INT-T10-R010] - Un'estensione speciale per fornire un codice di cross-reference DEVE contenere un elemento XCode del namespace "http://www.ubl-italia.org/ns/CrossReference" e questo non può contenere altri elementi.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="@*|*" mode="M10"/>
   </xsl:template>
   
	<!--RULE -->

   <xsl:template match="//cac:AccountingSupplierParty/cac:Party | //cac:AccountingCustomerParty/cac:Party" priority="1003" mode="M10">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="//cac:AccountingSupplierParty/cac:Party | //cac:AccountingCustomerParty/cac:Party"/>

		<!--ASSERT -->

      <xsl:choose>
         <xsl:when test="contains($vCountryCodeList, concat(' ',normalize-space(cac:PostalAddress/cac:Country/cbc:IdentificationCode),' '))"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="contains($vCountryCodeList, concat(' ',normalize-space(cac:PostalAddress/cac:Country/cbc:IdentificationCode),' '))">
               <xsl:attribute name="flag">fatal</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-get-full-path"/>
               </xsl:attribute>
               <svrl:text>[INT-T10-R009] - Il codice del paese è obbligatorio e DEVE essere codificato in base alla lista ISO 3166-1 Alpha2.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="@*|*" mode="M10"/>
   </xsl:template>

	<!--RULE -->

   <xsl:template match="//cac:TaxCategory | //cac:ClassifiedTaxCategory" priority="1002" mode="M10">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="//cac:TaxCategory | //cac:ClassifiedTaxCategory"/>

		<!--ASSERT -->

      <xsl:choose>
         <xsl:when test="contains($vTaxCategoryIDList, concat(' ',normalize-space(cbc:ID),' '))"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="contains($vTaxCategoryIDList, concat(' ',normalize-space(cbc:ID),' '))">
               <xsl:attribute name="flag">fatal</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-get-full-path"/>
               </xsl:attribute>
               <svrl:text>[INT-T10-R008] - L'identificatore della categoria d'imposta (natura) è obbligatorio e DEVE essere codificato in base alla lista UNCL 5305 (UBL Italia subset).</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="@*|*" mode="M10"/>
   </xsl:template>
      
	<!--RULE -->

   <xsl:template match="//cac:TaxScheme/cbc:ID" priority="1001" mode="M10">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="//cac:TaxScheme/cbc:ID"/>

		<!--ASSERT -->

      <xsl:choose>
         <xsl:when test="( ( not(contains(normalize-space(.),' ')) and contains($vTaxSchemeIDList, concat(' ',normalize-space(.),' ') ) ) )"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="( ( not(contains(normalize-space(.),' ')) and contains($vTaxSchemeIDList, concat(' ',normalize-space(.),' ') ) ) )">
               <xsl:attribute name="flag">fatal</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-get-full-path"/>
               </xsl:attribute>
               <svrl:text>[INT-T10-R007] - L'identificatore del tipo di schema fiscale DEVE essere codificato in base alla lista UNCL 5153 (UBL Italia subset).</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>            
      <xsl:apply-templates select="@*|*" mode="M10"/>
   </xsl:template>

	<!--RULE -->

   <xsl:template match="//cbc:*" priority="1000" mode="M10">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="//cbc:*"/>

		<!--ASSERT -->

      <xsl:choose>
         <xsl:when test="normalize-space()">
            <xsl:apply-templates select="." mode="schematron-get-full-path"/>
         </xsl:when>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="normalize-space()">
               <xsl:attribute name="flag">fatal</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-get-full-path"/>
               </xsl:attribute>
               <svrl:text>[INT-T10-R006] - Un elemento informativo base, se istanziato, non può essere vuoto.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="@*|*" mode="M10"/>
   </xsl:template>  
   <xsl:template match="text()" priority="-1" mode="M10"/>
   <xsl:template match="@*|node()" priority="-2" mode="M10">
      <xsl:apply-templates select="@*|*" mode="M10"/>
   </xsl:template>
</xsl:stylesheet>