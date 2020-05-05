@echo off
SETLOCAL
For /F "tokens=1 delims=" %%X IN ('java -jar lib\FileChooser.jar sch') Do set "v=%%X"
ENDLOCAL&set "%~1=%v%"
exit /b