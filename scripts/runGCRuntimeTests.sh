#!/usr/bin/env bash
set -ex

if test "$PLATFORM_NAME" = ""; then
    PLATFORM_NAME="$(uname -s)"
fi

./sysmelc --release -o build-gc-tests tests/RuntimeLibrariesTests.sysmel
mkdir -p artifacts/test-results/$PLATFORM_NAME
build-gc-tests/release/out/RuntimeLibrariesTests | tee artifacts/test-results/$PLATFORM_NAME/gcRuntimeLibrariesTests.txt
