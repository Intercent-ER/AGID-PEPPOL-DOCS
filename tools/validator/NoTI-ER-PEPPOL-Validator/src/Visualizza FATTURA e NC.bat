@echo off
cls
echo PEPPOL BIS Billing 3.0 (EN-16931) Viewer
set "xml="
call _fc xml
IF %ERRORLEVEL% EQU 1 GOTO :done
echo.
echo Rendering %xml%

call _xslt2 "%xml%" xsl\PEPPOL\stylesheet-ubl.xslt output\view.html

explorer "file://%~d0%~p0output\view.html"

:done
