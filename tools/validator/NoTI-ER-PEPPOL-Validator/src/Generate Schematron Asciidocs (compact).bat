@echo off
cls
echo ISO Schematron Easy Compiler
echo Copyright (C) 2018, JAVEST by Roberto Cisternino
set "xml="
call _fc-sch xml
IF %ERRORLEVEL% EQU 1 GOTO :done
echo.
echo compiling %xml%
echo ____________________________________________________________
echo - Phase 1: expand inclusions
call _xslt "%xml%" xsl\iso_dsdl_include.xsl output\ph1.sch

echo ____________________________________________________________
echo - Phase 2: expand abstract patterns
call _xslt output\ph1.sch xsl\iso_abstract_expand.xsl output\ph2.sch

echo ____________________________________________________________
echo - Phase 3: generate rules asciidoc documentation
call _xslt2 output\ph2.sch xsl\iso_schematron-to-asciidoc-v1.0.xsl output\doc.adoc "tableMode=compact"

:done
