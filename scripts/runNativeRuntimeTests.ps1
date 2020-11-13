$ErrorActionPreference = "Stop"

.\sysmelc.bat --no-rtti --release -o build-native-tests tests\RuntimeLibrariesTests.sysmel
New-Item -Path "artifacts\test-results\win64" -ItemType "directory" -Force
build-native-tests\release\out\RuntimeLibrariesTests > artifacts\test-results\win64\nativeRuntimeLibrariesTests.txt
