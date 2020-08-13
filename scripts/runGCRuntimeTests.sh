#!/usr/bin/env bash
set -ex

./sysmelc -o out-gc-tests -object tests/RuntimeLibrariesTests.sysmel
mkdir -p artifacts/test-results
out-gc-tests/RuntimeLibrariesTests | tee artifacts/test-results/gcRuntimeLibrariesTests.txt
