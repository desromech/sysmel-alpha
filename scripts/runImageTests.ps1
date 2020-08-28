$ErrorActionPreference = "Stop"

.\pharo-vm\PharoConsole.exe "$pwd\sysmel.image" test --junit-xml-output --stage-name="SysmelCompiler" "SysmelMoebius.*" "SysmelLanguage-.*"

$DIST = "artifacts/test-results/Win64"
New-Item -Path "$DIST" -ItemType "directory"
Copy-Item -Path "*.xml" -Destination "$DIST"
