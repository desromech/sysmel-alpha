#!/usr/bin/env bash
set -ex

if test "$PLATFORM_NAME" = ""; then
    PLATFORM_NAME=`$(uname -s)`
fi

DIST=artifacts/dist/$PLATFORM_NAME

mkdir -p $DIST/module-sources $DIST/third-party
cp -R pharo-vm pharo pharo-ui $DIST
cp -R Pharo*.sources sysmel.* sysmelc sysmelc-ui $DIST
cp -R module-sources/* pharo-local/iceberg/**/abstract-gpu/bindings/sysmel/module-sources/* $DIST/module-sources
cp -R third-party/* pharo-local/iceberg/**/abstract-gpu/bindings/sysmel/third-party/* $DIST/third-party
cp -R pharo-local/phanapi/libs/abstract-gpu/* $DIST/third-party/abstract-gpu
cp -R LICENSE README.md docs tests samples $DIST
