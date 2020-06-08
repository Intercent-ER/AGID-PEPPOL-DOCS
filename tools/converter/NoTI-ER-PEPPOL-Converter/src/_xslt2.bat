@echo off
java -jar lib/saxon9.jar -s:%1 -xsl:%2 -o:%3
