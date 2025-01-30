Write-Host "TESTTEST" -ForegroundColor Blue
#Write-Host "eśąćź" -ForegroundColor Green
$path_romper = "$env:ProgramData/romper-downloader/romper-downloader.ps1"
$path_ytdlp = "$env:ProgramData/romper-downloader/yt-dlp.exe"
Invoke-WebRequest "https://asius.pages.dev/romperdownloader/romper-downloader.ps1" -OutFile "$env:ProgramData/romper-downloader/romper-downloader.ps1"
Invoke-WebRequest "https://github.com/yt-dlp/yt-dlp/releases/latest/download/yt-dlp.exe" -OutFile "$env:ProgramData/romper-downloader/yt-dlp.exe"
Invoke-WebRequest "https://www.gyan.dev/ffmpeg/builds/ffmpeg-git-full.7z" -OutFile "$env:ProgramData/romper-downloader/ffmpeg.7z"



Get-ChildItem '$env:ProgramData/romper-downloader/ffmpeg.7z' -Filter *.7z | Expand-Archive -DestinationPath '$env:ProgramData/romper-downloader/ffmpeg/' -Force