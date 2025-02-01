function Sprawdzytdlp {
    try {
        $output = & yt-dlp 2>&1 | Select-Object -First 2

        if ($output -like "*System.Management.Automation.RemoteException*") {
            Write-Host "yt-dlp jest juz zainstalowany"
        } 
        else {

Write-Host $output
            Write-Host "Pobieranie yt-dlp..."
Invoke-WebRequest "https://github.com/yt-dlp/yt-dlp/releases/latest/download/yt-dlp.exe" -OutFile "$env:ProgramData/romper-downloader/yt-dlp.exe"

        }
    } catch {
        Write-Host "Pobieranie yt-dlp..."
Invoke-WebRequest "https://github.com/yt-dlp/yt-dlp/releases/latest/download/yt-dlp.exe" -OutFile "$env:ProgramData/romper-downloader/yt-dlp.exe"

    }
}

 $path = "$env:ProgramData\romper-downloader"

Write-Host "Czarodziej konfiguracji Romper Downloadera v1.0" 

New-Item -ItemType Directory -Path "$env:ProgramData/romper-downloader/psscripts" *> $null

Write-Host "Pobieranie skryptow..."
Invoke-WebRequest "https://asius.pages.dev/romperdownloader/romper-downloader.ps1" -OutFile "$env:ProgramData/romper-downloader/psscripts/romper-downloader.ps1"

Sprawdzytdlp

$ffmpegInstalled = $false
try {
    $ffmpegVersion = ffmpeg -version 2>$null
    if ($ffmpegVersion) {
        $ffmpegInstalled = $true
    }
} catch {
    $ffmpegInstalled = $false
}

if (-not $ffmpegInstalled) {
    Write-Host "Pobieranie ffmpeg..."
    Invoke-WebRequest "https://www.gyan.dev/ffmpeg/builds/ffmpeg-git-full.7z" -OutFile "$env:ProgramData/romper-downloader/ffmpeg.7z"
    New-Item -ItemType Directory -Path "$env:ProgramData/romper-downloader/ffmpeg" *> $null
    Write-Host "Rozpakowywanie ffmpeg..."
    $is_7zip = Test-Path "C:\PROGRA~1\7-Zip\7z.exe"
    if ($is_7zip)
    {
        $7zipPath = "C:\PROGRA~1\7-Zip\7z.exe"
        $zipFile = "$env:ProgramData/romper-downloader/ffmpeg.7z"
        $extractPath = "$env:ProgramData/romper-downloader/ffmpeg"
        &"$7zipPath" e -o"$extractPath" -y "$zipFile" *> $null
    }
    else
    {
    Write-Host "7zip nie jest zainstalowany, wymagane reczne rozpakowanie plikow z archiwum $path\ffmpeg.7z do folderu $path\ffmpeg" -ForegroundColor Yellow
    Write-Host "Po wypakowaniu plikow nacisnij enter aby kontynuowac dzialnie instalatora" -ForegroundColor Yellow -NoNewline
    $null = $Host.UI.RawUI.ReadKey('NoEcho,IncludeKeyDown');
    }
    
    $sourceFolder2 = "$env:ProgramData\romper-downloader\ffmpeg"
    $destinationPath = "$env:ProgramData\romper-downloader"
    
    Get-ChildItem -Path $sourceFolder2 -Filter "*.exe" -File | Move-Item -Destination $destinationPath -Force
    
    $binFolder = Get-ChildItem -Path $sourceFolder2 -Directory | ForEach-Object { "$($_.FullName)\bin" } | Where-Object { Test-Path $_ }
    
    if ($binFolder) {
    Get-ChildItem -Path $binFolder -Filter "*.exe" -File | Move-Item -Destination $destinationPath -Force
    }
    Remove-Item -Path $sourceFolder2 -Recurse -Force
    Remove-Item -Path "$path\ffmpeg.7z" -Force
} else {
   Write-Host "ffmpeg jest juz zainstalowany"
}

$folderToCheck = "$path\" 
$pathEntries = [System.Environment]::GetEnvironmentVariable("Path", "Machine") -split ";" 

if ($pathEntries -contains $folderToCheck) {
    Write-Host "Romper downloader jest już skonfigurowany"
} else {
    Write-Host "Konfiguracja Romper Downloadera..."
    [Environment]::SetEnvironmentVariable(
    "Path",
    [Environment]::GetEnvironmentVariable("Path", [EnvironmentVariableTarget]::Machine) + ";$path",
    [EnvironmentVariableTarget]::Machine)
}

Invoke-WebRequest "https://asius.pages.dev/romperdownloader/install.bat" -OutFile "$env:ProgramData/romper-downloader/romper-downloader-update-repair.bat"

$romper_alias = Read-Host "Wybierz alias dla skryptu (Domyslny: romper-downloader)"
    if ([string]::IsNullOrWhiteSpace($input)) {
        $romper_alias = "romper-downloader" # Domyslna wartosc
    }

Invoke-WebRequest "https://asius.pages.dev/romperdownloader/run.bat" -OutFile "$env:ProgramData/romper-downloader/$romper_alias.bat"

Write-Host " "

Write-Host "Instalacja zakonczona pomyslnie"
Write-Host " "
Write-Host "Aby wywolac skrypt wpisz romper-downloader.ps1 w powershellu"
Write-Host "Aby zaaktualizowac lub naprawic skrypt i/lub jego zaleznosci uruchom plik romper-downloader-update-repair.bat w folderze $path"

Pause
