@echo off

set directoryOfThisScript=%~dp0
 

echo Now installing [[[[ PUT SOMETHING MEANINGFUL HERE ]]]]

@REM THE FOLLOWING COMMANDS ARE A WAY TO INVOKE A POWERSHELL SCRIPT.
Powershell.exe -NonInteractive -command "Set-ExecutionPolicy Unrestricted"
Powershell.exe -NonInteractive -command "%directoryOfThisScript%[[[[[[[[NAME OF POWERSHELL SCRIPT TO EXECUTE]]]]]].ps1"

echo.
echo This window will close in 20 seconds...
timeout /t 20 >nul
exit