@echo off
setlocal EnableDelayedExpansion

:: Sprawdzenie, czy skrypt jest uruchomiony jako administrator
net session >nul 2>&1
if %errorLevel% neq 0 (
    powershell -Command "Start-Process cmd -ArgumentList '/c "%~f0"' -Verb RunAs"
    exit /b
)

:: Ustawienie ścieżki docelowej
set "APP_FOLDER=%ProgramFiles%\romper-downloader"

:: Tworzenie folderu docelowego (jeśli nie istnieje)
if not exist "%APP_FOLDER%" mkdir "%APP_FOLDER%"

:: Pobieranie skryptu PowerShell

powershell Invoke-WebRequest -Uri 'https://asius.pages.dev/romperdownloader/conf.ps1' -OutFile '%APP_FOLDER%\conf.ps1'

powershell $content = Get-Content '%APP_FOLDER%\conf.ps1' -Raw

powershell $content | Set-Content '%APP_FOLDER%\conf.ps1' -Encoding utf8

::dupadupa

:: Uruchamianie pobranego skryptu PowerShell
powershell -ExecutionPolicy Bypass -File "%APP_FOLDER%\conf.ps1"

pause

