function Sprawdzytdlp {
    try {
        # Uruchomienie ffmpeg i pobranie pierwszej linii wyniku
        $output = & yt-dlp 2>&1 | Select-Object -First 2

        # Sprawdzenie pierwszych 16 znaków
        if ($output -like "*System.Management.Automation.RemoteException*") {
            Write-Host "yt-dlp jest już zainstalowane"
        } 
        else {

Write-Host $output
            Write-Host "Pobieranie yt-dlp..."
Invoke-WebRequest "https://github.com/yt-dlp/yt-dlp/releases/latest/download/yt-dlp.exe" -OutFile "$env:ProgramData/romper-downloader/yt-dlp.exe"
            exit 1
        }
    } catch {
        Write-Host "Pobieranie yt-dlp..."
Invoke-WebRequest "https://github.com/yt-dlp/yt-dlp/releases/latest/download/yt-dlp.exe" -OutFile "$env:ProgramData/romper-downloader/yt-dlp.exe"
            exit 1
    }
}



function SprawdzFFmpeg {
    try {
        # Uruchomienie ffmpeg i pobranie pierwszej linii wyniku
        $output = & ffmpeg -version 2>&1 | Select-Object -First 1

        # Sprawdzenie pierwszych 16 znaków
        if ($output -like "ffmpeg version 7*") {
            Write-Host "ffmpeg jest już zainstalowane"
        } 
        else {
          Write-Host "Pobieranie ffmpeg..."
Invoke-WebRequest "https://www.gyan.dev/ffmpeg/builds/ffmpeg-git-full.7z" -OutFile "$env:ProgramData/romper-downloader/ffmpeg.7z"
mkdir "$env:ProgramData/romper-downloader/ffmpeg"
$path = "$env:ProgramData/romper-downloader"
Write-Host "Rozpakowywanie ffmpeg..."
$is_7zip = Test-Path "C:\PROGRA~1\7-Zip\7z.exe"
if ($is_7zip)
{
    
    $7zipPath = "C:\PROGRA~1\7-Zip\7z.exe"

    $zipFile = "$env:ProgramData/romper-downloader/ffmpeg.7z"
    $extractPath = "$env:ProgramData/romper-downloader/ffmpeg"
    
    iex "$7zipPath e -o$extractPath -y $zipFile"

}
else
{
    Write-Host "7zip nie jest zainstalowany, wymagane ręczne rozpakowanie plików z archiwum $path\ffmpeg.7z do folderu $path\ffmpeg" -ForegroundColor Yellow
    Write-Host "Po wypakowaniu plików naciśnij enter aby kontynuować działanie instalatora" -ForegroundColor Yellow

    Write-Host -NoNewLine 'Press any key to continue...';
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
        }
    } catch {
       Write-Host "Pobieranie ffmpeg..."
Invoke-WebRequest "https://www.gyan.dev/ffmpeg/builds/ffmpeg-git-full.7z" -OutFile "$env:ProgramData/romper-downloader/ffmpeg.7z"
mkdir "$env:ProgramData/romper-downloader/ffmpeg"
$path = "$env:ProgramData/romper-downloader"
Write-Host "Rozpakowywanie ffmpeg..."
$is_7zip = Test-Path "C:\PROGRA~1\7-Zip\7z.exe"
if ($is_7zip)
{
    
    $7zipPath = "C:\PROGRA~1\7-Zip\7z.exe"

    $zipFile = "$env:ProgramData/romper-downloader/ffmpeg.7z"
    $extractPath = "$env:ProgramData/romper-downloader/ffmpeg"
    
    iex "$7zipPath e -o$extractPath -y $zipFile"

}
else
{
    Write-Host "7zip nie jest zainstalowany, wymagane ręczne rozpakowanie plików z archiwum $path\ffmpeg.7z do folderu $path\ffmpeg" -ForegroundColor Yellow
    Write-Host "Po wypakowaniu plików naciśnij enter aby kontynuować działanie instalatora" -ForegroundColor Yellow

    Write-Host -NoNewLine 'Press any key to continue...';
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
    }
}



Write-Host "Czarodziej konfiguracji Romper Downloadera rozpoczyna prace" 
Write-Host "Pobieranie skryptów..."
Invoke-WebRequest "https://asius.pages.dev/romperdownloader/romper-downloader.ps1" -OutFile "$env:ProgramData/romper-downloader/romper-downloader.ps1"
Sprawdzytdlp
SprawdzFFmpeg




[Environment]::SetEnvironmentVariable(
    "Path",
    [Environment]::GetEnvironmentVariable("Path", [EnvironmentVariableTarget]::Machine) + ";$path",
    [EnvironmentVariableTarget]::Machine)

Remove-Item -Path $sourceFolder2 -Recurse -Force
Remove-Item -Path "$path\ffmpeg.7z" -Force
