#!/usr/bin/env bash
set -ex

./pharo sysmel.image test --junit-xml-output --stage-name="SysmelCompiler" "SysmelMoebius.*" "SysmelLanguage-.*"
mkdir -p artifacts/test-results
cp *.xml artifacts/test-results
