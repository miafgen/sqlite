@echo off
set version=3.40.0.0
"makensis.exe" /DVERSION=%version% _resources\sqlite.nsi
pause
