Write-Host "TESTTEST" -ForegroundColor Blue
#Write-Host "eśąćź" -ForegroundColor Green
$path_romper = "$env:ProgramData/romper-downloader/romper-downloader.ps1"
$path_ytdlp = "$env:ProgramData/romper-downloader/yt-dlp.exe"
Invoke-WebRequest "https://asius.pages.dev/romperdownloader/romper-downloader.ps1" -OutFile "$env:ProgramData/romper-downloader/romper-downloader.ps1"
Invoke-WebRequest "https://github.com/yt-dlp/yt-dlp/releases/latest/download/yt-dlp.exe" -OutFile "$env:ProgramData/romper-downloader/yt-dlp.exe"
Invoke-WebRequest "https://asius.pages.dev/romperdownloader/ffmpeg.exe" -OutFile "$env:ProgramData/romper-downloader/ffmpeg.exe"
Invoke-WebRequest "https://asius.pages.dev/romperdownloader/ffplay.exe" -OutFile "$env:ProgramData/romper-downloader/ffplay.exe"
Invoke-WebRequest "https://asius.pages.dev/romperdownloader/ffprobe.exe" -OutFile "$env:ProgramData/romper-downloader/ffprobe.exe"