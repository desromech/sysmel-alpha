$ErrorActionPreference = "Stop"

.\sysmelc.bat --release -o build-gc-tests tests\RuntimeLibrariesTests.sysmel
New-Item -Path "artifacts\test-results\win64" -ItemType "directory" -Force
build-gc-tests\release\out\RuntimeLibrariesTests > artifacts\test-results\win64\nativeRuntimeLibrariesTests.txt
