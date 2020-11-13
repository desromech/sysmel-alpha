#!/usr/bin/env bash
set -ex

if test "$PLATFORM_NAME" = ""; then
    PLATFORM_NAME="$(uname -s)"
fi

./sysmelc --no-rtti --release -o build-native-tests tests/RuntimeLibrariesTests.sysmel
mkdir -p artifacts/test-results/$PLATFORM_NAME
build-native-tests/release/out/RuntimeLibrariesTests | tee artifacts/test-results/$PLATFORM_NAME/nativeRuntimeLibrariesTests.txt
