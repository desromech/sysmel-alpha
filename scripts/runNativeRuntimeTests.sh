#!/usr/bin/env bash
set -ex

if test "$PLATFORM_NAME" = ""; then
    PLATFORM_NAME=`$(uname -s)`
fi

./sysmelc -no-rtti -o out-native-tests -object tests/RuntimeLibrariesTests.sysmel
mkdir -p artifacts/test-results/$PLATFORM_NAME
out-native-tests/RuntimeLibrariesTests | tee artifacts/test-results/$PLATFORM_NAME/nativeRuntimeLibrariesTests.txt
