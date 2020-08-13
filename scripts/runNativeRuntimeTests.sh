#!/usr/bin/env bash
set -ex

./sysmelc -no-rtti -o out-native-tests -object tests/RuntimeLibrariesTests.sysmel
mkdir -p artifacts/test-results
out-native-tests/RuntimeLibrariesTests | tee artifacts/test-results/nativeRuntimeLibrariesTests.txt
