function Sprawdzytdlp {
    try {
        # Uruchomienie ffmpeg i pobranie pierwszej linii wyniku
        $output = & yt-dlp -U 2>&1 | Select-Object -First 6

        # Sprawdzenie pierwszych 16 znakow
        if ($output -like "Latest*") {
            
        } 
        else {

Write-Host $output
            Write-Host " "
            Write-Host "Nie udalo sie uruchomic yt-dlp. Upewnij sie ze yt-dlp jest poprawnie zainstalowane i skonfigurowane" -ForegroundColor Yellow  
            Write-Host "https://github.com/yt-dlp/yt-dlp?tab=readme-ov-file#installation" -ForegroundColor Yellow
            Write-Host "Lub uruchom skrypt romper-downloader-update-repair.bat znajdujacy sie w katalogu C:\programdata\romper-downloader" -ForegroundColor Yellow
            Write-Host " " 
            exit 1
        }
    } catch {
        Write-Host " "
        Write-Host "Nie udalo sie uruchomic yt-dlp. Upewnij sie ze yt-dlp jest poprawnie zainstalowane i skonfigurowane" -ForegroundColor Yellow  
            Write-Host "https://github.com/yt-dlp/yt-dlp?tab=readme-ov-file#installation" -ForegroundColor Yellow
            Write-Host "Lub uruchom skrypt romper-downloader-update-repair.bat znajdujacy sie w katalogu C:\programdata\romper-downloader" -ForegroundColor Yellow
            Write-Host " "
            exit 1
    }
}



function SprawdzFFmpeg {
    try {
        # Uruchomienie ffmpeg i pobranie pierwszej linii wyniku
        $output = & ffmpeg -version 2>&1 | Select-Object -First 1

        # Sprawdzenie pierwszych 16 znakow
        if ($output -like "ffmpeg version *") {
            
        } 
        else {
           Write-Host " "
            Write-Host "Nie udalo sie uruchomic ffmpeg. Konwersja formatu pliku moze byc niemozliwa" -ForegroundColor Yellow  
            Write-Host "Aby zapewnic poprawne dzialanie programu zainstaluj ffmpeg: https://www.gyan.dev/ffmpeg/builds/" -ForegroundColor Yellow 
            Write-Host "Lub uruchom skrypt romper-downloader-update-repair.bat znajdujacy sie w katalogu C:\programdata\romper-downloader" -ForegroundColor Yellow       
        Write-Host " "
        }
    } catch {
        
        Write-Host "Nie udalo sie uruchomic ffmpeg. Konwersja formatu pliku moze nie byc mozliwa" -ForegroundColor Yellow  
        Write-Host "Aby zapewnic poprawne dzialanie programu zainstaluj ffmpeg: https://www.gyan.dev/ffmpeg/builds/" -ForegroundColor Yellow
        Write-Host "Lub uruchom skrypt romper-downloader-update-repair.bat znajdujacy sie w katalogu C:\programdata\romper-downloader" -ForegroundColor Yellow

    
    }
}
Sprawdzytdlp
# Wywolanie funkcji
SprawdzFFmpeg

Write-Host "Romper Downloader v1.67"
Write-Host " "

Write-Host "Obslugiwane serwisy: https://github.com/yt-dlp/yt-dlp/blob/master/supportedsites.md"
Write-Host "Podaj link: " -NoNewline
$link = Read-Host

$linkregEx="(https?:\/\/(?:www\.|(?!www))[a-zA-Z0-9][a-zA-Z0-9-]+[a-zA-Z0-9]\.[^\s]{2,}|www\.[a-zA-Z0-9][a-zA-Z0-9-]+[a-zA-Z0-9]\.[^\s]{2,}|https?:\/\/(?:www\.|(?!www))[a-zA-Z0-9]+\.[^\s]{2,}|www\.[a-zA-Z0-9]+\.[^\s]{2,})"

if($link -notmatch $linkregEx){
    Write-host -ForegroundColor Red "Nieprawidlowy link"
    exit 1
}

Write-Host " "

