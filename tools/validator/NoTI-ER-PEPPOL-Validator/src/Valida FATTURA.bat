@echo off
cls
echo PEPPOL BIS Billing 3.0 (EN-16931) - UBL-Invoice-2.1 two-phase validation
set "xml="
call _fc xml
IF %ERRORLEVEL% EQU 1 GOTO :done
echo.
echo Validating %xml%
echo ____________________________________________________________
echo - Phase 1: XSD schema validation

call _w3cschema xsd\maindoc\UBL-Invoice-2.1.xsd "%xml%" >output\syntax_report.txt
if %errorlevel% neq 0 goto :syntax_error
echo No schema validation errors.

echo ____________________________________________________________
echo - Phase 2: XSLT semantic validation

echo   - EN \ OPENPEPPOL CIUS \ Italian CIUS Rules
call _xslt2 "%xml%" xsl\PEPPOL\ITNAT-EN16931-UBL.xsl output\svrl_report.xml
echo Output is provided using Schematron Validation Report Language (SVRL)
call _xslt2 output\svrl_report.xml xsl\SVRLReportRender-IT.xsl output\semantic_report.html

goto :semantic_error

:syntax_error
explorer "file://%~d0%~p0output\syntax_report.txt"
goto :done

:semantic_error
explorer "file://%~d0%~p0output\semantic_report.html"

:done