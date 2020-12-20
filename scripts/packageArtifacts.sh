#!/usr/bin/env bash
set -ex

if test "$PLATFORM_NAME" = ""; then
    PLATFORM_NAME="$(uname -s)"
fi

DIST=artifacts/dist/$PLATFORM_NAME

mkdir -p $DIST/module-sources $DIST/native-module-sources
cp -R pharo-vm pharo pharo-ui $DIST
cp -R Pharo*.sources sysmel.* sysmelc sysmelc-ui $DIST
cp -R module-sources/* pharo-local/iceberg/**/abstract-gpu/bindings/sysmel/module-sources/* $DIST/module-sources
cp -R native-module-sources/* pharo-local/iceberg/**/abstract-gpu/bindings/sysmel/native-module-sources/* $DIST/native-module-sources
cp -R pharo-local/phanapi/libs/abstract-gpu/* $DIST/native-module-sources/abstract-gpu
cp -R LICENSE README.md docs tests samples $DIST
