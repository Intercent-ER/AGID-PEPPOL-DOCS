@echo off
cls
echo FatturaPA 1.2.1 validation
set "xml="
call _fc xml
IF %ERRORLEVEL% EQU 1 GOTO :done
echo.
echo Validating %xml%
echo ____________________________________________________________
echo - Phase 1: XSD schema validation

call _w3cschema profiles\national\it\SDI\fatturapa-1.2.1\fatturapa_v1.2.1.xsd "%xml%" >output\syntax_report.txt
if %errorlevel% neq 0 goto :syntax_error
echo No schema validation errors.

:syntax_error
explorer "file://%~d0%~p0output\syntax_report.txt"
goto :done

:done
