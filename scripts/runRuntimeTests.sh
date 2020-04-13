#!/usr/bin/env bash
set -ex

./sysmelc -no-rtti -o . -monolithic tests/RuntimeLibrariesTests.sysmel
mkdir -p artifacts/test-results
./RuntimeLibrariesTests | tee artifacts/test-results/runtimeLibrariesTests.txt
