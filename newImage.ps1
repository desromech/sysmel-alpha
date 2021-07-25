$ErrorActionPreference = "Stop"

$PharoImage_URL = "http://files.pharo.org/get-files/90/pharoImage-x86_64.zip"
$PharoVM_URL = "http://files.pharo.org/get-files/90/pharo-vm-Windows-x86_64-stable.zip"
function downloadAndExtractZip {
    $URL = $args[0]
    $DestFileName = $args[1]
    $ExtractedDestination = $args[2]
    Invoke-WebRequest -Uri "$URL" -OutFile "$DestFileName"

    Expand-Archive -Path "$DestFileName" -Force -DestinationPath "$ExtractedDestination"
}

downloadAndExtractZip "$PharoVM_URL" "pharo-vm.zip" "pharo-vm"
downloadAndExtractZip "$PharoImage_URL" "pharo-image.zip" "."

.\pharo-vm\PharoConsole.exe --headless (get-item .\Pharo*.image).FullName st scripts/loadImage.st
