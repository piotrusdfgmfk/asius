function Sprawdzytdlp {
    try {
        $output = & yt-dlp 2>&1 | Select-Object -First 2

        if ($output -like "*System.Management.Automation.RemoteException*") {
            Write-Host "yt-dlp jest już zainstalowany"
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

Write-Host "Czarodziej konfiguracji Romper Downloadera v0.97" 
Write-Host "Pobieranie skryptów..."
Invoke-WebRequest "https://asius.pages.dev/romperdownloader/romper-downloader.ps1" -OutFile "$env:ProgramData/romper-downloader/romper-downloader.ps1"

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
    Write-Host "7zip nie jest zainstalowany, wymagane ręczne rozpakowanie plików z archiwum $path\ffmpeg.7z do folderu $path\ffmpeg" -ForegroundColor Yellow
    Write-Host "Po wypakowaniu plików naciśnij enter aby kontynuować działanie instalatora" -ForegroundColor Yellow -NoNewline
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
   Write-Host "ffmpeg jest już zainstalowany"
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

Invoke-WebRequest "https://asius.pages.dev/romperdownloader/install.bat" -OutFile "$env:ProgramData/romper-downloader/update_repair.bat"

Write-Host "Instalacja zakończona pomyślnie"
Write-Host " "
Write-Host "Aby wywołać skrypt wpisz romper-downloader.ps1 w powershellu"
Write-Host "Aby zaaktualizować lub naprawić skrypt i/lub jego zależności uruchom plik update_repair.bat w folderze $path"

Pause