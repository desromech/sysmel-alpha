$ErrorActionPreference = "Stop"

$PharoImage_URL = "http://files.pharo.org/get-files/80/pharo64.zip"
$PharoVM_URL = "http://files.pharo.org/get-files/80/pharo64-win-headless-latest.zip"

function downloadAndExtractZip {
    $URL = $args[0]
    $DestFileName = $args[1]
    $ExtractedDestination = $args[2]
    Invoke-WebRequest -Uri "$URL" -OutFile "$DestFileName"

    Expand-Archive -Path "$DestFileName" -Force -DestinationPath "$ExtractedDestination"
}

downloadAndExtractZip "$PharoVM_URL" "pharo-vm.zip" "pharo-vm"
downloadAndExtractZip "$PharoImage_URL" "pharo-image.zip" "."

.\pharo-vm\PharoConsole.exe (get-item .\Pharo*.image).FullName st scripts/loadImage.st
