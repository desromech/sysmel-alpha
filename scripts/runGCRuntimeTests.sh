#!/usr/bin/env bash
set -ex

if test "$PLATFORM_NAME" = ""; then
    PLATFORM_NAME=`$(uname -s)`
fi

./sysmelc -o out-gc-tests -object tests/RuntimeLibrariesTests.sysmel
mkdir -p artifacts/test-results/$PLATFORM_NAME
out-gc-tests/RuntimeLibrariesTests | tee artifacts/test-results/$PLATFORM_NAME/gcRuntimeLibrariesTests.txt
