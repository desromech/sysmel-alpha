#!/usr/bin/env bash
set -ex

if test "$PLATFORM_NAME" = ""; then
    PLATFORM_NAME=`$(uname -s)`
fi

./pharo sysmel.image test --junit-xml-output --stage-name="SysmelCompiler" "SysmelMoebius.*" "SysmelLanguage-.*"

mkdir -p artifacts/test-results/$PLATFORM_NAME
cp *.xml artifacts/test-results/$PLATFORM_NAME
