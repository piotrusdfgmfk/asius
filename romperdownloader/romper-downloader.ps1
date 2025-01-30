function Sprawdzytdlp {
    try {
        # Uruchomienie ffmpeg i pobranie pierwszej linii wyniku
        $output = & yt-dlp -U 2>&1 | Select-Object -First 2

        # Sprawdzenie pierwszych 16 znaków
        if ($output -like "*System.Management.Automation.RemoteException*") {
            
        } 
        else {

Write-Host $output
            Write-Host " "
            Write-Host "Nie udało się uruchomić yt-dlp. Upewnij się że yt-dlp jest poprawnie zainstalowane i skonfigurowane" -ForegroundColor Yellow  
            Write-Host "https://github.com/yt-dlp/yt-dlp?tab=readme-ov-file#installation" -ForegroundColor Yellow
            Write-Host " " 
            exit 1
        }
    } catch {
        Write-Host " "
        Write-Host "Nie udało się uruchomić yt-dlp. Upewnij się że yt-dlp jest poprawnie zainstalowane i skonfigurowane" -ForegroundColor Yellow  
            Write-Host "https://github.com/yt-dlp/yt-dlp?tab=readme-ov-file#installation" -ForegroundColor Yellow
            Write-Host " "
            exit 1
    }
}



function SprawdzFFmpeg {
    try {
        # Uruchomienie ffmpeg i pobranie pierwszej linii wyniku
        $output = & ffmpeg -version 2>&1 | Select-Object -First 1

        # Sprawdzenie pierwszych 16 znaków
        if ($output -like "ffmpeg version *") {
            
        } 
        else {
           Write-Host " "
            Write-Host "Nie udało się uruchomić ffmpeg. Konwersja formatu pliku może być niemożliwa" -ForegroundColor Yellow  
            Write-Host "Aby zapewnić poprawne działanie programu zainstaluj ffmpeg: https://www.gyan.dev/ffmpeg/builds/" -ForegroundColor Yellow        
        Write-Host " "
        }
    } catch {
        
        Write-Host "Nie udało się uruchomić ffmpeg. Konwersja formatu pliku może nie być możliwa" -ForegroundColor Yellow  
        Write-Host "Aby zapewnić poprawne działanie programu zainstaluj ffmpeg: https://www.gyan.dev/ffmpeg/builds/" -ForegroundColor Yellow
    
    }
}
Sprawdzytdlp
# Wywołanie funkcji
SprawdzFFmpeg

Write-Host "Romper Downloader v0.97"
Write-Host " "

Write-Host "Obsługiwane serwisy: https://github.com/yt-dlp/yt-dlp/blob/master/supportedsites.md"
Write-Host "Podaj link: " -NoNewline
$link = Read-Host

$linkregEx="(https?:\/\/(?:www\.|(?!www))[a-zA-Z0-9][a-zA-Z0-9-]+[a-zA-Z0-9]\.[^\s]{2,}|www\.[a-zA-Z0-9][a-zA-Z0-9-]+[a-zA-Z0-9]\.[^\s]{2,}|https?:\/\/(?:www\.|(?!www))[a-zA-Z0-9]+\.[^\s]{2,}|www\.[a-zA-Z0-9]+\.[^\s]{2,})"

if($link -notmatch $linkregEx){
    Write-host -ForegroundColor Red "Nieprawidłowy link"
    exit 1
}

Write-Host " "

