@echo off
set /p version=Version of SQLite: 
"C:\Program Files (x86)\NSIS\makensis.exe" /DVERSION=%version% resources\sqlite.nsi
pause
