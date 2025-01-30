function Sprawdzytdlp {
    try {
        # Uruchomienie ffmpeg i pobranie pierwszej linii wyniku
        $output = & yt-dlp 2>&1 | Select-Object -First 2

        # Sprawdzenie pierwszych 16 znaków
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

# Sprawdzenie, czy ffmpeg jest zainstalowany
$ffmpegInstalled = $false
try {
    $ffmpegVersion = ffmpeg -version 2>$null
    if ($ffmpegVersion) {
        $ffmpegInstalled = $true
    }
} catch {
    $ffmpegInstalled = $false
}

# Jeśli ffmpeg nie jest zainstalowany, wykonaj dodatkowy kod
if (-not $ffmpegInstalled) {
    Write-Host "Pobieranie ffmpeg..."
    Invoke-WebRequest "https://www.gyan.dev/ffmpeg/builds/ffmpeg-git-full.7z" -OutFile "$env:ProgramData/romper-downloader/ffmpeg.7z"
    New-Item -ItemType Directory -Path "$env:ProgramData/romper-downloader/ffmpeg"
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
    
    # Przeniesienie plików .exe bezpośrednio z folder2
    Get-ChildItem -Path $sourceFolder2 -Filter "*.exe" -File | Move-Item -Destination $destinationPath -Force
    
    # Znalezienie folderu o dowolnej nazwie w folder2 i przeniesienie plików .exe z jego bin
    $binFolder = Get-ChildItem -Path $sourceFolder2 -Directory | ForEach-Object { "$($_.FullName)\bin" } | Where-Object { Test-Path $_ }
    
    if ($binFolder) {
    Get-ChildItem -Path $binFolder -Filter "*.exe" -File | Move-Item -Destination $destinationPath -Force
    }
    Remove-Item -Path $sourceFolder2 -Recurse -Force
    Remove-Item -Path "$path\ffmpeg.7z" -Force
} else {
   Write-Host "ffmpeg jest już zainstalowany"
}

$folderToCheck = "$path\"  # Podmień na swój folder
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

Write-Host "Instalacja zakończona pomyślnie"
Write-Host " "
Write-Host "Aby wywołać skrypt wpisz romper-downloader.ps1 w powershellu"
Write-Host "Aby zaaktualizować lub naprawić skrypt i/lub jego zależności uruchom plik update_repair.bat w folderze $path"

Invoke-WebRequest "https://asius.pages.dev/romperdownloader/install.bat" -OutFile "$env:ProgramData/romper-downloader/update_repair.ps1"

Pause