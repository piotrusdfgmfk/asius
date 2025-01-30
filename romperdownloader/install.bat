@echo off
setlocal EnableDelayedExpansion

:: Sprawdzenie, czy skrypt jest uruchomiony jako administrator
net session >nul 2>&1
if %errorLevel% neq 0 (
    powershell -Command "Start-Process cmd -ArgumentList '/c "%~f0"' -Verb RunAs"
    exit /b
)

:: Ustawienie ścieżki docelowej
set "APP_FOLDER=%ProgramData%\romper-downloader"

:: Tworzenie folderu docelowego (jeśli nie istnieje)
if not exist "%APP_FOLDER%" mkdir "%APP_FOLDER%"


:: Pobieranie skryptu PowerShell
powershell -Command "Invoke-WebRequest -Uri 'https://asius.pages.dev/romperdownloader/conf.ps1' -OutFile '%APP_FOLDER%\conf.ps1'"

:: Konwersja pliku do UTF-8 bez BOM
:: powershell -Command " $content = Get-Content '%APP_FOLDER%\conf.ps1' -Raw; $utf8NoBom = New-Object System.Text.UTF8Encoding $false; [System.IO.File]::WriteAllText('%APP_FOLDER%\conf.ps1', $content, $utf8NoBom) "

:: dupadupa

:: Uruchamianie pobranego skryptu PowerShell
pwsh.exe -ExecutionPolicy Bypass -File "%APP_FOLDER%\conf.ps1"

::pwsh.exe -NoProfile -ExecutionPolicy Bypass -Command "& {Start-Process PowerShell -ArgumentList '-NoProfile -ExecutionPolicy Bypass -File ""%APP_FOLDER%\conf.ps1""' -Verb RunAs}"

pause


