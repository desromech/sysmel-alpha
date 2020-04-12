#!/usr/bin/env bash
set -ex

DIST=artifacts/dist

mkdir -p $DIST/module-sources $DIST/third-party
cp -R pharo-vm pharo pharo-ui $DIST
cp -R Pharo*.sources sysmel.* sysmelc sysmelc-ui $DIST
cp -R module-sources/* pharo-local/iceberg/**/abstract-gpu/bindings/sysmel/* $DIST/module-sources
cp -R pharo-local/phanapi/libs/abstract-gpu/ $DIST/third-party/abstract-gpu
cp -R LICENSE README.md docs tests samples $DIST
