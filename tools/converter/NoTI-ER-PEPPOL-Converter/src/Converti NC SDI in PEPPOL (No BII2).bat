@echo off
cls
echo Fattura-PA-1.2.1-to-PEPPOL-BIS-05a-400_UBL-CreditNote-2.1_NoTIER conversion
set "xml="
call _fc xml
IF %ERRORLEVEL% EQU 1 GOTO :done
echo ____________________________________________________________
echo - Phase 1: Conversion
echo.
echo Converting %xml%

call _xslt2 "%xml%" adapters\government\it\Fattura-PA-1.2.1-to-PEPPOL-BIS-05a-400_UBL-CreditNote-2.1_NoTIER\adapter.xsl output\converted.xml 2>output\conversion_report.txt

echo.
echo Validating output\converted.xml
echo ____________________________________________________________
echo - Phase 2: XSD schema validation

call _w3cschema profiles\open\OASIS\UBL\os-UBL-2.1\xsd\maindoc\UBL-CreditNote-2.1.xsd output\converted.xml >>output\conversion_report.txt

call explorer "file://%~d0%~p0output\conversion_report.txt"

echo ____________________________________________________________
echo - Phase 3: XSLT semantic validation

echo   - OPENPEPPOL Rules
call _xslt2 output\converted.xml xsl\PEPPOL\ITNAT-UBL-T14_NOBII2.xsl output\svrl_report.xml
echo Output is provided using Schematron Validation Report Language (SVRL)
call _xslt2 output\svrl_report.xml xsl\SVRLReportRender-IT.xsl output\semantic_report.html

goto :semantic_error

:semantic_error
explorer "file://%~d0%~p0output\semantic_report.html"
goto :done

:done