function Lokalizacja {

    Write-Host "Wybierz lokalizacje docelowa pliku" 
    $choice = $(Write-Host -NoNewline) + $(Write-Host "[1] Pobrane   " -ForegroundColor Cyan -NoNewline; Write-Host "[2] Aktualny folder   [3] Wlasna   (Domyslny: Pobrane): " -NoNewline; Read-Host)

      # Jesli uzytkownik nacisnal Enter bez wpisywania, ustaw domyslna opcje
      if ([string]::IsNullOrWhiteSpace($choice)) {
        $choice = "1" # Domyslna opcja: MP4
    }

    # Przypisanie wyboru do odpowiedniego formatu
    Switch ($choice) {
        "1" { $selectedLocation = (Get-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Shell Folders").PSObject.Properties["{374DE290-123F-4565-9164-39C4925E467B}"].Value }
        "2" { $selectedLocation = Get-Location }
        "3" { 
            Write-Host ""
            Write-Host "Podaj sciezke folderu: " -NoNewline
            $selectedLocation = Read-Host
            }
        Default {
            Write-Host "Nieprawidlowy wybor. Sprobuj ponownie." -ForegroundColor Red
            return WybierzFormat # Powtorz wybor w przypadku bledu
        }
    }

    return $selectedLocation
}

$lokalizacja = Lokalizacja

#Write-Host "[Debug] $lokalizacja; $link; $AudioVideo   ;$Format" -ForegroundColor Yellow
Write-Host ""


function AudioVideo {

    Write-Host "Wybierz rodzaj docelowego pliku" 
    $choice = $(Write-Host -NoNewline) + $(Write-Host "[1] Video   " -ForegroundColor Cyan -NoNewline; Write-Host "[2] Audio   (Domyslny: Video): " -NoNewline; Read-Host)

      # Jesli uzytkownik nacisnal Enter bez wpisywania, ustaw domyslna opcje
      if ([string]::IsNullOrWhiteSpace($choice)) {
        $choice = "1" # Domyslna opcja: MP4
    }

    # Przypisanie wyboru do odpowiedniego formatu
    Switch ($choice) {
        "1" { $selectedFormat = "Video" }
        "2" { $selectedFormat = "Audio" }
        Default {
            Write-Host "Nieprawidlowy wybor. Sprobuj ponownie." -ForegroundColor Red
            return WybierzFormat # Powtorz wybor w przypadku bledu
        }
    }

    return $selectedFormat
}

$AudioVideo = AudioVideo

Write-Host " "

if($AudioVideo -eq "Audio"){
 #   Write-Host "[Debug] $lokalizacja; $link; $AudioVideo   ;$Format" -ForegroundColor Yellow
    $AudioFormat = Read-Host "Podaj format docelowego pliku audio (Domyslny: mp3)"
    if ([string]::IsNullOrWhiteSpace($input)) {
        $AudioFormat = "mp3" # Domyslna wartosc
    }
    Write-Host " "
    &yt-dlp $link -x --audio-format $AudioFormat --audio-quality 0 -P $lokalizacja -o "%(title)s.%(ext)s"
    exit 1
}


if($AudioVideo -eq "Video"){
$VideoFormat = Read-Host "Podaj format docelowego pliku audio (Pozostaw puste w przypadku braku zainstalowanego FFMPEG, domyslny format FFMPEG to mkv)"
if ([string]::IsNullOrWhiteSpace($VideoFormat)) {
    $remuxFormat = @()
} else {
    $remuxFormat = @("--remux-video", $VideoFormat)
}
}

Write-Host " "
Write-Host "Po wywolaniu polecenia yt-dlp nalezy wskazac wybrany format pobierania pliku albo wybrac domyslny klikajac enter"
Write-Host "Istnieje mozliwosc polaczenia roznych formatow audio i video poprzez wpisanie id obu formatow oddzielonych znakiem *+* np: *2137+69*"
Write-Host "Niektore kodeki audio i video moga nie wspolpracowac z danym formatem/urzadzeniem, aby zapewnic bezproblemowe odtwarzanie zalecane jest audio mp4a i video avc1, aby uzyskac lepsza jakosc nalezy wybrac odpowiednie formaty w zaleznosci od wsparcia danego systemu"
Write-Host " "
#Write-Host "[Debug] $lokalizacja; $link; $AudioVideo ;$AudioFormat; $VideoFormat ;$remuxformat" -ForegroundColor Yellow
#Write-Host '[Debug] yt-dlp $link -f - $remuxFormat -o "%(title)s.%(ext)s" -P $lokalizacja ' -ForegroundColor Yellow

& yt-dlp "$link" -f - @remuxFormat -o "%(title)s.%(ext)s" -P $lokalizacja

Write-Host " "
Write-Host "Pobieranie zakonczone, plik znajduje sie w $lokalizacja" -ForegroundColor Green
Write-Host " "
