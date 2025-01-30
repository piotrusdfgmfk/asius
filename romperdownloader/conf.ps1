Write-Host "TESTTEST" -ForegroundColor Blue
#Write-Host "eśąćź" -ForegroundColor Green
$path = "$env:ProgramData/romper-downloader/romper-downloader.ps1"
Invoke-WebRequest "https://asius.pages.dev/romperdownloader/romper-downloader.ps1" -OutFile $path

