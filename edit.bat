:: on Windows busybox.exe must be in path
:: example with light webserver: ./webserver.exe -port 8585 -dir . -cmd "edit=cmd.exe /C edit.bat" -debug
:: http://localhost:8585/edit.html?backend=_#/README.md

@ECHO OFF
PATH=%PATH%:../../bin:.

busybox.exe bash -c edit.sh %1 %2 %3 %4 %5 %6 %7 %8 %9
