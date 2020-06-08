@echo off
cls
echo PEPPOL-BIS-05a-400_UBL-Invoice-2.1-to-Fattura-PA-1.2 conversion
set "xml="
call _fc xml
IF %ERRORLEVEL% EQU 1 GOTO :done
echo ____________________________________________________________
echo - Phase 1: Conversion
echo.
echo Converting %xml%

call _xslt2 "%xml%" adapters\government\it\PEPPOL-BIS-05a-400_UBL-Invoice-2.1-to-Fattura-PA-1.2\adapter.xsl output\converted.xml 2>output\conversion_report.txt

echo.
echo Validating output\converted.xml
echo ____________________________________________________________
echo - Phase 2: XSD schema validation

call _w3cschema profiles\national\it\SDI\fatturapa-1.2\fatturapa_v1.2.xsd output\converted.xml >>output\conversion_report.txt

explorer "file://%~d0%~p0output\conversion_report.txt"

goto :done

:done