function Lokalizacja {

    Write-Host "Wybierz lokalizacje docelową pliku" 
    $choice = $(Write-Host -NoNewline) + $(Write-Host "[1] Pobrane   " -ForegroundColor Cyan -NoNewline; Write-Host "[2] Aktualny folder   [3] Własna   (Domyślny: Pobrane): " -NoNewline; Read-Host)

      # Jeśli użytkownik nacisnął Enter bez wpisywania, ustaw domyślną opcję
      if ([string]::IsNullOrWhiteSpace($choice)) {
        $choice = "1" # Domyślna opcja: MP4
    }

    # Przypisanie wyboru do odpowiedniego formatu
    Switch ($choice) {
        "1" { $selectedLocation = (Get-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Shell Folders").PSObject.Properties["{374DE290-123F-4565-9164-39C4925E467B}"].Value }
        "2" { $selectedLocation = Get-Location }
        "3" { 
            Write-Host ""
            Write-Host "Podaj ścieżke folderu: " -NoNewline
            $selectedLocation = Read-Host
            }
        Default {
            Write-Host "Nieprawidłowy wybór. Spróbuj ponownie." -ForegroundColor Red
            return WybierzFormat # Powtórz wybór w przypadku błędu
        }
    }

    return $selectedLocation
}

$lokalizacja = Lokalizacja

#Write-Host "[Debug] $lokalizacja; $link; $AudioVideo   ;$Format" -ForegroundColor Yellow
Write-Host ""


function AudioVideo {

    Write-Host "Wybierz rodzaj docelowego pliku" 
    $choice = $(Write-Host -NoNewline) + $(Write-Host "[1] Video   " -ForegroundColor Cyan -NoNewline; Write-Host "[2] Audio   (Domyślny: Video): " -NoNewline; Read-Host)

      # Jeśli użytkownik nacisnął Enter bez wpisywania, ustaw domyślną opcję
      if ([string]::IsNullOrWhiteSpace($choice)) {
        $choice = "1" # Domyślna opcja: MP4
    }

    # Przypisanie wyboru do odpowiedniego formatu
    Switch ($choice) {
        "1" { $selectedFormat = "Video" }
        "2" { $selectedFormat = "Audio" }
        Default {
            Write-Host "Nieprawidłowy wybór. Spróbuj ponownie." -ForegroundColor Red
            return WybierzFormat # Powtórz wybór w przypadku błędu
        }
    }

    return $selectedFormat
}

$AudioVideo = AudioVideo

Write-Host " "

if($AudioVideo -eq "Audio"){
 #   Write-Host "[Debug] $lokalizacja; $link; $AudioVideo   ;$Format" -ForegroundColor Yellow
    $AudioFormat = Read-Host "Podaj format docelowego pliku audio (Domyślny: mp3)"
    if ([string]::IsNullOrWhiteSpace($input)) {
        $AudioFormat = "mp3" # Domyślna wartość
    }
    Write-Host " "
    &yt-dlp $link -x --audio-format $AudioFormat --audio-quality 0 -P $lokalizacja -o "%(title)s.%(ext)s"
    exit 1
}


if($AudioVideo -eq "Video"){
$VideoFormat = Read-Host "Podaj format docelowego pliku audio (Pozostaw puste w przypadku braku zainstalowanego FFMPEG, domyślny format FFMPEG to mkv)"
if ([string]::IsNullOrWhiteSpace($VideoFormat)) {
    $remuxFormat = @()
} else {
    $remuxFormat = @("--remux-video", $VideoFormat)
}
}

Write-Host " "
Write-Host "Po wywołaniu polecenia yt-dlp należy wskazać wybrany format pobierania pliku albo wybrać domyślny klikając enter"
Write-Host "Istnieje możliwość połączenia różnych formatów audio i video poprzez wpisanie id obu formatów oddzielonych znakiem *+* np: *2137+69*"

#Write-Host "[Debug] $lokalizacja; $link; $AudioVideo ;$AudioFormat; $VideoFormat ;$remuxformat" -ForegroundColor Yellow
#Write-Host '[Debug] yt-dlp $link -f - $remuxFormat -o "%(title)s.%(ext)s" -P $lokalizacja ' -ForegroundColor Yellow

& yt-dlp "$link" -f - @remuxFormat -o "%(title)s.%(ext)s" -P $lokalizacja

Write-Host ""
Write-Host "Pobieranie zakończone, plik znajduje się w $lokalizacja" -ForegroundColor Green