@echo off
setlocal EnableDelayedExpansion

:: Sprawdzenie, czy skrypt jest uruchomiony jako administrator
net session >nul 2>&1
if %errorLevel% neq 0 (
    echo Uruchom ten skrypt jako administrator.
    pause
    exit /b
)

:: Ustawienie ścieżki docelowej
set "APP_FOLDER=%ProgramFiles%\romperdownloader"

:: Tworzenie folderu docelowego (jeśli nie istnieje)
if not exist "%APP_FOLDER%" mkdir "%APP_FOLDER%"

:: Pobieranie skryptu PowerShell
powershell -Command "Invoke-WebRequest -Uri 'https://asius.pages.dev/romperdownloader/romper-downloader.ps1' -OutFile '%APP_FOLDER%\romper-downloader.ps1'"

:: Uruchamianie pobranego skryptu PowerShell
powershell -ExecutionPolicy Bypass -File "%APP_FOLDER%\romper-downloader.ps1"
