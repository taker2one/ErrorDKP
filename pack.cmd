@echo off
echo Delete old archive
del /f ErrorDKP.zip
echo Done
@echo on
"C:\Program Files\7-Zip\7z.exe" a -r -tzip -xr@exclude.txt ErrorDKP.zip .\